#!/usr/bin/perl -w
#
# ====================================================================
#               ---::: Remove Oldes Files (rof) :::---
# ====================================================================
#
# ====================================================================
#          (c) Copyright by Karl Heinz Marbaise 2005
#                          Release 0.0.3
# ====================================================================
#
use strict;
use Getopt::Long;
use Data::Dumper;

=head1 NAME

rof - remove oldest files.

=head1 SYNOPSIS

rof 

=head1 DESCRIPTION

This script will read the files in the given directory
and check how much files in there. If there are less than
10 files (default value) than nothing will be touched.
If there are more than 10 files the oldest files of the list
will be printed at stdout. With the file list you can use
xargs e.g. to delete the list of files to have only 10 files
in the directory and alway the newest 10 files.

The value of 10 within the above can be changed using the 
command line option --number.

=head1 DETAILS

The sorting of the files is based on the modifictaion time
of the files in the given directory.

=head1 USAGE

rof[.pl] [options] directory

=head1 OPTIONS

=over 4 

=item B<--help>, B<-h>, B<-?>

    Print out Help pages which you are currently reading.

=item B<--number #>

    Give the number of files which should be left untouched.

=item B<--pattern pattern>

    You can change the pattern which will be used to
    check for files if you like to minimize searching 
    just for a limited number of files and not all files.

=back

=head1 AUTHOR

Written by Karl Heinz Marbaise

=head1 REPORTING BUGS

Report Bugs to <rof@soebes.de>

=head1 SEE ALSO

The full documentation of the script can be read as in Texinfo
manual using the following command:


	info rof

=head1 COPYRIGHT

Copyright (C) 2005 by Karl Heinz Marbaise

This program is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation;
either version 2, or (at your option) any later version.

This program is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public
License along with this program; if not, write to the Free
Software Foundation, Inc., 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.

=cut

#
#
my $Version = "0.0.3";
#
my @FileListCleaned = ();
#
my $OptHelp = 0;
my $OptVerbose = 0;
my $OptVersion = 0;
my $OptDirectory = ".";
my $OptPattern = "*";
my $OptNumber = 10;
my $OptJustFilenames = 0;
#
# 
#
#
sub Usage ()
{
	print STDOUT "
NAME
  rof.pl ...

--help			Print out Help
--verbose		produce more output while running...
--version		Print out the version of the Script
--number #		Change the number of files.
--pattern pat	Define the pattern of the files we search for.
--filenames		If set than just filenames will be printed out
				otherwise filenames prefixed by the path will
				printed out.

Examples:

BUGS:

";
}
#
Getopt::Long::config('bundling');
if (! GetOptions(
	"help|h|?"		=> \$OptHelp,
	"version"		=> \$OptVersion,
	"verbose"		=> \$OptVerbose,
	"directory=s"	=> \$OptDirectory,
	"pattern=s"		=> \$OptPattern,
	"number=i"		=> \$OptNumber,
	"filenames"		=> \$OptJustFilenames,
))
{
	print STDERR "\n\nrun rof.pl --help for further help\n";
	exit 1;
};
#
#
# =============================================================================
# ======================= M A I N =============================================
# =============================================================================
#
if ($OptHelp)
{
	Usage ();
	exit 2;
}
if ($OptVersion) {
	print "rof Version $Version\n";
	exit 3;
}
#
if (@ARGV) {
	$OptDirectory = shift @ARGV;
}
print "directory='$OptDirectory'\n" if ($OptVerbose);
print "number='$OptNumber'\n" if ($OptVerbose);
print "pattern='$OptPattern'\n" if ($OptVerbose);
#
my @FileList = `ls -A1t $OptDirectory/$OptPattern`;
#
# remove directory part from the files
# just left the filenames
for my $file (@FileList) {
	chomp $file;
	if ($file =~ /^$OptDirectory\/(.*)$/ && $OptJustFilenames) {
		push @FileListCleaned, $1;
		print "File: $1 added\n" if ($OptVerbose);
	} else {
		push @FileListCleaned, $file;
		print "File: $1 added\n" if ($OptVerbose);
	}
}

print "Anzahl ", scalar(@FileListCleaned), " in der Liste\n" if ($OptVerbose);

if (scalar(@FileListCleaned) > $OptNumber) {
	print "Anzahl > 10\n" if ($OptVerbose);
	# Löschliste anlegen
	# die ältesten bis wir bis max. 10 Einträge haben.
	# Die ältesten erhalten wir, da wir Anhand modification time 
	# sortiert haben.
	my $result = $#FileListCleaned - $OptNumber;
	for (my $i=0; $i<=$result; $i++) {
		print $FileListCleaned[$i + $OptNumber], "\n";
	}
}
exit 0;
