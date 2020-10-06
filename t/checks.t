# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Test script for Date::Convert
#     Copyright © 2020 Jean Forget
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
# Checking the value checks.
#
use Test::More;
use Date::Convert;
BEGIN {
  eval "use Test::Exception;";
  plan skip_all => "Test::Exception needed" if $@;
}

plan tests => 25;

my $d;
dies_ok { Date::Convert::Gregorian->new(2020         ) }  "missing month";
dies_ok { Date::Convert::Gregorian->new(2020, 10     ) }  "missing day";
dies_ok { Date::Convert::Gregorian->new(2020, -3,   6) }  "month out of range";
dies_ok { Date::Convert::Gregorian->new(2020, 13,   6) }  "month out of range";
dies_ok { Date::Convert::Gregorian->new(2020, 10,  36) }  "day out of range";
dies_ok { Date::Convert::Gregorian->new(2020, 10,  -6) }  "day out of range";
dies_ok { Date::Convert::Gregorian->new(2020,  2,  30) }  "day out of range";
dies_ok { Date::Convert::Gregorian->new(2021,  2,  29) }  "day out of range";

dies_ok { Date::Convert::Julian->new(2020         ) }  "missing month";
dies_ok { Date::Convert::Julian->new(2020, 10     ) }  "missing day";
dies_ok { Date::Convert::Julian->new(2020, -3,   6) }  "month out of range";
dies_ok { Date::Convert::Julian->new(2020, 13,   6) }  "month out of range";
dies_ok { Date::Convert::Julian->new(2020, 10,  36) }  "day out of range";
dies_ok { Date::Convert::Julian->new(2020, 10,  -6) }  "day out of range";
dies_ok { Date::Convert::Julian->new(2020,  2,  30) }  "day out of range";
dies_ok { Date::Convert::Julian->new(2021,  2,  29) }  "day out of range";

dies_ok { Date::Convert::Hebrew->new(5780         ) }  "missing month";
dies_ok { Date::Convert::Hebrew->new(5780, 10     ) }  "missing day";

dies_ok { Date::Convert::Hebrew->new(5780, -3,   6) }  "month out of range";
dies_ok { Date::Convert::Hebrew->new(5780, 13,   6) }  "month out of range";
dies_ok { Date::Convert::Hebrew->new(5779, 14,   6) }  "month out of range";

dies_ok { Date::Convert::Hebrew->new(5780, 10,  36) }  "day out of range";
dies_ok { Date::Convert::Hebrew->new(5780, 10,  -6) }  "day out of range";
dies_ok { Date::Convert::Hebrew->new(5780,  2,  30) }  "day out of range";
dies_ok { Date::Convert::Hebrew->new(5781,  8,  30) }  "day out of range";

