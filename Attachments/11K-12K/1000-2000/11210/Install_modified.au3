#include "Header.au3"


Dim $Software = IniRead("Setup.ini" , "Global" , "Software" , "" )
Dim $Pic = IniRead("Setup.ini" , "Global", "Picture", "" )
Dim $Size = IniRead( "Setup.ini" , "Site 3" , "Size" , "Not given" )
Dim $Default_Folder = IniRead( "Setup.ini" , "Site 3", "Default_Folder" , @ProgramFilesDir )
Dim $Site1_Text = "This will install " & $Software & " on your computer." & @CRLF & @CRLF & "It is recommend that you close all other apllications before continuing." & @CRLF & @CRLF & "Click Next to continue, or Cancel to exit the Setup."
Dim $File = FileOpen("EULA.txt" , 0 )

Global $i_activewin = 1

; Site 1
$Site1 = GUICreate( "Setup - " & $Software, 500, 365)
GUICtrlCreateLabel("", 0, 315, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
$Button_Site1_Next = GUICtrlCreateButton("Next >", 320, 330, 75, 25)
GUICtrlSetState( -1 , $GUI_FOCUS )
$Button_Site1_Cancel = GUICtrlCreateButton("Cancel", 410, 330, 75, 25)
GUICtrlCreatePic( $Pic, 0, 0, 170, 315)
GUICtrlCreateLabel("Welcome to the " & $Software & " Setup Wizard", 185, 10, 300, 60)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel( $Site1_Text, 185, 80, 300, 217)

;Site 2
$Site2 = GUICreate( "Setup - " & $Software, 500, 365)
$Button_Site2_Back = GUICtrlCreateButton( "< Back" , 240 , 330 , 75, 25 )
Guictrlcreatepic( $Pic , 425, 0 , 75 , 75 )
GUICtrlCreateLabel("", 0, 75, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
GUICtrlCreateLabel("", 0, 315, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
GUICtrlCreateLabel("License Agreement" , 20, 10, 150)
GUICtrlSetFont(-1, 13, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel("Please read the following important information before continuing.", 40 , 40 )
GUICtrlCreateLabel("Please read the following License Agreement. You must accept the terms of this" & @CRLF & "agreement before continuing with the installation." , 40 ,80 , 400 , 50 )
$Edit_Site2 = GUICtrlCreateEdit( FileRead( $File ) , 20 , 120, 460 , 140, $ES_READONLY + $ES_AUTOVSCROLL + $ES_AUTOHSCROLL + $WS_VSCROLL + $WS_HSCROLL)
$Button_Site2_Next = GUICtrlCreateButton("Next >", 320, 330, 75, 25)
GUICtrlSetState( -1 , $GUI_DISABLE )
$Button_Site2_Cancel = GUICtrlCreateButton("Cancel", 410, 330, 75, 25)
$Radio_Site2_Accept = GUICtrlCreateRadio( "I accept the agreement.", 40, 270)
$Radio_Site2_Not_Accept = GUICtrlCreateRadio( "I do not accept the agreement." , 40, 290 )
GUICtrlSetState( -1, $GUI_CHECKED )
GUICtrlSetState( $Button_Site2_Back, $GUI_FOCUS )

;Site 3
$Site3 = GUICreate( "Setup - " & $Software, 500, 365)
Guictrlcreatepic( $Pic , 425, 0 , 75 , 75 )
GUICtrlCreateLabel("", 0, 75, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
GUICtrlCreateLabel("", 0, 315, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
$Button_Site3_Back = GUICtrlCreateButton( "< Back" , 240 , 330 , 75, 25 )
$Button_Site3_Next = GUICtrlCreateButton("Next >", 320, 330, 75, 25)
GUICtrlSetState( -1 , $GUI_FOCUS )
$Button_Site3_Cancel = GUICtrlCreateButton("Cancel", 410, 330, 75, 25)
GUICtrlCreateLabel( "Select Destination Location", 20, 10, 150)
GUICtrlSetFont(-1, 13, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel( "Where should " & $Software & " be installed?",40, 40, 300)
GUICtrlCreateIcon( "shell32.dll" , 3 , 40 , 100 )
GUICtrlCreateLabel( "Setup will install " & $Software & " into the following folder." , 80, 110 )
GUICtrlCreateLabel( "To continue, click Next. If you would like to select a different folder, click Browse." , 40 , 140 , 400 )
$Input_Site3_Folder = GUICtrlCreateInput( $Default_Folder , 40, 160 , 300 )
GUICtrlSetState( -1, $GUI_FOCUS )
$Button_Site3_Browse = GUICtrlCreateButton( "Browse" , 350 , 160, 75 , 22.5)
If $Size <> "Not Given" Then
	GUICtrlCreateLabel( "At least " & $Size & " of free disk space required." , 10 , 290 , 400 )
EndIf

;Site 4
$Site4 = GUICreate( "Setup - " & $Software, 500, 365)
Guictrlcreatepic( $Pic , 425, 0 , 75 , 75 )
GUICtrlCreateLabel("", 0, 75, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
GUICtrlCreateLabel("", 0, 315, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
$Button_Site4_Back = GUICtrlCreateButton( "< Back" , 240 , 330 , 75, 25 )
$Button_Site4_Next = GUICtrlCreateButton("Next >", 320, 330, 75, 25)
GUICtrlSetState( -1 , $GUI_FOCUS )
$Button_Site4_Cancel = GUICtrlCreateButton("Cancel", 410, 330, 75, 25)
GUICtrlCreateLabel( "Select Start Menu Folder", 20, 10, 150)
GUICtrlSetFont(-1, 13, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel( "Where should Setup place the program's shortcuts?",40, 40, 300)
GUICtrlCreateIcon( "shell32.dll" , 4 , 40 , 100 )
GUICtrlCreateLabel( "Setup will create the program's shortcuts in the following Start Menu Folder" , 80, 110 )
GUICtrlCreateLabel( "To continue, click Next. If you would like to select a different folder, click Browse." , 40 , 140 , 400 )
$Input_Site4_Folder = GUICtrlCreateInput( $Software , 40, 160 , 300 )
GUICtrlSetState( -1, $GUI_FOCUS )
$Button_Site4_Browse = GUICtrlCreateButton( "Browse" , 350 , 160, 75 , 22.5)
$Checkbox_Site4 = GUICtrlCreateCheckbox( "Do not create Start Menu Folder." , 30 , 290 , 400 )

;Site 5
$Site5 = GUICreate( "Setup - " & $Software, 500, 365)
Guictrlcreatepic( $Pic , 425, 0 , 75 , 75 )
GUICtrlCreateLabel("", 0, 75, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
GUICtrlCreateLabel("", 0, 315, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
$Button_Site5_Back = GUICtrlCreateButton( "< Back" , 240 , 330 , 75, 25 )
$Button_Site5_Next = GUICtrlCreateButton("Next >", 320, 330, 75, 25)
GUICtrlSetState( -1 , $GUI_FOCUS )
$Button_Site5_Cancel = GUICtrlCreateButton("Cancel", 410, 330, 75, 25)
GUICtrlCreateLabel( "Select Additional Tasks", 20, 10, 150)
GUICtrlSetFont(-1, 13, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel( "Which additional tasks should be performed?",40, 40, 300)
GUICtrlCreateLabel( "Select the additional tasks you would like Setup to perform while installing" & @CRLF & $Software & " , then click Next." , 40, 110 )
GUICtrlCreateLabel( "Additional icons:" , 40 , 150 )
$Checkbox_Site5_Quicklaunch = GUICtrlCreateCheckbox( "Create a Quick Launch icon" , 40 , 180 )
$Checkbox_Site5_Desktop = GUICtrlCreateCheckbox( "Create a desktop icon", 40 , 210 )
GUICtrlSetState( $Checkbox_Site5_Desktop, $GUI_CHECKED )

;Site 6
$Site6 = GUICreate( "Setup - " & $Software, 500, 365)
Guictrlcreatepic( $Pic , 425, 0 , 75 , 75 )
GUICtrlCreateLabel("", 0, 75, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
GUICtrlCreateLabel("", 0, 315, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
$Button_Site6_Back = GUICtrlCreateButton( "< Back" , 240 , 330 , 75, 25 )
$Button_Site6_Install = GUICtrlCreateButton("Install", 320, 330, 75, 25)
GUICtrlSetState( -1 , $GUI_FOCUS )
$Button_Site6_Cancel = GUICtrlCreateButton("Cancel", 410, 330, 75, 25)
GUICtrlCreateLabel( "Ready to install", 20, 10, 150)
GUICtrlSetFont(-1, 13, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel( "Setup is now ready to start installing " & $Software & " on your computer.", 40, 40, 300)
GUICtrlCreateLabel( "Click Install to continue with the installation, or Back if you want to " & @CRLF & "review or change any settings.", 40 , 110)
$Edit_Site6 = GUICtrlCreateEdit( "" , 40 , 150, -1 , 150 , $ES_READONLY)

;Site 7
$Site7 = GUICreate( "Setup - " & $Software, 500, 365)
Guictrlcreatepic( $Pic , 425, 0 , 75 , 75 )
GUICtrlCreateLabel("", 0, 75, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
GUICtrlCreateLabel("", 0, 315, 500, 3)
GUICtrlSetBkColor( -1 , "0xFFFFFF" )
$Button_Site7_Back = GUICtrlCreateButton( "< Back" , 240 , 330 , 75, 25 )
GUICtrlSetState( -1, $GUI_DISABLE )
$Button_Site7_Install = GUICtrlCreateButton("Install", 320, 330, 75, 25)
GUICtrlSetState( -1 , $GUI_DISABLE )
$Button_Site7_Finish = GUICtrlCreateButton("Finish", 410, 330, 75, 25)
GUICtrlSetState( -1, $GUI_DISABLE )
GUICtrlCreateLabel( "Installing...", 20, 10, 150)
GUICtrlSetFont(-1, 13, 400, 0, "MS Sans Serif")
$Label_Site7_Finished = GUICtrlCreateLabel( "Wait..." , 40 , 150, 300 )

;Set Site1 show
GUISetState( @SW_SHOW , $Site1 )

While 1 
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			_Exit($i_activewin)
		Case $Button_Site1_Next
			$ai_winposition = WinGetPos ($Site1)
			WinMove($Site2,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site2 )
			GUISetState( @SW_HIDE, $Site1 )
			$i_activewin = $Site2
		Case $Button_Site2_Back
			$ai_winposition = WinGetPos ($Site2)
			WinMove($Site1,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site1 )
			GUISetState( @SW_HIDE, $Site2 )	
			$i_activewin = $Site1 
		Case $Button_Site2_Next
			$ai_winposition = WinGetPos ($Site2)
			WinMove($Site3,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site3 )
			GUISetState( @SW_HIDE, $Site2 )
			$i_activewin = $Site3
		Case $Button_Site3_Back
			$ai_winposition = WinGetPos ($Site3)
			WinMove($Site2,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site2 )
			GUISetState( @SW_HIDE, $Site3 )
			$i_activewin = $Site2
		Case $Button_Site3_Next
			$ai_winposition = WinGetPos ($Site3)
			WinMove($Site4,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site4 )
			GUISetState( @SW_HIDE, $Site3 )
			$i_activewin = $Site4
		Case $Button_Site4_Back
			$ai_winposition = WinGetPos ($Site4)
			WinMove($Site3,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site3 )
			GUISetState( @SW_HIDE, $Site4 )
			$i_activewin = $Site3
		Case $Button_Site4_Next
			$ai_winposition = WinGetPos ($Site4)
			WinMove($Site5,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site5 )
			GUISetState( @SW_HIDE, $Site4 )
			$i_activewin = $Site5
		Case $Button_Site5_Back
			$ai_winposition = WinGetPos ($Site5)
			WinMove($Site4,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site4 )
			GUISetState( @SW_HIDE, $Site5 )	
			$i_activewin = $Site4
		Case $Button_Site5_Next
			$ai_winposition = WinGetPos ($Site5)
			WinMove($Site6,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site6 )
			GUISetState( @SW_HIDE, $Site5 )
			$i_activewin = $Site6
			$Edit_Site6_Text = "Destination location:" & @CRLF & "  " & GUICtrlRead( $Input_Site3_Folder ) & @CRLF & @CRLF 
			If GUICtrlRead( $Checkbox_Site4 ) = 0 Then
				$Edit_Site6_Text = $Edit_Site6_Text & "Start Menu folder:" & @CRLF & "  " & GUICtrlRead( $Input_Site4_Folder ) & @CRLF & @CRLF 
			EndIf
			If GUICtrlRead( $Checkbox_Site5_Desktop ) = 1 or GUICtrlRead( $Checkbox_Site5_Quicklaunch ) = 1 Then
				$Edit_Site6_Text &= "Additional Tasks:"
				If GUICtrlRead( $Checkbox_Site5_Desktop ) = 1 Then
					$Edit_Site6_Text = $Edit_Site6_Text & @CRLF & "Create Desktop Icon"
				EndIf
				If GUICtrlRead( $Checkbox_Site5_Quicklaunch) = 1 Then
					$Edit_Site6_Text = $Edit_Site6_Text & @CRLF & "Create Quicklaunch Icon"
				EndIf
			EndIf
			GUICtrlSetData( $Edit_Site6 , "" )
			GUICtrlSetData( $Edit_Site6 , $Edit_Site6_Text )
		Case $Button_Site6_Back
			$ai_winposition = WinGetPos ($Site6)
			WinMove($Site5,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW, $Site5 )
			GUISetState( @SW_HIDE, $Site6 )	
			$i_activewin = $Site5
		Case $Button_Site6_Install
			$ai_winposition = WinGetPos ($Site6)
			WinMove($Site7,"",$ai_winposition[0],$ai_winposition[1])
			GUISetState( @SW_SHOW , $Site7 )
			GUISetState( @SW_HIDE , $Site6 )
			$i_activewin = $Site7
			#include "Files.au3"
			If GUICtrlRead( $Checkbox_Site5_Desktop ) = 1 Then
				If GUICtrlRead( $Checkbox_Site5_Desktop ) = 1 Then
					FileCreateShortcut( IniRead( "Setup.ini" , "Shortcuts", "Desktoppath" , "" ) , @DesktopDir & IniRead( "Setup.ini" , "Shortcuts", "Desktopname" , "" ) )
				EndIf
				If GUICtrlRead( $Checkbox_Site5_Quicklaunch) = 1 Then
					FileCreateShortcut( IniRead( "Setup.ini" , "Shortcuts", "Quicklaunchpath" , "" ) , @DesktopDir & IniRead( "Setup.ini" , "Shortcuts", "Quicklaunchname" , "" ) )
				EndIf
			EndIf
			If GUICtrlRead( $Checkbox_Site4 ) = $GUI_CHECKED Then
				#include "Startmenu.au3"
			EndIf
			GUICtrlSetData( $Label_Site7_Finished, "Finished installing" )
			GUICtrlSetState( $Button_Site7_Finish, $GUI_ENABLE )
		Case $Button_Site1_Cancel 
			_Exit( $Site1 )
		Case $Button_Site2_Cancel
			_Exit( $Site2 )
		Case $Button_Site3_Cancel
			_Exit( $Site3 )
		Case $Button_Site4_Cancel
			_Exit( $Site4 )
		Case $Button_Site5_Cancel
			_Exit( $Site5 )
		Case $Button_Site6_Cancel
			_Exit( $Site6 )
		Case $Button_Site7_Finish
			Exit
		Case $Radio_Site2_Accept
			GUICtrlSetState( $Button_Site2_Next , $GUI_ENABLE )
			GUICtrlSetState( $Button_Site2_Next , $GUI_FOCUS)
		Case $Radio_Site2_Not_Accept
			GUICtrlSetState( $Button_Site2_Next , $GUI_DISABLE )
			GUICtrlSetState( $Button_Site2_Back, $GUI_FOCUS )
		Case $Checkbox_Site4
			If GUICtrlRead($Checkbox_Site4) = $GUI_CHECKED Then
				GUICtrlSetState( $Input_Site4_Folder , $GUI_DISABLE )
				GUICtrlSetState( $Button_Site4_Browse, $GUI_DISABLE )
			Else
				GUICtrlSetState( $Input_Site4_Folder , $GUI_ENABLE )
				GUICtrlSetState( $Button_Site4_Browse, $GUI_ENABLE )
			Endif
		Case $Button_Site3_Browse
			$Dest = FileSelectFolder( "Select Folder" , GUICtrlRead( $Input_Site3_Folder ) )
			If $Dest <> "" Then
				GUICtrlSetData( $Input_Site3_Folder , $Dest )
			EndIf
		Case $Button_Site4_Browse
			$Dest = FileSelectFolder( "Select Folder" , @StartMenuDir)
			If $Dest <> "" Then
				GUICtrlSetData( $Input_Site4_Folder , $Dest )
			EndIf
	EndSwitch
WEnd

Func _Exit( $GUI )
	GUISetState( @SW_DISABLE, $GUI )
	$Box = MsgBox( 4 + 48 , "Exit Setup"  , "Setup is not complete, if you exit now the program will not be installed." & @CRLF & "Are you sure you want to exit the setup?")
	If $Box = 6 Then
		Exit
	ElseIf $Box = 7 Then
		GUISetState( @SW_ENABLE, $GUI )
		GUISetState(@SW_RESTORE, $GUI )
	EndIf
EndFunc
