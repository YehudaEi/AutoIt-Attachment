; ------------------------------------------------------------------------------
;
; AutoIt Version: v3.1.1.107 (beta)
; Language:       English
; Description:    
; 	Script to download a series of rar archives from a remote webserver.
;	Also will get a named nfo file from the same dir and the sfv file as well.
; Date: February 8, 2006
; Version 1-D
; ------------------------------------------------------------------------------

; ####################################
; GUI
; ####################################
#include <GUIConstants.au3>
GUICreate("Rar archive downloader - By WUS - Made with AutoIT", 541, 280, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

; Labels
$Label_srcurl = GUICtrlCreateLabel("Source folder URL", 10, 10, 520, 20)
$Label_filename = GUICtrlCreateLabel("File name of original rar, i.e. rld-dowa.rar", 10, 70, 520, 20)
$Label_destfolder = GUICtrlCreateLabel("Destination folder i.e. c:/war/", 10, 200, 520, 20)
$Label_start = GUICtrlCreateLabel("Start archive # (-1 to get original .rar too)", 250, 130, 210, 20)
$Label_stop = GUICtrlCreateLabel("End archive #", 380, 170, 80, 20)
; Input
$h_srcurl = GUICtrlCreateInput("http://", 10, 30, 520, 20)
$h_filename = GUICtrlCreateInput("", 10, 90, 520, 20)
$h_destfolder = GUICtrlCreateInput("", 10, 220, 520, 20)
$h_start = GUICtrlCreateInput("-1", 470, 130, 60, 20)
$h_stop = GUICtrlCreateInput("", 470, 170, 60, 20)
$h_nfofilename = GUICtrlCreateInput("", 20, 170, 190, 20)
; Checkboxes
$h_sfv = GUICtrlCreateCheckbox("download .sfv file", 20, 110, 120, 30)
$h_nfo = GUICtrlCreateCheckbox("download .nfo file (filename goes below)", 20, 140, 210, 30)
$h_create = GUICtrlCreateCheckbox("Create Destination Folder", 20, 245, 200, 30)
; Buttons
$ok = GUICtrlCreateButton( "OK", 400, 245, 50, 30)
$cancel = GUICtrlCreateButton( "Cancel", 460, 245, 70, 30)

; Gui Loop, only exits for 'cancel' or 'close'.  Only allows the script to move on with correct data and 'ok'.
While 1
	
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				Exit
			Case $msg = $cancel
				Exit
			Case $msg = $ok
				GUISetState(@SW_HIDE)
				ExitLoop
		EndSelect
	WEnd
	
	; Inputs
	$srcurl = GUICtrlRead($h_srcurl)
	$filename = GUICtrlRead($h_filename)
	$destfolder = GUICtrlRead($h_destfolder)
	$start = GUICtrlRead($h_start)
	$stop = GUICtrlRead($h_stop)
	$nfofilename = GUICtrlRead($h_nfofilename)
	
	; Checkboxes
	$create = GUICtrlRead($h_create)
	$sfv = GUICtrlRead($h_sfv)
	$nfo = GUICtrlRead($h_nfo)
	
	; Error Checking the inputs
	Dim $error = ""
	$error = _outputerror($error, $srcurl, "Source URL")
	$error = _outputerror($error, $filename, "File Name")
	$error = _outputerror($error, $destfolder, "Destination Folder")
	$error = _outputerror($error, $start, "Start Archive")
	$error = _outputerror($error, $stop, "Stop Archive")
	
	If StringInStr( StringRight($filename, 4), ".rar") = 0 Then
		$error = $error & @CRLF & "The filename must end in .rar"
	EndIf
	
	If $start < - 1 Or $start > 99 Then
		$error = $error & @CRLF & "The start archive # must be a number between -1 and 99."
	EndIf
	
	If $stop < 0 Or $stop > 99 Then
		$error = $error & @CRLF & "The stop archive # must be a number between 0 and 99."
	EndIf
	
	If $nfo = $GUI_CHECKED Then
		If StringInStr( StringRight($nfofilename, 4), ".nfo") = 0 Then
			$error = $error & @CRLF & "The nfo filename must end in .nfo"
		EndIf
	EndIf
	
	; Displays errors in inputor moves on to next part if no errors
	If $error <> "" Then
		MsgBox(48, "ERROR", $error)
		$error = ""
	ElseIf $error = "" Then
		ExitLoop
	EndIf
	
WEnd
; ####################################
; Input parseing and such
; ####################################

; Declaring a few modified variables.

Dim $log = ""
Dim $s_filename = StringLeft($filename, StringLen($filename) - 2)
Dim $sfvfilename = StringLeft($filename, StringLen($filename) - 3) & "sfv"
Dim $i = $start

; String formatting for the url and pathnames
$srcurl = StringReplace($srcurl, "\", "/")
If "/" <> StringRight($srcurl, 1) Then
	$srcurl = $srcurl & "/"
EndIf

$destfolder = StringReplace($destfolder, "\", "/")
If "/" <> StringRight($destfolder, 1) Then
	$destfolder = $destfolder & "/"
EndIf

; Creating the destination folder if necessary
If $create = $GUI_CHECKED Then
	If FileExists($destfolder) = 0 Then
		DirCreate($destfolder)
	EndIf
EndIf

; ####################################
; Main loop that actually downloads the files
; ####################################
Do
	; downloads the sfv file, if box is checked
	If $sfv = $GUI_CHECKED Then
		$log &= _download($srcurl & $sfvfilename, $destfolder & $sfvfilename)
		$sfv = 0
	EndIf
	
	; downloads the nfo if the box is checked
	If $nfo = $GUI_CHECKED Then
		$log &= _download($srcurl & $nfofilename, $destfolder & $nfofilename)
		$nfo = 0
	EndIf
	
	; downloads the main rar file if the $start archive number was -1
	If $i = -1 Then
		$log &= _download($srcurl & $filename, $destfolder & $filename)
		$i += 1
	EndIf
	
	; creates a 2 digit number from the $i value and combines it with the rar filename to give the current archive name
	If $i < 10 Then
		$count = "0" & StringLeft($i, 1)
	Else
		$count = $i
	EndIf
	
	; downloads the archives from $start to $stop
	$log &= _download($srcurl & $s_filename & $count, $destfolder & $s_filename & $count)
	
	; increments $i so the next archive an be downloaded
	$i += 1
	
Until $i = $stop + 1

; Log of transfers shown after script completes
MsgBox(48, "Log", $log)


; ####################################
; Functions
; ####################################
Func _outputerror($string, $vartocheck, $varname)
	If $vartocheck = "" Then
		$string = $string & @CRLF & $varname & " has no value, please give it a value."
	EndIf
	Return $string
EndFunc   ;==>_outputerror

Func _download($src, $dest)
	
	$size = Round(InetGetSize($src) / (1024 * 1024), 1)
	$check = InetGet($src, $dest, 1, 1)
	
	While @InetGetActive
		TrayTip("Downloading " & StringTrimLeft($src, StringInStr($src, "/", 0, -1)), Round(((@InetGetBytesRead/ (1024 * 1024)) / $size) * 100, 1) & "% of " & $size & " Mbs", 10, 16)
		Sleep(250)
	WEnd
	
	If $check = 1 Then
		$return = $src & " - " & $size & "Mbytes, Downloaded successfully to " & $dest & @CRLF
		Return $return
	ElseIf $check = 0 Then
		$return = $src & " - " & $size & "Mbytes, did not Downloaded successfully to " & $dest & @CRLF
		Return $return
	EndIf
	
EndFunc   ;==>_download

