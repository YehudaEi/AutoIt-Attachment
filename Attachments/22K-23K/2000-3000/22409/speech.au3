;Speaking Flags
Global Const Enum Step *2 $SPF_ASYNC, _
    $SPF_PURGEBEFORESPEAK,      _
    $SPF_IS_FILENAME,           _
    $SPF_IS_XML,                _
    $SPF_IS_NOT_XML,            _       
    $SPF_PERSIST_XML,           _
	$SPF_NLP_SPEAK_PUNC,        _
    $SPF_NLP_MASK,              _
    $SPF_VOICE_MASK,            _
    $SPF_UNUSED_FLAGS      

;Running States
Global Const Enum  Step *2 $SPRS_DONE, _
    $SPRS_IS_SPEAKING

;SpeechVoicePriority
Global Const Enum $SVPNormal, $SVPAlert, $SVPOver

;SpeechDisplayUI Flags
Global Const $SPDUI_AddRemoveWord = "AddRemoveWord"
Global Const $SPDUI_UserTraining = "UserTraining"
Global Const $SPDUI_MicTraining = "MicTraining"
Global Const $SPDUI_AudioProperties = "AudioProperties"
Global Const $SPDUI_AudioVolume = "AudioVolume" 

; #FUNCTION# ;===============================================================================
;
; Name...........: _Speech
; Description ...: Returns a COM Object for Speech
; Syntax.........: _Speech()
; Parameters ....: None
; Return values .: Success - Com Object
;                  Failure - Returns 0 and Sets @Error:
;				   |1 - Com Object Creation failed
; Author ........: Tom Schuster
; Modified.......:
; Remarks .......:
; Related .......: 
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _Speech ()
	Local $oSpeech = ObjCreate ( "SAPI.SPVoice")
	if @error Then
		Return SetError (1,0,0)
	EndIf
	if IsObj ( $oSpeech ) Then
		Return $oSpeech
	Else
		Return SetError (1,0,0)
	EndIf
EndFunc ;==>_Speech

; #FUNCTION# ;===============================================================================
;
; Name...........: _SpeechSpeak
; Description ...: Speak a defined Text
; Syntax.........: _SpeechSpeak(ByRef $oSpeech, $sText)
; Parameters ....: $oSpeech - Speech COM Object
;                  $sText - Text to speak
;				   $iFlag - Optional, Speech Flags
; Return values .: Success - 1
;                  Failure - Returns 0 and Sets @Error:
;                  |1 - $oSpeech is not a Speech COM Object
;                  |2 - $sText is not a String
; Author ........: Tom Schuster
; Modified.......:
; Remarks .......:
; Related .......: _Speech
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _SpeechSpeak ( ByRef $oSpeech, $sText, $iFlag = 0 )
	If Not IsObj ( $oSpeech ) or ObjName ($oSpeech) <> 'ISpeechVoice' Then
		Return SetError (1,0,0)
	EndIf
	If Not IsString ( $sText ) Then
		Return SetError(2,0,0)
	EndIf
	if not IsInt ( $iFlag ) then
		Return SetError(3,0,0)
	EndIf		
	Return $oSpeech.speak ( $sText , $iFlag)
EndFunc ;==>_SpeechSpeak

; #FUNCTION# ;===============================================================================
;
; Name...........: _SpeechOption
; Description ...: Returns and optionaly sets a Option/Property
; Syntax.........: _SpeechOption(ByRef $oSpeech, $sOption, $vNewValue = Default)
; Parameters ....: $oSpeech - Speech COM Object
;                  $sOption - Option to use
;				   $vNewValue - Optional: New Value to set for the Option, cant be used by status and SpeakCompleteEvent
;					 One of the following:
;						AlertBoundaray - Unkown
;						AllowAudioOutputFormatChangesOnNextSet - True or False
;						AudioOutput - COM Object, eg from _SpeechGetAudioOutputs and then in the array [0][0] or [1][0]...
;						EventInterests - Number
;						Priority - 0 or 1
;						Rate - Number
;						Status - Nothing
;						SynchronousSpeakTimeout - Number
;						Voice - COM Object, eg from _SpeechGetVoices and then in the array [0][0] or [1][0]...
;						Volume - Number,  0 < and  > 100
; Return values .: Success - One of the following:
;					 In Case of $sOption:
;						AlertBoundaray - Unkown						
;						AllowAudioOutputFormatChangesOnNextSet - True or False
;						AudioOutput - Array with:
;							[0] = COM Object (ISpeechObjectToken)
;							[1] = Registery Key of Output
;							[2] = Name of Output
;						EventInterests - Number
;						Priority - Number
;						Rate - Number
;						SpeakCompleteEvent - Number
; 						Status - Array with:
;							[0] = Option
;							[1] = Value
;						SynchronousSpeakTimeout - Number
;						Voice - Array with:
;							[0] = COM Object (ISpeechObjectToken)
;							[1] = Registery Key of Voice
;							[3] = Name of Voice
;						Volume - Number
;                  Failure - Returns 0 and Sets @Error:
;                  |1 - $oSpeech is not a Speech COM Object
;                  |2 - $sOption is not a String
;				   |3 - New Value is invalid
;				   |4 - $sOption doesnt exist
; Author ........: Tom Schuster
; Modified.......:
; Remarks .......:
; Related .......: _Speech, _SpeechGetAudioOutputs, _SpeechGetVoices
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _SpeechOption ( ByRef $oSpeech, $sOption, $vNewValue = Default)
	Local $fSet = False, $avAudioOutputArray, $avStatusArray, $avVoiceArray
	if Not IsObj ( $oSpeech ) or ObjName ($oSpeech) <> 'ISpeechVoice' Then
		Return SetError (2,0,0)
	EndIf
	if Not IsString ($sOption )  Then
		Return SetError (2,0,0)
	EndIf
	if $vNewValue <> Default Then
		$fSet = True
	EndIf
	Switch $sOption	
		case "AlertBoundary"
			If $fSet then
				$oSpeech.AlertBoundary = $vNewValue
			EndIf
			return $oSpeech.AlertBoundary	
		case "AllowAudioOutputFormatChangesOnNextSet"
			if $fSet Then
				if not IsBool ( $vNewValue ) Then 
					Return SetError(3,0,0)
				EndIf
				$oSpeech.AllowAudioOutputFormatChangesOnNextSet = $vNewValue
			EndIf
			Return $oSpeech.AllowAudioOutputFormatChangesOnNextSet
		case "AudioOutput"
			if $fSet Then
				if not IsObj ( $vNewValue ) or ObjName ($vNewValue) <> 'ISpeechObjectToken' Then
					Return SetError (3,0,0)
				EndIf
				$oSpeech.AudioOutput = $vNewValue
			EndIf
			Dim $avAudioOutputArray[3] = [$oSpeech.AudioOutput, $oSpeech.AudioOutput.id, $oSpeech.AudioOutput.GetDescription()]
			Return $avAudioOutputArray
		case "EventInterests"
			if $fSet Then
				if not IsNumber ( $vNewValue )  or IsString ( $vNewValue ) Then
					Return SetError (3,0,0)
				EndIf
				$oSpeech.EventInterests = $vNewValue
			EndIf
			Return $oSpeech.EventInterests	
		case "Priority"
			if $fSet Then
				if $vNewValue >= 0 and $vNewValue <= 2 Then
					Return SetError (3,0,0)
				EndIf
				$oSpeech.Priority = $vNewValue
			EndIf	
				
			Return $oSpeech.Priority
				
		case "Rate"
			if $fSet Then
				if not IsNumber ( $vNewValue ) or IsString ( $vNewValue ) or $vNewValue < - 10  or $vNewValue > 10 Then
					Return SetError (3,0,0)
				EndIf
				$oSpeech.Rate = $vNewValue
			EndIf
			Return $oSpeech.Rate
		case "Status"
	;~ 		CurrentStreamNumber    : 0
	;~ 		LastStreamNumberQueued : 0
	;~ 		LastHResult            : 0
	;~ 		RunningState           : 1
	;~ 		InputWordPosition      : 0
	;~ 		InputWordLength        : 0
	;~ 		InputSentencePosition  : 0
	;~ 		InputSentenceLength    : 0
	;~ 		LastBookmark           :
	;~ 		LastBookmarkId         : 0
	;~ 		PhonemeId              : 0
	;~ 		VisemeId               : 0
			$oStatus = $oSpeech.Status
			if not IsObj ( $oStatus ) Then
				Return SetError(3,0,0)
			EndIf
			Dim $avStatusArray[12][2]
			With $oStatus
				$avStatusArray[0][0] = 'CurrentStreamNumber'
				$avStatusArray[0][1] = .CurrentStreamNumber
				$avStatusArray[1][0] = 'LastStreamNumberQueued'
				$avStatusArray[1][1] = .LastStreamNumberQueued			
				$avStatusArray[2][0] = 'LastHResult'
				$avStatusArray[2][1] = .LastHResult						
				$avStatusArray[3][0]  = 'RunningState'
				$avStatusArray[3][1] = .RunningState
				$avStatusArray[4][0]  = 'InputWordPosition'
				$avStatusArray[4][1] = .InputWordPosition			
				$avStatusArray[5][0]  = 'InputWordLength'
				$avStatusArray[5][1] = .InputWordLength
				$avStatusArray[6][0]  = 'InputSentencePosition'
				$avStatusArray[6][1] = .InputSentencePosition			
				$avStatusArray[7][0]  = 'InputSentenceLength'
				$avStatusArray[7][1] = .InputSentenceLength	
				$avStatusArray[8][0]  = 'LastBookmark'
				$avStatusArray[8][1] = .LastBookmark		
				$avStatusArray[9][0]  = 'LastBookmarkId'
				$avStatusArray[9][1] = .LastBookmarkId		
				$avStatusArray[10][0]  = 'PhonemeId'
				$avStatusArray[10][1] = .PhonemeId			
				$avStatusArray[11][0]  = 'VisemeId'
				$avStatusArray[11][1] = .VisemeId			
			EndWith			
			Return $avStatusArray	

		case "SpeakCompleteEvent"
			Return $oSpeech.SpeakCompleteEvent()
		
		case "SynchronousSpeakTimeout"
			if $fSet Then
				if not IsNumber ( $vNewValue ) or IsString ( $vNewValue ) Then
					Return SetError (3,0,0)
				EndIf
				$oSpeech.SynchronousSpeakTimeout = $vNewValue
			EndIf	
			Return $oSpeech.SynchronousSpeakTimeout	
		case "Voice"
			if $fSet Then
				if not IsObj ( $vNewValue ) or ObjName ($vNewValue) <> 'ISpeechObjectToken' Then
					Return SetError (3,0,0)
				EndIf
				$oSpeech.Voice = $vNewValue
			EndIf
			Dim $avVoiceArray[3] = [$oSpeech.Voice, $oSpeech.Voice.id, $oSpeech.Voice.GetDescription()]
			Return $avVoiceArray		
		case "Volume"
			if $fSet Then
				if not IsNumber ( $vNewValue ) or IsString ( $vNewValue ) or $vNewValue < 0 or  $vNewValue > 100 Then
					Return SetError (3,0,0)
				EndIf
				$oSpeech.Volume = $vNewValue
			EndIf
			Return $oSpeech.Volume	
		case Else
			Return SetError(4,0,0)
	EndSwitch
EndFunc ;==> _SpeechOption

; #FUNCTION# ;===============================================================================
;
; Name...........: _SpeechGetVoices
; Description ...: Returns an Array with Voices 
; Syntax.........: _SpeechGetVoices($oSpeech)
; Parameters ....: $oSpeech - Speech COM Object
;				   $sRequiredAttributes - Optional: Specifies the RequiredAttributes of the Voice
;				   $sOptionalAttributes - Optional: Specifies the OptionalAttributes of the Voice
; Return values .: Success - Array with:
;					[0] = Com Object, eg use for _SpeechOption($oSpeech, "voice", $array[0,1,..][0])
;					[1] = Registery Key of Voice (id)
;					[2] = Description of Voice
;					[3] - [7] Gender, Age (Dont work for me, try for yourself), Name, Language, Vendor
;                  Failure - Returns 0 and Sets @Error:
;                  |1 - $oSpeech is not a Speech COM Object
;                  |2 - $oSpeech.GetVoices failed
;				   |3 - No Voices found
; Author ........: Tom Schuster
; Modified.......:
; Remarks .......:
; Related .......: _SpeechGetAudioOutputs
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _SpeechGetVoices ( ByRef $oSpeech, $sRequiredAttributes = '', $sOptionalAttributes = '')
	if Not IsObj ( $oSpeech ) or ObjName ($oSpeech) <> 'ISpeechVoice' Then
		Return SetError (1,0,0)
	EndIf
	Local $oVoices, $oVoice, $avVoicesArray, $iIndex
	$oVoices = $oSpeech.GetVoices ( $sRequiredAttributes,  $sOptionalAttributes )
	if Not IsObj ( $oVoices )  Then
		Return SetError (2,0,0)
	EndIf
	if $oVoices.count = 0 Then
		Return SetError (3,0,0)
	EndIf
	
	Dim $avVoicesArray[1][8]
	$iIndex = 0	
	for $oVoice in $oVoices
		If $iIndex > UBound ( $avVoicesArray ) -1 Then
			ReDim  $avVoicesArray[$iIndex+1][8]
		EndIf
		$avVoicesArray[$iIndex][0] = $oVoice
		$avVoicesArray[$iIndex][1] = $oVoice.id
		$avVoicesArray[$iIndex][2] = $oVoice.GetDescription()
		$avVoicesArray[$iIndex][3] = $oVoice.GetAttribute ("Gender")
;~ 		$avVoicesArray[$iIndex][4] = $oVoice.GetAttribute ("Age") Dont work on my Computer dont know why
		$avVoicesArray[$iIndex][5] = $oVoice.GetAttribute ("Name")
		$avVoicesArray[$iIndex][6] = $oVoice.GetAttribute ("Language")
		$avVoicesArray[$iIndex][7] = $oVoice.GetAttribute ("Vendor")
		$iIndex += 1
	Next
	Return $avVoicesArray
EndFunc ;==>_SpeechGetVoices

; #FUNCTION# ;===============================================================================
;
; Name...........: _SpeechGetAudioOutputs
; Description ...: Returns an Array with Audio Devices
; Syntax.........: _SpeechGetAudioOutputs($oSpeech)
; Parameters ....: $oSpeech - Speech COM Object
; Return values .: Success - Array with:
;					[0] = Com Object, eg use for _SpeechOption($oSpeech, "AudioOutput", $array[0,1,..][0])
;					[1] = Registery Key of Ouput (id)
;					[3] = Description/Name of Output
;                  Failure - Returns 0 and Sets @Error:
;                  |1 - $oSpeech is not a Speech COM Object
;                  |2 - $oSpeech.GetAudioOutPuts failed
; Author ........: Tom Schuster
; Modified.......:
; Remarks .......:
; Related .......: _SpeechGetVoices
; Link ..........;
; Example .......; No
;
; ;==========================================================================================	
Func _SpeechGetAudioOutputs ( ByRef $oSpeech )
	if Not IsObj ( $oSpeech ) or ObjName ($oSpeech) <> 'ISpeechVoice' Then
		Return SetError (1,0,0)
	EndIf
	Local $oAudioOutputs, $oAudioOutput, $avAudioOutputsArray, $iIndex
	$oAudioOutputs = $oSpeech.GetAudioOutPuts
	if Not IsObj ( $oAudioOutputs ) Then
		Return SetError (2,0,0)
	EndIf
	Dim $avAudioOutputsArray[1][3]
	$iIndex = 0
	for $oAudioOutput in $oAudioOutputs 
		if Not IsObj ( $oAudioOutput ) Then
			Return SetError (3,0,0)
		EndIf
		If $iIndex > UBound ( $avAudioOutputsArray ) -1 Then
			ReDim $avAudioOutputsArray[$iIndex+1][3]
		EndIf	
		$avAudioOutputsArray[$iIndex][0] = $oAudioOutput
		$avAudioOutputsArray[$iIndex][1] = $oAudioOutput.id
		$avAudioOutputsArray[$iIndex][2] = $oAudioOutput.GetDescription()
		$iIndex += 1
	Next
	Return $avAudioOutputsArray
EndFunc ;==>  _SpeechGetAudioOutputs

; #FUNCTION# ;===============================================================================
;
; Name...........: _SpeechDisyplayUI
; Description ...: Creats a UI
; Syntax.........: _SpeechDisplayUI (ByRef $oSpeech, $hWndParent , $sTitle, $sTypeOfUI, $vExtraData = 0)
; Parameters ....: $oSpeech - Speech COM Object
;				   $hWndParent - Specifies the window handle of the owning window
;				   $sTitle - Specifies the caption used for the UI window
;				   $sTypeOfUI - A String specifying the name of the UI to display ($SPDUI_AddRemoveWord...)
;				   $vExtraData - Optional: Specifies the ExtraData
; Return values .: Success - 1
;                  Failure - Returns 0 and Sets @Error:
;				   |1 - $oSpeech is not a Speech COM Object
;				   |2 - $hWndParent is not a Hwnd
;				   |3 - $sTitle is not a String
;				   |4 - $sTypeOfUI is not a String
;				   |5 - $sTypeOfUI is not supported
; Author ........: Tom Schuster
; Modified.......:
; Remarks .......:
; Related .......: 
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
func _SpeechDisplayUI (ByRef $oSpeech, $hWndParent , $sTitle, $sTypeOfUI, $vExtraData = 0)
	if not IsObj ( $oSpeech ) or ObjName ($oSpeech) <> 'ISpeechVoice' Then
		Return SetError (1,0,0)
	EndIf
	if not IsHWnd ( $hWndParent ) Then
		Return SetError (2,0,0)
	EndIf
	if not IsString ( $sTitle ) Then
		Return SetError (3,0,0)
	EndIf
	if not IsString ( $sTypeOfUI ) then
		Return SetError (4,0,0)
	EndIf
	if not $oSpeech.IsUISupported ( $sTypeOfUi ) Then
		Return SetError (5,0,0)
	EndIf
	$oSpeech.DisplayUI (int(string($hWndParent)), $sTitle, $sTypeOfUi, $vExtraData )
	;mhm seems like there is no way to get the window handle :(
	
	Return 1
EndFunc ;==>_SpeechDisyplayUI
	