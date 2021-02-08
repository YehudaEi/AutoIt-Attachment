#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
$OSbit = @OSArch
$OS = @OSVersion
$Form1 = GUICreate("",200,500)
$edit = GUICtrlCreateEdit ("",0,0,200,480)
$button = GUICtrlCreateButton ("search",0,480,200,20)

$path = FileOpenDialog("Find File", @ScriptDir & "\", "All Files (*.*)",1+2)
If $path = "" Then
MsgBox(48,'ERROR',"You need to open file. Exiting now...")
Exit
Else
EndIf
GUISetState(@SW_SHOW)
While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
       Case $GUI_EVENT_CLOSE
           Exit
	Case $button
For $i = 1 To 500
$prop = _GetExtProperty($path,$i)
;Server 2003
If $OS = "WIN_2003" And $prop > "0" Then
	GUICtrlSetData ($edit, "Windows Server 2003 #" & $i & "=" & $prop & @CRLF,"Input")
ElseIf $OS = "WIN_2003" And $prop = "0" Then
	GUICtrlSetData ($edit, "","input")
;XP
ElseIf $OS = "WIN_XP" And $OSbit = "X86" And $prop > "0" Then
	GUICtrlSetData ($edit, "Windows XP 32bit #" & $i & "=" & $prop & @CRLF,"Input")
ElseIf $OS = "WIN_XP" And $OSbit = "X86" And $prop = "0" Then
	GUICtrlSetData ($edit, "","input")
ElseIf $OS = "WIN_XP" And $OSbit = "X64" And $prop > "0" Then
	GUICtrlSetData ($edit, "Windows XP 64bit #" & $i & "=" & $prop & @CRLF,"Input")
ElseIf $OS = "WIN_XP" And $OSbit = "X64" And $prop = "0" Then
	GUICtrlSetData ($edit, "","input")
;Server 2008
ElseIf $OS = "WIN_2008" And $OSbit = "X86" And $prop > "0" Then
	GUICtrlSetData ($edit, "Windows Server 2008 32bit #" & $i & "=" & $prop & @CRLF,"Input")
ElseIf $OS = "WIN_2008" And $OSbit = "X86" And $prop = "0" Then
	GUICtrlSetData ($edit, "","input")
ElseIf $OS = "WIN_2008" And $OSbit = "X64" And $prop > "0" Then
	GUICtrlSetData ($edit, "Windows Server 2008 64bit #" & $i & "=" & $prop & @CRLF,"Input")
ElseIf $OS = "WIN_2008" And $OSbit = "X64" And $prop = "0" Then
	GUICtrlSetData ($edit, "","input")
;Vista Windows 7
ElseIf $OS = "WIN_VISTA" And $OSbit = "X86" And $prop > "0" Then
	GUICtrlSetData ($edit, "Windows 7 32bit #" & $i & "=" & $prop & @CRLF,"Input")
ElseIf $OS = "WIN_VISTA" And $OSbit = "X86" And $prop = "0" Then
	GUICtrlSetData ($edit, "","input")
ElseIf $OS = "WIN_VISTA" And $OSbit = "X64" And $prop > "0" Then
	GUICtrlSetData ($edit, "Windows 7 64bit #" & $i & "=" & $prop & @CRLF,"Input")
ElseIf $OS = "WIN_VISTA" And $OSbit = "X64" And $prop = "0" Then
	GUICtrlSetData ($edit, "","input")
ElseIf $OS = "WIN_7" And $OSbit = "X86" And $prop > "0" Then
	GUICtrlSetData ($edit, "Windows 7 32bit #" & $i & "=" & $prop & @CRLF,"Input")
ElseIf $OS = "WIN_7" And $OSbit = "X86" And $prop = "0" Then
	GUICtrlSetData ($edit, "","input")
ElseIf $OS = "WIN_7" And $OSbit = "X64" And $prop > "0" Then
	GUICtrlSetData ($edit, "Windows 7 64bit #" & $i & "=" & $prop & @CRLF,"Input")
ElseIf $OS = "WIN_7" And $OSbit = "X64" And $prop = "0" Then
	GUICtrlSetData ($edit, "","input")
EndIf
; repeat 500 times
Next
MsgBox(32,'Status','DONE')
   EndSwitch
WEnd
#Region ;This is the function that should not be touched
Func _GetExtProperty($sPath, $iProp)
	Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
	$iExist = FileExists($sPath)
	If $iExist = 0 Then
		SetError(1)
		Return 0
	Else
		$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
		$sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
		$oShellApp = ObjCreate ("shell.application")
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
#EndRegion
