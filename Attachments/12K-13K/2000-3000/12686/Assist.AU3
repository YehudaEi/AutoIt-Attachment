HotKeySet("{F8}", "_TAssist")
HotKeySet("{F9}", "_PAttk")
HotKeySet("{F10}", "_Cast")
HotKeySet("{F11}", "_Follow")
HotKeySet("{Delete}", "_Exito")
AutoItSetOption("WinTitleMatchMode", 4) 
Global $handle = WinGetHandle("classname=GxWindowClassD3d") 
Global $TAssistRun = 0
Global $FollowRun = 0
Global $PAttkRun = 0
Global $CastRun = 0
Global $ExitoRun = 0

While 1
     Sleep(100)
WEnd

Func CLOSEClicked()
  Exit
EndFunc

Func _Follow()
     $FollowRun = Not $FollowRun
          If Not $FollowRun Then Return
          ControlSend($handle, "", "", "{ENTER}")
          Opt("SendKeyDelay", 50)
          ControlSend($handle, "", "", " /Target Dunkelheit")
	  Opt("SendKeyDelay", 50)
	  ControlSend($handle, "", "", "{Enter}")
	  Opt("SendKeyDelay", 50)
	  ControlSend($handle, "", "", "{Enter}")
          Opt("SendKeyDelay", 50)
	  ControlSend($handle, "", "", "/Follow")
	  Opt("SendKeyDelay", 50)
	  ControlSend($handle, "", "", "{Enter}")
          Opt("SendKeyDelay", 10)
 EndFunc

Func _TAssist()
     $TAssistRun = Not $TAssistRun
          If Not $TAssistRun Then Return
          ControlSend($handle, "", "", "{ENTER}")
          Opt("SendKeyDelay", 50)
          ControlSend($handle, "", "", " /Target Dunkelheit")
	  Opt("SendKeyDelay", 50)
	  ControlSend($handle, "", "", "{Enter}")
	  Opt("SendKeyDelay", 50)
	  ControlSend($handle, "", "", "{Enter}")
          Opt("SendKeyDelay", 50)
	  ControlSend($handle, "", "", "/Assist")
	  Opt("SendKeyDelay", 50)
	  ControlSend($handle, "", "", "{Enter}")
          Opt("SendKeyDelay", 10)
 EndFunc

Func _PAttk()
     $PAttkRun = Not $PAttkRun
          If Not $PAttkRun Then Return
          ControlSend($handle, "", "", "`")
          Opt("SendKeyDelay", 20)
 EndFunc

Func _Cast()
     $CastRun = Not $CastRun
          If Not $CastRun Then Return
          ControlSend($handle, "", "", "{ENTER}")
          Opt("SendKeyDelay", 20)
          ControlSend($handle, "", "", " /Cast Curse of Agony(Rank 6)")
	  Opt("SendKeyDelay", 20)
	  ControlSend($handle, "", "", "{Enter}")
          Opt("SendKeyDelay",1000)
	  ControlSend($handle, "", "", "{Enter}")
	  Opt("SendKeyDelay", 20)
          ControlSend($handle, "", "", "/Cast Corruption(Rank 7)")
          Opt("SendKeyDelay",20)
	  ControlSend($handle, "", "", "{Enter}")
	  Opt("SendKeyDelay", 20)
 EndFunc

Func _Exito()
     $ExitoRun = Not $ExitoRun
          If Not $ExitoRun Then Return
          Exit
EndFunc