# ChatGPTSummary

## 概要
- ChatGPTを利用して記事本文を元に要約を作成します。
- 要約の文字数はデフォルトで150文字。（文章が複雑な場合は超過する）
- 要約を更新したい場合は、出力されている要約を削除してください。
- APIには本文以外に要約の制御文が渡されます。
文字数を計算するときは本文+制御文の合計となります。

## 利用方法
- MTのpluginディレクトリにプラグインを設置してプラグインをインストールします。
- プラグイン設定画面にOpenAIアカウントで発行したAPIKEYと組織IDを設定します。
※TimeoutSecondsとPromptTextは用途に合わせて適宜変更してください。

## プラグイン設定値
|項目|備考|
| ------ | ------ |
|ApiKey|API実行時に使用するキー|
|APIOrg|APIを利用する組織のID|
|TimeoutSeconds|chatGPTAPIの処理待ち時間(秒)|
|PromptText|本文の要約条件|

## 利用しているAPIの仕様　
※2023/6/7時点
|項目|詳細|備考|
| ------ | ------ | ------ |
|モデル|gpt-3.5-turbo||
|料金|$0.002 / 1K tokens|従量課金制です。概ね700文字程度で1kトークン|
|利用上限|3,500 RPM or 90,000 TPM|1分間当たり|

