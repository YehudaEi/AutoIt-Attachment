#include <GUIconstants.AU3>

; Example CPU load monitor using WMI
;
; 2006-01-11 SvenP
;
; Based on example VBS source code on: http://www.informit.com/articles/article.asp?p=390586&seqNum=2&rl=1
;
; Requires at least Windows XP to run (due to usage of the SWbemRefresher object)
;
; To do: Create a GUI editbox in which you can choose a different computer to monitor


$strComputer = "."		; Local computer

; Connect to WMI root
$objWMIService = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")

; Object required to periodically refresh processor performance counter.
; See also: http://windowssdk.msdn.microsoft.com/library/en-us/wmisdk/wmi/swbemrefresher.asp
$objRefresher = ObjCreate("WbemScripting.Swbemrefresher")

; Attach to processor performance counters
$objProcessor = $objRefresher.AddEnum ($objWMIService, "Win32_PerfFormattedData_PerfOS_Processor").objectSet

; Our processor load threshold.
$MaxPercent = 90

; We use a threshold for the number of times the processor is above $MaxPercent to prevent alerting on short processor 'peaks'.
$intThresholdViolations = 0

; Refresh counters
$objRefresher.Refresh


; Make a simple GUI to display processor load
GUICreate( "WMI Processor usage test", 640, 480)

$NumProcessors = $objprocessor.count - 1


; Create a nice bar-display
Dim $GUI_ProcUsage[$NumProcessors+1]

For $ProcNum = 0 To $NumProcessors

	; Some tweaking: performance counter 0 is actually the total usage of all processors
	If $ProcNum = 0 then 
		$ProcNumText = "Total" 
	else 
		$ProcNumText = $ProcNum 
	EndIf

	GUICtrlCreateLabel("Processor " & $ProcNumText & " usage:",10, 12 + $ProcNum * 30, 130, 15)
	
	$GUI_ProcUsage[$ProcNum] = GUICtrlCreateProgress(10, 10 + 20 + $ProcNum * 30, 600, 10)
Next

; Create an up/down control to change the refresh rate
					  GUICtrlCreateLabel ("Refresh Rate: ",10,150)
$GUI_UpDownInput	= GUICtrlCreateInput ("2",80,148, 40, 20)
					  GUICtrlSetLimit ( $GUI_UpDownInput, 200, 1 )	; Set a limit to the refresh rate.
$GUI_UpDown			= GUICtrlCreateUpdown($GUI_UpDownInput)
					  GUICtrlCreateLabel ("Seconds",130,150)
					  
; Create an edit box for processor load history 
					  GUICtrlCreateLabel ("History:",10,180)
$GUI_EditBox		= GUICtrlCreateEdit("",10,200,600,150)

$GUI_CloseButton	= GUICtrlCreateButton(" Close ", 300, 400)

GUISetState()       ;Show GUI

AdlibEnable( "RefreshStatistics" ,2 * 1000 )	; Start refreshing every 2 seconds

; Loop until user closes window
While 1
	
	$msg = GUIGetMsg()
	
	; Change refresh rate
	If $msg = $GUI_UpDownInput or $msg = $GUI_Updown then 
		AdLibDisable()
		AdLibEnable("RefreshStatistics",GUICtrlRead($GUI_UpDownInput)*1000)
	EndIf

	If $msg = $GUI_EVENT_CLOSE Or $msg = $GUI_CloseButton Then ExitLoop

WEnd

AdLibDisable()

GUIDelete()

$objRefresher.DeleteAll	; Remove all items from refresher


Exit


Func RefreshStatistics()

	$ProcNum = 0
	
	For $intProcessorUse In $objProcessor; For each processor in the system
		$CurrentLoad = $intProcessorUse.PercentProcessorTime   ; Grab load
		
		GUICtrlSetData($GUI_ProcUsage[$ProcNum], $CurrentLoad) ; Update GUI usage bar		

		; Some tweaking: performance counter 0 is actually the total usage of all processors
		If $ProcNum = 0 then 
			$ProcNumText = "Total" 
		else 
			$ProcNumText = $ProcNum 
		EndIf
		
		GUICtrlSetData($GUI_EditBox, @HOUR & ":" & @MIN & ":" & @SEC & " Processor " & $ProcNumText & ": " & $CurrentLoad & "%" & @CRLF,"append")
		
		If $CurrentLoad > $MaxPercent Then; Is our processor load above the given threshold?
			$intThresholdViolations = $intThresholdViolations + 1; Do not alert yet..
			If $intThresholdViolations = 10 Then; Only alert after this happened ten time successively
				$intThresholdViolations = 0; Reset threshold
				MsgBox(0, "Alert!", "Processor " & $ProcNum & " usage threshold exceeded with " & $CurrentLoad & " percent !", 5) ; Alarm !
			EndIf
		Else
			$intThresholdViolations = 0; Reset amount-threshold if CPU is back below load-threshold
		EndIf
		
		$ProcNum+=1		; For our GUI usage bar
		
	Next ; Next processor
	
	$objRefresher.Refresh; Refresh performance counters

EndFunc
