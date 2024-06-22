package com.test.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.test.bean.RestStyle;

public interface RestStyleRepository extends JpaRepository<RestStyle, Integer>{
	@Query("SELECT r FROM RestStyle r")
	List<RestStyle> findAllRestStyle();
}
