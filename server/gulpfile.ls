#
# @author Andrew Fatkulin
# @license MIT
#

require! {
	gulp
	\gulp-livescript
}

gulp.task \ls !->
	gulp
		.src <[server/src/**/*.ls]>
		.pipe gulp-livescript bare: true
		.pipe gulp.dest \server/application

gulp.task \watch !->
	gulp
		.watch <[server/src/**/*.ls]>, [\ls]

gulp.task \default [\ls]
