;================================================================================================================================
;
; List Generator (AKA Key Gen)
; by: SkinnyWhiteGuy
; Date: 04/06/2007
; 
; Purpose: I was bored, and wanted this, so I made it
; Use: Give it a list of characters, and starting and stopping points, and it will Generate every form of password that
;      can be made from the list, duplicate letters included.
;
; Credits: Koda Form Designer for the GUI (awesome software).
;		   Thorsten Meger for script examples on GUI manipulation.
;          Ch1ldProd1gy for the idea (at least, for bringing the idea to the board, so I would want to do it enough to make this)
;
;================================================================================================================================

#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=g:\autoit scripts\listgen.kxf
$ListGen = GUICreate("List Generator", 350, 164, 328, 135)
$Inp_Letters = GUICtrlCreateInput("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", 16, 24, 321, 21)
$Lab_Letters = GUICtrlCreateLabel("Set of characters to generate keys from:", 16, 8, 193, 15)
$Lab_Start = GUICtrlCreateLabel("Shortest Entry:", 32, 56, 73, 17)
$Lab_End = GUICtrlCreateLabel("Longest Entry:", 32, 80, 72, 17)
$Inp_Start = GUICtrlCreateInput("1", 104, 56, 33, 21)
$Inp_End = GUICtrlCreateInput("3", 104, 80, 33, 21)
$But_Gen = GUICtrlCreateButton("Generate!", 152, 56, 81, 49, 0)
$But_Close = GUICtrlCreateButton("Close", 240, 56, 73, 49, 0)
$Prog_Done = GUICtrlCreateProgress(16, 112, 321, 17)
GUICtrlSetData($Prog_Done, 0)
$Lab_Perc = GUICtrlCreateLabel("Percentage Complete:", 32, 136, 128, 17)
$Lab_Len = GUICtrlCreateLabel("Current Key Length:", 200, 136, 106, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $But_Close
			Exit
		Case $But_Gen
			; Get values from GUI
			$let = GUICtrlRead($Inp_Letters)
			$start = GUICtrlRead($Inp_Start)
			$end = GUICtrlRead($Inp_End)
			
			; Error Checking for eroneous values
			If Int($start) < 1 Then
				MsgBox(0, "Error", "Please enter only whole numbers above 0 into Shortest Entry.")
				ContinueLoop
			EndIf
			
			If Int($end) < 1 Then
				MsgBox(0, "Error", "Please enter only whole numbers above 0 into Longest Entry.")
				ContinueLoop
			EndIf
			
			If $start > $end Then
				MsgBox(0, "Error", "Put the lesser number into the Shortest Entry box, and the greater number into the Longest Entry box.")
				ContinueLoop
			EndIf
			
			; If we've made it this far, Calculations Continue
			Global $current = 0
			Global $total = 0
			
			; Go ahead and create the file for usage
			Global $file_path = FileSaveDialog("Where to Save Output?",@DesktopDir & "\", "Text files (*.txt)", 16 , "output.txt")
			$file = FileOpen($file_path,2)
			FileClose($file)
			
			; Make the array of letters to use, and get the progress bar info ready
			Global $letters = StringSplit($let,"")
			For $len = $start To $end
				$total += $letters[0]^$len
			Next
			
			; This actually runs the Calculations
			For $len = $start to $end
				GUICtrlSetData($Lab_Len, "Current Key Length: " & $len)
				Gen_File($len)
			Next
			
			; Everything is Done, Tell the User, Show the User, and Reset the Form
			MsgBox(4096, "File Generator", "Done!")
			Run("notepad.exe " & $file_path)
			GUICtrlSetData($Prog_Done, 0)
			GUICtrlSetData($Lab_Perc, "Percentage Complete:")
			GUICtrlSetData($Lab_Len, "Current Key Length:")
	EndSwitch
WEnd

Func Gen_File($length)
	; Setup Variables
	Dim $temp, $file
	Dim $perc = 0
	Dim $old_perc = 0
	Dim $position[$length+1]
	$position[0] = $length
	For $i = 1 to $position[0]
		$position[$i] = 1
	Next
	
	; Main Loop for Calculations
	While 1
		; Get each character at each position, and load it into the temp var
		For $i = 1 to $position[0]
			$temp = $temp & $letters[$position[$i]]
		Next
		
		; Go ahead and write it to File, so if it is interupted, you still get a partial file
		$file = FileOpen($file_path, 1)
		FileWrite($file, $temp & @CRLF)
		FileClose($file)
		$temp = "" ; Reset Temp here so that on the next pass, we don't rewrite the same line to the file
		
		; Percentage complete calculations/display
		$current += 1
		$perc = Round(($current * 100) / $total,0)
		If $perc > $old_perc Then
			GUICtrlSetData($Prog_Done, $perc)
			GUICtrlSetData($Lab_Perc, "Percentage Complete: " & $perc)
			$old_perc = $perc
		EndIf
		
		; Keep track of which character is where, and when one goes above the max number of characters input,
		; carry over and reset that level.
		$position[$length] += 1
		For $i = $length To 1 Step - 1
			If $position[$i] > $letters[0] AND $i <> 1 Then
				$position[$i - 1] += 1
				$position[$i] = 1
			ElseIf $position[$i] > $letters[0] AND $i == 1 Then
				Return $temp ; This is just here to make the function return when done, so we don't get stuck forever
			EndIf
		Next
	WEnd
EndFunc