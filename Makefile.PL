#!/usr/bin/perl
# $File: //member/autrijus/Locale-Maketext-Lexicon/Makefile.PL $ $Author: autrijus $
# $Revision: #10 $ $Change: 9506 $ $DateTime: 2003/12/31 08:28:21 $

require 5.005;
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
    'Regexp::Common'	=> '0.01',
    'Pod::Usage'	=> '0.01',
);

# workaround weird bug that prevents R::C from being detected by MM.
eval { require Regexp::Common };

&WriteAll( sign => 1);
