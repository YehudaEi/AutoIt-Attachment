#include <GUIConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include<ButtonConstants.au3>
#include<EditConstants.au3>
#include<WindowsConstants.au3>

Global Const $SS_REALSIZEIMAGE = 0x0800

$Form = GUICreate(getini("Form"), getini("Width"),getini("Height"),getini("Left"), getini("Top")) ;,0x80880000)
GUISetIcon("icon.ico")

$buidl=getini("Pic")
$n=getini("Items")
$line1=getini("Line1")
$line2=getini("Line2")
$line3=getini("Line3")
$line4=getini("Line4")
$line5=getini("Line5")


dim $button[$n]
dim $hint[$n]

GUISetBkColor(0xEAE5D3)
;$Pic1 = GUICtrlCreatePic($buidl, 350, 8, 258, 164, BitOR($SS_NOTIFY,$SS_REALSIZEIMAGE,$WS_GROUP,$WS_CLIPSIBLINGS,$WS_OVERLAPPED))
;$GuiCtrlSetState(-1,$GUI_DISABLE)

$Label3 = GUICtrlCreateLabel($line1, 50, 300, 250, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label4 = GUICtrlCreateLabel($line2, 50, 320, 250, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label5 = GUICtrlCreateLabel($line3, 50, 340, 250, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label6 = GUICtrlCreateLabel($line4, 50, 360, 250, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label7 = GUICtrlCreateLabel($line5, 50, 380, 250, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

for $i=1 to $n
	$button[$i-1]=GUICtrlCreateButton(getitem($i,"AppName"),350,250+30*($i-1),250,30)
	GUICtrlSetTip(-1, getitem($i,"Hint"))
Next
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	for $i=1 to $n

		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			case $button[$i-1]
				$a=getitem($i,"Command")
				if $a="CDEnd" then exit
				shellexecute($a)
		EndSwitch
	Next
WEnd

Func getini($s)
	$g=IniRead("cdstart.ini", "CDStart", $s, "x")
	If @error Then 
		MsgBox(4096, "", "INI File Error")
	EndIf
	Return $g
EndFunc

Func getitem($i,$s)
	$g=IniRead("cdstart.ini", $i,$s,"x")
	If @error Then 
		MsgBox(4096, "", "INI File Error")
	EndIf
	Return $g
EndFunc

