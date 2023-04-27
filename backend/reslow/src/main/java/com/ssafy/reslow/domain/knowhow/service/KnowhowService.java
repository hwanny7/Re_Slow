package com.ssafy.reslow.domain.knowhow.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

import javax.transaction.Transactional;

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
	private final S3StorageClient s3StorageClient;

	// 게시글 정보 KnowhowReuqest DTO에 저장
	public Map<String, Object> saveKnowhowDto(Long memberNo, List<MultipartFile> imageList,
		KnowhowRequest knowhowRequest) throws IOException {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		// KnowhowRequest knowhow = request.ofEntity(member.getId(), imageList, request);
		// Knowhow table 저장
		List<String> contentList = knowhowRequest.getContents();
		List<KnowhowContent> knowhowContents = new ArrayList<>();
		
		for (int i = 0; i < imageList.size(); i++) {
			KnowhowContent knowhowContent = KnowhowContent.builder().image(s3StorageClient.uploadFile(imageList.get(i)))
				.content(contentList.get(i)).build();

			knowhowContents.add(knowhowContent);
		}

		// 카테고리 객체 만들기
		KnowhowCategory category = knowhowCategoryRepository.findByCategory(knowhowRequest.getCategory())
			.orElseThrow(() -> new NoSuchElementException("category 존재하지 않음"));

		knowhowRepository.save(Knowhow.ofEntity(knowhowRequest, member, category, knowhowContents));
		return null;
	}

}
