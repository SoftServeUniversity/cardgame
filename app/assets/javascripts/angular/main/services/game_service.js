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
		join: {method: "GET", params: {id: "@id"}},
		update: {method: "PUT", params: {id: "@id"}},
		delete: {method: "DELETE", params: {id: "@id"}}
	});
}]);

MyApp.factory("JoinService", ["$resource", function($resource){
	return $resource("games/:id/update.json", {}, {
		join: {method: "POST", params: {id: "@id"}}
	});
}]);

MyApp.factory("PutService", ["$resource", function($resource){
	return $resource(" /games/:id/put_card.json", {}, {
		put_card: {method: "POST", params: {id: "@id"}}
	});
}]);

MyApp.factory("EndService", ["$resource", function($resource){
	return $resource(" /games/:id/end_turn.json", {}, {
		end_turn: {method: "POST", params: {id: "@id"}}
	});
}]);

MyApp.service('userService',['$resource', function($resource){
	return $resource(" users/:id.json", {}, {
		get_user: {method: "GET", params: {id: "@id"}},
		update_user: {method: "PUT", params: {id: "@id"}}
	});
	
}]);