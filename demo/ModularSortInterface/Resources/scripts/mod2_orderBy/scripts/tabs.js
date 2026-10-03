
// declare vars
const paletteButtons = document.querySelectorAll(".ss_tab-btn");

// loop on palette buttons
paletteButtons.forEach(button => {
    button.addEventListener("click", () => {
        
        // reset active button
        paletteButtons.forEach(btn => btn.classList.remove("active"));

        // set curent button active
        button.classList.add("active");

        // update contents
        filterPiecesCancel();
        const tabId = button.dataset.tab;
        PIECES = ALL_PIECES.filter(item => item.nature === tabId);
        renderPalette();

    });
});