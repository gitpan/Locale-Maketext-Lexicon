# $File: //member/autrijus/Acme-ComeFrom/ComeFrom.pm $ $Author: autrijus $
# $Revision: #9 $ $Change: 3586 $ $DateTime: 2002/03/29 13:55:17 $

package Locale::Maketext::Lexicon;
$Locale::Maketext::Lexicon::VERSION = '0.02';

use strict;

=head1 NAME

Locale::Maketext::Lexicon - Use other catalog formats in Maketext

=head1 VERSION

This document describes version 0.02 of Locale::Maketext::Lexicon, released
May 13, 2002.

=head1 SYNOPSIS

As part of a localization class:

    package Hello::L10N;
    use base 'Locale::Maketext';
    use Locale::Maketext::Lexicon {de => [Gettext => 'hello_de.po']};

Alternatively, as part of a localization subclass:

    package Hello::L10N::de;
    use base 'Hello::L10N';
    use Locale::Maketext::Lexicon;
    Locale::Maketext::Lexicon->import(Gettext => \*DATA);
    __DATA__
    # Some sample data
    msgid ""
    msgstr ""
    "Project-Id-Version: Hello 1.3.22.1\n"
    "MIME-Version: 1.0\n"
    "Content-Type: text/plain; charset=iso8859-1\n"
    "Content-Transfer-Encoding: 8bit\n"

    #: Hello.pm:10
    msgid "Hello, World!"
    msgstr "Hallo, Welt!"

=head1 DESCRIPTION

This module provides lexicon-handling modules to read from other
localization formats, such as I<Gettext>, I<Msgcat>, and so on.

The C<import()> function accepts two forms of arguments:

=over 4

=item (I<format>, [ I<filehandle> | I<filename> | I<arrayref> ])

This form pass the contents specified by the second argument to
B<Locale::Maketext::Plugin::I<format>>->parse as a plain list,
and export its return value as the C<%Lexicon> hash in the calling
package.

=item { I<language> => I<format>, [ I<filehandle> | I<filename> | I<arrayref> ] ... }

This form accepts a hash reference. It will export a C<%Lexicon>
into the subclasses specified by each I<language>, using the process
described above.  It is designed to alleviate the need to set up a
separate subclass for each localized language, and just use the catalog
files.

=back

=cut

sub import {
    my $class = shift;
    return unless @_;

    my %entries = %{UNIVERSAL::isa($_[0], 'HASH') ? $_[0] : { '' => [ @_ ] }};

    while (my ($lang, $entry) = each %entries) {
	my ($format, $src) = @{$entries{$lang}};
	my $export = caller;
	$export .= "::$lang" if $lang;

	my @content;
	if (UNIVERSAL::isa($src, 'ARRAY')) {
	    @content = @{$src};
	}
	elsif ($src =~ /GLOB/ or UNIVERSAL::isa($src, 'IO::Handle')) {
	    @content = <$src>;
	}
	elsif (ref($src)) {
	    die "Can't handle source reference: $src";
	}
	else {
	    require FileHandle;
	    require File::Spec;
	    my $fh = FileHandle->new; # filename - open and return its handle
	    my @path = split('::', $export);
	    $src = (grep { -e } map {
		my @subpath = @path[0..$_];
		map { File::Spec->catfile($_, @subpath, $src) } @INC;
	    } -1..$#path)[-1];

	    $fh->open($src) or die $!;
	    @content = <$fh>;
	}

	no strict 'refs';
	eval "use $class\::$format";
	%{"$export\::Lexicon"} = "$class\::$format"->parse(@content);
	push @{"$export\::ISA"}, caller if $lang;
    }
}

1;

=head1 ACKNOWLEDGEMENTS

Thanks to Jesse Vincent for suggesting this function, and Sean M Burke for
coming up with B<Locale::Maketext> in the first place.

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
