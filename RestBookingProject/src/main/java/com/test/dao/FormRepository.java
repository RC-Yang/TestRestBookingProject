package com.test.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.test.bean.District;

public interface FormRepository extends JpaRepository<District, Integer>{
	
	@Query("SELECT d FROM District d WHERE d.countryName = :country")
	List<District> findDistrictsByCountry(@Param("country")String country);
	
	@Query("SELECT d FROM District d")
	List<District> findAllDistricts();
	
	@Query("SELECT d FROM District d")
	List<District> findAllCity();
}
