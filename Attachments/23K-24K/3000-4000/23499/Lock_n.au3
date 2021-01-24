#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Lock'n.ico
#AutoIt3Wrapper_Outfile=Lock'n.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=Lock'n 1.4
#AutoIt3Wrapper_Res_Description=d3mon Corporation
#AutoIt3Wrapper_Res_Fileversion=1.4
#AutoIt3Wrapper_Res_LegalCopyright=d3mon Corporation. All rights Reserved.
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;===============================================================================
; Script Name: Lock'n
; Author(s): d3mon Corporation
; Copyright : All functions in this script writted by me (without other autor)
; must be used or copied with my name on top
;===============================================================================

Opt("WinTitleMatchMode", 2)
Opt("GuiOnEventMode", 1)
Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <WinApi.au3>
#include <String.au3>
#include <Misc.au3>
_ReduceMemory(@ScriptName)

FileInstall("Lock'n.bmp", @TempDir & "\Lock'n.bmp", 1)
TraySetToolTip("Lock'n <d3montools>" & @CRLF & "Initializing...")

#Region First launch --------------------------------------
If (FileRead(@TempDir & "\FolderLock.txt") = "") Then
	FileDelete(@TempDir & "\FolderLock.txt")
	FileWrite(@TempDir & "\FolderLock.txt", "Lock'n 1.4| 0|")
	FileSetAttrib(@TempDir & "\FolderLock.txt", "+SH")
EndIf

If (FileRead(@TempDir & "\ClassLock.txt") = "") Then
	FileDelete(@TempDir & "\ClassLock.txt")
	FileWrite(@TempDir & "\ClassLock.txt", "Lock'n 1.4| 0|")
	FileSetAttrib(@TempDir & "\ClassLock.txt", "+SH")
EndIf

If (FileRead(@TempDir & "\FileLock.txt") = "") Then
	FileDelete(@TempDir & "\FileLock.txt")
	FileWrite(@TempDir & "\FileLock.txt", "Lock'n 1.4| 0|")
	FileSetAttrib(@TempDir & "\FileLock.txt", "+SH")
EndIf
#EndRegion First launch --------------------------------------

#Region CPU---------------------------------------------------
;===============================================================================
; Function Name: _GetSysTime / _CPUCalc
; Author(s): rasim
;===============================================================================
Local $IDLETIME, $KERNELTIME, $USERTIME
Local $StartIdle, $StartKernel, $StartUser
Local $EndIdle, $EndKernel, $EndUser

$IDLETIME = DllStructCreate("dword;dword")
$KERNELTIME = DllStructCreate("dword;dword")
$USERTIME = DllStructCreate("dword;dword")

Func _GetSysTime(ByRef $sIdle, ByRef $sKernel, ByRef $sUser)
	DllCall("kernel32.dll", "int", "GetSystemTimes", "ptr", DllStructGetPtr($IDLETIME), _
			"ptr", DllStructGetPtr($KERNELTIME), _
			"ptr", DllStructGetPtr($USERTIME))

	$sIdle = DllStructGetData($IDLETIME, 1)
	$sKernel = DllStructGetData($KERNELTIME, 1)
	$sUser = DllStructGetData($USERTIME, 1)
EndFunc   ;==>_GetSysTime

Func _CPUCalc()
	Local $iSystemTime, $iTotal, $iCalcIdle, $iCalcKernel, $iCalcUser

	$iCalcIdle = ($EndIdle - $StartIdle)
	$iCalcKernel = ($EndKernel - $StartKernel)
	$iCalcUser = ($EndUser - $StartUser)

	$iSystemTime = ($iCalcKernel + $iCalcUser)
	$iTotal = Int(($iSystemTime - $iCalcIdle) * (100 / $iSystemTime)) & "%"

	Global $CPUCalc = $iTotal
EndFunc   ;==>_CPUCalc
#EndRegion CPU---------------------------------------------------

#Region Global---------------------------------------------
Global $FolderLock = FileRead(@TempDir & "\FolderLock.txt")
Global $FileLock = FileRead(@TempDir & "\FileLock.txt")

Global $LockPW = _StringEncrypt(0, FileRead(@SystemDir & "\Lock'n.txt"), "d3mon Corporation", 3)

Global $FOLDERLOCKSTATUS = True
Global $FILELOCKSTATUS = True
Global $DESKTOPLOCKSTATUS = False

Global $LOCKN = True
Global $CECO = False

Local $CPW, $PWD, $Lpw, $GUI, $Timer, $Run, $Saverlist1, $Saverlist2, $ECO, $CPUCalc, $CPU, $MEM

If (FileReadLine(@TempDir & "\Lock'n-Lock.txt", 1) = "1") Then
	RegWrite("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system", "DisableTaskMgr", "REG_DWORD", "1")
EndIf

If (FileReadLine(@TempDir & "\Lock'n-Lock.txt", 2) = "1") Then
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", "REG_DWORD", "1")
EndIf
#EndRegion Global---------------------------------------------

#Region Lock'n Desktop -------------------------------------------------------------
Func _GUI()
	$GUI = GUICreate("Lock'n <d3montools>", @DesktopWidth + 100, @DesktopHeight + 100, -50, -50, $WS_POPUP + $WS_BORDER, $WS_EX_TOPMOST)
	WinSetTrans($GUI, "", 25)
	GUISetBkColor(0xFFFFFF, $GUI)
	GUISetState(@SW_SHOW, $GUI)
EndFunc   ;==>_GUI

Func _Dsktop()
	$DESKTOPWND = GUICreate("Lock'n Desktop <d3montools>", 170, 14, 50, 50, $WS_BORDER + $WS_POPUP, $WS_EX_TOPMOST, $GUI)
	GUICtrlCreateLabel("Lock'n Desktop <d3montools> v1.4", 0, 0, 200, 17)
	GUISetState(@SW_SHOW, $DESKTOPWND)
EndFunc   ;==>_Dsktop
#EndRegion Lock'n Desktop -------------------------------------------------------------

#Region TRAY------------------------------------------------
$MenuTray = TrayCreateMenu(">>")
TrayCreateItem("Lock'n")
TrayItemSetOnEvent(-1, "_Newpassword")
TrayCreateItem("")
TrayCreateItem("About...")
TrayItemSetOnEvent(-1, "_About")
TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_Exit")

$DesktopTray = TrayCreateMenu("Desktop", $MenuTray)
TrayCreateItem("Enable Lock", $DesktopTray)
TrayItemSetOnEvent(-1, "_DESKTOPELOCK")

$DesktopTray = TrayCreateMenu("Stop-saver", $MenuTray)
TrayCreateItem("Enable Stop", $DesktopTray)
TrayItemSetOnEvent(-1, "_PasswordStopsaver")

$FileTray = TrayCreateMenu("File", $MenuTray)
$FILEELOCK = TrayCreateItem("Enable Lock", $FileTray)
TrayItemSetState($FILEELOCK, $TRAY_CHECKED)
TrayItemSetOnEvent($FILEELOCK, "_FILEELOCK")
$FILEDLOCK = TrayCreateItem("Disable Lock", $FileTray)
TrayItemSetOnEvent($FILEDLOCK, "_FILEDLOCK")
TrayCreateItem("File Lock...", $FileTray)
TrayItemSetOnEvent(-1, "_FileLock")


$FolderTray = TrayCreateMenu("Folder", $MenuTray)
$FOLDERELOCK = TrayCreateItem("Enable Lock", $FolderTray)
TrayItemSetState($FOLDERELOCK, $TRAY_CHECKED)
TrayItemSetOnEvent($FOLDERELOCK, "_FOLDERELOCK")
$FOLDERDLOCK = TrayCreateItem("Disable Lock", $FolderTray)
TrayItemSetOnEvent($FOLDERDLOCK, "_FOLDERDLOCK")
TrayCreateItem("Folder Lock...", $FolderTray)
TrayItemSetOnEvent(-1, "_FolderLock")
#EndRegion TRAY------------------------------------------------

#Region About wnd -------------------------------------------
$About = GUICreate("Lock'n About v1.4", 350, 200, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUICtrlCreatePic(@TempDir & "\Lock'n.bmp", 5, 5, 90, 90)
GUISetBkColor("0xFFFFFF", $About)
GUICtrlCreateLabel("Lock'n - d3mon Corporation", 100, 10, 300, 25)
GUICtrlSetFont(-1, 12, 400, 1, "Comic Sans MS")
GUICtrlCreateLabel("Contact : d3mon@live.fr", 20, 100, 300, 25)
GUICtrlSetFont(-1, 10)
GUICtrlCreateLabel("[Lock'n > File && Folder && Desktop !]", 20, 120, 330, 25)
GUICtrlSetFont(-1, 10)
GUICtrlCreateLabel("Thanks to Autoit Script", 20, 140, 300, 25)
GUICtrlSetFont(-1, 10)

$startup = GUICtrlCreateCheckbox("Run on start-up", 115, 30, 300, 25)
GUICtrlSetFont(-1, 10)
$taskmgr = GUICtrlCreateCheckbox("Lock taskmgr", 115, 50, 300, 25)
GUICtrlSetFont(-1, 10)
$regedit = GUICtrlCreateCheckbox("Lock regedit", 115, 70, 300, 25)
GUICtrlSetFont(-1, 10)

GUICtrlCreateButton("OK", 100, 170, 150, 25)
GUICtrlSetOnEvent(-1, "_AboutClose")
WinSetTrans($About, "", 220)
GUISetState(@SW_HIDE, $About)
#EndRegion About wnd -------------------------------------------


#Region Folder Lock wnd ----------------------------------------
$Folderwnd = GUICreate("Lock'n Folder <d3montools>", 350, 310, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
$Folder = GUICtrlCreateEdit("", 5, 5, 315, 17, $ES_AUTOVSCROLL)
GUICtrlCreateButton("...", 325, 5, 20, 17)
GUICtrlSetOnEvent(-1, "_FolderAdd")
$Folderlist = GUICtrlCreateListView("Folder|Nb", 5, 28, 340, 100)
GUICtrlSendMsg(-1, 0x101E, 0, 298)
GUICtrlSendMsg(-1, 0x101E, 1, 37)

$Classfolder = GUICtrlCreateEdit("", 5, 147, 340, 17, $ES_AUTOVSCROLL)
$Classlist = GUICtrlCreateListView("FolderName|Nb", 5, 170, 340, 100)
GUICtrlSendMsg(-1, 0x101E, 0, 298)
GUICtrlSendMsg(-1, 0x101E, 1, 37)

GUICtrlCreateLabel("[ENTER] Add item", 5, 285)
GUICtrlCreateLabel("[DEL] del item", 274, 285)

GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -22, 237, 277, 32, 32)
GUICtrlSetOnEvent(-1, "_CLASSSHOW")

GUICtrlCreateButton("OK", 100, 280, 130, 25)
GUICtrlSetOnEvent(-1, "_FolderHIDE")
GUISetState(@SW_HIDE, $Folderwnd)
#EndRegion Folder Lock wnd ----------------------------------------

#Region CLASS-------------------------------------------------
$wndCLASS = GUICreate("Lock'n CLASS <d3montools>", 155, 185, -1, -1, -1, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
GUISetOnEvent($GUI_EVENT_CLOSE, "_CLASSHIDE")

$C1 = GUICtrlCreateCheckbox("Explorer Windows [Folder]", 5, 5)
$C2 = GUICtrlCreateCheckbox("Mozilla Firefox [Internet]", 5, 25)
$C3 = GUICtrlCreateCheckbox("Opera Software [Internet]", 5, 45)
$C4 = GUICtrlCreateCheckbox("Internet Explorer [Internet]", 5, 65)
$C5 = GUICtrlCreateCheckbox("Instant Messenger [MSN]", 5, 85)
$C6 = GUICtrlCreateCheckbox("Instant Messenger [Skype]", 5, 105)

GUICtrlCreateButton("Add...", 5, 130, 40, 20)
GUICtrlSetOnEvent(-2, "_NEWCLASS")
$CLASS = GUICtrlCreateEdit("", 50, 132, 85, 17, $ES_AUTOVSCROLL)

GUICtrlCreateButton("OK", 5, 155, 140, 25)
GUICtrlSetOnEvent(-1, "_ADDCLASS")
GUISetState(@SW_HIDE, $wndCLASS)
#EndRegion CLASS-------------------------------------------------

#Region File Lock wnd ----------------------------------------
$Filewnd = GUICreate("Lock'n Process <d3montools>", 350, 310, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
$File = GUICtrlCreateEdit("", 5, 5, 315, 17, $ES_AUTOVSCROLL)
GUICtrlCreateButton("...", 325, 5, 20, 17)
GUICtrlSetOnEvent(-1, "_FileAdd")
$Filelist = GUICtrlCreateListView("Process|Nb", 5, 28, 340, 240)
GUICtrlSendMsg(-1, 0x101E, 0, 298)
GUICtrlSendMsg(-1, 0x101E, 1, 37)

GUICtrlCreateLabel("[ENTER] Add item", 5, 285)
GUICtrlCreateLabel("[DEL] del item", 274, 285)

GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -3, 237, 277, 32, 32)
GUICtrlSetOnEvent(-1, "_PIDSHOW")

GUICtrlCreateButton("OK", 100, 280, 130, 25)
GUICtrlSetOnEvent(-1, "_FileHIDE")
GUISetState(@SW_HIDE, $Filewnd)
#EndRegion File Lock wnd ----------------------------------------

#Region PID wnd ----------------------------------------------
$wndPID = GUICreate("Lock'n Process List <d3montools>", 250, 250, -1, -1, -1, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUISetOnEvent($GUI_EVENT_CLOSE, "_PIDHIDE")
$PIDlist = GUICtrlCreateListView("Process [F5 refresh list]|ID", 5, 5, 240, 240)
GUICtrlSendMsg(-1, 0x101E, 0, 180)
GUICtrlSendMsg(-1, 0x101E, 1, 40)

GUISetState(@SW_HIDE, $wndPID)
#EndRegion PID wnd ----------------------------------------------


While 1
	#Region FOLDER LOCK--------------------------------------------------
	If $FOLDERLOCKSTATUS = True And $LOCKN = True Then
		$array = StringSplit(FileRead(@TempDir & "\FolderLock.txt"), "//")
		For $nbarray = 1 To $array[0]
			If Not @error And ($array[$nbarray] <> "") And $LOCKN = True Then
				If WinExists(StringTrimRight($array[$nbarray], 4), "") Then
					WinSetState(StringTrimRight($array[$nbarray], 4), "", @SW_HIDE)
					Global $LOCKED = StringTrimRight($array[$nbarray], 4)
					Global $FOLDERLOCKSTATUS = False
					Global $LOCKN = False
					_PasswordFolder()
				EndIf
			EndIf
		Next
	EndIf

	If $FOLDERLOCKSTATUS = True And $LOCKN = True Then
		$array = StringSplit(FileRead(@TempDir & "\ClassLock.txt"), "//")
		For $nbarray = 1 To $array[0]
			If Not @error And ($array[$nbarray] <> "") And $LOCKN = True Then
				If WinExists(StringTrimRight($array[$nbarray], 4), "") Then
					WinSetState(StringTrimRight($array[$nbarray], 4), "", @SW_HIDE)
					Global $LOCKED = StringTrimRight($array[$nbarray], 4)
					Global $FOLDERLOCKSTATUS = False
					Global $LOCKN = False
					_PasswordFolder()
				EndIf
			EndIf
		Next
	EndIf
	#EndRegion FOLDER LOCK--------------------------------------------------

	#Region FILE LOCK----------------------------------------------------
	If $FILELOCKSTATUS = True And $LOCKN = True Then
		$array = StringSplit(FileRead(@TempDir & "\FileLock.txt"), "//")
		For $nbarray = 1 To $array[0]
			If Not @error And ($array[$nbarray] <> "") And $LOCKN = True Then
				If ProcessExists(StringTrimRight($array[$nbarray], 4)) Then
					_ProcessSuspend(StringTrimRight($array[$nbarray], 4))
					Global $LOCKED = StringTrimRight($array[$nbarray], 4)
					Global $FILELOCKSTATUS = False
					Global $LOCKN = False
					TrayItemSetState($FILEELOCK, $TRAY_UNCHECKED)
					TrayItemSetState($FILEDLOCK, $TRAY_CHECKED)
					_PasswordFile()
				EndIf
			EndIf
		Next
	EndIf
	#EndRegion FILE LOCK----------------------------------------------------

	#Region DESKTOP LOCK-------------------------------------------------
	If $DESKTOPLOCKSTATUS = True _
			And $LOCKN = True Then
		_LOCKDESKTOP()
		Global $LOCKN = False
	EndIf
	#EndRegion DESKTOP LOCK-------------------------------------------------

	#Region Folder---------------------------------------------------
	If WinActive($Folderwnd, "") Then
		If _IsPressed("0D") Then
			If GUICtrlRead($Folder) <> "" Then
				$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\FolderLock.txt"), 2), 1)
				GUICtrlCreateListViewItem(GUICtrlRead($Folder) & "| " & $NB + 1, $Folderlist)
				FileWrite(@TempDir & "\FolderLock.txt", "//" & GUICtrlRead($Folder) & "| " & $NB + 1 & "|")
				GUICtrlSetData($Folder, "") ;---------------------------------------------
				Sleep(150) ;-----------------------------------
			ElseIf GUICtrlRead($Classfolder) <> "" Then
				$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\ClassLock.txt"), 2), 1)
				GUICtrlCreateListViewItem(GUICtrlRead($Classfolder) & "| " & $NB + 1, $Classlist)
				FileWrite(@TempDir & "\ClassLock.txt", "//" & GUICtrlRead($Classfolder) & "| " & $NB + 1 & "|")
				GUICtrlSetData($Classfolder, "") ;---------------------------------------------
				Sleep(150) ;-----------------------------------
			EndIf
		ElseIf _IsPressed("2E") Then
			If GUICtrlRead(GUICtrlRead($Folderlist)) <> "" Then
				$FolderR = StringReplace(FileRead(@TempDir & "\FolderLock.txt"), "//" & GUICtrlRead(GUICtrlRead($Folderlist)), "")
				FileDelete(@TempDir & "\FolderLock.txt")
				FileWrite(@TempDir & "\FolderLock.txt", $FolderR)
				FileSetAttrib(@TempDir & "\FolderLock.txt", "+SH")
				_FolderRefresh()
			ElseIf GUICtrlRead(GUICtrlRead($Classlist)) <> "" Then
				$ClassR = StringReplace(FileRead(@TempDir & "\ClassLock.txt"), "//" & GUICtrlRead(GUICtrlRead($Classlist)), "")
				FileDelete(@TempDir & "\ClassLock.txt")
				FileWrite(@TempDir & "\ClassLock.txt", $ClassR)
				FileSetAttrib(@TempDir & "\ClassLock.txt", "+SH")
				_ClassRefresh()
			EndIf
			Sleep(150) ;--------------------------------------------------
		EndIf
	EndIf
	#EndRegion Folder---------------------------------------------------

	#Region File-----------------------------------------------------
	If WinActive($Filewnd, "") Then
		If _IsPressed("0D") Then
			If GUICtrlRead($File) <> "" Then
				$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\FileLock.txt"), 2), 1)
				GUICtrlCreateListViewItem(GUICtrlRead($File) & "| " & $NB + 1, $Filelist)
				FileWrite(@TempDir & "\FileLock.txt", "//" & GUICtrlRead($File) & "| " & $NB + 1 & "|")
				GUICtrlSetData($File, "") ;---------------------------------------------
				Sleep(150) ;-----------------------------------
			EndIf
		ElseIf _IsPressed("2E") Then
			If GUICtrlRead(GUICtrlRead($Filelist)) <> "" Then
				$FileR = StringReplace(FileRead(@TempDir & "\FileLock.txt"), "//" & GUICtrlRead(GUICtrlRead($Filelist)), "")
				FileDelete(@TempDir & "\FileLock.txt")
				FileWrite(@TempDir & "\FileLock.txt", $FileR)
				FileSetAttrib(@TempDir & "\FileLock.txt", "+SH")
				_FileRefresh()
			EndIf
			Sleep(150) ;--------------------------------------------------
		EndIf
	EndIf
	#EndRegion File-----------------------------------------------------

	#Region Proces List----------------------------------------------
	If WinActive($wndPID, "") Then
		If _IsPressed("74") Then
			_PIDRefresh()
		EndIf
	EndIf
	#EndRegion Proces List----------------------------------------------

	#Region WinExists------------------------------------------------
	If WinExists("Desktop Lock <d3montools>", "") _
			Or WinExists("File Lock <d3montools>", "") _
			Or WinExists("Folder Lock <d3montools>", "") _
			Or WinExists("Stop-saver Lock <d3montools>", "") Then

		If WinExists("[CLASS:DV2ControlHost]", "") Then
			WinSetState("[CLASS:DV2ControlHost]", "", @SW_DISABLE)
			WinSetTrans("[CLASS:DV2ControlHost]", "", 0)
		EndIf
		If WinExists("[CLASS:#32771]", "") Then
			WinSetState("[CLASS:#32771]", "", @SW_HIDE)
			WinMinimizeAll() ;-------------------
		EndIf
		
		If WinExists("Desktop Lock <d3montools>", "") Then
			$YZ = WinGetPos("Desktop Lock <d3montools>")
			_MouseTrap($YZ[0] + 4, $YZ[1] + 25, $YZ[0] + $YZ[2] - 2, $YZ[1] + $YZ[3] - 2)
			If _IsPressed("0D") Then
				_UNLOCKPASSWORD()
			EndIf
		EndIf
		
		If WinExists("File Lock <d3montools>", "") Then
			$YZ = WinGetPos("File Lock <d3montools>")
			_MouseTrap($YZ[0] + 4, $YZ[1] + 25, $YZ[0] + $YZ[2] - 2, $YZ[1] + $YZ[3] - 2)
			If _IsPressed("0D") Then
				_UNLOCKFILE()
			EndIf
		EndIf
		
		If WinExists("Folder Lock <d3montools>", "") Then
			$YZ = WinGetPos("Folder Lock <d3montools>")
			_MouseTrap($YZ[0] + 4, $YZ[1] + 25, $YZ[0] + $YZ[2] - 2, $YZ[1] + $YZ[3] - 2)
			If _IsPressed("0D") Then
				_UNLOCKFOLDER()
			EndIf
		EndIf
		
		If WinExists("Stop-saver Lock <d3montools>", "") Then
			$YZ = WinGetPos("Stop-saver Lock <d3montools>")
			_MouseTrap($YZ[0] + 4, $YZ[1] + 25, $YZ[0] + $YZ[2] - 2, $YZ[1] + $YZ[3] - 2)
			If _IsPressed("0D") Then
				_UNLOCKStopsaver()
			EndIf
		EndIf
	EndIf

	If WinExists("Stop-saver Lock <d3montools>", "") Then
		Sleep(300)
		$Diff = StringLeft(TimerDiff($Timer) * 0.001, 4)
		GUICtrlSetData($Run, "Running time : " & $Diff & " sec")

		_GetSysTime($EndIdle, $EndKernel, $EndUser)
		_CPUCalc() ;--------------------------------
		_GetSysTime($StartIdle, $StartKernel, $StartUser)
		GUICtrlSetData($CPU, "CPU : " & $CPUCalc)

		$Stats = MemGetStats()
		GUICtrlSetData($MEM, "Memory : " & $Stats[0] & "%")

		If (GUICtrlRead($ECO) = $GUI_CHECKED) _
				And $CECO = False Then
			GUISetBkColor(0x000000, $GUI)
			WinSetTrans($GUI, "", 255)
			$CECO = True
		ElseIf (GUICtrlRead($ECO) = $GUI_UNCHECKED) _
				And $CECO = True Then
			GUISetBkColor(0xFFFFFF, $GUI)
			WinSetTrans($GUI, "", 25)
			$CECO = False
		EndIf
	EndIf
	#EndRegion WinExists------------------------------------------------

	Sleep(100) ;-------------------------
	TraySetToolTip("Lock'n <d3montools>" & @CRLF & "Desktop Lock " & _
			$DESKTOPLOCKSTATUS & @CRLF & "FileLock " & $FILELOCKSTATUS & @CRLF & "Folder Lock " & $FOLDERLOCKSTATUS)
	TraySetState()
WEnd


#Region About--------------------------------------------------------------------------------------
Func _About()
	$CPW = InputBox("Folder Lock", "Enter password to show about", "", "-", 200, 100)

	If $CPW = $LockPW Then
		GUISetState(@SW_SHOW, $About)
		RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Lock'n")
		If @error Then
			GUICtrlSetState($startup, $GUI_UNCHECKED)
		Else
			GUICtrlSetState($startup, $GUI_CHECKED)
		EndIf

		RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system", "DisableTaskMgr")
		If @error Then
			GUICtrlSetState($taskmgr, $GUI_UNCHECKED)
		Else
			GUICtrlSetState($taskmgr, $GUI_CHECKED)
		EndIf

		RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools")
		If @error Then
			GUICtrlSetState($regedit, $GUI_UNCHECKED)
		Else
			GUICtrlSetState($regedit, $GUI_CHECKED)
		EndIf
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_About

Func _AboutClose()
	FileDelete(@TempDir & "\Lock'n-Lock.txt")
	If (GUICtrlRead($startup) == $GUI_CHECKED) Then
		RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Lock'n", "REG_SZ", @ScriptFullPath)
	Else
		RegDelete("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Lock'n")
	EndIf

	If (GUICtrlRead($taskmgr) == $GUI_CHECKED) Then
		RegWrite("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system", "DisableTaskMgr", "REG_DWORD", "1")
		FileWrite(@TempDir & "\Lock'n-Lock.txt", "1")
	Else
		RegDelete("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system", "DisableTaskMgr")
		FileWrite(@TempDir & "\Lock'n-Lock.txt", "0")
	EndIf

	If (GUICtrlRead($regedit) == $GUI_CHECKED) Then
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", "REG_DWORD", "1")
		FileWrite(@TempDir & "\Lock'n-Lock.txt", @CRLF & "1")
	Else
		RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools")
		FileWrite(@TempDir & "\Lock'n-Lock.txt", @CRLF & "0")
	EndIf

	FileSetAttrib(@TempDir & "\Lock'n-Lock.txt", "+SH")
	GUISetState(@SW_HIDE, $About)
EndFunc   ;==>_AboutClose
#EndRegion About--------------------------------------------------------------------------------------


#Region Desktop------------------------------------------------------------------------------------
Func _DESKTOPELOCK()
	$CPW = InputBox("Desktop Lock", "Enter password to enable Lock !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		Global $DESKTOPLOCKSTATUS = True
		Global $LOCKN = True
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_DESKTOPELOCK

Func _LOCKDESKTOP()
	WinMinimizeAll()
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
	WinSetState("[CLASS:DV2ControlHost]", "", @SW_DISABLE)
	WinSetTrans("[CLASS:DV2ControlHost]", "", 0)
	WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
	WinSetState("Program Manager", "", @SW_HIDE)
	_GUI()
	_Dsktop()

	$XY = WinGetPos("Lock'n Desktop <d3montools>")
	_MouseTrap($XY[0] + 4, $XY[1] + 4, $XY[0] + $XY[2] - 2, $XY[1] + $XY[3] - 2)
	Do ;----------------------
		Sleep(100)
	Until _IsPressed("1B")
	_MouseTrap() ;--------------------------------------------------------
	$CPW = GUICreate("Desktop Lock <d3montools>", 200, 75, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST), $GUI)
	GUICtrlCreateLabel("Enter password to disable lock !", 5, 5, 190, 17)
	Global $PWD = GUICtrlCreateInput("", 5, 25, 190, 17, $ES_PASSWORD + $ES_AUTOHSCROLL)
	$Lpw = GUICtrlCreateLabel("", 110, 54, 100, 17)
	GUICtrlCreateButton("OK", 5, 50, 100, 20)
	GUICtrlSetOnEvent(-1, "_UNLOCKPASSWORD")
	GUISetState(@SW_SHOW, $CPW)

	$YZ = WinGetPos($CPW)
	_MouseTrap($YZ[0] + 4, $YZ[1] + 25, $YZ[0] + $YZ[2] - 2, $YZ[1] + $YZ[3] - 2)
EndFunc   ;==>_LOCKDESKTOP

Func _UNLOCKPASSWORD()
	If Not (GUICtrlRead($PWD) = $LockPW) Then
		GUICtrlSetData($Lpw, "Wrong password !")
	EndIf

	If GUICtrlRead($PWD) = $LockPW Then
		Global $DESKTOPLOCKSTATUS = False
		Global $LOCKN = True
		GUIDelete("Desktop Lock <d3montools>")
		GUIDelete("Lock'n Desktop <d3montools>")
		GUIDelete($GUI) ;----------------------------------
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
		WinSetState("Program Manager", "", @SW_SHOW)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
		WinSetState("[CLASS:DV2ControlHost]", "", @SW_ENABLE)
		WinSetTrans("[CLASS:DV2ControlHost]", "", 255)
		_MouseTrap() ;------------------------------
		TrayTip("Lock'n", "Desktop Lock Disabled !", 2, 1)
	EndIf
EndFunc   ;==>_UNLOCKPASSWORD
#EndRegion Desktop------------------------------------------------------------------------------------


#Region Folder Lock--------------------------------------------------------------------------------
Func _FOLDERELOCK()
	$CPW = InputBox("Folder Lock", "Enter password to enable lock !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		Global $FOLDERLOCKSTATUS = True
		Global $LOCKN = True
		TrayItemSetState($FOLDERDLOCK, $TRAY_UNCHECKED)
		TrayItemSetState($FOLDERELOCK, $TRAY_CHECKED)
		TrayTip("Folder Lock Enabled !", "", 2, 1)
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_FOLDERELOCK

Func _FOLDERDLOCK()
	$CPW = InputBox("Folder Lock", "Enter password to disable lock !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		Global $FOLDERLOCKSTATUS = False
		Global $LOCKN = True
		TrayItemSetState($FOLDERELOCK, $TRAY_UNCHECKED)
		TrayItemSetState($FOLDERDLOCK, $TRAY_CHECKED)
		TrayTip("Lock'n", "Folder Lock Disabled !", 2, 1)
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_FOLDERDLOCK

Func _FolderLock()
	$CPW = InputBox("Folder Lock", "Enter password to have access !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		GUISetState(@SW_SHOW, $Folderwnd)
		_FolderRefresh()
		_ClassRefresh()
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_FolderLock

Func _FolderAdd()
	$FolderLock = FileSelectFolder("Select folder to add", "")

	If @error Then
		MsgBox(4096, "Error", "No folder Selected !")
	Else
		GUICtrlSetData($Folder, $FolderLock)
	EndIf
EndFunc   ;==>_FolderAdd

Func _FolderHIDE()
	GUISetState(@SW_HIDE, $Folderwnd)
EndFunc   ;==>_FolderHIDE

Func _FolderRefresh()
	GUICtrlDelete($Folderlist)
	$array = StringSplit(FileRead(@TempDir & "\FolderLock.txt"), "//")
	$Folderlist = GUICtrlCreateListView("Folder|Nb", 5, 28, 340, 100)
	GUICtrlSendMsg(-1, 0x101E, 0, 298)
	GUICtrlSendMsg(-1, 0x101E, 1, 37)

	For $nbarray = 1 To $array[0]
		If $array[$nbarray] <> "" Then
			GUICtrlCreateListViewItem($array[$nbarray], $Folderlist)
		EndIf
	Next
EndFunc   ;==>_FolderRefresh

Func _ClassRefresh()
	GUICtrlDelete($Classlist)
	$array = StringSplit(FileRead(@TempDir & "\ClassLock.txt"), "//")
	$Classlist = GUICtrlCreateListView("Class name|Nb", 5, 170, 340, 100)
	GUICtrlSendMsg(-1, 0x101E, 0, 298)
	GUICtrlSendMsg(-1, 0x101E, 1, 37)

	For $nbarray = 1 To $array[0]
		If $array[$nbarray] <> "" Then
			GUICtrlCreateListViewItem($array[$nbarray], $Classlist)
		EndIf
	Next
EndFunc   ;==>_ClassRefresh
#EndRegion Folder Lock--------------------------------------------------------------------------------


#Region File Lock-------------------------------------------------------------------------------------
Func _FILEELOCK()
	$CPW = InputBox("File Lock", "Enter password to enable lock !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		Global $FILELOCKSTATUS = True
		Global $LOCKN = True
		TrayItemSetState($FILEDLOCK, $TRAY_UNCHECKED)
		TrayItemSetState($FILEELOCK, $TRAY_CHECKED)
		TrayTip("Lock'n", "File Lock Enabled !", 2, 1)
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_FILEELOCK

Func _FILEDLOCK()
	$CPW = InputBox("File Lock", "Enter password to disable lock !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		Global $FILELOCKSTATUS = False
		Global $LOCKN = True
		TrayItemSetState($FILEELOCK, $TRAY_UNCHECKED)
		TrayItemSetState($FILEDLOCK, $TRAY_CHECKED)
		TrayTip("Lock'n", "File Lock Disabled !", 2, 1)
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_FILEDLOCK

Func _FileLock()
	$CPW = InputBox("File Lock", "Enter password to have access !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		GUISetState(@SW_SHOW, $Filewnd)
		_FileRefresh()
	EndIf
EndFunc   ;==>_FileLock

Func _FileAdd()
	$FileLock = FileOpenDialog("Select file to add", "", "Application (*.exe)|Data (*.dat)", 1 + 2)

	If @error Then
		MsgBox(4096, "Error", "No file Selected !")
	Else
		GUICtrlSetData($File, $FileLock)
	EndIf
EndFunc   ;==>_FileAdd

Func _FileRefresh()
	GUICtrlDelete($Filelist)
	$array = StringSplit(FileRead(@TempDir & "\FileLock.txt"), "//")
	$Filelist = GUICtrlCreateListView("File|Nb", 5, 28, 340, 240)
	GUICtrlSendMsg(-1, 0x101E, 0, 298)
	GUICtrlSendMsg(-1, 0x101E, 1, 37)

	For $nbarray = 1 To $array[0] Step +1
		If $array[$nbarray] <> "" Then
			GUICtrlCreateListViewItem($array[$nbarray], $Filelist)
		EndIf
	Next
EndFunc   ;==>_FileRefresh

Func _FileHIDE()
	GUISetState(@SW_HIDE, $Filewnd)
EndFunc   ;==>_FileHIDE
#EndRegion File Lock-------------------------------------------------------------------------------------


#Region password-----------------------------------------------------------------------------------
Func _Newpassword()
	$CPW = InputBox("Lock'n password", "Enter password to have access !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		$NPW = InputBox("Folder Lock", "Enter new password for Lock'n !", "", "-", 200, 100)
		$APW = InputBox("Folder Lock", "Enter again password for Lock'n !", "", "-", 200, 100)
		If $NPW = $APW Then
			FileDelete(@SystemDir & "\Lock'n.txt")
			FileWrite(@SystemDir & "\Lock'n.txt", _StringEncrypt(1, $NPW, "d3mon Corporation", 3))
			FileSetAttrib(@SystemDir & "\Lock'n.txt", "+SH")

			Global $LockPW = _StringEncrypt(0, FileRead(@SystemDir & "\Lock'n.txt"), "d3mon Corporation", 3)
			FileSetAttrib(@SystemDir & "\Lock'n.txt", "+SH")
			TrayTip("Lock'n", "New password saved !", 2, 1)
		Else
			TrayTip("Lock'n", "Wrong password entered !", 2, 2)
		EndIf
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_Newpassword

Func _PasswordFolder()
	WinMinimizeAll()
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
	WinSetState("[CLASS:DV2ControlHost]", "", @SW_DISABLE)
	WinSetTrans("[CLASS:DV2ControlHost]", "", 0)
	WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
	WinSetState("Program Manager", "", @SW_HIDE)
	_GUI() ;--------------------------------

	$CPW = GUICreate("Folder Lock <d3montools>", 200, 85, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST), $GUI)
	GUICtrlCreateLabel("Enter password to disable lock !" & @CRLF & $LOCKED, 5, 5, 190, 27)
	Global $PWD = GUICtrlCreateInput("", 5, 35, 190, 17, $ES_PASSWORD + $ES_AUTOHSCROLL)
	$Lpw = GUICtrlCreateLabel("", 110, 64, 100, 17)
	GUICtrlCreateButton("OK", 5, 60, 100, 20)
	GUICtrlSetOnEvent(-1, "_UNLOCKFOLDER")
	GUISetState(@SW_SHOW, $CPW)

	$YZ = WinGetPos($CPW)
	_MouseTrap($YZ[0] + 4, $YZ[1] + 25, $YZ[0] + $YZ[2] - 2, $YZ[1] + $YZ[3] - 2)
EndFunc   ;==>_PasswordFolder

Func _UNLOCKFOLDER()
	If Not (GUICtrlRead($PWD) = $LockPW) Then
		GUICtrlSetData($Lpw, "Wrong password !")
	EndIf

	If (GUICtrlRead($PWD) = $LockPW) Then
		GUICtrlSetData($Lpw, "Unlocking...")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
		WinSetState("Program Manager", "", @SW_SHOW)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
		WinSetState("[CLASS:DV2ControlHost]", "", @SW_ENABLE)
		WinSetTrans("[CLASS:DV2ControlHost]", "", 255)
		GUIDelete("Folder Lock <d3montools>")
		GUIDelete($GUI)
		_MouseTrap() ;--------------------------------
		WinSetState($LOCKED, "", @SW_SHOW)
		Global $FOLDERLOCKSTATUS = False
		Global $LOCKN = True
		TrayItemSetState($FOLDERELOCK, $TRAY_UNCHECKED)
		TrayItemSetState($FOLDERDLOCK, $TRAY_CHECKED)
		TrayTip("Lock'n", "Folder Lock Disabled !", 2, 1)
	EndIf
EndFunc   ;==>_UNLOCKFOLDER


Func _PasswordFile()
	WinMinimizeAll()
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
	ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
	WinSetState("[CLASS:DV2ControlHost]", "", @SW_DISABLE)
	WinSetTrans("[CLASS:DV2ControlHost]", "", 0)
	WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
	WinSetState("Program Manager", "", @SW_HIDE)
	_GUI() ;--------------------------------

	$CPW = GUICreate("File Lock <d3montools>", 200, 85, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST), $GUI)
	GUICtrlCreateLabel("Enter password to disable lock !" & @CRLF & $LOCKED, 5, 5, 190, 27)
	Global $PWD = GUICtrlCreateInput("", 5, 35, 190, 17, $ES_PASSWORD + $ES_AUTOHSCROLL)
	$Lpw = GUICtrlCreateLabel("", 110, 64, 100, 17)
	GUICtrlCreateButton("OK", 5, 60, 100, 20)
	GUICtrlSetOnEvent(-1, "_UNLOCKFILE")
	GUISetState(@SW_SHOW, $CPW)

	$YZ = WinGetPos($CPW)
	_MouseTrap($YZ[0] + 4, $YZ[1] + 25, $YZ[0] + $YZ[2] - 2, $YZ[1] + $YZ[3] - 2)
EndFunc   ;==>_PasswordFile

Func _UNLOCKFILE()
	If Not (GUICtrlRead($PWD) = $LockPW) Then
		GUICtrlSetData($Lpw, "Wrong password !")
	EndIf

	If GUICtrlRead($PWD) = $LockPW Then
		GUICtrlSetData($Lpw, "Unlocking...")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
		WinSetState("Program Manager", "", @SW_SHOW)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
		WinSetState("[CLASS:DV2ControlHost]", "", @SW_ENABLE)
		WinSetTrans("[CLASS:DV2ControlHost]", "", 255)
		GUIDelete("File Lock <d3montools>")
		GUIDelete($GUI)
		_MouseTrap() ;--------------------------------
		_ProcessResume($LOCKED)
		Global $FILELOCKSTATUS = False
		Global $LOCKN = True
		TrayItemSetState($FILEELOCK, $TRAY_UNCHECKED)
		TrayItemSetState($FILEDLOCK, $TRAY_CHECKED)
		TrayTip("Lock'n", "File Lock Disabled !", 2, 1)
	EndIf
EndFunc   ;==>_UNLOCKFILE


Func _PasswordStopsaver()
	$CPW = InputBox("Lock'n <d3montools>", "Enter password to have access !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		WinMinimizeAll()
		Global $Timer = TimerInit()
		ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
		ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
		ControlDisable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
		WinSetState("[CLASS:DV2ControlHost]", "", @SW_DISABLE)
		WinSetTrans("[CLASS:DV2ControlHost]", "", 0)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
		WinSetState("Program Manager", "", @SW_HIDE)
		_GUI() ;-------------------

		$CPW = GUICreate("Stop-saver Lock <d3montools>", 200, 125, -1, -1, $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST), $GUI)
		GUICtrlCreateLabel("Enter password to disable Stop-saver !", 5, 5, 190, 27)
		Global $PWD = GUICtrlCreateInput("", 5, 25, 190, 17, $ES_PASSWORD + $ES_AUTOHSCROLL)
		$Lpw = GUICtrlCreateLabel("", 110, 54, 100, 17)
		GUICtrlCreateButton("OK", 5, 50, 100, 20)
		GUICtrlSetOnEvent(-1, "_UNLOCKStopsaver")
		$Run = GUICtrlCreateLabel("Running time : 0 sec", 5, 75, 170, 17)
		$ECO = GUICtrlCreateCheckbox("Start screen saver", 5, 90, 190, 17)
		$MEM = GUICtrlCreateLabel("Memory : 0%", 5, 110, 170, 17)
		$CPU = GUICtrlCreateLabel("CPU : 0%", 100, 110, 170, 17)
		GUISetState(@SW_SHOW, $CPW)

		$YZ = WinGetPos($CPW)
		_MouseTrap($YZ[0] + 4, $YZ[1] + 25, $YZ[0] + $YZ[2] - 2, $YZ[1] + $YZ[3] - 2)
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_PasswordStopsaver

Func _UNLOCKStopsaver()
	If Not (GUICtrlRead($PWD) = $LockPW) Then
		GUICtrlSetData($Lpw, "Wrong password !")
	EndIf

	If GUICtrlRead($PWD) = $LockPW Then
		GUICtrlSetData($Lpw, "Unlocking...")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow321")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow322")
		ControlEnable("classname=Shell_TrayWnd", "", "ToolbarWindow323")
		WinSetState("Program Manager", "", @SW_SHOW)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
		WinSetState("[CLASS:DV2ControlHost]", "", @SW_ENABLE)
		WinSetTrans("[CLASS:DV2ControlHost]", "", 255)
		$PList = ProcessList()
		For $P = $PList[1][0] To $PList[0][0]
			If Not $P = "System" Or _
					$P = "svchost.exe" Or _
					$P = @ScriptName Or _
					$P = "0" Or $P = "" Then
				_ProcessResume($P)
			EndIf
		Next
		GUIDelete("Stop-saver Lock <d3montools>")
		GUIDelete($GUI) ;--------------------
		_MouseTrap() ;--------------
		Global $FILELOCKSTATUS = False
		Global $LOCKN = True
		Global $CECO = False
		TrayItemSetState($FILEELOCK, $TRAY_UNCHECKED)
		TrayItemSetState($FILEDLOCK, $TRAY_CHECKED)
		TrayTip("Lock'n", "Stop-saver Disabled !", 2, 1)
	EndIf
EndFunc   ;==>_UNLOCKStopsaver
#EndRegion password-----------------------------------------------------------------------------------


#Region Stop-saver---------------------------------------------------------------------------------
Func _STOPSAVERELOCK()
	$PList = ProcessList()
	For $P = $PList[1][0] To $PList[0][0]
		If Not $P = "System" Or _
				$P = "svchost.exe" Or _
				$P = @ScriptName Or _
				$P = "0" Or $P = "" Then
			_ProcessSuspend($P)
		EndIf
	Next
EndFunc   ;==>_STOPSAVERELOCK
#EndRegion Stop-saver---------------------------------------------------------------------------------


#Region Exit-----------------------------------------------
Func _Exit()
	$CPW = InputBox("Lock'n <d3montools>", "Enter password to exit !", "", "-", 200, 100)

	If $CPW = $LockPW Then
		RegDelete("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system", "DisableTaskMgr")
;~ RegWrite("HKCU\Software\Policies\Microsoft\Windows\System","DisableCMD","REG_DWORD","1")
		RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools")
		FileDelete(@TempDir & "\Lock'n.bmp")
		Exit
	Else
		TrayTip("Lock'n", "Wrong password entered !", 2, 2)
	EndIf
EndFunc   ;==>_Exit
#EndRegion Exit-----------------------------------------------

#Region Process--------------------------------------------
;===============================================================================
; Function Name: _ProcessSuspend / _ProcessResume
; Author(s): The Kandie Man
;===============================================================================
Func _ProcessSuspend($ID)
	$processid = ProcessExists($ID)
	If $processid Then
		$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
		$i_sucess = DllCall("ntdll.dll", "int", "NtSuspendProcess", "int", $ai_Handle[0])
		DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
		If IsArray($i_sucess) Then
			Return 1
		Else
			SetError(1)
			Return 0
		EndIf
	Else
		SetError(2)
		Return 0
	EndIf
EndFunc   ;==>_ProcessSuspend

Func _ProcessResume($ID)
	$processid = ProcessExists($ID)
	If $processid Then
		$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
		$i_sucess = DllCall("ntdll.dll", "int", "NtResumeProcess", "int", $ai_Handle[0])
		DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
		If IsArray($i_sucess) Then
			Return 1
		Else
			SetError(1)
			Return 0
		EndIf
	Else
		SetError(2)
		Return 0
	EndIf
EndFunc   ;==>_ProcessResume


;===============================================================================
; Function Name: _ReduceMemory
; Author(s): jftuga
;===============================================================================
Func _ReduceMemory($i_PID = -1)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf

	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory
#EndRegion Process--------------------------------------------

#Region PID------------------------------------------------
Func _PIDSHOW()
	GUISetState(@SW_MINIMIZE, $Filewnd)
	GUISetState(@SW_SHOW, $wndPID)
	_PIDRefresh()
EndFunc   ;==>_PIDSHOW

Func _PIDHIDE()
	GUISetState(@SW_HIDE, $wndPID)
	WinActivate($Filewnd, "")
EndFunc   ;==>_PIDHIDE

Func _PIDRefresh()
	$procl = ProcessList()

	GUICtrlDelete($PIDlist)
	$PIDlist = GUICtrlCreateListView("Process [F5 refresh list]|ID", 5, 5, 240, 240)
	GUICtrlSendMsg(-1, 0x101E, 0, 180)
	GUICtrlSendMsg(-1, 0x101E, 1, 40)

	For $i = 1 To $procl[0][0]
		$percent = Round(($i / $procl[0][0]) * 100)
		If $procl[$i][1] = 0 Or $procl[$i][0] = "System" Then ContinueLoop
		If ProcessExists($procl[$i][1]) Then
			$listitem = GUICtrlCreateListViewItem($procl[$i][0] & "|" & $procl[$i][1], $PIDlist)
			$menu = GUICtrlCreateContextMenu($listitem)
			GUICtrlCreateMenuItem("Copy name", $menu)
			GUICtrlSetOnEvent(-1, "_CopyPID")
			GUICtrlCreateMenuItem("Close it", $menu)
			GUICtrlSetOnEvent(-1, "_KillPID")
		EndIf
	Next
EndFunc   ;==>_PIDRefresh

Func _CopyPID()
	$pid = StringSplit(GUICtrlRead(GUICtrlRead($PIDlist)), "|")
	If @error Or ($pid = "") Then
		TrayTip("Lock'n process list", "Could not copy process to clipboard !", 2, 2)
	Else
		ClipPut($pid[1])
		TrayTip("Lock'n process list", "Process " & $pid[1] & " copied to clipboard !", 2, 1)
	EndIf
EndFunc   ;==>_CopyPID

Func _KillPID()
	$pid = StringSplit(GUICtrlRead(GUICtrlRead($PIDlist)), "|")
	If @error Or ($pid = "") Then
		TrayTip("Lock'n process list", "Could not close process !", 2, 2)
	Else
		ProcessClose($pid[1])
		TrayTip("Lock'n process list", "Process " & $pid[1] & " closed !", 2, 1)
	EndIf
	_PIDRefresh()
EndFunc   ;==>_KillPID
#EndRegion PID------------------------------------------------

#Region CLASS----------------------------------------------
Func _CLASSSHOW()
	GUISetState(@SW_MINIMIZE, $Folderwnd)
	GUISetState(@SW_SHOW, $wndCLASS)
EndFunc   ;==>_CLASSSHOW

Func _CLASSHIDE()
	GUISetState(@SW_HIDE, $wndCLASS)
	WinActivate($Folderwnd, "")
EndFunc   ;==>_CLASSHIDE

Func _NEWCLASS()
	WinMove($wndCLASS, "", 2, 2)
	Do ;-----------
		Sleep(200)
		$WND = WinGetHandle("", "")
		GUICtrlSetData($CLASS, _WinAPI_GetClassName($WND))
	Until _IsPressed("02")
EndFunc   ;==>_NEWCLASS

Func _ADDCLASS()
	If (GUICtrlRead($C1) = $GUI_CHECKED) Then
		$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\ClassLock.txt"), 2), 1)
		GUICtrlCreateListViewItem("[CLASS:CabinetWClass]| " & $NB + 1, $Classlist)
		FileWrite(@TempDir & "\ClassLock.txt", "//" & "[CLASS:CabinetWClass]| " & $NB + 1 & "|")
	EndIf

	If (GUICtrlRead($C2) = $GUI_CHECKED) Then
		$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\ClassLock.txt"), 2), 1)
		GUICtrlCreateListViewItem("[CLASS:MozillaUIWindowClass]| " & $NB + 1, $Classlist)
		FileWrite(@TempDir & "\ClassLock.txt", "//" & "[CLASS:MozillaUIWindowClass]| " & $NB + 1 & "|")
	EndIf

	If (GUICtrlRead($C3) = $GUI_CHECKED) Then
		$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\ClassLock.txt"), 2), 1)
		GUICtrlCreateListViewItem("[CLASS:OpWindow]| " & $NB + 1, $Classlist)
		FileWrite(@TempDir & "\ClassLock.txt", "//" & "[CLASS:OpWindow]| " & $NB + 1 & "|")
	EndIf

	If (GUICtrlRead($C4) = $GUI_CHECKED) Then
		$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\ClassLock.txt"), 2), 1)
		GUICtrlCreateListViewItem("[CLASS:IEFrame]| " & $NB + 1, $Classlist)
		FileWrite(@TempDir & "\ClassLock.txt", "//" & "[CLASS:IEFrame]| " & $NB + 1 & "|")
	EndIf

	If (GUICtrlRead($C5) = $GUI_CHECKED) Then
		$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\ClassLock.txt"), 2), 1)
		GUICtrlCreateListViewItem("[CLASS:MSBLWindowClass]| " & $NB + 1, $Classlist)
		FileWrite(@TempDir & "\ClassLock.txt", "//" & "[CLASS:MSBLWindowClass]| " & $NB + 1 & "|")
		$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\ClassLock.txt"), 2), 1)
		GUICtrlCreateListViewItem("[CLASS:IMWindowClass]| " & $NB + 1, $Classlist)
		FileWrite(@TempDir & "\ClassLock.txt", "//" & "[CLASS:IMWindowClass]| " & $NB + 1 & "|")
	EndIf

	If (GUICtrlRead($C6) = $GUI_CHECKED) Then
		$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\ClassLock.txt"), 2), 1)
		GUICtrlCreateListViewItem("[CLASS:tSkMainForm.UnicodeClass]| " & $NB + 1, $Classlist)
		FileWrite(@TempDir & "\ClassLock.txt", "//" & "[CLASS:tSkMainForm.UnicodeClass]| " & $NB + 1 & "|")
	EndIf

	If (GUICtrlRead($CLASS) <> "") Then
		$NB = StringTrimRight(StringRight(FileRead(@TempDir & "\ClassLock.txt"), 2), 1)
		GUICtrlCreateListViewItem("[CLASS:" & GUICtrlRead($CLASS) & "]| " & $NB + 1, $Classlist)
		FileWrite(@TempDir & "\ClassLock.txt", "//" & "[CLASS:" & GUICtrlRead($CLASS) & "]| " & $NB + 1 & "|")
	EndIf
	_CLASSHIDE()
EndFunc   ;==>_ADDCLASS
#EndRegion CLASS----------------------------------------------