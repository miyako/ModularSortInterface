
// Collapse / expand the sidebar (icon-only when collapsed)

// events

If (FORM Event:C1606.code=Sur clic:K2:4)
	
	// toggle state flag
	
	Form:C1466.collapsed:=Not:C34(Form:C1466.collapsed)
	
	// apply
	
	If (Form:C1466.collapsed)
		
		// reduce table list
		
		OBJECT SET VISIBLE:C603(*; "tBrandName@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "tBrandTag@"; False:C215)
		
		OBJECT MOVE:C664(*; "rNav@"; 0; 0; -158)
		OBJECT SET VISIBLE:C603(*; "tNav@"; False:C215)
		
		OBJECT MOVE:C664(*; "bNav@"; 0; 0; -158)
		OBJECT MOVE:C664(*; "nSidebarDiv@"; 0; 0; -158)
		OBJECT MOVE:C664(*; "nSidebarRight"; -158; 0)
		
		OBJECT SET TITLE:C194(*; "tNavReduce"; Localized string:C991("tExtend"))
		OBJECT SET FORMAT:C236(*; "pNavReduceIcon"; "path:/RESOURCES/images/explorer/chevron_right.svg")
		
		// extend block table name
		
		OBJECT MOVE:C664(*; "tListTableName"; -158; 0)
		
		// extend block button back
		
		OBJECT MOVE:C664(*; "rListGroup1"; -158; 0)
		OBJECT MOVE:C664(*; "nToolSep"; -158; 0)
		OBJECT MOVE:C664(*; "rListGroup2"; -158; 0; 158)
		OBJECT MOVE:C664(*; "rListSearchBack"; -158; 0; 158)
		
		// extend block button
		
		OBJECT MOVE:C664(*; "@ListAdd"; -158; 0)
		OBJECT MOVE:C664(*; "@ListDelete"; -158; 0)
		OBJECT MOVE:C664(*; "@ListReport"; -158; 0)
		OBJECT MOVE:C664(*; "@ListLabel"; -158; 0)
		OBJECT MOVE:C664(*; "@ListPrint"; -158; 0)
		OBJECT MOVE:C664(*; "@ListExport"; -158; 0)
		OBJECT MOVE:C664(*; "@ListSearch"; -158; 0)
		
		// extend block data list
		
		OBJECT MOVE:C664(*; "@rListBoxBack"; -158; 0; 158)
		OBJECT MOVE:C664(*; "@ListBoxClassic"; -158; 0; 158)
		OBJECT MOVE:C664(*; "@ListBoxOrda"; -158; 0; 158)
		
	Else 
		
		// extend table list
		
		OBJECT SET VISIBLE:C603(*; "tBrandName@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "tBrandTag@"; True:C214)
		
		OBJECT MOVE:C664(*; "rNav@"; 0; 0; 158)
		OBJECT SET VISIBLE:C603(*; "tNav@"; True:C214)
		
		OBJECT MOVE:C664(*; "bNav@"; 0; 0; 158)
		OBJECT MOVE:C664(*; "nSidebarDiv@"; 0; 0; 158)
		OBJECT MOVE:C664(*; "nSidebarRight"; 158; 0)
		
		OBJECT SET TITLE:C194(*; "tNavReduce"; Localized string:C991("tReduce"))
		OBJECT SET FORMAT:C236(*; "pReduceIcon"; "path:/RESOURCES/images/explorer/chevron_left.svg")
		
		// reduce block table name
		
		OBJECT MOVE:C664(*; "tListTableName"; 158; 0)
		
		// reduce block button back
		
		OBJECT MOVE:C664(*; "rListGroup1"; 158; 0)
		OBJECT MOVE:C664(*; "nToolSep"; 158; 0)
		OBJECT MOVE:C664(*; "rListGroup2"; 158; 0; -158)
		OBJECT MOVE:C664(*; "rListSearchBack"; 158; 0; -158)
		
		// reduce block button
		
		OBJECT MOVE:C664(*; "@ListAdd"; 158; 0)
		OBJECT MOVE:C664(*; "@ListDelete"; 158; 0)
		OBJECT MOVE:C664(*; "@ListReport"; 158; 0)
		OBJECT MOVE:C664(*; "@ListLabel"; 158; 0)
		OBJECT MOVE:C664(*; "@ListPrint"; 158; 0)
		OBJECT MOVE:C664(*; "@ListExport"; 158; 0)
		OBJECT MOVE:C664(*; "@ListSearch"; 158; 0)
		
		// reduce block data list
		
		OBJECT MOVE:C664(*; "@rListBoxBack"; 158; 0; -158)
		OBJECT MOVE:C664(*; "@ListBoxClassic"; 158; 0; -158)
		OBJECT MOVE:C664(*; "@ListBoxOrda"; 158; 0; -158)
		
	End if 
End if 
