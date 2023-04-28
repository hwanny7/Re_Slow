package com.ssafy.reslow.domain.knowhow.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowContentDetail;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowDetailResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRequest;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowCategory;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowContent;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowCategoryRepository;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowContentRepository;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowRepository;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.infra.storage.S3StorageClient;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class KnowhowService {

	private final RedisTemplate redisTemplate;
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

	public KnowhowDetailResponse getKnowhowDetail(Long knowhowNo) {
		Knowhow knowhow = knowhowRepository.getById(knowhowNo);

		List<KnowhowContent> contentList = knowhow.getKnowhowContents();
		List<KnowhowContentDetail> detailList = new ArrayList<>();
		for (int i = 1; i <= contentList.size(); i++) {
			KnowhowContent content = contentList.get(i - 1);
			KnowhowContentDetail detail = KnowhowContentDetail.builder()
				.order(Long.valueOf(i))
				.knowhowNo(content.getNo())
				.image(content.getImage())
				.content(content.getContent())
				.build();

			detailList.add(detail);
		}

		return KnowhowDetailResponse.builder()
			.writer(knowhow.getMember().getNickname())
			.date(knowhow.getCreatedDate())
			.title(knowhow.getTitle())
			.contentList(detailList).build();
	}

	/*
	public String updateKnowhow(Long memberNo, List<MultipartFile> imageList,
		KnowhowUpdateRequest updateRequest) throws IOException {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		Knowhow knowhow = knowhowRepository.findById(updateRequest.getBoardNo())
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));

		// 글 쓴 사람과 로그인한 유저가 같은지 확인
		if (knowhow.getMember() != member) {
			throw new CustomException(USER_NOT_MATCH);
		}

		// 새로운 카테고리 객체 만들기
		KnowhowCategory category = knowhowCategoryRepository.findById(updateRequest.getCategoryNo())
			.orElseThrow(() -> new NoSuchElementException("category 존재하지 않음"));

		// 글 제목, 카테고리 등 수정
		knowhow.update(KnowhowRequest.ofEntity(updateRequest), member, category);

		// 글 내용 수정
		Set<KnowhowContent> preContent = knowhowContentRepository.findKnowhowContentsByKnowhow(knowhow)
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));

		Set<KnowhowContent> nowContent = new HashSet<>();

		return "글 수정 완료";
	}
	*/

	public Map<String, Long> likeKnowhow(Long memberNo, Long knowhowNo) {
		SetOperations<Object, Long> setOperations = redisTemplate.opsForSet();
		setOperations.add(knowhowNo, memberNo);
		setOperations.add(memberNo + "_like_knowhow", knowhowNo);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(knowhowNo));
		return map;
	}

	public Map<String, Long> unlikeKnowhow(Long memberNo, Long knowhowNo) {
		SetOperations<Object, Long> setOperations = redisTemplate.opsForSet();
		setOperations.remove(knowhowNo, memberNo);
		setOperations.remove(memberNo + "_like_knowhow", knowhowNo);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(knowhowNo));
		return map;
	}
}
