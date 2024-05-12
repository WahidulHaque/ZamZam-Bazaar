'use strict';

angular.module('ecommerce')

    .component('ecomHeader', {
        templateUrl: 'src/components/ecomHeader/ecomHeader.html',
        controller: ['$window', '$rootScope', '$scope', '$location', 'LocalStorage', 'QueryService', 'SweetAlert', function ($window, $rootScope, $scope, $location, LocalStorage, QueryService, SweetAlert) {

            $rootScope.CATEGORIES = [];
            $scope.search = {keyword: ''};
            angular.extend($scope.search, $location.search());

            // update mini cart
            $rootScope.$watch('CART_PRODUCTS', function() {
                var productQty = 0;
                var productTotal = 0;

                angular.forEach($rootScope.CART_PRODUCTS, function(product, key) {
                    productQty += product.quantity;
                    productTotal += product.quantity * product.mrp;
                });

                $rootScope.PRODUCT_QTY = productQty;
                $rootScope.PRODUCT_TOTAL = productTotal;
            }, true);


            // fetch categories
            QueryService.query('GET', 'OrderDB/GetAllCategory', {}, {}).then(function (data){
                $rootScope.CATEGORIES = data.data;

                setTimeout(function() {
                    $('.select_option').niceSelect();
                }, 100);
            }).catch(function (response) {

            });

            $scope.removeCartProduct = function (product) {
                var index = $rootScope.CART_PRODUCTS.indexOf(product);
                $rootScope.CART_PRODUCTS.splice(index, 1);
                LocalStorage.update('cart_products', $rootScope.CART_PRODUCTS);
            };

            $scope.productSearch = function () {
                if($scope.search.keyword.length > 2) {
                    $location.path('/catalog/search').search($scope.search);
                } else {
                    SweetAlert.swal("Failed", "Please enter search keyword with at least 3 character", "warning");
                }
            };

            $scope.logout = function () {
                LocalStorage.remove('access_token');
                LocalStorage.remove('user');
                $rootScope.USER = {};

                $window.location.href = '/';
            };
        }]
    });