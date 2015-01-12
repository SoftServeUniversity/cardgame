var MyApp = angular.module("MyApp");

MyApp.controller("ShowGameController", ["$scope", "EndFactory", "PutFactory", "JoinFactory", "GamesFactory", "GameFactory", "$location", "Auth",
    function($scope, EndFactory, PutFactory, JoinFactory, GamesFactory, GameFactory, $location, Auth) {

        $scope.updateGame = function() {
            GameFactory.show({
                id: $location.path().split('/').pop()
            }, function(data) {
                $scope.checkAuth();
                $scope.currentGame = data;
            }, function(error) {
                console.log(error);
            });
        };

        $scope.checkAuth = function() {
            $scope.isAuthenticated = Auth.isAuthenticated();
            $scope.currentUser = Auth.currentUser();
        };

        $scope.putCard = function(card) {
            PutFactory.put_card({
                id: $location.path().split('/').pop(),
                suite: card.suite,
                rang: card.rang
            }, function(data) {
                $scope.reloadCards()
            }, function(error) {
                console.log(error);
            });
        };

        $scope.reloadCards = function() {

            setTimeout(function() {
                $scope.$apply(function() {
                    GameFactory.show({
                        id: $location.path().split('/').pop()
                    }, function(data) {
                        $scope.currentGame = data;
                    }, function(error) {
                        console.log(error);
                    });
                });
            }, 2000)
        };

        $scope.endTurn = function() {
            EndFactory.end_turn({
                id: $location.path().split('/').pop()
            }, function(data) {
                $scope.reloadCards();
            }, function(error) {
                console.log(error);
            });
        };

        $scope.endGame = function() {
            alert("endGame");
        };

        $scope.updateGame();

    }
]);
