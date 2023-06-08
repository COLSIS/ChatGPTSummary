package ChatGPTSummary::Callback;

use strict;
use warnings;
use utf8;
use ChatGPTSummary::Utils;
use LWP::UserAgent;
use JSON qw/encode_json/;

use constant API_URI => 'https://api.openai.com/v1/chat/completions';

sub plugin {
    return MT->component('ChatGPTSummary');
}

sub hdlr_cms_post_save {
    my ( $eh, $app, $obj ) = @_;
    my $plugin = plugin();

    if ( $obj->text && !$obj->excerpt ) {
        my $prompt_text = $plugin->get_config_value('prompt_text');
        my $post_text   = $obj->text;
        $post_text =~ s/<[^>]+>//xg;
        $prompt_text .= $post_text;
        $prompt_text =~ s/\n//xg;

        my $uri = URI->new(API_URI);
        my $req = HTTP::Request->new( POST => $uri );
        $req->header( 'Content-Type' => 'application/json' );
        $req->header( 'Authorization' => 'Bearer '
              . $plugin->get_config_value('api_key') );
        $req->header(
            'OpenAI-Organization' => $plugin->get_config_value('api_org') );
        $req->content(
            encode_json(
                {
                    model    => "gpt-3.5-turbo",
                    messages => [
                        {
                            role    => "user",
                            content => $prompt_text,
                        }
                    ]
                }
            )
        );
        my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 } );
        $ua->timeout( $plugin->get_config_value('timeout_seconds') );

        my $res;
        eval { $res = $ua->request($req) };
        if ($@) {
            die 'API ERROR';
        }

        my $res_text = $res->{'_content'};
        if ( $res_text =~ /("content":".+?")/ ) {
            $res_text = $1;
            if ( $res_text =~ /("content":")(.+)("$)/ ) {
                $res_text = $2;
                my $entry = MT->model('entry')->load( $obj->id );
                $entry->excerpt($res_text);
                $entry->save();
            }
        }
        else {
            die 'API ERROR';
        }

    }

}

1;
