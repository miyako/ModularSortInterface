
// vars

var $evs : Integer

// evs

$evs:=FORM Event:C1606.code

Case of 
	: ($evs=Sur chargement:K2:1)
		
		cs:C1710.Lib_PlaySchoolExplorer.me.update()
		
End case 


