#!/usr/bin/perl -I../Date-Convert/lib
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Test script for Date::Convert
#     Copyright © 2020 Mordechai Abzug and Jean Forget
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
#
# Checking the conversions
# See https://rt.cpan.org/Public/Bug/Display.html?id=130291
# and also https://rt.cpan.org/Public/Bug/Display.html?id=55145 and https://rt.cpan.org/Public/Bug/Display.html?id=98287
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
  my ($y_he, $m_he, $d_he, $y_gr, $m_gr, $d_gr) = @$_;
  my $date = Date::Convert::Gregorian->new($y_gr, $m_gr, $d_gr);
  Date::Convert::Hebrew->convert($date);
  my $expected = sprintf("%04d-%02d-%02d", $y_he, $m_he, $d_he);
  my $result   = sprintf("%04d-%02d-%02d", $date->year, $date->month, $date->day);
  is($result, $expected, "Expecting $expected, obtained $result");
}

for (@test_data) {
  my ($y_he, $m_he, $d_he, $y_gr, $m_gr, $d_gr) = @$_;
  my $date = Date::Convert::Hebrew->new($y_he, $m_he, $d_he);
  Date::Convert::Gregorian->convert($date);
  my $expected = sprintf("%04d-%02d-%02d", $y_gr, $m_gr, $d_gr);
  #if ($y_gr < 0) {
  #  $expected = sprintf("-%04d-%02d-%02d", -$y_gr, $m_gr, $d_gr);
  #}
  my $result   = sprintf("%04d-%02d-%02d", $date->year, $date->month, $date->day);
  is($result, $expected, "Expecting $expected, obtained $result");
}

# Hebrew dates picked from the various Hebrew calendar Perl 5 modules
# Gregorian dates computed with Nachum Dershowitz and Edward M. Reingold's calendrica-3.0.cl
sub load_data {
  @test_data = (
       [ qw<5703  1 14    1943  4 19> ]
     , [ qw<5770  1  1    2010  3 16> ]
     , [ qw<5771  1  1    2011  4  5> ]
     #----------------------------------- From rt.cpan.org Date::Convert::Hebrew
     , [ qw<5717 12 29    1957  3  2> ]   # RT 98287
     , [ qw<5717  6 29    1957  9 25> ]   # RT 98287
     , [ qw<5770 12 16    2010  3  2> ]   # RT 55145
     #----------------------------------- From t/*.t Date::Convert::Hebrew v0.16
     , [ qw<5757 13  9    1997  3 18> ]
     , [ qw<5735  9 13    1974 11 27> ]
     , [ qw<5756  7  8    1995 10  2> ]
     , [ qw<5736  2 25    1976  5 25> ]
     , [ qw<5765 10 26    2005  1  7> ]
     #----------------------------------- From t/*.t Date::Hebrew::Simple
     , [ qw<5778 11  1    2018  1 17> ]
     , [ qw<5778 11 27    2018  2 12> ]
     #----------------------------------- From t/*.t DateTime::Calendar::Hebrew
     , [ qw<5708  2  5    1948  5 14> ]
     , [ qw<2449  1 15   -1311  3 31> ]
     , [ qw<3339  5  9    -421  7 29> ]
     , [ qw<5735 10  5    1974 12 19> ]
     , [ qw<3829  5  9      69  7 14> ]
     , [ qw<5763  1  1    2003  4  3> ]
     , [ qw<5763  5 23    2003  8 21> ]
     , [ qw<5764  7  1    2003  9 27> ]
     , [ qw<   1  1  1   -3759  3  4> ]
     #----------------------------------- from t/*.t Date::Converter
     , [ qw<3593  9 25    -168 12  5> ]
     , [ qw<3831  7  3      70  9 24> ]
     , [ qw<4230 10 18     470  1  8> ]
     , [ qw<4336  3  4     576  5 20> ]
     , [ qw<4455  8 13     694 11 10> ]
     , [ qw<4773  2  6    1013  4 25> ]
     , [ qw<4856  2 23    1096  5 24> ]
     , [ qw<4950  1  7    1190  3 23> ]
     , [ qw<5000 13  8    1240  3 10> ]
     , [ qw<5048  1 21    1288  4  2> ]
     , [ qw<5058  2  7    1298  4 27> ]
     , [ qw<5151  4  1    1391  6 12> ]
     , [ qw<5196 11  7    1436  2  3> ]
     , [ qw<5252  1  3    1492  4  9> ]
     , [ qw<5314  7  1    1553  9 19> ]
     , [ qw<5320 12 27    1560  3  5> ]
     , [ qw<5408  3 20    1648  6 10> ]
     , [ qw<5440  4  3    1680  6 30> ]
     , [ qw<5476  5  5    1716  7 24> ]
     , [ qw<5528  4  4    1768  6 19> ]
     , [ qw<5579  5 11    1819  8  2> ]
     , [ qw<5599  1 12    1839  3 27> ]
     , [ qw<5663  1 22    1903  4 19> ]
     , [ qw<5689  5 19    1929  8 25> ]
     , [ qw<5702  7  8    1941  9 29> ]
     , [ qw<5703  1 14    1943  4 19> ]
     , [ qw<5704  7  8    1943 10  7> ]
     , [ qw<5752 13 12    1992  3 17> ]
     , [ qw<5756 12  5    1996  2 25> ]
     , [ qw<5799  8 12    2038 11 10> ]
     , [ qw<5854  5  5    2094  7 18> ]
     #----------------------------------- Around the Gregorian epoch
     , [ qw<3761  5  5       1  7 13> ]
     , [ qw<3760  5  5       0  7 23> ]
     , [ qw<3759  5  5      -1  7  4> ]
     #----------------------------------- Exact Gregorian epoch
     , [ qw<3761 10 17       0 12 31> ]
     , [ qw<3761 10 18       1  1  1> ]
     #----------------------------------- MJD epoch
     , [ qw<5619  9  9    1858 11 16> ]
     , [ qw<5619  9 10    1858 11 17> ]
     , [ qw<5619  9 11    1858 11 18> ]
);
}

