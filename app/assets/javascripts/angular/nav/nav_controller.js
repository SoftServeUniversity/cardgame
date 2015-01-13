var MyApp = angular.module("MyApp");

MyApp.controller("NavController", ["$scope", "Auth", "$http",
    function($scope, Auth, $http) {

        $scope.logout = function() {
            Auth.logout().then(function(oldUser) {
                alert(oldUser.username + "you're signed out now.");
            }, function(error) {
                console.log(error);
            });
        };

        $scope.$on('devise:unauthorized', function(event, xhr, deferred) {
            // $scope.credentials = {
            //     login: "qwe",
            //     password: "qweqweqwe"
            // };
            // Auth.login($scope.credentials).then(function() {
            // 	console.log("Relogin");
            //     // Successfully logged in.
            //     // Redo the original request.
            //     return $http(xhr.config);
            // }).then(function(response) {
            //     // Successfully recovered from unauthorized error.
            //     // Resolve the original request's promise.
            //     deferred.resolve(response);
            // }, function(error) {
            //     // There was an error logging in.
            //     // Reject the original request's promise.
            //     deferred.reject(error);
            // });
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

        $scope.$watch('user', function(newValue, oldValue) {
            console.log("____________________________________");
            console.log(new Date());
            console.log("____________________________________");
            console.log("NewValue: " + newValue.username);
            console.log("OldValue: " + oldValue.username);
        });
    }
]);