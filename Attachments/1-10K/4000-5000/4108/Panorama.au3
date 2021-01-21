; Panorama 1.0
; Ben Shepherd, bjs54@dl.ac.uk
; 22 August 2005
; Stitches together specified pictures into a panorama
; Requires: Autostitch (www.autostitch.net)
; 			JHead (http://www.sentex.net/~mwandel/jhead/)
;			AMP WinOFF (http://www.ampsoft.net/utilities/WinOFF.php)

#include <array.au3>

$jheadpath = "C:\Program Files\jhead.exe"
$aspath = "C:\Program Files\AutoStitch\autostitch.exe"
$winoffpath = "C:\Program Files\AMP WinOFF\WinOFF.exe"
$queuefile = "C:\Documents\Pictures\Panorama queue.txt"
$scale = "100%"

$queuehandle = FileOpen ($queuefile, 0)
$end = 0
$asrunning = 1
While Not $end
	$folder = FileReadLine ($queuehandle)
	If @error Then
		$end = 1
	Else
		Dim $imagefile [1]
		$numimages = -1
		Do
			$line = FileReadLine ($queuehandle)
			_ArrayAdd ($imagefile, $line)
			$numimages = $numimages + 1
		Until $line = "-" Or @error
		_ArrayDelete ($imagefile, 0)
		_ArrayDelete ($imagefile, $numimages)

		;_ArrayDisplay ($imagefile, $numimages)
		; check Autostitch is running, otherwise start it
		If Not ProcessExists ("autostitch.exe") Then
			$asrunning = 0
			Run ($aspath)
			WinWaitActive ("autostitch")
		EndIf
		
		;bring the Autostitch window to the front
		WinSetState ("autostitch", "", @SW_RESTORE)
		WinActivate ("autostitch")
		
		;make sure the required output size is set
		WinMenuSelectItem ("autostitch", "", "Edit", "Options")
		WinWaitActive ("Options")
		ControlClick ("Options", "", 1002) ;Scale (%) option
		ControlSetText ("Options", "", 1019, $scale) ;Scale edit box
		ControlClick ("Options", "", 1) ;OK button
		
		WinMenuSelectItem ("autostitch", "", "File", "Open")
		WinWaitActive ("Open")
		
		ControlSetText ("Open", "", 1152, $folder)
		Sleep (2000)
		ControlClick ("Open", "", "Button2") ;Button2 is 'Open'
		
		; check no other pano.jpg windows exist. This will confuse the script later.
		; if they do, obfuscate them slightly :)
		While WinExists ("pano.jpg")
			WinSetTitle ("pano.jpg", "", "_" & WinGetTitle ("pano.jpg"))
		Wend
		
		$imagefiles = _ArrayToString ($imagefile, ":")
		$imagefiles = '"' & StringReplace ($imagefiles, ":", '" "') & '"'
		ControlSetText ("Open", "", 1152, $imagefiles)
		Sleep (1000)
		ControlClick ("Open", "", "&Open") ;Button2 is 'Open'
		
		WinWaitActive ("pano.jpg")
		; allow viewing for 5 seconds...
		Sleep (5000)
		WinClose ("pano.jpg")
		;MsgBox (0, "", "done")
		; make sure last image file in array is last one alphanumerically
		_ArraySort ($imagefile, 0, 0)
		;_ArrayDisplay ($imagefile, "")
		$lastimagefile = $imagefile [$numimages - 1]
		
		; insert an 'a' before the extension - i.e. P8091234.JPG -> P8091234a.JPG
		; This means that navigating the files alphanumerically shows the panorama bits, then the whole thing.
		$p = StringInStr ($lastimagefile, ".", 0, -1)
		$panofile = StringLeft ($lastimagefile, $p - 1) & "a" & StringTrimLeft ($lastimagefile, $p - 1)
		$panofilepath = $folder & "\" & $panofile
		FileMove ($folder & "\pano.jpg", $panofilepath)
		
		; clone EXIF info
		;ClipPut ('"' & $jheadpath & '" -te "' & $lastimagefile & '" "' & $panofile & '"')
		If $jheadpath <> "" Then
			$error = RunWait ('"' & $jheadpath & '" -te "' & $lastimagefile & '" "' & $panofile & '"', $folder, @SW_HIDE)
			If $error Then
				MsgBox (0, "", "JHead returned an error (" & $error & ") when cloning the EXIF info from " & $lastimagefile & " to " & $panofile, 5)
			EndIf	
			; set EXIF date +10sec from last image file and reset the file date from this
			;ClipPut ('"' & $jheadpath & '" -ta+0:00:10 -ft"' & $panofile & '"')
			$error =  RunWait ('"' & $jheadpath & '" -ta+0:00:10 -ft "' & $panofile & '"', $folder, @SW_HIDE)
			If $error Then
				MsgBox (0, "", "JHead returned an error (" & $error & ") when resetting the date/time of " & $panofile, 5)
			EndIf
		EndIf
	EndIf
WEnd

; close Autostitch if it wasn't running at the beginning
If Not $asrunning Then WinClose ("autostitch")

; display an always-on-top warning of the impending hibernation, allowing the user to cancel
If $winoffpath <> "" Then 
	If MsgBox (1 + 48 + 262144, "Panorama", "Hibernating in 30 seconds...", 30) <> 2 Then
		Run ('"' & $winoffpath & '" -hibernate')
	EndIf
EndIf
