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
import com.ssafy.reslow.domain.chatting.dto.FcmMessage;
import com.ssafy.reslow.domain.chatting.entity.ChatMessage;
import com.ssafy.reslow.domain.chatting.entity.ChatRoom;
import com.ssafy.reslow.domain.chatting.repository.ChatMessageRepository;
import com.ssafy.reslow.domain.chatting.repository.ChatRoomRepository;
import com.ssafy.reslow.domain.member.entity.Device;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.DeviceRepository;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.exception.CustomException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatService {
	private final DeviceRepository deviceRepository;
	private final RedisMessageListenerContainer redisMessageListenerContainer; // 채팅방(topic)에 발행되는 메시지 처리할 Listener
	private final ChatSubscriber chatSubscriber;
	public static final String ENTER_INFO = "ENTER_INFO"; // 채팅룸에 입장한 클라이언트의 sessionId와 채팅룸 id를 맵핑한 정보 저장
	// private Map<String, ChannelTopic> topics;
	private ValueOperations<String, Object> valueOpsTopicInfo;
	private SetOperations<String, Object> setOpsSocketInfo;
	private final ChatRoomRepository chatRoomRepository;
	private final ChatMessageRepository chatMessageRepository;

	private final ChatPublisher chatPublisher;
	private final MemberRepository memberRepository;
	private final RedisTemplate<String, Object> redisTemplate;

	@PostConstruct
	private void init() {
		setOpsSocketInfo = redisTemplate.opsForSet();
		valueOpsTopicInfo = redisTemplate.opsForValue();
		// topics = new HashMap<>();
	}

	public void sendMessage(ChatMessageRequest chatMessage) throws IOException, FirebaseMessagingException {
		String roomId = chatMessage.getRoomId();

		System.out.println("!!sendMessage로 들어옴!!");
		// 해당 토픽이 존재하지 않다면 채팅방을 찾을 수 없음 처리
		// if (topics.get(roomId) == null) {
		// 	throw new CustomException(CHATROOM_NOT_FOUND);
		// }
		// // redis로 publish
		// chatPublisher.publish(topics.get(roomId), chatMessage);

		System.out.println("publish 수행완료!");

		Member receiver = findReceiver(roomId, chatMessage.getSender());
		// 상대방이 소켓에 참여중이지 않다면 FCM 알림 보내기
		if (!isUserOnline(roomId, receiver)) {
			// 받을사람 Member객체 가져오기
			Member sender = memberRepository.findById(chatMessage.getSender())
				.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
			Device device = deviceRepository.findByMember(receiver)
				.orElseThrow(() -> new CustomException(DEVICETOKEN_NOT_FOUND));

			System.out.println("알림 보내러 출발!!!!!!");
			System.out.println("보낸사람: " + sender.getNickname());
			System.out.println("받는사람: " + receiver.getNickname());
			FirebaseCloudMessageService.sendMessageTo(FcmMessage.SendMessage.of(chatMessage, device.getDeviceToken()),
				sender);
		}
	}

	// 유저가 소켓에 참여중인지 체크
	private boolean isUserOnline(String roomId, Member member) {
		// 소켓에 참여중이라면
		if (setOpsSocketInfo.isMember(roomId, member.getNo())) {
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
		// ChannelTopic topic = topics.get(roomId);
		ChannelTopic topic = new ChannelTopic(roomId);
		valueOpsTopicInfo.set(roomId, topic);

		// // 없던 topic이면 새로 만든다.
		// if (topic == null) {
		// 	topic = new ChannelTopic(roomId);
		// }
		System.out.println("====" + memberNo + "가 채팅방 " + topic.getTopic() + "에 참여함 ====");
		redisMessageListenerContainer.addMessageListener(chatSubscriber, topic);
		// topics.put(roomId, topic);
	}

	// 채팅방 나가기
	public void leaveChattingRoom(String roomId, Long memberNo) {
		// ChannelTopic topic = topics.get(roomId);
		ChannelTopic topic = (ChannelTopic)valueOpsTopicInfo.get(roomId);
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

	// 해당 방 소켓에 참여함
	public void setUserSocketInfo(String roomId, Long memberNo) {
		System.out.println("해당 소켓에 참여: " + roomId + " ,멤버: " + memberNo);
		setOpsSocketInfo.add(roomId, memberNo);
	}

	// 해당 방 소켓에서 나옴
	public void removeUserSocketInfo(String roomId, Long memberNo) {
		System.out.println("해당 소켓에서 나감!!: " + roomId + " ,멤버: " + memberNo);
		setOpsSocketInfo.remove(roomId, memberNo);
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
