
function closeWin() {
    $4d.buttonCloseWin( function($result) {

    });
}

function plansSave(){

    const plans = JSON.stringify(copyLanestoJSON());
    $4d.buttonPlansSave( plans, function($result) {

    });

}

function plansLoad(){
    $4d.buttonPlansLoad( function($result) {

    });
}

function plansExecute(){
    
    const plans = JSON.stringify(copyLanestoJSON());
    $4d.buttonPlansExecute( plans, function($result) {

    });

}

function plansResetAll() {
    lanes = [[]];
    renderLanes();
    refreshFieldList();
}

function plansAddLane() {
    lanes.push([]);
    renderLanes();
}
