
#include "_XMLDomWrapper.au3"
#include <Array.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <string.au3>

Dim $lien

$ret = _XMLFileOpen (foldercolors.xml)

$test = 0
$PlusLong=0

For $i=1 to _XMLGetNodeCount("/foldercolors/path")
	$pathstring = _XMLGetValue("/foldercolors/path[" & $i & "]/dir/pathstring")
	If NOT FileExists($pathstring[1]) Then
		$test=$test+1
	EndIf
Next

If $test = 0 then
	If $file = -1 Then
		Exit
	Else
		MsgBox(0,"","Nothing to do...")
	EndIf
Else
	GuiCreate("List...", 420, 400)

	GuiCtrlCreateList("", 5, 30, 410, 320, $WS_HSCROLL  + $WS_VSCROLL)

	For $i=1 to _XMLGetNodeCount("/foldercolors/path")
		$pathstring = _XMLGetValue("/foldercolors/path[" & $i & "]/dir/pathstring")
		If NOT FileExists($pathstring[1]) Then
			GuiCtrlSetData(-1, $pathstring[1], "")
			$longueur = StringLen ($pathstring[1])
			if $longueur > $PlusLong Then
				$PlusLong = $longueur
			EndIf

		EndIf
	Next

GUICtrlSetLimit(-1, $PlusLong * 7)

	$clean = GUICtrlCreateButton("Clean list", 130, 360, 60, 30, 0)
	$close = GUICtrlCreateButton("Close", 230, 360, 60, 30, 0)

	If $test=1 then
		GuiCtrlCreateLabel("This path doesn't exist anymore...", 5, 8, 195, 15)
	Else
		GuiCtrlCreateLabel("All these " & $test & " paths don't exist anymore...", 5, 8, 195, 15)
	EndIf

	GuiSetState()
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $clean
				clean()
			Case $close
				close()
		EndSwitch
	WEnd

EndIf

Func clean ()
	$rep= msgbox(36,"Alert...","Clean list ?")
	if $rep = 6 Then
		For $i=_XMLGetNodeCount("/foldercolors/path") to 1 Step -1
			$pathstring = _XMLGetValue("/foldercolors/path[" & $i & "]/dir/pathstring")
			If NOT FileExists($pathstring[1]) Then
				_XMLDeleteNode("/foldercolors/path[" & $i & "]")
			EndIf
		Next
		Exit
	endif
EndFunc

Func close ()
	exit
EndFunc
