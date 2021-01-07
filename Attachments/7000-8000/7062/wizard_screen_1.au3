#include <GUIConstants.au3>
#include <GuiList.au3>
#include <GuiListView.au3>
#include <Process.au3>
#include<Array.au3>
#include<File.au3>
;#NoTrayIcon

dim $folders
Dim $InArray

$txtsize = FileGetSize("test.txt")
if $txtsize = 0 then 
FileDelete ( "test.txt" )
endif
If FileExists("test.txt") Then
_FileReadToArray("test.txt",$folders)
Else
$file = FileOpen("test.txt", 1)
_FileReadToArray("test.txt",$folders)
_ArrayDelete($folders,0)
EndIf

$CountLines = _FileCountLines("test.txt")

GUICreate("Q-Backup Setup and Installation Wizard",640,480)
GuiCtrlCreatePic("qbackup.gif",0,0, 175,35,$WS_EX_TRANSPARENT)

TrayTip("Welcome to Q-Backup", "The Q-Backup Setup and Installation Wizard will hold your hand all the way through getting Q-Backup working on your system!", 5, 1)

$filemenu = GuiCtrlCreateMenu ("File")
$fileitem = GuiCtrlCreateMenuitem ("Open...",$filemenu)
$recentfilesmenu = GuiCtrlCreateMenu ("Recent Files",$filemenu)
$separator1 = GuiCtrlCreateMenuitem ("",$filemenu)
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$helpmenu = GuiCtrlCreateMenu ("?")
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)

$mylist = GUICtrlCreateList("", 125, 40, 180, 120, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY))

;$mylist=GUICtrlCreateList ("", 176,50,450,200, BitOR($LBS_NOTIFY))
GUICtrlSetLimit(-1,200) ; to limit horizontal scrolling

$Add = GuiCtrlCreateButton ("Add folder",0,300,70,20)
$removebutton = GuiCtrlCreateButton ("Remove Folder",100,300,70,20)
$nextbutton = GuiCtrlCreateButton ("Next",200,300,70,20)
$clearbutton = GuiCtrlCreateButton ("Clear all",400,300,70,20)

GuiSetState()

for $i = 1 to $countlines
	$sArrayString = _ArrayToString($folders,@TAB, $i,$i )
	GUICtrlSetData($mylist, $sArrayString)
next

While 1
$msg = GUIGetMsg()
	  	Select
		
		Case $msg = $GUI_EVENT_CLOSE
		exit

		Case $msg = $nextbutton
			Call ( Save ( ) )
			exitloop

		Case $msg = $fileitem
			$file = FileOpenDialog("Choose file...",@TempDir,"All (*.*)")
			If @error <> 1 Then GuiCtrlCreateMenuItem ($file,$recentfilesmenu)

		Case $msg = $exititem
			ExitLoop

		Case $msg = $removebutton
			 $ret = _GUICtrlListGetSelItemsText ($mylist)
 		         If (Not IsArray($ret)) Then
                	 	MsgBox(16, "Error", "Unknown error from _GUICtrlListGetSelItemsText")
            		 Else
                  		For $i = 1 To $ret[0]
                    			MsgBox(0, "Selected", $ret[$i])

			        Next            

			 EndIf
			 $ret = _GUICtrlListSelectedIndex ($mylist)
			 MsgBox(16, "Error", $ret)
			 $aret=( $ret + 1 )
			 _ArrayDelete ( $folders, $aret )
			 _GUICtrlListDeleteItem($mylist, $ret)
			 

		Case $msg = $clearbutton
        	    	_GUICtrlListClear ($mylist)
			for $i = 0 to 100
				_ArrayDelete ( $folders,$i )
			next
			FileClose ( "test.txt" )
			FileDelete ( "test.txt" )

		Case $msg = $Add
			For $i = 1 to 1
				$var = FileSelectFolder("Choose a folder to backup!", "")
				if @error = 1 Then exitloop
				$drivetype = DriveGetType( $var )
				; for testing the drive type! MsgBox(4096, "Q-Backup", $drivetype)

				if $drivetype = "Removable" Then 
					MsgBox(4096, "Q-Backup", "Sorry you cannot backup floppy or removable drives!") 
					exitloop
				EndIf

				if $drivetype = "CDROM" Then
					MsgBox(4096, "Q-Backup", "Sorry you cannot backup CD-ROM or DVD-ROM Drives!") 
					exitloop
				EndIf

				if $drivetype = "Network" Then
					MsgBox(4096, "Q-Backup", "Network shares are backup up in the next part of this Wizard!") 
					exitloop
				EndIf

				if $drivetype = "" Then
					MsgBox(4096, "Q-Backup", "Sorry you cannot backup this location!") 
					exitloop
				EndIf
				_ArrayAdd ( $folders, $var )
   				GUICtrlSetData($mylist, $var)
call ( Save () )

			Next

		Case $msg = $aboutitem
			Msgbox(0,"About","Q-Backup Setup and Installation Wizard version 2.00. ©2006 Qual-IT. www.qualit-uk.com/backup")
			EndSelect
WEnd

GUIDelete()

Exit

Func Save ( )
		
$Pos1 = _ArrayToString($folders,@TAB, 1, 1 )
if $Pos1 = "" THEN exit
	;_ArrayDisplay( $folders, "_ArrayDisplay() Test" )
	If FileExists("test.txt") Then
		FileDelete ( "test.txt" )
		CALL ( Folders ( ) )
		CALL ( _ArrayRemoveDupes($folders) )
		_ArraySort( $folders )	
		;_ArrayDisplay( $folders, "_ArrayDisplay() Test" )	
		_FileWriteFromArray("test.txt",$folders,1)
		$file=FileClose("test.txt")
	EndIf
$txtsize = FileGetSize("test.txt")
if $txtsize = 0 then 
	FileDelete ( "test.txt" )
endif
If FileExists("test.txt") Then
	_FileReadToArray("test.txt",$folders)
Else
	$file = FileOpen("test.txt", 1)
	_FileReadToArray("test.txt",$folders)
	_ArrayDelete($folders,0)
EndIf
	;_ArrayDisplay( $folders, "_ArrayDisplay() Test" )
	If FileExists("test.txt") Then
		FileDelete ( "test.txt" )
		CALL ( Folders ( ) )
		CALL ( _ArrayRemoveDupes($folders) )
		_ArraySort( $folders )	
		;_ArrayDisplay( $folders, "_ArrayDisplay() Test" )	
		_FileWriteFromArray("test.txt",$folders,1)
		$file=FileClose("test.txt")
	EndIf
EndFunc

Func Folders ( )
$folders = _ArrayRemoveDupes($folders)
EndFunc
Func _ArrayRemoveDupes($InArray)
    Dim $TempArray[$InArray[0]+1][2]
    $TempArray[0][0] = $InArray[0]
    For $x = 1 to $InArray[0]
        $TempArray[$x][0] = $InArray[$x]
        $TempArray[$x][1] = $x
    Next
$n = $temparray[0][0]
$h = 1
While $h <= $n/3
    $h = $h * 3 + 1
WEnd

While $h >0
    For $outer = $h To $n
        $temp = $temparray[$outer][0]
        $temp2 = Number(StringStripWS($temparray[$outer][1],1))
        $inner = $outer
        While $inner > ($h - 1) And StringLower($temparray[$inner-$h][0]) >= StringLower($temp)
            $temparray[$inner][0] = $temparray[$inner-$h][0]
            $temparray[$inner][1] = $temparray[$inner-$h][1]
            $inner = $inner - $h
        WEnd
        $temparray[$inner][0] = $temp
        $temparray[$inner][1] = $temp2
    Next
$h = ($h - 1)/3
WEnd    
For $blah = 1 To $temparray[0][0]-1
    If $TempArray[$blah][0] = $temparray[$blah + 1][0] Then
        _ArrayDelete($InArray,$temparray[$blah][1])
        $InArray[0] = $InArray[0]-1
    EndIf
Next
Return($InArray)
EndFunc


