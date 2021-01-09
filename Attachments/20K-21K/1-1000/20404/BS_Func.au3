;~ ===============================================================================================================================
;~  AutoIt Version: v3.2.12.0
;~  Language:       English
;~  Platform:       WinXP
;~  Author:        	Prophet
;~
;~ 	This script is the Function script for the Bearshare Searchtool
;~ 	This Script is is only tested with BearShare Pro 5.2.5
;~ ===============================================================================================================================

;===================================================================================
;					DEFINE CONSTANTS
;===================================================================================
Dim Const $sec = 1000
Dim Const $minute = 60 * $sec
Dim Const $SearchSleep = 2 * $minute 			;Sleep time for a Search
Dim Const $DownSleep = 4 * $minute 				;Sleep time for Downloads
Dim Const $BSversion = "BearShare Pro" 			;Bearshare Window Caption
Dim Const $timer = 8 							;timer for alerts

;===================================================================================
;					START OF FUNCTIONS
;===================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: BSSearch
; Description ...: BSSearch for files on BearShare
; Syntax.........: Search($SearchString , ($SearchType), ($Filter), ($FileSizemin), ($FileSizemax))
; Parameters ....: $SearchString - The string to search for
;................: $SearchType - Type of file to search in a text representation: apps , doc , image , movie , music
;................: $Filter - Words to filter out of the search seperated by ,
;................: $FileSizemin - Minimum filesize in kb
;................: $$FileSizemax - Maximum filesize in kb
; Return values .: Success 1
;                  Failure -1, sets @error to:
;                  1 - User Abort
;                  2 - $SearchString to short must be atleast 3 chars
;                  3 - $SearchType is not a Valid SearchType
;                  4 - Filesize is 0 or less
; Author ........: Prophet
; ===============================================================================================================================
Func BSSearch($SearchString , $SearchType="music" , $FileSizemin=3072 , $FileSizemax=25600 , $Filter="")
;===================================================================================
;					PROCESS FUNCTION ARGUMENTS
;===================================================================================
	;Check $Searchstring length
	If StringLen($SearchString) < 3 Then
		ConsoleWrite("Search String must be atleast 3 chars" & @CR)
		SetError(2)
		return -1
	EndIf
	
	;Process SearchType
	Switch $SearchType
	Case "apps"
		$FTSend = "EA"
	Case "doc"
		$FTSend = "ED"
	Case "image"
		$FTSend = "EI"
	Case "music"
		$FTSend = "EM"
	Case "movie"
		$FTSend = "EMM"
	Case Else
		ConsoleWrite("Not a Valid SearchType , use apps doc image movie music" & @CR)
		SetError(3)
		return -1
	EndSwitch

	;Check Filesizes
	If $FileSizemin <= 0 Or $FileSizemax <= 0 Then
		ConsoleWrite("FileSizes must be greather then 0" & @CR)
		SetError(4)
		return -1		
	EndIf
	
	; ++++++++++++ Continue? ++++++++++++++	
	$MSGString = "Search is ready, Search for " & $SearchString & " now?"
	$startdown = MsgBox(36, "Search starting?", $MSGString, $timer)
	If $startdown = -1 Then
	ElseIf $startdown = 6 Then
	Else
		MsgBox(16, "Aborting", "Aborting Search", $timer)
		SetError(1)
		Return -1
	EndIf
	
	;==================================================================================
	;					SEARCH PROCESS
	;==================================================================================
	;select search button
	ControlClick($BSversion, "", "ToolbarWindow3227", "left", 1, 28, 24)
	;Send search string to search box
	ControlSend($BSversion, "", "Edit2", $SearchString)
	;Set type to image
	ControlSend($BSversion, "", "ComboBox1", $FTSend)
	Sleep(300)
	;activate advanced button
	ControlFocus($BSversion, "", 2036)
	Sleep(500)
	Send("{SPACE}")
	WinWaitActive("New Search")
	;TAB to next TAB in the search window
	ControlCommand("New Search", "", "[ID:12320; INSTANCE:1;]", "TabRight")
	Sleep(300)
	;Check Filsize buttons send filsizes and Search
	ControlCommand("New Search", "", "Button2", "Check")
	ControlSend("New Search", "", "Edit1", "{END}+{HOME}{DEL}" & $FileSizemin)
	Sleep(300)
	ControlCommand("New Search", "", "Button3", "Check")
	ControlSend("New Search", "", "Edit2", "{END}+{HOME}{DEL}" & $FileSizemax)
	Sleep(300)
	ControlSend("New Search", "", "Edit5", $Filter)
	Sleep(300)
	ControlClick("New Search", "", "&Search", "left", 1, 35, 10)
	Sleep(300)
	Send("!{TAB}")
	Sleep($SearchSleep)
	;select search button
	ControlClick($BSversion, "", "ToolbarWindow3227", "left", 1, 28, 24)
	;Refresh search
	ControlClick($BSversion, "", "ToolbarWindow328", "left", 1, 10, 10)
	Sleep($SearchSleep)
	Return 1
EndFunc   ;==>BSSearch

; #FUNCTION# ====================================================================================================================
; Name...........: BSDown
; Description ...: Download the results in Bearshare, with a interval of $DownSleep
; Syntax.........: BSDown($FullScreen)
; Parameters ....: $FullScreen - The number of files selected with one page down, this cahnges at different resolutions
; Return values .: Success 1
;                  Failure -1, sets @error to:
;                  1 - User Abort
;                  2 - No Filles found in search for Download
; Author ........: Prophet
; ===============================================================================================================================
Func BSDown($FullScreen = 32)
; ++++++++++++ Continue? ++++++++++++++	
	$startdown = MsgBox(36, "Download?", "Download is ready, Download now?", $timer)
	If $startdown = -1 Then
		WinActivate($BSversion)
	ElseIf $startdown = 6 Then
		WinActivate($BSversion)
	Else
		MsgBox(16, "Aborting", "Aborting Download", $timer)
		SetError(1)
		Return -1
	EndIf	
	;================================================================================
	;					DOWNLOAD PROCESS
	;================================================================================	
	WinWaitActive($BSversion)
	;select search button
	ControlClick($BSversion, "", "ToolbarWindow3227", "left", 1, 28, 24)
	Sleep(300)
	;Focus on Search results
	ControlFocus($BSversion, "", "SysListView323")
	Sleep(300)
	;click in the search results and go to the top
	ControlClick($BSversion, "", "SysListView323", "left", 1, 25, 25)
	Sleep(300)
	
	;Get the number results divide by  2 x full screen
	$items = ControlListView($BSversion , "" , "SysListView323" , "GetItemCount")
	If $items < 1 Then
		ConsoleWrite("No files found for Download" & @CR)
		SetError(2)
		Return -1
	EndIf
	$repeat = Ceiling($items / ($FullScreen*2))
	
	; ++++++++++++ START DOWNLOAD LOOP +++++++++++++++++++++
	For $Subloop = 0 To $repeat - 1
		;If its the first time go direct to download, otherwise pop a allert
		If $Subloop = 0 Then
			;Shift + Pagedown to select 2 full searchwindows and download
			Send("+{PGDN 2}")
			Sleep(300)
			;click on the download button
			ControlClick($BSversion, "", "ToolbarWindow3210", "left", 1, 112, 11)
			Sleep(300)
			Send("{SPACE}")
		Else
			;sleep here in the loop so there there is no sleep at the end of the last download stage
			Sleep($DownSleep)
			
			; ++++++++++++ Continue? ++++++++++++++
			$startdown = MsgBox(36, "Download?", "Download is ready, Download now?", $timer)
			If $startdown = -1 Then
				WinActivate($BSversion)
			ElseIf $startdown = 6 Then
				WinActivate($BSversion)
			Else
				MsgBox(16, "Aborting", "Aborting Download", $timer)
				SetError(1)
				Return -1				
			EndIf
			
			; ++++++++ DOWNLOAD +++++++++++
			WinWaitActive($BSversion)
			;select search button
			ControlClick($BSversion, "", "ToolbarWindow3227", "left", 1, 28, 24)
			Sleep(300)
			;Focus on Search results
			ControlFocus($BSversion, "", "SysListView323")
			Sleep(300)
			;click in the search results
			ControlClick($BSversion, "", "SysListView323", "left", 1, 25, 25)
			Sleep(300)
			;one extra pagedown to go to the bottom before downloading 2 screens
			Send("{PGDN}+{PGDN 2}")
			;click on the download button
			ControlClick($BSversion, "", "ToolbarWindow3210", "left", 1, 112, 11)
			Sleep(300)
			Send("{SPACE}")
		EndIf
		Send("!{TAB}")
	Next
	Return 1
EndFunc   ;==>BSDown


; #FUNCTION# ====================================================================================================================
; Name...........: BSRetryFail
; Description ...: Retry failed downloads
; Syntax.........: BSRetryFail()
; Return values .: Success 1
;                  Failure -1, sets @error to:
;                  1 - User Abort
;
; Author ........: Prophet
; ===============================================================================================================================
Func BSRetryFail()
	; ++++++++++++ Continue? ++++++++++++++
	$startdown = MsgBox(36, "Download?", "Download is ready, Download now?", $timer)
	If $startdown = -1 Then
		WinActivate($BSversion)
	ElseIf $startdown = 6 Then
		WinActivate($BSversion)
	Else
		MsgBox(16, "Aborting", "Aborting Download", $timer)
		SetError(1)
		Return -1
	EndIf	
	
	;click on downloads button and click in the downloadwindow
	ControlClick($BSversion, "", "ToolbarWindow3227", "left", 1, 90, 25)
	ControlClick($BSversion, "", "SysListView324", "left", 1, 96, 113)
	;select all files and richtclick to select start for all downloads
	ControlListView($BSversion, "", "SysListView324", "SelectAll")
	ControlClick($BSversion, "", "SysListView324", "right", 1, 96, 113)
	Send("{DOWN 6} {ENTER}")
	Sleep(400)
	;Click on the search button
	ControlClick($BSversion, "", "ToolbarWindow3227", "left", 1, 28, 24)
	Send("!{TAB}")
	Sleep($DownSleep)
	Return 1
EndFunc   ;==>BSRetryFail

;===================================================================================
;					END OF FUNCTIONS
;===================================================================================