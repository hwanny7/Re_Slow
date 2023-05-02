package com.ssafy.reslow.domain.member.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.entity.KnowhowCategory;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowCategoryRepository;
import com.ssafy.reslow.domain.member.dto.MemberAddressResponse;
import com.ssafy.reslow.domain.member.dto.MemberIdRequest;
import com.ssafy.reslow.domain.member.dto.MemberLoginRequest;
import com.ssafy.reslow.domain.member.dto.MemberNicknameRequest;
import com.ssafy.reslow.domain.member.dto.MemberSignUpRequest;
import com.ssafy.reslow.domain.member.dto.MemberUpdateRequest;
import com.ssafy.reslow.domain.member.dto.MemberUpdateResponse;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.entity.MemberAddress;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.product.entity.ProductCategory;
import com.ssafy.reslow.domain.product.repository.ProductCategoryRepository;
import com.ssafy.reslow.global.auth.jwt.JwtTokenProvider;
import com.ssafy.reslow.global.common.dto.TokenResponse;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.infra.storage.S3StorageClient;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class MemberService {

	private final MemberRepository memberRepository;
	private final ProductCategoryRepository productCategoryRepository;
	private final KnowhowCategoryRepository knowhowCategoryRepository;
	private final PasswordEncoder passwordEncoder;
	private final JwtTokenProvider jwtTokenProvider;
	private final RedisTemplate redisTemplate;
	private final AuthenticationManager authenticationManager;
	private final S3StorageClient s3Service;

	public Map<String, Object> signUp(MemberSignUpRequest signUp) {
		if (memberRepository.existsById(signUp.getId()) || memberRepository.existsByNickname(signUp.getId())) {
			throw new CustomException(MEBER_ALREADY_EXSIST);
		}
		Member member = memberRepository.save(Member.toEntity(signUp, passwordEncoder.encode(signUp.getPassword())));

		ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
		List<ProductCategory> productCategories = productCategoryRepository.findAll();
		productCategories.forEach((productCategory -> {
			zSetOperations.add("product_" + member.getNo(), String.valueOf(productCategory.getNo()), 0);
		}));
		List<KnowhowCategory> knowhowCategoryies = knowhowCategoryRepository.findAll();
		knowhowCategoryies.forEach((knowhowCategory -> {
			zSetOperations.add("knowhow_" + member.getNo(), String.valueOf(knowhowCategory.getNo()), 0);
		}));

		Map<String, Object> map = new HashMap<>();
		map.put("nickname", member.getNickname());
		return map;
	}

	public TokenResponse login(MemberLoginRequest login) {
		Member member = memberRepository.findById(login.getId())
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		if (!passwordEncoder.matches(login.getPassword(), member.getPassword())) {
			throw new CustomException(PASSWORD_NOT_MATCH);
		}

		UsernamePasswordAuthenticationToken authenticationToken = login.toAuthentication();
		Authentication authentication = authenticationManager.authenticate(authenticationToken);
		SecurityContextHolder.getContext().setAuthentication(authentication);
		TokenResponse tokenInfo = jwtTokenProvider.generateToken(authentication);

		redisTemplate.opsForValue()
			.set("RT:" + authentication.getName(), tokenInfo.getRefreshToken(),
				tokenInfo.getRefreshTokenExpirationTime(), TimeUnit.MILLISECONDS);
		return tokenInfo;
	}

	public Map<String, Object> logout(Authentication authentication) {
		if (redisTemplate.opsForValue().get("RT:" + authentication.getName()) != null) {
			redisTemplate.delete("RT:" + authentication.getName());
		}
		Map<String, Object> map = new HashMap<>();
		map.put("no", authentication.getName());
		return map;
	}

	public Map<String, Object> idDuplicate(MemberIdRequest id) {
		Map<String, Object> map = new HashMap<>();
		if (memberRepository.existsById(id.getId())) {
			map.put("isPossible", "NO");
		} else {
			map.put("isPossible", "YES");
		}
		return map;
	}

	public Map<String, Object> nicknameDuplicate(MemberNicknameRequest nickname) {
		Map<String, Object> map = new HashMap<>();
		if (memberRepository.existsByNickname(nickname.getNickname())) {
			map.put("isPossible", "NO");
		} else {
			map.put("isPossible", "YES");
		}
		return map;
	}

	public MemberUpdateResponse updateUser(Long memberNo, MemberUpdateRequest request, MultipartFile file)
		throws IOException {
		Member member = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		String imageUrl = null;
		if (!file.isEmpty()) {
			String preImg = member.getProfilePic();
			s3Service.deleteFile(preImg);
			imageUrl = s3Service.uploadFile(file);
		} else {
			imageUrl = member.getProfilePic();
		}
		member.updateMember(request.getNickname(), imageUrl);
		memberRepository.save(member);
		MemberAddress memberAddress = MemberAddress.toEntity(request);
		MemberUpdateResponse updateUser = MemberUpdateResponse.of(member, memberAddress);
		return updateUser;
	}

	public MemberAddressResponse userAddress(Long memberNo) {
		Member member = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		MemberAddress memberAddress = member.getMemberAddress();
		if (memberAddress == null) {
			throw new CustomException(ADDRESS_NOT_FOUND);
		}
		MemberAddressResponse response = MemberAddressResponse.of(memberAddress);
		return response;
	}
}
