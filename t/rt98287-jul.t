#!/usr/bin/perl -I../Date-Convert/lib
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Test script for Date::Convert
#     Copyright (C) 2020 Jean Forget
#
#     This program is distributed under the same terms as Perl 5.16.3:
#     GNU Public License version 1 or later and Perl Artistic License
#
#     You can find the text of the licenses in the F<LICENSE> file or at
#     L<https://dev.perl.org/licenses/artistic.html>
#     and L<https://www.gnu.org/licenses/gpl-1.0.html>.
#
#     Here is the summary of GPL:
#
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 1, or (at your option)
#     any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software Foundation,
#     Inc., <https://www.fsf.org/>.
#
#
# Checking the conversions between Hebrew and Julian.
# Especially the dates which may cause problems with the Julian calendar.
#
use utf8;
use strict;
use warnings;
use Test::More;
use Date::Convert;

my @test_data;
load_data();

plan tests => 2 * @test_data;

for (@test_data) {
  my ($y_he, $m_he, $d_he, $y_ju, $m_ju, $d_ju) = @$_;
  my $date = Date::Convert::Hebrew->new($y_he, $m_he, $d_he);
  Date::Convert::Julian->convert($date);
  my $expected = sprintf("%04d-%02d-%02d", $y_ju, $m_ju, $d_ju);
  #if ($y_ju < 0) {
  #  $expected = sprintf("-%04d-%02d-%02d", -$y_ju, $m_ju, $d_ju);
  #}
  my $result   = sprintf("%04d-%02d-%02d", $date->year, $date->month, $date->day);
  is($result, $expected, "Expecting $expected, obtained $result");
}

for (@test_data) {
  my ($y_he, $m_he, $d_he, $y_ju, $m_ju, $d_ju) = @$_;
  my $date = Date::Convert::Julian->new($y_ju, $m_ju, $d_ju);
  Date::Convert::Hebrew->convert($date);
  my $expected = sprintf("%04d-%02d-%02d", $y_he, $m_he, $d_he);
  my $result   = sprintf("%04d-%02d-%02d", $date->year, $date->month, $date->day);
  is($result, $expected, "Expecting $expected, obtained $result");
}

# Hebrew dates picked from the various Hebrew calendar Perl 5 modules
# then filtered to select the dates which might give problems in the Julian calendar module.
# Julian dates computed with Nachum Dershowitz and Edward M. Reingold's calendar.l, shifting
# negative dates by 1 to take in acocunt the zero year.
sub load_data {
  @test_data = (
       [ qw<5703  1 14    1943  4  6> ]
     , [ qw<2449  1 15   -1311  4 12> ]
     , [ qw<3339  5  9    -421  8  3> ]
     , [ qw<   1  1  1   -3759  4  3> ]
     , [ qw<3593  9 25    -168 12  8> ]
     #----------------------------------- Around the Julian epoch
     , [ qw<3761  5  5       1  7 15> ]
     , [ qw<3760  5  5       0  7 25> ]
     , [ qw<3759  5  5      -1  7  6> ]
     #----------------------------------- Exact Julian epoch
     , [ qw<3761 10 15       0 12 31> ]
     , [ qw<3761 10 16       1  1  1> ]
     #----------------------------------- 4-yeazr block boundary
     , [ qw<3965 10 21     204 12 31> ]
     , [ qw<3965 10 22     205  1  1> ]
     , [ qw<3557 10 10    -204 12 31> ]
     , [ qw<3557 10 11    -203  1  1> ]
);
}

