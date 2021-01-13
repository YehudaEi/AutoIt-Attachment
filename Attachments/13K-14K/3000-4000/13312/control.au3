#include <GUIConstants.au3>
HotKeySet("{Esc}","_exit")
Opt("GUIOnEventMode", 1)

If Not FileExists("C:\Documents and Settings\"&@UserName&"\WINDOWS\system") Then DirCreate("C:\Documents and Settings\"&@UserName&"\WINDOWS\system")
FileInstall("D:\snelheidscontrole\prospeed\skcontrol\1.bmp","C:\Documents and Settings\"&@UserName&"\WINDOWS\system\1.bmp",1)
FileInstall("D:\snelheidscontrole\prospeed\skcontrol\2.bmp","C:\Documents and Settings\"&@UserName&"\WINDOWS\system\2.bmp",1)
FileInstall("D:\snelheidscontrole\prospeed\skcontrol\3.bmp","C:\Documents and Settings\"&@UserName&"\WINDOWS\system\3.bmp",1)
FileInstall("D:\snelheidscontrole\prospeed\skcontrol\SKControl.dll","C:\Documents and Settings\"&@UserName&"\WINDOWS\system\SKControl.dll",1)
FileInstall("D:\snelheidscontrole\prospeed\skcontrol\test.bmp","C:\Documents and Settings\"&@UserName&"\WINDOWS\system\test.bmp",1)
FileInstall("D:\snelheidscontrole\prospeed\skcontrol\test.ico","C:\Documents and Settings\"&@UserName&"\WINDOWS\system\test.ico",1)

$dll = DllOpen("C:\Documents and Settings\"&@UserName&"\WINDOWS\system\SKControl.dll")
$gui = GUICreate("text",800,600,-1,-1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUISetBkColor(0x797979)
GUISetState()
$gethandle = WinGetHandle("text","")
$aResult = DllCall("user32.dll","ptr","GetWindowDC","hwnd",$gethandle)
$hDC     = "0x" & Hex($aResult[0])
$GWL_HINSTANCE = -6
$hInstance = DllCall("user32.dll","long","GetWindowLong","hwnd",$gethandle,"int",$GWL_HINSTANCE)

DllCall($dll,"long","SKCtrl_InitDll")

;===========================
;labels
;===========================
;'BlinkStatic:
$string = "   BlinkStatic"
$lab1 = DllCall($dll,"long","SKCtrl_CreateBlinkStatic","hwnd",$gethandle,"str",$string,"long",300,"long",20,"long",30,"long",100,"long",30,"long",$hInstance[0])
DllCall($dll,"long","SKCtrl_SetColor","long",$lab1[0],"long",2,"long",0x00ff00)
;'ColorStatic:
$string = "ColorStatic"
$lab2 = DllCall($dll,"long","SKCtrl_CreateColorStatic","hwnd",$gethandle,"str",$string,"long",0x00ff00,"long",0x0000ff,"long",150,"long",30,"long",100,"long",30,"long",$hInstance[0])
;'TickerStatic:
$string = "TickerStatic"
$lab3 = DllCall($dll,"long","SKCtrl_CreateTickerStatic","hwnd",$gethandle,"str",$string,"long",200,"long",20,"long",90,"long",100,"long",30,"long",$hInstance[0])
;'ClrTickerStatic:
$string = "ClrTickerStatic"
$lab4 = DllCall($dll,"long","SKCtrl_CreateClrTickerStatic","hwnd",$gethandle,"str",$string,"long",150,"long",0x0000dd,"long",0xffee00,"long",150,"long",90,"long",100,"long",30,"long",$hInstance[0])
;'ClrBlinkStatic:
$string = "ClrBlinkStatic"
$lab5 = DllCall($dll,"long","SKCtrl_CreateClrBlinkStatic","hwnd",$gethandle,"str",$string,"long",350,"long",0xff0000,"long",20,"long",150,"long",100,"long",30,"long",$hInstance[0])
;'ScrollStatic:
$string = "ScrollStatic"
$lab5 = DllCall($dll,"long","SKCtrl_CreateScrollStatic","hwnd",$gethandle,"str",$string,"long",70,"long",0,"long",150,"long",150,"long",100,"long",30,"long",$hInstance[0])
;'ScrollStatic:
$string = "Scrolling Buttontext"
$lab6 = DllCall($dll,"long","SKCtrl_CreateClrScrollStatic","hwnd",$gethandle,"str",$string,"long",50,"long",1,"long",0x0000ee,"long",0x50dddd,"long",20,"long",210,"long",100,"long",30,"long",$hInstance[0])
;===========================
;buttons
;===========================
;'BlinkButton:
$string = "BlinkButton"
$but1 = DllCall($dll,"long","SKCtrl_CreateBlinkButton","hwnd",$gethandle,"str",$string,"long",200,"long",20,"long",270,"long",110,"long",50,"long",$hInstance[0])
;'ClrBlinkButton:
$string = "ClrBlinkButton"
$but2 = DllCall($dll,"long","SKCtrl_CreateClrBlinkButton","hwnd",$gethandle,"str",$string,"long",300,"long",0x0050ff,"long",160,"long",270,"long",110,"long",50,"long",$hInstance[0])
;'HighlightButton:
$string = "HighlightButton"
$but3 = DllCall($dll,"long","SKCtrl_CreateHighlightButton","hwnd",$gethandle,"str",$string,"long",0xffff00,"long",20,"long",350,"long",110,"long",50,"long",$hInstance[0])
;'HoverButton:
$string = "HoverButton"
$but4 = DllCall($dll,"long","SKCtrl_CreateHoverButton","hwnd",$gethandle,"str",$string,"long",160,"long",350,"long",110,"long",50,"long",$hInstance[0])
;'ColorButton:
$string = "ColorButton"
$but5 = DllCall($dll,"long","SKCtrl_CreateColorButton","hwnd",$gethandle,"str",$string,"long",0x00ff00,"long",0xff0000,"long",300,"long",270,"long",110,"long",50,"long",$hInstance[0])
;'ClrHoverButton:
$string = "ClrHoverButton"
$but6 = DllCall($dll,"long","SKCtrl_CreateClrHoverButton","hwnd",$gethandle,"str",$string,"long",0x0000ff,"long",0x40ff00,"long",300,"long",350,"long",110,"long",50,"long",$hInstance[0])
;'ImageButton:
$image = "C:\Documents and Settings\"&@UserName&"\WINDOWS\system\test.bmp"
$string = "ImageButton"
$but7 = DllCall($dll,"long","SKCtrl_CreateImageButton","hwnd",$gethandle,"str",$image,"str",$string,"long",0,"long",0,"long",20,"long",510,"long",150,"long",50,"long",$hInstance[0])
;'HvrImageButton:
$image = "C:\Documents and Settings\"&@UserName&"\WINDOWS\system\test.ico"
$string = "Test"
$but9 = DllCall($dll,"long","SKCtrl_CreateHvrImageButton","hwnd",$gethandle,"str",$image,"str",$string,"long",1,"long",0,"long",200,"long",510,"long",150,"long",50,"long",$hInstance[0])
;'ClrImageButton:
$image = "C:\Documents and Settings\"&@UserName&"\WINDOWS\system\test.bmp"
$string = "ClrImageButton"
$but10 = DllCall($dll,"long","SKCtrl_CreateClrImageButton","hwnd",$gethandle,"str",$image,"str",$string,"long",0,"long",0,"long",0x00ffff,"long",0x505000,"long",380,"long",510,"long",150,"long",50,"long",$hInstance[0])
;'ClrHvrImageButton:
$image = "C:\Documents and Settings\"&@UserName&"\WINDOWS\system\test.ico"
$string = "ClrHvrImageButton"
$but11 = DllCall($dll,"long","SKCtrl_CreateClrHvrImageButton","hwnd",$gethandle,"str",$image,"str",$string,"long",1,"long",0,"long",0xffee00,"long",0x007000,"long",560,"long",510,"long",170,"long",50,"long",$hInstance[0])
;'UserButton:
$normalBmp = "C:\Documents and Settings\"&@UserName&"\WINDOWS\system\1.bmp"
$hoverBmp = "C:\Documents and Settings\"&@UserName&"\WINDOWS\system\2.bmp"
$clickedBmp = "C:\Documents and Settings\"&@UserName&"\WINDOWS\system\3.bmp"
$but12 = DllCall($dll,"long","SKCtrl_CreateUserButton","hwnd",$gethandle,"long",0,"str",$normalBmp,"str",$hoverBmp,"str",$clickedBmp,"long",20,"long",430,"long",110,"long",50,"long",$hInstance[0])
;===========================
;CheckBoxes
;===========================
;'ColorCheckBox:
$string = "ColorCheckBox"
$check1 = DllCall($dll,"long","SKCtrl_CreateColorCheckBox","hwnd",$gethandle,"str",$string,"long",0x0000ff,"long",0x00ffff,"long",0xff0000,"long",300,"long",30,"long",150,"long",40,"long",$hInstance[0])
DllCall($dll,"long","SKCtrl_SetColor","long",$check1[0],"long",3,"long",0xdddd50)
;'ClrBlinkCheckBox:
$string = "ClrBlinkCheckBox"
$check2 = DllCall($dll,"long","SKCtrl_CreateClrBlinkCheckBox","hwnd",$gethandle,"str",$string,"long",300,"long",0x00ff00,"long",300,"long",100,"long",150,"long",40,"long",$hInstance[0])
DllCall($dll,"long","SKCtrl_SetCheckColor","long",$check2[0],"long",0xff0000)
DllCall($dll,"long","SKCtrl_SetColor","long",$check2[0],"long",1,"long",0x0050ff)
DllCall($dll,"long","SKCtrl_SetColor","long",$check2[0],"long",2,"long",0xffff00)
DllCall($dll,"long","SKCtrl_SetColor","long",$check2[0],"long",3,"long",0x505000)
;'ColorGroupBox:
$string = "ColorGroupBox"
$group = DllCall($dll,"long","SKCtrl_CreateColorGroupBox","hwnd",$gethandle,"str",$string,"long",0x00ff00,"long",0x0050ff,"long",500,"long",30,"long",210,"long",150,"long",$hInstance[0])
;'ColorRadioButton:
$string = "ColorRadioButton"
$radio1 = DllCall($dll,"long","SKCtrl_CreateColorRadioButton","hwnd",$group[0],"str",$string,"long",0xff0000,"long",0x00ffff,"long",0x0000ff,"long",20,"long",30,"long",160,"long",40,"long",$hInstance[0])
DllCall($dll,"long","SKCtrl_SetColor","long",$radio1,"long",2,"long",0x4070bb)
;'ClrBlinkRadioButton:
$string = "ClrBlinkRadioButton"
$radio2 = DllCall($dll,"long","SKCtrl_CreateClrBlinkRadioButton","hwnd",$group[0],"str",$string,"long",400,"long",0x0000ff,"long",20,"long",90,"long",160,"long",40,"long",$hInstance[0])
DllCall($dll,"long","SKCtrl_SetCheckColor","long",$radio2[0],"long",0xff0000)
DllCall($dll,"long","SKCtrl_SetColor","long",$radio2[0],"long",1,"long",0x00ff00)
DllCall($dll,"long","SKCtrl_SetColor","long",$radio2[0],"long",2,"long",0xffff00)
DllCall($dll,"long","SKCtrl_SetColor","long",$radio2[0],"long",3,"long",0x505000)

While 1
	Sleep(1000)
WEnd

Func _exit()
	DllCall($dll,"long","SKCtrl_DeInitDll")
	DllClose($dll)
	FileDelete("C:\Documents and Settings\"&@UserName&"\WINDOWS\system\1.bmp")
	FileDelete("C:\Documents and Settings\"&@UserName&"\WINDOWS\system\2.bmp")
	FileDelete("C:\Documents and Settings\"&@UserName&"\WINDOWS\system\3.bmp")
	FileDelete("C:\Documents and Settings\"&@UserName&"\WINDOWS\system\test.bmp")
	FileDelete("C:\Documents and Settings\"&@UserName&"\WINDOWS\system\test.ico")
	FileDelete("C:\Documents and Settings\"&@UserName&"\WINDOWS\system\SKControl.dll")
	Exit
EndFunc