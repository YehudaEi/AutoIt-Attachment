#Region  >>>  Compiler
#Compiler_Prompt=N
#Compiler_Compression=2
#Compiler_Allow_Decompile=Y
#Compiler_UseUpx=Y
#Compiler_Icon=C:\AutoIt3\Icons\filetype3.ico
#Compiler_Res_Comment=http://www.autoitscript.com/autoit3/compiled.html
#Compiler_Res_Description=Automaticly Restart DSL-604+ Router
#Compiler_Res_Fileversion=3.2.2.4
#Compiler_Res_FileVersion_AutoIncrement=Y
#Compiler_Res_LegalCopyright=©2007 One of Ten <oneoften@gmail.com>
#Compiler_Res_Field=*Build Date|%date% %time%
#Compiler_Res_Field=*Compiler|AutoIt %AutoItVer%
#Compiler_Res_Field=*Configuration|Settings defined in similar-named INI file.
#Compiler_Run_AU3Check=Y
#Compiler_AU3Check_Stop_OnWarning=Y
#EndRegion  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Opt("TrayIconDebug", 1)

#Region  >>>  INI
Dim $RouterURL = ""
Dim $AuthStr = ""
Dim $FormNum = 1
$INIFile = StringTrimRight(@ScriptFullPath, 3) & "ini"
If Not FileExists($INIFile) Then FileInstall("DSL604-Restarter.ini", $INIFile, 0) ; no overwrite
$INIKeys=IniReadSection($INIFile, "DSL-604+")
For $key=1 To $INIKeys[0][0]
	Assign($INIKeys[$key][0],$INIKeys[$key][1])
Next
If $FormNum < 1 Then $FormNum = 1 ; sanity
#EndRegion  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#Region  >>>  IE
#include <IE.au3>
$__IEAU3Debug = True
_IEErrorHandlerRegister()
$oIE = _IECreateEmbedded()
$oSink = ObjEvent($oIE, "_IEEvent_", "DWebBrowserEvents")
If @error Then
	MsgBox(0x10, Default, "DWebBrowserEvents Hook Error: 0x" & Hex(@error, 8) & "  (" & @error & ")")
	Exit
EndIf
#EndRegion  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#Region  >>>  GUI
;~ #include <GUIConstants.au3>
; 0x80CE0000 = PopUp+Caption+MinimizeBox+SizeBox+SysMenu
; 0x14CF0000 = Overlapped+Visible+ClipSiblings
$InetGUI = GUICreate(StringTrimRight(@ScriptName, 4), 810, 240, Default, Default, 0x14CF0000)
$InetObject = GUICtrlCreateObj($oIE, 1, 1, 800, 218)
$InetStatus = GUICtrlCreateLabel("Status", 1, 221, 698, 18, 0x100B) ; (Sunken+Simple)
$InetProgress = GUICtrlCreateProgress(700, 221, 100, 18, 0x0) ; (Smooth)=0x1
GUISetState()
#EndRegion  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#Region  >>>  Core
; SYNTAX: object.Navigate(url As String,[Flags As Variant,][TargetFrameName As Variant,][PostData As Variant,][Headers As Variant])
$oIE.navigate($RouterURL, "", "", "", "Authorization: Basic " & $AuthStr & @CRLF & @CRLF)

;~ _IELoadWait($oIE)
Do
	Sleep(1)
Until StringInStr(GUICtrlRead($InetStatus), "Done")

$oForm = _IEFormGetCollection($oIE, ($FormNum - 1)) ; convert to zero array
_IEFormSubmit($oForm, 0) ; no_wait

Do
	Sleep(5)
Until GUIGetMsg() = -3 ; $GUI_EVENT_CLOSE
Exit
#EndRegion  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#Region  >>>  UDFs
Func _IEEvent_ProgressChange($Progress, $ProgressMax)
	GUICtrlSetData($InetProgress, ($Progress * 100) / $ProgressMax)
EndFunc
Func _IEEvent_StatusTextChange($Text)
	GUICtrlSetData($InetStatus, $Text)
EndFunc
#EndRegion  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
