; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------
;
; Author:
; 	Malu05 aka. Mads Hagbart Lund <Batmazbaz@hotmail.com>
;
; Script Function:
; 	World Of Warcraft Packet Sniffer
;
; Notes:
; 
; 
; 
; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------
;;================================================================================
;;Includes;
;;================================================================================
#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <NomadMemory.au3>
#Include <Misc.au3>
HotKeySet("{ESC}","terminate")


;;================================================================================
;;Variable Definition;
;;================================================================================
dim $appname = "WoW Packet Sniffer"
dim $packetget, $i = 0
dim $collect_data
global $oPktX
dim $bytelength = -54
dim $timeframe
dim $valuesOwn[35]
dim $hexoffset = 256/60
dim $hexoffsetMin = 256/(60*24)
dim $number = 0
dim $transyn = 1
;;================================================================================
;;GUI Creation
;;================================================================================
Opt('MustDeclareVars', 1)
GUICreate($appname, 730, 260)
SetPrivilege("SeDebugPrivilege", 1)
;ControlS
$Button_1 = GUICtrlCreateButton ("Start Capture",  170, 230, 100)
$Button_2 = GUICtrlCreateButton ("Stop Capture",  390, 230, 100)
$Button_3 = GUICtrlCreateButton ("Clear",  280, 230, 100)
$ontop= GUICtrlCreateCheckbox ("On Top", 5, 220, 120, 18)
$trans= GUICtrlCreateCheckbox ("Transparent", 5, 240, 80, 18)
$listview = GUICtrlCreateListView ("NR|SIZE|DATA          |",8,10,713,110)
GUICtrlSetFont (-1,8, 400, "", "Lucida Console")  
_GUICtrlListView_SetColumnWidth ( $listview, 0, 27 )
_GUICtrlListView_SetColumnWidth ( $listview, 1, 39 )			
_GUICtrlListView_SetColumnWidth ( $listview, 2, 624 )
;info
$captions = GUICtrlCreateLabel ("01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34",  82, 121,700)
GUICtrlSetFont (-1,8, 400, "", "Lucida Console")  
GUICtrlSetColor(-1,0x8888888) 
GUICtrlCreateLabel("", 1, 130, 800, 3,BitOr($SS_CENTER ,$SS_SUNKEN))
GUICtrlCreateLabel("", 1, 145, 800, 3,BitOr($SS_CENTER ,$SS_SUNKEN))
GUICtrlCreateLabel("", 440, 147, 3, 80,BitOr($SS_CENTER ,$SS_SUNKEN))
$lastinput = GUICtrlCreateLabel ("last input:",  10, 135,700,10)
GUICtrlSetFont (-1,8, 400, "", "Lucida Console")  
$packetsrecived = GUICtrlCreateLabel ("Packets Recived:",  10, 150,190)
GUICtrlSetFont (-1,8, 400, "", "Lucida Console")  
;data
$timeframe = GUICtrlCreateLabel ("Timeframe:",  450, 150,400)
GUICtrlSetFont (-1,8, 400, "", "Lucida Console")  
$posX = GUICtrlCreateLabel ("PosX:",  450, 165,400)
GUICtrlSetFont (-1,8, 400, "", "Lucida Console")  
$posY = GUICtrlCreateLabel ("PosY:",  450, 180,400)
GUICtrlSetFont (-1,8, 400, "", "Lucida Console")  
$posZ = GUICtrlCreateLabel ("PosZ:",  450, 195,400)
GUICtrlSetFont (-1,8, 400, "", "Lucida Console")  
$rotation = GUICtrlCreateLabel ("Rotation:",  450, 210,400)
GUICtrlSetFont (-1,8, 400, "", "Lucida Console")  
GUISetState () 
packetget()
;;================================================================================
;;Packetget
;;================================================================================
func packetget()
While 1
$msg = GUIGetMsg()
Select
    Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $Button_1
		$packetget = 1
	Case $msg = $Button_3
		_GUICtrlListViewDeleteAllItems ( $listview )
		$number = 0
	EndSelect
		if GUICtrlRead($trans) = 4 Then
		if $transyn = 1 Then
			WinSetTrans( $appname, "", 255)
			$transyn = 0
		EndIf
	Else
		if $transyn = 0 Then
			WinSetTrans( $appname, "", 200)
			$transyn = 1
		EndIf
	EndIf	
	if GUICtrlRead($ontop) = 1 Then
		WinSetOnTop($appname, "", 1)
	Else
		WinSetOnTop($appname, "", 0)
	EndIf
if $packetget = 1 Then
	$oPktX = ObjCreate("PktX.PacketX")
	If Not IsObj($oPktX) Then MsgBox(0, "ERROR", "No Object")
		$EventObject = ObjEvent($oPktX, "PacketX_")
	For $i = 1 To $oPktX.Adapters.Count
Next
$oPktX.Adapter = $oPktX.Adapters ($oPktX.Adapters.Count)
$oPktX.Start
while $packetget = 1
    Sleep(10)
	$msg = GUIGetMsg()
	Select
    Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $Button_2
		$oPktX.stop
		$oPktX = 0
		$packetget = 0
	Case $msg = $Button_3
		_GUICtrlListViewDeleteAllItems ( $listview )
		$number = 0
	EndSelect
		if GUICtrlRead($trans) = 4 Then
		if $transyn = 1 Then
			WinSetTrans( $appname, "", 255)
			$transyn = 0
		EndIf
	Else
		if $transyn = 0 Then
			WinSetTrans( $appname, "", 200)
			$transyn = 1
		EndIf
	EndIf	
	if GUICtrlRead($ontop) = 1 Then
		WinSetOnTop($appname, "", 1)
	Else
		WinSetOnTop($appname, "", 0)
	EndIf
WEnd
EndIf
Wend
EndFunc


;;================================================================================
;;Packet Filter
;;================================================================================
Func PacketX_OnPacket($oPacket)

	For $bByte In $oPacket.Data
		$bytelength = $bytelength + 1
		if $bytelength > 0 Then
			$i = $i + 1
			if $bytelength < 35 Then
			$valuesOwn[$i] = Hex($bByte,2)
			EndIf
			$collect_data = $collect_data & Hex($bByte,2) & " "
		EndIf
    Next
	if $bytelength = 34 Then
		$number = $number + 1
			GuiCtrlCreateListViewItem($number & "|" & $bytelength & "|" & $collect_data & "|",$listview)
			GUICtrlSetData($Timeframe,"Timeframe: " & $valuesOwn[13]& " " &$valuesOwn[12]& " " &$valuesOwn[11])
			GUICtrlSetData($Rotation,"Rotation: " & $valuesOwn[27]& " " &$valuesOwn[28]& " " &$valuesOwn[29]& " " &$valuesOwn[30])
			GUICtrlSetData($PosY,"PosY: " & $valuesOwn[19]& " " &$valuesOwn[20]& " " &$valuesOwn[21]& " " &$valuesOwn[22])
			GUICtrlSetData($PosX,"PosX: " & $valuesOwn[15]& " " &$valuesOwn[16]& " " &$valuesOwn[17]& " " &$valuesOwn[18])
			GUICtrlSetData($PosZ,"PosZ: " & $valuesOwn[23]& " " &$valuesOwn[24]& " " &$valuesOwn[25]& " " &$valuesOwn[26])
			GUICtrlSetData($lastinput,"Last input: " &$collect_data)
			GUICtrlSetData($packetsrecived, "Packets Recived: " & $number)
		EndIf
		$i = 0
	$collect_data = ""
	$bytelength = -54

EndFunc  ;==>PacketX_OnPacket

;;================================================================================
;;Exit
;;================================================================================
func terminate()
    $oPktX.stop
    $oPktX = 0
    Exit
EndFunc ;==>Terminate