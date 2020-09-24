#!perl -w
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Test script for Date::Convert
#     Copyright © 1997, 2000, 2020 Mordechai Abzug and Jean Forget
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

use Date::Convert;

print "1..9\n";

$n=1;

$a=1757642;
$date=new Date::Convert::Absolute($a);
if ($date->date == 1757642)
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

convert Date::Convert::Julian $date;
if ($date->date_string eq "100 Feb 29")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

convert Date::Convert::Absolute $date;
if ($date->date_string eq "1757642")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

$date=new Date::Convert::Gregorian(1997, 4, 15);
convert Date::Convert::Julian $date;
if ($date->date_string eq "1997 Apr 2")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;


convert Date::Convert::Gregorian $date;
if ($date->date_string eq "1997 Apr 15")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

$date=new Date::Convert::Julian(1999, 9, 25);
if ($date->date_string eq "1999 Sep 25")
    {print "ok $n\n"} else
    {print "no ok $n\n"}
$n++;

convert Date::Convert::Gregorian $date;
if ($date->date_string eq "1999 Oct 8")
    {print "ok $n\n"} else
    {print "no ok $n\n"}
$n++;

$date=new Date::Convert::Julian(1999, 12, 18);
convert Date::Convert::Gregorian $date;
if ($date->date_string eq "1999 Dec 31")
    {print "ok $n\n"} else
    {print "no ok $n\n"}
$n++;

$date=new Date::Convert::Julian(1999, 12, 19);
convert Date::Convert::Gregorian $date;
if ($date->date_string eq "2000 Jan 1")
    {print "ok $n\n"} else
    {print "no ok $n\n"}
$n++;


