#include <GuiConstants.au3>
#include <Date.au3>

;amount of time connection is allowed to be up before warning to disconnect (in minutes)
Dim $disconnectwarn=1
Dim $livetime=$disconnectwarn

Main()

Func Main()
   $connect=TimerInit()
   While 1
      Sleep(1000)
      ;If TimerDiff($connect) >= ($disconnectwarn * 60000) Then
      If TimerDiff($connect) >= ($disconnectwarn * 10000) Then
         ShowGUI()
      EndIf
   WEnd
EndFunc

Func ShowGUI()
   ;amount of time user has to cancel disconnection (in seconds)
   Global $disconTO=50
   
   Opt("GUIOnEventMode",1)
   GuiCreate("Network connection", 335, 180,(@DesktopWidth-335)/2, (@DesktopHeight-180)/2)
   GuiCtrlCreateIcon("SHELL32.dll",15,10,10,50,50)
   
   If $livetime > 59 Then
      $livehour = $livetime/60
      $livemin = Mod($livetime,60)
   EndIf
   $msgtext = "Your connection has been enabled for "
   If IsDeclared("livehour") Then
      $msgtext = $msgtext & $livehour & "hour"
      If $livehour > 1 Then $msgtext = $msgtext & "s"
      $msgtext = $msgtext & " and " & $livemin
   Else
      $msgtext = $msgtext & $livetime
   EndIf
   $msgtext = $msgtext & " minute(s). "
   $MsgLabel = GuiCtrlCreateLabel($msgtext & "Do you still wish to use it? If you ignore this message the connection will automatically disconnect.", 80, 10, 240, 60)
   
   If $disconTO > 59 Then
      $disconTOmin = $disconTO/60
      $disconTOsec = Mod($disconTO,60)
   Else
      $disconTOmin = 0
      $disconTOsec = $disconTO
   EndIf
   
   $Time = StringFormat("%02i:%02i",$disconTOmin,$disconTOsec)
         
   $TimeLabel = GuiCtrlCreateLabel("Time to disconnection:" & @TAB & $Time, 70, 90, 250, 20)
   
   $DisconnectButton = GuiCtrlCreateButton("&Disconnect", 40, 130, 110, 30)
   GUICtrlSetOnEvent($DisconnectButton,"Disconnect")
   $StayConnectedButton = GuiCtrlCreateButton("Stay &Connected", 190, 130, 110, 30)
   GUICtrlSetOnEvent($StayConnectedButton,"StayConnected")
   GuiSetState()
   AdlibEnable("DisconnectCountdown",1000)
   While 1
   WEnd
EndFunc

Func Disconnect()
   GuiDelete()
   Run(@ScriptDir & "\NetCon.exe Disable")
   Exit
EndFunc

Func StayConnected()
   AdlibDisable()
   GuiDelete()
   $livetime=$livetime+$disconnectwarn
   Main()
EndFunc

Func DisconnectCountdown()
   $disconTo = $disconTo - 1
      
   If $disconTO > 59 Then
      $disconTOmin = $disconTO/60
      $disconTOsec = Mod($disconTO,60)
   Else
      $disconTOmin = 0
      $disconTosec = $disconTO
   EndIf
   
   $Time = StringFormat("%02i:%02i",$disconTOmin,$disconTOsec)
   ControlSetText("Network connection","","Static3","Time to disconnection:" & @TAB & $Time)

   If $disconTO <= 0 Then Disconnect()
EndFunc

#cs
If MsgBox(4148,"Network connection","Your network connection has been in use for over " & $livetime & " minutes." & @LF & "Do you want to keep using it?") = 7 Then
   Run(@ScriptDir & "\NetCon.exe Disable")
   Exit
Else
   $livetime=$livetime+$disconnectwarn
   $connect=TimerInit()
EndIf
#ce