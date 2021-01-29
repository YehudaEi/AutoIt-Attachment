; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------
; Script Start - Add your code below here
#include "SysTray_UDF.au3"
MsgBox(0, "count", _SystrayIconCount ())
For $p = 0 To _SystrayIconCount ()
   ConsoleWrite(@CR & "#" & $p & "Tooltip: " & _SysTrayIconTooltip ($p))
Next
MsgBox(0, "Tooltip", _SysTrayIconTooltip (_SysTrayIconIndex ("Feedreader.exe")))
; -- Example 1 --
; Get window titles of all windows that have icon on systray
$iTitles = _SysTrayIconTitles ()
; Get process names of all processes that have icon on systray
$iProcesses = _SysTrayIconProcesses ()
For $i = 0 To UBound($iTitles) - 1
   ; write the info to consolewindow
   ConsoleWrite(@CR & "#" & $i & "Title: " & $iTitles[$i] & ", process: " & $iProcesses[$i])
Next
; -- Example 2 --
$st_process = "bittorrent.exe"; change this if needed
_SysTrayIconRemove (_SysTrayIconIndex ($st_process))
; Note that only the icon was removed; process still should be running
; -- Example 3 --
$st_process = "feedreader.exe"; change this if needed
_SysTrayIconVisible (1, _SysTrayIconIndex ($st_process))
; Note that the icon is hidden
Sleep(10000)
_SysTrayIconVisible (0, _SysTrayIconIndex ($st_process))
; -- Example 4 --
$pos = _SysTrayIconIndex ($st_process)
$ret = _SysTrayIconMove ($pos, $pos + 3); edit newpos if needed
; -- Example 5 --
; Left-click Feedreader's icon on system tray
; Press hide inactive icon's button part is from Valik's refresh system tray script!
$oldMatchMode = Opt("WinTitleMatchMode", 4)
$oldChildMode = Opt("WinSearchChildren", 1)
$class = "classname=Shell_TrayWnd"
$hControl = ControlGetHandle($class, "", "Button2")
; get tray position and move there. Helps if Auto Hide tray option is used.
$posTray = WinGetPos(_FindTrayToolbarWindow ())
MouseMove($posTray[0], $posTray[1])
$index = _SysTrayIconIndex ("feedreader.exe"); Change this to some other application if needed
If $index <> -1 Then
   $pos = _SysTrayIconPos ($index)
   If $pos = -1 Then
      ; ***** Moved by CatchFish *****
      ; If XP and the Hide Inactive Icons mode is active
      If $hControl <> "" And ControlCommand($class, "", $hControl, "IsVisible", "") Then
         ControlClick($class, "", $hControl)
         Sleep(250); Small delay to allow the icons to be drawn
      EndIf
      ; ******************************
      $pos = _SysTrayIconPos ($index)
      If $pos = -1 Then Exit ; ** A real error this time;)
   EndIf
   MouseMove($pos[0], $pos[1])
   Sleep(1000)
   MouseClick("left")
EndIf
ConsoleWrite(@CRLF & @CRLF & "Pos[0]: " & $pos[0] & "$pos[1]: " & $pos[1])
; Restore Opt settings
Opt("WinTitleMatchMode", $oldMatchMode)
Opt("WinSearchChildren", $oldChildMode)