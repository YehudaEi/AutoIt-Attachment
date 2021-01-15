#include <GUIConstants.au3>
#include <Array.au3>
#Include <File.au3>
#include <Date.au3>


Opt("GUIOnEventMode", 1)

$Form = GUICreate("Qsek's Cached Screenshot Deleter", 311, 129, 341, 200)
$Autodel = GUICtrlCreateCheckbox("Auto Del", 8, 8, 81, 25, BitOR($BS_CHECKBOX,$BS_AUTOCHECKBOX,$BS_PUSHLIKE,$WS_TABSTOP))
$Fc = GUICtrlCreateInput("100", 104, 8, 33, 21)
GUICtrlSetLimit($Fc, 4)
$FcText = GUICtrlCreateLabel("Max Files", 144, 12, 66, 24)
$SaveC = GUICtrlCreateButton("Save Current", 8, 48, 97, 25, )
$ren = GUICtrlCreateCheckbox("Rename for Virtual Dub", 120,52)
$Status = GUICtrlCreateLabel("", 8, 80, 295, 41, $SS_SUNKEN)
$Info = GUICtrlCreateButton(" ? ", 280, 8,)
GUISetState(@SW_SHOW)


GUISetOnEvent($GUI_EVENT_CLOSE, "ExitScript")

GUICtrlSetOnEvent ( $Autodel, "Autodel" )
GUICtrlSetOnEvent ( $Fc, "Fc" )
GUICtrlSetOnEvent ( $SaveC, "SaveC" )
GUICtrlSetOnEvent ( $Info, "Info" )

Global $Fstat=0
Global $ADs=False
Global $Filecount = GUICtrlRead ($Fc)


Opt("WinTitleMatchMode", 1)

While 1
	$SSdir = RegRead ( "HKEY_LOCAL_MACHINE\SOFTWARE\Fraps2", "Screenshot Directory" )
	If $SSdir = "" Then 
		GUICtrlSetData ( $Status, "No Screenshot Dir. found. Is Fraps2 Installed?")
		Sleep(500)
		ContinueLoop
	EndIf
	GUICtrlSetData ( $Status, "Screenshot Dir. found:"&@CRLF&$SSdir)
	ExitLoop
WEnd
FileChangeDir ( $SSdir )



Func Autodel()
	If GUICtrlRead ($Autodel) = 1 Then $ADs=False
EndFunc

Func Fc()
;~ 	GUICtrlSetState ( $Autodel,  $GUI_UNCHECKED)
	$Filecount = GUICtrlRead ($Fc)
	GUICtrlSetState ( $Status,  $GUI_FOCUS)
EndFunc

Func SaveC()
;~ 	MsgBox(0,0,GUICtrlRead ($Autodel))
	$FileList =_FileListToArray("C:\Dokumente und Einstellungen\Administrator\Desktop\BF2","*.bmp")
	If @error > 0 Then
		MsgBox (0,"","No Files Found.")
		Return
	EndIf

;~ 	MsgBox(0,'',"The time is:" & _NowTime())
;~ 	_ArrayDisplay($FileList,"$FileList")
;~ 	For $i = 1 To $Fstattmp
;~ 		DirCreate ( "\testing\" )
	$newdir = StringReplace(_NowDate()&"_"&_NowTime(),":", "-")
		
	If 	GUICtrlRead ($ren) = 1 Then
		For $i = 1 To $FileList[0]
			$dat = StringFormat ( "%04i", $i)
;~ 			MsgBox(0,0,$dat)
			FileMove (@WorkingDir&"\"&$FileList[$i],$newdir&"\"&$newdir&"_"&$dat&".bmp",9)
		Next
		GUICtrlSetData ( $Status, $FileList[0]&" Files have been renamed and moved to "&$newdir&"\")
	Else
		FileMove (@WorkingDir&"\*.bmp",$newdir&"\",9)
		GUICtrlSetData ( $Status, $FileList[0]&" Files have been moved to "&$newdir)
	EndIf
;~ 	Next

EndFunc

Func Info()
	MsgBox(0,"Help","Auto Del                          = Turn on to limit the Screenshot-Folder every 5 Seconds to the most recent maximum Files." & @CRLF & "" & @CRLF & "Max Files                         = Limit of maximum Files the Screenshot-Folder may contain." & @CRLF & "" & @CRLF & "Save Current                   = Move all Files to a New Folder named after current Date and Time." & @CRLF & "" & @CRLF & "Rename for Virtual Dub   = Rename the files in the format ...0001.bmp ...0002.bmp etc." & @CRLF & "" & @CRLF & "Copyright © 2007 by Qsek")
EndFunc


Func ExitScript()
	Exit
EndFunc   ;==>EndScript



While 1
	$Fstattmp = 0
	For $i = 1 To 10
		If $ADs=False And GUICtrlRead ($Autodel) = 1 Then
			$ADs=True
			ExitLoop
		ElseIf GUICtrlRead ($Autodel) = 4 Then
			$i = 1
		EndIf 
		Sleep (500)
		$class = ControlGetFocus ( "Qsek's Cached Screenshot Deleter")
		If $class = "Edit1" Then 
			GUICtrlSetData ( $Status, "Halted")
			$i = 9
		EndIf
	Next
	$FileList =_FileListToArray("C:\Dokumente und Einstellungen\Administrator\Desktop\BF2","*.bmp")
	If @error > 0 Then
		GUICtrlSetData ( $Status,"No Files Found.")
		ContinueLoop
	EndIf

;~ 	_ArrayDisplay($FileList,"$FileList")
	If $FileList[0] > $Filecount Then 
		$Fstattmp = $FileList[0]-$Filecount
		For $i = 1 To $Fstattmp
			FileDelete ($FileList[$i])
		Next
	EndIf
	$Fstat += $Fstattmp
	GUICtrlSetData ( $Status, "Files deleted ("&$Fstat&")" )
;~ GUICtrlSetData ( $Status, GUICtrlGetState ( $Fc )&"("&$Fstat&")")
	
WEnd
