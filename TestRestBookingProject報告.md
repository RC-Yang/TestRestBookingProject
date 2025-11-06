# Git：

## 如果要避免不需要提交的檔案，出現於unstaged change欄位：

首先，下載.gitignore檔。  
<https://github.com/github/gitignore/blob/main/Global/Eclipse.gitignore>

接著執行以下指令：  
![](media/73d6f37c62184195c204737bd4ebfa7f.PNG)

執行該指令後，便會於專案根目錄，產生.gitignore檔，這時就將剛剛下載下來的.gitignore檔，其內容通通貼到這個新產生的.gitignore檔，並存檔。

![](media/73d6f37c62184195c204737bd4ebfa7f.PNG)

最後回到egit視圖，重新整理即可。

## 如果要讓檔案，完全回復到遠端版本：

右鍵檔案-\>Replace With-\>HEAD Revision(恢復成本地分支最後一次commit的內容)。

## 如何將多餘的檔案(.settings跟target內檔案)移出git的管理，以讓egit的unstaged、staged change都沒有這些檔案：

### 首先先檢查要移除的檔案：

C:\\Users\\cuser\\git\\TestRestBookingProject\>git ls-files \| findstr target

### 接著移除：

C:\\Users\\cuser\\git\\TestRestBookingProject\>git rm -r --cached RestBookingProject/target

C:\\Users\\cuser\\git\\TestRestBookingProject\>git rm -r --cached RestBookingProject/.settings

### 再次檢查檔案是否被移除：

C:\\Users\\cuser\\git\\TestRestBookingProject\>git ls-files \| findstr target

C:\\Users\\cuser\\git\\TestRestBookingProject\>git ls-files \| findstr settings

### 接著就可正式將這些檔案，移出git管理：

git commit -m "remove .settings and target from version control"

### 檢查結果是否是預期的：

C:\\Users\\cuser\\git\\TestRestBookingProject\>git status

如果Changes not staged for commit、Untracked files都沒有 .settings 與 target，即為預期結果。

### 檔案又退回到staged change，所有檔案圖示，都有一個灰色叉叉：

因為尚未執行

C:\\Users\\cuser\\git\\TestRestBookingProject\>  
git commit -m "remove .settings and target from version control"

# 如何啟動HTTPS：

透過Spring Boot的application.properties：

## application.properties：

於application.properties，啟動內嵌Tomcat的SSL、設置https憑證，且伺服器端以8443為埠號。  
server.ssl.enabled=true

server.ssl.key-store=classpath:keystore.p12

server.ssl.key-store-password=606452441716

server.ssl.key-store-type=PKCS12

server.port=8443

## Spring Boot跟Spring MVC專案的classpath？

classapth可以直接當成src/main/resources；在開發習慣上可以這樣想，但實際上不完全等於。

## server.ssl.key-store=classpath:keystore.p12 寫成這樣，為何路徑不會被解析成：src/main/resourceskeystore.p12 而可以是src/main/resources/keystore.p12？

classpath:keystore.p12，指的是「class path 根目錄下的 keystore.p12」，  
而非直接去拼接src/main/resourceskeystore.p12。

## 如何查看自簽憑證：

keytool -list -v -storetype PKCS12 -keystore C:\\Users\\cuser\\git\\TestRestBookingProject\\RestBookingProject\\src\\main\\resources\\keystore.p12

# 註冊功能：

## 註冊頁面：

reqAndLogin5.jsp![](media/f5f587f198a6d01af2a5cba967bf2499.PNG)

針對email欄位與密碼欄位，分別檢查email格式與兩個密碼是否一致：

### 檢查email格式：

於email欄位設置type="email"；瀏覽器會檢查email基本格式，若沒通過檢查，瀏覽器會自動加上invalid偽類。

這時再給該欄位所在區塊，添加was-validated這個class；was-validated是bootstrap的class，讓合法的(:valid)input欄位框變成綠色，不合法的(:invalid)input欄位框變成紅色，且invalid-feedback的display變成block(invalid-feedback本來是display: none;)。

該欄位所在區塊：  
**var** emailDiv = document.getElementsByClassName("emailDiv");

添加was-validated這個class：  
emailDiv[0].classList.add("was-validated");

若擔心該類會重複被添加，那就在add之前先添加  
emailDiv[0].classList.remove('was-validated');

而該檢查是keyup事件發生當下進行的，故將其包在keyup事件內：

\$("\#reg \#email").keyup(**function**(){

emailDiv[0].classList.remove('was-validated');

emailDiv[0].classList.add("was-validated");

});

畫面：  
![](media/88da956eb8ba655b75529fd77d1cba82.PNG)

### 檢查兩個密碼是否一致：

取出這兩個欄位值進行檢查，若不一致就對表單內，該元素的setCustomValidity寫入值，例如空白字元，這樣該元素自動被瀏覽器添加:invalid偽類。這時一樣給該欄位所在區塊，添加was-validated這個class。  
密碼欄位：  
**var** checkPassword = document.getElementById("checkedPassword");

該欄位所在區塊：  
**var** pwdDiv = document.getElementsByClassName("pwdDiv");

對表單內，該元素的setCustomValidity寫入值，例如空白字元：  
checkPassword.setCustomValidity(" ");

給該欄位所在區塊，添加was-validated這個class：  
pwdDiv[0].classList.add("was-validated");

而這是在該欄位發生input事件時要做的檢查：

checkPassword.addEventListener("input",**function**(e){

checkPwdMatch();

});

畫面：  
![](media/130393362a8e8e79143d466035514a69.PNG)

### 傳送註冊表單：

使用JQuery AJAX，這樣才能在回呼函數，呈顯註冊成功或失敗的視窗。

document.getElementById('regSubmitButton').addEventListener('click',**function**(e){

**var** regForm = document.getElementById('reg');

**if**(regForm.checkValidity()){

**var** regFormData = **new** FormData(regForm);

\$.ajax({

url: "\${pageContext.request.contextPath}/entry/regForUser",

type: "post",

data: regFormData,

processData: **false**,

contentType: **false**,

success: **function**(response) {

**if**(response=="用戶驗證信已寄出"){

\$('\#regSuccess.modal').modal('show');

}

},

error: **function**(xhr, status, error) {

}

});

}

checkValidity()是瀏覽器提供的、驗證表單的API，可直接使用。

使用FormData物件是為了最好的包含表單內所有類型的資料；如果用JQuery的serialize()就無法包含圖片。

那兩個false是為了處理傳送圖片而設置。

JQuery ajax回呼函數參數，為response body的內容，可直接用或用JSON.parse()處理；fetch()則回一個Response物件，你得再呼叫res.text()或res.json()才拿得到response body的內容。

**else**{

e.preventDefault();

e.stopPropagation();

regForm.classList.add("was-validated");

}

若表單驗證失敗，則停止事件預設行為，並阻止事件上浮到上層元素而被攔截，並給欄位所在區塊添加was-validated類。

畫面：  
![](media/f758ef9e7cb094581ccd383a20fceba1.PNG)

## 後端：

後端要儲存註冊資料，但註冊的用戶此時尚未啟動，需要產生含驗證碼token的驗證連結，透過用戶給的email傳給用戶，用戶須點擊該連結以啟動註冊用戶。

user跟驗證碼token，因為一user可以有多個驗證信，故其是一對多的關係，所以驗證碼token必然是獨立的bean；故設置驗證碼bean，以及對應的表格。

新增表格需加上  
ENGINE=InnoDB

DEFAULT CHARACTER SET utf8mb4

COLLATE utf8mb4_0900_ai_ci;

### 驗證碼bean：

VerificationToken：

@Column

**private** **boolean** used;

因為token是一次性的，故以該屬性表示是否已被用過；預設為false。

最重要的是其跟user bean的綁定，其有user外鍵，其又跟user為多對一關係故用@ManyToOne、@JoinColumn：

@ManyToOne

@JoinColumn(name="user_account")

**private** User user;

又有外鍵的那一方，可透過外鍵去主控另一方內容，故這時驗證碼bean是主控方。

而在user bean也要做出修改，因為其跟驗證碼是一對多的關係，故用@OneToMany；這時user bean是被控方，要標示被主控方的哪個部分主控，就是主控方的外鍵，也就是主控方外鍵對應的屬性，故要寫成：

@OneToMany(mappedBy="user")

**private** List\<VerificationToken\> verificationToken;

user是雙向關係的被控端，那mappedBy表示被誰主控，主控方是Token，因為其有user這個對應外鍵的屬性，故屬性user能主控所有關連到的user。故mappedBy為user。

### Controller：

EntryController：

儲存註冊資料：  
@PostMapping(value="/regForUser")

@ResponseBody

**public** String registerToDB(@Valid RegisterDTO registerDTO){

String token = userService.register(registerDTO);

若表單欄位名直接等於DTO屬性名，則Spring MVC可直接將表單值對應到DTO屬性值。

@Valid是對表單值啟用後端驗證，可不加。

### Service：

UserService：

#### 設置encoder：

PasswordEncoder encoder;

需要encoder，因為等等要把密碼從明文變成密文。

這名稱要跟  
@Bean public PasswordEncoder passwordEncoder() { return new BCryptPasswordEncoder(); }  
搭配？不用，型別有對上即可。

**public** UserService(UserDao userDao, PasswordEncoder encoder, VerificationRepository verificationRepository) {

**this**.encoder = encoder;

}

透過建構子注入，注入註冊過的encoder。

#### 儲存用戶：

@Transactional("jpaTxManager")

**public** String register(RegisterDTO reg) {

u.setPassword(encoder.encode(reg.getPassword()));

u.setEnabled(**false**);

**int** result = userDao.addUser(u);

存入dao前，將密碼從明文變成密文。

用戶狀態設為尚未啟動。

呼叫dao方法，該方法由Spring JDBC寫成。

既然該方法由Spring JDBC寫成，那麼為何交易管理器用Spring Data JPA的？因為後面要呼叫的DAO方法由Spring Data JPA寫成，而Spring Data JPA版交易管理器，相容Spring JDBC。

若在Service內有分別用Spring JDBC、Spring Data JPA的DAO方法，那直接用 @Transactional可以根據實際狀況，切換不同的交易管理器？

不行。

#### 產生驗證碼：

需要分別產生明文版跟密文版：

明文版，要附加在驗證連結中：

**byte**[] key = KeyGenerators.*secureRandom*(32).generateKey();

String tokenForEmail = Base64.*getUrlEncoder*().withoutPadding().encodeToString(key);

密文版，要寫入資料庫：

md = MessageDigest.*getInstance*("SHA-256");

String tokenHash = java.util.HexFormat.*of*().formatHex(md.digest(tokenForEmail.getBytes(StandardCharsets.**UTF_8**)));

VerificationToken vt = **new** VerificationToken();

vt.setToken(tokenHash);

vt.setUser(u);

vt.setCreatedAt(Instant.*now*());

verificationRepository.save(vt);

驗證碼生成時間，選擇Instant.now()，是因為其最能鎖定在某個時間。

#### 回傳明文版驗證碼：

**return** tokenForEmail;

### Spring Data JPA Repository：

**public** **interface** VerificationRepository **extends** JpaRepository\<VerificationToken, Integer\> {

}

在Spring Data JPA，tokenRepo extends JpaRepository 就可呼叫save()。

### 回到Controller：

取得明文版驗證碼，那就能寄信了。

**if**(token!=**null**) {

emailService.sendVerificationMail(registerDTO.getEmail(), token);

}

回傳訊息給回呼函數，讓他可以彈出modal來告知用戶收信。

**return** "用戶驗證信已寄出";

畫面：  
![](media/29a7326745a11ba130e1b3d641cba656.PNG)

email：  
![](media/0a8e01a7821dfc4fc2c27e8872f692f9.PNG)

## 驗證用戶：

點擊連結後就進入Controller：

### Controller：

EntryController：

@GetMapping("/verify")

**public** String verify(@RequestParam String token,RedirectAttributes ra) {

**int** result = userService.verify(token);

}

RedirectAttributes redirectAttribute，這個參數是方法參數注入。

### Service：

UserService：

將明文版驗證碼轉為密文版，來進行比對，若比對成功則修改用戶狀態、將驗證碼改為已使用。

@Transactional("jpaTxManager")

**public** **int** verify(String rawToken) {

Optional\<VerificationToken\> result = verificationRepository.fetchByToken(token);

**if**(result.isPresent()) {

VerificationToken vt = result.get();

vt.setUsed(**true**);

verificationRepository.save(vt);

User user = result.get().getUser();

//user.setEnabled(true);

**return** userDao.updateUser(user);

fetchByToken方法是自訂的Spring Data JPA方法：  
@Query("select vt from VerificationToken vt where vt.token = :token")

Optional\<VerificationToken\> fetchByToken(@Param("token") String token);

將驗證碼改為已使用：  
verificationRepository.save(vt);

Spring Data JPA的save，會根據主鍵是否存在，判斷要做insert還是update。

修改用戶狀態：  
userDao.updateUser(user);

### 回到Controller：

回傳訊息給登入頁面，以呈顯含訊息的alert視窗：

**if**(result!=0) {

ra.addFlashAttribute("verificationPass", "用戶已通過驗證");

**return** "redirect:/entry/goToLogIn";

}

**return** **null**;

addFlashAttribute(key, val) 將資料先暫存(通常在Session)，再放入下一請求的request，才能用el取出資料；addAttribute(key, val)會將資訊直接曝露在querystring，故較不適合。

在Spring MVC，"redirect:/entry/goToLogIn"  
路徑直接會被加上ContextPath。

### 回到頁面：

regAndLogin5.jsp：

\<c:if test=*"*\${**not empty** verificationPass}*"*\>

\<div class=*"alert alert-success position-relative"*\>

\${verificationPass}

\<button type=*"button"* class=*"btn-close position-absolute end-0 me-2"* data-bs-dismiss=*"alert"* aria-label=*"Close"*\>\</button\>

\</div\>

\</c:if\>

position-absolute 是根據上層元素來做絕對定位？根據上層有position: relative的元素。

畫面：  
![](media/0d0c59d64ef9d765404afd05a8647d78.png)

## 遇到的錯誤：

### java.lang.IllegalStateException: Already value [org.springframework.jdbc.datasource.ConnectionHolder@4a31d267] for key [HikariDataSource (HikariPool-1)] bound to thread

添加@Transactional("jpaTxManager")

### org.springframework.beans.factory.NoSuchBeanDefinitionException: No bean named 'transactionManager' available: No matching TransactionManager bean found for qualifier 'transactionManager' - neither qualifier match nor bean name match!

添加

@EnableJpaRepositories(transactionManagerRef = "jpaTxManager")  
這樣就能取代bean註冊檔語法：  
\<tx:annotation-driven transaction-manager="transactionManager"\>\</tx:annotation-driven\>

到Spring Boot啟動類

### java.sql.SQLException: Field 'createdAt' doesn't have a default value

資料庫欄位名改成created_at

### 出現Failed to authenticate since password does not match stored value

因為註冊密碼，encode了兩次。

# 登入功能：

首先會用http://localhost:8080/RestBookingProject/index.jsp  
來登入首頁，接著要能自動跳轉到https://localhost:8443/RestBookingProject/index.jsp

## 如何設置http請求，自動跳轉到https：

TestSpringSecurity5xConfig.java：  
透過Spring Security，先設置http 8080請求專用的通道：

### 設置http 8080請求專用的通道：

@Bean

**public** WebServerFactoryCustomizer\<TomcatServletWebServerFactory\> customizer() {

**return** factory -\> factory.addAdditionalTomcatConnectors(createHttpConnector());

}

**private** Connector createHttpConnector() {

Connector connector = **new** Connector(TomcatServletWebServerFactory.**DEFAULT_PROTOCOL**);

connector.setScheme("http");

connector.setPort(8080);

connector.setSecure(**false**);

**return** connector;

}

### 處理來自http通道的請求：

來到專門處理來自http通道的請求，其先將http url改成https url，包在response內，並回覆要求瀏覽器重導的response給瀏覽器，讓瀏覽器用https的url，進行重導。：  
.requiresChannel(channel -\> {

channel.anyRequest().requiresSecure();

}).portMapper((portMapper) -\>

portMapper

.http(8080).mapsTo(8443)

)

重導結果：  
![](media/bb7064992962d2bd4d5bd11dcea10bc5.png)

## 驗證與授權：

### 設置驗證用戶工具：

.authenticationProvider(customProvider)

AuthenticationProvider讓Spring Security能根據用戶清單，檢查嘗試登入者是否為用戶。

有了AuthenticationProvider，外加透過Spring Security驗證用戶登入成功，就可以在Spring Security tag使用principal。

authenticationProvider(customProvider)，這段設置驗證方式，但不執行驗證；真正的驗證-\>不用在securityFilterChain內定義。

### 授權：

.authorizeRequests(authorizeRequests -\> authorizeRequests

.antMatchers("/entry/goToLogIn",

"/entry/checkLogin", "/index.jsp")

.permitAll().anyRequest().authenticated())

設置請求的授權方式：分別設置可直接授權的請求，跟必須經過驗證才可授權的請求。

### 驗證：

這裡只設定表單驗證：

.formLogin(form -\> form

.loginPage("/entry/goToLogIn").usernameParameter("account")

.passwordParameter("password")

.loginProcessingUrl("/entry/checkLogin")

.defaultSuccessUrl("/entry/login"))

loginProcessingUrl表示該url對應到Spring Security自帶的驗證功能，完全不需自己另外寫方法來驗證，故該url無對應方法。

defaultSuccessUrl方法，表示驗證成功後，重導要用的url；這個url就可對應到某方法，以便做forward。這表示若要forward到某個jsp頁面，就必須用表單提交。

#### forward的問題：

Controller方法明明有跑到return "xxx"，且viewResolver正確設置，卻無法呈顯xxx.jsp，瀏覽器頁面看起來是停留在同一頁，且完全無錯誤訊息，連eclipse console都無錯誤訊息？

這是因為，用fetch/XHR送出請求。如果用JQuery ajax，也是一樣。

#### 為何跳出Spring Security預設登入頁面：

UserDetailsService的loadUserByUsername方法丟了例外。  
帳戶過期、被鎖住(isAccountNonExpired、isAccountNonLocked都是true)。  
都會導致重導至Spring Security預設登入頁面。

## 開啟CSRF功能：

TestSpringSecurity5xConfig.java：

要讓使用者登入後，Spring Security給這位使用者csrf token。

.csrf(csrf -\> csrf

.csrfTokenRepository(**new** HttpSessionCsrfTokenRepository()))

### HttpSessionCsrfTokenRepository，是將SESSION跟CSRF TOKEN綁定，為何這樣可以阻止CSRF攻擊？

伺服器針對所有請求中，額外加入一個隨機字串（CSRF Token），並傳回給瀏覽器端，瀏覽器才能給請求添加這個CSRF Token。這樣的話，即使有心人士企圖偽造請求，也會因為不知道伺服器給了什麼CSRF Token而無法偽造，也就阻止了CSRF攻擊。

### 不過，有心人士難道不能於惡意程式內，添加 document.querySelector('meta[name="_csrf"]').content; 來獲取CSRF Token？

不能，因為有心人士偽造的網頁，網域是別的，別網域的網站無法直接取得CSRF Token。

### 只能用HttpSessionCsrfTokenRepository來綁定CSRF Token？

伺服器的Session跟瀏覽器的cookie內的jsessionid，都是用戶在伺服器端的唯一識別碼，所以都可以用來綁定CSRF Token。

## 登入成功頁面：

![](media/612058cb2c24d30c301dd93965cc70c4.png)

# 登出功能：

透過Spring Boot+Spring Security，來設置登出+CSRF功能。

## 設置session到期時間：

於application.properties內設置：

server.servlet.session.timeout=2m

## 登出功能：

### 後端部分：

TestSpringSecurity5xConfig.java：

.logout(logout -\> logout

.logoutRequestMatcher(**new** OrRequestMatcher(

**new** AntPathRequestMatcher("/session/logout", "POST"),

**new** AntPathRequestMatcher("/entry/logout", "GET")

))

.logoutSuccessUrl("/index.jsp")

.invalidateHttpSession(**true**)

.deleteCookies("JSESSIONID"))

logoutSuccessUrl方法內的url參數，會跟重導通知，被伺服器包裝進response，這樣就會重導至該頁面。

這樣即可，不需另外寫Controller方法。

### 前端部分：

#### 以超連結來傳送登出資訊：

loginSuccessForUser.jsp：

\<a href=*"*\<%=request.getContextPath() %\>*/entry/logout"*\>登出\</a\>

#### 以表單來傳送登出資訊：

remindSessionTimeoutModal.jsp：

\<form id=*"logoutForm"* action=*"*\<%= request.getContextPath() %\>*/session/logout"* method=*"POST"*\>

\<input type=*"hidden"* name=*"_csrf"* value=*"*\${_csrf.token}*"*/\>

\</form\>

**const** form = document.querySelector("\#logoutForm");

form.submit();

#### 以表單+fetch API來傳送登出資訊：

**const** form = document.querySelector("\#logoutForm");

**const** formData = **new** FormData(form);

fetch(form.action, {

method: form.method,

body: formData,

credentials: "same-origin" // 夾帶 JSESSIONID cookie

}).then(res =\> { **if** (res.redirected) { window.location.href = res.url; }});

fetch方法執行後，等待，直到後端回傳一個物件，比方說response物件，這時Promise物件的狀態，會變成fulfilled。

res就是JavaScript的response物件。

#### 以fetch API來傳送登出資訊：

**const** token = document.querySelector('meta[name="_csrf"]').content;

**const** header = document.querySelector('meta[name="_csrf_header"]').content;

fetch('\<%= request.getContextPath() %\>/session/logout', {

method: 'POST',

credentials: 'same-origin',

headers: { [header]: token }

}).then(res =\> { **if** (res.redirected) { window.location.href = res.url; }});

# 按下特定按鈕後，延長session存活時間以繼續維持登入：

設置BootStrap modal，再設置按下按鈕後，發送一個請求到後端即可：

![](media/ed64f53662af7e61840553240281c783.png)

## 後端部分：

SessionController.java：

@GetMapping("/keepAlive")

@ResponseBody//將已被Spring Boot轉成json格式字串的物件，寫入response body

**public** Map\<String,Object\> keepAlive() {

**return** Map.*of*("ifContinue", **true**);

}

## 前端部分：

remindSessionTimeoutModal.jsp：

document.getElementById("continue").addEventListener("click",**function**(){

fetch("\<%= request.getContextPath() %\>/session/keepAlive")

.then((res)=\>res.json())

.then((map)=\>{

**if**(map.ifContinue){

remindSessionTimeout();

remindSessionTimeoutModal.hide();

}

});

});

then()，一樣是產生回傳物件後，該物件被包裹在promise物件裡，且promise物件狀態改為fulfilled。

res就是JavaScript的response物件。

在Spring Boot，後端回傳的物件，被額外處理成JSON格式的內容；若還添加了@ResponseBody，則該JSON格式的內容還會被寫入response body。要解析成對應的JavaScript物件，就要用res.json()。

當res.json()處理完成，then函數就將其包裹在promise物件裡，這時promise物件狀態改為fulfilled；接著便return promise物件，給下一個then函數。

then((res)=\>res.json())，等價於then((res)=\>{return res.json();})。

# 重設密碼功能：

要透過忘記密碼頁面，輸入email，於表單按下確認後，彈出確認視窗，按下確認後，寄發修改密碼連結信給該email，透過該連結進入修改密碼頁面，進而修改密碼。

## 前端：

reqAndLogin5.jsp

### 彈出重設密碼確認視窗：

**function** submitEmailForm(){

**if**(checkEmailForm()==**true**){

**var** sendMailConfirmModal = document.getElementById("sendMailConfirm");

sendMailConfirmModal = **new** bootstrap.Modal(sendMailConfirmModal);

sendMailConfirmModal.show();

//該區塊要監聽該modal是否被click，有的話就關閉該modal、寄發密碼重設連結信給表單內填寫的email，寄發成功後彈出另一modal，表示已成功寄出，監聽該modal是否被click，有的話就返回首頁

}

}

checkValidity，是瀏覽器的原生API；直接檢查所有input欄位值是否合法。

### 寄發修改密碼連結信給該email：

那麼，在函數內監聽事件，會因為函數結束而跟著無法繼續監聽？  
在函數內監聽事件，不會隨著函數執行結束而結束。這其實就是閉包。

#### 閉包：

閉包是一個block+外部環境參照，即使外部環境被移除仍能持續存在，內部參照會隨著外部修改而改變。

最常見的閉包就是函數內的函數，比方說addEventListener、setTimeout內的函數參數。

#### 事件冒泡：

內層、外層DOM元素若監聽相同事件，然後內層元素觸發該事件，如果外層也跟著觸發事件，就是事件冒泡；為了避免這樣，就需要在內層函數添加e.stopPropagation();

如果外層DOM元素沒有監聽相同事件，就可不加e.stopPropagation();

document.querySelector('\#sendMailConfirm button.btn-primary').addEventListener("click",**function**(){

//\$('\#sendMailConfirm').modal('hide');

sendMailConfirmModal.hide();

**var** forgetPasswordForm = document.getElementById("forgetPassword");

forgetPasswordFormData = **new** FormData(forgetPasswordForm);

fetch("\<%=request.getContextPath() %\>/entry/sendUpdatePasswordMail",

{method:"post",body: forgetPasswordFormData})

.then(res=\>res.text())

.then((text)=\>{

**if**(text=="密碼重設信傳送成功"){

**var** sendMailFinish = document.getElementById("sendMailFinish");

sendMailFinishModal = **new** bootstrap.Modal(sendMailFinish);

//\$('\#sendMailFinish').modal('show');

sendMailFinishModal.show();

document.querySelector('\#sendMailFinish button.btn-primary').addEventListener("click",**function**(){

//sendMailFinishModal.hide();

setTimeout(()=\>location.href="https://localhost:8443/RestBookingProject/index.jsp",300);

});

}

});

});

Spring Boot內的jQuery ajax回呼函數，若是後端回傳字串，則回呼函數的參數，值即為該字串。

new bootstrap.Modal，參數可以是DOM元素跟CSS選擇器？只能是前者。

上面的表單以FormData物件格式傳輸，那可以用\$('\#updatePasswordForm').serialize()？

\$('\#updatePasswordForm').serialize()，這樣是將這個jQuery物件內的值序列化，成為可加在url後方的querystring或被寫入httpRequest。

\$('\#updatePasswordForm').serialize()和FormData物件差異，就是兩者都能被寫入HttpRequest，但後者還能另外寫入多媒體訊息。

以上的語法，可以寫成onclick="showConfirmModal();"？  
這種語法，無法設定nonce，故會有XSS的可能。

### 防止XSS的方式：

透過filter，已在HttpResponse header的script-src裡，放了'nonce-xxxx'；這是必須的，因為這樣瀏覽器才能拿response裡面的nonce來跟script tag內的nonce來比對是否一致。

這樣的話，於response.setHeader設置unsafe-inline，unsafe-inline會無效；最好'unsafe-inline'跟'unsafe-eval'要移除。

### Bootstrap modal淡入淡出效果不見的問題：

bootstrap modal有設置fade class，但sendMailFinishModal.show();  
sendMailFinishModal.hide();  
卻沒有淡入淡出效果？  
因為程式某處將fade class移除了。

## 後端：

### application.properties：

於application.properties設定Spring Mail：

spring.mail.host=email-smtp.ap-southeast-1.amazonaws.com

spring.mail.port=587

spring.mail.username=\${mail.username}

spring.mail.password=\${mail.password}

spring.mail.properties.mail.smtp.auth=true

spring.mail.properties.mail.smtp.starttls.enable=true

這裡的寄信伺服器是AWS SES，所以username = 連到AWS SES且有SMTP憑證的帳號。

上面的帳密不能被提交至遠端，故必須寫在另一個不會被提交的檔案內：  
檔案要置於src/main/resources。檔案名叫secrets/mail.properties

然後在application.properties，引用該檔案：  
spring.config.import=optional:classpath:secrets/mail.properties

### 設置mail.properties不會被提交：

#### .gitignore檔：

於.gitignore檔，添加/RestBookingProject/src/main/resources/secrets/

最前面多一個斜槓，是因為要表示從repository開始的路徑；結尾有/，表示secrets資料夾本身直接被排除在git管理。

#### git status：

存檔後，下git status檢查是否成功，若出現  
Untracked files: (use "git add \<file\>..." to include in what will be committed) RestBookingProject/src/main/resources/secrets/

表示剛剛在.gitignore檔，寫的路徑有誤。

### Controller：

@RequestMapping("/sendUpdatePasswordMail")

@ResponseBody

**public** String sendUpdatePasswordMail(HttpServletRequest req) {

String email = req.getParameter("email");

emailService.sendMail(email);

**return** "密碼重設信傳送成功";

}

### Service：

@Service

**public** **class** EmailService {

@Autowired

**private** JavaMailSender javaMailSender;

**public** **boolean** sendMail(String email) {

SimpleMailMessage message = **new** SimpleMailMessage();

message.setFrom("test@rcyang.bid");

message.setTo(email);

message.setSubject("找回密碼");

message.setText("https://localhost:8443/RestBookingProject/entry/goToResetPassword");

**try** {

javaMailSender.send(message);

**return** **true**;

} **catch** (Exception e) {

System.**out**.println(e);

**return** **false**;

}

}

}

寄信結果：  
![](media/65286eeafbcabdbc454af1b5b778a234.PNG)

## 回到前端：

passwordReset.jsp

**function** resetPasswordWithAjax(){

\$.post({

url:'/RestBookingProject/entry/updatePassword',

data:\$('\#updatePasswordForm').serialize(),

success:(data)**=\>**{

if(data=='update password success'){

\$('\#updatePasswordSuccess').modal('show');

}

},

error:()**=\>**{

}

});

}

# 查詢餐廳功能：

## 設置查詢餐廳頁面：

queryRest4.jsp

使用bootstrap手風琴ui+bootstrapVue套件來呈顯城市與行政區的checbox，且切換城市的checkbox時可以動態改變成對應的行政區checkbox，且原本選擇的行政區checkbox不會不見。

城市的checbox區，要有呈顯的option本身、被選中的value兩種值，這兩種值來自Vue的data參數；計畫要從後端取出城市的id、名稱，取出的內容直接寫入這個參數，這樣checbox區就能自動呈顯checbox跟城市名稱。

行政區的checbox區，一樣要有呈顯的option本身、被選中的value兩種值，這兩種值也來自Vue的data參數。

另外還要能透過bootstrapVue標籤，呈顯已被選中的資料，資料一樣來自Vue的data參數。

這樣Vue的data參數，內部總共需要五個參數；又因為這些參數，不管是城市還是行政區還是呈顯的標籤都是多個，故參數必須設為陣列：

data(){

**return**{

cityId:'',

cityOptions:[],

districtId:[],

districtOptions:[],

allDistricts:[]

}

}

cityId、districtId分別是要被綁定到城市、行政區checkbox的value；cityOptions、districtOptions分別是要被綁定到城市、行政區checkbox的option本身。

其實這樣就是return javascript物件。

### 頁面載入：

城市、行政區需要有預設呈顯的資料，故頁面載入時就必須執行fetch()，從後端取出相關資料，寫入Vue參數，讓Vue可以即時渲染這些資料：

mounted(){

fetch("\<%=request.getContextPath()%\>/form/queryAllCity")

.then(res=\>res.json()).then(data=\>**this**.cityOptions=data);

fetch("\<%=request.getContextPath()%\>/form/queryDistrictForRest?country=臺北市")

.then(res=\>res.json()).then(data=\>**this**.districtOptions=data);

}

bootstrapVue套件的option是接收js array，而後端List傳回前端，經過json()後，就是JS Array。

頁面載入時，另外還需要先將全部的行政區資料都準備好，這樣用戶按下行政區時，就可及時檢查哪個行政區被選中，需要用標籤來呈顯：

fetch("\<%=request.getContextPath()%\>/form/queryAllDistricts")

.then(res=\>res.json()).then(data=\>**this**.allDistricts=data)

### 用戶每選中一個checkbox的相應動作：

用戶每選中一個checkbox，就要同步運算有哪些標籤要呈顯：

computed:{

selectedOptions(){

**var** arr; arr=**this**.allDistricts.filter(district=\>**this**.districtId.includes(district.districtId));

**return** arr;

}

}

上面的**this**.districtId，是Vue參數且被綁定到checkbox的value，故可直接拿**this**.districtId跟**this**.allDistricts的id來比。

### 用戶每切換一個城市的相應動作：

用戶每切換一個城市，就要同步執行方法來切換城市的行政區：

methods:{

loadDistricts(){

fetch("\<%=request.getContextPath()%\>/form/queryDistrict?cityId="+this.cityId)

.then(res=\>res.json()).then(data=\>**this**.districtOptions=data)

}

}

checkbox那邊需要用change事件來呼叫方法：

@change=*"loadDistricts"*

### 用bootstrapVue套件做的checkbox群組：

\<b-form-group\>

\<b-form-checkbox-group v-model=*"cityId"*

:options=*"cityOptions"*

value-field=*"id"*

text-field=*"countryName"*

@change=*"loadDistricts"*\>

\</b-form-checkbox-group\>

\<hr\>

\<b-form-checkbox-group v-model=*"districtId"*

:options=*"districtOptions"*

value-field=*"districtId"*

text-field=*"districtName"*

name=*"districtId"*\>

\</b-form-checkbox-group\>

\</b-form-group\>

v-model表示checbox值要跟哪個Vue參數綁定(v-model用於將外部值綁定到data屬性值)。  
:options表示checbox option群組要跟哪個Vue參數綁定。  
value-field、text-field是用於對應後端資料的屬性名稱。  
name是用於checkbox值對應的name名稱。

另外，為了使頁面ui整齊，故還需添加style="column-count:*3*;

### 使用表單傳送資料：

\<b-form

action=*"*\<%=request.getContextPath()%\>*/rest/queryRests"*

method=*"post"*\>

\<b-button type=*"submit"* class=*"btn btn-success my-2"*\>查詢\</b-button\>

\</b-form\>

另外為使表單ui整齊，故添加  
class=*"d-flex flex-column justify-content-center align-items-center vh-100"*

### 查詢餐廳頁面：

![](media/0091c343b90bc3bcf63bebfc0ef5f9ab.PNG)

## 後端：

### DAO：

@Query(value="SELECT d.\* FROM district d join country c"

\+ " on d.country_name=c.country_name WHERE c.id = :cityId"

,nativeQuery=**true**)

List\<District\> findDistrictsByCity(@Param("cityId")Integer cityId);

**public** String getDistrictNameById(String districtId) {

String sql="select district_name from web.district where district_id=?";

String queryCondition = districtId;

RowMapper\<String\> mapper = **new** RowMapper\<\>() {

**public** String mapRow(ResultSet rs, **int** rowNum) **throws** SQLException {

**return** rs.getString("district_name");

}

};

**return** jdbcTemplate.queryForObject(sql, mapper,queryCondition);

}

### Controller：

@RequestMapping(value="/queryRests")

**public** String queryRests(Model model,@RequestParam String[] districtId) {

List\<Restaurant\> allQueryRest = **new** ArrayList\<\>();

List\<String\> districtNames=**new** ArrayList\<\>();

**for**(String id:districtId) {

String districtName = restDao.getDistrictNameById(id);

districtNames.add(districtName);

List\<Restaurant\> rests = restDao.getRestsByDistrictJoinImage(districtName);

**for**(Restaurant rest:rests) {

allQueryRest.add(rest);

}

}

model.addAttribute("checkedDistrictList", districtNames);

model.addAttribute("rests", allQueryRest);

**return** "queryRestResult2";

}

@RequestParam(value = "districtId") String[] districtId  
可以簡寫為  
@RequestParam String[] districtId

### 查詢結果：

![](media/268fbe84ec97ef70d5d4b23aa1588f5b.png)

## 錯誤排查：

### 查詢頁面的手風琴ui，一開始無法完全置中，於上層元素使用d-flex也一樣：

添加*vh-100*。

### 在執行查詢行政區的Spring Data JPA部分時，出現找不到id的錯誤：

因為SQL必須完全將VO的所有屬性值都查出，否則會無法塞值給VO來回傳。

### 瀏覽器開發者模式下的程式一直沒有更新：

關掉開發者模式重開、重新執行程式即可。
