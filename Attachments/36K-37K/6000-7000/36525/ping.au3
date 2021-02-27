#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\bill 2G\icons\New Folder\ONLINE.ICO
#AutoIt3Wrapper_Outfile=Programs\ping.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
local $site = inputbox("ping site","site to ping :")
Local $var = Ping($site, 250)
If $var Then; also possible:  If @error = 0 Then ...
    MsgBox(0, "Status", "Online, roundtrip was:" & $var)
Else
    MsgBox(0, "Status", "An error occured with number: " & @error)
EndIf
