



#include <GuiEdit.au3>
#include <GUIConstants.au3>
#include <Array.au3>

GUICreate("My GUI")  ; will create a dialog box that when displayed is centered
GUISetState (@SW_SHOW)       ; will display an empty dialog box
$Text_box = GUICtrlCreateEdit("Text Area",10,10,350,350,$ES_AUTOVSCROLL+$WS_VSCROLL+$WS_HSCROLL)
$convert = GUICtrlCreateButton("Convert",150,360,70,20)



func Convert()
	GUICtrlSetState ( $convert, $GUI_DISABLE )
	GUICtrlSetData ( $convert, "Please Wait" )

	Dim $avArray[1]


	$text = GUICtrlRead($Text_box)
	$text = StringStripWS($text,2)
	$text = StringReplace($text, @TAB, "|")
	$avArray = StringSplit($text,@CRLF)
	_ArrayDelete( $avArray,0)
	_ArraySort($avArray)
		
	Empty_array($avArray) ; Deleting the empty array
;~ 	Do
;~ 		$Pos = _ArraySearch ($avArray, "", 0, 0, 0, False)
;~ 	Select
;~     Case $Pos = -1
;~     Case Else
;~ 		_ArrayDelete( $avArray,0)
;~ 	EndSelect
;~ 	until $Pos = -1
	$address1 = ""
	
	For $I = 0 to UBound( $avArray ) + 1
    Dim $avArray_string = _ArrayToString( $avArray,"|",$I, $I)

	$num_pos = StringInStr($avArray_string, "|")
	If $num_pos = 0 Then
;~ 		msgbox(0,"","String didnt match")
	Else
	$number = StringLeft($avArray_string,$num_pos)
	$number = StringTrimRight($number,1)
	$street = StringTrimLeft($avArray_string,$num_pos)
	$address = $street & " - " & $number
	$Start_search = $I + 1
Do
	$Pos = _ArraySearch ($avArray, $street,$Start_search, 0, 0, True)
	Select
	Case $Pos = -1
		
    Case Else
	
		$avArray_string = _ArrayToString( $avArray,"|",$Pos, $Pos)
			$num_pos = StringInStr($avArray_string, "|")
		If $num_pos = 0 Then
		Else
		$Found_number = StringLeft($avArray_string,$num_pos)
		$Found_number = StringTrimRight($Found_number,1)
;~ 		IF $Found_number <> $number Then
			$address = $address& ","  & $Found_number
		_ArrayDelete( $avArray,$Pos)
;~ 		Else
;~ 		$address = $address
;~ 		EndIf
	EndIf
    EndSelect    
	
	until $Pos = -1
	$address1 = $address1 & @CRLF & $address
	EndIf
	Next
	Dim $newarray = StringSplit($address1,@CRLF)
	_ArraySort($newarray)
	Empty_array($newarray)
;~ 	Do
;~ 		$Pos = _ArraySearch ($newarray, "", 0, 0, 0, False)
;~ 	Select
;~     Case $Pos = -1
;~     Case Else
;~ 		_ArrayDelete( $newarray,0)
;~ 	EndSelect
;~ 	until $Pos = -1
	_ArrayDelete( $newarray,0)
;~ 	_ArrayDisplay($newarray)
	$address1 = _ArrayToString( $newarray,@CRLF,0)
	msgbox(0,"",$address1)
	_GUICtrlEdit_SetText ($Text_box, $address1)
	GUICtrlSetData ( $convert, "Convert")
	GUICtrlSetState ( $convert, $GUI_ENABLE )
EndFunc




Func Empty_array(ByRef $Array)
	Do
		$Pos = _ArraySearch ($Array, "", 0, 0, 0, False)
	Select
    Case $Pos = -1
    Case Else
		_ArrayDelete( $Array,0)
	EndSelect
until $Pos = -1
EndFunc























While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $convert
		Convert()
	case $msg = $GUI_EVENT_CLOSE 
	Exit
	EndSelect
Wend