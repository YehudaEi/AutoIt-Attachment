#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=meerecat head.ico
#AutoIt3Wrapper_Outfile=Meerecat File Guard.exe
#AutoIt3Wrapper_Res_Description=Protect your files from prying eyes before sending them with Meerecat File Guard
#AutoIt3Wrapper_Res_Fileversion=1.0
#AutoIt3Wrapper_Res_LegalCopyright=Meerecat IT Services 2011
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Crypt.au3>

Global $Increase = 0
Global $Extension = '.crypt'
Global $TrimLength = StringLen($Extension)
Global $hWnd
Global $IMG_DIR = @AppDataDir & '\Meerecat\FileGuard'

If Not FileExists($IMG_DIR) Then DirCreate($IMG_DIR)
If FileExists($IMG_DIR & '\meerecat.jpg') = 0 Then FileInstall('meerecat.jpg', $IMG_DIR & '\meerecat.jpg')

_main()

Func _main()
	GUIDelete()
	$Form1 = GUICreate("Meerecat File Guard", 528, 242)
	GUISetBkColor(0xFFFFFF)
	$Pic1 = GUICtrlCreatePic($IMG_DIR & '\meerecat.jpg', 8, 45, 113, 150)
	$Label2 = GUICtrlCreateLabel("Meerecat File Guard", 191, 8, 145, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$Label3 = GUICtrlCreateLabel("Meerecat IT Services  ©2011", 376, 224, 145, 17)
	GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
	$Pic2 = GUICtrlCreatePic("meerecat.jpg", 408, 45, 113, 150)
	$encrypt = GUICtrlCreateButton("Encrypt File", 163, 54, 200, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$decrypt = GUICtrlCreateButton("Decrypt File", 163, 95, 200, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$help = GUICtrlCreateButton("Help", 163, 136, 200, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$exit = GUICtrlCreateButton("Exit", 163, 176, 200, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $encrypt
				_encrypt()
			Case $decrypt
				_decrypt()
			Case $help
				ShellExecute("                                               ")
			Case $exit
				Exit

		EndSwitch
	WEnd
EndFunc   ;==>_main

Func _encrypt()
	GUIDelete()
	$hWnd = GUICreate("Meerecat File Guard", 528, 242)
	GUISetBkColor(0xFFFFFF)
	GUICtrlCreatePic("meerecat.jpg", 8, 45, 113, 150)
	$Label2 = GUICtrlCreateLabel("Meerecat File Guard", 191, 8, 145, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$Label3 = GUICtrlCreateLabel("Meerecat IT Services  ©2011", 376, 224, 145, 17)
	GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
	$back = GUICtrlCreateButton("Back", 411, 112, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$InFileLabel = GUICtrlCreateLabel("Input File", 150, 48, 47, 17)
	$InFileInput = GUICtrlCreateInput("", 150, 64, 180, 21)
	$OutFileLabel = GUICtrlCreateLabel("Output File", 150, 96, 55, 17)
	$OutFileInput = GUICtrlCreateInput("", 150, 112, 180, 21)
	$InFileButton = GUICtrlCreateButton(". . .", 336, 64, 30, 25)
	$OutFileButton = GUICtrlCreateButton(". . .", 336, 112, 30, 25)
	$PasswordLabel = GUICtrlCreateLabel("Encryption Password", 150, 144, 103, 17)
	$PasswordInput = GUICtrlCreateInput("", 150, 160, 180, 21)
	$EncryptButton = GUICtrlCreateButton("Encrypt", 411, 64, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUISetState(@SW_SHOW)



	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $back
				_main()
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
	$hWnd = GUICreate("Meerecat File Guard", 528, 242)
	GUISetBkColor(0xFFFFFF)
	GUICtrlCreatePic("meerecat.jpg", 8, 45, 113, 150)
	$Label2 = GUICtrlCreateLabel("Meerecat File Guard", 191, 8, 145, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$Label3 = GUICtrlCreateLabel("Meerecat IT Services  ©2011", 376, 224, 145, 17)
	GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
	$back = GUICtrlCreateButton("Back", 411, 112, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$InFileLabel = GUICtrlCreateLabel("Input File", 150, 48, 47, 17)
	$InFileInput = GUICtrlCreateInput("", 150, 64, 180, 21)
	$OutFileLabel = GUICtrlCreateLabel("Output File", 150, 96, 55, 17)
	$OutFileInput = GUICtrlCreateInput("", 150, 112, 180, 21)
	$InFileButton = GUICtrlCreateButton(". . .", 336, 64, 30, 25)
	$OutFileButton = GUICtrlCreateButton(". . .", 336, 112, 30, 25)
	$PasswordLabel = GUICtrlCreateLabel("Encryption Password", 150, 144, 103, 17)
	$PasswordInput = GUICtrlCreateInput("", 150, 160, 180, 21)
	$EncryptButton = GUICtrlCreateButton("Decrypt", 411, 64, 100, 30)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUISetState(@SW_SHOW)


	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $back
				_main()
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