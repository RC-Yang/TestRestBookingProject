function showLoginSuccessModal(response){
	$('#logInSuccessModal').addClass('fade');
	$('#logInSuccessModal').modal('show');
	$('#logInSuccessModal .modal-title').text(response);
	$('#logInSuccessModal .modal-body p').text(response);
}