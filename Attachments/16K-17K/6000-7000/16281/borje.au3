; first #include
#include <GUIConstants.au3>
#include <array.au3> ; only necessary to show you the content of the array

;second opt
Opt("TrayIconDebug", 0) ;this is generally useful, if you are unsure in scripting

;third Declaration of variables
Global $avTableOfFilesAndSubfolders[1][2] ;this is an array something like a table actually with 1 row and 2 columns $avTableOfFilesAndSubfolders[0][0]=Cell A1  $avTableOfFilesAndSubfolders[0][1]=Cell B1

;fourth GUI
const $PrCopyGui = GUICreate(" Delete all files in folder", 420, 90, -1, -1, -1, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
$progressbar1 = GUICtrlCreateProgress (10,20,400,20)
GUISetState(@SW_SHOW)

; this the second part of the GUI section
While 1
	_CleanFolder1("D:\IM-Backuper")
    ;$msg = GUIGetMsg()
Wend


;fifth function always at the end!
Func _CleanFolder1($fullpath)
	Local $dirSize, $file_found, $handle_search, $i = 0, $count = 0
	If FileExists ($fullpath) then
		; Get the amount of file and dirs in the root
		$handle_search = FileFindFirstFile($fullpath & '\*')
		If $handle_search <> -1 Then
			While 1
				$file_found = FileFindNextFile($handle_search)
				If @error Then ExitLoop
				$count += 1
				ReDim $avTableOfFilesAndSubfolders[$count+ 1][2] ;attach one row more the array/table
				$avTableOfFilesAndSubfolders[$count][0]= $fullpath & '\' & $file_found ;attention arrays starts always with cero!!! Second row is $avTableOfFilesAndSubfolders[1][0] not $avTableOfFilesAndSubfolders[2][0]
				If StringInStr(FileGetAttrib($fullpath & '\' & $file_found ), 'D') then 
					$avTableOfFilesAndSubfolders[$count][1]= 1; this is a folder, which will be deleted with DirRemove()
				Else
					$avTableOfFilesAndSubfolders[$count][1]= 0	; this is a file, which will be deleted with FileDelete()
				EndIf
			WEnd
			FileClose($handle_search)
			$avTableOfFilesAndSubfolders[0][0]= UBound($avTableOfFilesAndSubfolders)-1; max. number of files and subfolders
			If Not $count Then Return SetError(2, 0, '')
		EndIf
		
		_ArrayDisplay($avTableOfFilesAndSubfolders, 'Content of $avTableOfFilesAndSubfolders for a better understanding'); comment it out, if you are sure in using arrays
		
		; Progress through the folder
		If $avTableOfFilesAndSubfolders[0][0] > 0 then
			For $i = 1 to $avTableOfFilesAndSubfolders[0][0]
				If $avTableOfFilesAndSubfolders[$i][1]== 1 then DirRemove($avTableOfFilesAndSubfolders[$i][0], 1); last parameter for recursive deleting
				If $avTableOfFilesAndSubfolders[$i][1]== 0 then FileDelete($avTableOfFilesAndSubfolders[$i][0])
				GUICtrlSetData ($progressbar1, $i*100/Number($avTableOfFilesAndSubfolders[0][0]))
			Next	
			MsgBox(4096, 'Info', $avTableOfFilesAndSubfolders[0][0] & ' files and subfolders successfully deleted')
		Else
			SetError (2, 0, 2) 
			MsgBox(4096,'Info','Canceled. This folder contains no files and/or subfolders')
		EndIf
	Else
		SetError (1, 0, 1)
		MsgBox(4096,"Info", "Canceled. This folder: " & $fullpath & " doesn't exist.")
	EndIf
	Exit
EndFunc














	