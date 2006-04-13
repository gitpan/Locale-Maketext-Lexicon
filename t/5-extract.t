#! /usr/bin/perl -w
use lib '../lib';
use strict;
use Test::More tests => 22;

use_ok('Locale::Maketext::Extract');
my $Ext = Locale::Maketext::Extract->new;
isa_ok($Ext => 'Locale::Maketext::Extract');

extract_ok('_("123")'		=> 123,		    'Simple extraction');

extract_ok('_("[_1] is happy")'	=> '%1 is happy',   '[_1] to %1');
extract_ok('_("%1 is happy")'   => '%1 is happy',   '%1 verbatim', 1);

extract_ok('_("[*,_1] counts")'	=> '%*(%1) counts', '[*,_1] to %*(%1)');
extract_ok('_("%*(%1) counts")'	=> '%*(%1) counts', '%*(%1) verbatim', 1);

extract_ok('_("[*,_1,_2] counts")' => '%*(%1,%2) counts',
    '[*,_1,_2] to %*(%1,%2)');
extract_ok('_("[*,_1,_2] counts")' => '[*,_1,_2] counts',
    '[*,_1,_2] verbatim', 1);

extract_ok(q(_('foo\$bar'))	=> 'foo\\$bar',   'Escaped \$ in q');
extract_ok(q(_("foo\$bar"))	=> 'foo$bar',	    'Normalized \$ in qq');

extract_ok(q(_('foo\x20bar'))	=> 'foo\\x20bar', 'Escaped \x in q');
extract_ok(q(_("foo\x20bar"))	=> 'foo bar',	    'Normalized \x in qq');

extract_ok(q(_('foo\nbar'))	=> 'foo\\nbar',   'Escaped \n in qq');
extract_ok(q(_("foo\nbar"))	=> "foo\nbar",	    'Normalized \n in qq');
extract_ok(qq(_("foo\nbar"))	=> "foo\nbar",	    'Normalized literal \n in qq');

extract_ok(q(_("foo\nbar"))	=> "foo\nbar",	    'Trailing \n in qq');
extract_ok(qq(_("foobar\n"))	=> "foobar\n",	    'Trailing literal \n in qq');

extract_ok(q(_('foo\bar'))	=> 'foo\\bar',    'Escaped \ in q');
extract_ok(q(_('foo\\\\bar'))	=> 'foo\\bar',    'Normalized \\\\ in q');
extract_ok(q(_("foo\bar"))	=> "foo\bar",	  'Interpolated \b in qq');

extract_ok(q([% loc( 'foo "bar" baz' ) %]) => 'foo "bar" baz', 'Escaped double quote in text');

sub extract_ok {
    my ($text, $result, $info, $verbatim) = @_;
    $Ext->extract('' => $text);
    $Ext->compile($verbatim);
    is(join('', %{$Ext->lexicon}), $result, $info);
    $Ext->clear;
}

