package com.ssafy.reslow.domain.knowhow.service;

import java.io.IOException;
import java.util.*;

import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowCategory;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowRepository;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.infra.storage.S3StorageClient;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import static com.ssafy.reslow.global.exception.ErrorCode.MEMBER_NOT_FOUND;

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
