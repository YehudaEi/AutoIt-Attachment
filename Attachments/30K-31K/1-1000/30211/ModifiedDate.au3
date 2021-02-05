#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
#include <Array.au3>

Opt('MustDeclareVars', 1)

;~ Global $hListView, $hListView2
Local $arevafolder
Local $browsefolder
Local $gobutton
Local $inputbox
Local $FilesInAreva=""
Local $arrsize=1000
Local $1000
Local $10000
Local $25000
Local $50000
Local $group
Local $main
_Example1()

Func _Example1()
	Local $helpmenu,$helpmenuAbout,$helpmenuHelp
	Local $contextMenu,$contextMenuAbout,$contextMenuHelp
	TraySetIcon("Shell32.dll",44)
	$main=GUICreate("DateModified", 400, 120)
	GuiSetIcon(@SystemDir & "\syncapp.exe", 0)
	$browsefolder=GUICtrlCreateButton("&BrowseFolder", 10, 6, 70, 20)
	$gobutton=GUICtrlCreateButton("Go", 250, 50, 70, 20)
	; INPUT
	$inputbox=GuiCtrlCreateInput("", 100, 6, 250, 20)

	GuiCtrlCreateGroup("Select Array Size", 10, 30,200,60)
	$1000=GuiCtrlCreateRadio("1000", 20, 45, 80)	
	$10000=GuiCtrlCreateRadio("10000", 20, 65, 80)
	GuiCtrlSetState(-1, $GUI_CHECKED)
	$25000=GuiCtrlCreateRadio("25000", 100, 45, 80)
	$50000=GuiCtrlCreateRadio("50000", 100, 65, 80)	
	GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
	
	$helpmenu = GUICtrlCreateMenu("Help")
	$helpmenuHelp = GUICtrlCreateMenuItem("&Help Topics", $helpmenu)
	GuiCtrlCreateMenuItem("", $helpmenu) ;separator
	$helpmenuAbout = GUICtrlCreateMenuItem("&About IniViewer", $helpmenu)
	
	$contextMenu = GuiCtrlCreateContextMenu()
	$contextMenuAbout=GuiCtrlCreateMenuItem("&About", $contextMenu)
	GuiCtrlCreateMenuItem("", $contextMenu) ;separator
	$contextMenuHelp=GuiCtrlCreateMenuItem("&Help", $contextMenu)
	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $browsefolder
				$arevafolder = FileSelectFolder("Choose folder.", "")				
				$FilesInAreva=_FileListToArray($arevafolder)
				If @Error=4 or @Error =1 Then
					$arevafolder=""
					$FilesInAreva=""
					MsgBox(0,"","Select a proper folder")
				Else
					GUICtrlSetData($inputbox, $arevafolder)
					GUISetState()
				EndIf		
			Case $gobutton
				If GUICtrlRead ( $inputbox ) ="" Then
					MsgBox(0,"","Select a proper folder")
				Else
					$arevafolder=GUICtrlRead ( $inputbox )
					If GUICtrlRead ( $1000 ) =1 Then
						$arrsize=1000
					ElseIf GUICtrlRead ( $10000 ) =1 Then
						$arrsize=10000
					ElseIf GUICtrlRead ( $25000 ) =1 Then
						$arrsize=25000
					ElseIf GUICtrlRead ( $50000 ) =1 Then
						$arrsize=50000
					Else
						$arrsize=1000
					EndIf			
					GUICtrlSetState ( $browsefolder, $GUI_DISABLE )
					GUICtrlSetState ( $gobutton, $GUI_DISABLE )
					GUISetCursor ( 15 ,1,$main)								
					Update()
					GUICtrlSetState ( $browsefolder, $GUI_ENABLE)	
					GUICtrlSetState ( $gobutton, $GUI_ENABLE )
					GUISetCursor ( 2 ,1,$main)	
				EndIf
			Case $contextMenuAbout
				MsgBox(64,"About","-Why this tool?" _
				& @LF & "This tool can be used to check the last modified date in a Folder." _
				& @LF & "-Contact sojy dot john at gmail dot com for any feature addition required for the tool.")
			Case $helpmenuAbout
				MsgBox(64,"About","-Why this tool?" _
				& @LF & "This tool can be used to check the last modified date in a Folder." _
				& @LF & "-Contact sojy dot john at gmail dot com for any feature addition required for the tool.")
			Case $contextMenuHelp
				MsgBox(64,"Help","1. Select the folder using BrowseFolder button." _
				& @LF & "2. The selected folder will be displayed in input box." _
				& @LF & "3. Also you can directly give the path in input box and Press Go." _
				& @LF & "4. Last 30 Folders with date modified will be displayed in list." _
				& @LF & "5. Increment the array if asked.")	
			Case $helpmenuHelp
				MsgBox(64,"Help","1. Select the folder using BrowseFolder button." _
				& @LF & "2. The selected folder will be displayed in input box." _
				& @LF & "3. Also you can directly give the path in input box and Press Go." _
				& @LF & "4. Last 30 Folders with date modified will be displayed in list." _
				& @LF & "5. Increment the array if asked.")	
		EndSwitch
	WEnd
	GUIDelete()
EndFunc   ;==>_Example1

Func Update()	
	Local $FilesInSub1=""
	Local $FilesInSub2=""
	Local $FilesInSub3=""
	Local $FilesInSub4=""
	Local $FilesInSub5=""
	Local $int_i=0
	Local $int_j=0
	Local $int_k=0
	Local $int_l=0
	Local $int_m=0
	Local $int_n=0
	Local $int_arr=0
	Local $avArray[$arrsize][2]
	Local $t 
	Local $incarr=0

	$FilesInAreva=_FileListToArray($arevafolder)		
	If @Error=4 or @Error =1 Then
	Else
		For $int_i=1 To $FilesInAreva[0]
			If	$incarr=1 Then
					ExitLoop
			EndIf				
			$t =  FileGetTime($arevafolder& "\" & $FilesInAreva[$int_i], 1)
			If @error = 1 Then
			Else
				If $int_arr < $arrsize Then					
					$avArray[$int_arr][0] = $FilesInAreva[$int_i]
					$avArray[$int_arr][1] = $t[0] & "/" & $t[1] & "/" & $t[2]
					$int_arr=$int_arr+1					
				Else
					$incarr=1
					MsgBox(0,"","Increment Array Size")
					ExitLoop
				EndIf				
			EndIf				
			$FilesInSub1=_FileListToArray($arevafolder& "\" & $FilesInAreva[$int_i])
			If @Error=4 or @Error =1  Then
			Else
				For $int_j=1 To $FilesInSub1[0]
					If	$incarr=1 Then
						ExitLoop
					EndIf	
					$t =  FileGetTime($arevafolder& "\" & $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j], 1)
						If @error = 1 Then
						Else
							If $int_arr < $arrsize Then	
								$avArray[$int_arr][0] = $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j]
								$avArray[$int_arr][1] = $t[0] & "/" & $t[1] & "/" & $t[2]
								$int_arr=$int_arr+1
							Else
								$incarr=1
								MsgBox(0,"","Increment Array Size")
								ExitLoop								
							EndIf
						EndIf

					$FilesInSub2=_FileListToArray($arevafolder& "\" & $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j])
					If  @Error=4 or @Error =1 Then
					Else
						For $int_k=1 To $FilesInSub2[0]
							If	$incarr=1 Then
									ExitLoop
							EndIf	
							$t =  FileGetTime($arevafolder& "\" & $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j] & "\" & $FilesInSub2[$int_k], 1)
								If @error = 1 Then
								Else
									If $int_arr < $arrsize Then	
										$avArray[$int_arr][0] = $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j] & "\" & $FilesInSub2[$int_k]
										$avArray[$int_arr][1] = $t[0] & "/" & $t[1] & "/" & $t[2]
										$int_arr=$int_arr+1
									Else
										$incarr=1
										MsgBox(0,"","Increment Array Size")
										ExitLoop
									EndIf
								EndIf
							$FilesInSub3=_FileListToArray($arevafolder& "\" & $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j] & "\" & $FilesInSub2[$int_k])
							If  @Error=4 or @Error =1 Then
							Else
								For $int_l=1 To $FilesInSub3[0]
									If	$incarr=1 Then
											ExitLoop
									EndIf	
									$t =  FileGetTime($arevafolder& "\" & $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j] & "\" & $FilesInSub2[$int_k]& "\" & $FilesInSub3[$int_l], 1)
										If @error = 1 Then
										Else
											If $int_arr < $arrsize Then	
												$avArray[$int_arr][0] = $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j] & "\" & $FilesInSub2[$int_k]& "\" & $FilesInSub3[$int_l]
												$avArray[$int_arr][1] = $t[0] & "/" & $t[1] & "/" & $t[2]
												$int_arr=$int_arr+1
											Else
												$incarr=1
												MsgBox(0,"","Increment Array Size")
												ExitLoop
											EndIf
										EndIf
									$FilesInSub4=_FileListToArray($arevafolder& "\" & $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j] & "\" & $FilesInSub2[$int_k] & "\" & $FilesInSub3[$int_l])
									If  @Error=4 or @Error =1 Then
									Else
										For $int_m=1 To $FilesInSub4[0]
											If	$incarr=1 Then
													ExitLoop
											EndIf	
											$t =  FileGetTime($arevafolder& "\" & $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j] & "\" & $FilesInSub2[$int_k]& "\" & $FilesInSub3[$int_l]& "\" & $FilesInSub4[$int_m], 1)
												If @error = 1 Then
												Else
													If $int_arr < $arrsize Then	
														$avArray[$int_arr][0] = $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j] & "\" & $FilesInSub2[$int_k]& "\" & $FilesInSub3[$int_l] & "\" & $FilesInSub4[$int_m]
														$avArray[$int_arr][1] = $t[0] & "/" & $t[1] & "/" & $t[2]
														$int_arr=$int_arr+1
													Else
														$incarr=1
														MsgBox(0,"","Increment Array Size")
														ExitLoop													
													EndIf
												EndIf
											$FilesInSub5=_FileListToArray($arevafolder& "\" & $FilesInAreva[$int_i] & "\" & $FilesInSub1[$int_j] & "\" & $FilesInSub2[$int_k] & "\" & $FilesInSub3[$int_l]& "\" & $FilesInSub4[$int_m])
											If  @Error=4 or @Error =1 Then
											Else
												For $int_n=1 To $FilesInSub5[0]
;~ 														GUICtrlCreateTreeViewItem($FilesInSub5[$int_m], $ArevaSub5)
												Next	
											EndIf
										Next	
									EndIf									
								Next	
							EndIf
						Next						
					EndIf
				Next				
			EndIf
		Next		
	EndIf	
	GUISetState()
	If	$incarr=1 Then
	Else
		_ArraySort($avArray, 1, 0, 0, 1)
		_ArrayDisplay($avArray, "DateModified",30)
	EndIf		
EndFunc   ;==>Example