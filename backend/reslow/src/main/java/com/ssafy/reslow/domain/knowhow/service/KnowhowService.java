package com.ssafy.reslow.domain.knowhow.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

import javax.transaction.Transactional;

import com.ssafy.reslow.domain.knowhow.repository.KnowhowContentRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowRequest;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowCategory;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowContent;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowCategoryRepository;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowRepository;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.infra.storage.S3StorageClient;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class KnowhowService {
	private final MemberRepository memberRepository;
	private final KnowhowRepository knowhowRepository;
	private final KnowhowCategoryRepository knowhowCategoryRepository;
	private final KnowhowContentRepository knowhowContentRepository;
	private final S3StorageClient s3StorageClient;

	// 게시글 정보 저장
	public String saveKnowhow(Long memberNo, List<MultipartFile> imageList,
		KnowhowRequest knowhowRequest) throws IOException {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		// 카테고리 객체 만들기
		KnowhowCategory category = knowhowCategoryRepository.findById(knowhowRequest.getCategoryNo())
			.orElseThrow(() -> new NoSuchElementException("category 존재하지 않음"));

		// 노하우 테이블 저장
		Knowhow knowhow = Knowhow.ofEntity(knowhowRequest, member, category);
		knowhowRepository.save(knowhow);

		List<String> contentList = knowhowRequest.getContentList();
		List<KnowhowContent> knowhowContentList = new ArrayList<>();

		for (int i = 0; i < imageList.size(); i++) {
			KnowhowContent knowhowContent = KnowhowContent.builder().image(s3StorageClient.uploadFile(imageList.get(i)))
					.content(contentList.get(i)).knowhow(knowhow).build();

			knowhowContentList.add(knowhowContent);
		}
		// 노하우 글 저장
		knowhowContentRepository.saveAll(knowhowContentList);
		return "글 작성 완료";
	}

}
