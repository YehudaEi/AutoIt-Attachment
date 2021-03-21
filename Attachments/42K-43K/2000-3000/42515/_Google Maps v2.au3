#include-once
#include <GUIConstants.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <IE.au3>

#Region Header
#cs
	Title:   		Google Maps v2 UDF Library for AutoIt3
	Filename:  		Google Maps v2.au3
	Description: 	A collection of functions for creating and controlling a Google Maps control in AutoIT
	Author:   		seangriffin/Igor Kerekeš <Kescho>
	Version:  		V2.0
 	Last Update: 	2013-11-20
	Requirements: 	AutoIt3 3.2 or higher
	Changelog:		N/A
#ce
#EndRegion Header

#Region Global Variables and Constants
Global $lang = "en", $geocode_line, $bounds, $streetview = False
Global $country = False, $address_is_latlng = False
Global $total_distance = 0
Global $gtest, $gmap
#EndRegion Global Variables and Constants

#Region Core functions

#region _GUICtrlGoogleMap_GetLatLng()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_GetLatLng()
; Description ...:	Converts an address into a latitude and longitude array.
; Syntax.........:	_GUICtrlGoogleMap_GetLatLng($address)
; Parameters ....:	$address		- the address (either a location or latitude and longitude) to convert
;									  ie. both "Sydney, New South Wales, Australia" and "-34.397, 150.644" are valid.
; Return values .: 	On Success		- Returns an array with the latitude and longitude of the address.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:	Igor Kerekeš <Kescho>
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
func _GUICtrlGoogleMap_GetLatLng($address)

	Local $latlng[2], $latlng_search = 0, $address_part, $oHTTP, $HTMLSource

	$address_part = StringSplit($address, ",")
	_ArrayDelete($address_part, 0)

	; if the geocode is a lat long
	if UBound($address_part) = 2 and IsNumber($address_part[0]) = True and IsNumber($address_part[1]) = True Then
		$address_is_latlng = True
		$latlng[0] = StringStripWS($address_part[0], 3)
		$latlng[1] = StringStripWS($address_part[1], 3)
	Else
		; convert the address to a lat long
		$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
		$oHTTP.Open("GET","http://maps.google.com/maps/api/geocode/json?address=" & $address & "&sensor=false&")
		$oHTTP.Send()
		$HTMLSource = $oHTTP.Responsetext

		$geocode_line = StringSplit($HTMLSource, @LF, 1)

		For $latlng_search = 1 To $geocode_line[0]
			If StringInStr($geocode_line[$latlng_search], """location"" : {") Then
				$latlng[0] = $geocode_line[$latlng_search + 1]
				$latlng[0] = StringStripWS(StringReplace(StringReplace($latlng[0], """lat"" :", ""), ",", ""), 3)
				$latlng[1] = $geocode_line[$latlng_search + 2]
				$latlng[1] = StringStripWS(StringReplace(StringReplace($latlng[1], """lng"" :", ""), ",", ""), 3)
			EndIf
			;if location is country...
			If StringInStr($geocode_line[$geocode_line[0] - 5], "         ""types"" : [ ""country"", ""political"" ]") Then
				$country = True
;~ 				$bounds[0] = $geocode_line[$geocode_line[0] - 25]
;~ 				$bounds[0] = StringStripWS(StringReplace(StringReplace($bounds[0], """lat"" :", ""), ",", ""), 3); <== SW lat
;~ 				$bounds[1] = $geocode_line[$geocode_line[0] - 24]
;~ 				$bounds[1] = StringStripWS(StringReplace(StringReplace($bounds[1], """lng"" :", ""), ",", ""), 3); <== SW lng
;~ 				$bounds[2] = $geocode_line[$geocode_line[0] - 29]
;~ 				$bounds[2] = StringStripWS(StringReplace(StringReplace($bounds[2], """lat"" :", ""), ",", ""), 3); <== NE lat
;~ 				$bounds[3] = $geocode_line[$geocode_line[0] - 28]
;~ 				$bounds[3] = StringStripWS(StringReplace(StringReplace($bounds[3], """lng"" :", ""), ",", ""), 3); <== NE lng
			EndIf
		Next
	EndIf

	Return $latlng
EndFunc
#endregion

#region _GUICtrlGoogleMap_Create()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_Create()
; Description ...:	Creates a Google Map control.
; Syntax.........:	_GUICtrlGoogleMap_Create(ByRef $gmap, $left, $top, $width, $height, $address, $zoom = 8, $marker = 1, $streetview = True, $overview_map = false, $map_type = 0, $navigation_style = 0, $scale_style = 0, $map_type_style = 0, $lang = "en", $weather_unit = "C")
; Parameters ....:	$gmap				- The embedded Google Map object, required by the _GUICtrlGoogleMap functions below.
;					$left				- The left side of the control.
;					$top				- The top of the control.
;					$width				- The width of the control.
;					$height				- The height of the control.
;					$address			- An address (either a location or latitude and longitude) to center the map on
;									  	  ie. both "Sydney, New South Wales, Australia" and "-34.397, 150.644" are valid.
;					$zoom				- An initial map zoom level.
;					$marker				- 0 = Disable the marker for the above address
;									  	  1 = Enable the marker for the above address
;					$streetview			- A boolean indicating whether a streetview control is Enabled or Disabled.
;					$overview_map		- A boolean indicating whether a small overview map is Enabled or Disabled
;					$map_type			- 0 = Sets the map type to standard
;										  1 = Sets the map type to satellite
;										  2 = Sets the map type to hybrid
;									  	  3 = Sets the map type to terrain
;					$navigation_style	- 0 = Disable the Navigation control
;										  1 = Enable the Navigation control with a small style
;										  2 = Enable the Navigation control with a zoom pan style
;									  	  3 = Enable the Navigation control with a android style
;									  	  4 = Enable the Navigation control with a default style
;					$scale_style		- 0 = Disable the Scale control
;									  	  1 = Enable the Scale control
;					$map_type_style		- 0 = Disable the MapType control
;									  	  1 = Enable the MapType control with a horizontal bar style
;									  	  2 = Enable the MapType control with a dropdown menu style
;									  	  3 = Enable the MapType control with a default style
;					$lang				- (Optional)
;										  Sets the language for Google Maps controls, directions and labels localization.
;										  For available languages see: http://code.google.com/intl/sk/apis/maps/faq.html#languagesupport
;										  Default language = en
;					$weather_unit		- Unit for displaying weather conditions
;										  Default = C (C=CELSIUS, F=FAHRENHEIT)
; Return values .: 	On Success			- Returns the identifier (controlID) of the new control.
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......:	Igor Kerekeš <Kescho>
; Remarks .......:	This function must be used before any other function in the UDF is used.
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_Create(ByRef $gmap, $left, $top, $width, $height, $address, $zoom = 8, $marker = 1, $streetview = True, $overview_map = False, $map_type = 0, $navigation_style = 0, $scale_style = 0, $map_type_style = 0, $lang = "en", $weather_unit = "C")

	Local $onload_marker_options, $weather_unit_options

	If $marker = 1 Then
		$onload_marker_options = _
		"        marker = new google.maps.Marker({" & @CRLF & _
        "            position: latlng, " & @CRLF & _
        "            map: map," & @CRLF & _
		"            clickable: false" & @CRLF & _
        "        });" & @CRLF & _
		"//        markersArray.push(marker);"
	Else
		$onload_marker_options = ""
	EndIf

	If $weather_unit = "C" Then
		$weather_unit_options = "CELSIUS"
	ElseIf $weather_unit = "F" Then
		$weather_unit_options = "FAHRENHEIT"
	EndIf

	If $address_is_latlng = True Then
		$bounds = ""
	Else
		$bounds = _
		"        var geocoder = new google.maps.Geocoder();" & @CRLF & _
		"            geocoder.geocode({""address"": """ & $address & """}, function (results, status) {" & @CRLF & _
		"                var ne = results[0].geometry.viewport.getNorthEast();" & @CRLF & _
        "                var sw = results[0].geometry.viewport.getSouthWest();" & @CRLF & _
        "                map.fitBounds(results[0].geometry.viewport);" & @CRLF & _
        "            });"
	EndIf

	Local Const $navigation_style_html[5] = [ _
		"", _
		"navigationControl: true, navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL}, ", _
		"navigationControl: true, navigationControlOptions: {style: google.maps.NavigationControlStyle.ZOOM_PAN}, ", _
		"navigationControl: true, navigationControlOptions: {style: google.maps.NavigationControlStyle.ANDROID}, ", _
		"navigationControl: true, navigationControlOptions: {style: google.maps.NavigationControlStyle.DEFAULT}, "]
	Local Const $scale_style_html[2] = [ _
		"", _
		"scaleControl: true, "]
	Local Const $map_type_style_html[4] = [ _
		"", _
		"mapTypeControl: true, mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR}, ", _
		"mapTypeControl: true, mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU}, ", _
		"mapTypeControl: true, mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DEFAULT}, "]
	Local Const $map_type_html[4] = [ _
		"mapTypeId: google.maps.MapTypeId.ROADMAP", _
		"mapTypeId: google.maps.MapTypeId.SATELLITE", _
		"mapTypeId: google.maps.MapTypeId.HYBRID", _
		"mapTypeId: google.maps.MapTypeId.TERRAIN"]
	Local $latlng[2]

	$latlng = _GUICtrlGoogleMap_GetLatLng($address)

	Local $html1a = _
	"<html>" & @CRLF & _
	"<head>" & @CRLF & _
	"    <title>Google Maps JavaScript API v3 Example: Directions Draggable</title>" & @CRLF & _
	"    <meta name=""viewport"" content=""initial-scale=1.0, user-scalable=no"">" & @CRLF & _
	"    <meta meta http-equiv=""content-type"" content=""text/html; charset=UTF-8"">" & @CRLF & _
	"    <link href=""http://code.google.com/apis/maps/documentation/javascript/examples/default.css"" rel=""stylesheet"" type=""text/css"" />" & @CRLF & _
	"    <style type=""text/css"">" & @CRLF & _
    "       #map_canvas { height: 100%; width: 100%; }" & @CRLF & _
	"    </style>" & @CRLF & _
	"    <script type=""text/javascript"" src=""http://maps.googleapis.com/maps/api/js?sensor=false&libraries=geometry,places,weather&language=" & StringLower($lang) & """></script>" & @CRLF & _
	"    <script type=""text/javascript"">" & @CRLF & _
	"        var rendererOptions = {draggable: true};" & @CRLF & _
	"        var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);" & @CRLF & _
	"        var directionsService = new google.maps.DirectionsService();" & @CRLF & _
	"        var map;" & @CRLF & _
	"        var geocoder = new google.maps.Geocoder();" & @CRLF & _
	"        var latlng = new google.maps.LatLng(" & $latlng[0] & "," & $latlng[1] & ");" & @CRLF & _
	"        var markersArray = [];" & @CRLF & _
	"        var totalDistance = 0;" & @CRLF & _
	"        var totalDuration = 0;" & @CRLF & _
	"        var totalDetails;" & @CRLF & _
	"        var marker;" & @CRLF & _
	"        var markerPosition;" & @CRLF & _
	"        var markerAddress;" & @CRLF & _
	"        var updateLATLNG;" & @CRLF & _
	"        var updateLAT;" & @CRLF & _
	"        var updateLNG;" & @CRLF & _
	"        var updateADDRESS;" & @CRLF & _
	"        var weatherLayer;" & @CRLF & _
	"        var zoomLevel = 0;" & @CRLF & _
	"        function initialize() {" & @CRLF & _
	"        document.body.scroll = ""no"";" & @CRLF

	If $country = True Then
		Local $html1b = _
		"        var myOptions = {" & @CRLF & _
		"            disableDefaultUI: true, " & @CRLF & _
		"            " & $navigation_style_html[$navigation_style] & @CRLF & _
		"            streetViewControl: " & StringLower($streetview) & ", " & @CRLF & _
		"            overviewMapControl: " & StringLower($overview_map) & ", " & @CRLF & _
		"            " & $scale_style_html[$scale_style] & @CRLF & _
		"            " & $map_type_style_html[$map_type_style] & @CRLF & _
		"            " & $map_type_html[$map_type] & @CRLF & _
		"        };" & @CRLF & _
		"        weatherLayer = new google.maps.weather.WeatherLayer({" & @CRLF & _
		"            clickable: false," & @CRLF & _
		"            suppressInfoWindows: true," & @CRLF & _
        "            temperatureUnits: google.maps.weather.TemperatureUnit." & $weather_unit_options & @CRLF & _
        "        });" & @CRLF & _
		"        map = new google.maps.Map(document.getElementById(""map_canvas""), myOptions);" & @CRLF & _
		"        " & $onload_marker_options & @CRLF & _
		"        " & $bounds & @CRLF & _
		"        directionsDisplay.setMap(map);" & @CRLF & _
		"        google.maps.event.addListener(directionsDisplay, 'directions_changed', function() {" & @CRLF & _
		"            computeTotalDistance(directionsDisplay.directions);" & @CRLF & _
		"        });" & @CRLF & _
		"        var boundsChangedListener = google.maps.event.addListener(map, ""bounds_changed"", function(event){" & @CRLF & _
		"            zoomLevel = map.getZoom();" & @CRLF & _
		"            google.maps.event.removeListener(boundsChangedListener);" & @CRLF & _
		"        });" & @CRLF & _
		"        google.maps.event.addListener(map, ""zoom_changed"", function() {" & @CRLF & _
		"            zoomLevel = map.getZoom();" & @CRLF & _
		"        });" & @CRLF & _
		"        updateMarkerPosition(latlng);" & @CRLF & _
		"        geocodePosition(latlng);" & @CRLF & _
		"//        setTimeout(function() {zoomLevel = map.getZoom()}, 250);" & @CRLF & _
		"//        zoomLevel = map.getZoom();" & @CRLF & _
		"        setTimeout(getMapZoomLevel(), 250);" & @CRLF & _
		"    }" & @CRLF
	Else
		Local $html1b = _
		"        var myOptions = {" & @CRLF & _
		"            disableDefaultUI: true," & @CRLF & _
		"            zoom: " & $zoom & ", " & @CRLF & _
		"            center: latlng, " & @CRLF & _
		"            " & $navigation_style_html[$navigation_style] & @CRLF & _
		"            streetViewControl: " & StringLower($streetview) & ", " & @CRLF & _
		"            overviewMapControl: " & StringLower($overview_map) & ", " & @CRLF & _
		"            " & $scale_style_html[$scale_style] & @CRLF & _
		"            " & $map_type_style_html[$map_type_style] & @CRLF & _
		"            " & $map_type_html[$map_type] & @CRLF & _
		"        };" & @CRLF & _
		"        weatherLayer = new google.maps.weather.WeatherLayer({" & @CRLF & _
		"            clickable: false," & @CRLF & _
		"            suppressInfoWindows: true," & @CRLF & _
        "            temperatureUnits: google.maps.weather.TemperatureUnit." & $weather_unit_options & @CRLF & _
        "        });" & @CRLF & _
		"        map = new google.maps.Map(document.getElementById(""map_canvas""), myOptions);" & @CRLF & _
		"        " & $onload_marker_options & @CRLF & _
		"        directionsDisplay.setMap(map);" & @CRLF & _
		"        google.maps.event.addListener(directionsDisplay, 'directions_changed', function() {" & @CRLF & _
		"            computeTotalDistance(directionsDisplay.directions);" & @CRLF & _
		"        });" & @CRLF & _
		"        var boundsChangedListener = google.maps.event.addListener(map, ""bounds_changed"", function(event){" & @CRLF & _
		"            zoomLevel = map.getZoom();" & @CRLF & _
		"            google.maps.event.removeListener(boundsChangedListener);" & @CRLF & _
		"        });" & @CRLF & _
		"        google.maps.event.addListener(map, ""zoom_changed"", function() {" & @CRLF & _
		"            zoomLevel = map.getZoom();" & @CRLF & _
		"        });" & @CRLF & _
		"        updateMarkerPosition(latlng);" & @CRLF & _
		"        geocodePosition(latlng);" & @CRLF & _
		"//        setTimeout(function() {zoomLevel = map.getZoom()}, 250);" & @CRLF & _
		"//        zoomLevel = map.getZoom();" & @CRLF & _
		"        setTimeout(getMapZoomLevel(), 250);" & @CRLF & _
		"    }" & @CRLF
	EndIf

	Local $html1c = _
	"        function calcRoute(start, end, travel_mode_num, wp1, wp2, wp3, wp4) {" & @CRLF & _
	"            directionsDisplay.setMap(map);" & @CRLF & _
	"            var wpt = [wp1, wp2, wp3, wp4];" & @CRLF & _
	"            var waypts = [];" & @CRLF & _
	"            for (i = 0; i < 4; i++) {" & @CRLF & _
	"                if (wpt[i] != ' ') {" & @CRLF & _
	"                    waypts.push({location: wpt[i]});" & @CRLF & _
	"                };" & @CRLF & _
	"            }" & @CRLF & _
	"            var travel_mode = [google.maps.DirectionsTravelMode.DRIVING, google.maps.DirectionsTravelMode.WALKING, google.maps.DirectionsTravelMode.BICYCLING];" & @CRLF & _
	"            var request = {" & @CRLF & _
	"                origin: start," & @CRLF & _
	"                destination: end," & @CRLF & _
	"//                waypoints:[{location: ""Rudná, SK""}, {location: ""Jovice, SK""}, {location: ""Nadabula, SK""}, {location: ""Èuèma, SK""}]," & @CRLF & _
	"                waypoints: waypts," & @CRLF & _
	"                travelMode: travel_mode[travel_mode_num]" & @CRLF & _
	"            };" & @CRLF & _
	"            directionsService.route(request, function(response, status) {" & @CRLF & _
	"                if (status == google.maps.DirectionsStatus.OK) {" & @CRLF & _
	"                    directionsDisplay.setDirections(response);" & @CRLF & _
	"                }" & @CRLF & _
	"            });" & @CRLF & _
	"            zoomLevel = map.getZoom();" & @CRLF & _
	"        }" & @CRLF & _
	"        function computeTotalDistance(result) {" & @CRLF & _
	"            totalDistance = 0;" & @CRLF & _
	"            totalDuration = 0;" & @CRLF & _
	"            var myroute = result.routes[0];" & @CRLF & _
	"            for (i = 0; i < myroute.legs.length; i++) {" & @CRLF & _
	"                totalDistance += myroute.legs[i].distance.value;" & @CRLF & _
	"                totalDuration += myroute.legs[i].duration.value;" & @CRLF & _
	"            }" & @CRLF & _
	"            totalDetails = totalDistance + ""~"" + totalDuration + ""\n"";" & @CRLF & _
	"            for (i = 0; i < myroute.legs.length; i++) {" & @CRLF & _
	"				 totalDetails = totalDetails + myroute.legs[i].start_address + ""\n"";" & @CRLF & _
	"                totalDetails = totalDetails + myroute.legs[i].distance.value + ""~"" + myroute.legs[i].duration.value + ""\n"";" & @CRLF & _
	"                for (x = 0; x < myroute.legs[i].steps.length; x++) {" & @CRLF & _
	"                    totalDetails = totalDetails + (x + 1) + "".~"" + myroute.legs[i].steps[x].instructions + ""~"" + myroute.legs[i].steps[x].distance.value + ""\n"";" & @CRLF & _
	"                }" & @CRLF & _
	"                totalDetails = totalDetails + myroute.legs[i].end_address + ""\n"";" & @CRLF & _
	"            }" & @CRLF & _
	"        }" & @CRLF & _
	"        function move_map(address, zoom, loc_marker) {" & @CRLF & _
	"            if (loc_marker == 1) {" & @CRLF & _
	"                directionsDisplay.setMap(null);" & @CRLF & _
	"                geocoder.geocode( {""address"": address}, function(results, status) {" & @CRLF & _
	"                    if (status == google.maps.GeocoderStatus.OK) {" & @CRLF & _
	"                        map.setCenter(results[0].geometry.location);" & @CRLF & _
	"                        marker = new google.maps.Marker({" & @CRLF & _
	"                            map: map," & @CRLF & _
	"                            position: results[0].geometry.location," & @CRLF & _
	"                            draggable: true" & @CRLF & _
	"                        });" & @CRLF & _
	"                        markersArray.push(marker);" & @CRLF & _
	"                        updateMarkerPosition(results[0].geometry.location);" & @CRLF & _
	"                        geocodePosition(results[0].geometry.location);" & @CRLF & _
  	"                        google.maps.event.addListener(marker, ""drag"", function() {" & @CRLF & _
	"                            updateMarkerPosition(marker.getPosition());" & @CRLF & _
	"                        });" & @CRLF & _
	"                        google.maps.event.addListener(marker, ""dragend"", function() {" & @CRLF & _
	"                            geocodePosition(marker.getPosition());" & @CRLF & _
	"                        });" & @CRLF & _
	"//                        google.maps.event.addListener(map, ""zoom_changed"", function() {" & @CRLF & _
	"//                            zoomLevel = map.getZoom();" & @CRLF & _
	"//                            map.setCenter(marker.getPosition());" & @CRLF & _
	"//                        });" & @CRLF & _
	"                    } else {" & @CRLF & _
	"                        alert(""Geocode was not successful for the following reason: "" + status);" & @CRLF & _
	"                    }" & @CRLF & _
	"                });" & @CRLF & _
	"            } else if (loc_marker == 0) {" & @CRLF & _
	"                directionsDisplay.setMap(null);" & @CRLF & _
	"                geocoder.geocode( {""address"": address}, function(results, status) {" & @CRLF & _
	"                    if (status == google.maps.GeocoderStatus.OK) {" & @CRLF & _
	"                        map.setCenter(results[0].geometry.location);" & @CRLF & _
	"                        updateMarkerPosition(results[0].geometry.location);" & @CRLF & _
	"                        geocodePosition(results[0].geometry.location);" & @CRLF & _
  	"//                        google.maps.event.addListener(map, ""zoom_changed"", function() {" & @CRLF & _
	"//                            zoomLevel = map.getZoom();" & @CRLF & _
	"//                            map.setCenter(marker.getPosition());" & @CRLF & _
	"//                        });" & @CRLF & _
	"                    } else {" & @CRLF & _
	"                        alert(""Geocode was not successful for the following reason: "" + status);" & @CRLF & _
	"                    }" & @CRLF & _
	"                });" & @CRLF & _
	"            }" & @CRLF & _
	"            map.setZoom(zoom);" & @CRLF & _
	"            zoomLevel = map.getZoom();" & @CRLF & _
	"        }" & @CRLF & _
	"        function showCoordinates(lat, lng, zoom) {" & @CRLF & _
	"            var markerPosition;" & @CRLF & _
	"            var markerAddress;" & @CRLF & _
	"            var GPScoord = new google.maps.LatLng(lat, lng);" & @CRLF & _
	"            directionsDisplay.setMap(null);" & @CRLF & _
	"            map.setCenter(GPScoord);" & @CRLF & _
	"            marker = new google.maps.Marker({" & @CRLF & _
	"                map: map, " & @CRLF & _
	"                position: GPScoord, " & @CRLF & _
	"                draggable: true" & @CRLF & _
	"            });" & @CRLF & _
	"            markersArray.push(marker);" & @CRLF & _
	"            map.setZoom(zoom);" & @CRLF & _
	"            updateMarkerPosition(GPScoord);" & @CRLF & _
	"            geocodePosition(GPScoord);" & @CRLF & _
	"            google.maps.event.addListener(marker, ""drag"", function() {" & @CRLF & _
	"                updateMarkerPosition(marker.getPosition());" & @CRLF & _
	"            });" & @CRLF & _
  	"            google.maps.event.addListener(marker, ""dragend"", function() {" & @CRLF & _
	"                geocodePosition(marker.getPosition());" & @CRLF & _
	"            });" & @CRLF & _
	"//            google.maps.event.addListener(map, ""zoom_changed"", function() {" & @CRLF & _
	"//                zoomLevel = map.getZoom();" & @CRLF & _
	"//                map.setCenter(marker.getPosition());" & @CRLF & _
	"//            });" & @CRLF & _
	"            zoomLevel = map.getZoom();" & @CRLF & _
	"        }" & @CRLF

	Local $html1d = _
	"        function geocodePosition(pos) {" & @CRLF & _
	"            geocoder.geocode( {""location"": pos}, function(results, status) {" & @CRLF & _
	"            if (status == google.maps.GeocoderStatus.OK) {" & @CRLF & _
	"                updateMarkerAddress(results[0].formatted_address);" & @CRLF & _
	"            } else {" & @CRLF & _
	"                updateMarkerAddress(""Cannot determine address at this location. "" + status);" & @CRLF & _
	"            }" & @CRLF & _
	"            });" & @CRLF & _
	"        }" & @CRLF & _
	"        function updateMarkerPosition(latlng) {" & @CRLF & _
	"            updateLATLNG = latlng.lat() + "", "" + latlng.lng();" & @CRLF & _
	"            updateLAT = latlng.lat();" & @CRLF & _
	"            updateLNG = latlng.lng();" & @CRLF & _
	"        }" & @CRLF & _
	"        function updateMarkerAddress(str) {" & @CRLF & _
	"            updateADDRESS = str" & @CRLF & _
	"        }" & @CRLF & _
	"        function zoom_map(zoom) {" & @CRLF & _
	"            if(markersArray.length > 0) {" & @CRLF & _
	"                map.setCenter(marker.getPosition());" & @CRLF & _
	"            }" & @CRLF & _
	"            map.setZoom(zoom);" & @CRLF & _
	"        }" & @CRLF & _
	"        function routeDetails() {" & @CRLF & _
	"            var totalRouteDetails = totalDetails" & @CRLF & _
	"            return totalRouteDetails;" & @CRLF & _
	"        }" & @CRLF & _
	"        function updatePosition() {" & @CRLF & _
	"            updatePOS = updateLAT + ""~"" + updateLNG + ""~"" + updateADDRESS" & @CRLF & _
	"            return updatePOS;" & @CRLF & _
	"        }" & @CRLF & _
	"        function getMapZoomLevel() {" & @CRLF & _
	"            var mapZoomLevel = zoomLevel;" & @CRLF & _
	"            mapZoomLevel = mapZoomLevel + ""~"";" & @CRLF & _
	"            return mapZoomLevel;" & @CRLF & _
	"        }" & @CRLF & _
	"        function addMarker(lat, lng, icon_url) {" & @CRLF & _
	"            var location = new google.maps.LatLng(lat, lng);" & @CRLF & _
  	"            marker = new google.maps.Marker({" & @CRLF & _
	"                position: location," & @CRLF & _
	"                map: map," & @CRLF & _
	"                icon: icon_url" & @CRLF & _
	"            });" & @CRLF & _
	"            markersArray.push(marker);" & @CRLF & _
	"        }" & @CRLF & _
	"        function clearMarkers() {" & @CRLF & _
	"            if (markersArray) {" & @CRLF & _
	"                for (i in markersArray) {" & @CRLF & _
	"                    markersArray[i].setMap(null);" & @CRLF & _
	"                }" & @CRLF & _
	"            }" & @CRLF & _
	"        }" & @CRLF & _
	"        function showMarkers() {" & @CRLF & _
	"            if (markersArray) {" & @CRLF & _
	"                for (i in markersArray) {" & @CRLF & _
	"                    markersArray[i].setMap(map);" & @CRLF & _
	"                }" & @CRLF & _
	"            }" & @CRLF & _
	"        }" & @CRLF & _
	"        function deleteMarkers() {" & @CRLF & _
	"            if (markersArray) {" & @CRLF & _
	"                for (i in markersArray) {" & @CRLF & _
	"                    markersArray[i].setMap(null);" & @CRLF & _
	"                }" & @CRLF & _
	"                markersArray.length = 0;" & @CRLF & _
	"            }" & @CRLF & _
	"        }" & @CRLF & _
	"        function viewMarkers() {" & @CRLF & _
	"            if (markersArray) {" & @CRLF & _
	"                var latlngbounds = new google.maps.LatLngBounds();" & @CRLF & _
	"                for (i in markersArray) {" & @CRLF & _
	"                    latlngbounds.extend(markersArray[i].getPosition());" & @CRLF & _
	"                }" & @CRLF & _
	"                map.fitBounds(latlngbounds);" & @CRLF & _
	"            }" & @CRLF & _
	"        }" & @CRLF & _
	"        function weather(status) {" & @CRLF & _
	"            switch (status) {" & @CRLF & _
	"                case 0:" & @CRLF & _
	"                    weatherLayer.setMap(null);" & @CRLF & _
    "                    break;" & @CRLF & _
    "                case 1:" & @CRLF & _
    "                    weatherLayer.setMap(map);" & @CRLF & _
    "                    break;" & @CRLF & _
    "            }" & @CRLF & _
	"        }" & @CRLF & _
	"    </script>" & @CRLF & _
	"</head>" & @CRLF & _
	"<body>" & @CRLF & _
	"<body style=""margin:0px; padding:0px;"" onload=""initialize();"">" & @CRLF & _
	"    <div id=""map_canvas""></div>" & @CRLF & _
	"</body>" & @CRLF & _
	"</html>"

	Dim $html = $html1a & $html1b & $html1c & $html1d

	$gmap = _IECreateEmbedded()
	$gmap_ctrl = GUICtrlCreateObj($gmap, $left, $top, $width, $height)
	_IENavigate($gmap, "about:blank", 0)
	_IEDocWriteHTML($gmap, $html)
	_IEAction ($gmap, "refresh")

	Return $gmap_ctrl
EndFunc
#endregion

#region _GUICtrlGoogleMap_ViewLocation()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_ViewLocation()
; Description ...:	Sets the center of a Google Map to a new address.
; Syntax.........:	_GUICtrlGoogleMap_ViewLocation($gmap, $address, $zoom)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
;					$address		- An address (either a location or latitude and longitude) to center the map on
;									  ie. both "Sydney, New South Wales, Australia" and "-34.397, 150.644" are valid.
;					$zoom			- Map zoom level
;									  (Optional) [Default = 12]
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:  Igor Kerekeš <Kescho>
; Remarks .......:  Not the exact location if GPS Coordinates are entered, location is binded to an existing address.
; Related .......:
; Link ..........:
; ;==========================================================================================
func _GUICtrlGoogleMap_ViewLocation($gmap, $address, $zoom = 12, $location_marker = 1)

	$gmap.document.parentWindow.execScript("move_map(""" & $address & """, " & $zoom & ", " & $location_marker & ");")

	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_ViewCoordinates()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_ViewCoordinates()
; Description ...:	Sets the center of a Google Map to coordinates.
; Syntax.........:	_GUICtrlGoogleMap_ViewCoordinates($gmap, $lat, $lng, $zoom)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
;					$lat			- Latitude to center the map on
;					$lat			- Longitude to center the map on
;					$zoom			- Map zoom level
;									  (Optional) [Default = 12]
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	Igor Kerekeš <Kescho>
; Modified.......:  
; Remarks .......:  Shows the exact location from GPS coordinates.
; Related .......:
; Link ..........:
; ;==========================================================================================
func _GUICtrlGoogleMap_ViewCoordinates($gmap, $lat, $lng, $zoom = 12)

	$gmap.document.parentWindow.execScript("showCoordinates(" & $lat & ", " & $lng & ", " & $zoom & ");")

	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_ZoomView()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_ZoomView()
; Description ...:	Zooms the center of a Google Map to a new level.
; Syntax.........:	_GUICtrlGoogleMap_ZoomView($gmap, $scale)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
;					$zoom			- The level to zoom the view to.
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:  Igor Kerekeš <Kescho>
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_ZoomView($gmap, $zoom)

	$gmap.document.parentWindow.execScript("zoom_map(" & $zoom & ");")
	
	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_GetMapZoom()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_GetMapZoom()
; Description ...:	Get the zoom level of the displayed map.
; Syntax.........:	_GUICtrlGoogleMap_GetMapZoom($gmap, $get_zoom_level)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
;					$zoom_level		- The zoom level of the map.
; Return values .: 	On Success		- Returns zoom level of the map.
;                 	On Failure		- Returns False.
; Author ........:	Igor Kerekeš <Kescho>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_GetMapZoom($gmap)
	Local $actual_zoom_level

	$actual_zoom_level = $gmap.document.parentWindow.eval("getMapZoomLevel();")

	Return StringReplace($actual_zoom_level, "~", "")
EndFunc
#endregion

#region _GUICtrlGoogleMap_AddMarker()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_AddMarker()
; Description ...:	Adds a marker to a Google Map.
; Syntax.........:	_GUICtrlGoogleMap_AddMarker($gmap, $address)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
;					$address		- An address (either a location or latitude and longitude) to add the marker to
;									  ie. both "Sydney, New South Wales, Australia" and "-34.397, 150.644" are valid.
;					$icon_url		- (Optional) A URL to an image that will be used for the icon of the marker.
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:	This function must be used before any other function in the UDF is used.
;					There is currently a clipping problem with the control, where the video
;					is overdrawn by any other window that overlaps it.  There is no known
;					solution at this time.
;
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_AddMarker($gmap, $address, $icon_url = "")
	Local $latlng[2]

	$latlng = _GUICtrlGoogleMap_GetLatLng($address)
	$gmap.document.parentWindow.execScript("addMarker(" & $latlng[0] & "," & $latlng[1] & ",'" & $icon_url & "');")
	
	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_HideAllMarkers()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_HideAllMarkers()
; Description ...:	Hides all the markers on a Google Map (previously created by the function "_GUICtrlGoogleMap_AddMarker").
; Syntax.........:	_GUICtrlGoogleMap_HideAllMarkers($gmap)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_HideAllMarkers($gmap)

	$gmap.document.parentWindow.execScript("clearMarkers();")
	
	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_ShowAllMarkers()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_ShowAllMarkers()
; Description ...:	Shows all the markers on a Google Map (previously hidden by the function "_GUICtrlGoogleMap_HideAllMarkers").
; Syntax.........:	_GUICtrlGoogleMap_ShowAllMarkers($gmap)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_ShowAllMarkers($gmap)

	$gmap.document.parentWindow.execScript("showMarkers();")
	
	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_DeleteAllMarkers()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_DeleteAllMarkers()
; Description ...:	Deletes all the markers on a Google Map (previously created by the function "_GUICtrlGoogleMap_AddMarker").
; Syntax.........:	_GUICtrlGoogleMap_DeleteAllMarkers($gmap)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_DeleteAllMarkers($gmap)

	$gmap.document.parentWindow.execScript("deleteMarkers();")
	
	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_ViewAllMarkers()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_ViewAllMarkers()
; Description ...:	Sets the view of a Google Map to fit all the markers (previously created by the function "_GUICtrlGoogleMap_AddMarker")..
; Syntax.........:	_GUICtrlGoogleMap_ViewAllMarkers($gmap)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_ViewAllMarkers($gmap)

	$gmap.document.parentWindow.execScript("viewMarkers();")
	
	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_SetMapType()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_SetMapType()
; Description ...:	Sets the type of map displayed.
; Syntax.........:	_GUICtrlGoogleMap_SetMapType($gmap, $map_type)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
;					$map_type		- 0 = Sets the map type to standard
;									  1 = Sets the map type to satellite
;									  2 = Sets the map type to hybrid
;									  3 = Sets the map type to terrain
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_SetMapType($gmap, $map_type)
	local Const $map_type_html[4] = [ _
		"google.maps.MapTypeId.ROADMAP", _
		"google.maps.MapTypeId.SATELLITE", _
		"google.maps.MapTypeId.HYBRID", _
		"google.maps.MapTypeId.TERRAIN"]

	$gmap.document.parentWindow.execScript("map.setMapTypeId(" & $map_type_html[$map_type] & ");")

	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_AddRoute()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_AddRoute()
; Description ...:	Adds a route (visually) to the map.
; Syntax.........:	_GUICtrlGoogleMap_AddRoute($gmap, $start_location, $end_location, $travel_mode = 0, $wp1 = " ", $wp2 = " ", $wp3 = " ", $wp4 = " ")
; Parameters ....:	$gmap				- The Google Map object from the function "_GUICtrlGoogleMap_Create".
;					$start_location 	- The starting location of the route.
;										  Expressed as an address (ie. both "Sydney, New South Wales, Australia").
;					$end_location   	- The ending location of the route.
;										  Expressed as an address (ie. both "Sydney, New South Wales, Australia").
;					$travel_mode		- 0 = Uses a travel mode of DRIVING
;										  1 = Uses a travel mode of WALKING
;										  2 = Uses a travel mode of BICYCLING
;					$wp1				- (Optional)
;										  Sets first Waypoint
;										  Expressed as an address (ie. both "Sydney, New South Wales, Australia").
;					$wp2				- (Optional)
;										  Sets second Waypoint
;										  Expressed as an address (ie. both "Sydney, New South Wales, Australia").
;					$wp3				- (Optional)
;										  Sets third Waypoint
;										  Expressed as an address (ie. both "Sydney, New South Wales, Australia").
;					$wp4				- (Optional)
;										  Sets fourth Waypoint
;										  Expressed as an address (ie. both "Sydney, New South Wales, Australia").
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:  Igor Kerekeš <Kescho>
; Remarks .......:  Route is draggable.
; Related .......:
; Link ..........:
; ;==========================================================================================
func _GUICtrlGoogleMap_AddRoute($gmap, $start_location, $end_location, $travel_mode = 0, $wp1 = " ", $wp2 = " ", $wp3 = " ", $wp4 = " ")

	$gmap.document.parentWindow.eval("calcRoute(""" & $start_location & """, """ & $end_location & """, " & $travel_mode & ", """ & $wp1 & """, """ & $wp2 & """, """ & $wp3 & """, """ & $wp4 & """)")
	
	Return True
EndFunc
#endregion

#region _GUICtrlGoogleMap_GetRouteDetails()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_GetRouteDetails()
; Description ...:	Gets the directions of a route.
; Syntax.........:	_GUICtrlGoogleMap_GetRouteDetails($gmap)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
; Return values .: 	On Success		- Returns route details (duration, distance, start, end and directions.
;                 	On Failure		- Returns ???.
; Author ........:	Igor Kerekeš <Kescho>
; Modified.......:
; Remarks .......:  Contains directions steps and distance in meters.
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_GetRouteDetails($gmap)
	Local $routeDetails

	$routeDetails = $gmap.document.parentWindow.eval("routeDetails()")

	Return $routeDetails
EndFunc
#endregion

#region _GUICtrlGoogleMap_GetPosition()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_GetPosition()
; Description ...:	Gets the position of marker.
; Syntax.........:	_GUICtrlGoogleMap_GetPosition($gmap)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	Igor Kerekeš <Kescho>
; Modified.......:  
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_GetPosition($gmap)
	Local $positionDetails[3], $position_details, $details, $posLAT, $posLNG, $posADR

	$posLAT = ""
	$posLNG = ""
	$posADR = ""

	$position_details = $gmap.document.parentWindow.eval("updatePosition()")
	$details = StringSplit($position_details, "~", 1)

	$posLAT = $details[1]
	$posLNG = $details[2]
	$posADR = $details[3]

	$positionDetails[0] = $posLAT
	$positionDetails[1] = $posLNG
	$positionDetails[2] = $posADR

	Return $positionDetails
EndFunc
#endregion

#region _GUICtrlGoogleMap_Weather()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_Weather()
; Description ...:	Enable or Disable the Weather Service
; Syntax.........:	_GUICtrlGoogleMap_Weather($gmap, $status, $unit)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
;					$status			- Enable/Disable
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	Igor Kerekeš <Kescho>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_Weather($gmap, $status = 0)

	$gmap.document.parentWindow.execScript("weather(" & $status & ");")
	
	Return True
EndFunc
#endregion

#cs
#region _GUICtrlGoogleMap_GetRouteDetails()
; #FUNCTION# ;===============================================================================
; Name...........:	_GUICtrlGoogleMap_GetRouteDetails()
; Description ...:	Gets the details of a route.
; Syntax.........:	_GUICtrlGoogleMap_GetRouteDetails($gmap)
; Parameters ....:	$gmap			- The Google Map object from the function "_GUICtrlGoogleMap_Create".
; Return values .: 	On Success		- Returns array of values.
;                 	On Failure		- Returns ???.
; Author ........:	seangriffin
; Modified.......:  Igor Kerekeš <Kescho>
; Remarks .......:  Distance in meters and duration in seconds.
; Related .......:
; Link ..........:
; ;==========================================================================================
Func _GUICtrlGoogleMap_GetRouteDetails($gmap)
	Local $routeDetails[2], $route_details, $details, $distance, $duration

	$distance = ""
	$duration = ""

	$route_details = $gmap.document.parentWindow.eval("routeDetails()")
	$details = StringSplit($route_details, "~", 1)

	$distance = $details[1]
	$duration = $details[2]

	$routeDetails[0] = $distance
	$routeDetails[1] = $duration

	Return $routeDetails
EndFunc
#endregion
#ce