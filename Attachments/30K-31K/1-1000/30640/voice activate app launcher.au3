#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <SAPIListBox.au3>

Const $num_apps = 20
dim $msg
dim $SpeechListBox1_item[$num_apps] = ["close", "note pad", "calculator", "word pad", "Word", "Excel", "Paint", "DOS", "Explorer", "IE", "Magnifier", "Narrator", "Hyperterminal", "MSN", "Sound Recorder", "Media Player", "Defrag", "Sys Info", "Address Book", "System Restore"]
dim $SpeechListBox1_cmd[$num_apps] = ["", "notepad.exe", "calc.exe", "wordpad.exe", "winword.exe", "excel.exe", "mspaint.exe", "cmd.exe", "explorer.exe", "iexplore.exe", "magnify.exe", "narrator.exe", "hypertrm.exe", "msnmsgr.exe", "sndrec32.exe", "wmplayer.exe", "dfrg.msc", "msinfo32.exe", "wab.exe", "c:\windows\system32\restore\rstrui.exe"]

; Setup the GUI
GUICreate("Voice Activated Application Launcher", 640, 580)
GUICtrlCreateLabel("Say / speak any Application from the listbox below, into an attached microphone, and that Application should open.", 10, 20)
$SpeechListBox1 = _GUICtrlSAPIListBox_Create(10, 40, 600, 360, True, False, False, $SpeechListBox1_item)

if $SpeechListBox1 = False Then
	
	MsgBox((262144+16), "SAPIListBox control Test - Error!", "Could not create a SAPI ListBox control." & @CRLF & "Ensure you have installed the" & @CRLF & "Microsoft Speech SDK 5.1 (SpeechSDK51.exe) and try again")
	Exit
EndIf

$close_button = GUICtrlCreateButton("Close (Esc)", 10, 550, 80, 20)
$speech_properties_button = GUICtrlCreateButton("Speech Properties", 300, 550, 100, 20)
dim $main_gui_accel[1][2]=[["{ESC}", $close_button]]
GUISetAccelerators($main_gui_accel)

; Display the GUI
GUISetState()

; Main loop
While 1
	
	if _GUICtrlSAPIListBox_CurSelChanged($SpeechListBox1) = True Then
		
		; If the user said "close", then close the active window.
		if StringCompare(_GUICtrlSAPIListBox_GetText($SpeechListBox1), "close") = 0 Then
			
			WinClose("[ACTIVE]", "")
		Else
		
			ShellExecute($SpeechListBox1_cmd[_GUICtrlSAPIListBox_GetCurSel($SpeechListBox1)])
		EndIf
	EndIf

	if $msg = $speech_properties_button Then
		
		_SAPI_SpeechProperties()
	EndIf

	if $msg = $GUI_EVENT_CLOSE or $msg = $close_button Then
		
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
WEnd

GUIDelete()
