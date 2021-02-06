#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=tv-icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Online TV Lista
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright mara- 2010
#AutoIt3Wrapper_Res_Field=ProductVersion|1.0
#AutoIt3Wrapper_Res_Field=ProductName|Online TV Lista
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <File.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>
#Include <GuiComboBox.au3>
Opt('GUIOnEventMode', 1)
;~ Opt('TrayMenuMode', 1)
GUICreate("Online TV Lista", 250, 120)
GUISetOnEvent($GUI_EVENT_CLOSE, 'GKIclose')
GUICtrlCreateLabel("Created by mara-", 160, 5)
GUICtrlSetColor(-1, 0x0000ff)
$combo = GUICtrlCreateCombo("http://free-bj.t-com.hr/dido/domaci.htm", 20, 30, 200, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "http://publicmedia.yolasite.com/internet-tv.php")
$button = GUICtrlCreateButton("Kreiranje liste", 170, 80)
GUICtrlSetOnEvent($button, "button")
$pgbar = GUICtrlCreateProgress(10, 82, 150, 20)
GUISetState(@SW_SHOW)

While 1
	Sleep (10)
WEnd

Func GKIclose()
	Exit
EndFunc

Func button()

If GUICtrlRead($combo) = "http://free-bj.t-com.hr/dido/domaci.htm" Then
page1()
Else
page2()
EndIf

EndFunc

Func page1()
	GUISetState(@SW_DISABLE)
	GUICtrlSetData($pgbar, 0)
FileDelete(@ScriptDir&'\temp.temp')
FileDelete(@ScriptDir&'\list.m3u')
$file = InetRead("http://free-bj.t-com.hr/dido/domaci.htm")
If @error Then
	MsgBox(16, "Greška", "Došlo je do greške pri preuzimanju liste. Moguæi razlozi: Niste spojeni sa Internetom, vaš zaštitni zid blokira ovu aplikaciju, stranica sa koje se preuzima lista nije dostupna.")
	GUISetState(@SW_ENABLE)
Else
_FileCreate(@ScriptDir&'\temp.temp')
$handle = FileOpen(@ScriptDir&'\temp.temp', 2)
FileWrite($handle, $file)
FileClose($handle)
$count = _FileCountLines(@ScriptDir&'\temp.temp')
$handle1 = FileOpen(@ScriptDir&'\temp.temp', 0)
_FileCreate(@ScriptDir&'\list.m3u')
$a = 0
$b = 1
For $i = 1 To $count
	GUICtrlSetData($pgbar, 100/$count*$i)
	$line = FileReadLine($handle1, $i)
	$find = StringInStr($line, "mms", 0, 1)
	If Not $find=0 Then
		$readline = FileReadLine($handle1, $i)
		$start = StringInStr($readline, "mms", 0, 1)
		$end = StringInStr($readline, '">', 0, 1, $start)
		$extract = StringMid($readline, $start, $end-$start)
		$chanelnamestart = StringInStr($readline, "/", 0, 3)
		$chanelnameend = StringInStr($readline, "?", 0)
		If $chanelnameend = 0 Then $chanelnameend = $end
		$channelname = StringMid($readline, $chanelnamestart+1, $chanelnameend-$chanelnamestart-1)
;~ 		MsgBox(0, "", StringMid($readline, 1, 3))
		If StringMid($readline, 1, 4) = "href" Then
			If Not $channelname = "" Then
		_FileWriteToLine(@ScriptDir&'\list.m3u', $a+1, '#EXTINF:0,00'&$b&' '&$channelname)
		_FileWriteToLine(@ScriptDir&'\list.m3u', $a+2, $extract)
		$a+=2
		$b+=1
		EndIf
		EndIf
	EndIf
Next

FileClose($handle1)
FileDelete(@ScriptDir&'\temp.temp')
MsgBox(0, "Završeno", "Lista je kreirana na slijedeæoj lokaciji: "&@ScriptDir&'\list.m3u')
GUISetState(@SW_ENABLE)
EndIf
EndFunc

Func page2()
	GUISetState(@SW_DISABLE)
	GUICtrlSetData($pgbar, 0)
	FileDelete(@ScriptDir&'\temp.temp')
FileDelete(@ScriptDir&'\list.m3u')
$file = InetRead("http://publicmedia.yolasite.com/internet-tv.php")
If @error Then
	MsgBox(16, "Greška", "Došlo je do greške pri preuzimanju liste. Moguæi razlozi: Niste spojeni sa Internetom, vaš zaštitni zid blokira ovu aplikaciju, stranica sa koje se preuzima lista nije dostupna.")
	GUISetState(@SW_ENABLE)
Else
_FileCreate(@ScriptDir&'\temp.temp')
$handle = FileOpen(@ScriptDir&'\temp.temp', 2)
FileWrite($handle, $file)
FileClose($handle)
$count = _FileCountLines(@ScriptDir&'\temp.temp')
$handle1 = FileOpen(@ScriptDir&'\temp.temp', 0)
_FileCreate(@ScriptDir&'\list.m3u')
$a = 0
$b = 1
For $i = 1 To $count
	GUICtrlSetData($pgbar, 100/600*$i)
	If $i>600 Then ExitLoop
	$line = FileReadLine($handle1, $i)
	$find = StringInStr($line, "mms", 0, 1)
	If Not $find=0 Then
		$readline = FileReadLine($handle1, $i)
		$start = StringInStr($readline, "mms", 0, 1)
		$end = StringInStr($readline, '"', 0, 1, $start)
		$extract = StringMid($readline, $start, $end-$start)
		$chanelnamestart = StringInStr($readline, '">', 0, 1, $start) +1
		$chanelnameend = StringInStr($readline, "</a>", 0, 1, $chanelnamestart)

		$channelname = StringMid($readline, $chanelnamestart+1, $chanelnameend-$chanelnamestart-1)
;~ 		MsgBox(0, $start , $chanelnamestart)
			If Not $channelname = "" Then
		_FileWriteToLine(@ScriptDir&'\list.m3u', $a+1, '#EXTINF:0,00'&$b&' '&$channelname)
		_FileWriteToLine(@ScriptDir&'\list.m3u', $a+2, $extract)
		$a+=2
		$b+=1
		EndIf
	EndIf
Next

FileClose($handle1)
FileDelete(@ScriptDir&'\temp.temp')
MsgBox(0, "Završeno", "Lista je kreirana na slijedeæoj lokaciji: "&@ScriptDir&'\list.m3u')
GUISetState(@SW_ENABLE)
EndIf
EndFunc
