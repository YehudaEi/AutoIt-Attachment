;Define Constants
#Include <GuiConstants.au3>
#Include <Array.au3>

$Add_Student_Close = -1

$StudentData = @ScriptDir & '\StudentData\'
$StudentDataLen = StringLen($StudentData)
$PrepMonth = 'January;February;March;April;May;June;July;August;September;October;November;December'
$Month_Array = StringSplit($PrepMonth,';')
$PrepDay = 'Monday;Tuesday;Wednesday;Thursday;Friday;Saturday;Sunday'
$Day_Array= StringSplit($PrepDay,';')

$EditStyle = BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY)

;Make ComboBox style read only
$ComboStyle = BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL, $CBS_SORT)
$GradeData = '|1|2|3|4|5'
;Set some initial Values
$val = ''
$1_2ComboData = ''
$num = 0

;Search through the .ini file to list names of classes
While $Val <> 'Error' 
	$Num = $Num + 1
	$1_2ComboData = $1_2ComboData & '|' & $Val
	$Val = IniRead(@ScriptDir & '\Main.ini', 'Classes 1_2',$Num,'Error')
WEnd
$1_2ComboData = StringTrimLeft($1_2ComboData,1)

$val = ''
$3_4ComboData = ''
$num = 0

;Search through the .ini file to list names of classes
While $Val <> 'Error' 
	$Num = $Num + 1
	$3_4ComboData = $3_4ComboData & '|' & $Val
	$Val = IniRead(@ScriptDir & '\Main.ini', 'Classes 3_4',$Num,'Error')
WEnd
$3_4ComboData = StringTrimLeft($3_4ComboData,1)

;Load the Edit History

	

;Make Gui
$MainTitle = 'Student Personell Manager'
$Main_Window = GUICreate($MainTitle,280,320)


GUICtrlCreateLabel('Grade',10,5,100,20)
$Student_Information_Grade = GuiCtrlCreateCombo('',10,20,40,100,$ComboStyle)
GuiCtrlSetData(-1,$GradeData)
GUICtrlCreateLabel('Students Name',60,5,100,20)
$Student_Information_StudentName = GuiCtrlCreateCombo('',60,20,180,100,$ComboStyle)

GUICtrlCreateTab(0,45,285,325)
;Student Info Tab
GuiCtrlCreateTabItem('Student Information')
GUICtrlCreateLabel('Date:',10,70,40,20)
$Student_Information_Date = GuiCtrlCreateDate('Date:',50,70,200,20)
GUICtrlCreateLabel('First Class',10,105,125,20)
$Student_Information_Class1 = GuiCtrlCreateCheckbox('',10,120,125,20)
GUICtrlCreateLabel('Second Class',145,105,125,20)
$Student_Information_Class2 = GuiCtrlCreateCheckBox('',145,120,125,20)
GUICtrlCreateLabel('Third Class',10,145,125,20)
$Student_Information_Class3 = GuiCtrlCreateCheckbox('',10,160,125,20)
GUICtrlCreateLabel('Fourth Class',145,145,125,20)
$Student_Information_Class4 = GuiCtrlCreateCheckbox('',145,160,125,20)
GUICtrlCreateGroup('Discipline',3,185,275,130)
$Student_Information_Comment = GuiCtrlCreateInput('',10,200,150,20)
$Student_Information_Add_Comment = GuiCtrlCreateButton('Add Comment',170,200,80,20)
$Student_Information_Discipline_Read = GUICtrlCreateEdit('',10,230,265,80, $EditStyle)


;Student Input Tab
GuiCtrlCreateTabItem('Edit Student')
GUICtrlCreateLabel('First Class',10,70,125,20)
$Edit_Student_Class1 = GuiCtrlCreateCombo('',10,85,125,100,$ComboStyle)
GUICtrlSetData(-1,'|' & $1_2ComboData)
GUICtrlCreateLabel('Second Class',145,70,125,20)
$Edit_Student_Class2 = GuiCtrlCreateCombo('',145,85,125,100,$ComboStyle)
GUICtrlSetData(-1,'|' & $1_2ComboData)
GUICtrlCreateLabel('Third Class',10,110,125,20)
$Edit_Student_Class3 = GuiCtrlCreateCombo('',10,125,125,100,$ComboStyle)
GUICtrlSetData(-1,'|' & $3_4ComboData)
GUICtrlCreateLabel('Fourth Class',145,110,125,20)
$Edit_Student_Class4 = GuiCtrlCreateCombo('',145,125,125,100,$ComboStyle)
GUICtrlSetData(-1,'|' & $3_4ComboData)
$Edit_Student_Submit = GUICtrlCreateButton('Submit',10,160,70,25)
$Edit_Student_New = GUICtrlCreateButton('New',90,160,70,25)
$Edit_Student_Delete = GUICtrlCreateButton('Delete',170,160,70,25)

;History Tab
GuiCtrlCreateTabItem('History')
$History_Edit = GuiCtrlCreateEdit('',10,80,259,229, $EditStyle)



GuiSetState(@SW_SHOW,$Main_Window)


While 1
    $msg = GUIGetMsg(1)
    Select
		;Closes the program
		Case $msg[0] = $GUI_EVENT_CLOSE AND $msg[1] = $Main_Window
			Exit
		
		;Updates the students information when it has been updated
		Case $msg[0] = $Edit_Student_Submit
			$FirstName = StringStripWS(GuiCtrlRead($Edit_Student_FirstName),3)
			$LastName = StringStripWS(GuiCtrlRead($Edit_Student_LastName),3)
			
			$Grade = GuiCtrlRead($Edit_Student_Grade)
			$Class1 = GuiCtrlRead($Edit_Student_Class1)
			$Class2 = GuiCtrlRead($Edit_Student_Class2)
			$Class3 = GuiCtrlRead($Edit_Student_Class3)
			$Class4 = GuiCtrlRead($Edit_Student_Class4)
			If $FirstName = '' Then 
				MsgBox(0,'Empty','Please enter in the students first name.')
			ElseIf $LastName = '' Then 
				MsgBox(0,'Empty','Please enter in the students last name.')
			ElseIf $Grade = '' Then 
				MsgBox(0,'Empty','Please enter in the students grade level.')
			ElseIf $Class1 = '' Then 
				MsgBox(0,'Empty','Please enter in the first class.')
			ElseIf $Class2 = '' Then 
				MsgBox(0,'Empty','Please enter in the second class.')
			ElseIf $Class3 = '' Then 
				MsgBox(0,'Empty','Please enter in the third class.')
			ElseIf $Class4 = '' Then 
				MsgBox(0,'Empty','Please enter in the fourth class.')
			Else
				$History = ''
				If FileExists($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini') Then
					$Choice = MsgBox(4,'Over Write', 'There is already a person by this name.  Do you want to overwrite the file?')
					If $Choice = 6 Then
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class1 , 'AbsentNum', 0)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class2 , 'AbsentNum', 0)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class3 , 'AbsentNum', 0)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class4 , 'AbsentNum', 0)
						
						;Write the first class
						$PrevEntry = IniRead($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '1','None')
						If $PrevEntry <> $Class1 Then 
							IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '1', $Class1)
							$History =  $History & 'First class changed from ' & $PrevEntry & ' to ' & $Class1 & '|'
						EndIf
						
						;Write the second class
						$PrevEntry = IniRead($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '2','None')
						If $PrevEntry <> $Class2 Then 
							IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '2', $Class2)
							$History = $History & 'First class changed from ' & $PrevEntry & ' to ' & $Class2 & '|'
						EndIf
						
						;Write the third class
						$PrevEntry = IniRead($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '3','None')
						If $PrevEntry <> $Class3 Then 
							IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '3', $Class3)
							$History = $History & 'First class changed from ' & $PrevEntry & ' to ' & $Class1 & '|'
						EndIf
						
						;Write the fourth class
						$PrevEntry = IniRead($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '4','None')
						If $PrevEntry <> $Class4 Then 
							IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '4', $Class4)
							$History = $History & 'First class changed from ' & $PrevEntry & ' to ' & $Class1 & '|'
						EndIf
					EndIf
				Else
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class1 , 'AbsentNum', 0)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class2 , 'AbsentNum', 0)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class3 , 'AbsentNum', 0)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class4 , 'AbsentNum', 0)
					
					;Write the first class
					$PrevEntry = IniRead($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '1','None')
					If $PrevEntry <> $Class1 Then 
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '1', $Class1)
						$History = $History & 'First class changed from ' & $PrevEntry & ' to ' & $Class1 & '|'
					EndIf
					
					;Write the second class
					$PrevEntry = IniRead($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '2','None')
					If $PrevEntry <> $Class2 Then 
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '2', $Class2)
						$History = $History & 'First class changed from ' & $PrevEntry & ' to ' & $Class2 & '|'
					EndIf
					
					;Write the third class
					$PrevEntry = IniRead($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '3','None')
					If $PrevEntry <> $Class3 Then 
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '3', $Class3)
						$History = $History & 'First class changed from ' & $PrevEntry & ' to ' & $Class1 & '|'
					EndIf
					
					;Write the fourth class
					$PrevEntry = IniRead($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '4','None')
					If $PrevEntry <> $Class4 Then 
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '4', $Class4)
						$History = $History & 'First class changed from ' & $PrevEntry & ' to ' & $Class1 & '|'
					EndIf
				
				
					GuiCtrlSetData($Edit_Student_FirstName,'')
					GuiCtrlSetData($Edit_Student_LastName,'')
					GuiCtrlSetData($Edit_Student_Grade,$GradeData,'')
					GuiCtrlSetData($Edit_Student_Class1,$1_2ComboData,'')
					GuiCtrlSetData($Edit_Student_Class2,$1_2ComboData,'')
					GuiCtrlSetData($Edit_Student_Class3,$3_4ComboData,'')
					GuiCtrlSetData($Edit_Student_Class4,$3_4ComboData,'')
				
					If $History <> '' then 
						_WriteHistory($History & '|', 'History')
					EndIf
				EndIf
			EndIf
		
		;Grabs the list of students when the grade has been selected
		Case $msg[0] = $Student_Information_Grade
			$Grade = GuiCtrlRead($Student_Information_Grade)
			RunWait(@Comspec & ' /c dir /b *.ini > ' & @TempDir & '\output.txt', $studentData & $Grade, @SW_Hide)
			$FileHandle = FileOPen(@TempDir & '\output.txt',0)
			$ComboDAta = ''
			While 1
				$LineRead = FileReadLine($FileHandle)
				If @Error = -1 Then ExitLoop
				$LineRead = StringTrimRight($LineRead,4)
				$LineRead = StringReplace($LineRead,'_',', ')
				$ComboData = $ComboData & '|' & $LineRead
			WEnd
			GuiCtrlSetData($Student_Information_StudentName,$ComboData)
			GuiCtrlSetData($Student_Information_Class1,'')
			GuiCtrlSetState($Student_Information_Class1,$GUI_UNCHECKED)
			ControlCommand($MainTitle,'','ComboBox3','SetCurrentSelection',0)
			GuiCtrlSetData($Student_Information_Class2,'')
			GuiCtrlSetState($Student_Information_Class2,$GUI_UNCHECKED)
			ControlCommand($MainTitle,'','ComboBox4','SetCurrentSelection',0)
			GuiCtrlSetData($Student_Information_Class3,'')
			GuiCtrlSetState($Student_Information_Class3,$GUI_UNCHECKED)
			ControlCommand($MainTitle,'','ComboBox5','SetCurrentSelection',0)
			GuiCtrlSetData($Student_Information_Class4,'')
			GuiCtrlSetState($Student_Information_Class4,$GUI_UNCHECKED)
			ControlCommand($MainTitle,'','ComboBox6','SetCurrentSelection',0)
			GuiCtrlSetData($Student_Information_Discipline_Read,'')
			GuiCtrlSetData($Student_Information_Comment,'')
		
		;Sets all values when a student's name has been selected.
		Case $msg[0] = $Student_Information_StudentName
			$Name = _GetName()
			$Grade = GuiCtrlRead($Student_Information_Grade)
			$1Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',1,'')
			$2Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',2,'')
			$3Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',3,'')
			$4Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',4,'')
			
			$AbsentNum = IniRead($StudentData & $Grade & '\' & $Name,$1Class,'AbsentNum','')
			GuiCtrlSetData($Student_Information_Class1,$1Class & ' ' & $AbsentNum)
			ControlCommand($MainTitle,'','ComboBox3','SelectString',$1Class)
			
			$AbsentNum = IniRead($StudentData & $Grade & '\' & $Name,$2Class,'AbsentNum','')
			GuiCtrlSetData($Student_Information_Class2,$2Class & ' ' & $AbsentNum)
			ControlCommand($MainTitle,'','ComboBox4','SelectString',$2Class)
			
			$AbsentNum = IniRead($StudentData & $Grade & '\' & $Name,$3Class,'AbsentNum','')
			GuiCtrlSetData($Student_Information_Class3,$3Class & ' ' & $AbsentNum)
			ControlCommand($MainTitle,'','ComboBox5','SelectString',$3Class)
			
			$AbsentNum = IniRead($StudentData & $Grade & '\' & $Name,$4Class,'AbsentNum','')
			GuiCtrlSetData($Student_Information_Class4,$4Class & ' ' & $AbsentNum)
			ControlCommand($MainTitle,'','ComboBox6','SelectString',$4Class)
			
			$FullDate = _GetDate()
			
			$Attendance = IniRead($StudentData & $Grade & '\' & $Name,$1Class,$FullDate,'Present')
			If $Attendance <> 'Present' Then GuiCtrlSetState($Student_Information_Class1,$GUI_CHECKED)
			
			$Attendance = IniRead($StudentData & $Grade & '\' & $Name,$2Class,$FullDate,'Present')
			If $Attendance <> 'Present' Then GuiCtrlSetState($Student_Information_Class2,$GUI_CHECKED)
				
			$Attendance = IniRead($StudentData & $Grade & '\' & $Name,$3Class,$FullDate,'Present')
			If $Attendance <> 'Present' Then GuiCtrlSetState($Student_Information_Class3,$GUI_CHECKED)
				
			$Attendance = IniRead($StudentData & $Grade & '\' & $Name,$4Class,$FullDate,'Present')
			If $Attendance <> 'Present' Then GuiCtrlSetState($Student_Information_Class4,$GUI_CHECKED)
				
			$Discipline = IniRead($StudentData & $Grade & '\' & $Name,'Discipline','History','')
			$Discipline = _FormatHistoryData($Discipline)
			GuiCtrlSetData($Student_Information_Discipline_Read,$Discipline)
			
			$History = IniRead($StudentData & $Grade & '\' & $Name,'History','History','')
			$History = _FormatHistoryData($History)
			GuiCtrlSetData($History_Edit,$History)
		
		;Next 4 records absences for all 4 classes.
		Case $msg[0] = $Student_Information_Class1
			$Check = GuiCtrlRead($Student_Information_Class1)
			If $Check = 1 Then 
				_WriteAbsence(1,$Student_Information_Class1)
				$History = 'Absence recorded in ' & ControlGetText($MainTitle,'', $Student_Information_Class1) & '.'
				
			Else
				_RemoveAbsence(1,$Student_Information_Class1)
				$History = 'Absence removed in ' & ControlGetText($MainTitle,'', $Student_Information_Class1) & '.'
			EndIf
			_WriteHistory($History & '|', 'History')
		
		Case $msg[0] = $Student_Information_Class2
			$Check = GuiCtrlRead($Student_Information_Class2)
			If $Check = 1 Then 
				_WriteAbsence(2,$Student_Information_Class2)
				$History = 'Absence recorded in ' & ControlGetText($MainTitle,'', $Student_Information_Class2) & '.'
			Else
				_RemoveAbsence(2,$Student_Information_Class2)
				$History = 'Absence removed in ' & ControlGetText($MainTitle,'', $Student_Information_Class2) & '.'
			EndIf
			_WriteHistory($History & '|', 'History')			
			
		Case $msg[0] = $Student_Information_Class3
			$Check = GuiCtrlRead($Student_Information_Class3)
			If $Check = 1 Then 
				_WriteAbsence(3,$Student_Information_Class3)
				$History = 'Absence recorded in ' & ControlGetText($MainTitle,'', $Student_Information_Class3) & '.'
			Else
				_RemoveAbsence(3,$Student_Information_Class3)
				$History = 'Absence removed in ' & ControlGetText($MainTitle,'', $Student_Information_Class3) & '.'
			EndIf
			_WriteHistory($History & '|', 'History')
		
		Case $msg[0] = $Student_Information_Class4
			$Check = GuiCtrlRead($Student_Information_Class4)
			If $Check = 1 Then 
				_WriteAbsence(4,$Student_Information_Class4)
				$History = 'Absence recorded in ' & ControlGetText($MainTitle,'', $Student_Information_Class4) & '.'
			Else
				_RemoveAbsence(4,$Student_Information_Class4)
				$History = 'Absence removed in ' & ControlGetText($MainTitle,'', $Student_Information_Class4) & '.'
			EndIf
			_WriteHistory($History & '|', 'History')
		
		;Adds the discipline comment
		Case $msg[0] = $Student_Information_Add_Comment
			$Name = _GetName()
			If $Name <> '.ini' Then
				$NewComment = GuiCtrlRead($Student_Information_Comment) 
				$Grade = GuiCtrlRead($Student_Information_Grade)
				_WriteHistory($NewComment,'Discipline')
				_WriteHistory('Discipline Recorded: ' & $NewComment & '|','History')
				$Discipline = IniRead($StudentData & $Grade & '\' & $Name,'Discipline','History','')
				$Discipline = _FormatHistoryData($Discipline)
				GuiCtrlSetData($Student_Information_Discipline_Read,$Discipline)
			EndIf
		
		;Creates the window that allows you to add a new student
		Case $msg[0] =  $Edit_Student_New
			$Add_Window = GUICreate('Add Student',280,250,'-1','-1','','',$Main_Window)
			
			GUICtrlCreateLabel('First Name',10,30,100,20)
			$Edit_Student_FirstName = GuiCtrlCreateInput('',10,45,100,20)
			GUICtrlCreateLabel('Last Name',120,30,100,20)
			$Edit_Student_LastName = GuiCtrlCreateInput('',120,45,100,20)
			GUICtrlCreateLabel('Grade',230,30,40,20)
			$Edit_Student_Grade = GuiCtrlCreateCombo('',230,45,40,100,$ComboStyle)
			GuiCtrlSetData(-1,$GradeData)
			GUICtrlCreateLabel('First Class',10,70,125,20)
			$Edit_Student_Class1 = GuiCtrlCreateCombo('',10,85,125,100,$ComboStyle)
			GUICtrlSetData(-1,$1_2ComboData)
			GUICtrlCreateLabel('Second Class',145,70,125,20)
			$Edit_Student_Class2 = GuiCtrlCreateCombo('',145,85,125,100,$ComboStyle)
			GUICtrlSetData(-1,$1_2ComboData)
			GUICtrlCreateLabel('Third Class',10,110,125,20)
			$Edit_Student_Class3 = GuiCtrlCreateCombo('',10,125,125,100,$ComboStyle)
			GUICtrlSetData(-1,$3_4ComboData)
			GUICtrlCreateLabel('Fourth Class',145,110,125,20)
			$Edit_Student_Class4 = GuiCtrlCreateCombo('',145,125,125,100,$ComboStyle)
			GUICtrlSetData(-1,$3_4ComboData)
			$Edit_Student_Submit = GUICtrlCreateButton('Submit',10,160,70,25)
			$Add_Student_Close = GUICtrlCreateButton('Close',90,160,70,25)
			
			GuiSetState(@SW_Disable,$Main_Window)
			GuiSetState(@SW_SHOW,$Add_Window)
		
		;Closes add student window
		Case $msg[0] = $Add_Student_Close AND $msg[1] = $Add_Window
			GuiSetState(@SW_Enable,$Main_Window)
			GuiDelete($Add_Window)
			WinActivate($MainTitle)
		
		;Deletes a Student
		Case $msg[0] = $Edit_Student_Delete
			$Student_Name = GuiCtrlRead($Student_Information_StudentName)
			$SplitName = StringSplit($Student_Name,',')
			$ANS = MsgBox(4,'Delete Student', 'Are you sure you want to permanantly delete the student' & $SplitName[2] & ' ' & $SplitName[1])
			If $ans = 6 Then
				$Grade = GuiCtrlRead($Student_Information_Grade)
				FileDelete($StudentData & $Grade & '\' & StringStripWS($SplitName[1]) & '_' & StringStripWS($SplitName[2]) & '.ini')
			EndIf
			
	EndSelect
Wend

;Grabs the students name and formats it for the .ini file
Func _GetName()
	$Name = GuiCtrlRead($Student_Information_StudentName)
	$Name = StringReplace($Name,', ','_')
	$Name = $Name & '.ini'
	Return($Name)
EndFunc

;gets the date and formats it in a way that is smaller to work with for absences
Func _GetDate()
	$Date = GuiCtrlRead($Student_Information_Date)
	$Year = StringRight($Date,4)
	$Date = StringTrimRight($Date,6)
	$Day = StringRight($Date,2)
	$Date = STringTrimRight($Date,3)
	For $i = 1 to 12
		If StringInStr($Date,$Month_Array[$i]) Then 
			$Month = StringRight('00' & $i,2)
			ExitLoop
		EndIf
	Next
	
	$FullDate = $Year & $Month & $Day
	Return($FullDate)
EndFunc

;Writes the absence to the .ini file
Func _WriteAbsence($Section,$ID)
		$Name = _GetName()
		$Grade = GuiCtrlRead($Student_Information_Grade)
		$Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',$Section,'')
		$Date = _GetDate()
		IniWrite($StudentData & $Grade & '\' & $Name,$Class,$Date,1)
		$AbsentNum = IniRead($StudentData & $Grade & '\' & $Name,$Class,'AbsentNum','')
		$NewAbsent = $AbsentNum + 1
		IniWrite($StudentData & $Grade & '\' & $Name,$Class,'AbsentNum',$AbsentNum + 1)
		GuiCtrlSetData($ID, $Class & ' ' & $NewAbsent)
		
EndFunc

;Removes the absence from the .ini file
Func _RemoveAbsence($Section,$ID)
	$Name = _GetName()
	$Grade = GuiCtrlRead($Student_Information_Grade)
	$Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',$Section,'')
	$Date = _GetDate()
	IniDelete($StudentData & $Grade & '\' & $Name,$Class,$Date)
	$AbsentNum = IniRead($StudentData & $Grade & '\' & $Name,$Class,'AbsentNum','')
	$NewAbsent = $AbsentNum - 1
	IniWrite($StudentData & $Grade & '\' & $Name,$Class,'AbsentNum',$NewAbsent)
	GuiCtrlSetData($ID, $Class & ' ' & $NewAbsent)
EndFunc

;Writes the history of all things done to a user.
Func _WriteHistory($HistoryText,$Section)
	$Name = _GetName()
	$Grade = GuiCtrlRead($Student_Information_Grade)
	$Date = _GetDate()
	$LoadedHistory = IniRead($StudentData & $Grade & '\' & $Name,$Section,'History','')
	IniWrite($StudentData & $Grade & '\' & $Name, $Section, 'History',$Date & ': ' & $HistoryText & '~' & $LoadedHistory)
EndFunc

;Grabs the history from the student file and formats it. Then puts it in history edit.
Func _FormatHistoryData($LoadedHistory)
	$History = ''
	$LoadedHistory = StringReplace($LoadedHistory,'|', @CRLF)
	$SplitHistory = StringSplit($LoadedHistory, '~')
	If $LoadedHistory <> '' Then
		_arraysort($SplitHistory,0,1)
		For $i = 2 to $SplitHistory[0]
			$LongDate = StringLeft($SplitHistory[$i],8)
			$LongDate = _ReAssembleDate($LongDate)
			$TrimmedHistory = StringTrimLeft($SplitHistory[$i],8)
			$History = $History & @CRLF & $LongDate & $TrimmedHistory
		Next
	EndIF
	Return($History)
EndFunc

;Turn YearMonthDay format to Month Day, Year format
Func _ReAssembleDate($Date_Long)
	$Year = StringLeft($Date_Long,4)
	$Date_Long = StringTrimLeft($Date_Long,4)
	$Month = StringLeft($Date_Long,2)
	$Month = $Month_Array[$Month]
	$Day = StringTrimLeft($Date_Long,2)
	$ReassembledDate = $Month & ' ' & $Day & ', ' & $Year
	Return($ReassembledDate)
EndFunc