var MyApp = angular.module("MyApp");

MyApp.controller("ShowGameController", ["$scope", "$interval", "EndService", "PutService", "GamesFactory", "GameFactory", "$location", "Auth", "$routeParams",
    function($scope, $interval, EndService, PutService, GamesFactory, GameFactory, $location, Auth, $routeParams) {

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

        $scope.checkAuth = function() {
            $scope.isAuthenticated = Auth.isAuthenticated();
            $scope.currentUser = Auth.currentUser();
        };

        $scope.putCard = function(card) {
            PutService.put_card({
                id: $routeParams.id,
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
            EndService.end_turn({
                id: $routeParams.id
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

MyApp.filter("toArray", function(){
    return function(obj) {
        var result = [];
        angular.forEach(obj, function(val, key) {
            result.push(val);
        });
        return result;
    };
});

