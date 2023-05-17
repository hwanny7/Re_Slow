package com.ssafy.reslow.domain.chatting.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.stereotype.Service;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.ssafy.reslow.domain.chatting.dto.ChatMessageRequest;
import com.ssafy.reslow.domain.chatting.dto.ChatRoomList;
import com.ssafy.reslow.domain.chatting.entity.ChatMessage;
import com.ssafy.reslow.domain.chatting.entity.ChatRoom;
import com.ssafy.reslow.domain.chatting.repository.ChatMessageRepository;
import com.ssafy.reslow.domain.chatting.repository.ChatRoomRepository;
import com.ssafy.reslow.domain.member.entity.Device;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.DeviceRepository;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.notice.entity.Notice;
import com.ssafy.reslow.domain.notice.repository.NoticeRepository;
import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.domain.product.repository.ProductRepository;
import com.ssafy.reslow.global.common.FCM.FirebaseCloudMessageService;
import com.ssafy.reslow.global.common.FCM.dto.ChatFcmMessage;
import com.ssafy.reslow.global.common.FCM.dto.MessageType;
import com.ssafy.reslow.global.exception.CustomException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatService {
	private final ProductRepository productRepository;
	private final NoticeRepository noticeRepository;
	private final DeviceRepository deviceRepository;
	private final ChatRoomRepository chatRoomRepository;
	private final ChatMessageRepository chatMessageRepository;
	private final RedisMessageListenerContainer redisMessageListenerContainer; // 채팅방(topic)에 발행되는 메시지 처리할 Listener
	private final ChatSubscriber chatSubscriber;
	private SetOperations<String, Object> setOpsChatRoom;
	private ValueOperations<String, Object> valueOpsTopicInfo;
	private final ChatPublisher chatPublisher;
	private final MemberRepository memberRepository;
	private final RedisTemplate<String, Object> redisTemplate;

	@PostConstruct
	private void init() {
		setOpsChatRoom = redisTemplate.opsForSet();
		valueOpsTopicInfo = redisTemplate.opsForValue();
	}

	public void sendMessage(ChatMessageRequest chatMessage) throws
		IOException,
		FirebaseMessagingException {
		String roomId = chatMessage.getRoomId();

		Member receiver = findReceiver(roomId, chatMessage.getSender());

		// 상대방이 소켓에 참여중이라면 publish로 보낸다.
		if (isUserOnline(roomId, receiver)) {
			String topicName = (String)valueOpsTopicInfo.get("topic_" + roomId);
			System.out.println("TOPIC name : " + topicName);
			if (topicName == null) {
				throw new CustomException(CHATROOM_NOT_FOUND);
			}

			// redis로 publish
			chatPublisher.publish(topicName, chatMessage);

			System.out.println("소켓이 연결되어 있으므로, publish 수행완료!");
		}
		// 상대방이 소켓에 참여중이지 않다면
		else {
			// 받을사람 Member객체 가져오기
			Member sender = memberRepository.findById(chatMessage.getSender())
				.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
			Device device = deviceRepository.findByMember(receiver)
				.orElseThrow(() -> new CustomException(DEVICETOKEN_NOT_FOUND));

			// 디바이스 알림 상태가 true일 때 알림 보내기
			boolean status = false;
			try {
				status = (boolean)redisTemplate.opsForHash().get("alert_" + receiver.getNo(), MessageType.CHATTING);
			} catch (Exception e) {
				// redis에 alert 상태 정보가 없다면 추가함
				redisTemplate.opsForHash().put("alert_" + receiver.getNo(), MessageType.CHATTING, true);
				log.error("redis에 디바이스별 상태가 나타나지 않음: " + e);
			}
			if (status) {
				FirebaseCloudMessageService.sendChatMessageTo(
					ChatFcmMessage.SendChatMessage.of(chatMessage, device.getDeviceToken()),
					sender);

				// 보낸 알림을 저장한다. 플리마켓 글 제목, 보낸사람 닉네임, 현재시간, 메시지타입
				String[] roomInfo = roomId.split("-");
				Long marketNo = Long.parseLong(roomInfo[0]);
				Product product = productRepository.findById(marketNo)
					.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));

				// 해당 글에대해 상대가 채팅을 보낸 이력이 있다면 보낸 시간만 업데이트한다.
				Notice notice = noticeRepository.findBySenderAndTitle(sender.getNickname(), product.getTitle())
					.orElse(Notice.of(sender.getNickname(), product.getTitle(), LocalDateTime.now(),
						MessageType.CHATTING));

				notice.UpdateNotice(LocalDateTime.now());
				noticeRepository.save(notice);
			}
		}
	}

	// 유저가 소켓에 참여중인지 체크
	private boolean isUserOnline(String roomId, Member member) {
		// 소켓에 참여중이라면
		if (Boolean.TRUE.equals(setOpsChatRoom.isMember(roomId, String.valueOf(member.getNo())))) {
			log.info("상대 유저가 소켓에 참여중");
			return true;
		}

		return false;
	}

	// 받은 채팅 mongoDB에 저장
	public Map<String, String> saveChatMessage(ChatMessageRequest chatMessage) {
		System.out.println("===========mongo에 저장하는 service로 들어옴!!!!!!!============");
		String nowDate = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now());
		ChatMessage message = ChatMessage.of(chatMessage.getRoomId(), chatMessage.getSender(), chatMessage.getMessage(),
			nowDate);
		chatMessageRepository.save(message);

		System.out.println("mongo에 저장한 메시지: " + message.getContent() + ", 날짜: " + message.getDateTime());

		Map<String, String> map = new HashMap<>();
		map.put("sender", String.valueOf(chatMessage.getSender()));
		map.put("message", chatMessage.getMessage());
		return map;
	}

	// 채팅방 생성
	public void createChattingRoom(String roomId, Map<String, Long> userList) {
		log.debug("====" + userList.get("user1") + "와 " + userList.get("user2") + "가 " + roomId + "채팅방을 생성함! ====");
		if (chatRoomRepository.findByRoomId(roomId).isEmpty()) {
			ChatRoom room = ChatRoom.of(roomId, userList.get("user1"), userList.get("user2"));
			chatRoomRepository.save(room);
		} else {
			log.debug("이미 생성된 채팅방이 있음!");
		}
	}

	// 채팅방 입장
	public void enterChattingRoom(String roomId, Long memberNo) {
		ChannelTopic topic = new ChannelTopic(roomId);
		valueOpsTopicInfo.set("topic_" + roomId, roomId);

		System.out.println("====" + memberNo + "가 채팅방 " + topic.getTopic() + "에 참여함 ====");
		// topic에 대한 메시지를 받으면, 이를 chatSubscriber에게 전달함
		redisMessageListenerContainer.addMessageListener(chatSubscriber, topic);
		setOpsChatRoom.add(roomId, String.valueOf(memberNo));
	}

	// 채팅방 나가기
	public void quitChattingRoom(String roomId, Long memberNo) {
		System.out.println("====" + memberNo + "가 채팅방 나감");
		setOpsChatRoom.remove(roomId, String.valueOf(memberNo));
	}

	// 채팅방 삭제
	public void leaveChattingRoom(String roomId, Long memberNo) {
		// ChannelTopic topic = topics.get(roomId);
		String topicName = (String)valueOpsTopicInfo.get("topic_" + roomId);
		ChannelTopic topic = new ChannelTopic(topicName);
		redisMessageListenerContainer.removeMessageListener(chatSubscriber, topic);
	}

	// 해당 멤버가 가진 모든 채팅방 목록 가져오기
	public List<ChatRoom> findRoom(Long memberNo) {
		List<ChatRoom> roomList = chatRoomRepository.findByParticipantsContaining(memberNo);
		return roomList;
	}

	// 가져온 멤버의 채팅방 목록에서 채팅방 정보 가져오기
	public List<ChatRoomList> giveChatRoomList(List<ChatRoom> roomList, Long memberNo) {
		List<String> roomIdList = new ArrayList<>();
		roomList.forEach(chatRoom -> roomIdList.add(chatRoom.getRoomId()));

		List<ChatMessage> messageList = new ArrayList<>(
			chatMessageRepository.findByRoomId(
				roomIdList)); // mongoRepository 인터페이스는 수정 불가능한 List를 반환하므로 ArrayList로 변환했음
		// 최신순으로 정렬
		Collections.sort(messageList, Comparator.comparing(ChatMessage::getDateTime).reversed());

		List<ChatRoomList> chatRoomList = new ArrayList<>();
		messageList.forEach(chatMessage -> {
			Member receiver = findReceiver(chatMessage.getRoomId(), memberNo);
			ChatRoomList chatRoom = ChatRoomList.of(receiver, chatMessage.getRoomId(), chatMessage.getDateTime(),
				chatMessage.getContent());
			chatRoomList.add(chatRoom);
		});

		return chatRoomList;
	}

	// 채팅방 내용 확인
	public Slice<ChatMessage> showChatDetail(Long memberNo, String roomId, Pageable pageable) {
		// 채팅방이 존재하는지 확인
		ChatRoom chatRoom = chatRoomRepository.findByRoomId(roomId)
			.orElseThrow(() -> new CustomException(CHATROOM_NOT_FOUND));

		// 채팅방에 있는 유저에 해당하는지 확인
		if (!chatRoom.getParticipants().contains(memberNo)) {
			throw new CustomException(NOT_CHATROOM_USER);
		}

		return chatMessageRepository.findByRoomId(roomId, pageable);
	}

	// 존재하는 채팅방인지 확인
	public Map<String, Boolean> checkRoomId(String roomId) {
		// 채팅방이 존재하는지 확인
		Map<String, Boolean> map = new HashMap<>();
		if (chatRoomRepository.existsByRoomId(roomId)) {
			map.put("room", true);
		} else {
			map.put("room", false);
		}

		return map;
	}

	public void setRoomInfo(String roomId, Long memberNo) {

	}

	// 채팅방 ID로 상대방 Member객체 가져오기
	public Member findReceiver(String roomId, Long senderNo) {
		String[] roomInfo = roomId.split("-");
		Long receiverNo =
			Long.valueOf(roomInfo[1]).equals(senderNo) ? Long.valueOf(roomInfo[2]) : Long.valueOf(roomInfo[1]);

		log.debug("senderNo: " + senderNo + ", receiverNo: " + receiverNo);

		return memberRepository.findById(receiverNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
	}

}
