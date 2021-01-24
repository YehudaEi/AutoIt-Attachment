#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=Account Control.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <date.au3>
#include <File.au3>
#include <Array.au3>
#include <IE.au3>
#include <Misc.au3>

$version = "V.1.01 - Bugfix version"
Opt("TrayMenuMode",1)   ; Default tray menu items will not be shown.

TrayTip("Account Control " & $version, "Right click me for the menu.", 500, 1)
TraySetToolTip("Account Control")

Global $Timer = TimerInit(), $Check_Wait = 5 ; check all Trusted every 5 minutes ( some can close and new ones open )
Global $Accountfile = "reportfile.acrf"
Global $detected = _Date_Time_GetLocalTime()
Global $list_Hold, $list, $newfile = ""; this will be where the process name is shown!

If _Singleton(@scriptname,1) = 0 Then
    MsgBox(64, "* NOTE * ", "Account Control -  was already running  ", 5)
    Exit
EndIf


If FileExists($Accountfile) Then
    _FileReadToArray($Accountfile, $list)
Else
    If MsgBox(262193, "First Run", "Please be sure all Running Programs are Trusted and Press OK      ") <> 1 Then Exit
    TrayTip("Account Control", "Thank you", 50, 1)
	Set_List()
EndIf
;Traymenu

$menuEdit = TrayCreateItem("Editor Panel")
TrayCreateItem("")
$MenuInfo = TrayCreateItem("Information")
TrayCreateItem("")
$MenuExit = TrayCreateItem("Exit")

$Attentiongui = GUICreate("Attention - Account Control", 391, 71, @DesktopWidth - 403, @DesktopHeight - 133, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_GROUP, $WS_BORDER, $WS_CLIPSIBLINGS))
$programlable = GUICtrlCreateLabel($newfile & " was detected at " & $detected & " as a new program!", 8, 8, 391, 17)
$info1 = GUICtrlCreateLabel("Please select an option from the list below!", 8, 24, 204, 17)
$TrustDone = GUICtrlCreateButton("Add as Trusted", 5, 40, 150, 25, 0)
$UntrustDone = GUICtrlCreateButton("Add as Untrusted", 160, 40, 150, 25, 0)
$UnsureDone = GUICtrlCreateButton("Unsure", 315, 40, 70, 25, 0)
GUISetState(@SW_HIDE)

AdlibEnable("chk_Process")

While 1
   $msg = TrayGetMsg()

    Switch $msg
        Case $menuedit
            _Editgui()
        Case $MenuInfo
            _infogui()
		Case $MenuExit
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(308,"Account Control","Are you sure you wish to exit?" & @CRLF & @CRLF & "Exiting will leave your computer at risk!")
				Select
					Case $iMsgBoxAnswer = 6 ;Yes
						Exit
					Case $iMsgBoxAnswer = 7 ;No
				EndSelect
    EndSwitch
WEnd

Func chk_Process()
    $list2 = ProcessList()
    If $list2[0][0] > $list_Hold Then Return Check_List()
    $list_Hold = $list2[0][0]
    If (Int(TimerDiff($Timer)) / (1000 * 60)) >= $Check_Wait Then Check_List()
EndFunc   ;==>chk_Process

Func Set_List()
    $list2 = ProcessList()
    For $i = 1 To UBound($list2) - 1
        If StringInStr($list2[$i][0], ".exe") Then FileWriteLine($Accountfile, $list2[$i][0] & "; Trusted")
    Next
    _FileReadToArray($Accountfile, $list)
EndFunc   ;==>Set_List

Func Check_List()
    AdlibDisable()
    $list = ""
    $list2 = ProcessList()
    _FileReadToArray($Accountfile, $list)
    For $x = 1 To UBound($list2) - 1
        $found = 0
        If Not StringInStr($list2[$x][0], ".exe") Then ContinueLoop
        For $i = 1 To UBound($list) - 1
            If StringInStr($list[$i], $list2[$x][0]) Then
                If StringInStr($list[$i], "Untrusted") Then ProcessClose($list2[$x][0])
                $found = 1
                ExitLoop
            EndIf
        Next
        If Not $found Then Show_GUI($list2[$x][0])
    Next
    $list2 = ProcessList()
    $list_Hold = $list2[0][0]
    $Timer = TimerInit()
    AdlibEnable("chk_Process")
EndFunc   ;==>Check_List

Func Show_GUI($addnewfile = "")
    $newfile = $addnewfile
    GUISetState(@SW_SHOW, $Attentiongui)
    $detected = _NowCalc();_Date_Time_GetLocalTime()
    GUICtrlSetData($programlable, $newfile & " was detected at " & $detected & " as a new program!")

    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
			GUIDelete($EDITGUI)
				
            Case $TrustDone
                GUISetState(@SW_HIDE, $Attentiongui)
				FileWriteLine($Accountfile, $newfile & "; Trusted")
				TrayTip("Account Control", "Thank you", 50, 1)
				ExitLoop
				
			Case $UntrustDone
                GUISetState(@SW_HIDE, $Attentiongui)
				FileWriteLine($Accountfile, $newfile & "; UnTrusted")
				TrayTip("Account Control", "Thank you", 50, 1)
                ExitLoop
				
			Case $UnsureDone
				_IECreate("http://www.processlibrary.com/search/?q=" & $newfile)
        EndSwitch
    WEnd
EndFunc   ;==>Show_GUI



Func _Editgui()
$file = FileRead("reportfile.acrf")

#Region ### START Koda GUI section ### Form=
$EDITGUI = GUICreate("Account Control - Editor", 561, 402, 193, 125)
$Editbox = GUICtrlCreateEdit("", 8, 32, 546, 342)
GUICtrlSetData($Editbox , $file)
$Label1 = GUICtrlCreateLabel("The Account Control, Editor Panel has been designed so that you may change an option if you change your mind.", 8, 8, 545, 17)
$Savebut = GUICtrlCreateButton("Save", 8, 376, 131, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($EDITGUI)
			ExitLoop
		Case $Savebut
			FileDelete("reportfile.acrf")
			FileWrite("reportfile.acrf", GUICtrlRead($Editbox))
	EndSwitch
WEnd	
EndFunc


Func _infogui()
	
$infogui = GUICreate("Account Control - Infomation panel", 618, 198, 193, 125)
$Group1 = GUICtrlCreateGroup("Editor Panel:", 8, 8, 601, 89)
$Label1 = GUICtrlCreateLabel("The Editor Panel has been designed so that you can use this program with ease. If you change you mind about a program", 16, 24, 582, 17)
$Label2 = GUICtrlCreateLabel("you can simply edit the option that you originaly picked.", 16, 40, 263, 17)
$Label3 = GUICtrlCreateLabel("To open the Editor Panel click the option Editor Panel in the menu.", 16, 72, 400, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("About Account Control:", 8, 112, 601, 73)
$Label5 = GUICtrlCreateLabel("", 16, 144, 4, 4)
$Label4 = GUICtrlCreateLabel("Original Idea came from Ashley's attempt and Windows Vista's built-in User Account Control", 16, 128, 452, 17)
$Label6 = GUICtrlCreateLabel("Many thanks to everybody that has help me develop this.", 16, 144, 273, 17)
$Label7 = GUICtrlCreateLabel("Made in Autoit v3", 16, 160, 87, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($infogui)
			ExitLoop
	EndSwitch
WEnd

EndFunc
