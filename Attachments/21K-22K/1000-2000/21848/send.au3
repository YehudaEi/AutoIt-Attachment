;///////////////////////////////////////////////////////////////////////////////
;// File:         Send.js
;//
;// Description:  This script demonstrates how to send packets
;//
;// Notes:        Run the script from command line using the cscript.exe program
;//
;// Created:      May 10, 2004
;//
;// Copyright (c) 2000-2004 BeeSync Technologies.
;///////////////////////////////////////////////////////////////////////////////

Global Const $HX_REF="0123456789ABCDEF"

;~ // Create PackeX object
Global $oPktX = ObjCreate("PktX.PacketX")
If Not IsObj($oPktX) Then MsgBox(0, "ERROR", "No Object")
$EventObject = ObjEvent($oPktX, "PacketX_")

;~ // Display network adapters
Dim $info
For $i = 1 To $oPktX.Adapters.Count
    If $oPktX.Adapters ($i).IsGood Then
        $info &= "(" & $i & ") " & $oPktX.Adapters ($i).Description & @CRLF
        PrintAdapter($oPktX.Adapters ($i))
    EndIf
Next

;Enter Adapter #
Dim $SelAdapter = $oPktX.Adapters.Count  ;default: last adapter #
While 1
    Local $SelAdapter = InputBox("Choose adapter Number", $info, $oPktX.Adapters.Count)
    If @error > 0 Then Exit 99
    If $SelAdapter >= 1 And $SelAdapter <= $oPktX.Adapters.Count Then ExitLoop
    MsgBox(0+16, "Error", "The Selected Number '"&$SelAdapter&"' is not in range")
WEnd

; Select network adapter
$oPktX.Adapter = $oPktX.Adapters ($SelAdapter)

;// Get adapter hardware address and IP address
$sHWAddr = $oPktX.Adapter.HWAddress
$sIPAddr = $oPktX.Adapter.NetIP
$sIPMask = $oPktX.Adapter.NetMask
ConsoleWrite("MAC Addr = " & $sHWAddr & @LF)
ConsoleWrite("IP  Addr = " & $sIPAddr & @LF)
ConsoleWrite("IP  Mask = " & $sIPMask & @LF)

;// Send ARP request for this IP address - ===not included in packet===
$sIPReso = "11.12.13.14"
$aIPReso=StringSplit($sIPReso, ".")
$aIPAddr=StringSplit($sIPAddr, ".")

;// You can use the following syntax to call the Adapter.SendPacket method
;//
;// 1. Send packet by reference (VT_BYREF|VT_VARIANT) as array of variants
;// oPktX.Adapter.SendPacket oPacket, 1
;//
;// 2. Send packet by value (VT_BYREF|VT_VARIANT|VT_ARRAY) as array of variants
;// oPktX.Adapter.SendPacket(oPacket)
;// 
;// 3. Send packet directly (VT_VARIANT|VT_ARRAY) as array of variants
;// oPktX.Adapter.SendPacket Array(1,2,...,n)

; packet sends "42 4D 2A 7C 68 6D 6D 7C 0A 00" (chat packet for a game called dofus) to 193.238.148.218:443 from 192.168.1.100:2534
Dim $oPacket[64] = [0x00, 0x17, 0x3F, 0x66, 0xF0, 0x90, 0x00, 0x13, 0x20, 0x9B, 0x88, 0x3C, 0x08, 0x00, 0x45, 0x00, 0x00, 0x32, 0x1C, 0x01, 0x40, 0x00, 0x80, 0x06, 0xC5, 0xEF, 0xC0, 0xA8, 0x01, 0x64, 0xC1, 0xEE, 0x94, 0xDA, 0x09, 0xE6, 0x01, 0xBB, 0xA1, 0xA4, 0x5D, 0x6B ,0x71, 0x8F, 0xE0, 0x25, 0x50, 0x18,0xFC, 0xBB, 0xF1, 0x17, 0x00, 0x00,0x42, 0x4D, 0x2A, 0x7C, 0x68, 0x6D, 0x6D, 0x7C, 0x0A, 0x00]

;write packet to console
;for $i=0 to 63
;	ConsoleWrite($oPacket[$i] & @LF)
;Next

;// Sends 1
$oPktX.Adapter.SendPacket($oPacket)

Func HexToDecimal($hx_hex)
    If StringLeft($hx_hex, 2) = "0x" Then $hx_hex = StringMid($hx_hex, 3)
    If StringIsXDigit($hx_hex) = 0 Then
        SetError(1)
        MsgBox(0,"Error","Wrong input, try again ...")
        Return ""
    EndIf
    Local $ret="", $hx_count=0, $hx_array = StringSplit($hx_hex, ""), $Ii, $hx_tmp
    For $Ii = $hx_array[0] To 1 Step -1
        $hx_tmp = StringInStr($HX_REF, $hx_array[$Ii]) - 1
        $ret += $hx_tmp * 16 ^ $hx_count
        $hx_count += 1
    Next
    Return $ret
EndFunc 


Func PrintAdapter($oAdapter)
    ConsoleWrite("Device name is " & $oAdapter.Device & @LF)
    ConsoleWrite("Link type is ")
    Switch $oAdapter.LinkType
        Case 1
            ConsoleWrite("Ethernet (802.3)" & @LF)
        Case 2
            ConsoleWrite("Token Ring (802.5)" & @LF)
        Case 3
            ConsoleWrite("FDDI" & @LF)
        Case 4
            ConsoleWrite("WAN" & @LF)
        Case 5
            ConsoleWrite("LocalTalk" & @LF)
        Case 6
            ConsoleWrite("DIX" & @LF)
        Case 7
            ConsoleWrite("ARCNET (raw)" & @LF)
        Case 8
            ConsoleWrite("ARCNET (878.2)" & @LF)
        Case 9
            ConsoleWrite("ATM" & @LF)
        Case 10
            ConsoleWrite("NdisWirelessXxx media" & @LF)
        Case Else
            ConsoleWrite("Unknown!" & @LF)
    EndSwitch
    ConsoleWrite("Link speed is " & $oAdapter.LinkSpeed & " bps" & @LF)
;~      Consolewrite( "Network IP addres is " & $oAdapter.NetIP&@LF)
;~    Consolewrite( "Network mask is " & $oAdapter.NetMask&@LF)
    ConsoleWrite("HW address is " & $oAdapter.HWAddress & @LF)
EndFunc   ;==>PrintAdapter