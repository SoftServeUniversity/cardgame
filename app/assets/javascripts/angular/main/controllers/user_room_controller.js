var MyApp = angular.module("MyApp");

MyApp.controller("UserRoomController", ["$scope", "userService", "Auth" , function($scope, userService ,Auth){

	$scope.showingForm = false;
	$scope.updatedUser = {};

	$scope.getStatistics = function(){
		userService.get_user({id: $scope.user.id}, function(data){
			$scope.user_stat = data;
		});
	};

 	$scope.updateUser = function(){
 		userService.update_user({
 			id: $scope.user.id,
 			username: $scope.updatedUser.username,
 			view_theme: $scope.updatedUser.view_theme
 		}, function(data){
        	$scope.user_stat = data;
        	$scope.user.username = data.username;
			$scope.toggleForm();
		});
 	};

	$scope.toggleForm = function(){
		console.log("toggle");
		$scope.showingForm = !$scope.showingForm;
		$scope.updatedUser = {};
		$scope.updatedUser.id = $scope.user.id;
	};

 	$scope.resolveUser();
 	$scope.getStatistics();
}]);