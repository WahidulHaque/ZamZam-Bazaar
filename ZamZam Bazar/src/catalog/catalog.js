'use strict';

angular.module('ecommerce.catalog', ['ngRoute', 'oitozero.ngSweetAlert'])

    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/catalog/search', {
            templateUrl: 'src/catalog/catalog.html',
            controller: 'ProductSearchController'
        });

        $routeProvider.when('/catalog/offers', {
            templateUrl: 'src/catalog/catalog.html',
            controller: 'ProductOfferController'
        });

        $routeProvider.when('/catalog/:categoryId', {
            templateUrl: 'src/catalog/catalog.html',
            controller: 'CatalogController'
        });
    }])

    .controller('CatalogController', ['$scope', '$routeParams', 'QueryService', function ($scope, $routeParams, QueryService) {
        $scope.products = [];

        var params = {categoryId: $routeParams.categoryId};
        QueryService.query('GET', 'OrderDB/GetProductByCategoryId', params, {}).then(function (data){
            $scope.products = data.data;
        }).catch(function (response) {

        });
    }])

    .controller('ProductSearchController', ['$scope', '$location', 'QueryService', 'SweetAlert', function ($scope, $location, QueryService, SweetAlert) {
        $scope.products = [];

        var search = $location.search();
        var params = {Name: search.keyword, CategoryId: search.categoryId};

        if(params.Name.length > 2) {
            QueryService.authQuery('GET', 'Product/GetProductForSearch', params, {}).then(function (data){
                $scope.products = data.data;
            }).catch(function (response) {

            });
        } else {
            SweetAlert.swal("Failed", "Please enter search keyword with at least 3 character", "warning");
        }
    }])

    .controller('ProductOfferController', ['$scope', 'QueryService', function ($scope, QueryService) {
        $scope.products = [];

        QueryService.query('GET', 'Product/GetAllOfferProduct', {}, {}).then(function (data){
            $scope.products = data.data;
        }).catch(function (response) {

        });
    }]);