

; Important! You must include the following UDFs:
;	#include <IE.au3>
;	#include <GuiEdit.au3>
;	#include <WinAPIEx.au3>



; #FUNCTION# ====================================================================================================================
; Name ..........: IECreatePseudoEmbedded
; Description ...: Create IE frame in GUI with the laset IE verison that installed on the computer
; Syntax ........: IECreatePseudoEmbedded($sURL, $h_Parent, $i_Left, $i_Top, $i_Width, $i_Height[, $wait = 5000])
; Parameters ....: $sURL                - The URL to load.
;                  $h_Parent            - The handle of the GUI to create the IE frame in..
;                  $i_Left              - X pos.
;                  $i_Top               - Y Pos
;                  $i_Width             - The width of the frame.
;                  $i_Height            - The height of the frame.
;                  $wait                - [optional] max time to wait for the page to load. Default is 5000 ms.
; Return values .: If error:
;					-1 = can't open internet explorer
;					-2 = loading time limit reached
;					-3 = object error occurred
; 				.: Id not error:
;					Array Variable:
;						[0] = $o_object - Object variable of an InternetExplorer.Application, Window or Frame object
;							the Object is for IE functions in IE.au3
;						[1] = Another array:
;								[0] = the pid of the IE frame
;								[1] = the handle of the IE frame
; Author ........: gil900
; Modified ......: Yes and No ;)
; Inspired from .: http://www.autoitscript.com/forum/topic/152173-pseudo-embed-google-chrome/
;				   http://www.autoitscript.com/forum/topic/138980-iecreatepseudoembedded/
;				   http://www.autoitscript.com/forum/topic/99234-iecreate2/#entry712594
;				   AutoIt3\Include\IE.au3

; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: yes
;
; ===============================================================================================================================
Func IECreatePseudoEmbedded($sURL, $h_Parent, $i_Left, $i_Top, $i_Width, $i_Height, $wait = 5000)
	Local $Output[2] = [-1,-1] , $acMain[2] , $o_IE , $timer , $GIECPE_Edit1 , $pid , $o_Shell , $o_ShellWindows , $o_window

	$GIECPE_Edit1 = GUICtrlCreateEdit("loading...", $i_Left, $i_Top, $i_Width, $i_Height,$ES_READONLY+$ES_CENTER)
	GUICtrlSetFont(-1, 35, 400, 2, "Tahoma")
	GUICtrlSetColor(-1, 0x646464)
	$pid = ShellExecute(@HomeDrive&"\Program Files\Internet Explorer\iexplore.exe","-k "&$sURL,"","",@SW_MINIMIZE)
	If $pid = 0 Then
		GUICtrlSetData($GIECPE_Edit1, "Error in opening Internet Explorer")
		Return -1
	EndIf

	$timer = TimerInit()
	While 1
		If TimerDiff($timer) >= $wait Then
			GUICtrlSetData($GIECPE_Edit1, "Error: loading time limit reached")
			ProcessClose($pid)
			Return -2
		EndIf
		$o_Shell = ObjCreate("Shell.Application")
		$o_ShellWindows = $o_Shell.Windows()
		For $o_window In $o_ShellWindows
			If $o_window.LocationURL = $sURL Then
				$o_IE = $o_window
				$Output[0] = $o_IE
				ExitLoop 2
			EndIf
		Next
	WEnd
	If Not IsObj($o_IE) Then
		GUICtrlSetData($GIECPE_Edit1, "Error: object error occurred")
		Return -3
	EndIf

	$acMain[1] = _IEPropertyGet($o_IE, "hwnd")
	$acMain[0] = WinGetProcess($acMain[1])
	$Output[1] = $acMain

	GUISetState(@SW_HIDE, $h_Parent)
	GUICtrlDelete($GIECPE_Edit1)
    _WinAPI_SetParent($acMain[1], $h_Parent)
    _WinAPI_SetWindowLong($acMain[1], $GWL_STYLE, $WS_POPUP + $WS_VISIBLE)

	GUISetState(@SW_SHOW, $h_Parent)


	ControlMove($acMain[1], "", "", $i_Left + 1, $i_Top + 1, $i_Width - 2, $i_Height - 2)
	WinActivate($acMain[1])
    Return $Output
EndFunc
