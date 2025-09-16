<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
	<script src="<%=request.getContextPath() %>/js/showLoginSuccessModal.js" nonce="${nonce}"></script>
	<sec:csrfMetaTags/>
	<%@ include file="/WEB-INF/views/remindSessionTimeoutModal.jspf" %>
    <style>
        *{
            margin:0;
            padding:0;
            box-sizing: border-box;
        }
    	header{
	        height:30vh;
	        width:100%;
	
	        display:flex;
	        justify-content: center;
	        align-items: center;
	        flex-direction:column;
	    }		
        .headerImgDiv{
            width:100%;
            height:20vh;

            display:flex;
            justify-content:space-around;
            align-items: center;
        }
        .headerImgDiv .headerimg{
        	/*圖片需剛好占有全部高的20%，而現在該圖片長寬為562px；那就讓圖片外部空間總共為20vh-562px，這樣的話上下外部空間就同為calc(10vh - 281px)*/
           	margin-bottom:calc(10vh - 281px);
           	margin-top:calc(10vh - 281px);
        }
        .headerImgDiv .headerUserImg{
        	transform: scale(0.3, 0.3);
        }
        .headerNavDiv{
            /* 設定該元素的高度，根據子元素的高度來自適應 */           
            height: 10vh;
            width:100%;

            background-color: aquamarine;
        }
        .headerNav{
            /*強制讓該元素置中*/
            width:70%;
            margin: 0 15%;
            height: 100%;
             
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
           height: 100%;
           /*強制讓純文字在該元素內，完全置中*/
           display: flex;
           justify-content:center;
           align-items: center;

           transition:0.25s;
        }
        .headerNav a:hover{
            /*a:hover繼承a既有的樣式，故不需重新寫樣式  */
           background-color: darkgreen;          
        }
        /* 看起來似乎可以正常運作，但前兩個anchor運作不正常，沒有在hover事件發生時改變背景色 */
        /* 看起來是z軸方向的上層元素，覆蓋住了anchor，所以添加以下code，提升anchor在z軸的高度: */
        .headerNav{
            position: relative;
        }
        .headerNav a{
            z-index: 99;
        }
        /* code添加完成；header css設定完成 */
        /* 以下設定main css */
        main{
            width:100%;
        }
        #mainDiv{
            width:100%;
            height:60vh;
        }
        #mainDiv .img,.carousel-inner,.carousel-item{
            width:100%;
            height:100%;
        }
        #mainDiv .img{
        	object-fit:cover;
        }
        /* 以下設定footer css */
        footer{
            background-color: aquamarine;
            /* 要讓子元素垂直水平方向都置中 */
            display: flex;
            justify-content: center;
            align-items: center;
            
            width:100%;
            height:10vh;
        }
        #fooText{
 
        }
    </style>
    <script nonce="${nonce}">
    $(document).ready(function(){
    	$('#logInSuccessModal').modal('hide');
      //20240625修改;直接從localStorage讀取來自上一個jsp頁面的值
    	if(localStorage.getItem("loginSuccess")=='true'){
    		showLoginSuccessModal(localStorage.getItem("loginSuccessMessage"));
        localStorage.removeItem("loginSuccess");
        localStorage.removeItem("loginSuccessMessage");
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
	        <p></p>
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
                <a href="booking.html">訂位</a>
                <a href="<%=request.getContextPath() %>/booking/queryBooking">查詢訂位</a>
                <a href="<%=request.getContextPath() %>/booking/goToUpdateBookingRecord">修改/取消訂位</a>
                <a href="<%=request.getContextPath() %>/form/queryRestStyle">查詢餐廳</a>
                <a href="#">推薦餐廳</a>
                <a href="#">關於我們</a>
            </nav>
        </div>
    </header>
    <main>
        <div id="mainDiv" class="carousel slide" data-bs-ride="carousel">
				  <div class="carousel-indicators">
				    <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
				    <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="1" aria-label="Slide 2"></button>
				    <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="2" aria-label="Slide 3"></button>
				    <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="3" aria-label="Slide 4"></button>
				    <button type="button" data-bs-target="#mainDiv" data-bs-slide-to="4" aria-label="Slide 5"></button>
				  </div>
				  <div class="carousel-inner" >
				    <div class="carousel-item active">
				      <img src="<%=request.getContextPath() %>/image/restaurant1.jpg" class="d-block w-100 img" alt="...">
				    </div>
				    <div class="carousel-item">
				      <img src="<%=request.getContextPath() %>/image/restaurant2.jpg" class="d-block w-100 img" alt="...">
				    </div>
				    <div class="carousel-item">
				      <img src="<%=request.getContextPath() %>/image/restaurant3.jpg" class="d-block w-100 img" alt="...">
				    </div>
				    <div class="carousel-item">
				      <img src="<%=request.getContextPath() %>/image/restaurant4.jpg" class="d-block w-100 img" alt="...">
				    </div>
				    <div class="carousel-item">
				      <img src="<%=request.getContextPath() %>/image/restaurant5.jpg" class="d-block w-100 img" alt="...">
				    </div>
				  </div>
				  <button class="carousel-control-prev" type="button" data-bs-target="#mainDiv" data-bs-slide="prev">
				    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
				    <span class="visually-hidden">Previous</span>
				  </button>
				  <button class="carousel-control-next" type="button" data-bs-target="#mainDiv" data-bs-slide="next">
				    <span class="carousel-control-next-icon" aria-hidden="true"></span>
				    <span class="visually-hidden">Next</span>
				  </button>
				</div>
    </main>
    <footer>
        <div id="fooText">web © 2015 , Update @2023 Maintain by TSuiling ( tsuiling1020@gmail.com )</div>
    </footer>
</body>
</html>