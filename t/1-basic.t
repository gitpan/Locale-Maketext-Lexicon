#!/usr/bin/perl -w
# $File: //member/autrijus/Acme-ComeFrom/t/1-basic.t $ $Author: autrijus $
# $Revision: #4 $ $Change: 3587 $ $DateTime: 2002/03/29 13:59:48 $

use strict;
use Test::More tests => 4;

package Hello::L10N;
use Test::More;

use_ok(base => 'Locale::Maketext');
use_ok('Locale::Maketext::Lexicon' => {de => [Gettext => \*::DATA]});

package main;
ok(my $lh = Hello::L10N->get_handle('de'), 'get_handle');
is($lh->maketext('Hello, World!'), 'Hallo, Welt!', 'maketext');

__DATA__
#: Hello.pm:10
msgid "Hello, World!"
msgstr "Hallo, Welt!"
