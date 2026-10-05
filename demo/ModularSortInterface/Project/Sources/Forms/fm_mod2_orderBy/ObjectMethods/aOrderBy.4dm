
// declare vars

var $evs : Integer:=FORM Event:C1606.code

var $url : Text

// evs

Case of 
	: ($evs=Sur refus ouverture fenêtre:K2:51)
		
		$url:=WA Get last filtered URL:C1035(*; "aOrderBy")
		
	: ($evs=Sur fin chargement URL:K2:47)
		
		WA EXECUTE JAVASCRIPT FUNCTION:C1043(*; "aOrderBy"; "setBaseLang"; *; Get database localization:C1009(Langue courante:K5:22))
		WA EXECUTE JAVASCRIPT FUNCTION:C1043(*; "aOrderBy"; "setContentsTitle"; *; Get window title:C450(Current form window:C827))
		
End case 
