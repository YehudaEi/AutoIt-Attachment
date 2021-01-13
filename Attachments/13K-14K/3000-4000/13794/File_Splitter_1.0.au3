; File Splitter 1.0 by Andrew Dunn (Hallman)

#include <GUIConstants.au3>
#include <file.au3>

; Create global variable to hold the file paths
Global $File_To_Split = ""
Global $File_To_Join = ""

; used by _PathSplit()
Dim $szDrive, $szDir, $szFName, $szExt

; GUI
$MainWindow = GUICreate("File Splitter 1.0", 300,300)


; File Splitting GUI stuff
GuiCtrlCreateGroup("Split File",10,10,280,100)

$Split_Sel_File_Btn = GUICtrlCreateButton("File ...",20,30,100,20)

GUICtrlCreateLabel("Split file into ...",150,33,100,15)

$Split_Size_Input = GUICtrlCreateInput("100",150,48,75,20,$ES_NUMBER)

GUICtrlCreateLabel("MB pieces.",150,70,100,15)

$Split_go_Btn = GUICtrlCreateButton("Split File",20,60,100,20)
GUICtrlSetState(-1,$GUI_DISABLE)



; File Joining GUI stuff

GuiCtrlCreateGroup("Join File",10,150,280,100)

$Join_Sel_File_Btn = GUICtrlCreateButton("File Part One ...",20,170,100,20)
$Join_go_Btn = GUICtrlCreateButton("Join File",20,200,100,20)
GUICtrlSetState(-1,$GUI_DISABLE)



GUISetState(@SW_SHOW)

While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
			
		Case $msg = $Split_Sel_File_Btn
			$Select_File = FileOpenDialog("Open ...",@DesktopDir,"All Files (*.*)",1)
			If NOT @error Then
				; Set the global variable for the path to the FileOpenDialog()
				$File_To_Split = $Select_File
				GUICtrlSetState($Split_go_Btn,$GUI_ENABLE)
			EndIf
			FileChangeDir(@ScriptDir)
			
		Case $msg = $Join_Sel_File_Btn
			$Select_File = FileOpenDialog("Open ...",@DesktopDir,"Part One (*.FS1)",1)
			If NOT @error Then
				; Set the global variable for the path to the FileOpenDialog()
				$File_To_Join = $Select_File
				GUICtrlSetState($Join_go_Btn,$GUI_ENABLE)
			EndIf
			FileChangeDir(@ScriptDir)
			
		Case $msg = $Split_go_Btn 
			If MsgBox(4,"Are you sure?","Are you sure you want to split the selected file? The origional file will not be changed.") = 6 Then
				$Path_Split = _PathSplit($File_To_Split, $szDrive, $szDir, $szFName, $szExt)
				
				GUICtrlSetState($MainWindow,@SW_HIDE)
				
				$File_Split = Split_File($File_To_Split,@DesktopDir & "\Split_" & $Path_Split[3] & $Path_Split[4] & "\",$Path_Split[3] & $Path_Split[4])
				
				GUICtrlSetState($MainWindow,@SW_SHOW)
				
				If $File_Split = -1 Then 
					MsgBox(0,"error","The size you inputed for the split size is larger than the file itself!")
				ElseIf $File_Split = -2 Then 
					MsgBox(0,"error","Unable to open the source file.")
				ElseIf $File_Split = -3 Then 
					MsgBox(0,"error","Unable to to create output files.")
				ElseIf $File_Split = 1 Then 
					MsgBox(0,"Done!","Done splitting the file. The pieces been saved on your desktop in a folder named after the file.")
				EndIf
			EndIf
		
		Case $msg = $Join_go_Btn
			If MsgBox(4,"Are you sure?","Are you sure you want to join the selected file? The origional files will not be changed. Before you begin, make sure all pieces are in the same directory.") = 6 Then
				
				$Path_Split = _PathSplit($File_To_Join, $szDrive, $szDir, $szFName, $szExt)
				
				$Temp_Split = StringSplit($Path_Split[3],".")
				
				$Real_File_Name = ""
				
				For $i = 1 To ($Temp_Split[0] - 1) Step 1
					$Real_File_Name &= $Temp_Split[$i] & "."
				Next
				
				$Real_File_Name = StringTrimRight($Real_File_Name,1)
				
				
				GUICtrlSetState($MainWindow,@SW_HIDE)
				
				$File_Join = Join_File($File_To_Join,@DesktopDir & "\" & $Real_File_Name,$Temp_Split[$Temp_Split[0]])
				
				GUICtrlSetState($MainWindow,@SW_SHOW)
				
				If $File_Join = -1 Then 
					MsgBox(0,"error","Unable to open the output file.")
					
				ElseIf $File_Join = -2 Then 
					MsgBox(0,"error","Unable to open the file part one.")
					
				ElseIf $File_Join = 1 Then 
					MsgBox(0,"Done!","Done joining the file. The file been saved on your desktop named after the file.")
				EndIf
			EndIf
		
	EndSelect
WEnd

Func Join_File($File_Part_One_Path,$Output_File,$Number_Of_Pieces)
	
	; Open the output file
	$Save_File = FileOpen($Output_File,10)
	
	If $Save_File = -1 Then Return -1
	
	; Open part one of the split file in read mode
	$Open_PartOne_File = FileOpen($File_Part_One_Path,0)
	If $Open_PartOne_File = -1 Then 
		FileClose($Save_File)
		Return -2
	EndIf
	
	; Write the contents of part one to the output file
	FileWrite($Output_File,FileRead($Open_PartOne_File))
	
	FileClose($Open_PartOne_File)
	
	
	; Set variable to the base file name of all the file parts
	$Base_Split_File_path = StringReplace($File_Part_One_Path,"." & $Number_Of_Pieces & ".FS1","")
	
	
	; Loop through all the file pieces writing their contents to the output file
	For $i = 2 To $Number_Of_Pieces Step 1
		$Open_Part_File = FileOpen($Base_Split_File_path & ".FS" & $i,0)
		
		If $Open_Part_File = -1 Then
			FileClose($Save_File)
			MsgBox(0,"Error","Unable to locate """ & $Base_Split_File_path & ".FS" & $i & """. Make sure it's in the same directory as part one.")
			Return 0
		EndIf
		
		FileWrite($Output_File,FileRead($Open_Part_File))
		
		FileClose($Open_Part_File)
	Next
	
	
	
	; close the output file
	FileClose($Save_File)
	
	; return Success
	Return 1
	
EndFunc

Func Split_File($Source,$Output_Folder,$Base_Name)
	
	; Check if the file is smaller than what the user inputed to be the split size
	If (FileGetSize($Source) / 1048576) <= GUICtrlRead($Split_Size_Input) Then Return -1
	
	
	; open the file that will be split (source file)
	$Open_File = FileOpen($Source,0)
	If $Open_File = -1 Then Return -2
	
	; get the size of the source file
	$File_Size = FileGetSize($Source)
	
	; Calculate the total number of files the source file will be split into
	$Number_Of_Files = Ceiling($File_Size / (GUICtrlRead($Split_Size_Input) * 1048576))
	
	; convert the split size form MB to bytes
	$Split_Size = (GUICtrlRead($Split_Size_Input) * 1048576)
	
	; create a variable to hold the current file number being wrote
	$Cur_File_Number = 0
	
	
	
	; ----- Create Progress GUI -----------------------------------------------------------------
	
	    $Progress_Win = GUICreate("Spitting file ...",300,160,-1,-1,$WS_CAPTION)

	    $Total_Percent_Label = GUICtrlCreateLabel("Total Percent Done = 0%",10,10,300,15)

        $Total_Percent_Progress = GUICtrlCreateProgress(10,25,280,25)
		GUICtrlSetLimit(-1,100,0)

        $File_Number_Label = GUICtrlCreateLabel("File 0 Of 0",10,65,300,15)

        $File_Percent_Progress = GUICtrlCreateProgress(10,80,280,25)
        GUICtrlSetLimit(-1,100,0)

        $File_Percent_Label = GUICtrlCreateLabel("Percent = 0",10,105,300,15)

        $Cancel_Btn = GUICtrlCreateButton("Cancel",10,130,100,20)

        GUISetState()
	
	; --------------------------------------------------------------------------------------------
	
	Sleep(1000)
	
	$Last_Per_Wrote = 0
	
	; loop through all the file pieces (except for the last one since it wont be the same size as the others) and write it's chunk of the source files data
	For $i = 1 To $Number_Of_Files - 1
		
		; Update the file number label in GUI
		    GUICtrlSetData($File_Number_Label,"File " & $i & " Of " & $Number_Of_Files)
		;------------------------------------
		
		$Cur_File_Number = $i
		
		If $i = 1 Then
			$Open_Cur_File = FileOpen($Output_Folder & $Base_Name & "." & $Number_Of_Files & ".FS" & $i,10)
		Else
		    $Open_Cur_File = FileOpen($Output_Folder & $Base_Name & ".FS" & $i,10)
		EndIf
		
		If $Open_Cur_File = -1 Then 
			FileClose($Open_File)
			DirRemove(StringTrimRight($Output_Folder,1), 1)
			GUIDelete($Progress_Win)
			Return -3
		EndIf
		
		$Loop_Amount = Floor($Split_Size / 4095)
		$Loop_To_Num = ($Loop_Amount * 4095)
		
		For $ii = 4095 To $Loop_To_Num Step 4095
			FileWrite($Open_Cur_File,FileRead($Open_File,4095))
			
			$Cur_File_Percent = Round((100 / $Loop_To_Num) * $ii,0)
			
			If $Cur_File_Percent <> $Last_Per_Wrote Then
			    GUICtrlSetData($File_Percent_Progress,$Cur_File_Percent)
			    GUICtrlSetData($File_Percent_Label,"Percent = " & $Cur_File_Percent)
			
			    $Last_Per_Wrote = $Cur_File_Percent
			EndIf
		Next
		
		FileWrite($Open_Cur_File,FileRead($Open_File,$Split_Size - $Loop_To_Num))
		
		GUICtrlSetData($File_Percent_Label,"Percent = 100")
		GUICtrlSetData($File_Percent_Progress,100)
		
		FileClose($Open_Cur_File)
		
		
		; calculate total percent done
		    $Cur_Total_Per = Round((100 / $Number_Of_Files) * $i,0)
		
		    GUICtrlSetData($Total_Percent_Label,"Total Percent Done = " & $Cur_Total_Per & "%")
		
		    GUICtrlSetData($Total_Percent_Progress,$Cur_Total_Per)
		;-----------------------------
		
		
	Next
	
	
	; calculate the total number of the source files data already wrote in the split files
	$Bytes_Wrote = $Cur_File_Number * $Split_Size
	
	; calculate the number bytes left over that still need to be wrote
	$Left_Over_Bytes = $File_Size - $Bytes_Wrote
	
	; Open the last split file
	$Open_Cur_File = FileOpen($Output_Folder & $Base_Name & ".FS" & ($Cur_File_Number + 1),10)
	
	If $Open_Cur_File = -1 Then 
		FileClose($Open_File)
		DirRemove(StringTrimRight($Output_Folder,1), 1)
		GUIDelete($Progress_Win)
		Return -3
	EndIf
	
	GUICtrlSetData($File_Number_Label,"File " & $Number_Of_Files & " Of " & $Number_Of_Files)
	
	; Write the rest of the bytes to the last file part
	If $Left_Over_Bytes > 4095 Then
	
	    $Loop_Amount = Floor($Left_Over_Bytes / 4095)
		$Loop_To_Num = ($Loop_Amount * 4095)
		
	    For $ii = 4095 To $Loop_To_Num Step 4095
		    FileWrite($Open_Cur_File,FileRead($Open_File,4095))
			
			$Cur_File_Percent = Round((100 / $Loop_To_Num) * $ii,0)
			
			If $Cur_File_Percent <> $Last_Per_Wrote Then
			    GUICtrlSetData($File_Percent_Progress,$Cur_File_Percent)
			    GUICtrlSetData($File_Percent_Label,"Percent = " & $Cur_File_Percent)
				$Last_Per_Wrote = $Cur_File_Percent
			EndIf
	    Next
		
	    FileWrite($Open_Cur_File,FileRead($Open_File,$Left_Over_Bytes - (4095 * $Loop_Amount)))
	Else
		FileWrite($Open_Cur_File,FileRead($Open_File,$Left_Over_Bytes))
	EndIf
	
	GUICtrlSetData($File_Percent_Progress,100)
	GUICtrlSetData($File_Percent_Label,"Percent = 100")
	
	GUICtrlSetData($Total_Percent_Label,"Total Percent Done = 100%")
	GUICtrlSetData($Total_Percent_Progress,100)
	
	Sleep(1000)
	
	; close files
	FileClose($Open_Cur_File)
	
	FileClose($Open_File)
	
	GUIDelete($Progress_Win)
	
	; return success
	Return 1
EndFunc