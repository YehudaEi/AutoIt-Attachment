;Opt ("TrayIconHide", 1)
$PID=""
$strComputer = "."
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$Output=""
$input="0"
;Opt("OnExitFunc", "TestFunc2")

;*********************************************WMI OBJECT***************************************************
 $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
 $colEvents = $objWMIService.ExecNotificationQuery _
    ("Select * From __InstanceOperationEvent Within 5 Where " _
        & "TargetInstance isa 'Win32_LogicalDisk' and " _
         & "TargetInstance.DriveType = 2" )
		 
		 AdlibEnable("TestFunc2"); check always if process of my application =0
While 1
	sleep(2000)
;WEnd

While 1
    $objEvent = $colEvents.NextEvent
    If $objEvent.TargetInstance.DriveType = 2 and $objEvent.TargetInstance.MediaType <>5 Then
        Select
           Case $objEvent.Path_.Class()="__InstanceCreationEvent" ;check drive inserted
			TestFunc2()
			TestFunc1()
		Case $objEvent.Path_.Class()="__InstanceDeletionEvent" ;check drive removed
			TestFunc2()
			TestFunc1()
		;case not ProcessExists("notepad.exe")
			;TestFunc2()
	EndSelect
EndIf
WEnd
WEnd

;****************************************TEST PEN DRIVE CONNECTED OR REMOVED*********************************
Func TestFunc1();wmi info
	;sleep(20)
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
			TestFunc2()
			BlockInput(1) ; block mouse and keyboard
			Msgbox(4096,"Attention","Plug the protection pen drive.", 2); 3 second delay
			;sleep(10)
			TestFunc1()
		Else
			BlockInput(0) ; enable mouse and keyboard
		endif
		$Output=""	
		$test=""
		;sleep(20)
		TestFunc2()
	Endif
EndFunc
;*************************IF MY APPLICATION NOT ACTIVE EXIT************************************
Func TestFunc2()
	;Msgbox(4096,"Attention","blabla.", 1)
	$PID =""
	$PID = ProcessExists("notepad.exe")
		If $PID = 0 Then
		BlockInput(0); enable mouse and keyboard
		exit
		endif
EndFunc