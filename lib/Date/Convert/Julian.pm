# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Utility module to deal with Julian dates in Date::Convert
#     Copyright (c) 1997, 2000, 2020 Mordechai Abzug and Jean Forget
#
#     See the license in the embedded documentation below.
#


# Julian is kinda like Gregorian, but the leap year rule is easier.

package Date::Convert::Julian;

use utf8;
use strict;
use warnings;
use Carp;
use POSIX qw/floor/;

our @ISA = qw ( Date::Convert::Gregorian Date::Convert );

# we steal useful constants from Gregorian
my $JULIAN_BEGINNING = $Date::Convert::Gregorian::GREG_BEGINNING - 2;
my $NORMAL_YEAR      = $Date::Convert::Gregorian::NORMAL_YEAR;
my $LEAP_YEAR        = $Date::Convert::Gregorian::LEAP_YEAR;
my $FOUR_YEARS       = $Date::Convert::Gregorian::FOUR_YEARS;
my @MONTH_ENDS       = @Date::Convert::Gregorian::MONTH_ENDS;
my @LEAP_ENDS        = @Date::Convert::Gregorian::LEAP_ENDS;

our $VERSION = "0.17";

sub initialize {
  my ($self, $year, $month, $day) = @_;
  return $self->Date::Convert::initialize
    unless defined($year);
  croak "Date::Convert::Julian::initialize needs more args"
    unless defined($month)
       and defined($day);

  # warn "These routines don't work well for Julian before year 1"
  #     if $year<1;
  croak "month number $month out of range"
    if $month < 1 || $month >12;
  my $is_leap = Date::Convert::Julian->is_leap($year);
  my $MONTH_REF = \@MONTH_ENDS;
  $MONTH_REF    = \@LEAP_ENDS if $is_leap;
  croak "day number $day out of range for month $month"
    if $day<1 || $day + $MONTH_REF->[$month-1] > $MONTH_REF->[$month];

  $self->{year}  = $year;
  $self->{month} = $month;
  $self->{day}   = $day;

  $year --;  #get years *before* this year.  Makes math easier.  :)
  # first, convert year into days. . .
  my $absol = $JULIAN_BEGINNING;
  $absol   += floor($year / 4) * $FOUR_YEARS;
  $year    %= 4;
  $absol   += $year * $NORMAL_YEAR;

  # now, month into days.
  $absol += $day + $MONTH_REF->[$month-1] - 1;
  $self->{absol}=$absol;
}


sub year {
  my $self = shift;
  return $self->{year}
    if exists $self->{year};

  my ($days, $year);
  # To avoid fenceposts, year and days are initially *before* today.
  # the next code is stolen directly form the ::Gregorian code.  Good thing
  # I'm the one who wrote it. . .
  $days = $self->absol - $JULIAN_BEGINNING;
  $year =  floor ($days / $FOUR_YEARS) * 4;
  $days %= $FOUR_YEARS;
  if (($days+1) % $FOUR_YEARS) {
    # Not on a four-year boundary.  Good!
    $year += int ($days / $NORMAL_YEAR); # fence post from year 1
    $days %= $NORMAL_YEAR;
    $days += 1; # today
    $year += 1;
  }
  else {
    $year += int ($days / $NORMAL_YEAR + 1) - 1;
    $days  = $LEAP_YEAR;
  }
  $self->{year}           = $year;
  $self->{days_into_year} = $days;
  return $year;
}

sub is_leap {
  my ($self, $year) = @_;
  $year = $self->year
    unless defined($year);

  return 0 if $year %4;
  return 1;
}


# OK, we're done.  Everything else just gets inherited from Gregorian.

# Instead of the usual boring "1" end-of-package value,
# just celebrate the Dumas-esque achievement of releasing
# version 0.17 in 2020, after version 0.16 in 2000
'Vingt ans après...';

__END__

=head1 NAME

Date::Convert::Julian - Utility module to deal with Julian dates in Date::Convert

=head1 DESCRIPTION

See the full documentation in the main module L<Date::Convert>.

=head1 METHODS

=head2 C<new>

Create a  new object.  You must  provide three  positional parameters:
year, month and day.

=head2 C<convert>

Use an  existing C<Date::Convert::>I<xxx>  object and convert  it into
the C<Date::Convert::Julian> class.

=head2 C<year>, C<month>, C<day>, C<absol>, C<date_string>

Accessors,  just  like  the  base  class  C<Date::Convert>  and  other
classes.

=head2 C<date>

Accessor, gives a triplet of values, with year, month and day.

=head2 C<is_leap>

Accessor, gives a  boolean which indicates if the year  has 365 or 366
days (0 for a 365-day year, 1 for a 366-day year). It can be used as a
method:

  my $flag = $juliandate->is_leap;

or as a function:

  my $flag = Date::Convert::Julian->is_leap($year);

=head1 NOTES ON JULIAN CALENDAR

The  old Roman  calendar, allegedly  named for  Julius Caesar.  Purely
solar, with a month that is  a rough approximation of the lunar month.
Used extensively in the Western world  up to a few centuries ago, then
the West gradually  switched over to the more  accurate Gregorian. Now
used only by the Eastern Orthodox Church, AFAIK.

=head1 SEE ALSO

perl(1)

L<DateTime>, with L<DateTime::Calendar::Julian>

L<Date::Converter>

L<Date::Julian::Simple>

=head1 AUTHORS

Module creator: Mordechai T. Abzug <morty at umbc dot edu>

Unofficial co-maintainer: Jean Forget <JFORGET at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright (c)  1997, 2000, 2020  Mordechai Abzug and Jean  Forget. All
rights reserved.

This  program  is  free  software. You  can  distribute,  modify,  and
otherwise mangle  Date::Convert::Julian under  the same terms  as Perl
5.16.3:  GNU Public  License  version  1 or  later  and Perl  Artistic
License

You can  find the text  of the licenses  in the F<LICENSE> file  or at
L<https://dev.perl.org/licenses/artistic.html>
and L<https://www.gnu.org/licenses/gpl-1.0.html>.

Here is the summary of GPL:

This program is  free software; you can redistribute  it and/or modify
it under the  terms of the GNU General Public  License as published by
the Free  Software Foundation; either  version 1, or (at  your option)
any later version.

This program  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
General Public License for more details.

You  should have received  a copy  of the  GNU General  Public License
along with  this program; if not,  see <https://www.gnu.org/licenses/>
or write to the Free Software Foundation, Inc., L<https://www.fsf.org>.

=cut
