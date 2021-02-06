; File: GenServList.au3
; Writes current list and details of services to inifile and retrieves for various uses like compare before and after.
; Released: April 12, 2010
; UDF's by: GEOSoft
; Script by: ripdad
; Version: 0.5 - April 14, 2010
;
#include <Array.au3>
;
$answer = MsgBox(36, 'GenServList', 'Generate Services List ?  ')
If $answer = 7 Then Exit
;
Global $output[1][1]
Global $input = (@ScriptDir & '\ServicesList#' & @YEAR & @MON & @MDAY & '#' & @HOUR & @MIN & @SEC & '.ini')
Global $oFile = FileOpen($input, 1)
Sleep(1000)
;
; Write service items header (1 thru 17)
$sData = '[Service]' & @CRLF & '1=System Name' & @CRLF & '2=Name' & @CRLF & _
		'3=Type' & @CRLF & '4=State' & @CRLF & '5=ExitCode' & @CRLF & _
		'6=Process ID' & @CRLF & '7=Can Pause' & @CRLF & '8=Can Stop' & @CRLF & _
		'9=Caption' & @CRLF & '10=Description' & @CRLF & '11=Interact DeskTop' & @CRLF & _
		'12=Display Name' & @CRLF & '13=Error Control' & @CRLF & '14=Exec File Path' & @CRLF & _
		'15=Started' & @CRLF & '16=Start Mode' & @CRLF & '17=Account' & @CRLF
FileWrite($oFile, $sData)
;
_ServIniList()
; Author: ripdad
; Reads Services and Details - then writes resulting data to Ini
Func _ServIniList()
	Local $count = 0
	Local $abs = _ServListInstalled()
	For $i = 1 To $abs[0]
		FileWrite($oFile, @CRLF & '[' & $abs[$i] & ']' & @CRLF)
		TrayTip('Generating Services List', $abs[$i], 1, 1)
		Local $ls = _ServGetDetails($abs[$i])
		For $j = 1 To $ls[0]
			$count += 1
			FileWrite($oFile, $count & '=' & $ls[$j] & @CRLF)
		Next
		$count = 0
	Next
	FileClose($oFile)
	TrayTip('Generating Services List', 'Done  ', 1, 1)
	Sleep(1000)
	TrayTip('', '', 1, 1)
EndFunc
;
; We have a copy of the current services/data on the hard drive.
; Now, we'll retrieve the data from the ini to use in an array.
;
_Ini2Array_Rows()
; Author: ripdad
; Works with standard ini
; Updated: April 12, 2010
Func _Ini2Array_Rows()
	Local $ct, $sn, $rs
	Local $MaxKeyCt = 0
	Local $sn_tick = 0
	$sn = IniReadSectionNames($input)
	While 1
		$sn_tick += 1
		$rs = IniReadSection($input, $sn[$sn_tick])
		If @error = 1 Then ContinueLoop
		If $rs[0][0] > $MaxKeyCt Then $MaxKeyCt = $rs[0][0]
		If $sn_tick = $sn[0] Then ExitLoop
	WEnd
	ReDim $output[$sn[0]][$MaxKeyCt + 1]
	$sn_tick = 0
	While 1
		$sn_tick += 1
		$rs = IniReadSection($input, $sn[$sn_tick])
		If @error = 1 Then
			$output[$sn_tick - 1][0] = $sn[$sn_tick]
			ContinueLoop
		EndIf
		For $ct = 1 To $rs[0][0]
			$output[$sn_tick - 1][$ct] = $rs[$ct][1]
		Next
		$output[$sn_tick - 1][0] = $sn[$sn_tick]
		If $sn_tick = $sn[0] Then ExitLoop
	WEnd
	MsgBox(64, 'GenServList', 'Total Number of Installed Services: ' & $sn[0] - 1)
	Return $output
EndFunc
;
ShellExecute($input); view the inifile
Sleep(2000)
_ArrayDisplay($output, "Result"); view the array
Exit
;
;===============================================================================
; Description:   List the currently installed services
; Syntax:   _ServListInstalled([,$Computer])
; Parameter(s):   $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Returns array with list of services
; Author(s)   GEOSoft
; Modification(s):
; Note(s):
; Example(s):
;===============================================================================
Func _ServListInstalled($Computer = ".")
	Local $Rtn = ''
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service")
	For $objService In $sItems
		$Rtn &= $objService.Name & '|'
	Next
	Return StringSplit(StringTrimRight($Rtn, 1), '|')
EndFunc
;
;===============================================================================
; Description:   Return the details of a Windows Service
; Syntax:   _ServGetDetails($iName[, $Computer])
; Parameter(s):   $iName - The name of the service to check
;                            $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Returns an array of the service details where element (-1 = Yes, 0 = No)
;                                    [1] = Computer Network Name
;                                    [2] = Service Name
;                                    [3] = Service Type (Own Process, Share Process)
;                                    [4] = Service State (Stopped, Running, Paused)
;                                    [5] = Exit Code (0, 1077)
;                                    [6] = Process ID
;                                    [7] = Can Be Paused (-1, 0)
;                                    [8] = Can Be Stopped (-1, 0)
;                                    [9] = Caption
;                                    [10] = Description
;                                    [11] = Can Interact With Desktop (-1, 0)
;                                    [12] = Display Name
;                                    [13] = Error Control (Normal, Ignore)
;                                    [14] = Executable Path Name
;                                    [15] = Service Started (-1, 0)
;                                    [16] = Start Mode (Auto, Manual, Disabled)
;                                    [17] = Account Name (LocalSystem, NT AUTHORITY\LocalService, NT AUTHORITY\NetworkService)
;                                Failure Sets @Error = -1 if service not found
; Author(s)   GEOSoft
; Modification(s):
; Note(s):
; Example(s):   $Var = _ServGetDetails("ATI Smart")
;                         $Dtl = "System Name|Name|Type|State|ExitCode|Process ID|Can Pause|Can Stop|Caption|Description|"
;                         $Dtl = StringSplit($Dtl & "Interact With DskTop|Display Name|Error Control|Exec File Path|Started|Start Mode|Account", '|')
;                         For $I = 1 To $Var[0]
;                         MsgBox(4096,$Dtl[$I], $Var[$I])
;                         Next
;===============================================================================
Func _ServGetDetails($iName, $Computer = ".")
	Local $Rtn = ''
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service")
	For $objService In $sItems
		If $objService.Name == $iName Then
			$Rtn &= $objService.SystemName & '|' & $objService.Name & '|' & $objService.ServiceType & '|' & $objService.State & '|'
			$Rtn &= $objService.ExitCode & '|' & $objService.ProcessID & '|' & $objService.AcceptPause & '|' & $objService.AcceptStop & '|'
			$Rtn &= $objService.Caption & '|' & $objService.Description & '|' & $objService.DesktopInteract & '|' & $objService.DisplayName & '|'
			$Rtn &= $objService.ErrorControl & '|' & $objService.PathName & '|' & $objService.Started & '|' & $objService.StartMode & '|'
			$Rtn &= $objService.StartName
			Return StringSplit($Rtn, '|')
		EndIf
	Next
	Return SetError(-1)
EndFunc
;