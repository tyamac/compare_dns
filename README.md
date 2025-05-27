# compare_dns.sh

2つのネームサーバーに対して `dig` コマンドを実行し、DNSレコードの応答内容を比較するシェルスクリプトです。

## 🔧 使い方

```bash
./compare_dns.sh <NS1> <NS2> <INPUT_FILE>
```

- `<NS1>`: 1つ目のネームサーバー（例: `ns1.example.com`）
- `<NS2>`: 2つ目のネームサーバー（例: `ns2.example.com`）
- `<INPUT_FILE>`: 比較対象のレコードリストファイル

## 📄 入力ファイルの形式

`INPUT_FILE` には、比較対象とするFQDNとレコードタイプの組み合わせを1行ずつ記述します。空行や `#` で始まるコメント行は無視されます。

例 (`records.txt`):

```
example.com A
example.com MX
www.example.com CNAME
mail.example.com TXT
# コメント行
```

## ✅ 出力例

```
=== チェック中: example.com (A) ===
✅ 一致しています

=== チェック中: www.example.com (CNAME) ===
❌ 差分があります:
--- ns1.example.com の応答 ---
www.example.com.
--- ns2.example.com の応答 ---
lb.example.net.
```

## 📦 実行権限を付与するには

```bash
chmod +x compare_dns.sh
```

## 💡 注意点

- `dig` コマンドが必要です（多くのLinux/UNIX/macOSには標準で含まれます）
- レコードタイプ（A, MX, TXT, etc.）は正しく記述してください
- `TXT` レコードで長い値を扱う場合は、255文字未満で分割することを推奨します（DNS仕様）
