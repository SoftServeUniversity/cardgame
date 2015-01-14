var MyApp = angular.module("MyApp");

MyApp.controller("GameController", ["$scope", "$interval" , "MY_CONST" , "Auth" , "CustomActionService" , "GamesFactory", "GameFactory", "$location", function($scope, $interval , MY_CONST , Auth , CustomActionService , GamesFactory, GameFactory, $location){

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
			GameFactory.delete({id: game.id},
			function(){
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
		CustomActionService.join({id: game.id , action: "update"}, function(){
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
        }, MY_CONST.TIMEOUT);
	}, MY_CONST.INTERVAL);
}]);