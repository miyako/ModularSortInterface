
// declare vars
const paletteButtons = document.querySelectorAll(".ss_tab-btn");

// loop on palette buttons
paletteButtons.forEach(button => {
    button.addEventListener("click", () => {
        
        // reset active button
        paletteButtons.forEach(btn => btn.classList.remove("active"));

        // set curent button active
        button.classList.add("active");

        const tabId = button.dataset.tab;

        // fields: only those of the table waiting for a field, if any
        if (tabId === "field") {
            showFieldsFor(contextTableId());
            return;
        }

        // update contents
        filterPiecesCancel();
        PIECES = ALL_PIECES.filter(item => item.nature === tabId);
        renderPalette();

    });
});