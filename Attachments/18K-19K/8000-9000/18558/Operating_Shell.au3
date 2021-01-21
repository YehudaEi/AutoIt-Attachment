#Include <Misc.au3>
#Include <GuiConstants.au3>
#Include <File.au3>

; +---------------------------------+
; | General Variables for script    |
; +---------------------------------+

Dim $Title = 'Lycanian Operating Shell'
Dim $Hide_Menu = 1, $Join = 1, $File_Bin_i = 1
Dim $Files[1000], $FileSize, $RightActive = 0
Dim $Icon_Image[200], $Icon_Text[200], $Time
Dim $x = 20, $y = 30, $w = 35, $h = 35
Dim $Icon_Determine, $Path[200], $SC_Backdrop
Dim $Shift = 122, $pfText[30], $posit[100]
Dim $pfText[16], $pfFile[30], $sn = 100
Dim $DropText[10000], $sc_text[100], $Hidden_Snow = 0
Dim $ConfigFile = 'Config.ini'

Dim $vText = 0x00FF00
Dim $vHText = 0xFF0000
Dim $vBackground = 0x000000
Dim $vSMBackground = 0x313131

; +----------------------------------+
; |	Declare The Icons For Future Use |
; +----------------------------------+

Dim Const $Picture_Icon = 117
Dim Const $Exe_Icon = 2
Dim Const $Folder_Icon_Open = 3
Dim Const $Folder_Icon_Closed = 4
Dim Const $Command_Icon = 24
Dim Const $Recycling_Icon = 101
Dim Const $Music_File = 116
Dim Const $Internet_Icon = 220
Dim Const $Txt_Icon = 70
Dim Const $Ini_Icon = 69
Dim Const $Unknown_Icon = 0
Dim Const $Shutdown_Icon = 25

Dim $Project = 'This project was set up by Seclinix on the 15th October 2007 to create a Operating system that can be integrated with windows so the user can have a totally new look on things and have a more understandable system that looks after itself and makes the users computer more friendly. It is a free open source project like unix and is written in AutoIt3 so if you would like to donate to this project you may donate money if you wish too or you can help with the coding which would be most appreciated. You can contact me through email: Seclinix@gmail.com'

$Files = _FileListToArray ( @DesktopDir, '*', 1 )

$MainOSHandle = GuiCreate ( $Title, 1028, 800, -5, -40 )
GuiSetBkColor ( $vBackground, $MainOSHandle )
For $i = 1 To $Files[0]
	
	$Ext = StringSplit ( $Files[$i], '.' )
	
	If $Ext[2] = 'exe' Then 
		$Icon_ID = '%1'
		$IPath = FileGetLongName ( $Files[$i] )
	EndIf
	If $Ext[2] = 'jpeg' Then 
		$Icon_ID = 117
		$IPath = 'Shell32.dll'
	EndIf
	If $Ext[2] = 'txt' Then 
		$Icon_ID = 70
		$IPath = 'Shell32.dll'
	EndIf
	If $Ext[2] = 'ini' Then 
		$Icon_ID = 69
		$IPath = 'Shell32.dll'
	EndIf
	If $Ext[2] = 'lnk' Then 
		$Icon_ID = 85
		$IPath = 'Shell32.dll'
	EndIf
	If $Ext[2] = 'Note' Then 
		$Icon_ID = 84
		$IPath = 'Shell32.dll'
	EndIf
		
	$Filename = StringSplit ( FileGetLongName ( $Files[$i] ), '\' )
	
	For $n = 1 To $Filename[0]
		$File_Name = $Filename[$n]
	Next
		
	$Icon_Image[$i] = GuiCtrlCreateIcon ( $IPath, $Icon_ID, $x, $y, $w, $h )
	$ControlPos = ControlGetPos ( $Title, '', $Icon_Image[$i] )
	$lx = $ControlPos[0] - 20
	$ly = ( $ControlPos[1] + $ControlPos[2] ) + 5
	$lw = 80
	$lh = 40
	$Icon_Text[$i] = GuiCtrlCreateLabel ( $File_Name, $lx, $ly, $lw, $lh, $SS_Center )
	$Path[$i] = FileGetShortName ( $Files[$i] )
	GuiCtrlSetColor ( $Icon_Text[$i], $vText )
	GuiCtrlSetBkColor ( $Icon_Text[$i], $GUI_BKCOLOR_TRANSPARENT )
	$x = $x + 80
	If $x > 900 Then 
		$x = 20
		$y = $y + 100
	EndIf
Next

; +-----------------------------+
; |			StartMenu			|
; +-----------------------------+

$StartButton = GuiCtrlCreateLabel ( 'Start Menu', 0, 748, 96, 30, $SS_Sunken )
GuiCtrlSetColor ( $StartButton, $vText )
GuiCtrlSetFont ( $StartButton, 14, 400, 0, 'Arial' )
GuiCtrlSetBkColor ( $StartButton, $vSMBackground )
;GuiCtrlCreateButton ( 'Start Menu', 0, 748, 96, 30, $BS_DEFPUSHBUTTON  )
$Menu_Bar = GuiCtrlCreateLabel ( '', 96, 748, 820, 30, $SS_SUNKEN  )
$Time_Bar = GuiCtrlCreateLabel ( @Hour & ':' & @Min, 900, 748, 120, 30, $SS_Center + $SS_SUNKEN  )

GuiCtrlSetBKColor ( $Menu_Bar, $vSMBackground )
GuiCtrlSetFont ( $Menu_Bar, 18, 400, 0, 'Times New Roman' )
GuiCtrlSetColor ( $Menu_Bar, $vText )

GuiCtrlSetBKColor ( $Time_Bar, $vSMBackground )
GuiCtrlSetFont ( $Time_Bar, 18, 400, 0, 'Times New Roman' )
GuiCtrlSetColor ( $Time_Bar, $vText )

; +-----------------------------+
; |			StartMenu Bar		|
; +-----------------------------+

$Start_Menu = GuiCtrlCreateLabel ( '', 2, 448, 200, 300, $SS_Sunken )
GuiCtrlSetBkColor ( $Start_Menu, $vSMBackground )
GuiCtrlSetState ( $Start_Menu, $Gui_Hide )

$SMText2 = GuiCtrlCreateLabel ( 'Exit', 6, 555 + $Shift, 200, 20 )
GuiCtrlSetFont ( $SMText2, 12, 600, 0, 'Lucida Console' )
GuiCtrlSetBkColor ( $SMText2, $GUI_BKCOLOR_TRANSPARENT )
$SMText3 = GuiCtrlCreateLabel ( 'Command Prompt', 6, 525 + $Shift, 200, 20 )
GuiCtrlSetFont ( $SMText3, 12, 600, 0, 'Lucida Console' )
GuiCtrlSetBkColor ( $SMText3, $GUI_BKCOLOR_TRANSPARENT )
$SMText4 = GuiCtrlCreateLabel ( 'Paint', 6, 495 + $Shift, 200, 20 )
GuiCtrlSetFont ( $SMText4, 12, 600, 0, 'Lucida Console' )
GuiCtrlSetBkColor ( $SMText4, $GUI_BKCOLOR_TRANSPARENT )
$SMText5 = GuiCtrlCreateLabel ( 'Internet Explorer', 6, 465 + $Shift, 200, 20 )
GuiCtrlSetFont ( $SMText5, 12, 600, 0, 'Lucida Console' )
GuiCtrlSetBkColor ( $SMText5, $GUI_BKCOLOR_TRANSPARENT )
$SMText6 = GuiCtrlCreateLabel ( 'Admin Panel', 6, 435 + $Shift, 200, 20 )
GuiCtrlSetFont ( $SMText6, 12, 600, 0, 'Lucida Console' )
GuiCtrlSetBkColor ( $SMText6, $GUI_BKCOLOR_TRANSPARENT )
$SMText7 = GuiCtrlCreateLabel ( 'System Info', 6, 405 + $Shift, 200, 20 )
GuiCtrlSetFont ( $SMText7, 12, 600, 0, 'Lucida Console' ) 
GuiCtrlSetBkColor ( $SMText7, $GUI_BKCOLOR_TRANSPARENT )
GuiCtrlSetColor ( $SMText2, $vText )
GuiCtrlSetColor ( $SMText3, $vText ) 
GuiCtrlSetColor ( $SMText4, $vText )
GuiCtrlSetColor ( $SMText5, $vText )
GuiCtrlSetColor ( $SMText6, $vText )
GuiCtrlSetColor ( $SMText7, $vText )

$User_Pic = GuiCtrlCreateButton ( 'Picture', 6, 330 + $Shift, 60, 60, $BS_ICON )
$Username = GuiCtrlCreateLabel ( @Username, 66, 335 + $Shift, 120, 40, $SS_Center )
GuiCtrlSetBkColor ( $Username, $GUI_BKCOLOR_TRANSPARENT )
GuiCtrlSetImage ( $User_Pic, 'Shell32.dll', 130 )
GuiCtrlSetFont ( $Username, 12, 600, 6, 'Lucida Console' )
GuiCtrlSetColor ( $Username, $vText )

; +------------------------------+
; |		Files Bin Menu			 |
; +------------------------------+

$Program_Files = GuiCtrlCreateLabel ( '', 205, 250, 160, 300, $SS_Sunken )
GuiCtrlSetBkColor ( $Program_Files, 0x313131 )

$pfText[1] = GuiCtrlCreateLabel ( 'Username: ' & @Username, 210, 260, 140, 20 )
$pfText[2] = GuiCtrlCreateLabel ( 'Operating system: ' & @OSTYPE , 210, 280, 140, 40 )
$pfText[3] = GuiCtrlCreateLabel ( 'Operating Build: ' & @OSBuild, 210, 320, 140, 20 )
$pfText[4] = GuiCtrlCreateLabel ( 'Computer Name: ' & @ComputerName, 210, 340, 140, 40 )
$pfText[5] = GuiCtrlCreateLabel ( 'IP Address: ' & @IPAddress1, 210, 380, 140, 30 )
$pfText[6] = GuiCtrlCreateLabel ( 'Version: ' & @AutoItVersion, 210, 400, 140, 30 )

For $i = 1 To 6
	GuiCtrlSetColor ( $pfText[$i], $vText )
	GuiCtrlSetBkColor ( $pfText[$i], $GUI_BKCOLOR_TRANSPARENT )
	GuiCtrlSetFont ( $pfText[$i], 10, 400, 0, 'Arial' )
Next


; +------------------------------+
; |		Right Click Menu		 |
; +------------------------------+

$RCBackdrop = GuiCtrlCreateLabel ( '', 200, 200, 100, 150, $SS_Sunken )
GuiCtrlSetBkColor ( $RCBackdrop, $vSMBackground )
ControlDisable ( $Title, '', $RCBackdrop )
$New = GuiCtrlCreateLabel ( 'Create New', 205, 205, 90, 15 )
GuiCtrlSetBkColor ( $New, $Gui_Bkcolor_Transparent )
GuiCtrlSetColor ( $New, $vText )
GuiCtrlSetFont ( $New, 9, 400, '', 'Lucida Console' )
$Delete = GuiCtrlCreateLabel ( 'Delete', 205, 220, 90, 15 )
GuiCtrlSetBkColor ( $Delete, $Gui_Bkcolor_Transparent )
GuiCtrlSetColor ( $Delete, $vText )
GuiCtrlSetFont ( $Delete, 9, 400, '', 'Lucida Console' )
$Tools = GuiCtrlCreateLabel ( 'Tools', 205, 235, 90, 15 )
GuiCtrlSetBkColor ( $Tools, $Gui_Bkcolor_Transparent )
GuiCtrlSetColor ( $Tools, $vText )
GuiCtrlSetFont ( $Tools, 9, 400, '', 'Lucida Console' )
$ACTSnow = GuiCtrlCreateLabel ( 'Start Snow', 205, 250, 90, 15 )
GuiCtrlSetBkColor ( $ACTSnow, $Gui_BKColor_Transparent )
GuiCtrlSetColor ( $ACTSnow, $vText )
GuiCtrlSetFont ( $ACTSnow, 9, 400, '', 'Lucida Console' )


; +------------------------------+
; |			Note Viewing		 |
; +------------------------------+

$Notebook = GuiCtrlCreateLabel ( '', 800, 500, 220, 240, $SS_Sunken )
ControlDisable ( $Title, '', $Notebook )
GuiCtrlSetBkColor ( $Notebook, $vSMBackground )
$Notebook_Title = GuiCtrlCreateLabel ( 'This is the Title', 805, 505, 210, 30, $SS_Center )
GuiCtrlSetFont ( $Notebook_Title, 18, 400, 0, 'System' )
GuiCtrlSetColor ( $Notebook_Title, $vText )
$Notebook_Note = GuiCtrlCreateLabel ( 'This is the note', 805, 540, 210, 195 )
GuiCtrlSetColor ( $Notebook_Note, $vText )

; +------------------------------+
; |
; +------------------------------+

; +------------------------------+
; |	Stuff To Start Off With...	 |
; +------------------------------+
HideStartMenu()
HideFilesBin()
HideRightClick()
HideNotebook()
GuiSetState ()
Activate_Screensaver_Snow()


While 1
	
	$Dc001 = GuiGetMsg ()
	
	If $Dc001 = $Gui_Event_Close Then Exit
	
	Select
		
	Case $Dc001 = $StartButton
		If $Hide_Menu = 1 Then 
			ShowStartMenu()
			$Hide_Menu = 0
		Else
			$Hide_Menu = 1
			HideStartMenu()
			HideFilesBin()
			$File_Bin_i = 1
		EndIf
		
	Case _IsPressed ( '02' ) 
		$KZad = MouseGetPos ( )
		$RightActive = 1
		ShowRightClick( $KZad[0],$KZad[1] )
		
	Case _IsPressed ( '01' ) 
		If WinActive ( $Title ) Then 
			$Cursor = GUIGetCursorInfo ( $MainOSHandle )
			If $RightActive = 1 Then
				If $Cursor[4] <> $RCBackdrop Then 
					If $Cursor[4] <> $New And $Cursor[4] <> $Delete And $Cursor[4] <> $Tools Then 
						HideRightClick()
						$RightActive = 0
					EndIf
				EndIf
				If $Cursor[4] = $ACTSnow Then
					$Optn = ControlGetText ( $Title, '', $ACTSnow )
					If $Optn = 'Start Snow' Then 
						Activate_Screensaver_Snow()
					EndIf
					If $Optn = 'Stop Snow' Then
						$Hidden_Snow = 1
					EndIf
					
				EndIf
				
			EndIf
			
			For $s = 1 To $Files[0]
				If $Cursor[2] = 1 Then 
					If $Cursor[4] = $Icon_Image[$s] Then
							Sleep ( 100 )
							$Check = GuiGetCursorInfo ( $MainOSHandle )
							If $Check[2] = 0 Then 
								Run ( @Comspec & ' /c ' & 'Start ' & $Path[$s], '', @sw_Hide )
								Exitloop
							Else
								While $Cursor[2] = 1 					
									GuiCtrlSetPos ( $Icon_Image[$s], $Cursor[0] - 5, $Cursor[1] )
									$Icon_Pos = ControlGetPos ( $Title, '', $Icon_Image[$s] )
									$xpos = $Icon_Pos[0] - 20
									$ypos = ( $Icon_Pos[1] + $Icon_Pos[2] ) + 5
									GuiCtrlSetPos ( $Icon_Text[$s], $xpos, $ypos )
									Sleep ( 20 )
									$Cursor = GuiGetcursorInfo ( $MainOSHandle )
								WEnd
							EndIf
					EndIf
				EndIf
			Next
		EndIf
		
	EndSelect
	
	Select
		
	Case $Dc001 = $SMText2
		Exit
	Case $Dc001 = $SMText3
		Run ( @Comspec, '', @sw_show )
	Case $Dc001 = $SMText4
		Run ( @Comspec & ' /c Start mspaint.exe', @SystemDir, @sw_hide )
	Case $Dc001 = $SMText5
		$Shell = ObjCreate ( 'InternetExplorer.Application.1' )
		$Shell.Navigate = ( 'www.Google.co.nz' )
		$Shell.Visible = 1
	Case $Dc001 = $SMText6
		
	Case $Dc001 = $SMText7
		If $File_Bin_i = 1 Then 
			ShowFilesBin()
			$File_Bin_i = 0
		Else
			HideFilesBin()
			$File_Bin_i = 1
		EndIf
	EndSelect
	
	Show_Colors()
	
WEnd

Func HideStartMenu()
	GuiCtrlSetState ( $Start_Menu, $Gui_Hide )
	GuiCtrlSetState ( $SMText2, $Gui_Hide )
	GuiCtrlSetState ( $SMText3, $Gui_Hide )
	GuiCtrlSetState ( $SMText4, $Gui_Hide )
	GuiCtrlSetState ( $SMText5, $Gui_Hide )
	GuiCtrlSetState ( $SMText6, $Gui_Hide )
	GuiCtrlSetState ( $SMText7, $Gui_Hide )
	GuiCtrlSetState ( $User_Pic, $Gui_Hide )
	GuiCtrlSetState ( $Username, $Gui_Hide )
EndFunc

Func ShowStartMenu()
	GuiCtrlSetState ( $SMText2, $Gui_Show )
	GuiCtrlSetState ( $SMText3, $Gui_Show )
	GuiCtrlSetState ( $SMText4, $Gui_Show )
	GuiCtrlSetState ( $SMText5, $Gui_Show )
	GuiCtrlSetState ( $SMText6, $Gui_Show )
	GuiCtrlSetState ( $SMText7, $Gui_Show )
	GuiCtrlSetState ( $User_Pic, $Gui_Show )
	GuiCtrlSetState ( $Username, $Gui_Show )
	GuiCtrlSetState ( $Start_Menu, $Gui_Show )
	GuiCtrlSetState ( $Start_Menu, $Gui_Disable )
EndFunc

Func ShowFilesBin()
	GuiCtrlSetState ( $Program_Files, $Gui_Show )
	GuiCtrlSetState ( $Program_Files, $Gui_Disable )
	For $i = 1 To 6
		GuiCtrlSetState ( $pfText[$i], $Gui_Show )
	Next
EndFunc

Func HideFilesBin()
	GuiCtrlSetState ( $Program_Files, $Gui_Hide )
	For $i = 1 To 6
		GuiCtrlSetState ( $pfText[$i], $Gui_Hide )
	Next
EndFunc

Func HideRightClick()
	GuiCtrlSetState ( $RCBackdrop, $Gui_Hide )
	GuiCtrlSetState ( $New, $Gui_Hide )
	GuiCtrlSetState ( $Delete, $Gui_Hide )
	GuiCtrlSetState ( $Tools, $Gui_Hide )
	GuiCtrlSetState ( $ACTSnow, $Gui_Hide )
EndFunc

Func ShowRightClick( $Positionx, $Positiony )
	
	$StablePoint = MouseGetPos ()
	
	ControlMove ( $Title, '', $RCBackdrop, $StablePoint[0], $StablePoint[1] )
	ControlMove ( $Title, '', $New, $StablePoint[0] + 5, $StablePoint[1] + 10 )
	ControlMove ( $Title, '', $Delete, $StablePoint[0] + 5, $StablePoint[1] + 25 )
	ControlMove ( $Title, '', $Tools, $StablePoint[0] + 5, $StablePoint[1] + 40 )
	ControlMove ( $Title, '', $ACTSnow, $StablePoint[0] + 5, $StablePoint[1] + 55 )
	
	GuiCtrlSetState ( $RCBackdrop, $Gui_Show )
	GuiCtrlSetState ( $New, $Gui_Show )
	GuiCtrlSetState ( $Delete, $Gui_Show )
	GuiCtrlSetState ( $Tools, $Gui_Show )
	GuiCtrlSetState ( $ACTSnow, $Gui_Show )
	
	GuiCtrlSetState ( $RCBackdrop, $Gui_Enable )
	GuiCtrlSetState ( $New, $Gui_Enable )
	GuiCtrlSetState ( $Delete, $Gui_Enable )
	GuiCtrlSetState ( $Tools, $Gui_Enable )
	GuiCtrlSetState ( $ACTSnow, $Gui_Enable )
EndFunc

Func HideNotebook()
	GuiCtrlSetState ( $Notebook, $Gui_Hide )
	GuiCtrlSetState ( $Notebook_Title, $Gui_Hide )
	GuiCtrlSetState ( $Notebook_Note, $Gui_Hide )
EndFunc

Func ShowNotebook()
	GuiCtrlSetState ( $Notebook, $Gui_Show )
	GuiCtrlSetState ( $Notebook_Title, $Gui_Show )
	GuiCtrlSetState ( $Notebook_Note, $Gui_Show )
EndFunc

Func ChangeColor( $Colors )
	GuiCtrlSetColor ( $SMText1, $Colors )
	GuiCtrlSetColor ( $SMText2, $Colors )
	GuiCtrlSetColor ( $SMText3, $Colors )
	GuiCtrlSetColor ( $SMText4, $Colors )
	GuiCtrlSetColor ( $SMText5, $Colors )
	GuiCtrlSetColor ( $SMText6, $Colors )
	GuiCtrlSetColor ( $SMText7, $Colors )
	For $l = 1 To $Files[0]
		GuiCtrlSetColor ( $Icon_Text[$l], $Colors )
	Next
	GuiCtrlSetColor ( $pfText[1], $Colors )
	GuiCtrlSetColor ( $pfText[2], $Colors )
	GuiCtrlSetColor ( $pfText[3], $Colors )
	GuiCtrlSetColor ( $pfText[4], $Colors )
	GuiCtrlSetColor ( $pfText[5], $Colors )
	GuiCtrlSetColor ( $pfText[6], $Colors )
	
EndFunc

Func Activate_Screensaver_Snow()
	;$SC_Backdrop = GuiCtrlCreateLabel ( '', 0, 0, @DesktopWidth, @DesktopHeight ) 
	GuiCtrlSetData ( $ACTSnow, 'Stop Snow' )
	For $sc = 1 To 30
		$Randomx = Random ( 0, 1024 )
		$Randomy = Random ( 0, 800 )
		
		$sc_text[$sc] = GuiCtrlCreateLabel ( '*', $Randomx, $Randomy, 5, 5 )
		
		GuiCtrlSetBkColor ( $sc_text[$sc], 0x000000 )
		GuiCtrlSetFont ( $sc_text[$sc], 7, 400, 0, 'Lucida Console' )
	Next
	
	While 1
		Sleep ( 6 )
		
		For $zk = 1 To 30
			$SnowPos = ControlGetPos ( $Title, '', $sc_text[$zk] )
			If $Hidden_Snow = 0 Then 
				If $SnowPos[1] > 735 Then 
					ControlMove ( $Title, '', $sc_text[$zk], $SnowPos[0], 0 )
					GuiCtrlSetColor ( $sc_text[$zk], 0xFFFFFF )
				Else
					ControlMove ( $Title, '', $sc_text[$zk], $SnowPos[0], $SnowPos[1] + 10 )
				EndIf
			Else
				Hide_Screensaver_Snow()
				ExitLoop
			EndIf
			
			MustDoFunc()
			Show_Colors()
		Next
		If $Hidden_Snow = 1 Then
			$Hidden_Snow = 0
			GuiCtrlSetData ( $ACTSnow, 'Start Snow' )
			ExitLoop
		EndIf
	WEnd
	
EndFunc

Func Hide_Screensaver_Snow()
	;GuiCtrlDelete ( $SC_Backdrop )
	For $p = 1 To 30
		GuiCtrlDelete ( $sc_text[$p] )
	Next
	$Hiden_Snow = 1
EndFunc

Func MustDoFunc()

	$Dc001 = GuiGetMsg ()
	
	Select
		
	Case $Dc001 = $StartButton
		If $Hide_Menu = 1 Then 
			ShowStartMenu()
			$Hide_Menu = 0
		Else
			$Hide_Menu = 1
			HideStartMenu()
			HideFilesBin()
			$File_Bin_i = 1
		EndIf
		
	Case _IsPressed ( '02' ) 
		$KZad = MouseGetPos ( )
		$RightActive = 1
		ShowRightClick( $KZad[0],$KZad[1] )
		
	Case _IsPressed ( '01' ) 
		If WinActive ( $Title ) Then 
			$Cursor = GUIGetCursorInfo ( $MainOSHandle )
			If $RightActive = 1 Then
				If $Cursor[4] <> $RCBackdrop Then 
					If $Cursor[4] <> $New And $Cursor[4] <> $Delete And $Cursor[4] <> $Tools Then 
						HideRightClick()
						$RightActive = 0
					EndIf
				EndIf
				If $Cursor[4] = $ACTSnow Then
					$Optn = ControlGetText ( $Title, '', $ACTSnow )
					If $Optn = 'Start Snow' Then 
						Activate_Screensaver_Snow()
					EndIf
					If $Optn = 'Stop Snow' Then
						$Hidden_Snow = 1
					EndIf
					
				EndIf
				
			EndIf
			
			For $s = 1 To $Files[0]
				If $Cursor[2] = 1 Then 
					If $Cursor[4] = $Icon_Image[$s] Then
							Sleep ( 100 )
							$Check = GuiGetCursorInfo ( $MainOSHandle )
							If $Check[2] = 0 Then 
								Run ( @Comspec & ' /c ' & 'Start ' & $Path[$s], '', @sw_Hide )
								Exitloop
							Else
								While $Cursor[2] = 1 					
									GuiCtrlSetPos ( $Icon_Image[$s], $Cursor[0] - 5, $Cursor[1] )
									$Icon_Pos = ControlGetPos ( $Title, '', $Icon_Image[$s] )
									$xpos = $Icon_Pos[0] - 20
									$ypos = ( $Icon_Pos[1] + $Icon_Pos[2] ) + 5
									GuiCtrlSetPos ( $Icon_Text[$s], $xpos, $ypos )
									Sleep ( 20 )
									$Cursor = GuiGetcursorInfo ( $MainOSHandle )
								WEnd
							EndIf
					EndIf
				EndIf
			Next
		EndIf
		
	EndSelect
	
	Select
		
	Case $Dc001 = $SMText2
		Exit
	Case $Dc001 = $SMText3
		Run ( @Comspec, '', @sw_show )
	Case $Dc001 = $SMText4
		Run ( @Comspec & ' /c Start mspaint.exe', @SystemDir, @sw_hide )
	Case $Dc001 = $SMText5
		$Shell = ObjCreate ( 'InternetExplorer.Application.1' )
		$Shell.Navigate = ( 'www.Google.co.nz' )
		$Shell.Visible = 1
	Case $Dc001 = $SMText6
		
	Case $Dc001 = $SMText7
		If $File_Bin_i = 1 Then 
			ShowFilesBin()
			$File_Bin_i = 0
		Else
			HideFilesBin()
			$File_Bin_i = 1
		EndIf
	EndSelect
	
EndFunc

Func Show_Colors()
	If WinGetTitle ( '' ) = $Title Then 
		$Over = GuiGetCursorInfo ( $MainOSHandle )
		If $Hide_Menu = 0 Then 
	
			If $Over[4] = $SMText7 Then
				GuiCtrlSetColor ( $SMText7, $vHText )
			Else
				GuiCtrlSetColor ( $SMText7, $vText )
			EndIf
			
			If $Over[4] = $SMText6 Then
				GuiCtrlSetColor ( $SMText6, $vHText )
			Else
				GuiCtrlSetColor ( $SMText6, $vText )
			EndIf
			
			If $Over[4] = $SMText5 Then
				GuiCtrlSetColor ( $SMText5, $vHText )
			Else
				GuiCtrlSetColor ( $SMText5, $vText )
			EndIf
				
			If $Over[4] = $SMText4 Then
				GuiCtrlSetColor ( $SMText4, $vHText )
			Else
				GuiCtrlSetColor ( $SMText4, $vText )
			EndIf
				
			If $Over[4] = $SMText3 Then
				GuiCtrlSetColor ( $SMText3, $vHText )
			Else
				GuiCtrlSetColor ( $SMText3, $vText )
			EndIf
				
			If $Over[4] = $SMText2 Then
				GuiCtrlSetColor ( $SMText2, $vHText )
			Else
				GuiCtrlSetColor ( $SMText2, $vText )
			EndIf
			
		EndIf
		
		
		If $Over[4] = $New Then 
			GuiCtrlSetColor ( $New, $vHText )
		Else
			GuiCtrlSetColor ( $New, $vText )
		EndIf
		If $Over[4] = $Delete Then 
			GuiCtrlSetColor ( $Delete, $vHText )
		Else
			GuiCtrlSetColor ( $Delete, $vText )
		EndIf
		If $Over[4] = $Tools Then 
			GuiCtrlSetColor ( $Tools, $vHText )
		Else
			GuiCtrlSetColor ( $Tools, $vText )
		EndIf
		If $Over[4] = $ACTSnow Then 
			GuiCtrlSetColor ( $ACTSnow, $vHText )
		Else
			GuiCtrlSetColor ( $ACTSnow, $vText )
		EndIf
		
		
		
	EndIf
EndFunc
