window.app = angular.module("clean", ["ngCookies", "ngResource", "ui.bootstrap", "ui.route", "clean.system", "clean.articles"])
angular.module "clean.system", []
angular.module "clean.articles", []

#Setting up route
window.app.config ["$routeProvider", ($routeProvider) ->
  $routeProvider
  .when "/articles",
    templateUrl: "views/articles/list.html"
  .when "/articles/create",
    templateUrl: "views/articles/create.html"
  .when "/articles/:articleId/edit",
    templateUrl: "views/articles/edit.html"
  .when "/articles/:articleId",
    templateUrl: "views/articles/view.html"
  .when "/",
    templateUrl: "views/index.html"
  .otherwise redirectTo: "/"
]

window.app.config ["$locationProvider", ($locationProvider) ->
]

app.run ($rootScope) ->
  $rootScope.account = window.account

$(document).ready ->
  window.location.hash = ""  if window.location.hash is "#_=_" # Fixing facebook bug with redirect
  angular.bootstrap document, ["clean"] # Initialize the app