#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; 04 Mar 2011 - Author: Hassan Kadhim
; GUI class of the User Creation Automation Application

#include <File.au3>
#include <GUIConstants.au3>
#include <GuiConstantsEx.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>

$numParams = $Cmdline[0]
$prefix = True;
$suffix = False;
$renameString = "";
For $i=1 to $numParams Step 1
;MsgBox(0, "TESTING",$i & ". " & $Cmdline[$i])
Next

; GUI
$biGUI = GuiCreate("Rename Files", 285, 100)
GUICtrlSetDefColor(0x05064A)

; LABELS
GUICtrlCreateLabel("Choose prefix or suffix to add to your file/folder names. ", 10, 6)

;GROUP WITH RADIO BUTTONS
GuiCtrlCreateGroup("Renaming Position", 15, 25, 105, 60)

$rdoPrefix = GuiCtrlCreateRadio("Prefix", 20, 40, 50)
;GUICtrlSetOnEvent(-1, 'deptEventListener')
GuiCtrlSetState(-1, $GUI_CHECKED)

$rdoSuffix = GuiCtrlCreateRadio("Suffix", 20, 60, 50)

; BUTTONS
$cmdRename = GuiCtrlCreateButton("Rename Files", 150,45, 111,25, $SS_SIMPLE)
GUICtrlSetColor(-1, 0x05064A)

; GUI MESSAGE LOOP
GuiSetState()

While 1
	$msg = GUIGetMsg(1)
	Select
		Case $msg[0] = $cmdRename
			;MsgBox(0, "MSGBOX 1", "Rename file clicked")
			If ($numParams <>0) Then
				RenameFiles()				
			EndIf
			ExitLoop
		Case $msg[0] = $rdoPrefix
			$prefix = True
			$suffix = False
		Case $msg[0] = $rdoSuffix
			$prefix = False
			$suffix = True
		Case $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $biGUI
			ExitLoop			
	EndSelect
WEnd

Func RenameFiles()
	Dim $url[2]
	Dim $file[2]
	
	If($prefix) Then
		$renameString = InputBox("Prefix to add", "Please enter the prefix to add to the filenames. ")
	Else
		$renameString = InputBox("Suffix to add", "Please enter the suffix to add to the filenames. ")
	EndIf

	
	For $i=1 to $numParams Step 1
		$url = ExtractDir($Cmdline[$i])
		If($prefix) then
			;MsgBox(0, "File", $url[0])
			;MsgBox(0, "Directory", $url[1] & " ... DirGetSize: " & DirGetSize($Cmdline[$i]))
			If(DirGetSize($Cmdline[$i]) = -1) Then
				FileMove($Cmdline[$i], $url[1] & "\" & $renameString & $url[0], 1)
			Else
				DirMove($Cmdline[$i], $url[1] & "\"  & $renameString & $url[0], 1)
			EndIf
		EndIf
		If($suffix) then
			$file = ExtractExtension($url[0])
			;MsgBox(0, "File", $url[1])
			;MsgBox(0, "File", $file[1])
			;MsgBox(0, "Extension", "." & $file[0])			
			If(DirGetSize($Cmdline[$i]) = -1) Then
				FileMove($Cmdline[$i], $url[1] & "\" & $file[1] & $renameString & "." & $file[0], 1)
			Else
				DirMove($Cmdline[$i],  $url[1] & "\" & $url[0] & $renameString, 1)
			EndIf
		EndIf
	Next
EndFunc

Func ExtractDir($URL)
	;MsgBox(0, "Extracting directory",$URL)
	$tempStr = $URL
	$i=1
	$tempI = $i
	Dim $a[2]
	While ($i < StringLen($URL) And $i <>0)
		$i = StringInStr($tempStr, "\")
		If ($i<>0) Then
			;MsgBox(0, "TempI: " & $tempI & "   I: " & $i, $tempStr)
			$tempStr = StringMid($tempStr, $i+1)
			$tempI = $tempI + $i
			;MsgBox(0, "TempI: " & $tempI & "   I: " & $i, $tempStr)
		EndIf
	WEnd
	
	$a[0] = $tempStr   ;returning the File
 	$tempStr = StringMid($URL, 1, $tempI-2)
	$a[1] = $tempStr    ;returning the Directory
	return $a
	;MsgBox(0, "DIR -  " & $tempI, $tempStr)
EndFunc

Func ExtractExtension($Filename)
	;MsgBox(0, "Extracting directory",$URL)
	$tempStr = $Filename
	$i=1
	$tempI = $i
	Dim $a[2]
	While ($i < StringLen($Filename) And $i <>0)
		$i = StringInStr($tempStr, ".")
		If ($i<>0) Then
			;MsgBox(0, "TempI: " & $tempI & "   I: " & $i, $tempStr)
			$tempStr = StringMid($tempStr, $i+1)
			$tempI = $tempI + $i
			;MsgBox(0, "TempI: " & $tempI & "   I: " & $i, $tempStr)
		EndIf
	WEnd
	
	$a[0] = $tempStr   ;returning the File
 	$tempStr = StringMid($Filename, 1, $tempI-2)
	$a[1] = $tempStr    ;returning the Directory
	return $a
	;MsgBox(0, "DIR -  " & $tempI, $tempStr)
EndFunc