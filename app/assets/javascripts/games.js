$(function(){
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



	// New Game Animation

	$("#newGameLogo").on("mouseover", function(){
		$(this).animate({
			"font-size": "+=5px",
		}, 80
		);
	});

	$("#newGameLogo").on("mouseleave", function(){
		$(this).animate({
			"font-size": "-=5px",
		}, 400
		);
	});



	$("#newGameLogo").on("click", function(){		
		var formPad = $("#newGameFormPad");
		if (formPad.height() === 0) {
			$(formPad).animate({
				"height": "121px",
			}, 800);
			setTimeout( function() {
				$("#newGameForm").fadeToggle(800);
			}, 400);

		} else if (formPad.height() === 121) {
			$("#newGameForm").fadeToggle(200);			
			$(formPad).animate({
				"height": "0px",
			}, 400);
		}
	});



	// User Edit Animation

	$("#userSettings").on("click", function(){		
		var formPad = $("#userEditFormPad");
		if (formPad.height() === 0) {
			$(formPad).animate({
				"height": "121px",
			}, 800);
			setTimeout( function() {
				$("#editUserForm").fadeToggle(800);
			}, 400);

		} else if (formPad.height() === 121) {
			$("#editUserForm").fadeToggle(200);			
			$(formPad).animate({
				"height": "0px",
			}, 400);
		}
	});




	// Cards Animations

	$(".playerCardsList li").on("mouseover", function(){
		var card = $(this);
		var position = card.position();
		if( position.top == 0 ){			
			$(this).css({"position": "relative"});
			$(this).animate({
				"top": "-50px",
			}, 150
			);
		}	
	});


	$(".playerCardsList li").on("mouseleave", function(){
		var card = $(this);		
		card.css({"position": "relative"});
		card.animate({
			"top": "0px",
		}, 400
		);
	});


});