#Include <File.au3>
#Include <Array.au3>



; THIS PROGRAM RECURSIVELY SCANS A MAIN FOLDER FOR ALL EXISTING SUBFOLDERS AND WIRTES THE RESULTING PATHS TO AN ARRAY
;
; SYNTAX:  _GetAllSubfolders( $MainFolder, $ShowTooltip ) 
;          The purpose of the variable $MainFolder is pretty self explanatory.  
;          If $ShowTooltip is set to 1, program progess is shown in the upper left corner of your screen; set to any other value to disable. 
;          Written and tested with AutoIt 3.2.12.1.  
;          Have fun. 
; AUTHOR:  Marcus.Wetzler@gmail.com




;  ALL YOU NEED TO KNOW IS THIS: 
Local $MainFolder  = "C:\Windows"                             ; set main folder 
Local $Subfolders = _GetAllSubfolders( $MainFolder, 1 )       ; run program 
_ArrayDisplay( $Subfolders )                                  ; show result 






;;;;;;;  PROGRAM FUNCTIONS  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Func _GetAllSubfolders( $MainFolder, $ShowTooltip ) 


	Dim $ToDoList[1] 
	Dim $ResultList[1] 	

	$ToDoList = _AddSubfoldersToArray( $MainFolder, $ToDoList ) 


	Do 
		
		$Folder = $ToDoList[1] 
		_ArrayDelete($ToDoList, 1) 
		_ArrayAdd($ResultList, $Folder) 
		$ToDoList = _AddSubfoldersToArray( $Folder, $ToDoList ) 
		
		If $ShowTooltip = 1 Then 
			ToolTip( (UBound($ResultList)-1)   ,1,1) 
		EndIf 
		
	Until (UBound($ToDoList)-1) = 0 
	
	
	ToolTip("") 
	
	Return $ResultList 

EndFunc 





Func _AddSubfoldersToArray( $FolderPath, $InputArray ) 


	Dim $OutputArray[1] 
	
	$OutputArray = $InputArray
	
	$ListOfSubfolders = _FileListToArray( $FolderPath, "*.*", 2 ) 


	For $i=1 To (UBound($ListOfSubfolders)-1) 
		
		$Folder = $ListOfSubfolders[$i] 
		_ArrayAdd( $OutputArray, $FolderPath &"\" &$Folder ) 
		
	Next 


	Return $OutputArray

EndFunc 



