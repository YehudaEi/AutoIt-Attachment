#NoTrayIcon
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MISC.AU3>
#Include <WinAPI.au3>
#include <String.au3>
#include <Array.au3>
#NoTrayIcon
global $t=0
Opt("WinTitleMatchMode", 4)
If @AutoItX64 Then
    DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
EndIf

HotKeySet("!{F4}","nicetry")
HotKeySet("!{D}","nicetry")
HotKeySet("!{TAB}","nicetry")
HotKeySet("{ESC}", "nicetry")
HotKeySet("!{x}", "Exitprogram")
HotKeySet("{LWIN}", "nicetry")
HotKeySet("{RWIN}", "nicetry")
HotKeySet("{SPACE}", "nicetry")
HotKeySet("{LEFT}", "nicetry")
HotKeySet("{RIGHT}", "nicetry")
HotKeySet("{UP}", "nicetry")
HotKeySet("{DOWN}", "nicetry")
HotKeySet("{TAB}", "nicetry")
HotKeySet("{F1}", "nicetry")

FileInstall("matrix code nfi.otf","C:\WINDOWS\Fonts\matrix code nfi.otf")
;Opt ('GUIoneventmode', 1)
$dll = DllOpen("user32.dll")

If _Singleton("LiA - Lock it all V1.2", 1) = 0 Then
    ProcessClose("LiA_Manjish.exe")
    ProcessWaitClose("LiA_Manjish.exe")
    Exit
EndIf

$_VERSION = '1.2.0'
$_SETTINGS = "settings.ini"
$_CRYPTSTRING = "LiA - Lock it all V1.2"
Global $_COPYRIGHT = "LiA - Lock it all V1.2 " & $_VERSION & @CRLF & "LiA"
Global Enum $TIMERID1 = 1001
$winlock = DllOpen("WinLockDll.dll")

If Not FileExists("settings.ini") Then
    MsgBox(0, "Firstrun", "Welcome to LockPC, the next step will help you configure LockPC." & @CRLF & @CRLF & "To run this setup again or change your lock code, delete the settings.ini found in the installation directory." & @CRLF & @CRLF & "For any questions - Mattijsje9@hotmail.com.")
    CreateSettingsFile()
Else
    $_INIVERSION = IniRead("settings.ini", "app", "version", '0')
    If $_VERSION <> $_INIVERSION Then
        MsgBox(0, "Error", "Your settings file was created in a different version, creating a new one...")
        FileDelete("settings.ini")
        CreateSettingsFile()
    EndIf
EndIf
Global $PassForm, $Input1, $Button1, $nMsg, $Attempts = 5,$Password="1111"
Global $passcode = _StringEncrypt(0, IniRead($_SETTINGS, "set", "passcode", '0000'), $_CRYPTSTRING)
Global $wmplayer_pause_resume = IniRead($_SETTINGS, "set", "wmplayer_pause_resume", '0')
Global $monitor_idle_off = IniRead($_SETTINGS, "set", "monitor_idle_off", '0')
Global $messenger_contact_list = IniRead($_SETTINGS, "set", "messenger_contact_list", '0')
Global $display_clock = IniRead($_SETTINGS, "set", "display_clock", '0')
Global $beep_on_deny = IniRead($_SETTINGS, "set", "beep_on_deny", '0')
Global $gmail_count = IniRead($_SETTINGS, "set", "gmail_count", '0')
Global $gmail_username = IniRead($_SETTINGS, "set", "gmail_username", '0')
Global $gmail_password = _StringEncrypt(0, IniRead($_SETTINGS, "set", "gmail_password", ''), $_CRYPTSTRING)

If Not IsDeclared("SM_VIRTUALWIDTH") Then Global Const $SM_VIRTUALWIDTH = 78
If Not IsDeclared("SM_VIRTUALHEIGHT") Then Global Const $SM_VIRTUALHEIGHT = 79
$VirtualDesktopWidth = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALWIDTH)
$VirtualDesktopWidth = $VirtualDesktopWidth[0]
$VirtualDesktopHeight = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALHEIGHT)
$VirtualDesktopHeight = $VirtualDesktopHeight[0]

Global $_WinWidth=$VirtualDesktopWidth
Global $_WinHeight=$VirtualDesktopHeight
Global $prevleng = 0
Global $mainpassentry
Global $hwnd = WinGetHandle("classname=Progman")
Global $user32 = DllOpen("user32.dll")
Global $last_active = 0
Global $timer = TimerInit()
Global $owmplayer
Global $DELAYTIMER = TimerInit()
Global $DELAY = 3
Global $DELAYTIMER2 = TimerInit()
Global $DELAY2 = 5
Global $new_data = "Loading..."
Global $old_data = ""
Global $_INFO[1]
Global $LabelStyle = $SS_CENTER
global $iTimer1
Global $hCallback
MainLock()
	

;$Parent = WinGetHandle ('Program Manager','')

DllClose($dll)

Func DoNothing()
    Return
EndFunc

Func exit1()
	Exit
EndFunc

Func _RandomMsg()
    Local $RandomMsg[10]
    $RandomMsg[0] = "Wrong Password!"
    $RandomMsg[1] = "Step away from the computer."
    $RandomMsg[2] = "Your not Mattijs."
    $RandomMsg[3] = "Give Up!"
    $RandomMsg[4] = "Don't Touch!"
    $RandomMsg[5] = "Please Enter Correct Password."
    $RandomMsg[6] = "Try Again!"
    $RandomMsg[7] = "Stop pushing my buttons."
    $RandomMsg[8] = "Seriously. Go get a Life!!"
    $RandomMsg[9] = "Ctrl-Alt-Dipshit"
    
    Return $RandomMsg[Random(10)]
EndFunc
 



Func Exitprogram()
    If ProcessExists("MLiA.exe") Then
    ProcessClose("MLiA.exe")
    Exit
ElseIf ProcessExists("MLiA.exe") = 0 Then
    Exit
    EndIf
EndFunc

Func Mouse()
    ShellExecute ( "MLiA.exe", "", "@DesktopDir" , "open", @SW_MINIMIZE)
EndFunc

    
Func CheckGmail()
    $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
    
    $oHTTP.Open("GET", "https://mail.google.com/mail/feed/atom", False)
    
    $oHTTP.SetCredentials($gmail_username, $gmail_password, 0)
    
    $oHTTP.Send()
    
    $response = $oHTTP.ResponseText
    
    If StringInStr($response, "<fullcount>", false) Then
        $_COUNT = _StringBetween($response, "<fullcount>", "</fullcount>")
        $_COUNT = Int($_COUNT[0])
        $s = "s"
        If $_COUNT = 0 Then
            $_COUNT = "no"
        ElseIf $_COUNT = 1 Then
            $s = ""
        EndIf
        $_RETURN = "You have " & $_COUNT & " new email" & $s
    Else
        $_RETURN = "Gmail Error"
        $_COUNT = False
    EndIf
    
    $_INFO[$gmail_count_i] = $_RETURN
EndFunc


Func timerevent($hWnd, $Msg, $iIDTimer, $dwTime)
    If $display_clock = 1 Then
        GUICtrlSetData($CLOCK, @HOUR & ":" & @MIN & ":" & @SEC)
    EndIf
    If $messenger_contact_list = 1 Then
        If Int(TimerDiff($DELAYTIMER)/1000) > $DELAY Then
            msnwindowlist()
            $DELAYTIMER = TimerInit()
        EndIf
    EndIf
    If $gmail_count = 1 Then
        If Int(TimerDiff($DELAYTIMER2)/1000) > $DELAY2 Then
            CheckGmail()
            $DELAYTIMER2 = TimerInit()
        EndIf
    EndIf
EndFunc

Func msnwindowlist()
    If ProcessExists("msnmsgr.exe") Then
        $processes = ProcessList("msnmsgr.exe")
        For $i = 1 To $processes[0][0]
            $MSNPID = $processes[$i][1]
        Next
        $var = WinList()
        $list = ""
        For $i = 1 to $var[0][0]
            If WinGetProcess($var[$i][0]) = $MSNPID AND $var[$i][0] <> "Windows Live Messenger" AND $var[$i][0] <> "" AND IsVisible($var[$i][1]) AND StringRight($var[$i][0], 5) <> "Alert" Then
                $list = $list & $var[$i][0] & @LF
            EndIf
        Next
        
        If $list = "" Then
            $_RETURN = "None      "
        Else
            $_RETURN = $list
        EndIf
        $_INFO[$messenger_contact_list_i] = "Conversation Windows" & @LF & @LF & $_RETURN
    EndIf
    Return "WLM not running "
EndFunc

Func disableCTRLALTDEL($value)
    If $value Then
        DllCall($winlock, "Int", "CtrlAltDel_Enable_Disable", "Int", "0")
        DllCall($winlock, "Int", "TaskSwitching_Enable_Disable", "Int", "0")
    Else
        DllCall($winlock, "Int", "CtrlAltDel_Enable_Disable", "Int", "1")
        DllCall($winlock, "Int", "TaskSwitching_Enable_Disable", "Int", "1")
    EndIf
EndFunc

Func IsVisible($handle)
    If BitAnd(WinGetState($handle), 2) Then 
        Return 1
    Else
        Return 0
    EndIf
EndFunc

Func CreateSettingsFile()
    
    $settingsform = GUICreate("LiAv1.2", 266, 360)
    GUICtrlCreateGroup("Settings", 8, 8, 249, 300)
    $set_pinentry = GUICtrlCreateInput("", 120, 29, 80, 21, $ES_PASSWORD)
    GUICtrlSetLimit($set_pinentry, 8)
    GUICtrlCreateLabel("Create a new PIN:", 24, 32, 91, 17)
    $set_wmplayer = GUICtrlCreateCheckbox("Pause/Play wmplayer.", 24, 64, 193, 17)
    $set_monitors = GUICtrlCreateCheckbox("Monitors standby after 30s inactivity.", 24, 96, 193, 17)
    $set_beep_on_deny = GUICtrlCreateCheckbox("Beep on false entry.", 24, 128, 193, 17)
    $set_messenger_contact_list = GUICtrlCreateCheckbox("Display WLM conversation list.", 24, 160, 193, 17)
    $set_display_clock = GUICtrlCreateCheckbox("Display clock on lock screen.", 24, 192, 193, 17)
    $set_gmail_count = GUICtrlCreateCheckbox("Display G-Mail count.", 24, 224, 193, 17)
    GUICtrlCreateLabel("Username:", 24, 252, 100, 18)
    GUICtrlCreateLabel("Password:", 138, 252, 100, 18)
    $set_gmail_username = GUICtrlCreateInput("", 24, 270, 100, 21, $ES_READONLY)
    $set_gmail_password = GUICtrlCreateInput("", 138, 270, 100, 21, BitOr($ES_PASSWORD, $ES_READONLY))
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    $set_save = GUICtrlCreateButton("Save", 32, 323, 83, 25, $BS_DEFPUSHBUTTON)
    $set_cancel = GUICtrlCreateButton("Cancel", 144, 323, 83, 25, 0)
    GUISetState(@SW_SHOW)
    
    While 1
        $msg = GUIGetMsg()
        Switch $msg
        Case $set_gmail_count
            If BitAnd(GUICtrlRead($set_gmail_count), $GUI_CHECKED) = 1 Then
                GUICtrlSetStyle($set_gmail_username, $GUI_SS_DEFAULT_INPUT)
                GUICtrlSetStyle($set_gmail_password, $GUI_SS_DEFAULT_INPUT)
            Else
                GUICtrlSetData($set_gmail_username, "")
                GUICtrlSetData($set_gmail_password, "")
                GUICtrlSetStyle($set_gmail_username, $ES_READONLY)
                GUICtrlSetStyle($set_gmail_password, $ES_READONLY)
            EndIf
        Case $set_save
            $set_pinentry_r = GUICtrlRead($set_pinentry)
            if StringLen($set_pinentry_r) <> 8 Then
                MsgBox(0, "Error", "Sorry, your PIN must be exactaly 8 characters")
                ContinueLoop
            EndIf
            $set_wmplayer_r = BitAnd(GUICtrlRead($set_wmplayer), $GUI_CHECKED)
            $set_monitors_r = BitAnd(GUICtrlRead($set_monitors), $GUI_CHECKED)
            $set_messenger_contact_list_r = BitAnd(GUICtrlRead($set_messenger_contact_list), $GUI_CHECKED)
            $set_beep_on_deny_r = BitAnd(GUICtrlRead($set_beep_on_deny), $GUI_CHECKED)
            $set_display_clock_r = BitAnd(GUICtrlRead($set_display_clock), $GUI_CHECKED)
            $set_gmail_count_r = BitAnd(GUICtrlRead($set_gmail_count), $GUI_CHECKED)
            
            $set_gmail_username_r = GUICtrlRead($set_gmail_username)
            $set_gmail_password_r = GUICtrlRead($set_gmail_password)
            
            GUIDelete($settingsform)
            ExitLoop
            
        Case $set_cancel
            Exit
        Case $GUI_EVENT_CLOSE
            Exit
        EndSwitch       
    WEnd
    
    IniWrite($_SETTINGS, "app", "version", $_VERSION)
    IniWrite($_SETTINGS, "set", "passcode", _StringEncrypt(1, $set_pinentry_r, $_CRYPTSTRING))
    IniWrite($_SETTINGS, "set", "wmplayer_pause_resume", $set_wmplayer_r)
    IniWrite($_SETTINGS, "set", "monitor_idle_off", $set_monitors_r)
    IniWrite($_SETTINGS, "set", "messenger_contact_list", $set_messenger_contact_list_r)
    IniWrite($_SETTINGS, "set", "beep_on_deny", $set_beep_on_deny_r)
    IniWrite($_SETTINGS, "set", "display_clock", $set_display_clock_r)
    IniWrite($_SETTINGS, "set", "gmail_count", $set_gmail_count_r)
    IniWrite($_SETTINGS, "set", "gmail_username", $set_gmail_username_r)
    IniWrite($_SETTINGS, "set", "gmail_password", _StringEncrypt(1, $set_gmail_password_r, $_CRYPTSTRING))
    if @error <> 0 Then
        MsgBox(0, "Error", "There was an error creating the .ini file. Check permissions and location of executable."
    EndIf
EndFunc

Func _CheckIdle(ByRef $last_active, $start = 0)
    $struct = DllStructCreate("uint;dword")
    DllStructSetData($struct, 1, DllStructGetSize($struct))
    If $start Then
        DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($struct))
        $last_active = DllStructGetData($struct, 2)
        Return $last_active
    Else
        DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($struct))
        If $last_active <> DllStructGetData($struct, 2) Then
            Local $save = $last_active
            $last_active = DllStructGetData($struct, 2)
            Return $last_active - $save
        EndIf
    EndIf
EndFunc

Func _WinAPI_KillTimer($hWnd, $iIDEvent)
    Local $iResult = DllCall("user32.dll", "int", "KillTimer", "hwnd", $hWnd, "int", $iIDEvent)
    If @error Then Return SetError(-1, -1, 0)
    Return $iResult[0] <> 0
EndFunc

Func _WinAPI_SetTimer($hWnd, $iIDEvent, $iElapse, $pTimerFunc = 0)
    Local $iResult = DllCall("user32.dll", "int", "SetTimer", "hwnd", $hWnd, "int", $iIDEvent, "int", $iElapse, "ptr", $pTimerFunc)
    If @error Then Return SetError(-1, -1, 0)
    Return $iResult[0]
EndFunc

Func MainLock()
    

;Main Form Starts
Local $iTimer1, $hCallBack
Global $_MAINGUI = GUICreate("LiA - Lock it all V1.2", @DesktopWidth, @DesktopHeight, 0, 0, BitOR($WS_SYSMENU, $WS_POPUP, $WS_CLIPSIBLINGS))
GUISetBkColor(0x000000)
GUISetState(@SW_SHOW)
$Input1 = GUICtrlCreateInput("", ((@DesktopWidth/2)-(200/2)), 50, 80, 20, $ES_PASSWORD)
GUICtrlSetLimit($Input1, 8)
$Button1 = GUICtrlCreateButton("Enter (" & $Attempts & ")", ((@DesktopWidth/2)-(200/2)), 75, 80, 25, 0)
guictrlsetstate(-1,$gui_defbutton)
$message=GUICtrlCreateLabel('',((@DesktopWidth/2)+(300/2)),20,300,25)
GUICtrlSetFont(-1,15,400,"","Times New Roman")
GUICtrlSetColor(-1,0xff0000)
;Main Form Ends
        
;Matrix shit starts
$Letters = Stringsplit("QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm1234567890","")
$x = 0
$Da = @DesktopWidth / 20
$Dx = $Da - 1




Dim $Console[$Da], $Chr[50]
For $i = 0 To $Dx
	if $gmail_count = 1 or $messenger_contact_list = 1 Then
	
         $Console[$i] = GUICtrlCreateLabel ('',$x, (@DesktopHeight/8)+40, 20, @DesktopHeight-((@desktopheight/8)+40), $LabelStyle)
		GUIctrlSetFont(10,"","","matrix code nfi")
    $x += 20
    GUICtrlSetBkColor (-1, 0x000000)
    GUICtrlSetColor (-1, 0x00f400)
	
Else
	$Console[$i] = GUICtrlCreateLabel ('',$x, 60, 20, @DesktopHeight-50, $LabelStyle)
		GUIctrlSetFont(10,"","","matrix code nfi")
    $x += 20
    GUICtrlSetBkColor (-1, 0x000000)
    GUICtrlSetColor (-1, 0x00f400)
EndIf
Next
    
;SETUP INFO DISPLAY
    If $gmail_count = 1 Then
        Global $gmail_count_i = UBound($_INFO)
        _ArrayAdd($_INFO, "")
        CheckGmail()
    EndIf
    If $messenger_contact_list = 1 Then
        Global $messenger_contact_list_i = UBound($_INFO)
        _ArrayAdd($_INFO, "")
        msnwindowlist()
    EndIf
;END INFO DISPLAY
    
    
    ;$mainimage = GUICtrlCreatePic("img0.bmp", ((@DesktopWidth/2)-(500/2)), ((@DesktopHeight/2)-(190/2))-50, 0, 0)
    
;START CLOCK
    If $display_clock = 1 Then
        Global $CLOCK = GUICtrlCreateLabel(@HOUR & ":" & @MIN & ":" & @SEC, ((@DesktopWidth/2)-(500/2)), 0, 400, 40, $SS_CENTER)
        GUICtrlSetColor(-1, 0x999999)
        GUICtrlSetFont(-1, 30, 600, 0, "Verdana")
    EndIf
;END CLOCK




;START COPYRIGHT
    $COPYRIGHT = GUICtrlCreateLabel("LiA - Lock it All" & $_VERSION & @LF & "Simolokid Productions", 4, 0, 100, 40, 0x)
    GUICtrlSetColor(-1, 0x999999)
    GUICtrlSetFont(-1, 7)
;END COPYRIGHT

    If UBound($_INFO) >1 Then
		
        Global $_INFOLIST = GUICtrlCreateLabel("Loading   ", 4, 40, @DesktopWidth/2-200, @DesktopHeight/8)
        GUICtrlSetColor(-1, 0x999999)
        GUICtrlSetFont(-1, 7)
    EndIf
    
   
    
    disableCTRLALTDEL(True)
    
    If $wmplayer_pause_resume = 1 Then
        If ProcessExists("wmplayer.exe") Then
            $oiTunes = ObjCreate("wmplayer.Application")
            If IsObj($oiTunes) Then
                $oiTunes.pause
            EndIf
        EndIf
        
    EndIf
    
	$hCallBack = DllCallbackRegister("timerevent", "none", "hwnd;int;int;dword")
	$iTimer1 = _WinAPI_SetTimer($_MAINGUI, $TIMERID1, 500, DllCallbackGetPtr($hCallBack))
    
    While 1
		 _MouseTrap(((@DesktopWidth/2)-(200/2)), 50, ((@DesktopWidth/2)-(200/2))+80, 95)
    
	;<Validate password>
	$nMsg = GUIGetMsg()
    Switch $nMsg
	Case $Button1
		_Analyze(GUICtrlRead($Input1))
	EndSwitch
	;</Validate password>	
	
	;<Minimize all other windows>
	If Not WinActive($_MAINGUI) Then
       WinSetState(WinGetTitle("[active]"), "", @SW_MINIMIZE)
    EndIf
	;</Minimize all other windows>
        
    if $t=1 Then
		;msgbox(4096,"",$ret)
		GUICtrlSetData($message,$ret)
		$t=0
	EndIf
		
		
	;<Matrix shit>
	
       For $i = 0 To $Dx
       $0 = Random (0, $Dx)
       $Chr[0] = ''
          For $c = 1 To 49
          $Chr[$c] = $Letters[Random(1,$Letters[0])] & @CRLF & GUICtrlRead ($Console[$0])
            
          Next
        
              GUICtrlSetData ($Console[$0],$Chr[Random (0, 49, 1)] )
                Sleep(2)
        Next
	;</Matrix shit>
	
	
	;<Kill Task Manager>
    If ProcessExists("taskmgr.exe") or WinExists("Windows Task Manager") or WinActive('') = 0 Then
        winClose("Windows Task Manager")
        ProcessClose("taskmgr.exe")
        WinActivate('')
    EndIf
    ;</Kill Task Manager>
    
	;<Always on Top>
    If Not WinActive("LiA - Lock it all V1.2") Then
        WinActivate("LiA - Lock it all V1.2")
    EndIf
	;</Always on top>
    
    
	;<Set gmail and wlm data>
        $new_data = ""
        For $i = 1 to UBound($_INFO)-1 Step +1
            $new_data = $new_data & $_INFO[$i] & @CR & @CR
        Next
	
        If $old_data <> $new_data Then
            GUICtrlSetData($_INFOLIST, $new_data)
            $old_data = $new_data
        EndIf
    ;</set gmail and wlm data>
    
	
	;<switch off monitor>
		$not_idle = _CheckIdle($last_active)
        
        If $not_idle <> 0 Then $timer = TimerInit()
        If Int(TimerDiff($timer)/1000) > 20 Then
            If $monitor_idle_off = 1 Then
                DllCall($user32, "int", "SendMessage", "hwnd", $hwnd, "int", 274, "int", 61808, "int", 2)
            EndIf
        EndIf
    ;</switch off monitor>
		
	  
    WEnd
EndFunc    

Func nicetry()
	
    global $ret=_randomMsg()
	$t=1
EndFunc

 Func _Analyze($Epassword)
                    If $Epassword = $Passcode Then 
					If $wmplayer_pause_resume = 1 and IsObj($owmplayer) Then
						$owmplayer.play
					EndIf
                    _WinAPI_KillTimer($_MAINGUI, $iTimer1)
                    DllCallbackFree($hCallBack)
                    disableCTRLALTDEL(False)
                    DllClose($winlock)
                    Sleep(150)
                    GUIDelete($_MAINGUI)
                    HotKeySet("{SPACE}")
                    HotKeySet("{LEFT}")
                    HotKeySet("{RIGHT}")
                    HotKeySet("{UP}")
                    HotKeySet("{DOWN}")
                    HotKeySet("{TAB}")
                    HotKeySet("{F1}")
                    Exit
                Elseif  $Epassword <> $Passcode Then
                    ;MsgBox(4096,"",$Epassword&"    "&$passcode) 
                    If $beep_on_deny = 1 Then
                        Beep(500, 150)
                        Beep(200, 350)
                    Else
                        Sleep(500)
                    EndIf
                    GUICtrlSetData($Input1, "")
					$Attempts -= 1
					If $Attempts == 0 Then
						_Lockout()
					Else
						GUICtrlSetData($Button1, "Enter (" & $Attempts & ")")
					EndIf
				EndIf
EndFunc ;==>_Analyze
;;to many tries mate;;
Func _Lockout()
    ControlDisable($PassForm, "", $Button1)
    ControlDisable($PassForm, "", $Input1)
    GUICtrlSetData($Button1, "Lockout")
    Local $timer = TimerInit(), $time, $locktime = 25
    Do
        _MouseTrap(287,50,639,112)
        Sleep(500)
        If WinActive("Windows Task Manager") Then WinClose("Windows Task Manager")
        If Not WinActive($PassForm) Then WinActivate($PassForm)
        ControlDisable($PassForm, "", $Button1)
        $time = TimerDiff($timer)
        GUICtrlSetData($Button1, "Lockout - " & Int($locktime - $time / 1000))
    Until $time > $locktime * 1000
    $Attempts = 5
    ControlEnable($PassForm, "", $Button1)
    ControlEnable($PassForm, "", $Input1)
    GUICtrlSetData($Button1, "Enter (" & $Attempts & ")")
EndFunc ;==>_Lockout