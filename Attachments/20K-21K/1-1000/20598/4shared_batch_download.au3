#Region converted Directives from E:\Meus documentos\Beta_tests\4shared Batch Download\4shared batch download.au3.ini
#AutoIt3Wrapper_icon=D:\Meus documentos\Beta_tests\4shared Batch Download\web_down.ico
#AutoIt3Wrapper_outfile=D:\Meus documentos\Beta_tests\4shared Batch Download\4shared_batch_download.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Made with AutoIt
#AutoIt3Wrapper_Res_Description=4Shared Batch Download
#AutoIt3Wrapper_Res_Fileversion=0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Res_LegalCopyright=2008 - tester001
#AutoIt3Wrapper_Run_AU3Check=4
#EndRegion converted Directives from E:\Meus documentos\Beta_tests\4shared Batch Download\4shared batch download.au3.ini
;
#include <GuiConstantsEx.au3>
#include <StaticConstants.au3>
#include <GuiListView.au3>
#include <IE.au3>

Opt ("WinTitleMatchMode", 2)

$oExplorer = _IECreate ()

$hGUI = GUICreate ("4Shared Batch Download", 500, 415, 0, 0)
$hList = GUICtrlCreateListView ("", 10, 10, 480, 300)
$hLoadListBtn = GUICtrlCreateButton ("Load download list from file", 300, 310, 190, 20)

$hProgressLabel = GUICtrlCreateLabel ("0/0", 10, 340, 60, 15, $SS_CENTER)
$hTotalProgress = GUICtrlCreateProgress (70, 340, 415, 15)
$hStartBtn = GUICtrlCreateButton ("Start", 70, 370, 360, 30)

GUICtrlSendMsg ($hList, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
_GUICtrlListView_InsertColumn ($hList, 0, "URL", 200)
_GUICtrlListView_InsertColumn ($hList, 1, "Folder", 200)
_GUICtrlListView_InsertColumn ($hList, 2, "Status", 75)

Opt ("GUIOnEventMode", 1)
GUISetOnEvent ($GUI_EVENT_CLOSE, "DlgProc")
GUICtrlSetOnEvent ($hLoadListBtn, "DlgProc")
GUICtrlSetOnEvent ($hStartBtn, "DlgProc")

GUISetState ()

While (True)
	Sleep (60000)
WEnd

Func DlgProc ()
	Switch (@GUI_CtrlId)
		Case $GUI_EVENT_CLOSE
			Exit

		Case $hLoadListBtn
			LoadList ()

		Case $hStartBtn
			DoTheDownloads ()
	EndSwitch
EndFunc


Func LoadList ()
	Local $szFile = FileOpenDialog ("Load downloads list from file", @WorkingDir, _
		"Downloads list (*.txt;*.csv)|All files (*.*)", 1)

	If (Not @error) Then
		Local $szList = StringRegExpReplace (FileRead ($szFile), "[;\t|,]", '|')
		Local $szArray = StringSplit ($szList, @CRLF, 1)

		_GUICtrlListView_DeleteAllItems ($hList)
		For $i = 1 To $szArray[0]
			Local $szTest = StringRegExpReplace ($szArray[$i], "[;\t|,]", "")
			If ($szTest <> "") Then
				$szColumns = StringSplit ($szArray[$i], '|', 1)
				If ((IsArray ($szColumns)) And ($szColumns[0] > 1)) Then
					$iIndex = _GUICtrlListView_InsertItem ($hList, $szColumns[1], -1)
					_GUICtrlListView_SetItemText ($hList, $iIndex, $szColumns[2], 1)
				EndIf
			EndIf
		Next
	EndIf
EndFunc


Func DoTheDownloads ()
	Local $iTotalDownloads = _GUICtrlListView_GetItemCount ($hList)
	If ($iTotalDownloads == 0) Then
		MsgBox (16, "4Shared Batch Download", "The downloads list is empty.")
		Return False
	EndIf

	GUICtrlSetData ($hTotalProgress, 0)
	GUICtrlSetState ($hLoadListBtn, $GUI_DISABLE)
	GUICtrlSetState ($hStartBtn, $GUI_DISABLE)

	;; Clean the status column ;;
	For $i = 0 To $iTotalDownloads - 1
		_GUICtrlListView_SetItemText ($hList, $i, "", 2)
	Next

	Local $iTotalSucceeded = 0
	For $i = 0 To $iTotalDownloads - 1
		;; Get the current proxy address from the list ;;
		Local $szUrl = _GUICtrlListView_GetItemText ($hList, $i, 0)
		Local $szDir = _GUICtrlListView_GetItemText ($hList, $i, 1)

		;; Download the file ;;
		_GUICtrlListView_SetItemText ($hList, $i, "Downloading", 2)
		Local $szFile = Download4SharedFile ($szUrl, $szDir)
		If (@error) Then
			Local $szStatus = "Error " & @error
		Else
			$iTotalSucceeded += 1
			Local $szStatus = "OK"
		EndIf
		_GUICtrlListView_SetItemText ($hList, $i, $szStatus, 2)
		LogFileDownloaded ($i, $szUrl, $szDir, $szFile, $szStatus)

		GUICtrlSetData ($hProgressLabel, ($i + 1) & '/' & $iTotalDownloads)
		GUICtrlSetData ($hTotalProgress, (($i + 1) * 100) / $iTotalDownloads)
	Next

	MsgBox (64, "4Shared Batch Download", $iTotalSucceeded & " of " & $iTotalDownloads & @CRLF & _
		"succeeded downloads.")

	GUICtrlSetState ($hLoadListBtn, $GUI_ENABLE)
	GUICtrlSetState ($hStartBtn, $GUI_ENABLE)
EndFunc


Func Download4SharedFile ($szUrl, $szDir)
	$szFileDownloadWnd = "[TITLE:File Download; CLASS:#32770]"
	$szSaveAsWnd = "[TITLE:Save As; CLASS:#32770]"
	$szDownloadCompleteWnd = "[TITLE:Download complete; CLASS:#32770]"

	;; Navigate to the download page ;;
	_IENavigate ($oExplorer, $szUrl)
	If (@error) Then
		SetError (1)
		Return False
	EndIf
	$szUrl = StringReplace ($szUrl, "/file/", "/get/")
	_IENavigate ($oExplorer, $szUrl)
	If (@error) Then
		SetError (2)
		Return False
	EndIf

	;; Wait until the download link appears ;;
	$divDLStart = $oExplorer.document.getElementById ("divDLStart")
	If (Not IsObj ($divDLStart)) Then
		SetError (3)
		Return False
	EndIf
	$iTimer = TimerInit ()
	While (($divDLStart.style.display = "none") And (TimerDiff ($iTimer) < 120000))
		Sleep (100)
	WEnd

	;; Click the download link ;;
	$oAElements = $divDLStart.getElementsByTagName ("a")
	If ((Not IsObj ($oAElements)) Or ($oAElements.length < 1)) Then
		SetError (4)
		Return False
	EndIf
	$oDownloadLink = $divDLStart.getElementsByTagName ("a").item (0)
	_IENavigate ($oExplorer, $oDownloadLink, 0)

	;; Click save on the download file dialog ;;
	If (Not WinWait ($szFileDownloadWnd, "", 60)) Then
		SetError (5)
		Return False
	EndIf
	BlockInput (1)
	WinActivate ($szFileDownloadWnd)
	If (Not WinWaitActive ($szFileDownloadWnd, "", 15)) Then
		SetError (6)
		BlockInput (0)
		Return False
	EndIf
	Send ("s")
	BlockInput (0)

	;; Tell the dialog to save the file to the correct folder ;;
	If (Not WinWait ($szSaveAsWnd, "", 15)) Then
		SetError (7)
		Return False
	EndIf
	Local $szFileName = ControlGetText ($szSaveAsWnd, "", 1148)
	ControlSetText ($szSaveAsWnd, "", 1148, $szDir & '\' & $szFileName)
	BlockInput (1)
	WinActivate ($szSaveAsWnd)
	If (Not WinWaitActive ($szSaveAsWnd, "", 15)) Then
		SetError (8)
		BlockInput (0)
		Return False
	EndIf
	Send ("{ENTER}")
	BlockInput (0)

	;; Replace dialog maybe? ;;
	$szReplaceText = "Do you want to replace it?"
	WinWait ($szSaveAsWnd, $szReplaceText, 5)
	If (WinExists ($szSaveAsWnd, $szReplaceText)) Then
		ControlClick ($szSaveAsWnd, $szReplaceText, 6)
	ElseIf (WinExists ($szSaveAsWnd)) Then
		SetError (9)
		Return False
	EndIf

	;; Wait until the download is over ;;
	While (True)
		If (Not WinExists ("[CLASS:#32770]", $szFileName)) Then ExitLoop
		If (WinExists ($szDownloadCompleteWnd, $szFileName)) Then
			WinClose ($szDownloadCompleteWnd, $szFileName)
		EndIf
		Sleep (100)
	WEnd
	Return $szFileName
EndFunc


Func LogFileDownloaded ($szIndex, $szUrl, $szDir, $szFile, $szStatus)
	$szLogFile = @WorkingDir & "\Logs\" & @YEAR & @MON & @MDAY & ".txt"

	$hFile = FileOpen ($szLogFile, 1 + 8)
	FileWriteLine ($hFile, '[' & @HOUR & ':' & @MIN & ':' & @SEC & ']')
	FileWriteLine ($hFile, "File: " & $szFile)
	FileWriteLine ($hFile, "Status: " & $szStatus)
	FileWriteLine ($hFile, "Url: " & $szUrl)
	FileWriteLine ($hFile, "Saved to: " & $szDir)
	FileWrite ($hFile, @CRLF)
	FileClose ($hFile)
EndFunc