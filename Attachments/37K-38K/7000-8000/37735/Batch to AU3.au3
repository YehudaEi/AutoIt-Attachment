#include <EditConstants.au3>
#include <File.au3>
#NoTrayIcon

Main()

Func Main()
	GUICreate("Batch to AutoIt", 360, 170, -1, -1)
	GUICtrlCreateLabel("Batch File:", 10, 20)
	$BatchFile = GUICtrlCreateInput("", 70, 19, 230, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	$Browse1 = GUICtrlCreateButton("...", 310, 19, 40, 20)
	GUICtrlCreateLabel("Save As:", 16, 60)
	$SaveDir = GUICtrlCreateInput("", 70, 59, 230, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	$Browse2 = GUICtrlCreateButton("...", 310, 59, 40, 20)
	$Convert = GUICtrlCreateButton("Convert", 130, 110, 80, 30)

	GUISetState()

	While 1
		$Msg = GUIGetMsg()
		Switch $Msg
			Case -3
				Exit
			Case $Browse1
				$File = FileOpenDialog("Choose a Batch File", @ScriptDir, "Batch Files (*.bat)")
				If Not @error Then
					GUICtrlSetData($BatchFile, $File)
					GUICtrlSetData($SaveDir, StringTrimRight($File, 4) & ".au3")
				EndIf
			Case $Browse2
				$File = FileSaveDialog("Save Location", @ScriptDir, "AutoIt Script (*.au3)")
				If Not @error Then
					GUICtrlSetData($SaveDir, $File)
				EndIf
			Case $Convert
				If Not GUICtrlRead($BatchFile) = "" Then
					FileWrite(GUICtrlRead($SaveDir), "")
					_FileWriteToLine(GUICtrlRead($SaveDir), 1, "#Include <Process.au3>")
					ControlDisable("", "", $Browse1)
					ControlDisable("", "", $Browse2)
					ControlDisable("", "", $Convert)

					For $i = 2 To _FileCountLines(GUICtrlRead($BatchFile))
						$Line = FileReadLine(GUICtrlRead($BatchFile), $i)
						If $Line = '' Then
							_FileWriteToLine(GUICtrlRead($SaveDir), $i, "")
							Else
							If Not StringInStr($Line, "'") Then
								_FileWriteToLine(GUICtrlRead($SaveDir), $i, "Run(@ComSpec & " & '" /c " ' & "& '" & $Line & "'" & ', "", @SW_HIDE)', 1)
							Else
								_FileWriteToLine(GUICtrlRead($SaveDir), $i, "Run(@ComSpec & " & '" /c " ' & '& "' & $Line & '"' & ', "", @SW_HIDE)', 1)
							EndIf
							GUICtrlSetData($Convert, "Converting...")
						EndIf
					Next

					GUICtrlSetData($Convert, "Done!")
					Sleep(2000)
					GUICtrlSetData($Convert, "Convert")
					ControlEnable("", "", $Browse1)
					ControlEnable("", "", $Browse2)
					ControlEnable("", "", $Convert)
				Else
					MsgBox(16, "Error!", "Choose a batch File!")
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>Main

