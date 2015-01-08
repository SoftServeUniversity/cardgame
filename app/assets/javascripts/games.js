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

});