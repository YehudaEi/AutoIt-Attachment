#include "ServiceControl.au3"

Dim $nRet

; Stop/start the Spooler service
If _ServiceExists("", "Spooler") Then
   MsgBox(4096,'debug:' , 'Spooler service exists') ;### Debug MSGBOX    
   If _ServiceRunning("", "Spooler") Then
      MsgBox(4096,'debug:' , 'Spooler service running') ;### Debug MSGBOX
      If _StopService("", "Spooler") Then
         MsgBox(4096,'debug:' , 'Spooler service stopped') ;### Debug MSGBOX
      EndIf
   Else
      MsgBox(4096,'debug:' , 'Spooler service stopped') ;### Debug MSGBOX
      If _StartService("", "Spooler") Then
         MsgBox(4096,'debug:' , 'Spooler service started') ;### Debug MSGBOX
      EndIf
   EndIf
Else
   MsgBox(4096,'debug:' , 'Spooler service does not exist') ;### Debug MSGBOX    
EndIf

Sleep(1000)

; Create/delete the WinVNC service
; You must copy both the winvnc.exe and vnchooks.dll file to the Windows directory before
; running this code.
If _ServiceExists("", "WinVNC") Then
   MsgBox(4096,'debug:' , 'WinVNC service exists') ;### Debug MSGBOX
   If _ServiceRunning("", "WinVNC") Then
      MsgBox(4096,'debug:' , 'WinVNC service running') ;### Debug MSGBOX
      If _StopService("", "WinVNC") Then
         Sleep(1000)
         MsgBox(4096,'debug:' , 'WinVNC service stopped') ;### Debug MSGBOX
         If _DeleteService("", "WinVNC") Then
            MsgBox(4096,'debug:' , 'WinVNC service deleted') ;### Debug MSGBOX
         EndIf
      EndIf
   Else
      If _DeleteService("", "WinVNC") Then
         MsgBox(4096,'debug:' , 'WinVNC service deleted') ;### Debug MSGBOX
      EndIf      
   EndIf
Else
   $nRet = _CreateService("", _
                          "WinVNC", _
                          "VNC Server", _
                          "%SystemRoot%\winvnc.exe -service", _
                          "LocalSystem", _
                          "", _
                          BitOR($SERVICE_WIN32_OWN_PROCESS, $SERVICE_INTERACTIVE_PROCESS))
   If $nRet Then
      MsgBox(4096,'debug:' , 'WinVNC service created') ;### Debug MSGBOX
      If _StartService("", "WinVNC") Then
         MsgBox(4096,'debug:' , 'WinVNC service started') ;### Debug MSGBOX
      EndIf
   Else
      MsgBox(4096,'debug:' , 'Failed to create WinVNC service: ' & @error) ;### Debug MSGBOX
   EndIf
EndIf
