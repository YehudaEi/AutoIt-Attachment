; MediaPlayer Download here :
;                                                        
	
; Flash MP3 player
;                                                                    

; Om bestanden te converteren zie hier :
;                                   

; Creating 1 FLV Video from many FLVs
;                                     

opt("GUIOnEventMode", 1)
#include <GUIConstantsEX.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>

; Initialize error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

; ---------------------------------- Declare objects -------------------------------
$oSWF = ObjCreate("ShockwaveFlash.ShockwaveFlash") 

; -------------------------------------------- Main Gui ---------------------------------
$hGui = GuiCreate("SWF Viewer - 1.0", 802, 590,-1, -1, Bitor($WS_SYSMENU, $WS_VISIBLE))

$Button_1 = GUICtrlCreateButton("Open File", 10, 10, 100)
GUICtrlSetOnEvent($Button_1,"_FileOpen")



$oSWF_Object = GUICtrlCreateObj ($oSWF, 10, 70 , 770 , 450)
GUICtrlSetStyle ( $oSWF_Object,  $WS_VISIBLE )
;GUICtrlSetResizing ($oSWF_Object,$GUI_DOCKAUTO)		; $GUI_DOCKAUTO Auto Resize Object

With $oSWF
		;.LoadMovie(0,"\mediaplayer.swf")
		;.Movie = @ScriptDir & "\mediaplayer.swf"
		.ScaleMode = 3 ;0 showall, 1 noborder, 2 exactFit, 3 noscale
		;.BackgroundColor = 123
		.bgcolor = "505050"
		.Loop = 'True'
		.WMode = "transparent" ; "window"
		.allowScriptAccess = "Always"
		.Quality = 1
		.Playing = 1
		.Menu = 1
EndWith

;ConsoleWrite($oSWF.Flashversion & @LF)

GUISetOnEvent($GUI_EVENT_CLOSE, "GUIeventClose")

GuiSetState()

While 1
	Sleep(100)
WEnd

Func _FileOpen()
	
$oSWF.GotoFrame(1)
$FileOpen = FileOpenDialog("Select your Flash Movie", @ScriptDir & "\", "Movies (*.swf;*.flv)")
$oSWF.Movie = @ScriptDir & "\mediaplayer.swf?file="&$FileOpen
$oSWF.rewind

EndFunc

Func GUIeventClose()
	Exit
EndFunc   ;==>GUIeventClose

;This is custom error handler
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"AutoItCOM Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
			 "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
			 "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
			 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
			 "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
			 "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
			 "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
			 "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
			 "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
			)
  SetError(1)  ; to check for after this function returns
Endfunc