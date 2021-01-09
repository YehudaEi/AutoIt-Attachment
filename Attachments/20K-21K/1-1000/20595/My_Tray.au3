#NoTrayIcon
#Region ;**** 参数创建于 AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=taskbar.ico
#AutoIt3Wrapper_outfile=My_Tray.exe
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <File.au3>
#Include <Array.au3>
#Include <Constants.au3>


;托盘使用变量
Global $PathList[10]
Dim $lookupitem, $aboutitem, $exititem, $msg, $menu[10][10], $firstmenu[10], $PathList[10]
Dim $h, $s, $x, $relocation, $folder, $i, $sign, $FileList









;###############检查重复进程##################
$var = ProcessList("My_Tray.exe")
If $var[0][0] > 1 Then
	MsgBox(0, "Already Run", "The software already run, Check the TaskTray")
	Exit
EndIf







main()


While 1

	$msg = TrayGetMsg()

	
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $relocation
			relocation()
			
			main()
			
		Case $msg = $exititem
			Exit
			

			
		Case Else
			For $i = 0 To $h - 1
				For $n = 0 To $s - 1

					If $msg = $menu[$i][$n] Then
						
						TraySetState(2)
						RunWait($folder & "\" & $PathList[$i] & TrayItemGetText($msg))
						TraySetState()
					EndIf
					
				Next
				
			Next

	EndSelect

WEnd





Func main()
	



	$sign = 0
	While $sign = 0 ;文件夹有效性********************************
		
		If RegRead("HKEY_CURRENT_USER\SOFTWARE\My_Tray", "Default") = "" Or Not FileExists(RegRead("HKEY_CURRENT_USER\SOFTWARE\My_Tray", "Default")) Then
			
			$folder = FileSelectFolder("Please select a folder with EXE File", "")
			RegWrite("HKEY_CURRENT_USER\SOFTWARE\My_Tray", "Default", "REG_SZ", $folder)
			
			
		Else

			$folder = RegRead("HKEY_CURRENT_USER\SOFTWARE\My_Tray", "Default")

		EndIf



		$FileList = _FileListToArray($folder, "*.exe")
		If IsArray($FileList) = 1 Then
			$sign = 1
			ExitLoop
		EndIf

		$PathList = _FileListToArray($folder, "*.")
		If IsArray($PathList) = 0 Then
			
			MsgBox(1, "no folders", "")
			$folder = FileSelectFolder("Please select a folder with EXE File", "")
			RegWrite("HKEY_CURRENT_USER\SOFTWARE\My_Tray", "Default", "REG_SZ", $folder)
			ContinueLoop
		EndIf


		For $i = 1 To $PathList[0]
			
			$FileList = _FileListToArray($folder & "\" & $PathList[$i] & "\", "*.exe")
			If IsArray($FileList) = 1 Then
				$sign = 1
				ExitLoop
			EndIf

		Next



		If $sign = 0 Then
			
			$folder = FileSelectFolder("Please select a folder with EXE File", "")
			RegWrite("HKEY_CURRENT_USER\SOFTWARE\My_Tray", "Default", "REG_SZ", $folder)
		EndIf

	WEnd
	;文件夹有效性********************************


	
	


	;*********重新××义数组××××××

	$PathList = _FileListToArray($folder, "*.")

	If IsArray($PathList) = 0 Then


		Dim $PathList[10]
		$PathList[0] = 0
		
	EndIf



	$n = 0

	$FileList = _FileListToArray($folder, "*.exe")
	If IsArray($FileList) = 0 Then


		$n = 0
		
	Else
		$n = $FileList[0]
	EndIf



	If $PathList[0] > 0 Then
		For $i = 1 To $PathList[0]
			
			If $i > $PathList[0] Then ExitLoop
			$FileList = _FileListToArray($folder & "\" & $PathList[$i] & "\", "*.exe")
			If IsArray($FileList) = 0 Then

				_ArrayDelete($PathList, $i)
				$PathList[0] = $PathList[0] - 1
				$i = $i - 1
				

				ContinueLoop
				
			EndIf

			If $FileList[0] > $n Then $n = $FileList[0]


		Next
	EndIf



	ReDim $menu[$PathList[0] + 1][$n]

	ReDim $firstmenu[ $PathList[0] + 1]


	$h = $PathList[0] + 1
	$s = $n

	For $i = 1 To $PathList[0]
		$PathList[$i] = $PathList[$i] & "\" 
	Next
	$PathList[0] = ""

	Opt("TrayMenuMode", 1)    ; 默认菜单项目 (脚本暂停/退出) will not be shown.


	;最外层目录

	$FileList = _FileListToArray($folder, "*.exe")


	If IsArray($FileList) = 1 Then
		
		For $i = 1 To $FileList[0]
			
			$menu[0][$i - 1] = TrayCreateItem($FileList[$i])
			
		Next



		TrayCreateItem("")
	EndIf



	For $i = 1 To UBound($firstmenu) - 1
		
		
		
		
		$firstmenu[$i] = TrayCreateMenu($PathList[$i])
		
		
		
		$FileList = _FileListToArray($folder & "\" & $PathList[$i] & "\", "*.exe")
		
		

		For $x = 1 To $FileList[0]
			
			
			
			
			$menu[$i][$x - 1] = TrayCreateItem($FileList[$x], $firstmenu[$i])
			
			
			
		Next

		
		
		TrayCreateItem("")
		
	Next


	$relocation = TrayCreateItem("Change Folder")

	TrayCreateItem("")

	$exititem = TrayCreateItem("Exit")

	TraySetState()


EndFunc   ;==>main




Func relocation()
	
	TraySetState(2)
	$folder = FileSelectFolder("Directory", "")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\My_Tray", "Default", "REG_SZ", $folder)
	
	
	For $i = 0 To $h - 1
		TrayItemDelete($firstmenu[$i])
		For $n = 0 To $s - 1

			
			
			TrayItemDelete($menu[$i][$n])
			
			
			
		Next
		
	Next
	
	TrayItemDelete($exititem)
	TrayItemDelete($relocation)
	TraySetState()
EndFunc   ;==>relocation
