#!/usr/bin/perl
# $File: //member/autrijus/Locale-Maketext-Lexicon/bin/xgettext.pl $ $Author: autrijus $
# $Revision: #7 $ $Change: 2107 $ $DateTime: 2002/11/13 11:11:01 $

use strict;
use Getopt::Std;
use Pod::Usage;
use constant NUL  => 0;
use constant BEG  => 1;
use constant PAR  => 2;
use constant QUO1 => 3;
use constant QUO2 => 4;
use constant QUO3 => 5;

$::interop = 0; # whether to interoperate with GNU gettext

=head1 NAME

xgettext.pl - Extract gettext strings from source

=head1 SYNOPSIS

B<xgettext.pl> 

=head1 OPTIONS

Options supported at this moment:

     [ B<-u> ] Disables conversion from B<Maketext> format to
               B<Gettext> format -- i.e. it leaves all brackets alone.
               This is useful if you are also using the B<Gettext> syntax 
               in your program.

     [ B<-o> I<FILE> ] PO file name to be written or incrementally updated
                       C<-> means writing to F<STDOUT>.  If not specified,
                       F<messages.po> is used.

     [ I<INPUTFILE>... ]

=head1 DESCRIPTION

Extract translatable strings from given input files.

Currently accepts Perl source files (valid localization function
names include C<maketext>, C<loc>, C<x> and C<_>), B<HTML::Mason>
templates (C<E<lt>&|/lE<gt>...E<lt>/&E<gt>> or
C<E<lt>&|/locE<gt>...E<lt>/&E<gt>>), and Template Toolkit files
(C<[%|l%]...[%END%]> or C<[%|loc%]...[%END%]>).

=cut

my (%file, %Lexicon, %opts);
my ($PO, $out);

# options as above. Values in %opts
getopts('huo:', \%opts)
  or pod2usage( -verbose => 1, -exitval => 1 );
$opts{h} and pod2usage( -verbose => 2, -exitval => 0 );

$PO = $opts{o} || "messages.po";

@ARGV = ('-') unless @ARGV;

if (-r $PO) {
    open LEXICON, $PO or die $!;
    while (<LEXICON>) {
	if (1 .. /^$/) { $out .= $_; next }
    }
    close LEXICON;

    require Locale::Maketext::Lexicon::Gettext;
    %Lexicon = %{ Locale::Maketext::Lexicon::Gettext->parse($PO) };
}

open PO, ">$PO";
select PO;

undef $/;
foreach my $file (@ARGV) {
    my $filename = $file;
    open _, $file or die $!; $_ = <_>; $filename =~ s!^./!!;

    my $line = 1; pos($_) = 0;
    # Text::Template
    if (/^STARTTEXT$/m and /^ENDTEXT$/m) {
	require HTML::Parser;
	require Lingua::EN::Sentence;

	{
	    package MyParser;
	    @MyParser::ISA = 'HTML::Parser';
	    sub text {
		my ($self, $text, $is_cdata) = @_;
		my $sentences = Lingua::EN::Sentence::get_sentences($text) or return;
		$text =~ s/\n/ /g; $text =~ s/^\s+//; $text =~ s/\s+$//;
		push @{$file{$text}}, [ $filename, $line ];
	    }
	}   

	my $p = MyParser->new;
	while (m/\G(.*?)^(?:START|END)[A-Z]+$/smg) {
	    my ($str) = ($1);
	    $line += ( () = ($& =~ /\n/g) ); # cryptocontext!
	    $p->parse($str); $p->eof; 
	}
	$_ = '';
    }

    # HTML::Mason
    $line = 1; pos($_) = 0;
    while (m!\G.*?<&\|/l(?:oc)?(.*?)&>(.*?)</&>!sg) {
	my ($vars, $str) = ($1, $2);
	$line += ( () = ($& =~ /\n/g) ); # cryptocontext!
	$str =~ s/\\'/\'/g; 
	push @{$file{$str}}, [ $filename, $line, $vars ];
    }

    # Template Toolkit
    $line = 1; pos($_) = 0;
    while (m!\G.*?\[%\s*\|l(?:oc)?(.*?)\s*%\](.*?)\[%\s*END\s*%\]</&>!sg) {
	my ($vars, $str) = ($1, $2);
	$line += ( () = ($& =~ /\n/g) ); # cryptocontext!
	$str =~ s/\\'/\'/g; 
	push @{$file{$str}}, [ $filename, $line, $vars ];
    }

    # Perl source file
    my ($state,$str,$vars)=(0);
    pos($_) = 0;
    my $orig = 1 + (() = ((my $__ = $_) =~ /\n/g));
  PARSER: {
      $_ = substr($_, pos($_)) if (pos($_));
      my $line = $orig - (() = ((my $__ = $_) =~ /\n/g));
      # maketext or loc or _
      $state == NUL &&
        m/\b(maketext|_|loc|x)/gcx && do { $state = BEG;  redo; };
      $state == BEG && m/^([\s\t\n]*)/gcx && do { redo; };
      # begin ()
      $state == BEG && m/^([\S\(]) /gcx && do {
	$state = ( ($1 eq '(') ? PAR : NUL) ;
	redo;
      };
      # begin or end of string
      $state == PAR  && m/^(\')  /gcx     && do { $state = QUO1; redo; };
      $state == QUO1 && m/^([^\']+)/gcx && do { $str.=$1; redo; };
      $state == QUO1 && m/^\'  /gcx     && do { $state = PAR;  redo; };

      $state == PAR  && m/^\"  /gcx     && do { $state = QUO2; redo; };
      $state == QUO2 && m/^([^\"]+)/gcx && do { $str.=$1; redo; };
      $state == QUO2 && m/^\"  /gcx     && do { $state = PAR;  redo; };

      $state == PAR  && m/^\`  /gcx     && do { $state = QUO3; redo; };
      $state == QUO3 && m/^([^\`]*)/gcx && do { $str.=$1; redo; };
      $state == QUO3 && m/^\`  /gcx     && do { $state = PAR;  redo; };

      # end ()
      $state == PAR && m/^[\)]/gcx
	&& do {
	  $state = NUL;	
	  $vars =~ s/[\n\r]//g if ($vars);
	  push @{$file{$str}}, [ $filename, $line - (() = $str =~ /\n/g), $vars] if ($str);
	  undef $str; undef $vars;
	  redo;
	};

      # a line of vars
      $state == PAR && m/^([^\)]*)/gcx && do { 	$vars.=$1."\n"; redo; };
    }
}

foreach my $str (sort keys %file) {
    unless ($opts{u}) {
	my $entry = $file{$str};

	$str =~ s/\\/\\\\/g;
	$str =~ s/\"/\\"/g;
	$str =~ s/((?<!~)(?:~~)+)\[_(\d+)\]/$1%$2/g;
	$str =~ s/((?<!~)(?:~~)+)\[([A-Za-z#*]\w*)([^\]]+)\]/"$1%$2(".escape($3).")"/eg;
	$str =~ s/~([\~\[\]])/$1/g;

	$file{$str} = $entry;
    }

    $Lexicon{$str} ||= '';
}

exit unless %Lexicon;

print $out ? "$out\n" : (<< '.');
# SOME DESCRIPTIVE TITLE.
# Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER
# This file is distributed under the same license as the PACKAGE package.
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
#
#, fuzzy
msgid ""
msgstr ""
"Project-Id-Version: PACKAGE VERSION\n"
"POT-Creation-Date: 2002-07-16 17:27+0800\n"
"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n"
"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"
"Language-Team: LANGUAGE <LL@li.org>\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=CHARSET\n"
"Content-Transfer-Encoding: 8bit\n"
.

foreach (sort keys %Lexicon) {
    my $f = join(' ', sort map "$_->[0]:$_->[1]", @{$file{$_}});
    $f = " $f" if length $f;
    my $nospace = $_;
    $nospace =~ s/ +$//;

    if (!$Lexicon{$_} and $Lexicon{$nospace}) {
	$Lexicon{$_} = $Lexicon{$nospace} . (' ' x (length($_) - length($nospace)));
    }

    my %seen;
    print "\n#:$f\n";
    foreach my $entry ( grep { $_->[2] } @{$file{$_}} ) {
	my ($file, $line, $var) = @{$entry};
	$var =~ s/^\s*,\s*//; $var =~ s/\s*$//;
	print "#. ($var)\n" unless $seen{$var}++;
    }

    print "#, maketext-format" if $::interop and /%(?:\d|\w+\([^\)]*\))/;
    print "msgid "; output($_);
    print "msgstr "; output($Lexicon{$_});
}

sub output {
    my $str = shift;

    if ($str =~ /\n/) {
	print "\"\"\n";
	print "\"$_\"\n" foreach split(/\n/, $str);
    }
    else {
	print "\"$str\"\n"
    }
}

sub escape {
    my $text = shift;
    $text =~ s/\b_(\d+)/%$1/;
    return $text;
}

1;

=head1 ACKNOWLEDGMENTS

Thanks to Jesse Vincent for contributing to an early version of this
utility.

Also to Alain Barbet, who effectively re-wrote the source parser with a
flex-like algorithm.

=head1 SEE ALSO

L<Locale::Maketext>, L<Locale::Maketext::Lexicon::Gettext>

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2002 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
