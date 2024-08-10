package com.test;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;


@Configuration
@EnableWebSecurity
public class TestSpringSecurityConfig  extends WebSecurityConfigurerAdapter{
	
	@Autowired
	private DataSource dataSource;
	@Bean
    public PasswordEncoder passwordEncoder() {
        return new PlainTextPasswordEncoder(); // 使用自定义的明文密码编码器
    }

	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
	    auth.jdbcAuthentication()
	        .dataSource(dataSource)
	        .usersByUsernameQuery("SELECT account, password, true as enabled FROM web.user WHERE account = ?")
	        //20240810新增
	        .authoritiesByUsernameQuery("SELECT account, authority FROM web.authorities WHERE account = ?")
	        .passwordEncoder(passwordEncoder()); // 使用明文密码编码器
	}
	
	protected void configure(HttpSecurity http) throws Exception { 
        http
            .authorizeRequests(authorizeRequests -> 
                authorizeRequests
                    .antMatchers("/image/**","/js/**","/entry/goToLogIn","/entry/goToReg","/entry/checkLogin").permitAll() // 公共资源无需认证
                    .anyRequest().authenticated() // 其他请求需要认证
            )
            .formLogin(formLogin -> 
                formLogin
                    .loginPage("/index.jsp")//一定要設定起始頁面，否則Spring Security將以自己的頁面做為預設頁面
                    .permitAll()
            )
            .logout(logout -> 
                logout
                    .permitAll()
            )
            .csrf(csrf -> 
		                csrf
		                .ignoringAntMatchers("/entry/goToReg", "/entry/reg","/entry/checkLogin","/entry/goToLogIn") // 註冊和登入頁面忽略 CSRF
		                .csrfTokenRepository(new HttpSessionCsrfTokenRepository())
            );
    }

	@Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
}
