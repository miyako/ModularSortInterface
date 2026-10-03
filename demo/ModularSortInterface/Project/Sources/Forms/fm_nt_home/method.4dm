
// vars

var $evs : Integer

// evs

$evs:=FORM Event:C1606.code

Case of 
	: ($evs=Sur libération:K2:2)
		
		KILL WORKER:C1390(Current process:C322)
		
End case 
