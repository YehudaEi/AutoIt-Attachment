#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=meerecat head.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=Protect your files before sendng them with Meerecat File Guard
#AutoIt3Wrapper_Res_Fileversion=1.5.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Meerecat IT Services 2011
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;Special thanks to Smartee, Mat and MHz on the AutoIt forum
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Crypt.au3>
#include "resources.au3"

Global $Increase = 0
Global $Extension = '.mcat'
Global $TrimLength = StringLen($Extension)
Global $hWnd
Global $pic1
Global $about_gui

RegWrite('HKCR\.mcat\', '', 'REG_SZ', 'Mcat')
RegWrite('HKCR\Mcat\shell\open\command\', '', 'REG_SZ', @ProgramFilesDir & '\Meerecat Simple Software\Meerecat File Guard\Meerecat File Guard.exe "%1"')

$prog = @ProgramFilesDir & '\Meerecat Simple Software\Meerecat File Guard\Meerecat File Guard.exe'
$text = 'Encrypt with Meerecat File Guard'

RegWrite("HKEY_CLASSES_ROOT\*\shell")
RegWrite("HKEY_CLASSES_ROOT\*\shell\" & $text)
RegWrite("HKEY_CLASSES_ROOT\*\shell\" & $text & "\command")
RegWrite("HKEY_CLASSES_ROOT\*\shell\" & $text & "\command", "", "REG_SZ", $prog & " %1")


If $CmdLine[0] > 0 Then
	If StringRight($CmdLine[1], 5) <> '.mcat' Then
		_encrypt()
	Else
		_decrypt()
	EndIf
EndIf


_main()

Func _main()
	GUIDelete()
	$prompt = GUICreate("Meerecat File Guard", 288, 287)
	GUISetBkColor(0xFFFFFF)
	$MainMenu = GUICtrlCreateMenu("&Main Menu")
	$encrypt_menu = GUICtrlCreateMenuItem("&Encrypt File", $MainMenu)
	$decrypt_menu = GUICtrlCreateMenuItem("&Decrypt File", $MainMenu)
	$exit_menu = GUICtrlCreateMenuItem("E&xit", $MainMenu)
	$HelpMenu = GUICtrlCreateMenu("&Help")
	$contact_menu = GUICtrlCreateMenuItem("&Contact Us", $HelpMenu)
	$about_menu = GUICtrlCreateMenuItem("&About", $HelpMenu)
	GUICtrlCreatePic("meerecat.jpg", 8, 58, 113, 150)
	_ResourceSetImageToCtrl($pic1, "MEERECAT_JPG_1") ; set JPG image to picture control from resource
	$Label2 = GUICtrlCreateLabel("Meerecat File Guard", 66, 8, 155, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Leelawadee")
	$encrypt = GUICtrlCreateButton("Encrypt File", 155, 86, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "Leelawadee")
	$decrypt = GUICtrlCreateButton("Decrypt File", 155, 135, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "Leelawadee")
	GUISetState(@SW_SHOW)

	While 1
		$aMsg = GUIGetMsg(1) ; Use advanced parameter to get array
		Switch $aMsg[1] ; check which GUI sent the message
			Case $prompt
				Switch $aMsg[0]
			Case $GUI_EVENT_CLOSE
				Exit
			Case $encrypt
				_encrypt()
			Case $decrypt
				_decrypt()
			Case $encrypt_menu
				_encrypt()
			Case $decrypt_menu
				_decrypt()
			Case $contact_menu
				ShellExecute("http://www.meerecat-itservices.co.uk/contact-us")
			Case $exit_menu
				Exit
			Case $about_menu
				GUICtrlSetState($about_menu, $GUI_DISABLE)
				_about()
			EndSwitch
		Case $about_gui
			Switch $aMsg[0]
				Case $GUI_EVENT_CLOSE ; If we get the CLOSE message from this GUI - we just delete the GUI <<<<<<<<<<<<<<<
				GUIDelete($about_gui)
				GUICtrlSetState($about_menu, $GUI_ENABLE)

	EndSwitch
	EndSwitch
	WEnd
EndFunc   ;==>_main

Func _encrypt()
	GUIDelete()
	$hWnd = GUICreate("Meerecat File Guard", 288, 287)
	GUISetBkColor(0xFFFFFF)
	$MainMenu = GUICtrlCreateMenu("&Main Menu")
	$encrypt_menu = GUICtrlCreateMenuItem("Encrypt File", $MainMenu)
	$decrypt_menu = GUICtrlCreateMenuItem("Decrypt File", $MainMenu)
	$exit_menu = GUICtrlCreateMenuItem("Exit", $MainMenu)
	$HelpMenu = GUICtrlCreateMenu("&Help")
	$contact_menu = GUICtrlCreateMenuItem("Contact Us", $HelpMenu)
	$about_menu = GUICtrlCreateMenuItem("About", $HelpMenu)
	$Label2 = GUICtrlCreateLabel("Meerecat File Guard", 66, 8, 155, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Leelawadee")
	$Label3 = GUICtrlCreateLabel("Meerecat IT Services  ©2011", 376, 224, 145, 17)
	GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
	$back = GUICtrlCreateButton("Back", 155, 231, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "Leelawadee")
	$InFileLabel = GUICtrlCreateLabel("Input File", 8, 56, 56, 19)
	GUICtrlSetFont(-1, 10, 400, 0, "Leelawadee")
	$InFileInput = GUICtrlCreateInput("", 8, 72, 225, 21)
	$OutFileLabel = GUICtrlCreateLabel("Output File", 8, 110, 67, 19)
	GUICtrlSetFont(-1, 10, 400, 0, "Leelawadee")
	$OutFileInput = GUICtrlCreateInput("", 8, 123, 225, 21)
	$InFileButton = GUICtrlCreateButton(". . .", 240, 72, 30, 25)
	$OutFileButton = GUICtrlCreateButton(". . .", 240, 123, 30, 25)
	$PasswordLabel = GUICtrlCreateLabel("Encryption Password", 8, 159, 125, 19)
	GUICtrlSetFont(-1, 10, 400, 0, "Leelawadee")
	$PasswordInput = GUICtrlCreateInput("", 7, 175, 225, 21)
	$EncryptButton = GUICtrlCreateButton("Encrypt", 35, 230, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "Leelawadee")

	If ($CmdLine[0] > 0) Then ;Used to prefill input areas
		GUICtrlSetData($InFileInput, $CmdLine[1])
		GUICtrlSetData($OutFileInput, $CmdLine[1] & $Extension)
	EndIf
	GUISetState(@SW_SHOW)



	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $back
				_main()
			Case $encrypt_menu
				_encrypt()
			Case $decrypt_menu
				_decrypt()
			Case $contact_menu
				ShellExecute("http://www.meerecat-itservices.co.uk/contact-us")
			Case $exit_menu
				Exit
			Case $about_menu
				_about()
			Case $InFileButton
				$file = FileOpenDialog("Input File", "", "All files (*.*;)")
				If $file <> "" Then
					GUICtrlSetData($InFileInput, $file)
					GUICtrlSetData($OutFileInput, $file & $Extension)
				EndIf
			Case $OutFileButton
				$file = FileSaveDialog("Output file", "", "Any file (*.*;)")
				If $file <> "" Then GUICtrlSetData($OutFileInput, $file)

			Case $EncryptButton
				$infile = GUICtrlRead($InFileInput)
				If Not FileExists($infile) Then
					MsgBox(16, "Error", "Input file doesn't exists!")
					ContinueLoop
				EndIf


				$outfile = GUICtrlRead($OutFileInput)
				If $outfile = "" Then
					MsgBox(16, "Error", "Please input a output file")
					ContinueLoop
				EndIf


				$password = GUICtrlRead($PasswordInput)
				If $password = "" Then
					MsgBox(16, "Error", "Please input a password")
					ContinueLoop
				EndIf

				AdlibRegister("Update", 333)
				$success = _Crypt_EncryptFile($infile, $outfile, $password, $CALG_RC4)
				If $success Then
					MsgBox(0, "Success", "Operation succeeded")
					_main()
				Else
					Switch @error
						Case 1
							MsgBox(16, "Fail", "Failed to create key")
						Case 2
							MsgBox(16, "Fail", "Couldn't open source file")
						Case 3
							MsgBox(16, "Fail", "Couldn't open destination file")
						Case 4 Or 5
							MsgBox(16, "Fail", "Encryption error")
					EndSwitch
				EndIf

				AdlibUnRegister("Update")
				WinSetTitle($hWnd, "", "File Encrypter")
		EndSwitch
	WEnd
EndFunc   ;==>_encrypt
Func _decrypt()
	GUIDelete()
	$hWnd = GUICreate("Meerecat File Guard", 288, 287)
	GUISetBkColor(0xFFFFFF)
	$MainMenu = GUICtrlCreateMenu("&Main Menu")
	$encrypt_menu = GUICtrlCreateMenuItem("Encrypt File", $MainMenu)
	$decrypt_menu = GUICtrlCreateMenuItem("Decrypt File", $MainMenu)
	$exit_menu = GUICtrlCreateMenuItem("Exit", $MainMenu)
	$HelpMenu = GUICtrlCreateMenu("&Help")
	$contact_menu = GUICtrlCreateMenuItem("Contact Us", $HelpMenu)
	$about_menu = GUICtrlCreateMenuItem("About", $HelpMenu)
	$Label2 = GUICtrlCreateLabel("Meerecat File Guard", 66, 8, 155, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Leelawadee")
	$Label3 = GUICtrlCreateLabel("Meerecat IT Services  ©2011", 376, 224, 145, 17)
	GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
	$back = GUICtrlCreateButton("Back", 155, 231, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "Leelawadee")
	$InFileLabel = GUICtrlCreateLabel("Input File", 8, 56, 56, 19)
	GUICtrlSetFont(-1, 10, 400, 0, "Leelawadee")
	$InFileInput = GUICtrlCreateInput("", 8, 72, 225, 21)
	$OutFileLabel = GUICtrlCreateLabel("Output File", 8, 110, 67, 19)
	GUICtrlSetFont(-1, 10, 400, 0, "Leelawadee")
	$OutFileInput = GUICtrlCreateInput("", 8, 123, 225, 21)
	$InFileButton = GUICtrlCreateButton(". . .", 240, 72, 30, 25)
	$OutFileButton = GUICtrlCreateButton(". . .", 240, 123, 30, 25)
	$PasswordLabel = GUICtrlCreateLabel("Encryption Password", 8, 159, 125, 19)
	GUICtrlSetFont(-1, 10, 400, 0, "Leelawadee")
	$PasswordInput = GUICtrlCreateInput("", 7, 175, 225, 21)
	$EncryptButton = GUICtrlCreateButton("Decrypt", 35, 230, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "Leelawadee")

	If ($CmdLine[0] > 0) Then ;Used to prefill input areas when running a .crypt file
		GUICtrlSetData($InFileInput, $CmdLine[1])
		GUICtrlSetData($OutFileInput, StringTrimRight($CmdLine[1], StringLen(".mcat")))
	EndIf

	GUISetState(@SW_SHOW)


	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $back
				_main()
			Case $encrypt_menu
				_encrypt()
			Case $decrypt_menu
				_decrypt()
			Case $contact_menu
				ShellExecute("http://www.meerecat-itservices.co.uk/contact-us")
			Case $exit_menu
				Exit
			Case $about_menu
				_about()
			Case $InFileButton
				$file = FileOpenDialog("Input File", "", "All files (*.*;)")
				If $file <> "" Then GUICtrlSetData($InFileInput, $file)
				GUICtrlSetData($OutFileInput, StringTrimRight($file, $TrimLength))
			Case $OutFileButton
				$file = FileSaveDialog("Output file", "", "Any file (*.*;)")
				If $file <> "" Then GUICtrlSetData($OutFileInput, $file)

			Case $EncryptButton
				$infile = GUICtrlRead($InFileInput)
				If Not FileExists($infile) Then
					MsgBox(16, "Error", "Input file doesn't exists!")
					ContinueLoop
				EndIf


				$outfile = GUICtrlRead($OutFileInput)
				If $outfile = "" Then
					MsgBox(16, "Error", "Please input a output file")
					ContinueLoop
				EndIf


				$password = GUICtrlRead($PasswordInput)
				If $password = "" Then
					MsgBox(16, "Error", "Please input a password")
					ContinueLoop
				EndIf

				AdlibRegister("Update", 333)
				$success = _Crypt_DecryptFile($infile, $outfile, $password, $CALG_RC4)
				If $success Then
					MsgBox(0, "Success", "Operation succeeded")
					_main()
				Else
					Switch @error
						Case 1
							MsgBox(16, "Fail", "Failed to create key")
						Case 2
							MsgBox(16, "Fail", "Couldn't open source file")
						Case 3
							MsgBox(16, "Fail", "Couldn't open destination file")
						Case 4 Or 5
							MsgBox(16, "Fail", "Encryption error")
					EndSwitch
				EndIf

				AdlibUnRegister("Update")
				WinSetTitle($hWnd, "", "File Decrypter")
		EndSwitch
	WEnd
EndFunc   ;==>_decrypt

Func Update()
	Switch Mod($Increase, 4)
		Case 0
			WinSetTitle($hWnd, "", "Processing... |")
		Case 1
			WinSetTitle($hWnd, "", "Processing... /")
		Case 2
			WinSetTitle($hWnd, "", "Processing... —")
		Case 3
			WinSetTitle($hWnd, "", "Processing... \")
	EndSwitch

	$Increase += 1
EndFunc   ;==>Update

Func _about()
$about_gui = GUICreate("About", 302, 165)
	GUISetBkColor(0xFFFFFF)
	$Label2 = GUICtrlCreateLabel("Meerecat File Guard", 73, 8, 155, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Leelawadee")
	$Label3 = GUICtrlCreateLabel("Meerecat IT Services  ©2011", 152, 144, 145, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Leelawadee")
	$Label1 = GUICtrlCreateLabel("Version 1.5", 116, 32, 69, 19)
	GUICtrlSetFont(-1, 10, 400, 0, "Leelawadee")
	$Label4 = GUICtrlCreateLabel("www.meerecat-itservices.co.uk", 61, 56, 179, 19)
	GUICtrlSetFont(-1, 10, 400, 0, "Leelawadee")
	$Label6 = GUICtrlCreateLabel("Special thanks to Smartee, MHz and Mat,", 49, 96, 203, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Leelawadee")
	$Label7 = GUICtrlCreateLabel("without who this program would not exist.", 46, 108, 208, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Leelawadee")
	GUISetState()

EndFunc   ;==>_about