//%attributes = {"invisible":true}

// METHOD : winmake_orda
// ----------------------------------------------------------------------------------

// parameters

#DECLARE($store : Text; $new : Boolean)

// vars

var $prc; $win : Integer
var $left; $top; $right; $bottom : Integer

// found process

$prc:=Process number:C372("xpro_"+$store)

// exec

Case of 
	: ($prc=0)
		
		// process not found make it
		
		CALL WORKER:C1389("xpro_"+$store; "winmake_orda"; $store; True:C214)
		
	: (Count parameters:C259=1)
		
		// pass to front process
		
		BRING TO FRONT:C326($prc)
		
	: ($new=True:C214)
		
		// make new windows
		
		$left:=(Screen width:C187-1024)/2
		$top:=(Screen height:C188-768)/2
		$right:=$left+1024
		$bottom:=$top+768
		
		$win:=Open window:C153($left; $top; $right; $bottom; Fenêtre standard:K34:13; "winmake_orda")
		DIALOG:C40("fm_explorer"; *)
		
End case 
