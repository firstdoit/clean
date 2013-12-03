window.app = angular.module("clean", ["ngCookies", "ngResource", "ngRoute", "pascalprecht.translate",
                                      "ui.bootstrap", "ngAnimate", "clean.articles"])
angular.module "clean.articles", []

app.factory "Global", [=>
  @_data =
    user: window.user
    authenticated: !!window.user
    env: window.env
  @_data
]

#Setting up route
app.config ($routeProvider) ->
  $routeProvider
  .when "/articles",
      templateUrl: "views/articles/list.html"
  .when "/articles/create",
      templateUrl: "views/articles/edit.html"
  .when "/articles/:articleId/edit",
      templateUrl: "views/articles/edit.html"
  .when "/articles/:articleId",
      templateUrl: "views/articles/view.html"
  .when "/",
      templateUrl: "views/index.html"
  .otherwise redirectTo: "/"

app.config ($translateProvider) ->
  $translateProvider.useStaticFilesLoader
    prefix: 'locale/'
    suffix: '.json'
  $translateProvider.preferredLanguage 'pt'

app.run ($rootScope) ->
  console.log "Hello, there."

angular.element(document).ready ->
  window.location.hash = ""  if window.location.hash is "#_=_" # Fixing facebook bug with redirect
  angular.bootstrap document, ["clean"] # Initialize the app
