#!/bin/bash

# ==== 引数チェック ====
if [[ $# -ne 3 ]]; then
  echo "使い方: $0 <NS1> <NS2> <INPUT_FILE>"
  echo "例:    $0 ns1.example.com ns2.example.com records.txt"
  exit 1
fi

NS1="$1"
NS2="$2"
INPUT_FILE="$3"

# ==== ファイル存在確認 ====
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "❌ 入力ファイルが見つかりません: $INPUT_FILE"
  exit 1
fi

# ==== レコードごとの比較処理 ====
while read -r NAME TYPE; do
  [[ -z "$NAME" || -z "$TYPE" || "$NAME" == \#* ]] && continue  # 空行やコメント行スキップ

  echo "=== チェック中: $NAME ($TYPE) ==="

  TMP1=$(mktemp)
  TMP2=$(mktemp)

  dig @$NS1 "$NAME" "$TYPE" +short | sort > "$TMP1"
  dig @$NS2 "$NAME" "$TYPE" +short | sort > "$TMP2"

  if diff -q "$TMP1" "$TMP2" > /dev/null; then
    echo "✔ 一致しています"
  else
    echo "❌ 差分があります:"
    echo "--- $NS1 の応答 ---"
    cat "$TMP1"
    echo "--- $NS2 の応答 ---"
    cat "$TMP2"
  fi

  rm "$TMP1" "$TMP2"
  echo

done < "$INPUT_FILE"
