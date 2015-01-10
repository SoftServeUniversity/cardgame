var MyApp = angular.module("MyApp");

MyApp.controller("AuthController", ["$scope", "Auth", "$location", "$http", function($scope, Auth, $http , $location){
	$scope.signedIn = false;
	$scope.login = function(){
		Auth.login($scope.user).then(function(user){
			$scope.signedIn = Auth.isAuthenticated
			$location.path('/home');
		});
	};

	$scope.register = function(){
		Auth.register($scope.user).then(function(user){
			console.log(user);
			$location.path('/home');
		});
	};

	$scope.$on('devise:unauthorized', function(event, xhr, deferred) {
            // Ask user for login credentials

            Auth.login($scope.user).then(function() {
                // Successfully logged in.
                // Redo the original request.
                return $http(xhr.config);
            }).then(function(response) {
                // Successfully recovered from unauthorized error.
                // Resolve the original request's promise.
                deferred.resolve(response);
            }, function(error) {
                // There was an error logging in.
                // Reject the original request's promise.
                deferred.reject(error);
            });
        });

}]);