package com.ssafy.reslow.domain.member.service;

import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.reslow.domain.knowhow.entity.KnowhowCategory;
import com.ssafy.reslow.domain.knowhow.repository.KnowhowCategoryRepository;
import com.ssafy.reslow.domain.member.dto.MemberAccountRequest;
import com.ssafy.reslow.domain.member.dto.MemberAddressResponse;
import com.ssafy.reslow.domain.member.dto.MemberIdRequest;
import com.ssafy.reslow.domain.member.dto.MemberLoginRequest;
import com.ssafy.reslow.domain.member.dto.MemberNicknameRequest;
import com.ssafy.reslow.domain.member.dto.MemberNoNickPicResponse;
import com.ssafy.reslow.domain.member.dto.MemberSignUpRequest;
import com.ssafy.reslow.domain.member.dto.MemberUpdateRequest;
import com.ssafy.reslow.domain.member.dto.MemberUpdateResponse;
import com.ssafy.reslow.domain.member.entity.Device;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.entity.MemberAccount;
import com.ssafy.reslow.domain.member.entity.MemberAddress;
import com.ssafy.reslow.domain.member.repository.DeviceRepository;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.product.entity.ProductCategory;
import com.ssafy.reslow.domain.product.repository.ProductCategoryRepository;
import com.ssafy.reslow.global.auth.jwt.JwtTokenProvider;
import com.ssafy.reslow.global.common.dto.TokenResponse;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.infra.storage.StorageServiceImpl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class MemberService {

	private final MemberRepository memberRepository;
	private final ProductCategoryRepository productCategoryRepository;
	private final KnowhowCategoryRepository knowhowCategoryRepository;
	private final DeviceRepository deviceRepository;
	private final PasswordEncoder passwordEncoder;
	private final JwtTokenProvider jwtTokenProvider;
	private final RedisTemplate redisTemplate;
	private final AuthenticationManager authenticationManager;
	private final StorageServiceImpl s3Service;
	@Value("${default-image-s3}")
	private String DEFAULT_IMAGE_S3;

	public Map<String, Object> signUp(MemberSignUpRequest signUp) {
		if (memberRepository.existsById(signUp.getId()) || memberRepository.existsByNickname(signUp.getId())) {
			throw new CustomException(MEBER_ALREADY_EXSIST);
		}
		Member member = memberRepository.save(
			Member.toEntity(signUp, DEFAULT_IMAGE_S3, passwordEncoder.encode(signUp.getPassword())));

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
		boolean existAccount = member.getMemberAccount() != null;
		tokenInfo.setExistAccount(existAccount);

		redisTemplate.opsForValue()
			.set("RT:" + authentication.getName(), tokenInfo.getRefreshToken(),
				tokenInfo.getRefreshTokenExpirationTime(), TimeUnit.MILLISECONDS);
		return tokenInfo;
	}

	public Map<String, String> logout(Authentication authentication) {
		if (redisTemplate.opsForValue().get("RT:" + authentication.getName()) != null) {
			redisTemplate.delete("RT:" + authentication.getName());
		}
		Map<String, String> map = new HashMap<>();
		map.put("no", authentication.getName());
		return map;
	}

	public Map<String, String> idDuplicate(MemberIdRequest id) {
		Map<String, String> map = new HashMap<>();
		if (memberRepository.existsById(id.getId())) {
			map.put("isPossible", "NO");
		} else {
			map.put("isPossible", "YES");
		}
		return map;
	}

	public Map<String, String> nicknameDuplicate(MemberNicknameRequest nickname) {
		Map<String, String> map = new HashMap<>();
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
		String imageUrl = DEFAULT_IMAGE_S3;
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

	@Transactional
	public Map<String, Long> registAccount(Long memberNo, MemberAccountRequest request) {
		Member member = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		MemberAccount memberAccount = MemberAccount.of(request);
		member.registAccount(memberAccount);
		Map<String, Long> map = new HashMap<>();
		map.put("memberNo", memberNo);
		return map;
	}

	@Transactional
	public Map<String, Long> updateAccount(Long memberNo, MemberAccountRequest request) {
		Member member = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		MemberAccount memberAccount = member.getMemberAccount();
		MemberAccount updatedMemberAccount = MemberAccount.of(request);
		memberAccount.updateAccount(updatedMemberAccount);
		member.registAccount(memberAccount);
		Map<String, Long> map = new HashMap<>();
		map.put("memberNo", memberNo);
		return map;
	}

	public Map<String, String> addDeviceToken(Long memberNo, String preToken, String newToken) {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		// 새로운 등록 요청
		Device device;
		if (preToken.equals("null")) {
			device = Device.of(member, newToken);
		} else {
			device = deviceRepository.findByMemberAndDeviceToken(member, preToken)
				.orElse(Device.of(member, newToken));
			device.update(newToken);
		}
		deviceRepository.save(device);

		Map<String, String> map = new HashMap<>();
		map.put("device", "ok");
		return map;
	}

	public Map<String, String> deleteDeviceToken(Long memberNo, String token) {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		// 토큰 찾아서
		Device device = deviceRepository.findByMemberAndDeviceToken(member, token)
			.orElseThrow(() -> new CustomException(DEVICETOKEN_NOT_FOUND));
		// 토큰 삭제
		deviceRepository.delete(device);

		Map<String, String> map = new HashMap<>();
		map.put("delete", "ok");
		return map;
	}

	public MemberNoNickPicResponse getMemberNoAndNicknameAndProfilePic(Long memberNo) {
		Member member = memberRepository.findById(memberNo).orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		return MemberNoNickPicResponse.of(memberNo, member.getNickname(), member.getProfilePic());
	}
}
