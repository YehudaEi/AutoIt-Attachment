#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>
#Include <String.au3>

Global $ini = @ScriptDir & "\Generation_carte.ini"



_GuiEDITini()

Func _GuiEDITini()
	Local $w = 800,$h=600,$int = 3
	Global $hListView,$ArrayCrypt[10]
	Dim $array,$iS = 1,$iC = 0
	GUICreate("ListView Edit Label", $w,$h)
	$hListView = GUICtrlCreateListView("", $int, $int, $w-2*$int, $h-2*$int, BitOR($LVS_EDITLABELS, $LVS_REPORT))
	_GUICtrlListView_SetUnicodeFormat($hListView, False);Use ANSI
	GUISetState()

	; Add columns
	_GUICtrlListView_InsertColumn($hListView, 0, "Valeur",1200)
	_GUICtrlListView_InsertColumn($hListView, 1, "Paramètre",$w/2.7)
	_GUICtrlListView_SetColumnOrder($hListView, "1|0")
	_GUICtrlListView_SetColumnWidth($hListView,0,$LVSCW_AUTOSIZE_USEHEADER)
	_GUICtrlListView_SetColumnWidth($hListView,0,_GUICtrlListView_GetColumnWidth($hListView,0)-20)

    _GUICtrlListView_EnableGroupView($hListView)

	; Add items
	$Sections = IniReadSectionNames($ini)
	If IsArray($Sections) Then
		For $i = 1 to $Sections[0]
			_GUICtrlListView_InsertGroup($hListView, $iS, $iS, $Sections[$i])
			$array = IniReadSection ( $ini, $Sections[$i] )
			If IsArray($array) Then
				For $j = 1 to $array[0][0]
					_GUICtrlListView_AddItem($hListView, $array[$j][1])
					_GUICtrlListView_AddSubItem($hListView, $iC, $array[$j][0], 1)
					_GUICtrlListView_SetItemGroupID($hListView, $iC, $iS)
					If $Sections[$i] = "Crypt" Then
						Redim $ArrayCrypt[$array[0][0]]
						$ArrayCrypt[$j-1] = $iC
					EndIf
					$iC+=1
				Next
				$iS += 1
			Else
				MsgBox(0,"","Erreur de lecture  des parametres")
				Return 0
			EndIf
		Next
	Else
		MsgBox(0,"","Erreur de lecture  du fichier de configuration")
		Return 0
	EndIf



	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	Do
		sleep(20)
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
	Return 1
EndFunc   ;==>_Main


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg, $iwParam
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
    $hWndListView = $hListView
    If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hWndListView
            Switch $iCode
                Case $LVN_BEGINLABELEDITA, $LVN_BEGINLABELEDITW ; Start of label editing for an item
                    $tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
					$id = _ArraySearch($ArrayCrypt,Int(DllStructGetData($tInfo, "Item")))
					If $id <> -1 Then
						$rep = InputBox("","Ce champ est crypté. Veuillez donner la nouvelle valeur ci-dessous.",_StringEncrypt(0,_GUICtrlListView_GetItemText($hListView,Int(DllStructGetData($tInfo, "Item"))), "12*/#Max987²", 2))
						;_ArrayDelete($ArrayCrypt,$id)
						If $rep <> "" Then _GUICtrlListView_SetItemText($hListView,Int(DllStructGetData($tInfo, "Item")),_StringEncrypt(1,$rep, "12*/#Max987²", 2))
						_GUICtrlListView_CancelEditLabel($hListView)
					EndIf
					Return False
				Case $LVN_ENDLABELEDITA, $LVN_ENDLABELEDITW ; The end of label editing for an item
                    $tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
                    Local $tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
                    If StringLen(DllStructGetData($tBuffer, "Text")) Then
						$a = _GUICtrlListView_GetGroupInfo($hWndListView,_GUICtrlListView_GetItemGroupID($hWndListView,Int(DllStructGetData($tInfo, "Item"))))
						$b = _GUICtrlListView_GetItemText($hWndListView,Int(DllStructGetData($tInfo, "Item")),1)
						;IniWrite($ini,$a[0],,DllStructGetData($tBuffer, "Text"))
						;
						ToolTip($b)
						Return True
					EndIf
				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
                    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_GUICtrlListView_EditLabel($hListView,Int(DllStructGetData($tInfo, "Index")))
					$id = _ArraySearch($ArrayCrypt,Int(DllStructGetData($tInfo, "Index")))
					If $id <> -1 Then
						$rep = InputBox("","Ce champ est crypté. Veuillez donner la nouvelle valeur ci-dessous.",_StringEncrypt(0,_GUICtrlListView_GetItemText($hListView,Int(DllStructGetData($tInfo, "Index"))), "12*/#Max987²", 2))
						If $rep <> "" Then _GUICtrlListView_SetItemText($hListView,Int(DllStructGetData($tInfo, "Index")),_StringEncrypt(1,$rep, "12*/#Max987²", 2))
						_GUICtrlListView_CancelEditLabel($hListView)
					EndIf
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
