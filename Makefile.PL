#!/usr/bin/perl

use 5.005;
use inc::Module::Install;

author		('Autrijus Tang <autrijus@autrijus.org>');
abstract	('Use other catalog formats in Maketext');
name		('Locale-Maketext-Lexicon');
version_from	('lib/Locale/Maketext/Lexicon.pm',);
license		('perl');
install_script	('script/xgettext.pl');
requires	(
    'Test::More'	=> '0.01',
    'Locale::Maketext'	=> '0.01',
);

WriteAll( sign => 1 );
