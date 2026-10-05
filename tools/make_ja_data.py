#!/usr/bin/env python3
"""Build the Japanese sample data from the French 4D SQL export (demo-specific).

Keeps IDs (UUIDs), foreign keys, dates, times, mileage, statuses, payment methods, and the
whole VEHICLES table. Replaces personal data (fictitious), part/service/intervention texts,
invoice notes and money: yen prices, 10 % consumption tax, totals recomputed from the lines.

  python tools/make_ja_data.py demo/ModularSortInterface/Resources/en.lproj/SQLExport \
                               demo/ModularSortInterface/Resources/ja.lproj/SQLExport
"""
import math
import re
import sys
from pathlib import Path

SRC = Path(sys.argv[1])  # .../en.lproj/SQLExport (French original, fallback locale)
DST = Path(sys.argv[2])  # .../ja.lproj/SQLExport
TAX = 0.1


# ---------------------------------------------------------------- SQL I/O
def parse(path):
    text = path.read_text(encoding="utf-8")
    header, body = text.split("\nVALUES\n", 1)
    rows = []
    for line in body.rstrip("\n").split("\n"):
        line = line.rstrip(",;")
        assert line.startswith("(") and line.endswith(")"), line
        vals = []
        for m in re.finditer(r"'((?:[^']|'')*)'|(-?[\d.]+)", line[1:-1]):
            vals.append(m.group(1).replace("''", "'") if m.group(1) is not None else num(m.group(2)))
        rows.append(vals)
    cols = re.findall(r"\[(\w+)\]", header)[1:]
    return header, cols, [dict(zip(cols, r)) for r in rows]


def num(s):
    return float(s) if "." in s else int(s)


def lit(v):
    if isinstance(v, str):
        return "'" + v.replace("'", "''") + "'"
    if isinstance(v, float) and v.is_integer():
        v = int(v)
    return repr(v) if isinstance(v, float) else str(v)


def write(path, header, cols, rows):
    lines = ["(" + " , ".join(lit(r[c]) for c in cols) + ")" for r in rows]
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(header + "\nVALUES\n" + ",\n".join(lines) + ";\n", encoding="utf-8")
    print(f"wrote {path} ({len(rows)} rows)")


# ---------------------------------------------------------------- people (fictitious)
SURNAME = {  # French surname -> (kanji, romaji)
    "Moreau": ("佐藤", "sato"), "Petit": ("鈴木", "suzuki"), "Leroy": ("高橋", "takahashi"),
    "Simon": ("田中", "tanaka"), "Laurent": ("伊藤", "ito"), "Michel": ("渡辺", "watanabe"),
    "Garcia": ("山本", "yamamoto"), "Dupont": ("中村", "nakamura"), "Martin": ("小林", "kobayashi"),
    "Bernard": ("加藤", "kato"), "Robert": ("吉田", "yoshida"), "Richard": ("山田", "yamada"),
    "Durand": ("佐々木", "sasaki"), "Dubois": ("山口", "yamaguchi"), "Lefebvre": ("松本", "matsumoto"),
    "Roux": ("井上", "inoue"), "David": ("木村", "kimura"), "Bertrand": ("林", "hayashi"),
    "Morel": ("斎藤", "saito"), "Fournier": ("清水", "shimizu"), "Girard": ("山崎", "yamazaki"),
    "Bonnet": ("森", "mori"), "Dupuis": ("池田", "ikeda"), "Lambert": ("橋本", "hashimoto"),
    "Fontaine": ("阿部", "abe"), "Rousseau": ("石川", "ishikawa"), "Vincent": ("山下", "yamashita"),
    "Muller": ("中島", "nakajima"), "Faure": ("石井", "ishii"), "Blanc": ("小川", "ogawa"),
    "Guerin": ("前田", "maeda"), "Boyer": ("岡田", "okada"), "Garnier": ("長谷川", "hasegawa"),
    "Chevalier": ("藤田", "fujita"), "Francois": ("後藤", "goto"), "Mercier": ("近藤", "kondo"),
    "Boucher": ("村上", "murakami"), "Gauthier": ("遠藤", "endo"), "Perrin": ("青木", "aoki"),
    "Andre": ("坂本", "sakamoto"), "Lefevre": ("西村", "nishimura"), "Benali": ("金城", "kinjo"),
}
GIVEN = {  # French given name -> (kanji, romaji); gender kept
    "Jean": ("太郎", "taro"), "Marie": ("花子", "hanako"), "Isabelle": ("恵子", "keiko"),
    "Francois": ("健二", "kenji"), "Nathalie": ("直美", "naomi"), "Alain": ("誠", "makoto"),
    "Elena": ("恵美", "emi"), "Sophie": ("美咲", "misaki"), "Luca": ("拓也", "takuya"),
    "Claire": ("明美", "akemi"), "Nicolas": ("浩", "hiroshi"), "Emma": ("愛", "ai"),
    "Thomas": ("大輔", "daisuke"), "Julie": ("由美", "yumi"), "Antoine": ("隆", "takashi"),
    "Camille": ("真由美", "mayumi"), "Julien": ("翔太", "shota"), "Laura": ("彩", "aya"),
    "Maxime": ("健太", "kenta"), "Sarah": ("さくら", "sakura"), "Pierre": ("修", "osamu"),
    "Manon": ("陽菜", "hina"), "Kevin": ("亮", "ryo"), "Chloe": ("結衣", "yui"),
    "Alexandre": ("和也", "kazuya"), "Marine": ("七海", "nanami"), "Romain": ("直樹", "naoki"),
    "Baptiste": ("達也", "tatsuya"), "Amelie": ("麻衣", "mai"), "Hugo": ("蓮", "ren"),
    "Ines": ("葵", "aoi"), "Valentin": ("悠斗", "yuto"), "Lea": ("美羽", "miu"),
    "Theo": ("湊", "minato"), "Alice": ("莉子", "riko"), "Nathan": ("大翔", "hiroto"),
    "Justine": ("千尋", "chihiro"), "Adam": ("陸", "riku"), "Zoe": ("杏", "an"),
    "Lucas": ("颯太", "sota"), "Charlotte": ("凛", "rin"), "Enzo": ("樹", "itsuki"),
    "Louise": ("楓", "kaede"), "Mathis": ("陽太", "yota"), "Jade": ("紬", "tsumugi"),
    "Karim": ("剛", "tsuyoshi"), "Lucie": ("由香", "yuka"),
}
TECH_GIVEN = {"Martin": ("健一", "kenichi")}  # "Martin Dupont": Martin is the given name here

# French city -> (postcode, prefecture+city+town, has chome). Postcodes checked with Japan Post data
# (zipcloud); block numbers are fictitious.
CITY = {
    "Paris": ("100-0005", "東京都千代田区丸の内", True),
    "Lyon": ("530-0001", "大阪府大阪市北区梅田", True),
    "Toulouse": ("460-0008", "愛知県名古屋市中区栄", True),
    "Lille": ("060-0001", "北海道札幌市中央区北一条西", "sapporo"),
    "Strasbourg": ("810-0001", "福岡県福岡市中央区天神", True),
    "Nantes": ("980-0021", "宮城県仙台市青葉区中央", True),
    "Bordeaux": ("650-0021", "兵庫県神戸市中央区三宮町", True),
    "Marseille": ("231-0023", "神奈川県横浜市中区山下町", False),
    "Nice": ("900-0015", "沖縄県那覇市久茂地", True),
    "Rennes": ("730-0011", "広島県広島市中区基町", False),
    "Reims": ("420-0852", "静岡県静岡市葵区紺屋町", False),
    "Le Havre": ("210-0007", "神奈川県川崎市川崎区駅前本町", False),
    "Grenoble": ("380-0823", "長野県長野市南千歳", True),
    "Dijon": ("330-0063", "埼玉県さいたま市浦和区高砂", True),
    "Angers": ("260-0013", "千葉県千葉市中央区中央", True),
    "Nimes": ("700-0901", "岡山県岡山市北区本町", False),
    "Metz": ("950-0087", "新潟県新潟市中央区東大通", True),
    "Tours": ("370-0841", "群馬県高崎市栄町", False),
    "Limoges": ("760-0019", "香川県高松市サンポート", False),
    "Amiens": ("920-0853", "石川県金沢市本町", True),
    "Besancon": ("400-0031", "山梨県甲府市丸の内", True),
    "Orleans": ("310-0015", "茨城県水戸市宮町", True),
    "Poitiers": ("320-0026", "栃木県宇都宮市馬場通り", True),
    "Rouen": ("430-0933", "静岡県浜松市中央区鍛冶町", False),
    "Clermont-Ferrand": ("860-0844", "熊本県熊本市中央区水道町", False),
    "Caen": ("790-0001", "愛媛県松山市一番町", True),
    "Mulhouse": ("940-0062", "新潟県長岡市大手通", True),
    "Perpignan": ("890-0053", "鹿児島県鹿児島市中央町", False),
    "Nancy": ("990-0039", "山形県山形市香澄町", True),
    "Avignon": ("630-8215", "奈良県奈良市東向中町", False),
    "Pau": ("680-0833", "鳥取県鳥取市末広温泉町", False),
    "Annecy": ("500-8833", "岐阜県岐阜市神田町", True),
    "La Rochelle": ("780-0870", "高知県高知市本町", True),
    "Bayonne": ("880-0805", "宮崎県宮崎市橘通東", True),
    "Chambery": ("390-0811", "長野県松本市中央", True),
    "Toulon": ("850-0853", "長崎県長崎市浜町", False),
    "Aix-en-Provence": ("640-8156", "和歌山県和歌山市七番丁", False),
    "Colmar": ("910-0006", "福井県福井市中央", True),
    "Bourges": ("870-0035", "大分県大分市中央町", True),
    "Chartres": ("030-0801", "青森県青森市新町", True),
}


def address(fr, i):
    m = re.match(r"(\d+) .*?(?:(\d{5}) |, )(.+)$", fr)
    no, postcode, city = int(m.group(1)), m.group(2), m.group(3).strip()
    code, place, chome = CITY[city]
    if chome == "sapporo":
        block = f"{2 + i % 3}丁目{no}"
    elif chome:
        block = f"{1 + i % 2}-{no}-{1 + i % 9}"
    else:
        block = f"{no}-{1 + i % 9}"
    # the French source writes the postcode only in its first records; keep that pattern
    return (f"〒{code} " if postcode else "") + place + block


def phone(fr):  # 06AABBCCDD -> 090-AABB-CCDD (keeps the source's duplicates)
    return f"090-{fr[2:6]}-{fr[6:10]}"


# ---------------------------------------------------------------- catalogue (tax excluded, yen)
SERVICES = {  # ID suffix -> (name, price)
    "00001": ("オイル交換＋オイルフィルター交換", 3000),
    "00002": ("フロントブレーキパッド交換", 8800),
    "00003": ("リアブレーキパッド交換", 8000),
    "00004": ("車検前点検", 5000),
    "00005": ("エアコンガス補充", 8000),
    "00006": ("電子診断（故障診断機）", 5500),
    "00007": ("総合点検", 18000),
    "00008": ("ホイールアライメント調整", 12000),
    "00009": ("タイミングベルト交換", 45000),
    "00010": ("一般工賃（1時間）", 8000),
}
PARTS = {  # ID suffix -> (name, price, fictitious ref, supplier)
    "00001": ("オイルフィルター", 1200, "OF-1012", "デンソー"),
    "00002": ("エアフィルター", 2800, "AF-2508", "デンソー"),
    "00003": ("フロントブレーキパッド", 7500, "FP-3341", "曙ブレーキ工業"),
    "00004": ("リアブレーキパッド", 6500, "RP-3352", "曙ブレーキ工業"),
    "00005": ("フロントブレーキディスクローター", 9800, "DR-4075", "ディクセル"),
    "00006": ("エンジンオイル 5W-40（1L）", 1500, "EO-5W40-1", "ENEOS"),
    "00007": ("タイミングベルト", 8500, "TB-1028", "バンドー化学"),
    "00008": ("タイミングベルトキット", 18000, "TK-4590", "バンドー化学"),
    "00009": ("バッテリー 60B24L", 12000, "BT-60B24L", "GSユアサ"),
    "00010": ("ハロゲンバルブ H7", 1800, "HB-H7-55", "小糸製作所"),
    "00011": ("フロントワイパーブレード（左右セット）", 3200, "WB-6545", "日本ワイパブレード"),
    "00012": ("ブレーキフルード DOT4（1L）", 1600, "BF-DOT4-1", "和光ケミカル"),
}
INTERVENTIONS = {
    "00001": "オイル交換＋オイルフィルター・エアフィルター交換",
    "00002": "フロントブレーキパッド・ディスクローター交換",
    "00003": "エンジン不調の診断＋O2センサー修理",
    "00004": "60,000km総合点検",
    "00005": "エアコンガス補充＋回路点検",
    "00006": "バッテリー交換＋オルタネーター点検",
    "00007": "ホイールアライメント調整＋バランス調整",
    "00008": "タイミングベルト交換（キット）",
    "00009": "オイル交換＋全般点検",
    "00010": "リアブレーキパッド交換",
    "00011": "電子診断（メーター警告灯）",
    "00012": "点検＋ワイパー・バルブ交換",
}
NOTES = {
    "Paiement CB en boutique": "店頭にてクレジットカード払い",
    "Virement recu J+5": "5日後に振込入金",
    "Especes": "現金払い",
    "Reglement tardif": "支払い遅延",
    "En attente de reglement": "入金待ち",
    "": "",
}
# Service lines carry no service ID: which service each line bills (from its description/price).
# Line 00009 is 2 x half an hour of labour.
LINE_SERVICE = {"00001": "00001", "00005": "00002", "00008": "00006", "00011": "00007",
                "00015": "00005", "00016": "00010", "00018": "00008", "00019": "00009",
                "00021": "00001", "00024": "00003"}
HALF_HOUR = {"00009": SERVICES["00010"][1] // 2}


def sfx(uuid):
    return uuid[-5:]


def main():
    out = {}
    h, c, rows = parse(SRC / "CUSTOMERS/Export.sql")
    emails = set()
    for i, r in enumerate(rows):
        (ln, lr), (fn, fr) = SURNAME[r["LastName"]], GIVEN[r["FirstName"]]
        r["LastName"], r["FirstName"] = ln, fn
        r["Phone"] = phone(r["Phone"])
        r["Email"] = f"{fr}.{lr}@example.jp"
        assert r["Email"] not in emails, r["Email"]
        emails.add(r["Email"])
        r["Address"] = address(r["Address"], i)
    out["CUSTOMERS"] = (h, c, rows)

    h, c, rows = parse(SRC / "TECHNICIANS/Export.sql")
    for r in rows:
        given, surname = r["Name"].split()
        r["Name"] = SURNAME[surname][0] + "　" + {**GIVEN, **TECH_GIVEN}[given][0]
    out["TECHNICIANS"] = (h, c, rows)

    h, c, rows = parse(SRC / "SERVICES/Export.sql")
    for r in rows:
        r["Name"], r["UnitPrice"] = SERVICES[sfx(r["ID"])]
        r["VATRate"] = TAX
    out["SERVICES"] = (h, c, rows)

    h, c, rows = parse(SRC / "PARTS/Export.sql")
    for r in rows:
        r["Name"], r["UnitPrice"], r["OemReference"], r["Supplier"] = PARTS[sfx(r["ID"])]
        r["VATRate"] = TAX
    out["PARTS"] = (h, c, rows)

    h, c, rows = parse(SRC / "INTERVENTIONS/Export.sql")
    for r in rows:
        r["Description"] = INTERVENTIONS[sfx(r["ID"])]
    out["INTERVENTIONS"] = (h, c, rows)

    h, c, lines = parse(SRC / "INVOICE_LINES/Export.sql")
    totals = {}
    for r in lines:
        k = sfx(r["ID"])
        if r["ItemType"] == 0:
            price = HALF_HOUR.get(k) or SERVICES[LINE_SERVICE[k]][1]
        else:
            price = PARTS[sfx(r["ID_Parts"])][1]
        r["UnitPrice"], r["VATRate"] = price, TAX
        r["LineTotal"] = r["Quantity"] * price
        totals[r["ID_Invoice"]] = totals.get(r["ID_Invoice"], 0) + r["LineTotal"]
    out["INVOICE_LINES"] = (h, c, lines)

    h, c, rows = parse(SRC / "INVOICES/Export.sql")
    for r in rows:
        excl = totals[r["ID"]]
        vat = math.floor(excl * TAX)  # consumption tax rounded down, as on most Japanese invoices
        r["TotalExclTax"], r["TotalVAT"], r["TotalInclTax"] = excl, vat, excl + vat
        r["Notes"] = NOTES[r["Notes"]]
    out["INVOICES"] = (h, c, rows)

    for table, (h, c, rows) in out.items():
        write(DST / table / "Export.sql", h, c, rows)
    vehicles = (SRC / "VEHICLES/Export.sql").read_bytes()  # kept as is
    (DST / "VEHICLES").mkdir(parents=True, exist_ok=True)
    (DST / "VEHICLES/Export.sql").write_bytes(vehicles)
    print(f"wrote {DST / 'VEHICLES/Export.sql'} (copied unchanged)")


if __name__ == "__main__":
    main()
