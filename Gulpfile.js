var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'),
    $ = require('gulp-load-plugins')();

gulp.task('sass', [], function() {
    gulp.src('client/sass/main.scss')
    .pipe($.plumber())
    .pipe($.sass())
    .pipe(gulp.dest('optimaList/static/optimaList/content'));
});

gulp.task('js', [], function(){
    gulp.src(['client/scripts/main.js','client/scripts/*.js'])
    .pipe($.plumber())
    .pipe($.concat('app.js'))
    .pipe(gulp.dest('optimaList/static/optimaList/content'));
});

gulp.task("default", ['js', 'sass'], function(){
    console.log("howdy y'all");
    gulp.watch(['client/scripts/*.js'], ['js']);
    gulp.watch(['client/sass/*.scss'], ['sass']);
});

