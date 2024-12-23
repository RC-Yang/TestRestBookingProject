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
			//jQuery Ajax接收的data，型別須為字串或javascript原生物件
			//通过调用$("#login").serialize()，将得到一个类似于"username=xxx&password=yyy"的字串，
			//這個字串會被添加至http request body內
			success: function(response) {
				if(response.message=="登入成功"){
					//20240625修改；需呈顯於下一個jsp頁面但不須傳送到後端的值，存於localStorage
					localStorage.setItem("loginSuccessMessage",response.message);
					localStorage.setItem("loginSuccess",true);
					window.location.href = 'http://localhost:8080/RestBookingProject/entry/login';
				}
				else{
					$('#logInFailModal').addClass('fade');
					$('#logInFailModal').modal('show');
				}
			},
             error: function(xhr, status, error) {
                 
             }
		});
	}else{
		return false;
	}
}