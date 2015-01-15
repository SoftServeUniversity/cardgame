var MyApp = angular.module("MyApp");

MyApp.controller("ShowGameController", ["$scope", "$interval", "$routeParams" , "MY_CONST" , "CustomActionService", "GamesFactory", "GameFactory", "$location", "Auth",
    function($scope, $interval, $routeParams , MY_CONST , CustomActionService , GamesFactory, GameFactory, $location, Auth) {

        $scope.updateGame = function() {
            GameFactory.show({
                id: $routeParams.id
            }, function(data) {
                $scope.resolveUser();
                $scope.gameEnded(data)
                $scope.currentGame = data;
                $scope.deckCounter = MY_CONST.DECK_CARDS_NUMBER - data.cursor;
            }, function(error) {
                // console.log(error);
            });
        };

        $scope.putCard = function(card) {
            CustomActionService.put_card({
                id: $routeParams.id,
                action: "put_card",
                suite: card.suite,
                rang: card.rang
            }, function(data) {
                $scope.gameEnded(data);
                $scope.reloadCards();
            }, function(error) {
                // console.log(error);
            });
        };

        $scope.reloadCards = function() {

            setTimeout(function() {
                $scope.$apply(function() {
                    GameFactory.show({
                        id: $routeParams.id
                    }, function(data) {
                        $scope.currentGame = data;
                    }, function(error) {
                        // console.log(error);
                    });
                });
            }, MY_CONST.TIMEOUT)
        };

        $scope.endTurn = function() {
            CustomActionService.end_turn({
                id: $routeParams.id,
                action: "end_turn"
            }, function(data) {
                $scope.reloadCards();
            }, function(error) {
                // console.log(error);
            });
        };

        $scope.endGame = function() {
            if(confirm("Are you sure?")){
                GameFactory.delete({id: game.id}, function(){
                    $location.path("users_room");
                });
            }
        };

        $scope.updateGame();

        $interval(function() {
            $scope.reloadCards();
        }, MY_CONST.INTERVAL);
        
        $scope.gameEnded = function(date){
            if(date.status == "ended"){
                $location.path("/users_room");
            }
        };
    }
]);

MyApp.filter("toArray", function(){
    return function(obj) {
        var result = [];
        angular.forEach(obj, function(val, key) {
            result.push(val);
        });
        return result;
    };
});

