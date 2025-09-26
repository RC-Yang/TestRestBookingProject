<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>密碼重設</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<script src="<%=request.getContextPath() %>/js/checkPasswordResetForm.js"></script>
<!--20240330新增-->
<script nonce="${nonce}">
	function showConfirmModal(){
		$('#updatePasswordConfirm').modal('show');

		$('#updatePasswordConfirm button.btn-primary').click(function () {
			
			$('#updatePasswordConfirm').modal('hide');
			//20240627修改
			resetPasswordWithAjax();
    	});
	}
	//20240627新增
	$(document).ready(function(){
		$("#account,#password").on("input",function(){
			$.post({
				url:'/RestBookingProject/form/checkUser',
				data:$('#updatePasswordForm').serialize(),
				success:(result)=>{
					$("#accAndPassResult").text(result);
					if(result=='帳密正確。'){
						$("#accAndPassResult").css('color','green');
					}else{
						$("#accAndPassResult").css('color','red');
					}					
					$("#accAndPassResult").css('font-size', '20px');
				},
				error:()=>{
					
				}
			});		
		});
		//20240627新增
		$("#password1,#checkPassword1").on('input',function(){
			checkPasswordResetFormWithAjax();
		});
		
		$("#submitButton").click(showConfirmModal);
		$("#cancelButton").click(function(){
			window.location.href='https://localhost:8443/RestBookingProject/form/goToReqAndLogin';
		});

		$("#updatePasswordSuccessButton").click(function(){
			location.href="https://localhost:8443/RestBookingProject/index.jsp";
		});		
	});
</script>
</head>
<body>
	<!-- 密碼修改成功後要彈出的視窗，按下確定後要重導到登入頁面 -->
	<div id="updatePasswordSuccess" class="modal fade" tabindex="-1">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">密碼修改成功，請重新登入</h5>
	      </div>
	      <div class="modal-body">
	        <p>密碼修改成功，請重新登入。</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" id="updatePasswordSuccessButton">確認</button>
	      </div>
	    </div>
	  </div>
	</div>

	<!-- 密碼修改前要彈出的視窗，按下確定後執行修改密碼 -->
	<div id="updatePasswordConfirm" class="modal fade" tabindex="-1">
		<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
			<h5 class="modal-title">確認要修改密碼？</h5>
			</div>
			<div class="modal-body">
			<p>確認要修改密碼？</p>
			</div>
			<div class="modal-footer">
			<button type="button" class="btn btn-primary">確認</button>
			</div>
		</div>
		</div>
	</div>

	<div class="container-xl py-5">
	  <div class="row">
		<form id="updatePasswordForm" method="post" action="<%=request.getContextPath()%>/mvc/entry/updatePassword">
			<div class="mb-3">
				<label for="account" class="form-label">請輸入帳號：</label>
                <input type="text" class="form-control" id="account" name="account"/>
			</div>

			<div class="mb-3">
				<label for="password" class="form-label">請輸入新密碼：</label>
				<input type="password" class="form-control" id="password1" name="password1">
			</div>
			<div class="mb-3">
				<label for="checkPassword1" class="form-label">請再次輸入新密碼：</label>
				<input type="password" class="form-control" id="checkPassword1" name="checkPassword1">
				<p id="newPassResult"></p>
			</div>
			
			<button type="button" class="btn btn-primary" id="submitButton">提交</button>
			<button type="button" class="btn btn-danger" id="cancelButton">取消</button>
		</form>
	  </div>
	</div>
</body>
</html>