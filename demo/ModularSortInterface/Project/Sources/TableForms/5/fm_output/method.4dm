
// declare vars

var $evs : Integer:=FORM Event:C1606.code

// events

Case of 
	: ($evs=Sur chargement:K2:1)
		
		Form:C1466.dataExplore:=cs:C1710.Lib_DataExplorer.new()
		Form:C1466.dataExplore.selectAll()
		
	: ($evs=Sur nouvelle sélection:K2:29)
		
		Form:C1466.dataExplore.update()
		
	: ($evs=Sur libération:K2:2)
		
		KILL WORKER:C1390(Current process:C322)
		
End case 