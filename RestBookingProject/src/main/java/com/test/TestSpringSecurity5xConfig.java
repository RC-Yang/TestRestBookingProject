package com.test;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.apache.catalina.connector.Connector;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.OrRequestMatcher;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;

@Configuration
//@EnableWebSecurity
//在Spring Boot專案，啟用Spring Security，不需以上設定
public class TestSpringSecurity5xConfig {
//	@Autowired
//	private DataSource dataSource;
	
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
        
        connector.setRedirectPort(8443);

        return connector;
    }

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http,
            AuthenticationProvider customProvider) throws Exception {
		//這樣也是方法參數注入
		
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
				//設置驗證用戶工具
				.authenticationProvider(customProvider)
				//設置請求的授權方式；分別設置可直接授權的請求(這些請求也就不會被驗證provider處理)，跟必須經過驗證才可授權的請求
				.authorizeRequests(
						authorizeRequests -> authorizeRequests
								.antMatchers("/image/**", "/js/**", "/entry/goToLogIn", "/entry/goToReg",
										"/entry/checkLogin", "/form/queryDistrictForRest","/index.jsp","/entry/regForUser"
										,"/indexForAdmin.jsp","/entry/checkloginForAdmin","/entry/goToResetPassword"
										,"/entry/sendUpdatePasswordMail","/entry/updatePassword"
										,"/entry/verify")
								.permitAll().anyRequest().authenticated())
				//用表單驗證(若只有這個，就只能用表單驗證)
				.formLogin(form -> form
				          .loginPage("/entry/goToLogIn").usernameParameter("account")
					    .passwordParameter("password")
					    .loginProcessingUrl("/entry/checkLogin")
					    .defaultSuccessUrl("/entry/login"))
				
				//使用者登入後，Spring Security給這位使用者csrf token
				.csrf(csrf -> csrf
						.csrfTokenRepository(new HttpSessionCsrfTokenRepository())
						.ignoringRequestMatchers(
				                new AntPathRequestMatcher("/entry/updatePassword", "POST"),
				                new AntPathRequestMatcher("/entry/sendUpdatePasswordMail", "POST"),
				                new AntPathRequestMatcher("/entry/goToLogIn", "GET"))
				)
				.logout(logout -> logout
					    .logoutRequestMatcher(new OrRequestMatcher(
					            new AntPathRequestMatcher("/session/logout", "POST"),
					            new AntPathRequestMatcher("/entry/logout", "GET")
					        ))
					    .logoutSuccessUrl("/index.jsp")//url會跟重導通知，被伺服器包裝進response
					    .invalidateHttpSession(true)
					    .deleteCookies("JSESSIONID"))
				.build();//這是Spring Security拿HttpSecurity物件(這只是個清單)，再另外打包成的具有完整資安功能的物件
	}

	@Bean//這個bean讓Spring Security能根據用戶清單，檢查嘗試登入者是否為用戶
	//有了該bean，外加透過Spring Security驗證用戶登入成功，就可以在Spring Security tag使用principal
	//用方法參數注入法，來注入UserDetailsService
    public AuthenticationProvider authenticationProvider(UserDetailsService userDetailsService
    		, PasswordEncoder encoder) {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        //authProvider.setUserDetailsService(new TestUserDetailsService());
        //authProvider.setUserDetailsService(userDetailsService());
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(encoder);//註冊encoder後即可用方法參數注入
        return authProvider;
    }
	
//	@Bean
//	public UserDetailsService userDetailsService() {
//	    return new TestUserDetailsService();
//	}

//    @Bean//這個bean用於設置用戶清單
//    public UserDetailsService userDetailsService() {
//        JdbcUserDetailsManager jdbcUserDetailsManager = new JdbcUserDetailsManager();
//        jdbcUserDetailsManager.setDataSource(dataSource);
//        // 設置用戶查詢
//        jdbcUserDetailsManager.setUsersByUsernameQuery("SELECT account, password, true as enabled FROM web.user WHERE account = ?");
//        
//        // 設置權限查詢
//        jdbcUserDetailsManager.setAuthoritiesByUsernameQuery("SELECT u.account, a.authority FROM web.user u join web.authorities a "
//        		+ "on u.user_id=a.id WHERE u.account = ?");
//
//        return jdbcUserDetailsManager;
//    }
}
