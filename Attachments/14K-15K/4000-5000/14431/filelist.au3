#include <GUIConstants.au3>
#include <File.au3>
#include <Array.au3>
$GUI = GUICreate("Files", 633, 474)
$ListView = GUICtrlCreateListView("Name|Size|Owner|Author|Date Modified|Date Created", 0, 30, 632, 424, BitOR($LVS_SINGLESEL, $LVS_ICON, $LVS_SHOWSELALWAYS, $WS_VSCROLL))
Dim $FileArray[1]
$FileArray[0] = 0
GUISetState()
$FileListArray = _FileListToArray(@SystemDir, "*.dll")
If Not @error Then
	For $i = 1 To $FileListArray[0]
		$file = $FileListArray[$i]
		If @error Then ExitLoop
		Local $filepath = @SystemDir & "\" & $file
		Local $author = _GetExtProperty($filepath, 9)
		If $author = "0" Then $author = ""
		_ArrayAdd($FileArray, GUICtrlCreateListViewItem($file & "|" & _GetExtProperty($filepath, 1) & _
				"|" & _GetExtProperty($filepath, 8) & "|" & $author & "|" & _
				_GetExtProperty($filepath, 3) & "|" & _GetExtProperty($filepath, 4), $ListView))
		$FileArray[0] += 1
	Next
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch

WEnd

;===============================================================================
; Function Name:	GetExtProperty($sPath,$iProp)
; Description:      Returns an extended property of a given file.
; Parameter(s):     $sPath - The path to the file you are attempting to retrieve an extended property from.
;                   $iProp - The numerical value for the property you want returned. If $iProp is is set
;							  to -1 then all properties will be returned in a 1 dimensional array in their corresponding order.
;							The properties are as follows:
;							Name = 0
;							Size = 1
;							Type = 2
;							DateModified = 3
;							DateCreated = 4
;							DateAccessed = 5
;							Attributes = 6
;							Status = 7
;							Owner = 8
;							Author = 9
;							Title = 10
;							Subject = 11
;							Category = 12
;							Pages = 13
;							Comments = 14
;							Copyright = 15
;							Artist = 16
;							AlbumTitle = 17
;							Year = 18
;							TrackNumber = 19
;							Genre = 20
;							Duration = 21
;							BitRate = 22
;							Protected = 23
;							CameraModel = 24
;							DatePictureTaken = 25
;							Dimensions = 26
;							Width = 27
;							Height = 28
;							Company = 30
;							Description = 31
;							FileVersion = 32
;							ProductName = 33
;							ProductVersion = 34
; Requirement(s):   File specified in $spath must exist.
; Return Value(s):  On Success - The extended file property, or if $iProp = -1 then an array with all properties
;                   On Failure - 0, @Error - 1 (If file does not exist)
; Author(s):        Simucal (Simucal@gmail.com)
; Note(s):
;
;===============================================================================
Func _GetExtProperty($sPath, $iProp)
	Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
	$iExist = FileExists($sPath)
	If $iExist = 0 Then
		SetError(1)
		Return 0
	Else
		$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
		$sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
		$oShellApp = ObjCreate("shell.application")
		$oDir = $oShellApp.NameSpace ($sDir)
		$oFile = $oDir.Parsename ($sFile)
		If $iProp = -1 Then
			Local $aProperty[35]
			For $i = 0 To 34
				$aProperty[$i] = $oDir.GetDetailsOf ($oFile, $i)
			Next
			Return $aProperty
		Else
			$sProperty = $oDir.GetDetailsOf ($oFile, $iProp)
			If $sProperty = "" Then
				Return 0
			Else
				Return $sProperty
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GetExtProperty
