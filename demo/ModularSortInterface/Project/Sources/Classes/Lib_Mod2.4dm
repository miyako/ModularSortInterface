
property target : Variant
property instance : Text
property window : Integer
property windowOrigin : Integer

singleton Class constructor()
	
	This:C1470.target:=Null:C1517
	This:C1470.instance:=""
	This:C1470.window:=0
	This:C1470.windowOrigin:=0
	
	
Function localizedString($resname : Text; $replace : Text)->$message : Text
	
	// declare var
	
	var $p : Integer
	
	// conter code
	
	$message:=Localized string:C991($resname)
	
	For ($p; 2; Count parameters:C259)
		
		$message:=Replace string:C233($message; "{x}"; ${$p}; 1)
	End for 
	
Function isClassicMode()->$mode : Boolean
	
	$mode:=(Current form name:C1298="fm_output") | (Current form name:C1298="fm_input")
	
	
Function orderBy($table : Variant; $instance : Text)
	
	// declare var
	
	var $originTable : Integer:=Value type:C1509($table)
	
	var $tableName : Text
	
	var $formData : Object
	
	// retry table name
	
	Case of 
		: ($originTable=Est un pointeur:K8:14)
			
			$formData:=New object:C1471(\
				"tableName"; Table name:C256($table); \
				"tableId"; Table:C252($table); \
				"tablePointer"; $table)
			
		: ($originTable=Est un entier long:K8:6)
			
			$formData:=New object:C1471(\
				"tableName"; Table name:C256($table); \
				"tableId"; $table; \
				"tablePointer"; Table:C252($table))
			
		: ($originTable=Est un texte:K8:3)
			
			$formData:=New object:C1471(\
				"tableName"; $table; \
				"tableId"; ds:C1482[$table].getInfo().tableNumber; \
				"tablePointer"; Table:C252(ds:C1482[$table].getInfo().tableNumber))
			
		: ($originTable=Est un objet:K8:27)
			
			$formData:=New object:C1471(\
				"tableName"; $table.getDataClass().getInfo().name; \
				"tableId"; $table.getDataClass().getInfo().tableNumber; \
				"tablePointer"; Table:C252($table.getDataClass().getInfo().tableNumber))
			
		Else 
			
			$formData:=New object:C1471(\
				"tableName"; ""; \
				"tableId"; 0; \
				"tablePointer"; Get pointer:C304(""))
			
	End case 
	
	This:C1470.target:=$table
	This:C1470.instance:=$instance
	
	// open order window
	
	If ($formData.table_name#"")
		
		This:C1470.windowOrigin:=Current form window:C827
		This:C1470.window:=Open form window:C675("fm_mod2_orderBy"; Form dialogue modal déplaçable:K39:8; Centrée horizontalement:K39:1; Centrée verticalement:K39:4)
		SET WINDOW TITLE:C213(Uppercase:C13($formData.tableName); This:C1470.window)
		DIALOG:C40("fm_mod2_orderBy"; $formData; *)
		
	End if 
	
	
Function paletteLoadDictionary()->$result : Text
	
	// declare vars
	
	var $tableName; $tableId; $fieldName; $fieldType : Text
	
	var $data : Collection:=New collection:C1472()
	
	// init tables and fields
	
	For each ($tableName; ds:C1482)
		
		$tableId:="T"+String:C10(ds:C1482[$tableName].getInfo().tableNumber)
		
		$data.push(New object:C1471(\
			"id"; $tableId; \
			"label"; $tableName; \
			"nature"; "table"; \
			"icon"; "ti-table"; \
			"emits"; "table"; \
			"hint"; "["+$tableName+"]"))
		
		// loop on field
		
		For each ($fieldName; ds:C1482[$tableName])
			
			If (ds:C1482[$tableName][$fieldName].kind="storage")
				
				$fieldType:=Choose:C955(ds:C1482[$tableName][$fieldName].fieldType=11; "time"; ds:C1482[$tableName][$fieldName].type)
				
				$data.push(New object:C1471(\
					"id"; $tableId+"F"+String:C10(ds:C1482[$tableName][$fieldName].fieldNumber); \
					"label"; $fieldName; \
					"nature"; "field"; \
					"icon"; "t4-"+$fieldType; \
					"emits"; "field"; \
					"type"; ds:C1482[$tableName][$fieldName].fieldType; \
					"hint"; "["+$tableName+"]"+$fieldName))
				
			End if 
			
		End for each 
	End for each 
	
	// init directions
	
	$data.push(New object:C1471(\
		"id"; "asc"; \
		"label"; "ASC"; \
		"nature"; "direction"; \
		"icon"; "ti-sort-ascending"; \
		"emits"; "direction"; \
		"hint"; Localized string:C991("tSortAscending")))
	
	$data.push(New object:C1471(\
		"id"; "desc"; \
		"label"; "DESC"; \
		"nature"; "direction"; \
		"icon"; "ti-sort-descending"; \
		"emits"; "direction"; \
		"hint"; Localized string:C991("tSortDescending")))
	
	// transmute
	
	$result:=JSON Stringify:C1217($data)
	
	
Function buttonCloseWin()
	
	CANCEL:C270
	
Function buttonPlansLoad()
	
	// declare var
	
	var $plans : Object
	
	var $fileName : Text
	
	// select file
	
	$fileName:=Select document:C905(99; ".4od"; "Save plans order by"; Utiliser fenêtre feuille:K24:11)
	If (Ok=1)
		
		// try load
		
		$plans:=JSON Parse:C1218(Document to text:C1236(document; "UTF-8"; Document inchangé:K24:18))
		If (Ok=1)
			
			// try load in area
			
			WA EXECUTE JAVASCRIPT FUNCTION:C1043(*; "aOrderBy"; "loadFromPlan"; *; $plans)
			
		End if 
	End if 
	
Function buttonPlansSave($plansText : Text)
	
	// declare var
	
	var $fileName : Text
	var $plans : Object:=JSON Parse:C1218("{\"plans\":"+$plansText+", \"version\":1.0 }")
	If (Ok=1)
		
		// select file name and directory
		
		$fileName:=Select document:C905(99; ".4od"; "Save plans order by"; Saisie nom de fichier:K24:17)
		If (Ok=1)
			
			// send contents to file
			
			TEXT TO DOCUMENT:C1237(document; JSON Stringify:C1217($plans; *); "UTF-8"; Document inchangé:K24:18)
			
		End if 
	End if 
	
Function buttonPlansExecute($plansText : Text)
	
	// declare vars
	
	var $plans : Object:=JSON Parse:C1218("{\"plans\":"+$plansText+", \"version\":1.0 }")
	
	var $lane; $pieces : Object
	
	var $formula; $tableLast : Text
	
	// code
	
	If (Value type:C1509(This:C1470.target)=Est un pointeur:K8:14)
		
		// loop on critere lanes
		
		For each ($lane; $plans.plans)
			
			// loop on pieces
			
			For each ($pieces; $lane.pieces)
				
				Case of 
					: ($pieces.nature="table")
						
						If ($tableLast="")
							
							$formula:="ORDER BY:C49(["+$pieces.label+"];"
							$tableLast:=$pieces.label
						Else 
							
							If ($tableLast#$pieces.label)
								
								// good ending
								
								If ($formula[[Length:C16($formula)]]=";")
									$formula:=Delete string:C232($formula; Length:C16($formula); 1)
								End if 
								
								$formula:=$formula+")"
								
								// execute order
								
								CALL FORM:C1391(This:C1470.windowOrigin; Formula:C1597(EXECUTE FORMULA:C63($formula)))
								
								$formula:="ORDER BY:C49(["+$pieces.label+"];"
								$tableLast:=$pieces.label
								
							End if 
						End if 
						
					: ($pieces.nature="field")
						
						$formula:=$formula+"["+$tableLast+"]"+$pieces.label+";"
						
					: ($pieces.nature="direction")
						
						$formula:=$formula+Choose:C955($pieces.label="ASC"; ">"; "<")+";"
						
					: ($pieces.nature="operator")
						
						// ( Y ) pas le temps laisser en plant
						
					: ($pieces.nature="function")
						
						// ( Y ) pas le temps laisser en plant
						
				End case 
				
			End for each 
		End for each 
		
		// good ending
		
		If ($formula[[Length:C16($formula)]]=";")
			$formula:=Delete string:C232($formula; Length:C16($formula); 1)
		End if 
		
		$formula:=$formula+")"
		
		// execute order
		
		CALL FORM:C1391(This:C1470.windowOrigin; Formula:C1597(EXECUTE FORMULA:C63($formula)))
		
	Else 
		
		// loop on critere lanes
		
		For each ($lane; $plans.plans)
			
			// loop on pieces
			
			For each ($pieces; $lane.pieces)
				
				Case of 
					: ($pieces.nature="table")
						
						If ($tableLast="")
							
							$formula:=This:C1470.instance+":="+This:C1470.instance+".orderBy(\""
							$tableLast:=$pieces.label
							
						Else 
							
							// good ending
							
							If ($formula[[Length:C16($formula)]]=",")
								$formula:=Delete string:C232($formula; Length:C16($formula); 1)
							End if 
							
							$formula:=$formula+"\")"
							
							// execute order
							
							CALL FORM:C1391(This:C1470.windowOrigin; Formula:C1597(EXECUTE FORMULA:C63($formula)))
							
							$formula:=This:C1470.instance+":="+This:C1470.instance+".orderBy(\""
							$tableLast:=$pieces.label
							
						End if 
						
					: ($pieces.nature="field")
						
						$formula:=$formula+$pieces.label+" "
						
					: ($pieces.nature="direction")
						
						$formula:=$formula+$pieces.label+","
						
					: ($pieces.nature="operator")
						
						// ( Y ) pas le temps laisser en plant
						
					: ($pieces.nature="function")
						
						// ( Y ) pas le temps laisser en plant
						
				End case 
				
			End for each 
		End for each 
		
		// good ending
		
		If ($formula[[Length:C16($formula)]]=",")
			$formula:=Delete string:C232($formula; Length:C16($formula); 1)
		End if 
		
		$formula:=$formula+"\")"
		
		// execute order
		
		CALL FORM:C1391(This:C1470.windowOrigin; Formula:C1597(EXECUTE FORMULA:C63($formula)))
		
	End if 
	