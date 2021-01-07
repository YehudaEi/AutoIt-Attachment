;Test.au3
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
;$strComputer = "localhost"
$strComputer = InputBox("Get System Name","Enter target System Name:")
$Output=""
$Output = $Output & "Computer: " & $strComputer  & @CRLF
$Output = $Output & "==========================================" & @CRLF
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Product", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

If IsObj($colItems) then
   For $objItem In $colItems

     $Output = $Output & "Name: " & $objItem.Name 
     $Output = $Output & "   Version: " & $objItem.Version & @CRLF
;  $Output = $Output & "Workgroup: " & $objItem.Workgroup @CRLF    
;  $Output = $Output & "Computer Name: " & $objItem.Name @CRLF
;  $Output = $Output & "PrimaryOwnerName: " & $objItem.UserName & @CRLF
   Next
Msgbox(1,"Installed Software -",$Output)

Else
   Msgbox(0,"WMI Output","No WMI Objects Found for class: " & "Win32_ComputerSystem" )
Endif
