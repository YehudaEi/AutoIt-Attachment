#include<array.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>


;$filename = StringReplace($cmdline[1],"'"," ")

$filename = $cmdline[1]

; to accept file names having space in between
for $i = 2 to UBound($cmdline) - 1
	$filename = $filename & " " & $cmdline[$i]
Next
;MsgBox(0,"file",$filename)

$filehandle = FileOpen($filename)
;$filehandle = FileOpenDialog("","","")



; get input from user
$searchinput =InputBox("Enter Search Items","Enter Items in csv format to search multiple items" & @CR & "e.g. TORD1040592755,PHX01040583939,CreateDFOrder","")
;ConsoleWrite($searchinput & @CR)

$searcharray=StringSplit($searchinput,",",2)


$line = "" ; read line by line
Local $matchArray[65535][2]
;Local $insertitem[1][2]
$linecount = 1
$aArray=0
$arraycount=0
;code for gui creation
Opt("GUIOnEventMode", 1)

GuiCreate("Tracking - " & StringTrimLeft($filename,StringLen($filename)-23), 400,230)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSE")

GUISetState (@SW_SHOW)

$editbox=GuiCtrlCreateEdit("", 5,5,390,170,$ES_MULTILINE+$ES_WANTRETURN+$ES_AUTOVSCROLL+$WS_VSCROLL+$ES_READONLY)

$slider = GuiCtrlCreateSlider(5, 195, 200)
GUICtrlSetOnEvent(-1, "SetTrans")
GUICtrlSetData (-1, 100)

GuiCtrlCreateLabel("Transparency",70,180)


Func SetTrans()

	ConsoleWrite(GuiCtrlRead($slider) & "%" & @CRLF)
    ConsoleWrite(GuiCtrlRead($slider) * 2.55 & @CRLF)
    WinSetTrans("", "", GuiCtrlRead($slider) * 2.55)

EndFunc

Func CLOSE()
    Exit 0
EndFunc

;end code for gui creation



While True
		$line = FileReadLine($filehandle)
		;ConsoleWrite($line)
		if @error = -1 Then
			ConsoleWrite("EOF")
			sleep(100)
		Else

		for $j = 0 to UBound($searcharray) - 1

				if(StringInStr($line,$searcharray[$j])) > 0 Then
					GuiCtrlsetdata($editbox,$searcharray[$j] & "  found at line  #  " & $linecount & @CRLF,1)
				EndIf
			;Next

		Next


		$linecount = $linecount+1

	EndIf


WEnd
