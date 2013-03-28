
use strict;
use warnings;

use 5.005;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Use other catalog formats in Maketext",
  "AUTHOR" => "Clinton Gormley <drtech\@cpan.org>, Audrey Tang <cpan\@audreyt.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Locale-Maketext-Lexicon",
  "EXE_FILES" => [],
  "LICENSE" => "mit",
  "NAME" => "Locale::Maketext::Lexicon",
  "PREREQ_PM" => {
    "Locale::Maketext" => "1.17"
  },
  "VERSION" => "0.93",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



