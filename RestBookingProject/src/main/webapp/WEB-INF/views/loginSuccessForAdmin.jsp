<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
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
	<style>
	*{
		margin:0;
		padding:0;
		box-sizing:border-box;
	}
	header{
		display:flex;
		justify-content:space-around;
		align-items:center;
		
		width:100%;
		height:20vh;
	}
	headerimg{
		clip-path:inset(20% 0 20% 0);
		
		height:100%;
		object-fit: cover; /*該語法用來保持img不變形，搭配height:100%這個語法，
		就變成高度可以完全貼合父元素且寬度與高度比例不變*/
	}
	nav{
		width:100%;
		height:10vh;
		background-color: pink;
		
		display:flex;
		justify-content:space-around;
		align-items:center;
	}
	nav a{
		width:20%;
		height:100%;
		text-decoration: none;
		font-size: 18px;
    	font-family: Calibri, sans-serif;
    	color:black;
    	
    	display:flex;
		justify-content:center;
		align-items:center;
		
		background-color: pink;
	}
	nav a:hover{
		background-color:DarkRed;
		transition:0.25s;
		cursor: pointer;
	}
	main{
		width:100%;
		height:60vh;
	}
	main .img{
		width:100%;
		height:100%;
		object-fit: cover;
	}
	footer{
		width:100%;
		height:10vh;
		background-color: pink;
		
		display:flex;
		justify-content: center;
		align-items:center;
	}
	.headerUserImg{
		transform: scale(0.4, 0.4);
	}
	</style>
</head>
<body>
	<header>
		<img src="<%=request.getContextPath() %>/image/photo1.png" class="headerimg">
		<div>
			你好，${account}~~~
       		<img src="data:image/jpeg;base64,${userImage}" alt="Image" class="headerUserImg">
       		<a href="<%=request.getContextPath() %>/entry/logout">登出</a>
       	</div>
	</header>
	<nav>
		<a>查詢客戶端訂位狀況</a>
		<a>查詢餐廳端訂位狀況</a>
	</nav>
	<main>
		<img src="<%=request.getContextPath() %>/image/restaurant1.jpg" class="img">
	</main>
	<footer>
		<div>web © 2015 , Update @2023 Maintain by TSuiling ( tsuiling1020@gmail.com )</div>
	</footer>
</body>
</html>