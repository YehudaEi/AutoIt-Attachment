#include-once
#include <WinApi.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
Opt("OnExitFunc","MsgBoxHookDeRegister")

; AutoIt Coding by Prog@ndy

;~Author of adapted VB-Code:    © Copyright 2002 Pacific Database Pty Limited
;~           Graham R Seach gseach@pacificdb.com.au
;~           Phone: +61 2 9872 9594  Fax: +61 2 9872 9593
;~
;~           Adapted from Randy Birch;~s code for creating and
;~           displaying a custom MsgBox with user-defined button
;~           text: "Modifying a Message Box with SetWindowsHookEx"
;~
;~           You may freely use and distribute this code
;~           with any applications you may develop, on the
;~           condition that the copyright notice remains
;~           unchanged, and intact as part of the code. You
;~           may not publish this code in any form without
;~           the express written permission of the copyright
;~           holder.
;~
;~                                                 
;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~;~


;~Miscellaneous constants
;~ Local Const $WH_CBT = 5
;~ Local Const $GWL_HINSTANCE = (-6)
Local Const $HCBT_ACTIVATE = 5
$MSGBOXEX_HOOK_PARAMS = "long hWndOwner;long hHook"

$MSGBOXEX_WINDOWPLACEMENT = "long Length;long flags;long showCmd;"&$tagPOINT&" ptMinPosition;"&$tagPOINT&" ptMaxPosition;" &$tagRECT& "rcNormalPosition"

;~We need these declared at module level as they is used
;~in the call and the hook proc
$MSGBOXEX_MSGHOOK = DllStructCreate($MSGBOXEX_HOOK_PARAMS)
$MSGBOXHOOKPROC = DllCallbackRegister("MsgBoxHookProc","long","long;long;long")
Func MsgBoxHookDeRegister()
    DllCallbackFree($MSGBOXHOOKPROC)
EndFunc

;### VARIABLES ##
;~Miscellaneous variables
Global $MSGBOXEX_strOk; As String
Global $MSGBOXEX_strYes; As String
Global $MSGBOXEX_strNo; As String
Global $MSGBOXEX_strCancel; As String
Global $MSGBOXEX_strPrompt; As String
Global $MSGBOXEX_strTitle; As String
Global $MSGBOXEX_mLeft; As Long ;~The MsgBox;~s Left position
Global $MSGBOXEX_mTop; As Long  ;~The MsgBox;~s Top position
Global $sIcon ;As String
;###############

;### ENUMS #####
    ;~Enum for the MsgBox;~s Flags
    ;~ Public Enum FlagType
        $mbNone = 0
        $mbInformation = 0x40
        $mbExclamation = 0x30
        $mbQuestion = 0x20
        $mbCritical = 0x10
    ;~ End Enum
    
    ;~Enum for the MsgBox;~s default button
    ;~ Public Enum DefaultButton
        $mbDefaultButton1 = 0x0
        $mbDefaultButton2 = 0x100
        $mbDefaultButton3 = 0x200
    ;~ End Enum
;##############

;===============================================================================
;
; Function Name:   xMsgBox
; Description::    Shows a Message Box with Cutsom Buttons and Optioinal a custom Icon
; Parameter(s):    $lFlagType    -> MSgBox Flags
;                  $sPrompt      -> Text
;                  $sTitle       -> Title
;                  $sButtonText1 -> Button1, "" = default Buttons
;                  $sButtonText2 -> Button2, "" = only 1 Button, if Button 1 defined
;                  $sButtonText3 -> Button2, "" = 2 Buttons if Button 1 and 2 defined
;                  $lLeft        -> Left Position of MsgBox
;                  $lTop         -> Top Position of MsgBox
;                  $sIconPath    -> Optional: Path of Icon for MsgBox, Default: Empty
;                  $hwndThreadOwner -> Optional: Handle of owner window
;                  
; Requirement(s):  v3.2.12.0 or higher
; Return Value(s): If no custom ButtonTexts: default MsgBox
;              1 named Button: Closing and Button = 1
;              2 named Buttons: Button1 = 6, Button2 = 7
;              3 named Buttons: Button1 = 6, Button2 = 7, Button3 = 2
;                  For 2 and 3 Buttons: Closing MsgBox = 2 (cancel) [ ! 3rd named Button is the same ! ]
; Author(s):   Prog@ndy    
;
;===============================================================================
;
Func xMsgBox($lFlagType, _ 
    $sTitle, $sPrompt, _
    $sButtonText1 = "" , $sButtonText2 = "" , _
    $sButtonText3 = "" , _
    $lLeft = 0, $lTop = 0, _
    $sIconPath = "", _
    $hwndThreadOwner = 0)

    Global $MSGBOXEX_strOk; As String
    Global $MSGBOXEX_strYes; As String
    Global $MSGBOXEX_strNo; As String
    Global $MSGBOXEX_strCancel; As String
    Global $MSGBOXEX_strPrompt; As String
    Global $MSGBOXEX_strTitle; As String
    
    Local $hInstance; As Long
    Local $hThreadId; As Long
    Local $hWndOwner; As Long
    Local $lButtons; As Long
    Local $lWidth; As Long
    Local $lHeight; As Long
    Local $xMsgBox
        
    ;~Setup the MsgBox parameters
    $MSGBOXEX_strPrompt = $sPrompt
    $MSGBOXEX_strTitle = $sTitle
    $MSGBOXEX_mLeft = Int($lLeft)
    $MSGBOXEX_mTop = Int($lTop)
	If $lLeft = Default Then $MSGBOXEX_mLeft = Default
	If $lTop = Default Then $MSGBOXEX_mTop = Default
	
    If ($sButtonText1 <> "") Or ($sButtonText2 <> "") Or ($sButtonText3 <> "") Then $lFlagType = BitAND($lFlagType,BitNOT(21))
    ;~Work out which buttons to display, and what text to put in them.
    If ($sButtonText1 <> "") And ($sButtonText2 <> "") _
            And ($sButtonText3 <> "") Then
        $MSGBOXEX_strYes = $sButtonText1
        $MSGBOXEX_strNo = $sButtonText2
        $MSGBOXEX_strCancel = $sButtonText3
        $lButtons = BitOR(0x3 , $lFlagType )
    ElseIf ($sButtonText1 <> "") And ($sButtonText2 <> "") Then
        $MSGBOXEX_strYes = $sButtonText1
        $MSGBOXEX_strNo = $sButtonText2
        $lButtons = BitOR(0x4 , $lFlagType )
    ElseIf ($sButtonText1 <> "") Then
        $MSGBOXEX_strYes = $sButtonText1
        $MSGBOXEX_strOk = $sButtonText1
        $lButtons = $lFlagType
    EndIf
    ;~Check for an icon
    $sIcon = ""
    If $sIconPath <> "" Then
        If FileExists($sIconPath) Then $sIcon = $sIconPath
    EndIf
    
    ;~Setup the hook.
    $hInstance = _WinAPI_GetWindowLong($hwndThreadOwner, $GWL_HINSTANCE)
    If $hwndThreadOwner = 0 Then 
        $hInstance = DllCall("kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
        $hInstance = $hInstance[0]
    EndIf
;~     MsgBox(0, '', _WinAPI_GetLastErrorMessage())
    $hThreadId = _WinAPI_GetCurrentThreadId()
    $hWndOwner = _WinAPI_GetDesktopWindow()
    
    ;~Setup the MSGBOX_HOOK_PARAMS values.
    ;~By specifying a Windows hook as one of the params, we can intercept messages
    ;~sent by Windows and thereby manipulate the dialog.
;~     With MSGHOOK

    ;~ Private Declare Function SetWindowsHookEx Lib "user32" _
;~     Alias "SetWindowsHookExA" (ByVal idHook; As Long, _
;~     ByVal lpfn; As Long, ByVal hmod; As Long, _
;~     ByVal dwThreadId; As Long); As Long
        DllStructSetData($MSGBOXEX_MSGHOOK,"hWndOwner", $hWndOwner)
        $temp = DllCall("user32.dll","hwnd","SetWindowsHookEx","int",$WH_CBT,"ptr",DllCallbackGetPtr($MSGBOXHOOKPROC),"hwnd",$hInstance,"dword",$hThreadId)
        DllStructSetData($MSGBOXEX_MSGHOOK,"hHook", $temp[0]);SetWindowsHookEx(WH_CBT, AddressOf MsgBoxHookProc, hInstance, hThreadId)
;~     End With
    
    ;~Call the MessageBox API and return the value as the result of the function. The
    ;~length of the Prompt & Title strings assures the messagebox is wide enough for
    ;~the message that will be set in the hook.

    $xMsgBox = MsgBox($lButtons, $sTitle,$sPrompt,0,$hWndOwner )
;~     $xMsgBox = DllCall("user32.dll","long","MessageBox","long",$hWndOwner,"str", $sPrompt,"str", $sTitle,"long", $lButtons)
    Return SetError(@error,@extended,$xMsgBox)
EndFunc

Func MsgBoxHookProc($uMsg,$wParam, $LParam); As Long
    Local $mWidth; As Long
    Local $mHeight; As Long
    Local $wp = DllStructCreate($MSGBOXEX_WINDOWPLACEMENT)
    Local $retVal; As Long
    Local $hWnd; As Long
    Local $hIcon; As Long
        
    ;~When the message box is about to display, change the titlebar text,
    ;~prompt message and button captions.
    If $uMsg = $HCBT_ACTIVATE Then
        ;~         UnhookWindowsHookEx MSGHOOK.hHook
            DllCall("user32.dll","long","UnhookWindowsHookEx","long",DllStructGetData($MSGBOXEX_MSGHOOK,"hHook"))
        ;~In an HCBT_ACTIVATE message, wParam holds the handle to the messagebox.
        WinSetTitle($wParam,"", $MSGBOXEX_strTitle)
        
        
        ;~The ID;~s of the buttons on the message box correspond exactly to the values they return,
        ;~so the same values can be used to identify specific buttons in a SetDlgItemText call.
        If ($MSGBOXEX_strOk <> "") Then  DllCall("user32.dll","long","SetDlgItemText","long",$wParam,"long", 1,"str", $MSGBOXEX_strOk)             ;~Use IDYES for VB
        If ($MSGBOXEX_strYes <> "") Then  DllCall("user32.dll","long","SetDlgItemText","long",$wParam,"long", 6,"str", $MSGBOXEX_strYes)             ;~Use IDYES for VB
        If ($MSGBOXEX_strNo <> "") Then DllCall("user32.dll","long","SetDlgItemText","long",$wParam,"long", 7,"str", $MSGBOXEX_strNo)                ;~Use IDNO for VB
        If ($MSGBOXEX_strCancel <> "") Then DllCall("user32.dll","long","SetDlgItemText","long",$wParam,"long", 2,"str", $MSGBOXEX_strCancel)    ;~Use IDCANCEL for VB
        
        ;~Change the dialog prompt text
        DllCall("user32.dll","long","SetDlgItemText","long",$wParam,"long", 65535,"str", $MSGBOXEX_strPrompt)
        
        ;~Get the message box;~s handle
;~         $hwnd = _WinAPI_FindWindow("#32770",$MSGBOXEX_strTitle)
        $hwnd = HWnd($wParam)

        ;~Only move the MsgBox is values have been supplied
        If $MSGBOXEX_mLeft > 0 Or $MSGBOXEX_mTop > 0 Then
            
            ;~Move the message box
            $retVal = WinMove($hwnd,"",$MSGBOXEX_mLeft,$MSGBOXEX_mTop);MoveWindow(hWnd, mLeft, mTop, mWidth, mHeight, True)
            ConsoleWrite($retVal & @CRLF)
        EndIf
        
        If StringLen($sIcon) > 0 Then
            $hIcon = _WinAPI_LoadImage(0, $sIcon, $IMAGE_ICON, 0, _
                0, $LR_LOADFROMFILE)
            
            If $hIcon <> 0 Then
                $retVal = _SendMessage($hWnd, $WM_SETICON, 1, $hIcon)
                If $retVal <> 0 Then _WinAPI_DestroyIcon($retVal)
            EndIf
            _WinAPI_DestroyIcon($hIcon)
        EndIf
        

    EndIf

    ;~Return False to let normal processing continue.
    Return False
EndFunc

;~ ;### EXAMPLE
;~ $REturn = xMsgBox(16+0x200,"Title","Text","Butt 1","The 2nd","The3rd",Default,34,"C:\vista.ico")
;~ MsgBox(0, 'ReturnValue:', $REturn)

; To Use Custom OnAutoItExitFunc, use:
;~ Opt("OnExitFunc","OnAutoItExit")

;~ MsgBoxHookDeRegister() ; Should be called in OnAutoItExit, if it is used.