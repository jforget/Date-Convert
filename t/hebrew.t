#!perl
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Test script for Date::Convert
#     Copyright (c) 1997, 2000, 2020 Mordechai Abzug and Jean Forget
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

use strict;
use warnings;
use Test::More;
use Date::Convert;

plan(tests => 137);

my $date = Date::Convert::Hebrew->new(5757, 13, 9);
is($$date{absol}, 2450526);

my @absols = qw(2447800 2448155 2448509 2448894 2449247 2449602 2449986
                2450341 2450724 2451078 2451433 2451818 2452171 2452525
                2452910 2453265 2453648 2454002 2454357 2454740 2455094
                2455449 2455834 2456188 2456541 2456926 2457280 2457665
                2458018 2458372 2458757
             );


foreach my $i (5750..5780) {
    my $rosh = Date::Convert::Hebrew->rosh($i);
    is($rosh, shift @absols);
}


my $rina_birthday = Date::Convert::Gregorian->new(1976, 5, 25);
is($rina_birthday->date_string, "1976 May 25");

Date::Convert::Hebrew->convert($rina_birthday);
is($rina_birthday->date_string, "5736 Iyyar 25");

Date::Convert::Gregorian->convert($rina_birthday);
is($rina_birthday->date_string, "1976 May 25");

my $broken_date = Date::Convert::Hebrew->new(5765, 10, 26);
is($broken_date->date_string, "5765 Teves 26");

convert Date::Convert::Gregorian $broken_date;
is($broken_date->date_string, "2005 Jan 7");


my @leaps = qw(0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1
               0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1
               0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1
               0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1
               0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1
               0 0 1 0 0);

foreach my $i (1..100) {
    is(is_leap Date::Convert::Hebrew($i), shift @leaps);
}

