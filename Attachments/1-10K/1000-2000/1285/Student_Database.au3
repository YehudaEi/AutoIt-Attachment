;Define Constants
#Include <GuiConstants.au3>

$StudentData = @ScriptDir & '\StudentData\'
$StudentDataLen = StringLen($StudentData)
$PrepMonth = 'January;February;March;April;May;June;July;August;September;October;November;December'
$Month_Array = StringSplit($PrepMonth,';')

$EditStyle = BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY)

;Make ComboBox style read only
$ComboStyle = $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL + $CBS_SORT
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



	

;Make Gui
GUICreate('Student Personell Manager',280,320)
GUICtrlCreateTab(-1,0,285,325)

;Student Info Tab
GuiCtrlCreateTabItem('Student Information')
GUICtrlCreateLabel('Date:',15,35,40,20)
$Student_Information_Date = GuiCtrlCreateDate('Date:',50,30,200,20)
GUICtrlCreateLabel('Students Name',10,65,100,20)
$Student_Information_StudentName = GuiCtrlCreateCombo('',10,80,180,100)
GUICtrlCreateLabel('First Class',10,105,125,20)
$Student_Information_Class1 = GuiCtrlCreateCheckbox('',10,120,125,20)
GUICtrlCreateLabel('Second Class',145,105,125,20)
$Student_Information_Class2 = GuiCtrlCreateCheckBox('',145,120,125,20)
GUICtrlCreateLabel('Third Class',10,145,125,20)
$Student_Information_Class3 = GuiCtrlCreateCheckbox('',10,160,125,20)
GUICtrlCreateLabel('Fourth Class',145,145,125,20)
$Student_Information_Class4 = GuiCtrlCreateCheckbox('',145,160,125,20)
GUICtrlCreateLabel('Grade',200,65,100,20)
$Student_Information_Grade = GuiCtrlCreateCombo('',200,80,40,100,$ComboStyle)
GuiCtrlSetData(-1,$GradeData)
GUICtrlCreateGroup('Discipline',3,185,275,130)
$Student_Information_Comment = GuiCtrlCreateInput('',10,200,150,20)
$Student_Information_Add_Comment = GuiCtrlCreateButton('Add Comment',170,200,80,20)
$Student_Information_Discipline_Read = GUICtrlCreateEdit('',10,230,265,80, $EditStyle)


;Student Input Tab
GuiCtrlCreateTabItem('Add Student')
GUICtrlCreateLabel('First Name',10,30,100,20)
$AddStudent_FirstName = GuiCtrlCreateInput('',10,45,100,20)
GUICtrlCreateLabel('Last Name',120,30,100,20)
$AddStudent_LastName = GuiCtrlCreateInput('',120,45,100,20)
GUICtrlCreateLabel('Grade',230,30,40,20)
$AddStudent_Grade = GuiCtrlCreateCombo('',230,45,40,100,$ComboStyle)
GuiCtrlSetData(-1,$GradeData)
GUICtrlCreateLabel('First Class',10,70,125,20)
$AddStudent_Class1 = GuiCtrlCreateCombo('',10,85,125,100,$ComboStyle)
GUICtrlSetData(-1,$1_2ComboData)
GUICtrlCreateLabel('Second Class',145,70,125,20)
$AddStudent_Class2 = GuiCtrlCreateCombo('',145,85,125,100,$ComboStyle)
GUICtrlSetData(-1,$1_2ComboData)
GUICtrlCreateLabel('Third Class',10,110,125,20)
$AddStudent_Class3 = GuiCtrlCreateCombo('',10,125,125,100,$ComboStyle)
GUICtrlSetData(-1,$3_4ComboData)
GUICtrlCreateLabel('Fourth Class',145,110,125,20)
$AddStudent_Class4 = GuiCtrlCreateCombo('',145,125,125,100,$ComboStyle)
GUICtrlSetData(-1,$3_4ComboData)
$AddStudent_Submit = GUICtrlCreateButton('Submit',10,160,70,25)



GuiSetState(@SW_SHOW)

While 1
    $msg = GUIGetMsg()
    Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
			
		Case $msg = $AddStudent_Submit
			$FirstName = StringStripWS(GuiCtrlRead($AddStudent_FirstName),3)
			$LastName = StringStripWS(GuiCtrlRead($AddStudent_LastName),3)
			
			$Grade = GuiCtrlRead($AddStudent_Grade)
			$Class1 = GuiCtrlRead($AddStudent_Class1)
			$Class2 = GuiCtrlRead($AddStudent_Class2)
			$Class3 = GuiCtrlRead($AddStudent_Class3)
			$Class4 = GuiCtrlRead($AddStudent_Class4)
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
				If FileExists($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini') Then
					$Choice = MsgBox(4,'Over Write', 'There is already a person by this name.  Do you want to overwrite the file?')
					If $Choice = 6 Then
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class1 , 'AbsentNum', 0)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class2 , 'AbsentNum', 0)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class3 , 'AbsentNum', 0)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class4 , 'AbsentNum', 0)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '1', $Class1)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '2', $Class2)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '3', $Class3)
						IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '4', $Class4)
					EndIf
				Else
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class1 , 'AbsentNum', 0)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class2 , 'AbsentNum', 0)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class3 , 'AbsentNum', 0)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', $Class4 , 'AbsentNum', 0)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '1', $Class1)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '2', $Class2)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '3', $Class3)
					IniWrite($StudentData & $Grade & '\' & $LastName & '_' & $FirstName & '.ini', 'Class Order' , '4', $Class4)
				EndIf
				
				GuiCtrlSetData($AddStudent_FirstName,'')
				GuiCtrlSetData($AddStudent_LastName,'')
				GuiCtrlSetData($AddStudent_Grade,$GradeData,'')
				GuiCtrlSetData($AddStudent_Class1,$1_2ComboData,'')
				GuiCtrlSetData($AddStudent_Class2,$1_2ComboData,'')
				GuiCtrlSetData($AddStudent_Class3,$3_4ComboData,'')
				GuiCtrlSetData($AddStudent_Class4,$3_4ComboData,'')
			EndIf
		
		Case $msg = $Student_Information_Grade
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
			GuiCtrlSetData($Student_Information_Class2,'')
			GuiCtrlSetState($Student_Information_Class2,$GUI_UNCHECKED)
			GuiCtrlSetData($Student_Information_Class3,'')
			GuiCtrlSetState($Student_Information_Class3,$GUI_UNCHECKED)
			GuiCtrlSetData($Student_Information_Class4,'')
			GuiCtrlSetState($Student_Information_Class4,$GUI_UNCHECKED)
			GuiCtrlSetData($Student_Information_Discipline_Read,'')
			GuiCtrlSetData($Student_Information_Comment,'')
			
		Case $msg = $Student_Information_StudentName
			$Name = _GetName()
			$Grade = GuiCtrlRead($Student_Information_Grade)
			$1Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',1,'')
			$2Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',2,'')
			$3Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',3,'')
			$4Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',4,'')
			
			GuiCtrlSetData($Student_Information_Class1,$1Class)
			GuiCtrlSetData($Student_Information_Class2,$2Class)
			GuiCtrlSetData($Student_Information_Class3,$3Class)
			GuiCtrlSetData($Student_Information_Class4,$4Class)
			
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
			$Discipline = StringReplace($Discipline,'|',@CRLF)
			GuiCtrlSetData($Student_Information_Discipline_Read,$Discipline)
				
		Case $msg = $Student_Information_Class1
			$Check = GuiCtrlRead($Student_Information_Class1)
			If $Check = 1 Then 
				_WriteAbsence(1)
			Else
				_RemoveAbsence(1)
			EndIf
			
		Case $msg = $Student_Information_Class2
			$Check = GuiCtrlRead($Student_Information_Class2)
			If $Check = 1 Then 
				_WriteAbsence(2)
			Else
				_RemoveAbsence(2)
			EndIf	
			
		Case $msg = $Student_Information_Class3
			$Check = GuiCtrlRead($Student_Information_Class3)
			If $Check = 1 Then 
				_WriteAbsence(3)
			Else
				_RemoveAbsence(3)
			EndIf
		
		Case $msg = $Student_Information_Class4
			$Check = GuiCtrlRead($Student_Information_Class4)
			If $Check = 1 Then 
				_WriteAbsence(4)
			Else
				_RemoveAbsence(4)
			EndIf
			
		Case $msg = $Student_Information_Add_Comment
			$Name = _GetName()
			If $Name <> '.ini' Then
				$Date = GuiCtrlRead($Student_Information_Date)
				For $i = 1 to 12
					If StringInStr($Date,$Month_Array[$i]) Then 
						$Date = StringTrimLeft($Date,StringLen($Month_Array[$i])+1)
						ExitLoop
					EndIf
				Next
				$NewComment = GuiCtrlRead($Student_Information_Comment) 
				$OldComment = GuiCtrlRead($Student_Information_Discipline_Read)
				$NewEdit = $Date & ': ' & $NewComment & @CRLF & @CRLF & $OldComment
				$Grade = GuiCtrlRead($Student_Information_Grade)
				$ChangedNewEdit = StringReplace($NewEdit,@crlf,'|')
				IniWrite($StudentData & $Grade & '\' & $Name,'Discipline','History',$ChangedNewEdit)
				GuiCtrlSetData($Student_Information_Discipline_Read,$NewEdit)
			EndIf
	EndSelect
Wend

Func _GetName()
	$Name = GuiCtrlRead($Student_Information_StudentName)
	$Name = StringReplace($Name,', ','_')
	$Name = $Name & '.ini'
	Return($Name)
EndFunc

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

Func _WriteAbsence($Section)
		$Name = _GetName()
		$Grade = GuiCtrlRead($Student_Information_Grade)
		$Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',$Section,'')
		$Date = _GetDate()
		IniWrite($StudentData & $Grade & '\' & $Name,$Class,$Date,1)
EndFunc

Func _RemoveAbsence($Section)
	$Name = _GetName()
	$Grade = GuiCtrlRead($Student_Information_Grade)
	$Class = IniRead($StudentData & $Grade & '\' & $Name,'Class Order',$Section,'')
	$Date = _GetDate()
	IniDelete($StudentData & $Grade & '\' & $Name,$Class,$Date)
EndFunc