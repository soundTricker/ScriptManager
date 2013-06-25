'use strict';
var mountFolder = function (connect, dir) {
  return connect.static(require('path').resolve(dir));
};

module.exports = function (grunt) {
  // load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  // configurable paths
  var scriptManagerconfig = {
    app: 'app',
    dist: 'dist',
    test: 'test'
  };
  grunt.initConfig({
    gasgithub: scriptManagerconfig,
    watch: {
      coffee: {
        files: ['<%= gasgithub.app %>/{,*/}*.coffee'],
        tasks: ['coffee:dist']
      },
      test: {
        files: ['<%= gasgithub.test %>/{,*/}*.coffee'],
        tasks: ['coffee:test']
      }

    },
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
            '.tmp',
            '<%= gasgithub.dist %>/*',
            '!<%= gasgithub.dist %>/.git*'
          ]
        }]
      },
      test: {
        files: [{
          dot: true,
          src: [
            '.testtmp',
            '<%= gasgithub.dist %>/*',
            '!<%= gasgithub.dist %>/.git*'
          ]
        }]
      },
      server: '.tmp'
    },
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      all: [
        'Gruntfile.js',
        '<%= gasgithub.app %>/{,*/}*.js'
      ]
    },
    coffee: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= gasgithub.app %>/',
          src: '{,*/}*.coffee',
          dest: '.tmp',
          ext: '.js'
        }]
      },
      test: {
        files: [{
          expand: true,
          cwd: '<%= gasgithub.test %>/',
          src: '{,*/}*.coffee',
          dest: '.testtmp',
          ext: '.js'
        }]
      }
    },
    concat: {
      dist: {
        files: {
          '<%= gasgithub.dist %>/scripts.js': [
            '.tmp/*.js',
            '.tmp/*/*.js',
            '<%= gasgithub.app %>/{,*/}*.js'
          ]
        }
      },
      test:{
        files: {
          '<%= gasgithub.dist %>/specs.js': [
            '.testtmp/{,*/}*.js',
            '<%= gasgithub.test %>/{,*/}*.js'
          ]
        }
      }
    },
    uglify: {
      dist: {
        files: {
          '<%= gasgithub.dist %>/scripts.js': [
            '<%= gasgithub.dist %>/scripts.js'
          ]
        }
      }
    },
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= gasgithub.app %>',
          dest: '<%= gasgithub.dist %>',
          src: [
            '*.{ico,txt}',
            '.htaccess',
            'components/**/*',
            'images/{,*/}*.{gif,webp}',
            'styles/fonts/*'
          ]
        }]
      }
    }
  });
  grunt.renameTask('regarde', 'watch');

  grunt.registerTask('build', [
    'clean:dist',
    'coffee',
    'concat',
    'copy'
  ]);
  grunt.registerTask('test', [
    'clean:test',
    'coffee:test',
    'concat:test'
  ]);

  grunt.registerTask('default', ['build']);
};
