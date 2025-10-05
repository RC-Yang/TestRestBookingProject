package com.test.dao;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.test.bean.User;

public interface UserRepositoryBySpringJPA extends JpaRepository<User, String> {
	
	@Query("SELECT u FROM User u WHERE u.account = :account and u.userRole='ROLE_REST'")
	User queryRestUser(@Param("account")String account);
	@Query("SELECT u FROM User u WHERE u.account = :account")
	Optional<User> queryUserAccount(@Param("account")String account);
	@Query("SELECT u FROM User u WHERE u.account = :account and u.password = :password")
	Optional<User> queryUser(@Param("account")String account,@Param("password")String password);
}
