// -- Initiate ---------------------------------------------------------------

 // curent palette pieces
let PIECES = [];

// global pieces dictionary
let ALL_PIECES = {};
$4d.paletteLoadDictionary( function($result) {

    ALL_PIECES = JSON.parse($result);
    PIECES = Object.values(ALL_PIECES).filter(p => p.nature === 'table');
    renderPalette();

});

// compatibility pieces
const COMPATIBLE = {
    table: ['field', 'function'],
    field: ['direction', 'operation'],
    operator: ['field'],
    function: ['direction']
};

// array of arrays of piece IDs
let lanes = [[]];

// piece being dragged
let dragPieceId = null;

// -- Helpers ---------------------------------------------------------------

function getPiece(id) {
    return ALL_PIECES[id] || PIECES.find(p => p.id === id) || Object.values(ALL_PIECES).find(p => p.id === id);
}

function canDrop(lane, newPiece) {

    if (lane.length === 0) {
        return ['table', 'function'].includes(newPiece.nature);
    }

    if (newPiece.nature === 'field') {
        const hasTable = lane.some(pid => getPiece(pid)?.nature === 'table');
        if (!hasTable) return false;
    }

    const lastPiece = getPiece(lane[lane.length - 1]);
    const lastEmit = lastPiece.emits;

    // Vérification table/field : le field doit appartenir à la table
    if (lastEmit === 'table' && newPiece.nature === 'field') {
        const tableId = lastPiece.id;                        // ex: "T1"
        const fieldId = newPiece.id;                         // ex: "T1F3"
        const expectedPrefix = new RegExp(`^${tableId}F\\d+$`);
        if (!expectedPrefix.test(fieldId)) return false;
    }

    return (COMPATIBLE[lastEmit] || []).includes(newPiece.nature);

}

// table whose fields the Field tab should offer: the last criterion that has a table but no field yet
function contextTableId() {

    for (let i = lanes.length - 1; i >= 0; i--) {
        const pieces = lanes[i].map(getPiece);
        const table = pieces.find(p => p?.nature === 'table');
        if (table && !pieces.some(p => p?.nature === 'field')) return table.id;
    }
    return null;

}

// select the Field tab and list only the fields of the given table (all fields if none)
function showFieldsFor(tableId) {

    document.querySelectorAll('.ss_tab-btn').forEach(btn =>
        btn.classList.toggle('active', btn.dataset.tab === 'field'));

    filterPiecesCancel();

    PIECES = Object.values(ALL_PIECES).filter(item =>
        item.nature === 'field' &&
        (!tableId || new RegExp(`^${tableId}F\\d+$`).test(item.id))
    );
    renderPalette();

}

// select a tab and list all modules of its category
function showCategory(tabId) {

    document.querySelectorAll('.ss_tab-btn').forEach(btn =>
        btn.classList.toggle('active', btn.dataset.tab === tabId));

    filterPiecesCancel();

    PIECES = Object.values(ALL_PIECES).filter(item => item.nature === tabId);
    renderPalette();

}

// after a table leaves the composition area, the field list must not keep its fields
function refreshFieldList() {

    const active = document.querySelector('.ss_tab-btn.active');
    if (!active || active.dataset.tab !== 'field') return;

    const tableId = contextTableId();
    if (tableId) {
        showFieldsFor(tableId);
    } else {
        showCategory('table');
    }

}

function copyDomTree() {

    const serializer = new XMLSerializer();
    return serializer.serializeToString(document);

}

// -- Rendering -------------------------------------------------------------

function renderPalette() {

    const pal = document.getElementById('palette');
    pal.innerHTML = '';

    let tabler = 'ti';

    PIECES.forEach(p => {

        if ( p.nature === 'field') { tabler = 't4' } else { tabler = 'ti'};

        const el = document.createElement('div');
        el.className = `ss_piece nature-${p.nature}`;
        el.draggable = true;
        el.title = p.hint;
        el.innerHTML =
            `<i class="${tabler} ${p.icon}" aria-hidden="true" style="font-size:14px"></i>` +
            `${p.label}` +
            `<span class="ss_badge-nature">(${p.nature})</span>`;

        let dragPiece = null;

        el.addEventListener('dragstart', () => {
            dragPieceId = p.id;
            dragPiece = p;
            el.classList.add('dragging');
        });
        el.addEventListener('dragend', () => {
            el.classList.remove('dragging');
            dragPieceId = null;
            dragPiece = null;
        });

        pal.appendChild(el);

    });
}

function renderLanes() {

    const wrap = document.getElementById('lanes-wrap');
    wrap.innerHTML = '';

    lanes.forEach((lane, li) => {
        // Row
        const row = document.createElement('div');
        row.className = 'ss_lane-row';

        // Number label
        const num = document.createElement('span');
        num.className = 'ss_lane-num';
        num.textContent = li + 1;
        row.appendChild(num);

        // Drop zone
        const laneEl = document.createElement('div');
        laneEl.className = 'ss_sort-lane';

        if (lane.length === 0) {

            const ph = document.createElement('span');

            ph.className = 'ss_lane-placeholder';
            ph.innerHTML = `<i class="ti ti-drag-drop" aria-hidden="true" style="font-size:16px"></i>${i18next.t('xlf_lane_hint')}`;
            laneEl.appendChild(ph);

        } else {

            lane.forEach((pid, pi) => {

                if (pi > 0) {
                    const line = document.createElement('div');
                    line.className = 'ss_connector-line';
                    laneEl.appendChild(line);
                }

                let tabler = 'ti';
                
                const p = getPiece(pid);
                const el = document.createElement('div');

                if ( p.nature === 'field') { tabler = 't4' } else { tabler = 'ti'};

                el.className = `ss_piece nature-${p.nature}`;
                el.innerHTML =
                    `<i class="${tabler} ${p.icon}" aria-hidden="true" style="font-size:14px"></i>` +
                    `${p.label}` +
                    `<button class="ss_remove-btn" title="${i18next.t('xlf_remove_piece')}" onclick="removePiece(${li},${pi})">×</button>`;

                // Clic sur une table dans la lane → charger ses champs
                if (p.nature === 'table') {
                    el.style.cursor = 'pointer';
                    el.addEventListener('click', (e) => {
                        if (e.target.classList.contains('ss_remove-btn')) return; // ignorer le ×

                        showFieldsFor(p.id);

                    });
                }

                laneEl.appendChild(el);

            });

        }

        // Drag-over feedback

        laneEl.addEventListener('dragover', e => {

            e.preventDefault();
            const p = getPiece(dragPieceId);

            if (!p) {
                laneEl.classList.remove('over', 'invalid');
                return;
            }

            if (canDrop(lane, p)) {
                laneEl.classList.add('over');
                laneEl.classList.remove('invalid');
            } else {
                laneEl.classList.add('invalid');
                laneEl.classList.remove('over');
            }

        });

        laneEl.addEventListener('dragleave', () => {
            laneEl.classList.remove('over', 'invalid');
        });

        laneEl.addEventListener('drop', e => {

            e.preventDefault();

            laneEl.classList.remove('over', 'invalid');

            const p = getPiece(dragPieceId);

            if (!p) return;

            if (canDrop(lane, p)) {
                lanes[li].push(dragPieceId);
                renderLanes();
                // a table was just added: offer only its fields
                if (p.nature === 'table') showFieldsFor(p.id);
            } else {
                // Flash invalid
                laneEl.classList.add('invalid');
                setTimeout(() => laneEl.classList.remove('invalid'), 800);
            }

        });

        // Remove-lane button
        const rmBtn = document.createElement('button');
        rmBtn.className = 'ss_btn-remove-lane';
        rmBtn.title = i18next.t('xlf_b_delete_criterion');
        rmBtn.innerHTML = '<i class="ti ti-x"></i>';
        rmBtn.onclick = () => removeLane(li);

        row.appendChild(laneEl);
        row.appendChild(rmBtn);
        wrap.appendChild(row);
    });
}

// -- Actions ---------------------------------------------------------------

function removeLane(i) {

    if (lanes.length === 1) {
        lanes[0] = [];
    } else {
        lanes.splice(i, 1);
    }

    renderLanes();
    refreshFieldList();

}

function removePiece(laneIdx, pieceIdx) {

    // each module depends on the one before it: remove the rest of the criterion too
    lanes[laneIdx].splice(pieceIdx);
    renderLanes();
    refreshFieldList();

}

// -- Peuplate ---------------------------------------------------------------

function setContentsTitle($title) {

    document.querySelector('.ss_title div:nth-child(2)').innerHTML = $title;

}

// -- Tools -------------------------------------------------------------------

function copyLanestoJSON() {

  return [...document.querySelectorAll('.ss_lane-row')].map((row, i) => ({
    lane: i + 1,
    pieces: [...row.querySelectorAll('.ss_piece')].map(el => ({
      nature: [...el.classList]
        .find(c => c.startsWith('nature-'))
        ?.replace('nature-', ''),
      label: el.childNodes[0]?.textContent?.trim()
           || el.textContent.trim().replace(/×$/, '').trim()
    }))
  }));

}

// -- Plans -------------------------------------------------------------------

function loadFromPlan(plan) {

    // control structure
    if (!plan || !Array.isArray(plan.plans)) {
        console.warn('loadPlan: structure invalide', plan);
        return;
    }

    // resolve piece {nature, label} to existing ID in ALL_PIECES
    function resolveId(nature, label) {

        // raw search
        const match = Object.values(ALL_PIECES).find(p =>
            p.nature === nature &&
            p.label.trim().toLowerCase() === label.trim().toLowerCase()
        );

        if (match) return match.id;

        // show error in virtual item
        const syntheticId = `synthetic_${nature}_${label}`.replace(/\s+/g, '_');

        if (!ALL_PIECES[syntheticId]) {
            ALL_PIECES[syntheticId] = {
                id: syntheticId,
                nature,
                label,
                icon: 'ti-circle',
                hint: label,
                emits: nature
            };
        }

        return syntheticId;

    }

    // update lan from plans
    lanes = plan.plans.map(laneData =>
        (laneData.pieces || []).map(piece => resolveId(piece.nature, piece.label))
    );

    // show one line by default
    if (lanes.length === 0) lanes = [[]];

    renderLanes();

}

// -- Main inittiate -----------------------------------------------------------

renderPalette();
renderLanes();
