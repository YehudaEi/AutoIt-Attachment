#include-once																									;Only include this file once if more then one file calls it

; #INDEX# =======================================================================================================================
; Title .........: Kris UDF
; AutoIt Version : 3.3.6.1+
; Version........: 1.16.25 - 4/29/2011
;				   Version delimit shall be Release.Functions.Build
; Language ......: English
; Description ...: A Series of UDF's that I'll use often
; Remarks........: To add to the UDFs, use the au3.UserUdfs.properties file
; Author(s) .....: Kris Mills <kmills at dmp dot com>
; ===============================================================================================================================

#Include <Array.au3>																							;For use with _TimeToTicksEx
#Include <Color.au3>																							;For use with _RandomColor
#Include <Date.au3>																								;For use with _TicksToTimeEx
#Include <GuiMenu.au3>																							;For use with _ClickMenu
;_CreateBuild()																									;Create a build when the script is run with F5

; #CURRENT# =====================================================================================================================
; FUNCTIONS:
; _Array2DClearBlanks
; _ClickMenu
; _CreateBuild
; _ForceInsigZero
; _GetDate
; _PauseScript
; _RandomColor
; _TCPListen
; _TCPSend
; _TicksToTimeEx
; _TimeAddition
; _TimeDifference
; _TimeToTicksEx
; _ToolTipTimer
;
; INTERNAL USE ONLY:
; _TCPConnectThenReceive
; _TCPListenThenSend
; ===============================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Array2DClearBlanks
; Description ...: Removes all blank lines from a 2D or 1D array
; Syntax.........: _Array2DClearBlanks( $Array [, $2DSize = 2 ] )
; Parameters ....: $Array	- The array to remove the blank lines from
;				   $2DSize	- [optional] The size of the 2nd dimension of the array. For example, the $x in $Array[1][$x]. Default is 2
;										 Entering 0 for this parameter means the array is one dimensional.
; Return values .: The array without the blanks
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......:
; UserCallTip....: _Array2DClearBlanks( array , "2D size" ) Remove all completely blank lines from a 2D or 1D array.(required: #include <KrisUDF.au3>)
; Modified.......: 3/25/2011 - Created, commented, added function header
;				   4/26/2011 - Added the 1D functionality
; ===============================================================================================================================
Func _Array2DClearBlanks($Array,$2DSize = 2)
	Local $Pass = 0, $i, $j																		;Declare the local variables, $Pass, $i, and $j
	If $2DSize = 0 Then																			;If the user selected a 1 dimensional array, then
		Dim $ArrayPass[2]																		;Declare the 1 dimensional array
		For $i = 1 to UBound($Array) - 1														;Start a For loop that will run for the size of the array
			If $Array[$i] <> "" Then															;If the given array value is not blank, then
				ReDim $ArrayPass[1 + $Pass]														;Increase the size of the new array
				$ArrayPass[$Pass] = $Array[$i]													;Write the value of the given array to the new array
				$Pass += 1																		;Add one to the value of $Pass
			EndIf
		Next																					;Perform the next iteration of the For loop
		Return $ArrayPass																		;Return the new array
	EndIf
	Dim $ArrayPass[2][$2DSize]																	;Declare the local $ArrayPass 2D array
	For $i = 1 To UBound ($Array) - 1															;Start the For loop that will run for the size of the array
		If $Array[$i][0] <> "" Then																;If the array line is NOT blank, then
			ReDim $ArrayPass[$Pass + 1][$2DSize]												;Increase the size of the second array
				For $j = 0 To $2DSize - 1														;Start a For loop that will run for each of the second dimensions
					$ArrayPass[$Pass][$j] = $Array[$i][$j]										;Set the $ArrayPass array equal to the $Array array
				Next																			;Perform the next iteration of the For loop
			$Pass += 1																			;Increase the value of $Pass by 1
		EndIf
	Next																						;Perform the next iteration of the For loop
	Return $ArrayPass																			;Return the array
EndFunc   ;==>_Array2DClearBlanks

; #FUNCTION# ====================================================================================================================
; Name...........: _ClickMenu
; Description ...: To click a given menu item. Will work for sub items and sub-sub items
; Syntax.........: _ClickMenu ( [$Window_Name = "" [, $Main_Number = 1 [, $Sub_Number = 1 [, $Spacers = 0 [, $Sub_Sub = 0 [, $Sub_Spacers = 0 [, $Mouse_Button = "left" [, $Clicks = 1 [, $Mouse_Move_Speed = 10 ]]]]]]]]] )
; Parameters ....: $Window_Name		- [optional] The name of the window containing the menu. Default is the active window
;				   $Main_Number		- [optional] The main menu item number to be clicked. File is index 0. Default is 0
;				   $Sub_Number		- [optional] The sub item number to be clicked. First sub item is 1. Enter 0 to only click the main menu item. Default is 1
;				   $Spacers			- [optional] The number of spacers (lines) between the given sub item and the top of the sub menu items. Default is 0
;				   $Sub_Sub			- [optional] The number of the sub menu item of the sub menu items. Default is 0
;				   $Sub_Spacers		- [optional] The number of spacers (lines) between the given sub-sub item and the top of the sub-sub items. Default is 0
;				   $Mouse_Button	- [optional] The mouse button to click. Default is "left"
;				   $Clicks			- [optional] The number of times to click the mouse. Default is 1
;				   $Mouse_Move_Speed- [optional] The speed to move the mouse. The default is 10
; Return values .: Success - Returns an array with the passed test results
;					   $Test_Results[0] - Type of test returned. In this case, "Menu Click"
;					   $Test_Results[1] - The Main menu number, given by the user
;					   $Test_Results[2] - The Sub menu number, given by the user
;					   $Test_Results[3] - The Sub-Sub number, given by the user
;					   $Test_Results[4] - 1 - Signifying the function has passed
;                  Failure - Returns an array with the failed test results
;					   $Test_Results[0] - Type of test returned. In this case, "Menu Click"
;					   $Test_Results[1] - The Main menu number, given by the user
;					   $Test_Results[2] - The Sub menu number, given by the user
;					   $Test_Results[3] - The Sub-Sub number, given by the user
;					   $Test_Results[4] - The error given by the function
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: The reason I chose to increase the line count of this function by repeatedly naming the $ClickXPos and $ClickYPos was due to the confusing and lengthy
;				   nature of the variables. To use them verbatim in each place would have been much harder to edit and understand later as well as increasing the size of the function.
; Required.Files.: <GuiMenu.au3>
; UserCallTip....: _ClickMenu ( ["window" [, "menu index" [, "sub menu index" [, "spacers" [, "sub-sub index" [, "sub spacers" [, "button" [, "clicks" [, "speed" ]]]]]]]]] ) Click a given menu item. Works with sub menu items and sub-sub menu items.(required: #include <KrisUDF.au3>)
; Modified.......: 12/30/2010 - Created the function
;				   1/3/2011	  - Edited to use the results array rather than the @error codes
;				   3/29/2011  - Added the User Call Tip to the function header
; ===============================================================================================================================
Func _ClickMenu($Window_Name = "", $Main_Number = 0, $Sub_Number = 1, $Spacers = 0, $Sub_Sub = 0, $Sub_Spacers = 0, $Mouse_Button = "left", $Clicks = 1, $Mouse_Move_Speed = 10)
	Dim $Test_Results[5]																		;Initialize the results array
	$Test_Results[0] = "Menu Click"																;Write the type "Menu Click" to the results array
	$Test_Results[1] = $Main_Number																;Write the main menu index number to the results array
	$Test_Results[2] = $Sub_Number																;Write the sub-menu index number to the results array
	$Test_Results[3] = $Sub_Sub																	;Write the sub-sub index number to the results array
	If $Window_Name = "" Then $Window_Name = WinGetTitle("[active]")							;Get active window if the user did not provide one
	$hMenu = _GUICtrlMenu_GetMenu(WinGetHandle($Window_Name))									;Get the handle to the main menu of the window
	AutoItSetOption("MouseCoordMode", 1)														;Set the AutoIt coord option to MouseCoordMode
	$Menu_Rectangle = _GUICtrlMenu_GetItemRect(WinGetHandle($Window_Name), $hMenu, $Main_Number) ;Get the rectangle sizes and positions of the main menu items
	If $Main_Number = -1 Or $Menu_Rectangle[1] = "" Then 										;If the menu did not exist, then
		$Test_Results[4] = "The main menu did not exist."										;Write the error to the results array
		Return $Test_Results																	;Return the results array with the error
	Else																						;If the menu does exist, then
		$Test_Results[4] = "The main menu item click failed. The button is not in the list or invalid parameters were given, such as x without y." ;Write the error to the results array. Will be overwritten if the function passes
		$ClickXPos = ($Menu_Rectangle[0]+($Menu_Rectangle[2]-$Menu_Rectangle[0])/2)				;Set the original main menu X-Coord
		$ClickYPos = ($Menu_Rectangle[1]+($Menu_Rectangle[3]-$Menu_Rectangle[1])/2)				;Set the original main menu Y-Coord
		$ClickError = MouseClick($Mouse_Button, $ClickXPos, $ClickYPos, $Clicks, $Mouse_Move_Speed) ;Click the main menu item
			If $ClickError = 0 Then Return $Test_Results										;Return the results array with the error
		$Test_Results[4] = "The sub menu item click failed. The button is not in the list or invalid parameters were given, such as x without y." ;Write the error to the results array. Will be overwritten if the function passes
		$ClickYPos = ($ClickYPos+(($Menu_Rectangle[3]-$Menu_Rectangle[1])*($Sub_Number+($Spacers*.5)))) ;Set the sub menu Y-Coord
		$ClickError = MouseClick($Mouse_Button, $ClickXPos, $ClickYPos, $Clicks, $Mouse_Move_Speed) ;Click the sub menu item
			If $ClickError = 0 Then Return $Test_Results										;Return the results array with the error
		If $Sub_Sub <> 0 Then																	;If the user has indicated a sub sub menu to click, then,
			$Test_Results[4] = "The sub-sub item click failed. The button is not in the list or invalid parameters were given, such as x without y." ;Write the error to the results array. Will be overwritten if the function passes
			$ClickXPos = $ClickXPos+200															;Update the X-Coord for the sub sub menu item
			MouseMove($ClickXPos,$ClickYPos,$Mouse_Move_Speed)									;Move the mouse to the right, preserving the sub sub menu
			$ClickYPos = ($ClickYPos+(($Menu_Rectangle[3]-$Menu_Rectangle[1])*(($Sub_Sub+($Sub_Spacers*.5))-1))) ;Update the Y-Coord for the sub sub menu item
			$ClickError = MouseClick($Mouse_Button,$ClickXPos,$ClickYPos, $Clicks, $Mouse_Move_Speed) ;Click the sub-sub menu item
				If $ClickError = 0 Then Return SetError(4,0,-1)									;Send error 4 - The sub sub menu click failed. The button is not in the list or invalid parameters were given, such as x without y
		EndIf
		$Test_Results[4] = 1																	;Write 1 to the results array
	EndIf
EndFunc   ;==>_ClickMenu

; #FUNCTION# ====================================================================================================================
; Name...........: _CreateBuild
; Description ...: This function creates a build archive with log and previous build files. Can be a user defined location, or the script location
; Syntax.........: _CreateBuild( [ $ArchiveLocation = @ScriptDir ] )
; Parameters ....: $ArchiveLocation - [optional] The directory to use for the archive location. Default is @ScriptDir
; Return values .: Nones
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Required.Files.: If used outside of the KrisUDF, must include the KrisUDF - #include <KrisUDF.au3>, uses the _GetDate() function from KrisUDF
; Remarks........: This function will ONLY run if the script is uncompiled.
; UserCallTip....: _CreateBuild ( [ "archive location" ] ) Creates a build archive with log and previous build files. Can be a user defined location, or the script location. (required: #include <KrisUDF.au3>)
; Modified.......: 4/11/2011 - Created, commented, added a function header
;				   4/12/2011 - Added the "Create new build?" prompt
;				   4/14/2011 -
; ===============================================================================================================================
Func _CreateBuild($ArchiveLocation = @ScriptDir)
	Local $BuildChanges, $BuildCurrent, $BuildLog, $BuildName									;Declare the local variables to use in this function
	If @Compiled = 1 Then Return																;Only executes the function if the script is not compiled
	If MsgBox(68,"Create New Build","Create new build?") = 7 Then Return						;Ask if the user would like to create a new build. If not, exit the function
	If FileExists($ArchiveLocation & "\BuildLog.ini") = 0 Then FileWrite($ArchiveLocation & "\BuildLog.ini","[CurrentBuild]" & @CRLF & "CurrentBuild=0" & @CRLF) ;If the Log file does not exist, create one with build number 0
	If FileExists($ArchiveLocation & "\BuildLog.ini") = 1 Then $BuildLog = FileOpen($ArchiveLocation & "\BuildLog.ini",1) ;If the file does exist, open it in Write mode
	$BuildCurrent = IniRead($ArchiveLocation & "\BuildLog.ini","CurrentBuild","CurrentBuild",0) ;Get the current build number from the INI file
	$BuildChanges = InputBox("Create New Build", _GetDate() & " - " & @HOUR & ":" & @MIN & @CRLF & @CRLF & "New Build Number: " & $BuildCurrent + 1 & @CRLF & @CRLF & _ ;First line of code prompting the user for change information
					"Please write a short description of the changes made in this build.","","",200,200) ;Second line of code prompting the user for change information
	If $BuildChanges = "" Then $BuildChanges = "Changes not noted."								;If the user does not include change information, write "Changes not noted."
	FileWrite($BuildLog, @CRLF & "===== Build: " & $BuildCurrent + 1 & " - " & _GetDate() & " - "  & @HOUR & ":" & @MIN & " =====" & @CRLF & "     " & $BuildChanges) ;Write the new build information to the Log file
	IniWrite($ArchiveLocation & "\BuildLog.ini","CurrentBuild","CurrentBuild",$BuildCurrent + 1) ;Change the current version to the new build number
	FileClose($BuildLog)																		;Close the Log file
	$BuildName = StringTrimRight(@ScriptName,4)													;Get the script name by removing the file extension from the filename
	FileCopy(@ScriptFullPath, $ArchiveLocation & "\Builds\" & $BuildName & "_v" & $BuildCurrent + 1 & ".au3",9) ;Copy the script in the Builds folder for archiving
EndFunc   ;==>_CreateBuild

; #FUNCTION# ====================================================================================================================
; Name...........: _ForceInsigZero
; Description ...: Forces insignificant zeroes onto the end of a number string. Also can be used to define exactly how many decimal places to be return
; Syntax.........: _ForceInsigZero( $Number [, $DecimalPlaces = 2 ] )
; Parameters ....: $Number 			- The original number to be modified
;				   $DecimalPlaces 	- [optional] The amount of decimal places to be returned. If this is lower than the current amount
;												 of decimal places, the extras are removed. If this is above the current amount, zeroes are added
; Return values .: The modified number
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......:
; UserCallTip....: _ForceInsigZero ( "number" [, "decimal places" ] ) Forces insignificant zeroes onto the end of a number string. Also can be used to define exactly how many decimal places to be return.(required: #include <KrisUDF.au3>)
; Modified.......: 3/31/2011 - Created, commented, and added a function header
; ===============================================================================================================================
Func _ForceInsigZero($Number, $DecimalPlaces = 2)
	Dim $aNumber[3]																				;Declare the array to be used in this function
	If StringInStr($Number,".") <> 0 Then														;If the string does include a . , then
		$aNumber = StringSplit($Number,".")														;Delimit the string based on .
	Else																						;If the string does not include a . , then
		$aNumber[1] = $Number																	;Set the aNumber[1] to the given number
	EndIf
	If $DecimalPlaces > 0 Then																	;If the user chose to have decimal places, then
		If $DecimalPlaces < StringLen($aNumber[2]) Then Return $aNumber[1] & "." & StringLeft($aNumber[2],$DecimalPlaces) ;If the given decimal places is lower than the length of the string, return the shortened number
		For $i = StringLen($aNumber[2]) To $DecimalPlaces - 1									;Start a For loop. This will repeat for each added zero
			$aNumber[2] = $aNumber[2] & "0"														;Add a zero to the end of the string
		Next																					;Perform the next iteration of the For loop
		Return $aNumber[1] & "." & $aNumber[2]													;Return the full number with added zeros
	Else																						;If the user chose not to have decimal places, then
		Return $aNumber[1]																		;Return only the integer
	EndIf
EndFunc   ;==>_ForceInsigZero

; #FUNCTION# ====================================================================================================================
; Name...........: _GetDate
; Description ...: Retrieves the current date in the following format: "Monday, March 28, 2011"
; Syntax.........: _GetDate()
; Parameters ....: None
; Return values .: The date in a string formatted as "Monday, March 28, 2011"
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Uses the internal computer dates
; UserCallTip....: _GetDate ( ) Retrieves the current date in the following format: "Monday, March 28, 2011" (required: #include <KrisUDF.au3>)
; Modified.......: 3/29/2011 - Created, commented, add function header
; ===============================================================================================================================
Func _GetDate()
	Local $sWDay, $sMonth, $sDay																;Declare the local variables for use in this function
	Select																						;Start a Select conditional statement
		Case @WDAY = 1																			;If the weekday number is 1, then
			$sWDay = "Sunday"																	;Write Sunday to the $sWDay variable
		Case @WDAY = 2																			;If the weekday number is 2, then
			$sWDay = "Monday"																	;Write Monday to the $sWDay variable
		Case @WDAY = 3																			;If the weekday number is 3, then
			$sWDay = "Tuesday"																	;Write Tuesday to the $sWDay variable
		Case @WDAY = 4																			;If the weekday number is 4, then
			$sWDay = "Wednesday"																;Write Wednesday to the $sWDay variable
		Case @WDAY = 5																			;If the weekday number is 5, then
			$sWDay = "Thursday"																	;Write Thursday to the $sWDay variable
		Case @WDAY = 6																			;If the weekday number is 6, then
			$sWDay = "Friday"																	;Write Friday to the $sWDay variable
		Case @WDAY = 7																			;If the weekday number is 7, then
			$sWDay = "Saturday"																	;Write Saturday to the $sWDay variable
	EndSelect																					;End the day Select conditional statement
	Select																						;Start a Select conditional statement
		Case @MON = 1																			;If the month number is 1, then
			$sMonth = "January"																	;Write January to the $sMonth variable
		Case @MON = 2																			;If the month number is 2, then
			$sMonth = "February"																;Write February to the $sMonth variable
		Case @MON = 3																			;If the month number is 3, then
			$sMonth = "March"																	;Write March to the $sMonth variable
		Case @MON = 4																			;If the month number is 4, then
			$sMonth = "April"																	;Write April to the $sMonth variable
		Case @MON = 5																			;If the month number is 5, then
			$sMonth = "May"																		;Write May to the $sMonth variable
		Case @MON = 6																			;If the month number is 6, then
			$sMonth = "June"																	;Write June to the $sMonth variable
		Case @MON = 7																			;If the month number is 7, then
			$sMonth = "July"																	;Write July to the $sMonth variable
		Case @MON = 8																			;If the month number is 8, then
			$sMonth = "August"																	;Write August to the $sMonth variable
		Case @MON = 9																			;If the month number is 9, then
			$sMonth = "September"																;Write September to the $sMonth variable
		Case @MON = 10																			;If the month number is 10, then
			$sMonth = "October"																	;Write October to the $sMonth variable
		Case @MON = 11																			;If the month number is 11, then
			$sMonth = "November"																;Write November to the $sMonth variable
		Case @MON = 12																			;If the month number is 12, then
			$sMonth = "December"																;Write December to the $sMonth variable
	EndSelect																					;End the month Select conditional statement
	$sDay = @MDAY																				;Write the @MDAY value to the $sDay variable
	If @MDAY < 10 Then $sDay = StringTrimLeft(@MDAY,1)											;If the day is less than 10, remove the leading 0
	Return $sWDay & ", " & $sMonth & " " & $sDay & ", " & @YEAR									;Return the date string
EndFunc   ;==>_GetDate

; #FUNCTION# ====================================================================================================================
; Name...........: _MilitaryToStandard
; Description ...: Converts a given military timestamp in a standard time stamp. Returns in HH:MM:SS AM/PM or HH:MM AM/PM
; Syntax.........: _MilitaryToStandard( $Time [, $Seconds = 1 ] )
; Parameters ....: $Time	- The time to convert to standard, can be entered as any of the following:
;							(Military)		(Standard)
;							- HH			- HH A			- HH AM			- HH P			- HH PM
;							- HH:MM			- HH:MM A		- HH:MM AM		- HH:MM P		- HH:MM PM
;							- HH:MM:SS		- HH:MM:SS A	- HH:MM:SS AM	- HH:MM:SS P	- HH:MM:SS PM
;				   $Seconds - [optional] Sets wether or not the seconds are returned or just hours and minutes. 1 is shown, 0 is not shown. Default is 1
; Return values .: Success - The timestamp in the format HH:MM:SS or HH:MM or the numerical value HH.MM
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......:
; Required.File..: #include <Date.au3> and #include <Array.au3> - Both are included as part of this UDF
; UserCallTip....: _MilitaryToStandard( "time" [, "seconds" ] ) Converts a military time to a standard time. (required: #include <KrisUDF.au3>)
; Modified.......: 3/29/2011 - Created, commented, added a function header
; ===============================================================================================================================
Func _MilitaryToStandard($Time, $Seconds = 1)
	$Ticks = _TimeToTicksEx($Time)																;Convert the given time to ticks
	Return _TicksToTimeEx($Ticks, $Seconds,0,1)													;Return the standard time
EndFunc   ;==>_MilitaryToStandard

; #FUNCTION# ====================================================================================================================
; Name...........: _PauseScript
; Description ...: Pauses the script and prompts the user to return to the script, or exit
; Syntax.........: _PauseScript()
; Parameters ....: None
; Return values .: None
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......:
; UserCallTip....: _PauseScript ( ) Pause the script and prompt the user to end or continue.(required: #include <KrisUDF.au3>)
; Modified.......: 3/8/2011
; ===============================================================================================================================
Func _PauseScript()
	$Pause_Msg = MsgBox(4164, "Script Paused", "The script has been paused. Do you wish to resume the script?") ;Prompt the user to eithe continue or end the script
	If $Pause_Msg = 7 Then Exit																	;If the user selects to end the script, then exit
EndFunc   ;==>_PauseScript

; #FUNCTION# ====================================================================================================================
; Name...........: _RandomColor
; Description ...: This function randomly generates the hex code of a color and returns the color and its RGB values based on user input
; Syntax.........: _RandomColor( [ $sOutput = 0 ] )
; Parameters ....: $sOutput - [optional] If only the string of the hex value is needed, enter 0. If an array with the hex code
;										 and the RGB values is needed, enter anything besides 0. Default is 0
; Return values .: If $sOutput = 0  - If the user chose 0, the function returns a string with the hex value of the randomly generated color.
;				   If $sOutput <> 0 - If the user input anything besides 0, the function returns an array with the hex value as well as the RGB values
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: This function requires #include <Color.au3> if used outside of this UDF
; UserCallTip....: _RandomColor ( [ "output" ] ) Randomly generate a color and its hex code if output is 0, else returns a hex code and the RGB values.(required: #include <KrisUDF.au3>)
; Modified.......: 4/25/2011 - Created, commented, added function header
; ===============================================================================================================================
Func _RandomColor($sOutput = 0)
	Dim $arColor[4]																				;Declare the local array used in this function
	Local $srColor = "0x", $sIsAlpha, $sAddDig													;Declare the local variabels used in this function
	For $i = 1 To 6																				;Start a For loop. This will repeat 6 times
		$sIsAlpha = Random(1,10,1)																;Generate a random number between 1 and 10
		If $sIsAlpha <= 7 Then $sAddDig = Random(0,9,1)											;If that number is 7 or below, set the $sAddDig variable to a random number between 0 and 9
		If $sIsAlpha > 7 Then																	;If that number is 8 or above, then
			$sAddDig = Random(1,6,1)															;Set the $sAddDig variable to a random numer between 1 and 6
				Select																			;Begin a Select conditional
					Case $sAddDig = 1															;If the $aAddDig variable it 1, then
						$sAddDig = "A"															;Set the $sAddDig variable to A
					Case $sAddDig = 2															;If the $aAddDig variable it 2, then
						$sAddDig = "B"															;Set the $sAddDig variable to B
					Case $sAddDig = 3															;If the $aAddDig variable it 3, then
						$sAddDig = "C"															;Set the $sAddDig variable to C
					Case $sAddDig = 4															;If the $aAddDig variable it 4, then
						$sAddDig = "D"															;Set the $sAddDig variable to D
					Case $sAddDig = 5															;If the $aAddDig variable it 5, then
						$sAddDig = "E"															;Set the $sAddDig variable to E
					Case $sAddDig = 6															;If the $aAddDig variable it 6, then
						$sAddDig = "F"															;Set the $sAddDig variable to F
				EndSelect																		;End the Select conditional
			EndIf
		$srColor = $srColor & $sAddDig															;Add the new digit to the end of the hex variable
	Next																						;Perform the next iteration of the For loop
	If $sOutput = 0 Then Return $srColor														;If the user has select to only receive a string, return the string
	$arColor[0] = $srColor																		;Set the color string to the 0 value in the $arColor array
	$arColor[1] = _ColorGetBlue($arColor[0])													;Set the Blue value to the 1 value in the $arColor array
	$arColor[2] = _ColorGetGreen($arColor[0])													;Set the Green value to the 2 value in the $arColor array
	$arColor[3] = _ColorGetRed($arColor[0])														;Set the Red value to the 3 value in the $arColor array
	Return $arColor																				;Return the $arColor array
EndFunc   ;==>_RandomColor

; #FUNCTION# ====================================================================================================================
; Name...........: _TCPListen
; Description ...: Listens on an open port for a connection and a message from an external source.
; Syntax.........: _TCPListen ( $ListenIP, $ConnectIP, $Port, [ $Message = "Ack" ] )
; Parameters ....: $ListenIP  - The IP to listen on. (The user computer's IP)
;				   $ConnectIP - The IP to connect to. (The client's IP)
;			       $Port 	  - The Port to connect over
;				   $Message   - [optional] The acknowledgement message to be sent. Default is "Ack"
; Return values .: The message
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Used in conjuction with _TCPSend
; UserCallTip....: _TCPListen ( "listen ip", "connect ip", "port" [, "message" ]) Listens on an open port for a connection and a message from an external source.(required: #include <KrisUDF.au3>)
; Modified.......: 4/25/2011 - Created, commented, added function header
; ===============================================================================================================================
Func _TCPListen($ListenIP, $ConnectIP, $Port, $Message = "Ack")
	_TCPListenThenSend($ListenIP,$Port,$Message)												;Run the listening function
	Return _TCPConnectThenReceive($ConnectIP,$Port)											;Run the sending function
EndFunc   ;==>_TCPListen

; #FUNCTION# ====================================================================================================================
; Name...........: _TCPSend
; Description ...: Sends a message of a given IP and listens for a response.
; Syntax.........: _TCPSend ( $ConnectIP, $ListenIP, $Port, [ $Message = "Ack" ] )
; Parameters ....: $ConnectIP - The IP to connect to. (The client's IP)
;				   $ListenIP  - The IP to listen on. (The user computer's IP)
;			       $Port 	  - The Port to connect over
;				   $Message   - [optional] The acknowledgement message to be sent. Default is "Ack"
; Return values .: None
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Used in conjunction with _TCPListen
; UserCallTip....: _TCPSend ( "connect ip", "listen ip", "port" [, "message" ]) Sends a message of a given IP and listens for a response.(required: #include <KrisUDF.au3>)
; Modified.......: 4/25/2011 - Created, commented, added function header
; ===============================================================================================================================
Func _TCPSend($ConnectIP, $ListenIP, $Port, $Message = "Ack")
	_TCPConnectThenReceive($ConnectIP,$Port)													;Run the sending function
	_TCPListenThenSend($ListenIP,$Port,$Message)												;Run the listening function
EndFunc   ;==>_TCPSend

; #FUNCTION# ====================================================================================================================
; Name...........: _TicksToTimeEx
; Description ...: Converts a tick count to time in the following format HH:MM:SS or HH:MM or the numerical representation HH.MM
; Syntax.........: _TicksToTimeEx( $iTicks [, $Seconds = 1 [, $Convert = 0 [, $Standard = 0 [, $Milli ]]]] )
; Parameters ....: $iTicks 	 - The number of ticks to convert
;				   $Seconds  - [optional] Sets wether or not the seconds are returned or just hours and minutes. 1 is shown, 0 is not shown. Default is 1
;				   $Convert  - [optional] Sets wether or not the resulting time is converted to the numerical representation of the number. 1 is convert, 0 is don't convert. Default is 0
;				   $Standard - [optional] Sets wether or not the time is returned in Standard time rather than military time. 1 is Standard, 0 is military. Default is 0
;				   $Milli	 - [optional] Sets wether or not the seconds will be rounded to the nearest second, or show the milliseconds. 1 shows the milliseconds, 0 does not. Default is 0
; Return values .: Success - The timestamp in the format HH:MM:SS.MS, HH:MM:SS, HH:MM or HH.MM
;				   Failure - 0
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: May include options for other formats later.
;				   Standard mode won't be used very often.
; Required.File..: #include <Date.au3> - This is included as part of this UDF
; UserCallTip....: _TicksToTimeEx ( "ticks" [, "seconds" [, "convert" [, "standard" [, "milliseconds" ]]]] ) Converts a tick count to time in the following format - HH:MM:SS.MS, HH:MM:SS, HH:MM or the numerical representation HH.MM (required: #include <KrisUDF.au3>)
; Modified.......: 3/8/2011  - Created, commented, added function header
;				   3/29/2011 - Added the $Seconds, $Convert, and $Standard coding and functionality
;				   3/30/2011 - Changed the $iExt to include the " " rather than an extra space in the return
;				   5/2/2011  - Added the millisecond functionality to the function
; ===============================================================================================================================
Func _TicksToTimeEx($iTicks, $Seconds = 1, $Convert = 0, $Standard = 0, $Milli = 0)
	Local $iHours, $iMins, $iSecs, $iExt, $iMilli = ""											;Set the local time variables
	If $Milli = 1 Then																			;If the user has selected to use the Milliseconds, then
		$iMilli = StringRight($iTicks,3)														;Return the millisecond value
		$iTicks = StringTrimRight($iTicks,3) & "000"											;Get the new iTicks value (remove the milliseconds and add '000')
	EndIf
	$Fail = _TicksToTime($iTicks,$iHours,$iMins,$iSecs)											;Run the original TicksToTime function
	If $Fail = 0 Then Return 0																	;If the TicksToTime function fails, return 0
	If StringLen($iHours) = 1 Then $iHours = 0 & $iHours										;Pad the Hours number with a leading 0 if only one digit
	If StringLen($iMins) = 1 Then $iMins = 0 & $iMins											;Pad the Minutes number with a leading 0 if only one digit
	If StringLen($iSecs) = 1 Then $iSecs = 0 & $iSecs											;Pad the Second number with a leading 0 if only one digit
	If $Convert = 1 Then 																		;If the user chose to convert, then
		If $iHours < 10 Then $iHours = StringTrimLeft($iHours,1)								;If $iHours is less then ten, remove the leading 0
		$iMins = StringTrimLeft(Round($iMins/60,2),2)											;Convert $iMins to the numerical value
		If $iMins = "" Then Return $iHours														;If $iMins is blank, return just the hours
		Return $iHours & "." & $iMins															;Return the time in a numerical value
	EndIf
	If $Standard = 1 Then																		;If the user has chosen to return the value in standard time, then
		If $iHours < 12 Then $iExt = " AM"														;If the time is below 12:00 PM then write AM
		If $iHours >= 12 Then $iExt = " PM"														;If the time is above 12:00 PM then write PM
		If $iHours >= 13 Then $iHours = $iHours - 12											;If the time is 1 PM or above, subtract 12 from the value
		If $iHours = "00" Then $iHours = 12														;If the time is 12 AM, set the $iHours to 12
	EndIf
	If $Seconds = 0 Then Return $iHours & ":" & $iMins & $iExt									;If the user chose not to see seconds, return only hours and minutes
	If $Milli = 1 Then Return $iHours & ":" & $iMins & ":" & $iSecs & "." & $iMilli				;If the user chose to return milliseconds, return the resulting timestamp
	Return $iHours & ":" & $iMins & ":" & $iSecs & $iExt										;Return the resulting timestamp
EndFunc   ;==>_TicksToTimeEx

; #FUNCTION# ====================================================================================================================
; Name...........: _TimeAddition
; Description ...: Adds two times together and returns the sum in the following format HH:MM:SS or HH:MM or the numerical representation HH.MM
; Syntax.........: _TimeAddition( $StartTime, $AddTime [, $Seconds = 1 [, $Convert = 0 [, $Standard = 0 ]]] )
; Parameters ....: $StartTime - The beginning amount of time to be added to, can be entered as any of the following:
;							(Military)		(Standard)
;							- HH			- HH A			- HH AM			- HH P			- HH PM
;							- HH:MM			- HH:MM A		- HH:MM AM		- HH:MM P		- HH:MM PM
;							- HH:MM:SS		- HH:MM:SS A	- HH:MM:SS AM	- HH:MM:SS P	- HH:MM:SS PM
;				   $AddTime	  - The amount of time to add to the given time, can be entered as any of the following:
;							(Military)		(Standard)
;							- HH			- HH A			- HH AM			- HH P			- HH PM
;							- HH:MM			- HH:MM A		- HH:MM AM		- HH:MM P		- HH:MM PM
;							- HH:MM:SS		- HH:MM:SS A	- HH:MM:SS AM	- HH:MM:SS P	- HH:MM:SS PM
;				   $Seconds   - [optional] Sets wether or not the seconds are returned or just hours and minutes. 1 is shown, 0 is not shown. Default is 1
;				   $Convert   - [optional] Sets wether or not the resulting time is converted to the numerical representation of the number. 1 is convert, 0 is don't convert. Default is 0
;				   $Standard  - [optional] Sets wether or not the time is returned in Standard time rather than military time. 1 is Standard, 0 is military. Default is 0
;				   $Milli	  - [optional] Sets wether or not the seconds will be rounded to the nearest second, or show the milliseconds. 1 shows the milliseconds, 0 does not. Default is 0
; Return values .: Success - The timestamp in the format HH:MM:SS or HH:MM
;				   Failure - 0
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: May include options for other formats later.
;				   Standard mode won't be used very often.
; Required.File..: #include <Date.au3> - This is included as part of this UDF
; UserCallTip....: _TimeAddition ( "start time" , "add time" [, "second" [, "convert" [, "standard" [, "milliseconds" ]]]] ) Adds to the times together and returns in the following timestamp formats - HH:MM:SS or HH:MM or the numerical representation HH.MM (required: #include <KrisUDF.au3>)
; Modified.......: 3/30/2011 - Created, commented, added function header
;				   5/2/2011  - Added the millisecond functionality
; ===============================================================================================================================
Func _TimeAddition($StartTime, $AddTime, $Seconds = 1, $Convert = 0, $Standard = 0, $Milli = 0)
	Local $TimeA = _TimeToTicksEx($StartTime),$TimeB = _TimeToTicksEx($AddTime)					;Declare the variables to be used in this function
	Return _TicksToTimeEx($TimeA + $TimeB,$Seconds, $Convert, $Standard, $Milli) 				;Return the sum of the two times in the user given form
EndFunc   ;==>_TimeAddition

; #FUNCTION# ====================================================================================================================
; Name...........: _TimeDifference
; Description ...: Calculates the difference between two timestamps. Returns in HH:MM:SS or HH:MM or the numerical representation HH.MM
; Syntax.........: _TimeDifference( $StartTime, $EndTime [, $Seconds = 1 [, $Convert = 1 ]] )
; Parameters ....: $StartTime 	- The beginning timestamp, can be entered as any of the following:
;							(Military)		(Standard)
;							- HH			- HH A			- HH AM			- HH P			- HH PM
;							- HH:MM			- HH:MM A		- HH:MM AM		- HH:MM P		- HH:MM PM
;							- HH:MM:SS		- HH:MM:SS A	- HH:MM:SS AM	- HH:MM:SS P	- HH:MM:SS PM
;							- HH:MM:SS.MS	- HH:MM:SS.MS A	- HH:MM:SS.MS AM- HH:MM:SS.MS P	- HH:MM:SS.MS PM
;				   $EndTime		- The ending timestamp, can be entered as any of the following:
;							(Military)		(Standard)
;							- HH			- HH A			- HH AM			- HH P			- HH PM
;							- HH:MM			- HH:MM A		- HH:MM AM		- HH:MM P		- HH:MM PM
;							- HH:MM:SS		- HH:MM:SS A	- HH:MM:SS AM	- HH:MM:SS P	- HH:MM:SS PM
;							- HH:MM:SS.MS	- HH:MM:SS.MS A	- HH:MM:SS.MS AM- HH:MM:SS.MS P	- HH:MM:SS.MS PM
;				   $Seconds 	- [optional] Sets wether or not the seconds are returned or just hours and minutes. 1 is shown, 0 is not shown. Default is 1
;				   $Convert 	- [optional] Sets wether or not the resulting time is converted to the numerical representation of the number. 1 is convert, 0 is don't convert. Default is 0
;				   $Milli	 	- [optional] Sets wether or not the seconds will be rounded to the nearest second, or show the milliseconds. 1 shows the milliseconds, 0 does not. Default is 0
; Return values .: Success - The timestamp in the format HH:MM:SS or HH:MM or the numerical value HH.MM
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......:
; Required.File..: #include <Date.au3> and #include <Array.au3> - Both are included as part of this UDF
; UserCallTip....: _TimeDifference( "start time", "end time" [, "seconds" [, "convert" [, "milliseconds" ]]]) Calculate the difference between two different times.(required: #include <KrisUDF.au3>)
; Modified.......: 3/29/2011 - Created, commented, added a function header
;				   5/2/2011  - Shortened it up a bit, and added the millisecond functionality
;							 - Commented out the reverse difference ability, as it messed up the Time Scheduler
; ===============================================================================================================================
Func _TimeDifference($StartTime, $EndTime, $Seconds = 1, $Convert = 0, $Milli = 0)
	Local $TimeA = _TimeToTicksEx($StartTime),$TimeB = _TimeToTicksEx($EndTime)					;Declare the variables to be used in this function
;	If $TimeA > $TimeB Then Return _TicksToTimeEx($TimeA - $TimeB, $Seconds, $Convert, "", $Milli) ;Return the timestamp of the difference between Time A and Time B
	Return _TicksToTimeEx($TimeB - $TimeA, $Seconds, $Convert, "", $Milli)						;Return the timestamp of the difference between Time A and Time B
EndFunc   ;==>_TimeDifference

; #FUNCTION# ====================================================================================================================
; Name...........: _TimeToTicksEx
; Description ...: Converts a given time (In Military, Standard, or Numeric) to a tick amount
; Syntax.........: _TimeToTicksEx( $Time [, $Numeric = 0 ] )
; Parameters ....: $Time - The time to convert to ticks. Format can be any of the following:
;							(Military)		(Standard)														(If Numeric = 1)
;							- HH			- HH A			- HH AM			- HH P			- HH PM			- N
;							- HH:MM			- HH:MM A		- HH:MM AM		- HH:MM P		- HH:MM PM		- N.N
;							- HH:MM:SS		- HH:MM:SS A	- HH:MM:SS AM	- HH:MM:SS P	- HH:MM:SS PM	- etc.
;							- HH:MM:SS.MS	- HH:MM:SS.MS A	- HH:MM:SS.MS AM- HH:MM:SS.MS P	- HH:MM:SS.MS PM
; Return values .: Success - The tick amount
;				   Failuer - 0 - Denotes that a user tried to enter a time value as a numeric value.
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......:
; Required.File..: #include <Date.au3> and #include <Array.au3> - Both are included as part of this UDF
; UserCallTip....: _TimeToTicksEx ( "time" [, "numeric" ] ) Converts a time (Standard A/P/AM/PM, Military, or Numeric) to a tick amount.(required: #include <KrisUDF.au3>)
; Modified.......: 3/29/2011 - Created, commented, added a function header
;				   3/31/2011 - Removed the $Ticks variable from the last line (Return $Ticks) and just directly returned the result
;							 - Added the numeric functionality
;				   5/2/2011	 - Added the milliseconds functionality to the function
; ===============================================================================================================================
Func _TimeToTicksEx($Time, $Numeric = 0)
	Dim $TimeArray[3], $DecArray[2]																;Declare the local arrays for use in this function
	Local $AM = 0, $PM = 0																		;Declare the local variables for use in this function
	If $Numeric = 1 Then																		;If the user has selected to return a numeric value, then
		If StringInStr($Time,":") <> 0 Then Return 0											;If the given time is in a timestamp, return an error
		$Time = _ForceInsigZero($Time,2)														;Force the number to contain two decimal places
		$TimeArray = StringSplit($Time,".")														;Delimit the string based on .
		Return _TimeToTicks($TimeArray[1],Round((($TimeArray[2]*60)/100),0))					;Return the tick value for the entered numerical value
	EndIf
	If StringInStr($Time,"A") <> 0 Or StringInStr($Time,"P") <> 0 Then							;If the string contains an A or a P
		If StringInStr($Time,"A") <> 0 Then $AM = 1												;Set the $AM variable to 1 if the time is AM
		If StringInStr($Time,"P") <> 0 Then $PM = 12											;If the time is P or PM, then set the $PM variable to 12
		If StringInStr($Time,"M") = 0 Then $Time = StringTrimRight($Time,2)						;If the string does not contain an M, remove two characters from the right
		If StringInStr($Time,"M") <> 0 Then $Time = StringTrimRight($Time,3)					;If the string contains an M, remove three characters from the right
	EndIf
	$TimeArray = StringSplit($Time,":")															;Delimit the string based on ":"
	If $TimeArray[1] = 12 And $AM = 1 Then $TimeArray[1] = "00"									;Set the hours to 00 if the time was 12 AM
	If $TimeArray[1] <> 12 Then $TimeArray[1] = $TimeArray[1] + $PM								;Add the $PM value to the hour variable in the array if the value is already 12
	If UBound($TimeArray) = 2 Then _ArrayAdd($TimeArray,"00")									;If there is no second value, make it "00"
	If UBound($TimeArray) = 3 Then _ArrayAdd($TimeArray,"00")									;If there is no third valur, make it "00"
	If StringInStr($TimeArray[3],".") <> 0 Then 												;If there are milliseconds in the seconds time, then
		$DecArray = StringSplit($TimeArray[3],".")												;Delimit the string at the decimal
		$Ticks = _TimeToTicks($TimeArray[1],$TimeArray[2],$DecArray[1])							;Get the ticks value
		Return $Ticks + $DecArray[2]															;Add the milliseconds to the ticks value
	EndIf
	Return _TimeToTicks($TimeArray[1],$TimeArray[2],$TimeArray[3])								;Get the ticks of the time and return the value
EndFunc   ;==>_TimeToTicksEx

; #FUNCTION# ====================================================================================================================
; Name...........: _ToolTipTimer
; Description ...: Creates a simple timer (with an optional message) that shows the time on the Tool Tip.
; Syntax.........: _ToolTipTimer( [ $iTime = 5 [, $iMessage = "" ]] )
; Parameters ....: $iTime    - The time for the timer, in seconds. Default is 5
;				   $iMessage - Any simple message to display (such as test status). Enter "" for no message. Default is no message
; Return values .: Failuer   - -1 - Denotes that a user tried to enter a time below 1 second
; Author ........: Kris Mills <fett8802 at gmail dot com>
; UserCallTip....: _ToolTipTimer ( [ "time" [, "message" ]] ) Creates a simple timer (with an optional message) that shows the time on the Tool Tip.(required: #include <KrisUDF.au3>)
; Modified.......: 4/29/2011 - Created, commented, added a function header
; ===============================================================================================================================
Func _ToolTipTimer($iTime = 5, $iMessage = "")
	If $iTime < 1 Then Return -1																;If the user enters an incorrect value for time, return -1
	$iTime = Round($iTime,0)																	;Round to the nearest whole number to eliminate user error
	For $i = 1 To $iTime																		;Start a For loop that will repeat for as long as the user gave
		If $iMessage = "" Then ToolTip($iTime - $i)												;If no message was given, simply display the time left
		If $iMessage <> "" Then ToolTip($iMessage & " - " & ($iTime - $i))						;If a message was given, display the message followed by the time left
		Sleep(1000)																				;Sleep for 1 second
	Next																						;Perform the next iteration of the For loop
	ToolTip("")																					;Clear the Tool Tip
EndFunc   ;==>_ToolTipTimer


; ===============================================================================================================================
; FUNCTIONS BELOW THIS MARKER ARE FOR INTERNAL USE ONLY. NOT FOR USE OUTSIDE THIS UDF
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _TCPConnectThenReceive
; Description ...: This function establishes a connection to a given IP over a given Port and receives a message
; Syntax.........: _TCPConnectThenReceive ( $IP, $Port )
; Parameters ....: $IP   - The IP to connect to
;			       $Port - The Port to connect over
; Return values .: Returns the received message
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: THIS FUNCTION IS FOR INTERNAL USE ONLY. NOT FOR USE OUTSIDE THIS UDF
; Modified.......: 4/25/2011 - Created, commented, added function header
; ===============================================================================================================================
Func _TCPConnectThenReceive($IP, $Port)
	Local $Socket, $sMessage, $Ack = "", $sTimeOut = 0														;Declare the local variables for use in this function
	TCPStartup()																							;Start the TCP protocol
	$Socket = TCPConnect($IP, $Port)																		;Connect to the given IP over the given Port
		If $Socket = -1 Or $Socket = 0 Then Return @error													;If the connection is not established, return @error
	Do																										;Start a Do loop. This will repeat until the Until contidition is met
		$sMessage = TCPRecv($Socket,9999)																	;Receive data from the socket
		$sTimeOut += 1																						;Increase the timeout counter by 1
	Until $sMessage <> "" Or $sTimeOut = 10000																;Perform the next iteration of the Do loop until the Until condition is met
	TCPCloseSocket($Socket)																					;Close the TCP socket
	TCPShutdown()																							;Shut down the TCP protocol
	If $sTimeOut = 10000 Then Return 3																		;If TimeOut occured, return 3
	Return $sMessage																						;Return the received message
EndFunc   ;==>_TCPConnectThenReceive

; #FUNCTION# ====================================================================================================================
; Name...........: _TCPListenThenSend
; Description ...:
; Syntax.........: _TCPListenThenSend ( $IP, $Port, [ $Message = "Ack" ] )
; Parameters ....: $IP   	- The IP to connect to
;			       $Port 	- The Port to connect over
;				   $Message - [optional] The acknowledgement message to be sent. Default is "Ack"
; Return values .: Success - 1
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: THIS FUNCTION IS FOR INTERNAL USE ONLY. NOT FOR USE OUTSIDE THIS UDF
; Modified.......: 4/25/2011 - Created, commented, added function header
; ===============================================================================================================================
Func _TCPListenThenSend($IP, $Port, $Message = "Ack")
	Local $Socket, $ConnectedSocket = 0																		;Declare the local variabels for use in this function
	TCPStartup()																							;Start the TCP protocol
	$Socket = TCPListen($IP, $Port)																			;Listen over the given IP and the given Port
	If $Socket = -1 Or $Socket = 0 Then Return @error														;If the listen connection failed, return @error
	Do																										;Start a Do loop. This will repeat until the Until condition is met
		$ConnectedSocket = TCPAccept($Socket)																;Accept a incoming connection over the listening socket
	Until $ConnectedSocket >= 0																				;Perform the next iteration of the Do loop until the Until condition is met
	TCPSend($ConnectedSocket,$Message)																		;Send the message of the connected socket
	TCPCloseSocket($ConnectedSocket)																		;Close the connected socket
	TCPCloseSocket($Socket)																					;Close the listening socket
	Return 1																								;Return 1 to indicate a successful send
EndFunc   ;==>_TCPListenThenSend
