#!/usr/bin/perl
# $File: //member/autrijus/Locale-Maketext-Lexicon/script/xgettext.pl $ $Author: autrijus $
# $Revision: #4 $ $Change: 10139 $ $DateTime: 2004/02/19 18:25:46 $ vim: expandtab shiftwidth=4

use strict;
use Cwd;
use Getopt::Std;
use Locale::Maketext::Extract;

=head1 NAME

xgettext.pl - Extract translatable strings from source

=head1 SYNOPSIS

B<xgettext.pl> [ B<-u> ] [ B<-g> ] [ B<-o> I<outputfile> ] [ I<inputfile>... ]

=head1 DESCRIPTION

This program extracts translatable strings from given input files, or
from STDIN if none are given.

Please see L<Locale::Maketext::Extract> for a list of supported
input file formats.

=head1 OPTIONS

=over 4

=item B<-u>

Disables conversion from B<Maketext> format to B<Gettext> format -- i.e.
leave all brackets alone.  This is useful if you are also using the
B<Gettext> syntax in your program.

=item B<-g>

Enables GNU gettext interoperability by printing C<#, perl-maketext-format>
before each entry that has C<%> variables.

=item B<-o> I<outputfile>

PO file name to be written or incrementally updated; C<-> means writing to
B<STDOUT>.  If not specified, F<messages.po> is used.

=item I<inputfile>...

The files to extract messages from.  If not specified, B<STDIN> is assumed.

=back

=cut

my %opts;
getopts('hugo:', \%opts) or help();
help() if $opts{h};

my $PO = Cwd::abs_path($opts{o} || "messages.po");
@ARGV = ('-') unless @ARGV;
s!^.[/\\]!! for @ARGV;

my $Ext = Locale::Maketext::Extract->new;
$Ext->read_po($PO, $opts{u}) if -r $PO;
$Ext->extract_file($_) for grep !/\.po$/i, @ARGV;
$Ext->compile($opts{u}) or exit;
$Ext->write_po($PO);

sub help {
    local $SIG{__WARN__} = sub {};
    exec "perldoc $0";
    exec "pod2text $0";
}

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
