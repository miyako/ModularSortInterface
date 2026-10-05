var $dataClassName : Text
For each ($dataClassName; ds:C1482)
	If (ds:C1482[$dataClassName].getCount()=0)
		$path:=Localized document path:C1105(["SQLExport"; $dataClassName; "Export.sql"].join("/"))
		If (Test path name:C476($path)=Is a document:K24:1)
			SQL EXECUTE SCRIPT:C1089($path; SQL On error confirm:K49:16)
		End if 
	End if 
End for each 

winmake_home()
