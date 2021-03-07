#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <GuiEdit.au3>

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <ListViewConstants.au3>

#include "File_sequence.au3"

Opt("GUIOnEventMode", 1)

;Gui;
Global $GUI = GUICreate("File Sequence Manager", 1479, 801, -1, -1)
GUISetFont(7, 400, 0, "MS Sans Serif")
Global $GUI_LV = GUICtrlCreateListView("#|Sequence Name|Range|Length|Exists|Total Size|Img Dimensions|Parent Folder|RegExp Folder|Wildcard Name", 8, 40, 1457, 673, BitOR($LVS_REPORT,$LVS_SHOWSELALWAYS))
Global $GUI_LOG = GUICtrlCreateEdit("", 8, 720, 1457, 73)
Global $GUI_INP_PATH = GUICtrlCreateInput("", 8, 8, 689, 21)
Global $GUI_BTN_BROWSE = GUICtrlCreateButton("Browse", 704, 8, 65, 25)
Global $GUI_BTN_REFRESH = GUICtrlCreateButton("Refresh", 1256, 8, 209, 25)
Global $GUI_CMB_FILTER = GUICtrlCreateCombo("", 776, 8, 321, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
Global $GUI_CHB_RECURSIVE = GUICtrlCreateCheckbox("Scan Subfolders", 1104, 8, 137, 25)
GUICtrlSetState($GUI_CHB_RECURSIVE, $GUI_CHECKED)
Global $FILTER_ALL = "All Images"
GUICtrlSetData($GUI_CMB_FILTER, $FILTER_ALL & "|mov|avi|png|jpg|exr|dpx|tga|bmp|cin|tif|gif|sgi|rla|rpf|tiff", $FILTER_ALL)

;on event
GUISetOnEvent($GUI_EVENT_CLOSE, "MyExit")
GUISetOnEvent($GUI_EVENT_DROPPED, "MyDrop")
GUICtrlSetState($GUI_LV, $GUI_DROPACCEPTED)
GUICtrlSetOnEvent($GUI_BTN_REFRESH, "FS_Refresh")
GUICtrlSetOnEvent($GUI_BTN_BROWSE, "FS_Browse")

;Menu
Global $Menu = GUICtrlCreateContextMenu($GUI_LV)
GUICtrlCreateMenuItem("Reveal in explorer", $Menu)
GUICtrlSetOnEvent(-1, "FS_Reveal")
GUISetState()

;loop
While 1
	Sleep(250)
WEnd

Func FS_Add_Items($hWnd, $sPath, $sExt)
	Local $iTotalSize = 0
	Local $iTotalLength = 0
	Local $iTimer = TimerInit()

	GUICtrlCreateListViewItem("|Gathering information : " & $sPath, $hWnd)
	MyConsole("+Gathering information")

	_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hWnd), 1, $LVSCW_AUTOSIZE)

	Local $bRecursive = True
	If GUICtrlRead($GUI_CHB_RECURSIVE) = $GUI_UNCHECKED Then $bRecursive = False
	Local $aFileSequences = _FileSequence_Find($sPath, $bRecursive, $sExt)

	If Not @error Then
		MyConsole("+" & $aFileSequences[0] & " sequences found " & Round(TimerDiff($iTimer) / 1000, 3) & " s.")

		_ArraySort($aFileSequences, 0, 1, $aFileSequences[0])
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hWnd))

		If IsArray($aFileSequences) And $aFileSequences[0] > 0 Then
			For $i = 1 To $aFileSequences[0]
				Local $Seq_Name = $aFileSequences[$i]
				Local $Seq_Range = -1
				Local $Seq_Length = -1
				Local $Seq_Exists = "False"
				Local $Seq_Size = -1
				Local $Seq_ParentFolder = ""
				Local $Seq_RegExp = "Error"
				Local $Seq_Wildcard = "Error"
				Local $Seq_ImgDimensions = "-"

				;_FileSequence_Exists returns True if the given path
				;is a valid image sequence:
				If _FileSequence_Exists($aFileSequences[$i]) Then
					$Seq_Exists = "True"
				EndIf

				;_FileSequence_GetRange returns a 1D array, where [0] is first file number
				;and [1] is the last file number:
				Local $aFrame_Range = _FileSequence_GetRange($aFileSequences[$i])
				If Not @error Then
					$Seq_Range = $aFrame_Range[0] & "-" & $aFrame_Range[1]
					$Seq_Length = $aFrame_Range[1] - $aFrame_Range[0] + 1
					$iTotalLength += $Seq_Length
				EndIf

				;_FileSequence_FSToRegExp is used to convert #### file numbering
				;symbol to stringformat %04d. some programs use different kind of
				;file numbering symbols:
				Local $Ret = _FileSequence_FSToRegExp($aFileSequences[$i])
				If Not @error Then
					$Seq_RegExp = $Ret
				EndIf

				;_FileSequence_FSToWildcard is used to convert #### file numbering
				;symbol to wildcard ****. useful with filecopy, filefindfirtsfile etc...
				Local $Ret = _FileSequence_FSToWildcard($aFileSequences[$i])
				If Not @error Then
					$Seq_Wildcard = $Ret
				EndIf

				;_FileSequence_GetImageDimensions always returns an array.
				;If @error then the array is -1 -1
				;It works only for bitmat images supported by GDIPlus (I think only <=8bit images)
				;For other file formats I recommend using FreeImage
				;from Floris van den Berg and Hervé Drolon
				Local $Ret = _FileSequence_GetImageDimensions($aFileSequences[$i])
				If Not @error Then
					$Seq_ImgDimensions = $Ret[0] & "*" & $Ret[1]
				EndIf

				;_FileSequence_GetSize returns the total size in bytes of the
				;whole file sequence:
				$Seq_Size = _FileSequence_GetSize($aFileSequences[$i]) / 1048576
				$iTotalSize += $Seq_Size
				If $Seq_Size >= 1000 Then
					$Seq_Size = Round($Seq_Size / 1000, 1) & " GB"
				Else
					$Seq_Size = Round($Seq_Size, 1) & " MB"
				EndIf

				;_FileSequence_GetParentFolder returns the parent folder of the
				;given filesequence:
				$Seq_ParentFolder = _FileSequence_GetParentFolder($aFileSequences[$i])

				GUICtrlCreateListViewItem($i & "|" & $Seq_Name & "|" & $Seq_Range & "|" & $Seq_Length & "|" & $Seq_Exists & "|" & $Seq_Size & "|" & $Seq_ImgDimensions & "|" & $Seq_ParentFolder & "|" & $Seq_RegExp & "|" & $Seq_Wildcard, $hWnd)
				_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hWnd), 0, $LVSCW_AUTOSIZE)
				_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hWnd), 1, $LVSCW_AUTOSIZE)
				_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hWnd), 7, $LVSCW_AUTOSIZE)
				_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hWnd), 8, $LVSCW_AUTOSIZE)
				_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hWnd), 9, $LVSCW_AUTOSIZE)

			Next

			;Writes additional information in the column names:
			If $iTotalSize > 1000 Then
				$iTotalSize = Round($iTotalSize / 1000, 1) & " GB"
			Else
				$iTotalSize = Round($iTotalSize, 1) & " MB"
			EndIf
			_GUICtrlListView_SetColumn(GUICtrlGetHandle($hWnd), 5, "Total Size = " & $iTotalSize)
			_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hWnd), 5, $LVSCW_AUTOSIZE_USEHEADER)
			_GUICtrlListView_SetColumn(GUICtrlGetHandle($hWnd), 3, "Total Length = " & $iTotalLength)
			_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hWnd), 3, $LVSCW_AUTOSIZE_USEHEADER)


			MyConsole("+Finish Getting Informations " & Round(TimerDiff($iTimer) / 1000, 3) & " s.")

		Else
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hWnd))
			GUICtrlCreateListViewItem("|No sequence found!", $hWnd)
			_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hWnd), 1, $LVSCW_AUTOSIZE)
		EndIf
	EndIf
EndFunc   ;==>FS_Add_Items

Func FS_Refresh()
	Local $sPath = GUICtrlRead($GUI_INP_PATH)
	Local $sFilter = GUICtrlRead($GUI_CMB_FILTER)
	If $sFilter = $FILTER_ALL Then $sFilter = Default
	If Not $sPath Or (Not FileExists($sPath)) Then Return MsgBox(0, "error", "No path specified or path doesn't exist")
	FS_Add_Items($GUI_LV, $sPath, $sFilter)
EndFunc   ;==>FS_Refresh

Func FS_Browse()
	Local $sInitialDir = GUICtrlRead($GUI_INP_PATH)
	Local $sPath = FileSelectFolder("Choose the folder you want to see the sequences", "", 4 + 2 + 1, $sInitialDir, $GUI)
	If @error Then Return
	GUICtrlSetData($GUI_INP_PATH, $sPath)
EndFunc   ;==>FS_Browse

Func FS_Reveal()
	Local $LV_Item_Selected = _GUICtrlListView_GetSelectedIndices(GUICtrlGetHandle($GUI_LV), False)
	MyConsole("+ Opening in Explorer = " & $LV_Item_Selected)
	Return Run("Explorer.exe " & _GUICtrlListView_GetItemText(GUICtrlGetHandle($GUI_LV), $LV_Item_Selected, 6))
EndFunc   ;==>FS_Reveal

Func MyDrop()
	ConsoleWrite(@GUI_DragFile & @CRLF)
	FS_Add_Items($GUI_LV, @GUI_DragFile, Default)
EndFunc   ;==>MyDrop

Func MyExit()
	GUISetState(@SW_LOCK)
	GUICtrlDelete($GUI_LV)
	GUIDelete($GUI)
	GUISetState(@SW_UNLOCK)
	Exit
EndFunc   ;==>MyExit

Func MyConsole($sMsg)
	_GUICtrlEdit_AppendText(GUICtrlGetHandle($GUI_LOG), $sMsg & @CRLF)
	ConsoleWrite($sMsg & @CRLF)
EndFunc   ;==>MyConsole