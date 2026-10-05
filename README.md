# 汎用並び替えエディター（ORDAおよびクラシックモード）

Modular Sort Interface for 4D (ORDA and Classic Mode), Technical Note 26-07: Japanese edition.

このテクニカルノートでは、4Dのコードを書かずに複数条件の並べ替えをグラフィカルに組み立てられる、モジュール式の並べ替えエディターを紹介します。テーブル、フィールド、並べ替え方向をモジュールとしてドラッグ＆ドロップで組み合わせると、同じダイアログから従来のカレントセレクションにもORDAのエンティティセレクションにも並べ替えを適用できます。エディターは4DフォームのWebエリアにHTMLとJavaScriptで実装されており、4D側のLib_Mod2クラスと連携します。並べ替えの設定はファイルに保存して再利用できます。付属のデモは日本語に対応しており、日本語のサンプルデータが含まれています。

This technical note presents a modular, drag-and-drop sort editor for 4D that builds multi-criteria sorts without code and applies them to classic selections or ORDA entity selections. This repository contains the Japanese translation of the note and a localised version of its demo.

## Download

| | |
|---|---|
| PDF (Japanese) | [26-07_ModularSortInterface_ja.pdf](https://github.com/miyako/ModularSortInterface/releases/latest/download/26-07_ModularSortInterface_ja.pdf) |
| 4D demo | [ModularSortInterface.zip](https://github.com/miyako/ModularSortInterface/releases/latest/download/ModularSortInterface.zip) |
| Original (English) | `document/26-07_ModularSortInterface.pdf` |

## Demo

- 4D version: 4D 21 R3
- Open `demo/ModularSortInterface/Project/ModularSortInterface.4DProject`.
- Languages: Japanese, English, French. The UI follows the system language; the XLIFF files are in `Resources/<lang>.lproj/`. The sort editor (Web area) uses the same language through i18next.
- The data file is not included. On first launch, use a new, empty data file: `On Startup` imports the sample data of the current language from `Resources/<lang>.lproj/SQLExport/` into every empty table, then opens the home window. Choose classic selection or ORDA selection there.

### Demo data

The sample data for Japanese (`Resources/ja.lproj/SQLExport/`) replaces the original French garage data with fictitious Japanese customers and technicians (names, addresses with real postcodes, `090-` phone numbers, `@example.jp` e-mails), Japanese parts, services and interventions, and prices in yen with 10 % consumption tax; invoice totals are recomputed from the lines. UUIDs, vehicles and dates are unchanged. It is generated from the original data by `tools/make_ja_data.py`. The original French data is the fallback for other languages (`Resources/en.lproj/SQLExport/`).

## Differences from the original

- Title: 「汎用並び替えエディター」. The dialog is called 並び替えエディター, the historical name of the 4D sort editor.
- All screenshots (Figures 1–4 and the `Resources` folder) were retaken from the Japanese demo; the labels of Figure 5 are translated.
- "TRI command" (the French command name) is written ORDER BY. Two list items lost in the layout of the source PDF are restored.
- Sort editor: the palette now always shows the category the criterion needs next (a dropped table shows only its fields, a field leads to directions, and removing a module or a row goes back accordingly). Removing a module also removes the modules after it, so a criterion can't be left incomplete. The text of the section on contextual navigation describes this behaviour.
- Demo fixes: Edit menu on every window (cut, copy, paste did not work); a French command name that only compiled in French 4D; list box columns no longer truncated; hard-coded French and English labels moved to XLIFF; typos in the English XLIFF.

## Editing and rebuilding

The PDF is generated from plain-text sources. Edit them and run `make`.

| File | What |
|---|---|
| `src/ja.md` | Translated body text. **Don't touch code blocks** (`make check` verifies them). |
| `figures/fig-NN.ja.txt` | Text drawn in figure NN. Line N corresponds to line N of `fig-NN.en.txt`: an identical line keeps the original, an empty line erases it. |
| `figures/layout/fig-NN.json` | Per-label overrides for size, weight, alignment and position; `"replace"` uses a ready-made image |
| `glossary.md` | Terminology |

```sh
make            # check → figures → build/26-07_ModularSortInterface_ja.pdf
make check      # code blocks unchanged, figure references complete
make review     # contact sheets of the figures (build/contact-N.png)
make release-assets
```

Requirements: Python 3, Google Chrome, CJK fonts, and Tesseract (only needed for re-extraction).
See the [localisation template](https://github.com/miyako/4d-technote-localisation-template) for the full workflow.

## Credits

- Original: Olivier Marolleau, Quality Support Engineer, 4D France (Technical Note 26-07)
- Produced with [4d-technote-localisation-template](https://github.com/miyako/4d-technote-localisation-template) and GitHub Copilot.
