#!/usr/bin/perl
# $File: //member/autrijus/Locale-Maketext-Lexicon/Makefile.PL $ $Author: autrijus $
# $Revision: #3 $ $Change: 340 $ $DateTime: 2002/07/16 03:18:58 $

require 5.005;

use ExtUtils::MakeMaker;

WriteMakefile(
    AUTHOR		=> 'Autrijus Tang (autrijus@autrijus.org)',
    ABSTRACT		=> 'Use other catalog formats in Maketext',
    NAME		=> 'Locale::Maketext::Lexicon',
    VERSION_FROM	=> 'lib/Locale/Maketext/Lexicon.pm', 
    DISTNAME		=> 'Locale-Maketext-Lexicon',
    BINARY_LOCATION	=> 'x86/Locale-Maketext-Lexicon.tar.gz',

    EXE_FILES		=> [ 'bin/xgettext.pl' ],
    PREREQ_PM		=> {
	'Test::More'		=> '0.01',
	'Locale::Maketext'	=> '0.01',
	'Regexp::Common'	=> '0.01',
    },

    dist		=> {
        COMPRESS	=> 'gzip',
        SUFFIX		=> '.gz',
    },
);

