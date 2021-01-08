#include <GUIConstants.au3>
#include <GuiList.au3>
#include <GuiListView.au3>
#include <Process.au3>
#include<Array.au3>
#include<File.au3>
;#NoTrayIcon

dim $folders
Dim $InArray
Dim $aret
$v = "2.00"

$txtsize = FileGetSize("~netfldr.tmp")
if $txtsize = 0 then 
	FileDelete ( "~netfldr.tmp" )
endif
If FileExists("~netfldr.tmp") Then
	_FileReadToArray("~netfldr.tmp",$folders)
Else
	$file = FileOpen("~netfldr.tmp", 1)
	_FileReadToArray("~netfldr.tmp",$folders)
	_ArrayDelete($folders,0)
EndIf

$CountLines = _FileCountLines("~netfldr.tmp")
if $CountLines > 60 Then
	msgbox (262160,"Backup", "Your Backup configuration specifies more than 60 network shares. This is beyond the limit of 60 network shares that Backup is capable of. Please uninstall Backup, delete the CONFIG.QIT file containing your settings and then re-install Backup.")
EndIf

msgbox (262208,"Backup", "Backup is currently set to protect " & $countlines & " network shares on other machines.")

GUICreate("Backup" & " version " & $v & " Setup and Installation Wizard",640,480)

TrayTip("Backup Step 2/7", "Step 2: This step is completely optional. If you have folders shared on other computers you can add them to the backup as well. Laptops, hand held devices, Apple and IBM compatible desktop computers.", 5, 1)

$filemenu = GuiCtrlCreateMenu ("File")
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$helpmenu = GuiCtrlCreateMenu ("Help!")
$webitem = GuiCtrlCreateMenuitem ("Backup Website",$helpmenu)
$guideitem = GuiCtrlCreateMenuitem ("Setup Guide",$helpmenu)
$aboutitem = GuiCtrlCreateMenuitem ("About Backup",$helpmenu)


GuiCtrlCreatePic("qbackup.gif",0,2, 175,35,$WS_EX_TRANSPARENT)
GuiCtrlCreatePic("2.gif",575,2, 60,53,$WS_EX_TRANSPARENT)
GuiCtrlCreateLabel("Setup Wizard", 5, 35)
GuiCtrlCreateLabel("Version " & $v & " © 2006 Qual-IT", 5, 50)
GuiCtrlCreateLabel("Select shared folders on other computers to backup (optional).", 5, 80)
GuiCtrlCreateLabel("Use the Clear button to clear your selections. This section is for specifying up to 60 network shares.", 5,93 )
GuiCtrlCreateLabel("If you are stuck press the Help! button for an explaination of this page, otherwise press Next when done.", 5, 106)
GuiCtrlCreateLabel("You currently have the following network shares selected:", 5, 145)

$mylist = GUICtrlCreateList("", 5, 165, 270, 165, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY))
;GUICtrlSetLimit(-1,200) ; to limit horizontal scrolling

GuiCtrlCreateLabel("Passwords for network shares:", 320, 145)
GuiCtrlCreateLabel("Some network resources require authentication. If you need to", 320, 165)
GuiCtrlCreateLabel("supply a username and password to access one or more of your", 320, 178)
GuiCtrlCreateLabel("your network resources you wish to backup, please press", 320, 191)
GuiCtrlCreateLabel("the Authentication button below to specify credentials", 320, 204)
GuiCtrlCreateLabel("that may be needed for Backup to access other machines.", 320, 217)

$authbutton = GuiCtrlCreateButton ("Authentication",380,300,70,20)
$advbutton = GuiCtrlCreateButton ("Advanced",450,300,70,20)

$outlook = GUICtrlCreateRadio("Somebody works on this computer and it has Microsoft Outlook or Outlook Express e-Mail.", 5, 365)
$exchange = GUICtrlCreateRadio("This computer is an unattended Server and has Microsoft Exchange Installed.", 5, 383)
$nonms = GUICtrlCreateRadio("This computer is an unattended Server and has a non Microsoft e-Mail system installed.", 5, 401)

$Add = GuiCtrlCreateButton ("Add",5,315,70,20)
$removebutton = GuiCtrlCreateButton ("Remove",80,315,70,20)
$clearbutton = GuiCtrlCreateButton ("Clear",155,315,70,20)

$helpbutton = GuiCtrlCreateButton ("Help!",414,435,70,20)
$quitbutton = GuiCtrlCreateButton ("Quit",489,435,70,20)
$nextbutton = GuiCtrlCreateButton ("Next >>",564,435,70,20)
$backbutton = GuiCtrlCreateButton ("<< Back",5,435,70,20)

GuiSetState()

for $i = 1 to $countlines
	$sArrayString = _ArrayToString($folders,@TAB, $i,$i )
	GUICtrlSetData($mylist, $sArrayString)
next

While 1

$msg = GUIGetMsg()
	  	Select
		
		Case $msg = $GUI_EVENT_CLOSE
      	 	$answer = MsgBox(262148, "Backup", "You are about to quit without saving your changes. Press Next to complete the next step. Backup will not operate correctly until you complete this Wizard. Are you sure?")
		If $answer = 6 Then
		exit
		EndIf
		
		Case $msg = $quitbutton
      	 	$answer = MsgBox(262148, "Backup", "You are about to quit without saving your changes. Press Next to complete the next step. Backup will not operate correctly until you complete this Wizard. Are you sure?")
		If $answer = 6 Then
		exit
		EndIf

		Case $msg = $helpbutton
          	MsgBox(262208, "Backup", "                           ")

		Case $msg = $nextbutton

			Call ( Save ( ) )
			MsgBox(262208, "Backup", "Settings saved!")
			
		
		Case $msg = $exititem
			ExitLoop

		Case $msg = $removebutton
			 $ret = _GUICtrlListGetSelItemsText ($mylist)
 		         If (Not IsArray($ret)) Then
                	 	MsgBox(262192, "Backup", "Nothing selected to remove!")
            		 Else
                  		;For $i = 1 To $ret[0]
                    			;MsgBox(262208, "Selected", $ret[$i])

			        ;Next            
			 EndIf
			 $ret = _GUICtrlListSelectedIndex ($mylist)
			 ;MsgBox(4, "Testdata", $ret)
			 $aret=( $ret + 1 )
			 _GUICtrlListDeleteItem($mylist, $ret)
			 
		Case $msg = $authbutton
			 $ret = _GUICtrlListGetSelItemsText ($mylist)
 		         If (Not IsArray($ret)) Then
                	 	MsgBox(262192, "Backup", "No shares selected to specify authentication for. Please select a share in the left hand part of this section.")
            		 Else
                  		;For $i = 1 To $ret[0]
                    			;MsgBox(262208, "Selected", $ret[$i])

			        ;Next            
			 EndIf
			 GUICreate("Backup" & " version " & $v & " Network Authentication",320,200)

$mylist = GUICtrlCreateList("", 5, 165, 270, 165, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY))
			 $ret = _GUICtrlListSelectedIndex ($mylist)
			 ;MsgBox(4, "Testdata", $ret)
			 $aret=( $ret + 1 )
			 _GUICtrlListDeleteItem($mylist, $ret)

		Case $msg = $clearbutton
              	 	$answer = MsgBox(262148, "Backup", "This will permanently remove ALL the selected folders from your backup. Are you sure?")
        	    	If $answer = 6 Then
			_GUICtrlListClear ($mylist)
			for $i = 0 to 100
				_ArrayDelete ( $folders,$i )
			next
			FileClose ( "~netfldr.tmp" )
			FileDelete ( "~netfldr.tmp" )
			EndIf

		Case $msg = $Add
			$selerr = 0
			For $i = 1 to 1
				$var = FileSelectFolder("Choose a folder to backup!", "")
				if @error = 1 Then exitloop
				$drivetype = DriveGetType( $var )
				; for testing the drive type! 
				;MsgBox(4096, "Backup", $drivetype)

				if $drivetype = "Removable" Then 
					MsgBox(262160, "Backup", "Sorry you cannot backup floppy or removable drives!") 
					exitloop
				EndIf

				if $drivetype = "CDROM" Then
					MsgBox(262160, "Backup", "Sorry you cannot backup CD-ROM or DVD-ROM Drives!") 
					exitloop
				EndIf

				if $drivetype = "Fixed" Then
					MsgBox(262160, "Backup", "Local disks are backed up in the previous part of this Wizard (step 1)!") 
					exitloop
				EndIf

				if $drivetype = "" Then
					MsgBox(262160, "Backup", "Sorry you cannot backup this location!") 
					exitloop
				EndIf
				$var2 = $var
				$var2 = StringSplit(StringTrimRight($var2,1),"\")
				$var2 = "" & $var2[1] & "\" 
				;msgbox(4,"var2",$var2)

				$checkfldr = StringInStr ( "C:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf
				
				$checkfldr = StringInStr ( "D:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "E:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "F:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "G:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "H:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "I:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "J:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "K:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "L:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "M:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "N:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "O:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "P:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "Q:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "R:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "S:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "T:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "U:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "V:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "W:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "X:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "Y:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	

				$checkfldr = StringInStr ( "Z:\", $var2 )
				if $checkfldr = 1 Then
					$selerr = 1
					MsgBox(262208, "Backup", "Your selection includes a drive on your system " & $var2 & " that cannot be added to the backup. Please browse for network shares in My Network Places. Please press the Help! button if you do not understand.") 
				EndIf	
								
				if not $selerr = 1 Then				
				$var = StringSplit(StringTrimLeft($var,2),"\")
				$var = "\\" & $var[1] & "\" & $var[2] 
        					
				_ArrayAdd ( $folders, $var )
 				GUICtrlSetData($mylist, $var)
				call ( Save () )
				EndIf

			Next

		Case $msg = $aboutitem
			
		Case $msg = $guideitem
			Msgbox(262208,"Guide", "This will display the full setup guide.")

		Case $msg = $webitem
			_RunDos("start /max                                ")

			EndSelect


WEnd

GUIDelete()

Exit

Func Save ( )
$Pos1 = _ArrayToString($folders,@TAB, 1, 1 )
;_ArrayDisplay( $folders, "_ArrayDisplay() Test" )
if $Pos1 = "" THEN exit
	If FileExists("~netfldr.tmp") Then
		FileDelete ( "~netfldr.tmp" )
		CALL ( Folders ( ) )
		CALL ( _ArrayRemoveDupes($folders) )
		_ArraySort( $folders )	
		;_ArrayDisplay( $folders, "_ArrayDisplay() Test" )	
		_FileWriteFromArray("~netfldr.tmp",$folders,1)
		$file=FileClose("~netfldr.tmp")
	EndIf
$txtsize = FileGetSize("~netfldr.tmp")
if $txtsize = 0 then 
	FileDelete ( "~netfldr.tmp" )
endif
If FileExists("~netfldr.tmp") Then
	_FileReadToArray("~netfldr.tmp",$folders)
Else
	$file = FileOpen("~netfldr.tmp", 1)
	_FileReadToArray("~netfldr.tmp",$folders)
	_ArrayDelete($folders,0)
EndIf
	;_ArrayDisplay( $folders, "_ArrayDisplay() Test" )
	If FileExists("~netfldr.tmp") Then
		FileDelete ( "~netfldr.tmp" )
		CALL ( Folders ( ) )
		CALL ( _ArrayRemoveDupes($folders) )
		if not $aret = "" THEN
			_ArrayDelete ( $folders, $aret )
		Endif
		_ArraySort( $folders )	
		;_ArrayDisplay( $folders, "_ArrayDisplay() Test" )	
		_FileWriteFromArray("~netfldr.tmp",$folders,1)
		$file=FileClose("~netfldr.tmp")
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

Func _FileSearch($szMask,$nOption)
    $szRoot = ""
    $hFile = 0
    $szBuffer = ""
    $szReturn = ""
    $szPathList = "*"
    Dim $aNULL[1]
    If Not StringInStr($szMask,"\") Then
         $szRoot = @SCRIPTDIR & "\"
    Else
         While StringInStr($szMask,"\")
              $szRoot = $szRoot & StringLeft($szMask,StringInStr($szMask,"\"))
              $szMask = StringTrimLeft($szMask,StringInStr($szMask,"\"))
         Wend
    EndIf
    If $nOption = 0 Then
         _FileSearchUtil($szRoot, $szMask, $szReturn)
    Else
         While 1
              $hFile = FileFindFirstFile($szRoot & "*.*")
              If $hFile >= 0 Then
                   $szBuffer = FileFindNextFile($hFile)
                   While Not @ERROR
                        If $szBuffer <> "." And $szBuffer <> ".." And _
                             StringInStr(FileGetAttrib($szRoot & $szBuffer),"D") Then _
                             $szPathList = $szPathList & $szRoot & $szBuffer & "*"
                        $szBuffer = FileFindNextFile($hFile)
                   Wend
                   FileClose($hFile)
              EndIf
              _FileSearchUtil($szRoot, $szMask, $szReturn)
              If $szPathList == "*" Then ExitLoop
              $szPathList = StringTrimLeft($szPathList,1)
              $szRoot = StringLeft($szPathList,StringInStr($szPathList,"*")-1) & "\"
              $szPathList = StringTrimLeft($szPathList,StringInStr($szPathList,"*")-1)

         Wend
    EndIf
    If $szReturn = "" Then
         $aNULL[0] = 0
         Return $aNULL
    Else
         Return StringSplit(StringTrimRight($szReturn,1),"*")
    EndIf
EndFunc

Func _FileSearchUtil(ByRef $ROOT, ByRef $MASK, ByRef $RETURN)
    $hFile = FileFindFirstFile($ROOT & $MASK)
    If $hFile >= 0 Then
         $szBuffer = FileFindNextFile($hFile)
         While Not @ERROR
              If $szBuffer <> "." And $szBuffer <> ".." Then _
                   $RETURN = $RETURN & $ROOT & $szBuffer & "*"
              $szBuffer = FileFindNextFile($hFile)
         Wend
         FileClose($hFile)
    EndIf
EndFunc

