# $File: //member/autrijus/parse_demo.pl $ $Author: autrijus $
# $Revision: #1 $ $Change: 4091 $ $DateTime: 2002/05/02 18:04:48 $

package Locale::Maketext::Lexicon::Gettext;
$Locale::Maketext::Lexicon::Gettext = '0.01';

use strict;

=head1 NAME

Locale::Maketext::Lexicon::Gettext - Gettext catalog parser for Maketext

=head1 SYNOPSIS

Called via B<Locale::Maketext::Lexicon>:

    package Hello::L10N;
    use base 'Locale::Maketext';
    use Locale::Maketext::Lexicon {de => [Gettext => 'hello_de.po']};

Directly calling C<parse()>:

    use Locale::Maketext::Lexicon::Gettext;
    my %Lexicon = Locale::Maketext::Lexicon::Gettext->parse(<DATA>);
    __DATA_
    #: Hello.pm:10
    msgid "Hello, World!"
    msgstr "Hallo, Welt!"

=head1 DESCRIPTION

This module implements a perl-based C<Gettext> parser for
B<Locale::Maketext>. It transforms all C<%1>, C<%2>... sequences
to C<[_1]>, C<[_2]>, and so on.

=cut

sub parse {
    my $self = shift;
    my (%var, $key, @ret);

    # Parse *.po; Locale::Gettext objects and *.mo are not yet supported.
    foreach (@_) {
	/^(msgid|msgstr) +"(.*)" *$/	? do {	# leading strings
	    $var{$1} = $2;
	    $key = $1;
	} :

	/^"(.*)" *$/			? do {	# continued strings
	    $var{$key} .= $1;
	} :

	/^#, +(.*) *$/			? do {	# control variables
	    $var{$1} = 1;
	} :

	/^ *$/				? do {	# interpolate string escapes
	    push @ret, map { transform($_) } @var{'msgid', 'msgstr'} if length $var{msgstr};
	    %var = ();
	} : ();
    }

    push @ret, map { transform($_) }
	@var{'msgid', 'msgstr'} if length $var{msgstr};

    return @ret;
}

sub transform {
    my $str = shift;
    $str =~ s/\\([0x]..|c?.)/qq{"\\$1"}/eeg;
    $str =~ s/[\~\[\]]/~$&/g;
    $str =~ s/(^|[^%\\])%(\d+)/$1\[_$2]/g;

    chomp $str;
    return $str;
}

1;

=head1 SEE ALSO

L<Locale::Maketext>, L<Locale::Maketext::Lexicon>

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2002 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
