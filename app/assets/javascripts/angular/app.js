var MyApp = angular.module("MyApp",['ngResource', 'ngRoute', 'Devise']);

MyApp.config(["$routeProvider", "$locationProvider", function($routeProvider, $locationProvider){

		$routeProvider.
		when("/home", {
			templateUrl: "assets/games/show.html",
			controller: "GameController"
		}).
		when("/login", {
			templateUrl: "assets/auth/login.html",
			controller: "AuthController"
		}).
		when("/register", {
			templateUrl: "assets/auth/registration.html",
			controller: "AuthController"
		}).
		otherwise({
			redirectTo: "/home"
		});
}]);