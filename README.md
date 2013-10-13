# CLEAN Stack

CLEAN is an opinionated [MEAN](http://www.mean.io/) fork which uses
CoffeeScript and LESS while providing a simpler organization and less files.
Furthermore, it prefers a model-based folder structure (instead of `models/` and `controllers/` folders).

We use Grunt for managing your server lifecycle, but not compiling.
Instead, for this, we use the incredible [Harp](http://harpjs.com/) middleware.
It automatically compiles Coffee, LESS and much more, upon browser request.


## Prerequisites
* Node.js - Download and Install [Node.js](http://www.nodejs.org/download/). You can also follow [this gist](https://gist.github.com/isaacs/579814) for a quick and easy way to install Node.js and npm
* MongoDB - Download and Install [MongoDB](http://www.mongodb.org/downloads) - Make sure it's running on the default port (27017).


## Quick Install

    $ npm install
    $ grunt

Then open a browser and go to:

    http://localhost:3000


## Configuration

Take a quick look at `server.coffee` and hopefully you'll learn everything there is to know about what is where.


## Questions

**Q: Why is `config/auth.coffee` separated? Why are there routes there?!?!?!**
**A:** Because you'll probably *not* fiddle around it much, and it is a
horrible, horrible boilerplate code which is, unfortunately, needed.
