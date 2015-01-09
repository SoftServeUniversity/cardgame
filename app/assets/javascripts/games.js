// $(function(){
// 	$(".playerCardsList li").click(
// 		function(){
// 			$(this).hide('slow');
// 		}
// 	);
// });

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



});