var MyApp = angular.module("MyApp");

MyApp.controller("NavController", ["$scope", "Auth", "$http", function($scope, Auth, $http){
	$scope.signedIn = Auth.isAuthenticated();
	$scope.logout = Auth.logout();
	
	Auth.currentUser().then(function(user){
		$scope.user = user;
	});

	$scope.$on("devise:new-registration", function(e, user){
		$scope.user = user;
	});

	$scope.$on("devise:login", function(e, user){
		$scope.user = user;
	});

	$scope.$on("devise:logout", function(e, user){
		$scope.user = {};
	});

	$scope.$on('devise:unauthorized', function(event, xhr, deferred) {
            $scope.credentials = {
            	email: "ppp@gmail.com",
            	password: "12qwaszx"
            };

            Auth.login($scope.credentials).then(function() {
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

        // Request requires authorization
        // Will cause a `401 Unauthorized` response,
        // that will be recovered by our listener above.
        $http.delete('/users/sign_out.json', {
            interceptAuth: true
        }).then(function(response) {
            // Deleted user 1
        }, function(error) {
            // Something went wrong.
        });

}]);