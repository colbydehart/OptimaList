var gulp = require('gulp'),
    $ = require('gulp-load-plugins')();

var paths = {
    js: ['client/scripts/main.js', 'client/scripts/*.js'],
    sass: ['client/sass/main.scss']
};

gulp.task('sass', [], function() {
    gulp.src(paths.sass)
    .pipe($.plumber())
    .pipe($.sass())
    .pipe(gulp.dest('ol/static/ol/'));
});

gulp.task('js', [], function(){
    gulp.src(paths.js)
    .pipe($.plumber())
    .pipe($.concat('app.js'))
    .pipe(gulp.dest('ol/static/ol'));
});

gulp.task("default", ['js', 'sass'], function(){
    console.log("gulp y'all");
    gulp.watch(paths.js, ['js']);
    gulp.watch(paths.sass, ['sass']);
});
