angular.module("clean").controller "IndexController", ["$scope", "Global", ($scope, Global) ->
  $scope.global = Global
]
