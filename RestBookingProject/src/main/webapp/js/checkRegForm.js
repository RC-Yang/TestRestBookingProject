    function checkRegForm(){
    	$(".form-check-label.userType").css("color","green");
    	var result=false;
    	var emailRegex=/^[a-zA-Z0-9][\w\.-]*@[\dA-Za-z][\dA-Za-z_\-]*[\dA-Za-z]\.[\dA-Za-z]{2,}/;
    	
    	if($("#reg #account").val()==''||$("#reg #account").val()==null){
    		$(".invalid-Account").css("display","block");
    		$(".invalid-Email").css("color","red");
    		$("#account").css("border-color","red");
    	}
    	else{
    		$(".valid-Account").css("display","block");
    		$(".valid-Account").css("color","green");
    		$("#account").css("border-color","green");
    	}
    	if($("#reg #email").val()==''||$("#reg #email").val()==null){
    		$(".invalid-Email").css("display","block");
    		$(".invalid-Email").css("color","red");
    		$("#email").css("border-color","red");
    	}
    	else{
    		$(".valid-Email").css("display","block");
    		$(".valid-Email").css("color","green");
    		$("#email").css("border-color","green");
    	}
    	if($("#reg #password").val()==''||$("#reg #password").val()==null){
    		$(".invalid-Password").css("display","block");
    		$(".invalid-Password").css("color","red");
    		$("#password").css("border-color","red");
    	}
    	else{
    		$(".valid-Password").css("display","block");
    		$(".valid-Password").css("color","green");
    		$("#password").css("border-color","green");
    	}
    	if($("#reg #checkedPassword").val()==''||$("#reg #checkedPassword").val()==null){
    		$(".invalid-CheckedPassword").css("display","block");
    		$(".invalid-CheckedPassword").css("color","red");
			$("#checkedPassword").css("border-color","red");
    	}
    	else{
    		$(".valid-CheckedPassword").css("display","block");
    		$(".valid-CheckedPassword").css("color","green");
    		$("#checkedPassword").css("border-color","green");
    	}
  
    	if($("#reg #account").val()!=''&& $("#reg #email").val()!=''
    	&&$("#reg #password").val()!=''&& $("#reg #checkedPassword").val()!==''
    	){
			var regexResult = emailRegex.test($("#reg #email").val());
			if(regexResult)
				result=true;
		}
		return result;
    }