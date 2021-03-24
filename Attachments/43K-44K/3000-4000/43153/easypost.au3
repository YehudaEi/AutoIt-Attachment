Func _getlabel($shipment, $rate)
	; Creating the object
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("POST", "                                      " & $shipment & "/buy", False)

	$oHTTP.SetRequestHeader('Authorization', 'Basic ' & _Base64Encode($login))
	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

	$test = 'rate[id]=' & $rate



	; Performing the Request
	$oHTTP.Send($test)

	; Download the body response if any, and get the server status response code.
	$oReceived = $oHTTP.ResponseText
	$oStatusCode = $oHTTP.Status

	$url = StringTrimLeft($oReceived, StringInStr($oReceived, 'tracking_code":') + 15)
	$url = StringLeft($url, StringInStr($url, '"') - 1)
;~ 	ConsoleWrite(@CRLF & $oHTTP.ResponseText & @CRLF)

	FileWriteLine("tracking.csv", $url & @CRLF)

	$url = StringTrimLeft($oReceived, StringInStr($oReceived, 'label_url":') + 11)
	$url = StringLeft($url, StringInStr($url, '"') - 1)
;~ 	*******************
	Return $url
EndFunc   ;==>_getlabel


Func _getcustoms($description, $quantity, $weight, $value)
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("POST", "                                         ", False)
	$oHTTP.SetRequestHeader('Authorization', 'Basic ' & _Base64Encode($login))
	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	$test = 'customs_info[customs_certify]=true' _
			 & '&customs_info[FromPhone]=6074270019' _
			 & '&customs_info[customs_signer]=Javan Martin' _
			 & '&customs_info[contents_type]=merchandise' _
			 & '&customs_info[contents_explanation]=' _
			 & '&customs_info[restriction_type]=none' _
			 & '&customs_info[eel_pfc]=NOEEI 30.37(a)' _
			 & '&customs_info[customs_items][1][description]=' & $description _
			 & '&customs_info[customs_items][1][quantity]=' & $quantity _
			 & '&customs_info[customs_items][1][value]=' & $value _
			 & '&customs_info[customs_items][1][weight]=' & $weight _
			 & '&customs_info[customs_items][1][origin_country]=US'
	; Performing the Request
	$oHTTP.Send($test)

	; Download the body response if any, and get the server status response code.
	$oReceived = $oHTTP.ResponseText
	$oStatusCode = $oHTTP.Status

	$url = StringTrimLeft($oReceived, StringInStr($oReceived, 'id":"') + 4)
	$url = StringLeft($url, StringInStr($url, '"') - 1)
EndFunc   ;==>_getcustoms


Func _getshipment($to, $from, $parcel, $customs = "")
	; Creating the object
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("POST", "                                     ", False)
	$oHTTP.SetRequestHeader('Authorization', 'Basic ' & _Base64Encode($login))
	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

	$test = 'shipment[to_address][id]=' & $to _
			 & '&shipment[from_address][id]=' & $from _
			 & '&shipment[parcel][id]=' & $parcel _

	If $customs == "" Then
	Else
		$test = $test & '&shipment[customs_info][id]=' & $customs
	EndIf

	; Performing the Request
	$oHTTP.Send($test)

	; Download the body response if any, and get the server status response code.
	$oReceived = $oHTTP.ResponseText
	$oStatusCode = $oHTTP.Status

	$url = StringTrimLeft($oReceived, StringInStr($oReceived, 'service":"First"') + 16)
	$url = StringTrimLeft($url, StringInStr($url, 'shipment_id":"') + 13)
	$url = StringLeft($url, StringInStr($url, '"') - 1)
	$rate = StringTrimLeft($oReceived, StringInStr($oReceived, '"rates":[{"id":"') + 15)
	$rate = StringLeft($rate, StringInStr($rate, '"') - 1)

	Return $url
EndFunc   ;==>_getshipment


Func _getpackage($packagetype, $weight)
	; Creating the object
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("POST", "                                   ", False)
	$oHTTP.SetRequestHeader('Authorization', 'Basic ' & _Base64Encode($login))
	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

	$test = 'parcel[predefined_package]=' & $packagetype _
			 & '&parcel[weight]=' & $weight

	; Performing the Request
	$oHTTP.Send($test)

	; Download the body response if any, and get the server status response code.
	$oReceived = $oHTTP.ResponseText
	$oStatusCode = $oHTTP.Status

	$url = StringTrimLeft($oReceived, StringInStr($oReceived, 'id":"') + 4)
	$url = StringLeft($url, StringInStr($url, '"') - 1)
	Return $url
EndFunc   ;==>_getpackage


Func _getaddress($name, $address1, $address2, $city, $state, $zip, $country, $phone)
	; Creating the object
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("POST", "                                     ", False)

	$oHTTP.SetRequestHeader('Authorization', 'Basic ' & _Base64Encode($login))
	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

	$test = 'address[name]=' & $name _
			 & '&address[street1]=' & $address1 _
			 & '&address[city]=' & $city _
			 & '&address[state]=' & $state _
			 & '&address[zip]=' & $zip _
			 & '&address[country]=' & $country _
			 & '&address[phone]=' & $phone
;~ ConsoleWrite($test)
	$oHTTP.Send($test)

	; Download the body response if any, and get the server status response code.
	$oReceived = $oHTTP.ResponseText
	$oStatusCode = $oHTTP.Status

	$url = StringTrimLeft($oReceived, StringInStr($oReceived, 'id":"') + 4)
	$url = StringLeft($url, StringInStr($url, '"') - 1)
	Return $url
EndFunc   ;==>_getaddress
