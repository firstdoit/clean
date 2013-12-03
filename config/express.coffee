###
Module dependencies.
###
express = require("express")
mongoStore = require("connect-mongo")(express)
flash = require("connect-flash")
dustjs = require("adaro")
harp = require("harp")
_ = require("underscore")

module.exports = (app, passport, config) ->
  # express/mongo session storage
  session =
    secret: config.secret
    store: new mongoStore(
      url: config.db
      collection: "sessions"
    )

  compressOptions =
    filter: (req, res) ->
      (/json|text|javascript|css/).test res.getHeader("Content-Type")
    level: 9

  cacheHandler = (req, res, next) ->
    if /\.js|\.css|\.woff/.test(req.url)
      res.header "Cache-Control", "public"
      res.header "Expires", new Date(Date.now() + 31536000000).toUTCString()
    next()

  wwwRedirectHandler = (req, res, next) ->
    if req.headers.host.match(/^www\..*/i)
      res.redirect(301, req.protocol + '://' + req.headers.host.replace('www\.', ''))
    else
      next()

  booleanQueryParser = (req, res, next) ->
    req.query[key] = (value is 'true') for key, value of req.query when value in ['true', 'false']
    next()

  localsHandler = (req, res, next) ->
    res.locals.version = config.version
    res.locals.user = if req.user then JSON.stringify(_.pick(req.user, "provider", "name", "email", "_id")) else JSON.stringify(null)
    res.locals.development = (process.env.NODE_ENV isnt 'production')
    res.locals.production = (process.env.NODE_ENV is 'production')
    next()

  errorHandler = (err, req, res, next) ->
    #Log it
    console.error err.stack
    #Error page
    res.status(500).render "error",
      error: err.stack
      httpStatus: "500"
      layout: false

  notFoundHandler = (req, res) ->
    res.status(404).render "error",
      url: req.originalUrl
      error: "Not found"
      httpStatus: "404"
      layout: false

  app.enable "jsonp callback" # Enable jsonp
  app.set "showStackError", true
  app.set "views", "app/views" # Set views path
  app.engine "dust", dustjs.dust(layout: "layout")
  app.set "view engine", "dust" # Set template engine
  app.use wwwRedirectHandler # Redirect www to no-www
  app.use cacheHandler # Enable cache for 1 year
  app.use express.compress compressOptions # Should be before express.static
  app.use express.favicon() # Setting the fav icon and static folder
  app.use express.static(config.root + "/public")
  app.use express.static(config.root + "/public/compiled") if process.env.NODE_ENV is "production"
  app.use harp.mount(config.root + "/public") if process.env.NODE_ENV isnt "production"
  app.use express.logger("dev") if process.env.NODE_ENV isnt "test"
  app.use booleanQueryParser # Parse Booleans in req.query
  app.use express.cookieParser() # cookieParser should be above session
  app.use express.bodyParser() # bodyParser should be above methodOverride
  app.use express.methodOverride()
  app.use express.session session
  app.use flash() # connect flash for flash messages
  app.use passport.initialize()
  app.use passport.session() # use passport session
  app.use localsHandler
  passport.setupRoutes()
  app.use app.router # routes should be the last
  app.use errorHandler # Treat errors thrown by any middleware
  app.use notFoundHandler # Assume 404 since no middleware responded