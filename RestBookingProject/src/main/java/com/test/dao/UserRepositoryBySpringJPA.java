package com.test.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.test.bean.User;

public interface UserRepositoryBySpringJPA extends JpaRepository<User, String> {
	
	@Query("SELECT u FROM User u WHERE u.account = :account and u.userType=2")
	User queryRestUser(@Param("account")String account);
}
