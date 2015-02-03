#
# @author Andrew Fatkulin
# @license MIT
#

require! {
	gulp
	\gulp-livescript
}


do
	<-! gulp.task \ls
	gulp
		.src <[src/*.ls src/*/*.ls src/*/*/*.ls]>
		.pipe gulp-livescript bare: true
		.pipe gulp.dest \application

do
	<-! gulp.task \watch
	gulp
		.watch <[src/*.ls src/*/*.ls src/*/*/*.ls]>, [\ls]
