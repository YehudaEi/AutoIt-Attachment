#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>


Global $TV_FIRST            = 0x1100
Global $TVM_GETNEXTITEM        = $TV_FIRST + 10
Global $TVGN_PARENT            = 0x0003
Global $TVGN_CARET            = 0x0009

Global $AppData,$AppDataRun

$Title = "- Tech Tool -"
GUICreate($Title)
$tree        = GUICtrlCreateTreeView(10,10,200,200)

$item1        = GUICtrlCreateTreeViewItem("General",$tree);####
$subitem11    = GUICtrlCreateTreeViewItem("About",$item1)
$subitem12    = GUICtrlCreateTreeViewItem("Computer",$item1)
$subitem13    = GUICtrlCreateTreeViewItem("User",$item1)
;---------------

$button        = GUICtrlCreateButton("Check",70,220,70,20)

$startlabel = GUICtrlCreateLabel($Title & @LF & "      " & @YEAR , 240, 10, 150, 80)

GUISetState()

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop

        Case $msg = $button
            GUICtrlRead($tree)
			clear()
			Option ()

		Case $msg = $subitem11
			clear()
			GUICtrlSetData($startlabel,"Stand alone tech tool which connects to often used tools, shares, and updates.")
				;Msgbox(0,"Handle",(GUICtrlRead($tree)))

		Case $msg = $subitem12
			clear()
			GUICtrlSetData($startlabel,"Name:" & @TAB & @ComputerName & @LF & "OS:" & @TAB & @OSVersion & @LF & "SP:" & @TAB & @OSServicePack)
				;Msgbox(0,"Handle",(GUICtrlRead($tree)))
;User State
		Case $msg = $subitem13
			if IsAdmin ()= 1 then
			$adCheck = " Admin Rights"
			Else
			$adCheck = "Non Admin Access"
			EndIf
			GUICtrlSetData($startlabel,"User:  " & @TAB & @UserName & @LF & "Access" & @TAB & $adCheck)
				UserVariables()
				;Msgbox(0,"Handle",(GUICtrlRead($tree)))

		;Case $msg = $AppDataRun
		;	Apptest()

    EndSelect
WEnd

;Exit

Func Option ()
		GUICtrlSetData($startlabel, $Title & @LF & "       " & @YEAR)
EndFunc

Func Clear()
			GUICtrlSetState($AppData, $GUI_HIDE)
			GUICtrlSetState($AppDataRun, $GUI_HIDE)
EndFunc

Func UserVariables()
    $AppData = GUICtrlCreateCombo("AppData", 230, 150,100)
    GUICtrlSetData(-1, "Desktop|Documents|Favorites|Programs|StartMenu|Startup|UserProfile", "AppData")
	$AppDataRun = GUICtrlCreateButton("Run", 335, 150,50,20)
EndFunc

Func Apptest()
Msgbox(0,"test","Test")
EndFunc


Func GetItemHandle($item)
    $hItem        = GUICtrlSendMsg($tree,$TVM_GETNEXTITEM,$TVGN_CARET,0)
    $hParent    = GUICtrlSendMsg($tree,$TVM_GETNEXTITEM,$TVGN_PARENT,$hItem)
    Return $hParent
EndFunc