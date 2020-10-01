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
# Checking the conversions and the "Adar" vs "Adar I" name
# See https://rt.cpan.org/Public/Bug/Display.html?id=98287
#
use utf8;
use strict;
use warnings;
use Test::More;
use Date::Convert;

plan(tests => 5);

my $date = Date::Convert::Gregorian->new(1957, 9, 25);
Date::Convert::Hebrew->convert($date);
is($date->date_string(), "5717 Elul 29", "1957 Sep 25 should be 5717 Elul 29");

$date = Date::Convert::Gregorian->new(1957, 3, 2);
Date::Convert::Hebrew->convert($date);
is($date->date_string(), "5717 Adar I 29", "1957 Mar 2 should be 5717 Adar I 29");

$date = Date::Convert::Gregorian->new(2020, 3, 25);
Date::Convert::Hebrew->convert($date);
is($date->date_string(), "5780 Adar 29", "2020 Mar 25 should be 5780 Adar 29");

$date = Date::Convert::Julian->new(2100, 3, 1);
Date::Convert::Gregorian->convert($date);
Date::Convert::Julian   ->convert($date);
is($date->date_string(), "2100 Mar 1", 'roundtrip from "2100 Mar 1" should arrive at "2100 Mar 1", not "2100 Feb 29"');

$date = Date::Convert::Julian->new(2100, 2, 29);
Date::Convert::Gregorian->convert($date);
Date::Convert::Julian   ->convert($date);
is($date->date_string(), "2100 Feb 29", '"2100 Feb 29" should not crash');

