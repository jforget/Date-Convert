#!perl -w

use Date::Convert;

print "1..114\n";

$n=1;

$date=new Date::Convert::Hebrew(5757, 13, 9);
if ($$date{astro} == 2450526)
    {print "ok $n\n"} else 
    {print "not ok $n\n"}
$n++;

@astros=qw(2447800 2448155 2448509 2448894 2449247 2449602 2449986
	   2450341 2450724 2451078);


foreach $i (5750..5759) {
    my $rosh=rosh Date::Convert::Hebrew $i;
    if ($rosh = shift @astros)
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
