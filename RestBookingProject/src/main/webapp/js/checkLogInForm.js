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
			data:$("#login").serialize(),
			//jQuery Ajax接收的data，型別須為字串或javascript原生物件
			//通过调用$("#login").serialize()，将得到一个类似于"username=xxx&password=yyy"的字串，
			//這個字串會被添加至http request body內
			//20240629新增
			beforeSend: function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success: function(response) {
				if(response=="登入成功"){
					//20240625修改；需呈顯於下一個jsp頁面但不須傳送到後端的值，存於localStorage
					localStorage.setItem("loginSuccessMessage",response);
					localStorage.setItem("loginSuccess",true);
					//window.location.href = 'http://localhost:8080/RestBookingProject/entry/login?_csrf=' + encodeURIComponent(window.token)
					//+'&_csrf_header=' + encodeURIComponent(window.header);

					//20240629修改；不能使用get方法傳送csrf參數，必須改用post方法，故需要另外產生http post請求，裡面包csrf參數
					goToLoginSuccessPage();
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

function goToLoginSuccessPage(){
	$.post({
        url: "http://localhost:8080/RestBookingProject/entry/login",
        beforeSend: function(xhr) {
			alert(window.token+"  "+window.header);
			xhr.setRequestHeader(window.header, window.token);
		},success: function(data) {
			alert("请求成功:", data);
		},
		error: function(error) {
			alert("请求失败:", error);
		}
    });
}