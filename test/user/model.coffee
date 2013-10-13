###
Module dependencies.
###
should = require("should")
app = require("../../server")
mongoose = require("mongoose")
User = mongoose.model("User")

#Globals
user = undefined

#The tests
describe "<Unit Test>", ->
	describe "Model User:", ->
		before (done) ->
			user = new User(
				name: "Full name"
				email: "test@test.com"
				username: "user"
				password: "password"
			)
			done()

		describe "Method Save", ->
			it "should be able to save whithout problems", (done) ->
				user.save (err) ->
					should.not.exist err
					done()


			it "should be able to show an error when try to save witout name", (done) ->
				user.name = ""
				user.save (err) ->
					should.exist err
					done()



		after (done) ->
			done()


