module.exports = (grunt) ->

  pkg = grunt.file.readJSON('package.json')

  # Project Configuration
  grunt.initConfig
    watch:
      options:
        livereload: true

      client:
        files: ['public/**/*.*']

    mochaTest:
      test:
        options:
          reporter: 'spec'
        src: ['test/**/*.coffee']

    nodemon:
      main:
        options:
          file: 'server.coffee'
          ignoredFiles: ['node_modules/**', '.idea/**', 'public/**']

    concurrent:
      tasks: ['nodemon', 'watch']
      options:
        logConcurrentOutput: true

  #Load NPM tasks
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

  grunt.registerTask "default", ["concurrent"]
  grunt.registerTask "test", ["mochaTest"]
