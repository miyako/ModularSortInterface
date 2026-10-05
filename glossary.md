# 用語集 / Glossary

Keep terminology consistent across `src/<target>.md` and `figures/*.<target>.txt`.
Change an entry here first, then search and replace in both places.

Style (ja): です・ます調. Half-width alphanumerics, no space between Japanese and Latin text (e.g. `4D.Vector型`).
Full-width `（）` and `：` in prose. First occurrence of a technical term: 日本語（English）.

## 4D terms (from the official 4D Japanese documentation)

| English | 日本語 | Notes |
|---|---|---|
| entity / entity selection | エンティティ / エンティティセレクション | |
| datastore | データストア | |
| dataclass | データクラス | |
| attribute | 属性 | |
| computed attribute | 計算属性 | |
| collection | コレクション | |
| object | オブジェクト | |
| method | メソッド | |
| project method | プロジェクトメソッド | |
| function | 関数 | |
| class | クラス | |
| parameter | 引数 | |
| form | フォーム | |
| form object | フォームオブジェクト | |
| list box | リストボックス | |
| web area | Webエリア | |
| 4D Web Server | 4D Webサーバー | |
| worker | ワーカー | |
| process | プロセス | |
| query | クエリ | |
| formula | フォーミュラ | |
| component | コンポーネント | |
| pointer | ポインター | |
| current selection | カレントセレクション | |
| sort / order by | 並べ替え | 4Dの並べ替えエディター（sort editor）に合わせる |
| ascending / descending | 昇順 / 降順 | ASC / DESC はモジュール名としてそのまま |
| ORDER BY command (TRI) | ORDER BYコマンド | 原文の「TRI command」（フランス語版コマンド名）もORDER BYに統一（編集者指示） |
| EXECUTE FORM command | EXECUTE FORMコマンド | 原文ママ。コマンド名は翻訳しない |

## Document-specific terms

| English | 日本語 | Notes |
|---|---|---|
| Modular Sort Interface | モジュール式並べ替えインターフェース | タイトル |
| modular | モジュール式 | |
| module | モジュール | |
| classic selection / classic mode | クラシックセレクション / クラシックモード | |
| ORDA mode | ORDAモード | |
| sort criterion / criteria | 並べ替え条件 / 条件 | |
| multi-criteria sort | 複数条件の並べ替え | |
| sort direction | 並べ替え方向 | モジュールカテゴリー名は「方向」 |
| sort definition | 並べ替えの定義 | |
| sort plan | 並べ替えプラン | |
| sort editor | 並べ替えエディター | |
| palette | パレット | |
| composition area | 組み立てエリア | |
| compose / composition | 組み立てる / 組み立て | |
| hub / central hub | ハブ / 中央ハブ | Lib_Mod2クラス |
| business logic | ビジネスロジック | |
| presentation layer | プレゼンテーション層 | |
| context | コンテキスト | current context → カレントコンテキスト |
| serialize / deserialize | シリアライズ / デシリアライズ | |
| internationalization / localization | 国際化 / ローカライズ | |
| tooltip | ツールチップ | 要確認：4D公式は「ヘルプTips」 |
| Web Area / 4D Area (Figure 5) | Webエリア / 4Dエリア | |
| Note | 注記 | |

## UI labels (must match the localised demo, Phase 5)

| English | 日本語 | Notes |
|---|---|---|
| Table / Fields / Direction | テーブル / フィールド / 方向 | モジュールカテゴリー |
| Reset / Add / Execute | リセット / 追加 / 実行 | |
| Save / Load / Close | 保存 / 読み込み / 閉じる | |
| Sorting criteria | 並べ替え条件 | |
| Target Sort Composer | 並び替えエディター | ダイアログのタイトル。4D旧版の「並び替えエディター」に合わせる（編集者指示）。本文の「並べ替え」はそのまま |
| Search... / Clear search | 検索... / 検索をクリア | |
| — drop items here | — ここにモジュールをドロップ | |
| table → field → ASC/DESC | テーブル → フィールド → ASC/DESC | 空の条件行のヒント |
| Ascending order / Descending order | 昇順 / 降順 | ASC/DESCモジュールのツールチップ |
| OrderBy Composer | OrderBy Composer | ホーム画面のブランド名（翻訳しない） |
| Beast garage™ | Beast garage™ | デモアプリ名（翻訳しない） |
| Order (list button) | 並べ替え | ダイアログを開くボタン |
| Customers / Vehicles / Interventions | 顧客 / 車両 / 整備 | テーブル表示名・メニュー（テーブル名自体は翻訳しない） |
| Services / Parts / Invoices / Invoice lines / Technicians | サービス / 部品 / 請求書 / 請求明細 / 技術者 | 同上 |

## Proper nouns in examples

| English | 日本語 | Notes |
|---|---|---|
| TECHNICIANS / Name | TECHNICIANS / Name | デモのテーブル名・フィールド名（翻訳しない） |
| sample records | 架空の日本の顧客・技術者、円建て価格、消費税10% | `Resources/ja.lproj/SQLExport/`（フランス語の原本はフォールバックの `en.lproj/SQLExport/`）。VEHICLES・日付・UUIDは原文ママ |
| Olivier Marolleau | Olivier Marolleau | 著者名はラテン文字のまま |
