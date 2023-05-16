package com.ssafy.reslow.domain.notice.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.ssafy.reslow.domain.member.entity.Device;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.DeviceRepository;
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
	private final DeviceRepository deviceRepository;

	public void updateNoticeStatus(Long memberNo, NoticeStatusRequest request) {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		Device device = deviceRepository.findByMember(member).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		device.updateNoticeStatus(request.isAlert());
		deviceRepository.save(device);
	}

	public List<NoticeResponse> getNoticeList(Long memberNo, Pageable pageable) {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		List<NoticeResponse> noticeResponseList = new ArrayList<>();
		noticeRepository.findByMemberOrderByAlertTimeDesc(member, pageable).forEach(notice -> {
			noticeResponseList.add(NoticeResponse.of(
				notice.getSender(),
				notice.getTitle(),
				DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(notice.getAlertTime()),
				notice.getType()
			));
		});

		return noticeResponseList;
	}
}
