var MyApp = angular.module("MyApp");

MyApp.factory("GamesFactory", ["$resource", function($resource){
	return $resource("/games.json", {}, {
		query: {method: "GET", isArray: true},
		create: {method: "POST"}
	});
}]);

MyApp.factory("GameFactory", ["$resource", function($resource){
	return $resource("games/:id.json", {}, {
		show: {method: "GET", params: {id: "@id"}},
		update: {method: "PUT", params: {id: "@id"}},
		delete: {method: "DELETE", params: {id: "@id"}}
	});
}]);

MyApp.factory("CustomActionService", ["$resource", function($resource){
	return $resource("games/:id/:action.json", {}, {
		join: {method: "POST", params: {id: "@id", action:"@action"}},
		put_card: {method: "POST", params: {id: "@id", action: "@action"}},
		end_turn: {method: "POST", params: {id: "@id", action: "@action"}},
		end_game: {method: "POST", params: {id: "@id", action: "@action"}}
	});
}]);