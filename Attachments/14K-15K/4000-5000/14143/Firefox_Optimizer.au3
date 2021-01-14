#include <GUIConstants.au3>
#include <File.au3>
#Include <Array.au3>
#include <GuiCombo.au3>
Global $prefs

$filelist =_FileListToArray(@AppDataDir & "\Mozilla\Firefox\Profiles\")
$prefs = @AppDataDir & "\Mozilla\Firefox\Profiles\" & $filelist[1] & "\prefs.js"
DirCreate(@ScriptDir & "\Backups\")
$backup = @ScriptDir & "\Backups\prefs.js"
$aStart = IniRead(@ScriptDir & "\Backups\Backup.ini", "Main", "Backup Created", "N")

If $aStart = "N" Then
$bkup = FileCopy($prefs, $backup)
IniWrite(@ScriptDir & "\Backups\Backup.ini", "Main", "Backup Created", "Y")
MsgBox(0, "Backup", "A backup up has been created of your current configuration. To restore any changes made by this program, click the Restore All button on the main tab.")
EndIf


$Form1 = GUICreate("Firefox Optimizer", 450, 195, 333, 258)

$FirefoxOptimizer = GUICtrlCreateTab(0, 0, 449, 193)
$TabSheet1 = GUICtrlCreateTabItem("Basic Optimization")
$Title = GUICtrlCreateLabel("Basic Optimization", 12, 36, 425, 17, $SS_CENTER)
$Lable1 = GUICtrlCreateLabel("This optimization works best if you have a broadband connection. It will decrease the time it takse to load pages.", 32, 56, 381, 33, $SS_CENTER)
$BasicOptimize = GUICtrlCreateButton("Optimize", 136, 105, 177, 25, 0)
$Restore = GUICtrlCreateButton("Restore", 136, 140, 177, 25, 0)

$TabSheet2 = GUICtrlCreateTabItem("Custom Changes")
$Label2 = GUICtrlCreateLabel("Select the preset you want to load", 8, 32, 433, 17, $SS_CENTER)
$Combo = GUICtrlCreateCombo("", 144, 55, 160, 25)
$Change = GUICtrlCreateButton("Change", 144, 90, 153, 25, 0)
$New = GUICtrlCreateButton("New/Edit Preset", 144, 130, 153, 25, 0)

$TabSheet3 = GUICtrlCreateTabItem("Advanced Optimization")
$Label3 = GUICtrlCreateLabel("Select the setting that is most revelent to your computer", 96, 40, 265, 17)
$Radio1 = GUICtrlCreateRadio("Fast Computer Fast Connection", 32, 72, 177, 17)
$Radio2 = GUICtrlCreateRadio("Fast Computer Slow Connection", 32, 104, 177, 17)
$Radio3 = GUICtrlCreateRadio("Slow Computer Fast Connection", 224, 72, 185, 17)
$Radio4 = GUICtrlCreateRadio("Slow Computer Slow Connection", 224, 104, 177, 17)
$Advanced = GUICtrlCreateButton("Optimize", 144, 144, 153, 25, 0)
GUICtrlCreateTabItem("")

Dim $line
Dim $filename = @ScriptDir & "\presets\names.txt"
Dim $nlinenumber
$linenumber = 1
If FileExists($filename) Then
Else
	DirCreate(@ScriptDir & "\presets\")
	_FileCreate($filename)
EndIf
FileOpen($filename, 0)

While 1
	$line = FileReadLine($filename, $linenumber)
	If @error = -1 Then
		ExitLoop
	Else
		_GUICtrlComboResetContent($Combo)
		_GUICtrlComboAddString($Combo, $line)
		$linenumber = $linenumber + 1
EndIf
Sleep (100)
WEnd


_GUICtrlComboSetCurSel($Combo, 0)
GUISetState(@SW_SHOW)

While 1
	$msg = GuiGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then
		Exit
	EndIf
	If $msg = $New Then
		Dim $ScriptName = @ScriptDir & "\Presets.au3"
		Run(@AutoItExe & ' "' & $ScriptName & '"')
	EndIf
	If $msg = $Change Then
		Custom()
	EndIf
	If $msg = $Restore Then
		Restore()
	EndIf
	If WinExists("New Preset") Then
		While 1
			If WinExists("New Preset") Then
				While 1
				$line = FileReadLine($filename, $linenumber)
					If @error = -1 Then
						ExitLoop
					Else
						_GUICtrlComboResetContent($Combo)
						_GUICtrlComboAddString($Combo, $line)
						$linenumber = $linenumber + 1
					EndIf
				WEnd
			Else
				ExitLoop
			EndIf
			Sleep (100)
		WEnd
	_GUICtrlComboSetCurSel($Combo, 0)
	EndIf
	If $msg = $BasicOptimize Then
		Basic()
		If $msg  = $Advanced Then
			If GUICtrlRead($Radio1) = $GUI_CHECKED Then
				FastFast()
			ElseIf GUICtrlRead($Radio2) = $GUI_CHECKED Then
				FastSlow()
			ElseIf GUICtrlRead($Radio3) = $GUI_CHECKED Then
				SlowFast()
			ElseIf GUICtrlRead($Radio1) = $GUI_CHECKED Then
				SlowSlow()
			Else
				MsgBox(0, "Error", "Please select an option")
			EndIf
		EndIf
	EndIf
WEnd


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func Basic()
	$WebSite = "http://download.mozilla.org/?product=firefox-2.0.0.2&os=win&lang=en-US"

;Check if Firefox is Installed
$FF_version = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\MOZILLA\MOZILLA FIREFOX\", "Currentversion")
;If not installed
If @error Then
	$Return = MsgBox(4, "Firefox Not Installed", "Firefox does not appeared to be installed on this machine. Would you like to download Firefox now?")
	If $Return = 6 Then
		Run(@ComSpec & " /c start " & $WebSite)
		MsgBox(0, "Re-Run", "Once Firefox is installed, please re run this script to optimize it.")
	Else
		MsgBox(0, "Error", "This program cannot optimize Firefox unless it is installed")
		Exit
	EndIf
EndIf

;Basic Optimization

;Gay Folder
$FileList =_FileListToArray(@AppDataDir & "\Mozilla\Firefox\Profiles\")
If @Error=1 Then
    MsgBox (0,"","Firefox can not be optimized due to a bad location of files")
    Exit
EndIf

$prefs = @AppDataDir & "\Mozilla\Firefox\Profiles\" & $filelist[1] & "\prefs.js"

;Check If Firefox is Running
MsgBox(4096, "Basic Optimization", "Firefox will now be optimized. Please close all instances of firefox including the download manager.")
If ProcessExists("Firefox.exe") Then
	$Return = MsgBox(4, "Firefox Still Open", "Firefox still aprears to be running. Do you want to terminate Firefox now?")
		If $Return = 6 Then
			ProcessClose("Firefox.exe")
			If FileExists($prefs) Then
				Basic_optimize()
			Else
				_FileCreate($prefs)
				Basic_optimize()
			EndIf
		Else
			MsgBox(0, "Optimization Terminated", "Firefox could not be optimized because it is still running.")
			Exit
		EndIf
	EndIf	
	
;Optimizing


If FileExists($prefs) Then
	Basic_optimize()
Else
	_FileCreate($prefs)
	Basic_optimize()
EndIf
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func Basic_optimize()
	FileWrite($prefs, @CRLF)
;Search for network.http.pipelining
Dim $search = $prefs
Dim $find = "network.http.pipelining"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("network.http.pipelining", True);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.pipelining", True);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.proxy.pipelining
Dim $find = "network.http.proxy.pipelining"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("network.http.proxy.pipelining", True);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.proxy.pipelining", True);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.pipelining.maxrequests
Dim $find = "network.http.proxy.pipelining"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("network.http.pipelining.maxrequests", 30);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.pipelining.maxrequests", 30);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;nglayout.initialpaint.delay
Dim $find = "nglayout.initialpaint.delay"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("nglayout.initialpaint.delay", 0);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("nglayout.initialpaint.delay", 0);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

MsgBox(0, "Success", "Firefox was optimized successfully")
;;;;End Func Basic Optimize
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func FastFast()
	FileWrite($prefs, @CRLF)
;Search for content.interrupt.parsing
Dim $search = $prefs
Dim $find = "content.interrupt.parsing"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.interrupt.parsing", True);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.interrupt.parsing", True);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.max.tokenizing.time
Dim $find = "content.max.tokenizing.time"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.max.tokenizing.time", 2250000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.max.tokenizing.time", 2250000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.notify.interval
Dim $find = "content.notify.interval"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.notify.interval", 750000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.notify.interval", 750000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.notify.ontimer
Dim $find = "content.notify.ontimer"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.notify.ontimer", True);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.notify.ontimer", True);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.switch.threshold
Dim $find = "content.switch.threshold"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'content.switch.threshold", True);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.switch.threshold", True);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-connections-per-server
Dim $find = "network.http.max-connections-per-server"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-connections-per-server", 16);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-connections-per-server", 16);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-persistent-connections-per-proxy
Dim $find = "network.http.max-persistent-connections-per-proxy"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-persistent-connections-per-proxy", 16);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-persistent-connections-per-proxy", 16);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-persistent-connections-per-server
Dim $find = "network.http.max-persistent-connections-per-server"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-persistent-connections-per-server", 8);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-persistent-connections-per-server", 8);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for browser.cache.memory.capacity
Dim $find = "browser.cache.memory.capacity"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'browser.cache.memory.capacity", 65536);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("browser.cache.memory.capacity", 65536);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next
MsgBox(0, "Success", "Firefox was optimized successfully")
EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func FastSlow()
	FileWrite($prefs, @CRLF)
;Search for content.max.tokenizing.time
Dim $search = $prefs
Dim $find = "content.max.tokenizing.time"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.max.tokenizing.time", 2250000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.max.tokenizing.time", 2250000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.notify.interval
Dim $search = $prefs
Dim $find = "content.notify.interval"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.notify.interval", 750000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.notify.interval", 750000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.notify.ontimer
Dim $search = $prefs
Dim $find = "content.notify.ontimer"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.notify.ontimer", True);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.notify.ontimer", True);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.switch.threshold
Dim $search = $prefs
Dim $find = "content.switch.threshold"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.switch.threshold", 750000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.switch.threshold", 750000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-connections-per-server
Dim $find = "network.http.max-connections-per-server"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-connections-per-server", 16);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-connections-per-server", 16);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-persistent-connections-per-proxy
Dim $find = "network.http.max-persistent-connections-per-proxy"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-persistent-connections-per-proxy", 16);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-persistent-connections-per-proxy", 16);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-persistent-connections-per-server
Dim $find = "network.http.max-persistent-connections-per-server"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-persistent-connections-per-server", 8);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-persistent-connections-per-server", 8);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for browser.cache.memory.capacity
Dim $find = "browser.cache.memory.capacity"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'browser.cache.memory.capacity", 65536);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("browser.cache.memory.capacity", 65536);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next
MsgBox(0, "Success", "Firefox was optimized successfully")
EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func SlowFast()
	FileWrite($prefs, @CRLF)
;Search for content.max.tokenizing.time
Dim $search = $prefs
Dim $find = "content.max.tokenizing.time"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.max.tokenizing.time", 3000000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.max.tokenizing.time", 3000000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.notify.backoffcount
Dim $search = $prefs
Dim $find = "content.notify.backoffcount"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.notify.backoffcount", 5);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.notify.backoffcount", 5);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.notify.interval
Dim $search = $prefs
Dim $find = "content.notify.interval"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.notify.interval", 1000000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.notify.interval", 1000000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.notify.ontimer
Dim $search = $prefs
Dim $find = "content.notify.ontimer"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.notify.ontimer", True);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.notify.ontimer", True);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.maxtextrun
Dim $search = $prefs
Dim $find = "content.switch.threshold"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.switch.threshold", 1000000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.switch.threshold", 1000000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.maxtextrun
Dim $search = $prefs
Dim $find = "content.maxtextrun"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.maxtextrun", 4095);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.maxtextrun", 4095);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for nglayout.initialpaint.delay
Dim $search = $prefs
Dim $find = "nglayout.initialpaint.delay"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("nglayout.initialpaint.delay", 1000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("nglayout.initialpaint.delay", 1000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for nglayout.initialpaint.delay
Dim $search = $prefs
Dim $find = "nglayout.initialpaint.delay"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("nglayout.initialpaint.delay", 1000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("nglayout.initialpaint.delay", 1000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-connections-per-server
Dim $find = "network.http.max-connections-per-server"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-connections-per-server", 16);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-connections-per-server", 16);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-persistent-connections-per-proxy
Dim $find = "network.http.max-persistent-connections-per-proxy"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-persistent-connections-per-proxy", 16);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-persistent-connections-per-proxy", 16);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-persistent-connections-per-server
Dim $find = "network.http.max-persistent-connections-per-server"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-persistent-connections-per-server", 8);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-persistent-connections-per-server", 8);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for dom.disable_window_status_change
Dim $find = "dom.disable_window_status_change"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'dom.disable_window_status_change", 8);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("dom.disable_window_status_change", 8);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next
MsgBox(0, "Success", "Firefox was optimized successfully")
EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func SlowSlow()
		FileWrite($prefs, @CRLF)
;Search for content.max.tokenizing.time
Dim $search = $prefs
Dim $find = "content.max.tokenizing.time"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.max.tokenizing.time", 2250000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.max.tokenizing.time", 2250000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.notify.interval
Dim $search = $prefs
Dim $find = "content.notify.interval"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.notify.interval", 750000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.notify.interval", 750000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.notify.ontimer
Dim $search = $prefs
Dim $find = "content.notify.ontimer"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.notify.ontimer", True);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.notify.ontimer", True);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for content.switch.threshold
Dim $search = $prefs
Dim $find = "content.switch.threshold"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("content.switch.threshold", 750000);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("content.switch.threshold", 750000);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for nglayout.initialpaint.delay
Dim $search = $prefs
Dim $find = "nglayout.initialpaint.delay"

Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'user_pref("nglayout.initialpaint.delay", 750);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("nglayout.initialpaint.delay", 750);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-connections-per-server
Dim $find = "network.http.max-connections-per-server"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-connections-per-server", 16);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-connections-per-server", 16);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-persistent-connections-per-proxy
Dim $find = "network.http.max-persistent-connections-per-proxy"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-persistent-connections-per-proxy", 16);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-persistent-connections-per-proxy", 16);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for network.http.max-persistent-connections-per-server
Dim $find = "network.http.max-persistent-connections-per-server"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'network.http.max-persistent-connections-per-server", 8);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("network.http.max-persistent-connections-per-server", 8);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next

;Search for dom.disable_window_status_change
Dim $find = "dom.disable_window_status_change"
Dim $aRecords
If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf
For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, 'dom.disable_window_status_change",True);', 1)
	If @error = 0 Then FileWrite($prefs, 'user_pref("dom.disable_window_status_change", True);') 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next
MsgBox(0, "Success", "Firefox was optimized successfully")
EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func Custom()

$aPreset = GUICtrlRead($Combo)
$aNumberLines = _FileCountLines(@ScriptDir & "\Presets\" & $aPreset & ".txt")

If @error = 1 Then
	MsgBox(0, "Error", "This preset is empty, no changes will be made. You can add values by clicking New/Edit Values.")
EndIf

$aLine = 1

Do
$aFileLine = FileReadLine(@ScriptDir & "\Presets\" & $aPreset & ".txt", $aLine)
	
Global $search
Dim $find = $aFileLine
Dim $aRecords

If Not _FileReadToArray($search,$aRecords) Then
   MsgBox(4096,"Error", "Error")
   Exit
EndIf

For $x = 1 to $aRecords[0]
    If StringInStr($aRecords[$x], $find) Then _FileWriteToLine($prefs, $x, $aFileLine & ");", 1)
	If @error = 0 Then FileWrite($prefs, $aFileLine & ");") 
	FileWrite($prefs, @CRLF)
	ExitLoop
Next
$aLine = $aLine + 1
Until $aLine = $aNumberLines + 1
MsgBox(0, "Success", "Firefox was changed successfully")
EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Func Restore()
	$x1 = MsgBox(4, "Restore", "This will restore your firefox configuration to what it was before you used this program. Other changes that were not made by this program will also be lost.")
	If $x1 = 6 Then
		FileCopy($backup, $prefs, 1)
		MsgBox(0, "Restore Completed", "Firefox was successfull restored,")
	Else
		MsgBox(0, "Resore Canceled", "You canceled the restore, no changes were made.")
	EndIf
EndFunc