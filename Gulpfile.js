var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'),
    $ = require('gulp-load-plugins')();

paths = {
    js: [
            'client/vendor/jquery/dist/jquery.js',
            'client/vendor/bootstrap/dist/js/bootstrap.js',
            'client/vendor/lodash/dist/lodash.js',
            'client/vendor/angular/angular.js',
            'client/vendor/angular-route/angular-route.js',
            'client/vendor/restangular/dist/restangular.js',
            'client/vendor/angular-local-storage/dist/angular-local-storage.js',
            'client/scripts/main.js',
            'client/scripts/*.js'
        ],
    sass: 'client/sass/main.scss'
};

gulp.task('sass', [], function() {
    gulp.src(paths.sass)
    .pipe($.plumber())
    .pipe($.sass())
    .pipe(gulp.dest('optimaList/static/optimaList/content'));
});

gulp.task('js', [], function(){
    gulp.src(paths.js)
    .pipe($.plumber())
    .pipe($.concat('app.js'))
    .pipe(gulp.dest('optimaList/static/optimaList/content'));
});

gulp.task("default", ['js', 'sass'], function(){
    console.log("howdy y'all");
    gulp.watch(['client/scripts/*.js'], ['js']);
    gulp.watch(['client/sass/*.scss'], ['sass']);
});

