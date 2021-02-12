#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#NoTrayIcon


$hForm = GUICreate("Test", 350, 110,-1, -1)
GUISetBkColor(0xf8f8ff)

$m_g_group = GUICtrlCreateGroup("Select", 10, 10, 330, 70)

GUISetState()
$noFilesFound = "data2.dat"

If Not FileExists ($noFilesFound) Then
    $noFilesLbl = GUICtrlCreateLabel("No data found!", 16, 42, 318, 28, $SS_CENTER)
    GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
Else

$vSpacer = 30
$hSpacer = 30
$tasks = ''

Global $Tg_check_[100]

$TGList = IniReadSection("data2.dat","1")

Global $Tg_check_[$TGList[0][0] + 1]
    If $TGList <> '' Then
        For $i = 1 To $TGList[0][0]
			$Tg_check_[$i] = GUICtrlCreateCheckbox($TGList[$i][1], $hSpacer, $vSpacer, 50, 17) ; Save the ControlIds on the new array
			$hSpacer += 50
            If $hSpacer > 300 Then
                $vSpacer = 55
                $hSpacer = 30
            EndIf
        Next
EndIf
EndIf

$test_Button = GUICtrlCreateButton("test", 260, 85, 70, 20, $BS_ICON)
$test_Button2 = GUICtrlCreateButton("test", 150, 85, 70, 20, $BS_ICON)
GUICtrlSetState($test_Button2,$GUI_DISABLE)
;*****Here i disable the button, i need a way to activated when a checkbox is checked

While 1

    $iMsg = GUIGetMsg()

    Switch $iMsg
		
		Case $GUI_EVENT_CLOSE
            	Exit
		Case $test_Button
				_listCheck()
				
		;Case $i = 1 To $TGList[0][0]
         ;   If GUICtrlRead($Tg_check_[$i][1]) = 1 Then
         ;       GUICtrlSetState($test_Button2,$GUI_ENABLE)
		;	Else
		;		GUICtrlSetState($test_Button2,$GUI_DISABLE)
         ;   EndIf
	
	EndSwitch

WEnd




Func _listCheck()
			
$win_5 = GUICreate("Multiple File Printing...",320,200,-1,-1,$WS_BORDER)

$CtrlProgress1 = GUICtrlCreateProgress(10,10,300,20)

$CtrlProgress2 = GUICtrlCreateProgress(10,40,300,20)

$status_group = GUICtrlCreateGroup("", 10, 60, 300, 40)
GUIStartGroup("Status")
$status = GUICtrlCreateLabel("Initializating...", 20, 70, 280, 24, $SS_CENTER)
GUICtrlSetFont(-1, 14, 280, 0, "MS Sans Serif")

GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group


$status_group = GUICtrlCreateGroup("Overview ...", 10, 100, 300, 65)
GUIStartGroup("Overview")
$CtrlPhase = GUICtrlCreateLabel("Phase: waiting ...",20,115,280,20)
$CtrlMachine = GUICtrlCreateLabel("Type: waiting ...",20,130,280,20)
$CtrlFile = GUICtrlCreateLabel("File to print: waiting ...",20,145,280,20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUISetState()
GUISetState(@SW_Hide,$hForm)
GUISetState(@SW_SHOW,$win_5)
GUISwitch($win_5)				

	
    For $i = 1 To $TGList[0][0]
			If GUICtrlRead($Tg_check_[$i]) = 1 Then ; Check the checkboxes
				GUICtrlSetData($CtrlProgress1,0)
				GUICtrlSetData($status,"Generating file(s) ...")
				WinSetTitle($win_5,"","Printing check list's for: " & $TGList[$i][1])
				GUICtrlSetData($CtrlPhase,"Phase: Printing " &  " files.")
				GUICtrlSetData($CtrlMachine,"Type: " & $TGList[$i][1])
				
				GUICtrlSetData($CtrlFile,"Check list: " & "")
	
			$tasks = $TGList[$i][1]  ; Add the text from the file list
			$tasks2 = $TGList[$i][1]
			$tire = IniRead("tire_distribution.dat","TG_DISTRIB",$TGList[$i][1],"NO DATA!")
			$tire_val = IniRead("tire_tg.dat","TG_TIRE",$tire,"NO DATA!")
			

		GUICtrlSetData($CtrlProgress1,25)
		GUICtrlSetData($status,"Sending file(s) to printer ...")
		Sleep(3000)
		
		GUICtrlSetData($CtrlProgress1,50)
		GUICtrlSetData($status,"Printing file(s) ...")
		Sleep(3000)		
		;_ExcelBookClose($tg_check,1,0)
		
		GUICtrlSetData($CtrlFile,"Check list: " & "")
		GUICtrlSetData($CtrlProgress1,75)
		GUICtrlSetData($status,"Sending file(s) to printer ...")
		Sleep(3000)
		GUICtrlSetData($status,"Printing file(s) ...")
		Sleep(3000)
		GUICtrlSetData($CtrlProgress1,100)
		Sleep(3000)
			
		EndIf
		;!!!!!!!!!!!! Here i need a way to set progress bar to the current Status
		;!!!!!!!!!!!!
				;!!!!!!!!!!!! This work's when all check box are checked
			GUICtrlSetData($CtrlProgress2,(($i/$TGList[0][0])*100))
		;!!!!!!!!!!!! Here i need a way to determin the number of checkbox which are checked, insted of $TGList[0][0] 	
			
			
		Next
		
			Sleep(2000)
			GUICtrlSetData($status,"Done!")
		MsgBox(0,"Done","Done")
		
		
		
    While 1
        $msg = GUIGetMsg(1)

        Select
        Case $msg[0] = $GUI_EVENT_CLOSE
            ExitLoop(1)
        EndSelect

    WEnd
		
		
		
		GUISetState(@SW_Show, $hForm)
		GUIDelete($win_5)
		GUISwitch($hForm)
EndFunc   ;==>_listCheck

