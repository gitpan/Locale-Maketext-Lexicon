#!/usr/bin/perl
# $File: //member/autrijus/Locale-Maketext-Lexicon/script/xgettext.pl $ $Author: autrijus $
# $Revision: #3 $ $Change: 9506 $ $DateTime: 2003/12/31 08:28:21 $ vim: expandtab shiftwidth=4

use strict;
use Cwd;
use Getopt::Std;
use Pod::Usage;
use Locale::Maketext::Extract;

=head1 NAME

xgettext.pl - Extract translatable strings from source

=head1 SYNOPSIS

B<xgettext.pl> [ B<-u> ] [ B<-g> ] [ B<-o> I<outputfile> ] [ I<inputfile>... ]

=head1 OPTIONS

[ B<-u> ] Disables conversion from B<Maketext> format to B<Gettext>
format -- i.e. it leaves all brackets alone.  This is useful if you are
also using the B<Gettext> syntax in your program.

[ B<-g> ] Enables GNU gettext interoperability by printing C<#,
perl-maketext-format> before each entry that has C<%> variables.

[ B<-o> I<outputfile> ] PO file name to be written or incrementally
updated C<-> means writing to F<STDOUT>.  If not specified,
F<messages.po> is used.

[ I<inputfile>... ] are the files to extract messages from.

=head1 DESCRIPTION

This program extracts translatable strings from given input files, or
from STDIN if none are given.

Please see L<Locale::Maketext::Extract> for a list of supported
input file formats.

=cut

my %opts;
getopts('hugo:', \%opts) or pod2usage( -verbose => 1, -exitval => 1 );
pod2usage( -verbose => 2, -exitval => 0 ) if $opts{h};

my $PO = Cwd::abs_path($opts{o} || "messages.po");
@ARGV = ('-') unless @ARGV;
s!^.[/\\]!! for @ARGV;

my $Ext = Locale::Maketext::Extract->new;
$Ext->read_po($PO, $opts{u}) if -r $PO;
$Ext->extract_file($_) for grep !/\.po$/i, @ARGV;
$Ext->compile($opts{u}) or exit;
$Ext->write_po($PO);

1;

=head1 SEE ALSO

L<Locale::Maketext::Extract>,
L<Locale::Maketext::Lexicon::Gettext>,
L<Locale::Maketext>

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, 2003, 2004 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
