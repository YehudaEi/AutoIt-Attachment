
#include "SysTray_UDF.au3"

; -- Example 1 --
; Get window titles of all windows that have icon on systray
$iTitles = _SysTrayIconTitles()
; Get process names of all processes that have icon on systray
$iProcesses = _SysTrayIconProcesses()
For $i=0 to Ubound($iTitles)-1
; write the info to consolewindow
ConsoleWrite(@CR & "#" &$i & "Title: " & $iTitles[$i] & ", process: " & $iProcesses[$i])
Next





; -- Example 5 --
; Left-click Outlook's icon on system tray

; Press hide inactive icon's button part is from Valik's refresh system tray script!
$oldMatchMode = Opt("WinTitleMatchMode", 4)
$oldChildMode = Opt("WinSearchChildren", 1)

$class = "classname=Shell_TrayWnd"
$hControl = ControlGetHandle($class, "", "Button2")

; get tray position and move there. Helps if Auto Hide tray option is used.
$posTray = WinGetPos(_FindTrayToolbarWindow())
MouseMove($posTray[0], $posTray[1])

; If XP and the Hide Inactive Icons mode is active
If $hControl <> "" And ControlCommand($class, "", $hControl, "IsVisible","") Then
ControlClick($class, "", $hControl)
Sleep(250); Small delay to allow the icons to be drawn
EndIf

$index = _SysTrayIconIndex("Outlook.exe"); Change this to some other application if needed
If $index <> -1 Then
$pos = _SysTrayIconPos($index)

If $pos = -1 Then Exit
MouseMove($pos[0], $pos[1])
Sleep(1000)
MouseClick("left")
EndIf
ConsoleWrite(@CRLF & @CRLF & "Pos[0]: " & $pos[0] & "$pos[1]: " & $pos[1])
; Restore Opt settings
Opt("WinTitleMatchMode", $oldMatchMode)
Opt("WinSearchChildren", $oldChildMode)
