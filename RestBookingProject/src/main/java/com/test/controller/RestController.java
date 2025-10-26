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
	public String queryRests(Model model,@RequestParam String[] districtId) {
		
		List<Restaurant> allQueryRest = new ArrayList<>();

		List<String> districtNames=new ArrayList<>();
		for(String id:districtId) {
			String districtName = restDao.getDistrictNameById(id);
			districtNames.add(districtName);

			List<Restaurant> rests = restDao.getRestsByDistrictJoinImage(districtName);
			for(Restaurant rest:rests) {
				allQueryRest.add(rest);
			}
		}
		
		model.addAttribute("checkedDistrictList", districtNames);
		model.addAttribute("rests", allQueryRest);

		return "queryRestResult2";
	}
}
