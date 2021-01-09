#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <NomadMemory.au3>
#Include <GuiListView.au3>

#Include <Array.au3>

#Region GuiForm1
$Gui_Form1 = GUICreate("Mr. Search", 325, 371, 237, 149)
$Open_Button = GUICtrlCreateButton("Open", 0, 0, 50, 20)
$Label1 = GUICtrlCreateLabel("Search Value:", 15, 47, 71, 17)
$Search_Input = GUICtrlCreateInput("", 15, 64, 145, 21)
$Group1 = GUICtrlCreateGroup("Data Type", 171, 40, 70, 75)
$Decimal_Radio = GUICtrlCreateRadio("Decimal", 180, 61, 55, 17)
GUICtrlSetState(-1,$GUI_CHECKED)
$Text_Radio = GUICtrlCreateRadio("Text", 180, 82, 55, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Search_Button = GUICtrlCreateButton("Search", 15, 87, 75, 25, 0)
$Cancel_Button = GUICtrlCreateButton("Cancel", 15, 87, 75, 25, 0)
GUICtrlSetState(-1, $GUI_HIDE)
$Refine_Button = GUICtrlCreateButton("Refine", 90, 87, 75, 25, 0)
GUICtrlSetState(-1, $GUI_HIDE)
$ProgressBar = GUICtrlCreateProgress(75, 3, 213, 17)
$Search_Label = GUICtrlCreateLabel("Not Attached", 147, 21, 67, 17)
$Return_ListView = GUICtrlCreateListView("Address|Value", 9, 150, 241, 204)
GUICtrlSendMsg(-1, 0x101E, 0, 100)
GUICtrlSendMsg(-1, 0x101E, 1, 100)
$Refresh_Button = GUICtrlCreateButton("Refresh", 255, 162, 54, 25, 0)
$Modify_Button = GUICtrlCreateButton("Modify", 255, 195, 57, 25, 0)
GUISetState(@SW_SHOW,$Gui_Form1)
#EndRegion

#Region Variable Dec
Global $ProcessHandle, $ValidMemory[500][2]
#EndRegion

While 1
$Msg1 = GUIGetMsg()
    Switch $Msg1
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Open_Button
            OpenProcess()
            
        Case $Search_Button
            If $ProcessHandle = 0  Then
                MsgBox(64,"Error","Select a process to search in before searching.")
            Else
                _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Return_ListView))
                GUICtrlSetState($Search_Button, $GUI_HIDE)
                GUICtrlSetState($Refine_Button, $GUI_Show)
                GUICtrlSetState($Cancel_Button, $GUI_Show)
                GUICtrlSetData($Search_Label,"Searching...")
                VirtualQuery()
                $Search_Value = GUICtrlRead($Search_Input)
;~                 $s = TimerInit()
                SearchData(ConvertToSearch($Search_Value))
;~                 MsgBox(0,"",TimerDiff($s))
                GUICtrlSetData($Search_Label,"Done")
            EndIf
            
        Case $Cancel_Button
            ResetGui()
    EndSwitch
WEnd

Func ConvertToSearch($Data_Converting);done
    Local $Hex_Value,$Hex_Trim1,$Hex_Trim2,$Hex_Trim3,$Hex_Trim4
    $DataType_Check1 = GUICtrlRead($Decimal_Radio)
    $DataType_Check2 = GUICtrlRead($Text_Radio)
    If $DataType_Check1 = $GUI_CHECKED Then
        $Hex_Value = Hex($Data_Converting);12345678
        $Hex_Trim1 = StringTrimRight($Hex_Value, 6);12
        $Hex_Trim2 = StringTrimRight(StringTrimLeft($Hex_Value,2),4);34
        $Hex_Trim3 = StringTrimRight(StringTrimLeft($Hex_Value,4),2);56
        $Hex_Trim4 = StringTrimLeft($Hex_Value,6);78
        Return $Hex_Trim4 & $Hex_Trim3 & $Hex_Trim2 & $Hex_Trim1;78563412
    ElseIf $DataType_Check2 = $GUI_CHECKED Then
        Return Hex(StringToBinary($Data_Converting))
    EndIf
EndFunc

Func OpenProcess();done
    GUISetState(@SW_DISABLE,$Gui_Form1)
    $Gui_Form2 = GUICreate("Select Process", 185, 206, 210, 127, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
    $Gui2_List = GUICtrlCreateList("", 0, 0, 181, 175)
    $Gui2_Open_Button = GUICtrlCreateButton("Open", 50, 180, 75, 21, 0)
    GUISetState(@SW_SHOW)
    
    $Gui2_ProcessList = ProcessList()
    $Gui2_String_ProcessList = $Gui2_ProcessList[1][0]
    For $Trigger = 2 to $Gui2_ProcessList[0][0]
        $Gui2_String_ProcessList = $Gui2_String_ProcessList & '|' & $Gui2_ProcessList[$Trigger][0]
    Next
    
    GuiCtrlSetData($Gui2_List , $Gui2_String_ProcessList)
    While 1
        $Msg2 = GUIGetMsg()
        Switch $Msg2
            Case $GUI_EVENT_CLOSE
                GUIDelete($Gui_Form2)
                GUISetState(@SW_ENABLE,$Gui_Form1)
                WinActivate($Gui_Form1)
                ExitLoop
            Case $Gui2_Open_Button
                $Selected_Process = GUICtrlRead($Gui2_List)
                $ProcessHandle = _MemoryOpen(ProcessExists($Selected_Process))
                WinSetTitle ( $Gui_Form1, "", "Mr. Search ("& $Selected_Process& ")")
                GUICtrlSetData($Search_Label,"Attached")
                GUIDelete($Gui_Form2)
                GUISetState(@SW_ENABLE,$Gui_Form1)
                WinActivate($Gui_Form1)
                ExitLoop
        EndSwitch
    WEnd
EndFunc

Func ResetGui();done
    GUICtrlSetState($Search_Button, $GUI_Show)
    GUICtrlSetState($Refine_Button, $GUI_HIDE)
    GUICtrlSetState($Cancel_Button, $GUI_HIDE)
    GUICtrlSetData($Search_Label,"Attached")
    GUICtrlSetData($ProgressBar, 0)
    _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Return_ListView))
EndFunc

Func SearchData($Data);i think needs more work
    $n = 0
    Do
        $n = $n + 1
        $Memory_Read = _MemoryRead($ValidMemory[4][0], $ProcessHandle, 'byte['&$ValidMemory[4][1]&']');reads  bytes
;~         $StringSplit3 = StringSplit($Memory_Read, $Data, 1)
        ControlSetText ( "yo.txt - Notepad", "", "Edit1", $Memory_Read)
;~         MsgBox(0,"",$Memory_Read )
        String_FindAll($Memory_Read,$Data)
    Until $n = $ValidMemory[0][0]
EndFunc

Func VirtualQuery();functional but rewriteable
    Local $StartMemory = 0     ;Dec(0x00000000)
    Local $EndMemory = 4294967295  ;Dec(0xFFFFFFFF)
    Local $Address, $LastAddress, $n = 0, $BaseAddress, $RegionSize, $State
    Local $Buffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
    While 1
        DllCall($ProcessHandle[0], 'int', 'VirtualQueryEx', 'int', $ProcessHandle[1], 'int', $Address, 'ptr', DllStructGetPtr($Buffer), 'int', DllStructGetSize($Buffer))
        $BaseAddress = '0x' & Hex(DllStructGetData($Buffer, 1)); + 0)
        $RegionSize = DllStructGetData($Buffer, 4)
        $Protect = Hex(DllStructGetData($Buffer, 6))
        $LastAddress = $Address
        $Address = '0x' & Hex($BaseAddress + $RegionSize)
        If $Protect = 0x04 Then; if isn't protected
            $n = $n + 1
            $ValidMemory[$n][0] = $BaseAddress;address
            $ValidMemory[$n][1] = $RegionSize; distance of good
            $ValidMemory[0][0] = $n
        EndIf
        If $BaseAddress < 0 Then
            $BaseAddress = 2147483648 + ($BaseAddress) + 2147483648
        EndIf
        If ($BaseAddress + $RegionSize) >= $EndMemory Then
            ExitLoop
        EndIf
        If $Address = $LastAddress Then
            ExitLoop
        EndIf
    WEnd
EndFunc

Func String_FindAll($String,$SearchString)
    $StringLen1 = StringLen($SearchString)
    $StringSplit = StringSplit($String, $SearchString, 1)
    $StringSplit[0] = $StringSplit[0] -1;converting to # found
    $StringSplit[1] = StringLen($StringSplit[1]) + 1
    If $StringSplit[0] <> 1 Then
        If $StringSplit[0] >= 2 Then
            $StringSplit[2] = $StringSplit[1] + (StringLen($StringSplit[2])+ $StringLen1)
            If $StringSplit[0] >= 3 Then
                For $trig = 3 to $StringSplit[0] Step 1
                    $StringSplit[$trig] = $StringSplit[$trig-1] + (StringLen($StringSplit[$trig])+ $StringLen1)
                Next
            EndIf
        EndIf
    EndIf
    Return $StringSplit
EndFunc