package com.test;

import javax.persistence.EntityManagerFactory;
import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
//@EnableAspectJAutoProxy
//上面那段不用加，因為Spring Boot會自動加
public class TestConfig {
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	public InternalResourceViewResolver internalResourceViewResolver() {
		InternalResourceViewResolver resolver = new InternalResourceViewResolver();
		resolver.setPrefix("/WEB-INF/views/");
		resolver.setSuffix(".jsp");
		
		return resolver;
	}

	//這包含Spring JDBC、Spring Data JPA、JPA的交易管理
	//dataSource、emf兩個參數，會由Spring Boot生成物件並做方法參數注入
	//Spring是根據new的物件型別，判斷註冊的bean是哪種
	@Bean(name = "jdbcTxManager")
	@Primary//設置預設的TransactionManager，取代bean註冊檔語法
	public PlatformTransactionManager jdbcTransactionManager(DataSource dataSource) {
		return new DataSourceTransactionManager(dataSource);
	}

	@Bean(name = "jpaTxManager")
	public PlatformTransactionManager jpaTransactionManager(EntityManagerFactory emf) {
		return new JpaTransactionManager(emf);
	}
}
