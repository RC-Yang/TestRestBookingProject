package com.test.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.test.bean.Country;
import com.test.bean.District;

public interface FormRepository extends JpaRepository<District, Integer>{
	
	@Query(value="SELECT d.* FROM district d join country c"
			+ " on d.country_name=c.country_name WHERE c.id = :cityId"
			,nativeQuery=true)
	List<District> findDistrictsByCity(@Param("cityId")Integer cityId);
	
	@Query("SELECT d FROM District d WHERE d.countryName = :country")
	List<District> findDistrictsByCountry(@Param("country")String country);
	
	@Query("SELECT d FROM District d")
	List<District> findAllDistricts();
	
	@Query("SELECT c FROM Country c")
	List<Country> findAllCity();

}
