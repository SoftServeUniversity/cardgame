var MyApp = angular.module("MyApp");

MyApp.controller("ShowGameController", ["$scope", "JoinFactory" , "GamesFactory", "GameFactory", "$location", function($scope, JoinFactory , GamesFactory, GameFactory, $location){
	GameFactory.show({id: $location.path().split('/').pop()},function(data){
		$scope.showGame = data;
	},function(error){
		console.log(error);
	});

}]);