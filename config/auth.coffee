mongoose = require("mongoose")
LocalStrategy = require("passport-local").Strategy
TwitterStrategy = require("passport-twitter").Strategy
FacebookStrategy = require("passport-facebook").Strategy
GitHubStrategy = require("passport-github").Strategy
GoogleStrategy = require("passport-google-oauth").Strategy
User = mongoose.model("User")
users = require("../app/user/user-controller")

module.exports = (app, passport, config) ->
  passport.auth =
    #	Generic require login routing middleware
    requiresLogin: (req, res, next) ->
      return res.send(401, "User is not authorized")  unless req.isAuthenticated()
      next()

    #	User authorizations routing middleware
    user:
      hasAuthorization: (req, res, next) ->
        return res.send(401, "User is not authorized")  unless req.profile.id is req.user.id
        next()

    #	Article authorizations routing middleware
    article:
      hasAuthorization: (req, res, next) ->
        return res.send(401, "User is not authorized")  unless req.article.user.id is req.user.id
        next()

  #Serialize sessions
  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findOne
      _id: id
    , (err, user) ->
      done err, user

  ###
  Passport Strategies initialization
  ###

  #Use local strategy
  passport.use new LocalStrategy(
    usernameField: "email"
    passwordField: "password"
  , (email, password, done) ->
    User.findOne
      email: email
    , (err, user) ->
      return done(err)  if err
      unless user
        return done(null, false,
          message: "Unknown user"
        )
      unless user.authenticate(password)
        return done(null, false,
          message: "Invalid password"
        )
      done null, user
  )

  #Use twitter strategy
  passport.use new TwitterStrategy(
    consumerKey: config.twitter.clientID
    consumerSecret: config.twitter.clientSecret
    callbackURL: config.twitter.callbackURL
  , (token, tokenSecret, profile, done) ->
    User.findOne
      "twitter.id_str": profile.id
    , (err, user) ->
      return done(err)  if err
      unless user
        user = new User(
          name: profile.displayName
          username: profile.username
          provider: "twitter"
          twitter: profile._json
        )
        user.save (err) ->
          console.log err  if err
          done err, user

      else
        done err, user
  )

  #Use facebook strategy
  passport.use new FacebookStrategy(
    clientID: config.facebook.clientID
    clientSecret: config.facebook.clientSecret
    callbackURL: config.facebook.callbackURL
  , (accessToken, refreshToken, profile, done) ->
    User.findOne
      "facebook.id": profile.id
    , (err, user) ->
      return done(err)  if err
      unless user
        user = new User(
          name: profile.displayName
          email: profile.emails[0].value
          username: profile.username
          provider: "facebook"
          facebook: profile._json
        )
        user.save (err) ->
          console.log err  if err
          done err, user

      else
        done err, user
  )

  #Use github strategy
  passport.use new GitHubStrategy(
    clientID: config.github.clientID
    clientSecret: config.github.clientSecret
    callbackURL: config.github.callbackURL
  , (accessToken, refreshToken, profile, done) ->
    User.findOne
      "github.id": profile.id
    , (err, user) ->
      unless user
        user = new User(
          name: profile.displayName
          email: profile.emails[0].value
          username: profile.username
          provider: "github"
          github: profile._json
        )
        user.save (err) ->
          console.log err  if err
          done err, user

      else
        done err, user
  )

  #Use google strategy
  passport.use new GoogleStrategy(
    consumerKey: config.google.clientID
    consumerSecret: config.google.clientSecret
    callbackURL: config.google.callbackURL
  , (accessToken, refreshToken, profile, done) ->
    User.findOne
      "google.id": profile.id
    , (err, user) ->
      unless user
        user = new User(
          name: profile.displayName
          email: profile.emails[0].value
          username: profile.username
          provider: "google"
          google: profile._json
        )
        user.save (err) ->
          console.log err  if err
          done err, user

      else
        done err, user
  )

  ###
  Authentication Routes
  ###

  passport.setupRoutes = ->
    #Setting the facebook oauth routes
    app.get "/auth/facebook", passport.authenticate("facebook",
      scope: ["email", "user_about_me"]
      failureRedirect: "/signin"
    ), users.signin
    app.get "/auth/facebook/callback", passport.authenticate("facebook",
      failureRedirect: "/signin"
    ), users.authCallback

    #Setting the github oauth routes
    app.get "/auth/github", passport.authenticate("github",
      failureRedirect: "/signin"
    ), users.signin
    app.get "/auth/github/callback", passport.authenticate("github",
      failureRedirect: "/signin"
    ), users.authCallback

    #Setting the twitter oauth routes
    app.get "/auth/twitter", passport.authenticate("twitter",
      failureRedirect: "/signin"
    ), users.signin
    app.get "/auth/twitter/callback", passport.authenticate("twitter",
      failureRedirect: "/signin"
    ), users.authCallback

    #Setting the google oauth routes
    app.get "/auth/google", passport.authenticate("google",
      failureRedirect: "/signin"
      scope: ["https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/userinfo.email"]
    ), users.signin
    app.get "/auth/google/callback", passport.authenticate("google",
      failureRedirect: "/signin"
    ), users.authCallback

