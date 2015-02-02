var MyApp = angular.module("MyApp");

MyApp.controller("GameController", ["$scope", "$interval" , "CONST" , "Auth" , "CustomActionService" , "GamesFactory", "GameFactory", "userService", "$location", function($scope, $interval , CONST , Auth , CustomActionService , GamesFactory, GameFactory, userService, $location){

	$scope.indexGames = function(){
		GamesFactory.query({}, function(data) {
                $scope.games = data;
            }, function(error) {
                console.log(error);
            }
    );
	};

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
			$location.path(CONST.GAMES_PATH + data.id);
		}, function(error){
			console.log(error);
		});
	};

	$scope.joinGame = function(game){
		CustomActionService.join({id: game.id , action: CONST.ACTION_UPDATE}, function(){
			$location.path(CONST.GAMES_PATH + game.id);
		});
	};

	$scope.showGame = function(game) {
		$location.path(CONST.GAMES_PATH + game.id);
	};

	$scope.gameEmpty = function(game){
		if(game.state === "expactation_second_player")
			return true
		else
			return false
	};

	$scope.gameOwner = function(game, user){
		if(game.owner.id === user.id)
			return true;
		else
			return false;
	};

	$scope.updateUser = function(){
		userService.get_user({id: $scope.user.id}, function(data){
			$scope.myGame = data.my_game;
		});
	};

	$scope.resolveUser();
	$scope.indexGames();

	$interval(function(){
		setTimeout(function() {
            $scope.$apply(function() {
                $scope.indexGames();
                $scope.updateUser();
            });
        }, CONST.TIMEOUT);
	}, CONST.INTERVAL);
}]);