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
			"height": "+=0.5em",
		}, 80
		);
	});

	$("#newGameLogo").on("mouseleave", function(){
		$(this).animate({
			"height": "-=0.5em",
		}, 400
		);
	});



	$("#newGameLogo").on("click", function(){
		$("#newGameFormPad").animate({
			"height": "160px",
		}, 80
		);
		$("#newGameForm").toggle(1000);
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