#include <GuiMenu.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
;#include <GuiImageList.au3>
Global $_OneRec = "",$Record = "", $ViewForm,$NewForm,$c, $_row, $Recordnumber,$_EDITRec
$hGUI = GUICreate('Base DBase', 800, 500)
$View = GUICtrlCreateButton ( "View", 10, 460,90)
$New = GUICtrlCreateButton ( "New", 100, 460,90)
$Del = GUICtrlCreateButton("Delete", 190, 460, 90)
$hListView = _GUICtrlListView_Create($hGUI, "", 2, 2, 800, 440)
_GUICtrlListView_SetExtendedListViewStyle($hListView, $LVS_EX_GRIDLINES)
GUISetState()

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
$file = FileOpen("C:\Base\DBase.txt", 8)

If $file = -1 Then
	DirCreate("C:\Base")
	$file = FileOpen("C:\Base\DBase.txt", 10)

	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf
EndIf
$Records = FileRead($file)
FileClose($file)
If $Records  = "   " Then
	
else
	Main()
Endif
GUISetState(@SW_SHOW)
GUISwitch($hGUI)
; Loop until user exits
$msg = GUIGetMsg()
Do 
	$msg1 = GUIGetMsg()
	Select
	;Check if user clicked on a close button of any of the 2 windows
		Case $msg1 = $GUI_EVENT_CLOSE
			GUIDelete()
			;Exit the script
			Exit
		Case $msg1 = $View
			GUICtrlSetState($View, $GUI_DISABLE)
			GUICtrlSetState($New, $GUI_DISABLE)
			EditWin()
		Case $msg1 = $New
			GUICtrlSetState($View, $GUI_DISABLE)
			GUICtrlSetState($New, $GUI_DISABLE)	
			NewWin()
		Case $msg1 = $Del
			DeleteItem()
	EndSelect
Until $msg = $GUI_EVENT_CLOSE

Func ListView_Click()

    
EndFunc   ;==>ListView_Click


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
    $hWndListView = $hListView
    If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    ;$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hWndListView
            Switch $iCode
                Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
                    Local $aHit = _GUICtrlListView_SubItemHitTest($hListView) ; Get id of clicked item
                    If $aHit[0] <> -1 Then ; Check it was an item
						$Record = ""
						$_row = $aHit[0]
						for $aHit[1] = 0 to 28
						Local $sText = _GUICtrlListView_GetItemText($hListView, $aHit[0], $aHit[1] ); Read the item text
						$Record = $Record & $sText & "|"
						next
                    EndIf
                    Return 0
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
    
EndFunc   ;==>WM_NOTIFY
Func EditWin()
	for $Column = 0 to 28
		$OneRec =_GUICtrlListView_GetItemText($hListView, 0, $Column)
		$_OneRec = $_OneRec & $OneRec & "|"
	Next
	If $Record = "" Then
		If $_OneRec = "" Then
			$Record = "|||||||||||||||||||||||||||||"
		Else 
			$Record = $_OneRec
		EndIf
	EndIf
	$Fields = StringSplit($Record,"|",1)
	$ViewForm = GUICreate("Individual Records", 500, 350, -1, -1, Default, Default, WinGetHandle(AutoItWinGetTitle()))
	$Label1 =  GUICtrlCreateLabel("ID", 10, 10, 50)
	$Label2 =  GUICtrlCreateLabel("Last Name", 10, 30, 120)
	$Label3 =  GUICtrlCreateLabel("First Name", 10, 50, 120)
	$Label4 =  GUICtrlCreateLabel("Middle Initial", 10, 70, 120)
	$Label5 =  GUICtrlCreateLabel("Employee Number", 10, 90, 120)
	$Label6 =  GUICtrlCreateLabel("Hiring Date", 10, 110, 120)
	$Label7 =  GUICtrlCreateLabel("Permanency Date", 10, 130, 120)
	$Label8 =  GUICtrlCreateLabel("Unit Assigned", 10, 150, 120)
	$Label9 =  GUICtrlCreateLabel("Date Started", 10, 170, 120)
	$Label10 =  GUICtrlCreateLabel("Designation", 10, 190, 120)
	$Label11 =  GUICtrlCreateLabel("Rank / Job Level", 10, 210, 120)
	$Label12 =  GUICtrlCreateLabel("Date Last Promoted", 10, 230, 120)
	$Label13 =  GUICtrlCreateLabel("Work Schedule", 10, 250, 120)
	$Label14 =  GUICtrlCreateLabel("Previous Employer", 10, 270, 120)
	$Label15 =  GUICtrlCreateLabel("Division Dept.", 10, 290, 120)
	$Label16 =  GUICtrlCreateLabel("Position", 250, 30, 120)
	$Label17 =  GUICtrlCreateLabel("Inclusive Dates", 250, 50, 120)
	$Label18 =  GUICtrlCreateLabel("Birth Date", 250, 70, 120)
	$Label19 =  GUICtrlCreateLabel("Birth Place", 250, 90, 120)
	$Label20 =  GUICtrlCreateLabel("Gender", 250, 110, 120)
	$Label21 =  GUICtrlCreateLabel("Civil Status", 250, 130,120)
	$Label22 =  GUICtrlCreateLabel("Citizenship", 250, 150, 120)
	$Label23 =  GUICtrlCreateLabel("Religion", 250, 170, 120)
	$Label24 =  GUICtrlCreateLabel("Univ / School Graduated", 250, 190, 120)
	$Label25 =  GUICtrlCreateLabel("Degree / Course", 250, 210, 120)
	$Label26 =  GUICtrlCreateLabel("Valid ID Details", 250, 230, 120)
	$Label27 =  GUICtrlCreateLabel("Home Address", 250, 250, 120)
	$Label28 =  GUICtrlCreateLabel("Home Telephone", 250, 270, 120)
	$Label29 =  GUICtrlCreateLabel("Mobile Number", 250, 290, 120)
	$Input1 = GUICtrlCreateInput($Fields[1], 130, 10, 100, 18)
	$Input2 = GUICtrlCreateInput($Fields[2], 130, 30, 100, 18)
	$Input3 = GUICtrlCreateInput($Fields[3], 130, 50, 100, 18)
	$Input4 = GUICtrlCreateInput($Fields[4], 130, 70, 100, 18)
	$Input5 = GUICtrlCreateInput($Fields[5], 130, 90, 100, 18)
	$Input6 = GUICtrlCreateInput($Fields[6], 130, 110, 100, 18)
	$Input7 = GUICtrlCreateInput($Fields[7], 130, 130, 100, 18)
	$Input8 = GUICtrlCreateInput($Fields[8], 130, 150, 100, 18)
	$Input9 = GUICtrlCreateInput($Fields[9], 130, 170, 100, 18)
	$Input10 = GUICtrlCreateInput($Fields[10], 130, 190, 100, 18)
	$Input11 = GUICtrlCreateInput($Fields[11], 130, 210, 100, 18)
	$Input12 = GUICtrlCreateInput($Fields[12], 130, 230, 100, 18)
	$Input13 = GUICtrlCreateInput($Fields[13], 130, 250, 100, 18)
	$Input14 = GUICtrlCreateInput($Fields[14], 130, 270, 100, 18)
	$Input15 = GUICtrlCreateInput($Fields[15], 130, 290, 100, 18)
	$Input16 = GUICtrlCreateInput($Fields[16], 380, 30, 100, 18)
	$Input17 = GUICtrlCreateInput($Fields[17], 380, 50, 100, 18)
	$Input18 = GUICtrlCreateInput($Fields[18], 380, 70, 100, 18)
	$Input19 = GUICtrlCreateInput($Fields[19], 380, 90, 100, 18)
	$Input20 = GUICtrlCreateInput($Fields[20], 380, 110, 100, 18)
	$Input21 = GUICtrlCreateInput($Fields[21], 380, 130, 100, 18)
	$Input22 = GUICtrlCreateInput($Fields[22], 380, 150, 100, 18)
	$Input23 = GUICtrlCreateInput($Fields[23], 380, 170, 100, 18)
	$Input24 = GUICtrlCreateInput($Fields[24], 380, 190, 100, 18)
	$Input25 = GUICtrlCreateInput($Fields[25], 380, 210, 100, 18)
	$Input26 = GUICtrlCreateInput($Fields[26], 380, 230, 100, 18)
	$Input27 = GUICtrlCreateInput($Fields[27], 380, 250, 100, 18)
	$Input28 = GUICtrlCreateInput($Fields[28], 380, 270, 100, 18)
	$Input29 = GUICtrlCreateInput($Fields[29], 380, 290, 100, 18)
	GUICtrlSetState($Input1, $GUI_DISABLE)
	GUICtrlSetState($Input2, $GUI_DISABLE)
	GUICtrlSetState($Input3, $GUI_DISABLE)
	GUICtrlSetState($Input4, $GUI_DISABLE)
	GUICtrlSetState($Input5, $GUI_DISABLE)
	GUICtrlSetState($Input6, $GUI_DISABLE)
	GUICtrlSetState($Input7, $GUI_DISABLE)
	GUICtrlSetState($Input8, $GUI_DISABLE)
	GUICtrlSetState($Input9, $GUI_DISABLE)
	GUICtrlSetState($Input10, $GUI_DISABLE)
	GUICtrlSetState($Input11, $GUI_DISABLE)
	GUICtrlSetState($Input12, $GUI_DISABLE)
	GUICtrlSetState($Input13, $GUI_DISABLE)
	GUICtrlSetState($Input14, $GUI_DISABLE)
	GUICtrlSetState($Input15, $GUI_DISABLE)
	GUICtrlSetState($Input16, $GUI_DISABLE)
	GUICtrlSetState($Input17, $GUI_DISABLE)
	GUICtrlSetState($Input18, $GUI_DISABLE)
	GUICtrlSetState($Input19, $GUI_DISABLE)
	GUICtrlSetState($Input20, $GUI_DISABLE)
	GUICtrlSetState($Input21, $GUI_DISABLE)
	GUICtrlSetState($Input22, $GUI_DISABLE)
	GUICtrlSetState($Input23, $GUI_DISABLE)
	GUICtrlSetState($Input24, $GUI_DISABLE)
	GUICtrlSetState($Input25, $GUI_DISABLE)
	GUICtrlSetState($Input26, $GUI_DISABLE)
	GUICtrlSetState($Input27, $GUI_DISABLE)
	GUICtrlSetState($Input28, $GUI_DISABLE)
	GUICtrlSetState($Input29, $GUI_DISABLE)
	$Button1 = GUICtrlCreateButton("Previous", 60, 320, 100)
	$Button2 = GUICtrlCreateButton("Edit", 185, 320, 100)
	$Button3 = GUICtrlCreateButton("Next", 310, 320, 100)
	;Show the child window/Make the child window visible
	GUISetState(@SW_SHOW)
		While 1
			$msg = GUIGetMsg(1)
			Select
				;Check if user clicked on a close button of any of the 2 windows
				Case $msg[0] = $GUI_EVENT_CLOSE
					;Check if user clicked on the close button of the child window
					If $msg[1] = $ViewForm Then
						GUICtrlSetState($View, $GUI_ENABLE)
						GUICtrlSetState($New, $GUI_ENABLE)
						;Switch to the child window
						GUISwitch($hGUI)
						;Destroy the child GUI including the controls
						GUIDelete($ViewForm)
						;Check if user clicked on the close button of the parent window
					ElseIf $msg[1] = $hGUI Then
						;Switch to the parent window
						GUISwitch($hGUI)
						;Destroy the parent GUI including the controls
						GUIDelete()
						;Exit the script
						Exit
					ElseIf $msg[1] = $NewForm Then
						GUICtrlSetState($View, $GUI_ENABLE)
						GUICtrlSetState($New, $GUI_ENABLE)
						;Switch to the child window
						GUISwitch($hGUI)
						;Destroy the child GUI including the controls
						GUIDelete($NewForm)
						;Check if user clicked on the close button of the parent window
					Endif
				Case $msg[0] = $View
					GUICtrlSetState($View, $GUI_DISABLE)
					GUICtrlSetState($New, $GUI_DISABLE)
					EditWin()
				Case  $msg[0] = $New
					GUICtrlSetState($View, $GUI_DISABLE)
					GUICtrlSetState($New, $GUI_DISABLE)
					NewWin()
				Case  $msg[0] = $Del	
					DeleteItem()
				Case $msg[0] = $Button2
					If GUICtrlRead($Button2) = "Edit" Then
						GUICtrlSetData($Button2, "Save")
						GUICtrlSetState($Input1, $GUI_ENABLE)
						GUICtrlSetState($Input2, $GUI_ENABLE)
						GUICtrlSetState($Input3, $GUI_ENABLE)
						GUICtrlSetState($Input4, $GUI_ENABLE)
						GUICtrlSetState($Input5, $GUI_ENABLE)
						GUICtrlSetState($Input6, $GUI_ENABLE)
						GUICtrlSetState($Input7, $GUI_ENABLE)
						GUICtrlSetState($Input8, $GUI_ENABLE)
						GUICtrlSetState($Input9, $GUI_ENABLE)
						GUICtrlSetState($Input10, $GUI_ENABLE)
						GUICtrlSetState($Input11, $GUI_ENABLE)
						GUICtrlSetState($Input12, $GUI_ENABLE)
						GUICtrlSetState($Input13, $GUI_ENABLE)
						GUICtrlSetState($Input14, $GUI_ENABLE)
						GUICtrlSetState($Input15, $GUI_ENABLE)
						GUICtrlSetState($Input16, $GUI_ENABLE)
						GUICtrlSetState($Input17, $GUI_ENABLE)
						GUICtrlSetState($Input18, $GUI_ENABLE)
						GUICtrlSetState($Input19, $GUI_ENABLE)
						GUICtrlSetState($Input20, $GUI_ENABLE)
						GUICtrlSetState($Input21, $GUI_ENABLE)
						GUICtrlSetState($Input22, $GUI_ENABLE)
						GUICtrlSetState($Input23, $GUI_ENABLE)
						GUICtrlSetState($Input24, $GUI_ENABLE)
						GUICtrlSetState($Input25, $GUI_ENABLE)
						GUICtrlSetState($Input26, $GUI_ENABLE)
						GUICtrlSetState($Input27, $GUI_ENABLE)
						GUICtrlSetState($Input28, $GUI_ENABLE)
						GUICtrlSetState($Input29, $GUI_ENABLE)
						GUICtrlSetState($Button1, $GUI_DISABLE)
						GUICtrlSetState($Button3, $GUI_DISABLE)
					Else
						GUICtrlSetData($Button2, "Edit")
						GUICtrlSetState($Input1, $GUI_DISABLE)
						GUICtrlSetState($Input2, $GUI_DISABLE)
						GUICtrlSetState($Input3, $GUI_DISABLE)
						GUICtrlSetState($Input4, $GUI_DISABLE)
						GUICtrlSetState($Input5, $GUI_DISABLE)
						GUICtrlSetState($Input6, $GUI_DISABLE)
						GUICtrlSetState($Input7, $GUI_DISABLE)
						GUICtrlSetState($Input8, $GUI_DISABLE)
						GUICtrlSetState($Input9, $GUI_DISABLE)
						GUICtrlSetState($Input10, $GUI_DISABLE)
						GUICtrlSetState($Input11, $GUI_DISABLE)
						GUICtrlSetState($Input12, $GUI_DISABLE)
						GUICtrlSetState($Input13, $GUI_DISABLE)
						GUICtrlSetState($Input14, $GUI_DISABLE)
						GUICtrlSetState($Input15, $GUI_DISABLE)
						GUICtrlSetState($Input16, $GUI_DISABLE)
						GUICtrlSetState($Input17, $GUI_DISABLE)
						GUICtrlSetState($Input18, $GUI_DISABLE)
						GUICtrlSetState($Input19, $GUI_DISABLE)
						GUICtrlSetState($Input20, $GUI_DISABLE)
						GUICtrlSetState($Input21, $GUI_DISABLE)
						GUICtrlSetState($Input22, $GUI_DISABLE)
						GUICtrlSetState($Input23, $GUI_DISABLE)
						GUICtrlSetState($Input24, $GUI_DISABLE)
						GUICtrlSetState($Input25, $GUI_DISABLE)
						GUICtrlSetState($Input26, $GUI_DISABLE)
						GUICtrlSetState($Input27, $GUI_DISABLE)
						GUICtrlSetState($Input28, $GUI_DISABLE)
						GUICtrlSetState($Input29, $GUI_DISABLE)
						if $_row = "" then
							$_row = 0
						endif
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input1), 0)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input2), 1)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input3), 2)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input4), 3)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input5), 4)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input6), 5)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input7), 6)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input8), 7)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input9), 8)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input10), 9)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input11), 10)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input12), 11)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input13), 12)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input14), 13)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input15), 14)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input16), 15)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input17), 16)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input18), 17)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input19), 18)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input20), 19)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input21), 20)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input22), 21)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input23), 22)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input24), 23)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input25), 24)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input26), 25)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input27), 26)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input28), 27)
						_GUICtrlListView_SetItemText($hListView, $_row, GUICtrlRead($Input29), 28)
						Global $NewFileCont
						For $GH = 0 to $Recordnumber - 1
							$NewFileCont = $NewFileCont & _GUICtrlListView_GetItemText($hListView, $GH, 0) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 1) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 2) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 3) & "^_^" & _
							_GUICtrlListView_GetItemText($hListView, $GH, 4) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 5) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 6) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 7) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 8) & "^_^" & _
							_GUICtrlListView_GetItemText($hListView, $GH, 9) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 10) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 11) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 12) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 13) & "^_^" & _
							_GUICtrlListView_GetItemText($hListView, $GH, 14) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 15) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 16) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 17) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 18) & "^_^" & _
							_GUICtrlListView_GetItemText($hListView, $GH, 19) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 20) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 21) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 22) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 23) & "^_^" & _
							_GUICtrlListView_GetItemText($hListView, $GH, 24) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 25) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 26) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 27) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GH, 28) & @CrLf
						Next
						FileDelete("C:\Base\DBase.txt")
						sleep(50)
						$Sfile = FileOpen("C:\Base\DBase.txt", 10)
						; Check if file opened for reading OK
						If $Sfile = -1 Then
							MsgBox(0, "Error", "Error Editing The File!")
							GUIDelete($ViewForm)
						EndIf
						FileWriteLine($Sfile, $NewFileCont)
						FileClose($Sfile)
						MsgBox(0,"Notice", "Sucessfuly Edited one Record")
						$NewFileCont = ""
						GUICtrlSetState($Button1, $GUI_ENABLE)
						GUICtrlSetState($Button3, $GUI_ENABLE)
					EndIf
				Case $msg[0] = $Button1
					if $_row = 0 then
					$_row = 0
					else
					$_row = $_row - 1	
					GUICtrlSetData($Input1, _GUICtrlListView_GetItemText($hListView, $_row, 0))
					GUICtrlSetData($Input2, _GUICtrlListView_GetItemText($hListView, $_row, 1))
					GUICtrlSetData($Input3, _GUICtrlListView_GetItemText($hListView, $_row, 2))
					GUICtrlSetData($Input4, _GUICtrlListView_GetItemText($hListView, $_row, 3))
					GUICtrlSetData($Input5, _GUICtrlListView_GetItemText($hListView, $_row, 4))
					GUICtrlSetData($Input6, _GUICtrlListView_GetItemText($hListView, $_row, 5))
					GUICtrlSetData($Input7, _GUICtrlListView_GetItemText($hListView, $_row, 6))
					GUICtrlSetData($Input8, _GUICtrlListView_GetItemText($hListView, $_row, 7))
					GUICtrlSetData($Input9, _GUICtrlListView_GetItemText($hListView, $_row, 8))
					GUICtrlSetData($Input10, _GUICtrlListView_GetItemText($hListView, $_row, 9))
					GUICtrlSetData($Input11, _GUICtrlListView_GetItemText($hListView, $_row, 10))
					GUICtrlSetData($Input12, _GUICtrlListView_GetItemText($hListView, $_row, 11))
					GUICtrlSetData($Input13, _GUICtrlListView_GetItemText($hListView, $_row, 12))
					GUICtrlSetData($Input14, _GUICtrlListView_GetItemText($hListView, $_row, 13))
					GUICtrlSetData($Input15, _GUICtrlListView_GetItemText($hListView, $_row, 14))
					GUICtrlSetData($Input16, _GUICtrlListView_GetItemText($hListView, $_row, 15))
					GUICtrlSetData($Input17, _GUICtrlListView_GetItemText($hListView, $_row, 16))
					GUICtrlSetData($Input18, _GUICtrlListView_GetItemText($hListView, $_row, 17))
					GUICtrlSetData($Input19, _GUICtrlListView_GetItemText($hListView, $_row, 18))
					GUICtrlSetData($Input20, _GUICtrlListView_GetItemText($hListView, $_row, 19))
					GUICtrlSetData($Input21, _GUICtrlListView_GetItemText($hListView, $_row, 20))
					GUICtrlSetData($Input22, _GUICtrlListView_GetItemText($hListView, $_row, 21))
					GUICtrlSetData($Input23, _GUICtrlListView_GetItemText($hListView, $_row, 22))
					GUICtrlSetData($Input24, _GUICtrlListView_GetItemText($hListView, $_row, 23))
					GUICtrlSetData($Input25, _GUICtrlListView_GetItemText($hListView, $_row, 24))
					GUICtrlSetData($Input26, _GUICtrlListView_GetItemText($hListView, $_row, 25))
					GUICtrlSetData($Input27, _GUICtrlListView_GetItemText($hListView, $_row, 26))
					GUICtrlSetData($Input28, _GUICtrlListView_GetItemText($hListView, $_row, 27))
					GUICtrlSetData($Input29, _GUICtrlListView_GetItemText($hListView, $_row, 28))
					endif
				Case $msg[0] = $Button3
					if $_row < $Recordnumber - 1 Then
						$_row = $_row + 1	
						GUICtrlSetData($Input1, _GUICtrlListView_GetItemText($hListView, $_row, 0))
						GUICtrlSetData($Input2, _GUICtrlListView_GetItemText($hListView, $_row, 1))
						GUICtrlSetData($Input3, _GUICtrlListView_GetItemText($hListView, $_row, 2))
						GUICtrlSetData($Input4, _GUICtrlListView_GetItemText($hListView, $_row, 3))
						GUICtrlSetData($Input5, _GUICtrlListView_GetItemText($hListView, $_row, 4))
						GUICtrlSetData($Input6, _GUICtrlListView_GetItemText($hListView, $_row, 5))
						GUICtrlSetData($Input7, _GUICtrlListView_GetItemText($hListView, $_row, 6))
						GUICtrlSetData($Input8, _GUICtrlListView_GetItemText($hListView, $_row, 7))
						GUICtrlSetData($Input9, _GUICtrlListView_GetItemText($hListView, $_row, 8))
						GUICtrlSetData($Input10, _GUICtrlListView_GetItemText($hListView, $_row, 9))
						GUICtrlSetData($Input11, _GUICtrlListView_GetItemText($hListView, $_row, 10))
						GUICtrlSetData($Input12, _GUICtrlListView_GetItemText($hListView, $_row, 11))
						GUICtrlSetData($Input13, _GUICtrlListView_GetItemText($hListView, $_row, 12))
						GUICtrlSetData($Input14, _GUICtrlListView_GetItemText($hListView, $_row, 13))
						GUICtrlSetData($Input15, _GUICtrlListView_GetItemText($hListView, $_row, 14))
						GUICtrlSetData($Input16, _GUICtrlListView_GetItemText($hListView, $_row, 15))
						GUICtrlSetData($Input17, _GUICtrlListView_GetItemText($hListView, $_row, 16))
						GUICtrlSetData($Input18, _GUICtrlListView_GetItemText($hListView, $_row, 17))
						GUICtrlSetData($Input19, _GUICtrlListView_GetItemText($hListView, $_row, 18))
						GUICtrlSetData($Input20, _GUICtrlListView_GetItemText($hListView, $_row, 19))
						GUICtrlSetData($Input21, _GUICtrlListView_GetItemText($hListView, $_row, 20))
						GUICtrlSetData($Input22, _GUICtrlListView_GetItemText($hListView, $_row, 21))
						GUICtrlSetData($Input23, _GUICtrlListView_GetItemText($hListView, $_row, 22))
						GUICtrlSetData($Input24, _GUICtrlListView_GetItemText($hListView, $_row, 23))
						GUICtrlSetData($Input25, _GUICtrlListView_GetItemText($hListView, $_row, 24))
						GUICtrlSetData($Input26, _GUICtrlListView_GetItemText($hListView, $_row, 25))
						GUICtrlSetData($Input27, _GUICtrlListView_GetItemText($hListView, $_row, 26))
						GUICtrlSetData($Input28, _GUICtrlListView_GetItemText($hListView, $_row, 27))
						GUICtrlSetData($Input29, _GUICtrlListView_GetItemText($hListView, $_row, 28))
					endif
			EndSelect
		WEnd
EndFunc

Func NewWin()
	$NewForm = GUICreate("Individual Records", 500, 350, -1, -1,Default, Default, WinGetHandle(AutoItWinGetTitle()))
	$NLabel1 =  GUICtrlCreateLabel("ID", 10, 10, 50)
	$NLabel2 =  GUICtrlCreateLabel("Last Name", 10, 30, 120)
	$NLabel3 =  GUICtrlCreateLabel("First Name", 10, 50, 120)
	$NLabel4 =  GUICtrlCreateLabel("Middle Initial", 10, 70, 120)
	$NLabel5 =  GUICtrlCreateLabel("Employee Number", 10, 90, 120)
	$NLabel6 =  GUICtrlCreateLabel("Hiring Date", 10, 110, 120)
	$NLabel7 =  GUICtrlCreateLabel("Permanency Date", 10, 130, 120)
	$NLabel8 =  GUICtrlCreateLabel("Unit Assigned", 10, 150, 120)
	$NLabel9 =  GUICtrlCreateLabel("Date Started", 10, 170, 120)
	$NLabel10 =  GUICtrlCreateLabel("Designation", 10, 190, 120)
	$NLabel11 =  GUICtrlCreateLabel("Rank / Job Level", 10, 210, 120)
	$NLabel12 =  GUICtrlCreateLabel("Date Last Promoted", 10, 230, 120)
	$NLabel13 =  GUICtrlCreateLabel("Work Schedule", 10, 250, 120)
	$NLabel14 =  GUICtrlCreateLabel("Previous Employer", 10, 270, 120)
	$NLabel15 =  GUICtrlCreateLabel("Division Dept.", 10, 290, 120)
	$NLabel16 =  GUICtrlCreateLabel("Position", 250, 30, 120)
	$NLabel17 =  GUICtrlCreateLabel("Inclusive Dates", 250, 50, 120)
	$NLabel18 =  GUICtrlCreateLabel("Birth Date", 250, 70, 120)
	$NLabel19 =  GUICtrlCreateLabel("Birth Place", 250, 90, 120)
	$NLabel20 =  GUICtrlCreateLabel("Gender", 250, 110, 120)
	$NLabel21 =  GUICtrlCreateLabel("Civil Status", 250, 130,120)
	$NLabel22 =  GUICtrlCreateLabel("Citizenship", 250, 150, 120)
	$NLabel23 =  GUICtrlCreateLabel("Religion", 250, 170, 120)
	$NLabel24 =  GUICtrlCreateLabel("Univ / School Graduated", 250, 190, 120)
	$NLabel25 =  GUICtrlCreateLabel("Degree / Course", 250, 210, 120)
	$NLabel26 =  GUICtrlCreateLabel("Valid ID Details", 250, 230, 120)
	$NLabel27 =  GUICtrlCreateLabel("Home Address", 250, 250, 120)
	$NLabel28 =  GUICtrlCreateLabel("Home Telephone", 250, 270, 120)
	$NLabel29 =  GUICtrlCreateLabel("Mobile Number", 250, 290, 120)
	$NInput1 = GUICtrlCreateInput("", 130, 10, 100, 18)
	$NInput2 = GUICtrlCreateInput("", 130, 30, 100, 18)
	$NInput3 = GUICtrlCreateInput("", 130, 50, 100, 18)
	$NInput4 = GUICtrlCreateInput("", 130, 70, 100, 18)
	$NInput5 = GUICtrlCreateInput("", 130, 90, 100, 18)
	$NInput6 = GUICtrlCreateInput("", 130, 110, 100, 18)
	$NInput7 = GUICtrlCreateInput("", 130, 130, 100, 18)
	$NInput8 = GUICtrlCreateInput("", 130, 150, 100, 18)
	$NInput9 = GUICtrlCreateInput("", 130, 170, 100, 18)
	$NInput10 = GUICtrlCreateInput("", 130, 190, 100, 18)
	$NInput11 = GUICtrlCreateInput("", 130, 210, 100, 18)
	$NInput12 = GUICtrlCreateInput("", 130, 230, 100, 18)
	$NInput13 = GUICtrlCreateInput("", 130, 250, 100, 18)
	$NInput14 = GUICtrlCreateInput("", 130, 270, 100, 18)
	$NInput15 = GUICtrlCreateInput("", 130, 290, 100, 18)
	$NInput16 = GUICtrlCreateInput("", 380, 30, 100, 18)
	$NInput17 = GUICtrlCreateInput("", 380, 50, 100, 18)
	$NInput18 = GUICtrlCreateInput("", 380, 70, 100, 18)
	$NInput19 = GUICtrlCreateInput("", 380, 90, 100, 18)
	$NInput20 = GUICtrlCreateInput("", 380, 110, 100, 18)
	$NInput21 = GUICtrlCreateInput("", 380, 130, 100, 18)
	$NInput22 = GUICtrlCreateInput("", 380, 150, 100, 18)
	$NInput23 = GUICtrlCreateInput("", 380, 170, 100, 18)
	$NInput24 = GUICtrlCreateInput("", 380, 190, 100, 18)
	$NInput25 = GUICtrlCreateInput("", 380, 210, 100, 18)
	$NInput26 = GUICtrlCreateInput("", 380, 230, 100, 18)
	$NInput27 = GUICtrlCreateInput("", 380, 250, 100, 18)
	$NInput28 = GUICtrlCreateInput("", 380, 270, 100, 18)
	$NInput29 = GUICtrlCreateInput("", 380, 290, 100, 18)
	$NButton4 = GUICtrlCreateButton("Save", 185, 320, 100)
	GUISetState(@SW_SHOW)
		While 1
			$_msg = GUIGetMsg(1)
			Select
				;Check if user clicked on a close button of any of the 2 windows
				Case $_msg[0] = $GUI_EVENT_CLOSE
					;Check if user clicked on the close button of the child window
					If $_msg[1] = $ViewForm Then
						GUICtrlSetState($View, $GUI_ENABLE)
						GUICtrlSetState($New, $GUI_ENABLE)
						;Switch to the child window
						GUISwitch($hGUI)
						;Destroy the child GUI including the controls
						GUIDelete($ViewForm)
						;Check if user clicked on the close button of the parent window
					ElseIf $_msg[1] = $hGUI Then
						;Switch to the parent window
						GUISwitch($hGUI)
						;Destroy the parent GUI including the controls
						GUIDelete()
						;Exit the script
						Exit
					ElseIf $_msg[1] = $NewForm Then
						GUICtrlSetState($View, $GUI_ENABLE)
						GUICtrlSetState($New, $GUI_ENABLE)
						;Switch to the child window
						GUISwitch($hGUI)
						;Destroy the child GUI including the controls
						GUIDelete($NewForm)
						;Check if user clicked on the close button of the parent window
					Endif
				Case $_msg[0] = $View
					GUICtrlSetState($View, $GUI_DISABLE)
					GUICtrlSetState($New, $GUI_DISABLE)
					EditWin()
				Case  $_msg[0] = $New
					GUICtrlSetState($View, $GUI_DISABLE)
					GUICtrlSetState($New, $GUI_DISABLE)
					NewWin()
				Case  $_msg[0] = $Del
					DeleteItem()					
				Case $_msg[0] = $NButton4
					_GUICtrlListView_AddItem($hListView, GUICtrlRead($NInput1), 0)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput2), 1)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput3), 2)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput4), 3)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput5), 4)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput6), 5)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput7), 6)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput8), 7)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput9), 8)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput10), 9)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput11), 10)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput12), 11)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput13), 12)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput14), 13)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput15), 14)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput16), 15)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput17), 16)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput18), 17)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput19), 18)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput20), 19)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput21), 20)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput22), 21)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput23), 22)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput24), 23)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput25), 24)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput26), 25)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput27), 26)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput28), 27)
					_GUICtrlListView_AddSubItem($hListView, $c, GUICtrlRead($NInput29), 28)
					$c = $c + 1
					
					$file = FileOpen("C:\Base\DBase.txt", 1)

					; Check if file opened for reading OK
					If $file = -1 Then
						MsgBox(0, "Error", "Error Saving The File!")
						Exit
					EndIf
					$_NewRec = GUICtrlRead($NInput1) & "^_^" & GUICtrlRead($NInput2) & "^_^" &  GUICtrlRead($NInput3) & "^_^" &  GUICtrlRead($NInput4) & "^_^" &  GUICtrlRead($NInput5) & "^_^" & _
					GUICtrlRead($NInput6) & "^_^" &  GUICtrlRead($NInput7) & "^_^" &  GUICtrlRead($NInput8) & "^_^" &  GUICtrlRead($NInput9) & "^_^" &  GUICtrlRead($NInput10) & "^_^" &  GUICtrlRead($NInput11) & "^_^" & _
					GUICtrlRead($NInput12) & "^_^" &  GUICtrlRead($NInput13) & "^_^" &  GUICtrlRead($NInput14) & "^_^" &  GUICtrlRead($NInput15) & "^_^" &  GUICtrlRead($NInput16) & "^_^" &  GUICtrlRead($NInput17) & "^_^" & _
					GUICtrlRead($NInput18) & "^_^" &  GUICtrlRead($NInput19) & "^_^" &  GUICtrlRead($NInput20) & "^_^" &  GUICtrlRead($NInput21) & "^_^" &  GUICtrlRead($NInput22) & "^_^" &  GUICtrlRead($NInput23) & "^_^" & _
					GUICtrlRead($NInput24) & "^_^" &  GUICtrlRead($NInput25) & "^_^" &  GUICtrlRead($NInput26) & "^_^" &  GUICtrlRead($NInput27) & "^_^" &  GUICtrlRead($NInput28) & "^_^" &  GUICtrlRead($NInput29)
					FileWriteLine($file, $_NewRec)
					FileClose($file)
					$Recordnumber = $Recordnumber + 1
					MsgBox(0,"Notice", "Sucessfuly Saved one Record")
					GUICtrlSetState($View, $GUI_ENABLE)
					GUICtrlSetState($New, $GUI_ENABLE)
					GUIDelete($NewForm)
			EndSelect
		Wend
EndFunc

Func Main()
; Add columns
$_Records = StringSplit($Records, @CrLF,1)
_GUICtrlListView_InsertColumn ($hListView,0,  "ID", 25)
_GUICtrlListView_InsertColumn ($hListView,1,  "Last Name", 100)
_GUICtrlListView_InsertColumn ($hListView,2,  "First Name", 100)
_GUICtrlListView_InsertColumn ($hListView,3,  "Middle Initial", 100)
_GUICtrlListView_InsertColumn ($hListView,4,  "Employee Number", 100)
_GUICtrlListView_InsertColumn ($hListView,5,  "Hiring Date", 100)
_GUICtrlListView_InsertColumn ($hListView,6,  "Permanency Date", 100)
_GUICtrlListView_InsertColumn ($hListView,7,  "Unit Assigned", 100)
_GUICtrlListView_InsertColumn ($hListView,8,  "Date Started", 100)
_GUICtrlListView_InsertColumn ($hListView,9,  "Designation", 100)
_GUICtrlListView_InsertColumn ($hListView,10,  "Rank / job Level", 100)
_GUICtrlListView_InsertColumn ($hListView,11,  "Date last Promoted", 100)
_GUICtrlListView_InsertColumn ($hListView,12,  "Work Schedule", 100)
_GUICtrlListView_InsertColumn ($hListView,13,  "Previous Employer", 100)
_GUICtrlListView_InsertColumn ($hListView,14,  "Division Dept.", 100)
_GUICtrlListView_InsertColumn ($hListView,15,  "Position", 100)
_GUICtrlListView_InsertColumn ($hListView,16,  "Inclusive Dates", 100)
_GUICtrlListView_InsertColumn ($hListView,17,  "Birth Date", 100)
_GUICtrlListView_InsertColumn ($hListView,18,  "Birth Place", 100)
_GUICtrlListView_InsertColumn ($hListView,19,  "Gender", 100)
_GUICtrlListView_InsertColumn ($hListView,20,  "Civil Status", 100)
_GUICtrlListView_InsertColumn ($hListView,21,  "Citizenship", 100)
_GUICtrlListView_InsertColumn ($hListView,22,  "Religion", 100)
_GUICtrlListView_InsertColumn ($hListView,23,  "Univ / School Grad", 100)
_GUICtrlListView_InsertColumn ($hListView,24,  "Degree / Course", 100)
_GUICtrlListView_InsertColumn ($hListView,25,  "Valid ID Details", 100)
_GUICtrlListView_InsertColumn ($hListView,26,  "Home Address", 100)
_GUICtrlListView_InsertColumn ($hListView,27,  "Home Telephone", 100)
_GUICtrlListView_InsertColumn ($hListView,28,  "Mobile Number", 100)
; Add items
	for $i = 1 to UBound($_Records) - 1
		if StringLen(StringReplace($_Records[$i]," ","")) = 0 Then ExitLoop
		$Fields = StringSplit($_Records[$i],"^_^",1)
		$ID = $Fields[1]
		$LName = $Fields[2]
		$FName = $Fields[3]
		$MName = $Fields[4]
		$ENumber = $Fields[5]
		$HDate = $Fields[6]
		$PDate = $Fields[7]
		$UnitAss = $Fields[8]
		$DateStart = $Fields[9]
		$Designation = $Fields[10]
		$Rank = $Fields[11]
		$DateLastProm = $Fields[12]
		$WorkSched = $Fields[13]
		$PrevEmpl = $Fields[14]
		$Dept = $Fields[15]
		$Position = $Fields[16]
		$InclusiveDates = $Fields[17]
		$BDate = $Fields[18]
		$BPlace = $Fields[19]
		$Gender = $Fields[20]
		$CivilStat = $Fields[21]
		$Citizenship = $Fields[22]
		$Religion = $Fields[23]
		$Univ = $Fields[24]
		$Degree = $Fields[25]
		$ValidID = $Fields[26]
		$HomeAdd = $Fields[27]
		$HomePhone = $Fields[28]
		$MobileNumber = $Fields[29]
		
		_GUICtrlListView_AddItem($hListView, $ID, $i - 1)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $LName, 1)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $FName, 2)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $MName, 3)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $ENumber, 4)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $HDate, 5)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $PDate, 6)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $UnitAss, 7)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $DateStart, 8)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $Designation, 9)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $Rank, 10)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $DateLastProm, 11)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $WorkSched, 12)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $PrevEmpl, 13)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $Dept, 14)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $Position, 15)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $InclusiveDates, 16)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $BDate, 17)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $BPlace, 18)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $Gender, 19)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $CivilStat, 20)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $Citizenship, 21)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $Religion, 22)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $Univ, 23)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $Degree, 24)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $ValidID, 25)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $HomeAdd, 26)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $HomePhone, 27)
		_GUICtrlListView_AddSubItem($hListView, $i - 1, $MobileNumber, 28)
		$c = $c + 1
		$Recordnumber = $Recordnumber + 1
	next
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOr($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
EndFunc

Func DeleteItem()
	$MsgDel = msgbox(32 + 4,"Delete Record","Do you want to Delete this record?")
	Global $NewFileContDel,$NewFileContDel2
	Switch $MsgDel
    Case 6; 6 value for button Yes
		_GUICtrlListView_DeleteItemsSelected($hListView)
		For $GDH = 0 to $Recordnumber - 1
			$NewFileContDel = $NewFileContDel & _GUICtrlListView_GetItemText($hListView, $GDH, 0) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 1) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 2) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 3) & "^_^" & _
			_GUICtrlListView_GetItemText($hListView, $GDH, 4) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 5) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 6) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 7) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 8) & "^_^" & _
			_GUICtrlListView_GetItemText($hListView, $GDH, 9) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 10) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 11) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 12) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 13) & "^_^" & _
			_GUICtrlListView_GetItemText($hListView, $GDH, 14) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 15) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 16) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 17) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 18) & "^_^" & _
			_GUICtrlListView_GetItemText($hListView, $GDH, 19) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 20) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 21) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 22) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 23) & "^_^" & _
			_GUICtrlListView_GetItemText($hListView, $GDH, 24) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 25) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 26) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 27) & "^_^" & _GUICtrlListView_GetItemText($hListView, $GDH, 28) & "|||"
			$NewFileContDel = StringReplace($NewFileContDel,"^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^^_^","")
		Next
		$remove = StringSplit($NewFileContDel,"|||",1)
		For $GDHR = 1 to UBound($remove)-1
			if StringLen($remove[$GDHR]) > 8 then
				$NewFileContDel2 = $NewFileContDel2 & $remove[$GDHR] & @CrLf
			Endif
		Next
		FileDelete("C:\Base\DBase.txt")
		sleep(50)
		$SDfile = FileOpen("C:\Base\DBase.txt", 10)
		; Check if file opened for reading OK
		If $SDfile = -1 Then
			MsgBox(0, "Error", "Error Deleting The File!")
			GUIDelete($ViewForm)
		EndIf
		FileWriteLine($SDfile, $NewFileContDel2)
		FileClose($SDfile)
		MsgBox(0,"Notice", "Sucessfuly Deleted one Record!")
		$NewFileContDel2 = ""
		$NewFileContDel = ""
    Case 7; 7 value for button No
        msgbox(0,"","yo")
	EndSwitch
EndFunc	