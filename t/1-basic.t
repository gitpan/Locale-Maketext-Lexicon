#!/usr/bin/perl -w
# $File: //member/autrijus/Acme-ComeFrom/t/1-basic.t $ $Author: autrijus $
# $Revision: #4 $ $Change: 3587 $ $DateTime: 2002/03/29 13:59:48 $

use strict;
use Test::More tests => 5;

package Hello::L10N;
use Test::More;

use_ok(base => 'Locale::Maketext');
use_ok('Locale::Maketext::Lexicon' => {de => [Gettext => \*::DATA]});

package main;
ok(my $lh = Hello::L10N->get_handle('de'), 'get_handle');
is($lh->maketext('Hello, World!'), 'Hallo, Welt!', 'maketext');
is($lh->maketext('__Content-Type'), 'text/plain; charset=big5', 'metadata');

__DATA__
msgid ""
msgstr ""
"Project-Id-Version: RT 2.1.7\n"
"POT-Creation-Date: 2002-05-02 11:36+0800\n"
"PO-Revision-Date: 2002-05-13 02:00+0800\n"
"Last-Translator: Whiteg Weng <whiteg@elixus.org>\n"
"Language-Team: Chinese <contact@ourinet.com>\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=big5\n"
"Content-Transfer-Encoding: 8bit\n"

#: Hello.pm:10
msgid "Hello, World!"
msgstr "Hallo, Welt!"
