$(document).ready(function(){
	$("#btn-sign-up").click(function(){
		mixpanel.track("Landing Expand");
		$("#sign-up").animate({
		  height: "0px"	
		}, 500, function(){
			$("#sign-up").hide();
		} );
		
		$("#signup-row").animate({
			height: "128px"
		}, 500, function(){} );
	});
	
	$("#button-sign-up").click( function(){
		mixpanel.track("Landing Page Sign Up");
		
		var email = $("#email-sign-up").val();
		$.post( "/landing/signup.json", { email: email } );		
		$("#signup-row").animate({
			height: "0px"
		}, 500, function(){});
		$("#sign-up-success").fadeIn();
	});
});