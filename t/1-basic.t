#!/usr/bin/perl -w
# $File: //member/autrijus/Locale-Maketext-Lexicon/t/1-basic.t $ $Author: autrijus $
# $Revision: #2 $ $Change: 339 $ $DateTime: 2002/07/16 02:53:47 $

use strict;
use Test::More tests => 15;

package Hello::L10N;
use Test::More;
use Tie::Hash;

use_ok(base => 'Locale::Maketext');
use_ok(
    'Locale::Maketext::Lexicon' => {
	en => ['Auto'],
	de => ['Gettext' => \*::DATA],
	fr => ['Tie' => [ 'Tie::StdHash' ]],
	zh_tw => ['Gettext' => 't/messages.mo'],
    }
);

package main;

################################################################

ok(my $lh = Hello::L10N->get_handle('en'), 'Auto - get_handle');

is(
    $lh->maketext('Heute die Welt'),
    'Heute die Welt',
    'Auto - autofilling'
);

################################################################

ok($lh = Hello::L10N->get_handle('de'), 'Gettext - get_handle');

is(
    $lh->maketext('Hello, World!'),
    'Hallo, Welt!',
    'Gettext - simple case'
);
is(
    $lh->maketext('You have [*,_1,piece] of mail.', 10),
    'Sie haben 10 Poststuecken.',
    'Gettext - complex case'
);
is(
    $lh->maketext('[_1] [_2] [_*]', 1, 2, 3),
    '123 2 1',
    'Gettext - asterisk interpoliation'
);
is(
    $lh->maketext('[_1]()', 10),
    '10()',
    'Gettext - correct parens'
);
is(
    $lh->maketext('__Content-Type'),
    'text/plain; charset=ISO-8859-1',
    'Gettext - metadata'
);

################################################################

ok($lh = Hello::L10N->get_handle('zh_tw'), 'Gettext - get_handle');

is(
    $lh->maketext('This is a test'),
    '³o¬O´ú¸Õ',
    'Gettext - MO File'
);

################################################################

ok($lh = Hello::L10N->get_handle('fr'), 'Tie - get_handle');
$Hello::L10N::fr::Lexicon{"Good morning"} = 'Bon jour';
$Hello::L10N::fr::Lexicon{"Good morning, [_1]"} = 'Bon jour, [_1]';

is(
    $lh->maketext('Good morning'),
    'Bon jour',
    'Tie - simple case'
);

is(
    $lh->maketext('Good morning, [_1]', 'Sean'),
    'Bon jour, Sean',
    'Tie - complex case'
);

__DATA__
msgid ""
msgstr ""
"Project-Id-Version: Test App 0.01\n"
"POT-Creation-Date: 2002-05-02 11:36+0800\n"
"PO-Revision-Date: 2002-05-13 02:00+0800\n"
"Last-Translator: <autrijus@autrijus.org>\n"
"Language-Team: German <autrijus@autrijus.com>\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=ISO-8859-1\n"
"Content-Transfer-Encoding: 8bit\n"

#: Hello.pm:10
msgid "Hello, World!"
msgstr "Hallo, Welt!"

#: Hello.pm:11
msgid "You have %*(%1,piece) of mail."
msgstr "Sie haben %*(%1,Poststueck,Poststuecken)."

#: Hello.pm:12
msgid "%1()"
msgstr "%1()"

#: Hello.pm:13
msgid "%1 %2 %*"
msgstr "%* %2 %1"
