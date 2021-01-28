Func _GetDefaultPrinter();Original Function By Martin
    Local $result,$strComputer,$np,$colEvents
    $result = ''

    $strComputer = "."
    $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")

    $colEvents = $objWMIService.ExecQuery _
            ("Select * From Win32_Printer Where Default = TRUE");TRUE
    $np = 0

    For $objPrinter in $colEvents
        $result = $objPrinter.DeviceID
    Next

    Return $result
EndFunc
Func _PrinterSetAsDefault($PrinterName);Original Function By Martin
    Local $result, $strComputer, $colEvents, $np

    $result = 0
    $strComputer = "."
    $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
    $colEvents = $objWMIService.ExecQuery _
            (StringFormat('Select * From Win32_Printer')); Where DeviceID = "%s"', $PrinterName));TRUE
    $np = 0
    For $objPrinter in $colEvents
        If $objPrinter.DeviceID = $PrinterName Then
            $objPrinter.SetDefaultPrinter()
            $result = 1
        EndIf

    Next
    Return $result

EndFunc
func _PrintDialogWait($sPrinter="",$sPages="",$sCopies="",$sProssess="",$iTimeout=20)
	local $timer=TimerInit(), $proccess, $pid, $reqpid, $index, $title="[TITLE:Print; CLASS:#32770]"

	while 1;WAIT LOOP
		sleep(10)
		if TimerDiff($timer)>$iTimeout*1000 then return 0;Timed Out

		$pid=WinGetProcess($title)
		if $pid<>-1 then
			if $sProssess<>"" Then
				$reqpid=ProcessExists($sProssess)
				if $reqpid=0 OR $pid<>$reqpid then continueloop
			endif

			exitloop
		endif
	wend

	sleep(500)

	for $i=1 to 4;CHECK FOR UNEXPECTED WINDOW
		if StringInStr(WinGetText("[TITLE:Print; INSTANCE:"&$i&"]"),"Before you can print, you need to select a printer") then
			ControlCommand ("[TITLE:Print; INSTANCE:"&$i&"]","","[CLASS:Button; INSTANCE:1]","Check")
			sleep(1000)
			$handle=WinGetHandle($title)
		endif
	next

	if $sPrinter<>"" then;ADJ PRINTER
		for $i=1 to 80;FIND
			$index=ControlListView ($title,"","[CLASS:SysListView32; INSTANCE:1]","FindItem",$sPrinter)
			if $index<>-1 then ExitLoop
			sleep(10)
		Next
		if $i>=80 then return -7

		for $i=1 to 80;SELECT
			ControlListView ($title,"","[CLASS:SysListView32; INSTANCE:1]","Select",$index)
			if NOT @error then ExitLoop
			sleep(10)
		Next
		if $i>=40 then return -3
	endif

	if $sPages<>"" then;PAGES
		for $i=1 to 80
			ControlSetText ($title,"","[CLASS:Edit; INSTANCE:4]",$sPages)
			if NOT @error then ExitLoop
			sleep(10)
		Next
		if $i>=20 then return -4
	endif

	if $sCopies<>"" then;COPIES
		for $i=1 to 80
			ControlSetText ($title,"","[CLASS:Edit; INSTANCE:5]",$sCopies)
			if NOT @error then ExitLoop
			sleep(10)
		Next
		if $i>=20 then return -5
	endif

	sleep(500)

	for $i=1 to 80;PRESS OK
		ControlCommand ($title,"","[CLASS:Button; INSTANCE:13]","check")
		if NOT @error then ExitLoop
		sleep(10)
	Next
	if $i>=80 then return -6

	return 1
endfunc
