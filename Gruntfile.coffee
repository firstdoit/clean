harp = require 'harp'
module.exports = (grunt) ->

  pkg = grunt.file.readJSON('package.json')

  # Project Configuration
  grunt.initConfig
    clean:
      ['public/compiled', 'public/livereload']

    watch:
      public:
        files: ['public/**']
        options:
          livereload: true
      test:
        files: ['test/**', 'app/**']
        tasks: ['mochaTest']

    mochaTest:
      main:
        options:
          reporter: 'spec'
        src: ['test/**/*.coffee']

    nodemon:
      main:
        options:
          file: 'server.coffee'
          ignoredFiles: ['node_modules/**', '.idea/**', 'public/**', '.git/**']
          watchedFolders: ['app', 'config']
          debug: true
          delayTime: 1

    concurrent:
      main:
        tasks: ['nodemon', 'watch:public']
        options:
          logConcurrentOutput: true
          limit: 2

    release:
      options:
        npm: false

  #Load NPM tasks
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

  grunt.registerTask "test-env", -> process.env.NODE_ENV = 'test'
  grunt.registerTask "default", ["clean", "concurrent"]
  grunt.registerTask "test", ["test-env", "mochaTest", "watch:test"]
  grunt.registerTask "dist", ["clean", "harp"]
  grunt.registerTask "harp", ->
    done = @async()
    harp.compile './public/script', '../compiled/script', (err) ->
      throw err if err
      harp.compile './public/style', '../compiled/style', (err2) ->
        throw err2 if err2
        done()