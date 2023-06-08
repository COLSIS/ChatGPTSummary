package MT::Plugin::ChatGPTSummary;

use strict;
use warnings;
use utf8;
use ChatGPTSummary::Utils;

our $PLUGIN_NAME = 'ChatGPTSummary';
our $VERSION     = '1.0';

my $prompt_text = <<"EOS";
#命令書
あなたはプロの編集者です。以下の制約条件に従って、入力する文章を要約してください。
#制約条件
・重要なキーワードを取りこぼさない。
・文章の意味を変更しない。
・架空の表現や言葉を使用しない。
・入力する文章を150文字以内にまとめて出力。
・文章中の数値には変更を加えない。
・適切な助詞を利用する。
#入力する文章 
EOS

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new(
    {
        id          => lc $PLUGIN_NAME,
        name        => $PLUGIN_NAME,
        key         => lc $PLUGIN_NAME,
        version     => $VERSION,
        author_name => 'colsis',
        description => '<__trans phrase="Summarize text using chatGPT.">',
        l10n_class  => 'ChatGPTSummary::L10N',
        system_config_template => \&system_config_template,
        settings               => new MT::PluginSettings(
            [
                [ 'api_key',         { Default => '' } ],
                [ 'api_org',         { Default => '' } ],
                [ 'timeout_seconds', { Default => '60' } ],
                [ 'prompt_text',     { Default => $prompt_text } ],

            ]
        ),
    }
);

sub init_registry {
    my $plugin = shift;

    $plugin->registry(
        {
            callbacks => {
                'cms_post_save.entry' =>
                  'ChatGPTSummary::Callback::hdlr_cms_post_save',
            },
        }
    );
}
MT->add_plugin($plugin);

sub system_config_template {
    my $tmpl = << 'HTML';
<mtapp:setting id="api_key" label="ApiKey:">
<input type="text" name="api_key" id="api_key" style="width: 100%;" value="<mt:var name="api_key" escape="html">" />
</mtapp:setting>
<mtapp:setting id="api_org" label="APIOrg:">
<input type="text" name="api_org" id="api_org" style="width: 100%;" value="<mt:var name="api_org" escape="html">" />
</mtapp:setting>
<mtapp:setting id="timeout_seconds" label="TimeoutSeconds:">
<input type="text" name="timeout_seconds" id="timeout_seconds" style="width: 100%;" value="<mt:var name="timeout_seconds" escape="html">" />
</mtapp:setting>
<mtapp:setting id="prompt_text" label="PromptText:">
<textarea id="prompt_text" name="prompt_text" style="width: 100%;height: calc(1.5 * 11em);line-height: 1.5;" row="10"><mt:var name="prompt_text" escape="html"></textarea>
</mtapp:setting>
HTML
}

1;
__END__
