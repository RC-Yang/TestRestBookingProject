function checkEmailForm(){
	var result = false;
	var emailRegex=/^[a-zA-Z0-9][\w+\.-]*@[\dA-Za-z][\dA-Za-z_\-]*[\dA-Za-z]\.[\dA-Za-z]{2,}/;

	if($("#forgetPassword #email").val()!=''){
			var regexResult = emailRegex.test($("#forgetPassword #email").val());
			if(regexResult)
				result=true;
		}
		return result;
}