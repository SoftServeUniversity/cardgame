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
		when("/new_game", {
			templateUrl: "assets/games/new_game.html",
			controller: "GameController"
		}).
		when("/games/:id", {
			templateUrl: "assets/games/show_game.html",
			controller: "ShowGameController"
		}).
		otherwise({
			redirectTo: "/home"
		});
}]);

MyApp.config([ "AuthInterceptProvider" ,function( AuthInterceptProvider) {
        // Intercept 401 Unauthorized everywhere
        AuthInterceptProvider.interceptAuth(true);
    }]);