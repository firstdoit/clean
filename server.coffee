###
Module dependencies.
###
express = require 'express'
fs = require 'fs'
passport = require 'passport'
logger = require 'mean-logger'
path = require 'path'
mongoose = require 'mongoose'
_ = require 'underscore'
glob = require 'glob'
pkg = require './package.json'

###
Main application entry file.
Please note that the order of loading is important.
###

# Default configurations, extended by options provided in config/env files
defaultConfig =
  root: path.normalize '.'
  port: if process.env.NODE_ENV is 'production' then 80 else 3000
  db: process.env.MONGOHQ_URL
  secret: process.env.SECRET or 'CLEAN'
  env: process.env.NODE_ENV or 'development'
  version: pkg.version

config = _.extend(defaultConfig, require("./config/env/#{defaultConfig.env}.json") or {})
app = express() # Create your express app
db = mongoose.connect(config.db) # Bootstrap db connection

# Bootstrap models
require(file) for file in glob.sync './app/**/*-model.coffee'
require('./config/auth') app, passport, config # Bootstrap passport config and auth rules
require('./config/express') app, passport, config # Express settings
require('./config/routes') app, passport # Bootstrap routes

# Start the app
app.listen config.port
console.log "App started on port #{config.port} with environment #{config.env}"

# Initializing logger
logger.init app, passport, mongoose

exports = module.exports = app

# Kick in livereload by creating a file in the public dir
fs.writeFile('./public/livereload', new Date())