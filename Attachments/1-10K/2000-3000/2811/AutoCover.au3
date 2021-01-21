#include <GUIConstants.au3>
Opt("MustDeclareVars",1)

Local $hGUI,$hCompanyAddress,$hHRContact,$hCompanyName,$hJobTitle,$hOpen
Local $hExit,$hCopy
Local $szCompanyAddress,$szHRContact,$szCompanyName,$szJobTitle,$szDate
Local $szFile,$szCoverletter

$szDate	= _GetASCIIDate()

$hGUI				= GUICreate("AutoCover",300,200)
$hCompanyName		= GUICtrlCreateInput("",75,5,220)
$hJobTitle			= GUICtrlCreateInput("",75,30,220)
$hHRContact			= GUICtrlCreateInput("To Whom It May Concern",75,55,220)
$hCompanyAddress	= GUICtrlCreateEdit("",5,100,290,70)
$hOpen				= GUICtrlCreateButton("Open",40,173,40)
$hExit				= GUICtrlCreateButton("Exit",220,173,40)
$hCopy				= GUICtrlCreateButton("Copy to Clipboard",100,173,100)
GUICtrlCreateLabel("Company:",5,7)
GUICtrlCreateLabel("Job:",5,32)
GUICtrlCreateLabel("Contact:",5,57)
GUICtrlCreateLabel("Company Address:",5,82)
GUICtrlSetState($hCopy,$GUI_DISABLE)
GUICtrlSetState($hCompanyName,$GUI_FOCUS)

GUISetState()
While 1
	Local $msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Or $msg = $hExit Then ExitLoop
	If $msg = $hOpen Then
		$szFile	= FileOpenDialog("Cover Letter","","Text files (*.txt)",1)
		If Not @error And FileExists($szFile) Then
			GUICtrlSetState($hCopy,$GUI_ENABLE)
		Else
			GUICtrlSetState($hCopy,$GUI_DISABLE)
		EndIf
	EndIf
	If $msg = $hCopy Then
		$szCompanyName		= GUICtrlRead($hCompanyName)
		$szJobTitle			= GUICtrlRead($hJobTitle)
		$szHRContact		= GUICtrlRead($hHRContact)
		$szCompanyAddress	= GUICtrlRead($hCompanyAddress)

		$szCoverletter	= _ReplaceTags($szFile,$szDate,$szCompanyName,_
										$szJobTitle,$szHRContact,_
										$szCompanyAddress)
		if $szCoverletter <> "" Then ClipPut($szCoverletter)
	EndIf
WEnd


Func _GetASCIIDate()
	Local $mon	= StringSplit("January February March April May June July August September October November December"," ")

	Return $mon[@MON] & " " & @MDAY & ", " & @YEAR
EndFunc

Func _ReplaceTags($szFile,$szDate,$szCompanyName,$szJobTitle,$szHRContact,$szCompanyAddress)
	Local $szCoverLetter,$line,$fd,$i
	Local $tag = StringSplit("<DATE>|<COMPANY ADDRESS>|<HR CONTACT>|<JOB TITLE>|<COMPANY NAME>","|")
	Local $replace = StringSplit($szDate & "|" & $szCompanyAddress & "|" & $szHRContact & "|" & $szJobTitle & "|" & $szCompanyName,"|")


	$fd	= FileOpen($szFile,0)
	If $fd = -1 Then return ""

	While 1
		$line = FileReadLine($fd)
		If @error = -1 Then ExitLoop
		For $i = 1 To 5
			$line	= StringReplace($line,$tag[$i],$replace[$i])
		Next
		$szCoverLetter &= $line & @CRLF
	Wend
	FileClose($fd)

	Return $szCoverLetter

EndFunc
