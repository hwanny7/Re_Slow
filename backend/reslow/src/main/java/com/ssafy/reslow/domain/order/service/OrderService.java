package com.ssafy.reslow.domain.order.service;

import static com.ssafy.reslow.domain.order.entity.OrderStatus.*;
import static com.ssafy.reslow.global.exception.ErrorCode.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.siot.IamportRestClient.response.Payment;
import com.ssafy.reslow.domain.coupon.entity.IssuedCoupon;
import com.ssafy.reslow.domain.coupon.repository.IssuedCouponRepository;
import com.ssafy.reslow.domain.member.entity.Device;
import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.member.repository.DeviceRepository;
import com.ssafy.reslow.domain.member.repository.MemberRepository;
import com.ssafy.reslow.domain.notice.entity.Notice;
import com.ssafy.reslow.domain.notice.repository.NoticeRepository;
import com.ssafy.reslow.domain.order.dto.OrderComfirmationResponse;
import com.ssafy.reslow.domain.order.dto.OrderListResponse;
import com.ssafy.reslow.domain.order.dto.OrderRegistRequest;
import com.ssafy.reslow.domain.order.dto.OrderUpdateCarrierRequest;
import com.ssafy.reslow.domain.order.dto.OrderUpdateStatusRequest;
import com.ssafy.reslow.domain.order.entity.Order;
import com.ssafy.reslow.domain.order.entity.OrderStatus;
import com.ssafy.reslow.domain.order.repository.OrderRepository;
import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.domain.product.repository.ProductRepository;
import com.ssafy.reslow.global.common.FCM.FirebaseCloudMessageService;
import com.ssafy.reslow.global.common.FCM.dto.ChatFcmMessage;
import com.ssafy.reslow.global.common.FCM.dto.MessageType;
import com.ssafy.reslow.global.exception.CustomException;
import com.ssafy.reslow.infra.delivery.DeliveryService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@Transactional
@RequiredArgsConstructor
public class OrderService {
	private final NoticeRepository noticeRepository;
	private final DeviceRepository deviceRepository;
	private final MemberRepository memberRepository;
	private final OrderRepository orderRepository;
	private final ProductRepository productRepository;
	private final IssuedCouponRepository issuedCouponRepository;
	private final PaymentService paymentService;
	private final DeliveryService deliveryService;
	private final RedisTemplate redisTemplate;

	public Slice<OrderListResponse> myOrderList(Long memberNo, int status, Pageable pageable) {
		Member member = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		Slice<Order> list;
		if (status == COMPLETE_DELIVERY.getValue()) {
			list = orderRepository.findByBuyerAndStatusIsGreaterThanEqualOrderByUpdatedDateDesc(
				member,
				OrderStatus.ofValue(status),
				pageable);
		} else {
			list = orderRepository.findByBuyerAndStatusOrderByUpdatedDateDesc(member,
				OrderStatus.ofValue(status),
				pageable);
		}

		List<OrderListResponse> responses = new ArrayList<>();
		list.stream().forEach(
			order -> {
				Product product = order.getProduct();
				String imageResource =
					product.getProductImages().isEmpty() ? null
						: product.getProductImages().get(0).getUrl();
				responses.add(OrderListResponse.of(product, order, imageResource,
					order.getStatus().getValue()));
			}
		);
		return new SliceImpl<>(responses, pageable, list.hasNext());
	}

	@Transactional
	public Map<String, Long> registOrder(String imp_uid, Long memberNo,
		OrderRegistRequest request) throws IOException, FirebaseMessagingException {
		Payment payment = paymentService.getPayment(imp_uid);
		if (!payment.getStatus().equals("paid")) {
			throw new CustomException(PAYMENT_FAILED);
		}
		Product product = productRepository.findById(request.getProductNo())
			.orElseThrow(() -> new CustomException(PRODUCT_NOT_FOUND));
		Member member = memberRepository.findById(memberNo)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
		IssuedCoupon issuedCoupon = null;
		if (request.getIssuedCouponNo() != null) {
			issuedCoupon = issuedCouponRepository.findById(request.getIssuedCouponNo())
				.orElseThrow(() -> new CustomException(COUPON_NOT_FOUND));
			issuedCoupon.use();
		}
		Order order = Order.of(request, product, member, issuedCoupon);
		Order savedOrder = orderRepository.save(order);

		// 상품 알림
		Device device = deviceRepository.findByMember(member)
			.orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));

		// 알림을 꺼놓지 않았다면
		boolean status = (boolean)redisTemplate.opsForHash()
			.get("alert_" + product.getMember().getNo(), MessageType.ORDER);

		if (status) {
			// 작성자에게 fcm 알림을 보낸다.
			fcmNotice(device.getDeviceToken(), product, member.getNickname());

			// 작성자가 받은 알림을 저장한다.
			Notice notice = Notice.of(member.getNickname(), product.getTitle(), LocalDateTime.now(),
				MessageType.ORDER);

			noticeRepository.save(notice);
		}

		product.setOrder(order);
		Map<String, Long> map = new HashMap<>();
		map.put("orderNo", savedOrder.getNo());
		return map;
	}

	@Transactional
	public Map<String, Long> updateStatus(Long orderNo, OrderUpdateStatusRequest request) {
		Order order = orderRepository.findById(orderNo)
			.orElseThrow(() -> new CustomException(ORDER_NOT_FOUND));

		if (request.getStatus() == ORDER_CANCEL.getValue()) {
			System.out.println("!!!");
			orderRepository.deleteById(orderNo);
		} else {
			order.updateStatus(OrderStatus.ofValue(request.getStatus()));
		}
		Map<String, Long> map = new HashMap<>();
		map.put("orderNo", orderNo);
		return map;
	}

	@Transactional
	public Map<String, Long> updateCarrier(Long orderNo, OrderUpdateCarrierRequest request) {
		Order order = orderRepository.findById(orderNo)
			.orElseThrow(() -> new CustomException(ORDER_NOT_FOUND));
		order.updateCarrier(request);
		Map<String, Long> map = new HashMap<>();
		map.put("orderNo", orderNo);
		return map;
	}

	public Object getCarrier(Long orderNo) {
		Order order = orderRepository.findById(orderNo)
			.orElseThrow(() -> new CustomException(ORDER_NOT_FOUND));
		String carrierCompany = order.getCarrierCompany();
		String carrierTrack = order.getCarrierTrack();
		Object savedCarrier = redisTemplate.opsForValue().get(carrierCompany + "_" + carrierTrack);
		Object response = null;
		if (savedCarrier == null) {
			response = deliveryService.deliveryTracking(carrierCompany,
				carrierTrack);
			redisTemplate.opsForValue()
				.set(carrierCompany + "_" + carrierTrack, String.valueOf(response));
			return response;
		} else {
			return savedCarrier;
		}
	}

	public Object getdirectCarrier(Long orderNo) {
		Order order = orderRepository.findById(orderNo)
			.orElseThrow(() -> new CustomException(ORDER_NOT_FOUND));
		String carrierCompany = order.getCarrierCompany();
		String carrierTrack = order.getCarrierTrack();
		String response = deliveryService.directDeliveryTracking(carrierCompany,
			carrierTrack);
		JSONObject jsonObject = new JSONObject(response);
		return jsonObject.get("completeYN");
	}

	public OrderComfirmationResponse orderConfirmation(Long orderNo) {
		Order order = orderRepository.findById(orderNo)
			.orElseThrow(() -> new CustomException(ORDER_NOT_FOUND));
		OrderComfirmationResponse response = OrderComfirmationResponse.of(order.getProduct(),
			order);
		return response;
	}

	public void fcmNotice(String deviceToken, Product product, String senderNickname) throws
		IOException,
		FirebaseMessagingException {

		ChatFcmMessage.SendCommentOrderMessage sendCommentMessage = ChatFcmMessage.SendCommentOrderMessage.of(
			deviceToken, product.getTitle(), "주문서 도착", product.getNo(), senderNickname);

		FirebaseCloudMessageService.sendCommentOrderMessageTo(sendCommentMessage);
	}
}
