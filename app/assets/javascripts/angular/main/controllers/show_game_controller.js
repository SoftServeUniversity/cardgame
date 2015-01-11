var MyApp = angular.module("MyApp");

MyApp.controller("ShowGameController", ["$scope", "PutFactory" , "JoinFactory" , "GamesFactory", "GameFactory", "$location", "Auth" , function($scope, PutFactory , JoinFactory , GamesFactory, GameFactory, $location, Auth){
	GameFactory.show({id: $location.path().split('/').pop()},function(data){
		$scope.checkAuth();
		$scope.currentGame = data;
	},function(error){
		console.log(error);
	});

	$scope.checkAuth = function(){
  		$scope.isAuthenticated = Auth.isAuthenticated();
  		$scope.currentUser = Auth.currentUser();
 	};

 	$scope.putCard = function(card){
 		PutFactory.put_card({id: $location.path().split('/').pop(), suite: card.suite, rang: card.rang}, function(data){
			setTimeout(function () {
        		$scope.$apply(function () {
            		GameFactory.show({id: $location.path().split('/').pop()},function(data){
						$scope.currentGame = data;
					},function(error){
						console.log(error);
					});
        		});
    		}, 2000)
		}, function(error){
			console.log(error);
		});
 	};

}]);