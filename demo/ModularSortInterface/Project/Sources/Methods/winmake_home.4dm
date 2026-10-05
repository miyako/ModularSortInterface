//%attributes = {}

// METHOD : winmake_home
// ----------------------------------------------------------------------------------

// parameters

#DECLARE($new : Boolean)

// vars

var $prc; $win : Integer

// found process

$prc:=Process number:C372("xpro_home")

// exec

Case of 
	: ($prc=0)
		
		// process not found make it
		
		CALL WORKER:C1389("xpro_home"; "winmake_home"; True:C214)
		
	: (Count parameters:C259=0)
		
		// pass to front process
		
		BRING TO FRONT:C326($prc)
		
	: ($new=True:C214)
		
		// make new windows
		
		$win:=Open form window:C675("fm_nt_home"; Form fenêtre standard:K39:10; Centrée horizontalement:K39:1; Centrée verticalement:K39:4)
		DIALOG:C40("fm_nt_home"; *)
		
End case 
