var MyApp = angular.module("MyApp");

MyApp.controller("ShowGameController", ["$scope", "$interval", "$routeParams" , "CONST" , "CustomActionService", "GamesFactory", "GameFactory", "$location", "Auth",
    function($scope, $interval, $routeParams , CONST , CustomActionService , GamesFactory, GameFactory, $location, Auth) {

        $scope.updateGame = function() {
            GameFactory.show({
                id: $routeParams.id
            }, function(data) {
                $scope.resolveUser();
                $scope.gameEnded(data);
                $scope.currentGame = data;
                $scope.deckCounter = CONST.DECK_CARDS_NUMBER - data.cursor;

            }, function(error) {
                // console.log(error);
            });
        };

        $scope.putCard = function(card) {
            CustomActionService.put_card({
                id: $routeParams.id,
                action: CONST.ACTION_PUT_CARD,
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
            }, CONST.TIMEOUT)
        };

        $scope.endTurn = function() {
            CustomActionService.end_turn({
                id: $routeParams.id,
                action: CONST.ACTION_END_TURN
            }, function(data) {
                $scope.reloadCards();
            }, function(error) {
                // console.log(error);
            });
        };

        $scope.endGame = function() {
            if(confirm("Are you sure?")){
                CustomActionService.end_game({
                    id: $routeParams.id,
                    action: CONST.ACTION_END_GAME
                }, function(){
                    $location.path(CONST.USER_ROOM_PATH);
                });
            }
        };

        $scope.updateGame();

        $interval(function() {
            $scope.updateGame();
        }, CONST.INTERVAL);
        
        $scope.gameEnded = function(date){
            if(date.status === CONST.ENDED_STATUS){
                $location.path(CONST.USER_ROOM_PATH);
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