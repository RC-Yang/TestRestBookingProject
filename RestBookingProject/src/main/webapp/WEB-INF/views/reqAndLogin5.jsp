<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sp" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登入或註冊</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>

	<script src="<%=request.getContextPath() %>/js/checkRegForm.js" nonce="${nonce}"></script>
	<script src="<%=request.getContextPath() %>/js/checkLogInForm.js" nonce="${nonce}"></script>
	<script src="<%=request.getContextPath() %>/js/checkEmailForm.js" nonce="${nonce}"></script>
</head>
<script nonce="${nonce}">
    $(document).ready(function(){    	
        //20240629新增
        window.token = $("meta[name='_csrf']").attr("content");
        window.header = $("meta[name='_csrf_header']").attr("content");
        
        const action = "${action}";
        // 先清空預設被激活的form與li的狀態
        $("#home-tab").removeClass('active');
        $("#home").removeClass('active');
        
        $(".valid-Account").css("display","none");
        $(".valid-Email").css("display","none");
		$(".valid-Password").css("display","none");
		$(".valid-CheckedPassword").css("display","none");
		$(".invalid-Account").css("display","none");
		$(".invalid-Email").css("display","none");
		$(".invalid-Password").css("display","none");
		$(".invalid-CheckedPassword").css("display","none");
		//確保所有modal都被隱藏
		$(".modal").modal('hide');
        //將提交鈕被按下後的預設行為擋下來
        $('.btn-primary').click(function(event){
        	  event.preventDefault();
        });

        switch(action){
            case "1":              
                $("#home-tab").addClass("active");
                // $("#home").addClass("show");
                $("#home").addClass("active");
                break;
            case "2":
                $("#profile-tab").addClass("active");
                // $("#profile").addClass("show");
                $("#profile").addClass("active");
                break;
            case "3":
                $("#contact-tab").addClass("active");
                // $("#contact").addClass("show");
                $("#contact").addClass("active");
                break;
        }

        $(".nav-link").click(function(){
            $(".nav-link").removeClass("active");
            $(this).addClass("active");
        });
    });
 
    function regSubmit(){
    	if(checkRegForm()){
    		//$('#reg').submit();//這是無回呼函數版本的submit方法
    		
   			//將表單所有使用者輸入資料(包含多媒體資料如圖片)，包裝成物件
   			var regForm = new FormData(document.getElementById('reg'));
   			
   			 $.ajax({
   				 url: "${pageContext.request.contextPath}/entry/reg", // 從表單的 action 屬性獲取提交 URL
   	             type: "post", // 從表單的 method 屬性獲取提交方式 (POST)
   	             //data: $(this).serialize()
                 //將表单中的input欄位name-value對，轉成字串；然後這個字串再被串在url後方，形成queryString
   	             //而Java 的序列化，是將物件轉成可儲存於資料庫或傳送到其他地方的字串

   	             data: regForm,
   	             processData: false,//防止jQuery對表單資料進行預處理
   	             contentType: false,//防止jQuery自動判斷表單型別，表單型別交給瀏覽器判斷
   	             success: function(response) {
   	            	 $('#regSuccess.modal').addClass('fade');
   	            	 $('#regSuccess.modal').modal('show');
   	            	 
   	             },
   	             error: function(xhr, status, error) {
   	                 
   	             }
   			 });
    	}
    }
    
    function goToHomePage(){
    	 window.location.href = '<%=request.getContextPath()%>/entry/login';
    	 $('.modal').modal('hide');
    }
    
    function submitEmailForm(){
    	if(checkEmailForm()==true){

    		var sendMailConfirmModal = document.getElementById("sendMailConfirm");
    		sendMailConfirmModal = new bootstrap.Modal(sendMailConfirmModal);
    		
    		sendMailConfirmModal.show();

            document.querySelector('#sendMailConfirm button.btn-primary').addEventListener("click",function(){
                
                //$('#sendMailConfirm').modal('hide');
                sendMailConfirmModal.hide();
                
                var forgetPasswordForm = document.getElementById("forgetPassword");
                forgetPasswordFormData = new FormData(forgetPasswordForm);
                
                fetch("<%=request.getContextPath() %>/entry/sendUpdatePasswordMail",
                		{method:"post",body: forgetPasswordFormData})
                		.then(res=>res.text())
                		.then((text)=>{
							if(text=="密碼重設信傳送成功"){
								var sendMailFinish = document.getElementById("sendMailFinish");
								sendMailFinishModal = new bootstrap.Modal(sendMailFinish);
								
								//$('#sendMailFinish').modal('show');
								sendMailFinishModal.show();
								
								document.querySelector('#sendMailFinish button.btn-primary').addEventListener("click",function(){
									//sendMailFinishModal.hide();
									setTimeout(()=>location.href="https://localhost:8443/RestBookingProject/index.jsp",300);
								});
							}
                		});
            }); 		
    	}
    }
</script>
<script nonce="${nonce}">
    document.addEventListener('DOMContentLoaded', function () {
		const userRadio = document.getElementById('userType1');
		const restRadio = document.getElementById('userType2');

		userRadio.addEventListener('click', function () {
			// 隱藏額外的表單元素
			$(".restData").css("display", "none");
		});
		restRadio.addEventListener('click', function () {
			// 顯示額外的表單元素
			$(".restData").css("display", "block");
		});
		//20240807新增動態檢查註冊email格式
		var emailRegex=/^[a-zA-Z0-9][\w\.-]*@[\dA-Za-z][\dA-Za-z_\-]*[\dA-Za-z]\.[\dA-Za-z]{2,}/;
    	$("#email").keyup(function(){
    		var regexResult = emailRegex.test($("#reg #email").val());
			if(regexResult){
				$(".invalid-Email").css("display","block");
				$(".invalid-Email").text("email格式正確！");
				$(".invalid-Email").css("color","green");
				return;
			}
    	$(".invalid-Email").css("display","block");
    	$(".invalid-Email").text("email格式錯誤！");
		$(".invalid-Email").css("color","red");
		$(".invalid-Email").css("border-color","red");
    	});
    	//20240826修改：CSP不允許直接透過onclick呼叫函數，故改為以下寫法
    	document.getElementById("submitLogin").addEventListener('click', function () {
    		document.getElementById("login").submit();
		});
    	document.getElementById("cancelSubmitLogin").addEventListener('click', function () {
    		history.back();
		});
    });
 </script>
 <style>
	 .restData{
		 display:none;
	 }
    *{
        margin: 0;
        padding: 0;
        box-sizing:border-box;
    }
    #logo{
    	height:25vh;
        width:100%;
        /*現圖片高為25vh，要將該圖片高縮為100px的話，需要將外部空間自上、下方來往下、上拉。將外部空間自上、下方來往下、上拉後，此時上+下方+圖片高仍為25vh，
        又圖片高為100px，且上下方需相等，故上方要向下拉12.5vh-50、下方要向上拉12.5vh-50
        又因為外部空間是自上、下方往下、上拉，故外部空間margin須為負值，故12.5vh-50px變成50px - 12.5vh*/
        margin-top:calc(50px - 12.5vh);
        margin-bottom:calc(50px - 12.5vh);
    }
    .headerimg{
    	/* 讓圖片填滿上一層div */
        display:block; 
        height:100%;
        /*避免圖片變形*/
        object-fit:cover;
        
		padding-left:calc(50vw - 87.9px);
		padding-right:calc(50vw - 87.9px);
		/*margin-top:calc(50px - 12.5vh);
        margin-bottom:calc(50px - 12.5vh);*/
        /*為何不是寫在這？因為該圖下方無元素，無法透過從該圖下方拉取空間，也就無法使用margin-bottom*/
    }
    body .container,body .row{
        display:block;/*強制所有div皆為block*/
        height: 100%;
    }
    #title{
        /* width:100%; *//*block預設width即為100%*/
        display:flex;
        justify-content:center;
        align-items:center;
        font-size: 36px;
    }
    .nav{
        display: flex;
        justify-content: center;
        align-items: center;
        padding:0 20px;
    }
    /*表單區*/
    form{
        /*display:block;*//*form預設即為block*/
    }
    
    .nav-tabs .nav-link.active{/*自定義的css樣式，通常優先於bootstrap預設的樣式，但更具體的選擇器可以確保提高優先權*/
        background-color: #799bc2;
        border-bottom-color: #799bc2;
    }
    .tab-pane.active{
    	padding:10px 40px;
        background-image: linear-gradient(180deg,#799bc2,#fff);
    }

    
</style>
<body>
    <!-- 確認要寄出修改密碼信件的modal -->
	<div id="sendMailConfirm" class="modal fade" tabindex="-1">
		<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
			<h5 class="modal-title">確認要寄出修改密碼信件？</h5>
			</div>
			<div class="modal-body">
			<p>確認要寄出修改密碼信件？</p>
			</div>
			<div class="modal-footer">
			<button type="button" class="btn btn-primary">確認</button>
			</div>
		</div>
		</div>
	</div>
    <!-- 寄出修改密碼信件的modal -->
	<div id="sendMailFinish" class="modal fade" tabindex="-1">
		<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
			<h5 class="modal-title">已寄出修改密碼信件。</h5>
			</div>
			<div class="modal-body">
			<p>已寄出修改密碼信件。</p>
			</div>
			<div class="modal-footer">
			<button type="button" class="btn btn-primary" data-bs-dismiss="modal">確認</button>
			</div>
		</div>
		</div>
	</div>
	<!-- 註冊成功後要彈出的視窗，按下確定後要重導到首頁 -->
	<div id="regSuccess" class="modal fade" tabindex="-1">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">註冊成功、即將登入</h5>
	      </div>
	      <div class="modal-body">
	        <p>註冊成功、即將登入。</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" onclick="goToHomePage();">確認</button>
	      </div>
	    </div>
	  </div>
	</div>
	<!-- 登入失敗後要彈出的視窗 -->
	<div id="logInFailModal" class="modal fade" tabindex="-1">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">登入失敗</h5>
	      </div>
	      <div class="modal-body">
	        <p>登入失敗</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">確認</button>
	      </div>
	    </div>
	  </div>
	</div>

    <div id="logo"><img src="https://imgur.com/YtOejpS.png" class="headerimg"></div>
    <div id="title">登入或註冊</div>
    <div class="container">
        <div class="row">
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                  <button class="nav-link active" id="home-tab" data-bs-toggle="tab" data-bs-target="#home" type="button" role="tab" aria-controls="home" aria-selected="true">註冊</button>
                </li>
                <li class="nav-item" role="presentation">
                  <button class="nav-link" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab" aria-controls="profile" aria-selected="false">登入</button>
                </li>
                <li class="nav-item" role="presentation">
                  <button class="nav-link" id="contact-tab" data-bs-toggle="tab" data-bs-target="#contact" type="button" role="tab" aria-controls="contact" aria-selected="false">忘記密碼？</button>
                </li>
            </ul>
            <div class="tab-content" id="myTabContent">
                <div class="tab-pane show active" id="home" role="tabpanel" aria-labelledby="home-tab">
                    <div class="container">
                        <div class="row">
                            <form id="reg" method="post" action="${pageContext.request.contextPath}/entry/reg" enctype="multipart/form-data">
                            	<!--20240629新增-->
                                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                <div class="d-flex flex-row justify-content-evenly align-items-center">
                                    <div class="form-check">
                                        <input type="radio" class="form-check-input" name="userType" id="userType1" value="1"/>
                                        <label class="form-check-label userType" for="userType1">
                                          一般客戶端
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input type="radio" class="form-check-input" name="userType" id="userType2" value="2" checked="checked"/>
                                        <label class="form-check-label userType" for="userType2">
                                          餐廳端
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                <label for="account" class="form-label">請輸入帳號：</label>
                                <input type="text" class="form-control" id="account" name="account"/>
                                    <div class="valid-Account">
                                        Looks good!
                                    </div>
                                    <div class="invalid-Account">
                                        Please enter a account.
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                <label for="email" class="form-label">請輸入Email：</label>
                                <input type="text" class="form-control" id="email" name="email" aria-describedby="emailHelp"/>
                                <div id="emailHelp" class="form-text">We'll never share your email with anyone else.</div>
                                    <div class="valid-Email">
                                        Looks good!
                                    </div>
                                    <div class="invalid-Email">
                                        Please enter a email.
                                    </div>
                                </div>
                                <div class="mb-3">
                                <label for="password" class="form-label">請輸入密碼：</label>
                                <input type="password" class="form-control" id="password" name="password"/>
                                <div class="valid-Password">
                                    Looks good!
                                </div>
                                <div class="invalid-Password">
                                    Please enter a password.
                                </div>
                                </div>
                                <div class="mb-5">
                                    <label for="checkedPassword" class="form-label">請再次輸入密碼：</label>
                                    <input type="password" class="form-control" id="checkedPassword" name="checkedPassword" />
                                    <div class="valid-CheckedPassword">
                                        Looks good!
                                    </div>
                                    <div class="invalid-CheckedPassword">
                                        Please enter a password.
                                    </div>
                                </div>
                                <div class="mb-3">
								    <label for="formFile" class="form-label">個人/餐廳圖像：</label>
								    <input class="form-control" type="file" id="picture" name="picture"/>
								</div>
                                <!--20240124新增-->
								<div class="mb-3 restData">
									<label for="restName" class="form-label">餐廳名稱：</label>
									<input type="text" class="form-control" id="restName" name="restName"/>
                                
                                </div>
                                <div class="mb-3 restData">
                                    <label for="restAddr" class="form-label">餐廳地址：</label>
									<div class="d-flex" style="padding-bottom:10px;">
										<div class="dropdown">
										  <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
											請選擇縣市：
										  </button>
										  <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
											<li><a class="dropdown-item countryAnchor" href="#">臺北市</a></li>
											<li><a class="dropdown-item countryAnchor" href="#">新北市</a></li>
											<li><a class="dropdown-item countryAnchor" href="#">基隆市</a></li>
											<li><a class="dropdown-item countryAnchor" href="#">桃園市</a></li>
											<li><a class="dropdown-item countryAnchor" href="#">新竹市</a></li>
											<li><a class="dropdown-item countryAnchor" href="#">新竹縣</a></li>
										  </ul>
										</div>
										&nbsp;
										<div class="dropdown">
										  <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton2" data-bs-toggle="dropdown" aria-expanded="false">
											請選擇行政區：
										  </button>
										  <ul id="districtMenu" class="dropdown-menu" aria-labelledby="dropdownMenuButton2">
											<li><a class="dropdown-item districtAnchor" href="#">大同區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">中山區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">中正區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">松山區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">大安區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">萬華區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">信義區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">士林區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">北投區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">內湖區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">南港區</a></li>
											<li><a class="dropdown-item districtAnchor" href="#">文山區</a></li>
										  </ul>
										</div>
									</div>
									<input type="hidden" id="selectedCountry" name="selectedCountry" value="">
									<input type="hidden" id="selectedDistrict" name="selectedDistrict" value="">
                                    <input type="text" class="form-control" id="restAddr" name="restAddr" />
                                </div>
                                <div class="mb-3 restData">
								    <label for="restTel" class="form-label">餐廳電話：</label>
								    <input class="form-control" type="text" id="restTel" name="restTel"/>
								</div>
								<div class="mb-3 restData">
								    <label for="restTelExt" class="form-label">餐廳電話分機：</label>
								    <input class="form-control" type="text" id="restTelExt" name="restTelExt"/>
								</div>
								<div class="mb-3 restData">
								    <label for="openingTime" class="form-label">開始營業時間：</label>
								    <input class="form-control" type="time" id="openingTime" name="openingTime"/>
								</div>
								<div class="mb-3 restData">
								    <label for="closingTime" class="form-label">結束營業時間：</label>
								    <input class="form-control" type="time" id="closingTime" name="closingTime"/>
								</div>

                                <div class="text-center">
                                    <button type="button" class="btn btn-primary" onclick="regSubmit();">提交</button>
                                    <button type="button" class="btn btn-danger" onclick="javascript:history.back();">取消</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane show" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                    <div class="container">
                        <div class="row">
                            <form id="login" method="post" action="<%=request.getContextPath() %>/entry/checkLogin">
                                <!--20240629新增-->
                                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                            	<div class="d-flex flex-row justify-content-evenly align-items-center">
                                    <div class="form-check">
                                        <input type="radio" class="form-check-input" name="userType" id="userType"value="1"/>
                                        <label class="form-check-label userType" for="userType">
                                          一般客戶端
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input type="radio" class="form-check-input" name="userType" id="userType" value="2" checked="checked"/>
                                        <label class="form-check-label userType" for="userType">
                                          餐廳端
                                        </label>
                                    </div>
                                </div>
                                <div class="mb-3">
                                <label for="account" class="form-label">請輸入帳號：</label>
                                <input type="email" class="form-control" id="account" name="account">
                                </div>
                                <div class="mb-5">
                                <label for="password" class="form-label">請輸入密碼：</label>
                                <input type="password" class="form-control" id="password" name="password">
                                </div>

                                <div class="text-center">
                                    <button type="button" id="submitLogin" class="btn btn-primary">提交</button>
                                    <button type="button" id="cancelSubmitLogin"class="btn btn-danger">取消</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane show" id="contact" role="tabpanel" aria-labelledby="contact-tab">
                    <div class="container">
                        <div class="row">
                            <form id="forgetPassword">
                                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                <div class="mb-5">
	                                <label for="inputEmail3" class="form-label">請輸入要傳送重設密碼信件的郵件位置：</label>
	                                <input type="email" class="form-control" id="email" name="email">
	                                <div class="invalid-feedback">郵件位置格式錯誤</div>
                                </div>
                                
                                <div class="text-center">
                                    <button type="button" class="btn btn-primary" onclick="submitEmailForm();">提交</button>
                                    <button type="button" class="btn btn-danger" onclick="javascript:history.back();">取消</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>            
        </div>
    </div>
</body>
<script nonce="${nonce}">
	//$(document).on("ready",function(){
		$(document).ready(function(){
			$(".countryAnchor").on("click",function(e){
				
				e.preventDefault();
				//設定第一層選單被選中的選項
				$(".countryAnchor").removeClass("selected");
				$(this).addClass("selected");
				//設定餐廳地址欄位的縣市
				var selectedCountry = $(this).text();
				$('#restAddr').empty();
				$('#restAddr').val(selectedCountry);

				// 清空第二層選單的選項
				$("#districtMenu").empty();
				
				var queryStringData = 'country=' + encodeURIComponent(selectedCountry);

				$.ajax({
					url: '<%=request.getContextPath()%>/form/queryDistrictForRest',
					method: 'GET',
					data: queryStringData,
					//dataType: 'json',//可加可不加
					success: function (districtJsonStr) {
						// 根據AJAX獲取的數據動態生成第二層選單的選項
						//後端回傳的是arraylist版本的json格式物件，這物件會自動被jQuery轉型為js的array物件，再將其assgin給回呼函數之參數
						//故回呼函數之參數，可直接當成js array物件
						for (var i = 0; i < districtJsonStr.length; i++) {
							$("#districtMenu").append('<li><a class="dropdown-item districtAnchor" href="#">' + districtJsonStr[i].districtName + '</a></li>');
						}
						//20240901對行政區anchor設置事件監聽，以便能呼叫動態改寫城市+行政區之字串
						for(var i=0;i<document.getElementsByClassName('districtAnchor').length;i++){
							document.getElementsByClassName('districtAnchor')[i].addEventListener('click',function(event){
								clickDistrict(this,event);
							});
						}
					},
					error: function (error) {
					  console.error('Error fetching district options:', error);
					}
				});
			});
			//設定餐廳地址欄位，自動被寫入縣市行政區(以下寫法受到empty方法干擾，會失效)
			$(".districtAnchor").on("click",function(e){
				
				e.preventDefault();
				
				var selectedDistrict = $(this).text();
				var selectedCountry = $(".selected");
				$('#restAddr').empty();
				$('#restAddr').text(selectedDistrict);
			});

		});

		//設定餐廳地址欄位，自動被寫入縣市行政區(改成傳統js寫法)
		function clickDistrict(element,event){
			event.preventDefault();
			//var selectedDistrict = this.textContent;
			var selectedDistrict = element.textContent;
			var selectedCountry = $(".selected").text();
			$('#restAddr').empty();
			//$('#restAddr').text(selectedCountry+selectedDistrict);
			$('#restAddr').val(selectedCountry+selectedDistrict);
		}

</script>
</html>