package com.ssafy.reslow.domain.notice.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.util.ArrayList;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.domain.Pageable;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.notice.dto.NoticeResponse;
import com.ssafy.reslow.domain.notice.dto.NoticeStatusRequest;
import com.ssafy.reslow.domain.notice.repository.NoticeRepository;
import com.ssafy.reslow.global.exception.CustomException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class NoticeService {
	private final NoticeRepository noticeRepository;
	private final MemberRepository memberRepository;
	private final RedisTemplate redisTemplate;

	public void updateNoticeStatus(Long memberNo, NoticeStatusRequest request) {
		if (request.getType().size() == 1) {
			redisTemplate.opsForHash().put("alert_" + memberNo, request.getType(), request.isAlert());
		} else { // 전체끄기
			request.getType().forEach(type -> {
				redisTemplate.opsForHash().put("alert_" + memberNo, request.getType(), false);
			});
		}
	}

	public List<NoticeResponse> getNoticeList(Long memberNo, Pageable pageable) {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		List<NoticeResponse> noticeResponseList = new ArrayList<>();
		noticeRepository.findByMemberOrderByAlertTimeDesc(member, pageable).forEach(notice -> {
			noticeResponseList.add(NoticeResponse.of(notice));
		});

		return noticeResponseList;
	}

	@Transactional
	public void deleteNotice(Long memberNo, Long noticeNo) {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		// noticeNo = -1일 시, 전체삭제
		if (noticeNo == -1) {
			noticeRepository.deleteAllByMember(member);

		} else {
			noticeRepository.deleteById(noticeNo);
		}
	}
}
