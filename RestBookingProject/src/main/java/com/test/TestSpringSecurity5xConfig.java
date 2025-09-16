package com.test;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.JdbcUserDetailsManager;

import java.util.*;

import javax.sql.DataSource;

import org.apache.catalina.connector.Connector;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.PortMapper;
import org.springframework.security.web.PortMapperImpl;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.OrRequestMatcher;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;

@Configuration
//@EnableWebSecurity
//在Spring Boot專案，啟用Spring Security，不需以上設定
public class TestSpringSecurity5xConfig {
	@Autowired
	private DataSource dataSource;
	//20241216設置8080請求通道，其將8080請求交給Spring filter chain
	@Bean
    public WebServerFactoryCustomizer<TomcatServletWebServerFactory> customizer() {
        return factory -> factory.addAdditionalTomcatConnectors(createHttpConnector());
    }

    private Connector createHttpConnector() {
        Connector connector = new Connector(TomcatServletWebServerFactory.DEFAULT_PROTOCOL);
        connector.setScheme("http");
        connector.setPort(8080);
        connector.setSecure(false);

        return connector;
    }

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

		return http//HttpSecurity物件的功能，就類似於一個清單，用於手動添加安全規定
				//啟用HSTS
//				.headers(headers -> 
//	                headers
//	                    .httpStrictTransportSecurity()
//	                    .includeSubDomains(true)
//	                    .maxAgeInSeconds(31536000)
//	            )
				.requiresChannel(channel -> {
				    channel.anyRequest().requiresSecure();
				        }
				).portMapper((portMapper) ->
	                portMapper
	                .http(8080).mapsTo(8443)
				)
				.authorizeRequests(
						authorizeRequests -> authorizeRequests
								.antMatchers("/image/**", "/js/**", "/entry/goToLogIn", "/entry/goToReg",
										"/entry/checkLogin", "/form/queryDistrictForRest","/index.jsp","/entry/reg"
										,"/indexForAdmin.jsp","/entry/checkloginForAdmin")
								.permitAll().anyRequest().authenticated())
				//用於確認任何請求路徑是否通過「是否為用戶」的檢查，若通過就放行請求路徑，若不通過則重導回去
				.csrf(csrf -> csrf
						.csrfTokenRepository(new HttpSessionCsrfTokenRepository()))
				//使用者登入後，Spring Security給這位使用者csrf token

				.logout(logout -> logout
					    .logoutRequestMatcher(new OrRequestMatcher(
					            new AntPathRequestMatcher("/session/logout", "POST"),
					            new AntPathRequestMatcher("/entry/logout",   "POST")
					        )).logoutSuccessUrl("/index.jsp")
					    .invalidateHttpSession(true)
					    .deleteCookies("JSESSIONID"))
				.build();//這是Spring Security拿HttpSecurity物件(這只是個清單)，再另外打包成的具有完整資安功能的物件
	}

	@Bean//這個bean用於根據用戶清單，檢查嘗試登入者是否為用戶
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(new PlainTextPasswordEncoder());
        return authProvider;
    }

    @Bean//這個bean用於設置用戶清單
    public UserDetailsService userDetailsService() {
        JdbcUserDetailsManager jdbcUserDetailsManager = new JdbcUserDetailsManager();
        jdbcUserDetailsManager.setDataSource(dataSource);
        // 設置用戶查詢
        jdbcUserDetailsManager.setUsersByUsernameQuery("SELECT account, password, true as enabled FROM web.user WHERE account = ?");
        
        // 設置權限查詢
        jdbcUserDetailsManager.setAuthoritiesByUsernameQuery("SELECT u.account, a.authority FROM web.user u join web.authorities a "
        		+ "on u.user_id=a.id WHERE u.account = ?");

        return jdbcUserDetailsManager;
    }
}
