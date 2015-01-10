var MyApp = angular.module("MyApp");

MyApp.controller("NavController", ["$scope", "Auth", function($scope, Auth){
	$scope.signedIn = Auth.isAuthenticated();
	$scope.logout = Auth.logout();
	
	Auth.currentUser().then(function(user){
		$scope.signedIn = Auth.isAuthenticated();
		$scope.user = user;
	});

	$scope.$on("devise:new-registration", function(e, user){
		$scope.signedIn = Auth.isAuthenticated();
		$scope.user = user;
	});

	$scope.$on("devise:login", function(e, user){
		$scope.signedIn = Auth.isAuthenticated();
		$scope.user = user;
	});

	$scope.$on("devise:logout", function(e, user){
		$scope.signedIn = Auth.isAuthenticated();
		$scope.user = {};
	});

}]);