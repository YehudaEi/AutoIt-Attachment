

_UserLogonDlg ()

Func _UserLogonDlg ($sTitle = "", $sPrompt = "", $sDefUser = "", $sDefPassWord = "", $sDefDomain = "", $nConfirm = 1, $nDomain = 1, $nRet = 0, $hParent = 0)
   Local $hGUI, $hBtn[2], $hInp[4]
   If @OSVersion <> "WIN_2003" And @OSVersion <> "WIN_XP" And @OSVersion <> "WIN_2000" Then Return SetError(2, 0, 0); OS not compatible
   If $sTitle = "" Then $sTitle = "Logon..."
   If $sPrompt = "" Then $sPrompt = "Please enter a valid user name and password."
   If $nRet < 0 Or $nRet > 1 Then $nRet = 0
   If $sDefUser = -1 Then $sDefUser = @UserName
   If $sDefDomain = -1 Then $sDefDomain = @LogonDomain
   If $nConfirm <> 1 Then
      $nConfirm = 22
   Else
      $nConfirm = 0
   EndIf
   If $nDomain <> 1 Then $nConfirm += 22

   $hGUI = GuiCreate($sTitle, 326, 134 - $nConfirm, -1, -1, -1, -1, $hParent)

      $hInp[0] = GuiCtrlCreateInput($sDefUser, 74, 24, 250, 20, -1, -1)
      $hInp[1] = GuiCtrlCreateInput($sDefPassWord, 74, 46, 250, 20, 32, -1)
      $hInp[2] = GuiCtrlCreateInput($sDefPassWord, 74, 68, 250, 20, 32, -1)
         If $nConfirm <> 0 Then GUICtrlSetState (-1, 32)
      $hInp[3] = GuiCtrlCreateInput($sDefDomain, 74, 90 - $nConfirm, 250, 20, 32, -1)
         If $nDomain <> 1 Then GUICtrlSetState (-1, 32)
      GuiCtrlCreateLabel($sPrompt, 2, 2, 400, 20, -1, -1)
      GuiCtrlCreateLabel("User Name: ", 2, 26, 70, 20, 2, -1)
      GuiCtrlCreateLabel("Password: ", 2, 48, 70, 20, 2, -1)
      GuiCtrlCreateLabel("Confirm: ", 2, 70, 70, 20, 2, -1)
         If $nConfirm <> 0 Then GUICtrlSetState (-1, 32)
      GuiCtrlCreateLabel("Domain: ", 2, 92 - $nConfirm, 70, 20, 2, -1)
         If $nDomain <> 1 Then GUICtrlSetState (-1, 32)
      $hBtn[1] = GuiCtrlCreateButton("Cancel", 160, 112 - $nConfirm, 80, 20)
      $hBtn[0] = GuiCtrlCreateButton("OK", 245, 112 - $nConfirm, 80, 20)

      GuiSetState()
   While 1
      Switch GUIGetMsg ()
         Case -3
            ExitLoop
         Case $hBtn[1]
            ExitLoop
         Case $hBtn[0]
            If GUICtrlRead ($hInp[0]) = "rrr" Then ContinueLoop 1 + 0 * MsgBox (48, "Error", "Invalid Username." & @CRLF & "User cannot be blank.")
            If Not (_UserIsValid (GUICtrlRead ($hInp[0]))) Then ContinueLoop 1 + 0 * MsgBox (48, "Error.", "Invalid Username." & @CRLF & _
               GUICtrlRead ($hInp[0]) & " is not a valid username.")
            If Not (GUICtrlRead ($hInp[1]) == GUICtrlRead ($hInp[2])) Then ContinueLoop 1 + 0 * MsgBox (48, "Error", "Invalid Password." & @CRLF & _
               "Passwords do not match.")
            If Not (_UserPasswordIsValid (GUICtrlRead ($hInp[0]), GUICtrlRead ($hInp[2]), ".", "")) Then ContinueLoop 1 + 0 * MsgBox (48, _
               "Error", "Invalid Password." & @CRLF & "Password is not valid.")
            If $nRet = 1 Then Return 1
            _UserLogInToOtherDirect (GUICtrlRead ($hInp[0]), GUICtrlRead ($hInp[3]), GUICtrlRead ($hInp[2]))
      EndSwitch
   WEnd
   Return 0
EndFunc ; ==> _UserLogonDlg
