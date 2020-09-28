# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Utility module to deal with Gregorian dates in Date::Convert
#     Copyright © 1997, 2000, 2020 Mordechai Abzug and Jean Forget
#
#     See the license in the embedded documentation below.
#

package Date::Convert::Gregorian;

use utf8;
use strict;
use warnings;
use Carp;
use POSIX qw/floor/;

our @ISA = qw ( Date::Convert );

our $GREG_BEGINNING=1721426; # 1 Jan 1 in the Gregorian calendar, although
                             # technically, the Gregorian calendar didn't exist at
                             # the time.
our @MONTHS_SHORT  = qw ( nil Jan Feb Mar Apr May Jun July Aug Sep Oct Nov Dec );
our @MONTH_ENDS    = qw ( 0   31  59  90  120 151 181  212 243 273 304 334 365 );
our @LEAP_ENDS     = qw ( 0   31  60  91  121 152 182  213 244 274 305 335 366 );

our $NORMAL_YEAR    = 365;
our $LEAP_YEAR      = $NORMAL_YEAR + 1;
our $FOUR_YEARS     =  4 * $NORMAL_YEAR + 1; # one leap year every four years
my  $CENTURY        = 25 * $FOUR_YEARS  - 1; # centuries aren't leap years . . .
my  $FOUR_CENTURIES =  4 * $CENTURY     + 1; # . . .except every four centuries.


sub year {
  my $self = shift;

  # no point recalculating.
  return $self->{year}
    if exists $self->{year};

  my $days;
  my $year;
  # note:  years and days are initially days *before* today, rather than
  # today's date.  This is because of fenceposts.  :)
  $days =  $self->{absol} - $GREG_BEGINNING;
  if (($days+1) % $FOUR_CENTURIES) {
    # normal case
    $year  = floor ($days / $FOUR_CENTURIES) * 400;
    $days %= $FOUR_CENTURIES;
    $year += int ($days / $CENTURY) * 100; # years.
    $days %= $CENTURY;
    $year += int ($days / $FOUR_YEARS) * 4;
    $days %= $FOUR_YEARS;
    if (($days+1) % $FOUR_YEARS) {
      $year += int ($days / $NORMAL_YEAR); # fence post from year 1
      $days %= $NORMAL_YEAR; 
      $days += 1; # today
      $year += 1;
    }
    else {
      $year += int ($days / $NORMAL_YEAR + 1) - 1;
      $days =  $LEAP_YEAR;
    }
  }
  else {
    # exact four century boundary.  Uh oh. . .
    $year =  floor ($days / $FOUR_CENTURIES + 1) * 400;
    $days =  $LEAP_YEAR; # correction for later.
  }
  $self->{year}            = $year;
  $self->{days_into_year } = $days;
  return $year;
}

sub is_leap {
  my ($self, $year) = @_;
  $year = $self->year
    unless defined($year);
  return 0 if (($year %4) || (($year % 400) && !($year % 100)));
  return 1;
}


sub month {
    my $self = shift;
    return $$self{month} if exists $$self{month};
    my $year = $self -> year;
    my $days = $$self{days_into_year};
    my $MONTH_REF = \@MONTH_ENDS;
    $MONTH_REF = \@LEAP_ENDS if ($self->is_leap);
    my $month= 13 - (grep {$days <= $_} @$MONTH_REF);
    $$self{month} = $month;
    $$self{day}   = $days-@$MONTH_REF[$month-1];
    return $month;
}



sub day {
    my $self = shift;
    return $$self{day} if exists $$self{day};
    $self->month; # calculates day as a side-effect
    return $$self{day};
}



sub date {
    my $self = shift;
    return ($self->year, $self->month, $self->day);
}



sub date_string {
    my $self  = shift;
    my $year  = $self->year;
    my $month = $self->month;
    my $day   = $self->day;
    return "$year $MONTHS_SHORT[$month] $day";
}

sub initialize {
  my ($self, $year, $month, $day) = @_;
  return Date::Convert->initialize
    unless defined($year);
  croak "Date::Convert::Gregorian::initialize needs more args"
    unless defined($month)
       and defined($day);
  # warn "These routines don't work well for Gregorian before year 1"
  #   if $year<1;
  my $absol = $GREG_BEGINNING;
  $self->{'year'}  = $year;
  $self->{'month'} = $month;
  $self->{'day'}   = $day;
  my $is_leap      = Date::Convert::Gregorian->is_leap($year);
  $year --;  #get years *before* this year.  Makes math easier.  :)

  # first, convert year into days. . .
  $absol += floor($year/400) * $FOUR_CENTURIES;
  $year  %= 400;
  $absol += int($year/100) * $CENTURY;
  $year  %= 100;
  $absol += int($year/4) * $FOUR_YEARS;
  $year  %= 4;
  $absol += $year * $NORMAL_YEAR;

  # now, month into days.
  croak "month number $month out of range" 
    if $month < 1 || $month > 12;
  my $MONTH_REF = \@MONTH_ENDS;
  $MONTH_REF = \@LEAP_ENDS if $is_leap;
  croak "day number $day out of range for month $month"
    if   $day < 1
      || $day + $$MONTH_REF[$month-1] > $$MONTH_REF[$month];
  $absol += $day + $$MONTH_REF[$month-1] - 1;
  $self->{absol} = $absol;
}

# Instead of the usual boring "1" end-of-package value,
# just celebrate the Dumas-esque achievement of releasing
# version 0.17 in 2020, after version 0.16 in 2000
'Vingt ans après...';

__END__

=head1 NAME

Date::Convert::Gregorian - Utility module to deal with Gregorian dates in Date::Convert

=head1 DESCRIPTION

See the full documentation in the main module L<Date::Convert>.

=head1 NOTES ON GREGORIAN CALENDAR

The Gregorian calendar  is a purely solar calendar, with  a month that
is only  an approximation  of a lunar  month. It is  based on  the old
Julian (Roman)  calendar. This is the  calendar that has been  used by
most of the Western world for the  last few centuries. The time of its
adoption varies  from country  to country. This  B<::Gregorian> module
allows  you to  extrapolate back  to 1  A.D., as  per the  programming
tradition, even though the calendar definitely was not in use then.

In addition  to the required  methods, B<Gregorian> also  has B<year>,
B<month>, B<day>, and B<is_leap> methods.  B<is_leap> can also be used
statically.

=head1 AUTHORS

Module creator: Mordechai T. Abzug <morty at umbc dot edu>

Unofficial co-maintainer: Jean Forget <JFORGET at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright  © 1997,  2000, 2020  Mordechai Abzug  and Jean  Forget. All
rights reserved.

This  program  is  free  software. You  can  distribute,  modify,  and
otherwise  mangle Date::Convert::French_Rev  under the  same terms  as
Perl 5.16.3: GNU  Public License version 1 or later  and Perl Artistic
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
