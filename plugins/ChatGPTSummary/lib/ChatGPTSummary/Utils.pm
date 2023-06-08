package ChatGPTSummary::Utils;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub doLog {
    my ($msg) = @_;
    return unless defined($msg);

    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg);
    $log->level( MT::Log::DEBUG() );
    $log->save or die $log->errstr;

    return;
}

1;
__END__
