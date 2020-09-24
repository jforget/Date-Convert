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

print "1..137\n";

$n=1;

$date=new Date::Convert::Hebrew(5757, 13, 9);
if ($$date{absol} == 2450526)
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

@absols=qw(2447800 2448155 2448509 2448894 2449247 2449602 2449986
	   2450341 2450724 2451078 2451433 2451818 2452171 2452525
	   2452910 2453265 2453648 2454002 2454357 2454740 2455094
	   2455449 2455834 2456188 2456541 2456926 2457280 2457665
	   2458018 2458372 2458757
	);


foreach $i (5750..5780) {
    my $rosh=rosh Date::Convert::Hebrew $i;
    if ($rosh = shift @absols)
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;
}


$rina_birthday=new Date::Convert::Gregorian(1976, 5, 25);
if ($rina_birthday->date_string eq "1976 May 25")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

convert Date::Convert::Hebrew $rina_birthday;
if ($rina_birthday->date_string eq "5736 Iyyar 25")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

convert Date::Convert::Gregorian $rina_birthday;
if ($rina_birthday->date_string eq "1976 May 25")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

my $broken_date=new Date::Convert::Hebrew(5765, 10, 26);
if ($broken_date->date_string eq "5765 Teves 26")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

convert Date::Convert::Gregorian $broken_date;
if ($broken_date->date_string eq "2005 Jan 7")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;


@leaps=qw(0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1 
	  0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1 
	  0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1 
	  0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1 
	  0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 1 
	  0 0 1 0 0);

foreach $i (1..100) {
    if (is_leap Date::Convert::Hebrew($i) == shift @leaps)
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;
}

print "\n";
