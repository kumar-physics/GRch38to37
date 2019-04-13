#!/usr/bin/perl
use warnings;
use lib "$ENV{HOME}/src/bioperl-1.6.924";
use lib "$ENV{HOME}/src/ensembl/modules";
use lib "$ENV{HOME}/src/ensembl-compara/modules";
use lib "$ENV{HOME}/src/ensembl-variation/modules";
use lib "$ENV{HOME}/src/ensembl-funcgen/modules";
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Feature;



my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'useastdb.ensembl.org', # alternatively 'useastdb.ensembl.org''ensembldb.ensembl.org'
    -user => 'anonymous'
);
my $slice_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Slice' );#95939-100939
my $slice = $slice_adaptor->fetch_by_region( 'chromosome', '10', 25000, 30000,1,'GRch38' );
# The method coord_system() returns a Bio::EnsEMBL::CoordSystem object
my $coord_sys  = $slice->coord_system()->name();
my $coord_ver  = $slice->coord_system()->version();
my $seq_region = $slice->seq_region_name();
my $start      = $slice->start();
my $end        = $slice->end();
my $strand     = $slice->strand();
print "Input Slice: $coord_sys $coord_ver $seq_region $start-$end ($strand)\n\n";

my $feat = new Bio::EnsEMBL::Feature(
    -start => 95939,
    -end  => 100939,
    -strand => 1,
    -slice => $slice
);
print "Slice converted using transform method\n";
if ( my $new_feature = $feat->transform('chromosome','GRch38') ) {
    printf(
        "Output Slice: %s %d-%d (%+d) %s\n\n",
        $new_feature->slice->seq_region_name(),
        $new_feature->start(), $new_feature->end(), $new_feature->strand(),
	$new_feature->slice()->coord_system()->version()
    );
} else {
    print "Feature is not defined in clonal coordinate system\n";
}
print "Output Slice converted using project method\n";
my $projection = $feat->project('chromosome','GRch38');

foreach my $segment ( @{$projection} ) {
    my $to_slice = $segment->to_Slice();

    printf(
        "Slice: %s %d-%d (%+d) %s\n",
        $to_slice->seq_region_name(), $to_slice->start(),
        $to_slice->end(),             $to_slice->strand(),
	$to_slice->coord_system()->version()
    );
}


