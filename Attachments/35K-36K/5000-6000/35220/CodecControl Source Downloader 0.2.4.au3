#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
;~ #AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Alexander Samuelsson (AdmiralAlkex)

 Script Function:
	Download the source to CodecControl

 Uses the following UDF's
;~ 	http://www.autoitscript.com/forum/topic/116565-zipau3-udf/

#ce ----------------------------------------------------------------------------

#include <IE.au3>
#include <Array.au3>
#include <File.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListviewConstants.au3>
#Include <GuiListView.au3>
#include <GuiImageList.au3>
#Include <Crypt.au3>

Global Const $sRepository = "http://dl.dropbox.com/u/18344147/SourceDownloader"

$oIE = _IECreate("http://hem.passagen.se/amax/CodecControl/index.html", 0, 0, 1, 0)
_IEQuit($oIE)

FileDelete(@ScriptDir & "\FileHashes.txt")
Local $hDownload = InetGet($sRepository & "/FileHashes.txt", @ScriptDir & "\FileHashes.txt", 1)

Global $asFileList
_FileReadToArray(@ScriptDir & "\FileHashes.txt", $asFileList)

$hWnd = GUICreate(StringTrimRight(@ScriptName, 4), 640, 480)

GUICtrlCreateLabel("Red = 1 or more files missing, Yellow = 1 or more files with wrong checksum, Green = fully identical to online version", 10, 10, 620, 40)

$hListview = GUICtrlCreateListView("Scripts|Files missing|Files with wrong checksum|Files with right checksum|Files total", 10, 60, 620, 360, $GUI_SS_DEFAULT_LISTVIEW, BitOR($LVS_EX_GRIDLINES, $LVS_EX_CHECKBOXES, $LVS_EX_DOUBLEBUFFER))

$hImage = _GUIImageList_Create()
_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0xFF0000, 16, 16))
_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0xFFFF00, 16, 16))
_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0x00FF00, 16, 16))
_GUICtrlListView_SetImageList($hListView, $hImage, 1)

Local $sCrypt, $iFilesTotal = 0, $iFilesMissing = 0, $iFilesBadHash = 0, $iFilesRightHash = 0

_GUICtrlListView_AddItem($hListView, $asFileList[1])

For $iX = 2 To $asFileList[0]
	If StringLeft($asFileList[$iX], 1) = "\" Then   ;Filename
		$iFilesTotal += 1
		Switch _Crypt_HashFile(@ScriptDir & $asFileList[$iX], $CALG_MD5)
			Case -1   ;File missing
				$iFilesMissing +=1
			Case $asFileList[$iX +1]   ;File exist with RIGHT checksum
				$iFilesRightHash += 1
			Case Else   ;File exist with WRONG checksum
				$iFilesBadHash += 1
		EndSwitch
	ElseIf StringLeft($asFileList[$iX], 2) = "0x" Then   ;MD5 checksum
		ContinueLoop
	Else   ;Next folder
		If $iFilesMissing > 0 Then
			_GUICtrlListView_SetItemImage($hListview, _GUICtrlListView_GetItemCount($hListview) -1, 0)
		ElseIf $iFilesBadHash > 0 Then
			_GUICtrlListView_SetItemImage($hListview, _GUICtrlListView_GetItemCount($hListview) -1, 1)
		ElseIf $iFilesRightHash = $iFilesTotal Then
			_GUICtrlListView_SetItemImage($hListview, _GUICtrlListView_GetItemCount($hListview) -1, 2)
		EndIf
		_GUICtrlListView_AddSubItem($hListview, _GUICtrlListView_GetItemCount($hListview) -1, $iFilesMissing, 1)
		_GUICtrlListView_AddSubItem($hListview, _GUICtrlListView_GetItemCount($hListview) -1, $iFilesBadHash, 2)
		_GUICtrlListView_AddSubItem($hListview, _GUICtrlListView_GetItemCount($hListview) -1, $iFilesRightHash, 3)
		_GUICtrlListView_AddSubItem($hListview, _GUICtrlListView_GetItemCount($hListview) -1, $iFilesTotal, 4)
		Local $iFilesTotal = 0, $iFilesMissing = 0, $iFilesBadHash = 0, $iFilesRightHash = 0
		_GUICtrlListView_AddItem($hListView, $asFileList[$iX])
	EndIf
Next
If $iFilesMissing > 0 Then
	_GUICtrlListView_SetItemImage($hListview, _GUICtrlListView_GetItemCount($hListview) -1, 0)
ElseIf $iFilesBadHash > 0 Then
	_GUICtrlListView_SetItemImage($hListview, _GUICtrlListView_GetItemCount($hListview) -1, 1)
ElseIf $iFilesRightHash = $iFilesTotal Then
	_GUICtrlListView_SetItemImage($hListview, _GUICtrlListView_GetItemCount($hListview) -1, 2)
EndIf
_GUICtrlListView_AddSubItem($hListview, _GUICtrlListView_GetItemCount($hListview) -1, $iFilesMissing, 1)
_GUICtrlListView_AddSubItem($hListview, _GUICtrlListView_GetItemCount($hListview) -1, $iFilesBadHash, 2)
_GUICtrlListView_AddSubItem($hListview, _GUICtrlListView_GetItemCount($hListview) -1, $iFilesRightHash, 3)
_GUICtrlListView_AddSubItem($hListview, _GUICtrlListView_GetItemCount($hListview) -1, $iFilesTotal, 4)

_GUICtrlListView_SetColumnWidth($hListview, 0, $LVSCW_AUTOSIZE)
_GUICtrlListView_SetColumnWidth($hListview, 1, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListView_SetColumnWidth($hListview, 2, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListView_SetColumnWidth($hListview, 3, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListView_SetColumnWidth($hListview, 4, $LVSCW_AUTOSIZE_USEHEADER)

$hInstall = GUICtrlCreateButton("Install selected scripts", 10, 430, 200, 40)
$hHash = GUICtrlCreateCheckbox("Redownload files with wrong checksum", 220, 430, 200, 20)
$hSciTE = GUICtrlCreateCheckbox("Launch downloaded scripts in SciTE", 220, 450, 200, 20)
$hExit = GUICtrlCreateButton("Exit", 420, 430, 200, 40)
GUISetState()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $hExit
			GUIDelete()
			Exit
		Case $hInstall
			Local $iReDownloadBadHashes = BitAnd(GUICtrlRead($hHash), $GUI_CHECKED);, $iRunSciTEAfterDownload = BitAnd(GUICtrlRead($hSciTE), $GUI_CHECKED)
			For $iX = 0 To _GUICtrlListView_GetItemCount($hListview) -1
				If _GUICtrlListView_GetItemChecked($hListview, $iX) Then
					Local $sItemText = _GUICtrlListView_GetItemText($hListview, $iX)
					For $iY = $iX To $asFileList[0]
						If $asFileList[$iY] = $sItemText Then
							For $iZ = $iY +1 To $asFileList[0]
								If StringLeft($asFileList[$iZ], 1) = "\" Then
									Switch _Crypt_HashFile(@ScriptDir & $asFileList[$iZ], $CALG_MD5)
										Case -1   ;File missing
											ConsoleWrite("Missing file:" & $asFileList[$iZ] & @CRLF)
											_Download(@ScriptDir, $asFileList[$iZ])
										Case $asFileList[$iZ +1]   ;File exist with RIGHT checksum
											ConsoleWrite("Right checksum:" & $asFileList[$iZ] & @CRLF)
											ContinueLoop
										Case Else   ;File exist with WRONG checksum
											ConsoleWrite("Wrong checksum:" & $asFileList[$iZ] & @CRLF)
											If $iReDownloadBadHashes Then _Download(@ScriptDir, $asFileList[$iZ])
									EndSwitch
								ElseIf StringLeft($asFileList[$iZ], 2) = "0x" Then
									ContinueLoop
								Else
									ContinueLoop 3
								EndIf
							Next
						EndIf
					Next
				EndIf
			Next
			If @Compiled Then
				Run(@AutoItExe)
			Else
				Run('"' & @AutoItExe & '" /AutoIt3ExecuteScript "' & @ScriptFullPath & '"')
			EndIf
			Exit
	EndSwitch
WEnd

Func _Download($sPathBeginning, $sPathEnd)
	Static Local $sAutoItStr = "HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt"
	If @AutoItX64 Then $sAutoItStr = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\AutoIt v3\AutoIt"
	Static Local $sAutoItReg = RegRead($sAutoItStr, "InstallDir") & "\SciTE\SciTE.exe"

	Static Local $sAutoItReg2 = RegRead("HKEY_CLASSES_ROOT\AutoIt3Script\Shell\Edit\Command", "")

	Local $szDrive, $szDir, $szFName, $szExt
	_PathSplit($sPathBeginning & $sPathEnd, $szDrive, $szDir, $szFName, $szExt)

	DirCreate($szDrive & $szDir)
	$iInet = InetGet($sRepository & StringReplace($sPathEnd, "\", "/"), $sPathBeginning & $sPathEnd, 1)   ;Wait until the download is finished

	If @error Then
		ConsoleWrite("Download failed: " & $sRepository & StringReplace($sPathEnd, "\", "/") & @CRLF)
	Else
		ConsoleWrite("Download succeeded: " & $sRepository & StringReplace($sPathEnd, "\", "/") & @CRLF)
		If $szExt <> ".au3" Then Return
		If StringInStr($szDir, $szFName) And BitAnd(GUICtrlRead($hSciTE), $GUI_CHECKED) Then
			Run('"' & $sAutoItReg & '" "' & $sPathBeginning & $sPathEnd & '"')   ;Do we want to run SciTE
;~ 			Run(StringReplace($sAutoItReg2, "%1", $sPathBeginning & $sPathEnd))   ;or run the default app for Edit action on .au3 files?
		EndIf
	EndIf
EndFunc