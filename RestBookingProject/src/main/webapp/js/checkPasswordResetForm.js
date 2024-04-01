function checkPasswordResetFormWithAjax(){
	
	var password = document.getElementById('password').value;
	var checkPassword = document.getElementById('checkPassword').value;
	
	if(password!=null&&password.trim()!=''&&checkPassword!=null&&checkPassword.trim()!=''
		&&(password==checkPassword)){
		
		$.post({
			url:$('#updatePasswordForm').attr('action'),
			data:$('#updatePasswordForm').serialize(),
			success: function(response) {
				if(response=="update password success"){
					$('#updatePasswordSuccess').modal('show');;	
				}
				else{
				}
			},
             error: function(xhr, status, error) {
                 
             }
		});
	}
}