var MyApp = angular.module("MyApp");

MyApp.controller("GameController", [
    "$scope",
    "$interval",
    "$timeout",
    "$location",
    "CONST",
    "Auth",
    "CustomActionService",
    "GamesFactory",
    "GameFactory",
    "userService",
    function($scope, $interval, $timeout, $location, CONST, Auth,
        CustomActionService, GamesFactory, GameFactory, userService) {

        $scope.indexGames = function() {
            GamesFactory.query({}, function(data) {
                $scope.error = null;
                $scope.games = data;
            }, function(error) {
                $scope.error = "Loading all games ERROR";
                console.log(error);
            });
        };

        $scope.deleteGame = function(game) {
            if (confirm("Are you sure?")) {
                GameFactory.delete({
                        id: game.id
                    },
                    function() {
                        $scope.indexGames();
                    });
            }
        };

        $scope.createGame = function() {
            GamesFactory.create({
                game: $scope.newGame
            }, function(data, $scope) {
                $scope.error = null;
                $location.path(CONST.GAMES_PATH + data.id);
            }, function(error) {
                $scope.error = "Create game ERROR";
                console.log(error);
            });
        };

        $scope.joinGame = function(game) {
            CustomActionService.join({
                id: game.id,
                action: CONST.ACTION_UPDATE
            }, function() {
                $location.path(CONST.GAMES_PATH + game.id);
            });
        };

        $scope.showGame = function(game) {
            $location.path(CONST.GAMES_PATH + game.id);
        };

        $scope.gameEmpty = function(game) {
            if (game.state === "expactation_second_player")
                return true
            else
                return false
        };

        $scope.gameOwner = function(game, user) {
            if (game.owner.id === user.id)
                return true;
            else
                return false;
        };

        $scope.updateUser = function() {
            userService.get_user({
                id: $scope.user.id
            }, function(data) {
                $scope.myGame = data.my_game;
            });
        };

        $scope.resolveUser();
        $scope.indexGames();

        $interval(function() {
            $timeout(function() {
                $scope.indexGames();
                $scope.updateUser();
            }, CONST.TIMEOUT);
        }, CONST.INTERVAL);
    }
]);