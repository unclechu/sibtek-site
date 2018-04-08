#!/usr/bin/env perl6
use v6.c;
use Terminal::ANSIColor;

sub sha256(Str $str) of Str {
	with run 'sha256sum', :in, :out {
		.in.print: $str;
		.in.close;
		return .out.get.split(/\s+/, :skip-empty)[0];
	}
}

sub base64(Str $str) of Str {
	with run <base64 -w 0>, :in, :out {
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

enum Action <All NoHeader Standard SignIn GetPublicSalt>;

sub do-action(Action $action, Int $port, Str $host --> Int) {
	say "~~~~~\nDoing action " ~ (color('bold') ~ $action ~ RESET) ~ "…\n";
	my Str $showAction = color('bold white on_cyan') ~ $action ~ RESET;

	my Int $result = do given $action {
		when NoHeader {
			run(Q:w<curl --fail>, "http://$host:$port/admin", '--verbose').exitcode;
		}

		when Standard {
			my Str $h := gen-auth-header sha256('public'), sha256('private');
			run(Q:w<curl --fail>, "http://$host:$port/admin", Q:w<--verbose -H>, $h).exitcode
		}

		when SignIn {
			run(
				Q:w<curl --fail>, "http://$host:$port/admin/api/account/sign-in", '--verbose'
			).exitcode
		}

		when GetPublicSalt {
			run(
				Q:w<curl --fail>, "http://$host:$port/admin/api/account/get-public-salt",
				Q:w<--verbose -X POST>,
				'-H', 'Content-Type: application/json',
				'-d', '{"username": "ananon"}',
			).exitcode
		}

		default {
			say (color('bold white on_red') ~ 'Unknown action' ~ RESET) ~ ": $showAction";
			exit 1
		}
	};

	my $failure-mark = $result == 0
		?? (color('bold white on_green') ~ "[SUCCESS $result]" ~ RESET)
		!! (color('bold white on_red') ~ "[ERROR $result]" ~ RESET);

	"\n… $failure-mark end of doing action $showAction …\n~~~~~".say;
	$result
}

sub MAIN(Action :a(:$action) = All, Int :$port = 8081, Str :$host = '127.0.0.1') {
	if $action == All {
		my Int %result;
		%result{$_} = do-action $_, $port, $host for [NoHeader, Standard, SignIn, GetPublicSalt];

		'Summary: '.say;

		for %result.kv -> $k, $v {
			say '  ' ~ (color('bold white on_cyan') ~ $k ~ RESET) ~ ': ' ~ (
				$v == 0
					?? (color('bold white on_green') ~ "[SUCCESS $v]")
					!! (color('bold white on_red') ~ "[ERROR $v]")
			) ~ RESET
		}
	} else {
		exit do-action $action, $port, $host
	}
}
