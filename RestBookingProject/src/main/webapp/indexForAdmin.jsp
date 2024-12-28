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
	#formDiv{
		width:100%;
		height:100vh;
	
		display:flex;
		justify-content:center;
		align-items:center;
		
		background-color: gray;
		position:relative;
		z-index:1;
	}
	#adminForm{
		width:30%;
		height:35%;

		background-color:white;
		z-index:2;
		
		display:flex;
		flex-direction: column;
		justify-content:center;
		align-items:center;
		
		border-radius: 15px;
	}
	#adminForm div,#adminForm label{
		width:80%;
	}
	</style>
	<script nonce="${nonce}">
	$(document).ready(function(){
		document.getElementById('submitButton').addEventListener("click",async function(){
			var testForm=new FormData(document.getElementById('adminForm'));
			
			var url = "<%=request.getContextPath() %>/entry/checkloginForAdmin";

			var responseEntity = await fetch(url,{method:'post',body:testForm});
			//var response = await responseEntity.json();
			var response = await responseEntity.text();
			
			if(response=="登入成功"){
				window.location.href="<%=request.getContextPath() %>/entry/goTologinSuccessForAdmin";
			}else{
				window.location.href="<%=request.getContextPath() %>/indexForAdmin.jsp";
			}
		});
	});
	</script>
</head>
<body>
	<div id="formDiv">
		<form action="" id="adminForm" method="post">
		  <input type="hidden" name="_csrf" value="${_csrf.token}"/>
		  
		  <div class="mb-3 mt-3">
		    <label for="account" class="form-label">帳號:</label>
		    <input type="text" class="form-control" id="account" name="account" placeholder="輸入帳號">
		  </div>
		  <div class="mb-3">
		    <label for="pwd" class="form-label">密碼:</label>
		    <input type="password" class="form-control" id="password" name="password" placeholder="輸入密碼">
		  </div>

		  <button type="button" class="btn btn-primary" id="submitButton">提交</button>
		</form>	
	</div>
</body>
</html>