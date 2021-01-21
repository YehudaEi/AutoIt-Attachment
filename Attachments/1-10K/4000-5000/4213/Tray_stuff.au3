#Include <GUIConstants.au3>
;#NoTrayIcon

Opt("TrayMenuMode",1) ; Default tray menu items (Script Paused/Exit) will not be shown.
$array_menu = IniReadSectionNames(@ScriptDir & "\menu.ini")
Dim $array_created_keys[99][99]
$h = 1

If @error Then 
	MsgBox(4096, "", "Error occured, probably no INI file.")
Else
	For $i = 1 To $array_menu[0]
		$array_created_menus = TrayCreateMenu($array_menu[$i])
		$array_keys = IniReadSection(@ScriptDir & "\menu.ini", $array_menu[$i])
		For $u = 1 To $array_keys[0][0]
			$array_created_keys[$i][$h] = TrayCreateItem($array_keys[$u][0] &" ",$array_created_menus)
			$h = $h +1
		Next
	$h = 1
	Next
EndIf
$Exit = TrayCreateItem("Exit")

While 1
Sleep(20)
	$msg = TrayGetMsg()
Select	
 	
	Case $msg = $Exit
 		Exit
		
	Case $msg = $array_created_keys[1][1]
		MsgBox(0,"Click","You clicked Menu 1 item 1")	
		
	Case $msg = $array_created_keys[1][2]
		MsgBox(0,"Click","You clicked Menu 1 Item 2")		
		
	Case $msg = $array_created_keys[2][1]
		MsgBox(0,"Click","You clicked Menu 2 item 1")	
		
	Case $msg = $array_created_keys[2][2]
		MsgBox(0,"Click","You clicked Menu 2 Item 2")	
		
	Case $msg = $array_created_keys[3][1]
		MsgBox(0,"Click","You clicked Menu 3 item 1")	
		
	Case $msg = $array_created_keys[3][2]
		MsgBox(0,"Click","You clicked Menu 3 Item 2")	

EndSelect	
WEnd