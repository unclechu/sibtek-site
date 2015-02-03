#
# @author Andrew Fatkulin
# @license MIT
#

require! {
	gulp
	\gulp-livescript
	path
}

src-dir = path.join process.cwd!, \server, \src

gulp.task \ls !->
	gulp
		.src <[src/**/*.ls]>
		.pipe gulp-livescript bare: true
		.pipe gulp.dest \application

gulp.task \watch !->
	gulp
		.watch <[src/**/*.ls]>, [\ls]

gulp.task \default [\ls]
