#include-once
#include <GUIConstants.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <IE.au3>
#Region Header
#cs
	Title:   		Twitter UDF Library for AutoIt3
	Filename:  		Twitter.au3
	Description: 	Automate Twitter using OAuth and the Twitter API
	Author:   		seangriffin
	Version:  		V0.1
	Last Update: 	02/07/10
	Requirements: 	AutoIt3 3.2 or higher
	Changelog:
					---------02/07/10---------- v0.1
					Initial release.

#ce
#EndRegion Header
#Region Global Variables and Constants
	Global Const $_Twitter_html1 = _
		"<HTML>" & @CRLF & _
		"<head>" & @CRLF & _
		"<script type=""text/javascript"" src=""http://oauth.googlecode.com/svn/code/javascript/sha1.js""></script>" & @CRLF & _
		"<script type=""text/javascript"" src=""http://oauth.googlecode.com/svn/code/javascript/oauth.js""></script>" & @CRLF & _
		"<script type=""text/javascript"">" & @CRLF & _
		"  var consumer = {};" & @CRLF & _
		"  consumer.signForm =" & @CRLF & _
		"  function signForm(form, etc) {" & @CRLF & _
		"    form.action = etc.URL.value;" & @CRLF & _
		"    var accessor = { consumerSecret: etc.consumerSecret.value" & @CRLF & _
		"                   , tokenSecret   : etc.tokenSecret.value};" & @CRLF & _
		"    var message = { action: form.action" & @CRLF & _
		"                  , method: form.method" & @CRLF & _
		"                  , parameters: []" & @CRLF & _
		"                  };" & @CRLF & _
		"    for (var e = 0; e < form.elements.length; ++e) {" & @CRLF & _
		"        var input = form.elements[e];" & @CRLF & _
		"        if (input.name != null && input.name != """" && input.value != null" & @CRLF & _
		"            && (!(input.type == ""checkbox"" || input.type == ""radio"") || input.checked))" & @CRLF & _
		"        {" & @CRLF & _
		"            message.parameters.push([input.name, input.value]);" & @CRLF & _
		"        }" & @CRLF & _
		"    }" & @CRLF & _
		"    OAuth.setTimestampAndNonce(message);" & @CRLF & _
		"    OAuth.SignatureMethod.sign(message, accessor);" & @CRLF & _
		"    var parameterMap = OAuth.getParameterMap(message.parameters);" & @CRLF & _
		"    for (var p in parameterMap) {" & @CRLF & _
		"        if (p.substring(0, 6) == ""oauth_""" & @CRLF & _
         		"&& form[p] != null && form[p].name != null && form[p].name != """")" & @CRLF & _
		"        {" & @CRLF & _
		"            form[p].value = parameterMap[p];" & @CRLF & _
		"        }" & @CRLF & _
		"    }" & @CRLF & _
		"    return true;" & @CRLF & _
		"};" & @CRLF & _
		"</script>" & @CRLF & _
		"</head>" & @CRLF & _
		"<body>" & @CRLF & _
		"  <form name=""request"" method=""POST"" onSubmit=""consumer.signForm(this, document.etc)"">" & @CRLF & _
		"      <input name=""submit"" type=""submit"" value=""Submit""/><br/>" & @CRLF

	Global Const $_Twitter_html2 = _
		"  </form>" & @CRLF & _
		"  <form name=""etc"">" & @CRLF

	Global Const $_Twitter_html3 = _
		"  </form>" & @CRLF & _
		"</body>" & @CRLF & _
		"</HTML>" & @CRLF

	Global $_Twitter_oauth_consumer_key_html, $_Twitter_oauth_token_html, $_Twitter_oauth_signature_method_html
	Global $_Twitter_oauth_verifier_html, $_Twitter_oauth_timestamp_html, $_Twitter_oauth_nonce_html, $_Twitter_oauth_signature_html
	Global $_Twitter_url_html, $_Twitter_consumer_secret_html, $_Twitter_token_secret_html
	Global $_Twitter_message_html, $_Twitter_lat_html, $_Twitter_long_html

#EndRegion Global Variables and Constants
#Region Core functions
; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlTwitter_Create()
; Description ...:	Creates a Twitter control.
; Syntax.........:	_GUICtrlTwitter_Create(ByRef $twitter, $left, $top, $width, $height)
; Parameters ....:	$twitter			- The embedded Twitter object, required by the _GUICtrlTwitter functions below.
;					$left				- The left side of the control.
;					$top				- The top of the control.
;					$width				- The width of the control.
;					$height				- The height of the control.
; Return values .: 	On Success			- Returns the identifier (controlID) of the new control.
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:	The main purpose of having a visual control for Twitter (such as this one)
;					is for performing the required web-based username and password authentication
;					(see the function "_GUICtrlTwitter_Authenticate").
; Related .......:
; Link ..........:
; Example .......:	Yes
;
; ;==========================================================================================
func _GUICtrlTwitter_Create(ByRef $twitter, $left, $top, $width, $height)

	dim $twitter_ctrl

	if IsObj($twitter) = False Then

		$twitter = _IECreateEmbedded ()
		$twitter_ctrl = GUICtrlCreateObj($twitter, $left, $top, $width, $height)
		_IENavigate($twitter, "about:blank")
	EndIf

	Return $twitter_ctrl
EndFunc


; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlTwitter_Authenticate()
; Description ...:	Performs the entire OAuth / Twitter user authentication process
;					(getting a request token, user login and PIN retrieval, and getting an access token).
; Syntax.........:	_GUICtrlTwitter_Authenticate($twitter, $twitter_ctrl, $consumer_key, $consumer_secret, $hide_token_authetication = True)
; Parameters ....:	$twitter					- The Twitter object from the function "_GUICtrlTwitter_Create".
;					$twitter_ctrl				- The Twitter control from the function "_GUICtrlTwitter_Create".
;					$consumer_key				- The consumer key of the client application (calling this UDF and) registered with Twitter.
;					$consumer_secret			- The consumer secret of the client application (calling this UDF and) registered with Twitter.
;					$hide_token_authetication	- True = Hide the Twitter control whilst token authentication is occurring.
;												  False = Show the Twitter control whilst token authentication is occurring.
; Return values .: 	On Success			- Returns True.
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:	Yes
;
; ;==========================================================================================
func _GUICtrlTwitter_Authenticate($twitter, $twitter_ctrl, $consumer_key, $consumer_secret, $hide_token_authetication = True)

	dim $html

	; Step 1 - Get a Request Token

	$_Twitter_oauth_consumer_key_html = 		"      consumer key:     <input name=""oauth_consumer_key""     type=""text"" size=""64"" value=""" & $consumer_key & """/><br/>" & @CRLF
	$_Twitter_oauth_signature_method_html =		"      signature method: <input name=""oauth_signature_method"" type=""text"" value=""HMAC-SHA1""/>" & @CRLF
	$_Twitter_oauth_timestamp_html = 			"                        <input name=""oauth_timestamp""        type=""hidden""/>" & @CRLF
	$_Twitter_oauth_nonce_html = 				"                        <input name=""oauth_nonce""            type=""hidden""/>" & @CRLF
	$_Twitter_oauth_signature_html = 			"                        <input name=""oauth_signature""        type=""hidden""/>" & @CRLF
	$_Twitter_url_html =						"      URL:              <input name=""URL""                    type=""text"" size=""80"" value=""https://api.twitter.com/oauth/request_token""/><br/>" & @CRLF
	$_Twitter_consumer_secret_html =			"      consumer secret:  <input name=""consumerSecret""         type=""text"" size=""64"" value=""" & $consumer_secret & """/><br/>" & @CRLF
	$_Twitter_token_secret_html =				"                        <input name=""tokenSecret""            type=""hidden"" value=""""/>" & @CRLF

	$html = $_Twitter_html1 & $_Twitter_oauth_consumer_key_html & $_Twitter_oauth_signature_method_html & $_Twitter_oauth_timestamp_html & $_Twitter_oauth_nonce_html & $_Twitter_oauth_signature_html & $_Twitter_html2 & $_Twitter_url_html & $_Twitter_consumer_secret_html & $_Twitter_token_secret_html & $_Twitter_html3

	if $hide_token_authetication = True Then GUICtrlSetState($twitter_ctrl, $GUI_HIDE)

	_IEDocWriteHTML($twitter, $html)

	; Submit the form
	$form = _IEFormGetObjByName($twitter, "request")
	$submit = _IEFormElementGetObjByName($form, "submit")
	_IEAction($submit, "click")

	; Get the response
	_IELoadWait($twitter)
	$response = _IEBodyReadText($twitter)
	$response_part = StringSplit($response, "&")
	$oauth_token = StringReplace($response_part[1], "oauth_token=", "")
	$oauth_token_secret = StringReplace($response_part[2], "oauth_token_secret=", "")

	; Step 2 - User login and PIN retrieval

	_IENavigate($twitter, "https://twitter.com/oauth/authorize?oauth_token=" & $oauth_token)

	if $hide_token_authetication = True Then GUICtrlSetState($twitter_ctrl, $GUI_SHOW)

	Do

		Sleep(250)
		$response = _IEBodyReadText($twitter)
	Until StringInStr($response, "successfully granted access")

	if $hide_token_authetication = True Then GUICtrlSetState($twitter_ctrl, $GUI_HIDE)

	$number = StringRegExp($response, "[0-9]+", 1)
	$pin = $number[0]

	; Step 3 - Get an Access Token

	$_Twitter_oauth_token_html =		"      request token:    <input name=""oauth_token""            type=""text"" size=""64"" value=""" & $oauth_token & """/><br/>" & @CRLF
	$_Twitter_oauth_verifier_html =		"      PIN:              <input name=""oauth_verifier""         type=""text"" size=""64"" value=""" & $pin & """/>" & @CRLF
	$_Twitter_url_html =				"      URL:              <input name=""URL""                    type=""text"" size=""80"" value=""https://api.twitter.com/oauth/access_token""/><br/>" & @CRLF
	$_Twitter_token_secret_html =		"      token secret:     <input name=""tokenSecret""            type=""text"" size=""64"" value=""" & $oauth_token_secret & """/>" & @CRLF

	$html = $_Twitter_html1 & $_Twitter_oauth_consumer_key_html & $_Twitter_oauth_token_html & $_Twitter_oauth_signature_method_html & $_Twitter_oauth_verifier_html & $_Twitter_oauth_timestamp_html & $_Twitter_oauth_nonce_html & $_Twitter_oauth_signature_html & $_Twitter_html2 & $_Twitter_url_html & $_Twitter_consumer_secret_html & $_Twitter_token_secret_html & $_Twitter_html3
	_IEDocWriteHTML($twitter, $html)

	; Submit the form
	$form = _IEFormGetObjByName($twitter, "request")
	$submit = _IEFormElementGetObjByName($form, "submit")
	_IEAction($submit, "click")

	; Get the response
	_IELoadWait($twitter)
	$response = _IEBodyReadText($twitter)
	$response_part = StringSplit($response, "&")
	$oauth_token = StringReplace($response_part[1], "oauth_token=", "")
	$oauth_token_secret = StringReplace($response_part[2], "oauth_token_secret=", "")
	$user_id = StringReplace($response_part[3], "user_id=", "")
	$screen_name = StringReplace($response_part[4], "screen_name=", "")

	$_Twitter_oauth_token_html =	"      request token:    <input name=""oauth_token""            type=""text"" size=""64"" value=""" & $oauth_token & """/><br/>" & @CRLF
	$_Twitter_token_secret_html =	"      token secret:     <input name=""tokenSecret""            type=""text"" size=""64"" value=""" & $oauth_token_secret & """/>" & @CRLF

	Return True

EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlTwitter_UpdateStatus()
; Description ...:	Posts a Tweet (updates the status) for the authenticated person.
; Syntax.........:	_GUICtrlTwitter_UpdateStatus(ByRef $twitter, $message, $lat, $long)
; Parameters ....:	$twitter		- The Twitter object from the function "_GUICtrlTwitter_Create".
;					$message		- The message (Tweet) to post.
;					$lat			- The latitude of the location this tweet refers to.
;									  Will not be used if an empty string.
;					$long			- The longitude of the location this tweet refers to.
;									  Will not be used if an empty string.
; Return values .: 	On Success		- Returns an array with the latitude and longitude of the address.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:  The function "_GUICtrlTwitter_Authenticate" must have be called prior to
;					calling this function.
; Related .......:
; Link ..........:
; Example .......:	Yes
;
; ;==========================================================================================
func _GUICtrlTwitter_UpdateStatus(ByRef $twitter, $message, $lat = "", $long = "")

	$_Twitter_message_html =		"      message:          <input name=""status""                 type=""text"" size=""64"" value=""" & $message & """/><br/>" & @CRLF

	if StringLen($lat) > 0 Then

		$_Twitter_lat_html =			"      latitude:         <input name=""lat""                    type=""text"" value=""" & $lat & """/><br/>" & @CRLF
	Else

		$_Twitter_lat_html = ""
	EndIf

	if StringLen($long) > 0 Then

		$_Twitter_long_html =			"      longitude:        <input name=""long""                   type=""text"" value=""" & $long & """/><br/>" & @CRLF
	Else

		$_Twitter_long_html = ""
	EndIf

	$_Twitter_url_html =			"      URL:              <input name=""URL""                    type=""text"" size=""80"" value=""https://api.twitter.com/statuses/update.xml""/><br/>" & @CRLF

	$html = $_Twitter_html1 & $_Twitter_message_html & $_Twitter_lat_html & $_Twitter_long_html & $_Twitter_oauth_consumer_key_html & $_Twitter_oauth_token_html & $_Twitter_oauth_signature_method_html & $_Twitter_oauth_timestamp_html & $_Twitter_oauth_nonce_html & $_Twitter_oauth_signature_html & $_Twitter_html2 & $_Twitter_url_html & $_Twitter_consumer_secret_html & $_Twitter_token_secret_html & $_Twitter_html3
	_IEDocWriteHTML($twitter, $html)

	; Submit the form
	$form = _IEFormGetObjByName($twitter, "request")
	$submit = _IEFormElementGetObjByName($form, "submit")
	_IEAction($submit, "click")
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlTwitter_Search()
; Description ...:	Returns tweets that match a specified query.
; Syntax.........:	_GUICtrlTwitter_Search($search_text, $result_type = "mixed")
; Parameters ....:	$search_text	- the search query
;					$result_type	- "mixed": Include both popular and real time results in the response.
;									  "recent": return only the most recent results in the response
;									  "popular": return only the most popular results in the response
; Return values .: 	On Success		- Returns a "Scripting.Dictionary" object of details for the listing.
;									  The key of each dictionary item is formatted as follows:
;									    "entry<entry number>.<attribute name>"
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:	Yes
;
; ;==========================================================================================
func _GUICtrlTwitter_Search($search_text, $result_type = "mixed")

	Local $search_result = ObjCreate("Scripting.Dictionary")

	$search_text = StringReplace($search_text, " ", "+")

	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("GET","http://search.twitter.com/search.atom?q=" & $search_text & "&result_type=" & $result_type)
	$oHTTP.Send()
	$HTMLSource = $oHTTP.Responsetext

	$entry = StringSplit($HTMLSource, "<entry>", 1)
	_ArrayDelete($entry, 0)
	_ArrayDelete($entry, 0)
	$entry_num = 1

	for $each in $entry

		$entry_attribute = StringSplit($each, @LF, 1)
		_ArrayDelete($entry_attribute, 0)
		_ArrayDelete($entry_attribute, 0)
		_ArrayDelete($entry_attribute, UBound($entry_attribute - 2))
		_ArrayDelete($entry_attribute, UBound($entry_attribute - 2))

		for $each_attribute in $entry_attribute

			if StringInStr($each_attribute, ">") > 0 And (StringInStr($each_attribute, ">") <> StringLen($each_attribute)) Then

				$each_attribute_part = StringSplit($each_attribute, "<>")
				;_ArrayDisplay($each_attribute_part)
				$search_result.item("entry" & $entry_num & "." & $each_attribute_part[2]) = $each_attribute_part[3]
			EndIf

		Next

		$entry_num = $entry_num + 1
	Next

	return $search_result

EndFunc