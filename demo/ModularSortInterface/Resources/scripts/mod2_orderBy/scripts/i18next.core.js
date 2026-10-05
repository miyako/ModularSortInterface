// -- in18 ---------------------------------------------------------------------

let lang = "";//navigator.language.substring(0, 2);

function setBaseLang($lang) {

    lang=$lang;

    i18next.init({
        lng: ["fr", "en", "ja"].includes(lang) ? lang : "en",
        resources: {
            fr: {
                translation: {
                    xlf_title: "Composeur de trie cible",
                    xlf_field: "Champs",
                    xlf_search: "Rechercher...",
                    xlf_search_erase: "Effacer la recherche",
                    xlf_not_found: "Aucun résultat trouvé.",
                    xlf_drop_here: "— déposez les pièces ici",
                    xlf_Criteria: "Critères de tri",
                    xlf_b_reset: "Réinitialiser",
                    xlf_b_add: "Ajouter",
                    xlf_b_exe: "Executer",
                    xlf_b_save: "Sauver",
                    xlf_b_load: "Charger",
                    xlf_b_close: "Fermer",
                    xlf_b_delete_criterion: "Supprimer ce critère",
                    xlf_table: "Table",
                    xlf_direction: "Direction",
                    xlf_lane_hint: "table → champ → ASC/DESC",
                    xlf_remove_piece: "Retirer cette pièce"
                }
            },
            en: {
                translation: {
                    xlf_title: "Target Sort Composer",
                    xlf_field: "Fields",
                    xlf_search: "Search...",
                    xlf_search_erase: "Clear search",
                    xlf_not_found: "No results found.",
                    xlf_drop_here: "— drop items here",
                    xlf_Criteria: "Sorting criteria",
                    xlf_b_reset: "Reset",
                    xlf_b_add: "Add",
                    xlf_b_exe: "Execute",
                    xlf_b_save: "Save",
                    xlf_b_load: "Load",
                    xlf_b_close: "Close",
                    xlf_b_delete_criterion: "Remove this criterion",
                    xlf_table: "Table",
                    xlf_direction: "Direction",
                    xlf_lane_hint: "table → field → ASC/DESC",
                    xlf_remove_piece: "Remove this item"
                }
            },
            ja: {
                translation: {
                    xlf_title: "並び替えエディター",
                    xlf_field: "フィールド",
                    xlf_search: "検索...",
                    xlf_search_erase: "検索をクリア",
                    xlf_not_found: "該当する項目はありません。",
                    xlf_drop_here: "— ここにモジュールをドロップ",
                    xlf_Criteria: "並べ替え条件",
                    xlf_b_reset: "リセット",
                    xlf_b_add: "追加",
                    xlf_b_exe: "実行",
                    xlf_b_save: "保存",
                    xlf_b_load: "読み込み",
                    xlf_b_close: "閉じる",
                    xlf_b_delete_criterion: "この条件を削除",
                    xlf_table: "テーブル",
                    xlf_direction: "方向",
                    xlf_lane_hint: "テーブル → フィールド → ASC/DESC",
                    xlf_remove_piece: "このモジュールを削除"
                }
            }
        }
    }, () => {
        translatePage();
        // lanes are first drawn before the language is known
        if (typeof renderLanes === "function") renderLanes();
    });

}

function translatePage() {

    // Texte
    document.querySelectorAll("[data-i18n]").forEach(el => {
        el.textContent = i18next.t(el.dataset.i18n);
    });

    // Placeholder
    document.querySelectorAll("[data-i18n-placeholder]").forEach(el => {
        el.placeholder = i18next.t(el.dataset.i18nPlaceholder);
    });

    // Title (tooltip)
    document.querySelectorAll("[data-i18n-title]").forEach(el => {
        el.title = i18next.t(el.dataset.i18nTitle);
    });

    // Value des boutons input
    document.querySelectorAll("[data-i18n-value]").forEach(el => {
        el.value = i18next.t(el.dataset.i18nValue);
    });
}
