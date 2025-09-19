function checkLogInForm(){
	//var account = $("#login #account").val();
	//var password = $("#login #password").val();
	var account = document.getElementById('account').value;
	var password = document.getElementById('password').value;
	
	if(account!=null&&account.trim()!=''&&password!=null&&password.trim()!=''){
		$("#login").submit();
	}
}

function checkLogInFormWithAjax(){

	var account = $("#login #account").val();//回傳的是字串，字串自帶trim()
	var password = $("#login #password").val();
	
	if(account!=null&&account.trim()!=''&&password!=null&&password.trim()!=''){
		$.post({
			url:$("#login").attr('action'),
			data:
			$("#login").serialize(),
			success: function(response) {

			},
             error: function(xhr, status, error) {
                 
             }
		});
	}else{
		return false;
	}
}