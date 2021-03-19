#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Add_Constants=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include <GUIConstants.au3>

Run("c:\WINDOWS\system32\msiexec.exe /i  c:\support\install.msi  /norestart INSTALL_VX=1 PORT_VX=7")
WinWait("Software Installation", "Continue Anyway")

WinActivate("Software Installation", "Continue Anyway")

If WinActive("Software Installation", "Continue Anyway") Then
	Send("!c")

EndIf



