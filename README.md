# Rails Application Test

## ローカルでの動かし方

前提:
- Ruby / Bundler / SQLite3 がインストール済み
- macOS + zsh を想定

1. リポジトリ取得（省略可）

2. 環境変数を設定
- プロジェクト直下に `.env` を作成し、以下を設定してください（値は例です）。

```
user_id="your_user_id"
user_password="your_password"
client_id="your_oauth_client_id"
client_secret="your_oauth_client_secret"
```

3. 依存インストール
```
bundle install
```

4. DB 準備（作成・マイグレーション・seed）
```
bin/rails db:prepare
bin/rails db:seed
```
- seed により `.env` の `user_id` / `user_password` のユーザーが作成されます。

5. サーバ起動
```
bin/dev
```
- ブラウザで http://localhost:3000 を開きます。

6. 動作確認
- ログイン: `.env` のユーザーでログイン
- 写真アップロード: 「写真をアップロード」からタイトルと画像を指定
- OAuth 連携: 「MyTweetAppと連携」を押して認可→コールバックでアクセストークン取得
- ツイート投稿: 一覧の各カードに「ツイートする」ボタンが表示され、押下で連携アプリに投稿

トラブルシュート:
- フラッシュが表示されない: レイアウトのフラッシュ表示を利用しています。ページを再読み込みしてください。
- `.env` が反映されない: サーバを再起動してください。
- OAuth 失敗: `log/development.log` にリクエスト/エラーを出力しています。`client_id`/`client_secret`/`redirect_uri` を確認してください。
