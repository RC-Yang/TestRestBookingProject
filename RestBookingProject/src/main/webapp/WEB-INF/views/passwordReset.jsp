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
<script src="<%=request.getContextPath() %>/js/goToLoginPage.js"></script>
<script src="<%=request.getContextPath() %>/js/checkPasswordResetForm.js"></script>
<!--20240330新增-->
<script>
	function showConfirmModal(){
		$('#updatePasswordConfirm').modal('show');

		$('#updatePasswordConfirm button.btn-primary').click(function () {
			
			$('#updatePasswordConfirm').modal('hide');
			checkPasswordResetFormWithAjax();
			$('#updatePasswordSuccess').modal('show');
    	});
	}
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
	        <button type="button" class="btn btn-primary" onclick="goToLoginPage();">確認</button>
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
		    <label for="password" class="form-label">請輸入密碼：</label>
		    <input type="password" class="form-control" id="password" name="password">
		  </div>
		  <div class="mb-3">
		    <label for="password1" class="form-label">請再次輸入密碼：</label>
		    <input type="password" class="form-control" id="checkPassword" name="checkPassword">
		  </div>
		  
		  <button type="button" class="btn btn-primary" onclick="showConfirmModal();">提交</button>
		</form>
	  </div>
	</div>
</body>
</html>