#cs -----------------------------------------------------------------------------------------------------------------------------------------
;    
;    AutoIt Version: 3.3.0.0
;    Author:         Dan Maxwell
;    
;    Script Function:
;    Automatically applies money via the ACAS screen
;    
#ce -----------------------------------------------------------------------------------------------------------------------------------------

; Includes
#include <Excel.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

; Options
Opt("GUIOnEventMode", 1); Change to OnEvent mode
Opt("GUIResizeMode", 1); Keeps the GUI window from being resized by the user

; Variable List
Global $iB1, $iC1, $iE1, $iV1, $iZ1
Global $sCompanyCode, $sPolicyNumber, $iClicks, $sTotal, $sFuncCode, $sTran1Code, $iTran1Date, $sTran2Code, $iTran2Amount
Global $sMessage, $vPath, $sFilePath1, $oExcel, $fVisible, $sPolicyNumber, $sTempPolNumber, $sCompanyCode, $bDelete, $Admin
Global $Form1_1, $iRowStartInput, $iRowEndInput, $sRowStartLabel, $sRowEndLabel
Global $OKButton, $CancelButton

; -------------------------------------------------------------------------------------------------------------------------------------------- ;

; Makes sure the ADMINISTRATOR is open so test can proceed
MsgBox(262208, "The ADMINISTRATOR", "You must be logged into The ADMINISTRATOR in order to proceed", 30)

; Stops this script if the ADMINISTRATOR is not open
If WinExists("The ADMINISTRATOR") Then
    Sleep(100)
Else
    MsgBox(262160, "Error", "The ADMINISTRATOR is not open.  Exiting...", 5)
    Exit
EndIf

; Sets the window handle of the ADMINISTRATOR window for easier scripting throughout the rest of this script
$Admin = WinGetHandle("The ADMINISTRATOR")

; Choose the Excel Spreadsheet you would like to reference; opens after the GUI interaction
$sMessage = "Please choose the file with the policy listing"
$vPath = FileOpenDialog($sMessage, @DesktopCommonDir & "\", "Excel Spreadsheet (*.xls)", 1 + 4)
 
 If @error = 1 Then
    MsgBox(262160, "Error", "The ADMINISTRATOR is not open.  Exiting...", 5)
    Exit
EndIf
; -------------------------------------------------------------------------------------------------------------------------------------------- ;

; This creates the window GUI form
#Region ### START Koda GUI section ### Form=c:\documents and settings\sadmm\my documents\my dropbox\work\gpin\form1.kxf
$Form1_1 = GUICreate("ACAS Entry Form", 349, 185, 315, 167)

; Tells which row is the first row to read (aka the beginning of your list)
$sRowStartLabel = GUICtrlCreateLabel("Which row would you like to start reading from?", 72, 24, 261, 19)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$iRowStartInput = GUICtrlCreateInput("", 16, 24, 33, 23)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")

; Tells which row is the last row to read (aka the end of your list)
$sRowEndLabel = GUICtrlCreateLabel("What is the last row to read from?", 72, 80, 187, 19)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$iRowEndInput = GUICtrlCreateInput("", 16, 80, 33, 22)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")


; Creates the OK and Cancel buttons on the GUI
$OKButton = GUICtrlCreateButton("OK", 73, 136, 75, 25, 0)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
GUICtrlSetOnEvent($OKButton, "OKButton")
$CancelButton = GUICtrlCreateButton("Cancel", 209, 136, 75, 25, 0)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
GUICtrlSetOnEvent($CancelButton, "CancelButton")

; Shows the GUI window to the user
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

; Dictates the behavior of the window
While 1
    Sleep(1000); Sets window to idle
WEnd

Func OKButton() ; When you press the 'OK' button
    $iB1 = GUICtrlRead($iRowStartInput);
    $iC1 = GUICtrlRead($iRowEndInput);
    GUISetState(@SW_HIDE, $Form1_1)
	Run_Excel($iB1, $iC1)
EndFunc   ;==>OKButton

Func CancelButton()
    ;Note: at this point @GUI_CTRLID would equal $CancelButton,
    ;and @GUI_WINHANDLE would equal $mainwindow
    Exit
EndFunc   ;==>CancelButton

Func SpecialEvents()
    Select
        Case @GUI_CtrlId = $GUI_EVENT_CLOSE
            Exit

        Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE

        Case @GUI_CtrlId = $GUI_EVENT_RESTORE

    EndSelect
EndFunc   ;==>SpecialEvents

; -------------------------------------------------------------------------------------------------------------------------------------------- ;

Func Run_Excel($iB1, $iC1)
    ; Opens the Add_Contract script
    $sFilePath1 = $vPath
    ; Sets the spreadsheet to appear or stay invisible
    $fVisible = 1
    $oExcel = _ExcelBookOpen($sFilePath1, $fVisible)
    ;Sets the Sheet to the actual script and not other sheets within the script
    _ExcelSheetActivate($oExcel, 1)


    ; Tells the loop to run from row # to #
    For $iE1 = $iB1 To $iC1
       
	   ; Variables involved in successfully filling out an ACAS acreen
       $sCompanyCode = _ExcelReadCell($oExcel, $iE1, 1)
	   $sPolicyNumber = _ExcelReadCell($oExcel, $iE1, 2)
	   $iClicks = _ExcelReadCell($oExcel, $iE1, 4)
	   $sFuncCode = ("A")
	   $sTran1Code = _ExcelReadCell($oExcel, $iE1, 9)
	   $iTran1Amount = _ExcelReadCell($oExcel, $iE1, 10)
	   $iTran1Date = _ExcelReadCell($oExcel, $iE1, 12)
	   $sTran2Code = _ExcelReadCell($oExcel, $iE1, 17)
	   $iTran2Amount = _ExcelReadCell($oExcel, $iE1, 19)
	   $sTempPolNumber = $SPolicyNumber
	   $iV1 = ($iE1+($iClicks-1))
	
	
        ; Procedures
		; Goes to the ACAS screen
        WinActivate($Admin)
        WinMove($Admin, "", 0, 0)
        MouseClick("left", 110, 65, 1)
		Sleep(25)
        Send("ACAS")
        Sleep(25)
        Send($sPolicyNumber)
        Send("{TAB}")
        Sleep(25)
		Send($sCompanyCode)
		Sleep(25)
        Send("{F11}")
        Sleep(500)
		
		; Creates ACAS lines for processing in the amount of $iClicks (i.e. - $iClicks = 9, 9 lines are created in ACAS)
		Mouseclick("left", 312, 540, $iClicks)
		Mouseclick("left", 80, 308, 1)
		
			; Loops from the current row to the last row of the current policy number (aka, current row + $iClicks)
			For $iZ1 = $iE1 To $iV1
			; Exits the loop when the policy numbers no longer match
			;If $iZ1 = $iE1 + 4 Then $sPolicyNumber = 2
			If _ExcelReadCell($oExcel, $iZ1, 2)<> $sTempPolNumber Then ExitLoop
			; Creates and enters the information in the ACAS blanks until the next policy number
			WinActivate($Admin)
			Sleep(25)
			Send($sFuncCode)
			Send("{ENTER}")
			Send("{TAB}")
			Sleep(25)
			Send("{CTRLDOWN}{DOWN}{CTRLUP}")
			Sleep(100)
			Send($sTran1Code)
			Send("{CTRLDOWN}{ENTER}{CTRLUP}")
			Send("{TAB 3}")
			Sleep(25)
			Send($iTran1Amount)
			Send("{TAB 4}")
			Sleep(25)
			Send($iTran1Date)
			Send("{TAB 4}")
			Sleep(25)
			Send($iTran1Amount)
			Send("{TAB 6}")
		
			Next
	
	
		; Puts the total from the current transaction in the Total Credits and Net Amount to Cash boxes
		$sTotal = ($iTran1Amount*$iClicks)
		WinActivate($Admin)
		MouseClick("left", 495, 200, 1)
		
		; I am adding 5 so it does not actually process (Invalid Totals)!
		Send($sTotal)
		
		Send("{TAB}")
		Sleep(25)
		Send($sTotal)
		Sleep(25)
	
		; Processes the transaction
		Send("{F4}")
		Sleep(25)
		
		; Because the processing of ACAS can be a random act time-wise, This msgbox allows the script to pause until it is finished
		MsgBox(262192, "ACAS", "Click OK when the ACAS has finished processing", 60)
	
		; Goes to the DSCM screen
        WinActivate($Admin)
        MouseClick("left", 110, 65, 1)
		Sleep(25)
        Send("DSCM")
        Sleep(25)
        Send($sPolicyNumber)
        Send("{TAB}")
        Sleep(25)
		Send($sCompanyCode)
		Sleep(25)
        Send("{F11}")
        Sleep(500)
		
		; This Msgbox pause allows the user to take a screenshot of the DSCM if it is needed
		MsgBox(262192, "Screenshot Message", "Please take a screenshot of the DSCM <if necessary> and press OK to move on.    ", 0)
		
		; Checks to see if we have gotten to the end of the range entered by the user
        If $iZ1 > $iC1 Then ExitLoop
		
		; Next - in case the user entered the lines wrongly, is there a policy number to read? 
		; read the policynumber cell on line $iV1 and exit if it is blank
        If _ExcelReadCell($oExcel, ($iZ1), 2) = "" Then ExitLoop
		
		; So there is another policy to read in
		; But first we must reduce the count value by one, because the Next statement below will increase it by one and so we would skip a line if we did not!
		; So set the loop variable as so:
        $iE1 = $iZ1 - 1


	; Goes on to the next policy and starts the loop all over again
    Next

; -------------------------------------------------------------------------------------------------------------------------------------------- ;

	; Closes the Excel spreadsheet
    _ExcelBookClose($oExcel, 1, 0)
    
	; Closes the GUI window as the script is finished
    GUISetState(@SW_SHOW, $Form1_1)

EndFunc   ;==>Run_Excel

Exit