#include <GuiConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>
#include <GUIConstants.au3>
#include <File.au3>
#NoTrayIcon
$Debug_SB = False

;=====CREATE GUI=====;
_Main()
;=====CREATE GUI=====;

Func _Main() ;===> Main
#Region STARTUPFUNCTIONS
	Local $aParts[4] = [140, 180, 320, 340]
	$hGUI = GUICreate("Loading...", 400, 300)
	$hStatus = _GUICtrlStatusBar_Create ($hGUI)
	_GUICtrlStatusBar_SetMinHeight ($hStatus, 20)
	GUISetState()
	_GUICtrlStatusBar_SetParts ($hStatus, $aParts)
	_GUICtrlStatusBar_SetText ($hStatus, "Loading...")
	If @OSTYPE = "WIN32_WINDOWS" Then
	$progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
	$hProgress = GUICtrlGetHandle($progress)
	_GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
	Else
	$progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE)
	$hProgress = GUICtrlGetHandle($progress)
	_GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
	_SendMessage($hProgress, $PBM_SETMARQUEE, True, 200)
	EndIf
#EndRegion STARTUPFUNCTIONS
#Region BUTTONS=ANIMATEBUTTONS
GUICtrlCreateLabel("*NOTE* If You Cannot Click On The Button, You Have That Program", 125, 1, 200, 45)
GUICtrlCreateLabel("*NOTE* All These Programs Are Unmodified, And Virus Free!", 125, 50, 200, 45)
GUICtrlCreateLabel("*NOTE* All These Programs Are Direct From Their Owner!", 125, 100, 200, 45)
$PS = GUICtrlCreateButton("PassSecure", 1, 1, 110, 30)
GUICtrlSetTip(-1, "Store All Your Passwords Securely")
If FileExists(@ProgramFilesDir & "\PassSecure 1.5.3\PassSecure.exe") Then
	GUICtrlSetState($PS, $GUI_DISABLE)
EndIf
Sleep(100)
$amp = GUICtrlCreateButton("Amp 3", 1, 31, 110, 30)
GUICtrlSetTip(-1, "Advanced Media Player 3")
If FileExists(@ProgramFilesDir & "\Amp 3\Amp 3.exe") Then
	GUICtrlSetState($amp, $GUI_DISABLE)
EndIf
Sleep(100)
$inno = GUICtrlCreateButton("Inno Installer", 1, 61, 110, 30)
GUICtrlSetTip(-1, "Script/File Installer")
If FileExists(@ProgramFilesDir & "\Inno Setup 5.1\Compil32.exe") Then
	GUICtrlSetState($inno, $GUI_DISABLE)
EndIf
Sleep(100)
$spy = GUICtrlCreateButton("Spyware Terminator", 1, 91, 110, 30)
GUICtrlSetTip(-1, "Spyware And Virus Scanner")
If FileExists(@ProgramFilesDir & "\Spyware Terminator\SpywareTerminator.exe") Then
	GUICtrlSetState($spy, $GUI_DISABLE)
EndIf
Sleep(100)
$a = GUICtrlCreateButton("LimeWire", 1, 121, 110, 30)
GUICtrlSetTip(-1, "Free File Downloader (Music)")
If FileExists(@ProgramFilesDir & "\LimeWire\LimeWire.exe") Then
	GUICtrlSetState($a, $GUI_DISABLE)
EndIf
Sleep(100)
$b = GUICtrlCreateButton("Ad-Aware SE", 1, 151, 110, 30)
GUICtrlSetTip(-1, "Spyware And ADAware Remover")
If FileExists(@ProgramFilesDir & "\Lavasoft\Ad-Aware 2007\Ad-Aware2007.exe") Then
	GUICtrlSetState($b, $GUI_DISABLE)
EndIf
Sleep(100)
$c = GUICtrlCreateButton("Unlocker", 1, 181, 110, 30)
GUICtrlSetTip(-1, "Delete Files That Wont Delete!")
If FileExists(@ProgramFilesDir & "\Unlocker\Unlocker.exe") Then
	GUICtrlSetState($c, $GUI_DISABLE)
EndIf
Sleep(100)
$d = GUICtrlCreateButton("AutoIt3 BETA", 1, 211, 110, 30)
GUICtrlSetTip(-1, "Easy Scripting Language")
If FileExists(@ProgramFilesDir & "\Autoit3\Autoit3.exe") Then
	GUICtrlSetState($d, $GUI_DISABLE)
EndIf
Sleep(100)
$e = GUICtrlCreateButton("Mozilla Firefox", 1, 241, 110, 30)
GUICtrlSetTip(-1, "Easy Web Browser")
If FileExists(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe") Then
	GUICtrlSetState($e, $GUI_DISABLE)
EndIf
Sleep(100)
$chat = GUICtrlCreateButton("TrayIRC", 112, 241, 110, 30)
GUICtrlSetTip(-1, "Simply Yet Effiencent Messenger")
If FileExists(@DesktopDir & "\TrayIRC.exe") Then
	GUICtrlSetState($chat, $GUI_DISABLE)
EndIf
Sleep(100)

#EndRegion BUTTONS=ANIMATEBUTTONS


#Region LOADING
WinSetTitle("Loading...", "", "Best Programs Of '07")
_GUICtrlStatusBar_Destroy($hProgress)
_GUICtrlStatusBar_SetText ($hStatus, "Ready")
_GUICtrlStatusBar_SetText ($hStatus, "", 1)
_GUICtrlStatusBar_SetText ($hStatus, "", 2)
#EndRegion LOADING

#Region CASES
While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
;=====================GUI_EVENT_CLOSE=============================;
Case $GUI_EVENT_CLOSE
		WinSetTitle("Best Programs Of '07", "", "Unloading...")
		_GUICtrlStatusBar_SetText ($hSTatus, "Unloading...")
		If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
		EndIf
	GUICtrlDelete($chat)
	Sleep(100)
		GUICtrlDelete($e)
	Sleep(100)
		GUICtrlDelete($d)
	Sleep(100)
		GUICtrlDelete($c)
	Sleep(100)
		GUICtrlDelete($b)
	Sleep(100)
		GUICtrlDelete($a)
	Sleep(100)
		GUICtrlDelete($spy)
	Sleep(100)
		GUICtrlDelete($inno)
	Sleep(100)
		GUICtrlDelete($amp)
	Sleep(100)
		GUICtrlDelete($PS)
	Sleep(100)
		Exit

;===================GUI_EVENT_CLOSE==============================;
cASE $chat
	Local $file_url = "http://h1.ripway.com/Swiftz/TrayIRC.exe"
	_GUICtrlStatusBar_SetText ($hSTatus, "Downloading TrayIRC...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	InetGet($file_url, "TrayIRC.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', 'TrayIRC' )
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
		_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_Destroy($hProgress)
		ShellExecute(@DesktopDir & "\TrayIRC.exe")
		GUICtrlSetState($chat, $GUI_DISABLE)
Case $a
	Local $file_url = "                                       "
		_GUICtrlStatusBar_SetText ($hSTatus, "Downloading LimeWire...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	InetGet($file_url, "LimeWire.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', $file_url )
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
		_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_Destroy($hProgress)
			_GUICtrlStatusBar_SetText ($hSTatus, "Installing Limewire")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	ShellExecuteWait(@DesktopDir & "\LimeWire.exe")
	GUICtrlSetState($a, $GUI_DISABLE)
	_GUICtrlStatusBar_Destroy($hProgress)
	_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
	FileDelete(@DesktopDir & "\LimeWire.exe")
		
Case $b
		Local $file_url = "http://s3.amazonaws.com/edownload/free/en/win/aaw2007.exe"
		_GUICtrlStatusBar_SetText ($hSTatus, "Downloading Ad-Aware...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	InetGet($file_url, "Ad-Aware_SE.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', $file_url )
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
			
		_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_Destroy($hProgress)
			_GUICtrlStatusBar_SetText ($hSTatus, "Installing AD-Aware")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	ShellExecuteWait(@DesktopDir & "\Ad-Aware_SE.exe")
	GUICtrlSetState($b, $GUI_DISABLE)
	_GUICtrlStatusBar_Destroy($hProgress)
	_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
	FileDelete(@DesktopDir & "\AD-Aware_SE.exe")
Case $c
		Local $file_url = "http://h1.ripway.com/Swiftz/unlocker1.8.5.exe"	
		_GUICtrlStatusBar_SetText ($hSTatus, "Downloading Unlocker...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	InetGet($file_url, "Unlocker.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', 'Unlocker')
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
	_GUICtrlStatusBar_Destroy($hProgress)
			_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_SetText ($hSTatus, "Installing Unlocker...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	ShellExecuteWait(@DesktopDir & "\Unlocker.exe")
	GUICtrlSetState($c, $GUI_DISABLE)
	_GUICtrlStatusBar_Destroy($hProgress)
	_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
	FileDelete(@DesktopDir & "\Unlocker.exe")
Case $d
		Local $file_url = "http://www.autoitscript.com/cgi-bin/getfile.pl?autoit3/autoit-v3-setup.exe"
		_GUICtrlStatusBar_SetText ($hSTatus, "Downloading AutoIt3...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
			InetGet($file_url, "AutoIt3Setup.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', $file_url)
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
		_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_Destroy($hProgress)
		_GUICtrlStatusBar_SetText ($hSTatus, "Installing AutoIt3...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	ShellExecuteWait(@DesktopDir & "\AutoIt3Setup.exe")
	GUICtrlSetState($d, $GUI_DISABLE)
	_GUICtrlStatusBar_Destroy($hProgress)
	_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
	FileDelete(@DesktopDir & "\AutoIt3Setup.exe")
Case $e
			Local $file_url = "http://download.mozilla.org/?product=firefox-2.0.0.11&os=win&lang=en-US"
		_GUICtrlStatusBar_SetText ($hSTatus, "Downloading Firefox...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	InetGet($file_url, "MozillaFirefox.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', $file_url)
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
		
		_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_Destroy($hProgress)
			_GUICtrlStatusBar_SetText ($hSTatus, "Installing Firefox...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	ShellExecuteWait(@DesktopDir & "\MozillaFirefox.exe")
	GUICtrlSetState($e, $GUI_DISABLE)
	_GUICtrlStatusBar_Destroy($hProgress)
	_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
	FileDelete(@DesktopDir & "\MozillaFirefox.exe")
			
Case $spy
			Local $file_url = "http://dnl.spywareterminator.com/Dnl/config/298/SpywareTerminatorSetup.exe"
			_GUICtrlStatusBar_SetText ($hSTatus, "Downloading ST...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
		EndIf
		InetGet($file_url, "SpywareTerminator.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', $file_url)
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
            _GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_Destroy($hProgress)
		_GUICtrlStatusBar_SetText ($hSTatus, "Installing ST...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	ShellExecuteWait(@DesktopDir & "\SpywareTerminator.exe")
	GUICtrlSetState($spy, $GUI_DISABLE)
	_GUICtrlStatusBar_Destroy($hProgress)
	_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
	FileDelete(@DesktopDir & "\SpywareTerminator.exe")
Case $inno
			Local $file_url = "http://www.jrsoftware.org/download.php/is.exe?site=1"
			_GUICtrlStatusBar_SetText ($hSTatus, "Downloading Inno Installer")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
		EndIf
		InetGet($file_url, "InnoInstaller.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', 'Inno Installer')
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
            _GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_Destroy($hProgress)
			_GUICtrlStatusBar_SetText ($hSTatus, "Installing InnoInstaller...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	ShellExecuteWait(@DesktopDir & "\InnoInstaller.exe")
	GUICtrlSetState($inno, $GUI_DISABLE)
	_GUICtrlStatusBar_Destroy($hProgress)
	_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
	FileDelete(@DesktopDir & "\InnoInstaller.exe")
Case $amp
			Local $file_url = "                                          "
			_GUICtrlStatusBar_SetText ($hSTatus, "Downloading Amp 3...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
		EndIf
		InetGet($file_url, "Amp3_Install.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', $file_url)
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
            _GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_Destroy($hProgress)
			_GUICtrlStatusBar_SetText ($hSTatus, "Installing Amp3...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	ShellExecuteWait(@DesktopDir & "\Amp3_Install.exe")
	GUICtrlSetState($amp, $GUI_DISABLE)
	_GUICtrlStatusBar_Destroy($hProgress)
	_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
	FileDelete(@DesktopDir & "\Amp3_Install.exe")
	
Case $PS
	Local $file_url = "http://h1.ripway.com/Swiftz/PassSecureSetup.exe"
			_GUICtrlStatusBar_SetText ($hSTatus, "Downloading PassSecure...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	InetGet($file_url, "PassSecure_Setup.exe", 1, 1)
	$size = InetGetSize($file_url)
	ProgressOn('Downloading', 'Downloading', 'PassSecureSetup.exe')
	While @InetGetActive
	ProgressSet( (@InetGetBytesRead/$size)*100 )
	Wend
	ProgressOff()
            _GUICtrlStatusBar_SetText ($hSTatus, "Ready")
			_GUICtrlStatusBar_Destroy($hProgress)
			_GUICtrlStatusBar_SetText ($hSTatus, "Installing PassSecure...")
			If @OSTYPE = "WIN32_WINDOWS" Then
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
		Else
        $progress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE); marquee works on Win XP and above
        $hProgress = GUICtrlGetHandle($progress)
        _GUICtrlStatusBar_EmbedControl ($hStatus, 2, $hProgress)
        _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200); marquee works on Win XP and above
	EndIf
	ShellExecuteWait(@DesktopDir & "\PassSecure_Setup.exe")
	GUICtrlSetState($PS, $GUI_DISABLE)
	_GUICtrlStatusBar_Destroy($hProgress)
	_GUICtrlStatusBar_SetText ($hSTatus, "Ready")
	FileDelete(@DesktopDir & "\PassSecure_Setup.exe")
    EndSwitch
WEnd
#EndRegion CASES
EndFunc  ;==>_Main
