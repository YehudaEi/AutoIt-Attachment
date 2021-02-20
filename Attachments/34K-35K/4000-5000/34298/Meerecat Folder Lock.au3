#NoTrayIcon
#include <Array.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <Crypt.au3>
#include <Misc.au3>

#Region AutoIt3Wrapper directives section
;** This is a list of compiler directives used by AutoIt3Wrapper.exe.
;** comment the lines you don't need or else it will override the default settings
;===============================================================================================================
;===============================================================================================================
;** AUT2EXE settings
#AutoIt3Wrapper_Icon=                           meerecat head.ico
#AutoIt3Wrapper_OutFile=                        ;Target exe/a3x filename.
#AutoIt3Wrapper_OutFile_Type=                   ;a3x=small AutoIt3 file; exe=Standalone executable (Default)
#AutoIt3Wrapper_Compression=                    ;Compression parameter 0-4 0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=                         ;(Y/N) Compress output program.  Default=Y
#AutoIt3Wrapper_UPX_Parameters=                 ;Override the default setting for UPX.
#AutoIt3Wrapper_Change2CUI=                     ;(Y/N) Change output program to CUI in stead of GUI. Default=N
;===============================================================================================================
;** Target program Resource info
#AutoIt3Wrapper_Res_Comment=                    ;Comment field
#AutoIt3Wrapper_Res_Description=                Keep your private documents safe and secure with Meerecat Folder Lock
#AutoIt3Wrapper_Res_Fileversion=                1.5
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=  ;(Y/N/P)AutoIncrement FileVersion After Aut2EXE is finished. default=N
;                                                 P=Prompt, Will ask at Compilation time if you want to increase the versionnumber
#AutoIt3Wrapper_Res_ProductVersion=             ;Product Version. Default is the AutoIt3 version used.
#AutoIt3Wrapper_Res_Language=                   ;Resource Language code . default 2057=English (United Kingdom)
#AutoIt3Wrapper_Res_LegalCopyright=             Meerecat IT Services 2011
#AutoIt3Wrapper_res_requestedExecutionLevel=    ;None, asInvoker, highestAvailable or requireAdministrator   (default=None)
#AutoIt3Wrapper_Res_SaveSource=                 ;(Y/N) Save a copy of the Scriptsource in the EXE resources. default=N

#EndRegion

Global $DIR_PASSWORD = @AppDataDir & '\Meerecat\FolderLock'
Global $INI_PASSWORD = $DIR_PASSWORD & '\FldLock.ini'
Global $INI_PASSWORD_ENCRYPT = $DIR_PASSWORD & '\FldLock.crypt'
Global $dir = @MyDocumentsDir & '\My Secure Folder'
Global $BTN_CANCELED, $BTN_PASSWORD, $CHK_PASSWORD1, $GUI_PASSWORD, $GUI_PASSWORD1

If Not FileExists($DIR_PASSWORD) Then DirCreate($DIR_PASSWORD)

If FileExists($DIR_PASSWORD & '\meerecat.jpg') = 0 Then FileInstall ('meerecat.jpg', $DIR_PASSWORD & '\meerecat.jpg')

If FileExists ($INI_PASSWORD_ENCRYPT) then
	_decrypt()
EndIf


func _decrypt()
	_Crypt_DecryptFile ($INI_PASSWORD_ENCRYPT, $INI_PASSWORD,  'test', $CALG_RC4)
	sleep (3000)
	FileDelete ($INI_PASSWORD_ENCRYPT)
EndFunc

func _encrypt()
	_Crypt_EncryptFile ($INI_PASSWORD, $INI_PASSWORD_ENCRYPT, 'test', $CALG_RC4)
	sleep (1000)
	FileDelete ($INI_PASSWORD)
EndFunc

If IniRead($INI_PASSWORD, 'Password', 'Password', 'Error') = 'Error' Then
    $MSG_MEEREKAT = MsgBox(65, "Meerecat Folder Lock", "This is your first time running Folder Lock on this PC" & @LF & @LF & "You will now be prompted to create a password.")
	If $MSG_MEEREKAT = 2 Then Exit
	_SET_PASSWORD('Password')
EndIf

If FileExists($dir) = 0 Then
    DirCreate($dir)
    MsgBox(0 + 64, "Meerecat Folder Lock", "Your secure folder has been created:" & @LF & @LF & "You will now find a folder in your Documents area called My Secure Folder.")
EndIf

_GET_PASSWORD('Password')


Func _main()
	GUIDelete()
	$prompt = GUICreate("Meerecat Folder Lock", 528, 242)
    GUICtrlCreateLabel("Meerecat IT Services  ©2011", 376, 224, 145, 17)
    GUICtrlCreateLabel("Meerecat Folder Lock", 186, 8, 155, 20)
    GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
    GUICtrlCreatePic($DIR_PASSWORD & "\meerecat.jpg", 8, 45, 113, 150)
    GUICtrlCreatePic($DIR_PASSWORD & "\meerecat.jpg", 408, 45, 113, 150)
    GUISetBkColor(0xFFFFFF)
    $lock = GUICtrlCreateButton("Lock Folder", 163, 40, 200, 25)
    $unlock = GUICtrlCreateButton("Unlock Folder", 163, 80, 200, 25)
    $advanced = GUICtrlCreateButton("Options", 163, 120, 200, 25)
	$help = GUICtrlCreateButton("Help", 163, 160, 200, 25)
    $exit = GUICtrlCreateButton("Exit", 163, 200, 200, 25)
    GUISetState(@SW_SHOW)
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				_encrypt()
				Exit
			Case $exit
				_encrypt()
				Exit
			Case $lock
				RunWait(@ComSpec & ' /c attrib +s +h +r "' & $dir & '"',@UserProfileDir,@SW_HIDE)
                RunWait(@ComSpec & ' /c cacls "' & $dir & '" /e /c /d ' & @UserName,@UserProfileDir,@SW_HIDE)
			MsgBox(0 + 64,"Meerecat Folder Lock","Your folder has been LOCKED")
			Case $unlock
				RunWait(@ComSpec & ' /c cacls "' & $dir & '" /e /c /g ' & @UserName & ":f",@UserProfileDir,@SW_HIDE)
                RunWait(@ComSpec & ' /c attrib -s -h -r "' & $dir & '"',@UserProfileDir,@SW_HIDE)
			MsgBox(0 + 64,"Meerecat Folder Lock","Your folder has been UNLOCKED")
			Case $advanced
				_Advanced()
			Case $help
				ShellExecute ("http://www.meerecat-itservices.co.uk/contact-us")

		EndSwitch
	WEnd
EndFunc

Func _Advanced()
    GUIDelete()
	$prompt = GUICreate("Meerecat Folder Lock", 528, 242)
    GUICtrlCreateLabel("Meerecat IT Services  ©2011", 376, 224, 145, 17)
    GUICtrlCreateLabel("Meerecat Folder Lock", 186, 8, 155, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
    GUICtrlCreatePic($DIR_PASSWORD & "\meerecat.jpg", 8, 45, 113, 150)
	GUICtrlCreatePic($DIR_PASSWORD & "\meerecat.jpg", 408, 45, 113, 150)
    GUISetBkColor(0xFFFFFF)
	$open = GUICtrlCreateButton("Open Secure Folder", 163, 48, 200, 25)
    $chgpass = GUICtrlCreateButton("Change Folder Lock Password", 163, 128, 200, 25)
    $delete = GUICtrlCreateButton("Delete Secure Folder", 163, 88, 200, 25)
    $back = GUICtrlCreateButton("Go Back", 163, 168, 200, 25)
    GUISetState(@SW_SHOW)
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				_main()
			Case $back
				_main()
			Case $chgpass
				_CHANGE_PASSWORD('Password', $prompt)
			Case $open
				RunWait(@ComSpec & ' /c cacls "' & $dir & '" /e /c /g ' & @UserName & ":f",@UserProfileDir,@SW_HIDE)
				RunWait(@ComSpec & ' /c attrib -s -h -r "' & $dir & '"',@UserProfileDir,@SW_HIDE)
				ShellExecute($dir)
			Case $delete
				$MSG_DELETE = MsgBox(49,"Meerecat Folder Lock","This will delete your secure folder.  This action CANNOT be undone." & @CRLF & "To continue press OK otherwise press Cancel")
				If $MSG_DELETE = 1 Then
					RunWait(@ComSpec & ' /c cacls "' & $dir & '" /e /c /g ' & @UserName & ":f",@UserProfileDir,@SW_HIDE)
				    RunWait(@ComSpec & ' /c attrib -s -h -r "' & $dir & '"',@UserProfileDir,@SW_HIDE)
					DirRemove($dir,1)
					MsgBox(64,"Meerecat Folder Lock","Your secure folder has been removed. You will need to restart the program to recreate it.")
				Else
					_Advanced()
				EndIf
		EndSwitch
	WEnd
EndFunc

_GET_PASSWORD('Password')

Func _GET_PASSWORD($INI_SECTION)
  $GUI_PASSWORD = GUICreate('Meerecat Folder Lock', 320, 100)
  GUICtrlCreateLabel('Please enter your Password:', 10, 10, 300, 20)
  $GUI_PASSWORD1 = GUICtrlCreateInput('', 10, 35, 200, 20, $ES_PASSWORD)
  $CHK_PASSWORD1 = GUICtrlCreateLabel('', 210, 35, 100, 20, $SS_CENTERIMAGE)
  $BTN_PASSWORD = GUICtrlCreateButton('OK', 10, 60, 100, 20)
  $BTN_CANCELED = GUICtrlCreateButton('Cancel', 110, 60, 100, 20)
  GUISetState()
  While 1
    $msg = GUIGetMsg()
    Switch $msg
	Case $GUI_EVENT_CLOSE
		_encrypt()
        Exit
	Case $BTN_CANCELED
		_encrypt()
        Exit
      Case $BTN_PASSWORD
        $GET_PASSWORD = IniRead($INI_PASSWORD, $INI_SECTION, 'Password', 'Error')
        If $GET_PASSWORD = 'Error' Then
          $MSG_MEEREKAT = MsgBox(65, "Meerecat Folder Lock", "Meerecat Folder Lock Password has not been set, you will now be prompted to create a password.")
          If $MSG_MEEREKAT = 2 Then Exit
          _SET_PASSWORD('Password')
        Else
          CHK_PASSWORD($GET_PASSWORD)
        EndIf
      Case $GUI_PASSWORD1
        If _IsPressed('0D') Then
          $GET_PASSWORD = IniRead($INI_PASSWORD, $INI_SECTION, 'Password', 'Error')
          If $GET_PASSWORD = 'Error' Then
            $MSG_MEEREKAT = MsgBox(65, "Meerecat Folder Lock", "Meerecat Folder Lock Password has not been set, you will now be prompted to create a password.")
            If $MSG_MEEREKAT = 2 Then Exit
            _SET_PASSWORD('Password')
          Else
            CHK_PASSWORD($GET_PASSWORD)
          EndIf
        EndIf
    EndSwitch
  WEnd
EndFunc

Func CHK_PASSWORD($PAR_PASSWORD)
  If GUICtrlRead($GUI_PASSWORD1) <> $PAR_PASSWORD Then
    GUICtrlSetBkColor($GUI_PASSWORD1, 0xFFE1E1)
    GUICtrlSetData($CHK_PASSWORD1, 'Password Incorrect')
    GUICtrlSetColor($CHK_PASSWORD1, 0xCC0000)
  ElseIf GUICtrlRead($GUI_PASSWORD1) = '' Then
    GUICtrlSetBkColor($GUI_PASSWORD1, 0xFFE1E1)
    GUICtrlSetData($CHK_PASSWORD1, 'Blank Password')
    GUICtrlSetColor($CHK_PASSWORD1, 0xCC0000)
  Else
    GUICtrlSetBkColor($GUI_PASSWORD1, 0xFFFFFF)
    GUICtrlSetData($CHK_PASSWORD1, '')
  GUIDelete($GUI_PASSWORD)
_main()
  EndIf
EndFunc

Func _SET_PASSWORD($INI_SECTION, $PARENT_WINDOW = '')
	$GUI_PASSWORD = GUICreate('Meerecat Folder Lock', 320, 120, -1, -1, -1, -1, $PARENT_WINDOW)
	GUICtrlCreateLabel('Password:', 10, 10, 100, 20)
	$GUI_PASSWORD1 = GUICtrlCreateInput('', 110, 10, 100, 20, $ES_PASSWORD)
	$CHK_PASSWORD1 = GUICtrlCreateLabel('', 210, 10, 100, 20, $SS_CENTERIMAGE)
	GUICtrlCreateLabel('Confirm Password', 10, 35, 100, 20)
	GUICtrlCreateLabel('Please type a password above then click OK.', 10, 65, 250, 20)
	$GUI_PASSWORD2 = GUICtrlCreateInput('', 110, 35, 100, 20, $ES_PASSWORD)
	$CHK_PASSWORD2 = GUICtrlCreateLabel('', 210, 35, 100, 20, $SS_CENTERIMAGE)
	$BTN_PASSWORD = GUICtrlCreateButton('OK', 10, 90, 100, 20)
	$BTN_CANCELED = GUICtrlCreateButton('Cancel', 110, 90, 100, 20)
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($GUI_PASSWORD)
				Exit
			Case $BTN_CANCELED
				GUIDelete($GUI_PASSWORD)
				Exit
			Case $BTN_PASSWORD
				If GUICtrlRead($GUI_PASSWORD1) <> GUICtrlRead($GUI_PASSWORD2) Then
					GUICtrlSetBkColor($GUI_PASSWORD1, 0xFFE1E1)
					GUICtrlSetBkColor($GUI_PASSWORD2, 0xFFE1E1)
					GUICtrlSetData($CHK_PASSWORD1, 'Password Mismatch')
					GUICtrlSetData($CHK_PASSWORD2, 'Password Mismatch')
					GUICtrlSetColor($CHK_PASSWORD1, 0xCC0000)
					GUICtrlSetColor($CHK_PASSWORD2, 0xCC0000)
					ContinueLoop
				ElseIf GUICtrlRead($GUI_PASSWORD1) = '' Then
					GUICtrlSetBkColor($GUI_PASSWORD1, 0xFFE1E1)
					GUICtrlSetData($CHK_PASSWORD1, 'Blank Password')
					GUICtrlSetColor($CHK_PASSWORD1, 0xCC0000)
					ContinueLoop
				Else
					GUICtrlSetBkColor($GUI_PASSWORD1, 0xFFFFFF)
					GUICtrlSetBkColor($GUI_PASSWORD2, 0xFFFFFF)
					GUICtrlSetData($CHK_PASSWORD1, '')
					GUICtrlSetData($CHK_PASSWORD2, '')
					IniWrite($INI_PASSWORD, $INI_SECTION, 'Password', GUICtrlRead($GUI_PASSWORD1))
					GUIDelete($GUI_PASSWORD)
					ExitLoop
				EndIf
		EndSwitch
	WEnd
EndFunc

Func _CHANGE_PASSWORD($INI_SECTION, $PARENT_WINDOW = '')
	$GUI_PASSWORD = GUICreate('Meerecat Folder Lock', 320, 120, -1, -1, -1, -1, $PARENT_WINDOW)
	GUICtrlCreateLabel('Password:', 10, 10, 100, 20)
	$GUI_PASSWORD1 = GUICtrlCreateInput('', 110, 10, 100, 20, $ES_PASSWORD)
	$CHK_PASSWORD1 = GUICtrlCreateLabel('', 210, 10, 100, 20, $SS_CENTERIMAGE)
	GUICtrlCreateLabel('Confirm Password', 10, 35, 100, 20)
	GUICtrlCreateLabel('Please type a password above then click OK.', 10, 65, 250, 20)
	$GUI_PASSWORD2 = GUICtrlCreateInput('', 110, 35, 100, 20, $ES_PASSWORD)
	$CHK_PASSWORD2 = GUICtrlCreateLabel('', 210, 35, 100, 20, $SS_CENTERIMAGE)
	$BTN_PASSWORD = GUICtrlCreateButton('OK', 10, 90, 100, 20)
	$BTN_CANCELED = GUICtrlCreateButton('Cancel', 110, 90, 100, 20)
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				_Advanced()
			Case $BTN_CANCELED
				_Advanced()
			Case $BTN_PASSWORD
				If GUICtrlRead($GUI_PASSWORD1) <> GUICtrlRead($GUI_PASSWORD2) Then
					GUICtrlSetBkColor($GUI_PASSWORD1, 0xFFE1E1)
					GUICtrlSetBkColor($GUI_PASSWORD2, 0xFFE1E1)
					GUICtrlSetData($CHK_PASSWORD1, 'Password Mismatch')
					GUICtrlSetData($CHK_PASSWORD2, 'Password Mismatch')
					GUICtrlSetColor($CHK_PASSWORD1, 0xCC0000)
					GUICtrlSetColor($CHK_PASSWORD2, 0xCC0000)
					ContinueLoop
				ElseIf GUICtrlRead($GUI_PASSWORD1) = '' Then
					GUICtrlSetBkColor($GUI_PASSWORD1, 0xFFE1E1)
					GUICtrlSetData($CHK_PASSWORD1, 'Blank Password')
					GUICtrlSetColor($CHK_PASSWORD1, 0xCC0000)
					ContinueLoop
				Else
					GUICtrlSetBkColor($GUI_PASSWORD1, 0xFFFFFF)
					GUICtrlSetBkColor($GUI_PASSWORD2, 0xFFFFFF)
					GUICtrlSetData($CHK_PASSWORD1, '')
					GUICtrlSetData($CHK_PASSWORD2, '')
					IniWrite($INI_PASSWORD, $INI_SECTION, 'Password', GUICtrlRead($GUI_PASSWORD1))
					GUIDelete($GUI_PASSWORD)
					MsgBox (64, "Meerecat Folder Lock", "Your password has been changed")
					ExitLoop
				EndIf
		EndSwitch
	WEnd
EndFunc