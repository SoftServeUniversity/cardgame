var cardsEffects = function(){

	var cardJumpTo = 50;
	var cardJumpFadeIn = 150;
	var cardJumpFadeOut = 400;
	
	// Cards Animations

	$(".playerCardsList li").on("mouseover", function(){
		var card = $(this);
		var position = card.position();
		if( position.top == 0 ){			
			$(this).css({"position": "relative"});
			$(this).animate({
				"top": "-" + cardJumpTo + "px",
			}, cardJumpFadeIn
			);
		}	
	});


	$(".playerCardsList li").on("mouseleave", function(){
		var card = $(this);		
		card.css({"position": "relative"});
		card.animate({
			"top": "0px",
		}, cardJumpFadeOut
		);
	});
};

$(function(){
	cardsEffects();	
});