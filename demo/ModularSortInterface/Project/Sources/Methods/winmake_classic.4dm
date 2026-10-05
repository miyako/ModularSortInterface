//%attributes = {"invisible":true}

// METHOD : winmake_classic
// ----------------------------------------------------------------------------------

// parameters

#DECLARE($table : Pointer; $new : Boolean)

// vars

var $prc; $win : Integer
var $left; $top; $right; $bottom : Integer

// found process

$prc:=Process number:C372("xprc_"+Table name:C256($table))

// exec

Case of 
	: ($prc=0)
		
		// process not found make it
		
		CALL WORKER:C1389("xprc_"+Table name:C256($table); "winmake_classic"; $table; True:C214)
		
	: (Count parameters:C259=1)
		
		// pass to front process
		
		BRING TO FRONT:C326($prc)
		
	: ($new=True:C214)
		
		// make new windows
		
		$left:=(Screen width:C187-1024)/2
		$top:=(Screen height:C188-768)/2
		$right:=$left+1024
		$bottom:=$top+768
		
		$win:=Open window:C153($left; $top; $right; $bottom; Fenêtre standard:K34:13; "winmake_classic")
		ALL RECORDS:C47($table->)
		MODIFY SELECTION:C204($table->; Sélection multiple:K50:3; False:C215; *)
		CLOSE WINDOW:C154($win)
		
End case 
