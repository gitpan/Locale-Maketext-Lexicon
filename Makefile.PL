#!/usr/bin/perl
# $File: //member/autrijus/Locale-Maketext-Lexicon/Makefile.PL $ $Author: autrijus $
# $Revision: #7 $ $Change: 8355 $ $DateTime: 2003/10/09 18:01:40 $

require 5.005;

use ExtUtils::MakeMaker;

# workaround weird bug that prevents R::C from being detected by MM.
eval { require Regexp::Common };

WriteMakefile(
    AUTHOR		=> 'Autrijus Tang (autrijus@autrijus.org)',
    ABSTRACT		=> 'Use other catalog formats in Maketext',
    NAME		=> 'Locale::Maketext::Lexicon',
    VERSION_FROM	=> 'lib/Locale/Maketext/Lexicon.pm', 
    DISTNAME		=> 'Locale-Maketext-Lexicon',
    BINARY_LOCATION	=> 'x86/Locale-Maketext-Lexicon.tar.gz',

    EXE_FILES		=> [ 'script/xgettext.pl' ],
    PREREQ_PM		=> {
	'Test::More'		=> '0.01',
	'Locale::Maketext'	=> '0.01',
	'Regexp::Common'	=> '0.01',
	'Pod::Usage'		=> '0.01',
    },

    dist		=> {
	DIST_DEFAULT	=> 'all metafile sign tardist',
        COMPRESS	=> 'gzip -9',
        SUFFIX		=> '.gz',
    },
);

sub MY::postamble {
  q{
sign ::
	cpansign -s
}
}
