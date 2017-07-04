#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

my $existingKeys = '10mx1m@040fix 10mx2m@060fix 12mx1m@060fix 250x40 250x60 2mx1m@020 2mx1m@020fix 2mx1m@040 2mx1m@040fix 2mx1m@060 2mx1m@060fix 2mx1m@080 2mx1m@080fix 2mx1m@100 2mx1m@100fix 2mx1m@100fix 2mx2m@020 2mx2m@040 2mx2m@060 2mx2m@080 2mx2m@100 300x60 3mx2m@020 3mx2m@040 3mx2m@040fix 3mx2m@060 3mx2m@060fix 3mx2m@080 3mx2m@100 3mx3m@040 4mx1m@000 4mx1m@020 4mx1m@040 4mx1m@040fix 4mx1m@060 4mx1m@140 4mx2m@020 4mx2m@040 4mx2m@060 4mx2m@080 4mx2m@100 5mx2m@020 5mx2m@020fix 5mx2m@040 5mx2m@040fix 5mx2m@060 5mx2m@060fix 5mx2m@120 6mx1m@080fix 6mx2m@020fix 6mx2m@040 6mx2m@040fix 6mx2m@060 6mx2m@060fix 6mx2m@080 7mx2m@060fix cancel ciseau custom N/A paleo xxx';



print "day\tstage\tband\tneed\tkey\n";
while (<>) {
    chomp;
    my @columns = split /\t/;
    if(@columns) {
        my $day = $columns[0];
        if ($day ne 'Jour') {
            my $stage = $columns[1];
            if ($stage) {
                if ($stage eq 'VM') {
                    $stage = "DO";
                } elsif ($stage eq 'AR') {
                    $stage = "ARC";
                } elsif ($stage eq 'DT') {
                    $stage = "DET";
                }

                my $band = $columns[2];
                my $c = 0;
                for (my $i = 1; $i <= 12; $i++) {
                    if (@columns >= 3+$i) {
                        my $prat = $columns[(2*$i)+1];
                        my $sol = $columns[(2*$i)+2];
                        if ($prat || $sol) {
                            $c++;
                            print $day . "\t" . $stage . "\t" . $band;
                            if ($c>1) {
                                print " (" . $c . ")";
                            }
                            print "\t" . $prat;
                            my $sol = $columns[(2*$i)+2];
                            if ($sol) {
                                print " (" . $sol . ")";
                            }
                            my $formatedPrat = formatNeed($prat);
                            if ($formatedPrat eq "xxx") {
                                my $tempFormatedPrat = formatNeed($sol);
                                if ($tempFormatedPrat &&  $tempFormatedPrat ne "xxx") {
                                    $formatedPrat = $tempFormatedPrat;
                                }
                            }
                            print "\t"  . $formatedPrat;
                            if (index($existingKeys,$existingKeys) == -1) {
                                print "\tkey not found";

                            }
                            print "\n";
                        }
                    }
                }
            }
        }
    }
}

sub formatNeed {
    my $str = $_[0];
    if ($str) {
        if ($str =~ /^\d/) {
            $str = lc $str;
            $str =~ s/TBC//g;
            $str =~ s/\s//g;
            $str =~ s/\.//g;
            $str =~ s#'##g;
            $str =~ s/^8x1$/3mx2m\@020/g;
            $str =~ s/^1x8$/2mx1m\@020/g;
            $str =~ s/^8x4$/2mx1m\@020/g;
            $str =~ s/8x4x1/2mx1m\@020/g;
            $str =~ s/8x8x2/3mx2m\@060/g;
            $str =~ s/8x8x1/3mx2m\@020/g;
            $str =~ s/8x6x1/3mx2m\@020/g;
            $str =~ s/10x8x1/3mx3m\@060/g;
            $str =~ s/x/mx/g;
            $str =~ s/mmx/mx/g;
            $str =~ s/^(.*)m$/$1/;
            $str =~ s/x20$/\@020/;
            $str =~ s/02$/020/;
            $str =~ s/x30$/\@040/;
            $str =~ s/x40$/\@040/;
            $str =~ s/04$/040/;
            $str =~ s/05$/040/;
            $str =~ s/x60$/\@060/;
            $str =~ s/06$/060/;
            $str =~ s/x80$/\@080/;
            $str =~ s/08$/080/;
            $str =~ s/1$/100/;
            $str =~ s/x100$/\@100/;
            $str =~ s/mx1$/m\@100/;
            $str =~ s/mx2$/m\@200/;
            $str =~ s/mx\?/m\@xxx/;
            if ($str =~ /^([0-9])mx([0-9])m\@([0-9]+)$/) {
                if ($2 > $1) {
                    $str = $2 . "mx" . $1 . "m\@" . $3;
                }
            } else {
                $str = "xxx";
            }
            if ($str eq '2mx1m@100' || $str eq '2mx1m@80') {
                $str = "ciseau";
            }
        } else {
            $str = "xxx";
        }
    } else {
        $str = "xxx";
    }
    return $str;
}
