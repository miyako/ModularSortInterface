
property exSelection : 4D:C1709.EntitySelection
property exUserSet : 4D:C1709.EntitySelection
property exEntity : 4D:C1709.Entity
property exPosition : Real
property exFields : Collection
property exDataClass : 4D:C1709.DataClass
property exDataClassName : Text

Class constructor
	
	If (cs:C1710.Lib_Mod2.me.isClassicMode())
		
		var $field : Text
		
		This:C1470.exDataClassName:=Table name:C256(Current form table:C627)
		This:C1470.exDataClass:=ds:C1482[This:C1470.exDataClassName]
		This:C1470.exFields:=New collection:C1472()
		
		For each ($field; This:C1470.exDataClass)
			
			This:C1470.exFields.push(New object:C1471(\
				"targeted"; False:C215; \
				"fieldNumber"; This:C1470.exDataClass[$field].fieldNumber; \
				"fieldType"; This:C1470.exDataClass[$field].fieldType; \
				"indexed"; This:C1470.exDataClass[$field].indexed; \
				"name"; This:C1470.exDataClass[$field].name; \
				"type"; This:C1470.exDataClass[$field].type))
			
		End for each 
		
	Else 
		
		// get table names
		
		ARRAY TEXT:C222(mTables; 0)
		OB GET PROPERTY NAMES:C1232(ds:C1482; mTables)
		SORT ARRAY:C229(mTables; >)
		
		mTables:=1
		
		// draw fields
		
		This:C1470.drawFields()
		
	End if 
	
Function drawFieldType($dataClassFieldType : Integer)->$formFieldType : Text
	
	// text | integer | number | boolean | picture | time | date | object
	
	Case of 
		: ($dataClassFieldType=0)  // string
			$formFieldType:="text"
			
		: ($dataClassFieldType=2)  // text
			$formFieldType:="text"
			
		: ($dataClassFieldType=4)  // date
			$formFieldType:="date"
			
		: ($dataClassFieldType=11)  // time
			$formFieldType:="time"
			
		: ($dataClassFieldType=6)  // boolean
			$formFieldType:="boolean"
			
		: ($dataClassFieldType=8)  // int
			$formFieldType:="integer"
			
		: ($dataClassFieldType=9)  // longint
			$formFieldType:="integer"
			
		: ($dataClassFieldType=25)  // int64
			$formFieldType:="integer"
			
		: ($dataClassFieldType=1)  // real
			$formFieldType:="number"
			
		: ($dataClassFieldType=30)  // blob
			$formFieldType:=""
			
		: ($dataClassFieldType=3)  // picture
			$formFieldType:="picture"
			
		: ($dataClassFieldType=38)  // objet
			$formFieldType:="object"
			
		: ($dataClassFieldType=35)  // float
			$formFieldType:="number"
		: ($dataClassFieldType=42)  // link
			$formFieldType:=""
	End case 
	
Function drawFields()
	
	// declare vars
	
	var $nbsColumns; $c; $t; $dataType; $top : Integer
	
	var $field : Text
	
	var $columnIdx : Integer:=1
	
	var $columnName; $headerName; $footerName; $formula : Text
	
	var $headerVar; $footerVar : Pointer
	
	var $form : Object
	
	// init
	
	This:C1470.exDataClass:=ds:C1482[mTables{mTables}]
	
	// build data shower
	
	If (FORM Get current page:C276=2)
		
		// input form
		
		$form:=New object:C1471(\
			"$4d"; New object:C1471(); \
			"windowSizingX"; "variable"; \
			"windowSizingY"; "variable"; \
			"windowMinWidth"; 0; \
			"windowMinHeight"; 0; \
			"windowMaxWidth"; 32767; \
			"windowMaxHeight"; 32767; \
			"rightMargin"; 20; \
			"bottomMargin"; 20; \
			"events"; New collection:C1472(); \
			"windowTitle"; "window title"; \
			"destination"; "detailScreen"; \
			"pages"; New collection:C1472(); \
			"geometryStamp"; 0; \
			"editor"; New object:C1471())
		
		$form.editor.activeView:="View 1"
		$form.editor.defaultView:="View 1"
		$form.editor.views:=New object:C1471("View 1"; New object:C1471())
		
		$form.pages.push(New object:C1471("objects"; New object:C1471()))
		$form.pages.push(New object:C1471("objects"; New object:C1471()))
		
		$c:=0
		$top:=0
		
		For each ($field; This:C1470.exDataClass)
			
			If (This:C1470.exDataClass[$field].kind="storage") & (This:C1470.exDataClass[$field].fieldType#Is BLOB:K8:12)
				
				$c:=$c+1
				$top:=$top+5+27
				
				$form.pages[0].objects["tField"+String:C10($c)]:=New object:C1471(\
					"type"; "text"; \
					"text"; This:C1470.exDataClass[$field].name+" :"; \
					"top"; $top; \
					"left"; 37; \
					"width"; 200; \
					"height"; 16; \
					"class"; "ss_label")
				
				$form.pages[0].objects["iField1"+String:C10($c)]:=New object:C1471(\
					"type"; "input"; \
					"left"; 257; \
					"top"; $top; \
					"width"; 300; \
					"height"; 17; \
					"borderStyle"; "solid"; \
					"dataSourceTypeHint"; This:C1470.drawFieldType(This:C1470.exDataClass[$field].fieldType); \
					"dataSource"; "Form:C1466."+This:C1470.exDataClass[$field].name)
				
			End if 
		End for each 
		
		OBJECT SET SUBFORM:C1138(*; "sFieldList"; $form)
		OBJECT SET DATA SOURCE FORMULA:C1851(*; "sFieldList"; Formula:C1597(Form:C1466.dataExplore.exEntity))
		
		This:C1470.update()
		
	Else 
		
		// output form
		
		If (This:C1470.exDataClassName#mTables{mTables})
			
			This:C1470.exDataClassName:=mTables{mTables}
			
			This:C1470.exFields:=New collection:C1472()
			
			For each ($field; This:C1470.exDataClass)
				
				// only storage field as show, and squiz blob
				
				If (This:C1470.exDataClass[$field].kind="storage") & (This:C1470.exDataClass[$field].fieldType#Is BLOB:K8:12) & (This:C1470.exDataClass[$field].fieldType#Is picture:K8:10)
					
					// init column
					
					$columnName:="xDataStore_C"+String:C10($columnIdx)
					$headerName:="xDataStore_H"+String:C10($columnIdx)
					$footerName:="xDataStore_F"+String:C10($columnIdx)
					
					$headerVar:=Get pointer:C304($headerName)
					$footerVar:=Get pointer:C304($footerName)
					
					$formula:="This:C1470."+This:C1470.exDataClass[$field].name
					$dataType:=This:C1470.exDataClass[$field].fieldType
					
					// set column
					
					$nbsColumns:=LISTBOX Get number of columns:C831(*; "xDataStore")
					If ($nbsColumns<$columnIdx)
						
						LISTBOX INSERT COLUMN FORMULA:C970(*; "xDataStore"; $columnIdx; $columnName; $formula; $dataType; $headerName; $headerVar; $footerName; $footerVar)
						OBJECT SET FONT:C164(*; $columnName; "Arial")
						OBJECT SET FONT:C164(*; $headerName; "Arial")
						OBJECT SET FONT SIZE:C165(*; $columnName; 12)
						OBJECT SET FONT SIZE:C165(*; $headerName; 12)
						OBJECT SET FONT STYLE:C166(*; $headerName; Bold:K14:2)
						
						LISTBOX SET COLUMN WIDTH:C833(*; $columnName; 120; 96)
						LISTBOX SET PROPERTY:C1440(*; $columnName; lk truncate:K53:37; lk without ellipsis:K53:64)
						
					Else 
						
						LISTBOX SET COLUMN FORMULA:C1203(*; $columnName; $formula; $dataType)
					End if 
					
					// update column
					
					This:C1470.exFields.push(New object:C1471(\
						"targeted"; False:C215; \
						"fieldNumber"; This:C1470.exDataClass[$field].fieldNumber; \
						"fieldType"; This:C1470.exDataClass[$field].fieldType; \
						"indexed"; This:C1470.exDataClass[$field].indexed; \
						"name"; This:C1470.exDataClass[$field].name; \
						"type"; This:C1470.exDataClass[$field].type; \
						"boxColumnIndex"; $columnIdx; \
						"boxColumnName"; $columnName; \
						"boxHeaderName"; $headerName))
					
					OBJECT SET TITLE:C194(*; $headerName; This:C1470.exDataClass[$field].name)
					OBJECT SET FORMAT:C236(*; $headerName; "#images/internals/Icon_Field_"+String:C10(This:C1470.exDataClass[$field].fieldType; "00")+".svg;1")
					OBJECT SET RGB COLORS:C628(*; $headerName; 0x0633; Background color:K23:2)
					
					Case of 
						: (Position:C15("ID"; $formula)>0)
							
							OBJECT SET FONT:C164(*; $columnName; "Courier")
							OBJECT SET RGB COLORS:C628(*; $columnName; 0x00FF0000; Background color:K23:2)
							OBJECT SET FORMAT:C236(*; $columnName; "#### #### #### #### #### #### #### ####")
						Else 
							
							OBJECT SET FONT:C164(*; $columnName; "Arial")
							OBJECT SET RGB COLORS:C628(*; $columnName; Foreground color:K23:1; Background color:K23:2)
							OBJECT SET FORMAT:C236(*; $columnName; "")
					End case 
					
					// update index
					
					$columnIdx:=$columnIdx+1
					$nbsColumns:=LISTBOX Get number of columns:C831(*; "xDataStore")
					
				End if 
			End for each 
			
			// clean column
			
			$nbsColumns:=LISTBOX Get number of columns:C831(*; "xDataStore")
			If (($columnIdx-1)<$nbsColumns)
				
				LISTBOX DELETE COLUMN:C830(*; "xDataStore"; $columnIdx; ($nbsColumns-$columnIdx)+1)
			End if 
			
			// load selection
			
			This:C1470.exSelection:=This:C1470.exDataClass.all()
			This:C1470.exSelection:=This:C1470.exDataClass.newSelection()
			This:C1470.exEntity:=New object:C1471()
			
		End if 
	End if 
	
Function update()
	
	// declare var
	
	var $tableName : Text
	
	// code
	
	If (cs:C1710.Lib_Mod2.me.isClassicMode())
		
		// declare var
		
		var $table : Pointer:=Current form table:C627
		
		$tableName:=Table name:C256($table)
		
		// update win title
		
		OBJECT SET TITLE:C194(*; "tTitleSub"; Localized string:C991("tTable"+String:C10(Table:C252($table))))
		SET WINDOW TITLE:C213("Beast garage™  |  "+Table name:C256($table)+"  |  "+String:C10(Records in selection:C76($table->))+" / "+String:C10(Records in table:C83($table->)); Current form window:C827)
		
		OBJECT SET ENABLED:C1123(*; "bListDelete"; (Records in set:C195("UserSet")>0))
		
	Else 
		
		// update win title
		
		$tableName:=This:C1470.exDataClass.getInfo().name
		
		OBJECT SET TITLE:C194(*; "tTitleSub"; Localized string:C991("tTable"+String:C10(This:C1470.exDataClass.getInfo().tableNumber)))
		SET WINDOW TITLE:C213("Beast garage™  |  "+This:C1470.exDataClass.getInfo().name+"  |  "+String:C10(This:C1470.exSelection.length)+" / "+String:C10(This:C1470.exDataClass.all().length); Current form window:C827)
		
		// update buttons
		
		If (FORM Get current page:C276=2)
			
			// input
			
			If (OB Is empty:C1297(This:C1470.exEntity)=False:C215)
				
				OBJECT SET ENABLED:C1123(*; "bRecDelete"; Not:C34(This:C1470.exEntity.isNew()))
				OBJECT SET ENABLED:C1123(*; "bRecFirst"; This:C1470.exEntity.indexOf()>0)
				OBJECT SET ENABLED:C1123(*; "bRecPrevious"; This:C1470.exEntity.indexOf()>0)
				OBJECT SET ENABLED:C1123(*; "bRecNext"; This:C1470.exEntity.indexOf()<(This:C1470.exSelection.length-1))
				OBJECT SET ENABLED:C1123(*; "bRecLast"; This:C1470.exEntity.indexOf()<(This:C1470.exSelection.length-1))
			End if 
		Else 
			
			// output
			
			OBJECT SET ENABLED:C1123(*; "bListDelete"; (This:C1470.exUserSet.length>0))
		End if 
	End if 
	
Function searchStop()
	
	// clear interface
	
	OBJECT Get pointer:C1124(Object named:K67:5; "iSearch")->:=""
	OBJECT SET FORMAT:C236(*; "pSearch"; "Path:/RESOURCES/images/search/searchNormal.svg")
	
Function searchMenu()
	
	// declare var
	
	var $menu : Text:=Create menu:C408
	var $menuChoice : Text
	
	var $field : Object
	
	var $fields : Collection
	
	// menu
	
	APPEND MENU ITEM:C411($menu; This:C1470.exDataClass.getInfo().name+"<B")
	SET MENU ITEM ICON:C984($menu; -1; "Path:/RESOURCES/images/internals/List_shell_table.svg")
	APPEND MENU ITEM:C411($menu; "-")
	
	For each ($field; This:C1470.exFields)
		
		APPEND MENU ITEM:C411($menu; $field.name)
		SET MENU ITEM PARAMETER:C1004($menu; -1; $field.name)
		SET MENU ITEM MARK:C208($menu; -1; Choose:C955($field.targeted; Char:C90(18); ""))
		SET MENU ITEM ICON:C984($menu; -1; "Path:/RESOURCES/images/internals/"+String:C10($field.fieldType; "Icon_Field_00")+".svg")
		
	End for each 
	
	APPEND MENU ITEM:C411($menu; "-")
	APPEND MENU ITEM:C411($menu; Localized string:C991("bCancel"))
	SET MENU ITEM ICON:C984($menu; -1; "Path:/RESOURCES/images/lists/List_Cancel.svg")
	
	// choice
	
	$menuChoice:=Dynamic pop up menu:C1006($menu)
	If ($menuChoice#"")
		
		// reset
		
		OBJECT Get pointer:C1124(Object named:K67:5; "iSearch")->:=""
		
		For each ($field; This:C1470.exFields)
			OBJECT SET RGB COLORS:C628(*; $field.boxColumnName; Foreground color:K23:1; Background color:K23:2)
			$field.targeted:=False:C215
		End for each 
		
		$fields:=This:C1470.exFields.query("name = :1"; $menuChoice)
		If ($fields.length>0)
			
			$fields[0].targeted:=True:C214
			OBJECT SET RGB COLORS:C628(*; $fields[0].boxColumnName; Foreground color:K23:1; 0x00FFEBCC)
			OBJECT SET SCROLL POSITION:C906(*; "xDataStore"; 1; $fields[0].boxColumnIndex)
			
			// set target
			
			Case of 
				: ($fields[0].fieldType=Is alpha field:K8:1) | ($fields[0].fieldType=Is text:K8:3)  // text
					
					OBJECT SET PLACEHOLDER:C1295(*; "iSearch"; "ex : Dupond")
					OBJECT SET FILTER:C235(*; "iSearch"; "")
					
				: ($fields[0].fieldType=Is date:K8:7)  // date
					
					OBJECT SET PLACEHOLDER:C1295(*; "iSearch"; "ex : 01/01/2001 | >= 01/01/2000 < 01/02/2000")
					OBJECT SET FILTER:C235(*; "iSearch"; "&\"0-9;:;>;<;=; ;\"")
					
				: ($fields[0].fieldType=Is time:K8:8)  // time
					
					OBJECT SET PLACEHOLDER:C1295(*; "iSearch"; "ex : 14:00 | > 14:00 < 14:30")
					OBJECT SET FILTER:C235(*; "iSearch"; "&\"0-9;/;>;<;=; ;\"")
					
				: ($fields[0].fieldType=Is boolean:K8:9)  // boolean
					
					OBJECT SET PLACEHOLDER:C1295(*; "iSearch"; "ex : 1 | 0")
					OBJECT SET FILTER:C235(*; "iSearch"; "&\"0-9\"")
					
				: ($fields[0].fieldType=Is integer:K8:5) | ($fields[0].fieldType=Is longint:K8:6) | ($fields[0].fieldType=Is integer 64 bits:K8:25) | ($fields[0].fieldType=Is real:K8:4) | ($fields[0].fieldType=35)  // number
					
					OBJECT SET PLACEHOLDER:C1295(*; "iSearch"; "ex : 45 | > 45 < 50")
					OBJECT SET FILTER:C235(*; "iSearch"; "&\"0-9;.;,;>;<;=; ;-\"")
					
				: ($fields[0].fieldType=Is object:K8:27)  // object
					
					OBJECT SET PLACEHOLDER:C1295(*; "iSearch"; "in dev (. Y .)")
					OBJECT SET FILTER:C235(*; "iSearch"; "")
					
				Else 
					
					OBJECT SET PLACEHOLDER:C1295(*; "iSearch"; "")
					OBJECT SET FILTER:C235(*; "iSearch"; "")
					
			End case 
			
			GOTO OBJECT:C206(*; "iSearch")
			
		End if 
	End if 
	
Function searchInput($evs : Integer)
	
	// declare var
	
	var $value : Text:=Get edited text:C655
	
	var $objCurent : Text:=OBJECT Get name:C1087(Object with focus:K67:3)
	
	var $field : Object
	
	var $values : Collection:=New collection:C1472()
	var $pattern : Collection
	
	var $fieldName; $query : Text
	
	var $p : Integer
	
	// code
	
	Case of 
		: ((($evs=On After Keystroke:K2:26) | ($evs=On Getting Focus:K2:7) | ($evs=On Activate:K2:9)) & ($value#"") & ($objCurent="iSearch"))
			
			// set interface
			
			OBJECT SET FORMAT:C236(*; "pSearch"; "Path:/RESOURCES/images/search/searchActiveEdit.svg")
			
		: ((($evs=On After Keystroke:K2:26) | ($evs=On Getting Focus:K2:7) | ($evs=On Activate:K2:9)) & ($value>="") & ($objCurent="iSearch"))
			
			// set inteface
			
			OBJECT SET FORMAT:C236(*; "pSearch"; "Path:/RESOURCES/images/search/searchActive.svg")
			
		: ((($evs=On Losing Focus:K2:8) | ($evs=On Deactivate:K2:10)) & ($value#""))
			
			// set inteface
			
			OBJECT SET FORMAT:C236(*; "pSearch"; "Path:/RESOURCES/images/search/searchNormalEdit.svg")
			
		: ((($evs=On Losing Focus:K2:8) | ($evs=On Deactivate:K2:10)) & ($value=""))
			
			// set inteface
			
			OBJECT SET FORMAT:C236(*; "pSearch"; "Path:/RESOURCES/images/search/searchNormal.svg")
			
	End case 
	
	// execute
	
	If (This:C1470.exFields.query("targeted = :1"; True:C214).length=1) & ($evs=On After Keystroke:K2:26)
		
		$field:=This:C1470.exFields.query("targeted = :1"; True:C214)[0]
		
		Case of 
			: ($field.fieldType=Is alpha field:K8:1) | ($field.fieldType=Is text:K8:3)
				
				This:C1470.exSelection:=This:C1470.exDataClass.query($field.name+" = :1"; "@"+$value+"@")
				
			: ($field.fieldType=Is date:K8:7)
				
				This:C1470.exSelection:=This:C1470.exDataClass.query($field.name+" = :1"; Date:C102($value))
				
			: ($field.fieldType=Is time:K8:8)
				
				This:C1470.exSelection:=This:C1470.exDataClass.query($field.name+" = :1"; Time:C179($value))
				
			: ($field.fieldType=Is boolean:K8:9)
				
				This:C1470.exSelection:=This:C1470.exDataClass.query($field.name+" = :1"; (($value="1") | ($value="true") | ($value="vrai")))
				
			: ($field.fieldType=Is integer:K8:5) | ($field.fieldType=Is longint:K8:6) | ($field.fieldType=Is integer 64 bits:K8:25) | ($field.fieldType=Is real:K8:4) | ($field.fieldType=35)
				
				// found pattern
				
				$pattern:=Split string:C1554($value; " "; sk ignore empty strings:K86:1)
				If ($pattern.length>1)
					
					// init field targeted
					
					$fieldName:=This:C1470.exFields.query("targeted = :1"; True:C214)[0].name
					$query:=""
					
					// loop on parameters
					
					For ($p; 1; $pattern.length; 2)
						
						// parameter found build query
						
						If ($pattern[$p-1]=">") | ($pattern[$p-1]="<") | ($pattern[$p-1]=">=") | ($pattern[$p-1]="<=")
							
							If ($p<$pattern.length)
								
								$query:=$query+"("+$fieldName+" "+$pattern[$p-1]+" "+String:C10(Num:C11($pattern[$p]))+") AND "
							Else 
								
								$query:=""
								break
							End if 
							
						Else 
							
							$query:=""
							break
						End if 
					End for 
					
					// squiz last in surplus
					
					If (Position:C15(" and "; $query)>0)
						$query:=Substring:C12($query; 0; Length:C16($query)-5)
					End if 
					
					// advanced search
					
					If ($query#"")
						This:C1470.exSelection:=This:C1470.exDataClass.query($query)
					End if 
					
				Else 
					
					// simple search
					
					This:C1470.exSelection:=This:C1470.exDataClass.query($field.name+" = :1"; Num:C11($value))
				End if 
				
				
			: ($field.fieldType=Is BLOB:K8:12)
				
			: ($field.fieldType=Is picture:K8:10)
				
			: ($field.fieldType=Is object:K8:27)
				
		End case 
		
		This:C1470.exUserSet:=This:C1470.exDataClass.newSelection()
		This:C1470.exEntity:=New object:C1471()
		This:C1470.exPosition:=0
		
		This:C1470.update()
		
	End if 
	
	// output form
	
Function edit()
	
	// declare vars
	
	var $evs : Integer:=FORM Event:C1606.code
	
	If (cs:C1710.Lib_Mod2.me.isClassicMode())
		
	Else 
		
		// squizz event
		
		FILTER EVENT:C321
		
		// custom event
		
		Case of 
			: ($evs=On Selection Change:K2:29)
				
				This:C1470.update()
				
			: ($evs=On Double Clicked:K2:5)
				
				If (This:C1470.exUserSet.length>0)
					
					FORM GOTO PAGE:C247(2)
					
				End if 
		End case 
	End if 
	
Function add()
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (cs:C1710.Lib_Mod2.me.isClassicMode())
			
			ADD RECORD:C56(Current form table:C627->)
		Else 
			
			This:C1470.exEntity:=This:C1470.exDataClass.new()
			FORM GOTO PAGE:C247(2)
		End if 
		
		This:C1470.update()
	End if 
	
Function deleteSet()
	
	If (cs:C1710.Lib_Mod2.me.isClassicMode())
		
		// declare var 
		
		var $table : Pointer:=Current form table:C627
		
		// event
		
		If (FORM Event:C1606.code=On Clicked:K2:4) & (Records in set:C195("UserSet")>0)
			
			If (Records in set:C195("UserSet")=1)
				
				CONFIRM:C162(Localized string:C991("tEraseThisRec"); Localized string:C991("bYes"); Localized string:C991("bNo"))
			Else 
				
				CONFIRM:C162(cs:C1710.Lib_Mod2.me.localizedString("tEraseTheseRec"; String:C10(Records in set:C195("UserSet"))); Localized string:C991("bYes"); Localized string:C991("bNo"))
			End if 
			
			If (Ok=1)
				
				CREATE SET:C116($table->; "CurentSet")
				DIFFERENCE:C122("CurentSet"; "UserSet"; "CurentSet")
				
				USE SET:C118("UserSet")
				DELETE SELECTION:C66($table->)
				
				USE SET:C118("CurentSet")
				CLEAR SET:C117("CurentSet")
				
				This:C1470.update()
				
			End if 
		End if 
		
	Else 
		
		// declare var
		
		var $notDropped : 4D:C1709.EntitySelection
		
		var $page : Integer:=FORM Get current page:C276
		
		// event
		
		If (FORM Event:C1606.code=On Clicked:K2:4) & (This:C1470.exUserSet.length>0)
			
			If (This:C1470.exUserSet.length=1)
				
				CONFIRM:C162(Localized string:C991("tEraseThisRec"); Localized string:C991("bYes"); Localized string:C991("bNo"))
			Else 
				
				CONFIRM:C162(cs:C1710.Lib_Mod2.me.localizedString("tEraseTheseRec"; String:C10(This:C1470.exUserSet.length)); Localized string:C991("bYes"); Localized string:C991("bNo"))
			End if 
			
			Case of 
				: ($page=1) & (Ok=1)
					
					This:C1470.exSelection:=This:C1470.exSelection.minus(This:C1470.exUserSet)
					$notDropped:=This:C1470.exUserSet.drop()
					If ($notDropped.length>0)
						
						This:C1470.exSelection:=This:C1470.exSelection.or($notDropped)
						This:C1470.exUserSet:=$notDropped
						This:C1470.exEntity:=New object:C1471()
						This:C1470.exPosition:=0
						BEEP:C151
					End if 
					
				: ($page=2) & (Ok=1)
					
					If (This:C1470.exUserSet.drop().success=True:C214)
						
						This:C1470.exUserSet:=This:C1470.exDataClass.newSelection()
						This:C1470.exEntity:=New object:C1471()
						This:C1470.exPosition:=0
						
						FORM GOTO PAGE:C247(1)
					Else 
						
						BEEP:C151
					End if 
					
			End case 
			
			This:C1470.update()
			
		End if 
	End if 
	
Function selectAll()
	
	var $evs : Integer:=FORM Event:C1606.code
	
	If ($evs=On Clicked:K2:4) | ($evs=On Load:K2:1) | (Count parameters:C259=0)
		
		If (cs:C1710.Lib_Mod2.me.isClassicMode())
			
			ALL RECORDS:C47(Current form table:C627->)
		Else 
			
			This:C1470.searchStop()
			
			This:C1470.exSelection:=This:C1470.exDataClass.all()
			This:C1470.exEntity:=New object:C1471()
			This:C1470.exPosition:=0
			This:C1470.exUserSet:=This:C1470.exDataClass.newSelection()
		End if 
		
		This:C1470.update()
	End if 
	
Function selectSub()
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (cs:C1710.Lib_Mod2.me.isClassicMode())
			
			USE SET:C118("UserSet")
		Else 
			
			This:C1470.searchStop()
			
			This:C1470.exSelection:=This:C1470.exUserSet
			This:C1470.exEntity:=New object:C1471()
			This:C1470.exPosition:=0
			This:C1470.exUserSet:=This:C1470.exDataClass.newSelection()
		End if 
		
		This:C1470.update()
	End if 
	
Function orderBy()
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (cs:C1710.Lib_Mod2.me.isClassicMode())
			
			cs:C1710.Lib_Mod2.me.orderBy(Current form table:C627)
		Else 
			
			cs:C1710.Lib_Mod2.me.orderBy(Form:C1466.dataExplore.exSelection; "Form.dataExplore.exSelection")
		End if 
		
		This:C1470.update()
	End if 
	
Function report()
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (cs:C1710.Lib_Mod2.me.isClassicMode())
			
			QR REPORT:C197(Current form table:C627->; Char:C90(1))
		Else 
			
			USE ENTITY SELECTION:C1513(This:C1470.exSelection)
			QR REPORT:C197(Table:C252(This:C1470.exDataClass.getInfo().tableNumber)->; Char:C90(1))
		End if 
		
		This:C1470.update()
	End if 
	
Function query()
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		// declare var
		
		var $mut : Collection:=New collection:C1472()
		
		// query
		
		If (cs:C1710.Lib_Mod2.me.isClassicMode())
			
			QUERY:C277(Current form table:C627->)
		Else 
			
			If (This:C1470.exFields.query("name = ID").length>0)
				
				QUERY:C277(Table:C252(This:C1470.exDataClass.getInfo().tableNumber)->)
				If (Ok=1)
					
					This:C1470.searchStop()
					
					// mut to orda
					
					ARRAY TEXT:C222($_ID; 0)
					SELECTION TO ARRAY:C260(Field:C253(This:C1470.exDataClass.getInfo().tableNumber; This:C1470.exFields.query("name = ID")[0].fieldNumber)->; $_ID)
					ARRAY TO COLLECTION:C1563($mut; $_ID)
					ARRAY TEXT:C222($_ID; 0)
					
					// update box
					
					This:C1470.exSelection:=This:C1470.exDataClass.query("ID IN :1"; $mut)
					This:C1470.exEntity:=New object:C1471()
					This:C1470.exPosition:=0
					This:C1470.exUserSet:=This:C1470.exDataClass.newSelection()
					
				End if 
				
			Else 
				
				BEEP:C151
			End if 
		End if 
		
		This:C1470.update()
	End if 
	
Function print()
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (cs:C1710.Lib_Mod2.me.isClassicMode())
			
			PRINT SELECTION:C60(Current form table:C627->)
		Else 
			
			var $table : Pointer:=Table:C252(This:C1470.exDataClass.getInfo().tableNumber)
			
			USE ENTITY SELECTION:C1513(This:C1470.exSelection)
			PRINT SELECTION:C60($table->)
		End if 
		
		This:C1470.update()
	End if 
	
Function label()
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (cs:C1710.Lib_Mod2.me.isClassicMode())
			
			PRINT LABEL:C39(Current form table:C627->; Char:C90(1))
		Else 
			
			USE ENTITY SELECTION:C1513(This:C1470.exSelection)
			PRINT LABEL:C39(Table:C252(This:C1470.exDataClass.getInfo().tableNumber)->; Char:C90(1))
		End if 
		
		This:C1470.update()
	End if 
	
Function export()
	
	// declare vars
	
	var $params; $exportType; $xml_settings; $xml_textSettings; $xml_field : Text
	
	var $field : Object
	
	// events
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		// pre build export 
		
		$xml_settings:=DOM Create XML Ref:C861("settings-import-export")
		If (Ok=1)
			
			DOM SET XML ATTRIBUTE:C866($xml_settings; "char_display_format"; "decimal")
			DOM SET XML ATTRIBUTE:C866($xml_settings; "encoding"; "UTF-8")
			DOM SET XML ATTRIBUTE:C866($xml_settings; "format"; "text")
			DOM SET XML ATTRIBUTE:C866($xml_settings; "platform"; "automatic")
			DOM SET XML ATTRIBUTE:C866($xml_settings; "table_no"; String:C10(This:C1470.exDataClass.getInfo().tableNumber))
			DOM SET XML ATTRIBUTE:C866($xml_settings; "table_name"; This:C1470.exDataClass.getInfo().name)
			
			$xml_textSettings:=DOM Create XML element:C865($xml_settings; "text_settings"; "delimiter_field"; 9; "delimiter_record"; 13; "with_column_title"; False:C215)
			
			For each ($field; This:C1470.exFields)
				
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
				
				$xml_field:=DOM Create XML element:C865($xml_settings; "field"; "field_no"; $field.fieldNumber; "kind"; $exportType; "table_no"; This:C1470.exDataClass.getInfo().tableNumber)
				
			End for each 
			
			DOM EXPORT TO VAR:C863($xml_settings; $params)
			DOM CLOSE XML:C722($xml_settings)
			
			If (cs:C1710.Lib_Mod2.me.isClassicMode())
				
				EXPORT DATA:C666(""; $params; *)
				
			Else 
				
				USE ENTITY SELECTION:C1513(This:C1470.exSelection)
				EXPORT DATA:C666(""; $params; *)
				
			End if 
			
			This:C1470.update()
			
		End if 
	End if 
	
	// input form
	
Function first()
	
	// go to first entity
	
	LISTBOX SELECT ROW:C912(*; "xDataStore"; 1; lk replace selection:K53:1)
	
	This:C1470.update()
	
Function previous()
	
	// declare vars
	
	var $index : Integer:=This:C1470.exEntity.indexOf()-1
	
	// go to previous entity
	
	If ($index<0)
		$index:=0
	End if 
	
	LISTBOX SELECT ROW:C912(*; "xDataStore"; $index+1; lk replace selection:K53:1)
	
	This:C1470.update()
	
Function next()
	
	// declare vars
	
	var $index : Integer:=This:C1470.exEntity.indexOf()+1
	
	// go to next entity
	
	If ($index>(This:C1470.exSelection.length-1))
		$index:=This:C1470.exSelection.length
	End if 
	
	LISTBOX SELECT ROW:C912(*; "xDataStore"; $index+1; lk replace selection:K53:1)
	
	This:C1470.update()
	
Function last()
	
	LISTBOX SELECT ROW:C912(*; "xDataStore"; This:C1470.exSelection.length; lk replace selection:K53:1)
	
	This:C1470.update()
	
Function delete()
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		If (This:C1470.exEntity.drop().success=True:C214)
			
			FORM GOTO PAGE:C247(1)
			This:C1470.update()
		Else 
			
			BEEP:C151
		End if 
	End if 
	
Function cancel()
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		This:C1470.exEntity:=New object:C1471()
		
		FORM GOTO PAGE:C247(1)
		
		This:C1470.update()
		
	End if 
	
Function apply()->$status : Object
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		// save common
		
		$status:=This:C1470.exEntity.save()
		If ($status.success=True:C214)
			
		Else 
			
			BEEP:C151
		End if 
	End if 
	
Function valid()
	
	// declare var
	
	var $status : Object
	
	var $index; $page : Integer
	
	// events
	
	If (FORM Event:C1606.code=On Clicked:K2:4)
		
		// save common
		
		If (This:C1470.apply().success=True:C214)
			
			// return to list
			
			FORM GOTO PAGE:C247(1)
			
			// update selection
			
			This:C1470.selectAll()
			
			// go to last add
			
			$index:=This:C1470.exSelection.length
			
			GOTO OBJECT:C206(*; "xDataStore")
			OBJECT SET SCROLL POSITION:C906(*; "xDataStore"; $index)
			LISTBOX SELECT ROW:C912(*; "xDataStore"; $index; lk replace selection:K53:1)
			
		Else 
			
			BEEP:C151
		End if 
		
	End if 
	