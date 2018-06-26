#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

my $existingKeys = '10mx1m@040fix 10mx1m@040fix 10mx2m@060fix 12mx1m@040fix 12mx1m@060fix 12mx1m@060fix 12mx1m@080fix 12mx1m@100fix 12mx1m@120fix 12mx1m@140fix 250x40 250x60 2mx1m@020 2mx1m@020fix 2mx1m@040 2mx1m@040fix 2mx1m@060 2mx1m@060fix 2mx1m@080 2mx1m@080fix 2mx1m@100 2mx1m@100fix 2mx1m@100fix 2mx2m@020 2mx2m@040 2mx2m@060 2mx2m@080 2mx2m@100 300x60 3mx2m@020 3mx2m@020fix 3mx2m@040 3mx2m@040fix 3mx2m@060 3mx2m@060fix 3mx2m@080 3mx2m@100 3mx3m@040 4mx1m@000 4mx1m@020 4mx1m@040 4mx1m@040fix 4mx1m@060 4mx1m@140 4mx2m@020 4mx2m@040 4mx2m@060 4mx2m@080 4mx2m@100 4mx3m@040 4mx3m@060 5mx2m@020 5mx2m@020fix 5mx2m@040 5mx2m@040fix 5mx2m@060 5mx2m@060fix 5mx2m@120 6mx1m@080 6mx1m@080fix 6mx2m@020 6mx2m@020fix 6mx2m@040 6mx2m@040fix 6mx2m@060 6mx2m@060fix 6mx2m@080 6mx3m@040 7mx2m@060fix 8mx1m@020 8mx1m@020fix 8mx1m@040 cancel ciseau custom N/A paleo xxx';



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
                            if (index($existingKeys,$formatedPrat) == -1) {
                                print "\tkey not found: $formatedPrat";

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
        $str =~ s/^ciseaux$/ciseau/g;
        $str =~ s/^AR$/N\/A/g;
        $str =~ s/^2x2x40\s\(no\sroue\)$/2mx2m\@040fix/g;
        $str =~ s/^4x1x100\s\(no\sroue\)$/4mx1m\@100fix/g;
        $str =~ s/^2x1x60\s\(no\sroue\)$/2mx1m\@060fix/g;
        if ($str =~ /^\d/) {
            $str = lc $str;
            $str =~ s/TBC//g;
            $str =~ s/\s//g;
            $str =~ s/\.//g;
            $str =~ s#'##g;
            $str =~ s/^8x1$/3mx2m\@020/g;
            $str =~ s/^1x1x50$/2mx1m\@040/g;          
            $str =~ s/^1x1x50$/2mx1m\@040/g;          
            $str =~ s/^5x3x50$/6mx3m\@040/g;
            $str =~ s/^1x8$/2mx1m\@020/g;
            $str =~ s/^2x2x50$/2mx2m\@040/g;
            $str =~ s/^2x1x50$/2mx1m\@040/g;
            $str =~ s/^3x2x50$/3mx2m\@040/g;
            $str =~ s/^4x2x50$/4mx2m\@040/g;
            $str =~ s/^4x15x40$/4mx2m\@040/g;
            $str =~ s/^4x3x50$/4mx3m\@040/g;
            $str =~ s/^8x4$/2mx1m\@020/g;
            $str =~ s/^4x8/2mx1m\@020/g;
            $str =~ s/^8x4x1$/2mx1m\@020/g;
            $str =~ s/^8x4x2$/2mx1m\@040/g;
            $str =~ s/^8x8x2$/3mx2m\@060/g;
            $str =~ s/^8x8x1$/3mx2m\@020/g;
            $str =~ s/^8x8x12$/3mx2m\@040/g;
            $str =~ s/^8x6x1$/3mx2m\@020/g;
            $str =~ s/^8x8$/2mx3m\@020/g;
            $str =~ s/10x8x1/3mx3m\@060/g;
            $str =~ s/x/mx/g;
            $str =~ s/mmx/mx/g;
            $str =~ s/12mx1mx40/12mx1m\@040fix/g;
            $str =~ s/12mx1mx60/12mx1m\@060fix/g;
            $str =~ s/12mx1mx80/12mx1m\@080fix/g;
            $str =~ s/12mx1mx100/12mx1m\@100fix/g;
            $str =~ s/12mx1mx120/12mx1m\@120fix/g;
            $str =~ s/12mx1mx140/12mx1m\@140fix/g;
            $str =~ s/^(.*)m$/$1/;
            $str =~ s/x20$/\@020/g;
            $str =~ s/02$/020/g;
            $str =~ s/x30$/\@040/g;
            $str =~ s/x40$/\@040/g;
            $str =~ s/04$/040/g;
            $str =~ s/05$/040/g;
            $str =~ s/x60$/\@060/g;
            $str =~ s/06$/060/g;
            $str =~ s/x80$/\@080/g;
            $str =~ s/08$/080/g;
            #$str =~ s/1$/100/g;
            $str =~ s/x100$/\@100/g;
            $str =~ s/mx1$/m\@100/g;
            $str =~ s/mx2$/m\@200/g;
            $str =~ s/mx\?/m\@xxx/g;
            
            if ($str =~ /^([0-9])mx([0-9])m\@([0-9]+)$/) {
                if ($2 > $1) {
                    $str = $2 . "mx" . $1 . "m\@" . $3;
                }
            } else {
                #$str = "key not found";
            }
            if ($str eq '2mx1m@100' || $str eq '2mx1m@80') {
                $str = "ciseau";
            }
        } else {
            #$str = "xxx";
        }
    } else {
        $str = "xxx";
    }
    return $str;
}
