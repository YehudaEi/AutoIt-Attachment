#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Program Files\AutoIt3\Icons\filetype2.ico
#AutoIt3Wrapper_Outfile=sb-Scribe_1.3.exe
#AutoIt3Wrapper_Res_Comment=T8 Programs
#AutoIt3Wrapper_Res_Description=Small Blue .atom to .csv converter
#AutoIt3Wrapper_Res_Fileversion=1.3
#AutoIt3Wrapper_Run_Debug_Mode=N
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
	SB-Scribe v1.3
		v1.1
			Featured: 
				First official version. Included GUI with progress bar and innefficient loop structure.
			Eliminated:
				Progress, for speed reasons (gathering all <entry> occurances added +/- 2 mins to overall time.
		v1.2
			Kept: 
				Tray menu for speed settings for usability.
				Excel COM for writing to .xls file
			Featured:
				A new, more efficient loop structure, but experimentation with AutoIt-written XML (non MSXML) parser 
				failed miserably at clock time, despite my best efforts for efficiency (not surprising).
			Eliminated:
				Excel COM, adopted the .csv format for speed reasons.
				The new loop structure (obviously)
		v1.3
			Kept:
				Very little, haha. Almost a complete rewrite.
			Features:
				A slightly more efficient and intelligent loop structure, adaptive $xEntry array size (still a little iffy about
				how it'll hold up), re-implementation of MSXML, new output file format, and MUCH more efficient implimentation of
				tray tip status (entries/second).
	/SB-Scribe v1.3
	
	This program processes drag-and-drop company report .atom files and outputs a .cvs file.
	
	Requirements:
	MSXML 4
#ce

;Set up Includes and Modes
#include <_XMLDomWrapper.au3>
#include <GUIConstants.au3>
#include <ExcelCOM_UDF.au3>
#include <Constants.au3>
#include <File.au3>
#include <String.au3>
#include <array.au3>

Opt("GUIOnEventMode", 1)
Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode", 1)

;Check if drag-and-drop, if not file dialog
If $CmdLine[0] > 0 Then
	$fPath = $CmdLine[1]
Else
	$fPath = FileOpenDialog("Please select the target .atom file", "G:\Documents", "Atom Feeds (*.atom)", 1 + 2)
	If $fPath = "" Then Exit
EndIf
$tOA = TimerInit()

;Build Tray Menu
$tMenu = TrayCreateMenu("Performance")
$tsFast = TrayCreateItem("Fast (high CPU load)", $tMenu, -1, 1)
TrayItemSetOnEvent(-1, "Fast")
$tsMedium = TrayCreateItem("Medium (medium CPU load)", $tMenu, -1, 1)
TrayItemSetOnEvent(-1, "Medium")
TrayItemSetState(-1, $TRAY_CHECKED)
$tsSlow = TrayCreateItem("Slower (lowest CPU load)", $tMenu, -1, 1)
TrayItemSetOnEvent(-1, "Slow")

;Open XML file in MSXML
Tip("Opening File...")
$xmlns = 'xmlns:at="http://www.w3.org/2005/Atom" xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:sy="http://purl.org/rss/1.0/modules/syndication/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
$oXML = _xmlfileopen($fPath, $xmlns, 4)
If $oXML = -1 Then
	MsgBox(0, "Error", "An error has occured while opening the .atom file. Extended information from MSXML:" & @CRLF & @CRLF & _XMLError())
	Exit
EndIf

;Quick, sloppy statistics for adaptive array size
;	Take # of <entry> occurences from original file, divide by original file size, multiply resultant by the size of the selected file
;	Multiply by 1.125 for added buffer, just to be safe
Dim $ar2D = Ceiling((1.125 * (3239 / 787 * (FileGetSize($fPath) / 1024))))

;Pre-loop variable setup
Dim $Sleep = 50
Dim $xEntry[4][$ar2D]
Global $i = 1
Dim $lEnd = False


;Pre-loop file setup
$sNum = StringInStr($fPath, ".", 0, -1) - 1
$fPath = StringTrimRight($fPath, StringLen($fPath) - $sNum) & ".csv"
$s = 1
$rec = False
While 1
	$s += 1
	If FileExists($fPath) Then
		If $rec Then
			$sNum = StringInStr($fPath, "(", 0, -1) - 1
		Else
			$sNum = StringInStr($fPath, ".", 0, -1) - 1
		EndIf
		$fPath = StringTrimRight($fPath, StringLen($fPath) - $sNum) & "(" & $s & ").csv"
		$rec = True
	Else
		ExitLoop
	EndIf
	sleep(100)
WEnd
FileWrite($fPath, '"ID","Joined Date","Activity","Activity Date"' & @CRLF)

;Initiate main engine
Tip("Processing XML. Mouseover for status.")
TraySetOnEvent($TRAY_EVENT_MOUSEOVER, "StatTip")
$tInit = TimerInit()
While $lEnd = False
	$xEntry[0][$i] = _GetFirstValue('//at:entry[' & $i & ']/at:content/at:div[@class="id"]')
	$xEntry[1][$i] = _GetFirstValue('//at:entry[' & $i & ']/at:content/at:div[@class="joinedDate"]')
	$xEntry[2][$i] = _GetFirstValue('//at:entry[' & $i & ']/at:content/at:div[@class="activity"]')
	$xEntry[3][$i] = _GetFirstValue('//at:entry[' & $i & ']/at:content/at:div[@class="activityDate"]')
	$i += 1
	Sleep($Sleep)
WEnd

;Write parsed data to .csv
Dim $sLoop = $i
Dim $fVar
Tip("Writing document...")
$tInit2 = TimerInit()
TraySetOnEvent($TRAY_EVENT_MOUSEOVER, "StatSaveTip")
For $i = 1 To $sLoop-1
    If $xEntry[1][$i] <> "" Then $xEntry[1][$i] = '"' & $xEntry[1][$i] & '"'
    $fVar &='"' & $xEntry[0][$i] & '", ' & $xEntry[1][$i] & ', ' & $xEntry[2][$i] & ', ' & $xEntry[3][$i] & @CRLF
Next
FileWrite($fPath,$fVar)

;Finish
Beep(1000, 115)
Beep(1250, 115)
Beep(2000, 150)
Tip("Conversion took " & Round((TimerDiff($tOA) / 1000) / 60, 1) & " minutes.")
ConsoleWrite(Round((TimerDiff($tOA) / 1000) / 60, 1))
TraySetOnEvent($TRAY_EVENT_MOUSEOVER, "")
Sleep(15000)

Func _GetFirstValue($xNode)
	$ret_val = _XMLGetValue($xNode)
	If isarray($ret_val) Then
		Return ($ret_val[1])
	Else
		$lEnd = true
	EndIf
EndFunc   ;==>_GetFirstValue

Func Fast()
	Uncheck()
	$Sleep = 10
	TrayItemSetState($tsFast, $TRAY_CHECKED)
EndFunc   ;==>Fast

Func Medium()
	Uncheck()
	$Sleep = 50
	TrayItemSetState($tsMedium, $TRAY_CHECKED)
EndFunc   ;==>Medium

Func Slow()
	Uncheck()
	$Sleep = 100
	TrayItemSetState($tsSlow, $TRAY_CHECKED)
EndFunc   ;==>Slow

Func Uncheck()
	TrayItemSetState($tsFast, $TRAY_UNCHECKED)
	TrayItemSetState($tsMedium, $TRAY_UNCHECKED)
	TrayItemSetState($tsSlow, $TRAY_UNCHECKED)
EndFunc   ;==>Uncheck

Func StatTip()
	Tip("Processing Entry " & $i & @CRLF & "Entries Per Second: " & Round($i / (TimerDiff($tInit) / 1000), 2))
EndFunc   ;==>StatTip

Func StatSaveTip()
	Tip("Processing Entry " & $i & @CRLF & "Entries Per Second: " & Round(($i / (TimerDiff($tInit2) / 1000)), 2) & @CRLF & "Time remaining: " & Round($i / (TimerDiff($tInit2) / 1000), 2) / ($sLoop - $i) & " seconds.")
EndFunc   ;==>StatSaveTip

Func Tip($mText)
	TrayTip("SB-Scribe Message", $mText, 5, 1)
EndFunc   ;==>Tip

Func _Exit()
	Exit
EndFunc   ;==>_Exit