$(function() {

$('button#register').bind('click', function(evt) {
		var email = $('#register_email').val();
		var username = $('#login_username').val();
		var password = $('#login_password').val();
		var confirm_password = $('#login_confirm_password').val();
		var isChecked = $('#register_terms:checked').val() ? true : false;
		var email_re =/^([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\.([a-zA-Z])+([a-zA-Z])+/;
		
		if(!email){
			$('.messages').removeClass('alertsucess');
			$('.messages').addClass('alerterror');
			$('div.alerterror').text('Please, enter your email.. ');
			return false;
		}else if(!email_re.test(email)){
				$('.messages').removeClass('alertsucess');
				$('.messages').addClass('alerterror');
				$('div.alerterror').text('Please, enter valid email.. ');		
				return false;
		}else if(!username){
			$('.messages').removeClass('alertsucess');
			$('.messages').addClass('alerterror');
			$('div.alerterror').text('Please, enter your username.. ');
			return false;
		}else if(!password){
			$('.messages').removeClass('alertsucess');
			$('.messages').addClass('alerterror');
			$('div.alerterror').text('Please, enter your password.. ');
			return false;
		}else if(!confirm_password){
			$('.messages').removeClass('alertsucess');
			$('.messages').addClass('alerterror');
			$('div.alerterror').text('Please, enter your confirm password.. ');
			return false;
		}else if(password != confirm_password){
			$('.messages').removeClass('alertsucess');
			$('.messages').addClass('alerterror');
			$('div.alerterror').text('Password and confirm password must be same..  ');
			return false;
		}else if(!isChecked){
			$('.messages').removeClass('alertsucess');
			$('.messages').addClass('alerterror');
			$('div.alerterror').text('To continue registration, agree Terms and conditions.. ');
			return false;
		}else{
			$('.messages').removeClass('alerterror');
			$('.messages').addClass('alertsuccess');
			$('div.alertsuccess').text('Your registration details taken ..');
			return true;	
		}		
  });
  
  $('button#login').bind('click', function(evt) {
		var username = $('#login_username').val();
		var password = $('#login_password').val();
	
		if(!username){
			$('.messages').removeClass('alertsucess');
			$('.messages').addClass('alerterror');
			$('div.alerterror').text('Please, enter your username.. ');
			return false;
		}else if(!password){
			$('.messages').removeClass('alertsucess');
			$('.messages').addClass('alerterror');
			$('div.alerterror').text('Please, enter your password.. ');
			return false;
		}else{
			$('.messages').removeClass('alerterror');
			$('.messages').addClass('alertsuccess');
			$('div.alertsuccess').text('Your login details taken ..');
			return true;	
		}		
  });

});