#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         Maurice Koster

 Script Function:
	API-Library for the Snarl notification system

#ce ----------------------------------------------------------------------------

#cs --- Snarl.au3 -- Snarl AutoItV3 include / copyright information ------------

   © 2004-2008 full phat products.  All Rights Reserved.

   Include this module if you want your AutoIt application to talk to Snarl.

        Version: 38 (R2.0)
       Revision: 2
        Created: 6-Dec-2004
   Last Updated: 11-Apr-2008
         Author: C. Peel (aka Cheekiemunkie)
        Licence: GNU LGPL (http://www.gnu.org/licenses/lgpl.html)

   Notes
   -----

   This include file can be used in conjunction with the Snarl API documentation
   (                                   ) when porting Snarl support to a different
   programming language.  
   
   As best as possible all functions are documented here, including the local and
   supporting ones.

   This module is adapted from the VB6 API (m_Snarl_i.bas).

   Revision History
   ----------------

   38.2 (11-Apr-08)
       - Clarified function return values.

   38.1 (19-Mar-08)
       - Fixed bug in snGetVersion() which would return True even if uSend() failed.

   39 (7-Apr-07)
       - Final R1.6 release

   36 (14-Mar-07)
       - VB-friendly UTF8 string conversions finally sorted out.  This change *only*
         affects the VB include (this one) and should *not* impact on existing VB-based
         applications.

   35 (13-Mar-07)
       - snGetAppPath() reworked completely.  Now Snarl itself provides the path through
         a 'Static' class child window within the Dispatcher window.

   34 (28-Feb-07)
       - Added string length constants (taken from Tresni's C++ includes)
       - Moved out all unused code/constants/types
       - Added new snSetTimeout() function and associated command
       - uSend() timeout increased from 100ms to 500ms
       - uSend() now returns M_FAILED if Snarl window not found or M_TIMED_OUT if sending timed out

   33 (21-Feb-07)
       - More commenting

   32 (13-Feb-07)
       - Added snGetSnarlWindow() -- standardised way of retrieving message handling window
       - Added WM_SNARLTEST constant

   31
       - snRegisterAlert() -- registers an alert for a specific application
       - snRegisterConfig2() -- allows external image to be used rather than config window icon
       - We now use SendMessageTimeout() instead of SendMessage()
       - snRegisterConfig() and snRegisterConfig2() both set a local variable (m_hWndFrom)
         with the hWnd parameter passed to them
       - snRevokeConfig() clears the m_hwndFrom local variable
       - uSend() now passes m_hWndFrom to Snarl in wParam

#ce  ----------------------------------------------------------------------------

#Include <WinAPI.au3>

; Constants

Const $SNARL_STRING_LENGTH = 1024
Const $SNARL_UNICODE_LENGTH = $SNARL_STRING_LENGTH / 2

#comments-start WM_SNARLTEST message

   This can be used for development and test purposes.  When received,
   Snarl will display a simple message in order to show that
   communication has been established okay.

   Parameters for SendMessage() are:

       hWnd - Snarl Dispatcher Window (use snGetSnarlWindow())
       wParam - Command - see table below
       lParam - Depends on wParam

       +--------+------------------------------------------------------+
       | wParam | lParam                                               |
       +--------+------------------------------------------------------+
       |    0   | Not used                                             |
       |    1   | Value is displayed by the Snarl message              |
       +--------+------------------------------------------------------+

   Possible return values are:
      -1                   - Succeeded
       0                   - SendMessage() failed
       M_NOT_IMPLEMENTED   - Bad wParam value

 
#comments-end

Const $WM_SNARLTEST = 0x400 + 237     ; note hardcoded WM_USER value!

#comments-start Global event identifiers

   Identifiers marked with a '*' are sent by Snarl in two ways:
       1. As a broadcast message (uMsg = 'SNARL_GLOBAL_MSG')
       2. To the window registered in snRegisterConfig() or snRegisterConfig2()
          (uMsg = reply message specified at the time of registering)

   In both cases these values appear in wParam.

   Identifiers not marked are not broadcast; they are simply sent to the application's
   registered window.

#comments-end

Const $SNARL_LAUNCHED = 1         ; Snarl has just started running*
Const $SNARL_QUIT = 2             ; Snarl is about to stop running*
Const $SNARL_ASK_APPLET_VER = 3   ; (R1.5) Reserved for future use
Const $SNARL_SHOW_APP_UI = 4      ; (R1.6) Application should show its UI


#comments-start Message event identifiers

   These are sent by Snarl to the window specified in snShowMessage() when the
   Snarl Notification raised times out or the user clicks on it.

#comments-end

Const $SNARL_NOTIFICATION_CLICKED = 32    ; notification was right-clicked by user
Const $SNARL_NOTIFICATION_TIMED_OUT = 33
Const $SNARL_NOTIFICATION_ACK = 34        ; notification was left-clicked by user

; Added in V37 (R1.6) -- same value, just improved the meaning of it */

Const $SNARL_NOTIFICATION_CANCELLED = $SNARL_NOTIFICATION_CLICKED

; -- M_RESULT ----------------------------------------------------------------------------

Const $M_ABORTED  =	 		0x80000007
Const $M_ACCESS_DENIED =	0x80000009
Const $M_ALREADY_EXISTS =	0x8000000C
Const $M_BAD_HANDLE = 		0x80000006
Const $M_BAD_POINTER =		0x80000005
Const $M_FAILED =			0x80000008
Const $M_INVALID_ARGS =		0x80000003
Const $M_NO_INTERFACE =		0x80000004
Const $M_NOT_FOUND =		0x8000000B
Const $M_NOT_IMPLEMENTED =	0x80000001
Const $M_OK =				0x00000000
Const $M_OUT_OF_MEMORY =	0x80000002
Const $M_TIMED_OUT =		0x8000000A 

#cs --------------------------------------------------------------------------------------

   SNARL_COMMANDS Enumeration

#ce --------------------------------------------------------------------------------------

; --- Standard commands -- all use a SNARLSTRUCT ---
    
Enum $SNARL_SHOW = 1, _
	$SNARL_HIDE, _ 
	$SNARL_UPDATE, _ 
	$SNARL_IS_VISIBLE, _ 
	$SNARL_GET_VERSION, _ 
	$SNARL_REGISTER_CONFIG_WINDOW, _ 
	$SNARL_REVOKE_CONFIG_WINDOW

; --- Following introduced in Snarl V37 (R1.6) ---

Enum $SNARL_REGISTER_ALERT = $SNARL_REVOKE_CONFIG_WINDOW+1, _ 
	$SNARL_REVOKE_ALERT, _ 
	$SNARL_REGISTER_CONFIG_WINDOW_2, _ 
	$SNARL_GET_VERSION_EX, _ 
	$SNARL_SET_TIMEOUT

; --- Extended commands -- all use a SNARLSTRUCTEX ---

Const $SNARL_EX_SHOW = 0x20


#cs ---------------------------------------------------------------------------------------------------------------
    STRUCTURES
#ce ---------------------------------------------------------------------------------------------------------------

#comments-start SNARLSTRUCT

   This is an internal structure used to pass information between Snarl and
   registered applications - do not attempt to craft your own messages
   using this structure; use the standard sn... api methods instead.

#comments-end

#cs
Public Type SNARLSTRUCT
    Cmd As SNARL_COMMANDS       ' 1. what to do...
    Id As Long                  ' 2. snarl message id (returned by snShowMessage())
    Timeout As Long             ' 3. timeout in seconds (0=sticky)
    LngData2 As Long            ' 4. reserved
    title As String * 512		' 5.
    Text As String * 512        ' 6. VB defines these as wide so they're actually 1024 bytes
    Icon As String * 512		' 7.

End Type

Public Type SNARLSTRUCTEX
    Cmd As SNARL_COMMANDS       ' 1. // what to do...
    Id As Long                  ' 2. // snarl message id (returned by snShowMessage())
    Timeout As Long             ' 3. // timeout in seconds (0=sticky)
    LngData2 As Long            ' 4. // reserved
    title As String * 512		' 5.
    Text As String * 512        ' 6. // VB defines these as wide so they're actually 1024 bytes
    Icon As String * 512		' 7.
    Class As String * 512		' 8.
    Extra As String * 512		' 9.
    Extra2 As String * 512		' 10.
    Reserved1 As Long			' 11.
    Reserved2 As Long			' 12.

End Type

#ce

;  DllStructure
Const $SNARLSTRUCT = "long Cmd;long Id;long Timeout;long LngData2;char Title[1024];char Text[1024];char Icon[1024]"
Const $SNARLSTRUCTEX = "long Cmd;long Id;long Timeout;long LngData2;char Title[1024];char Text[1024];char Icon[1024];char Class[1024];char Extra[1024];char Extra2[1024];long Reserved1;long Reserved2"
Const $COPYDATASTRUCT = "long dwData;long cbData;long lpData"

; internal declares 

;Const $WM_COPYDATA = 0x4A
Const $SNARL_GLOBAL_MSG = "SnarlGlobalEvent"

Const $SMTO_ABORTIFHUNG = 0x2

Global $m_hwndFrom = 0 ; Long

#cs WinAPI wrappers
#ce

Func IsWindow($hwnd)
Local $result

	$result = DllCall("user32.dll", "long", "IsWindow", "long", $hwnd)
	Return $result[0]
	
EndFunc

Func SendMessageTimeout( $hWnd, $Msg, $wParam, $lParam, $fuFlags, $uTimeout, ByRef $lpdwResult )
Local $result

#cs
	ConsoleWrite ( "SendMessageTimeout hwnd:" & $hWnd & @CRLF )
	ConsoleWrite ( "SendMessageTimeout msg:" & $Msg & @CRLF )
	ConsoleWrite ( "SendMessageTimeout wparam:" & $wParam & @CRLF )
	ConsoleWrite ( "SendMessageTimeout lparam:" & $lParam & @CRLF )
	ConsoleWrite ( "SendMessageTimeout fuflags:" & $fuFlags & @CRLF )
	ConsoleWrite ( "SendMessageTimeout timeout:" & $uTimeout & @CRLF )
#ce

	$result = DllCall("user32.dll", "long", "SendMessageTimeoutA", "hwnd", $hWnd, "uint", $Msg, _ 
		"wparam", $wParam, "lparam", $lParam, "uint", $fuFlags, "uint", $uTimeout, "dword*", $lpdwResult)
	
;	ConsoleWrite ( "SendMessageTimeout error:" &@error )
	if @error = 0 Then
;		ConsoleWrite ( "SendMessageTimeout:" & $result[0] & @CRLF )
;		ConsoleWrite ( "SendMessageTimeout result:" & $result[7] & " - " & $lpdwResult & @CRLF )
		$lpdwResult = $result[7]
		Return $result[0]
	Else
		Return 0
	EndIf
	
EndFunc



;--- Private parts

Func uSend($pss)
Dim $hWnd ; Long
Dim $pcds ; COPYDATASTRUCT
Dim $dw ; Long
Dim $p

	$pcds = DllStructCreate($COPYDATASTRUCT)
	
    $hWnd = snGetSnarlWindow()
    If IsWindow($hWnd) <> 0 Then

		DllStructSetData( $pcds, 1, 2 )  ; SNARLSTRUCT
        DllStructSetData( $pcds, 2, DllStructGetSize($pss) )
        DllStructSetData( $pcds, 3, DllStructGetPtr($pss) )
		
		$p = DllStructGetPtr($pcds)
				
        If SendMessageTimeout($hWnd, 0x4A, $m_hwndFrom, $p, $SMTO_ABORTIFHUNG, 500, $dw) > 0 Then
            ; worked! 
            Return $dw

        Else
            ; timed-out or failed 
            Return 0x8000000A         ; M_TIMED_OUT

        EndIf
		
    Else
        Return 0x80000008             ; M_FAILED

    EndIf

EndFunc

Func uLOWORD($dw)
	ConsoleWrite( "dw: " & $dw & @CRLF )
	Return BitAND($dw, 0x1111)

EndFunc

Func uHIWORD($dw)
	ConsoleWrite( "dw: " & $dw & @CRLF )
	Return BitShift($dw, 16)

EndFunc



; ---- Public area


Func snShowMessage($Title, $Text, $Timeout=0, $IconPath="", $hWndReply=0, $uReplyMsg=0)
Dim $pss;  As SNARLSTRUCT

	$pss = DllStructCreate($SNARLSTRUCT)

	DllStructSetData($pss, 1, $SNARL_SHOW )
    DllStructSetData($pss, 5, $Title )
	DllStructSetData($pss, 6, $Text )
	DllStructSetData($pss, 7, $IconPath )
	DllStructSetData($pss, 3, $Timeout )
	DllStructSetData($pss, 4, $hWndReply )
	DllStructSetData($pss, 2, $uReplyMsg )

    Return uSend($pss)

EndFunc

Func snHideMessage($Id)
Dim $pss

	$pss = DllStructCreate($SNARLSTRUCT)
	
	DllStructSetData($pss, 1, $SNARL_HIDE )
    DllStructSetData($pss, 2, $Id )
    
	Return uSend($pss)

EndFunc

Func snIsMessageVisible($Id)
Dim $pss

	$pss = DllStructCreate($SNARLSTRUCT)
	
	DllStructSetData($pss, 1, $SNARL_IS_VISIBLE )
    DllStructSetData($pss, 2, $Id )

	Return uSend($pss)

EndFunc

Func snUpdateMessage($Id, $Title, $Text, $IconPath = "")
Dim $pss

	$pss = DllStructCreate($SNARLSTRUCT)
	
	DllStructSetData($pss, 1, $SNARL_UPDATE )
    DllStructSetData($pss, 2, $Id )
	DllStructSetData($pss, 5, $Title )
	DllStructSetData($pss, 6, $Text )
	DllStructSetData($pss, 7, $IconPath )

    Return uSend($pss)

EndFunc

Func snRegisterConfig($hWnd, $AppName, $ReplyMsg)
Dim $pss ;  As SNARLSTRUCT

	$pss = DllStructCreate($SNARLSTRUCT)
    $m_hwndFrom = $hWnd
   
	DllStructSetData($pss, 1, $SNARL_REGISTER_CONFIG_WINDOW )
    DllStructSetData($pss, 4, $hWnd )
    DllStructSetData($pss, 2, $ReplyMsg )
    DllStructSetData($pss, 5, $AppName )

    Return uSend($pss)

EndFunc

Func snRevokeConfig($hWnd)
Dim $pss ; As SNARLSTRUCT

	$pss = DllStructCreate($SNARLSTRUCT)
	
	DllStructSetData($pss, 1, $SNARL_REVOKE_CONFIG_WINDOW )
	DllStructSetData($pss, 4, $hWnd )
	
    $result = uSend($pss)
	
    $m_hwndFrom = 0

	Return $result
	
EndFunc

#comments-start snGetSnarlWindow()
   snGetSnarlWindow() -- returns a handle to the Snarl Dispatcher window  (V37)

   Synopsis

       int32 snGetSnarlWindow()

   Inputs
       None

   Results
       Returns handle to Snarl Dispatcher window, or zero if it's not found

   Notes
       This is now the preferred way to test if Snarl is actually running


#comments-end

Func snGetSnarlWindow() ; As Long
    Local $result
    $result = DllCall("user32.dll", "hwnd", "FindWindow", "ulong", 0, "str", "Snarl")
    return $result[0]
   
EndFunc

Func snGetVersion(ByRef $Major, ByRef $Minor)
Dim $pss ; As SNARLSTRUCT
Local $hr ; As Long

	$pss = DllStructCreate($SNARLSTRUCT)

    DllStructSetData($pss, 1, $SNARL_GET_VERSION ) ; Cmd
    $hr = uSend($pss)
    If BitAND($hr, 0x80000000) = 0 Then         ; FIXED: uSend() returns an M_RESULT on error
		ConsoleWrite( "GetVersion: " & $hr & @CRLF )
        $Major = uHIWORD($hr)
        $Minor = uLOWORD($hr)
        Return True

    EndIf

EndFunc

#comments-start

   snGetGlobalMsg() -- returns the value of Snarl's global registered message

   Synopsis

       int32 snGetGlobalMsg()

   Inputs
       None

   Results
       A 16-bit value (translated to 32-bit) which is the registered Windows
       message for Snarl.

   Notes
       Snarl registers SNARL_GLOBAL_MSG during startup which it then uses to
       communicate with all running applications through a Windows broadcast
       message.  This function can only fail if for some reason the Windows
       RegisterWindowMessage() function fails - given this, this function
       *cannnot* be used to test for the presence of Snarl.

#comments-end

Func snGetGlobalMsg()

	$result = DllCall( "user32.dll", "long", "RegisterWindowMessageA", "str", $SNARL_GLOBAL_MSG )
	
	If @error = 0 then
		Return $result[0]
	Else	
		Return 0
	EndIf

EndFunc


#comments-start -----------------------------------------------------------------------------------------------


    V37 (R1.6) Additions


#comments-end -------------------------------------------------------------------------------------------------


#comments-start

   snRegisterAlert() -- registers a specific application notification  (V37)

   Inputs
       AppName - Application name, same as that used in snRegisterConfig() or snRegisterConfig2()
       Class - Alert class name

   Results
       Returns M_OK if the alert registered okay, or one of the following if it didn't:
           M_FAILED - Snarl not running
           M_TIMED_OUT - Message sending timed out
           M_NOT_FOUND - Application not found in Snarl's roster
           M_ALREADY_EXISTS - Alert is already registered

#comments-end

Func snRegisterAlert($AppName, $Class)
Dim $pss ; As SNARLSTRUCT

	$pss = DllStructCreate($SNARLSTRUCT)

    DllStructSetData($pss, 1, $SNARL_REGISTER_ALERT ) ; Cmd
	DllStructSetData($pss, 5, $AppName )
	DllStructSetData($pss, 6, $Class )

    Return uSend($pss)

EndFunc

#comments-start

   snRegisterConfig2() -- registers a configuration handler with Snarl  (V37)

   Inputs
       hWnd - Application name, same as that used in snRegisterConfig() or snRegisterConfig2()
       AppName - Name of application to register
       ReplyMsg - Message Snarl will send to hWnd to notify it of something
       Icon - Path to PNG icon to use

   Results
       Returns M_OK if the handler registered okay, or one of the following if it didn't:
           M_FAILED - Snarl not running
           M_TIMED_OUT - Message sending timed out
           M_ALREADY_EXISTS - Application is already registered
           M_ABORTED - Internal problem registering the handler

#comments-end

Func snRegisterConfig2($hWnd, $AppName, $ReplyMsg, $Icon)
Dim $pss ; As SNARLSTRUCT

    $m_hwndFrom = $hWnd

	$pss = DllStructCreate($SNARLSTRUCT)

    DllStructSetData($pss, 1, $SNARL_REGISTER_CONFIG_WINDOW_2 ) ; Cmd
	DllStructSetData($pss, 4, $hWnd )
	DllStructSetData($pss, 2, $ReplyMsg )
	DllStructSetData($pss, 5, $AppName )
	DllStructSetData($pss, 7, $Icon )

    Return uSend($pss)

EndFunc


#comments-start

   snGetIconsPath() -- returns a path to Snarl's default icon location  (V37)

   Synopsis

       str snGetIconsPath()

   Inputs
       None

   Results
       A fully-qualified path to Snarl's default icon location

   Notes
       The easiest way to create this function is as below; simply return the
       result of snGetAppPath() and tag "etc\icons\" to the end of it.

       Starting with R2.0 (V38) Snarl now makes better use of per-user settings
       by storing configuration data in %APPDATA%.  Consequently the use of this
       function is now very limited.

#comments-end

Func snGetIconsPath()

    Return snGetAppPath() & "etc\icons\"

EndFunc

#comments-start

   snGetAppPath() -- returns a path to Snarl's installed location  (V37)

   Synopsis

       str snGetAppPath()

   Inputs
       None

   Results
       A fully-qualified path to the location of the *running* instance of Snarl
       or an empty string if an error occurred (mostly likely Snarl isn't running)

   Notes
       Snarl creates a static control within its dispatcher window, the label of
       which is set to the path the executable is run from.  This function simply
       finds the dispatcher window, then finds the static control and retrieves
       the control's title.

       Starting with R2.0 (V38) Snarl now makes better use of per-user settings
       by storing configuration data in %APPDATA%.  Consequently the use of this
       function is now very limited.

#comments-end

Func snGetAppPath() 
Dim $hWnd ; As Long
Dim $hWndPath ; As Long
Dim $sz ; As String
Dim $i ; As Long
Dim $result

    $hWnd = snGetSnarlWindow()
    If $hWnd <> 0 Then
		
		$result = DllCall( "user32.dll","long", "FindWindowExA", "long", $hwnd, "long", 0, "str", "static", "long", 0 )
		if @error = 0 Then
			$hWndPath = $result[0]
		Else
			$hWndPath = 0
		EndIf
		
        If $hWndPath <> 0 Then
           
		   $result = DllCall("user32.dll", "int", "GetWindowText", "hwnd", $hWndPath, "str", "", "int", 32768)
			if @error = 0 Then
				$i = $result[0]   ; number of chars returned
				$sz = $result[2]   ; Text returned in param 2
			Else
				$i = 0
				$sz=""
			EndIf
			
            If $i > 0 Then 
				Return StringLeft($sz, $i)
			EndIf
			
        EndIf
    EndIf

EndFunc


#comments-start

   snShowMessageEx() -- displays a Snarl notification using registered class  (V37)

   Inputs
       Class - Notification class, same as that specified in snRegisterAlert()
       Title - Text to display in title
       Text - Text to display in body
       Timeout - Number of seconds to display notification or zero for indefinite (sticky)
       IconPath - Path to PNG icon to use
       hWndReply - Handle of window for Snarl to send replies to
       uReplyMsg - Message for Snarl to send to hWndReply
       SoundFile - Path to WAV file to play

   Results
       Returns an M_RESULT indicating success or failure

#comments-end

Func snShowMessageEx($Class, $Title, $Text, $Timeout=0, $IconPath="", $hWndReply=0, $uReplyMsg=0, $SoundFile="")
Dim $pss ; As SNARLSTRUCTEX

	$pss = DllStructCreate($SNARLSTRUCTEX)

    DllStructSetData($pss, 1, $SNARL_EX_SHOW ) ; Cmd
	DllStructSetData($pss, 5, $Title )
	DllStructSetData($pss, 6, $Text )
	DllStructSetData($pss, 7, $IconPath )
	DllStructSetData($pss, 3, $Timeout )
	DllStructSetData($pss, 4, $hWndReply )
	DllStructSetData($pss, 2, $uReplyMsg )
	DllStructSetData($pss, 9, $SoundFile )
	DllStructSetData($pss, 8, $Class )

    Return uSend($pss)

EndFunc

#comments-start

   snGetVersionEx() -- returns the Snarl system version number  (V37)

   Synopsis

   int32 snGetVersionEx()

   Inputs
       None

   Results
       Returns Snarl system version number or one of the following:
           M_FAILED - Snarl not running
           M_TIMED_OUT - Message sending timed out
           0 or M_NOT_IMPLEMENTED - Pre-V37 version of Snarl

#comments-end

Func snGetVersionEx()
Dim $pss ; As SNARLSTRUCT

	$pss = DllStructCreate($SNARLSTRUCTEX)
	
    DllStructSetData($pss, 1, $SNARL_GET_VERSION_EX )
	
    Return uSend($pss)

EndFunc

#comments-start

   snSetTimeout() -- changes the timeout of an active notification  (V37)

   Inputs
       Id - Notification identifier, returned after a successful snShowMessage() or snShowMessageEx()
       Timeout - Updated timeout in seconds, zero means display indefinately

   Results
       M_OK - Succeeded
       M_FAILED - Snarl not running
       M_TIMED_OUT - Message sending timed out
       M_NOT_FOUND - Notification wasn't found

   Notes
       Timeout cannot be less than zero or greater than 65535 (18.2 hours)

#comments-end

Func snSetTimeout($Id, $Timeout)
Dim $pss ; As SNARLSTRUCT

	$pss = DllStructCreate($SNARLSTRUCT)
	
    DllStructSetData($pss, 1, $SNARL_SET_TIMEOUT)
    DllStructSetData($pss, 2, $Id )
    DllStructSetData($pss, 4, $Timeout )
	
    Return uSend($pss)

EndFunc
