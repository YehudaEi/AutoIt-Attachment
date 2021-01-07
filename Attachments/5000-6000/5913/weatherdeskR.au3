;========================================================================
; Original code by layer
; Modified by billmez to add menu and selections for regional forecasts
; and various enhancements documented in code below.
; Happy 2006 to all
;========================================================================

#include <GuiConstants.au3>
#NoTrayIcon 

; Check for program already running
$g_szVersion = "Weather 1.0"
If WinExists($g_szVersion) Then Exit ; It's already running
AutoItWinSetTitle($g_szVersion)
; Auto Resize settings so buttons and image will scale with window
Opt("GUIResizeMode", $GUI_DOCKAUTO)

Dim $pic = 1; $BS_FLAT = 0x8000
Dim $loc = "us"
; Set picture width and height to a variable
Dim $LastPic = 1, $PicH = 405, $PicW = 600
Dim $sat
Dim $refr = 300000 ; milliseconds to refresh (5 min. - see note below)

; GUI create for resizable window
$gui1 = GUICreate("Weather Desk", 600, 450, -1, -1, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

; GUI create for non-resizable window
;$gui1 = GUICreate("Weather Desk", 600, 450, -1, -1, $WS_CAPTION + $WS_SYSMENU + $WS_MINIMIZEBOX + $WS_VISIBLE)

; Test for active Internet connection with Ping
$InetActive = Ping("www.google.com")
If Not $InetActive > 0 Then
MsgBox(4112, "Connection Not Found!", "You must be connected to the Internet" & @CRLF & "to use this program")
Exit
EndIf

; Create Forecast Menu
$selectmenu = GUICtrlCreateMenu("Select Forecast Region",-1,1)  
; Menu select items place in array to more easily facilitate selecting/deselecting
	Dim $selectitem[10] = [GUICtrlCreateMenuitem ("US National",$selectmenu), GUICtrlCreateMenuitem ("North East",$selectmenu), GUICtrlCreateMenuitem ("East Central",$selectmenu), GUICtrlCreateMenuitem ("South East",$selectmenu), GUICtrlCreateMenuitem ("North Central",$selectmenu), GUICtrlCreateMenuitem ("Central",$selectmenu), GUICtrlCreateMenuitem ("South Central",$selectmenu), GUICtrlCreateMenuitem ("North West",$selectmenu), GUICtrlCreateMenuitem ("West Central",$selectmenu), GUICtrlCreateMenuitem ("South West",$selectmenu)]
	
; Set US National as default selected	
GUICtrlSetState($selectitem[0],$GUI_CHECKED)

	; Select Menu Array Assignments
	;$selectitem[0] = "US National"	
	;$selectitem[1] = "North East"
	;$selectitem[2] = "East Central"
	;$selectitem[3] = "South East"
	;$selectitem[4] = "North Central"
	;$selectitem[5] = "Central"
	;$selectitem[6] = "South Central"
	;$selectitem[7] = "North West"
	;$selectitem[8] = "West Central"
	;$selectitem[9] = "South West"
	
; create menu items to display current selection
$region = GUICtrlCreateMenu("Currently US National")
$display = GUICtrlCreateMenu("Doppler Radar")
DirCreate(@TempDir & "\WeatherMaps")

InetGet("http://image.weather.com/web/radar/us_radar_plus_usen.jpg", @TempDir & "\WeatherMaps\pic1.jpg", 1, 0)
$Button1 =  GUICtrlCreatePic(@TempDir & "\WeatherMaps\pic1.jpg", 0, 0, $PicW, $PicH)
$Button2 =  GUICtrlCreateButton("US Radar", 0, 408, 75, 20, $BS_FLAT)
$Button3 =  GUICtrlCreateButton("US Satelite", 75, 408, 75, 20, $BS_FLAT)
$Button4 =  GUICtrlCreateButton("Forecast", 150, 408, 75, 20, $BS_FLAT)
$Button5 =  GUICtrlCreateButton("Temperatures", 225, 408, 75, 20, $BS_FLAT)
$Button6 =  GUICtrlCreateButton("Current Weather", 300, 408, 85, 20, $BS_FLAT)
$Button7 =  GUICtrlCreateButton("Tropics", 385, 408, 70, 20, $BS_FLAT)
$Button8 =  GUICtrlCreateButton("Severe", 455, 408, 75, 20, $BS_FLAT)
$Button9 =  GUICtrlCreateButton("Drought", 530, 408, 70, 20, $BS_FLAT)

GUISetState(@SW_SHOW, $gui1)

; Even under the most severe conditions the NWS only updates doppler radar sweeps ever 3 minutes
; because it takes that long to complete a scan of the elevations and angles. This script would need
; direct access to NWS radar feeds to be updated even this frequently. TWC probably only updates every
; 10-15 minutes so setting a refresh time of less than 5 minutes is unnecessary. Click the button
; again to update inbetween auto refreshes.
;
; Changed AdlibEnable("_GetEcho", 180000) to a function so it can update the refresh times whenever 
; a different region is selected. Added a variable $refr to set the refresh time

_ReLoad()

While 1
   $get = GUIGetMsg()
   Select
	Case $get = $selectitem[0]
	   $loc = "us"
	   _UnCheck()
	   GUICtrlSetState($selectitem[0],$GUI_CHECKED)
	   GUICtrlSetData($region,"Currently US National")
	   _SetButtons("nat")
	   ; setting $pic to LastPic and calling GetEcho from the menu selctions will
	   ; force an update with the same button selection when a different region
	   ; is selected.
	   $pic = $LastPic
       _GetEcho()
	
		; selection regions set by variable below for each forecast type.
	Case $get = $selectitem[1]
	   $loc = "ne"
	   $sat = "northeast"
	   $prec = "ne"
	   $sev = "ne"
	   $rad = "ne"
	   _UnCheck()
	   GUICtrlSetState($selectitem[1],$GUI_CHECKED)
	   GUICtrlSetData($region,"Currently North East")
	   _SetButtons("reg")
	   $pic = $LastPic
       _GetEcho()
	Case $get = $selectitem[2]
	   $loc = "ec"
	   $sat = "east_cen"
	   $prec = "ecen"
	   $sev = "ec"
	   $rad = "ec"
	   _UnCheck()
	   GUICtrlSetState($selectitem[2],$GUI_CHECKED)
	   GUICtrlSetData($region,"Currently East Central")
	   _SetButtons("reg")
	   $pic = $LastPic
       _GetEcho()
	Case $get = $selectitem[3]
	   $loc = "se"
	   $sat = "southeast"
	   $prec = "se"
	   $sev = "se"
	   $rad = "se"
	   _UnCheck()
	   GUICtrlSetState($selectitem[3],$GUI_CHECKED)
	   GUICtrlSetData($region,"Currently South East")
	   _SetButtons("reg")
	   $pic = $LastPic
       _GetEcho()
	Case $get = $selectitem[4]
	   $loc = "nc"
	   $sat = "n_central"
	   $prec = "ncen"
	   $sev = "nc"
	   $rad = "nc"
	   _UnCheck()
	   GUICtrlSetState($selectitem[4],$GUI_CHECKED)
	   GUICtrlSetData($region,"Currently North Central")
	   _SetButtons("reg") 
	   $pic = $LastPic
       _GetEcho()
	Case $get = $selectitem[5]
	   $loc = "cen"
	   $sat = "central"
	   $prec = "cen"
	   $sev = "cn"
	   $rad = "cn"
	   _UnCheck()
	   GUICtrlSetState($selectitem[5],$GUI_CHECKED)
	   GUICtrlSetData($region,"Currently Central")
	   _SetButtons("reg")
	   $pic = $LastPic
       _GetEcho()
	Case $get = $selectitem[6]
	   $loc = "sc"
	   $sat = "s_central"
	   $prec = "scen"
	   $sev = "sc"
	   $rad = "sc" 
	   _UnCheck()
	   GUICtrlSetState($selectitem[6],$GUI_CHECKED)
	   GUICtrlSetData($region,"Currently South Central")
	   _SetButtons("reg")
	   $pic = $LastPic
       _GetEcho()
	Case $get = $selectitem[7]
	   $loc = "nw"
	   $sat = "northwest"
	   $prec = "nw"
	   $sev = "nw"
	   $rad = "nw"
	   _UnCheck()
	   GUICtrlSetState($selectitem[7],$GUI_CHECKED)
	   GUICtrlSetData($region,"Currently North West")
	   _SetButtons("reg")
	   $pic = $LastPic
       _GetEcho()
	Case $get = $selectitem[8]
	   $loc = "wc"
	   $sat = "west_cen"
	   $prec = "wcen"
	   $sev = "wc"
	   $rad = "wc"
	   _UnCheck()
	   GUICtrlSetState($selectitem[8],$GUI_CHECKED)
	   GUICtrlSetData($region,"Currently West Central")
	   _SetButtons("reg")
	   $pic = $LastPic
       _GetEcho()
	Case $get = $selectitem[9]
		$loc = "sw"
		$sat = "southwest"
		$prec = "sw"
		$sev = "sw"
		$rad = "sw"
		_UnCheck()
		GUICtrlSetState($selectitem[9],$GUI_CHECKED)
		GUICtrlSetData($region,"Currently South West")
		_SetButtons("reg")
		$pic = $LastPic
       _GetEcho()
	Case $get = -3
        Exit
	Case $get = $Button2
        $pic = 1
        _GetEcho()
    Case $get = $Button3
		$pic = 2
        _GetEcho()
    Case $get = $Button4
        $pic = 3
        _GetEcho()
    Case $get = $Button5
        $pic = 4
        _GetEcho()
    Case $get = $Button6
        $pic = 5
        _GetEcho()
    Case $get = $Button7
        $pic = 6
        _GetEcho()
	Case $get = $Button8
        $pic = 7
        _GetEcho()
	Case $get = $Button9
        $pic = 8
        _GetEcho()
	EndSelect
	$LastPic = $pic
WEnd

Func _GetEcho()
	If $pic = 1 Then
      InetGet("http://image.weather.com/web/radar/us_radar_plus_usen.jpg", @TempDir & "\WeatherMaps\pic1.jpg", 1, 0)
      $name = "\pic1.jpg"
	  GUICtrlSetData($display,"US Doppler Radar")
	  _ReLoad()
	ElseIf $pic = 2 Then
	  InetGet("http://image.weather.com/images/sat/ussat_600x405.jpg", @TempDir & "\WeatherMaps\pic2.jpg", 1, 0)
      $name = "\pic2.jpg"
	  GUICtrlSetData($display,"US Infrared Satelite")
	  _ReLoad()
	ElseIf $pic = 3 Then
	  If $loc = "us" Then
      InetGet("http://image.weather.com/web/forecast/us_wxhi1_large_usen_600.jpg", @TempDir & "\WeatherMaps\pic3.jpg", 1, 0)
	  GUICtrlSetData($display,"Forecast")
	  Else
	  InetGet("http://image.weather.com/images/maps/current/cur_" & $loc & "_720x486.jpg", @TempDir & "\WeatherMaps\pic3.jpg", 1, 0)
	  GUICtrlSetData($display,"Local Surface Weather")
	  EndIf
      $name = "\pic3.jpg"  
	  _ReLoad()
	ElseIf $pic = 4 Then
	  If $loc = "us" Then
      InetGet("http://image.weather.com/images/maps/current/acttemp_600x405.jpg", @TempDir & "\WeatherMaps\pic4.jpg", 1, 0)
	  GUICtrlSetData($display,"Temperatures")
	  Else
	  InetGet("http://image.weather.com/images/maps/current/" & $loc & "_curtemp_720x486.jpg", @TempDir & "\WeatherMaps\pic4.jpg", 1, 0)
	  GUICtrlSetData($display,"Local Temperatures")
	  EndIf
      $name = "\pic4.jpg"  
	  _ReLoad()
	ElseIf $pic = 5 Then
	  If $loc = "us" Then
	  InetGet("http://image.weather.com/images/maps/current/curwx_600x405.jpg", @TempDir & "\WeatherMaps\pic5.jpg", 1, 0)
	  GUICtrlSetData($display,"Surface Weather")
	  Else
	  InetGet("http://image.weather.com/images/maps/forecast/" & $prec & "_precfcst_600x405.jpg", @TempDir & "\WeatherMaps\pic5.jpg", 1, 0)
	  GUICtrlSetData($display,"Local Precipitation")
	  EndIf
      $name = "\pic5.jpg" 
	  _ReLoad()
	ElseIf $pic = 6 Then
	  If $loc = "us" Then
      InetGet("http://image.weather.com/images/sat/tropsat_600x405.jpg", @TempDir & "\WeatherMaps\pic6.jpg", 1, 0)
	  GUICtrlSetData($display,"Tropical Satelite")
	  Else
	  InetGet("http://image.weather.com/images/maps/special/severe_" & $sev & "_720x486.jpg", @TempDir & "\WeatherMaps\pic6.jpg", 1, 0)
	  GUICtrlSetData($display,"Local Severe Weather")
	  EndIf
      $name = "\pic6.jpg"
	  _ReLoad()
	ElseIf $pic = 7 Then
	  If $loc = "us" Then
      InetGet("http://image.weather.com/images/maps/special/severe_us_600x405.jpg", @TempDir & "\WeatherMaps\pic7.jpg", 1, 0)
	  GUICtrlSetData($display,"Severe Weather")
	  Else
	  InetGet("http://image.weather.com/web/radar/us_" & $rad & "_9regradar_large_usen.jpg", @TempDir & "\WeatherMaps\pic7.jpg", 1, 0)
	  GUICtrlSetData($display,"Local Doppler Radar")
	  EndIf
      $name = "\pic7.jpg"
	  _ReLoad()
	ElseIf $pic = 8 Then
	  If $loc = "us" Then
      InetGet("http://image.weather.com/images/maps/current/palmer_drought_720x486.jpg", @TempDir & "\WeatherMaps\pic8.jpg", 1, 0)
	  GUICtrlSetData($display,"Drought Conditions")
	  Else
	  InetGet("http://image.weather.com/images/sat/regions/" & $sat & "_sat_720x486.jpg", @TempDir & "\WeatherMaps\pic8.jpg", 1, 0)
	  GUICtrlSetData($display,"Local Infrared Satelite")
	  EndIf
      $name = "\pic8.jpg"
	  _ReLoad()
  EndIf
  ; The following will resize the image when a new selection is made
  $Winsize = WinGetClientSize ( "Weather Desk" ) ; get client window size
	$PicW = $Winsize[0] ; set pic width to window width
	$PicH = Int($Winsize[1]*.935) ; set pic height to allow for buttons in client window
	GUICtrlSetImage($Button1, @TempDir & "\WeatherMaps\" & $name) ; place new image
	GUICtrlSetPos ($Button1, 0, 0, $PicW, $PicH) ; set new image size to window size
   
EndFunc;==>_GetEcho

Func OnAutoItExit()
   AdlibDisable()
   If $gui1 Then
   GUIDelete($gui1)
   EndIf
   DirRemove(@TempDir & "\WeatherMaps\", 1)
EndFunc;==>OnAutoItExit

; Uncheck all menu items before checking current selection
Func _UnCheck()
	For $i = 0 to 9
		GUICtrlSetState($selectitem[$i],$GUI_UnCHECKED)
		Next
	EndFunc
	
; Set button display for either regional or national forecasts
Func _SetButtons($buttons)
	If $buttons = "reg" Then
		GUICtrlSetData($Button4, "Current")
		GUICtrlSetData($Button6, "Precipitation")
		GUICtrlSetData($Button7, "Severe")
		GUICtrlSetData($Button8, "Radar")
		GUICtrlSetData($Button9, "Satelite")
	Else
		$buttons = "nat"
		GUICtrlSetData($Button4, "Forecast")
		GUICtrlSetData($Button6, "Current Weather")
		GUICtrlSetData($Button7, "Tropics")
		GUICtrlSetData($Button8, "Severe")
		GUICtrlSetData($Button9, "Drought")
	EndIf
EndFunc
Func _ReLoad()
	AdlibDisable()
	AdlibEnable("_GetEcho", $refr)
EndFunc
