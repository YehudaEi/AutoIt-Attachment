; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; 1 means alive
; 0 means disconnect

$x =DLLCall("SENSAPI.dll","int","IsNetworkAlive")
msgbox (4096,"TEST",$x[0])

; ----------------------------------------------------------------------------
; Script Start - Add your code below here
; ----------------------------------------------------------------------------

