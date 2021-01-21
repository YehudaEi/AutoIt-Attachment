; ----------------------------------------------------------------------------
;
; from original Weatherxml.au3
; Original Author:  Larry Bailey <psichosis@tvn.net>
;
; Script Function:
;    Downloads and parses xml file from "http://www.nws.noaa.gov/data/current_obs/"
;   and displays weather information for the area that was downloaded
;    
;
; Modifications: Bill Mezian
; 	Added:
;		Multiple stations
;		Context Menu Selections
;		Connection test
;		Error checking
;	Modified:
;		Display GUI
;		Weather Content
; ----------------------------------------------------------------------------
; station codes are available from the following web site:
; http://www.nws.noaa.gov/data/current_obs/
; 
; Current default selections:
; KMYR Myrtle Beach SC, KCRE North Myrtle Beach SC, KFLO Florence SC, KUDG Darlington SC, KCHS Charleston SC, KILM Wilmington NC

#include<guiconstants.au3>

Dim $g_szVersion = "CWeather 1.0"
If WinExists($g_szVersion) Then Exit ; It's already running
AutoItWinSetTitle($g_szVersion)
Opt("GUIResizeMode", $GUI_DOCKAUTO)

HotKeySet("{ESC}", "_Exit")
HotKeySet("!u", "_update")

Dim $Wdata, $msg, $station
$Station = "KMYR"

GuiCreate("Current Weather Conditions", 280, 106, -1, -1, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

Dim $InetActive = Ping("www.yahoo.com")
If Not $InetActive > 0 Then
	for $i = 1 to 3
		Sleep(3000)
		$InetActive = Ping("www.yahoo.com")
		If $InetActive = 0 Then
			ExitLoop
		EndIf
	Next	
MsgBox(4112, "Connection Not Found!", "You must be connected to the Internet" & @CRLF & "to use this program")
Exit
EndIf

Dim $WEdit = GUICtrlCreateLabel("", 5, 5, 270, 85, $ES_READONLY + $SS_SUNKEN)
Dim $statuslabel = GUICtrlCreateLabel ("  Right-click forecast window for more options.",0,92,280,13)
GUICtrlSetFont ($statuslabel, "7") 
GUISetState()

$contextmenu = GUICtrlCreateContextMenu($WEdit)
$locationMenu = GUICtrlCreateMenu("Location", $contextmenu)
$Locitem1 = GUICtrlCreateMenuitem("Myrtle Beach, SC", $locationMenu )
$Locitem2 = GUICtrlCreateMenuitem("North Myrtle Beach, SC", $locationMenu )
$Locitem3 = GUICtrlCreateMenuitem("Florence, SC", $locationMenu )
$Locitem4 = GUICtrlCreateMenuitem("Darlington, SC", $locationMenu )
$Locitem5 = GUICtrlCreateMenuitem("Charleston, SC", $locationMenu )
$Locitem6 = GUICtrlCreateMenuitem("Wilmington, NC", $locationMenu )
$sep1 = GUICtrlCreateMenuitem("", $contextmenu)
$updateitem = GUICtrlCreateMenuitem("Update Now", $contextmenu)
$copyitem = GUICtrlCreateMenuitem("Copy to Clipboard", $contextmenu)
$aboutitem = GUICtrlCreateMenuitem("About", $contextmenu)
$exititem = GUICtrlCreateMenuitem("Quit", $contextmenu)
_Check($Locitem1)
_Update()
While 1
    $msg = GUIGetMsg()
    Select
	Case $msg = $GUI_EVENT_CLOSE Or $msg = $exititem 
		ExitLoop
	Case $msg = $updateitem 
		_Update()
	Case $msg = $copyitem	
		ClipPut(GUICtrlRead($WEdit))
	Case $msg = $Locitem1	
		_unCheck()
		_Check($Locitem1)
		$Station = "KMYR"
		_Update()
	Case $msg = $Locitem2
		_unCheck()
		_Check($Locitem2)
		$Station = "KCRE"
		_Update()
	Case $msg = $Locitem3
		_unCheck()
		_Check($Locitem3)
		$Station = "KFLO"
		_Update()
	Case $msg = $Locitem4	
		_unCheck()
		_Check($Locitem4)
		$Station = "KUDG"
		_Update()
	Case $msg = $Locitem5	
		_unCheck()
		_Check($Locitem5)
		$Station = "KCHS"
		_Update()
	Case $msg = $Locitem6	
		_unCheck()
		_Check($Locitem6)
		$Station = "KILM"
		_Update()
	Case $msg = $aboutitem
			MsgBox(0, "About CC weather", "Weather data is from the National Weather" & @CRLF & "Service and is not official.")
	EndSelect		
    Wend
    
Func _Update()
	
    SplashTextOn("Updating", "Retrieving Data", 100, 30, -1, -1, 33, "", 9, 800)
	
	$WdataAvail = Inetget("http://www.nws.noaa.gov/data/current_obs/" & $Station & ".xml", @TempDir & "\weather.xml", 1, 0)
	
	If $WdataAvail <> 1 Then
	for $i = 1 to 3
		Sleep(3000)
		$WdataAvail = Inetget("http://www.nws.noaa.gov/data/current_obs/" & $Station & ".xml", @TempDir & "\weather.xml", 1, 0)
		If $WdataAvail = 1 Then
			ExitLoop
		EndIf
	Next	
MsgBox(262144, "Data Not Available!", "The Weather data is currently not available." & @CRLF & "Please try later. CC weather will now exit.")
Exit
EndIf
		 
	$oXml = ObjCreate("Msxml2.DOMDocument.3.0")
	$oXml.async=0
	$oXml.Load(@tempdir & "\weather.xml")
	$oXmlroot = $oXml.documentElement
		For $oXmlNode In $oXmlroot.childNodes
			Select
				Case $oXmlnode.nodename = "observation_time"
					$time = $oXmlnode.text
				Case $oXmlnode.nodename = "location"
					$loc = $oXmlnode.text
				Case $oXmlnode.nodename = "temperature_string"
					$tmp = $oXmlnode.text
				Case $oXmlnode.nodename = "weather"
					$wea = $oXmlnode.text	
				Case $oXmlnode.nodename = "relative_humidity"
					$rh = $oXmlnode.text
				Case $oXmlnode.nodename = "wind_string"
					$windstr = $oXmlnode.text	
				Case $oXmlnode.nodename = "wind_dir"
					$winddir = $oXmlnode.text
				Case $oXmlnode.nodename = "pressure_string"
					$pr = $oXmlnode.text
				Case $oXmlnode.nodename = "heat_index_string"
					$index = $oXmlnode.text
				Case $oXmlnode.nodename = "wind_mph"
					$wind = $oXmlnode.text
				Case $oXmlnode.nodename = "windchill_string"
					$chill = $oXmlnode.text
				Case $oXmlnode.nodename = "visibility_mi"
					$vis = $oXmlnode.text
			EndSelect
		Next
		
	GUICtrlSetData($WEdit, "")
		$Wdata = ""
		$Wdata &= " " & $loc & @crlf
		$Wdata &= " Last Update at: " & StringTrimLeft($time, 16) & @crlf
		$Wdata &= " Current Conditions: " & $wea & ", " & $tmp & @crlf
		$Wdata &= " Humidity: " & $rh & "%, Barometer: " & $pr & @crlf
		$Wdata &= " Wind " & $windstr & @crlf
			If $chill <> "NA" Then
				$Wdata &= " Wind Chill: " & $chill & ","
			ElseIf $index <> "NA" Then
			$Wdata &= " Heat Index: " & $index & ","
			EndIf
		$Wdata &= " Visibility: " & $vis & " mi" & @crlf
	GUICtrlSetData($WEdit, $Wdata)
	SplashOff()

EndFunc

Func _Exit()
    Exit
EndFunc
Func OnAutoItExit()
	If FileExists(@TempDir & "\weather.xml") Then
		FileDelete(@TempDir & "\weather.xml")
	EndIf	
EndFunc

	Func _unCheck()
	GUICtrlSetState($Locitem1,$GUI_UnCHECKED)
	GUICtrlSetState($Locitem2,$GUI_UnCHECKED)
	GUICtrlSetState($Locitem3,$GUI_UnCHECKED)
	GUICtrlSetState($Locitem4,$GUI_UnCHECKED)
	GUICtrlSetState($Locitem5,$GUI_UnCHECKED)
EndFunc
Func _Check($Mitem)
	GUICtrlSetState($Mitem,$GUI_CHECKED)
	EndFunc
