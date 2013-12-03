###
Module dependencies.
###
should = require("should")
app = require("../../server")
mongoose = require("mongoose")
User = mongoose.model("User")
Article = mongoose.model("Article")

#Globals
user = undefined
article = undefined

#The tests
describe "Model Article:", ->
  beforeEach (done) ->
    user = new User(
      name: "Full name"
      email: "test@test.com"
      username: "user"
      password: "password"
    )
    user.save (err) ->
      article = new Article(
        title: "Article Title"
        content: "Article Content"
        user: user
      )
      done()

  describe "Method Save", ->
    it "should save", (done) ->
      article.save (err) ->
        should.not.exist err
        done()

    it "should not save without title", (done) ->
      article.title = ""
      article.save (err) ->
        should.exist err
        done()