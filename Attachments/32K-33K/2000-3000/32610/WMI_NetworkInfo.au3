; Copied directly from AI_Scriptomatic.au3

$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$strComputer = "localhost"

$OutputTitle = ""
$Output = ""
$OutputTitle &= "Computer: " & $strComputer & @CRLF
$OutputTitle &= "==========================================" & @CRLF
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PerfRawData_Tcpip_NetworkInterface", "WQL", _
        $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

If IsObj($colItems) Then
    Local $Object_Flag = 0
    For $objItem In $colItems
        $Object_Flag = 1
        $Output &= "BytesReceivedPersec: " & $objItem.BytesReceivedPersec & @CRLF
        $Output &= "BytesSentPersec: " & $objItem.BytesSentPersec & @CRLF
        $Output &= "BytesTotalPersec: " & $objItem.BytesTotalPersec & @CRLF
        $Output &= "Caption: " & $objItem.Caption & @CRLF
        $Output &= "CurrentBandwidth: " & $objItem.CurrentBandwidth & @CRLF
        $Output &= "Description: " & $objItem.Description & @CRLF
        $Output &= "Frequency_Object: " & $objItem.Frequency_Object & @CRLF
        $Output &= "Frequency_PerfTime: " & $objItem.Frequency_PerfTime & @CRLF
        $Output &= "Frequency_Sys100NS: " & $objItem.Frequency_Sys100NS & @CRLF
        $Output &= "Name: " & $objItem.Name & @CRLF
        $Output &= "OutputQueueLength: " & $objItem.OutputQueueLength & @CRLF
        $Output &= "PacketsOutboundDiscarded: " & $objItem.PacketsOutboundDiscarded & @CRLF
        $Output &= "PacketsOutboundErrors: " & $objItem.PacketsOutboundErrors & @CRLF
        $Output &= "PacketsPersec: " & $objItem.PacketsPersec & @CRLF
        $Output &= "PacketsReceivedDiscarded: " & $objItem.PacketsReceivedDiscarded & @CRLF
        $Output &= "PacketsReceivedErrors: " & $objItem.PacketsReceivedErrors & @CRLF
        $Output &= "PacketsReceivedNonUnicastPersec: " & $objItem.PacketsReceivedNonUnicastPersec & @CRLF
        $Output &= "PacketsReceivedPersec: " & $objItem.PacketsReceivedPersec & @CRLF
        $Output &= "PacketsReceivedUnicastPersec: " & $objItem.PacketsReceivedUnicastPersec & @CRLF
        $Output &= "PacketsReceivedUnknown: " & $objItem.PacketsReceivedUnknown & @CRLF
        $Output &= "PacketsSentNonUnicastPersec: " & $objItem.PacketsSentNonUnicastPersec & @CRLF
        $Output &= "PacketsSentPersec: " & $objItem.PacketsSentPersec & @CRLF
        $Output &= "PacketsSentUnicastPersec: " & $objItem.PacketsSentUnicastPersec & @CRLF
        $Output &= "Timestamp_Object: " & $objItem.Timestamp_Object & @CRLF
        $Output &= "Timestamp_PerfTime: " & $objItem.Timestamp_PerfTime & @CRLF
        $Output &= "Timestamp_Sys100NS: " & $objItem.Timestamp_Sys100NS & @CRLF
        If MsgBox(1, "WMI Output", $Output) = 2 Then ExitLoop
        $Output = ""
    Next
    If $Object_Flag = 0 Then MsgBox(1, "WMI Output", $OutputTitle)
Else
    MsgBox(0, "WMI Output", "No WMI Objects Found for class: " & "Win32_PerfRawData_Tcpip_NetworkInterface")
EndIf
