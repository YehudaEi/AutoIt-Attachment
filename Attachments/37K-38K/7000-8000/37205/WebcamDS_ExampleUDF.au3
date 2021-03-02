#AutoIt3Wrapper_UseX64=n

#include <Misc.au3>
#include <Memory.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <array.au3>
#include <GuiComboBox.au3>
#include "WebcamDS_UDF.au3"

Opt("MustDeclareVars", 1)
Global $UserDLL = DllOpen("user32.dll")

OnAutoItExitRegister("_onExit")
Func _onExit()
	_WebcamDS_ReleaseObjects(1)
    DllClose($UserDLL)
EndFunc

; Error monitoring
Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")
Global  $hComboCam = '', $hComboComp = '', $hComboMic, $ZoomInput =''


_WebcamDS_Init()
_CreateGui()

_WebcamDS_RenderWebcam(1,1,$hGUI,1,640,480,24)
if $iWebAudio <> 0 and GUICtrlRead($AudioPrevBox) =  $GUI_UNCHECKED Then	GUICtrlSetState($AudioPrevBox, $GUI_CHECKED)

Global $msg
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $SaveButton
			local $audio=0, $comp
			if GUICtrlRead($AudioCapBox) = $GUI_CHECKED  Then $audio = _GUICtrlComboBox_GetCurSel ( $hComboMic ) + 1
			$comp = GUICtrlRead ($hComboComp)
			_WebcamDS_SaveFile('e:\test'&@min&'_'&@sec&'.avi',$comp,$audio)
		Case $msg = $StopButton
			_WebcamDS_Reset()
			_WebcamDS_RenderWebcam($iWebcam,$iWebAudio,$hGUI,$iWebRescale,$iWebX,$iWebY,24)
		Case $msg = $hComboMic
			if GUICtrlRead($AudioPrevBox) = $GUI_CHECKED  Then
				$iWebAudio = _GUICtrlComboBox_GetCurSel ( $hComboMic ) + 1
				if $iWebAudio = 3 Then $iWebAudio = 4 ; my Mic 3° position doesn't correspond to the 3° webcam, but it's the 4°
			EndIf
		Case $msg = $hComboCam
			_WebcamDS_Reset()
			; reset zoom positions:
			$aZoomPos[0] = 1
			$aZoomPos[1] = 0
			$aZoomPos[2] = 1
			$aZoomPos[3] = 0
			$iWebcam = _GUICtrlComboBox_GetCurSel ( $hComboCam)+1
			_WebcamDS_RenderWebcam($iWebcam,$iWebAudio,$hGUI,$iWebRescale,$iWebX,$iWebY,24)
		Case $msg = $ZoomButton
			_WebcamDS_Reset()
			if $ZoomInput <> '' Then
				Local $aZoom = StringSplit($ZoomInput,',')
				_WebcamDS_RenderWebcam($iWebcam,$iWebAudio,$hGUI,$iWebRescale,$iWebX,$iWebY,24,$aZoom[1],$aZoom[2],$aZoom[3],$aZoom[4])
				$ZoomInput= ''
			Else
				_WebcamDS_RenderWebcam($iWebcam,$iWebAudio,$hGUI,$iWebRescale,$iWebX,$iWebY,24)
				; reset zoom position
				$aZoomPos[0] = 1
				$aZoomPos[1] = 0
				$aZoomPos[2] = 1
				$aZoomPos[3] = 0
			EndIf
		Case $msg = $AudioPrevBox
			if GUICtrlRead($AudioPrevBox) = $GUI_CHECKED  Then
				$iWebAudio = _GUICtrlComboBox_GetCurSel ( $hComboMic ) + 1
				if $iWebAudio = 3 Then $iWebAudio = 4 ; my Mic 3° position doesn't correspond to the 3° webcam, but it's the 4°
			else
				$iWebAudio = 0
			EndIf
		Case $msg = $FullButton
			$oVideoWindow.put_FullScreenMode(-1) ;goes fullscreen
		Case $msg = $GUI_EVENT_CLOSE
			GUIDelete()
			ExitLoop
	EndSelect
	if _IsPressed('70' , $UserDLL) Then ; F1 to exit fullscreen
		local $full
		$oVideoWindow.get_FullScreenMode($full)
		if $full = -1 Then
			$oVideoWindow.put_FullScreenMode(0)  ; returning from fullscreen, it remains black...
			_WebcamDS_Reset()
		EndIf
	EndIf
	if _IsPressed("01", $UserDLL) Then ; left mouse button for zoom
		Local $aMouse_Pos = MouseGetPos()
		Local $iX1 = $aMouse_Pos[0]
		Local $iY1 = $aMouse_Pos[1]
		Local $aGUIPos = WinGetPos($hGui)
		; I take note of 50px due to titlebar and line of buttons
		if WinGetState($hGUI)= 15 and  $iX1 >= $aGUIPos[0]+2  and $iX1 < $aGUIPos[0]+$aGUIPos[2] and _
			$iY1 >= $aGUIPos[1]+50  and $iY1 < $aGUIPos[1]+$aGUIPos[3]	Then
			Local $sZoom = _WebcamDS_SelectRect($hGUI)
			if StringLen($sZoom) >2 Then ; if there is a call from comboBox selection it's not a selection zoom...
				$ZoomInput = $sZoom
				ControlClick($hGui, "", $ZoomButton)
			EndIf
		EndIf
	EndIf
WEnd

Func _CreateGui()
	Global $hGUI = GUICreate("DirectShow Capture", 1280, 720, -1, -1, -1)
	Global $AudioPrevBox = GUICtrlCreateCheckbox("AuPrev" , 420, 0, 50, 25)
	Global $AudioCapBox = GUICtrlCreateCheckbox("AuCap" , 795, 0, 50, 25)

	Global $FrameInput = GUICtrlCreateInput("30", 850, 0, 40, 25)
	Global $SaveButton = GUICtrlCreateButton("Save", 875, 0, 60, 25)
	Global $StopButton = GUICtrlCreateButton("Stop", 940, 0, 60, 25)
	Global $ZoomButton = GUICtrlCreateButton("Reset", 1120, 0, 70, 25)
	Global $FullButton = GUICtrlCreateButton("FullScreen", 1200, 0, 60, 25)

	GUISetState()

	if $hComboCam = '' Then
		for $i = 1 to $aWebcamList[0]
			if $hComboCam = '' Then
				$hComboCam = GUICtrlCreateCombo($aWebcamList[$i], 0, 0,200,25)
			Else
				if $aWebcamList[$i] <> '' Then GUICtrlSetData($hComboCam , $aWebcamList[$i])
			EndIf
		Next
	EndIf
	if $hComboComp = '' Then
		for $i = 1 to $aCompressorList[0]+1 ; I put +1 because I added the 'uncompressed' line
			if $hComboComp = '' Then
				$hComboComp = GUICtrlCreateCombo($aCompressorList[$i],  475, 0,200,25)
			Else
				GUICtrlSetData($hComboComp , $aCompressorList[$i])
			EndIf
		Next
	EndIf
	if $hComboMic = '' Then
		for $i = 1 to $aMicList[0] ;
			if $hComboMic = '' Then
				$hComboMic = GUICtrlCreateCombo($aMicList[$i],  210, 0,200,25)
			Else
				GUICtrlSetData($hComboMic , $aMicList[$i])
			EndIf
		Next
	EndIf

EndFunc
