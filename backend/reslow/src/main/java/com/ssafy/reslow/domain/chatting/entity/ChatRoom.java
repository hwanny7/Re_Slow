package com.ssafy.reslow.domain.chatting.entity;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.ssafy.reslow.domain.member.entity.Member;
import com.ssafy.reslow.domain.product.entity.Product;
import com.ssafy.reslow.global.common.entity.BaseEntity;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "CHAT_ROOM_TB")
@AttributeOverride(name = "no", column = @Column(name = "CHAT_ROOM_PK"))
public class ChatRoom extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 6494678977089006639L;
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SENDER_MEMBER_PK")
	private Member sender;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "RECEIVER_MEMBER_PK")
	private Member receiver;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRODUCT_PK")
	private Product product;

	public static ChatRoom create(Member sender, Member receiver) {
		ChatRoom chatRoom = new ChatRoom();
		chatRoom.sender = sender;
		chatRoom.receiver = receiver;
		return chatRoom;
	}
}
