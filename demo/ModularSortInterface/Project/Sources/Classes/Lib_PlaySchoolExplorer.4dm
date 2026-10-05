
singleton Class constructor()
	
	
Function changeTable($store : Variant; $mode : Text)
	
	// declare var
	
	var $tableName : Text
	
	var $tableId : Integer
	
	var $field : Text
	
	// init target
	
	If (Value type:C1509($store)=Is pointer:K8:14)
		
		$tableName:=Table name:C256($store)
		$tableId:=Table:C252($store)
	Else 
		
		$tableName:=$store
		$tableId:=ds:C1482[$store].getInfo().tableNumber
	End if 
	
	// init mode
	
	If (Form:C1466.mode="Classic")
		
		OBJECT SET DATA SOURCE:C1264(*; "xListBoxClassic"; $store)
		
		Form:C1466.dataExplore:=New object:C1471(\
			"dataClassName"; $tableName; \
			"dataClassId"; $tableId; \
			"dataClass"; ds:C1482[$tableName]; \
			"fields"; New collection:C1472(); \
			"position"; 1; \
			"tablePointer"; $store)
		
		ALL RECORDS:C47($store->)
		
	Else 
		
		Form:C1466.dataExplore:=New object:C1471(\
			"dataClassName"; $tableName; \
			"dataClassId"; $tableId; \
			"dataClass"; ds:C1482[$tableName]; \
			"fields"; New collection:C1472(); \
			"selection"; ds:C1482[$tableName].all(); \
			"entity"; 4D:C1709.Entity; \
			"position"; 1; \
			"userSet"; ds:C1482[$tableName].newSelection(); \
			"tablePointer"; Table:C252($tableId))
		
	End if 
	
	// init fields
	
	For each ($field; Form:C1466.dataExplore.dataClass)
		If (Form:C1466.dataExplore.dataClass[$field].kind="storage") & (Form:C1466.dataExplore.dataClass[$field].fieldType#Is BLOB:K8:12)
			
			// increment column index
			
			Form:C1466.dataExplore.fields.push(New object:C1471(\
				"targeted"; False:C215; \
				"fieldNumber"; Form:C1466.dataExplore.dataClass[$field].fieldNumber; \
				"fieldType"; Form:C1466.dataExplore.dataClass[$field].fieldType; \
				"indexed"; Form:C1466.dataExplore.dataClass[$field].indexed; \
				"name"; Form:C1466.dataExplore.dataClass[$field].name; \
				"type"; Form:C1466.dataExplore.dataClass[$field].type))
			
		End if 
	End for each 
	
	// draw field in listbox
	
	This:C1470.drawColumns()
	
Function drawColumns($fieldNames : Text)
	
	// declare var
	
	var $fieldFilters : Collection:=Split string:C1554($fieldNames; ";"; sk ignore empty strings:K86:1)
	
	var $f : Integer
	
	var $listBoxName : Text:=Choose:C955((Form:C1466.mode="Classic"); "xListBoxClassic"; "xListBoxOrda")
	
	var $listBoxColumnNbs : Integer:=LISTBOX Get number of columns:C831(*; $listBoxName)
	var $listBoxColumnIdx; $columnHit : Integer
	
	var $headerName; $columnName; $footerName; $formula : Text
	
	var $headerVar; $footerVar : Pointer
	
	// update mode
	
	OBJECT SET TITLE:C194(*; "tListTableName"; Localized string:C991("tTable"+String:C10(Form:C1466.dataExplore.dataClassId)))
	
	OBJECT Get pointer:C1124(Object named:K67:5; "iMode")->:="Mode · <span style=\"color:orange;font-weight:bold\">"+Form:C1466.mode+"</span>"
	
	OBJECT SET VISIBLE:C603(*; "xListBoxClassic"; (Form:C1466.mode="Classic"))
	OBJECT SET VISIBLE:C603(*; "xListBoxOrda"; (Form:C1466.mode="Orda"))
	
	If (Form:C1466.mode="Classic")
		LISTBOX SET TABLE SOURCE:C1013(*; "xListBoxClassic"; Form:C1466.dataExplore.dataClassId; "UserSet")
	End if 
	
	// update table list
	
	OBJECT SET RGB COLORS:C628(*; "rNav@"; Background color none:K23:10; 0x00E0EFFF)
	OBJECT SET RGB COLORS:C628(*; "rNav"+String:C10(Form:C1466.dataExplore.dataClassId); Background color none:K23:10; 0xCC44)
	
	// loop on field
	
	For ($listBoxColumnIdx; 0; (Form:C1466.dataExplore.fields.length-1))
		
		// init name
		
		$headerName:=$listBoxName+"_H"+String:C10($listBoxColumnIdx)
		$columnName:=$listBoxName+"_C"+String:C10($listBoxColumnIdx)
		$footerName:=$listBoxName+"_F"+String:C10($listBoxColumnIdx)
		
		$headerVar:=Get pointer:C304($headerName)
		$footerVar:=Get pointer:C304($footerName)
		
		// init mode
		
		If (Form:C1466.mode="Classic")
			
			$formula:="["+Form:C1466.dataExplore.dataClassName+":"+String:C10(Form:C1466.dataExplore.dataClassId)+"]"+Form:C1466.dataExplore.fields[$listBoxColumnIdx].name+":"+String:C10(Form:C1466.dataExplore.fields[$listBoxColumnIdx].fieldNumber)
		Else 
			
			$formula:="This:C1470."+Form:C1466.dataExplore.fields[$listBoxColumnIdx].name
		End if 
		
		// update or create column
		
		If (($listBoxColumnIdx+1)>$listBoxColumnNbs)
			
			LISTBOX INSERT COLUMN FORMULA:C970(*; $listBoxName; $listBoxColumnIdx; $columnName; $formula; Form:C1466.dataExplore.fields[$listBoxColumnIdx].fieldType; $headerName; $headerVar; $footerName; $footerVar)
			
			OBJECT SET FONT:C164(*; $headerName; "Segoe UI Variable")
			OBJECT SET FONT SIZE:C165(*; $headerName; 12)
			OBJECT SET RGB COLORS:C628(*; $headerName; 0x003C3C43; Background color:K23:2)
			
			OBJECT SET FONT:C164(*; $columnName; "Segoe UI Variable")
			OBJECT SET FONT SIZE:C165(*; $columnName; 13)
			OBJECT SET RGB COLORS:C628(*; $headerName; 0x001D1D1F; Background color:K23:2)
			
			LISTBOX SET PROPERTY:C1440(*; $columnName; lk truncate:K53:37; lk without ellipsis:K53:64)
			
		Else 
			
			LISTBOX SET COLUMN FORMULA:C1203(*; $columnName; $formula; Form:C1466.dataExplore.fields[$listBoxColumnIdx].fieldType)
			
		End if 
		
		// update header
		
		LISTBOX SET COLUMN WIDTH:C833(*; $columnName; 120; 64)
		
		OBJECT SET TITLE:C194(*; $headerName; "  "+Form:C1466.dataExplore.fields[$listBoxColumnIdx].name)
		OBJECT SET FORMAT:C236(*; $headerName; "#images/internals/Icon_Field_"+String:C10(Form:C1466.dataExplore.fields[$listBoxColumnIdx].fieldType; "00")+".svg;1")
		OBJECT SET RGB COLORS:C628(*; $headerName; 0x0633; Background color:K23:2)
		
		// cleaner
		
		$columnHit:=$columnHit+1
		
	End for 
	
	// clean column
	
	If ($listBoxColumnNbs>$columnHit)
		
		LISTBOX DELETE COLUMN:C830(*; $listBoxName; $columnHit; ($listBoxColumnNbs-$columnHit))
	End if 
	
	// update
	
	This:C1470.update()
	
	
Function bExport()
	
	// declare vars
	
	var $params; $exportType; $xml_settings; $xml_textSettings; $xml_field : Text
	
	var $field : Object
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		// pre build export 
		
		$xml_settings:=DOM Create XML Ref:C861("settings-import-export")
		If (Ok=1)
			
			DOM SET XML ATTRIBUTE:C866($xml_settings; "char_display_format"; "decimal")
			DOM SET XML ATTRIBUTE:C866($xml_settings; "encoding"; "UTF-8")
			DOM SET XML ATTRIBUTE:C866($xml_settings; "format"; "text")
			DOM SET XML ATTRIBUTE:C866($xml_settings; "platform"; "automatic")
			DOM SET XML ATTRIBUTE:C866($xml_settings; "table_no"; String:C10(Form:C1466.dataExplore.dataClassId))
			DOM SET XML ATTRIBUTE:C866($xml_settings; "table_name"; Form:C1466.dataExplore.dataClassName)
			
			$xml_textSettings:=DOM Create XML element:C865($xml_settings; "text_settings"; "delimiter_field"; 9; "delimiter_record"; 13; "with_column_title"; False:C215)
			
			For each ($field; Form:C1466.dataExplore.fields)
				
				Case of 
					: ($field.fieldType=Is alpha field:K8:1)
						$exportType:="alpha"
						
					: ($field.fieldType=Is text:K8:3)
						$exportType:="text"
						
					: ($field.fieldType=Is date:K8:7)
						$exportType:="Date"
						
					: ($field.fieldType=Is time:K8:8)
						$exportType:="time"
						
					: ($field.fieldType=Is boolean:K8:9)
						$exportType:="boolean"
						
					: ($field.fieldType=Is integer:K8:5)
						$exportType:="int16"
						
					: ($field.fieldType=Is longint:K8:6)
						$exportType:="int32"
						
					: ($field.fieldType=Is integer 64 bits:K8:25)
						$exportType:="int64"
						
					: ($field.fieldType=Is real:K8:4)
						$exportType:="real"
						
					: ($field.fieldType=35)
						$exportType:="float"
						
					: ($field.fieldType=Is BLOB:K8:12)
						$exportType:="blob"
						
					: ($field.fieldType=Is picture:K8:10)
						$exportType:="picture"
						
					: ($field.fieldType=Is object:K8:27)
						$exportType:="object"
						
				End case 
				
				$xml_field:=DOM Create XML element:C865($xml_settings; "field"; "field_no"; $field.fieldNumber; "kind"; $exportType; "table_no"; Form:C1466.dataExplore.dataClassId)
				
			End for each 
			
			DOM EXPORT TO VAR:C863($xml_settings; $params)
			DOM CLOSE XML:C722($xml_settings)
			
			If (Form:C1466.mode="Classic")
				
				EXPORT DATA:C666(""; $params; *)
			Else 
				
				USE ENTITY SELECTION:C1513(Form:C1466.dataExplore.selection)
				EXPORT DATA:C666(""; $params; *)
			End if 
		End if 
	End if 
	
Function bPrint()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			PRINT SELECTION:C60(Table:C252(Form:C1466.dataExplore.dataClassId)->)
		Else 
			
			USE ENTITY SELECTION:C1513(Form:C1466.dataExplore.selection)
			PRINT SELECTION:C60(Table:C252(Form:C1466.dataExplore.dataClassId)->)
		End if 
	End if 
	
Function bQuery()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			QUERY:C277(Table:C252(Form:C1466.dataExplore.dataClassId)->)
		Else 
			
		End if 
		
		This:C1470.update()
	End if 
	
Function bLabel()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			PRINT LABEL:C39(Table:C252(Form:C1466.dataExplore.dataClassId)->; Char:C90(1))
		Else 
			
			USE ENTITY SELECTION:C1513(Form:C1466.dataExplore.selection)
			PRINT LABEL:C39(Table:C252(Form:C1466.dataExplore.dataClassId)->; Char:C90(1))
		End if 
	End if 
	
Function bReport()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			QR REPORT:C197(Table:C252(Form:C1466.dataExplore.dataClassId)->; Char:C90(1))
		Else 
			
			USE ENTITY SELECTION:C1513(Form:C1466.dataExplore.selection)
			QR REPORT:C197(Table:C252(Form:C1466.dataExplore.dataClassId)->; Char:C90(1))
		End if 
	End if 
	
Function bListOrder()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			cs:C1710.Lib_Mod2.me.orderBy(Table:C252(Form:C1466.dataExplore.dataClassId))
		Else 
			
			cs:C1710.Lib_Mod2.me.orderBy(Form:C1466.dataExplore.selection; "Form.dataExplore.selection")
		End if 
	End if 
	
Function bListDelete()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			Case of 
				: (Records in set:C195("UserSet")=1)
					CONFIRM:C162(Localized string:C991("tEraseThisRec"); Localized string:C991("bYes"); Localized string:C991("bNo"))
					
				: (Records in set:C195("UserSet")>0)
					CONFIRM:C162(cs:C1710.Lib_Mod2.me.localizedString("tEraseTheseRec"; String:C10(Records in set:C195("UserSet"))); Localized string:C991("bYes"); Localized string:C991("bNo"))
					
			End case 
			
			If (Ok=1)
				
				var $table : Pointer:=Table:C252(Form:C1466.dataExplore.dataClassId)
				
				CREATE SET:C116($table->; "CurentSet")
				DIFFERENCE:C122("CurentSet"; "UserSet"; "CurentSet")
				
				USE SET:C118("UserSet")
				DELETE SELECTION:C66($table->)
				
				USE SET:C118("CurentSet")
				CLEAR SET:C117("CurentSet")
				
			End if 
			
		Else 
			
			Case of 
				: (Form:C1466.dataExplore.userSet.length=1)
					CONFIRM:C162(Localized string:C991("tEraseThisRec"); Localized string:C991("bYes"); Localized string:C991("bNo"))
					
				: (Form:C1466.dataExplore.userSet.length>0)
					CONFIRM:C162(cs:C1710.Lib_Mod2.me.localizedString("tEraseTheseRec"; String:C10(Form:C1466.dataExplore.userSet.length)); Localized string:C991("bYes"); Localized string:C991("bNo"))
					
			End case 
			
			If (Ok=1)
				
				Form:C1466.dataExplore.selection:=Form:C1466.dataExplore.selection.minus(Form:C1466.dataExplore.userSet)
				
				var $notDropped : 4D:C1709.EntitySelection:=Form:C1466.dataExplore.userSet.drop()
				If ($notDropped.length>0)
					
					Form:C1466.dataExplore.selection:=Form:C1466.dataExplore.selection.or($notDropped)
					Form:C1466.dataExplore.userSet:=$notDropped
					Form:C1466.dataExplore.entity:=New object:C1471()
					Form:C1466.dataExplore.position:=0
					BEEP:C151
					
				End if 
			End if 
			
		End if 
		
		This:C1470.update()
	End if 
	
Function bListAdd()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			CREATE RECORD:C68(Table:C252(Form:C1466.dataExplore.dataClassId)->)
			OBJECT SET ENABLED:C1123(*; "bGo@"; False:C215)
			
		Else 
			
			Form:C1466.dataExplore.entity:=Form:C1466.dataExplore.dataClass.new()
			OBJECT SET ENABLED:C1123(*; "bGo@"; False:C215)
		End if 
		
		This:C1470.helperNavMenu(False:C215)
		This:C1470.update()
		
	End if 
	
Function bListEdit()
	
	// declare var
	
	var $mouseX; $mouseY; $mouseB; $column; $line : Integer
	
	var $evs : Integer:=FORM Event:C1606.code
	
	var $table : Pointer:=Table:C252(Form:C1466.dataExplore.dataClassId)
	
	// event
	
	Case of 
		: ($evs=On Selection Change:K2:29)
			
			MOUSE POSITION:C468($mouseX; $mouseY; $mouseB)
			
			LISTBOX GET CELL POSITION:C971(*; "xListBox"+Form:C1466.mode; $mouseX; $mouseY; $column; $line)
			Form:C1466.dataExplore.position:=$line
			
		: ($evs=On Double Clicked:K2:5) & (Form:C1466.mode="Classic")
			
			GOTO SELECTED RECORD:C245($table->; Form:C1466.dataExplore.position)
			
			Case of 
				: (Records in selection:C76($table->)<2)
					
					OBJECT SET ENABLED:C1123(*; "bGo@"; False:C215)
					
				: (Form:C1466.dataExplore.position=1)
					
					OBJECT SET ENABLED:C1123(*; "bGoFirst"; False:C215)
					OBJECT SET ENABLED:C1123(*; "bGoPrevious"; False:C215)
					OBJECT SET ENABLED:C1123(*; "bGoNext"; True:C214)
					OBJECT SET ENABLED:C1123(*; "bGoLast"; True:C214)
					
				: (Form:C1466.dataExplore.position=Records in selection:C76($table->))
					
					OBJECT SET ENABLED:C1123(*; "bGoFirst"; True:C214)
					OBJECT SET ENABLED:C1123(*; "bGoPrevious"; True:C214)
					OBJECT SET ENABLED:C1123(*; "bGoNext"; False:C215)
					OBJECT SET ENABLED:C1123(*; "bGoLast"; False:C215)
					
				Else 
					OBJECT SET ENABLED:C1123(*; "bGo@"; True:C214)
					
			End case 
			
			This:C1470.helperNavMenu(False:C215)
			This:C1470.update()
			
		: ($evs=On Double Clicked:K2:5) & (Form:C1466.mode="Orda")
			
			Case of 
				: (Form:C1466.dataExplore.selection.length<2)
					
					OBJECT SET ENABLED:C1123(*; "bGo@"; False:C215)
					
				: (Form:C1466.dataExplore.position=1)
					
					OBJECT SET ENABLED:C1123(*; "bGoFirst"; False:C215)
					OBJECT SET ENABLED:C1123(*; "bGoPrevious"; False:C215)
					OBJECT SET ENABLED:C1123(*; "bGoNext"; True:C214)
					OBJECT SET ENABLED:C1123(*; "bGoLast"; True:C214)
					
				: (Form:C1466.dataExplore.position=Form:C1466.dataExplore.selection.length)
					
					OBJECT SET ENABLED:C1123(*; "bGoFirst"; True:C214)
					OBJECT SET ENABLED:C1123(*; "bGoPrevious"; True:C214)
					OBJECT SET ENABLED:C1123(*; "bGoNext"; False:C215)
					OBJECT SET ENABLED:C1123(*; "bGoLast"; False:C215)
					
				Else 
					OBJECT SET ENABLED:C1123(*; "bGo@"; True:C214)
					
			End case 
			
			This:C1470.helperNavMenu(False:C215)
			This:C1470.update()
			
	End case 
	
Function bRecFirst()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			// Classic
			
			FIRST RECORD:C50(Table:C252(Form:C1466.dataExplore.dataClassId)->)
			
			CREATE EMPTY SET:C140(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
			ADD TO SET:C119(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
		Else 
			
			// Orda
			
			Form:C1466.dataExplore.position:=1
			LISTBOX SELECT ROWS:C1715(*; "xListBoxOrda"; Form:C1466.dataExplore.dataClass.query("ID = :1"; Form:C1466.dataExplore.selection[0].ID); lk replace selection:K53:1)
		End if 
		
		// update go buttons
		
		OBJECT SET ENABLED:C1123(*; "bGoFirst"; False:C215)
		OBJECT SET ENABLED:C1123(*; "bGoPrevious"; False:C215)
		OBJECT SET ENABLED:C1123(*; "bGoNext"; True:C214)
		OBJECT SET ENABLED:C1123(*; "bGoLast"; True:C214)
		
	End if 
	
Function bRecLast()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			// Classic
			
			LAST RECORD:C200(Table:C252(Form:C1466.dataExplore.dataClassId)->)
			
			CREATE EMPTY SET:C140(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
			ADD TO SET:C119(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
		Else 
			
			// Orda
			
			Form:C1466.dataExplore.position:=Form:C1466.dataExplore.selection.length
			LISTBOX SELECT ROWS:C1715(*; "xListBoxOrda"; Form:C1466.dataExplore.dataClass.query("ID = :1"; Form:C1466.dataExplore.selection[Form:C1466.dataExplore.selection.length-1].ID); lk replace selection:K53:1)
		End if 
		
		// update go buttons
		
		OBJECT SET ENABLED:C1123(*; "bGoFirst"; True:C214)
		OBJECT SET ENABLED:C1123(*; "bGoPrevious"; True:C214)
		OBJECT SET ENABLED:C1123(*; "bGoNext"; False:C215)
		OBJECT SET ENABLED:C1123(*; "bGoLast"; False:C215)
		
	End if 
	
Function bRecPrevious()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			// Classic
			
			PREVIOUS RECORD:C110(Table:C252(Form:C1466.dataExplore.dataClassId)->)
			
			CREATE EMPTY SET:C140(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
			ADD TO SET:C119(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
			
			If ((Form:C1466.dataExplore.position-1)>1)
				
				Form:C1466.dataExplore.position:=Form:C1466.dataExplore.position-1
				
				OBJECT SET ENABLED:C1123(*; "bGoFirst"; True:C214)
				OBJECT SET ENABLED:C1123(*; "bGoPrevious"; True:C214)
				
			Else 
				
				Form:C1466.dataExplore.position:=1
				
				OBJECT SET ENABLED:C1123(*; "bGoFirst"; False:C215)
				OBJECT SET ENABLED:C1123(*; "bGoPrevious"; False:C215)
				
			End if 
			
		Else 
			
			// Orda
			
			If ((Form:C1466.dataExplore.position-1)>0)
				
				Form:C1466.dataExplore.position:=Form:C1466.dataExplore.position-1
				LISTBOX SELECT ROWS:C1715(*; "xListBoxOrda"; Form:C1466.dataExplore.dataClass.query("ID = :1"; Form:C1466.dataExplore.selection[Form:C1466.dataExplore.position-1].ID); lk replace selection:K53:1)
				
				OBJECT SET ENABLED:C1123(*; "bGoFirst"; True:C214)
				OBJECT SET ENABLED:C1123(*; "bGoPrevious"; True:C214)
				
			Else 
				
				Form:C1466.dataExplore.position:=1
				LISTBOX SELECT ROWS:C1715(*; "xListBoxOrda"; Form:C1466.dataExplore.dataClass.query("ID = :1"; Form:C1466.dataExplore.selection[0].ID); lk replace selection:K53:1)
				
				OBJECT SET ENABLED:C1123(*; "bGoFirst"; False:C215)
				OBJECT SET ENABLED:C1123(*; "bGoPrevious"; False:C215)
				
			End if 
		End if 
		
		// update go buttons
		
		OBJECT SET ENABLED:C1123(*; "bGoNext"; True:C214)
		OBJECT SET ENABLED:C1123(*; "bGoLast"; True:C214)
		
	End if 
	
Function bRecNext()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			// Classic
			
			NEXT RECORD:C51(Table:C252(Form:C1466.dataExplore.dataClassId)->)
			
			CREATE EMPTY SET:C140(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
			ADD TO SET:C119(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
			
			If ((Form:C1466.dataExplore.position+1)<Records in selection:C76(Table:C252(Form:C1466.dataExplore.dataClassId)->))
				
				Form:C1466.dataExplore.position:=Form:C1466.dataExplore.position+1
				
				OBJECT SET ENABLED:C1123(*; "bGoNext"; True:C214)
				OBJECT SET ENABLED:C1123(*; "bGoLast"; True:C214)
				
			Else 
				
				Form:C1466.dataExplore.position:=Records in selection:C76(Table:C252(Form:C1466.dataExplore.dataClassId)->)
				
				OBJECT SET ENABLED:C1123(*; "bGoNext"; False:C215)
				OBJECT SET ENABLED:C1123(*; "bGoLast"; False:C215)
				
			End if 
			
		Else 
			
			// Orda
			
			If ((Form:C1466.dataExplore.position+1)<Form:C1466.dataExplore.selection.length)
				
				LISTBOX SELECT ROWS:C1715(*; "xListBoxOrda"; Form:C1466.dataExplore.dataClass.query("ID = :1"; Form:C1466.dataExplore.selection[Form:C1466.dataExplore.position].ID); lk replace selection:K53:1)
				Form:C1466.dataExplore.position:=Form:C1466.dataExplore.position+1
				
				OBJECT SET ENABLED:C1123(*; "bGoNext"; True:C214)
				OBJECT SET ENABLED:C1123(*; "bGoLast"; True:C214)
				
			Else 
				
				Form:C1466.dataExplore.position:=Form:C1466.dataExplore.selection.length
				LISTBOX SELECT ROWS:C1715(*; "xListBoxOrda"; Form:C1466.dataExplore.dataClass.query("ID = :1"; Form:C1466.dataExplore.selection[Form:C1466.dataExplore.selection.length-1].ID); lk replace selection:K53:1)
				
				OBJECT SET ENABLED:C1123(*; "bGoNext"; False:C215)
				OBJECT SET ENABLED:C1123(*; "bGoLast"; False:C215)
				
			End if 
		End if 
		
		// update go buttons
		
		OBJECT SET ENABLED:C1123(*; "bGoFirst"; True:C214)
		OBJECT SET ENABLED:C1123(*; "bGoPrevious"; True:C214)
		
	End if 
	
	
Function update()
	
	// declare var
	
	var $formName : Text:=Current form name:C1298
	
	var $f; $tableId; $fieldId : Integer
	
	// code
	
	Case of 
		: ($formName="fm_explorer")
			
			If (Form:C1466.mode="Classic")
				
				var $table : Pointer:=Table:C252(Form:C1466.dataExplore.dataClassId)
				
				SET WINDOW TITLE:C213("Beast garage™  |  "+Form:C1466.dataExplore.dataClassName+\
					"  |  "+String:C10(Records in selection:C76($table->))+" / "+String:C10(Records in table:C83($table->)); Current form window:C827)
			Else 
				
				SET WINDOW TITLE:C213("Beast garage™  |  "+Form:C1466.dataExplore.dataClassName+\
					"  |  "+String:C10(Form:C1466.dataExplore.selection.length)+" / "+String:C10(Form:C1466.dataExplore.dataClass.all().length); Current form window:C827)
			End if 
			
		: ($formName="fm_input_playschool")
			
			// retry form objects
			
			ARRAY TEXT:C222($_objNames; 0)
			FORM GET OBJECTS:C898($_objNames)
			
			// update table name
			
			OBJECT SET TITLE:C194(*; "tListTableName"; Localized string:C991("tTable"+String:C10(Form:C1466.dataExplore.dataClassId)))
			
			If (Form:C1466.mode="Classic")
				
				OBJECT SET VISIBLE:C603(*; "iField_@_Orda"; False:C215)
			Else 
				
				OBJECT SET VISIBLE:C603(*; "iField_@_Classic"; False:C215)
			End if 
			
		: ($formName="fm_input")
			
		: ($formName="fm_output")
			
	End case 
	
	
Function bRecCancel()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		This:C1470.helperNavMenu(True:C214)
		
		OBJECT SET VISIBLE:C603(*; "tNav@"; Not:C34(Form:C1466.collapsed))
		OBJECT SET VISIBLE:C603(*; "tBrandName"; Not:C34(Form:C1466.collapsed))
		OBJECT SET VISIBLE:C603(*; "tBrandTag"; Not:C34(Form:C1466.collapsed))
		
	End if 
	
Function bRecValid()
	
	// event
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (Form:C1466.mode="Classic")
			
			// Classic
			
			SAVE RECORD:C53(Table:C252(Form:C1466.dataExplore.dataClassId)->)
			UNLOAD RECORD:C212(Table:C252(Form:C1466.dataExplore.dataClassId)->)
			
			CREATE EMPTY SET:C140(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
			ADD TO SET:C119(Table:C252(Form:C1466.dataExplore.dataClassId)->; "UserSet")
			
			ALL RECORDS:C47(Table:C252(Form:C1466.dataExplore.dataClassId)->)
			
			This:C1470.helperNavMenu(True:C214)
			
		Else 
			
			// Orda
			
			If (Form:C1466.dataExplore.entity.save().success=True:C214)
				
				var $id : Text:=Form:C1466.dataExplore.entity.ID
				
				Form:C1466.dataExplore.selection:=Form:C1466.dataExplore.dataClass.all()
				LISTBOX SELECT ROWS:C1715(*; "xListBoxOrda"; Form:C1466.dataExplore.dataClass.query("ID = :1"; $id); lk replace selection:K53:1)
				
				This:C1470.helperNavMenu(True:C214)
			Else 
				
				BEEP:C151
			End if 
			
		End if 
		
		This:C1470.update()
	End if 
	
	
Function helperNavMenu($visibility : Boolean)
	
	// declare vars
	
	var $tableSource; $tableForm : Pointer
	
	var $fm_input; $fm_output : Text
	
	// code
	
	FORM GOTO PAGE:C247(Choose:C955(($visibility)=True:C214; 1; 2))
	
	OBJECT SET VISIBLE:C603(*; "tBrandName"; $visibility)
	OBJECT SET VISIBLE:C603(*; "tBrandTag"; $visibility)
	
	OBJECT SET VISIBLE:C603(*; "pNav@"; $visibility)
	OBJECT SET VISIBLE:C603(*; "tNav@"; $visibility)
	OBJECT SET VISIBLE:C603(*; "rNav@"; $visibility)
	OBJECT SET VISIBLE:C603(*; "bNav@"; $visibility)
	
	OBJECT SET VISIBLE:C603(*; "nSidebarDiv@"; $visibility)
	OBJECT SET VISIBLE:C603(*; "nSidebarRight"; $visibility)
	
	If (Form:C1466.collapsed=False:C215)
		OBJECT MOVE:C664(*; "tListTableName"; Choose:C955(($visibility)=True:C214; 171; -171); 0; Choose:C955(($visibility)=True:C214; -171; 171))
	End if 
	
	OBJECT MOVE:C664(*; "nHeaders"; Choose:C955(($visibility)=True:C214; 242; -242); 0; Choose:C955(($visibility)=True:C214; -242; 242))
	
	OBJECT MOVE:C664(*; "fs_Edit"; Choose:C955(($visibility)=True:C214; 242; -242); 0; Choose:C955(($visibility)=True:C214; -242; 242))
	OBJECT MOVE:C664(*; "nButons"; Choose:C955(($visibility)=True:C214; 242; -242); 0; Choose:C955(($visibility)=True:C214; -242; 242))
	
	OBJECT MOVE:C664(*; "bGo@"; Choose:C955(($visibility)=True:C214; 242; -242); 0)
	
	// anti debug 
	
	$tableSource:=OBJECT Get data source:C1265(*; "fs_Edit")
	OBJECT GET SUBFORM:C1139(*; "fs_Edit"; $tableSource; $fm_input; $fm_output)
	
	// set source form
	
	OBJECT SET DATA SOURCE:C1264(*; "fs_Edit"; Table:C252(Form:C1466.dataExplore.dataClassId))
	OBJECT SET SUBFORM:C1138(*; "fs_Edit"; Table:C252(Form:C1466.dataExplore.dataClassId)->; "fm_input_playschool")
	OBJECT SET DATA SOURCE FORMULA:C1851(*; "fs_Edit"; Formula:C1597(Form:C1466))
	