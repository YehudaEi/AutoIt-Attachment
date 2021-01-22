;   <Deskpic.exe>
;   Desktop Background Changer v1.0
;   by JonnyThunder (26th March, 2008)




; Get some includes
#include <Misc.au3>
#Include <Constants.au3>
#include <GuiConstantsEx.au3>
#include <Array.au3>
#include <GuiListView.au3>
#include <GDIPlus.au3>
#NoTrayIcon





; EDIT ME!!  -  Put in your path to your JPG files here
$path_to_pictures = @WindowsDir & "\Backgrounds"




; This is the name and path to the INI file which stores the current users settings. It is best left in the User Profile Directory
$path_to_config   = @UserProfileDir & "\Application Data\DTBG\config.ini"




; This is the name and path of the BMP image file which will be used for the actual background when the JPG is converted
$path_to_BMP      = @UserProfileDir & "\Application Data\DTBG\dtbg.bmp"




; These are default settings for the INI file
$default_type     = "random"
$default_pic      = "0"
$default_colour   = "0"





; Setup colour choices
Dim $totalcolours = 10
Global $colourname[$totalcolours], $colourval[$totalcolours], $colourhex[$totalcolours], $colour_menu_handle[$totalcolours]
$colourname[0] = "Black"
$colourval[0]  = "0 0 0"
$colourname[1] = "White"
$colourval[1]  = "255 255 255"
$colourname[2] = "Light Green"
$colourval[2]  = "176 255 163"
$colourname[3] = "Dark Green"
$colourval[3]  = "38 127 0"
$colourname[4] = "Light Blue"
$colourval[4]  = "170 199 255"
$colourname[5] = "Dark Blue"
$colourval[5]  = "38 136 244"
$colourname[6] = "Light Orange"
$colourval[6]  = "255 177 33"
$colourname[7] = "Dark Orange"
$colourval[7]  = "196 86 23"
$colourname[8] = "Light Pink"
$colourval[8]  = "255 178 252"
$colourname[9] = "Dark Purple"
$colourval[9]  = "132 35 142"




; Set tray text
TraySetState()
TraySetToolTip("Desktop Background Tool")




; Generate hex values for later
for $i = 0 to ubound($colourname)-1
	$carr = stringsplit($colourval[$i], " ")
	$colourhex[$i] = "0x" & hex($carr[3],2) & hex($carr[2],2) & hex($carr[1],2)
Next





; Check if there is a settings file (and create default)
if not fileexists ( $path_to_config ) Then
	$config = FileOpen ( $path_to_config, 10 )
	FileClose ( $path_to_config )
	IniWriteSection ( $path_to_config, "DTBG", "Type=" & $default_type & @LF & "Pic=" & $default_pic & @LF & "Colour=" & $default_colour )
EndIf




; Read current values
$current_type   = IniRead ( $path_to_config, "DTBG", "Type",   $default_type )
$current_pic    = IniRead ( $path_to_config, "DTBG", "Pic",    $default_pic )
$current_colour = IniRead ( $path_to_config, "DTBG", "Colour", $default_colour )




; Read in the picture names first
Global $pic_file_names[1], $pic_menu_handle[1]




; Attempt searching for JPG files
$search = FileFindFirstFile($path_to_pictures & "\*.jpg")
If $search = -1 Then
	msgbox (64, "error", "No pic files")
    Exit
EndIf
While 1
    $file = FileFindNextFile($search) 
    If @error Then ExitLoop
    _ArrayAdd ( $pic_file_names, $file )
	_ArrayAdd ( $pic_menu_handle, "" )
WEnd
FileClose($search)
_ArrayDelete ( $pic_file_names, 0 )
_ArrayDelete ( $pic_menu_handle, 0 )




; Default tray menu items
Opt("TrayMenuMode",1)   




; Display the menu
$rotationmenu = ""
$menu_update = True
$bg_update = True
While 1

	; If we have to update the background
	If $bg_update = true Then
		$bg_update = False
		If $current_type = "colour" Then
			; Change to colour and set wallpaper blank
			_ChangeWallpaper("")
			_ChangeColour($colourval[$current_colour], $colourhex[$current_colour])
		Else
			; For random selection
			if $current_type = "random" Then
				$rnum = $current_pic
				while $rnum = $current_pic
					$current_pic = random (0, (ubound($pic_file_names)-1), 1)
				WEnd
				IniWrite ( $path_to_config, "DTBG", "Pic", $current_pic )
				$menu_update = True
			EndIf
			; For forward selection
			if $current_type = "forward" Then
				$current_pic = $current_pic + 1
				if $current_pic > (ubound($pic_file_names)-1) Then
					$current_pic = 0
				EndIf
				IniWrite ( $path_to_config, "DTBG", "Pic", $current_pic )
				$menu_update = True
			EndIf
			; For reverse selection
			if $current_type = "reverse" Then
				$current_pic = $current_pic - 1
				if $current_pic < 0 Then
					$current_pic = (ubound($pic_file_names)-1)
				EndIf
				IniWrite ( $path_to_config, "DTBG", "Pic", $current_pic )
				$menu_update = True
			EndIf
			; Change to wallpaper and default background to black
			_Convert2BMP ($path_to_pictures & "\" & $pic_file_names[$current_pic], $path_to_BMP)
			_ChangeWallpaper($path_to_BMP)
			_ChangeColour($colourval[0], $colourhex[0])
		EndIf
	EndIf



	; Update the menu if required
	if $menu_update = true Then
		if $rotationmenu <> "" Then
			TrayItemDelete($sysinfo)
			TrayItemDelete($div1)
			TrayItemDelete($rotationmenu)
			TrayItemDelete($fixedpicture)
			TrayItemDelete($fixedcolour)
			TrayItemDelete($div2)
			TrayItemDelete($exititem)
		EndIf
		$menu_update = False
		$sysinfo         = TrayCreateItem("System Information")
		$div1            = TrayCreateItem("")
		$rotationmenu    = TrayCreateMenu("Background")
		$force_change    =     TrayCreateItem("Force change now", $rotationmenu)
		$type_fixedpic   =     TrayCreateItem("Use Fixed Picture", $rotationmenu)
		$type_fixedcol   =     TrayCreateItem("Use Fixed Colour", $rotationmenu)
		$type_random     =     TrayCreateItem("Use Random Picture", $rotationmenu)
		$type_forward    =     TrayCreateItem("Use Rotation (Forward)", $rotationmenu)
		$type_reverse    =     TrayCreateitem("Use Rotation (Reverse)", $rotationmenu)
		$fixedpicture    = TrayCreateMenu("Background Picture")
		for $x = 0 to UBound($pic_file_names)-1
			$pic_menu_handle[$x] = TrayCreateItem(StringTrimRight($pic_file_names[$x],4), $fixedpicture)
			if $current_pic = $x and $current_type <> "colour" Then
				TrayItemSetState($pic_menu_handle[$x], $TRAY_DEFAULT)
			EndIf
		Next
		$fixedcolour     = TrayCreateMenu("Background Colour")
		for $x = 0 to UBound($colourname)-1
			$colour_menu_handle[$x] = TrayCreateItem($colourname[$x], $fixedcolour)
			if $current_colour = $x and $current_type = "colour" Then
				TrayItemSetState($colour_menu_handle[$x], $TRAY_DEFAULT)
			EndIf
		Next
		$div2            = TrayCreateItem("")
		$exititem        = TrayCreateItem("Exit")
		;TrayItemSetState( $exititem, $TRAY_DISABLE )
		TraySetState()
		; highlight selected
		TrayItemSetState($sysinfo, $TRAY_DEFAULT)
		if $current_type = "fixed"   Then TrayItemSetState($type_fixedpic, $TRAY_DEFAULT)
		if $current_type = "colour"  Then TrayItemSetState($type_fixedcol, $TRAY_DEFAULT)
		if $current_type = "random"  Then TrayItemSetState($type_random,   $TRAY_DEFAULT)
		if $current_type = "forward" Then TrayItemSetState($type_forward,  $TRAY_DEFAULT)
		if $current_type = "reverse" Then TrayItemSetState($type_reverse,  $TRAY_DEFAULT)
	EndIf



	; Check inputs
	$msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop

		Case $msg = $sysinfo
			$infowindow = GuiCreate(" System Information", 450, 370)
			$listView = GuiCtrlCreateListView("Property|Value|", 10, 10, 430, 350)
			GuiCtrlCreateListViewItem("Computer Name|" & @ComputerName, $listView)
			GuiCtrlCreateListViewItem("IP Address 1|" & @IPAddress1, $listView)
			GuiCtrlCreateListViewItem("IP Address 2|" & @IPAddress2, $listView)
			GuiCtrlCreateListViewItem("IP Address 3|" & @IPAddress3, $listView)
			GuiCtrlCreateListViewItem("IP Address 4|" & @IPAddress4, $listView)
			GuiCtrlCreateListViewItem("User Login Name|" & @UserName, $listView)
			GuiCtrlCreateListViewItem("Desktop Dimensions|" & @DesktopWidth & " x " & @DesktopHeight, $listView)
			GuiCtrlCreateListViewItem("Logon Domain|" & @LogonDomain, $listView)
			GuiCtrlCreateListViewItem("Logon Server|" & @LogonServer, $listView)
			GuiCtrlCreateListViewItem("Operating System|" & @OSVersion, $listView)
			GuiCtrlCreateListViewItem("Proc. Architecture|" & @ProcessorArch, $listView)
			GuiCtrlCreateListViewItem("Windows Dir|" & @WindowsDir, $listView)
			GuiCtrlCreateListViewItem("System Dir|" & @SystemDir, $listView)
			GuiCtrlCreateListViewItem("Program Files Dir.|" & @ProgramFilesDir, $listView)
			GuiCtrlCreateListViewItem("User Profile Dir|" & @UserProfileDir, $listView)
			GuiCtrlCreateListViewItem("Temp Dir|" & @TempDir, $listView)
			$mem = MemGetStats()
			GuiCtrlCreateListViewItem("Total Phys. Memory|" & _Format_Bytes($mem[1]) & " mb", $listView)
			GuiCtrlCreateListViewItem("Avail Phys. Memory|" & _Format_Bytes($mem[2]) & " mb", $listView)
			GuiCtrlCreateListViewItem("Pagefile Size|" & _Format_Bytes($mem[3]) & " mb", $listView)
			GuiCtrlCreateListViewItem("Virtual Avail. Memory|" & _Format_Bytes($mem[5]) & " mb", $listView)
			_GUICtrlListView_SetColumnWidth ($listView, 0, 150)
			_GUICtrlListView_SetColumnWidth ($listView, 1, 250)
			GuiSetState()
			While 1
				$msg = GuiGetMsg()
				if $msg = $GUI_EVENT_CLOSE then ExitLoop
			WEnd
			GUIDelete ($infowindow)



		Case $msg = $force_change
			$bg_update = True
			
			

		Case $msg = $type_fixedpic
			$current_type = "fixed"
			IniWrite ( $path_to_config, "DTBG", "Type", $current_type )
			$menu_update = True
			$bg_update = True


		Case $msg = $type_fixedcol
			$current_type = "colour"
			IniWrite ( $path_to_config, "DTBG", "Type", $current_type )
			$menu_update = True
			$bg_update = True


		Case $msg = $type_random
			$current_type = "random" 
			IniWrite ( $path_to_config, "DTBG", "Type", $current_type )
			$menu_update = True
			$bg_update = True


		Case $msg = $type_forward
			$current_type = "forward"
			IniWrite ( $path_to_config, "DTBG", "Type", $current_type )
			$menu_update = True
			$bg_update = True


		Case $msg = $type_reverse
			$current_type = "reverse"
			IniWrite ( $path_to_config, "DTBG", "Type", $current_type )
			$menu_update = True
			$bg_update = True


        Case $msg = $exititem
            ExitLoop
			

		EndSelect
		
		; Also check pic selections and colour selections
		for $x = 0 to ubound($pic_menu_handle)-1
			if $msg = $pic_menu_handle[$x] Then
				$current_pic = $x
				$current_type = "fixed"
				IniWrite ( $path_to_config, "DTBG", "Pic", $current_pic )
				IniWrite ( $path_to_config, "DTBG", "Type", $current_type )
				$menu_update = True
				$bg_update = True
			EndIf
		Next
		
		; Also check colour selection
		for $x = 0 to ubound($colour_menu_handle)-1
			if $msg = $colour_menu_handle[$x] Then
				$current_colour = $x
				$current_type = "colour"
				IniWrite ( $path_to_config, "DTBG", "Colour", $current_colour )
				IniWrite ( $path_to_config, "DTBG", "Type", $current_type )
				$menu_update = True
				$bg_update = True
			EndIf
		Next

	WEnd

Exit



Func _Format_Bytes($input)
	return round(($input / 1024),0)
EndFunc



Func _ChangeWallpaper($picpath)
    RegWrite('HKCU\Control Panel\Desktop', 'TileWallpaper', 'reg_sz', '0')
    RegWrite('HKCU\Control Panel\Desktop', 'WallpaperStyle', 'reg_sz', '2')
    RegWrite('HKCU\Control Panel\Desktop', 'Wallpaper', 'reg_sz', $picpath)
    RegWrite('HKU\.DEFAULT\Control Panel\Desktop', 'TileWallpaper', 'reg_sz', '0')
    RegWrite('HKU\.DEFAULT\Control Panel\Desktop', 'WallpaperStyle', 'reg_sz', '2')
	RegWrite('HKU\.DEFAULT\Control Panel\Desktop', 'Wallpaper', 'reg_sz', $picpath)
    DllCall("user32", "int", "SystemParametersInfo", "int", 20, "int", 0, "str", $picpath, "int", 0)
EndFunc



Func _Convert2BMP ($inputfile, $outputfile, $overwrite=true)
	_GDIPlus_StartUp()
	$imh = _GDIPlus_ImageLoadFromFile($inputfile)
	$clsid = _GDIPlus_EncodersGetCLSID("BMP")
	_GDIPlus_ImageSaveToFileEx($imh, $outputfile, $clsid)
	_GDIPlus_ShutDown()
EndFunc



Func _ChangeColour($colourvalue, $colourh)
    RegWrite('HKU\.DEFAULT\Control Panel\Colors', 'Background', 'reg_sz', $colourvalue)
	RegWrite('HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon', 'Background', 'reg_sz', $colourvalue)
	DllCall("user32","int","SetSysColors","int",1,"int*",1,"int*",$colourh)
EndFunc



