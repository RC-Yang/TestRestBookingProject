<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sp" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登入或註冊</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
    
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>

	<script src="<%=request.getContextPath() %>/js/checkRegForm.js"></script>
	<script src="<%=request.getContextPath() %>/js/checkLogInForm.js"></script>
	<script src="<%=request.getContextPath() %>/js/checkEmailForm.js"></script>
</head>
<script>

    $(document).ready(function(){
        //const urlParams = new URLSearchParams(window.location.search);
        //const action = urlParams.get('action');
        
        const action = "${action}";
        // 先清空預設被激活的form與li的狀態
        $("#home-tab").removeClass('active');
        $("#home").removeClass('active');

        $('*').removeClass('fade');
        
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
   				 url: $('#reg').attr('action'), // 從表單的 action 屬性獲取提交 URL
   	             type: $('#reg').attr('method'), // 從表單的 method 屬性獲取提交方式 (POST)
   	             //data: $(this).serialize()
   	             
   	             data: regForm,
   	             processData: false,
   	             contentType: false,
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
    		$('#forgetPassword').submit();
    	}
    }
</script>
<style>
    *{
        margin: 0;
        padding: 0;
    }
    #logo{
        position: absolute;/*會找到body去定位，效果類似float*/
        top:0;
        left: 0;
        /* 限制類float區塊的大小 */
        height:15%;
        width:15%;
        
    }
    .headerimg{
        display:block;
        /* 讓圖片填滿上一層div */
        width:100%;
        height:100%;
        /* 對logo的x y軸方向進行延伸變形 */
        transform: scale(2,1.5);
        transform-origin: 0 0;
        /* 讓logo上方留白不要太多 */
        margin-top:-20px;
    }
    body .container,body .row{
        display:block;/*強制所有div皆為block*/
        height: 100%;
    }
    #title{
        /* width:100%; *//*block預設width即為100%*/
        text-align: center;
        padding:10px 30vw;
        font-size: 36px;
        margin-top: 50px;
    }
    .nav{
        display: flex;
        justify-content: center;
        align-items: center;
        padding:0 20px;
    }
    /*表單區*/
    .tab-content ,.tab-content div{
        display:block;/*強制所有div皆為block*/
        height: 100%; 
        padding-left: 0;
        padding-right: 0;
    }

    form{
        display:block;/*強制所有form皆為block*/
        padding:10px 20vw!important;
    }
    
    .nav-link.active{
        background-color: #799bc2!important;
        border-bottom-color: #799bc2!important;
    }
    .tab-pane.active{
        background-image: linear-gradient(180deg,#799bc2,#fff)!important;
    }
</style>
<body>
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
    <div class="container">
        <div class="row">
            <div id="title">登入或註冊</div>
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
                <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab">
                    <div class="container">
                        <div class="row">
                            <sp:form modelAttribute="user" id="reg" method="post" action="${pageContext.request.contextPath}/entry/reg" enctype="multipart/form-data">
                            	
                            	
                                <div class="d-flex flex-row justify-content-evenly align-items-center my-3">
                                    <div class="form-check">
                                        <sp:radiobutton class="form-check-input" name="userType" id="userType" path="userType" value="1"/>
                                        <label class="form-check-label userType" for="userType">
                                          一般客戶端
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <sp:radiobutton class="form-check-input" name="userType" id="userType" path="userType" value="2" checked="checked"/>
                                        <label class="form-check-label userType" for="userType">
                                          餐廳端
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                <label for="account" class="form-label">請輸入帳號：</label>
                                <sp:input class="form-control" id="account" name="account" path="account"/>
                                    <div class="valid-Account">
                                        Looks good!
                                    </div>
                                    <div class="invalid-Account">
                                        Please enter a account.
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                <label for="email" class="form-label">請輸入Email：</label>
                                <sp:input type="email" class="form-control" id="email" name="email" aria-describedby="emailHelp" path="email"/>
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
                                <sp:input type="password" class="form-control" id="password" name="password" path="password"/>
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
								    <sp:input class="form-control" type="file" id="picture" name="picture" path="picture"/>
								</div>
                                
                                <div class="text-center">
                                    <button type="button" class="btn btn-primary" onclick="regSubmit();">提交</button>
                                    <button type="button" class="btn btn-danger" onclick="javascript:history.back();">取消</button>
                                </div>
                            </sp:form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                    <div class="container">
                        <div class="row">
                            <form id="login" method="post" action="<%=request.getContextPath() %>/entry/checkLogin">
                            	<div class="d-flex flex-row justify-content-evenly align-items-center my-3">
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
                                    <button type="submit" class="btn btn-primary" onclick="checkLogInFormWithAjax();">提交</button>
                                    <button type="button" class="btn btn-danger" onclick="javascript:history.back();">取消</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="contact" role="tabpanel" aria-labelledby="contact-tab">
                    <div class="container">
                        <div class="row">
                            <form id="forgetPassword" method="post" action="<%=request.getContextPath() %>/entry/sendUpdatePasswordMail">
                                <div class="mb-5">
	                                <label for="inputEmail3" class="form-label">請輸入要傳送重設密碼信件的郵件位置：</label>
	                                <input type="email" class="form-control" id="email" name="email">
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
</html>