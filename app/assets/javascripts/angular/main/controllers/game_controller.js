var MyApp = angular.module("MyApp");

MyApp.controller("GameController", ["$scope", "JoinFactory" , "GamesFactory", "GameFactory", "$location", function($scope, JoinFactory , GamesFactory, GameFactory, $location){
	$scope.games = GamesFactory.query();
	$scope.currentUser = true;

	$scope.deleteGame = function(game){
		if(confirm("Are you sure?")){
			GameFactory.delete({id: game.id}, function(){
				$scope.games = GamesFactory.query();
			});
		}
	};

	$scope.createGame = function(){
		GamesFactory.create({game: $scope.newGame}, function(data, $scope){
			$location.path("/games/"+ data.id);
		}, function(error){
			console.log(error);
		});
	};

	$scope.joinGame = function(game){
		JoinFactory.join({id: game.id}, function(){
			$location.path("/games/"+ game.id);
		});
	};
	// $scope.updateGame = function(){
	// 	GamesFactory.update({id: game.id}), function(){
	// 		$location.path("/show")
	// 	}
	// }
}]);