#include<ComboConstants.au3>
#include<ButtonConstants.au3>
#include<EditConstants.au3>
#include<GUIConstantsEx.au3>
#include<WindowsConstants.au3>
#include<Array.au3>


Global $array = _LogInBox('Einstellungen vornehmen', 0, 'Deutsch')
Func _LogInBox($title, $minLen = 0, $StartLang = 'German', $bPassVisible = False, $x = -1, $y = -1)
    Local $hGui, $hUserLabel, $hUser, $hPass, $hCheck, $hLanguage, $hCancel, $hOk, $hURL
    Local $opt, $style, $tmp
    Local $err = 0, $font = 'Arial', $aOut[3]
    Local $Userlabel, $PassLabel, $PassVisible, $Language, $Check, $Cancel, $Ok, $URLlabel
    Local $bgColorInner = 0xdddddd, $bgColorOuter = 0xaaaaaa
    $opt = Opt('GUIOnEventMode', 0)
    Switch $StartLang
        Case 'Deutsch', 'German'
            $Language = 'Deutsch|Englisch'
            $Userlabel = 'Benutzername:' & @CRLF & '(erforderlich)'
            $PassLabel = 'Passwort:'
			$URLlabel = 'URL:'
            If $minLen > 0 Then $PassLabel &= @CRLF & '(min. ' & $minLen & ' Zeichen)'
            $Check = '&Passwort sichtbar'
            $Ok = 'Festlegen...'
            $Cancel = 'Abbrechen'
        Case 'Englisch', 'English'
            $Language = 'English|German'
            $Userlabel = 'Username:' & @CRLF & '(needed)'
            $PassLabel = 'Password:'
			$URLlabel = 'URL:'
            If $minLen > 0 Then $PassLabel &= @CRLF & '(min. ' & $minLen & ' Chars)'
            $Check = '&Password visible'
            $Ok = 'Set...'
            $Cancel = 'Cancel'
        Case Else
            Return SetError(1, 0, $aOut)
    EndSwitch
   
   $hGui = GUICreate($title, 343, 250, $x, $y, BitOR($WS_SYSMENU, $DS_SETFOREGROUND))
    GUISetIcon(@SystemDir & "\shell32.dll", -212)
    GUISetBkColor($bgColorOuter)
    GUICtrlCreateLabel('', 5, 5, 325, 212, -1, $WS_EX_CLIENTEDGE)
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetBkColor(-1, $bgColorInner)
    
	
	$hUserLabel = GUICtrlCreateLabel($Userlabel, 12, 17, 90, 35)
    GUICtrlSetFont(-1, 9, 400, 0, $font)
    GUICtrlSetBkColor(-1, $bgColorInner)
    $hUser = GUICtrlCreateInput('', 115, 20, 210, 25, $WS_TABSTOP)
    GUICtrlSetFont(-1, 10, 400, 0, $font)
    
	
	$hPassLabel = GUICtrlCreateLabel($PassLabel, 12, 63 + ($minLen = 0) * 6, 100, 35)
    GUICtrlSetFont(-1, 9, 400, 0, $font)
    GUICtrlSetBkColor(-1, $bgColorInner)
    If $bPassVisible Then
        $style = BitOR($ES_AUTOHSCROLL, $WS_TABSTOP)
    Else
        $style = BitOR($ES_PASSWORD, $ES_AUTOHSCROLL, $WS_TABSTOP)
    EndIf
    $hPass = GUICtrlCreateInput('', 115, 65, 210, 25, $style)
    GUICtrlSetFont(-1, 10, 400, 0, $font)
	
$hURLlabel = GUICtrlCreateLabel($URLlabel, 12, 128, 90, 35)
GUICtrlSetFont(-1, 9, 400, 0, $font)
GUICtrlSetBkColor(-1, $bgColorInner)	
$hURL = GUICtrlCreateInput('', 115, 130, 210, 25, $WS_TABSTOP )
    GUICtrlSetFont(-1, 10, 400, 0, $font)

$hCheck = GUICtrlCreateCheckbox($Check, 120, 92, 200, 25)
    GUICtrlSetFont(-1, 9, 400, 0, $font)
    GUICtrlSetBkColor(-1, $bgColorInner)
    If $bPassVisible Then GUICtrlSetState(-1, $GUI_CHECKED)

$hLanguage = GUICtrlCreateCombo('', 10, 180, 100, 25, $CBS_DROPDOWNLIST)
    GUICtrlSetData(-1, $Language, StringLeft($Language, StringInStr($Language, '|')-1))
    GUICtrlSetFont(-1, 10, 400, 0, $font)

$hCancel = GUICtrlCreateButton($Cancel, 245, 180, 80, 25)
    GUICtrlSetFont(-1, 9, 400, 0, $font)

$hOk = GUICtrlCreateButton($Ok, 160, 180, 80, 25, $BS_DEFPUSHBUTTON)
    GUICtrlSetFont(-1, 9, 400, 0, $font)
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUISetState()
    WinSetOnTop($title, '', 1)

While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $hCancel
                $err = 1
                ExitLoop
            Case $hCheck
                If BitAND(GUICtrlRead($hCheck), $GUI_CHECKED) Then
                    $tmp = GUICtrlRead($hPass)
                    GUICtrlDelete($hPass)
                    $hPass = GUICtrlCreateInput($tmp, 115, 65, 210, 25)
                    GUICtrlSetFont(-1, 10, 400, 0, $font)
                    GUICtrlSetState(-1, $GUI_FOCUS)
                Else
                    $tmp = GUICtrlRead($hPass)
                    GUICtrlDelete($hPass)
                    $hPass = GUICtrlCreateInput($tmp, 115, 65, 210, 25, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
                    GUICtrlSetFont(-1, 10, 400, 0, $font)
                    GUICtrlSetState(-1, $GUI_FOCUS)
                EndIf
            Case $hLanguage
                Switch GUICtrlRead($hLanguage)
                    Case 'Deutsch', 'German'
                        $Language = 'Deutsch|Englisch'
                        $Userlabel = 'Benutzername:' & @CRLF & '(erforderlich)'
				        $PassLabel = 'Passwort:'
						$URLlabel = 'URL:'
                        If $minLen > 0 Then $PassLabel &= @CRLF & '(min. ' & $minLen & ' Zeichen)'
                        $Check = '&Passwort sichtbar'
                        $Ok = 'Festlegen...'
                        $Cancel = 'Abbrechen'
                    Case 'Englisch', 'English'
                        $Language = 'English|German'
                        $Userlabel = 'Username:' & @CRLF & '(needed)'
                        $PassLabel = 'Password:'
						$URLlabel = 'URL:'
                        If $minLen > 0 Then $PassLabel &= @CRLF & '(min. ' & $minLen & ' Chars)'
                        $Check = '&Password visible'
                        $ok = 'Set...'
                        $Cancel = 'Cancel'
                EndSwitch

GUICtrlSetData($hLanguage, '')
GUICtrlSetData($hLanguage, $Language, StringLeft($Language, StringInStr($Language, '|')-1))
GUICtrlSetData($hUserLabel, $Userlabel)
GUICtrlSetData($hURLlabel, $URLlabel) 
GUICtrlSetData($hPassLabel, $PassLabel) 
GUICtrlSetData($hCheck, $Check) 
GUICtrlSetData($hCancel, $Cancel) 
GUICtrlSetData($hOk, $Ok) 
GUICtrlSetState($hUser, $GUI_FOCUS)
            Case $hOk
                $aOut[0] = GUICtrlRead($hUser)
                $aOut[1] = GUICtrlRead($hPass)
				$aOut[2] = GUICtrlRead($hURL)
				ExitLoop
        EndSwitch
        If GUICtrlRead($hUser) <> '' And StringLen(GUICtrlRead($hPass)) >= $minLen Then
            If BitAND(GUICtrlGetState($hOk), $GUI_DISABLE) Then GUICtrlSetState($hOk, $GUI_ENABLE)
        Else
            If BitAND(GUICtrlGetState($hOk), $GUI_ENABLE) Then GUICtrlSetState($hOk, $GUI_DISABLE)
        EndIf
    WEnd
    Opt('GUIOnEventMode', $opt)
    GUIDelete($hGui)
    Return SetError($err, 0, $aOut)
	Opt("WinDetectHiddenText", 1 )


	
EndFunc  

$Datei = "c:\Benutzerdaten.ini"
IniWriteSection($Datei, "User="&$array[0],"Pwd="&$array[1] & @LF & "URL="&$array[2])
	
$var = IniReadSection ("c:\Benutzerdaten.ini")
If @error Then 
    MsgBox(4096, "", "Es ist ein Fehler aufgetreten. Warscheinlich keine INI Datei vorhanden.")
Else
    For $i = 1 To $var[0][0]
        MsgBox(4096, "", "Schlüssel: " & $var[$i][0] & @CRLF & "Wert: " & $var[$i][1])
    Next
EndIf





	





