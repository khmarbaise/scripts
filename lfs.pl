#!/usr/bin/perl -w
#
# (c) 2003 by Karl Heinz Marbaise
#
#
# $Id: lfs.pl,v 1.3 2003/08/29 10:27:20 kama Exp $

=head1 NAME

lfs - LogFileSplitter Script 

=head1 SYNOPSIS

lfs.pl --week access.log

lfs.pl --day access.log

lfs.pl --month access.log

=head1 DESCRIPTION

The LogFileSplitter (lfs) Script will help to split your Web-Server
logfiles into managable chunks.

This script extracts Log information out of an existing access.log which
usualy is created by Apache Web-Server.

The isue of this script is to extract e.g. daily based data out of 
an weekly based log file.

=head1 USAGE

lfs[.pl] [options] logfile

=head1 OPTIONS

--help, -h, -?  
    Print out Help pages which you are currently reading.

--version, -v
    Will print out the version of the script

--verbose
    produce more output while running...

--day
    This will produce out of the given Logfile
    files which will be named D#.log where
    # will be replaced by the day number in
    year.

--month
    This will produce out of the given log file
    files which will be named M#.log where
    # will be replaced by the month number
    in the year.

--week
    This will produce out of the given log file
    files which will be named W#.log where
    # will be replaced by the week number
    in the year.

--checksize
    Caclulate the summ of transfered data
    in Log-File


=head1 AUTHOR

Written by Karl Heinz Marbaise

=head1 REPORTING BUGS

Report Bugs to <khmarbaise\@gmx.de>

=head1 SEE ALSO

man(1), logresolvemerge.pl(1)

The logresolvemerge.pl Script is part of the AwStats packacke
http://awstats.sourceforge.net

Information about Apache Web-Server Log-File format can be
found here: http://httpd.apache.org/docs/logs.html

=head1 COPYRIGHT

Copyright (C) 2003 by Karl Heinz Marbaise

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

# $Id: lfs.pl,v 1.3 2003/08/29 10:27:20 kama Exp $
#
use strict;
#
# Command line argument analyzing
use Getopt::Long;
use Getopt::Std;
#
# Debugging puposes
use Data::Dumper;
#
use Date::Calc qw(:all);
use Date::Manip;
#
# Use it to be able to read/write compressed files (gzip)
use Compress::Zlib;
#
#
my $LFSEmail = "khmarbaise\@gmx.de";
my $LFSRelease = "1.0.2RC1";
#
#
my $OptHelp = 0;
my $OptVersion = 0;
my $OptVerbose = 0;
my $OptWeekLog = 0;
my $OptDayLog = 0;
my $OptMonthLog = 0;
my $OptCheckSize = 0;
#
#
my $Copyright = "$LFSRelease";

my $Version="lfs V$LFSRelease

Copyright (C) 2003 by Karl Heinz Marbaise

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
";

#
#
#
#
my $Usage = "
NAME
    lfs.pl -- The LogFileSplitter Script

DESCRIPTION
    The LogFileSplitter (lfs) Script will help to split your Web-Server
    logfiles into managable chunks.

    This script extracts Log information out of an existing access.log which
    usualy is created by Apache Web-Server.

    The isue of this script is to extract e.g. daily based data out of 
    an weekly based log file.


USAGE
    lfs[.pl] [Options] File

OPTIONS
    --help, -h, -?  
        Print out Help pages which you are currently reading.

    --version, -v
        Will print out the version of the script

    --verbose
        produce more output while running...

    --day
        This will produce out of the given Logfile
        files which will be named D#.log. Where
        # will be replaced by the day number in
        year.

    --month
        This will produce out of the given log file
        files which will be named M#.log. Where
        # will be replaced by the month number
        in the year.

    --week
        This will produce out of the given log file
        files which will be named W#.log. Where
        # will be replaced by the week number
        in the year.

    --checksize
        This will calculate the summ of transfered data
        within the given log file. This will count
        all values which have an entry for transfered bytes
        in log file. 

AUTHOR
    Written by Karl Heinz Marbaise

REPORTING BUGS
    Report Bugs to <khmarbaise\@gmx.de>

SEE ALSO

    man(1), logresolvemerge.pl(1)

    The logresolvemerge.pl Script is part of the AwStats packacke
    http://awstats.sourceforge.net

    Information about Apache Web-Server Log-File format can be
    found here: http://httpd.apache.org/docs/logs.html

";
#
#
#
#
# =============================================================================
# ======================= M A I N =============================================
# =============================================================================
#
#
#
# Read Option of command line
#
Getopt::Long::config('bundling');
if (! GetOptions(
	"help|h|?"		=> \$OptHelp,
	"version"		=> \$OptVersion,
	"verbose"		=> \$OptVerbose,
	"week"			=> \$OptWeekLog,
	"day"			=> \$OptDayLog,
	"month"			=> \$OptMonthLog,
	"checksize"		=> \$OptCheckSize,
))
{
	print STDERR "\n\nrun lfs.pl --help for further help\n";
	exit 2;
};
#
#
#
if ($OptVersion)
{
	print STDOUT $Version, "\n";
	exit 0;
}

if ($OptHelp)
{
	print STDOUT $Usage, "\n";
	exit 0;
}
#
# 
#
if (scalar(@ARGV) < 1)
{
	print STDERR "You have to give a file name while you call lfs.pl!\n";
	exit 1;
}
#
my $sOptInputFileName = $ARGV[0];
#
#
#
print "Creating Month based log files...\n" if ($OptMonthLog);
print "Creating Week based log files...\n" if ($OptWeekLog);
print "Creating Daily based log files...\n" if ($OptDayLog);
print "Calculating transfered Data size...\n" if ($OptCheckSize);

open (ACCESSLOG, $sOptInputFileName) or die "Can't open file $sOptInputFileName: $!\n";

my $iCurrentMonth = 0;
my $iCurrentWeek = 0;
my $iCurrentDayOfYear = 0;

my $bMonthLogOpen = 0;
my $bWeekLogOpen = 0;
my $bDayLogOpen = 0;

my $iSizeLogFile = 0;

while (<ACCESSLOG>)
{
	if ($OptCheckSize)
	{
		###if (/\[\d+\/.*?\/\d+\:\d+\:\d+\:\d+ .*?\] (\".*?\") (\d+) (.*?) (\".*?\") (\".*?)\"$/)
		if (/\[\d+\/.*?\/\d+\:\d+\:\d+\:\d+ .*?\] (\".*?\")\s+(\d+)\s+(\d+)/)
		{
			#print STDOUT 'GET String: "' . $1 . '" Code: ' . $2 . ' Size=' . $3 . "\n";
			$iSizeLogFile += $3;
		}
	}
	#Get Date from Apache Log...[09/May/2003:18:52:06 +0200]
	if (/\[((\d+)\/(.*?)\/(\d+)\:(\d+)\:(\d+)\:(\d+) (.*?))\]/)
	{
		my $iDay = $2;
		my $sMonth = $3;
		my $iYear = $4;
		my $iHour = $5;
		my $iMinute = $6;
		my $iSeconds = $7;
		my $sTimeZoneOffset = $8;

		my $iMonth = Decode_Month ($sMonth);
		##print STDOUT "Scanned Date $iDay $sMonth/$iMonth $iYear $iHour $iMinute $iSeconds $sTimeZoneOffset\n";

		my $iDayOfYear = Day_of_Year($iYear,$iMonth,$iDay);
		my ($iWeek,$iYearBelongsWeekTo) = Week_of_Year($iYear,$iMonth,$iDay);
		## Correct value.. into 0...n-1 format...
		$iWeek --;

		
		if ( ($iDayOfYear != $iCurrentDayOfYear) && $OptDayLog)
		{
			if ($bDayLogOpen)
			{
				close (DAYLOG);
				$bDayLogOpen = 0;
			}
			if (!$bDayLogOpen)
			{
				open (DAYLOG, ">D" . $iDayOfYear . ".log") or die "Can't open file $iDayOfYear: $!\n";
				$bDayLogOpen = 1;
			}
			$iCurrentDayOfYear = $iDayOfYear;
		}

		if ( ($iWeek != $iCurrentWeek) && $OptWeekLog)
		{
			if ($bWeekLogOpen)
			{
				close (WEEKLOG);
				$bWeekLogOpen = 0;
			}
			if (!$bWeekLogOpen)
			{
				open (WEEKLOG, ">W" . $iWeek . ".log") or die "Can't open file $iWeek: $!\n";
				$bWeekLogOpen = 1;
			}
			$iCurrentWeek = $iWeek;
		}

		if ( ($iMonth != $iCurrentMonth) && $OptMonthLog)
		{
			if ($bMonthLogOpen)
			{
				close (MONTHLOG);
				$bMonthLogOpen = 0;
			}
			if (!$bMonthLogOpen)
			{
				open (MONTHLOG, ">M" . $iMonth . ".log") or die "Can't open file $iMonth: $!\n";
				$bMonthLogOpen = 1;
			}
			$iCurrentMonth = $iMonth;
		}
		

		print DAYLOG $_ if ($bDayLogOpen && $OptDayLog);
		print WEEKLOG $_ if ($bWeekLogOpen && $OptWeekLog);
		print MONTHLOG $_ if ($bMonthLogOpen && $OptMonthLog);
	}
}
close(ACCESSLOG);


print STDOUT "Calculcated Transfered Data Size: " . $iSizeLogFile . "\n" if ($OptCheckSize);

exit 0;
