;	IconMap.AU3
;
;INTRODUCTION
;
;	IconMap saves and restores the desktop icon layout using ini-format *.ICN files.
;
;	Using IconMap you can update your desktop icon mappings at any time, or restore any 
;	saved layout at any time. Or you can create as many mappings as you like,
;	such as for different screen resolutions, or different users.  You can even
;	copy your desktop layout from one machine to another.
;
;OPERATION
;
;	0.	Compile and copy IconMap.EXE to "C:\Program Files\IconMaps\IconMap.exe"
;		.. or change the code for the "/INSTALL" switch below to reflect your chosen path.
;
;	1.	Run the EXE with no commandline parameters to activate an option that
;		installs shell context menu options for when *.ICN files are rightclicked in
;		Windows File Explorer.
;
;	2.	In any folder (even directly on the desktop itself), create a "New Text Document" 
;		with with a right-click option, and give it a meaningful name with an *.ICN extension.
;		For example: "1280 x 1024 (trids).icn" or "my_mappings.icn", etc.
;
;	3.	When you right-click the *.ICN file, and select the option
;		[S&ave IconMap layout], the positions of the icons on the desktop are recorded
;		into that *.ICN file.
;
;	4.	Select the right-click option [R&estore IconMap layout] to re-arrange the icons
;		according to previously saved mapping coordinates in the *.ICN file.
;


#INCLUDE "C:\Program Files\AutoIt3\Include\A3LListView.au3"

;Get runtime instructions
	If @COMPILED Then
		Switch $CmdLine[0]
			Case 0
				$sMode = "/INSTALL"
			Case 2
				$sMode = ( $CmdLine[1] )		;/SAVE or /RESTORE	
				$sINI = $CmdLine[2]		;the *.ICN filename to use as ini file
			Case Else
				MsgBox( 4096 + 48, @SCRIPTNAME, "Error - Commandline Usage:" & @LF & @LF & 'IconMap.exe /save "<.icn filename>"' & @LF & 'IconMap.exe /restore "<.icn filename>"' )
		EndSwitch
	Else
		;Designtime testing ;o)
		$sMode = "/RESTORE"
		$sINI = "D:\AU3_Functions\Trids\IconMap\Settings_1.icn"
	Endif

;Get a handle on the desktop, which is actually a listview control.
	$hWnd_LV = ControlGetHandle( "Program Manager", "", "SysListView321" )

;Save or Restore?
	Switch StringUpper( $sMode )
		Case "/SAVE"
			;Drop all previous icon positions
			IniDelete(  $sINI, "Icons" )
			;Walk the listview items, saving their positions to the INI file.
			For $nIdx = 0 to _ListView_GetItemCount( $hWnd_LV ) - 1
				$sIconText = _ListView_GetItemText( $hWnd_LV, $nIdx ) 
				$aPos = _ListView_GetItemPosition( $hWnd_LV, $nIdx )
				IniWrite( $sINI, "Icons", $sIconText, $aPos[0] & ";" & $aPos[1] )
			Next
			Beep( 1500, 100 )
			Beep( 1000, 100 )
			Beep( 500, 100 )
		
		Case "/RESTORE"
			;Walk the listview items, applying their positions from the INI file.
			For $nIdx = 0 to _ListView_GetItemCount( $hWnd_LV ) - 1
				$sIconText = _ListView_GetItemText( $hWnd_LV, $nIdx ) 
				$aPos = StringSplit( IniRead( $sINI, "Icons", $sIconText, "0;0" ), ";" )
				if $aPos[0] <> 2 Then
					MsgBox( 0, @SCRIPTNAME, "Error - invalid coordinates for icon:" & @LF & @LF & $sIconText )
					Exit
				Endif
				_ListView_SetItemPosition( $hWnd_LV, $nIdx, $aPos[1], $aPos[2] )
			Next
			Beep( 500, 100 )
			Beep( 1000, 100 )
			Beep( 1500, 100 )
		
		Case "/INSTALL"		
			;setup a context menu for the command shell
			If MsgBox( 4096 + 4 + 32, @SCRIPTNAME, "Configure shell options for Right-clicking on *.ICN map files?" ) = 6 Then ;6=Yes
				;Prep Registry entries to handle ".icn" files
				RegWrite( "HKCR\.icn", "", "REG_SZ", "IconMaps" ) 
				RegWrite( "HKCR\IconMaps", "", "REG_SZ", "Desktop Icon Positions" ) 
				RegWrite( "HKCR\IconMaps\Shell", "", "REG_SZ", "1_save" ) 
				RegWrite( "HKCR\IconMaps\Shell\1_save", "", "REG_SZ", "S&ave IconMap layout" ) 
				RegWrite( "HKCR\IconMaps\Shell\1_save\command", "", "REG_SZ", '"C:\Program Files\IconMaps\IconMap.exe" /save "%1"' ) 
				RegWrite( "HKCR\IconMaps\Shell\2_restore", "", "REG_SZ", "R&estore IconMap layout" ) 
				RegWrite( "HKCR\IconMaps\Shell\2_restore\command", "", "REG_SZ", '"C:\Program Files\IconMaps\IconMap.exe" /restore "%1"' ) 
			Endif
		Case Else
			MsgBox( 4096 + 48, @SCRIPTNAME, "Error - Switch Usage:" & @LF & @LF & 'IconMap.exe /save "<.icn filename>"' & @LF & 'IconMap.exe /restore "<.icn filename>"' )

	EndSwitch
	
