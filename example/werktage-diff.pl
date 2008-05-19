#!/usr/bin/perl -w
use strict;
use warnings;
use Date::Holidays::DE qw(holidays);
use Date::Business;

# Sample script for integration of Date::Holidays::DE with Date::Business

# Script by Martin Schmitt <mas at scsy dot de>

# Calculate the difference between two dates using three different
# methods from Date::Business

my $startdate = "20030414";    # Monday before Easter 2003
my $enddate   = "20030428";    # Monday after Easter monday 2003
my $year      = "2003";        # Not particularly elaborate, but okay for now

print "Abstand zwischen $startdate und $enddate...\n";

# 1. Not excluding weekends and holidays (Should be 14 days difference)
#
# Initialize start and ending dates
my $start1    = new Date::Business(DATE => $startdate);
my $end1      = new Date::Business(DATE => $enddate);
my $diff1     = $end1->diff($start1);
print "$diff1 Tage (Wochenenden und Feiertage unberücksichtigt)\n";

# 2. Excluding weekends (Should be 10 days difference)
#
# Initialize start and ending dates
my $start2    = new Date::Business(DATE => $startdate);
my $end2      = new Date::Business(DATE => $enddate);
my $diff2     = $end2->diffb($start2);
print "$diff2 Tage (Wochenenden berücksichtigt, Feiertage unberücksichtigt)\n";

# 3. Excluding weekends and holidays (Should be 8 days difference)
#
# Prepare a subroutine for use by Date::Business
sub business_holiday{
	my ($start, $end) = @_;
	my $count;
	# Get the holiday list from Date::Holidays::DE
	my @holidays = @{holidays(YEAR=>$year, 
				  FORMAT => "%Y%m%d", # This is important here
				  WEEKENDS => 0)};
	foreach (@holidays){
		# Count holidays between the start and end dates
		$count++ if (($start <= $_) and ($_ <= $end));
	}
	return $count;
}

# Initialize start and ending dates including reference to the above subroutine
my $start3    = new Date::Business(DATE => $startdate,
				   HOLIDAY => \&business_holiday);
my $end3      = new Date::Business(DATE => $enddate,
				   HOLIDAY => \&business_holiday);
my $diff3     = $end3->diffb($start3);
print "$diff3 Tage (Wochenenden und Feiertage berücksichtigt)\n";

exit 0;
