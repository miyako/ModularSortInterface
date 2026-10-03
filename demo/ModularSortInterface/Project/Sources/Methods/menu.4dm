//%attributes = {"invisible":true}

// declare parameters

#DECLARE($lineWant : Text)

// declare vars

var $lineRef : Text

// code

If (Count parameters:C259=1)
	
	$lineRef:=$lineWant
Else 
	
	$lineRef:=Get selected menu item parameter:C1005
End if 


Case of 
	: ($lineRef="xCommonMenuAbout")
		
	: ($lineRef="xCommonMenuItemPreferences")
		
	: ($lineRef="xCommonMenuItemQuit")
		
		QUIT 4D:C291(0)
		
	: ($lineRef="xCommonMenuDataExplorer")
		
		winmake_explorer("CUSTOMERS")
		
	: ($lineRef="xCommonMenuDataCLIENTS")
		
		winmake_classic(->[CUSTOMERS:1])
		
	: ($lineRef="xCommonMenuDataINVOICES")
		
		winmake_classic(->[INVOICES:6])
		
	: ($lineRef="xCommonMenuDataVEHICLES")
		
		winmake_classic(->[VEHICLES:2])
		
	: ($lineRef="xCommonMenuDataINTERVENTIONS")
		
		winmake_classic(->[INTERVENTIONS:3])
		
	: ($lineRef="xCommonMenuDataTECHNICIANS")
		
		winmake_classic(->[TECHNICIANS:8])
		
	: ($lineRef="xCommonMenuDataSERVICES")
		
		winmake_classic(->[SERVICES:4])
		
	: ($lineRef="xCommonMenuDataPARTS")
		
		winmake_classic(->[PARTS:5])
		
	: ($lineRef="xCommonMenuHomeNT")
		
		winmake_home()
		
End case 
