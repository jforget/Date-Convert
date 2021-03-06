#
#     Configuration script for Date::Convert
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
use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'             => 'Date::Convert'
  , 'VERSION_FROM'     => 'lib/Date/Convert.pm'
  , 'ABSTRACT'         => 'Date conversions between Gregorian, Hebrew and Julian'
  , 'AUTHOR'           => [ 'Mordechai Abzug', 'Jean Forget <JFORGET@cpan.org>' ],
  , 'LICENSE'          => 'perl'
  , 'MIN_PERL_VERSION' => '5.6.0'
  , 'BUILD_REQUIRES'   => { 'Test::More'      => '0'
                          , 'ExtUtils::MakeMaker' => '6.57_02'
                           },
   , META_MERGE       => {
       'meta-spec'      => { version => 2 },
       'dynamic_config' => 0,
       'prereqs' => {
          'build' => {
             'requires' => {
                'ExtUtils::MakeMaker' => '6.57_02'
             }
          },
          'configure' => {
             'requires' => {
                'ExtUtils::MakeMaker' => '6.57_02'
             }
          },
          'runtime' => {
             'requires' => {
                 'POSIX'           => '0'
               , 'strict'          => '0'
               , 'warnings'        => '0'
               , 'Carp'            => '0'
               , 'perl'            => '5.006000'
             }
          },
          'test' => {
             'recommends' => {
                  'Test::Exception' => '0'
             }
          },
       },
       provides       => {
           'Date::Convert' => {
                file => 'lib/Date/Convert.pm',
                version => '0.17',
           },
           'Date::Convert::Absolute' => {
                file => 'lib/Date/Convert/Absolute.pm',
                version => '0.17',
           },
           'Date::Convert::Gregorian' => {
                file => 'lib/Date/Convert/Gregorian.pm',
                version => '0.17',
           },
           'Date::Convert::Hebrew' => {
                file => 'lib/Date/Convert/Hebrew.pm',
                version => '0.17',
           },
           'Date::Convert::Julian' => {
                file => 'lib/Date/Convert/Julian.pm',
                version => '0.17',
           },
       },
       resources => {
           repository => {
               type => 'git',
               url  => 'https://github.com/jforget/Date-Convert.git',
               web  => 'https://github.com/jforget/Date-Convert',
           },
       },
    },
);

