var MyApp = angular.module("MyApp");

MyApp.controller("AuthController", ["$scope", "Auth", "$location", "$http",
    function($scope, Auth, $location, $http) {
        $scope.signedIn = Auth.isAuthenticated();
        $scope.login = function() {
            Auth.login($scope.user).then(function(user) {
                $scope.signedIn = Auth.isAuthenticated();
                $location.path('/home');
            });
        };

        $scope.register = function() {
            Auth.register($scope.user).then(function(user) {
                console.log(user);
                $location.path('/home');
            });
        };

    }
]);
