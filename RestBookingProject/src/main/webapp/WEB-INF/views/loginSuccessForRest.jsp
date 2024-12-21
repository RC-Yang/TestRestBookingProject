<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
<script src="<%=request.getContextPath() %>/js/showLoginSuccessModal.js"></script>
<title>Insert title here</title>
    <style>
        *{
            margin:0;
            padding:0;
            box-sizing: border-box;
        }

        .headerImgDiv{
            width:100%;
            /*調整子物件版面step1*/
            display:flex!important;/*必須要加!important，不知為何*/
            /*調整子物件版面step2*/
            justify-content:space-around;
            align-items: center;
            
            /*去除圖片上下方多餘空白*/
            display:inline-block;
            margin-top:-202px;
            margin-bottom:-202px;
            
        }
        .headerImgDiv .headerimg{
            /* 變形圖片當中的縮放圖片 */
            transform:scale(1,0.7);
        }
        .headerImgDiv .headerUserImg{
        	transform: scale(0.3, 0.3);
        }
        .headerNavDiv{
            /* 該div雖有高度，但這其實是子元素的高度，該div高度目前不明，所以需要以下兩行的設定: */
            /* 設定該元素的高度，根據子元素的高度來自適應 */
            display: flex;
            height: fit-content; 

            background-color: cyan;
        }
        .headerNav{
            /*強制讓該元素置中*/
            width:70%;
            margin: 0 auto;
            /*強制讓子元素在該元素內，分散置中*/
            display: flex;
            justify-content:space-between;
            align-items: center;
        }
        .headerNav a{
           text-decoration: none;
           color: black;

           display: inline-block;
           width:15%;
           padding:20px 10px;

           text-align: center;
        }
        .headerNav a:hover{
            /*a:hover繼承a既有的樣式，故不需重新寫樣式  */
           background-color: darkcyan!important;
           transition:0.25s!important;
        }
        /* 看起來似乎可以正常運作，但前兩個anchor運作不正常，沒有在hover事件發生時改變背景色 */
        /* 看起來是z軸方向的上層元素，覆蓋住了anchor，所以添加以下code，提升anchor在z軸的高度: */
        .headerNav{
            position: relative;
        }
        .headerNav a{
            z-index: 99;
        }
        .headerNav a:hover{
            z-index: 99;
        }
        main{
            width:100%;
        }
        #mainDiv{
            width:100%;
            height:60vh;
        }
        footer{
            background-color: cyan;
            /* 要讓子元素垂直水平方向都置中 */
            display: flex;
            justify-content: center;
            align-items: center;
            
            width:100%;
            height:10vh;
        }
    </style>
    <script>
    $(document).ready(function(){
    	$('#logInSuccessModal').modal('hide');
    	if(${loginResult}==true){
    		showLoginSuccessModal('${loginSuccessMessage}');
    	}
    });
    </script>
</head>
<body>
	<!-- 登入成功後要彈出的視窗，按下確定後要重導到首頁 -->
	<div id="logInSuccessModal" class="modal fade" tabindex="-1">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title"></h5>
	      </div>
	      <div class="modal-body">
	        <p>登入成功</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">確認</button>
	      </div>
	    </div>
	  </div>
	</div>
    <!--導覽列-->
    <header>
        <div class="headerImgDiv">
            <img src="<%=request.getContextPath() %>/image/photo1.png" class="headerimg">
			<div>
				你好，${account}~~~
        		<img src="data:image/jpeg;base64,${userImage}" alt="Image" class="headerUserImg">
        		<a href="<%=request.getContextPath() %>/entry/logout">登出</a>
        	</div>
        </div>
        <div class="headerNavDiv">
            <nav class="headerNav">
                <a href="<%=request.getContextPath() %>/booking/queryBookingForRest">查詢訂位</a>
                <a href="#">修改/取消訂位</a>
                <a href="<%=request.getContextPath() %>/form/goToUpdateUserInfo">修改餐廳資訊</a>
                <a href="#">關於我們</a>
            </nav>
        </div>
    </header>
    <main>
        <div id="mainDiv" class="carousel slide" data-bs-ride="carousel">
			<img src="<%=request.getContextPath() %>/image/restaurant1.jpg" class="d-block w-100 img" alt="...">	  
		</div>
    </main>
    <footer>
        <div id="fooText">web © 2015 , Update @2023 Maintain by TSuiling ( tsuiling1020@gmail.com )</div>
    </footer>
</body>
</html>