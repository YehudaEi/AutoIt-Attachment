#cs
vi:ts=4 sw=4:
ExecuteClip.au3 - Ejoc
Execute the autoit script in the clipboard, Makes it easy to
tryout someone's code that they posted.
#ce
#include <File.au3>
#include <GUIConstants.au3>
#notrayicon

$szTempFile		= @TempDir & "\Clipboard.au3"
$szClipBoard	= ClipGet()
if @error Then
	MsgBox(0,"Error","Clipboard empty or it is not text")
	exit
EndIf

$hGUI		= GUICreate("Execute Clipboard",200,145)
$hExecute	= GuiCtrlCreateRadio("Execute Script in Clipboard",5,10,195)
$hSave		= GuiCtrlCreateRadio("Save Script in Clipboard",5,35,195)
$hSaveExec	= GuiCtrlCreateRadio("Save && Execute Script in Clipboard",5,60,195)
$hEdit		= GUICtrlCreateRadio("Save && Edit Script in Clipboard",5,85,195)
$hOk		= GUICtrlCreateButton("Ok",50,110,40,-1,$BS_DEFPUSHBUTTON)
$hCancel	= GUICtrlCreateButton("Cancel",110,110,40)
GUICtrlSetState($hExecute,$GUI_CHECKED)
GUISetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $hCancel
			GUIDelete($hGUI)
			Exit

		Case $msg = $hOk
			Select
				Case GUICtrlRead($hExecute) = $GUI_CHECKED
					GUIDelete($hGUI)
					SaveScript($szTempFile)
					ExecuteScript($szTempFile)
					Exit

				Case GUICtrlRead($hSave) = $GUI_CHECKED
					GUIDelete($hGUI)
					SaveDiag()
					SaveScript($szTempFile)
					Exit

				Case GUICtrlRead($hSaveExec) = $GUI_CHECKED
					GUIDelete($hGUI)
					SaveDiag()
					SaveScript($szTempFile)
					ExecuteScript($szTempFile)
					Exit

				Case GUICtrlRead($hEdit) = $GUI_CHECKED
					GUIDelete($hGUI)
					SaveDiag()
					SaveScript($szTempFile)
					EditScript($szTempFile)
					Exit
			EndSelect
	EndSelect
Wend
exit

Func SaveDiag()
	$szTempFile = FileSaveDialog("Save AutoIt File", @MyDocumentsDir, "Scripts (*.au3)", 16, "*.au3")
	if @error Or $szTempFile = "" Then Exit
EndFunc

Func SaveScript($szFilename)
	Local $fd

	$fd	= FileOpen($szFilename,2)
	if $fd <> -1 Then
		FileWrite($fd,$szClipBoard)
		FileClose($fd)
	Endif
EndFunc

Func ExecuteScript($szFilename)
	Local $exe

	If @Compiled Then
		$exe = RegRead("HKLM\SOFTWARE\AutoIt v3\AutoIt","InstallDir")
		if $exe = "" Then MsgBox(0,"AutoIt not installed","AutoIt is not installed")
		Run($exe & '\AutoIt3.exe "' & $szFilename & '"')
	Else
		Run(@AutoItExe & ' "' & $szFilename & '"')
	Endif
EndFunc

Func EditScript($szFilename)
	Local $szEditorExe = ""

	$szEditorExe	= RegRead("HKLM\SOFTWARE\Classes\AutoiT3Script\Shell\Edit\Command","")
	if $szEditorExe <> "" Then 
		Run(StringReplace($szEditorExe,"%1",$szFilename))
	Endif
EndFunc
