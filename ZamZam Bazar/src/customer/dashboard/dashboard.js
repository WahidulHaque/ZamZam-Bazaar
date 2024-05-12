'use strict';

angular.module('ecommerce.customer.dashboard', ['ngRoute', 'ng-morris-js'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/customer/dashboard', {
            templateUrl: 'src/customer/dashboard/dashboard.html',
            controller: 'DashboardController',
            requiredAuth: true,
        });
    }])

    .controller('DashboardController', ['$rootScope', '$scope', '$http', 'SweetAlert', 'QueryService', 'LocalStorage', 'CONSTANTS', function ($rootScope, $scope, $http, SweetAlert, QueryService, LocalStorage, CONSTANTS) {

        QueryService.authQuery('GET', 'OrderInfo/GetOrderInfoByCustomerId', {customerId: $rootScope.USER.id}, {}).then(function (response) {
            $scope.barChartData = response.data;
            $scope.barChartOptions = {
                xkey: 'books',
                ykeys: ['member'],
                labels: ['Amount'],
                barColors: ['#ff7e12']
            };

        }).catch(function (response) {

        });

    }]);