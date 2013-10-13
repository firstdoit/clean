###
Module dependencies.
###
express = require("express")
mongoStore = require("connect-mongo")(express)
flash = require("connect-flash")
helpers = require("view-helpers")
harp = require("harp")
engine = require('ejs-locals')

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

  app.set "showStackError", true
  app.use express.compress compressOptions # Should be before express.static
  app.use express.favicon() # Setting the fav icon and static folder
  app.use express.static(config.root + "/public")
  app.use harp.pipeline(config.root + "/public")
  app.use express.logger("dev") if process.env.NODE_ENV isnt "test"
  app.set "views", config.root + "/app/views" # Set views path
  app.engine "ejs", engine
  app.set "view engine", "ejs" # Set template engine
  app.enable "jsonp callback" # Enable jsonp
  app.use express.cookieParser() # cookieParser should be above session
  app.use express.bodyParser() # bodyParser should be above methodOverride
  app.use express.methodOverride()
  app.use express.session session
  app.use flash() # connect flash for flash messages
  app.use helpers(config.app.name) # dynamic helpers
  app.use passport.initialize()
  app.use passport.session() # use passport session
  passport.setupRoutes()
  app.use app.router # routes should be the last

  # Assume "not found" in the error msgs is a 404.
  # this is somewhat silly, but valid,
  # you can do whatever you like, set properties, use instanceof etc.
  app.use (err, req, res, next) ->
    #Treat as 404
    return next()  if ~err.message.indexOf("not found")
    #Log it
    console.error err.stack
    #Error page
    res.status(500).render "500",
      error: err.stack

  #Assume 404 since no middleware responded
  app.use (req, res) ->
    res.status(404).render "404",
      url: req.originalUrl
      error: "Not found"
