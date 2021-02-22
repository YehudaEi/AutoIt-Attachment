#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Region ### Declair URL's ###
Global $google = "http://www.google.com/webhp?complete=0&hl=en#sclient=psy&hl=en&complete=0&site=webhp&source=hp&q=" ;google search url code beginning
Global $gmap = "http://maps.google.com/maps?q=+" ;google maps search button
#EndRegion #

#Region ### START GUI section ### Form=
$Form1 = GUICreate("Search Bar", 400, 145, 425, 275, 0, $WS_EX_TOPMOST)

$Label1 = GUICtrlCreateLabel("Google Search", 45, 5, 85, 17)
$ibGoogleInput = GUICtrlCreateInput("", 10, 20, 300, 21)
$btSearch1 = GUICtrlCreateButton("Search", 325, 19, 55, 23, $WS_GROUP)

$Label1 = GUICtrlCreateLabel("G-Map Search", 45, 45, 85, 17)
$ibGMapInput = GUICtrlCreateInput("", 10, 65, 300, 21)
$btSearch2 = GUICtrlCreateButton("Search", 325, 65, 55, 23, $WS_GROUP)

$btClear = GUICtrlCreateButton("Clear", 10, 90, 55, 23, $WS_GROUP)
$btExit = GUICtrlCreateButton("Exit", 65, 90, 55, 23, $WS_GROUP)

GUISetState(@SW_SHOW)

GUICtrlSetState($btClear, $GUI_DISABLE)

#EndRegion #

#Region ### Key Accelerators ### 
; Set accelerators for enter key
Global $AccelKeys[4][4] = [["^g", $btSearch1],["^m", $btSearch2],["{esc}", $btExit],["{LEFT}", $btClear]]
GUISetAccelerators($AccelKeys)
#EndRegion #

#Region ### Button Functions ### 

Local $device, $devdata, $myURL, $res, $devcoord, $gmap, $btReturn

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $btExit, $GUI_EVENT_CLOSE
            Exit
		Case $btClear ;Do this when the Clear button is pressed
			
		 GUICtrlSetData($ibGMapInput, "")
		 GUICtrlSetData($ibGoogleInput, "")
		 GUICtrlSetState($ibGoogleInput, $GUI_FOCUS) 

GUICtrlSetState($btClear, $GUI_DISABLE)

;regl. google search button
       Case $btSearch1
		     $device = GUICtrlRead($ibGoogleInput)
		
		$myURL = $google & $device
ShellExecute(@ScriptDir & "\chrome.exe", $myURL)

;google maps search button
       Case $btSearch2
		     $device2 = GUICtrlRead($ibGMapInput)
		
		$myURL2 = $gmap & $device2
ShellExecute(@ScriptDir & "\chrome.exe", $myURL2)
#EndRegion #
    EndSwitch
WEnd

;EndFunc
 