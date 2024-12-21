package com.test.filter;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
//防禦XSS攻擊的方式
//先定義Spring MVC過濾器，以設定每次HTTP請求時的nonce，接著將其寫入request跟response，再對所有script tag添加nonce
@Component
public class NonceFilter extends OncePerRequestFilter
//這個nonceFilter過濾器，繼承OncePerRequestFilter的類，這不用特別設定要過濾的路徑，就可以預設所有路徑都會通過這過濾器。因默认情况下会对所有 HTTP 请求生效
//每次有請求到來時，都會通過這過濾器、執行類的方法；且回應要返回時也會執行該方法
//意即對request添加nonce，以及對response添加nonce，可在同一方法內實作
//且繼承這個類就不用重寫init()、destroy()，因已有預設的實作
{

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
    	 String nonce = generateNonce();
    	 String requestURI = request.getRequestURI();

    	 if (requestURI.contains("/queryBooking")||
    			 requestURI.contains("/deleteBookingRecord")||
    			 requestURI.contains("/goToUpdateBookingRecordPage")||
    			 requestURI.contains("/goToUpdateBookingRecord")||
    			 requestURI.contains("/goToReg")||requestURI.contains("/reg")||
    			 requestURI.contains("/goToLogIn")) {
    		 
    	 }
    	 else {
    		 response.setHeader("Content-Security-Policy", "script-src 'self' 'nonce-" + nonce + "' 'unsafe-inline' 'unsafe-eval' "
    	         		+ "https://code.jquery.com https://cdn.jsdelivr.net https://unpkg.com https://cdnjs.cloudflare.com https://cdn.datatables.net;");
    	         //設置'self'，表示可從自身專案引入js檔
    	         //設置'unsafe-inline' 'unsafe-eval'，表示jsp內部的script沒有nonce的話也可執行，且讓CSP允許eval函數被執行
    	         //且5個URL的資源直接放行不需檢查nonce
    	         request.setAttribute("nonce", nonce); 
    	 }

        filterChain.doFilter(request, response);
    }
    
    private String generateNonce() {
        SecureRandom random = new SecureRandom();
        byte[] nonceBytes = new byte[16];
        random.nextBytes(nonceBytes);
        return Base64.getEncoder().encodeToString(nonceBytes);
        //產生出來的唯一亂數可能會出現像是<、>這些會被瀏覽器當成tag的字元，故需將產生出來的亂數，轉成保證可被辨識的字元
    }
}

