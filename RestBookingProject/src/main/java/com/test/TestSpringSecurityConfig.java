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
//@Configuration這個註釋在這邊的意義，是協助@EnableWebSecurity來註冊Spring Security必需的bean
//@EnableWebSecurity本身沒有註冊Spring Security必需bean的功能
//所以不可省略掉@Configuration，只剩下@EnableWebSecurity
//這樣這個TestSpringSecurityConfig類，即同時是Spring Bean註冊類、Spring Security啟動類
@EnableWebSecurity
public class TestSpringSecurityConfig  extends WebSecurityConfigurerAdapter{
	//DataSource Bean不須顯式的註冊；因為Spring Boot提供了對數據源的自動配置支持，故DataSource會自動配置
	@Autowired
	private DataSource dataSource;

	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
	    auth.jdbcAuthentication()
	        .dataSource(dataSource)
	        .usersByUsernameQuery("SELECT account, password, true as enabled FROM web.user WHERE account = ?")
	        //20240810新增
	        .authoritiesByUsernameQuery("SELECT account, authority FROM web.authorities WHERE account = ?")
	        .passwordEncoder(new PlainTextPasswordEncoder()); // 使用明文密码编码器
	}
	
	protected void configure(HttpSecurity http) throws Exception { 
        http
            .authorizeRequests(authorizeRequests -> 
                authorizeRequests
                    .antMatchers("/image/**","/js/**","/entry/goToLogIn","/entry/goToReg","/entry/checkLogin"
                    		,"/form/queryDistrictForRest").permitAll() // 公共资源无需认证
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
	//雖然@EnableWebSecurity會自動配置一些安全性相關的Bean，但AuthenticationManager並不會自動暴露為Bean
	//故其仍須被顯式的註冊
	//Spring Boot不能直接根據比方說application.properties的設定，自動生成AuthenticationManager物件
	@Bean
	//當Spring應用啟動時，所有被標註為@Bean的實例會被創建並註冊到Spring容器中
	//當其他類需要這些Bean時，Spring會將相關的Bean注入屬性中
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
}
