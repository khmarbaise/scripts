#!/usr/bin/perl -w
#
# (c) 2008 by Karl Heinz Marbaise
#
#
# $Id$

=head1 NAME

ses - Size Extraction Script

=head1 SYNOPSIS

ses.pl access.log


=head1 DESCRIPTION

The Size Extraction Script is intended to extract the
size of transfered data from an Apache log file.

=head1 USAGE

ses[.pl] [options] logfile

=head1 OPTIONS

--help, -h, -?  
    Print out Help pages which you are currently reading.

--version, -v
    Will print out the version of the script

--verbose
    produce more output while running...


=head1 AUTHOR

Written by Karl Heinz Marbaise

=head1 REPORTING BUGS

Report Bugs to <ses\@soebes.de>

=head1 SEE ALSO

=head1 COPYRIGHT

Copyright (C) 2008 by Karl Heinz Marbaise

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

# $Id$
#
use strict;
#
# Command line argument analyzing
use Getopt::Long;
use Getopt::Std;
#
# Use it to be able to read/write compressed files (gzip)
use Compress::Zlib;

#
#
my $LFSEmail = "khmarbaise\@gmx.de";
my $LFSRelease = "0.1";
#
#
my $OptHelp = 0;
my $OptVersion = 0;
my $OptVerbose = 0;
#
my $Copyright = "$LFSRelease";

my $Version="ses V$LFSRelease

Copyright (C) 2008 by Karl Heinz Marbaise

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
    ses.pl -- The Size Extraction Script

DESCRIPTION


USAGE
    ses[.pl] [Options] File

OPTIONS
    --help, -h, -?  
        Print out Help pages which you are currently reading.

    --version, -v
        Will print out the version of the script

    --verbose
        produce more output while running...

AUTHOR
    Written by Karl Heinz Marbaise

REPORTING BUGS
    Report Bugs to <khmarbaise\@gmx.de>


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
))
{
	print STDERR "\n\nrun ses.pl --help for further help\n";
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
	print STDERR "You have to give a file name while you call ses.pl!\n";
	exit 1;
}

my $iSizeLogFile = 0;
my $iHits = 0;
foreach my $sOptInputFileName (@ARGV) {
	open (ACCESSLOG, $sOptInputFileName) or die "Can't open file $sOptInputFileName: $!\n";

	while (<ACCESSLOG>)
	{
		#83.220.33.86 - - [18/Oct/2008:02:24:27 +0200] "GET /admin/phpmyadmin/main.php HTTP/1.0" 404 223 "-" "-"
		###if (/\[\d+\/.*?\/\d+\:\d+\:\d+\:\d+ .*?\] (\".*?\") (\d+) (.*?) (\".*?\") (\".*?)\"$/)
		if (/\[\d+\/.*?\/\d+\:\d+\:\d+\:\d+ .*?\] (\".*?\")\s+(\d+)\s+(\d+)/)
		{
			#print STDOUT 'GET String: "' . $1 . '" Code: ' . $2 . ' Size=' . $3 . "\n";
			$iSizeLogFile += $3;
			$iHits ++;
		} else {
			print "Line: $_\n";
		}
	}
	close(ACCESSLOG);
}
#
#
#
#



print STDOUT "Calculcated Transfered Data Size: " . $iSizeLogFile . "\n";
print STDOUT "Hits: " . $iHits . "\n";

exit 0;
