#!/usr/bin/perl
# $File: //member/autrijus/Locale-Maketext/Makefile.PL $ $Author: autrijus $
# $Revision: #3 $ $Change: 2411 $ $DateTime: 2001/11/24 03:06:03 $

require 5.005;

use ExtUtils::MakeMaker;

WriteMakefile(
    AUTHOR		=> 'Autrijus Tang (autrijus@autrijus.org)',
    ABSTRACT		=> 'Use other catalog formats in Maketext',
    NAME		=> 'Locale::Maketext::Lexicon',
    VERSION_FROM	=> 'lib/Locale/Maketext/Lexicon.pm', 
    DISTNAME		=> 'Locale-Maketext-Lexicon',
    BINARY_LOCATION	=> 'x86/Locale-Maketext-Lexicon.tar.gz',

    PREREQ_PM       => {
	'Test::More'		=> '0.01',
	'Locale::Maketext'	=> '0.01',
    },

    dist		=> {
        COMPRESS	=> 'gzip',
        SUFFIX		=> '.gz',
    },
);

