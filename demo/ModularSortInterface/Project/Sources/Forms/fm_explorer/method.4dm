
// vars

var $evs : Integer

// evs

$evs:=FORM Event:C1606.code

Case of 
	: ($evs=Sur chargement:K2:1)
		
		cs:C1710.Lib_PlaySchoolExplorer.me.changeTable(Form:C1466.target)
		
	: ($evs=Sur libération:K2:2)
		
		KILL WORKER:C1390(Current process:C322)
		
End case 
