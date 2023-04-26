package com.ssafy.reslow.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class TestController {

	@GetMapping
	public Map<String, Object> test() {
		Map<String, Object> map = new HashMap<>();
		map.put("test","success");
		return map;
	}

}

