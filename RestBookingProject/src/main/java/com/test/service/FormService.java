package com.test.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Service;

import com.test.bean.Country;
import com.test.bean.District;
import com.test.dao.FormRepository;

@Service
public class FormService {

	@Autowired
	private FormRepository formRepository;
	
	public List<District> findDistrictsByCity(Integer country){
		return formRepository.findDistrictsByCity(country);
	}	
	public List<District> findDistrictsByCountry(String country){
		return formRepository.findDistrictsByCountry(country);
	}
	public List<District> findAllDistricts(){
		return formRepository.findAllDistricts();
	}	
	public List<Country> findAllCity(){
		return formRepository.findAllCity();
	}
}
