//20240627修改
function checkPasswordResetFormWithAjax(){
	
	var password = document.getElementById('password1').value;
	var checkPassword = document.getElementById('checkPassword1').value;
	
	if(password!=null&&password.trim()!=''&&checkPassword!=null&&checkPassword.trim()!=''){
		if(password==checkPassword){
			$("#newPassResult").text("密碼值一致");
			$("#newPassResult").css('color','green');
		}else{
			$("#newPassResult").text("密碼值不一致");
			$("#newPassResult").css('color','red');
		}
		$("#newPassResult").css('font-size', '20px');
	}
}

function resetPasswordWithAjax(){
	$.post({
		url:'/RestBookingProject/entry/updatePassword',
		data:$('#updatePasswordForm').serialize(),
		success:(data)=>{
			if(data=='update password success'){
				$('#updatePasswordSuccess').modal('show');
			}
		},
		error:()=>{

		}
	});
}