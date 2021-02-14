#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.5.6 (beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include "GUIConstantsEx.au3"

; We prepare the Internet Explorer as our test subject
$oIE=ObjCreate("InternetExplorer.Application.1")
With $oIE
    .Visible=1
    .Top = (@DesktopHeight-400)/2
    .Height=800         ; Make it a bit smaller than our GUI.
    .Width=800
    $IEWnd=HWnd(.hWnd)  ; Remember the Window, in case user decides to close it
EndWith

$URL = "c:"
$oIE.Navigate( $URL )           
sleep(1000)             ; Give it some time to load the web page
