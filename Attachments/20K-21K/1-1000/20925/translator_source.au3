#include <IE.AU3>
#include <GUIConstants.au3>

GUICreate( "Translator" , 208,125)
GUISetState (@SW_SHOW)
GUICtrlCreateCombo ("Danish", 118,10, 80,20,)
GUICtrlSetData( 3, "Norwegian|Swedish" )
GUICtrlCreateLabel( "to",100,13)
GUICtrlCreateCombo ("English", 10,10, 80,20)
GUICtrlCreateInput( "Word to translate",10,40,188)
$button = GUICtrlCreateButton("Translate",10,60,188)
GUICtrlCreateInput( "",10,85,188,20,$ES_READONLY)
GUICtrlCreateLabel( "-by butji", 170,110 )

While 1
	$msg = GUIGetMsg()
    Select
	Case $msg = $button
		guictrlsetdata( 8, translate( GUICtrlRead( 6 ), "en", GUICtrlRead( 3)))
	Case $msg = $GUI_EVENT_CLOSE 
	ExitLoop
	EndSelect
Wend


Func translate( $search, $fromlang ,$tolang )
If $tolang = "Danish" Then
	$tolang = "da"
	$lang1 = 1
ElseIf $tolang = "Norwegian" Then
	$tolang = "no"
	$lang1 = 2
ElseIf $tolang = "Swedish" Then
	$tolang = "swe"
	$lang1 = 3
Endif
InetGet( "                                   "&$tolang&"&sl="&$fromlang&"&u=                                       " & $search,"txt" )
$l1 = FileReadLine( "txt",1)
$2bminus = StringLen( $search )
$len = StringLen( $l1 )
$len1 = $len - (3 * $2bminus)
If $lang1 = 1 Then
	$l2 = StringTrimLeft( $l1, 1218 + (1 * $2bminus))
	$l3 = StringTrimRight( $l2, 1672 + (2 * $2bminus))
ElseIf $lang1 = 2 Then
	$l2 = StringTrimLeft( $l1, 1225 + (1 * $2bminus))
	$l3 = StringTrimRight( $l2, 1672 + (2 * $2bminus))
ElseIf $lang1 = 3 Then
	$l2 = StringTrimLeft( $l1, 1223 + (1 * $2bminus))
	$l3 = StringTrimRight( $l2, 1678 + (2 * $2bminus))
Endif
FileDelete( "txt" )
If $l3 <> "" Then
Return $l3
ElseIf $l3 = "" Then
	MsgBox(0,"Error","The word could not be translated, please recheck your spelling." )
EndIf
EndFunc