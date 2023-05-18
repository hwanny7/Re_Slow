package com.ssafy.reslow.domain.knowhow.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.PriorityQueue;
import java.util.Set;
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
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRecommendRequest;
import com.ssafy.reslow.domain.knowhow.dto.KnowhowRecommendResponse;
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
import com.ssafy.reslow.infra.storage.StorageServiceImpl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class KnowhowService {

	private final RedisTemplate redisTemplate;
	private final MemberRepository memberRepository;
	private final KnowhowRepository knowhowRepository;
	private final KnowhowCategoryRepository knowhowCategoryRepository;
	private final KnowhowContentRepository knowhowContentRepository;
	private final KnowhowCommentRepository knowhowCommentRepository;
	private final StorageServiceImpl s3StorageClient;

	// 게시글 정보 저장
	public String saveKnowhow(Long memberNo, KnowhowRequest knowhowRequest) throws IOException {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		// 카테고리 객체 만들기
		KnowhowCategory category = knowhowCategoryRepository.findById(knowhowRequest.getCategoryNo())
			.orElseThrow(() -> new NoSuchElementException("category 존재하지 않음"));

		// 노하우 테이블 저장
		Knowhow knowhow = Knowhow.of(knowhowRequest, member, category);
		Knowhow newKnowhow = knowhowRepository.save(knowhow);

		// 노하우 글 저장
		saveKnowhowContent(knowhowRequest.getContentList(), knowhowRequest.getImageList(), knowhow);

		// 노하우 글 좋아요 개수 0으로 레디스에 저장
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		zSetOperations.add("knowhow", String.valueOf(newKnowhow.getNo()), 0);

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

	public KnowhowDetailResponse getKnowhowDetail(Long memberNo, Long knowhowNo) {
		Knowhow knowhow = knowhowRepository.findById(knowhowNo)
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));

		List<KnowhowContent> contentList = knowhow.getKnowhowContents();
		List<KnowhowContentDetail> detailList = new ArrayList<>();
		for (int i = 1; i <= contentList.size(); i++) {
			KnowhowContent content = contentList.get(i - 1);
			detailList.add(KnowhowContentDetail.ofEntity((long)i, content));
		}

		return KnowhowDetailResponse.of(knowhow, detailList, checkLiked(memberNo, knowhowNo), likeCount(knowhowNo));
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
		knowhow.update(KnowhowUpdateRequest.of(updateRequest), member, category);

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
		if (knowhow.getMember().getNo() != memberNo) {
			throw new CustomException(FORBIDDEN);
		}

		knowhowRepository.deleteById(knowhowNo);
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();

		String knowhowString = String.valueOf(knowhowNo);
		Set<String> likedMember = setOperations.members(knowhowString);
		Iterator<String> itor = likedMember.iterator();

		while (itor.hasNext()) {
			// 사용자가 좋아하는 카테고리 개수 -1
			zSetOperations.incrementScore("knowhow_" + memberNo,
				String.valueOf(knowhow.getKnowhowCategory().getNo()),
				-1);

			// 사용자의 좋아요 목록에서 제거
			zSetOperations.remove(memberNo + "_like_knowhow", knowhowString);
		}

		// 글 삭제
		setOperations.remove(knowhowString, String.valueOf(memberNo));
		zSetOperations.remove("knowhow", knowhowString);
		return "글 삭제 완료";
	}

	public List<KnowhowListResponse> getKnowhowList(Long memberNo, Pageable pageable, Long category,
		KnowhowRecommendRequest keywords) {

		List<Knowhow> list = knowhowRepository.findByKeywordsAndCategory(keywords, category,
			pageable);

		List<KnowhowListResponse> knowhowListResponseList = new ArrayList<>();

		list.forEach(
			knowhow -> knowhowListResponseList.add(KnowhowListResponse.of(knowhow, likeCount(knowhow.getNo()),
				(long)knowhow.getKnowhowComments().size(),
				checkLiked(memberNo, knowhow.getNo()))));

		return knowhowListResponseList;
	}

	/**
	 * 키워드별 노하우 추천
	 * @param memberNo
	 * @param pageable
	 * @param keywords
	 * @return 추천된 노하우 정보 List
	 */
	public List<KnowhowListResponse> getRecommendKnowhowList(Long memberNo, Pageable pageable,
		KnowhowRecommendRequest keywords) {
		Long category = checkMostLikedCategory(memberNo);

		List<Knowhow> list = knowhowRepository.findByKeywordsAndCategory(keywords, category,
			pageable);

		List<KnowhowListResponse> knowhowListResponseList = new ArrayList<>();
		PriorityQueue<KnowhowListResponse> pq = new PriorityQueue<>(
			(o1, o2) -> Long.compare(o2.getLikeCnt(), o1.getLikeCnt()));

		list.forEach(knowhow ->
			pq.add(KnowhowListResponse.of(knowhow, likeCount(knowhow.getNo()),
				(long)knowhow.getKnowhowComments().size(),
				checkLiked(memberNo, knowhow.getNo()))));

		for (int i = 0; i < Math.min(list.size(), 3); i++) {
			knowhowListResponseList.add(pq.poll());
		}

		return knowhowListResponseList;
	}

	/**
	 * 메인화면 노하우 추천
	 * 전체 글 최신순 100개 중에서 좋아요가 많은 노하우 글 추천
	 * @return List<KnowhowRecommendResponse>
	 */
	public List<KnowhowRecommendResponse> getMainKnowhowList() {
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		Set<String> KnowhowNoSet = zSetOperations.reverseRange("knowhow", 0, 4); // 4개 넘겨줌

		Iterator<String> itor = KnowhowNoSet.iterator();
		List<KnowhowRecommendResponse> knowhowRecommendResponseList = new ArrayList<>();
		while (itor.hasNext()) {
			Long knowhowNo = Long.valueOf(itor.next());
			Knowhow knowhow = knowhowRepository.findById(knowhowNo)
				.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));

			knowhowRecommendResponseList.add(KnowhowRecommendResponse.of(knowhow));
		}
		return knowhowRecommendResponseList;
	}

	public List<KnowhowListResponse> getMyKnowhowList(Pageable pageable, Long memberNo) {
		List<Knowhow> knowhowList = knowhowRepository.findAllByMember_No(pageable, memberNo).getContent();
		List<KnowhowListResponse> list = knowhowList
			.stream()
			.map(knowhow -> {
				// 해당 글 좋아요 개수 세기
				Long likeCnt = likeCount(knowhow.getNo());
				// 해당 글 댓글 개수 세기
				Long commentCnt = knowhowCommentRepository.countByKnowhow(knowhow).orElse(0L);
				// 노하우 리스트에 저장하기
				return KnowhowListResponse.of(knowhow, likeCnt, commentCnt, checkLiked(memberNo, knowhow.getNo()));
			})
			.collect(Collectors.toList());

		return list;
	}

	public Long likeCount(Long knowhowNo) {
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		return setOperations.size(String.valueOf(knowhowNo));
	}

	public boolean checkLiked(Long memberNo, Long knowhowNo) {
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		return setOperations.isMember(String.valueOf(knowhowNo), String.valueOf(memberNo));
	}

	/**
	 * 사용자가 좋아요를 많이 누른 카테고리 확인
	 * @param memberNo
	 * @return 좋아하는 카테고리No, 없을 시 -1
	 */
	public Long checkMostLikedCategory(Long memberNo) {
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		String mostLikeCategory = String.valueOf(zSetOperations.range("knowhow_" + memberNo, 0, 1));
		mostLikeCategory = mostLikeCategory.substring(1, mostLikeCategory.length() - 1);

		// 좋아요를 누른게 없으면
		Double mostLikeScore = zSetOperations.score("knowhow_" + memberNo, mostLikeCategory);
		if (mostLikeScore == null || mostLikeScore == 0.0)
			return null;

		return Long.parseLong(mostLikeCategory);
	}

	public Map<String, Long> likeKnowhow(Long memberNo, Long knowhowNo) {
		Knowhow knowhow = knowhowRepository.findById(knowhowNo)
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		String knowhowString = String.valueOf(knowhowNo);

		// key: knowhowNo, value: memberNo
		setOperations.add(knowhowString, String.valueOf(memberNo));
		boolean added = zSetOperations.addIfAbsent(memberNo + "_like_knowhow", knowhowString,
			System.currentTimeMillis());
		if (added) {
			zSetOperations.incrementScore("knowhow", knowhowString, 1);
			zSetOperations.incrementScore("knowhow_" + memberNo, String.valueOf(knowhow.getKnowhowCategory().getNo()),
				1);
		}

		Map<String, Long> map = new HashMap<>();
		map.put("count", (long)Math.floor(zSetOperations.score("knowhow", knowhowString)));
		return map;
	}

	public Map<String, Long> unlikeKnowhow(Long memberNo, Long knowhowNo) {
		Knowhow knowhow = knowhowRepository.findById(knowhowNo)
			.orElseThrow(() -> new CustomException(KNOWHOW_NOT_FOUND));
		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		SetOperations<String, String> setOperations = redisTemplate.opsForSet();
		String knowhowString = String.valueOf(knowhowNo);

		// 사용자가 좋아요하지 않은 게시글이라면
		if (!setOperations.isMember(knowhowString, String.valueOf(memberNo))) {
			throw new CustomException(KNOWHOW_NOT_FOUND);
		}
		// 노하우 글에 있는 사용자 목록에서 사용자 삭제
		setOperations.remove(knowhowString, String.valueOf(memberNo));

		zSetOperations.remove(memberNo + "_like_knowhow", knowhowString);
		zSetOperations.incrementScore("knowhow", knowhowString, -1);
		zSetOperations.incrementScore("knowhow_" + memberNo, String.valueOf(knowhow.getKnowhowCategory().getNo()), -1);

		Map<String, Long> map = new HashMap<>();
		map.put("count", (long)Math.floor(zSetOperations.score("knowhow", knowhowString)));
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
				return KnowhowListResponse.of(knowhow, likeCnt, commentCnt, checkLiked(memberNo, knowhow.getNo()));
			})
			.collect(Collectors.toList());

		boolean hasNext = zSetOperations.size(key) > end + 1;
		return new SliceImpl<>(knowhowListResponse, pageable, hasNext);
	}
}
