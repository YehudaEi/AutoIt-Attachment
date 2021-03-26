#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=images.ico
#AutoIt3Wrapper_Outfile=HotKeys.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
if _Singleton("HotKeys",1) = 0 Then
    Msgbox(0,"Error","Hotkeys already running")
    Exit
	EndIf
Dim $alt1,$alt2,$alt3,$alt4,$alt5,$alt6,$alt7,$alt8,$alt9,$alt10,$hk1,$hk2,$hk3,$hk4,$hk5,$hk,$hk6,$hk7,$hk8,$hk9,$hk10,$ex1,$ex2,$ex3,$ex4,$ex5,$ex6,$ex7,$ex8,$ex9,$ex10,$ctrl1,$ctrl2,$ctrl3,$ctrl4,$ctrl5,$ctrl6,$ctrl7,$ctrl8,$ctrl9,$ctrl10,$alt1,$alt2,$alt3,$alt4,$alt5,$alt6,$alt7,$alt8,$alt9,$alt10,$hkk1,$hkk2,$hkk3,$hkk4,$hkk5,$hkk6,$hkk7,$hkk8,$hkk9,$hkk10,$shift1,$shift2,$shift3,$shift4,$shift5,$shift6,$shift7,$shift8,$shift9,$shift10
$Form1 = GUICreate("Hotkeys", 578, 372, 190, 147)
$altbox1 = GUICtrlCreateCheckbox("Alt", 55, 20, 33, 17)
$shiftbox1 = GUICtrlCreateCheckbox("Shift", 90, 20, 49, 17)
$ctrlbox1 = GUICtrlCreateCheckbox("Ctrl", 15, 20, 33, 17)
$hotinput1 = GUICtrlCreateInput("", 140, 20, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput1 = GUICtrlCreateInput("", 190, 20, 297, 21)
$browse1 = GUICtrlCreateButton("Browse", 500, 20, 57, 25)
$altbox2 = GUICtrlCreateCheckbox("Alt", 55, 50, 33, 17)
$shiftbox2 = GUICtrlCreateCheckbox("Shift", 90, 50, 49, 17)
$ctrlbox2 = GUICtrlCreateCheckbox("Ctrl", 15, 50, 33, 17)
$hotinput2 = GUICtrlCreateInput("", 140, 50, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput2 = GUICtrlCreateInput("", 190, 50, 297, 21)
$browse2 = GUICtrlCreateButton("Browse", 500, 50, 57, 25)
$altbox3 = GUICtrlCreateCheckbox("Alt", 55, 80, 33, 17)
$shiftbox3 = GUICtrlCreateCheckbox("Shift", 90, 80, 49, 17)
$ctrlbox3 = GUICtrlCreateCheckbox("Ctrl", 15, 80, 33, 17)
$hotinput3 = GUICtrlCreateInput("", 140, 80, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput3 = GUICtrlCreateInput("", 190, 80, 297, 21)
$browse3 = GUICtrlCreateButton("Browse", 500, 80, 57, 25)
$altbox4 = GUICtrlCreateCheckbox("Alt", 55, 110, 33, 17)
$shiftbox4 = GUICtrlCreateCheckbox("Shift", 90, 110, 49, 17)
$ctrlbox4 = GUICtrlCreateCheckbox("Ctrl", 15, 110, 33, 17)
$hotinput4 = GUICtrlCreateInput("", 140, 110, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput4 = GUICtrlCreateInput("", 190, 110, 297, 21)
$browse4 = GUICtrlCreateButton("Browse", 500, 110, 57, 25)
$altbox5 = GUICtrlCreateCheckbox("Alt", 55, 140, 33, 17)
$shiftbox5 = GUICtrlCreateCheckbox("Shift", 90, 140, 49, 17)
$ctrlbox5 = GUICtrlCreateCheckbox("Ctrl", 15, 140, 33, 17)
$hotinput5 = GUICtrlCreateInput("", 140, 140, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput5 = GUICtrlCreateInput("", 190, 140, 297, 21)
$browse5 = GUICtrlCreateButton("Browse", 500, 140, 57, 25)
$altbox7 = GUICtrlCreateCheckbox("Alt", 55, 200, 33, 17)
$shiftbox7 = GUICtrlCreateCheckbox("Shift", 90, 200, 49, 17)
$ctrlbox7 = GUICtrlCreateCheckbox("Ctrl", 15, 200, 33, 17)
$hotinput7 = GUICtrlCreateInput("", 140, 200, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput7 = GUICtrlCreateInput("", 190, 200, 297, 21)
$browse7 = GUICtrlCreateButton("Browse", 500, 200, 57, 25)
$altbox6 = GUICtrlCreateCheckbox("Alt", 55, 170, 33, 17)
$shiftbox6 = GUICtrlCreateCheckbox("Shift", 90, 170, 49, 17)
$ctrlbox6 = GUICtrlCreateCheckbox("Ctrl", 15, 170, 33, 17)
$hotinput6 = GUICtrlCreateInput("", 140, 170, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput6 = GUICtrlCreateInput("", 190, 170, 297, 21)
$browse6 = GUICtrlCreateButton("Browse", 500, 170, 57, 25)
$altbox8 = GUICtrlCreateCheckbox("Alt", 55, 230, 33, 17)
$shiftbox8 = GUICtrlCreateCheckbox("Shift", 90, 230, 49, 17)
$ctrlbox8 = GUICtrlCreateCheckbox("Ctrl", 15, 230, 33, 17)
$hotinput8 = GUICtrlCreateInput("", 140, 230, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput8 = GUICtrlCreateInput("", 190, 230, 297, 21)
$browse8 = GUICtrlCreateButton("Browse", 500, 230, 57, 25)
$altbox9 = GUICtrlCreateCheckbox("Alt", 55, 260, 33, 17)
$shiftbox9 = GUICtrlCreateCheckbox("Shift", 90, 260, 49, 17)
$ctrlbox9 = GUICtrlCreateCheckbox("Ctrl", 15, 260, 33, 17)
$hotinput9 = GUICtrlCreateInput("", 140, 260, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput9 = GUICtrlCreateInput("", 190, 260, 297, 21)
$browse9 = GUICtrlCreateButton("Browse", 500, 260, 57, 25)
$altbox10 = GUICtrlCreateCheckbox("Alt", 55, 290, 33, 17)
$shiftbox10 = GUICtrlCreateCheckbox("Shift", 90, 290, 49, 17)
$ctrlbox10 = GUICtrlCreateCheckbox("Ctrl", 15, 290, 33, 17)
$hotinput10 = GUICtrlCreateInput("", 140, 290, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit(-1, 1)
$exeinput10 = GUICtrlCreateInput("", 190, 290, 297, 21)
$browse10 = GUICtrlCreateButton("Browse", 500, 290, 57, 25)
$Applybtn = GUICtrlCreateButton("Apply", 484, 330, 73, 25)


Opt("TrayMenuMode", 3)
Local $editini =TrayCreateItem("Edit Hotkeys")
;local $reload = TrayCreateItem("ReRead Hotkeys")
TrayCreateItem("")
Local $aboutitem = TrayCreateItem("About")
TrayCreateItem("")
Local $exititem = TrayCreateItem("Exit")
TraySetState()

readinis()
sethotkeys()



While 1
    Local $msg = TrayGetMsg()
	Local $nMsg = GUIGetMsg()
    Select
        Case $msg = $aboutitem
            MsgBox(64, "About:", "Hotkeys by siklosi@gmail.com")
        Case $msg = $exititem
            ExitLoop
		Case $msg = $editini
			GUISetState(@SW_SHOW)
			unsethotkeys()
			ReadHotGui()

	EndSelect


	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			readinis()
			sethotkeys()
			GUISetState(@SW_HIDE)
		Case $Applybtn
			readbtnstates()
			writeinis()
			readinis()
			sethotkeys()
			GUISetState(@SW_HIDE)
		Case $browse1
			$ex1 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput1,$ex1)
					Case $browse2
			$ex2 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput2,$ex2)
					Case $browse3
			$ex3 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput3,$ex3)
					Case $browse4
			$ex4 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput4,$ex4)
					Case $browse5
			$ex5 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput5,$ex5)
					Case $browse6
			$ex6 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput6,$ex6)
					Case $browse7
			$ex7 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput7,$ex7)
					Case $browse8
			$ex8 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput8,$ex8)
					Case $browse9
			$ex9 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput9,$ex9)
					Case $browse10
			$ex10 = FileOpenDialog("Select program",@ProgramFilesDir&"\","Programs (*.exe;*.msc)")
			GUICtrlSetData($exeinput10,$ex10)
	EndSwitch

WEnd

Exit

func readbtnstates()
$alt1=GUICtrlRead($altbox1)
$alt2=GUICtrlRead($altbox2)
$alt3=GUICtrlRead($altbox3)
$alt4=GUICtrlRead($altbox4)
$alt5=GUICtrlRead($altbox5)
$alt6=GUICtrlRead($altbox6)
$alt7=GUICtrlRead($altbox7)
$alt8=GUICtrlRead($altbox8)
$alt9=GUICtrlRead($altbox9)
$alt10=GUICtrlRead($altbox10)
$shift1=GUICtrlRead($shiftbox1)
$shift2=GUICtrlRead($shiftbox2)
$shift3=GUICtrlRead($shiftbox3)
$shift4=GUICtrlRead($shiftbox4)
$shift5=GUICtrlRead($shiftbox5)
$shift6=GUICtrlRead($shiftbox6)
$shift7=GUICtrlRead($shiftbox7)
$shift8=GUICtrlRead($shiftbox8)
$shift9=GUICtrlRead($shiftbox9)
$shift10=GUICtrlRead($shiftbox10)
$ctrl1=GUICtrlRead($ctrlbox1)
$ctrl2=GUICtrlRead($ctrlbox2)
$ctrl3=GUICtrlRead($ctrlbox3)
$ctrl4=GUICtrlRead($ctrlbox4)
$ctrl5=GUICtrlRead($ctrlbox5)
$ctrl6=GUICtrlRead($ctrlbox6)
$ctrl7=GUICtrlRead($ctrlbox7)
$ctrl8=GUICtrlRead($ctrlbox8)
$ctrl9=GUICtrlRead($ctrlbox9)
$ctrl10=GUICtrlRead($ctrlbox10)
$ex1 = GUICtrlRead($exeinput1)
$ex2 = GUICtrlRead($exeinput2)
$ex3 = GUICtrlRead($exeinput3)
$ex4 = GUICtrlRead($exeinput4)
$ex5 = GUICtrlRead($exeinput5)
$ex6 = GUICtrlRead($exeinput6)
$ex7 = GUICtrlRead($exeinput7)
$ex8 = GUICtrlRead($exeinput8)
$ex9 = GUICtrlRead($exeinput9)
$ex10 = GUICtrlRead($exeinput10)
$hk1=GUICtrlRead($hotinput1)
$hk2=GUICtrlRead($hotinput2)
$hk3=GUICtrlRead($hotinput3)
$hk4=GUICtrlRead($hotinput4)
$hk5=GUICtrlRead($hotinput5)
$hk6=GUICtrlRead($hotinput6)
$hk7=GUICtrlRead($hotinput7)
$hk8=GUICtrlRead($hotinput8)
$hk9=GUICtrlRead($hotinput9)
$hk10=GUICtrlRead($hotinput10)
EndFunc

func writeinis()
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk1", $hk1)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk2", $hk2)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk3", $hk3)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk4", $hk4)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk5", $hk5)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk6", $hk6)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk7", $hk7)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk8", $hk8)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk9", $hk9)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk10", $hk10)

IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex1", $ex1)
IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex2", $ex2)
IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex3", $ex3)
IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex4", $ex4)
IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex5", $ex5)
IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex6", $ex6)
IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex7", $ex7)
IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex8", $ex8)
IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex9", $ex9)
IniWrite(@ScriptDir & "\hotkeys.ini", "Execute", "ex10", $ex10)

IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt1", $alt1)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt2", $alt2)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt3", $alt3)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt4", $alt4)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt5", $alt5)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt6", $alt6)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt7", $alt7)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt8", $alt8)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt9", $alt9)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt10", $alt10)

IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift1", $shift1)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift2", $shift2)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift3", $shift3)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift4", $shift4)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift5", $shift5)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift6", $shift6)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift7", $shift7)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift8", $shift8)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift9", $shift9)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift10", $shift10)

IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl1", $ctrl1)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl2", $ctrl2)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl3", $ctrl3)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl4", $ctrl4)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl5", $ctrl5)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl6", $ctrl6)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl7", $ctrl7)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl8", $ctrl8)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl9", $ctrl9)
IniWrite(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl10", $ctrl10)
EndFunc


Func ReadHotGui()

GUICtrlSetData($hotinput1,$hk1)
GUICtrlSetData($hotinput2,$hk2)
GUICtrlSetData($hotinput3,$hk3)
GUICtrlSetData($hotinput4,$hk4)
GUICtrlSetData($hotinput5,$hk5)
GUICtrlSetData($hotinput6,$hk6)
GUICtrlSetData($hotinput7,$hk7)
GUICtrlSetData($hotinput8,$hk8)
GUICtrlSetData($hotinput9,$hk9)
GUICtrlSetData($hotinput10,$hk10)

GUICtrlSetData($exeinput1,$ex1)
GUICtrlSetData($exeinput2,$ex2)
GUICtrlSetData($exeinput3,$ex3)
GUICtrlSetData($exeinput4,$ex4)
GUICtrlSetData($exeinput5,$ex5)
GUICtrlSetData($exeinput6,$ex6)
GUICtrlSetData($exeinput7,$ex7)
GUICtrlSetData($exeinput8,$ex8)
GUICtrlSetData($exeinput9,$ex9)
GUICtrlSetData($exeinput10,$ex10)

GUICtrlSetState($altbox1,$alt1)
GUICtrlSetState($altbox2,$alt2)
GUICtrlSetState($altbox3,$alt3)
GUICtrlSetState($altbox4,$alt4)
GUICtrlSetState($altbox5,$alt5)
GUICtrlSetState($altbox6,$alt6)
GUICtrlSetState($altbox7,$alt7)
GUICtrlSetState($altbox8,$alt8)
GUICtrlSetState($altbox9,$alt9)
GUICtrlSetState($altbox10,$alt10)

GUICtrlSetState($ctrlbox1,$ctrl1)
GUICtrlSetState($ctrlbox2,$ctrl2)
GUICtrlSetState($ctrlbox3,$ctrl3)
GUICtrlSetState($ctrlbox4,$ctrl4)
GUICtrlSetState($ctrlbox5,$ctrl5)
GUICtrlSetState($ctrlbox6,$ctrl6)
GUICtrlSetState($ctrlbox7,$ctrl7)
GUICtrlSetState($ctrlbox8,$ctrl8)
GUICtrlSetState($ctrlbox9,$ctrl9)
GUICtrlSetState($ctrlbox10,$ctrl10)

GUICtrlSetState($shiftbox1,$shift1)
GUICtrlSetState($shiftbox2,$shift2)
GUICtrlSetState($shiftbox3,$shift3)
GUICtrlSetState($shiftbox4,$shift4)
GUICtrlSetState($shiftbox5,$shift5)
GUICtrlSetState($shiftbox6,$shift6)
GUICtrlSetState($shiftbox7,$shift7)
GUICtrlSetState($shiftbox8,$shift8)
GUICtrlSetState($shiftbox9,$shift9)
GUICtrlSetState($shiftbox10,$shift10)


EndFunc

func readinis()
$hk1 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk1", "")
$hk2 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk2", "")
$hk3 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk3", "")
$hk4 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk4", "")
$hk5 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk5", "")
$hk6 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk6", "")
$hk7 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk7", "")
$hk8 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk8", "")
$hk9 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk9", "")
$hk10 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "hk10", "")

$ctrl1 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl1", "")
$ctrl2 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl2", "")
$ctrl3 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl3", "")
$ctrl4 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl4", "")
$ctrl5 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl5", "")
$ctrl6 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl6", "")
$ctrl7 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl7", "")
$ctrl8 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl8", "")
$ctrl9 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl9", "")
$ctrl10 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "ctrl10", "")

$alt1 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt1", "")
$alt2 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt2", "")
$alt3 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt3", "")
$alt4 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt4", "")
$alt5 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt5", "")
$alt6 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt6", "")
$alt7 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt7", "")
$alt8 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt8", "")
$alt9 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt9", "")
$alt10 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "alt10", "")

$shift1 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift1", "")
$shift2 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift2", "")
$shift3 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift3", "")
$shift4 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift4", "")
$shift5 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift5", "")
$shift6 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift6", "")
$shift7 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift7", "")
$shift8 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift8", "")
$shift9 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift9", "")
$shift10 = IniRead(@ScriptDir & "\hotkeys.ini", "HotKeys", "shift10", "")

$ex1 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex1", "")
$ex2 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex2", "")
$ex3 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex3", "")
$ex4 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex4", "")
$ex5 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex5", "")
$ex6 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex6", "")
$ex7 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex7", "")
$ex8 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex8", "")
$ex9 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex9", "")
$ex10 = IniRead(@ScriptDir & "\hotkeys.ini", "Execute", "ex10", "")
$hkk1=$hk1
$hkk2=$hk2
$hkk3=$hk3
$hkk4=$hk4
$hkk5=$hk5
$hkk6=$hk6
$hkk7=$hk7
$hkk8=$hk8
$hkk9=$hk9
$hkk10=$hk10

if $alt1 = 1 then $hkk1 = "!" & $hkk1
if $alt2 = 1 then $hkk2 = "!" & $hkk2
if $alt3 = 1 then $hkk3 = "!" & $hkk3
if $alt4 = 1 then $hkk4 = "!" & $hkk4
if $alt5 = 1 then $hkk5 = "!" & $hkk5
if $alt6 = 1 then $hkk6 = "!" & $hkk6
if $alt7 = 1 then $hkk7 = "!" & $hkk7
if $alt8 = 1 then $hkk8 = "!" & $hkk8
if $alt9 = 1 then $hkk9 = "!" & $hkk9
if $alt10 = 1 then $hkk10 = "!" & $hkk10
if $shift1 = 1 then $hkk1 = "+" & $hkk1
if $shift2 = 1 then $hkk2 = "+" & $hkk2
if $shift3 = 1 then $hkk3 = "+" & $hkk3
if $shift4 = 1 then $hkk4 = "+" & $hkk4
if $shift5 = 1 then $hkk5 = "+" & $hkk5
if $shift6 = 1 then $hkk6 = "+" & $hkk6
if $shift7 = 1 then $hkk7 = "+" & $hkk7
if $shift8 = 1 then $hkk8 = "+" & $hkk8
if $shift9 = 1 then $hkk9 = "+" & $hkk9
if $shift10 = 1 then $hkk10 = "+" & $hkk10
if $ctrl1 = 1 then $hkk1 = "^" & $hkk1
if $ctrl2 = 1 then $hkk2 = "^" & $hkk2
if $ctrl3 = 1 then $hkk3 = "^" & $hkk3
if $ctrl4 = 1 then $hkk4 = "^" & $hkk4
if $ctrl5 = 1 then $hkk5 = "^" & $hkk5
if $ctrl6 = 1 then $hkk6 = "^" & $hkk6
if $ctrl7 = 1 then $hkk7 = "^" & $hkk7
if $ctrl8 = 1 then $hkk8 = "^" & $hkk8
if $ctrl9 = 1 then $hkk9 = "^" & $hkk9
if $ctrl10 = 1 then $hkk10 = "^" & $hkk10
EndFunc

func sethotkeys()
If $hk1 > "" Then HotKeySet($hkk1, "func1")
If $hk2 > "" Then HotKeySet($hkk2, "func2")
If $hk3 > "" Then HotKeySet($hkk3, "func3")
If $hk4 > "" Then HotKeySet($hkk4, "func4")
If $hk5 > "" Then HotKeySet($hkk5, "func5")
If $hk6 > "" Then HotKeySet($hkk6, "func6")
If $hk7 > "" Then HotKeySet($hkk7, "func7")
If $hk8 > "" Then HotKeySet($hkk8, "func8")
If $hk9 > "" Then HotKeySet($hkk9, "func9")
If $hk10 > "" Then HotKeySet($hkk10, "func10")
EndFunc

func unsethotkeys()
HotKeySet($hkk1)
HotKeySet($hkk2)
HotKeySet($hkk3)
HotKeySet($hkk4)
HotKeySet($hkk5)
HotKeySet($hkk6)
HotKeySet($hkk7)
HotKeySet($hkk8)
HotKeySet($hkk9)
HotKeySet($hkk10)
EndFunc

Func func1()
	$spex1=StringSplit($ex1,"\")
	$dex1=""
	for $i= 1 to $spex1[0]-1
		$dex1=$dex1 & $spex1[$i] & "\"
	Next
	If $ex1 > "" Then ShellExecute($ex1,"",$dex1)
EndFunc

Func func2()
	$spex2=StringSplit($ex2,"\")
	$dex2=""
	for $i= 1 to $spex2[0]-1
		$dex2=$dex2 & $spex2[$i] & "\"
	Next
	If $ex2 > "" Then ShellExecute($ex2,"",$dex2)
EndFunc

Func func3()
	ConsoleWrite("ACK")
	$spex3=StringSplit($ex3,"\")
	$dex3=""
	for $i= 1 to $spex3[0]-1
		$dex3=$dex3 & $spex3[$i] & "\"
	Next
	If $ex3 > "" Then ShellExecute($ex3,"",$dex3)
EndFunc

Func func4()
	$spex4=StringSplit($ex4,"\")
	$dex4=""
	for $i= 1 to $spex4[0]-1
		$dex4=$dex4 & $spex4[$i] & "\"
	Next
	If $ex4 > "" Then ShellExecute($ex4,"",$dex4)
EndFunc

Func func5()
	$spex5=StringSplit($ex5,"\")
	$dex5=""
	for $i= 1 to $spex5[0]-1
		$dex5=$dex5 & $spex5[$i] & "\"
	Next
	If $ex5 > "" Then ShellExecute($ex5,"",$dex5)
EndFunc

Func func6()
	$spex6=StringSplit($ex6,"\")
	$dex6=""
	for $i= 1 to $spex6[0]-1
		$dex6=$dex6 & $spex6[$i] & "\"
	Next
	If $ex6 > "" Then ShellExecute($ex6,"",$dex6)
EndFunc

Func func7()
	$spex7=StringSplit($ex7,"\")
	$dex7=""
	for $i= 1 to $spex7[0]-1
		$dex7=$dex7 & $spex7[$i] & "\"
	Next
	If $ex7 > "" Then ShellExecute($ex7,"",$dex7)
EndFunc

Func func8()
	$spex8=StringSplit($ex8,"\")
	$dex8=""
	for $i= 1 to $spex8[0]-1
		$dex8=$dex8 & $spex8[$i] & "\"
	Next
	If $ex8 > "" Then ShellExecute($ex8,"",$dex8)
EndFunc

Func func9()
	$spex9=StringSplit($ex9,"\")
	$dex9=""
	for $i= 1 to $spex9[0]-1
		$dex9=$dex9 & $spex9[$i] & "\"
	Next
	If $ex9 > "" Then ShellExecute($ex9,"",$dex9)
EndFunc

Func func10()
	$spex10=StringSplit($ex10,"\")
	$dex10=""
	for $i= 1 to $spex10[0]-1
		$dex10=$dex10 & $spex10[$i] & "\"
	Next
	If $ex10 > "" Then ShellExecute($ex10,"",$dex10)
EndFunc



