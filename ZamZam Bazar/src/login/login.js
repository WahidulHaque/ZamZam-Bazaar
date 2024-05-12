'use strict';

angular.module('ecommerce.login', ['ngRoute', 'oitozero.ngSweetAlert'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/login', {
            templateUrl: 'src/login/login.html',
            controller: 'LoginController',
            redirectIfAuthenticated: true,
        });
    }])

    .controller('LoginController', ['$location', '$rootScope',  '$scope', '$http', 'SweetAlert', 'QueryService', 'LocalStorage', 'CONSTANTS', function ($location, $rootScope,  $scope, $http, SweetAlert, QueryService, LocalStorage, CONSTANTS) {
        $scope.formData = {};

        $scope.login = function () {
            if($scope.loginFrom.$valid) {
                QueryService.query('POST', 'Login/Login', {}, $scope.formData).then(function (response) {
                    LocalStorage.set('access_token', response.data.data.accessToken);
                    LocalStorage.set('user', response.data.data.user);
                    $rootScope.USER = response.data.data.user;

                    $location.path('/customer/dashboard');

                }).catch(function (response) {

                });
            }
        };
    }]);