# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Utility module to deal with daycounts (or Absolute dates) in Date::Convert
#     Copyright © 1997, 2000, 2020 Mordechai Abzug and Jean Forget
#
#     See the license in the embedded documentation below.
#

# Here's a quickie, based on the base class.

package Date::Convert::Absolute;

use utf8;
use strict;
use warnings;
use Date::Convert;

our @ISA     = qw ( Date::Convert );
our $VERSION = "0.17";

sub initialize {
  return Date::Convert::initialize(@_);
}

sub date {
    my $self=shift;
    return $$self{'absol'};
}

sub date_string {
    my $self=shift;
    my $date=$self->date; # just a scalar
    return "$date";
}

# Instead of the usual boring "1" end-of-package value,
# just celebrate the Dumas-esque achievement of releasing
# version 0.17 in 2020, after version 0.16 in 2000
'Vingt ans après...';

__END__

=head1 NAME

Date::Convert::Absolute - Utility module to deal with daycounts (or Absolute dates) in Date::Convert

=head1 DESCRIPTION

See the full documentation in the main module L<Date::Convert>.

=head1 NOTES ON ABSOLUTE PACKAGE

The "Absolute"  calendar is  just the  number of  days from  a certain
reference point.  Calendar people should  recognize it as  the "Julian
Day Number" with one minor  modification: When you convert a Gregorian
day I<n> to absolute,  you get the JDN of the  Gregorian day from noon
on.

Since  "absolute" has  no  notion of  years it  is  an extremely  easy
calendar  for conversion  purposes.  I stole  the "absolute"  calendar
format from Reingold's emacs calendar mode, for debugging purposes.

The subclass  is little more  than the base  class, and as  the lowest
common denominator, doesn't have any special functions.

=head1 AUTHORS

Module creator: Mordechai T. Abzug <morty at umbc dot edu>

Unofficial co-maintainer: Jean Forget <JFORGET at cpan dot org>

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
