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
}]).constant("MY_CONST", {
        "TIMEOUT": 2000,
        "INTERVAL": 5000,
        "DECK_CARDS_NUMBER": 36,
        "ACTION_PUT_CARD": "put_card",
        "ACTION_END_TURN": "end_turn",
        "ACTION_UPDATE": "update",
        "USER_ROOM_PATH": "/users_room",
        "GAMES_PATH": "/games/",
        "HOME_PATH": "/home",
        "ENDED_STATUS": "ended"

    });
