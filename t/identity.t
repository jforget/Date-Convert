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

print "1..6\n";

$n=1;

@a=(5730, 3, 2);
@b=(new Date::Convert::Hebrew @a)->date;
if ("@a" eq "@b")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

@a=(5720, 8, 29);
@b=(new Date::Convert::Hebrew @a)->date;
if ("@a" eq "@b")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

@a=(5755, 9, 20);
@b=(new Date::Convert::Hebrew @a)->date;
if ("@a" eq "@b")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

@a=(5730, 3, 2);
@b=(new Date::Convert::Gregorian @a)->date;
if ("@a" eq "@b")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

@a=(5730, 3, 2);
@b=(new Date::Convert::Gregorian @a)->date;
if ("@a" eq "@b")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

@a=(5730, 3, 2);
@b=(new Date::Convert::Gregorian @a)->date;
if ("@a" eq "@b")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;


