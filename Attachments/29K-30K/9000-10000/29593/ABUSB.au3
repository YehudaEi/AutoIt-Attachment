#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=USB.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=A bootable USB
#AutoIt3Wrapper_Res_Fileversion=0.9.4.345
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Aris
#AutoIt3Wrapper_Res_Language=1032
#AutoIt3Wrapper_Res_Icon_Add=E:\Projects\FormatNew\Include\check.ico
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <GDIPlus.au3>
#include <Process.au3>
#include 'Icons.au3'

#include <GuiButton.au3>
#include <GuiImageList.au3>
#include <String.au3>

#NoTrayIcon
Opt('MustDeclareVars', 1)
Opt("ExpandEnvStrings", 1)
;Opt("GUICloseOnESC", 0)
;Opt("TrayIconDebug", 1)
Opt("MouseClickDragDelay", 10)

;General
Global $pos[4], $Exit_ISO, $Error, $reset, $usbsel, $size, $Status, $iGetISO, $forms
Global $Exit_ISO = 0, $reset = 0, $PID, $hWnd, $SourceFoI, $File
;Global $Include = @ScriptDir & '\Include\'
Global $IsWin2K = False, $IsWinXP = False, $Wallpaper, $Color[3], $R, $G, $B, $hWallpaper ;=====> Func WindowsCheck()
;Form1
Global $Wizard_Form1, $F1Next_btn, $F1Source_inp, $F1Info_lbl, $ISOF = False, $ISO, $Folder, $Browse_btn, $Open_btn
;Form2
Global $Wizard_Form2, $F2Next_btn, $USBDrives_cmb, $F2DeviceInfo_lbl, $USBCheck_btn
;Form3
Global $Wizard_Form3, $F3Label_inp, $Percentage, $NFiles, $Source, $Target, $TotalSpaceSize, $TransferSize, $cLogo, $Progress_F3, $Progress
;Form4
Global $Wizard_Form4
GUIRegisterMsg($WM_LBUTTONDOWN, "_WinMove")
WindowsCheck()
Setup()

#Region OS Checking Function
Func WindowsCheck()
	Switch @OSVersion
		Case "WIN_2003", "WIN_XP", "WIN_XPe"
			$IsWinXP = True
		Case "WIN_2000"
			$IsWin2K = True
	EndSwitch
	$Wallpaper = RegRead('HKEY_CURRENT_USER\Control Panel\Desktop', 'Wallpaper')
	If $Wallpaper = '' Then
		$Wallpaper = RegRead('HKEY_CURRENT_USER\Control Panel\Colors', 'Background')
		$Color = StringSplit($Wallpaper, ' ', 1)
		$R = Hex($Color[1], 2)
		$G = Hex($Color[2], 2)
		$B = Hex($Color[3], 2)
		$hWallpaper = _Icons_Bitmap_CreateSolidBitmap('0x' & $R & $G & $B, 250, 140)
	Else
		$hWallpaper = _Icons_Bitmap_Load($Wallpaper)
	EndIf
EndFunc   ;==>WindowsCheck
#EndRegion OS Checking Function


#Region Setup
Func Setup()
	Local $Pic, $hBitmap, $Icon, $hIcon, $Labelt, $ok, $Exit, $nMsg
	Local $Setup_Window, $Group1, $Radio1, $Radio2, $Label1, $Input1, $Button1, $Checkbox1, $Checkbox2, $Label2
	Local $ic1, $ic2, $read, $Logo, $Logoh

	If FileExists(@ScriptDir & '\ABUSB.ini') Then
		$read = IniRead(@ScriptDir & '\ABUSB.ini', 'Settings', 'Setup', 'NotFound')
		If $read = '1' Then ABUSB_Wizard()
	EndIf
	#Region ### START Koda GUI section ###
	$Setup_Window = GUICreate("A bootable USB - Setup", 300, 440, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_SYSMENU))
	$Group1 = GUICtrlCreateGroup("A bootable USB Setup", 8, 8, 280, 230, $BS_CENTER)
	GUICtrlSetFont($Group1, 10, 800)
	$Pic = GUICtrlCreatePic('', 24, 25, 250, 140)
	GUICtrlSetState(-1, $GUI_DISABLE)
	If $IsWin2K = True Then
		GUICtrlSetImage(-1, $Wallpaper)
	Else
		_SetHImage($Pic, $hWallpaper)
		$Icon = GUICtrlCreatePic('', 25, 25, 48, 48)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$File = _Install_Files(8)
		$ic1 = _Icons_Icon_Extract($File, -1, 48, 48)
		FileDelete($File)
		$File = _Install_Files(13)
		$ic2 = _Icons_Icon_Extract($File, -1, 16, 16)
		FileDelete($File)
		$hBitmap = _Icons_MergeToBitmap($ic1, $ic2, 0, 32)
		_SetHImage($Icon, $hBitmap)
		_WinAPI_DestroyIcon($ic1)
		_WinAPI_DestroyIcon($ic2)
		_WinAPI_DeleteObject($hBitmap)
	EndIf

	$Labelt = GUICtrlCreateLabel("A bootable" & @LF & "USB", 24, 70, 60, 25, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor(-1, 0xEBECEB)
	GUICtrlSetFont($Labelt, 6, 800)
	GUICtrlSetBkColor($Labelt, $GUI_BKCOLOR_TRANSPARENT)
	$Checkbox1 = GUICtrlCreateCheckbox("Create a Desktop shortcut", 24, 170, 150, 17)
	$Checkbox2 = GUICtrlCreateCheckbox("I have read and accepted the following", 24, 190, 205, 17)
	$Label2 = GUICtrlCreateLabel("License Agreement", 72, 205, 95, 17)
	GUICtrlSetBkColor($Label2, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor($Label2, 0x0000ff)
	GUICtrlSetCursor($Label2, 4)
	If $IsWin2K = True Then
		$File = _Install_Files(2)
		GUICtrlCreateIcon($File, -1, 100, 250, 50, 100, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
		FileDelete($File)
	Else
		$Logo = GUICtrlCreatePic('', 5, 180, 256, 256)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$File = _Install_Files(12)
		$Logoh = _Icons_Bitmap_Load($File)
		_SetHImage($Logo, $Logoh)
		FileDelete($File)
	EndIf
	$ok = GUICtrlCreateButton("OK", 25, 370, 110, 33)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$Exit = GUICtrlCreateButton("Exit", 155, 370, 110, 33)
	GUISetState(@SW_SHOW)


	#EndRegion ### END Koda GUI section ###
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Checkbox2
				If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then
					GUICtrlSetState($ok, $GUI_ENABLE)
				Else
					GUICtrlSetState($ok, $GUI_DISABLE)
				EndIf
			Case $ok
				If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then
					If FileExists($File) Then FileDelete($File)
					_Save(0)
				EndIf
				If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then FileCreateShortcut(@ScriptFullPath, @DesktopDir & "\A bootable USB.lnk", '', '', "A bootable USB")
				GUIDelete($Setup_Window)
				ABUSB_Wizard()
			Case $Label2
				$File = _Install_Files(11)
				ShellExecute($File)
			Case $Exit
				If FileExists($File) Then FileDelete($File)
				Exit
		EndSwitch
	WEnd
EndFunc   ;==>Setup
#EndRegion Setup


#Region A bootable USB Wizard
Func ABUSB_Wizard()
	;Global $Wizard_Form1, $Wizard_Form2, $i, $Multi;, $dummy
	Local $FolderISO, $Icon, $usb_logo, $hBitmap, $icn, $aris
	Local $Icon, $hIcon_1, $hIcon_2, $Sourcelabel, $F1Source_inpH, $hImage
	;Labels
	Local $LabelF11, $LabelF21, $Destination_lbl, $Finish_lbl, $Label_lbl
	;Buttons
	Local $F1Cancel_btn, $F2Back_btn, $F2Cancel_btn, $F3Back_btn, $F3Next_btn, $F3Cancel_btn, $F4Finish_btn
	;ProgressBars
	Local $Progress_F1, $Progress_F2
	;Handles
	Local $F3Label_inpH
	;Messages
	Local $nMsg, $hFocused
	;Timer
	Local $begin, $dif, $Multi, $homepage, $update, $read
	If $IsWin2K = False Then $File = _Install_Files(1)
	;$dummy = GUICreate("dummy", -1, -1,-1,-1)

	#Region $Wizard_Form1
	$Wizard_Form1 = GUICreate("A bootable USB 2010 Unlimited Edition", 500, 250, -1, -1)
	GUISetFont(Default, Default, Default, "Segoe UI")

	If $IsWin2K = True Then
		$File = _Install_Files(2)
		GUICtrlCreateIcon($File, -1, 0, 0, 100, 200, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
		FileDelete($File)
		$FolderISO = _Install_Files(3)
		$Icon = GUICtrlCreateIcon($FolderISO, -1, 452, 0, 48, 48, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
		FileDelete($FolderISO)
	Else
		$usb_logo = GUICtrlCreatePic('', 0, 0, 100, 200, -1, $GUI_WS_EX_PARENTDRAG)
		$hBitmap = _Icons_Bitmap_Load($File)
		_SetHImage($usb_logo, $hBitmap)
		$Icon = GUICtrlCreatePic('', 452, 0, 48, 48)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$hIcon_1 = _Icons_Icon_Extract(@SystemDir & '\shell32.dll', 4, 48, 48)
		$hIcon_2 = _Icons_Icon_Extract(@SystemDir & '\shell32.dll', 162, 32, 32)
		$hBitmap = _Icons_MergeToBitmap($hIcon_1, $hIcon_2, 16, 16)
		_SetHImage($Icon, $hBitmap)
		_WinAPI_DeleteObject($hBitmap)
		_WinAPI_DestroyIcon($hIcon_1)
		_WinAPI_DestroyIcon($hIcon_2)
	EndIf
	GUICtrlCreateLabel(_OSVersion(), 0, 210, 100, 30, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetFont(-1, Default, 800)
	GUICtrlCreateLabel('', 101, 0, 1, 250, $SS_GRAYFRAME, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreateLabel('Locate Source', 104, 0, 250, 20, $SS_LEFT, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 12, 400)
	GUICtrlCreateLabel('Source should be either image ISO file or folder' & @LF & 'containing the Windows® installation files.', 104, 20, 250, 26, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 8, 400)
	GUICtrlCreateGroup("", 104, 40, 384, 170)
	$Sourcelabel = GUICtrlCreateLabel("Source:", 110, 50, 60, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor($Sourcelabel, $GUI_BKCOLOR_TRANSPARENT)
	$F1Source_inp = GUICtrlCreateInput("Source path or ISO path here", 174, 50, 200, 21, $ES_AUTOHSCROLL)
	$F1Source_inpH = GUICtrlGetHandle($F1Source_inp)
	GUICtrlSetColor($F1Source_inp, 0x808080)
	$F1Info_lbl = GUICtrlCreateLabel('', 174, 74, 200, 60, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	If $IsWin2K = True Then
		$File = _Install_Files(4)
		$Browse_btn = GUICtrlCreateButton("&Browse", 404, 50, 64, 56, BitOR($BS_ICON, $BS_TOP))
		GUICtrlSetImage($Browse_btn, $File)
		FileDelete($File)
	Else
		$Browse_btn = GUICtrlCreateButton("&Browse", 404, 50, 64, 56)
		$hImage = _GUIImageList_Create(32, 32, 5)
		_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 3, True)
		_GUICtrlButton_SetImageList($Browse_btn, $hImage, 2)
	EndIf
	If $IsWin2K = True Then
		$File = _Install_Files(5)
		$Open_btn = GUICtrlCreateButton("&Open ISO", 404, 110, 64, 56, BitOR($BS_ICON, $BS_TOP))
		GUICtrlSetImage($Open_btn, $File)
		FileDelete($File)
	Else
		$Open_btn = GUICtrlCreateButton("&Open ISO", 404, 110, 64, 56)
		$hImage = _GUIImageList_Create(32, 32, 5)
		_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 188, True)
		_GUICtrlButton_SetImageList($Open_btn, $hImage, 2)
	EndIf
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetState($Browse_btn, $GUI_FOCUS)
	$Progress_F1 = GUICtrlCreateProgress(104, 210, 396, 5, $PBS_SMOOTH)
	GUICtrlSetData($Progress_F1, 25)
	$F1Next_btn = GUICtrlCreateButton("Next", 355, 220, 64, 25)
	GUICtrlSetState($F1Next_btn, $GUI_DISABLE)
	$F1Cancel_btn = GUICtrlCreateButton("Cancel", 425, 220, 64, 25)
	$read = IniRead(@ScriptDir & '\ABUSB.ini', 'Settings', 'Last', 'NotFound')
	If $read <> 'NotFound' Then
		GUICtrlSetData($F1Source_inp, $read)
		GUICtrlSetColor($F1Source_inp, 0x000000)
		GUICtrlSetState($F1Next_btn, $GUI_ENABLE)
		GUICtrlSetState($F1Next_btn, $GUI_DEFBUTTON)
		GUICtrlSetState($F1Next_btn, $GUI_FOCUS)
	EndIf
	GUISetState(@SW_SHOW)
	#EndRegion $Wizard_Form1

	#Region $Wizard_Form2
	$Wizard_Form2 = GUICreate("A bootable USB 2010 Unlimited Edition", 500, 250, -1, -1)
	If $IsWin2K = True Then
		$File = _Install_Files(2)
		GUICtrlCreateIcon($File, -1, 0, 0, 100, 200, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
		FileDelete($File)
	Else
		$usb_logo = GUICtrlCreatePic('', 0, 0, 100, 200, -1, $GUI_WS_EX_PARENTDRAG)
		$hBitmap = _Icons_Bitmap_Load($File)
		_SetHImage($usb_logo, $hBitmap)
	EndIf
	GUICtrlCreateLabel(_OSVersion(), 0, 210, 100, 30, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetFont(-1, Default, 800)
	GUICtrlCreateLabel('', 101, 0, 1, 250, $SS_GRAYFRAME, $GUI_WS_EX_PARENTDRAG)
	$LabelF21 = GUICtrlCreateLabel('Check USB device', 104, 0, 250, 20, $SS_LEFT, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 12, 400)
	GUICtrlCreateLabel('Select USB device that will be used' & @LF & 'to copy Windows® installation files.', 104, 20, 250, 26, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 8, 400)
	If $IsWin2K = True Then
		$File = _Install_Files(6)
		GUICtrlCreateIcon($File, -1, 452, 0, 48, 48, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
		FileDelete($File)
	Else
		$Icon = GUICtrlCreateIcon('', -1, 452, 0, 48, 48, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
		_SetCombineBkIcon($Icon, -1, @SystemDir & '\setupapi.dll', 20, 48, 48, @SystemDir & '\setupapi.dll', 13, 32, 32, 16, 16)
	EndIf
	GUICtrlCreateGroup("", 104, 40, 384, 170)
	$Destination_lbl = GUICtrlCreateLabel("Destination:", 110, 50, 60, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
	$USBDrives_cmb = GUICtrlCreateCombo('Please check USB drives', 174, 50, 200, 25, BitOR($CBS_UPPERCASE, $CBS_DROPDOWNLIST))
	If $IsWin2K = True Then
		$File = _Install_Files(7)
		$USBCheck_btn = GUICtrlCreateButton("&Check", 404, 50, 64, 56, BitOR($BS_ICON, $BS_TOP))
		GUICtrlSetImage($USBCheck_btn, $File)
		FileDelete($File)
	Else
		$USBCheck_btn = GUICtrlCreateButton("&Check", 404, 50, 64, 56, $BS_DEFPUSHBUTTON)
		$hImage = _GUIImageList_Create(32, 32, 5)
		_GUIImageList_AddIcon($hImage, @ScriptFullPath, 4, True)
		_GUICtrlButton_SetImageList($USBCheck_btn, $hImage, 2)
	EndIf
	$F2DeviceInfo_lbl = GUICtrlCreateLabel("USB Device Infos", 174, 74, 200, 100, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$F2Back_btn = GUICtrlCreateButton("Back", 285, 220, 64, 25)
	$F2Next_btn = GUICtrlCreateButton("Next", 355, 220, 64, 25)
	GUICtrlSetState($F2Next_btn, $GUI_DISABLE)
	$F2Cancel_btn = GUICtrlCreateButton("Cancel", 425, 220, 64, 25)
	$Progress_F2 = GUICtrlCreateProgress(104, 210, 396, 5, $PBS_SMOOTH)
	#EndRegion $Wizard_Form2

	#Region $Wizard_Form3
	$Wizard_Form3 = GUICreate("A bootable USB 2010 Unlimited Edition", 500, 250, -1, -1, Default)
	If $IsWin2K = True Then
		$File = _Install_Files(2)
		GUICtrlCreateIcon($File, -1, 0, 0, 100, 200, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
		FileDelete($File)
	Else
		$usb_logo = GUICtrlCreatePic('', 0, 0, 100, 200, -1, $GUI_WS_EX_PARENTDRAG)
		$File = _Install_Files(1)
		$hBitmap = _Icons_Bitmap_Load($File)
		_SetHImage($usb_logo, $hBitmap)
		FileDelete($File)
	EndIf
	GUICtrlCreateLabel(_OSVersion(), 0, 210, 100, 30, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetFont(-1, Default, 800)
	GUICtrlCreateLabel('', 101, 0, 1, 250, $SS_GRAYFRAME, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreateLabel('Finish', 104, 0, 350, 20, $SS_LEFT, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 12, 400)
	GUICtrlCreateLabel('Enter drive label,check or uncheck "A bootable USB"' & @LF & 'icon integration and proceed with next.', 104, 20, 250, 26, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 8, 400)
	$File = _Install_Files(8)
	GUICtrlCreateIcon($File, -1, 452, 0, 48, 48, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
	FileDelete($File)
	GUICtrlCreateGroup("", 104, 40, 384, 170)
	$Label_lbl = GUICtrlCreateLabel('Label:', 120, 50, 50, 21, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
	$F3Label_inp = GUICtrlCreateInput('A bootable USB', 174, 50, 200, 21)
	GUICtrlSetTip($F3Label_inp, 'Do not use these chars:' & @LF & '"Space" / ^ < >', 'Info', 1, 3)
	$F3Label_inpH = GUICtrlGetHandle($F3Label_inp)
	GUICtrlSetLimit($F3Label_inp, 30)
	GUICtrlSetColor($F3Label_inp, 0x808080)
	$cLogo = GUICtrlCreateCheckbox('Integrate A bootable USB icon.', 174, 75, 170, 21)
	GUICtrlSetState($cLogo, $GUI_CHECKED)
	GUICtrlCreateLabel('', 105, 100, 383, 1, $SS_GRAYFRAME, $GUI_WS_EX_PARENTDRAG)
	$Percentage = GUICtrlCreateLabel('Percent: ', 120, 110, 100, 21, -1, $GUI_WS_EX_PARENTDRAG)
	$NFiles = GUICtrlCreateLabel('No Files: ', 264, 110, 100, 21, -1, $GUI_WS_EX_PARENTDRAG)
	$TotalSpaceSize = GUICtrlCreateLabel('Total Size: ', 120, 127, 100, 21, -1, $GUI_WS_EX_PARENTDRAG)
	$TransferSize = GUICtrlCreateLabel('Transfered: ', 264, 127, 100, 21, -1, $GUI_WS_EX_PARENTDRAG)
	$Source = GUICtrlCreateLabel('From: ', 120, 143, 360, 21, BitOR($SS_LEFTNOWORDWRAP, $SS_LEFT), $GUI_WS_EX_PARENTDRAG)
	$Target = GUICtrlCreateLabel('To: ', 120, 160, 360, 21, BitOR($SS_LEFTNOWORDWRAP, $SS_LEFT), $GUI_WS_EX_PARENTDRAG)
	$Status = GUICtrlCreateLabel('Status: ', 120, 177, 200, 21, -1, $GUI_WS_EX_PARENTDRAG)
	$Progress = GUICtrlCreateProgress(120, 190, 360, 15, $PBS_SMOOTH)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$F3Back_btn = GUICtrlCreateButton("Back", 285, 220, 64, 25)
	$F3Next_btn = GUICtrlCreateButton("Next", 355, 220, 64, 25)
	$F3Cancel_btn = GUICtrlCreateButton("Cancel", 425, 220, 64, 25)
	$Progress_F3 = GUICtrlCreateProgress(104, 210, 396, 5, $PBS_SMOOTH)
	#EndRegion $Wizard_Form3

	#Region $Wizard_Form4
	$Wizard_Form4 = GUICreate("A bootable USB 2010 Unlimited Edition", 500, 250, -1, -1)
	If $IsWin2K = True Then
		$File = _Install_Files(2)
		GUICtrlCreateIcon($File, -1, 0, 0, 100, 200, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
		FileDelete($File)
	Else
		$usb_logo = GUICtrlCreatePic('', 0, 0, 100, 200, -1, $GUI_WS_EX_PARENTDRAG)
		$File = _Install_Files(1)
		$hBitmap = _Icons_Bitmap_Load($File)
		_SetHImage($usb_logo, $hBitmap)
		FileDelete($File)
	EndIf
	GUICtrlCreateLabel(_OSVersion(), 0, 210, 100, 30, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetFont(-1, Default, 800)
	GUICtrlCreateLabel('', 101, 0, 1, 250, $SS_GRAYFRAME, $GUI_WS_EX_PARENTDRAG)
	If $IsWin2K = True Then
		$File = _Install_Files(10)
		GUICtrlCreateIcon($File, -1, 344, 0, 155, 115, $SS_ICON, $GUI_WS_EX_PARENTDRAG)
		FileDelete($File)
	Else
		$aris = GUICtrlCreatePic('', 344, 0, 155, 115, -1, $GUI_WS_EX_PARENTDRAG)
		$File = _Install_Files(10)
		$hBitmap = _Icons_Bitmap_Load($File)
		_SetHImage($aris, $hBitmap)
		FileDelete($File)
	EndIf
	GUICtrlCreateLabel('Dedicated to :' & @LF & _
			'my lovely mother and cousin which' & @LF & _
			'do not live in this world any more,' & @LF & _
			'my family and especially to my brother, John,' & @LF & _
			'my uncle, Ernesto, all my friends,' & @LF & _
			'all you, :)', 105, 0, 220, 80, Default, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel('Q: Why "A bootable USB"?' & @LF & _
			'A: From "Aris bootable USB"', 105, 85, 220, 40, Default, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreateLabel('', 103, 116, 396, 1, $SS_GRAYFRAME, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreateLabel('Version : ' & FileGetVersion(@ScriptFullPath, 'FileVersion'), 105, 120, 100, 20, Default, $GUI_WS_EX_PARENTDRAG)
	$homepage = GUICtrlCreateLabel('Visit homepage', 235, 120, 100, 20, Default, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor(-1, 0x0000ff)
	GUICtrlSetCursor(-1, 0)
	$update = GUICtrlCreateLabel('Check for update', 375, 120, 100, 20, Default, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor(-1, 0x0000ff)
	GUICtrlSetCursor(-1, 0)
	$F4Finish_btn = GUICtrlCreateButton("Finish", 425, 210, 64, 25)
	#EndRegion $Wizard_Form4
	While 1
		$nMsg = GUIGetMsg()
		#Region Form1
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $F4Finish_btn
				Exit
			Case $F1Cancel_btn
				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox(292, '', 'Are you sure you want to cancel?', 0, $Wizard_Form1)
				Select
					Case $iMsgBoxAnswer = 6
						$pos = WinGetPos($Wizard_Form1, '')
						WinMove($Wizard_Form4, '', $pos[0], $pos[1])
						GUISetState(@SW_SHOW, $Wizard_Form4)
						GUISetState(@SW_HIDE, $Wizard_Form1)
					Case $iMsgBoxAnswer = 7
				EndSelect
			Case $Browse_btn
				GUISetCursor(1, 1, $Wizard_Form1)
				$Folder = 'b'
				$SourceFoI = Open_Folder($Wizard_Form1, $Folder)
				GUISetCursor(2, 1, $Wizard_Form1)
			Case $Open_btn
				GUISetCursor(1, 1, $Wizard_Form1)
				$ISO = 'b'
				Open_ISO($Wizard_Form1, $ISO)
				GUISetCursor(2, 1, $Wizard_Form1)
			Case $F1Next_btn
				If StringRight(GUICtrlRead($F1Source_inp), 4) = '.iso' And Not StringInStr(FileGetAttrib(GUICtrlRead($F1Source_inp)), 'd') Then
					If FileExists(GUICtrlRead($F1Source_inp)) Then
						GUISetCursor(1, 1, $Wizard_Form1)
						$ISO = 's'
						Open_ISO($Wizard_Form1, $ISO)
						If $Exit_ISO = 1 Then
							_Save(1)
							$ISOF = True
							GUICtrlSetData($Progress_F2, 25)

							$pos = WinGetPos($Wizard_Form1, '')
							WinMove($Wizard_Form2, '', $pos[0], $pos[1])
							GUISetState(@SW_SHOW, $Wizard_Form2)
							For $i = 5 To 10
								$Multi = $i * 5
								GUICtrlSetData($Progress_F2, $Multi)
								Sleep(10)
							Next
							GUISetState(@SW_HIDE, $Wizard_Form1)
							Check_USB($Wizard_Form2)
						EndIf
					Else
						GUICtrlSetData($F1Info_lbl, "ISO does not exist." & @LF & 'Please use "Opem ISO".')
						GUICtrlSetFont($F1Info_lbl, 8, 800)
						GUICtrlSetColor($F1Info_lbl, 0xFF0000)
					EndIf
				ElseIf FileExists(GUICtrlRead($F1Source_inp) & "\boot\bootsect.exe") Then
					_Save(1)
					$ISOF = False
					$Folder = 's'
					Open_Folder($Wizard_Form1, $Folder)
					$SourceFoI = GUICtrlRead($F1Source_inp)
					GUICtrlSetData($Progress_F2, 25)

					$pos = WinGetPos($Wizard_Form1, '')
					WinMove($Wizard_Form2, '', $pos[0], $pos[1])
					GUISetState(@SW_SHOW, $Wizard_Form2)
					For $i = 5 To 10
						$Multi = $i * 5
						GUICtrlSetData($Progress_F2, $Multi)
						Sleep(10)
					Next
					GUISetState(@SW_HIDE, $Wizard_Form1)
					Check_USB($Wizard_Form2)
				ElseIf FileExists(GUICtrlRead($F1Source_inp)) And Not FileExists(GUICtrlRead($F1Source_inp) & "\boot\bootsect.exe") Then
					GUICtrlSetData($F1Info_lbl, 'Folder is not correct.' & @LF & 'Please use "Browse" folder.')
					GUICtrlSetFont($F1Info_lbl, 8, 800)
					GUICtrlSetColor($F1Info_lbl, 0xFF0000)
				ElseIf Not FileExists(GUICtrlRead($F1Source_inp)) Then
					GUICtrlSetData($F1Info_lbl, 'Folder does not exists.' & @LF & 'Please use "Browse" folder.')
					GUICtrlSetFont($F1Info_lbl, 8, 800)
					GUICtrlSetColor($F1Info_lbl, 0xFF0000)
				EndIf
		EndSwitch
		#EndRegion Form1

		#Region Form2
		Switch $nMsg
			Case $F2Cancel_btn
				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox(292, '', 'Are you sure you want to cancel?', 0, $Wizard_Form2)
				Select
					Case $iMsgBoxAnswer = 6
						$pos = WinGetPos($Wizard_Form1, '')
						WinMove($Wizard_Form4, '', $pos[0], $pos[1])
						GUISetState(@SW_SHOW, $Wizard_Form4)
						GUISetState(@SW_HIDE, $Wizard_Form2)
					Case $iMsgBoxAnswer = 7
				EndSelect
			Case $USBDrives_cmb
				MsgBox(0, '', 'Clicked')
			Case $F2Next_btn
				$usbsel = StringLeft(GUICtrlRead($USBDrives_cmb), 2)
				Check_USB_Files($Wizard_Form2)
				If $Error = 0 Then
					GUICtrlSetData($Progress_F3, 50)
					GUICtrlSetState($Label_lbl, $GUI_FOCUS)
					$pos = WinGetPos($Wizard_Form2, '')
					WinMove($Wizard_Form3, '', $pos[0], $pos[1])
					GUISetState(@SW_SHOW, $Wizard_Form3)
					GUISetState(@SW_HIDE, $Wizard_Form2)
					For $i = 10 To 15
						$Multi = $i * 5
						GUICtrlSetData($Progress_F3, $Multi)
						Sleep(10)
					Next
				EndIf
			Case $F2Back_btn
				GUISetCursor(2, 1, $Wizard_Form1)
				GUICtrlSetData($Progress_F1, 50)
				$pos = WinGetPos($Wizard_Form2, '')
				WinMove($Wizard_Form1, '', $pos[0], $pos[1])
				GUISetState(@SW_SHOW, $Wizard_Form1)
				GUISetState(@SW_HIDE, $Wizard_Form2)
				For $i = 10 To 5 Step -1
					$Multi = $i * 5
					GUICtrlSetData($Progress_F1, $Multi)
					Sleep(10)
				Next
			Case $USBCheck_btn
				Check_USB($Wizard_Form2)
		EndSwitch
		#EndRegion Form2

		#Region Form3
		Switch $nMsg
			Case $F3Cancel_btn
				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox(292, '', 'Are you sure you want to cancel?', 0, $Wizard_Form3)
				Select
					Case $iMsgBoxAnswer = 6
						$pos = WinGetPos($Wizard_Form1, '')
						WinMove($Wizard_Form4, '', $pos[0], $pos[1])
						GUISetState(@SW_SHOW, $Wizard_Form4)
						GUISetState(@SW_HIDE, $Wizard_Form3)
					Case $iMsgBoxAnswer = 7
				EndSelect
			Case $F3Next_btn
				GUISetCursor(1, 1, $Wizard_Form3)
				GUICtrlSetState($F3Label_inp, $GUI_DISABLE)
				GUICtrlSetState($cLogo, $GUI_DISABLE)
				GUICtrlSetState($F3Back_btn, $GUI_DISABLE)
				GUICtrlSetState($F3Next_btn, $GUI_DISABLE)
				GUICtrlSetState($F3Cancel_btn, $GUI_DISABLE)
				Format_USB($Wizard_Form3)
				If $ISOF = True Then
					$SourceFoI = Extract_ISO($Wizard_Form3)
					_Make_Bootable($Wizard_Form3, $SourceFoI)
					_CopyDirWithProgress($SourceFoI, $usbsel)
					DirRemove($SourceFoI, 1)
				Else
					_Make_Bootable($Wizard_Form3, $SourceFoI)
					$begin = TimerInit()
					_CopyDirWithProgress($SourceFoI, $usbsel)
					$dif = TimerDiff($begin)
					ConsoleWrite(Round($dif / 1000, 1) & @LF)
				EndIf
				_Copy_Icon($Wizard_Form3)
				$pos = WinGetPos($Wizard_Form3, '')
				GUISetState(@SW_HIDE, $Wizard_Form3)
				GUIDelete($Wizard_Form1)
				GUIDelete($Wizard_Form2)
				GUIDelete($Wizard_Form3)
				WinMove($Wizard_Form4, '', $pos[0], $pos[1])
				GUISetState(@SW_SHOW, $Wizard_Form4)
			Case $F3Back_btn
				GUICtrlSetData($Progress_F2, 75)
				$pos = WinGetPos($Wizard_Form3, '')
				WinMove($Wizard_Form2, '', $pos[0], $pos[1])
				GUISetState(@SW_SHOW, $Wizard_Form2)
				GUISetState(@SW_HIDE, $Wizard_Form3)
				For $i = 15 To 10 Step -1
					$Multi = $i * 5
					GUICtrlSetData($Progress_F2, $Multi)
					Sleep(10)
				Next
		EndSwitch
		#EndRegion Form3

		#Region Form4
		Switch $nMsg
			Case $homepage
				ShellExecute('http://mylittlesoft.blogspot.com/')
			Case $update
				ShellExecute('http://cid-f52381d9f2fd5fd8.skydrive.live.com/browse.aspx/ABUSB')
		EndSwitch
		#EndRegion Form4

		$hFocused = _WinAPI_GetFocus()
		#Region Form1 Focus
		Switch $hFocused
			Case $F1Source_inpH
				If GUICtrlRead($F1Source_inp) = 'Source path or ISO path here' Then
					GUICtrlSetData($F1Source_inp, '')
					GUICtrlSetColor($F1Source_inp, 0x000000)
					GUICtrlSetState($F1Next_btn, $GUI_ENABLE)
					GUICtrlSetState($F1Next_btn, $GUI_DEFBUTTON)
				EndIf
			Case Else
				If GUICtrlRead($F1Source_inp) = '' Then
					GUICtrlSetData($F1Source_inp, 'Source path or ISO path here')
					GUICtrlSetColor($F1Source_inp, 0x808080)
					GUICtrlSetState($F1Next_btn, $GUI_DISABLE)
				EndIf
		EndSwitch
		#EndRegion Form1 Focus

		#Region Form3 Focus
		Switch $hFocused
			Case $F3Label_inpH
				If $reset = 0 Then
					GUICtrlSetColor($F3Label_inp, 0x000000)
					$reset = 1
				EndIf
			Case Else
				If GUICtrlRead($F3Label_inp) = '' Then
					GUICtrlSetData($F3Label_inp, 'A bootable USB')
					GUICtrlSetColor($F3Label_inp, 0x808080)
					GUICtrlSetState($File, $GUI_CHECKED)
					$reset = 0
				ElseIf GUICtrlRead($F3Label_inp) = 'A bootable USB' And $reset = 1 Then
					GUICtrlSetColor($F3Label_inp, 0x808080)
					GUICtrlSetState($File, $GUI_CHECKED)
					$reset = 0
				ElseIf (GUICtrlRead($F3Label_inp) <> '') And (GUICtrlRead($F3Label_inp) <> 'A bootable USB') Then
					GUICtrlSetState($File, $GUI_UNCHECKED)
				EndIf
		EndSwitch
		#EndRegion Form3 Focus
	WEnd
EndFunc   ;==>ABUSB_Wizard

Func _OSVersion()
	Local $OS
	$OS = @OSVersion
	Switch $OS
		Case 'WIN_2000'
			Return 'Windows 2000 ' & @OSArch
		Case 'WIN_XPe'
			Return 'WIN_XPe ' & @OSArch
		Case 'WIN_XP'
			Return 'Windows XP ' & @OSArch
		Case 'WIN_2003'
			Return 'Windows 2003 ' & @OSArch
		Case 'WIN_VISTA'
			Return 'Windows VISTA ' & @OSArch
		Case 'WIN_2008'
			Return 'Windows Server 2008 ' & @OSArch
		Case 'WIN_7'
			Return 'Windows 7 ' & @OSArch
		Case 'WIN_2008R2'
			Return 'Windows Server 2008R2 ' & @OSArch
		Case Else
			Return 'Error'
	EndSwitch

EndFunc   ;==>_OSVersion

Func _WinMove($hWnd, $Command, $wParam, $lParam)
	If BitAND(WinGetState($hWnd), 32) Then Return $GUI_RUNDEFMSG
	DllCall("user32.dll", "int", "SendMessage", "hWnd", $hWnd, "int", $WM_NCLBUTTONDOWN, "int", $HTCAPTION, "int", 0)
EndFunc   ;==>_WinMove

Func _Save($line)
	Switch $line
		Case 0
			IniWrite(@ScriptDir & '\ABUSB.ini', 'Settings', 'Setup', '1')
		Case 1
			IniWrite(@ScriptDir & '\ABUSB.ini', 'Settings', 'Last', GUICtrlRead($F1Source_inp))
	EndSwitch
EndFunc   ;==>_Save

Func _Install_Files($File)
	Switch $File
		Case 1
			FileInstall('E:\Projects\FormatNew\Include\usb.png', @TempDir & '\usb.png', 1)
			Return @TempDir & '\usb.png'
		Case 2
			FileInstall('E:\Projects\FormatNew\Include\USB_Logo.ico', @TempDir & '\USB_Logo.ico', 1)
			Return @TempDir & '\USB_Logo.ico'
		Case 3
			FileInstall('E:\Projects\FormatNew\Include\win2k.ico', @TempDir & '\win2k.ico', 1)
			Return @TempDir & '\win2k.ico'
		Case 4
			FileInstall('E:\Projects\FormatNew\Include\win2kfolder.ico', @TempDir & '\win2kfolder.ico', 1)
			Return @TempDir & '\win2kfolder.ico'
		Case 5
			FileInstall('E:\Projects\FormatNew\Include\win2kISO.ico', @TempDir & '\win2kISO.ico', 1)
			Return @TempDir & '\win2kISO.ico'
		Case 6
			FileInstall('E:\Projects\FormatNew\Include\Win2kComp.ico', @TempDir & '\Win2kComp.ico', 1)
			Return @TempDir & '\Win2kComp.ico'
		Case 7
			FileInstall('E:\Projects\FormatNew\Include\check.ico', @TempDir & '\check.ico', 1)
			Return @TempDir & '\check.ico'
		Case 8
			FileInstall('E:\Projects\FormatNew\usb.ico', @TempDir & '\usb.ico', 1)
			Return @TempDir & '\usb.ico'
		Case 9
			FileInstall('E:\Projects\FormatNew\Include\7z.exe', @TempDir & '\7z.exe', 1)
			FileInstall('E:\Projects\FormatNew\Include\7z.dll', @TempDir & '\7z.dll', 1)
			Return @TempDir & '\7z.exe'
		Case 10
			If $IsWin2K Then
				FileInstall('E:\Projects\FormatNew\Include\Aris.ico', @TempDir & '\Aris.ico', 1)
				Return @TempDir & '\Aris.ico'
			Else
				FileInstall('E:\Projects\FormatNew\Include\Aris.png', @TempDir & '\Aris.png', 1)
				Return @TempDir & '\Aris.png'
			EndIf
		Case 11
			FileInstall('E:\Projects\FormatNew\Include\license.txt', @TempDir & '\license.txt', 1)
			Return @TempDir & '\license.txt'
		Case 12
			FileInstall('E:\Projects\FormatNew\usb.png', @TempDir & '\usb.png', 1)
			Return @TempDir & '\usb.png'
		Case 13
			FileInstall('E:\Projects\FormatNew\include\shortcut.ico', @TempDir & '\shortcut.ico', 1)
			Return @TempDir & '\shortcut.ico'
	EndSwitch

EndFunc   ;==>_Install_Files

Func _Copy_Icon($hWnd)
	If GUICtrlRead($cLogo) = $GUI_CHECKED Then
		$File = _Install_Files(8)
		FileCopy($File, $usbsel & '\')
		IniWrite($usbsel & '\autorun.inf', 'Autorun', 'icon', 'usb.ico')
		FileDelete($File)
	EndIf
EndFunc   ;==>_Copy_Icon


Func Open_Folder($hWnd, $Folder)
	Local $iGetFolder
	If $Folder = 's' Then
		$iGetFolder = GUICtrlRead($F1Source_inp)
		If FileExists($iGetFolder & '\boot\bootsect.exe') Then
			$size = DirGetSize($iGetFolder & '\')
			GUICtrlSetData($F1Info_lbl, Round(($size) / 1024 / 1024, 1) & ' MB')
			GUICtrlSetFont($F1Info_lbl, 8, 400)
			GUICtrlSetColor($F1Info_lbl, 0x000000)
			GUICtrlSetData($F1Source_inp, $iGetFolder)
			GUICtrlSetColor($F1Source_inp, 0x000000)
			GUICtrlSetState($F1Next_btn, $GUI_ENABLE)
			Return $iGetFolder
		EndIf
	Else
		$iGetFolder = FileSelectFolder("Select installation folder: ", "", 2, @DesktopDir, $hWnd)
		If FileExists($iGetFolder & '\boot\bootsect.exe') Then
			$size = DirGetSize($iGetFolder & '\')
			GUICtrlSetData($F1Info_lbl, Round(($size) / 1024 / 1024, 1) & ' MB')
			GUICtrlSetFont($F1Info_lbl, 8, 400)
			GUICtrlSetColor($F1Info_lbl, 0x000000)
			GUICtrlSetData($F1Source_inp, $iGetFolder)
			GUICtrlSetColor($F1Source_inp, 0x000000)
			GUICtrlSetState($F1Next_btn, $GUI_ENABLE)
			Return $iGetFolder
		ElseIf $iGetFolder = "" Then
			GUICtrlSetState($Browse_btn, $GUI_FOCUS)
		Else
			MsgBox(48, "Warning", 'Make sure that the selected folder or drive' & @LF & 'contains proper Windows® installation files.', -1, $hWnd)
			Open_Folder($hWnd, $Folder)
		EndIf
	EndIf
EndFunc   ;==>Open_Folder


Func Open_ISO($hWnd, $ISO)
	Local $7zl = _Install_Files(9) & ' l "'
	Local $7zo = '" > ' & @TempDir & '\'
	Local $Temp = @TempDir & '\'
	Local $list = 'list.txt'
	Local $iGetList, $File, $line
	If $ISO = 's' Then
		$iGetISO = GUICtrlRead($F1Source_inp)
		$iGetList = $7zl & $iGetISO & $7zo & $list
		RunWait(@ComSpec & ' /c ' & $iGetList, @ScriptDir, @SW_HIDE)
		$File = FileOpen($Temp & $list, 0)
		While 1
			$line = FileReadLine($File)
			If @error = -1 Then ExitLoop
			If StringRegExp($line, 'boot\\bootsect.exe', 0) = 1 Then
				$size = FileGetSize($iGetISO)
				GUICtrlSetData($F1Info_lbl, Round(($size) / 1024 / 1024, 1) & ' MB')
				GUICtrlSetFont($F1Info_lbl, 8, 400)
				GUICtrlSetColor($F1Info_lbl, 0x000000)
				GUICtrlSetData($F1Source_inp, $iGetISO)
				GUICtrlSetColor($F1Source_inp, 0x000000)
				$Exit_ISO = 1
				ExitLoop
			EndIf
		WEnd
		FileClose($File)
		FileDelete($Temp & $list)
		If $Exit_ISO = 0 Then
			GUICtrlSetData($F1Info_lbl, 'Make sure that the selected ISO is correct.' & @LF & 'This ISO is not correct.')
			GUICtrlSetFont($F1Info_lbl, 8, 800)
			GUICtrlSetColor($F1Info_lbl, 0xFF0000)
			MsgBox(48, "Warning", 'Make sure that the selected ISO is correct.' & @LF & 'This ISO is not correct.', -1, $hWnd)
			$ISO = 'b'
			Open_ISO($hWnd, $ISO)
		EndIf
	Else
		$Exit_ISO = 0
		$iGetISO = FileOpenDialog("Browse ISO", "", "ISO images (*.iso)", 3, '', $hWnd)
		If $iGetISO = '' Then
			GUICtrlSetState($Open_btn, $GUI_FOCUS)
		ElseIf $iGetISO <> '' Then
			$iGetList = $7zl & $iGetISO & $7zo & $list
			RunWait(@ComSpec & ' /c ' & $iGetList, @ScriptDir, @SW_HIDE)
			$File = FileOpen($Temp & $list, 0)
			While 1
				$line = FileReadLine($File)
				If @error = -1 Then ExitLoop
				If StringRegExp($line, 'boot\\bootsect.exe', 0) = 1 Then
					$size = FileGetSize($iGetISO)
					GUICtrlSetData($F1Info_lbl, Round(($size) / 1024 / 1024, 1) & ' MB')
					GUICtrlSetFont($F1Info_lbl, 8, 400)
					GUICtrlSetColor($F1Info_lbl, 0x000000)
					GUICtrlSetData($F1Source_inp, $iGetISO)
					GUICtrlSetColor($F1Source_inp, 0x000000)
					GUICtrlSetState($F1Next_btn, $GUI_ENABLE)
					GUICtrlSetState($F1Next_btn, $GUI_FOCUS)
					$Exit_ISO = 1
					ExitLoop
				EndIf
			WEnd
			FileClose($File)
			FileDelete($Temp & $list)
			If $Exit_ISO = 0 Then
				MsgBox(48, "Warning", 'Make sure that the selected ISO is correct.' & @LF & 'This ISO is incorrect.', -1, $hWnd)
				$ISO = 'b'
				Open_ISO($hWnd, $ISO)
			EndIf
		EndIf
	EndIf
	FileDelete(@TempDir & '\7z.exe')
	FileDelete(@TempDir & '\7z.dll')
EndFunc   ;==>Open_ISO

Func Extract_ISO($hWnd)
	Local $Temp = @TempDir & '\Temp_Extraction'
	Local $7zx = _Install_Files(9) & ' x "'
	Local $7zo = '" -o"' & $Temp & '" -y'
	Local $extract
	$extract = $7zx & $iGetISO & $7zo
	GUICtrlSetData($Status, 'Extracting ...')
	RunWait($extract, @ScriptDir, @SW_HIDE)
	FileDelete(@TempDir & '\7z.exe')
	FileDelete(@TempDir & '\7z.dll')
	Return $Temp
EndFunc   ;==>Extract_ISO

Func Check_USB($hWnd)
	Global $usbl, $usbb
	Local $iGetRemovable, $TotalSpace, $FreeSpace, $FileSystem, $DriveLabel
	$Error = ''
	GUICtrlSetData($USBDrives_cmb, '')
	$iGetRemovable = DriveGetDrive("REMOVABLE")
	If @error Then
		$Error = 1
	Else
		For $i = 1 To $iGetRemovable[0]
			If $iGetRemovable[$i] = "a:" Or $iGetRemovable[$i] = "b:" Then
				$Error = 1
			ElseIf (DriveStatus($iGetRemovable[$i])) = "READY" Then
				$TotalSpace = DriveSpaceTotal($iGetRemovable[$i])
				$FreeSpace = DriveSpaceFree($iGetRemovable[$i])
				$FileSystem = DriveGetFileSystem($iGetRemovable[$i])
				$DriveLabel = DriveGetLabel($iGetRemovable[$i])
				If Round(($TotalSpace), 0) < Round(($size / 1024 / 1024), 0) Then
					GUICtrlSetData($F2DeviceInfo_lbl, 'Drive: ' & @TAB & @TAB & (StringUpper($iGetRemovable[$i])) & @LF & _
							'Name: ' & @TAB & $DriveLabel & @LF & _
							'Capacity:' & @TAB & (Round(($TotalSpace / 1024), 1)) & ' GB' & @LF & _
							'Free: ' & @TAB & @TAB & (Round(($FreeSpace / 1024), 1)) & ' GB' & @LF & _
							'Can not be used because :' & @LF & _
							'source(' & Round(($size / 1024 / 1024), 0) & ' MB) is bigger than drive capacity(' & Round(($TotalSpace), 0) & ') MB')
					$Error = 1
				Else
					GUICtrlSetData($USBDrives_cmb, (StringUpper($iGetRemovable[$i])) & "  Capacity: " & (Round(($TotalSpace / 1024), 0)) & " GB " & "Free: " & (Round($FreeSpace, 0)) & " MB", (StringUpper($iGetRemovable[$i])) & "  Capacity: " & (Round(($TotalSpace / 1024), 0)) & " GB " & "Free: " & (Round($FreeSpace, 0)) & " MB")
					GUICtrlSetData($F2DeviceInfo_lbl, 'Drive: ' & @TAB & @TAB & (StringUpper($iGetRemovable[$i])) & @LF & _
							'Name: ' & @TAB & $DriveLabel & @LF & _
							'Capacity:' & @TAB & (Round(($TotalSpace / 1024), 1)) & ' GB' & @LF & _
							'Free: ' & @TAB & @TAB & (Round(($FreeSpace / 1024), 1)) & ' GB')
					GUICtrlSetFont($F2DeviceInfo_lbl, 8, 400)
					GUICtrlSetColor($F2DeviceInfo_lbl, 0x000000)
					$Error = 0
				EndIf
			Else
				GUICtrlSetData($F2DeviceInfo_lbl, "Drive " & (StringUpper($iGetRemovable[$i])) & "\ may be unformated (RAW)." & @CRLF & "Format it first then use this tool.")
			EndIf
		Next
	EndIf
	If $Error = 0 Then
		GUICtrlSetState($F2Next_btn, $GUI_ENABLE)
		GUICtrlSetState($F2Next_btn, $GUI_DEFBUTTON)
	Else
		GUICtrlSetData($USBDrives_cmb, 'Please check USB drives', 'Please check USB drives')
		GUICtrlSetData($F2DeviceInfo_lbl, 'No USB drives found.' & @LF & 'Connect USB drive and check.')
		GUICtrlSetFont($F2DeviceInfo_lbl, 8, 800)
		GUICtrlSetColor($F2DeviceInfo_lbl, 0xFF0000)
		GUICtrlSetState($USBCheck_btn, $GUI_DEFBUTTON)
		GUICtrlSetState($F2Next_btn, $GUI_DISABLE)
		GUICtrlSetState($USBCheck_btn, $GUI_FOCUS)
		GUICtrlSetState($USBCheck_btn, $GUI_DEFBUTTON)
	EndIf
	Return $Error
EndFunc   ;==>Check_USB

Func Check_USB_Files($hWnd)
	Local $search
	$Error = ''
	$search = FileFindFirstFile($usbsel & '\' & '*.*')
	If $search = 1 Then
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox(308, "Warning", "All data will be erased." & @LF & 'Make sure to backup your data.' & @LF & 'Would you like to continue?', 0, $hWnd)
		Select
			Case $iMsgBoxAnswer = 6
				$Error = 0
			Case $iMsgBoxAnswer = 7
				$Error = 1
			Case $iMsgBoxAnswer = -1

		EndSelect
	EndIf

	FileClose($search)
	Return $Error
EndFunc   ;==>Check_USB_Files


Func Format_USB($hWnd)
	Local $Convert, $Replace, $format_com
	GUICtrlSetData($Status, 'Initializing ...')
	$Replace = StringRegExpReplace(GUICtrlRead($F3Label_inp), '[ /^<>]', '_')
	If $IsWin2K = True Then
		GUICtrlSetData($Progress, 10)
		GUICtrlSetData($Status, 'Formatting ...')
		GUICtrlSetData($Progress, 20)
		$format_com = 'format ' & $usbsel & ' /FS:NTFS /V:' & $Replace & ' /Q /X'
		GUICtrlSetData($Progress, 30)
		$PID = Run(@ComSpec & ' /c ' & $format_com, @ScriptDir, @SW_HIDE)
		GUICtrlSetData($Progress, 40)
		WinWait("[CLASS:ConsoleWindowClass]")
		GUICtrlSetData($Progress, 50)
		ControlSend("[CLASS:ConsoleWindowClass]", "", "", "{enter}")
		GUICtrlSetData($Progress, 60)
		ProcessWaitClose($PID)
		GUICtrlSetData($Progress, 70)
	ElseIf $IsWinXP = True Then
		GUICtrlSetData($Progress, 10)
		GUICtrlSetData($Status, 'Formatting .')
		GUICtrlSetData($Progress, 20)
		$format_com = 'format ' & $usbsel & ' /FS:FAT32 /Q /X /Y'
		GUICtrlSetData($Progress, 30)
		$PID = RunWait(@ComSpec & ' /c ' & $format_com, @ScriptDir, @SW_HIDE)
		GUICtrlSetData($Progress, 40)
		GUICtrlSetData($Status, 'Formatting ..')
		GUICtrlSetData($Progress, 50)
		$Convert = 'convert ' & $usbsel & ' /FS:NTFS /X'
		GUICtrlSetData($Progress, 60)
		$PID = RunWait(@ComSpec & ' /c ' & $Convert, @ScriptDir, @SW_HIDE)
		GUICtrlSetData($Progress, 70)
		GUICtrlSetData($Status, 'Formatting ...')
		GUICtrlSetData($Progress, 80)
		DriveSetLabel($usbsel, $Replace)
		GUICtrlSetData($Progress, 90)
	Else
		GUICtrlSetData($Status, 'Formatting ...')
		GUICtrlSetData($Progress, 25)
		$format_com = 'format ' & $usbsel & ' /FS:NTFS /V:' & $Replace & ' /Q /X /Y'
		GUICtrlSetData($Progress, 50)
		$PID = RunWait(@ComSpec & ' /c ' & $format_com, @ScriptDir, @SW_HIDE)
		GUICtrlSetData($Progress, 75)
	EndIf
	GUICtrlSetData($Progress, 100)
	GUICtrlSetData($Status, 'Formatting done.')
EndFunc   ;==>Format_USB


Func _Make_Bootable($hWnd, $iGetFolder)
	GUICtrlSetData($Status, 'Making bootable ...')
	RunWait($iGetFolder & '\boot\bootsect.exe /nt60 ' & $usbsel & ' /force /mbr', @ScriptDir, @SW_HIDE)
	GUICtrlSetData($Progress, 100)
	GUICtrlSetData($Status, 'Bootable done.')
EndFunc   ;==>_Make_Bootable


#Region ### External Function
Func _CopyDirWithProgress($sOriginalDir, $sDestDir)

	If StringRight($sOriginalDir, 1) <> '\' Then $sOriginalDir = $sOriginalDir & '\'
	If StringRight($sDestDir, 1) <> '\' Then $sDestDir = $sDestDir & '\'
	If $sOriginalDir = $sDestDir Then Return -1

	Local $aFileList = _FileSearch($sOriginalDir)
	If $aFileList[0] = 0 Then
		SetError(1)
		Return -1
	EndIf

	If FileExists($sDestDir) Then
		If Not StringInStr(FileGetAttrib($sDestDir), 'd') Then
			SetError(2)
			Return -1
		EndIf
	Else
		DirCreate($sDestDir)
		If Not FileExists($sDestDir) Then
			SetError(2)
			Return -1
		EndIf
	EndIf

	Local $iDirSize, $iCopiedSize = 0, $fProgress = 0
	Local $c, $FileName, $iOutPut = 0, $sLost = '', $sError
	Local $Sl = StringLen($sOriginalDir)

	_Quick_Sort($aFileList, 1, $aFileList[0])

	$iDirSize = Round((DirGetSize($sOriginalDir) / 1024 / 1024), 1)

	For $c = 1 To $aFileList[0]
		$FileName = StringTrimLeft($aFileList[$c], $Sl)
		GUICtrlSetData($Progress, Round(($fProgress * 100), 0))
		GUICtrlSetData($Status, 'Copying files ...')
		GUICtrlSetData($Percentage, 'Progress : ' & Round($fProgress * 100, 1) & ' %   ')
		GUICtrlSetData($NFiles, 'Files : ' & $c & '/' & $aFileList[0])
		GUICtrlSetData($Source, 'From : ' & StringLeft($aFileList[$c], 3) & '...\' & $FileName)
		GUICtrlSetData($Target, 'To : ' & $sDestDir & $FileName)
		GUICtrlSetData($TotalSpaceSize, 'Total : ' & $iDirSize & ' MB')
		GUICtrlSetData($TransferSize, 'Done : ' & Round($iCopiedSize, 1) & ' MB')
		If StringInStr(FileGetAttrib($aFileList[$c]), 'd') Then
			DirCreate($sDestDir & $FileName)
		Else
			If Not FileCopy($aFileList[$c], $sDestDir & $FileName, 1) Then
				If Not FileCopy($aFileList[$c], $sDestDir & $FileName, 1) Then;Tries a second time
					If RunWait(@ComSpec & ' /c copy /y "' & $aFileList[$c] & '" "' & $sDestDir & $FileName & '">' & @TempDir & '\o.tmp', '', @SW_HIDE) = 1 Then;and a third time, but this time it takes the error message
						$sError = FileReadLine(@TempDir & '\o.tmp', 1)
						$iOutPut = $iOutPut + 1
						$sLost = $sLost & $aFileList[$c] & '  ' & $sError & @CRLF
					EndIf
					FileDelete(@TempDir & '\o.tmp')
				EndIf
			EndIf

			$iCopiedSize = $iCopiedSize + FileGetSize($aFileList[$c]) / 1024 / 1024
			$fProgress = $iCopiedSize / $iDirSize
		EndIf
	Next


	If $sLost <> '' Then;tries to write the log somewhere.
		If FileWrite($sDestDir & 'notcopied.txt', $sLost) = 0 Then
			MsgBox(0, '', $sDestDir & 'notcopied.txt')
			If FileWrite($sOriginalDir & 'notcopied.txt', $sLost) = 0 Then
				MsgBox(0, '', $sOriginalDir & 'notcopied.txt')
				FileWrite(@WorkingDir & '\notcopied.txt', $sLost)
				MsgBox(0, '', @WorkingDir & '\notcopied.txt')
			EndIf
		EndIf
	EndIf

	Return $iOutPut
EndFunc   ;==>_CopyDirWithProgress

Func _FileSearch($sIstr, $bSF = 1)
	Local $sCriteria, $sBuffer, $iH, $iH2, $sCS, $sCF, $sCF2, $sCP, $sFP, $sOutPut = '', $aNull[1]
	$sCP = StringLeft($sIstr, StringInStr($sIstr, '\', 0, -1))
	If $sCP = '' Then $sCP = @WorkingDir & '\'
	$sCriteria = StringTrimLeft($sIstr, StringInStr($sIstr, '\', 0, -1))
	If $sCriteria = '' Then $sCriteria = '*.*'

	;To begin we seek in the starting path.
	$sCS = FileFindFirstFile($sCP & $sCriteria)
	If $sCS <> -1 Then
		Do
			$sCF = FileFindNextFile($sCS)
			If @error Then
				FileClose($sCS)
				ExitLoop
			EndIf
			If $sCF = '.' Or $sCF = '..' Then ContinueLoop
			$sOutPut = $sOutPut & $sCP & $sCF & @LF
		Until 0
	EndIf

	;And after, if needed, in the rest of the folders.
	If $bSF = 1 Then
		$sBuffer = @CR & $sCP & '*' & @LF;The buffer is set for keeping the given path plus a *.
		Do
			$sCS = StringTrimLeft(StringLeft($sBuffer, StringInStr($sBuffer, @LF, 0, 1) - 1), 1);current search.
			$sCP = StringLeft($sCS, StringInStr($sCS, '\', 0, -1));Current search path.
			$iH = FileFindFirstFile($sCS)
			If $iH <> -1 Then
				Do
					$sCF = FileFindNextFile($iH)
					If @error Then
						FileClose($iH)
						ExitLoop
					EndIf
					If $sCF = '.' Or $sCF = '..' Then ContinueLoop
					If StringInStr(FileGetAttrib($sCP & $sCF), 'd') Then
						$sBuffer = @CR & $sCP & $sCF & '\*' & @LF & $sBuffer;Every folder found is added in the begin of buffer
						$sFP = $sCP & $sCF & '\';                               for future searches
						$iH2 = FileFindFirstFile($sFP & $sCriteria);         and checked with the criteria.
						If $iH2 <> -1 Then
							Do
								$sCF2 = FileFindNextFile($iH2)
								If @error Then
									FileClose($iH2)
									ExitLoop
								EndIf
								If $sCF2 = '.' Or $sCF2 = '..' Then ContinueLoop
								$sOutPut = $sOutPut & $sFP & $sCF2 & @LF;Found items are put in the Output.
							Until 0
						EndIf
					EndIf
				Until 0
			EndIf
			$sBuffer = StringReplace($sBuffer, @CR & $sCS & @LF, '')
		Until $sBuffer = ''
	EndIf

	If $sOutPut = '' Then
		$aNull[0] = 0
		Return $aNull
	Else
		Return StringSplit(StringTrimRight($sOutPut, 1), @LF)
	EndIf
EndFunc   ;==>_FileSearch

Func _Quick_Sort(ByRef $SortArray, $First, $Last);Larry's code
	Dim $Low, $High
	Dim $Temp, $List_Separator

	$Low = $First
	$High = $Last
	$List_Separator = StringLen($SortArray[($First + $Last) / 2])
	Do
		While (StringLen($SortArray[$Low]) < $List_Separator)
			$Low = $Low + 1
		WEnd
		While (StringLen($SortArray[$High]) > $List_Separator)
			$High = $High - 1
		WEnd
		If ($Low <= $High) Then
			$Temp = $SortArray[$Low]
			$SortArray[$Low] = $SortArray[$High]
			$SortArray[$High] = $Temp
			$Low = $Low + 1
			$High = $High - 1
		EndIf
	Until $Low > $High
	If ($First < $High) Then _Quick_Sort($SortArray, $First, $High)
	If ($Low < $Last) Then _Quick_Sort($SortArray, $Low, $Last)
EndFunc   ;==>_Quick_Sort
#EndRegion ### External Function