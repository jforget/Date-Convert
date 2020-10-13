# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Perl module to convert dates between Gregorian, Julian and Hebrew
#     Copyright © 1997, 2000, 2020 Mordechai Abzug and Jean Forget
#
#     See the license in the embedded documentation below.
#

package Date::Convert;

use utf8;
use strict;
use warnings;
use Carp;
use Date::Convert::Absolute;
use Date::Convert::Gregorian;
use Date::Convert::Hebrew;
use Date::Convert::Julian;

our $VERSION = "0.17";

# methods that every class should have:
# initialize, day, date, date_string

# methods that are recommended if applicable:
# year, month, day, is_leap

my $BEGINNING = 1721426; # 1 Jan 1 in the Gregorian calendar, although technically,
                         # the Gregorian calendar didn't exist at the time.
my $VERSION_TODAY = 2450522; # today in JDN, when I wrote this.


sub new { # straight out of the perlobj manpage:
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->initialize(@_);
    return $self;
}


sub initialize {
  my ($self, $val) = @_;
  $val  = $VERSION_TODAY
    unless defined($val);
  carp "Date::Convert is not reliable before Absolute $BEGINNING"
      if $val < $BEGINNING;
  $self->{absol} = $val;
}



sub _clean {
    my $self  = shift;
    my $key;
    foreach $key (keys %$self) {
	delete $$self{$key} unless $key eq 'absol';
    }
}



sub convert {
    my $class = shift;
    my $self  = shift;
    $self->_clean;
    bless $self, $class;
}

sub absol {
    my $self = shift;
    return $$self{absol};
}

# Instead of the usual boring "1" end-of-package value,
# just celebrate the Dumas-esque achievement of releasing
# version 0.17 in 2020, after version 0.16 in 2000
'Vingt ans après...';

__END__

=head1 NAME

Date::Convert - Convert Between Calendrical Formats

=head1 SYNOPSIS

  use Date::Convert;

  my $date = Date::Convert::Gregorian->new(1997, 11, 27);
  @date    = $date->date;
  Date::Convert::Hebrew->convert($date);
  print $date->date_string, "\n";

=head1 DESCRIPTION

Date::Convert is intended to allow you to convert back and forth between
any arbitrary date formats (ie. pick any from: Gregorian, Julian, Hebrew,
Absolute, and any others that get added on).  It does this by having a
separate subclass for each format, and requiring each class to provide
standardized methods for converting to and from the date format of the base
class.  In this way, instead of having to code a conversion routine for
going between and two arbitrary formats foo and bar, the function only
needs to convert foo to the base class and the base class to bar.  Ie:

  Gregorian <--> Base class <--> Hebrew

The base class includes a B<Convert> method to do this transparently.

Currently defined subclasses:

  Date::Convert::Absolute
  Date::Convert::Gregorian
  Date::Convert::Hebrew
  Date::Convert::Julian

Nothing is exported because it wouldn't make any sense to export.


Functions can be split into several categories:

=over 4

=item *

Universal functions available for all subclasses (ie. all formats).  The
fundamental conversion routines fit this category.

=item *

Functions that are useful but don't necessarily make sense for all
subclasses.  The overwhelming majority of functions fall into this
category.  Even such seemingly universal concepts as year, for instance,
don't apply to all date formats.

=item *

Private functions that are required of all subclasses, ie. B<initialize>.
These should I<not> be called by users.

=back

Here's the breakdown by category:

=head2 Functions Defined for all Subclasses

=over 4

=item new

Create a new object in the specified format with the specified start
parameters, i.e. C<< $date = Date::Convert::Gregorian->new(1974, 11, 27) >>.  The
start parameters vary with the subclass.  My personal preference is to
order in decreasing order of generality (ie. year first, then month, then
day, or year then week, etc.)

This can have a default date, which should probably be "today".

=item date

Extract the date in a format appropriate for the subclass.  Preferably this
should match the format used with B<new>, so

  Date::Convert::SomeClass->new(@a)->date;

should be an identity function on @a if @a is a legitimate input value.

=item date_string

Return the date in a pretty, human-readable, format.

=item convert

Change the date to a new format.

=item absol

Give the absolute  value of the date, that is,  the Julian Day Number,
at noon.

=back

=head2 Non-universal functions

=over 4

=item year

Return just the year element of date.

=item month

Just like year.

=item day

Just like year and month.

=item is_leap

Boolean.  Note that (for B<::Hebrew> and B<::Gregorian>, at least!) this
can be also be used as a static.  That is, you can either say

  $date->is_leap

or

  Date::Convert::Hebrew->is_leap(5757)

=back

=head2 Private functions that are required of all subclasses

You shouldn't call these, but if you want to add a class, you'll need to
write them!  Or it, since at the moment, there's only one.

=over 4

=item initialize

Read in args and initialize object based on their values.  If there are no
args, initialize with the base class's initialize (which will initialize in
the default way described above for B<new>.)  Note the American spelling of
"initialize": "z", not "s".

=back


=head1 SUBCLASS SPECIFIC NOTES

=head2 Absolute

The "Absolute" calendar is just the number of days from a certain reference
point.  Calendar people should recognize it as the "Julian Day Number" with
one minor modification:  When you convert a Gregorian day n to absolute,
you get the JDN of the Gregorian day from noon on.

Since "absolute" has no notion of years it is an extremely easy calendar
for conversion purposes.  I stole the "absolute" calendar format from
Reingold's emacs calendar mode, for debugging purposes.

The subclass is little more than the base class, and as the lowest common
denominator, doesn't have any special functions.

=head2 Gregorian

The Gregorian calendar  is a purely solar calendar, with  a month that
is only  an approximation  of a lunar  month. It is  based on  the old
Julian (Roman)  calendar. This is the  calendar that has been  used by
most of the Western world for the  last few centuries. The time of its
adoption varies  from country  to country. This  B<::Gregorian> allows
you to extrapolate  back to 1 A.D., as per  the programming tradition,
even though the calendar definitely was not in use then.

In addition to the required methods, B<Gregorian> also has B<year>,
B<month>, B<day>, and B<is_leap> methods.  As mentioned above, B<is_leap>
can also be used statically.

=head2 Hebrew

This is the traditional Jewish calendar.  It's based on the solar year, on
the lunar month, and on a number of additional rules created by Rabbis to
make life tough on people who calculate calendars.  :)  If you actually wade
through the source, you should note that the seventh month really does come
before the first month, that's not a bug.

It comes with the following additional methods: B<year>, B<month>, B<day>,
B<is_leap>, B<rosh>, B<part_add>, and B<part_mult>.  B<rosh> returns the
absolute day corresponding to "Rosh HaShana" (New year) for a given year,
and can also be invoked as a static.  B<part_add> and B<part_mult> are
useful functions for Hebrew calendrical calculations are not for much else;
if you're not familiar with the Hebrew calendar, don't worry about them.


=head2 Islamic

The traditional Muslim calendar, a purely lunar calendar with a year that
is a rough approximation of a solar year.  Currently unimplemented.

=head2 Julian

The old Roman calendar, allegedly named for Julius Caesar.  Purely solar,
with a month that is a rough approximation of the lunar month.  Used
extensively in the Western world up to a few centuries ago, then the West
gradually switched over to the more accurate Gregorian.  Now used only by
the Eastern Orthodox Church, AFAIK.


=head1 ADDING NEW SUBCLASSES

This section describes how to extend B<Date::Convert> to add your favorite
date formats.  If you're not interested, feel free to skip it.  :)

There are only three function you I<have> to write to add a new subclass:
you need B<initialize>, B<date>, and B<date_string>.  Of course, helper
functions would probably help. . .  You do I<not> need to write a B<new> or
B<convert> function, since the base class handles them nicely.

First, a quick conceptual overhaul: the base class uses an "absolute day
format" (basically "Julian day format") borrowed from B<emacs>.  This is
just days numbered absolutely from an extremely long time ago.  It's really
easy to use, particularly if you have emacs and emacs' B<calendar mode>.
Each Date::Convert object is a reference to a hash (as in all OO perl) and
includes a special "absol" value stored under a reserved "absol" key.  When
B<initialize> initializes an object, say a Gregorian date, it stores
whatever data it was given in the object and it also calculates the "absol"
equivalent of the date and stores it, too.  If the user converts to another
date, the object is wiped clean of all data except "absol".  Then when the
B<date> method for the new format is called, it calculates the date in the
new format from the "absol" data.

Now that I've thoroughly confused you, here's a more compartmentalized
version:

=over 4

=item initialize

Take the date supplied as argument as appropriate to the format, and
convert it to "absol" format.  Store it as C<$$self{'absol'}>.  You might
also want to store other data, ie. B<::Gregorian> stores C<$$self{'year'}>,
C<$$self{'month'}>, and C<$$self{'day'}>.  If no args are supplied,
explicitly call the base class's initialize,
ie. C<Date::Convert::initialize>, to initialize with a default 'absol' date
and nothing else.

I<NOTE:>  I may move the default behavior into the new constructor.

=item date

Return the date in a appropriate format.  Note that the only fact that
B<date> can take as given is that C<$$self{'absol'}> is defined, i.e. this
object may I<not> have been initialized by the B<initialize> of this
object's class.  For instance, you might have it check if C<$$self{'year'}>
is defined.  If it is, then you have the year component, otherwise, you
calculate year from C<$$self{'absol'}>.

=item date_string

This is the easy part.  Just call date, then return a pretty string based
on the values.

=back


I<NOTE:> The B<::Absolute> subclass is a special case, since it's nearly an
empty subclass (ie. it's just the base class with the required methods
filled out).  Don't use it as an example!  The easiest code to follow would
have been B<::Julian> except that Julian inherits from B<::Gregorian>.
Maybe I'll reverse that. . .


=head1 EXAMPLES

  #!/usr/local/bin/perl5

  use strict;
  use warnings;
  use Date::Convert;

  $date = Date::Convert::Gregorian->new(1974, 11, 27);
  Date::Convert::Hebrew->convert($date);
  print $date->date_string, "\n";

My Gregorian birthday is 27 Nov 1974.  The above prints my Hebrew birthday.

  Date::Convert::Gregorian->convert($date);
  print $date->date_string, "\n";

And that converts it back and prints it in Gregorian.

  $guy = Date::Convert::Hebrew->new(5756, 7, 8);
  print $guy->date_string, " -> ";
  Date::Convert::Gregorian->convert($guy);
  print $guy->date_string, "\n";

Another day, done in reverse.

  @a = (5730, 3, 2);
  @b = Date::Convert::Hebrew->new(@a)->date;
  print "@a\n@b\n";

The above should be an identity for any list @a that represents a
legitimate date.

  #!/usr/local/bin/perl -an

  use Date::Convert;

  $date = Date::Convert::Gregorian->new(@F);
  Date::Convert::Hebrew->convert($date);
  print $date->date_string, "\n";

And that's a quick Greg -> Hebrew conversion program, for those times when
people ask.

=head1 SEE ALSO

perl(1), Date::DateCalc(3)

=head1 VERSION

Date::Convert 0.17 (pre-alpha)

=head1 AUTHORS

Module creator: Mordechai T. Abzug <morty at umbc dot edu>

Unofficial co-maintainer: Jean Forget <JFORGET at cpan dot org>

=head1 ACKNOWLEDGEMENTS AND FURTHER READING

The basic idea of using astronomical dates as an intermediary between all
calculations comes from Dershowitz and Reingold.  Reingold's code is the
basis of emacs's calendar mode.  Two papers describing their work (which I
used to own, but lost!  Darn.) are:

``Calendrical Calculations'' by Nachum Dershowitz and Edward M. Reingold,
I<Software--Practice and Experience>, Volume 20, Number 9 (September,
1990), pages 899-928.  ``Calendrical Calculations, Part II: Three
Historical Calendars'' by E. M. Reingold, N. Dershowitz, and S. M. Clamen,
I<Software--Practice and Experience>, Volume 23, Number 4 (April, 1993),
pages 383-404.

They were also scheduled to come out with a book on calendrical
calculations in Dec. 1996, but as of March 1997, it still isn't out yet.

The Hebrew calendrical calculations are largely based on a cute little
English book called I<The Hebrew Calendar> (I think. . .)  in a box
somewhere at my parents' house.  (I'm organized, see!)  I'll have to dig
around next time I'm there to find it.  If you want to access the original
Hebrew sources, let me give you some advice: Hilchos Kiddush HaChodesh in
the Mishneh Torah is not the Rambam's most readable treatment of the
subject.  He later wrote a little pamphlet called "MaAmar HaEibur" which is
both more complete and easier to comprehend.  It's included in "Mich't'vei
HaRambam" (or some such; I've I<got> to visit that house), which was
reprinted just a few years ago.

Steffen Beyer's Date::DateCalc showed me how to use MakeMaker and write POD
documentation.  Of course, any error is my fault, not his!

=head1 COPYRIGHT AND LICENSE

Copyright  © 1997,  2000, 2020  Mordechai Abzug  and Jean  Forget. All
rights reserved.

This  program  is  free  software. You  can  distribute,  modify,  and
otherwise  mangle Date::Convert::French_Rev  under the  same terms  as
Perl 5.16.3: GNU  Public License version 1 or later  and Perl Artistic
License

You can  find the text  of the licenses  in the F<LICENSE> file  or at
L<https://dev.perl.org/licenses/artistic.html>
and L<https://www.gnu.org/licenses/gpl-1.0.html>.

Here is the summary of GPL:

This program is  free software; you can redistribute  it and/or modify
it under the  terms of the GNU General Public  License as published by
the Free  Software Foundation; either  version 1, or (at  your option)
any later version.

This program  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
General Public License for more details.

You  should have received  a copy  of the  GNU General  Public License
along with  this program; if not,  see <https://www.gnu.org/licenses/>
or write to the Free Software Foundation, Inc., L<https://www.fsf.org>.

=cut
