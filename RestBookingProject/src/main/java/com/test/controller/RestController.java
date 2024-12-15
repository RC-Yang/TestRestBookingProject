package com.test.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.test.bean.District;
import com.test.bean.Image;
import com.test.bean.Restaurant;
import com.test.dao.RestDao;
import com.test.dao.RestRepositoryByJPA;
import com.test.service.FormService;

@Controller
@RequestMapping("/rest")
public class RestController {

	@Autowired
	private RestDao restDao;
	@Autowired
	private RestRepositoryByJPA restRepository;
	
	@RequestMapping(value="/queryAllRestImages")
	public String queryAllRestImages(Model model) {
		
		List<Image> allRestImages = restDao.getAllRestImage();
		
		model.addAttribute("allRestImages", allRestImages);
		
		return "queryRestResult";
	}

	@RequestMapping(value="/queryRests")
	public String queryRests(Model model,@RequestParam String country
			,@RequestParam String[] checkedDistrict) {
		//20241215修正被選中的的城市與行政區，呈顯的方式
		model.addAttribute("checkedDistrictList", Arrays.asList(checkedDistrict));
	
		List<Restaurant> allQueryRest = new ArrayList<>();
		
		for(String district:checkedDistrict) {
			
			//使用JPA
			//List<Restaurant> rests = restRepository.findRestsByDistrictJoinImage(dis);
			//使用Spring JDBC
			List<Restaurant> rests = restDao.getRestsByDistrictJoinImage(district.substring(0, 3), district.substring(3));
			for(Restaurant rest:rests) {
				allQueryRest.add(rest);
			}
		}
	
		model.addAttribute("rests", allQueryRest);
		//20240819修改
		return "queryRestResult2";
	}
}
