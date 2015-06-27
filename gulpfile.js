'use strict';

var
	colors     = require('colors'),
	gulp       = require('gulp'),
	del        = require('del'),
	livescript = require('gulp-livescript'),
	watch      = require('gulp-watch'),
	plumber    = require('gulp-plumber'),
	gutil      = require('gulp-util'),
	sourcemaps = require('gulp-sourcemaps');


gulp.task('clean-server', function (cb) {
	del(['server/build'], cb);
});

function serverTask(isWatcher, cb) {
	
	gulp.src(['server/src/**/*.ls'])
		.pipe(isWatcher ? watch('server/src/**/*.ls') : gutil.noop())
		.pipe(plumber({
			errorHanlder: function (err) {
				console.error('Error:'.red, err.stack || err);
				this.emit('end');
			},
		}))
		.pipe(sourcemaps.init())
		.pipe(livescript({ bare: true }))
		.pipe(sourcemaps.write())
		.pipe(gulp.dest('server/build'))
		.on('finish', cb);
}

gulp.task('server', ['clean-server'], function (cb) {
	serverTask(false, cb);
});

gulp.task('server-watch', function (cb) {
	serverTask(true, cb);
});

gulp.task('watch', ['server-watch']);

gulp.task('default', ['server']);
