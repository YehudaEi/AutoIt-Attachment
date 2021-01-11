#include <GUIConstants.au3>
#include <GuiListView.au3>

Opt( "GUIOnEventMode" , 1 )

Global $RefreshValue = 200
Global $GUI_ListView_Items[1] = [0]
Global $GUI_ListView_ItemsInfo[$GUI_ListView_Items[0] + 1][2] ;[0][0] = Items count || [n][0] = # , [n][1] = Full text , [n][2] = Color

Global $strComputer = "localhost"
Global $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
Global $COMBO_String = "ALL|Local|Netmgmt|icmp|egp|ggp|hello|rip|is-is|es-is|CiscoIgrp|bbnSpfIgp|ospf|bgp|Other"
Global $Filter = 'ALL'
Global $Routes_Array

$GUI = GUICreate("Routes Monitor", 489, 275, 192, 125,  BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS , $WS_BORDER) )

GUICtrlCreateLabel("Refresh:", 8, 15, 40, 15)
$GUI_Input_Refresh = GUICtrlCreateInput( $RefreshValue, 50, 13, 40 , 18 , BitOR($ES_AUTOHSCROLL,$WS_GROUP))
GUICtrlCreateLabel("ms", 92, 15 , 17, 17)

$GUI_Trancparecy = GUICtrlCreateSlider( 120 , 10 , 100 , 20 )
GUICtrlSetLimit(-1,255,100)
GUICtrlSetData( -1 , 255 )
$GUI_ON_TOP = GUICtrlCreateCheckbox( "Always on top." , 225 , 10 , 85 , 17 )

GUICtrlCreateLabel( "Filter:" , 320 , 13 , 30 , 20 )
$GUI_Filter = GUICtrlCreateCombo("", 350 , 10, 70 , 21)
GUICtrlSetData( $GUI_Filter , $COMBO_String , $Filter)
$GUI_Export = GUICtrlCreateButton("Export", 430, 8, 50, 25 , 0)

$GUI_ListView = GUICtrlCreateListView("#| Destination        | Mask                  | Gateway              | Metric|NIC Index", 0, 40, 489, 233)

Event_Set_All()

GUISetState(@SW_SHOW)
While 1
    updateRefreshValue()
   
    _wait()
   
    $Routes_Array = RoutesList_Update()
    If @error Then
        MsgBox( 16 , "Routes Monitor - Error" , "No Available interfaces." )
        Exit
    Else
        ListView_Update($Routes_Array)
    EndIf
   
WEnd

Func RoutesList_Update()
    Local $wbemFlagReturnImmediately = 0x10
    Local $wbemFlagForwardOnly = 0x20
    Local $colItems = ""
    Local $objItem
    Local $Items_count = 0
    Local $Output_Array[1][7] = [[$Items_count]]
   
    $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_IP4RouteTable", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
   
    If IsObj($colItems) then
        For $objItem In $colItems
            If ($Filter <> 'ALL') Then
                If ProtocolName($objItem.Protocol) <> $Filter Then
                    ContinueLoop
                EndIf
            EndIf
           
            $Items_count += 1
            ReDim $Output_Array[$Items_count + 1][7]
           
            $Output_Array[0][0] = $Items_count
            $Output_Array[$Items_count][0] = $Items_count ;// #
            $Output_Array[$Items_count][1] = $objItem.Destination ;//Destination
            $Output_Array[$Items_count][2] = $objItem.Mask ;// Mask
            $Output_Array[$Items_count][3] = $objItem.NextHop ;// GateWay
            $Output_Array[$Items_count][4] = $objItem.Metric1 ;//Metric1
            $Output_Array[$Items_count][5] = $objItem.InterfaceIndex ;//InterFace Index
            $Output_Array[$Items_count][6] = ProtocolName($objItem.Protocol)
        Next
       
        $Items_count = 0
        $colItems = 0
        $objItem = 0
       
       Return $Output_Array
   Else
        $Items_count = 0
        $colItems = 0
        SetError( 1 )
        Return
    Endif
   
EndFunc

Func ListView_Update($P_Array)
    Local $L_Text = ''
    Local $L_a , $L_Color
    Local $L_save = $GUI_ListView_Items[0]
   
    If $P_Array[0][0] <> $L_save Then
        If $L_save > $P_Array[0][0] Then
           
            $L_a = $L_save
           
            Do
                GUICtrlDelete( $GUI_ListView_Items[$L_a] )
                $L_a -= 1
                ReDim $GUI_ListView_Items[$L_a + 1]
                ReDim $GUI_ListView_ItemsInfo[$L_a + 1][3]
               
                $GUI_ListView_ItemsInfo[0][0] = $L_a
                $GUI_ListView_Items[0] = $L_a
            Until $GUI_ListView_Items[0] = $P_Array[0][0]
        ElseIf $L_save < $P_Array[0][0] Then
           
            $L_a = $L_save
           
            Do
                $L_a += 1
                ReDim $GUI_ListView_Items[$L_a + 1]
                ReDim $GUI_ListView_ItemsInfo[$L_a + 1][3]
               
                $GUI_ListView_Items[$L_a] = GUICtrlCreateListViewItem( '-|-|-|-|-|-' , $GUI_ListView )
               
                $GUI_ListView_Items[0] = $L_a
                $GUI_ListView_ItemsInfo[0][0] = $L_a
            Until $GUI_ListView_Items[0] = $P_Array[0][0]         
        EndIf
    EndIf
   
    For $L_a = 1 to $P_Array[0][0]
        $L_Text = $P_Array[$L_a][0] & '|' &$P_Array[$L_a][1] & '|' &$P_Array[$L_a][2] & '|' &$P_Array[$L_a][3] & '|' &$P_Array[$L_a][4] & '|' &$P_Array[$L_a][5]
       
        ;Updating the text data
        If $GUI_ListView_ItemsInfo[$L_a][1] <> $L_Text Then
            GUICtrlSetData( $GUI_ListView_Items[$L_a] , $L_Text )
            $GUI_ListView_ItemsInfo[$L_a][1] = $L_Text
        EndIf
       
        ;Getting the appropriate color
        Dim $L_Array[4] = [$P_Array[$L_a][0],$P_Array[$L_a][1] ,$P_Array[$L_a][2] ,$P_Array[$L_a][3]]
        $L_Color = ListViewItem_Color($L_Array)
       
        ;Updating the Color info
        If $GUI_ListView_ItemsInfo[$L_a][2] <> $L_Color Then
            GUICtrlSetBkColor( $GUI_ListView_Items[$L_a] , $L_Color )
            $GUI_ListView_ItemsInfo[$L_a][2] = $L_Color
        EndIf
       
    Next
   
EndFunc

Func ListViewItem_Color($P_Array)
    Local Const $GREEN_LIGHT = 0xC7FBBD
    Local Const $GREEN = 0x70ED79
    Local Const $GREEN_DARK = 0x09CC21
    Local Const $RED_LIGHT = 0xFF6464
    Local Const $RED = 0xFF5959
    Local Const $RED_DARK = 0xD70000
    Local Const $ORANGE_LIGHT = 0xFAC556
    Local Const $ORANGE = 0xEFB098
    Local Const $ORANGE_DARK = 0xC88D06
   
    Local Const $BLUE_LIGHT = 0x89B3F8
    Local Const $BLUE = 0x5783D2
    Local Const $BLUE_DARK = 0x1F59E0
   
    Local Const $DEFAULT = 0xFFFFFF
   
    Local $L_a = $P_Array[0]
    Local $L_des_ip = $P_Array[1]
    Local $L_mask = $P_Array[2]
    Local $L_GW = $P_Array[3]
   
    If (($L_des_ip == '0.0.0.0') And ($L_des_ip == $L_mask) And ($L_GW<>$L_mask)) Then ; Default Gateways will be Orange
        Return $ORANGE
    EndIf
   
    If (($L_des_ip == '255.255.255.255') And ($L_des_ip == $L_mask) And ($L_GW<>$L_mask)) Then ;NIC IP Address will be Green
        Return $GREEN
    EndIf
   
    Return $DEFAULT
EndFunc

Func ProtocolName($P_Protocol)
    Switch $P_Protocol
        Case 1
            Return 'Other'
        Case 2
            Return 'Local'
        Case 3
            Return 'Netmgmt'
        Case 4
            Return 'icmp'
        Case 5
            Return 'egp'
        Case 6
            Return 'ggp'
        Case 7
            Return 'hello'
        Case 8
            Return 'rip'
        Case 9
            Return 'is-is'
        Case 10
            Return 'es-is'
        Case 11
            Return 'CiscoIgrp'
        Case 12
            Return 'bbnSpfIgp'
        Case 13
            Return 'ospf'
        Case 14
            Return 'bgp'
    EndSwitch
EndFunc

Func Event_Set_All()
    GUISetOnEvent( -3 , "Quit" )
    GUICtrlSetOnEvent( $GUI_Input_Refresh , "updateRefreshValue" )
    GUICtrlSetOnEvent( $GUI_Filter , 'updateFilterValue' )
    GUICtrlSetOnEvent( $GUI_Export , "Export" )
    GUICtrlSetOnEvent( $GUI_ON_TOP , 'ManageOntopState' )
    GUICtrlSetOnEvent( $GUI_Trancparecy , 'ManageTranc')
EndFunc

Func _wait()
    Local $L_Timer = TimerInit()
   
    Do
        Sleep( 10 )
    Until $RefreshValue < TimerDiff( $L_Timer )
   
    $L_Timer = 0
EndFunc

Func ManageTranc()
    Local $L_Value = Int( GUICtrlRead( $GUI_Trancparecy ) )
    WinSetTrans( $GUI , '' , $L_Value )
    $L_Value = 0
EndFunc

Func ManageOntopState()
    If (BitAND(GUICtrlRead($GUI_ON_TOP), $GUI_CHECKED)) Then
        WinSetOnTop( $GUI , '', 1)
    Else
        WinSetOnTop( $GUI , '', 0)
    EndIf
EndFunc

Func Export()
    Local $LineFeed = @LF
    Local $OutPut = '#,Destination,Mask,NextHop,Metric1,InterfaceIndex' & $LineFeed
   
    $L_Path = FileSaveDialog( "What ever!" , @ScriptDir&'\' , '(*.CSV)' , 2 + 16 )
    If Not StringInStr( $L_Path , '.csv' ) Then $L_Path = $L_Path & '.csv'
    $L_open = FileOpen( $L_Path , 2 )
    If @error Then
        MsgBox( 16 , "Export Error!" , "Unable to open the file:"&@LF&$L_Path )
        Return
    EndIf
   
    If (Not @error) And ($L_Path <> '') Then
        For $L_a = 1 to $GUI_ListView_Items[0]
            $OutPut = $OutPut & StringStripCR(StringReplace( GUICtrlRead( $GUI_ListView_Items[$L_a] ) , '|' , ' , ' )) & $LineFeed
        Next
        FileWrite( $L_open , $OutPut)
        If @error Then
            MsgBox( 16 , "Export Error!" , "Unable to Write to the file:"&@LF&$L_Path&@LF&"Error:"&@error )
            Return
        EndIf
        FileClose( $L_open )
    EndIf
EndFunc

Func updateFilterValue()
    Local $L_read = GUICtrlRead( $GUI_Filter )

    If Not StringInStr( $COMBO_String , $L_read ) Then
        SetError(0)
        Return
    EndIf
   
    $Filter = $L_read
    $L_read = 0
EndFunc

Func updateRefreshValue()
    Local $L_read = GUICtrlRead( $GUI_Input_Refresh )
    $L_read = Int( $L_read )
   
    If $L_read > 0 Then
        Global $RefreshValue = $L_read
    EndIf
   $L_read = 0
    SetError(0)
EndFunc

Func Quit()
    Exit
EndFunc