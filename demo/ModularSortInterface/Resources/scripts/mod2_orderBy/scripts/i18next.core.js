// -- in18 ---------------------------------------------------------------------

let lang = "";//navigator.language.substring(0, 2);

function setBaseLang($lang) {

    lang=$lang;

    i18next.init({
        lng: ["fr", "en"].includes(lang) ? lang : "en",
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
                    xlf_b_delete_criterion: "Supprimer ce critère"
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
                    xlf_b_delete_criterion: "Remove this criterion"
                }
            }
        }
    }, () => {
        translatePage();
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
