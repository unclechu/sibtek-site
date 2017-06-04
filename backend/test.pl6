#!/usr/bin/env perl6
use v6.c;

sub sha256(Str $str) of Str {
	with run 'sha256sum', :in, :out {
		.in.print: $str;
		.in.close;
		return .out.get.split(/\s+/, :skip-empty)[0];
	}
}

sub base64(Str $str) of Str {
	with run Q:w<base64 -w 0>, :in, :out {
		.in.print: $str;
		.in.close;
		return .out.get;
	};
}

sub gen-auth-header(Str $public-token, Str $private-token) of Str {
	my Str $salt := sha256((9.rand.round for 1..128).join ~ '.' ~ DateTime.now);
	my Str $auth-data := "$public-token.$salt." ~ sha256($public-token ~ $salt ~ $private-token);
	'Authorization: Custom ' ~ base64($auth-data);
}

die 'At least one argument is required' if @*ARGS.elems == 0;

given @*ARGS[0] {
	when 'no-header' { run Q:w<curl http://localhost:8081/admin --verbose> }

	when 'standard' {
		my Str $h := gen-auth-header sha256('public'), sha256('private');
		run (Q:w<curl http://localhost:8081/admin --verbose -H>, $h);
	}

	when 'sign-in' { run (Q:w<curl http://localhost:8081/admin/api/account/signin --verbose>) }

	default { die "Unexpected argument: '$_'" }
}
