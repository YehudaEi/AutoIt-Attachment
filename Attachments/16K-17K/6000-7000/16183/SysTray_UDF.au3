#include <GuiConstants.au3>
#include "SysTray_UDF.au3"


Opt("GUIOnEventMode", 1)
Opt("TrayIconHide", 1)

; GUI
GuiCreate("Remote Control", 200, 300)

GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

; PIC
GuiCtrlCreatePic("logo.bmp",10,10, 180,181,$SS_SUNKEN)

; BUTTON
$Button1=GuiCtrlCreateButton("Connect", 10, 250, 80, 30)
$Button2=GuiCtrlCreateButton("Close", 110, 250, 80, 30)

GUICtrlSetOnEvent($Button1, "ConnectButton")
GUICtrlSetOnEvent($Button2, "CloseButton")

; TEXT
GuiCtrlCreateLabel("", 5, 207, 190, 20,$SS_ETCHEDFRAME)
GuiCtrlCreateLabel("Tel :- 01467 622766 before Connect", 10, 210, 190, 20)
GUICtrlSetColor(-1,0xff0000)    ; Red

GUISetState(@SW_SHOW)

; Open Windows XP SP2 Firewall
$os=@OSVersion
$ver=@OSServicePack
if $os="WIN_XP" And $ver>="Service Pack 2" Then
    Run("netsh firewall set allowedprogram winvnc.exe WinVNC ENABLE", "", @SW_HIDE)
    EndIf


; Idle around
While 1
  Sleep(100) 
WEnd

Func CLOSEClicked()
    $index = _SysTrayIconIndex("winvnc.exe"); Change this to some other application if needed
    $pos = _SysTrayIconPos($index)
    Run("winvnc.exe -kill")
      $PID = ProcessExists("winvnc.exe") ; Will return the PID or 0 if the process isn't found.
      If $PID Then ProcessClose($PID)
    MouseMove($pos[0], $pos[1], 0)
    Sleep(1000)
       Exit
 EndFunc

Func ConnectButton()
    $remote_Station = INPUTBOX("Remote Control", "Remote Control Address", "", "", -1, 120)
    Run("winvnc.exe -connect " & $remote_station)
EndFunc

Func CloseButton()
    $index = _SysTrayIconIndex("winvnc.exe"); Change this to some other application if needed
    $pos = _SysTrayIconPos($index)
    Run("winvnc.exe -kill")
      $PID = ProcessExists("winvnc.exe") ; Will return the PID or 0 if the process isn't found.
      If $PID Then ProcessClose($PID)
    MouseMove($pos[0], $pos[1], 0)
    Sleep(1000)
       Exit
EndFunc