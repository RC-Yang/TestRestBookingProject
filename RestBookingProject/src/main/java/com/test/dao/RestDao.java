package com.test.dao;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.test.bean.Image;
import com.test.bean.Restaurant;
import com.test.bean.User;

public interface RestDao {
	public List<Image> getAllRestImage();
	public List<Restaurant> getRestsByDistrictJoinImage(String country,String district);
	public List<Image> getRestImage(Integer restName,Integer restImageName);

}
