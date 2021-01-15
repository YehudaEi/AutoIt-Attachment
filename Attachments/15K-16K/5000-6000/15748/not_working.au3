#include <A3LMenu.au3>
#include <A3LToolbar.au3>
#include <A3LListbox.au3>
#include <Constants.au3>

Opt("MustDeclareVars", 1)

; ===============================================================================================================================
; Description ...: Right click on the Alkit VNC server (from:                         ), control icon in the task tray, then click 
;                  on "share window" in the context menu, then select the application window to share from the listbox in the
;                  "Share Window", the click on "OK" to share the application.
;                    

; Author ........: Thanks to Paul Campbell (PaulIA)for the 'volume.au3" script example and another author in the AutoIt forum for the
;                  script to get the LAN Ip address.
; Notes .........: I combined both these scripts to try and accomplish my goal  
; ===============================================================================================================================

; ===============================================================================================================================
; Global variables
; ===============================================================================================================================

Global $hWnd, $iI, $iCommand, $sText, $sVolume, $iIndex, $i, $lbc, $count = 1, $foo,$lines, $line, $x, $Ip, $Ifr

; ===============================================================================================================================
; Get server network IP address: For my computer it is: 192.168.0.123
; ===============================================================================================================================

$foo = Run(@ComSpec & " /c ipconfig", @SystemDir, @SW_HIDE, $STDOUT_CHILD)
$lines = ""
While 1
    $line = StdoutRead($foo)
    If @error Then ExitLoop
     $lines &= $line
Wend

$lines = StringSplit($lines,@CRLF,1)
For $x = 1 To $lines[0]
    If StringInStr($lines[$x], "IP Address") Then
        $lines = StringMid($lines[$x],StringInStr($lines[$x],":") + 2)
        ExitLoop
    EndIf
Next

;================================================================================================================================
; $sVolume variable on line 45, takes the resulting LAN IP address from the above code(on my computer: 192.168.0.123) and adds "WinVNC - "
; with the result: WinVNC - 192.168.0.123
;================================================================================================================================

$Ip = "WinVNC - "
$sVolume = ($Ip & $lines)

;===============================================================================================================================
; For testing purposes: Test the value of $sVolume by display the result in either a messagebox or Notepad
; ===============================================================================================================================

MsgBox(0,"IP Address", $sVolume)

Run("notepad.exe") 
Sleep(1000) 
Send($sVolume) 
 
; ===============================================================================================================================
; Right clicks on the "WinVNC - 192.168.0.123" icon in the task tray and selects "Share Window"
; ===============================================================================================================================

ControlFocus ("[CLASS:Shell_TrayWnd]", "", "Notification Area")

$hWnd = ControlGetHandle("[CLASS:Shell_TrayWnd]", "", "Notification Area")

if $hWnd = 0 then _Lib_ShowError("Unable to get tray handle")

for $iI = 0 to _Toolbar_ButtonCount($hWnd) - 1
  $iCommand = _Toolbar_IndexToCommand($hWnd, $iI)
  $sText    = _Toolbar_GetButtonText ($hWnd, $iCommand)
   
; ===============================================================================================================================
; Note: The following line of code is where I suspect my problem is. Spesifically the "$sVolume" variable.
; The result for both "$sText" and "$sVolume" should be "WinVNC - 192.168.0.123" to continue script.
; ===============================================================================================================================
     
   if $sText = $sVolume then
    BlockInput(1)
    if ControlGetHandle("[CLASS:Shell_TrayWnd]", "", "Button2") <> 0 then
      ControlClick("[CLASS:Shell_TrayWnd]", "", "Button2")
    endif
    _Toolbar_ClickButton($hWnd, $iCommand, "right")
    Sleep(100)
Send("S")
WinActivate ( "Share Window")
WinWaitActive("Share Window", "", 5)
    BlockInput(0)
    ExitLoop
 endif
next
;Sleep(1000)
Do
; a.) Put focus on the window called "Share Window"	
 $hWnd = ControlGetHandle("Share Window", "Select window to share:", 1037)
; b.) Find an item named "MTN F@stLink HSDPA Modem" in the listbox in "Share Window" window
$iIndex = _Listbox_FindTextExact($hWnd, "MTN F@stLink HSDPA Modem")
;Selects the string "MTN F@stLink HSDPA Modem" and scrolls it into view
$lbc = _Listbox_SetCurSel($hWnd, $iIndex)
; d.) Read the selected (higlighted) item from the listbox
$i = ControlCommand ( "Share Window", "Select window to share:", 1037, "GetCurrentSelection", "")
; Increase the count by one
	$count = $count + 1  

; Check if the item clicked in the listbox is the same as the highlighted item, if so move to the next line, if not loop back to (a.)
Until $lbc = $i or $count > 5

If $i = "MTN F@stLink HSDPA Modem" then
;Sets input focus to the "OK" button on the Alkit VNC "Share Window"
ControlFocus ("Share Window", "", "[CLASS:Button; TEXT:OK]")
;Sends a mouse click command to the "OK" button on the Alkit VNC "Share Window"
ControlClick("Share Window", "", "[CLASS:Button; TEXT:OK]") 
If $i not = "MTN F@stLink HSDPA Modem" then
	MsgBox(48, "Lakeview Primary School - Internet Server Control software: notification","Alkit VNC Server cannot share ""MTN F@stLink HSDPA Modem"" application with remote clients.")
EndIf
EndIf






 

	


