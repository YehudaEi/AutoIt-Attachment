; ----------------------------------------------------------------------------
; Author: 		Terry Matthews
; Date:			05/02/07
;
; Version:		1.0
; Description: 	This script monitors the execution manager log file in real time
;				and displays a GUI to show progress of app installs.
;
; Background:	SMS is used to push out a lot of applications silently.  Operators
;				would like to be able to walk up to a server that is being built 
;				and know what apps it is installing, where it is at, and how many
;				are left.  This information can be read from the execmgr log file
;				but we also dont want them opening files as many of the installs
;				and configurations are done using autoit scripts.  Plus a GUI is 
;				easier to see.
;
; Updates:		
;
; ----------------------------------------------------------------------------

;=====================================
; OPTIONS
;=====================================
Opt("TrayIconDebug", 1)
Opt("WinTitleMatchMode", 2)
Opt("WinDetectHiddenText",1)
Opt("ExpandEnvStrings", 1)

; ========================
; INCLUDE HELPER FUNCTIONS
; ========================
#include <constants.au3>
#include <GUIConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <file.au3>
#include <Date.au3>
#include <TailRW.au3>

; ===========================
; VARIABLES AND DECLARATIONS
; ===========================
Dim $AvailableArray [1]
Dim $ProgramsToInstall
Dim $PLabel1
Dim $ItemStart
Dim $PLabel

$ProgressArray = ""
$INIFILE = @SystemDir & "\ServerBuild.ini"
$LOG = @SystemDir & "\CCM\Logs\execmgr.log"
$Pause_Time = "10"
$LASTTIME = ""
$x = "1"

; ================
; OTHER
; ================
; Install ServerBuild.ini for this specific install
; Change this to match your location.
; Remember the "PROGRAM=" in the ini must equal the exact name that will be shown in the execmgr.log

FileInstall("c:\temp\CORITP\ServerBuild.ini", @SystemDir & "\ServerBuild.ini", 1)

; ================
; MAIN
; ================
; Create To Do list from ini file found in systemdir named ServerBuild.ini, I'll create an INI file with sections related to
; what apps to expect and then put it down each time, overlapping the previous one.
_FileToArray ($AvailableArray, $INIFILE)

; Install Check
 If $ProgramsToInstall = 0 Then
      msgbox(0, "Error", "No Programs Found, Config file may be missing")
	  RunWait('eventcreate /t ERROR /SO WATCH /L Application /id 140 /d "No Programs Found, Config File may be missing or incorrectly formatted"', "", @SW_HIDE)
	  Exit
EndIf

; Create GUI
_CreateGUI()

; Monitor File and update GUI as needed
While $x = "1"
	Sleep($Pause_Time)
	
	If GUIGetMsg() = $GUI_EVENT_CLOSE Then
		Exit
	EndIf
	
	; Get last modified time of log file
	$t =  FileGetTime($LOG)
	
	; Construct the time
	If Not @error Then
		$TIME = $t[0] & "/" & $t[1] & "/" & $t[2] & " " & $t[3] & ":" & $t[4] & ":" & $t[5]
		; If this just started set last time to current time
		If $LASTTIME = "" Then
			$LASTTIME = $TIME
		EndIf
	EndIf
	
	; Compare the times to find the difference
	$DIF = _DateDiff('s',$TIME,$LASTTIME)
	
	; If there's a difference then changes have been made, check to see if the last line of the log contains one of the following and do some action.
	If $DIF <> "0" Then

		; If the last log line contains "Execution Request for program ", parse everything between end of that and the 
		; next " state change from WaitingContent to NotifyExecution", find it on the to do list make it bold.
		_Read_last($log)
		
		
		
		
		; If the last log line begins with "Raised Program Started Event for Ad:" and contains ", Program: ", then parse out everything after this 
		; find it on to do list and make it bold with underline.
		_Read_last ($log)
		
		
		
		
		; If the last log line begins with "Execution is complete for program " and contains ". The exit code is ", parse the stuff in between and 
		; find on to do list and strikethrough, unbold.  Write Exit code returned next to label?  And if this is equal to the last program to install
		; then exit altogether.
		_Read_last ($log)
		
		
		
		
	EndIf
	
	$LASTTIME = $TIME
	
WEnd

; Close GUI
GUIDelete()

Exit


; ================
; FUNCTIONS
; ================

; Creates GUI
Func _CreateGUI()
	Dim $tSize
	$LABELS = $ProgramsToInstall - 1
	$j = 1000
	$tArrayItem = "0"
	$k = "0"
	
	; Figuring out size for GUI
	If $LABELS < 30 Then
        $tSize = 20 * $LABELS
    Else
        $tSize = 270
    EndIf
	
	; Create GUI
    GUICreate( "Applications to Install", 300, $tSize + 250, 20, 25, -1)
    GUISetFont ( 14 , 400 , "", "Arial")
	GUISetBkColor(0xFFFFFF)
	 
	; Labels on GUI
	$LabelContext = GUICtrlCreateLabel( "Installing Applications", 10, 10, 260 , 20 )
    GUICtrlSetFont (-1, 11, 646, "", "Arial")
	
	; Create Labels and Populate them with the contents from the ini file
	For $k=0 to $LABELS
		$PLabelNew = $PLabel & $k
		$TEXT = $AvailableArray[$tArrayItem + $k]
		$PLabelNew = GUICtrlCreateLabel( $TEXT , 30, $j , 260 , 60 )
		GUICtrlSetFont ( -1,  9, 400, "", "Arial" )

		$j+=70
	Next
	
	; Logo at Bottom
	$Pic1 = GUICtrlCreatePic("C:\temp\WAMULOGO.bmp", 30, $tSize + 150, 226, 69)

    GUISetState ()
	
EndFunc

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; Reads last line of logfile
Func _Read_last ($log)
	$LineNumber = -1
	$s_ReadLine = __FileReadLine ($Log, $LineNumber, 1)
EndFunc

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; Converts INI file to array
Func _FileToArray (ByRef $tArray, $INIFILE) 
   $i = 0
   $tOpenFile = FileOpen ($INIFILE, 0 )
   $ProgramsToInstall = "0"
	
	While 1
		$tLine = FileReadLine ($tOpenFile)
	  
		If @error = -1 Then ExitLoop
	  
		; Removes white space from begining and end
		$tLine = StringStripWS ($tLine, 3 )
		
		; Check if the line contains "PROGRAM" if it does add it to the array and remove '=' sign.
		If StringLeft ( $tLine, 7)  = "PROGRAM" Then
			ReDim $tArray [$i+1]
			$tPos  = StringInStr ($tLine, "=")
			$tLine = StringTrimLeft ($tLine, $tPos)
			$tLine = StringStripWS ($tLine, 3)
			$tArray [$i] = $tLine
			$i = $i + 1
			;Count programs to install
			$ProgramsToInstall = $ProgramsToInstall + 1
		EndIf
	Wend
  
   FileClose ($INIFILE)
   
EndFunc



