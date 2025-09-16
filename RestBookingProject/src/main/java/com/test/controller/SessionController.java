package com.test.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/session")
public class SessionController {

	@GetMapping("/keepAlive")
	@ResponseBody//將已被Spring Boot轉成json格式字串的物件，寫入response body
	public Map<String,Object> keepAlive() {
		return Map.of("ifContinue", true);
	}
}
