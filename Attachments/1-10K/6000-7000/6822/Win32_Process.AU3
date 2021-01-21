FileDelete ( @TempDir & "\Win32_Process.TXT" )
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$strComputer = "localhost"

$Output=""
$Output = $Output & "Computer: " & $strComputer  & @CRLF
$Output = $Output & '--------------------------------------------------' & @CRLF
$Output = $Output & "==========================================" & @CRLF
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Process", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

If IsObj($colItems) then
   For $objItem In $colItems
      $Output = $Output & "Caption: " & $objItem.Caption & @CRLF
      $Output = $Output & "CommandLine: " & $objItem.CommandLine & @CRLF
      $Output = $Output & "CreationClassName: " & $objItem.CreationClassName & @CRLF
      $Output = $Output & "CreationDate: " & WMIDateStringToDate($objItem.CreationDate) & @CRLF
      $Output = $Output & "CSCreationClassName: " & $objItem.CSCreationClassName & @CRLF
      $Output = $Output & "CSName: " & $objItem.CSName & @CRLF
      $Output = $Output & "Description: " & $objItem.Description & @CRLF
      $Output = $Output & "ExecutablePath: " & $objItem.ExecutablePath & @CRLF
      $Output = $Output & "ExecutionState: " & $objItem.ExecutionState & @CRLF
      $Output = $Output & "Handle: " & $objItem.Handle & @CRLF
      $Output = $Output & "HandleCount: " & $objItem.HandleCount & @CRLF
      $Output = $Output & "InstallDate: " & WMIDateStringToDate($objItem.InstallDate) & @CRLF
      $Output = $Output & "KernelModeTime: " & $objItem.KernelModeTime & @CRLF
      $Output = $Output & "MaximumWorkingSetSize: " & $objItem.MaximumWorkingSetSize & @CRLF
      $Output = $Output & "MinimumWorkingSetSize: " & $objItem.MinimumWorkingSetSize & @CRLF
      $Output = $Output & "Name: " & $objItem.Name & @CRLF
      $Output = $Output & "OSCreationClassName: " & $objItem.OSCreationClassName & @CRLF
      $Output = $Output & "OSName: " & $objItem.OSName & @CRLF
      $Output = $Output & "OtherOperationCount: " & $objItem.OtherOperationCount & @CRLF
      $Output = $Output & "OtherTransferCount: " & $objItem.OtherTransferCount & @CRLF
      $Output = $Output & "PageFaults: " & $objItem.PageFaults & @CRLF
      $Output = $Output & "PageFileUsage: " & $objItem.PageFileUsage & @CRLF
      $Output = $Output & "ParentProcessId: " & $objItem.ParentProcessId & @CRLF
      $Output = $Output & "PeakPageFileUsage: " & $objItem.PeakPageFileUsage & @CRLF
      $Output = $Output & "PeakVirtualSize: " & $objItem.PeakVirtualSize & @CRLF
      $Output = $Output & "PeakWorkingSetSize: " & $objItem.PeakWorkingSetSize & @CRLF
      $Output = $Output & "Priority: " & $objItem.Priority & @CRLF
      $Output = $Output & "PrivatePageCount: " & $objItem.PrivatePageCount & @CRLF
      $Output = $Output & "ProcessId: " & $objItem.ProcessId & @CRLF
      $Output = $Output & "QuotaNonPagedPoolUsage: " & $objItem.QuotaNonPagedPoolUsage & @CRLF
      $Output = $Output & "QuotaPagedPoolUsage: " & $objItem.QuotaPagedPoolUsage & @CRLF
      $Output = $Output & "QuotaPeakNonPagedPoolUsage: " & $objItem.QuotaPeakNonPagedPoolUsage & @CRLF
      $Output = $Output & "QuotaPeakPagedPoolUsage: " & $objItem.QuotaPeakPagedPoolUsage & @CRLF
      $Output = $Output & "ReadOperationCount: " & $objItem.ReadOperationCount & @CRLF
      $Output = $Output & "ReadTransferCount: " & $objItem.ReadTransferCount & @CRLF
      $Output = $Output & "SessionId: " & $objItem.SessionId & @CRLF
      $Output = $Output & "Status: " & $objItem.Status & @CRLF
      $Output = $Output & "TerminationDate: " & WMIDateStringToDate($objItem.TerminationDate) & @CRLF
      $Output = $Output & "ThreadCount: " & $objItem.ThreadCount & @CRLF
      $Output = $Output & "UserModeTime: " & $objItem.UserModeTime & @CRLF
      $Output = $Output & "VirtualSize: " & $objItem.VirtualSize & @CRLF
      $Output = $Output & "WindowsVersion: " & $objItem.WindowsVersion & @CRLF
      $Output = $Output & "WorkingSetSize: " & $objItem.WorkingSetSize & @CRLF
      $Output = $Output & "WriteOperationCount: " & $objItem.WriteOperationCount & @CRLF
      $Output = $Output & "WriteTransferCount: " & $objItem.WriteTransferCount & @CRLF
      if Msgbox(1,"WMI Output",$Output) = 2 then ExitLoop
      $Output=""
   Next
Else
   Msgbox(0,"WMI Output","No WMI Objects Found for class: " & "Win32_Process" )
Endif


Func WMIDateStringToDate($dtmDate)

	Return (StringMid($dtmDate, 5, 2) & "/" & _
	StringMid($dtmDate, 7, 2) & "/" & StringLeft($dtmDate, 4) _
	& " " & StringMid($dtmDate, 9, 2) & ":" & StringMid($dtmDate, 11, 2) & ":" & StringMid($dtmDate,13, 2))
EndFunc