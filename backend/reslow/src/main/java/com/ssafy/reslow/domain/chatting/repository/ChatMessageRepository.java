package com.ssafy.reslow.domain.chatting.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.Aggregation;
import org.springframework.data.mongodb.repository.MongoRepository;

import com.ssafy.reslow.domain.chatting.entity.ChatMessage;

public interface ChatMessageRepository extends MongoRepository<ChatMessage, String> {
	@Aggregation(pipeline = {
		"{$match: {roomId: {$in: ?0}}}",
		"{$sort: {dateTime: -1}}",
		"{$group: {_id: '$roomId', lastChat:{$first:  '$$ROOT'}}}",
		"{$project: {_id: 0, roomId: '$_id', user: '$lastChat.user', content: '$lastChat.content', dateTime: '$lastChat.dateTime'}}"
	})
	List<ChatMessage> findByRoomId(List<String> roomIdList);

}
