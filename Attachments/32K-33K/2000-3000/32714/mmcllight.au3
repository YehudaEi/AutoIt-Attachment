#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Furnaceactive.ico
#AutoIt3Wrapper_outfile=MMCL Light.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 3)
TraySetIcon("Furnaceactive.ico")
TraySetToolTip("Minikori's Minecraft Launcher (Light)")

If Not FileExists(@AppDataDir & "\.minecraft\pt.ini") Then
	IniWrite(@AppDataDir & "\.minecraft\pt.ini", "playtime", "playtime", 0)
EndIf

$TrayRun = TrayCreateItem("Launch Minecraft")
$TrayInfo = TrayCreateItem("Info")
$TrayExit = TrayCreateItem("Exit Launcher")

TraySetState()
TrayTip("MMCL Light v0.1", "Launcher started.", 5)
While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = $TrayExit
			ExitLoop
		Case $msg = $TrayRun
			RunWait("minecraft.exe")
		Case WinExists("Minecraft")
			$timer = TimerInit()
			Do
				Sleep(1)
			Until Not WinExists("Minecraft")
			$dif = TimerDiff($timer)
			$playtime = IniRead(@AppDataDir & "\.minecraft\pt.ini", "playtime", "playtime", 0)
			IniWrite(@AppDataDir & "\.minecraft\pt.ini", "playtime", "playtime", Number($playtime)+$dif)
		Case $msg = $TrayInfo
			MsgBox(0, "Info", "Minikori's Minecraft Launcher Light (v0.1)" & @CRLF & @CRLF & "Playtime: " & Round(Number(IniRead(@AppDataDir & "\.minecraft\pt.ini", "playtime", "playtime", 0))/3600000, 2) & " hours")
	EndSelect
WEnd
Exit