module.exports = (grunt) ->

  pkg = grunt.file.readJSON('package.json')

  # Project Configuration
  grunt.initConfig
    watch:
      public:
        files: ['public/**']
        options:
          livereload: true

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
        tasks: ['nodemon', 'watch']
        options:
          logConcurrentOutput: true
          limit: 2

  #Load NPM tasks
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

  grunt.registerTask "default", ["concurrent"]
  grunt.registerTask "test", ["mochaTest"]