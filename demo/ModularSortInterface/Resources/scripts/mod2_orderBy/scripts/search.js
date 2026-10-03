
// filter palette print by query
function filterPieces(query) {

  // rest all buttons
  document.getElementById('clearBtn').style.display = query.trim() ? 'block' : 'none';

  // declare vars
  const pieces = document.querySelectorAll('#palette .ss_piece');
  const q = query.toLowerCase().trim();
  let visible = 0;

  // loop on all pieces
  pieces.forEach(el => {

    // declare vars
    const text = el.textContent.toLowerCase();
    const title = (el.getAttribute('title') || '').toLowerCase();

    // pieces vs query compute showing
    if (!q || text.includes(q) || title.includes(q)) {

      el.classList.remove('hidden');
      visible++;

    } else {

      el.classList.add('hidden');

    }

  });

  // show pieces ?
  if ( visible === 0 ) {
    
    // not show and void message is not present make it 
    if ( !document.getElementById('noResult') ){

      const p = document.createElement('p');
      p.setAttribute('id','noResult');
      p.className = 'no-result';
      p.textContent = 'no result found';

      document.getElementById('palette').appendChild(p);
      
    }

  } else {

    // simply show piece
    if ( document.getElementById('noResult') ){
      document.getElementById('noResult').remove();
    }
    
  }

}

// cancel search in palette
function filterPiecesCancel() {

  // declare vars
  const input = document.getElementById('searchInput');

  // reset value
  input.value = "";
  input.focus();

  // update palette print
  filterPieces('');

}