var MyLogin = angular.module("MyLogin", ["ngRoute"]);

MyLogin.config(["$routeProvider",function($routeProvider){
		$routeProvider.
		when("/login", {
			templateUrl: "assets/login/login.html",
			ontroller: "LoginController"
			});
}]);

MyLogin.controller("LoginController", function($scope, $http){
	$scope.login_user = {email: null, password: null};

	$scope.login = function(){
		$http.post("../users/sign_in.json", {user: {email: $scope.login_user.email, password: $scope.login_user.password}} );
	};

	$scope.logout = function(){
		$http({method: "DELETE", url: "../users/sign_out.json", data: {}});
	};
});