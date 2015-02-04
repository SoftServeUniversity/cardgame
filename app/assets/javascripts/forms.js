var formsEffects = function(){

	var newGameLogoGrowth = 5;

	var logoFadeIn = 80;
	var logoFadeOut = 400;

	var formPadHeight = 121;
	var formPadFadeIn = 800;
	var formPadFadeOut = 400;
	
	var formDelay = 400;
	var formFadeIn = 800;
	var formFadeOut = 200;


	// New Game Logo Animation

	$("#newGameLogo").on("mouseover", function(){
		$(this).animate({
			"font-size": "+=" + newGameLogoGrowth + "px",
		}, logoFadeIn
		);
	});

	$("#newGameLogo").on("mouseleave", function(){
		$(this).animate({
			"font-size": "-=" + newGameLogoGrowth + "px",
		}, logoFadeOut
		);
	});


	// New Game Form Animation

	$("#newGameLogo").on("click", function(){		
		var formPad = $("#newGameFormPad");
		if (formPad.height() === 0) {
			$(formPad).animate({
				"height": formPadHeight + "px",
			}, formPadFadeIn);
			setTimeout( function() {
				$("#newGameForm").fadeToggle(formFadeIn);
			}, formDelay);

		} else if (formPad.height() === formPadHeight) {
			$("#newGameForm").fadeToggle(formFadeOut);			
			$(formPad).animate({
				"height": "0px",
			}, formPadFadeOut);
		}
	});
	

	// User Edit Form Animation

	$("#userSettings").on("click", function(){		
		var formPad = $("#userEditFormPad");
		if (formPad.height() === 0) {
			$(formPad).animate({
				"height": formPadHeight + "px",
			}, formPadFadeIn);
			setTimeout( function() {
				$("#editUserForm").fadeToggle(formFadeIn);
			}, formDelay);

		} else if (formPad.height() === formPadHeight) {
			$("#editUserForm").fadeToggle(formFadeOut);			
			$(formPad).animate({
				"height": "0px",
			}, formPadFadeOut);
		}
	});


	// Login Popover with Bootstrap

	$("#logInButton").popover({
		html: true,
		trigger: "click",
		placement: "auto",
		animation: "true",
		content: function(){
			return $(this).parents().find("#logInForm").html();
		}
	});
	
	$("#turnInfoButton").popover({
		html: true,
		trigger: "hover",
		placement: "left",
		animation: "true",
		content: function(){
			return $(this).parents().find("#turnInfoHint").html();
		}
	});
};


$(function(){
	formsEffects();	
});