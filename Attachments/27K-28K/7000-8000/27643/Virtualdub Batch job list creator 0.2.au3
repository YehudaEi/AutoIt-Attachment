#AutoIt3Wrapper_Res_SaveSource=y
#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.0.0
 Author:         goldenix

 Script Usage: Virtualdub / Virtualdubmod

			Just crete a template job list with virtualdub [F4 then save job list] , then drag & drop your files into gui.

			Exit GUI to finalize making the batch file

			It will be saved in the same dir as the original template file only renamed to _*.jobs

	Notes: Files output dir will be same as where your original files are, only renamed to _*.avi
			To choose manually optput dir change _declare_default_output_dir(True) to _declare_default_output_dir(False)

	http://www.autoitscript.com/forum/index.php?showtopic=100808
#ce ----------------------------------------------------------------------------
#include <Array.au3>
#include <file.au3>

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $avArray, $header, $body, $tempfilearray	; arrays
Global $File, $GUI				; gui globals
Global $total_jobs_nr  = 0		; start counting nr of jobs from 0 this way first job is nr 1
Global $current_job_nr = 0		;same as previous, except we count current job number

Global $numjob			= '// $numjobs ' ; number of jobs

Global $job 			= '// $job "Job '
Global $input 			= '// $input'
Global $output			= '// $output'
Global $Default_output	= _declare_default_output_dir(True) ; change to false to select output folder with folderselectdialog

Global $VirtualDub_Open	= 'VirtualDub.Open'
Global $VirtualDub_Save = 'VirtualDub.Save'

Global $temp_file = 'temp.txt'

FileDelete($temp_file)

Opt("GUIOnEventMode", 1)

$template =	_select_template()

			_read_template_to_array($template)


			;## Create 2 new arrays HEader & body, we add footer at program exit
			;~ ---------------------------------------------------------------------
			$end_of_header_array = _create_header_array()
;~ 			_ArrayDisplay($header, "$header")

									_create_body_array($end_of_header_array)
;~ 									_ArrayDisplay($body, "$body")


Func _declare_default_output_dir($Default_output)

	If $Default_output = False Then

		$Default_output = FileSelectFolder("Save all Files to:", "",4)
			If Not @error = 1 Then ; if we browse dir & hit OK

				If Not FileExists($Default_output) Then
					MsgBox(0,'Error','Folder does not exist!')
					_declare_default_output_dir(False)
				EndIf

			Else ; Cancel pressed
				Exit
			EndIf

	Else
		$Default_output = True
	EndIf

	Return $Default_output & '\'
EndFunc

Func _select_template()

	;## select job list template
	$var = FileOpenDialog('Select template', @ScriptDir & "\", "job list (*.jobs)", 1 + 4 )
		If @error Then
			Exit	; no files choses
		Else
			$var = StringReplace($var, "|", @CRLF)
		EndIf

	Return $var
EndFunc

Func _read_template_to_array($TEMPLATE)
		;## read file to array
		Dim $avArray
		If Not _FileReadToArray($TEMPLATE,$avArray) Then
		   MsgBox(4096,"Error", " Error reading log to Array  "&$TEMPLATE& @CRLF & "error:" & @error)
		   Exit
		EndIf
;~ 	 	_ArrayDisplay($avArray)
EndFunc

Func _create_header_array()

	Dim $header[1] ; create header array
;~ 	-------------------------------------
		For $y = 1 to $avArray[0] ; Pharse first array until [// $job "Job 1"] = create header

			If $avArray[$y] = '// $job "Job 1"' Then ExitLoop

			ReDim $header[$y+1] ; add a row

			$header[$y] = $avArray[$y]

		Next
		$z = $y ; header ends hire
;~ 	 _ArrayDisplay($header, "$header")

	Return $z
EndFunc

Func _create_body_array($end_of_header_array)

	Dim $body[1] ; create body array
;~ 	-------------------------------------
		For $y = 1 to $avArray[0] ; find the end of the header so we can start creating body

			If $y >= $end_of_header_array Then ExitLoop
		Next

		$i = 1
		For $y = $end_of_header_array to $avArray[0] ; start creating body

			If $avArray[$y] = '// $done' Then ExitLoop

			ReDim $body[$i+1] ; add a row

			$body[$i] = $avArray[$y]

			$i = $i + 1
		Next
;~ 	 _ArrayDisplay($body, "$body")

EndFunc
#cs *********************************************************************************

End of script startup

Now we can create the GUI start dropping files into it & mod arrays

#ce *********************************************************************************

#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate($GUI, 200, 90, -1+200, -1+200,-1,$WS_EX_ACCEPTFILES)
	WinSetOnTop($Form1,'',1)
	GUISetBkColor(0xf2f2f2)
	GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUIRegisterMsg(0x233, "On_WM_DROPFILES")
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")

While 1
    Sleep(100)
WEnd



Func _pharse_File()

	$split = StringSplit($File,'\')

	$filepath = StringReplace($File,$split[$split[0]],'') 	; Filepath
	$Filename = $split[$split[0]]							; Filename

	If $Default_output = True Then $Default_output = $filepath

	ToolTip('Working: ' & $Filename,0,0)

;~ 	ConsoleWrite($Filename & @CRLF)

	;## Modify body
;~ 	********************************************************************
;~ 	**********************************************************************
		For $y = 1 to UBound($body) -1 ; pharse body

		;## current Job number
;~ 		------------------------------------------
			If StringInStr($body[$y], $job) Then

;~ 				ConsoleWrite($body[$y] & @CRLF)

;~ 				$stringreplace = StringReplace($body[$y],$job,'')

				_ArrayDelete($body,$y)
				_ArrayInsert($body,$y,$job & $total_jobs_nr +1)

;~ 				ConsoleWrite($body[$y] & @CRLF)
			EndIf
;~ 		------------------------------------------


		;## Input
;~ 		------------------------------------------
			If StringInStr($body[$y], $input) Then

;~ 				ConsoleWrite($body[$y] & @CRLF)

				$split	= StringSplit($body[$y],'"',1)

				$stringreplace = StringReplace($body[$y],$split[2],$File)

				_ArrayDelete($body,$y)
				_ArrayInsert($body,$y,$stringreplace)

;~ 				ConsoleWrite($body[$y] & @CRLF)
			EndIf
;~ 		------------------------------------------


		;## Output , Default is @scriptdir, change $Default_output = false to bring up file save as
		;## sample:
;~ 					before	file.avi
;~ 					after	_file.avi
;~ 		------------------------------------------
			If StringInStr($body[$y], $output) Then

;~ 				ConsoleWrite($body[$y] & @CRLF)

				$split	= StringSplit($body[$y],'"',1)

				$stringreplace = StringReplace($body[$y],$split[2],$Default_output & '_' & $Filename)

				_ArrayDelete($body,$y)
				_ArrayInsert($body,$y,$stringreplace)

;~ 				ConsoleWrite($body[$y] & @CRLF & @CRLF)
			EndIf
;~ 		------------------------------------------


	;## VirtualDub.Open
;~ 		------------------------------------------
			If StringInStr($body[$y], $VirtualDub_Open) Then

;~ 				ConsoleWrite($body[$y] & @CRLF)

				$split	= StringSplit($body[$y],'"',1)

				$stringreplace = StringReplace($body[$y],$split[2],$File)
				$stringreplace = StringReplace($stringreplace,'\','\\')

				_ArrayDelete($body,$y)
				_ArrayInsert($body,$y,$stringreplace)

;~ 				ConsoleWrite($body[$y] & @CRLF)
			EndIf
;~ 		------------------------------------------

	;## VirtualDub.Save
;~ 		------------------------------------------
			If StringInStr($body[$y], $VirtualDub_Save) Then

;~ 				ConsoleWrite($body[$y] & @CRLF)

				$split	= StringSplit($body[$y],'"',1)

				$stringreplace = StringReplace($body[$y],$split[2],$Default_output & '_' & $Filename)
				$stringreplace = StringReplace($stringreplace,'\','\\')

				_ArrayDelete($body,$y)
				_ArrayInsert($body,$y,$stringreplace)

;~ 				ConsoleWrite($body[$y] & @CRLF & @CRLF)
			EndIf
;~ 		------------------------------------------

	$_LINE = $body[$y]
	FileWriteLine($temp_file,$_LINE & @CRLF)
;~ 	ConsoleWrite($_LINE & @CRLF)

	Next;==>Pharse body
;~ 	**********************************************************************
;~ 	**********************************************************************


;## Add +1 job nr into header [// $numjobs 1, +1 etc...]
;~ 	====================================================================
		For $y = 1 to UBound($header) -1 ; find [numjobs] in the header

			If StringInStr($header[$y], $numjob) Then

;~ 				ConsoleWrite($numjob & $total_jobs_nr +1 & @CRLF)

				_ArrayDelete($header,$y)
				_ArrayInsert($header,$y,$numjob & $total_jobs_nr +1)

			EndIf
		Next
;~ 	====================================================================


	$total_jobs_nr = $total_jobs_nr +1
	ToolTip('')
EndFunc


Func _create_batch_jobslist()

	;## readfile to array & then write both arrays to file


	;## Template destanation
		$split = StringSplit($template,'\')

		$filepath = StringReplace($template,$split[$split[0]],'') 	; Filepath
		$Filename = $split[$split[0]]								; Filename

		$new_template = $filepath & '_' & $Filename


		if FileExists($new_template) Then ; if file exists
		;------------------------------------------------
			$filepath = StringTrimRight($filepath,1)

			$var = FileSaveDialog( "Choose a name.", $filepath, "job list template (*.jobs)", 2,'_' & $Filename)
				; option 2 = dialog remains until valid path/file selected

				If @error Then
;~ 					MsgBox(4096,"","Save cancelled.")
					Exit
				Else
					$new_template = $var

					if FileExists($new_template) Then ; if file exists
						$msbox = MsgBox(1, 'Info!', 'File already Exists Overvrite?')

						If $msbox = 2 then ; cancelled
							_create_batch_jobslist()
						Else
							FileDelete($new_template)
						EndIf
					EndIf

				EndIf
		EndIf
		;--------------------------------------------------

		;## read file to array
		Dim $tempfilearray
		If Not _FileReadToArray($temp_file,$tempfilearray) Then
		   MsgBox(4096,"Error", " Error reading log to Array  "&$temp_file& @CRLF & "error:" & @error)
		   Exit
		EndIf

	;## Delete temp file
		FileDelete($temp_file)

		For $y = 1 to UBound($header) -1 ; pharse body
			FileWriteLine($new_template, $header[$y] & @CRLF)
		Next

		For $y = 1 to UBound($tempfilearray) -1 ; pharse body
			FileWriteLine($new_template, $tempfilearray[$y] & @CRLF)
		Next
EndFunc



Func On_WM_DROPFILES($hWnd, $Msg, $wParam, $lParam)
    Local $tDrop, $aRet, $iCount
    ;string buffer for file path
    $tDrop = DllStructCreate("char[260]")
    ;get file count
    $aRet = DllCall("shell32.dll", "int", "DragQueryFile", _
                                            "hwnd", $wParam, _
                                            "uint", -1, _
                                            "ptr", DllStructGetPtr($tDrop), _
                                            "int", DllStructGetSize($tDrop) _
                                            )
    $iCount = $aRet[0]
    ;get file paths
    For $i = 0 To $iCount-1
        $aRet = DllCall("shell32.dll", "int", "DragQueryFile", _
                                                "hwnd", $wParam, _
                                                "uint", $i, _
                                                "ptr", DllStructGetPtr($tDrop), _
                                                "int", DllStructGetSize($tDrop) _
                                                )

		$File = DllStructGetData($tDrop, 1)
		_pharse_File()
    Next

    ;finalize
    DllCall("shell32.dll", "int", "DragFinish", "hwnd", $wParam)

	_exit()
EndFunc


Func _exit()

	FileWriteLine($temp_file,'// $done' & @CRLF)

	_create_batch_jobslist()

	MsgBox(0, '', 'Done')

;~ 	MsgBox(0, '', 'Done')

	Exit
EndFunc



