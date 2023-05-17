package com.ssafy.reslow.domain.knowhow.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentCreateRequest;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowCommentUpdateRequest;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowComment;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowCommentRepository;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowRepository;
import com.ssafy.reslow.domain.member.entity.Device;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.DeviceRepository;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.notice.entity.Notice;
import com.ssafy.reslow.domain.notice.repository.NoticeRepository;
import com.ssafy.reslow.global.common.FCM.FirebaseCloudMessageService;
import com.ssafy.reslow.global.common.FCM.dto.ChatFcmMessage;
import com.ssafy.reslow.global.common.FCM.dto.MessageType;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.global.exception.ErrorCode;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class KnowhowCommentService {

	private final KnowhowCommentRepository commentRepository;
	private final MemberRepository memberRepository;
	private final KnowhowRepository knowhowRepository;
	private final DeviceRepository deviceRepository;
	private final NoticeRepository noticeRepository;
	private final RedisTemplate redisTemplate;

	public Slice<KnowhowCommentResponse> getCommentList(Long knowhowNo, Pageable pageable) {
		Slice<KnowhowComment> comments = commentRepository.findByKnowhowNoAndParentIsNull(knowhowNo, pageable);
		List<KnowhowCommentResponse> commentResponses = comments.getContent()
			.stream()
			.map(KnowhowCommentResponse::of)
			.collect(Collectors.toList());

		return new SliceImpl<>(commentResponses, pageable, comments.hasNext());
	}

	public Map<String, Object> createComment(Long memberNo, KnowhowCommentCreateRequest request) throws
		IOException,
		FirebaseMessagingException {
		Knowhow knowhow = knowhowRepository.findById(request.getKnowhowNo())
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		KnowhowComment parent =
			request.getParentNo() == null ? null : commentRepository.findById(request.getParentNo())
				.orElseThrow(() -> new CustomException(COMMENT_NOT_FOUND));

		KnowhowComment comment = KnowhowComment.of(knowhow, member, parent, request.getContent());
		Long savedCommentNo = commentRepository.save(comment).getNo();

		// 알림을 꺼놓지 않았다면
		boolean status = false;
		try {
			status = (boolean)redisTemplate.opsForHash()
				.get("alert_" + knowhow.getMember().getNo(), MessageType.COMMENT);
		} catch (Exception e) {
			// redis에 alert 상태 정보가 없다면 추가함
			redisTemplate.opsForHash().put("alert_" + knowhow.getMember().getNo(), MessageType.COMMENT, true);
			log.error("redis에 디바이스별 상태가 나타나지 않음: " + e);
		}

		if (status) {
			Device device = deviceRepository.findByMember(knowhow.getMember())
				.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
			// 작성자에게 fcm 알림을 보낸다.
			fcmNotice(device.getDeviceToken(), knowhow, request.getContent(), member.getNickname());

			// 작성자가 받은 알림을 저장한다.
			Notice notice = Notice.of(member.getNickname(), knowhow.getTitle(), LocalDateTime.now(),
				MessageType.COMMENT);

			noticeRepository.save(notice);
		}

		Map<String, Object> map = new HashMap<>();
		map.put("commentNo", savedCommentNo);
		return map;
	}

	public Map<String, Object> updateComment(Long memberNo, KnowhowCommentUpdateRequest request) {
		KnowhowComment comment = commentRepository.findById(request.getCommentNo())
			.orElseThrow(() -> new CustomException(ErrorCode.COMMENT_NOT_FOUND));

		if (!memberNo.equals(comment.getMember().getNo())) {
			throw new CustomException(ErrorCode.FORBIDDEN);
		}

		comment.updateContent(request.getContent());
		Long savedCommentNo = commentRepository.save(comment).getNo();

		Map<String, Object> map = new HashMap<>();
		map.put("commentNo", savedCommentNo);
		return map;
	}

	public void deleteComment(Long memberNo, Long commentNo) {
		KnowhowComment comment = commentRepository.findById(commentNo)
			.orElseThrow(() -> new CustomException(ErrorCode.COMMENT_NOT_FOUND));

		if (!memberNo.equals(comment.getMember().getNo())) {
			throw new CustomException(ErrorCode.FORBIDDEN);
		}

		commentRepository.deleteById(commentNo);
	}

	public void fcmNotice(String deviceToken, Knowhow knowhow, String content, String senderNickname) throws
		IOException,
		FirebaseMessagingException {

		ChatFcmMessage.SendCommentOrderMessage sendCommentMessage = ChatFcmMessage.SendCommentOrderMessage.of(
			deviceToken, knowhow.getTitle(), content,
			knowhow.getNo(), senderNickname);

		FirebaseCloudMessageService.sendCommentOrderMessageTo(sendCommentMessage);
	}

}
