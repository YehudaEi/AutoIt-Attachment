;Opt ("TrayIconHide", 1)
$PID=""
$strComputer = "."
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$Output=""
$input="0"
;*********************************************WMI OBJECT***************************************************
 $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
 $colEvents = $objWMIService.ExecNotificationQuery _
    ("Select * From __InstanceOperationEvent Within 5 Where " _
        & "TargetInstance isa 'Win32_LogicalDisk' and " _
         & "TargetInstance.DriveType = 2" )
		 sleep(500)
TestFunc1()
While 1
    $objEvent = $colEvents.NextEvent
    If $objEvent.TargetInstance.DriveType = 2 and $objEvent.TargetInstance.MediaType <>5 Then
        Select
		Case $objEvent.Path_.Class()="__InstanceCreationEvent" ;check drive inserted
			;sleep(1000)
			TestFunc1()
		Case $objEvent.Path_.Class()="__InstanceDeletionEvent" ;check drive removed
			;sleep(1000)
			TestFunc1()
	EndSelect
EndIf
WEnd
;****************************************TEST PEN DRIVE CONNECTED OR REMOVED*********************************
Func TestFunc1();wmi info
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) then
		For $objItem In $colItems
			if $objItem.DriveType ="2" and $objItem.MediaType<>"5" then
			$strPowerManagementCapabilities = $objItem.PowerManagementCapabilities(0)
			$Output = $Output & "Size: " & $objItem.Size & @CRLF
			EndIf
		Next
		$test=StringInStr($Output,"1005666304" & @CRLF,0,1); example, check if there is a inserted PEN DRIVE size=1005666304
		if $test="0" then
			BlockInput(1) ; block mouse and keyboard
		    SplashTextOn("", "plug the PenDrive", 300, 25, -1, -1, 1)
			;sleep(200)
		Else
			BlockInput(0) ; enable mouse and keyboard
			;sleep(20)
			SplashOff()
		endif
		$Output=""	
		$test=""
	Endif
EndFunc