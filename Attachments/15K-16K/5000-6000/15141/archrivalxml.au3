#include <Includes/_XMLDomWrapper.au3>
#include <Array.au3>

Dim $sFile = "config.xml"

FileDelete ( $sFile )

_XMLCreateFile ($sFile, "menu", True)
$XMLOBJECT = _XMLFileOpen ($sFile)

;Attributes for a folder item
$ATTRIBS1 = _ArrayCreate("name", "oscode")

;Attributes for a program item
$ATTRIBS2 = _ArrayCreate("name", "target", "oscode")

;Fake item 1
insertNode("Spyware/Install/Silent", _ArrayCreate("Great-Grandchild item", "PATH\TO\PROGRAM.EXE", "255"))

;Fake item 2
insertNode("Spyware/Install", _ArrayCreate("Grandchild item", "PATH\TO\PROGRAM.EXE", "255"))

;Fake item 3
insertNode("Spyware", _ArrayCreate("Child item", "PATH\TO\PROGRAM.EXE", "255"))

;Fake item 4
insertNode("", _ArrayCreate("Root item", "PATH\TO\PROGRAM.EXE", "255"))

;Fake item 5
insertNode("Antivirus", _ArrayCreate("Another child item", "PATH\TO\PROGRAM.EXE", "255"))

;Fake item 7
insertNode("Spyware/TEST", _ArrayCreate("Great-Grandchild item", "PATH\TO\PROGRAM.EXE", "255"))

;Transform if stylesheet exists
If FileExists ( "config.xsl" ) Then
	_XMLTransform ( $XMLOBJECT, "config.xsl","config.xml" )
EndIf


Func insertNode($PATH, $VALUES)
	$SPLITPATH = StringSplit($PATH, "/")
	
	;Reset element zero to zero for blank path (null counted as 1?)
	If $SPLITPATH[1] = "" Then $SPLITPATH[0] = 0
	
	;Maintain original path
	$ORIGINALPATH = $SPLITPATH
	
	$ROOT = "menu/"
	
	;Generate XPATH formatting for nodes
	For $X = 1 to $SPLITPATH[0]
		$SPLITPATH[$X] = StringFormat ( "folder[@name='%s']", $SPLITPATH[$X] )
	Next
		
	;Check if path is blank, if so create item in root
	If $SPLITPATH[0] Then
		
		;Generate folders to accomodate items path
		For $X = 1 to $SPLITPATH[0]
			
			$XPATH = $ROOT & _ArrayToString ( $SPLITPATH, "/", 1, $X )
			
			;Check if path exists
			If NOT IsArray ( _XMLGetPath ($XPATH) ) Then
				;MsgBox(48,"", $XPATH & " doesn't exist")
				If $X > 1 Then
					;CHILD FOLDER
					_XMLCreateChildWAttr($ROOT & _ArrayToString ( $SPLITPATH, "/", 1, $X - 1), "folder", $ATTRIBS1, _ArrayCreate($ORIGINALPATH[$X], "255"))
				Else
					;ROOT FOLDER
					_XMLCreateRootNodeWAttr("folder", $ATTRIBS1, _ArrayCreate($ORIGINALPATH[$X], "255"))
				EndIf
			EndIf
		Next
		
		;MsgBox(48,"", $XPATH)
		;CHILD ITEM
		_XMLCreateChildWAttr($XPATH, "item", $ATTRIBS2, $VALUES)
		
	Else
		;ROOT ITEM
		_XMLCreateRootNodeWAttr("item", $ATTRIBS2, $VALUES)
	EndIf
	
EndFunc