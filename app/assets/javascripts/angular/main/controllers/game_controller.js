var MyApp = angular.module("MyApp");

MyApp.controller("GameController", ["$scope", "GamesFactory", "GameFactory", "$location", function($scope, GamesFactory, GameFactory, $location){
	$scope.games = GamesFactory.query();

	$scope.currentUser = true;

	$scope.deleteGame = function(game){
		if(confirm("Are you sure?")){
			GameFactory.delete({id: game.id}, function(){
				$scope.games = GamesFactory.query();
			});
		}
	};
}]);