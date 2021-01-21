; ---------------------------------------------------------------------------- 
; 
; AutoIt Version: 3.1.0 
; Author:   Adam McGill
; 
; Script Function: 
;        Template AutoIt script. 
; 
; ---------------------------------------------------------------------------- 
#include <GUIConstants.au3> 

;Global variables used in Service Desk tool 
GLOBAL $item1, $line
GLOBAL $listview, $msg, $x, $y, $z 
$item1 = "" 
$x = "0" 
$y = "0" 
$z = "0" 
$line = "" 


call ("Main") 
Func Main() 
GUICreate("Service Desk Tool",700,445, 300,200,-1,$WS_EX_ACCEPTFILES)
$listview = GUICtrlCreateListView ("Branch       |ID Series    |Branch ID   ",5,180,230,260);,$LVS_SORTDESCENDING) 

GUISetBkColor (0x00E0FFFF)  ; will change background color 

GUICtrlCreateGroup ("Payrolls:", 240, 180, 100, 105) 
$buttonBlue = GUICtrlCreateButton ("Blue Payroll",245,195,90,25) 
$buttonGreen = GUICtrlCreateButton ("Green Payroll",245,225,90,25) 
$buttonRed = GUICtrlCreateButton ("Red Payroll",245,255,90,25) 
GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group 


GUISetState () 

Do 
$msg = GUIGetMsg () 
	Select 
                Case $msg = $buttonBlue 
                        call ("BranchCodingBlue") 
                Case $msg = $buttonGreen 
                        call ("BranchCodingGreen") 
                Case $msg = $buttonRed 
                        call ("BranchCodingRed") 
        EndSelect 
Until $msg = $GUI_EVENT_CLOSE     

EndFunc 


Func BranchCodingBlue() 
if $x = $item1 then 
        Msgbox(0,"Error","You have already clicked this button") 
else 
	$file = FileOpen("C:\Documents and Settings\amcgill\Desktop\SDT\Branch Coding\Branch Coding Blue.txt", 0) 
        ; Check if file opened for reading OK 
        If $file = -1 Then 
		MsgBox(0, "Error", "Unable to open file.") 
                Exit 
        EndIf 
        ; Read in lines of text until the EOF is reached 
        While 1 
        	$line = FileReadLine($file) 
                If @error = -1 Then ExitLoop 
                $x=StringFormat ("%s",$line) 
                $item1= GUICtrlCreateListViewItem($x,$listview) 
	Wend 
      
	$item1 = $x 
            
	FileClose($file) 
EndIf 
  
EndFunc 


Func BranchCodingGreen() 
if $y = $item1 then 
        Msgbox(0,"Error","You have already clicked this button") 
else 
	$file = FileOpen("C:\Documents and Settings\amcgill\Desktop\SDT\Branch Coding\Branch Coding Green.txt", 0) 
	; Check if file opened for reading OK 
	If $file = -1 Then 
		MsgBox(0, "Error", "Unable to open file.") 
		Exit 
	EndIf 
	; Read in lines of text until the EOF is reached 
	While 1 
		$line = FileReadLine($file) 
		If @error = -1 Then ExitLoop 
		$y=StringFormat ("%s",$line) 
		$item1= GUICtrlCreateListViewItem($y,$listview) 
        Wend 
      
        $item1 = $y 
            
        FileClose($file) 
EndIf 
EndFunc 


Func BranchCodingRed() 
if $z = $item1 then 
        Msgbox(0,"Error","You have already clicked this button") 
else                                                 
	$file = FileOpen("C:\Documents and Settings\amcgill\Desktop\SDT\Branch Coding\Branch Coding Red.txt", 0) 
        ; Check if file opened for reading OK 
        If $file = -1 Then 
                MsgBox(0, "Error", "Unable to open file.") 
		Exit 
        EndIf 
        ; Read in lines of text until the EOF is reached 
        While 1 
                $line = FileReadLine($file) 
                If @error = -1 Then ExitLoop 
                $z=StringFormat ("%s",$line) 
                $item1= GUICtrlCreateListViewItem($z,$listview) 
        Wend 
      
	$item1 = $z 
            
	FileClose($file) 
EndIf 
EndFunc