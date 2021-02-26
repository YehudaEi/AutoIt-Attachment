#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=

$left = RegRead("HKEY_CURRENT_USER\Software\renameTitle", "Left")
$top = RegRead("HKEY_CURRENT_USER\Software\renameTitle", "Top")

if $left = "" then $left = 0
if $top = "" then $top = 0
$Form1 = GUICreate("Title Renamer by jsiklosi@sbb.rs", 420, 100, $left, $top,    BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS), $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST+ $WS_EX_ACCEPTFILES)
GUISetOnEvent($GUI_EVENT_DROPPED, "MyFunc")
$Input1 = GUICtrlCreateInput("", 50, 16, 353, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Input2 = GUICtrlCreateInput("", 50, 50, 353, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Label1 = GUICtrlCreateLabel("Movie", 10, 22, 33, 17)
$Label2 = GUICtrlCreateLabel("Subtitle", 8, 56, 39, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			$l = WinGetPos("Title Renamer by jsiklosi@sbb.rs")
			RegWrite("HKEY_CURRENT_USER\Software\renameTitle", "Left", "REG_SZ", $l[0])
			RegWrite("HKEY_CURRENT_USER\Software\renameTitle", "Top", "REG_SZ", $l[1])

			Exit
		case $GUI_EVENT_DROPPED
			MyFunc()
	EndSwitch
WEnd



Func MyFunc()
    if GUICtrlRead($input1) > "" Then
		if GUICtrlRead($input2) > "" Then
		$filenameextMovie = CompGetFileName(GUICtrlRead($input1))
		$extensionMovie = CompGetFileExt(GUICtrlRead($input1))
		$filenameMovie = StringReplace($filenameextMovie,$extensionMovie,"")
		$pathmovie = CompGetParentDir(GUICtrlRead($input1))
		$extensionTitle = CompGetFileExt(GUICtrlRead($input2))
		$m = MsgBox (4,"rename: " & GUICtrlRead($input2) , "to: " & $pathmovie&"\" & $filenameMovie & $extensionTitle)
		if $m = 6 Then
			FileCopy(GUICtrlRead($input2),$pathmovie& "\" & $filenameMovie & $extensionTitle)
			FileDelete(GUICtrlRead($input2))
			GUICtrlSetData($input1,"")
			GUICtrlSetData($input2,"")
			endif
		
		
	EndIf
	EndIf
EndFunc




Func CompGetFileExt($Path,$Dot=True)
       ;by 1234hotmaster
    If StringLen($Path) < 4 Then Return -1
    $ret = StringSplit($Path,"\",2)
    If IsArray($ret) Then
        $ret = StringSplit($ret[UBound($ret)-1],".",2)
        If IsArray($ret) Then
            If $Dot Then
                $Dot = "."
            Else
                $Dot = ""
            EndIf
            Return $Dot & $ret[UBound($ret)-1]
        EndIf
    EndIf
    If @error Then Return -1
	EndFunc
	
	Func CompGetFileName($Path)
       ;by 1234hotmaster
    If StringLen($Path) < 4 Then Return -1
    $ret = StringSplit($Path,"\",2)
    If IsArray($ret) Then
        Return $ret[UBound($ret)-1]
    EndIf
    If @error Then Return -1
	EndFunc
	
	Func CompGetParentDir($Path,$EndSeparator=False)
       ;by 1234hotmaster
    If StringLen($Path) < 4 Then Return -1
    $ret = StringSplit($Path,"\",2)
    If IsArray($ret) Then
        Local $temp
        For $i = 0 To UBound($ret)-2
            $temp &= $ret[$i] & "\"
        Next
        If Not $EndSeparator Then $temp = StringTrimRight($temp,1)
        $ret=Chr(0)
        Return $temp
    EndIf
    If @error Then Return -1
	EndFunc
	