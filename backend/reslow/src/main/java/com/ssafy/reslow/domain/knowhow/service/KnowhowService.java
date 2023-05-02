package com.ssafy.reslow.domain.knowhow.service;

import static com.ssafy.reslow.domain.knowhow.entity.Knowhow.*;
import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.dto.KnowhowContentDetail;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowDetailResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowListResponse;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRequest;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowUpdateContent;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowUpdateRequest;
import com.ssafy.reslow.domain.knowhow.entity.Knowhow;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowCategory;
import com.ssafy.reslow.domain.knowhow.entity.KnowhowContent;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowCategoryRepository;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowCommentRepository;
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
	private final KnowhowCommentRepository knowhowCommentRepository;
	private final S3StorageClient s3StorageClient;

	// 게시글 정보 저장
	public String saveKnowhow(Long memberNo, List<MultipartFile> imageList,
		KnowhowRequest knowhowRequest) throws IOException {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		// 카테고리 객체 만들기
		KnowhowCategory category = knowhowCategoryRepository.findById(knowhowRequest.getCategoryNo())
			.orElseThrow(() -> new NoSuchElementException("category 존재하지 않음"));

		// 노하우 테이블 저장
		Knowhow knowhow = ofEntity(knowhowRequest, member, category);
		knowhowRepository.save(knowhow);

		// 노하우 글 저장
		saveKnowhowContent(knowhowRequest.getContentList(), imageList, knowhow);

		return "글 작성 완료";
	}

	public void saveKnowhowContent(List<String> contentList, List<MultipartFile> imageList, Knowhow knowhow) throws
		IOException {
		List<KnowhowContent> knowhowContentList = new ArrayList<>();

		for (int i = 0; i < imageList.size(); i++) {
			KnowhowContent knowhowContent = KnowhowContent.builder().image(s3StorageClient.uploadFile(imageList.get(i)))
				.content(contentList.get(i)).knowhow(knowhow).build();

			knowhowContentList.add(knowhowContent);
		}

		// 노하우 글 저장
		knowhowContentRepository.saveAll(knowhowContentList);
	}

	public KnowhowDetailResponse getKnowhowDetail(Long knowhowNo) {
		Knowhow knowhow = knowhowRepository.findById(knowhowNo)
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));

		List<KnowhowContent> contentList = knowhow.getKnowhowContents();
		List<KnowhowContentDetail> detailList = new ArrayList<>();
		for (int i = 1; i <= contentList.size(); i++) {
			KnowhowContent content = contentList.get(i - 1);
			detailList.add(KnowhowContentDetail.ofEntity((long)i, content));
		}

		return KnowhowDetailResponse.of(knowhow, detailList);
	}

	public String updateKnowhow(Long memberNo, List<MultipartFile> imageList,
		KnowhowUpdateRequest updateRequest) throws IOException {
		// 사용자 찾기
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
		// 이전 글 내용 리스트
		List<KnowhowContent> preContentList = knowhowContentRepository.findKnowhowContentsByKnowhow(knowhow)
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));

		// 바뀐 글 내용 리스트
		List<KnowhowUpdateContent> nowContentList = updateRequest.getContentList();

		// 이전 글 개수와 바뀐 글 개수를 비교한다. 양수: 내용 삭제, 음수: 내용 추가
		int contentCnt = preContentList.size() - nowContentList.size();
		int size = Math.min(preContentList.size(), nowContentList.size());

		// 리스트 돌면서 pk에 넣기
		for (int i = 0; i < size; i++) {
			KnowhowContent preContent = preContentList.get(i);
			KnowhowUpdateContent updateContent = nowContentList.get(i);

			String imageUrl;
			if (updateContent.isImageChange()) {
				// image가 바뀌었으면 이전껄 s3에서 삭제한다.
				s3StorageClient.deleteFile(preContent.getImage());

				// 바뀐 이미지를 s3에 넣는다.
				imageUrl = s3StorageClient.uploadFile(imageList.get(i));
			} else {
				imageUrl = preContent.getImage();
			}
			KnowhowContent newContent = KnowhowContent.builder()
				.content(updateContent.getContent())
				.image(imageUrl)
				.knowhow(knowhow)
				.build();

			preContent.update(newContent, knowhow);
		}

		if (contentCnt > 0) { // 글 삭제했으므로, DB에서 이전 글 pk로 삭제
			for (int i = size; i < preContentList.size(); i++) {
				KnowhowContent preContent = preContentList.get(i); // 이전 글
				knowhowContentRepository.deleteById(preContent.getNo());
			}
		} else if (contentCnt < 0) { // 글 추가했으므로, DB에 새로 추가

			List<String> contentList = new ArrayList<>();
			List<MultipartFile> multipartFileList = new ArrayList<>();
			for (int i = size; i < nowContentList.size(); i++) {
				KnowhowUpdateContent updateContent = nowContentList.get(i); // 현재 글
				contentList.add(updateContent.getContent());
				multipartFileList.add(imageList.get(i));
			}

			saveKnowhowContent(contentList, multipartFileList, knowhow);
		}
		return "글 수정 완료";
	}

	public String deleteKnowhow(Long memberNo, Long knowhowNo) {
		Knowhow knowhow = knowhowRepository.findById(knowhowNo)
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));
		if (knowhow.getMember().getNo().equals(memberNo)) {
			throw new CustomException(FORBIDDEN);
		}

		knowhowRepository.deleteById(knowhowNo);
		return "글 삭제 완료";
	}

	public List<KnowhowListResponse> getKnowhowList(Pageable pageable, Long category, String keyword) {
		List<KnowhowListResponse> list = knowhowRepository.findByMemberIsNotAndCategoryAndKeyword(keyword, category,
			pageable);
		list.forEach(knowhowList -> knowhowList.setLikeCnt(likeCount(knowhowList.getKnowhowNo())));

		return list;
	}

	public List<KnowhowListResponse> getMyKnowhowList(Pageable pageable, Long memberNo) {
		List<Knowhow> knowhowList = knowhowRepository.findAllByMember_No(pageable, memberNo).getContent();
		List<KnowhowListResponse> list = new ArrayList<>();
		for (Knowhow knowhow : knowhowList) {
			// 해당 글 좋아요 개수 세기
			Long likeCnt = likeCount(knowhow.getNo());
			// 해당 글 댓글 개수 세기
			Long commentCnt = knowhowCommentRepository.countByKnowhow(knowhow).orElse(0L);
			// 노하우 리스트에 저장하기
			list.add(KnowhowListResponse.of(knowhow, likeCnt, commentCnt));
		}

		return list;
	}

	public Long likeCount(Long knowhowNo) {
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		return setOperations.size(String.valueOf(knowhowNo));
	}

	public Map<String, Long> likeKnowhow(Long memberNo, Long knowhowNo) {
		Knowhow knowhow = knowhowRepository.findById(knowhowNo)
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		String knowhowString = String.valueOf(knowhowNo);
		String memberString = String.valueOf(memberNo);

		setOperations.add(knowhowString, memberString);
		zSetOperations.add(memberNo + "_like_knowhow", knowhowString, System.currentTimeMillis());
		zSetOperations.incrementScore("knowhow_" + memberNo, String.valueOf(knowhow.getKnowhowCategory().getNo()), 1);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(knowhowString));
		return map;
	}

	public Map<String, Long> unlikeKnowhow(Long memberNo, Long knowhowNo) {
		Knowhow knowhow = knowhowRepository.findById(knowhowNo)
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		String product = String.valueOf(knowhowNo);
		String member = String.valueOf(memberNo);

		setOperations.remove(product, member);
		zSetOperations.remove(memberNo + "_like_knowhow", product);
		zSetOperations.incrementScore("knowhow_" + memberNo, String.valueOf(knowhow.getKnowhowCategory().getNo()), -1);

		Map<String, Long> map = new HashMap<>();
		map.put("count", setOperations.size(product));
		return map;
	}

	public Slice<KnowhowListResponse> likeKnowhowList(Long memberNo, Pageable pageable) {
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		String key = memberNo + "_like_knowhow";
		int start = pageable.getPageNumber() * pageable.getPageSize();
		int end = start + pageable.getPageSize();

		List<Long> pkList = zSetOperations.reverseRange(key, start, end)
			.stream()
			.map(Long::parseLong)
			.collect(Collectors.toList());

		List<Knowhow> knowhowList = knowhowRepository.findByNoIn(pkList);
		Collections.sort(knowhowList, new Comparator<Knowhow>() {
			@Override
			public int compare(Knowhow o1, Knowhow o2) {
				return pkList.indexOf(o1.getNo()) - pkList.indexOf(o2.getNo());
			}
		});

		List<KnowhowListResponse> knowhowListResponse = knowhowList
			.stream()
			.map(knowhow -> {
				Long likeCnt = likeCount(knowhow.getNo());
				Long commentCnt = knowhowCommentRepository.countByKnowhow(knowhow).orElse(0L);
				return KnowhowListResponse.of(knowhow, likeCnt, commentCnt);
			})
			.collect(Collectors.toList());

		boolean hasNext = zSetOperations.size(key) > end + 1;
		return new SliceImpl<>(knowhowListResponse, pageable, hasNext);
	}
}
