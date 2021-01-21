
#include <file.au3>
#include <GuiConstants.au3>
Global $msg
Global $Button_next
Global $Label_select
Global $selectmodell
Global $Combo
Global $Combo2
Global $line
Global $startgui
Global $selecttype
Global $olddriver
Global $oldversion
Global $oldurl
Global $thirdgui
Global $fourthgui
Global $file
Global $newurl
Global $newurltemp
Global $newfilever
Global $var2
Global $newinfotemp
Global $newinfo
Global $l

call ("start")

Func Start ()

$startgui = GuiCreate("RIS - Driver Update Admin", 310, 200,(@DesktopWidth-400)/2, (@DesktopHeight-400)/2)

$Group_1 = GuiCtrlCreateGroup("RIS - PC Driver Update Admin ", 30, 20, 250, 60)
$Label_start = GuiCtrlCreateLabel("This wizard will help you to update the RIS - Drvier Update utility ", 40, 40, 190, 30)
$Combo = GuiCtrlCreateCombo("", 70, 110, 170, 21, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1,"Dell x200")
GUICtrlSetData(-1,"Dell x300") 
GUICtrlSetData(-1,"Dell GX280") 
GUICtrlSetData(-1,"Dell 530") 
GUICtrlSetData(-1,"Dell 620") 
GUICtrlSetData(-1,"Dell m70") 
GUICtrlSetData(-1,"Dell d600") 
$Label_select = GuiCtrlCreateLabel("1. Select Model", 70, 90, 130, 20)
$Button_next = GuiCtrlCreateButton("Next", 100, 155, 100, 25)
GuiSetState()
call ("OnSelectModel")

EndFunc

Func OnSelectModel ()
While 1
    $msg = GUIGetMsg()
	    if $msg = $Button_next then
		$selectmodell = GUICtrlRead($Combo)
		Select
		case $selectmodell = ""
			MsgBox(64, "RIS - Driver Update Admin", "Please, make a selection" & @LF & "before you press Next")
		case $selectmodell = "Dell GX280"
			GUIDelete ($startgui)
			call ("OnSelectType")
			ExitLoop
		case $selectmodell = "Dell 530"
			GUIDelete ($startgui)
			call ("OnSelectType") 			
            ExitLoop
		case $selectmodell = "Dell x200"
			GUIDelete ($startgui)
			call ("OnSelectType")
			ExitLoop
		EndSelect
	endif
wend

EndFunc

Func OnSelectType ()
;Select Driver Type
$secondgui = GuiCreate("RIS - Driver Update Admin", 310, 200,(@DesktopWidth-400)/2, (@DesktopHeight-400)/2)
$Group_1 = GuiCtrlCreateGroup("RIS - PC Driver Update Admin ", 30, 20, 250, 60)
$Label_start = GuiCtrlCreateLabel("This wizard will help you to update the RIS - Drvier Update utility ", 40, 40, 190, 30)
$Label_select2 = GuiCtrlCreateLabel("2. Select Driver Type for " & $selectmodell, 70, 90, 190, 20)
$Button_next = GuiCtrlCreateButton("Next", 165, 155, 75, 25)
$Button_back = GuiCtrlCreateButton("Back", 75, 155, 75, 25)
$Combo2 = GuiCtrlCreateCombo("", 70, 110, 170, 21, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1,"Audio Driver " & $selectmodell)
GUICtrlSetData(-1,"Video Driver " & $selectmodell)
GUICtrlSetData(-1,"Chipset Driver " & $selectmodell)
GUICtrlSetData(-1,"Nic Driver " & $selectmodell)
GuiSetState()
	
while 1
    $msg = GUIGetMsg()
    if $msg = $Button_next then
		$selecttype = GUICtrlRead($Combo2)
		Select
		case $selecttype = ""
			MsgBox(64, "RIS - Driver Update Admin", "Please, make a selection" & @LF & "before you press Next")
		case $selecttype = "Audio Driver " & $selectmodell
			ExitLoop
		case $selecttype = "Video Driver " & $selectmodell
			ExitLoop
		EndSelect
    Else
	    if $msg = $Button_back then
		   GUIDelete ($secondgui)
		   call ("Start")
		   ExitLoop
        EndIf
	endif
	
WEnd

$file = FileOpen("RIS Driver Update.au3", 0)

; Check if file opened for reading OK
If $file = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
EndIf

$oldurl = ""
$oldurltemp = ""
$oldversion = ""
$oldversiontemp = ""
$nextline = ""
$nextlinetemp = ""
$olddriver = ""
$olddrivertemp = ""

$i = 1
While 1
	$i = $i + 1
	$line = FileReadline($file)
	If @error = -1 Then ExitLoop

    If $nextline = 3 Then
	   $oldurltemp = StringTrimLeft($line, 20)
	   $oldurl = StringTrimRight($oldurltemp, 1)
	   MsgBox(0, "", $oldurl)
	   GUIDelete ($secondgui)
	   FileClose($file)
	   call ("NewDriverDetails")
	   ExitLoop
	EndIf
    If $nextline = 2 Then
	   $oldversiontemp = StringTrimLeft($line, 17)
	   $oldversion = StringTrimRight($oldversiontemp, 1)
	   MsgBox(0, "", $oldversion)
	   $nextline = 3
	EndIf
	If $nextline = 1 Then 
	   $olddrivertemp = StringTrimLeft($line, 18)
	   $olddriver = StringTrimRight($olddrivertemp, 1)
	   MsgBox(0, "", $olddriver)
	   $nextline = 2
	Endif
	$result2 = StringInStr($line, ";" & $selecttype)
     if $result2 = 1 then 
        msgbox (0, "", $i)
		$nextline = 1
	endif
WEnd
EndFunc

func NewDriverDetails ()
$thirdgui = GuiCreate("RIS - Driver Update Admin", 310, 300,(@DesktopWidth-400)/2, (@DesktopHeight-400)/2)
GuiCtrlCreateGroup("RIS - PC Driver Update Admin ", 30, 20, 250, 60)
GuiCtrlCreateLabel("This wizard will help you to update the RIS - Drvier Update utility ", 40, 40, 190, 30)
GuiCtrlCreateLabel("Old " & $selecttype & ":", 35, 90, 390, 15)
GuiCtrlCreateLabel("File = " & $olddriver, 35, 105, 390, 15)
GuiCtrlCreateLabel("Ver = " & $oldversion, 35, 120, 390, 15)

GuiCtrlCreateLabel("New " & $selecttype & ":", 35, 140, 390, 15)
GuiCtrlCreateLabel("File = ", 35, 155, 390, 15)
GuiCtrlCreateLabel("Ver = ", 35, 170, 390, 15)
GuiSetState(@SW_SHOW)

$ver = FileGetVersion($olddriver)
       if $ver = "0.0.0.0" then
		   MsgBox(64, "RIS - Driver Update Admin", "The old driver file is removed." & @LF & "Press Change new Driver File" & @LF & "to select driver file")
	   ElseIf $ver <= $oldversion then
		  MsgBox(64, "RIS - Driver Update Admin", "The old driver file verion is unchanged or older." & @LF & "Press Change new Driver File to select driver file")
	  Else
		  GuiCtrlCreateLabel("New " & $selecttype & ":", 35, 140, 390, 15)
		  GuiCtrlCreateLabel("File = " & $olddriver, 35, 155, 390, 15)
		  GuiCtrlCreateLabel("Ver = " & $ver, 35, 170, 390, 15)
EndIf

$Button_browse = GuiCtrlCreateButton("Change new Driver File", 75, 200, 165, 25)
$Button_back = GuiCtrlCreateButton("Back", 75, 250, 75, 25)
$Button_next = GuiCtrlCreateButton("Next", 165, 250, 75, 25)
$var2 = $olddriver
$newfilever = $ver

while 1
    $msg = GUIGetMsg()
    if $msg = $Button_browse then
		$message = "Select new driver file"
        $var2 = FileOpenDialog($message, "C:\Windows\system32\drivers\",  "All files (*.*)")
        If @error Then
	    ;MsgBox(4096,"","No File(s) chosen")
        Else
	    $var2 = StringReplace($var2, "|", @CRLF)
		$newfilever = FileGetVersion($var2)
		GuiCtrlCreateLabel("File = " & $var2, 35, 155, 390, 15)
		GuiCtrlCreateLabel("Ver = " & $newfilever, 35, 170, 390, 15)
	EndIf
    Else
	    if $msg = $Button_back then
		   GUIDelete ($thirdgui)
           call ("OnSelectType")
		   ExitLoop
        Else
		   if $msg = $Button_next then
		   GUIDelete ($thirdgui)
		   call ("OnEnterUrl")
		   ExitLoop
	   EndIf
	   EndIf
	endif
WEnd


while 1
	sleep (1000)
wend

EndFunc

Func OnEnterUrl ()
	
$fourthgui = GuiCreate("RIS - Driver Update Admin", 310, 235,(@DesktopWidth-400)/2, (@DesktopHeight-400)/2)
GuiCtrlCreateGroup("RIS - PC Driver Update Admin ", 30, 20, 250, 60)
GuiCtrlCreateLabel("This wizard will help you to update the RIS - Drvier Update utility ", 40, 40, 190, 30)
GuiCtrlCreateLabel("Old url for " & $selecttype & " file:", 35, 90, 390, 15)
GuiCtrlCreateLabel("Url = " & $oldurl, 35, 105, 390, 15)

GuiCtrlCreateLabel("Enter new url for " & $selecttype & " file:", 35, 125, 390, 15)
$newurltemp = GuiCtrlCreateInput("", 35, 145, 250, 20)

$Button_back = GuiCtrlCreateButton("Back", 75, 185, 75, 25)
$Button_next = GuiCtrlCreateButton("Next", 165, 185, 75, 25)


GuiSetState(@SW_SHOW)

while 1
    $msg = GUIGetMsg()
		if $msg = $Button_back then
		   GUIDelete ($fourthgui)
           call ("NewDriverDetails")
		   ExitLoop
        Else
		   if $msg = $Button_next then
			if GUICtrlRead($newurltemp) = "" Then
				MsgBox(64, "RIS - Driver Update Admin", "Please, enter a new url" & @LF & "before you press Next")
			else 
				$newurl = GUICtrlRead($newurltemp)
				GUIDelete ($fourthgui)
		        call ("OnEnterInfo")
		    ExitLoop
			EndIf
		  EndIf
	EndIf
WEnd
	
while 1
	sleep (1000)
wend

EndFunc

Func OnEnterInfo ()
	
$5gui = GuiCreate("RIS - Driver Update Admin", 415, 310,(@DesktopWidth-500)/2, (@DesktopHeight-400)/2)
GuiCtrlCreateGroup("RIS - PC Driver Update Admin ", 30, 20, 250, 60)
GuiCtrlCreateLabel("This wizard will help you to update the RIS - Drvier Update utility ", 40, 40, 190, 30)

GuiCtrlCreateLabel("Enter new Download Info Message for " & $selecttype, 12, 100, 390, 15)
$newinfotemp = GuiCtrlCreateInput("", 10, 120, 396, 112, BitOR ($ES_WANTRETURN, $ES_MULTILINE))

$Button_back = GuiCtrlCreateButton("Back", 115, 260, 75, 25)
$Button_next = GuiCtrlCreateButton("Next", 205, 260, 75, 25)


GuiSetState(@SW_SHOW)

while 1
    $msg = GUIGetMsg()
	    if $msg = $Button_back then
		   GUIDelete ($5gui)
           call ("OnEnterUrl")
		   ExitLoop
        Else
		   if $msg = $Button_next then
			if GUICtrlRead($newinfotemp) = "" Then
				MsgBox(64, "RIS - Driver Update Admin", "Please, enter a new Driver Info" & @LF & "before you press Next")
			else 
			   $newinfo = GUICtrlRead($newinfotemp)
		       GUIDelete ($5gui)
		       call ("OnCompile")
		       ExitLoop
			EndIf
		  EndIf
	EndIf
WEnd
	
while 1
	sleep (1000)
wend

EndFunc

Func OnCompile ()
	
$6gui = GuiCreate("RIS - Driver Update Admin", 415, 400,(@DesktopWidth-500)/2, (@DesktopHeight-400)/2)
GuiCtrlCreateGroup("RIS - PC Driver Update Admin ", 30, 20, 250, 60)
GuiCtrlCreateLabel("This wizard will help you to update the RIS - Drvier Update utility ", 40, 40, 190, 30)
GuiCtrlCreateLabel("Save Changes for " & $selecttype, 12, 90, 390, 15)

;GuiCtrlCreateLabel("File = " & $var2, 12, 105, 390, 15)
;GuiCtrlCreateLabel("Ver = " & $newfilever, 12, 120, 390, 15)
GuiCtrlCreateLabel("Url = " & $newurl, 12, 135, 390, 30)
GuiCtrlCreateLabel("Driver Info:", 12, 165, 390, 15)
GuiCtrlCreateInput($newinfo, 10, 182, 396, 112, Bitor ($ES_READONLY, $ES_MULTILINE))

_FileCreate ("temp.pak")
$temppak = FileOpen("temp.pak", 1)
If $temppak = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf
FileWrite($temppak, $newinfo)
FileClose($temppak)

$l = 0
$temppak = FileOpen("temp.pak", 0)
While 1
	$l = $l + 1
    $line = FileReadLine($temppak)
    If @error = -1 Then ExitLoop
	If $l = 1 Then
	    $line1 = $line
	    MsgBox(0, "Line read:", $line1)
        else
	    If $l = 2 Then
	    $line2 = $line
	    MsgBox(0, "Line read:", $line2)
        Else
	    If $l = 3 Then
		$line3 = $line
		MsgBox(0, "Line read:", $line3)
		Else
		If $l = 4 Then
		$line4 = $line
		MsgBox(0, "Line read:", $line4)
		Else
		If $l = 5 Then
		$line5 = $line
		MsgBox(0, "Line read:", $line5)
		Else
		If $l = 6 Then
		$line6 = $line
		MsgBox(0, "Line read:", $line6)
		Else
		If $l = 7 Then
		$line7 = $line
		MsgBox(0, "Line read:", $line7)
		Else
		If $l = 8 Then
		$line8 = $line
		MsgBox(0, "Line read:", $line8)
		EndIf
		EndIf
		EndIf
		EndIf
		EndIf
	    EndIf
        EndIf
  EndIf
Wend
FileClose($temppak)

$Button_create = GuiCtrlCreateButton("Compile EXE", 115, 320, 165, 25)
$Button_back = GuiCtrlCreateButton("Back", 115, 355, 75, 25)
$Button_cancel = GuiCtrlCreateButton("Cancel", 205, 355, 75, 25)


GuiSetState(@SW_SHOW)

while 1
    $msg = GUIGetMsg()
	    if $msg = $Button_back then
		   GUIDelete ($6gui)
           call ("OnEnterInfo")
		   ExitLoop
        Else
		   if $msg = $Button_create then
		   GUIDelete ($6gui)
		   call ("OnCompileFile")
           ExitLoop
           Else
		      if $msg = $Button_cancel then
		      Exit
			  EndIf
		  EndIf  
	Endif
WEnd
	
while 1
	sleep (1000)
wend

EndFunc

Func OnCompileFile ()
	
;$au3file = "Copy of RIS Driver Update.au3"
$au3file = "admin1.au3"
$au3filenew = "tempau3.au3"

; read in the file	
$list1 = FileRead($au3file, FileGetSize ($au3file))
           ;If @error = 1 Then
           ;MsgBox (0, "", "Error reading from " & $au3file)
           ;Exit 1
           ;EndIf
           ; split into lines
		   $list = StringSplit ($list1, @CRLF, 1)
           ; replace specific line
           $linenum = 5
		   $list[$linenum] = "This is the text on the replaced line."
           ; overwrite the file
		   $handle = FileOpen($au3filenew, 1)
           If $handle = -1 Then
           MsgBox(0, "Error", "Unable to open file.")
           Exit 1
           EndIf

           For $i = 1 To $list[0]
              FileWriteLine ($handle, $list[$i])
		   Next
		   msgbox(0,"", "har skrivit till filen")
		   FileClose($handle)
EndFunc
	