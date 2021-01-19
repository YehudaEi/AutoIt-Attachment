#include <Array.au3>
#include "CommMG.au3"
Dim $sErr
Dim $Latitude
Dim $Longitude
Dim $FixTime, $FixDate,	$Lat, $Lon,	$Quality, $NumberOfSatalites, $HorDilPitch, $Alt, $AltS, $Geo, $GeoS, $Status, $SpeedInKnots, $SpeedInMPH, $SpeedInKmH, $TrackAngle

HotKeySet("{ESC}", "_Exit")

_OpenComPort()
While 1
	_GetGPS()
WEnd

Func _Exit()
	_CloseComPort()
	Exit
EndFunc

Func _OpenComPort($CommPort = 3, $sBAUD = 4800, $iBits = 8, $iPar = 0, $iStop = 1, $iFlow = 0);Open specified COM port
	$OpenedPort = _CommSetPort ($CommPort, $sErr, $sBAUD, $iBits, $iPar, $iStop, $iFlow)
	If $OpenedPort = 1 Then
		Return (1)
	Else
		Return (0)
	EndIf
EndFunc   ;==>_OpenComPort

Func _CloseComPort();Closes specified COM port
	_CommClosePort ()
EndFunc   ;==>_CloseComPort

Func _GetGPS()
	$timeout = TimerInit()
	$maxtime = 800
	Dim $FixTime, $FixDate,	$Lat, $Lon,	$Quality, $NumberOfSatalites, $HorDilPitch, $Alt, $AltS, $Geo, $GeoS, $Status, $SpeedInKnots, $SpeedInMPH, $SpeedInKmH, $TrackAngle
	While 1
		$dataline = StringStripWS(_CommGetLine (), 8)
		;ConsoleWrite($dataline & @CRLF)
		If StringInStr($dataline, "GPGGA") Then
			_GPGGA($dataline)
		ElseIf StringInStr($dataline, "GPRMC") Then
			_GPGMC($dataline)
		EndIf
		If TimerDiff($timeout) > $maxtime Then ExitLoop
	WEnd
	ConsoleWrite("Time: " & $FixTime & @CRLF)
	ConsoleWrite("Date: " & $FixDate & @CRLF)
	ConsoleWrite("Latitude: " & $Lat & @CRLF)
	ConsoleWrite("Longitude: " & $Lon & @CRLF)
	ConsoleWrite("Quality: " & $Quality & @CRLF)
	ConsoleWrite("NumberOfSatalites: " & $NumberOfSatalites & @CRLF)
	ConsoleWrite("HorDilPitch: " & $HorDilPitch & @CRLF)
	ConsoleWrite("Altitude: " & $Alt & $AltS & @CRLF)
	ConsoleWrite("Geoidal: " & $Geo & $GeoS & @CRLF)
	ConsoleWrite("Status: " & $Status & @CRLF)
	ConsoleWrite("Speed(knots): " & $SpeedInKnots & @CRLF)
	ConsoleWrite("Speed(MPH): " & $SpeedInMPH & @CRLF)
	ConsoleWrite("Speed(km/h): " & $SpeedInKmH & @CRLF)
	ConsoleWrite("Track Angle: " & $TrackAngle & @CRLF)
EndFunc   ;==>_GetGPS


Func _GPGGA($data)
	$GPGGA_Split = StringSplit($data, ",")

	$FixTime = $GPGGA_Split[2]
	$Lat = _FormatLatLon($GPGGA_Split[3], $GPGGA_Split[4])
	$Lon = _FormatLatLon($GPGGA_Split[5], $GPGGA_Split[6])
	$Quality = $GPGGA_Split[7]
	$NumberOfSatalites = $GPGGA_Split[8]
	$HorDilPitch = $GPGGA_Split[9]
	$Alt = $GPGGA_Split[10] * 3.2808399
	$AltS = $GPGGA_Split[11]
	$Geo = $GPGGA_Split[12]
	$GeoS = $GPGGA_Split[13]
EndFunc   ;==>_GPGGA

Func _GPGMC($data)
	$GPGMC_Split = StringSplit($data, ",")

	$FixTime = $GPGMC_Split[2]
	$Status = $GPGMC_Split[3]
	$Lat = _FormatLatLon($GPGMC_Split[4], $GPGMC_Split[5])
	$Lon = _FormatLatLon($GPGMC_Split[6], $GPGMC_Split[7])
	$SpeedInKnots = $GPGMC_Split[8]
	$SpeedInMPH = $GPGMC_Split[8] * 1.15 & "MPH" 
	$SpeedInKmH = $GPGMC_Split[8] * 1.85200 & "km/h" 
	$TrackAngle = $GPGMC_Split[9]
	$FixDate = $GPGMC_Split[10]
EndFunc   ;==>_GPGMC
	
Func _FormatLatLon($inLatLon, $inLatLonNS)
	$Return = ''
	$splitlatlon = StringSplit($inLatLon, ".")
	If $splitlatlon[0] = 2 Then
		$LatLonD = StringMid((StringRight($splitlatlon[1], 2) & "." & StringRight($splitlatlon[2], 4)) / 60, 2, 10)
		$ufLatLon = StringLeft($splitlatlon[1], StringLen($splitlatlon[1]) - 2) & $LatLonD
		$Return = $inLatLonNS & ' ' & StringFormat('%0.7f', $ufLatLon);set return
	EndIf
	Return($Return)
EndFunc   ;==>_FormatLatLon