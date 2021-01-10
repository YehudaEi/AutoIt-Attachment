#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         Maurice Koster

 Script Function:
	Test script for the SNARL Library.

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#include "Snarl.au3"

Dim $m, $n

; Create a GUI

$g = GUICreate("Hello World", 250, 100)
GUICtrlCreateLabel("Hello world! How are you?", 30, 10)
$button1 = GUICtrlCreateButton("Counter", 20, 50, 60)
$button2 = GUICtrlCreateButton("BOE", 90, 50, 60)
$button3 = GUICtrlCreateButton("BAA", 160, 50, 60)

GUIRegisterMsg($WM_USER, "MY_SNARL" )

GUISetState()

; Do some registration with SNARL

snRegisterConfig($g, "TestSNARL", 0)
$ok = snGetVersion( $m, $n )
$e = snGetVersionEx()

$globmsg = snGetGlobalMsg()
$app_path = snGetAppPath()
$icn_path = snGetIconsPath()

;  Registers some alert classes
snRegisterAlert( "TestSNARL", "BOE" )
snRegisterAlert( "TestSNARL", "BAA" )

; Show version info ;)
snShowMessage( "TestSNARL", "Hello, world! (" & $globmsg & ")" & @CRLF & _ 
	"Major: " & $m & " Minor: "& $n & "   - V" & $e & @CRLF & _ 
	"Path: " & $app_path, 5, $icn_path & "styles.png" )

; This message is sticky and will handle the click on the notifcation
$id = snShowMessage( "TestSNARL", "Counter", 0, "", $g, $WM_USER )
$cnt = 0

While 1
  $msg = GUIGetMsg()

  Select
    Case $msg = $button1
	  $cnt += 1
	  snUpdateMessage( $id, "TestSNARL", "Counter: " & $cnt )
  
	Case $msg = $button2
	  
	  snShowMessageEx( "BOE", "Boe", "Whoooo!", 10 )
  	
	Case $msg = $button3
	  
	  snShowMessageEx( "BAA", "Baa", "Oinck oinck!", 2 )
  	
    
    Case $msg = $GUI_EVENT_CLOSE
		
	  If snIsMessageVisible($id) Then
		  snHideMessage($id)
	  EndIf
	  
      ExitLoop
	  
  EndSelect
  
WEnd 

snRevokeConfig($g)

Func MY_SNARL($hWnd, $Msg, $wParam, $lParam)
	If $wParam = $SNARL_NOTIFICATION_ACK Then
		Msgbox( 0, "TestSNARL", "Counter gone!" & @CRLF)
	EndIf
EndFunc
