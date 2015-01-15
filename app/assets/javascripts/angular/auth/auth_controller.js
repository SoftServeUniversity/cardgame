var MyApp = angular.module("MyApp");

MyApp.controller("AuthController", ["$scope", "MY_CONST" , "Auth", "$location", "$http",
    function($scope, MY_CONST , Auth, $location, $http) {
        $scope.signedIn = Auth.isAuthenticated();
        $scope.login = function() {
            Auth.login($scope.user).then(function(user) {
                $scope.signedIn = Auth.isAuthenticated();
                $location.path(MY_CONST.HOME_PATH);
            });
        };

        $scope.register = function() {
            Auth.register($scope.user).then(function(user) {
                console.log(user);
                $location.path(MY_CONST.HOME_PATH);
            });
        };

    }
]);
