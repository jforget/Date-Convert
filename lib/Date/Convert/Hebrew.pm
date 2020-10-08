# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Utility module to deal with Hebrew dates in Date::Convert
#     Copyright © 1997, 2000, 2020 Mordechai Abzug and Jean Forget
#
#     See the license in the embedded documentation below.
#

package Date::Convert::Hebrew;
use utf8;
use strict;
use warnings;
use Carp;

our @ISA     = qw ( Date::Convert );
our $VERSION = "0.17";

my $HEBREW_BEGINNING = 347996; # 1 Tishri 1
#  @MONTH       = (  29, 12, 793);
my @NORMAL_YEAR = ( 354,  8, 876); # _part_mult(12,  @MONTH);
my @LEAP_YEAR   = ( 383, 21, 589); # _part_mult(13,  @MONTH);
my @CYCLE_YEARS = (6939, 16, 595); # _part_mult(235, @MONTH);
my @FIRST_MOLAD = (   1,  5, 204);

#
# Which years in the Metonic cycle are leap years?
#
my @LEAP_BOOL   = qw ( 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 );
my @LEAP_CYCLE  = qw (       3     6   8    11    14    17 
                       0 );

my @MONTHS = ('Nissan',  'Iyyar',    'Sivan',  'Tammuz', 'Av',     'Elul',
              'Tishrei', 'Cheshvan', 'Kislev', 'Teves',  'Shevat', 'Adar', 'Adar II' );

# In the Hebrew calendar, the year starts in the seventh month, there can
# be a leap month, and there are two months with a variable number of days.
# Rather than calculate do the actual math, let's set up lookup tables based
# on year length.  :)

my %MONTH_START=
    ('353' => [177, 207, 236, 266, 295, 325, 1, 31, 60, 89, 118, 148],
     '354' => [178, 208, 237, 267, 296, 326, 1, 31, 60, 90, 119, 149],
     '355' => [179, 209, 238, 268, 297, 327, 1, 31, 61, 91, 120, 150],
     '383' => [207, 237, 266, 296, 325, 355, 1, 31, 60, 89, 118, 148, 178],
     '384' => [208, 238, 267, 297, 326, 356, 1, 31, 60, 90, 119, 149, 179],
     '385' => [209, 239, 268, 298, 327, 357, 1, 31, 61, 91, 120, 150, 180]);

my %MONTH_LENGTH =
    ('353' => [30, 29, 30, 29, 30, 29, 30, 29, 29, 29, 30, 29],
     '354' => [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29],
     '355' => [30, 29, 30, 29, 30, 29, 30, 30, 30, 29, 30, 29],
     '383' => [30, 29, 30, 29, 30, 29, 30, 29, 29, 29, 30, 30, 29],
     '384' => [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 30, 29],
     '385' => [30, 29, 30, 29, 30, 29, 30, 30, 30, 29, 30, 30, 29]);

sub is_leap {
    my $self = shift;
    my $year = shift;
    $year = $self->year if ! defined $year;
    my $mod = $year % 19;
    return $LEAP_BOOL[$mod];
}


sub initialize {
  my ($self, $year, $month, $day) = @_;
  return $self->Date::Convert::initialize
    unless defined($year);
  croak "Date::Convert::Gregorian::initialize needs more args"
    unless defined($month)
       and defined($day);

  # coarse check for month number and day number, it will be refined later.
  croak "month number $month out of range"
    if $month < 1 || $month > 13;
  croak "day number $day out of range for month $month"
    if   $day < 1 || $day > 30;

  warn "These routines don't work well for Hebrew before year 1"
    if $year<1;
  $self->{year}   = $year;
  $self->{$month} = $month;
  $self->{day}    = $day;
  my $rosh = $self->rosh;
  my $year_length = Date::Convert::Hebrew->rosh($year+1) - $rosh;

  # If this error is triggered, that means there is a bug in Date::Convert::Hebrew.
  # It does not mean that the user sent input parameters with invalid values.
  carp "Impossible year length $year_length"
    unless defined $MONTH_START{$year_length};

  my $months_ref = $MONTH_START{$year_length};

  # refined check for month number and day number
  croak "month number $month out of range"
    if $month > scalar @$months_ref;
  croak "day number $day out of range for month $month"
    if   $day > $MONTH_LENGTH{$year_length}[$month - 1];

  my $days  = $months_ref->[$month-1] + $day - 1;
  my $absol = $rosh + $days - 1;
  $self->{days}  = $days;
  $self->{absol} = $absol;
}

sub year {
  my $self = shift;

  # no point recalculating.
  return $self->{year}
    if exists $self->{year};

    my $days = $self->absol;
    my $year = int($days / 365) - 3 * 365; # just an initial guess, but a good one.
    $year = 0
      if $year < 0;
    warn "Date::Convert::Hebrew isn't reliable before the beginning of\n"
         . "\tthe Hebrew calendar"
      if $days < $HEBREW_BEGINNING;
    $year++
      while Date::Convert::Hebrew->rosh($year+1) <= $days;
    $self->{year} = $year;
    $self->{days} = $days - Date::Convert::Hebrew->rosh($year) + 1;
    return $year;
}

sub month {
  my $self = shift;

  # no point recalculating.
  return $self->{month}
    if exists $self->{month};

    my $year_length =   Date::Convert::Hebrew->rosh($self->year+1)
                      - Date::Convert::Hebrew->rosh($self->year);

  # If this error is triggered, that means there is a bug in Date::Convert::Hebrew.
  # It does not mean that the user sent input parameters with invalid values.
  carp "Impossible year length $year_length"
    unless defined $MONTH_START{$year_length};

    my $months_ref=$MONTH_START{$year_length};
    my $days=$$self{days};
    my ($n, $month)=(1);
    my $day=31; # 31 is too large.  Good.  :)
    grep {if ($days>=$_ && $days-$_<$day)
	  {$day=$days-$_+1;$month=$n}
	  $n++} @$months_ref;
    $$self{month}=$month;
    $$self{day}=$day;
    return $month;
}

sub day {
  my $self = shift;

  # no point recalculating.
  return $self->{day}
    if exists $self->{day};

    $self->month; # calculates day as a side-effect.
    return $$self{day};
}


sub date {
    my $self = shift;
    return ($self->year, $self->month, $self->day);
}


sub date_string {
  my $self = shift;
  my $month_name = $MONTHS[$self->month - 1];
  if ($self->month == 12 and $self->is_leap) {
    $month_name = 'Adar I';
  }
  return join ' ', $self->year, $month_name, $self->day;
}


sub rosh {
  my ($self, $year) = @_;
  $year = $self->year
    unless defined($year);

    my @molad= @FIRST_MOLAD;
    @molad = _part_add(@molad, _part_mult(int(($year-1) / 19), @CYCLE_YEARS));
    my $offset=($year-1)%19;
    my $num_leaps=(grep {$_<=$offset} @LEAP_CYCLE) - 1;
    @molad = _part_add(@molad, _part_mult($num_leaps          , @LEAP_YEAR));
    @molad = _part_add(@molad, _part_mult($offset - $num_leaps, @NORMAL_YEAR));
    my $day=shift @molad;
    my $hour=shift @molad;
    my $part= shift @molad;
    my $guess=$day%7;
    if (($hour>=18)                              # molad zoken al tidrosh
	or
	((! Date::Convert::Hebrew->is_leap($year)) and   # gatrad b'shanah
	 ($guess==2) and                         #      p'shutah g'rosh
	 (($hour>9)or($hour==9 && $part>=204)))
        or
        ((is_leap Date::Convert::Hebrew $year-1) and # b'to takfat achar
	 ($guess==1) and                         #      ha'ibur akor
	 (($hour>15)or($hour==15&&$part>589)))){ #      mi-lishorsh
	$guess++;
	$day++;
    }
    $guess%=7;
    if (scalar(grep {$guess==$_} (0, 3, 5))) {   # lo ad"o rosh
	$guess++;
	$day++;
    }
    $guess%=7;
    return ($day+1+$HEBREW_BEGINNING);
}

sub _part_add {
    my ($day1, $hour1, $part1)=(shift, shift, shift);
    my ($day2, $hour2, $part2)=(shift, shift, shift);
    my $part=$part1+$part2;
    my $hour=$hour1+$hour2;
    my $day =$day1 +$day2;
    if ($part>1080) {
	$part-=1080;
	$hour++;
    }
    if ($hour>24) {
	$hour-=24;
	$day++;
    }
    return ($day, $hour, $part);
}


sub _part_mult {
    my $scalar = shift;
    my $day= ((0+ shift) * $scalar);
    my $hour=((0+ shift) * $scalar);
    my $part=((0+ shift) * $scalar);
    my $tmp;
    if ($part>1080) {
	$tmp=int($part/1080);
	$part%=1080;
	$hour+=$tmp;
    }
    if ($hour>24) {
	$tmp=int($hour/24);
	$hour%=24;
	$day+=$tmp;
    }
    return($day, $hour, $part);
}

# Instead of the usual boring "1" end-of-package value,
# just celebrate the Dumas-esque achievement of releasing
# version 0.17 in 2020, after version 0.16 in 2000
'Vingt ans après...';

__END__

=head1 NAME

Date::Convert::Hebrew - Utility module to deal with Hebrew dates in Date::Convert

=head1 DESCRIPTION

See the full documentation in the main module L<Date::Convert>.

=head1 NOTES ON HEBREW CALENDAR

This is the traditional Jewish calendar. It's based on the solar year,
on the  lunar month, and  on a number  of additional rules  created by
Rabbis to make life tough on people who calculate calendars. :) If you
actually wade  through the  source, you should  note that  the seventh
month really does come before the first month, that's not a bug.

It  comes with  the following  additional methods:  B<year>, B<month>,
B<day>,  B<is_leap>, B<rosh>,  B<part_add>, and  B<part_mult>. B<rosh>
returns the  absolute day corresponding  to "Rosh HaShana"  (New year)
for a given year, and can also be invoked as a static. B<part_add> and
B<part_mult> are useful functions  for Hebrew calendrical calculations
are  not  for much  else;  if  you're  not  familiar with  the  Hebrew
calendar, don't worry about them.

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
