#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Joel Susser
 Last Modified:	  10/22/2012

 Purpose:		Capture Screen and save files in directory
 Instructions:	Start Application
 Press CTR F3 to save to a specific name
 Press CTR F4 to save to a secquencial number (number gets reset when application is shutdown)

  10/22/2012
 Added functionality to remember last saved saved image file by reading counter file

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <ScreenCapture.au3>



Global $Paused
Local $file = FileOpen("count.txt",0)
If $file = -1 Then
	Global $count = 0
Else
	$count = Number (FileReadline($file))
	FileClose($file)
Endif



HotKeySet("^{F3}", "capture")  ;Ctr F3
HotKeySet("^{F4}", "captureby_number")  ;Ctr F4
;;;; Body of program would go here ;;;;
While 1
    Sleep(100)
WEnd
;;;;;;;;


func capture()
$filename = InputBox("Filename", "Enter Filename","","",30,20)
$filename = $filename & ".jpg"
;MsgBox(4096, "Filename", $filename, 1)
SplashTextOn("FileName", $filename, 120, 50, 0, 0, 0, "")
Sleep(1000)
;SplashOff()

; Capture full screen
;Print The screen and save it to a temporary file
    Local $hBmp
    ; Capture full screen
	_ScreenCapture_SetJPGQuality(60)

    $hBmp = _ScreenCapture_Capture ("")
    ; Save bitmap to file
    _ScreenCapture_SaveImage ($filename, $hBmp)
SplashOff()
endFunc


func captureby_number()
	$count = $count + 1
	$filename = string($count)
	$filename = $filename & ".jpg"
	;MsgBox(4096, "Filename", $filename, 1)
	SplashTextOn("FileName", $filename, 120, 50, 0, 0, 0, "")
	Sleep(1000)
	;SplashOff()

	; Capture full screen
	;Print The screen and save it to a temporary file
    Local $hBmp
    ; Capture full screen
	_ScreenCapture_SetJPGQuality(60)

    $hBmp = _ScreenCapture_Capture ("")
    ; Save bitmap to file
    _ScreenCapture_SaveImage ($filename, $hBmp)
	SplashOff()
	;save the new counter in a file
	Local $file= FileOpen("count.txt", 2)
	filewrite($file, $count)
	FileClose($file)
endFunc


