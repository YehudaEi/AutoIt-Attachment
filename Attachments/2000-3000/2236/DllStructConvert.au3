#cs
vi:ts=4 sw=4:
Update beta 3.1.1.18 - 3.1.1.23 DllStruct calls to the new names from 3.1.1.24
#ce
#include <GUIConstants.au3>

$hGUI		= GUICreate("DllStruct Converter",200,80,-1,-1,-1,$WS_EX_ACCEPTFILES)
GUICtrlCreateLabel("File",10,5)
$hInput		= GUICtrlCreateInput("",10,20,130)
GuiCtrlSetState(-1,$GUI_ACCEPTFILES)
$hBrowse	= GUICtrlCreateButton("Browse",150,18)
$hConvert	= GUICtrlCreateButton("Convert",40,50)
$hQuit		= GUICtrlCreateButton("Quit",140,50)
GUISetState()

while 1
	$msg	= GUIGetMsg()

	Select
		case $msg = $GUI_EVENT_CLOSE OR $msg = $hQuit 
			ExitLoop
		case $msg = $hBrowse
			$file	= FileOpenDialog("AU3 Script","","AU3 Script(*.au3)",1)
			If Not @Error Then GUICtrlSetData($hInput,$file)
		case $msg = $hConvert
			_Convert(GUICtrlRead($hInput))
	EndSelect
wend

Func _Convert($szFilename)
	Local $szNewFile,$s,$fd,$old,$new,$i

	$old	= StringSplit("DllStructFree,DllStructGet,DllStructSet,DllStructElementPtr,DllStructSize,DllStructPtr",",")
	$new	= StringSplit("DllStructDelete,DllStructGetData,DllStructSetData,DllStructGetPtr,DllStructGetSize,DllStructGetPtr",",")
	
	if Not FileExists($szFilename) Then
		MsgBox(0,"File not found",$szFilename & " Not found")
		return
	EndIf
	$szNewFile	= StringTrimRight($szFilename,4) & "_Converted.au3"
	If FileExists($szNewFile) Then FileDelete($szNewFile)
	

	$fd	= FileOpen($szFilename,0)
	if $fd = -1 Then
		MsgBox(0,"Error","Could not open " & $szFilename & " for reading")
		return
	endif

	While 1
		$s	= FileReadLine($fd)
		if @error = -1 then exitloop
		For $i = 1 To $old[0]
			$s	= StringReplace($s,$old[$i],$new[$i])
		Next
		FileWriteLine($szNewFile,$s)
	WEnd
	FileClose($fd)
	MsgBox(0,"Complete","File Conversion Complete" & @CRLF & "New file " & $szNewFile & " has been created")
EndFunc
