
// declare vars

var aOrderBy_url : Text:=Get 4D folder:C485(Dossier Resources courant:K5:16)+"scripts"+Séparateur dossier:K24:12+"mod2_orderBy"+Séparateur dossier:K24:12+"main.html"

var $evs : Integer:=FORM Event:C1606.code

var $mod2 : Object

// events

Case of 
	: ($evs=Sur chargement:K2:1)
		
		// init area
		
		WA SET PREFERENCE:C1041(*; "aOrderBy"; WA autoriser déposer URL:K62:8; False:C215)
		WA SET PREFERENCE:C1041(*; "aOrderBy"; WA autoriser inspecteur Web:K62:7; True:C214)
		WA SET PREFERENCE:C1041(*; "aOrderBy"; WA autoriser menu contextuel:K62:6; True:C214)
		
		$mod2:=cs:C1710.Lib_Mod2.new()
		WA SET CONTEXT:C1848(*; "aOrderBy"; $mod2)
		
		// open framework
		
		WA OPEN URL:C1020(*; "aOrderBy"; "file://"+Convert path system to POSIX:C1106(aOrderBy_url))
		
End case 
