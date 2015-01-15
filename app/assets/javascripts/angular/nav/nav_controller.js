var MyApp = angular.module("MyApp");

MyApp.controller("NavController", ["$scope", "Auth", "$http", "$location",
    function($scope, Auth, $http, $location) {

        $scope.logout = function() {
            Auth.logout().then(function(oldUser) {
                alert(oldUser.username + "you're signed out now.");
            }, function(error) {
                console.log(error);
            });
        };

        $scope.$on('devise:unauthorized', function(event, xhr, deferred) {
           $location.path("/login");
        });
        
        $scope.resolveUser = function(){
            Auth.currentUser().then(function(user) {
                $scope.signedIn = Auth.isAuthenticated();
                $scope.user = user;
            });
        };

        $scope.$on("devise:new-registration", function(e, user) {
            $scope.signedIn = Auth.isAuthenticated();
            $scope.user = user;
        });

        $scope.$on("devise:login", function(e, user) {
            $scope.signedIn = Auth.isAuthenticated();
            $scope.user = user;
        });

        $scope.$on("devise:logout", function(e, user) {
            $scope.signedIn = Auth.isAuthenticated();
            $scope.user = {};
        });
        
        $scope.resolveUser();
    }
]);