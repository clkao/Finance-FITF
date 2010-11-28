use strict;
use Test::More;
use Finance::FITF ;
use File::Temp;

my $tf = File::Temp->new;

my $writer = Finance::FITF->new_writer(
    fh => $tf,
    header => {
        name => 'HKFE.HSI',
        date => '20101119',
        time_zone => 'Asia/Hong_Kong',
        bar_seconds => 300,
        format => FITF_TICK_NONE | FITF_BAR_USHORT,
    },
);

$writer->add_session( 585 * 60, 750 * 60 );
$writer->add_session( 870 * 60, 975 * 60 );

is_deeply $writer->header->{start}, [1290131100, 1290148200];
is_deeply $writer->header->{end}, [1290141000, 1290154500];

is $writer->nbars, 54;

for (1..54) {
    my $ts = $writer->{bar_ts}->[$_-1];
 #   diag $ts;
    $writer->push_bar($ts,
                      { open => 20000+$_,
                        high => 20000+$_,
                        low => 20000+$_,
                        close => 20000+$_,
                        volume => $_,
                        ticks => $_,
                    });
}

$writer->end;
close $tf;

my $reader = Finance::FITF->new_from_file( $tf );
is $reader->header->{name}, 'HKFE.HSI';
is $reader->nbars, 54;

is $reader->header->{records}, 0;
is_deeply $writer->header->{start}, [1290131100, 1290148200, 0];
is_deeply $writer->header->{end}, [1290141000, 1290154500, 0];
is $reader->{bar_ts}[0], 1290131400;

for (1..54) {
    my $ts = $writer->{bar_ts}->[$_-1];
    my $b = $reader->bar_at($ts);
    is $b->{open}, 20000+$_;
}

done_testing;
