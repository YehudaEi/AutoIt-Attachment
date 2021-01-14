#include <file.au3>
#include <GUIConstants.au3>
$Form1 = GUICreate("MY GPS", 194, 172, 192, 125)
GUICtrlCreateLabel("Latitude:", 8, 16, 45, 17)
GUICtrlCreateLabel("Longitude:", 8, 40, 54, 17)
$lat = GUICtrlCreateLabel("N/A", 72, 16, 120, 17)
$long = GUICtrlCreateLabel("N/A", 72, 40, 120, 17)
GUICtrlCreateLabel("Satellites:", 8, 64, 49, 17)
$sat = GUICtrlCreateLabel("N/A", 72, 64, 120, 17)
GUICtrlCreateLabel("Altitude:", 8, 88, 42, 17)
$alt = GUICtrlCreateLabel("N/A", 72, 88, 120, 17)
GUISetState(@SW_SHOW)

While 1
	If GuiGetMsg() = $GUI_EVENT_CLOSE Then Exit
	$line = _FileCountLines( @ScriptDir & "\GPS.log" )
	$data = FileReadLine( @ScriptDir & "\GPS.log", $line )
	If StringInStr( $data, "$GPGGA" ) Then
		$data = StringSplit( $data, "," )
			If $data[0] > 9 Then
				
				GUICtrlSetData( $lat, $data[4] & $data[3] )
				GUICtrlSetData( $long, $data[6] & $data[5] )
				GUICtrlSetData( $sat, $data[8] )
				GUICtrlSetData( $alt, $data[10] )
			EndIf
	EndIf
WEnd
;$GPRMC,011843.358,A,#include <GUIConstants.au3>
; == GUI generated with Koda ==
;$GPGGA,011844.358,4134.2291,N,08801.1210,W,1,07,1.2,204.1,M,-34.0,M,0.0,0000*46
;$GPGSA,A,3,08,28,11,27,17,19,26,,,,,,2.2,1.2,1.8*35