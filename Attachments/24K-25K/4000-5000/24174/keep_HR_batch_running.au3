#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WinAPI.au3>
#include <StaticConstants.au3>
#include <Constants.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>


Global $gwhMain ;window handle of excel / run batch window
Const $in_seconds = 1000 ;give time to sleep as <num of seconds> * $in_seconds

Const $BatchActiveFlagFile = "c:\homerun\batchactive.tmp" ;HR batch semaphore file

Opt('MustDeclareVars', 1)
Opt("WinTitleMatchMode", -2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=No Case

Func StartRunBatch()
	Local $ok, $i
	Local $proc
	Local $windows ; 2D array of window titles/handles
	Local $gHrBatchPid

	FileDelete($BatchActiveFlagFile)

	$gHrBatchPid = Run('C:\excel95\EXCEL.EXE  "c:\homerun\run batch of audits v9.xls"') ;assuming this is where it is installed.  I can find but can't seem to get desktop shortcuts to execute....
	Sleep(0.25 * $in_seconds)
	Send("{ENTER}") ;initial dialog box in excel
	Sleep(0.25 * $in_seconds)
	If @error <> 0 Then
		MsgBox(0, "autoit run HR batch", "Could not start BAtch run utility")
		Exit
	EndIf

	;'$ok = WinWaitActive("","run batch of audits",20)
	;If Not $ok Then
	;	msgbox(0,"autoit run HR batch", "Timed out waiting for hr batch to activate" )
	;EndIf

	; get the window handle for the process
	$gwhMain = ''
	$windows = WinList()
	For $i = 1 To $windows[0][0]
		If IsWindowVisible($windows[$i][1]) Then
			$proc = WinGetProcess($windows[$i][1])
			;msgbox(0,"debug", $i & ' winlist: 0=' & $windows[$i][0] & ' 1='&  $windows[$i][1])
			If $proc == $gHrBatchPid Then
				$gwhMain = $windows[$i][1]
				ExitLoop
			EndIf
		EndIf
	Next

	If $gwhMain == '' Then
		MsgBox(0, "autoit run HR batch", "Could not get handle for main batch window ????")
		Exit
	EndIf
	MsgBox(0, "debug", "Found the correct handle. it is " & $gwhMain)
EndFunc   ;==>StartRunBatch


Func IsWindowVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsWindowVisible


Func WaitForBatchtoStart()
	Do
		Sleep(1 * $in_seconds)
	Until FileExists($BatchActiveFlagFile)
	MsgBox(0, "debug", "Batch has started", 5)
EndFunc   ;==>WaitForBatchtoStart


Func Keep_Batch_active()
	Local $hwnd, $pos
	Local $lab, $lab2

	$hwnd = GUICreate("title", 500, 500, 5, 5)
	$pos = WinGetPos($hwnd)
	_WinAPI_SetWindowPos($hwnd, $HWND_BOTTOM, $pos[0], $pos[1], $pos[2], $pos[3], BitOR($SWP_SHOWWINDOW, $SWP_NOACTIVATE, $WS_EX_TOPMOST))

	$lab = GUICtrlCreateLabel('Keeping Batch Active ' & Chr(13) & 'Keeping Batch Active ' & Chr(13) & 'Keeping Batch Active ', 5, 5)

	Do
		WinActivate($gwhMain)
		Sleep(5 * $in_seconds) ;check often to make sure
	Until Not (FileExists($BatchActiveFlagFile))

EndFunc   ;==>Keep_Batch_active


Func main()
	StartRunBatch()
	MsgBox(0, "debug", "waiting for batch to start", 5)
	WaitForBatchtoStart()
	Keep_Batch_active()
	MsgBox(0, "debug", "Batch has finished - you can use the computer again.", 5)
EndFunc   ;==>main

main()