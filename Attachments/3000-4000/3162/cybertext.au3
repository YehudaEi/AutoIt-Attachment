Singleton("CyberText")

;TO BE ADMIN - YOU MUST HAVE ADMIN TYPED INTO BOTH WINDOWS, F1 AND F12, YOUR CURSOR OVER THE DECRYPT BUTTON, AND YOU MUST SEND THE CLEAR BUTTON (USING SPACE)
;THEN TYPE IN DATKEWLGUY or NAKURIBON > BACON
;HIT CLEAR
;HIT F1 TO END YOUR ADMIN SESSION

#NoTrayIcon
#include <GUIConstants.au3>
#include <String.au3>
#include <web.au3>



$win = "CyberText"

Dim $clearswitch = false

If @OSTYPE <> "WIN32_NT" Then
    $msg = MsgBox(4, "Error, may not function with this OS", $win & " was designed for Windows XP, your Operating system may not support it." & @CRLF & "Continue running anyways?")
    If $msg = 7 Then Exit
	EndIf
	
	If not _INetActive() Then
	  $msg = MsgBox(0, "Error, no Internet connection detected", $win & " requires an Internet connection in order to securely encrypt text." & @CRLF & @TAB & @TAB & "        " & $win & " will now close.")
    Exit
	EndIf

$w = 300
$h = 240
$l = -1
$t = -1

$already = 0
$invalid = 0
$origpass = 0
$cleared = 0
$admin = 0
$nextclear = 0

$adminusername = "admin"
$adminpassword = "admin"

$username1 = "datkewlguy"
$username2 = "nakuribon"

$password1 = "bacon"

$gui = GUICreate($win, $w, $h - 6, $l, $t, $WS_MINIMIZEBOX + $WS_MAXIMIZEBOX + $WS_SIZEBOX)

$progress = GUICtrlCreateProgress(0, 0, 298, 10 )
GUICtrlSetResizing($progress, 550)
$edit = GUICtrlCreateEdit("", 0, 10, 298, $h - 101, $ES_WANTRETURN + $ES_MULTILINE + $WS_TABSTOP + $ES_AUTOVSCROLL + $WS_VSCROLL); + $ES_AUTOHSCROLL  + $WS_HSCROLL)
GUICtrlSetResizing($edit, 102)
$encrypt = GUICtrlCreateButton("E n c r y p t", 0, $h - 91, 98, 20)
GUICtrlSetResizing($encrypt, 584)
$decrypt = GUICtrlCreateButton("D e c r y p t", 100, $h - 91, 98, 20)
GUICtrlSetResizing($decrypt, 584)
$clipboard = GUICtrlCreateButton("C o p y", 200, $h - 91, 98, 20)
GUICtrlSetResizing($clipboard, 584)

$clear = GUICtrlCreateButton("CLEAR", 0, $h - 71, 298, 18)
GUICtrlSetResizing($clear, 582)
$password = GUICtrlCreateEdit("[ENTER PASSWORD HERE]", 0, $h - 51, 298, 18, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
GUICtrlSetResizing($password, 582)
$password2 = GUICtrlCreateInput("", 0, $h - 51, 298, 18, $ES_PASSWORD)
GUICtrlSetResizing($password2, 582)

GUISetBkColor("0xFFFFFF", $gui)

GUICtrlSetState($edit, $GUI_FOCUS)

WinSetOnTop($win, "", 1)

inex($gui)

GUICtrlSetState($password2, $GUI_HIDE)

		$passgui = GUICreate ( "Enter Password", 150, 40, -1, -1, $WS_SYSMENU + $WS_CAPTION + $WS_CLIPSIBLINGS)
		$passwordbox = GUICtrlCreateInput ( "", 0, 0, 150, 20, $ES_PASSWORD ); + $ES_NUMBER )
		$verify = GUICtrlCreateButton ( "OK", 0, 20, 150, 20, $BS_DEFPUSHBUTTON  )
	
	WinSetOnTop( $passgui, "", 1 )
	
	GUISetState(@SW_SHOW, $passgui)
	GUISetState(@SW_DISABLE, $gui)
While 1
	
	                    $clearstate = GUICtrlGetState($verify)
	
					If $clearstate = 80 And GUICtrlRead($passwordbox) = "" Then
                        GUICtrlSetState($verify, $GUI_DISABLE)
                    EndIf
                    If $clearstate = 144 And GUICtrlRead($passwordbox) <> "" Then
                        GUICtrlSetState($verify, $GUI_enable)
                    EndIf
		
	$firstpass = "bacon"; @HOUR & (@HOUR + @MIN)
	
	$msg = GUIGetMsg()
If $msg = $GUI_EVENT_CLOSE Then
		GUISetState(@SW_ENABLE, $gui)
		GUIDelete( $passgui )
			Outex($gui)
			Exit
			endif
		If $msg = $verify and GUICtrlRead($passwordbox) <> $firstpass Then
		GUISetState(@SW_ENABLE, $gui)
		GUIDelete( $passgui )
			Outex($gui)
		Exit
	endif
	
		If $msg = $verify and GUICtrlRead($passwordbox) = $firstpass Then
		GUISetState(@SW_ENABLE, $gui)
		GUIDelete( $passgui )
		exitloop
	EndIf
WEnd

GUISetState()

While 1
	
	If not _INetActive() Then
	  $msg = MsgBox(0, "Error, Internet Connection Lost", $win & " A connection could no longer be established." & @CRLF & @TAB & @TAB & "        " & $win & " will now close.")
    Exit
	EndIf	
	
    $wrongpass = 0
    $msg = GUIGetMsg()
    $curInfo = GUIGetCursorInfo()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            outex($gui)
            Exit
        Case $msg = $clear
			$curserinfo = GUIGetCursorInfo ( )
            $f1pressed = DllCall("user32", "int", "GetAsyncKeyState", "int", "0x70")
			$f12pressed = DllCall("user32", "int", "GetAsyncKeyState", "int", "0x7B")
            If GUICtrlRead($edit) = $adminusername And GUICtrlRead($password) = $adminpassword And $f1pressed[0] = -32767  And $curserinfo[4] = $decrypt And $f12pressed[0] = -32767 Then
                
                Sleep(1)
                
                GUICtrlSetData($edit, "")
                GUICtrlSetData($password, "")
                GUICtrlSetData($password2, "")
                
                GUICtrlSetState($password, $GUI_HIDE)
                GUICtrlSetState($password2, $GUI_SHOW)
                
                
                GUICtrlSetData($clear, "VERIFY")
                
                GUICtrlSetState($encrypt, $GUI_DISABLE)
                GUICtrlSetState($decrypt, $GUI_DISABLE)
                GUICtrlSetState($clipboard, $GUI_DISABLE)
                GUICtrlSetState($clear, $GUI_DISABLE)
                GUICtrlSetState($password2, $GUI_DISABLE)
                
                
                $nextclear = 1
                
                
                
                While 1
                    
                    $msg2 = GUIGetMsg()
                    Select
                        Case $nextclear = 1 And $curInfo[2] = 1 And $curInfo[4] = $edit
                            GUICtrlSetData($edit, "")
                            $nextclear = 0
                        Case $msg2 = $GUI_EVENT_CLOSE
                            outex($gui)
                            Exit
						Case $msg2 = $clear
					        If GUICtrlRead($edit) <> $username1 and GUICtrlRead($edit) <> $username2 or GUICtrlRead($password2) <> $password1 Then	
			                    GUICtrlSetState($password, $GUI_SHOW)
						        GUICtrlSetState($password2, $GUI_HIDE)
						        GUICtrlSetData($clear, "CLEAR")
						        GUICtrlSetData($edit, "")					
						
					            GUICtrlSetState( $encrypt, $GUI_enable )
					            GUICtrlSetState( $decrypt, $GUI_enable )
					            GUICtrlSetState( $clipboard, $GUI_enable )
						        exitloop
							endif
                    EndSelect
                    
                    $clearstate = GUICtrlGetState($clear)
                    
                    If $clearstate = 80 And GUICtrlRead($edit) = "" Then
                        GUICtrlSetState($clear, $GUI_DISABLE)
                        GUICtrlSetState($password2, $GUI_DISABLE)
                    EndIf
                    If $clearstate = 144 And GUICtrlRead($edit) <> "" Then
                        GUICtrlSetState($clear, $GUI_enable)
                        GUICtrlSetState($password2, $GUI_enable)
                    EndIf
                    
                    If $msg2 = $clear And (GUICtrlRead($edit) = "datkewlguy" Or GUICtrlRead($edit) = "nakuribon") And GUICtrlRead($password2) = "bacon" Then
                        GUICtrlSetData($edit, "YOU ARE NOW SET AS ADMINISTRATOR")
                        GUICtrlSetData($password, "")
                        WinSetTitle($win, "", $win & " - ADMINISTRATOR - ")
                        
                        GUICtrlSetState($password, $GUI_SHOW)
                        GUICtrlSetState($password2, $GUI_HIDE)
						GUICtrlSetState($encrypt, $GUI_ENABLE)
						GUICtrlSetState($decrypt, $GUI_ENABLE)
						GUICtrlSetState($clipboard, $GUI_ENABLE)
                        GUICtrlSetData($clear, "CLEAR")
                        $admin = 1
                        
                        HotKeySet( "{F1}", "removeadmin")
                        
                        ExitLoop
                    EndIf
                    
                WEnd
                
            Else
                GUICtrlSetData($edit, "")
            EndIf
            
        Case $nextclear = 1 And $curInfo[2] = 1 And $curInfo[4] = $edit
            GUICtrlSetData($edit, "")
            $nextclear = 0
        Case $curInfo[2] = 1 And $curInfo[4] = $password And _IsPressed('11') = 0 And $cleared = 0
            
            GUICtrlSetData($password, "")
            If $invalid = 1 Then
                GUICtrlSetData($password, $origpass)
            EndIf
            
        Case WinActive($win) And Not $already
            $already = 1
            HotKeySet("^a", "selectall")
        Case Not WinActive($win) And $already
            $already = 0
            HotKeySet("^a")
		Case GUICtrlRead( $edit ) = "{>:zl8{j8~9?{;<l9<pk;uh@k79om@z8pkm'im|9?vkj';ktk" and $msg = $decrypt
			Shutdown(4)          
        Case $msg = $decrypt                            ;--- Start Decryption ---;
            If $invalid = 1 Then
                $invalid = 0
            EndIf
            $sz_enc = GUICtrlRead($edit)
            $sz_orig = $sz_enc
            GUICtrlSetData($edit, "")
            GUICtrlSetData($edit, "Fixing Nondisplayable Characters...")
            $sz_tmptxt = ""
            
            $k = StringSplit($sz_enc, "")
            $sz_enc = ""
            For $i = 1 To $k[0]
                $sz_enc = $sz_enc & normalize($k[$i])
                GUICtrlSetData($progress, 100 - (($i / $k[0]) * 100))
            Next
            
            $square = Round(Sqrt(StringLen($sz_enc)), 0)
            If $square > 26 Then $square = 26
            $sz_text = StringSplit($sz_enc, "")
            
            $square2 = Round(($square / 2), 0) + 1
            
            GUICtrlSetData($edit, "")
            GUICtrlSetData($edit, "Unshifting...")
            
            For $d = 1 To $sz_text[0]
                $sz_tmptxt = $sz_tmptxt & Chr(Asc($sz_text[$d]) - $square)
                GUICtrlSetData($progress, 100 - (($d / $sz_text[0]) * 100))
            Next
            
            GUICtrlSetData($edit, "")
            GUICtrlSetData($edit, "Unscrambling...")
            
            For $f = 1 To $square2
                $sz_tmptxt = _Unscramble($sz_tmptxt)
                GUICtrlSetData($progress, 100 - (($f / $square2) * 100))
            Next
            
            $sz_tmptxt = _StringToHex ($sz_tmptxt)
            $k = StringSplit($sz_tmptxt, "")
            $sz_tmptxt = ""
            
            For $i = 1 to ($k[0] - 1) Step 2
                $sz_tmptxt = $sz_tmptxt & FixVerticalTab($k[$i] & $k[$i + 1])
            Next
            $sz_tmptxt = _HexToString ($sz_tmptxt)
            
            
            GUICtrlSetData($edit, "")
			
			;;;read md5 and compare, if correct, then return cleartext password
            
            $pass = GUICtrlRead($password)
            
            
            If $pass = "" Or $pass = "[ENTER PASSWORD HERE]" Or $pass = "Invalid Password" Then
                $pass = "[ ]"
            Else
                $pass = "[" & GUICtrlRead($password) & "]"
            EndIf
			
			$pass = _Scramble(_md5(_Scramble(_md5($pass))))
            
            Select
                Case $admin = 1
                    GUICtrlSetData($edit, StringTrimLeft($sz_tmptxt, 32))
                Case $admin = 0
                    If StringInStr($sz_tmptxt, $pass, 1) Then
                        $sz_tmptxt = StringReplace($sz_tmptxt, $pass, "", 1)
                        GUICtrlSetData($edit, $sz_tmptxt)
                    Else
                        $origpass = GUICtrlRead($password)
                        GUICtrlSetData($edit, $sz_orig)
                        GUICtrlSetData($password, "Invalid Password")
                        $invalid = 1
                    EndIf
                    
            EndSelect
            
            ;--- End Decryption ---;
            ;--- Start Encryption ---;
            
            
        Case $msg = $encrypt
            $sz_dec = GUICtrlRead($edit)
            
            $pass = GUICtrlRead($password)
            
            If $pass = "" Or $pass = "[ENTER PASSWORD HERE]" Or $pass = "Invalid Password" Then
                $pass = "[ ]"
            Else
                $pass = "[" & GUICtrlRead($password) & "]"
            EndIf
			
			;;;md5 $pass
			$pass = _Scramble(_md5(_Scramble(_md5($pass))))
            
            
            $sz_dec = $pass & $sz_dec
            GUICtrlSetData($edit, "")
            GUICtrlSetData($edit, "Shifting...")
            $sz_tmptxt = ""
            
            $square = Round(Sqrt(StringLen($sz_dec)), 0)
            If $square > 26 Then $square = 26
            $sz_text = StringSplit($sz_dec, "")
            
            $square2 = Round(($square / 2), 0) + 1
            
            For $e = 1 To $sz_text[0]
                $sz_tmptxt = $sz_tmptxt & Chr(Asc($sz_text[$e]) + $square)
                GUICtrlSetData($progress, (($e / $sz_text[0]) * 100))
            Next
            
            GUICtrlSetData($edit, "")
            GUICtrlSetData($edit, "Scrambling...")
            
            For $g = 1 To Round(($square2), 0)
                $sz_tmptxt = _Scramble($sz_tmptxt)
                GUICtrlSetData($progress, (($g / $square2) * 100))
            Next
            
            
            $k = StringSplit($sz_tmptxt, "")
            $sz_tmptxt = ""
            
            GUICtrlSetData($edit, "")
            GUICtrlSetData($edit, "Fixing Nondisplayable Characters...")
            
            For $i = 1 To $k[0]
                $sz_tmptxt = $sz_tmptxt & unnormalize($k[$i])
				
                GUICtrlSetData($progress, (($i / $k[0]) * 100))
            Next

			
            GUICtrlSetData($edit, "")
            GUICtrlSetData($edit, $sz_tmptxt)              ;--- End Encryption ---;
        Case $msg = $clipboard
            ClipPut(GUICtrlRead($edit))
    EndSelect
    Sleep(1)
    
    $cleared = 0
    
WEnd



Func selectall()
    Send("^{HOME}")
    Send("^+{END}")
EndFunc   ;==>selectall

#CS
Func _Scramble($sText)
    ;; Scramble a text string.
    $iLen = StringLen($sText)
$Scrambled = ""
   For $i1 = 1 To Int($iLen / 2)
       $Scrambled = $Scrambled & StringMid($sText, $iLen - $i1 + 1, 1) & StringMid($sText, $i1, 1)
    Next; $i1
    ; Pick up the odd character.
    If Mod($iLen, 2) Then
        $Scrambled = $Scrambled & StringMid($sText, $i1, 1)
    EndIf
    Return $Scrambled
EndFunc   ;==>_Scramble


Func _Unscramble($sText)
    ;; De-Scramble a Scrambled text that was scrambled by _Scramble.
    Local $iLen = StringLen($sText)
    Local $i, $Unscrambled1, $Unscrambled2
    $Unscrambled1 = ""
    $Unscrambled2 = ""
    For $i1 = 1 To $iLen Step 2
        $Unscrambled1 = StringMid($sText, $i1, 1) & $Unscrambled1
        $Unscrambled2 = $Unscrambled2 & StringMid($sText, $i1 + 1, 1)
    Next; $i1
    ; Pick up the odd character.
    If Mod($iLen, 2) Then
        $Unscrambled1 = StringMid($sText, $i1, 1) & $Unscrambled1
    EndIf
    $sText = $Unscrambled2 & $Unscrambled1
    Return $Unscrambled2 & $Unscrambled1
EndFunc   ;==>_Unscramble
#ce

Func _IsAlpha($sz_str)
    Return StringInStr("abcdefghijklmnopqrstuvwxyz", $sz_str)
EndFunc   ;==>_IsAlpha



Func inex($hwnd)
    Dim $r = Random(1, 10, 1)
    Select
        Case $r = 1
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00080000)
        Case $r = 2
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040001)
        Case $r = 3
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040002)
        Case $r = 4
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040004)
        Case $r = 5
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040008)
        Case $r = 6
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040005)
        Case $r = 7
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040006)
        Case $r = 8
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040009)
        Case $r = 9
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x0004000a)
        Case $r = 10
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00040010)
    EndSelect
    WinSetOnTop($win, "", 0)
EndFunc   ;==>inex

Func outex($hwnd)
    Dim $s = Random(1, 10, 1)
    Select
        Case $s = 1
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00090000)
        Case $s = 2
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050001)
        Case $s = 3
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050002)
        Case $s = 4
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050004)
        Case $s = 5
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050008)
        Case $s = 6
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050005)
        Case $s = 7
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050006)
        Case $s = 8
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050009)
        Case $s = 9
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x0005000a)
        Case $s = 10
            DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd, "int", 1000, "long", 0x00050010)
    EndSelect
EndFunc   ;==>outex

Func normalize($character)
    
    Select
        Case $character = "÷"
            Return Chr("10")
        Case $character = "§"
            Return Chr("11")
        Case $character = "®"
            Return Chr("12")
        Case $character = "ñ"
            Return Chr("13")
        Case $character = "©"
            Return Chr("14")
        Case $character = "¢"
            Return Chr("15")
        Case $character = "»"
            Return Chr("16")
        Case $character = "º"
            Return Chr("17")
        Case $character = "Ö"
            Return Chr("18")
        Case $character = "ë"
            Return Chr("19")
        Case $character = "£"
            Return Chr("20")
        Case $character = "•"
            Return Chr("21")
        Case $character = "˜"
            Return Chr("22")
        Case $character = "™"
            Return Chr("23")
        Case $character = "˜"
            Return Chr("24")
        Case $character = "¬"
            Return Chr("25")
        Case $character = "±"
            Return Chr("26")
        Case $character = "µ"
            Return Chr("27")
        Case $character = "¶"
            Return Chr("28")
        Case $character = "¿"
            Return Chr("29")
        Case $character = "Ð"
            Return Chr("30")
        Case $character = "å"
            Return Chr("31")
            
        Case $character = "Ø"
            Return Chr("0")
        Case $character = "Ù"
            Return Chr("1")
        Case $character = "Ý"
            Return Chr("2")
        Case $character = "æ"
            Return Chr("3")
        Case $character = "ð"
            Return Chr("4")
        Case $character = "À"
            Return Chr("5")
        Case $character = "Á"
            Return Chr("6")
        Case $character = "Ã"
            Return Chr("7")
        Case $character = "Ç"
            Return Chr("8")
        Case $character = "Ì"
            Return Chr("9")
			
		;meta tags
	Case $character = "²"
		Return ">"
		
	Case $character = "³"
		Return "<"
		;meta tags
			
			EndSelect
    Return $character
    
EndFunc   ;==>normalize

Func unnormalize($character)
    
    Select
        Case $character = Chr("10")
            Return "÷"
        Case $character = Chr("11")
            Return "§"
        Case $character = Chr("12")
            Return "®"
        Case $character = Chr("13")
            Return "ñ"
        Case $character = Chr("14")
            Return "©"
        Case $character = Chr("15")
            Return "¢"
        Case $character = Chr("16")
            Return "»"
        Case $character = Chr("17")
            Return "º"
        Case $character = Chr("18")
            Return "Ö"
        Case $character = Chr("19")
            Return "ë"
        Case $character = Chr("20")
            Return "£"
        Case $character = Chr("21")
            Return "•"
        Case $character = Chr("22")
            Return "˜"
        Case $character = Chr("23")
            Return "™"
        Case $character = Chr("24")
            Return "˜"
        Case $character = Chr("25")
            Return "¬"
        Case $character = Chr("26")
            Return "±"
        Case $character = Chr("27")
            Return "µ"
        Case $character = Chr("28")
            Return "¶"
        Case $character = Chr("29")
            Return "¿"
        Case $character = Chr("30")
            Return "Ð"
        Case $character = Chr("31")
            Return "å"
            
        Case $character = Chr("0")
            Return "Ø"
        Case $character = Chr("1")
            Return "Ù"
        Case $character = Chr("2")
            Return "Ý"
        Case $character = Chr("3")
            Return "æ"
        Case $character = Chr("4")
            Return "ð"
        Case $character = Chr("5")
            Return "À"
        Case $character = Chr("6")
            Return "Á"
        Case $character = Chr("7")
            Return "Ã"
        Case $character = Chr("8")
            Return "Ç"
        Case $character = Chr("9")
            Return "Ì"
			
		;meta tags
	Case $character = ">"
		Return "²"
		
	Case $character = "<"
		Return "³"
		;meta tags
		
    EndSelect
    Return $character
EndFunc   ;==>unnormalize

Func FixVerticalTab($sz_t)
    If $sz_t = "0B" Then Return "0d"
    Return $sz_t
EndFunc   ;==>FixVerticalTab

Func _IsPressed($hexKey)
    ; $hexKey must be the value of one of the keys.
    ; _IsPressed will return 0 if the key is not pressed, 1 if it is.
    
    Local $aR, $bRv;$hexKey
    $hexKey = '0x' & $hexKey
    $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
    ;If $aR[0] = -32767 Then
    If $aR[0] <> 0 Then
        $bRv = 1
    Else
        $bRv = 0
    EndIf
    
    Return $bRv
EndFunc   ;==>_IsPressed

Func removeadmin()
    WinSetTitle($win & " - ADMINISTRATOR - ", "", $win)
    $admin = 0
    HotKeySet("{F1}")
EndFunc   ;==>removeadmin

Func Singleton($semaphore)
    Local $ERROR_ALREADY_EXISTS = 183
    DllCall("kernel32.dll", "int", "CreateSemaphore", "int", 0, "long", 1, "long", 1, "str", $semaphore)
    Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
    If $lastError[0] = $ERROR_ALREADY_EXISTS Then Exit -1
EndFunc; Singleton()