#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author: Nevercom

 Script Function:
	This will copy the text under Mouse Position to the Clip Board and will
	run such a script in MMB:
	Data$ = 'Selected Text' ; Selected text is value of $Data in AutoIt
	RunScript("GetData")

#ce ----------------------------------------------------------------------------

#include <MMBLib.au3>

if @Compiled AND $CmdLine[0] == 0 then
	MsgBox(16,"Error","Missing CMDLine parameters!")
	Exit
endif

if @Compiled then
	$title = $CmdLine[1] ; Get window title from CMD
Else
	;$title = "Welcome!" ; only for debugging
endif
;$title = 'Welcome!'; Title of MMB window
;$script = 'Message("Test","")'; MMB Script
;SendScriptMMB($title,$script)
Func _GetText()
   
    Local $PrevClip = ClipGet()
    Local $MPos = MouseGetPos()
   
    MouseClick('left', $MPos[0], $MPos[1], 2, 0)
    Send('^c')
    ;ConsoleWrite(ClipGet() & @LF)
	$Data = ClipGet()
	
	$script = 'Data$ = ' & $Data
	SendScriptMMB($title,$script)
	$script = 'RunScript("GetData")'
	SendScriptMMB($title,$script)
    ClipPut($PrevClip)
   
EndFunc

while 1
	if $CmdLine[2] == 'GetText' Then ; I will send parameters to AutoIt like this: MMBWindowTitle GetText
		_GetText()
	EndIf
    Sleep(100)
WEnd