#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         Kip

 Script Function:
	Properties Control (1.2)

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once
#include <StaticConstants.au3>
#include <ListboxConstants.au3>
#include <TreeViewConstants.au3>
#include <Misc.au3>


; $PropControl = _PropList_Create($Hwnd, $X, $Y, $Width, $Height) 														; Create properties list area ($Hwnd = handle to window)
; $PropItem[0] = _PropList_AddItem($PropControl, $Name, $Value="", $Style=$PL_INPUT) 									; Create an item for ...CreateList()
; $PropList = _PropList_CreateList($PropControl, $PropItem, $ItemHeight=16, $Split=0, $NameHeader="", $ValueHeader="")	; Create a list 


Global $User32 = DllOpen("User32.dll")


Global $PL_INPUT = 1
Global $PL_LABEL = 2
Global $PL_BUTTON = 4
Global $PL_BROWSEBUTTON = 8
Global $PL_BREAK = 8

Global $PL_MSG_EDITSTART = 1
Global $PL_MSG_EDITEND = 2
Global $PL_MSG_BUTTON = 3
Global $PL_MSG_BROWSEBUTTON = 4
Global $PL_MSG_LABEL = 5
Global $PL_MSG_NAME = 6

Global $SelectedItem = -1
Global $SelectedLabel = -1
Global $SelectionInput
Global $SelectionGui
Global $SelectionList


Func _PropList_Create($Hwnd, $X, $Y, $Width, $Height, $EditControl=0)
	
	If not $EditControl Then
		$SelectionInput = GUICtrlCreateInput("",0,0,100,16)
	Else
		$SelectionInput = $EditControl
	EndIf
	
	GUICtrlSetState($SelectionInput, $GUI_HIDE)
	
	Dim $Return[7]
	
	$Return[0] = $X
	$Return[1] = $Y
	$Return[2] = $Width
	$Return[3] = $Height
	
	$Return[5] = Random(1000000,9999999)
	$Return[6] = $Hwnd
	
	GUIRegisterMsg(0x0216,"MovingList")
	
	Return $Return
	
EndFunc

Func _PropList_ItemGetValuePos($Proplist,$ItemID)
	
	$Style = _PropList_ItemGetStyle($Proplist, $ItemID)

	If BitAND($Style, $PL_INPUT) Or BitAND($Style, $PL_LABEL) Then
		Return ControlGetPos(GUICtrlGetHandle($Proplist[$ItemID][0]),"","")
	Else
		Return ControlGetPos(GUICtrlGetHandle($Proplist[$ItemID][1]),"","")
	EndIf
	
EndFunc

Func _PropList_ItemGetNamePos($Proplist,$ItemID)
	
	Return ControlGetPos(GUICtrlGetHandle($Proplist[$ItemID][3]),"","")
	
EndFunc

Func _PropList_ItemSetNameColor($Proplist, $ItemID, $Color=0x000000, $BkColor=$GUI_BKCOLOR_TRANSPARENT)
	
	GUICtrlSetColor($Proplist[$ItemID][3],$Color)
	GUICtrlSetBkColor($Proplist[$ItemID][3],$BkColor)
	
EndFunc

Func _PropList_ItemSetNameFont($Proplist, $ItemID, $Font="MS Sans Serif", $Size=8.5, $Attribute=0)
	Return GUICtrlSetFont($Proplist[$ItemID][3],$Size,400,$Attribute,$Font)
EndFunc

Func _PropList_ItemSetValueColor($Proplist, $ItemID, $Color=0x000000, $BkColor=$GUI_BKCOLOR_TRANSPARENT)
	
	$Style = _PropList_ItemGetStyle($Proplist, $ItemID)
	
	If BitAND($Style, $PL_INPUT) Or BitAND($Style, $PL_LABEL) Then
		GUICtrlSetColor($Proplist[$ItemID][0],$Color)
		GUICtrlSetBkColor($Proplist[$ItemID][0],$BkColor)
	Else
		GUICtrlSetColor($Proplist[$ItemID][1],$Color)
		GUICtrlSetBkColor($Proplist[$ItemID][1],$BkColor)
	EndIf
	
	Return 1
	
EndFunc

Func _PropList_ItemSetValueFont($Proplist, $ItemID, $Font="MS Sans Serif", $Size=8.5, $Attribute=0)
	
	$Style = _PropList_ItemGetStyle($Proplist, $ItemID)
	
	If BitAND($Style, $PL_INPUT) Or BitAND($Style, $PL_LABEL) Then
		GUICtrlSetFont($Proplist[$ItemID][0],$Size,400,$Attribute,$Font)
	Else
		GUICtrlSetFont($Proplist[$ItemID][1],$Size,400,$Attribute,$Font)
	EndIf
	
	Return 1
	
EndFunc

Func _PropList_ListSetNameColor($Proplist, $Color=0x000000, $BkColor=$GUI_BKCOLOR_TRANSPARENT)
	
	for $i = 0 to UBound($Proplist)-1
		
		GUICtrlSetColor($Proplist[$i][3],$Color)
		GUICtrlSetBkColor($Proplist[$i][3],$BkColor)
		
	Next
	
	Return 1
	
EndFunc

Func _PropList_ListSetValueColor($Proplist, $Color=0x000000, $BkColor=$GUI_BKCOLOR_TRANSPARENT)
	
	for $i = 0 to UBound($Proplist)-1
		
		$Style = _PropList_ItemGetStyle($Proplist, $i)
		
		If BitAND($Style, $PL_INPUT) Or BitAND($Style, $PL_LABEL) Then
			GUICtrlSetColor($Proplist[$i][0],$Color)
			GUICtrlSetBkColor($Proplist[$i][0],$BkColor)
		Else
			GUICtrlSetColor($Proplist[$i][1],$Color)
			GUICtrlSetBkColor($Proplist[$i][1],$BkColor)
		EndIf
		
	Next
	
	Return 1
	
EndFunc

Func _PropList_ListSetNameFont($Proplist, $Font="MS Sans Serif", $Size=8.5, $Attribute=0)
	
	for $i = 0 to UBound($Proplist)-1
		
		GUICtrlSetFont($Proplist[$i][3],$Size,400,$Attribute,$Font)
		
	Next
	
	Return 1
	
EndFunc

Func _PropList_ListSetValueFont($Proplist, $Font="MS Sans Serif", $Size=8.5, $Attribute=0)
	
	for $i = 0 to UBound($Proplist)-1
		
		$Style = _PropList_ItemGetStyle($Proplist, $i)
		
		If BitAND($Style, $PL_INPUT) Or BitAND($Style, $PL_LABEL) Then
			GUICtrlSetFont($Proplist[$i][0],$Size,400,$Attribute,$Font)
		Else
			GUICtrlSetFont($Proplist[$i][1],$Size,400,$Attribute,$Font)
		EndIf
		
	Next
	
	Return 1
	
EndFunc

Func _PropList_ListSetState($Proplist, $State)
	
	for $i = 0 to UBound($Proplist)-1
		If $Proplist[$i][0] Then GUICtrlSetState($Proplist[$i][0],$State)
		If $Proplist[$i][1] And $Proplist[$i][1] <> "Static" Then GUICtrlSetState($Proplist[$i][1],$State)
		If $Proplist[$i][2] Then GUICtrlSetState($Proplist[$i][2],$State)
		If $Proplist[$i][3] Then GUICtrlSetState($Proplist[$i][3],$State)
	Next
	Return 1
EndFunc

Func _PropList_ItemSetState($Proplist, $ItemID, $State)
	
	If $Proplist[$ItemID][0] Then GUICtrlSetState($Proplist[$ItemID][0],$State)
	If $Proplist[$ItemID][1] And $Proplist[$ItemID][1] <> "Static" Then GUICtrlSetState($Proplist[$ItemID][1],$State)
	If $Proplist[$ItemID][2] Then GUICtrlSetState($Proplist[$ItemID][2],$State)
	If $Proplist[$ItemID][3] Then GUICtrlSetState($Proplist[$ItemID][3],$State)
	Return 1
EndFunc

Func _PropList_ItemGetValue($Proplist, $ItemID)
	
	$Style = _PropList_ItemGetStyle($Proplist, $ItemID)
	
	If BitAND($Style, $PL_INPUT) Or BitAND($Style, $PL_LABEL) Then
		Return GUICtrlRead($Proplist[$ItemID][0])
	Else
		Return GUICtrlRead($Proplist[$ItemID][1])
	EndIf
	
EndFunc

Func _PropList_ItemSetValue($Proplist, $ItemID, $Value)
	
	$Style = _PropList_ItemGetStyle($Proplist, $ItemID)
	
	If BitAND($Style, $PL_INPUT) Or BitAND($Style, $PL_LABEL) Then
		Return GUICtrlSetData($Proplist[$ItemID][0],$Value)
	Else
		Return GUICtrlSetData($Proplist[$ItemID][1],$Value)
	EndIf
	
EndFunc

Func _PropList_ItemGetName($Proplist, $ItemID)
	Return GUICtrlRead($Proplist[$ItemID][3])
EndFunc

Func _PropList_ItemSetName($Proplist, $ItemID, $Name)
	Return GUICtrlSetData($Proplist[$ItemID][3],$Name)
EndFunc

Func _PropList_ItemGetStyle($Proplist, $ItemID)
	
	Dim $Return
	
	If $Proplist[$ItemID][0] Then
		If $Proplist[$ItemID][1] <> "Static" Then ; Input
			$Return = $PL_INPUT
		Else ; Label
			$Return = $PL_LABEL
		endif
	Else ; Button
		$Return = $PL_BUTTON
	EndIf
	
	If $Proplist[$ItemID][2] Then $Return += $PL_BROWSEBUTTON
	
	Return $Return
	
EndFunc


Func _PropList_EditStart($PropControl, $Proplist, $ItemID)
	
	$Style = _PropList_ItemGetStyle($Proplist, $ItemID)
	
	If not BitAND($Style, $PL_INPUT) Then Return 0
	
	$Pos = ControlGetPos($PropControl[6],"", $Proplist[$ItemID][0])
	$X = $Pos[0]
	$Y = $Pos[1]
	$Width = $Pos[2]
	$Height = $Pos[3]
	
	GUICtrlSetPos($SelectionInput,$X,$Y,$Width,$Height+1)
	GUICtrlSetData($SelectionInput,GUICtrlRead($Proplist[$ItemID][0]))
	GUICtrlSetState($SelectionInput,$GUI_SHOW)
	GUICtrlSetState($SelectionInput,$GUI_FOCUS)
	
	GUICtrlSetState($Proplist[$ItemID][0],$GUI_HIDE)
	GUICtrlSetState($SelectedLabel,$GUI_SHOW)
	
	$SelectedItem = $ItemID
	
	$SelectedLabel = $Proplist[$ItemID][0]
EndFunc


Func _PropList_EditEnd($Proplist)
	
	$Read = GUICtrlRead($SelectionInput)
	GUICtrlSetData($SelectedLabel,$Read)
	GUICtrlSetState($SelectionInput,$GUI_HIDE)
	GUICtrlSetState($SelectedLabel,$GUI_SHOW)
	$tmp = $SelectedItem
	$SelectedItem = -1
	$SelectedLabel = -1
	
	Return 1
	
EndFunc

Func _PropList_EditGetValue()
	
	If $SelectedLabel Then Return GUICtrlRead($SelectionInput)
	
EndFunc

Func _PropList_EditSetValue($Value)
	
	If $SelectedLabel Then Return GUICtrlSetData($SelectionInput, $Value)
	
EndFunc

Func _PropList_ListUpdate($PropHwnd, $Proplist, $nMsg=0)
	
	$Hwnd = $PropHwnd[6]
	
	if not $nMsg Then $nMsg = GUIGetMsg()
	
	Dim $Return[2]
	$Return[0] = -1
	
	For $i = 0 to UBound($Proplist)-1
		If $nMsg and $SelectedLabel <> $Proplist[$i][0] Then
			
			If $Proplist[$i][0] and $nMsg = $Proplist[$i][0] And $Proplist[$i][1] <> "Static" Then ; Input
				$Pos = ControlGetPos($Hwnd,"",$Proplist[$i][0])
				$X = $Pos[0]
				$Y = $Pos[1]
				$Width = $Pos[2]
				$Height = $Pos[3]
				GUISwitch($Hwnd)
				
				GUICtrlSetPos($SelectionInput,$X,$Y,$Width,$Height+1)
				GUICtrlSetData($SelectionInput,GUICtrlRead($Proplist[$i][0]))
				GUICtrlSetState($SelectionInput,$GUI_SHOW)
				GUICtrlSetState($SelectionInput,$GUI_FOCUS)
				
				GUICtrlSetState($Proplist[$i][0],$GUI_HIDE)
				GUICtrlSetState($SelectedLabel,$GUI_SHOW)
				
				$SelectedItem = $i
				
				$SelectedLabel = $Proplist[$i][0]
				
				$Return[0] = $i
				$Return[1] = $PL_MSG_EDITSTART
				Return $Return
				
			ElseIf $Proplist[$i][0] and $nMsg = $Proplist[$i][0] And $Proplist[$i][1] = "Static" Then ; Label
				$Return[0] = $i
				$Return[1] = $PL_MSG_LABEL
				Return $Return
				
			ElseIf $Proplist[$i][1] And $nMsg = $Proplist[$i][1] Then ; Button
				$Return[0] = $i
				$Return[1] = $PL_MSG_BUTTON
				Return $Return
				
			ElseIf $Proplist[$i][2] and $nMsg = $Proplist[$i][2] Then
				$Return[0] = $i
				$Return[1] = $PL_MSG_BROWSEBUTTON
				Return $Return
				
			ElseIf $Proplist[$i][3] and $nMsg = $Proplist[$i][3] Then
				$Return[0] = $i
				$Return[1] = $PL_MSG_NAME
				Return $Return
				
			EndIf
			
		EndIf
	Next
	
	If _IsPressed("0d",$User32) And $SelectedLabel <> -1 Then
		$Read = GUICtrlRead($SelectionInput)
			GUICtrlSetData($SelectedLabel,$Read)
			GUICtrlSetState($SelectionInput,$GUI_HIDE)
			GUICtrlSetState($SelectedLabel,$GUI_SHOW)
			$tmp = $SelectedItem
			$SelectedItem = -1
			$SelectedLabel = -1
			
			$Return[0] = $tmp
			$Return[1] = $PL_MSG_EDITEND
			
			Return $Return
	EndIf
	
	$cInfo = GUIGetCursorInfo($Hwnd)
	
	If IsArray($cInfo) Then
		If $cInfo[2] and $cInfo[4] <> $SelectionInput and $SelectedLabel <> -1 Then
			$Read = GUICtrlRead($SelectionInput)
			GUICtrlSetData($SelectedLabel,$Read)
			GUICtrlSetState($SelectionInput,$GUI_HIDE)
			GUICtrlSetState($SelectedLabel,$GUI_SHOW)
			$tmp = $SelectedItem
			$SelectedItem = -1
			$SelectedLabel = -1
			
			$Return[0] = $tmp
			$Return[1] = $PL_MSG_EDITEND
			
			Return $Return
			
		EndIf
	EndIf
	
	Return $Return
	
EndFunc


Func _PropList_ListCreate($PropList, $ItemsArray, $ItemHeight=16, $Split=0)
	
	$X = $PropList[0]
	$Y = $PropList[1]
	$Width = $PropList[2]
	$Height = $PropList[3]
	
	If not $Split Then
		$Split = $Width/2
	EndIf
	
	$StartY = 0
	
	
	dim $Return[UBound($ItemsArray)][4]
	
	If IsArray($ItemsArray) Then
		
		For $i = 0 to UBound($ItemsArray)-1
			$ItemSplit = StringSplit($ItemsArray[$i],@CRLF,1)
			$Name = $ItemSplit[1]
			$Value = $ItemSplit[2]
			$Style = $ItemSplit[3]
			$PropListID = $ItemSplit[4]
			
			$ButtonWidth = 19
			
			If $PropListID = String($PropList[5]) Then
				Select
					Case BitAND($Style, $PL_INPUT) or $Style = $PL_BROWSEBUTTON
						
						$Return[$i][3] = GUICtrlCreateLabel($Name,$X,$Y+($i*$ItemHeight)+$StartY,$Split,$ItemHeight,$SS_SUNKEN)
						
						If BitAND($Style, $PL_BROWSEBUTTON) Then 
							$Return[$i][0] = GUICtrlCreateLabel($Value,$X+$Split,$Y+($i*$ItemHeight)+$StartY,$Width-$Split-$ButtonWidth,$ItemHeight,$SS_SUNKEN)
							$Return[$i][2] = GUICtrlCreateButton("···",$X+$Width-$ButtonWidth,$Y+($i*$ItemHeight)+$StartY,$ButtonWidth,$ItemHeight)
						Else
							$Return[$i][0] = GUICtrlCreateLabel($Value,$X+$Split,$Y+($i*$ItemHeight)+$StartY,$Width-$Split,$ItemHeight,$SS_SUNKEN)
						EndIf
						
					Case BitAND($Style, $PL_BUTTON)
						
						$Return[$i][3] = GUICtrlCreateLabel($Name,$X,$Y+($i*$ItemHeight)+$StartY,$Split,$ItemHeight,$SS_SUNKEN)
						
						If BitAND($Style, $PL_BROWSEBUTTON) Then
							$Return[$i][1] = GUICtrlCreateButton($Value,$X+$Split,$Y+($i*$ItemHeight)+$StartY,$Width-$Split-$ButtonWidth,$ItemHeight)
							$Return[$i][2] = GUICtrlCreateButton("···",$X+$Width-$ButtonWidth,$Y+($i*$ItemHeight)+$StartY,$ButtonWidth,$ItemHeight)
						Else
							$Return[$i][1] = GUICtrlCreateButton($Value,$X+$Split,$Y+($i*$ItemHeight)+$StartY,$Width-$Split,$ItemHeight)
						EndIf
						
					Case BitAND($Style, $PL_LABEL)
						
						$Return[$i][3] = GUICtrlCreateLabel($Name,$X,$Y+($i*$ItemHeight)+$StartY,$Split,$ItemHeight,$SS_SUNKEN)
						If BitAND($Style, $PL_BROWSEBUTTON) Then 
							$Return[$i][0] = GUICtrlCreateLabel($Value,$X+$Split,$Y+($i*$ItemHeight)+$StartY,$Width-$Split-$ButtonWidth,$ItemHeight,$SS_SUNKEN)
							$Return[$i][1] = "Static"
							$Return[$i][2] = GUICtrlCreateButton("···",$X+$Width-$ButtonWidth,$Y+($i*$ItemHeight)+$StartY,$ButtonWidth,$ItemHeight)
						Else
							$Return[$i][0] = GUICtrlCreateLabel($Value,$X+$Split,$Y+($i*$ItemHeight)+$StartY,$Width-$Split,$ItemHeight,$SS_SUNKEN)
							$Return[$i][1] = "Static"
						EndIf
				EndSelect
			EndIf
		Next
	EndIf
	
	Return $Return
	
EndFunc

Func _PropList_ListState($Proplist, $State=$GUI_SHOW)
	
	for $i = 0 to UBound($Proplist)-1
		
		GUICtrlSetState($Proplist[$i][0],$State)
		GUICtrlSetState($Proplist[$i][1],$State)
		GUICtrlSetState($Proplist[$i][2],$State)
		GUICtrlSetState($Proplist[$i][3],$State)
		
	Next
	
EndFunc

Func _PropList_AddItem($PropList,$Name,$Value="", $Style=$PL_INPUT)
	
	Dim $Return = $Name&@CRLF&$Value&@CRLF&$Style&@CRLF&$PropList[5]
	
	Return $Return
	
EndFunc

Func _PropList_Dropdown_List($PropControl, $Proplist, $ItemID, $ListItems, $ListDefault, $PreferHeight=60, $PreferWidth=0, $Style=0)
	
	If IsArray($Style) Then
		$Color = $Style[0]
		$BkColor = $Style[1]
		$Font = $Style[2]
		$Size = $Style[3]
		$Weight = $Style[4]
		$Attribute = $Style[5]
	Else
		$Color = 0x000000
		$BkColor = 0xFFFFFF
		$Font = "MS Sans Serif"
		$Size = 8.5
		$Weight = 400
		$Attribute = 0
	EndIf
	
	Local $Read=$ListDefault, $pos, $win, $hWnd,$y,$Width,$Height,$listv,$cInfo,$nMsg
	$Pos = _PropList_ItemGetValuePos($Proplist,$ItemID)

	Local $ItemStyle = _PropList_ItemGetStyle($Proplist, $ItemID)

	If BitAND($ItemStyle, $PL_INPUT) Or BitAND($ItemStyle, $PL_LABEL) Then
	Local $win = WinGetPos(GUICtrlGetHandle($Proplist[$ItemID][0]))
	Else
	Local $win = WinGetPos(GUICtrlGetHandle($Proplist[$ItemID][1]))
	EndIf

	$hWnd = $PropControl[6]

	$Y = $Pos[3]
	$Width = $Pos[2]
	$Height = $Pos[3]

	If not $PreferWidth Then

	If BitAND($ItemStyle, $PL_BROWSEBUTTON) Then
	$Width += 19
	EndIf

	Else
	$Width = $PreferWidth
	EndIf

	$SelectionGui = GUICreate("",$Width, $PreferHeight, $win[0],$win[1]+$y, $WS_POPUP,$WS_EX_TOOLWINDOW, $hWnd)

	Local $listv = GUICtrlCreateList("",0,0,$Width,$PreferHeight,$WS_VSCROLL)
	GUICtrlSetData(-1,$ListItems,$ListDefault)
	
	GUICtrlSetColor(-1, $Color)
	GUICtrlSetBkColor(-1, $BkColor)
	GUICtrlSetFont(-1, $Size, $Weight, $Attribute, $Font)
	
	GUISetState(@SW_SHOW,$SelectionGui)

	Local $cInfo ,$nMsg

	While WinActive($SelectionGui)

	$cInfo = GUIGetCursorInfo($SelectionGui)
	$nMsg = GUIGetMsg(1)

	Select
	Case $cInfo[2]
	While $cInfo[2]
	$nMsg = GUIGetMsg(1)
	If $nMsg[0] = $listv And $cInfo[2] And $nMsg[1] = $SelectionGui Then
	$Read = GUICtrlRead($listv)
	ExitLoop 2
	EndIf
	$cInfo = GUIGetCursorInfo($SelectionGui)
	Sleep(100)
	WEnd
	Case _IsPressed("0D",$User32)
	$Read = GUICtrlRead($listv)
	If Not $Read Then $Read = $ListDefault
	ExitLoop
	Case $nMsg[0] = $GUI_EVENT_CLOSE
	ExitLoop
	Case $nMsg[1] > 0 And $nMsg[1] <> $SelectionGui
	ExitLoop
	EndSelect
	WEnd

	GUIDelete($SelectionGui)
	Return $Read
	
EndFunc

Func _PropList_Dropdown_Check($PropControl, $Proplist, $ItemID, $CheckItems, $StartIndex=0, $PreferHeight = 60, $PreferWidth = 0, $Style=0)
	
	If IsArray($Style) Then
		$Color = $Style[0]
		$BkColor = $Style[1]
		$Font = $Style[2]
		$Size = $Style[3]
		$Weight = $Style[4]
		$Attribute = $Style[5]
		
	Else
		$Color = 0x000000
		$BkColor = 0xFFFFFF
		$Font = "MS Sans Serif"
		$Size = 8.5
		$Weight = 400
		$Attribute = 0
	EndIf
	
	
	Local $pos, $win, $y,$Width,$Height,$OK,$Return,$ChecklistItems,$State
	$pos = _PropList_ItemGetValuePos($Proplist, $ItemID)
	$win = WinGetPos($PropControl[6])

	$hWnd = $PropControl[6]
	Local $ItemStyle = _PropList_ItemGetStyle($Proplist, $ItemID)

	If BitAND($ItemStyle, $PL_INPUT) Or BitAND($ItemStyle, $PL_LABEL) Then
	Local $win = WinGetPos(GUICtrlGetHandle($Proplist[$ItemID][0]))
	Else
	Local $win = WinGetPos(GUICtrlGetHandle($Proplist[$ItemID][1]))
	EndIf

	$y = $pos[3]
	$Width = $pos[2]
	$Height = $pos[3]

	Local $ChecklistItems[UBound($CheckItems)]
	Local $Return[UBound($CheckItems)]

	If Not $PreferWidth Then

	$ItemStyle = _PropList_ItemGetStyle($Proplist, $ItemID)

	If BitAND($ItemStyle, $PL_BROWSEBUTTON) Then
	$Width += 19
	EndIf

	Else

	$Width = $PreferWidth

	EndIf

	$SeparatorChar = Opt("GUIDataSeparatorChar")

	$SelectionGui = GUICreate("", $Width, $PreferHeight, $win[0] , $win[1] + $y, $WS_POPUP, $WS_EX_TOPMOST, $hWnd)

	Local $Tree = GUICtrlCreateTreeView(0, 0, $Width, $PreferHeight, BitOR($TVS_CHECKBOXES, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS ), $WS_EX_CLIENTEDGE)
	
	GUICtrlSetColor(-1, $Color)
	GUICtrlSetBkColor(-1, $BkColor)
	GUICtrlSetFont(-1, $Size, $Weight, $Attribute, $Font)
	

	;GUISetBkColor($BkColor)
	GUICtrlSetBkColor($Tree,$BkColor)


	For $i = $StartIndex To UBound($CheckItems) - 1

	$Split = StringSplit($CheckItems[$i], $SeparatorChar)

	$State = $Split[1]
	$Value = StringReplace($CheckItems[$i], $State & $SeparatorChar, "", 1)
	$Return[$i] = $Value
	$ChecklistItems[$i] = GUICtrlCreateTreeViewItem($Value,$Tree)
	If $State = "1" Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf

	Next

	GUISetState()



	While WinActive($SelectionGui)

	$cInfo = GUIGetCursorInfo($SelectionGui)
	$nMsg = GUIGetMsg(1)

	Select
	;~ Case $cInfo[2]
	Case $nMsg[1] = $SelectionGui And $nMsg[0] = $OK
	ExitLoop
	Case _IsPressed("0D", $User32)
	ExitLoop
	Case $nMsg[0] = $GUI_EVENT_CLOSE
	ExitLoop
	Case $nMsg[1] > 0 And $nMsg[1] <> $SelectionGui
	ExitLoop
	EndSelect
	WEnd


	For $i = $StartIndex To UBound($CheckItems) - 1
	If BitAND(GUICtrlRead($ChecklistItems[$i]),$GUI_CHECKED) = $GUI_CHECKED Then
	$State = "1"
	Else
	$State = "0"
	EndIf

	$Value = $Return[$i]

	$Return[$i] = $State & $SeparatorChar & $Value
	Next
	
	GUIDelete($SelectionGui)

	Return $Return

EndFunc

Func _PropList_Dropdown_Style($Color=-1, $BkColor=-1, $Font=-1, $Size=-1, $Weight=-1, $Attribute=-1)
	
	Dim $Return[6]
	
	If $Color = -1 Then
		$Return[0] = 0x000000
	Else
		$Return[0] = $Color
	EndIf
	
	If $BkColor = -1 Then
		$Return[1] = 0xFFFFFF
	Else
		$Return[1] = $BkColor
	EndIf
	
	If $Font = -1 Then
		$Return[2] = "MS Sans Serif"
	Else
		$Return[2] = $Font
	EndIf
	
	If $Size = -1 Then
		$Return[3] = 8.5
	Else
		$Return[3] = $Size
	EndIf
	
	If $Weight = -1 Then
		$Return[4] = 400
	Else
		$Return[4] = $Weight
	EndIf
	
	If $Attribute = -1 Then
		$Return[5] = 0
	Else
		$Return[5] = $Attribute
	EndIf
	
	Return $Return
	
EndFunc

Func MovingList($hWnd, $Msg, $wParam, $lParam)
	If BitAnd(WinGetState($SelectionGui), 2) Then
		GUISetState(@SW_HIDE,$SelectionGui)
	EndIf
EndFunc