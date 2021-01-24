; ======================================================================================
;
;       GPS Time   		
;
;       David Rogers   		
;
;       Version 1.1 
;
;       Version history   	
;		Version 1.1 started Dec 26th 2008
; 		Many thanks to Martin (Mass Spammer), Paul P Meier and Seesoe for their posts on the AutoIT forums.
;
; 		If you have any suggestions or request please e-mail me.
;
; ======================================================================================
;Include
#include <string.au3>
#include <Date.au3>
#include <CommMG.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <UpDownConstants.au3> 
#Include <GuiButton.au3>
#NoTrayIcon
; ======================================================================================
;File on Demand
FileInstall("C:\Rally Results\GPS\commg.dll", @ScriptDir & "\commg.dll")							;include commg.dll into the compiled script.
; ======================================================================================
;HotKeySet
HotKeySet("{ESC}", "_Terminate")
; ======================================================================================
;Declare variables
Local $ComPort = 4																					;default vale of the com port	
Local $XPos = 100																					;location of the GUI, default values for first use
Local $YPos = 100																					;location of the GUI, default values for first use
Local $SyncEvery = 5																				;how often to auto synch system clock in minutes
Local $GPSString = ""
Local $avData = ""
Local $sData = ""
Local $hour = ""
Local $avtData = ""
Local $avdData = ""
Local $avHour = ""
Local $sportSetError																				;the variable that the com port will return any errors to
Local $IniFile = "gps.ini"																			;name of the .ini file
Local $file
Local $MinLable
Local $size
Local $NewLine = False																				;a flag to be sure we have read one whole line of GPS Data
Local $NewTime = False																				;a flag to be sure we have read one whole line of GPS Time Data
Local $NewDate = False																				;a flag to be sure we have read one whole line of GPS Date Data
Local $tick = @WindowsDir & "\Media\start.wav"														;the sound to make when the clock in synchronised
;TraySetIcon("mmcndmgr.dll",-15)
; ======================================================================================
;Call
_ReadIni() 																							;Read the .Ini file
_CommSetPort($ComPort,$sportSetError, 4800, 8, 0, 1, 0)												;configure the COM port to output data in the correct format
_CommClosePort()																					;close the com port
$file = FileOpen("COM" & $ComPort, 4)																;open the com port and start reading data
AdlibEnable("_SetPCTime",$SyncEvery*60000)															;set the PC time every 60,000ms x $SyncEvery (in minutes)
; ======================================================================================
;Create GUI
Opt("GUIOnEventMode", 1) 																			;change to OnEvent GUI mode 
$mainwindow = GUICreate("GPS Time", 300, 275, $XPos, $YPos) 										;create the GPS Time GUI
GuiSetIcon("mmcndmgr.dll",-15)																		;set the GUI icon to a clock
GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")
GUICtrlCreateGroup("GPS Date && Time", 10, 10, 280, 50)
$ShowDate = GUICtrlCreateLabel("GPS Date", 40, 30, 100) 
$ShowTime = GUICtrlCreateLabel("GPS Time", 135, 30, 120) 
$font = "Comic Sans MS"    																			;set font
GUICtrlSetFont ($ShowDate,14, 400, $font)    														;set font    
GUICtrlSetFont ($ShowTime,14, 400, $font)    														;set font 
GUICtrlCreateGroup("", -99, -99, 1, 1)  															;close group
GUICtrlCreateGroup("PC Date && Time", 10, 80, 280, 50)
$ShowPCTime = GUICtrlCreateLabel("PC Time Display", 40, 100, 170) 
$font = "Comic Sans MS"    																			;set font
GUICtrlSetFont ($ShowPCTime,14, 400, $font)    														;set font
GUICtrlCreateGroup("", -99, -99, 1, 1)  															;close group
GUICtrlCreateGroup("Control", 10, 150, 280, 115)
GUICtrlCreateLabel("Sync every", 20, 173, 60)
$input = GUICtrlCreateInput($SyncEvery, 90, 170, 50, 20)
$updown = GUICtrlCreateUpdown($input, BitOr($UDS_ARROWKEYS, $UDS_WRAP))
GUICtrlSetLimit($UpDown, 10, 1)																		;limit the spin control range to 1 to 10 minutes
$MinLable = GUICtrlCreateLabel("minutes.", 150, 173, 60)
GUICtrlCreateLabel("Com Port", 20, 203, 60)
$ComPortSet = GUICtrlCreateCombo("1", 90, 200,50) 													;create first item
GUICtrlSetData(-1, "2|3|4|5|6|7|8|9|10|11|12|13|14|15|16", $ComPort) 								;add range 1com 1 to com 16 and set the default from the .ini file
$setnowbutton = GUICtrlCreateButton("Synch now", 210, 170, 70, 22)
GUICtrlSetOnEvent($setnowbutton, "_SetNowButton")
$applybutton = GUICtrlCreateButton("Apply", 210, 200, 70, 22)
GUICtrlSetOnEvent($applybutton, "_ApplyButton")
$exitbutton = GUICtrlCreateButton("Exit", 210, 230, 70, 22)
GUICtrlSetOnEvent($exitbutton, "_terminate")
GUICtrlCreateGroup("", -99, -99, 1, 1)  															;close group
_GUICtrlButton_SetFocus($setnowbutton)																;move focus to the sync now button
GUISetState(@SW_SHOW) 																				;display the GUI
_MinuteLable()																						;set the lable to minute or minutes
; ======================================================================================
;While Loop
While 1																								;start the loop
	$chr = FileRead($file, 1)																		;read the com port data character by character
    ConsoleWrite($chr)																				;write the GPS data to the console for debugging purposes
	$GPSString = $GPSString & chr($chr)																;append each character to the end of the string
	If $chr = 13 then 																				;if the next character is a carriage return then assume a new line is next (don't forget the line-feed)
		$Newline = True																				;we have reached the first carriage return
		_ProcessString()																			;processstring reads the line of GPS data
	EndIf
WEnd																								;end the loop
GUIDelete()																							;kill the GUI
; ======================================================================================
Func _ReadIni()																						;reads the ini file if it exists
	If FileExists(@ScriptDir & '/' & $IniFile) Then
		$ComPort = IniRead($IniFile, "COM", "Port", "1")
		$XPos = IniRead($IniFile, "StartPosition", "XPos", "100")
		$YPos = IniRead($IniFile, "StartPosition", "YPos", "100")
		$SyncEvery = IniRead($IniFile, "SyncEvery", "Interval", "5")
	Else
		$ComPort = InputBox("Question", "Which COM port is the GPS attached to?", "4", "", -1, -1, 0, 0)	;if the .ini file doen't contain com port data then ask
	EndIf
	If StringIsDigit($ComPort) = 0 Then																;is the entered value for the com port an integer
		msgbox(0,"Error", "Error in Com Port settings")												;if not delete the .ini file and end the program
		FileDelete($IniFile)																		;if not delete the .ini file 
		Terminate()																					;if not end the program
	EndIf
EndFunc
; ======================================================================================
Func _SetNowButton()
  _SetPCTime()
EndFunc
; ======================================================================================
Func _ApplyButton()
	$ComPort = GUICtrlRead($ComPortSet)
	$SyncEvery = GUICtrlRead($input)
	IniWrite(@ScriptDir & '/' & $IniFile, "COM", "Port", $ComPort)									;write the COM port number to the .ini file
	IniWrite(@ScriptDir & '/' & $IniFile, "SyncEvery", "Interval", $SyncEvery)						;write the sync interval to the .ini file
	_MinuteLable()
EndFunc
; ======================================================================================
Func _ProcessString()
	If StringInStr($GPSString, "$GPGGA") Then														;does the GPS data string contain $GPGGA
		$avData = StringSplit($GPSString, ",")														;read each portion of the GPS data string into an array, splits the string at each comma
		If StringMid($GPSString, 2, 6) ="$GPGGA" then												;is the string $GPGGA in the given location (i.e is the string correctly formed!)
			$NewTime = True
			$avtData = StringSplit($avData[2], "")													;read each character of the second element of the GPS data string into an array
			GUICtrlSetData($ShowTime, $avtData[1] &  $avtData[2] & ":" & $avtData[3] & $avtData[4] & ":" & $avtData[5] &  $avtData[6]) ;update the GUI with GPS time
			$tCur = _Date_Time_GetSystemTime()														;get the system time
			GUICtrlSetData( $ShowPCTime, _Date_Time_SystemTimeToDateTimeStr($tCur))				;update the GUI with system time
		EndIf
	EndIf
	If StringInStr($GPSString, "$GPRMC") Then														;does the GPS data string contain $GPRMC
		$avData = StringSplit($GPSString, ",")														;read each portion of the GPS data string into an array, splits the string at each comma
		If StringMid($GPSString, 2, 6) ="$GPRMC" then												;is the string $GPRMC in the given location (i.e is the string correctly formed!)
			$NewDate = True
			$avdData = StringSplit($avData[10], "")													;read each character of the second element of the GPS data string into an array
			GUICtrlSetData($ShowDate, $avdData[3] &  $avdData[4] & "/" & $avdData[1] & $avdData[2]& "/20" & $avdData[5] &  $avdData[6])	;update the GUI with GPS date
			$tCur = _Date_Time_GetSystemTime()														;get the system date
			GUICtrlSetData ( $ShowPCTime, _Date_Time_SystemTimeToDateTimeStr($tCur))				;update the GUI with system date
		EndIf
	EndIf
	$GPSString=""																					;empty the string
EndFunc	
; ======================================================================================
Func _SetPCTime()
	If $NewLine = True then																						;do we have any whole data strings
		If $NewTime = True then																					;do we have time data
			If $NewDate = True then																				;do we have date data
				_SetTime($avtData[1] &  $avtData[2],$avtData[3] & $avtData[4],$avtData[5] &  $avtData[6])  		;set the PC time 
				_SetDate($avdData[1] &  $avdData[2],$avdData[3] & $avdData[4],20 & $avdData[5] &  $avdData[6])  ;set the PC date 
				SoundPlay($tick)																				;tick
			EndIf
		EndIf
	EndIf
EndFunc
; ======================================================================================
Func _MinuteLable()
	If $SyncEvery = 1 Then
		GUICtrlSetData($MinLable, "minute.")														;if $SsyncEvery = 1 then use the lable "minute"
	Else
		GUICtrlSetData($MinLable, "minutes.")														;if $SsyncEvery > 1 then use the lable "minutes"
	EndIf	
EndFunc
; ======================================================================================
Func _Terminate()
	$size = WinGetPos("GPS Time")																	;Save the position of the window
	IniWrite(@ScriptDir & '/' & $IniFile, "StartPosition", "XPos", $size[0])						;write the x-position to the .ini file
	IniWrite(@ScriptDir & '/' & $IniFile, "StartPosition", "YPos", $size[1])						;write the y-position to the .ini file
	IniWrite(@ScriptDir & '/' & $IniFile, "COM", "Port", $ComPort)									;write the COM port number to the .ini file
	IniWrite(@ScriptDir & '/' & $IniFile, "SyncEvery", "Interval", $SyncEvery)						;write the sync interval to the .ini file
	FileClose($file)																				;close the file we are writing GPS data to
	GUIDelete()																						;kill the GUI
	_CommClosePort()																				;close the com port
	Exit																							;end the program
EndFunc
; ======================================================================================