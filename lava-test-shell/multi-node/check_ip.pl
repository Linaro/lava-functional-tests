#!/usr/bin/perl
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  

=pod

=head1 Name

check_ip.pl  -  perl script to check IP addresses in the group per role

=head1 Description

Unlike the shell version F<check_ip.sh>, the perl version can accept an
optional argument for the role and filter the group by that role. Only
devices with the matching role will be checked.

Without the optional argument, F<check_ip.pl> works in the same way as
F<check_ip.sh>.

F<check_ip.pl> requires only a minimal perl setup.

=cut

use strict;
use warnings;
use vars qw/ $role $group $line /;

# accept the optional role argument
$role = shift;

# lava-group is tab separated
for $line (`lava-group`) {
	chomp($line);
	if ($line eq "") {
		next;
	}
	$line =~ /(.*)\t.*/;
	if (defined $role and $line !~ /(.*)\t$role/) {
		next;
	}
	my $device = $1;
	$device =~ s/\s+//g;
	print "Testing $device from '$line'\n";
	# get the ipv4 for this device
	my $addr = `lava-network query $device ipv4`;
	if (not defined $addr) {
		next;
	}
	# cover debug usage.
	chomp($addr);
	$addr =~ s/<LAVA.*>//g;
	$addr =~ s/\s//g;
	$addr =~ s/\n//g;
	# strip off the prefix for ipv4
	$addr =~ s/^addr://;
	system("ping -c1 -W1 $addr");
}
