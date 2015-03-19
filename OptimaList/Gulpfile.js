/// <vs SolutionOpened='default' />
var gulp = require('gulp'),
    $ = require('gulp-load-plugins')();


gulp.task('js', [], function(){
    gulp.src(['Client/Scripts/main.js','Client/Scripts/*.js'])
    .pipe($.plumber())
    .pipe($.concat('app.js'))
    .pipe(gulp.dest('Scripts'));
});

gulp.task("default", ['js'], function(){
    console.log("howdy y'all");
    gulp.watch(['Client/Scripts/*.js'], ['js']);
});

