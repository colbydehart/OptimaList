var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'),
    $ = require('gulp-load-plugins')();

gulp.task('sass', [], function() {
    gulp.src('Client/Sass/main.scss')
    .pipe($.plumber())
    .pipe($.sass())
    .pipe(gulp.dest('Content'));
});

gulp.task('js', [], function(){
    gulp.src(['Client/Scripts/main.js','Client/Scripts/*.js'])
    .pipe($.plumber())
    .pipe($.concat('app.js'))
    .pipe(gulp.dest('Scripts'));
});

gulp.task("default", ['js', 'sass'], function(){
    console.log("howdy y'all");
    gulp.watch(['Client/Scripts/*.js'], ['js']);
    gulp.watch(['Client/Sass/*.scss'], ['sass']);
});

