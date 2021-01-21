; --------------------------------------------------------------------------------
; File: AsyncHotKeyTest.au3
; 
; Desc: Test code for AsyncHotKeySet routines.
;
; Auth: Berean <http://www.autoitscript.com/forum/index.php?showuser=4581>.
; --------------------------------------------------------------------------------
#include "AsyncHotKeySet.au3"

;--------------------------------------------------------------------------------
; Call the main function.
MyMain()

;--------------------------------------------------------------------------------
; MyMain()
; Main function.
Func MyMain()
	; Install the Async Hot Keys
	AsyncHotKeySet("{ESC}","MyExit")
	AsyncHotKeySet("A","MyMessage")
	
	while 1 = 1
		AsyncHotKeyPoll()
    	Sleep(100)
	wend
EndFunc

;--------------------------------------------------------------------------------
; MyExit()
; Exit the program.
Func MyExit()
	MsgBox(0,"Exit","Exiting Program")
	Exit
EndFunc

;--------------------------------------------------------------------------------
; MyMessage()
; Message function.
Func MyMessage()
	MsgBox(0,"Message","Message Function")
EndFunc
