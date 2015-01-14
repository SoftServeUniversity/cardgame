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
		when("/users_room", {
			templateUrl: "assets/cabinet/users_room.html",
			controller: "UserRoomController"
		}).
		otherwise({
			redirectTo: "/home"
		});
}]);