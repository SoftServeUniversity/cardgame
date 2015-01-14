var MyApp = angular.module("MyApp");

MyApp.controller("ShowGameController", ["$scope", "$interval", "EndService", "PutService", "GamesFactory", "GameFactory", "$location", "Auth", "$routeParams",
    function($scope, $interval, EndService, PutService, GamesFactory, GameFactory, $location, Auth, $routeParams) {

        $scope.updateGame = function() {
            GameFactory.show({
                id: $routeParams.id
            }, function(data) {
                $scope.checkAuth();
                $scope.response = data;
                $scope.gameEnded(data)
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
                $scope.response = data;
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
            if(confirm("Are you sure?")){
                GameFactory.delete({id: game.id}, function(){
                    $location.path("users_room");
                });
            }
        };

        $scope.updateGame();

        $interval(function() {
            $scope.reloadCards();
        }, 5000);

        $scope.gameEnded = function(date){
            if(date.status == "ended"){
                $location.path("/users_room");
            }
        };
    }
]);