#!perl -w

use Date::Convert;

print "1..5\n";

$n=1;

$a=1757642;
$date=new Date::Convert::Astro($a);
if ($date->date == 1757642)
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

convert Date::Convert::Julian $date;
if ($date->date_string eq "100 Feb 29")
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

convert Date::Convert::Astro $date;
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

