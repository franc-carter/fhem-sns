
package main;

use strict;
use warnings;

use Amazon::SNS;

sub SNS_Initialize($$)
{
    my ($hash) = @_;

    $hash->{SetFn}    = "SNS_Set";
    $hash->{DefFn}    = "SNS_Define";
    $hash->{AttrList} = "setList key secret";
    $hash->{AttrFn}   = "SNS_Attr";
}

sub SNS_Define($$)
{
    my ($hash, $def) = @_;

    my ($name, $type, $arn) = split("[ \t]+", $def);
    if (! $arn =~ m/^arn:aws:sns:.*/) {
        my $error = "SNS ARN must be of the form 'arn:aws:sns:<region>:<account>:<topic>'";
        Log(1, $error);
        return $error;
    }
    my @arn_parts = split(':', $arn);
    my $region    = $arn_parts[3];
    my $sns       = Amazon::SNS->new({'key' => undef, 'secret' => undef});

    $sns->service('http://sns.'.$region.'.amazonaws.com');

    $hash->{fhem}{arn}   = $arn;
    $hash->{fhem}{sns}   = $sns;
    $hash->{fhem}{topic} = $arn;

    $hash->{STATE} = 'Defined';

    return undef;
}

sub SNS_Set($$@)
{
    my ($hash, $name, @msg) = @_;

    my $sns   = $hash->{fhem}{sns};
    my $topic = $sns->GetTopic($hash->{fhem}{topic});
    my $msg   = join(" ", @msg);
    my $ok    = $topic->Publish($msg);
    if (!defined($ok)) {
        Log(1, "$name: Failed to Publish '".$msg."' to ".$topic->arn);
        Log(1, "$name: ".$sns->error);
    }
    return undef;
}


sub SNS_Attr(@)
{
    my ($cmd, $name, $attrName, $attrVal) = @_;

    if($cmd eq "set") {
       my $hash = $defs{$name};
       my $sns  = $hash->{fhem}{sns};
       if ($attrName eq 'key') {
           $sns->key($attrVal);
       }
       elsif ($attrName eq 'secret') {
           $sns->secret($attrVal);
       }
       if (defined($sns->secret) && defined($sns->secret)) {
           $hash->{STATE} = 'Ready to Send';
       }
    }
}

1;
