#include <Process.au3>
#include <GetFileList.au3>

;
; Testing Distiller Plot
; 
; Ver. 3.4	- Imcrease SendKeyDelay
; Ver. 3.3	- Added Wait SplashText
; Ver. 3.2	- Change .\pdf_rs274x to .\pdf_rs274x
; Ver. 3.1	- Bugfix Line 115
; Ver. 3	- Add ComboBox Selection for Printers
; Ver. 2 	- Change code to add Loop to Open Files for Processing (Faster and more efficient)
;

; Prompt the user to run the script - use a Yes/No prompt (4 - see help file)
$answer = MsgBox(4, "Gerber RS274X PDF", "Generate PDF?")


; Check the user's answer to the prompt (see the help file for MsgBox return values)
; If "No" was clicked (7) then exit the script
	If $answer = 7 Then
		MsgBox(0, "Generate PDF End.", "OK.  Bye!")
    		Exit
	EndIf

;------------------------------------------------------------------------------------
; Set Global Variables
;------------------------------------------------------------------------------------
AutoItSetOption ("SendKeyDelay",1)

If FileExists(".\gerber_rs274x") Then
	Global $GerbDir = (@WorkingDir & '\gerber_rs274x')
	DirCreate(@WorkingDir & '\pdf_rs274x')
	Global $PdfDir = (@WorkingDir & '\pdf_rs274x')
Else
        ;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Warning
		MsgBox(48,"Warning!","There is no gerber_rs274x directory.")
EndIf

If FileExists(@WorkingDir & '\pdf_rs274x') Then
	FileDelete(@WorkingDir & '\pdf_rs274x\*.pdf')
	;DirRemove(@WorkingDir & '.\pdf_rs274x', 1)

EndIf


;Begin Loop 
Dim $FILES
Dim $FileExt = "*.art" 									; specify the filemask
;Dim $GerbPathFile = ($GerbDir & '\' & $FileExt)

$FILES = _GetFileList($GerbDir, $FileExt) 				; Build filelist using <GetFileList.au3>

;Feed filelist into Array
For $X = 1 To UBound($FILES)-1							; 1 is used because the value 0 is # of files
Dim $GerbPathFile = ($FILES[$X])

	If $X = 1 Then
;------------------------------------------------------------------------------------
; Start Processing Films to PDF
;------------------------------------------------------------------------------------

	Opt("WinTitleMatchMode", 2)				;Optional Window Title selection mode

	; Run Viewmate
	Run('Viewmate.exe ' & $GerbPathFile, "", @SW_MAXIMIZE)
	; $WinName = StringReplace($GerbPathFile, ".art", ".bin")
	
	$FileSplit = StringReplace(StringTrimLeft(StringReplace($GerbPathFile, $GerbDir, ""),1),".art",".bin")
	;	MsgBox(0,'Var Show:' & $GerbPathFile, $FileSplit,20)

	Sleep(3000)

	;If WinExists($FileSplit &" - ViewMate","") Then
		If WinExists("ViewMate","") Then
			WinSetState("ViewMate", "", @SW_MAXIMIZE)
			Send("!v")
			Send("v")
			Send("e")
			Send("o")
			Send("!f")
			Send("{ENTER}")
			
			WinActivate("ViewMate")
			;WinSetOnTop("- ViewMate", "", 1)
			;Send("!F")
			;Send("p")
			Send("^p")
		Else
			MsgBox(0,"WinExists", "Viewmate does not exist")
		Exit
		EndIf

	WinWaitActive("Print","",10)
	;WinActivate("Print","")
	Send("!l")
	Send("!b")
	Send("!p")
	Send("!t")

	WinWaitActive("Print Setup","",10)
	WinActivate("Print Setup")
	
	ControlCommand("Print Setup","","ComboBox1","ShowDropDown","")
	ControlCommand("Print Setup","","ComboBox1","SelectString",'PDFCreator')
	Send("{ENTER}")

	Sleep(100)
	Send("!n")
	Sleep(100)
	Send("p")
	Sleep(100)
	Send("!z")
	Sleep(100)
	Send("t")
	Sleep(100)
	Send("!a")
	
	ControlCommand("Print Setup", "", "Button7", "Check", "")
			WinWaitActive("Print","",10)
			WinSetTitle("Print","","Juniper Print Top")
			ControlCommand("Print", "", "Button16", "Check", "")
			WinWaitClose("Juniper Print Top")
			WinWaitActive("Print","",10)
			WinSetTitle("Print","","Juniper Print")
			ControlCommand("Print", "", "Button10", "Check", "")
			SplashTextOn("","Printing... Please Wait.",300,80)
			WinWaitClose("Juniper Print")
			;MsgBox(64,"Printing","Please Wait......")
			
			
			
	If WinWaitActive("PDFCreator","",50) Then
		;WinClose("Printing","Please Wait......")
		SplashOff()
		WinActivate("PDFCreator")
		EndIf
		If WinExists("PDFCreator") Then
			WinActivate("PDFCreator")
			ControlCommand("PDFCreator", "", "9", "UnCheck", "")
			Send("!s")
		Else
			MsgBox(0,"WinExists Error", "PDFCreator window not active", 5)
			SplashOff()
		EndIf

$PdfPathFile = StringReplace(StringReplace($GerbPathFile, ".art", ".pdf"),$GerbDir, $PdfDir)

;Sleep(1000)
;WinWaitActive("Save as","",2)
WinWaitActive("Save as")
WinSetTitle("Save as", "", "Juniper Save As")
	ControlFocus("Juniper Save As", "", "Edit1")
	Send($PdfPathFile,1)
	ControlCommand("Juniper Save As", "", "Button2", "Check", "")
		;Sleep(200000)
		WinWaitActive("")
		WinSetTitle("","","pdfc_splash")
		WinWaitClose("pdfc_splash")
		

	
	Opt("WinTitleMatchMode", 1)

	If WinExists($FileSplit &" - ViewMate") Then
		WinActivate($FileSplit &" - ViewMate")
		Sleep(200)
	Else
		MsgBox(0, "Winexist:", "Window does not exist")
	EndIf	

;22222222222222222222222222222222222222222222222222222222222222222222
	ElseIf $X > 1 Then
		Sleep(1000)
		Opt("WinTitleMatchMode", 1)
		If WinExists($FileSplit &" - ViewMate") Then
			WinActivate($FileSplit &" - ViewMate")
			Send("^o")
		EndIf
		
		$FileSplit = StringReplace(StringTrimLeft(StringReplace($GerbPathFile, $GerbDir, ""),1),".art",".bin")
		
		WinWaitActive("Open","",10)
		;WinActivate("Open")
		WinSetTitle("Open","","Juniper Openfile")
		WinActivate("Juniper Openfile")
		ControlCommand("Juniper Openfile", "", "Edit1", "Check", "")
		
		Send($GerbPathFile,1)
	
		ControlCommand("Juniper Openfile", "", "Button2", "Check", "")
		WinWaitClose("Juniper Openfile")
		
		WinWaitActive($FileSplit &" - ViewMate","",10)
		WinActivate($FileSplit &" - ViewMate")
		Send("^p")

			WinWaitActive("Print","",10)
			WinSetTitle("Print","","Juniper Print Top")
			ControlCommand("Juniper Print Top", "", "Button16", "Check", "")
			WinWaitClose("Juniper Print Top")
			WinWaitActive("Print","",10)

		WinWaitActive("")
		WinSetTitle("Print","","Juniper Print 2")
		ControlCommand("Juniper Print 2", "", "Button10", "Check", "")
		SplashTextOn("","Printing... Please Wait.",300,80)
		WinWaitClose("Juniper Print 2")
	
		WinWaitActive("PDFCreator","",50)
		If WinExists("PDFCreator") Then
			SplashOff()
			WinActivate("PDFCreator")
			ControlCommand("PDFCreator", "", "9", "UnCheck", "")
			Send("!s")
		Else
			MsgBox(0,"WinExists Error", "PDFCreator window not active", 5)
			SplashOff()
		EndIf
	
$PdfPathFile = StringReplace(StringReplace($GerbPathFile, ".art", ".pdf"),$GerbDir, $PdfDir)	
	
	WinWaitActive("Save as")
	WinSetTitle("Save as", "", "Juniper Save As")
	Sleep(100)
	ControlFocus("Juniper Save As", "&Save", "Edit1")
	Send($PdfPathFile,1)
	Sleep(100)
	ControlCommand("Juniper Save As", "&Save", "Button2", "Check", "")
	Sleep(100)	
		WinWaitActive("")
		WinSetTitle("","","pdfc_splash")
		WinWaitClose("pdfc_splash")
	
	If WinExists($FileSplit &" - ViewMate") Then
		WinActivate($FileSplit &" - ViewMate")
		Sleep(200)
	EndIf	
	
	EndIf
;22222222222222222222222222222222222222222222222222222222222222222222

	Next ; Ubound Array Loop
	
If WinExists($FileSplit &" - ViewMate") Then
	WinActivate($FileSplit &" - ViewMate")
	Sleep(100)
	Send("!{F4}")	
		
EndIf	
Exit
;Next





