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
describe "<Unit Test>", ->
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
			it "should be able to save whithout problems", (done) ->
				article.save (err) ->
					should.not.exist err
					done()


			it "should be able to show an error when try to save witout title", (done) ->
				article.title = ""
				article.save (err) ->
					should.exist err
					done()



		afterEach (done) ->
			done()


