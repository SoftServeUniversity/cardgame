var MyApp = angular.module("MyApp");

MyApp.controller("ShowGameController", ["$scope", "$interval", "$routeParams" , "CustomActionService", "GamesFactory", "GameFactory", "$location", "Auth",
    function($scope, $interval, $routeParams , CustomActionService , GamesFactory, GameFactory, $location, Auth) {

        $scope.updateGame = function() {
            GameFactory.show({
                id: $routeParams.id
            }, function(data) {
                $scope.checkAuth();
                $scope.currentGame = data;
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
                $scope.reloadCards()
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
            }, 2000)
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
            alert("endGame");
        };

        $scope.updateGame();

        $interval(function() {
            $scope.reloadCards();
        }, 5000);

    }
]);