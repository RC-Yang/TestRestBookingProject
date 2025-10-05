package com.test.dao;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.test.bean.VerificationToken;

public interface VerificationRepository extends JpaRepository<VerificationToken, Integer> {

	@Query("select vt from VerificationToken vt where vt.token = :token")
    Optional<VerificationToken> fetchByToken(@Param("token") String token);
}
