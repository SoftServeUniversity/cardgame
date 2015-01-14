var MyApp = angular.module("MyApp");

MyApp.controller("GameController", ["$scope", "$interval" , "Auth" , "JoinService" , "GamesFactory", "GameFactory", "$location", function($scope, $interval , Auth , JoinService , GamesFactory, GameFactory, $location){

	$scope.indexGames = function(){
		GamesFactory.query({}, function(data) {
                $scope.games = data;
            }, function(error) {
                console.log(error);
            }
        );
	}

	$scope.deleteGame = function(game){
		if(confirm("Are you sure?")){
			GameFactory.delete({id: game.id}, function(){
				$scope.indexGames();
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
		JoinService.join({id: game.id}, function(){
			$location.path("/games/"+ game.id);
		});
	};

	$scope.showGame = function(game) {
		$location.path("/games/"+game.id);
	};

	$scope.resolveUser();
	$scope.indexGames();

	$interval(function(){
		setTimeout(function() {
            $scope.$apply(function() {
                $scope.indexGames();
            });
        }, 2000);
	},5000);
}]);