var MyApp = angular.module("MyApp");

MyApp.factory("GamesFactory", ["$resource", function($resource){
	return $resource("/games.json", {}, {
		query: {method: "GET", isArray: true},
		create: {method: "POST"}
	});
}]);

MyApp.factory("GameFactory", ["$resource", function($resource){
	return $resource("games/:id", {}, {
		show: {method: "GET", params: {id: "@id"}},
		update: {method: "PUT", params: {id: "@id"}},
		delete: {method: "DELETE", params: {id: "@id"}}
	});
}]);