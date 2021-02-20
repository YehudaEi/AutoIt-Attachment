#include <WarUdf.au3>
#include <GUIConstantsEx.au3>

;Write and read UDF variables
;$War_Dir = @AppDataDir & "\Program"
$War_Dir = @ScriptDir
$War_File = "test.ini"
$War_Section = "test section"
$War_Key = "test"

;Write and read UDF
$WarUdf = WarUdf($War_Dir, $War_File, $War_Section, $War_Key)

;GUI variables
$EditHeight = 40
$EditWidht = 200
$EdgeRemove = 30
$title = "Info"

;Gui set up
GUICreate($title , 300, 200, -1, -1)
$guihandle = WinGetHandle($title)
$Name = GUICtrlCreateInput("Name", 50, $EditHeight-$EdgeRemove, $EditWidht, $EditHeight)
$Age = GUICtrlCreateInput("Age", 50, $EditHeight * 2-$EdgeRemove, $EditWidht, $EditHeight)
$Occupation = GUICtrlCreateInput("Occupation", 50, $EditHeight * 3-$EdgeRemove, $EditWidht, $EditHeight)
$OkButton = GUICtrlCreateButton("Ok", 50, $EditHeight * 4-$EdgeRemove,$EditWidht, $EditHeight)

;Shows gui if its first time
If $WarUdf = 0 Then
GUISetState(@SW_SHOW)
EndIf


;While loop
While 1
	If $WarUdf = 0 Then;If its first time
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE then;If close then exit
			Exit
		EndIf
		If $msg = $OkButton Then;If okay then save variables
			GUISetState(@SW_HIDE);Hide gui
			FileChangeDir($War_Dir);Change dir to the ini file
				If GUICtrlRead($Name) = "Name" Then;If the name isnt changed alert user and reset UDF variable
					MsgBox(0,"Name", "You did not enter your name!")
					IniWrite($War_File, $War_Section, $War_Key, 0);Reset UDF variable
				Else
					IniWrite($War_File, $War_Section, "Name", GUICtrlRead($Name));If name is changed then save variable
				EndIf

				If GUICtrlRead($Age) = "Age" Then;If the age isnt changed alert user and reset UDF variable
					MsgBox(0,"Age", "You did not enter your age!")
					IniWrite($War_File, $War_Section, $War_Key, 0);Reset UDF variable
				Else
					IniWrite($War_File, $War_Section, "Age", GUICtrlRead($Age));If Age is changed then save variable
				EndIf

				If GUICtrlRead($Occupation) = "Occupation" Then;If the occupation isnt changed alert user and reset UDF variable
				MsgBox(0,"Occupation", "You did not enter your occupation!")
				IniWrite($War_File, $War_Section, $War_Key, 0);Reset UDF variable
				Else
				IniWrite($War_File, $War_Section, "Occupation", GUICtrlRead($Occupation));If occupation is changed then save variable
				EndIf
			Exit
		EndIf
	Else
		FileChangeDir($War_Dir);Change dir to the ini file
		$Read_Name = IniRead($War_File, $War_Section, "Name", "Not found!");Reads name variable
		$Read_Age = IniRead($War_File, $War_Section, "Age", "Not found!");Reads age variable
		$Read_Occupation = IniRead($War_File, $War_Section, "Occupation", "Not found!");Reads occupation variable
		MsgBox(0,"Name", "Name: " & $Read_Name);Presents name
		MsgBox(0,"Age", "Age: " & $Read_Age);Presents age
		MsgBox(0,"Occupation", "Occupation: " & $Read_Occupation);Presents occupation
		Exit
	EndIf
WEnd


