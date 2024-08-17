package com.test;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.JdbcUserDetailsManager;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;

@Configuration
@EnableWebSecurity
public class TestSpringSecurity5xConfig {
	@Autowired
	private DataSource dataSource;

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		return http
				.authorizeRequests(
						authorizeRequests -> authorizeRequests
								.antMatchers("/image/**", "/js/**", "/entry/goToLogIn", "/entry/goToReg",
										"/entry/checkLogin", "/form/queryDistrictForRest")
								.permitAll().anyRequest().authenticated())
				.formLogin(formLogin -> formLogin.loginPage("/index.jsp").permitAll())
				.csrf(csrf -> csrf
						.ignoringAntMatchers("/entry/goToReg", "/entry/reg", "/entry/checkLogin", "/entry/goToLogIn")
						.csrfTokenRepository(new HttpSessionCsrfTokenRepository()))
				.build();
	}

	 @Bean
	    public AuthenticationProvider authenticationProvider() {
	        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
	        authProvider.setUserDetailsService(userDetailsService());
	        authProvider.setPasswordEncoder(new PlainTextPasswordEncoder());
	        return authProvider;
	    }

	    @Bean
	    public UserDetailsService userDetailsService() {
	        JdbcUserDetailsManager jdbcUserDetailsManager = new JdbcUserDetailsManager();
	        jdbcUserDetailsManager.setDataSource(dataSource);
	        // 设置用户查询
	        jdbcUserDetailsManager.setUsersByUsernameQuery("SELECT account, password, true as enabled FROM web.user WHERE account = ?");
	        
	        // 设置权限查询
	        jdbcUserDetailsManager.setAuthoritiesByUsernameQuery("SELECT account, authority FROM web.authorities WHERE account = ?");

	        return jdbcUserDetailsManager;
	    }
}
