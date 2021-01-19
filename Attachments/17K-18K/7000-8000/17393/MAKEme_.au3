#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.8.1
	Author:         SAG
	
	Script Function:
	AutoIt GUI Make script.
	
	Aut2exe.exe /in <infile.au3> [/out <outfile.exe>] [/icon <iconfile.ico>] [/nodecompile] [/comp 0-4] [/pass <passphrase>] [/nopack] [/ansi] [/unicode]
	
	Version History
	1.0.0 -	Original work
		  - GUI - btns/up-dn/listview/radios/statusbar/menus/etc
		  - listview mgmt - add/remove/sort/mv up/mv dn/renumber/etc
		  - cmd strings for aut2exe and AutoIt3Wrapper
		  - compilation of checked rows
		  - mgmt of max # of simultaneous compiles
		  - menus - open/save/new/etc
		  - choose compiler options
		  - context menus - compiler options/clear compiler options
	1.0.1 - recent files menu - both Open & Save => credit to Holger from forums 
				- http://www.autoitscript.com/forum/index.php?s=&showtopic=3534&view=findpost&p=23123
		  - strip invalid compile options from AutoIt3Wrapper compile options string
		  - added context menu to edit file
		  - added saving of compiler selection with MAK file - first row
		    0 = Aut2Exe, 1 = AutoIt3Wrapper
		  - misc tweaks: statusbar, init folder in fileopendialog,
		  - added support for command line launch -> double click a MAK file to open it
		  - added Options menus to associate/disassociate MAK files with the MAKEme! application
	1.0.2 - highlight table row when moved up/down
		  - added context copy/paste
	1.1.0 - added support for simple compile of HelpScribble (hsc) file
			and Inno Setup Compiler (iss) file
		  - added Setup Option control of compiler locations, Recent file count, save to INI
		  - added save of Setup Options and Recent file history to INI file
	1.1.1 - added checks for existance of HelpScribble and Inno Setup compilers
		  - added Setup Option to clear Recent file history
		  - updated _MonitorCompiles and _LimitCompiles functions to monitor HelpScribble
			and Inno compilers in addition to AutoIt compiles
		  - saved compile limit to INI file
#ce ----------------------------------------------------------------------------

#region -> Compiler Directives

#AutoIt3Wrapper_Icon = C:\Program Files\AutoIt3\Aut2Exe\Icons\MAKEMe.ICO
#AutoIt3Wrapper_Compression = 4
#AutoIt3Wrapper_Allow_Decompile = y
#AutoIt3Wrapper_Res_Comment = Built using AutoIt3! http://www.autoitscript.com/autoit3		;Comment field
#AutoIt3Wrapper_Res_Fileversion=1.1.1.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement = y	;AutoIncrement FileVersion After Aut2EXE is finished.
#AutoIt3Wrapper_Res_Description = AutoIt Make Utility	;Description field
#AutoIt3Wrapper_Res_LegalCopyright = SAG | 2007				;Copyright information
#AutoIt3Wrapper_Res_Field = Platform|Win 2000/XP
#AutoIt3Wrapper_res_field = AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Run_AU3Check = y

#endregion <- Compiler Directives

#region -> Includes
#Include <GUIConstants.au3>
#Include <GuiListView.au3>
#Include <GuiStatusBar.au3>
#Include <String.au3>
#Include <ModernMenu.au3>
#include <Math.au3>

#endregion <- Includes

#region -> Declarations
Local $guiwidth = 750, $guiheight = 350
Local $a_PartsRightEdge[3] = [ 80, ($guiwidth - 200), -1]
Local $a_PartsText[3] = ["", "", ""]
Local $i = 0 ; number of files selected
Local $Unsaved = False ; are there changes to be saved?
Local $limitCompile = 2 ; maximum number of simultaneous compiles to be allowed
Local $n
Local $CompileOptions = ""

Local $count = 0
Local $lastindex = 0
Local $maxrecentfiles = 5 ; max 5 recent files
Local $Inimaxrecentfiles; 
Local $recentfiles[$maxrecentfiles][2]
Local $SaveToINI = True
Local $iniFileName = @ScriptDir & "\" & StringTrimRight(@ScriptName, 3) & "ini" ; define INI file 

Const $color = 0xE0FFFF

Local $Aut2exeFolder = "C:\program files\AutoIt3\Aut2Exe"
Local $AutoIt3WrapperFolder = "C:\Program Files\AutoIt3\SciTE\AutoIt3Wrapper"
Local $fileOpenTitle = "Select your file. Hold down Ctrl or Shift to choose multiple files."
Local $fileSaveMAKTitle = "Name or select your MAKE file."
Local $fileOpenMAKTitle = "Select your MAKE file."

Local $hscFolder = "C:\Program Files\JGsoft\HelpScribble"
Local $issFolder = "C:\Program Files\Inno Setup 5"

Local $HelpCompiler = True ; default - HelpScribble help compiler available
Local $InnoCompiler = True ; default - Inno Help Compiler available

#endregion <- Declarations

$myGUI = GUICreate("MAKE me!", $guiwidth, $guiheight, -1, @DesktopHeight / 2 - 235, $WS_overlappedwindow)

#region -> Menus
$FileMenu = GUICtrlCreateMenu('&File')
$NewItem = _GUICtrlCreateODMenuItem ('&New', $FileMenu, 'shell32.dll', 54)
$OpenItem = _GUICtrlCreateODMenuItem ('&Open', $FileMenu, 'shell32.dll', 4)
$SaveItem = _GUICtrlCreateODMenuItem ('&Save', $FileMenu, 'shell32.dll', 5)
$RecentMenu = GUICtrlCreateMenu('&Recent', $FileMenu)
$FileMenuSeparator = _GUICtrlCreateODMenuItem ("", $FileMenu)
$ExitItem = _GUICtrlCreateODMenuItem ('&Exit', $FileMenu, 'shell32.dll', 27)

$OptionsMenu = GUICtrlCreateMenu('&Options')
$AssociateMakFileItem = _GUICtrlCreateODMenuItem ('&Associate MAK file to MAKEme!', $OptionsMenu, 'shell32.dll', 99)
$RemoveAssociationItem = _GUICtrlCreateODMenuItem ('&Remove MAK file association', $OptionsMenu, 'shell32.dll', 65)
$FileMenuSeparator = _GUICtrlCreateODMenuItem ("", $OptionsMenu)
$SetupOptionsItem = _GUICtrlCreateODMenuItem ('&Setup Options', $OptionsMenu, 'shell32.dll', 21)

$HelpMenu = GUICtrlCreateMenu('&Help')
$AboutItem = _GUICtrlCreateODMenuItem ("&About", $HelpMenu, 'shell32.dll', 23)

#endregion <- Menus

#region -> load INI settings if file exists - if not, values were defaulted as declared variables
If FileExists($iniFileName) Then 
	$iniFile = FileOpen($iniFileName, 0)
	If $iniFile <> -1 Then
		$Aut2exeFolder = IniRead($iniFileName, "FileLocations", "Aut2Exe", $Aut2exeFolder)
		$AutoIt3WrapperFolder = IniRead($iniFileName, "FileLocations", "AutoIt3Wrapper", $AutoIt3WrapperFolder) 
		$hscFolder = IniRead($iniFileName, "FileLocations", "HelpScribble", $hscFolder) ; location of HelpScribble compiler
		$issFolder = IniRead($iniFileName, "FileLocations", "InnoSetup", $issFolder) ; location of Inno setup compiler
		$limitCompile = IniRead($iniFileName, "CompileLimit", "Limit", $limitCompile) ; limit of simultaneous compiles
	
		$recentfileArray = IniReadSection($iniFileName, "RecentFiles") ; restore Recent file list
		$maxrecentfiles = $recentfileArray[1][1]
		For $k = 2 To $recentfileArray[0][0]
			$recentfiles[$k-2][1] = $recentfileArray[$k][1]
			$recentfiles[$k-2][0] = GUICtrlCreateMenuItem($recentfiles[$k-2][1], $RecentMenu, 0)
		Next
		$lastindex = $k-2
		
	EndIf
	FileClose($iniFile)
EndIf
$Inimaxrecentfiles = $maxrecentfiles

#endregion <- Load ini Settings

#region -> GUI Items
$ButtonAdd = GUICtrlCreateButton("&Add", 5, 40, 35, 20)
GUICtrlSetResizing(-1, $gui_dockall)
GUICtrlSetTip(-1, "Add files to list")
$ButtonRem = GUICtrlCreateButton("&Rem", 5, 65, 35, 20)
GUICtrlSetResizing(-1, $gui_dockall)
GUICtrlSetTip(-1, "Remove selected rows")

$ButtonUp = GUICtrlCreateButton("&Up", 5, 120, 35, 20)
GUICtrlSetResizing(-1, $gui_dockall)
GUICtrlSetTip(-1, "Move selected row up")
$ButtonDn = GUICtrlCreateButton("&Dn", 5, 145, 35, 20)
GUICtrlSetResizing(-1, $gui_dockall)
GUICtrlSetTip(-1, "Move selected row down")

$ButtonMake = GUICtrlCreateButton("&Make", 5, 195, 35, 20)
GUICtrlSetResizing(-1, $gui_dockall)
GUICtrlSetTip(-1, "MAKE checked rows")
$limitCompileInput = GUICtrlCreateInput($limitCompile, 5, 220, 40, 20)
GUICtrlSetTip(-1, "Max simultaneous compiles")
GUICtrlSetResizing(-1, $gui_dockall)
GUICtrlCreateUpdown($limitCompileInput)
GUICtrlSetLimit(-1, 999, 1)

$ButtonAll = GUICtrlCreateButton("v", 55, 10, 20, 20)
GUICtrlSetResizing(-1, $gui_dockall)
GUICtrlSetTip(-1, "Check all rows")
$ButtonNone = GUICtrlCreateButton(".", 78, 10, 20, 20)
GUICtrlSetResizing(-1, $gui_dockall)
GUICtrlSetTip(-1, "Clear all checks")
$ButtonRenumber = GUICtrlCreateButton("#", 103, 10, 20, 20)
GUICtrlSetResizing(-1, $gui_dockall)
GUICtrlSetTip(-1, "Renumber rows")

$fileList = GUICtrlCreateListView("Index|  AutoIt Script  |   Path   |  Options", 50, 35, $guiwidth - 60, $guiheight - 80, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_HEADERDRAGDROP))
GUICtrlSetResizing(-1, $gui_dockborders)
GUICtrlSendMsg($fileList, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
;GuiCtrlSetState(-1,$GUI_DROPACCEPTED)   ; to allow drag and dropping
GUICtrlSetBkColor($fileList, $GUI_BKCOLOR_LV_ALTERNATE)

; List View context menu
$LVContextMenu = GUICtrlCreateContextMenu($fileList)
$ContextOptions = GUICtrlCreateMenuItem("Compiler Options", $LVContextMenu)
GUICtrlCreateMenuItem("", $LVContextMenu)
$ContextClear = GUICtrlCreateMenuItem("Clear Compiler Options - This row", $LVContextMenu)
$ContextAllClear = GUICtrlCreateMenuItem("Clear Compiler Options - All rows", $LVContextMenu)
GUICtrlCreateMenuItem("", $LVContextMenu)
$ContextCopy = GUICtrlCreateMenuItem("Compiler Options - Copy", $LVContextMenu)
$ContextPaste = GUICtrlCreateMenuItem("Compiler Options - Paste", $LVContextMenu)
GUICtrlCreateMenuItem("", $LVContextMenu)
$ContextEditScript = GUICtrlCreateMenuItem("Edit file", $LVContextMenu)

GUICtrlCreateGroup("Select Converter", 150, 0, 320, 35)
GUICtrlSetResizing(-1, $gui_dockall)
$ver1 = FileGetVersion($Aut2exeFolder & "\" & "Aut2exe.exe")
$Aut2ExeRadio = GUICtrlCreateRadio("Aut2Exe - v" & $ver1, 180, 13, 120, 20)
GUICtrlSetResizing(-1, $gui_dockall)
$ver2 = FileGetVersion($AutoIt3WrapperFolder & "\" & "AutoIt3Wrapper.exe")
$Aut3WrapRadio = GUICtrlCreateRadio("AutoIt3Wrapper - v" & $ver2, 310, 13, 150, 20)
GUICtrlSetResizing(-1, $gui_dockall)

GUICtrlSetState($Aut3WrapRadio, $GUI_CHECKED) ; set default compiler as AutoIt3Wrapper

$StatusBar = _GUICtrlStatusBarCreate($myGUI, $a_PartsRightEdge, $a_PartsText)
#endregion <- GUI Items

; provide support for command line -> open a MAK file if double-clicked
;  and if MAKEMe!.exe is the program associated with the MAK file type
If $Cmdline[0] > 0 Then _OpenFile($Cmdline[1])

GUISetState()

Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount($fileList) ]

While 1
	
	
	$msg = GUIGetMsg()
	
	Switch $msg

		Case $GUI_EVENT_CLOSE, $ExitItem ; exit - save to INI and check for listview save
			If $SaveToINI Then 
				If _SaveToINI() = -1 Then MsgBox(0, "Error!", "Unable to create INI file.")
				
			EndIf
			
			If $Unsaved Then
				$saveMsg = MsgBox(35, "Unsaved file", "Do you wish to save before exiting?")
				Select
					Case $saveMsg = 6
						_SaveFile()
						Exit
					Case $saveMsg = 7
						Exit
					Case Else
				EndSelect
			Else
				Exit
			EndIf
			
		Case $GUI_EVENT_RESIZED, $GUI_EVENT_MAXIMIZE, $GUI_EVENT_RESTORE ; GUI max/min/restore
			_GUICtrlStatusBarResize($StatusBar)

		Case $fileList ; user clicked listview - sort columns
			$beginTime = TimerInit()
			; sort the list by the column header clicked on
			_GUICtrlStatusBarSetText($StatusBar, "sorting...", 2)
			GUISetState(@SW_LOCK)
			_GUICtrlListViewSort($fileList, $B_DESCENDING, GUICtrlGetState($fileList))
			GUISetState(@SW_UNLOCK)
			_GUICtrlStatusBarSetText($StatusBar, Round(TimerDiff($beginTime) / 1000, 1) & "s", 2)

		Case $ButtonDn ; move selected row down
			If _GUICtrlListViewGetItemCount($fileList) > 0 Then
				$n = _GUICtrlListViewGetCurSel($fileList)
				If $n >= 0 And $n < (_GUICtrlListViewGetItemCount($fileList) - 1) Then
					_MoveDown($n)
					$Unsaved = True
				EndIf
			EndIf
			
		Case $ButtonUp ; move selected row up
			If _GUICtrlListViewGetItemCount($fileList) > 0 Then
				$n = _GUICtrlListViewGetCurSel($fileList)
				If $n > 0 Then
					_MoveUp($n)
					$Unsaved = True
				EndIf
			EndIf

		Case $NewItem ; clear listview?
			$exit = 7
			If $Unsaved Then $exit = MsgBox(35, "Unsaved changes!", "Do you want to save your changes?")
			Select
				Case $exit = 6
					_SaveFile()
				Case $exit = 7
					GUISetState(@SW_LOCK)
					_GUICtrlListViewDeleteAllItems($fileList)
					GUISetState(@SW_UNLOCK)
					$Unsaved = False
				Case Else
					
			EndSelect
			_GUICtrlStatusBarSetText($StatusBar, _GUICtrlListViewGetItemCount($fileList) & " files in list", 0)
			
		Case $OpenItem ; open a MAK file
			_OpenFile()

		Case $SaveItem ; save listview to MAK file
			_SaveFile()

		Case $ButtonAdd ; add
			$Files = FileOpenDialog($fileOpenTitle, "", "AutoIt scripts (*.au3)|Help files (*.hsc)|Inno Installer Compiler files (*.iss)|All files (*.*)", 1 + 4)
			If @error Then ContinueLoop
			;MsgBox(0, "Files", $Files)
			If StringInStr($Files, "|") Then
				$Path = StringLeft($Files, StringInStr($Files, "|") - 1)
				$Files = StringTrimLeft($Files, StringLen($Path) + 1)
				While 1
					$i += 1
					$File = StringLeft($Files, StringInStr($Files, "|") - 1)
					GUICtrlCreateListViewItem($i - 1 & "|" & $File & "|" & $Path, $fileList)
					GUICtrlSetBkColor(-1, $color)
					;MsgBox(0, "File", $File)
					$Files = StringTrimLeft($Files, StringInStr($Files, "|"))
					If StringInStr($Files, "|") = 0 Then ExitLoop
				WEnd
				$i += 1
				GUICtrlCreateListViewItem($i - 1 & "|" & $Files & "|" & $Path, $fileList)
				GUICtrlSetBkColor(-1, $color)
			Else
				$i += 1
				$RFiles = _StringReverse($Files)
				;MsgBox(0, "RFiles", $RFiles)
				$File = _StringReverse(StringLeft($RFiles, StringInStr($RFiles, "\") - 1))
				;MsgBox(0, "File", $File)
				$Path = _StringReverse(StringTrimLeft($RFiles, StringInStr($RFiles, "\")))
				GUICtrlCreateListViewItem($i - 1 & "|" & $File & "|" & $Path, $fileList)
				GUICtrlSetBkColor(-1, $color)
			EndIf
			_GUICtrlListViewSetColumnWidth($fileList, 1, $LVSCW_AUTOSIZE)
			_GUICtrlListViewSetColumnWidth($fileList, 2, $LVSCW_AUTOSIZE)
			For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
				_GUICtrlListViewSetItemText($fileList, $n, 0, $n)
			Next
			_GUICtrlStatusBarSetText($StatusBar, _GUICtrlListViewGetItemCount($fileList) & " files in list", 0)
			$Unsaved = True
			
		Case $ButtonRem ; remove selected rows
			GUISetState(@SW_LOCK)
			_GUICtrlListViewDeleteItemsSelected($fileList)
			For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
				_GUICtrlListViewSetItemText($fileList, $n, 0, $n)
			Next
			GUISetState(@SW_UNLOCK)
			_GUICtrlStatusBarSetText($StatusBar, _GUICtrlListViewGetItemCount($fileList) & " files in list", 0)
			$Unsaved = True

		Case $ButtonAll ; check all rows
			For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
				_GUICtrlListViewSetCheckState($fileList, $n)
			Next
			
		Case $ButtonNone ; clear checks on all rows
			For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
				_GUICtrlListViewSetCheckState($fileList, $n, 0)
			Next
			
		Case $ButtonRenumber ; renumber rows
			For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
				_GUICtrlListViewSetItemText($fileList, $n, 0, $n)
			Next
			
		Case $limitCompileInput ; change max number of simultaneous compiles
			$limitCompile = GUICtrlRead($limitCompileInput)
			
		Case $ButtonMake ; compile checked rows

			$beginTime = TimerInit()

			; count how many checked lines
			$i = 0
			For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
				If _GUICtrlListViewGetCheckedState($fileList, $n) Then $i += 1
			Next
			_GUICtrlStatusBarSetText($StatusBar, "Making " & $i & " file(s)...", 1)
			If $i > $limitCompile Then _GUICtrlStatusBarSetText($StatusBar, "Limiting simultaneous compiles to " & $limitCompile, 2)
			
			; compile checked lines
			For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
				If _GUICtrlListViewGetCheckedState($fileList, $n) Then
				$fileType = _GUICtrlListViewGetItemText($fileList, $n, 1)
				$fileType = StringRight($fileType, 3)
				;MsgBox(0, "File type", $fileType)

				_LimitCompiles($limitCompile)
	
				Switch $fileType
					Case "au3" ; if the file is an AutoIt file

						If GUICtrlRead($Aut2ExeRadio) = $GUI_CHECKED Then
							$cmdString = $Aut2exeFolder & '\aut2exe.exe /in '
						Else
							$cmdString = $AutoIt3WrapperFolder & '\AutoIt3Wrapper.exe /in '
						EndIf
						
						$fileStrA = _GUICtrlListViewGetItemTextArray($fileList, $n)
						$File = $fileStrA[2]
						$Path = $fileStrA[3]
						$Options = $fileStrA[4]
						If GUICtrlRead($Aut2ExeRadio) = $GUI_CHECKED Then
							$cmdString &= '"' & $Path & '\' & $File & '"' & $Options
						Else ; AutoIt3Wrapper
							$A3Options = $Options
							; strip off options that aren't valid for AutoIt3Wrapper compiler
							If StringInStr($A3Options, ' /ansi ') Then $A3Options = StringReplace($A3Options, ' /ansi ', '')
							If StringInStr($A3Options, ' /unicode ') Then $A3Options = StringReplace($A3Options, ' /unicode ', '')
							If StringInStr($A3Options, ' /nopack ') Then $A3Options = StringReplace($A3Options, ' /nopack ', '')
							
							$cmdString &= '"' & $Path & '\' & $File & '"' & $A3Options ;& ' /run'
						EndIf
						;MsgBox(0, "String", $cmdString)
						Run($cmdString)
					
				
					Case "hsc" ; if the file is a HelpScribble file
						If $HelpCompiler Then ; if compiler exists at specified location
							$hscCmdString = $hscFolder & "\HelpScr.exe"
							$fileStrA = _GUICtrlListViewGetItemTextArray($fileList, $n)
							$File = $fileStrA[2]
							$Path = $fileStrA[3]
							$hscCmdString &= ' "' & $Path & '\' & $File & '" ' & '/c /q'
							;MsgBox(0, "Help Scribble cmd", $hscCmdString)
							Run($hscCmdString)
						Else
							MsgBox(0, "No help compiler", "Sorry, the HelpScribble compiler was not found." & @CR _
							& "Please use Options | Setup Options to choose the location of the HelpScr.exe compiler.")
						EndIf
						
					Case "iss" ; if the file is an Inno Setup Compiler file
						If $InnoCompiler Then ; if compiler exists at specified location
							$issCmdString = $issFolder & "\compil32 /cc "
							$fileStrA = _GUICtrlListViewGetItemTextArray($fileList, $n)
							$File = $fileStrA[2]
							$Path = $fileStrA[3]
							$issCmdString &= ' "' & $Path & '\' & $File & '"' 
							;MsgBox(0, "Inno Setup cmd", $issCmdString)
							Run($issCmdString)
						Else
							MsgBox(0, "No Inno compiler", "Sorry, the Inno Install compiler was not found." & @CR _
							& "Please use Options | Setup Options to choose the location of the compil32.exe compiler.")							
						EndIf

				EndSwitch
				EndIf
			Next

			_MonitorCompiles() ; afer all checked rows compiling, monitor progress
			_GUICtrlStatusBarSetText($StatusBar, Round(TimerDiff($beginTime) / 1000, 1) & "s", 2)
		
		
		Case $ContextClear ; clear compiler options for selected row
			_GUICtrlListViewSetItemText($fileList, _GUICtrlListViewGetCurSel($fileList), 3, "")
			
		Case $ContextAllClear ; clear compiler options for all rows
			For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
				_GUICtrlListViewSetItemText($fileList, $n, 3, "")
			Next
			
		Case $ContextEditScript ; edit current row
			$EditFile = _GUICtrlListViewGetItemText($fileList, _GUICtrlListViewGetCurSel($fileList), 2) & "\" & _GUICtrlListViewGetItemText($fileList, _GUICtrlListViewGetCurSel($fileList), 1)
			;MsgBox(0, "File", $EditFile)
			If $EditFile <> '\' And FileExists($EditFile) Then ShellExecute($EditFile)
		
		Case $ContextCopy ; copy compiler options
			$CompileOptions = _GUICtrlListViewGetItemText($fileList, _GUICtrlListViewGetCurSel($fileList), 3)
				
		Case $ContextPaste ; paste compiler options
			If $CompileOptions <> "" Then
				$LVSelections = _GUICtrlListViewGetSelectedIndices($fileList, 1)
				If $LVSelections <> $LV_ERR And $LVSelections[0] > 0 Then
					For $k = 1 To $LVSelections[0]
						$fileType = _GUICtrlListViewGetItemText($fileList, _GUICtrlListViewGetCurSel($fileList), 1)
						$fileType = StringRight($fileType, 3)
						If $fileType = "au3" Then
							_GUICtrlListViewSetItemText($fileList, $LVSelections[$k], 3, $CompileOptions)
						Else
							MsgBox(0, "Sorry..!", "Sorry - these compiler options don't apply to this file type")
						EndIf
					Next
				EndIf
			Else
				MsgBox(0, "No Compiler Options copied...", "You have not yet copied Compiler Options." & @CR & "Please copy before trying to paste.")
			EndIf


		Case $ContextOptions ; bring up compiler options gui for selected au3 row
			$optionList = _GUICtrlListViewGetItemText($fileList, _GUICtrlListViewGetCurSel($fileList), 3)

			$fileType = _GUICtrlListViewGetItemText($fileList, _GUICtrlListViewGetCurSel($fileList), 1)
			$fileType = StringRight($fileType, 3)
			Switch $fileType
				Case "au3"
					$optionGUI = GUICreate("Compiler Options", 398, 249, 314, 333, -1, -1, $myGUI)

					GUICtrlCreateGroup("Global Compile Options...", 8, 8, 385, 153)
					
					$inputLabel = GUICtrlCreateLabel("input file", 24, 32, 43, 17)
					$inputFileLabel = GUICtrlCreateLabel(_GUICtrlListViewGetItemText($fileList, _
							_GUICtrlListViewGetCurSel($fileList), 1), 80, 32, 300, 17)
					$outLabel = GUICtrlCreateLabel("output file", 24, 56, 50, 17)
					$outInput = GUICtrlCreateInput("", 80, 56, 270, 21)
					GUICtrlSetTip(-1, "/out")
					$outButton = GUICtrlCreateButton("...", 355, 56, 20, 20)
					$outFile = StringInStr($optionList, "/out ")
					If $outFile > 0 Then
						$outFile = StringTrimLeft($optionList, $outFile + 5)
						$outFile = StringLeft($outFile, StringInStr($outFile, '"') - 1)
						GUICtrlSetData($outInput, $outFile)
					EndIf
					$iconLabel = GUICtrlCreateLabel("icon file", 24, 80, 40, 17)
					$iconInput = GUICtrlCreateInput("", 80, 80, 270, 21)
					GUICtrlSetTip(-1, "/icon")
					$iconButton = GUICtrlCreateButton("...", 355, 80, 20, 20)
					$iconFile = StringInStr($optionList, "/icon ")
					If $iconFile > 0 Then
						$iconFile = StringTrimLeft($optionList, $iconFile + 6)
						$iconFile = StringLeft($iconFile, StringInStr($iconFile, '"') - 1)
						GUICtrlSetData($iconInput, $iconFile)
					EndIf
					$passLabel = GUICtrlCreateLabel("pass", 24, 104, 26, 17)
					$passInput = GUICtrlCreateInput("", 80, 104, 145, 21)
					GUICtrlSetTip(-1, "/pass")
					$pass = StringInStr($optionList, "/pass ")
					If $pass > 0 Then
						$pass = StringTrimLeft($optionList, $pass + 6)
						$pass = StringLeft($pass, StringInStr($pass, '"') - 1)
						GUICtrlSetData($passInput, $pass)
					EndIf
					
					$nodecompileCheckbox = GUICtrlCreateCheckbox("nodecompile", 80, 133, 97, 17)
					GUICtrlSetTip(-1, "/nodecompile")
					If StringInStr($optionList, "nodecompile") Then GUICtrlSetState($nodecompileCheckbox, $GUI_CHECKED)

					$compLabel = GUICtrlCreateLabel("Comp", 254, 120, 31, 17)
					$defLabel = GUICtrlCreateLabel("(default = 2)", 330, 120, 60, 17)
					$compInput = GUICtrlCreateInput("2", 286, 120, 40, 21)
					$compUpdown = GUICtrlCreateUpdown($compInput)
					GUICtrlSetLimit($compUpdown, 4, 0)
					GUICtrlSetTip(-1, "/comp ")
					If StringInStr($optionList, "/comp ") Then
						$comp = StringMid($optionList, StringInStr($optionList, "/comp ") + 6, 1)
					Else
						$comp = 2
					EndIf
					GUICtrlSetData($compInput, $comp)

					GUICtrlCreateGroup("Options for aut2exe only...", 8, 168, 273, 65)
					$nopackCheckbox = GUICtrlCreateCheckbox("nopack", 184, 192, 60, 17)
					If StringInStr($optionList, "nopack") Then GUICtrlSetState($nopackCheckbox, $GUI_CHECKED)
					GUICtrlSetTip(-1, "/nopack")
					$ansiCheckbox = GUICtrlCreateCheckbox("ansi", 24, 192, 60, 17)
					GUICtrlSetTip(-1, "/ansi")
					If StringInStr($optionList, "ansi") Then GUICtrlSetState($ansiCheckbox, $GUI_CHECKED)
					$unicodeCheckbox = GUICtrlCreateCheckbox("unicode", 104, 192, 60, 17)
					GUICtrlSetTip(-1, "/unicode")
					If StringInStr($optionList, "unicode") Then GUICtrlSetState($unicodeCheckbox, $GUI_CHECKED)
					
					$OKButton = GUICtrlCreateButton("Ok", 312, 176, 75, 25, 0)
					$CancelButton = GUICtrlCreateButton("Cancel", 312, 208, 75, 25, 0)

					GUISetState(@SW_SHOW)

					$optionHold = $optionList
					$optionList = ""
					While 1
						$nMsg = GUIGetMsg()
						Switch $nMsg
							
							Case $GUI_EVENT_CLOSE, $OKButton
								$outFile = GUICtrlRead($outInput)
								If $outFile <> "" And StringRight($outFile, 4) <> ".exe" Then $outFile &= ".exe"
								If $outFile <> "" Then $optionList &= ' /out "' & $outFile & '"'
								If GUICtrlRead($iconInput) <> "" Then $optionList &= ' /icon "' & GUICtrlRead($iconInput) & '"'
								If GUICtrlRead($passInput) <> "" Then $optionList &= ' /pass "' & GUICtrlRead($passInput) & '"'
								If GUICtrlRead($compInput) <> 2 Then $optionList &= " /comp " & GUICtrlRead($compInput) ; 2 is the default
								If GUICtrlRead($nodecompileCheckbox) = $GUI_CHECKED Then $optionList &= ' /nodecompile '
								If GUICtrlRead($nopackCheckbox) = $GUI_CHECKED Then $optionList &= ' /nopack '
								If GUICtrlRead($unicodeCheckbox) = $GUI_CHECKED Then $optionList &= ' /unicode '
								If GUICtrlRead($ansiCheckbox) = $GUI_CHECKED Then $optionList &= ' /ansi '
								
								_GUICtrlListViewSetItemText($fileList, _GUICtrlListViewGetCurSel($fileList), 3, $optionList)
								If $optionList <> $optionHold Then $Unsaved = True
								ExitLoop
								
							Case $CancelButton ; cancel
								ExitLoop
								
							Case $iconButton ; choose icon file
								$iconFile = FileOpenDialog("Select an Icon file", "", "Icon files (*.ico)", 1 + 2)
								GUICtrlSetData($iconInput, $iconFile)
								
							Case $outButton ; choose compiler output file
								$outFile = FileOpenDialog("Select an Output file", "", "Exe files (*.exe)|All files (*.*)")
								GUICtrlSetData($outInput, $outFile)
								
						EndSwitch
						
					WEnd
					
					GUIDelete($optionGUI)
			
				Case "hsc"
					MsgBox (0, "No support", "Sorry - currently no support for options on a Helpscribble file " & @CR & " - just /c /q (compile & quit) for now")
				
				Case "iss"
					MsgBox (0, "No support", "Sorry - currently no support for options on an Inno Setup file " & @CR & " - just /cc (compile)")
					
			EndSwitch
			
		Case $AssociateMakFileItem ; associate MAK files with MAKEme!.exe
			If @OSTYPE = "WIN32_NT" Then
				_AssociateMAKFiles()
			Else
				MsgBox(0, "Error", "Sorry...this is currently limited to NT or later")
			EndIf
			
		Case $RemoveAssociationItem ; remove MAK file association
			If @OSTYPE = "WIN32_NT" Then
				_RemoveMAKFileAssociation()
			Else
				MsgBox(0, "Error", "Sorry...this is currently limited to NT or later")
			EndIf

		Case $SetupOptionsItem ; bring up setup options gui

			$setupOptionsGUI = GUICreate("Setup Options", 500, 270, 230, 260, -1, -1, $myGUI)
			
			$Label = GUICtrlCreateLabel("Folder locations:", 15, 10, 150, 20)
			
			$Aut2ExeLabel = GUICtrlCreateLabel("Aut2exe", 40, 32, 43, 17, $SS_RIGHT)
			$Aut2exeFolderInput = GUICtrlCreateInput($Aut2exeFolder, 90, 32, 355, 21)
			GUICtrlSetTip(-1, "Choose location of aut2exe.exe file")
			$ButtonAut2Exe = GUICtrlCreateButton("...", 450, 32, 33, 25, 0)
			
			$AutoIt3WrapperLabel = GUICtrlCreateLabel("AutoIt3Wrapper", 5, 69, 79, 17, $SS_RIGHT)
			$AutoIt3WrapperFolderInput = GUICtrlCreateInput($AutoIt3WrapperFolder, 90, 68, 355, 21)
			GUICtrlSetTip(-1, "Choose location of AutoIt3Wrapper.exe file")
			$ButtonAutoIt3Wrapper = GUICtrlCreateButton("...", 450, 68, 33, 25, 0)

			$HelpScribbleLabel = GUICtrlCreateLabel("HelpScribble", 22, 105, 64, 17, $SS_RIGHT)
			$HelpScribbleFolderInput = GUICtrlCreateInput($hscFolder, 90, 104, 355, 21)
			GUICtrlSetTip(-1, "Choose location of HelpScribble compiler (HelpScr.exe) file")
			$ButtonHelpScribble = GUICtrlCreateButton("...", 450, 104, 33, 25, 0)
			
			$InnoSetupLabel = GUICtrlCreateLabel("Inno Setup", 29, 141, 56, 17, $SS_RIGHT)
			$InnoSetupFolderInput = GUICtrlCreateInput($issFolder, 90, 140, 355, 21)
			GUICtrlSetTip(-1, "Choose location of Inno Setup compiler (comp32.exe) file")
			$ButtonInnoSetup = GUICtrlCreateButton("...", 450, 140, 33, 25, 0)
			
			$MaxRecentFilesInput = GUICtrlCreateInput($Inimaxrecentfiles, 90, 175, 40, 21)
			GUICtrlSetTip(-1, "Number of Recent files")
			$MaxRecentFilesUpdown = GUICtrlCreateUpdown($MaxRecentFilesInput)
			GUICtrlSetLimit($MaxRecentFilesUpdown, 10, 0)
			GUICtrlCreateLabel("Number of Recent files (changes will take affect on next startup of MAKEme! if options are saved to INI)", 135, 172, 300, 40)
			
			$SaveOptionsCheckbox = GUICtrlCreateCheckbox("Save changes to INI", 350, 205, 121, 17)
			GUICtrlSetState($SaveOptionsCheckbox, $SaveToINI)
			GUICtrlSetTip(-1, "Remember these settings AND Recent files for next session.")
			
			;$ButtonClearRecent = GUICtrlCreateButton("Clear Recent", 65, 224, 75, 25)
			$ButtonClearRecent = GUICtrlCreateButton("Clear Recent", 350, 230, 75, 25)
			GUICtrlSetTip(-1, "Clear Recent files history")
			
			$ButtonOK = GUICtrlCreateButton("OK", 160, 224, 75, 25, 0)
			$ButtonCancel = GUICtrlCreateButton("Cancel", 248, 224, 75, 25, 0)
			
			GUISetState(@SW_SHOW)
			

			While 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					
					Case $GUI_EVENT_CLOSE, $ButtonOK
						If GUICtrlRead($Aut2exeFolderInput) <> "" Then $Aut2exeFolder = GUICtrlRead($Aut2exeFolderInput)
						If GUICtrlRead($AutoIt3WrapperFolderInput) <> "" Then $AutoIt3WrapperFolder = GUICtrlRead($AutoIt3WrapperFolderInput)
						If GUICtrlRead($HelpScribbleFolderInput) <> "" Then $hscFolder = GUICtrlRead($HelpScribbleFolderInput)
						If GUICtrlRead($InnoSetupFolderInput) <> "" Then $issFolder = GUICtrlRead($InnoSetupFolderInput)
						$Inimaxrecentfiles = GUICtrlRead($MaxRecentFilesInput)
						;ReDim $recentfiles[$maxrecentfiles][2]
						If GUICtrlRead($SaveOptionsCheckbox) = $GUI_CHECKED Then 
							$SaveToINI = True
						Else
							$SaveToINI = False
						EndIf
						If Not FileExists($hscFolder & "\HelpScr.exe") Then
							$HelpCompiler = False
						Else
							$HelpCompiler = True
						EndIf
						If Not FileExists($issFolder & "\compil32.exe") Then 
							$InnoCompiler = False
						Else
							$InnoCompiler = True
						EndIf
						ExitLoop
						
					Case $ButtonCancel ; cancel changes
						ExitLoop
						
					Case $ButtonClearRecent ; clear Recent file history
						For $k = 0 To $maxrecentfiles - 1
							GUICtrlDelete($recentfiles[$k][0])
							$recentfiles[$k][0] = ""
							$recentfiles[$k][1] = ""
						Next
						
					Case $ButtonAut2Exe ; choose location of Aut2Exe file
						$Aut2ExeLocation = FileSelectFolder("Select the location of your Aut2Exe file", "c:\", 4, $Aut2exeFolder)
						If $Aut2ExeLocation <> "" Then GUICtrlSetData($Aut2exeFolderInput, $Aut2ExeLocation)
						
					Case $ButtonAutoIt3Wrapper ; choose location of autoit3wrapper file
						$AutoIt3WrapperLocation = FileSelectFolder("Select the location of your Aut2Exe file", "c:\" ,4 ,$AutoIt3WrapperFolder)
						If $AutoIt3WrapperLocation <> "" Then GUICtrlSetData($AutoIt3WrapperFolderInput, $AutoIt3WrapperLocation)
						
					Case $ButtonHelpScribble ; choose location of HelpScribble compiler
						$HelpScribbleLocation = FileSelectFolder("Select the location of your Aut2Exe file", "c:\", 4, $hscFolder)
						If $HelpScribbleLocation <> "" Then GUICtrlSetData($HelpScribbleFolderInput, $HelpScribbleLocation)
						
					Case $ButtonInnoSetup ; choose location of Inno Setup compiler location
						$InnoSetupLocation = FileSelectFolder("Select the location of your Aut2Exe file", "c:\", 4, $issFolder)
						If $InnoSetupLocation <> "" Then GUICtrlSetData($InnoSetupFolderInput, $InnoSetupLocation)
						
				EndSwitch
			WEnd

			GUIDelete($setupOptionsGUI)


		Case $AboutItem ; display information about the application
			
			$t = FileGetTime(@ScriptDir & "\" & @ScriptName, 0)

			If Not @error Then
				$yyyymd = $t[1] & "/" & $t[2] & "/" & $t[0]
			EndIf

			MsgBox(0, "About", "MAKE me!" & @CR & _
					"Version - " & FileGetVersion(@ScriptDir & "\" & @ScriptName) & @CR & _
					"Created - " & $yyyymd & @CR & @CR & _
					"Batch convert AutoIt scripts to exe." & @CR & @CR & _
					"by: SAG")


		Case Else ; user selected a file from Recent Files
			
			For $i = 0 To $maxrecentfiles - 1
				;MsgBox(0, "Msg", $msg)
				If $msg > 0 And $msg = $recentfiles[$i][0] Then
					$openFile = $recentfiles[$i][1] ; now you have the file that was clicked
					If _GUICtrlListViewGetItemCount($fileList) > 0 Then
						If MsgBox(36, "Append?", "Do you wish to append from the file (Yes) or overwrite (No)?") = 7 Then
							GUISetState(@SW_LOCK)
							_GUICtrlListViewDeleteAllItems($fileList)
							GUISetState(@SW_UNLOCK)
						EndIf
					EndIf
					$fileHandle = FileOpen($openFile, 0)
					If $fileHandle <> -1 Then
						; read compiler choice from first line
						$compiler = FileReadLine($fileHandle, 1)
						If StringLen($compiler) = 1 Then
							If $compiler = 0 Then
								GUICtrlSetState($Aut2ExeRadio, $GUI_CHECKED)
							Else
								GUICtrlSetState($Aut3WrapRadio, $GUI_CHECKED)
							EndIf
							$j = 2
						Else
							$j = 1
						EndIf
						
						While 1
							$fileLine = FileReadLine($fileHandle, $j)
							If @error = -1 Then ; end of file
								ExitLoop
							Else
								;MsgBox(0, "Line", $fileLine)
								GUICtrlCreateListViewItem($fileLine, $fileList)
								GUICtrlSetBkColor(-1, $color)
								$j += 1
							EndIf
						WEnd
					Else
						MsgBox(16, "Error!", "Error opening file for writing. Please try another.")
					EndIf
					FileClose($fileHandle)
					GUISetState(@SW_LOCK)
					For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
						_GUICtrlListViewSetItemText($fileList, $n, 0, $n)
					Next
					GUISetState(@SW_UNLOCK)
					_GUICtrlStatusBarSetText($StatusBar, _GUICtrlListViewGetItemCount($fileList) & " files in list", 0)
					_GUICtrlStatusBarSetText($StatusBar, "Opened " & $openFile, 1)
					_GUICtrlListViewSetColumnWidth($fileList, 1, $LVSCW_AUTOSIZE)
					_GUICtrlListViewSetColumnWidth($fileList, 2, $LVSCW_AUTOSIZE)
					
					
				EndIf
			Next
			


	EndSwitch
	
WEnd



Func _SaveFile()
	; save make file - force extension to .mak
	
	$saveFile = FileSaveDialog($fileSaveMAKTitle, @ScriptDir, "MAKE files (*.mak)|All files (*.*)")
	If Not @error Then
		If StringRight($saveFile, 4) <> ".mak" Then $saveFile &= ".mak"
		$fileHandle = FileOpen($saveFile, 2)
		If $fileHandle <> -1 Then
			If GUICtrlRead($Aut2ExeRadio) = $GUI_CHECKED Then
				FileWriteLine($fileHandle, 0)
			Else
				FileWriteLine($fileHandle, 1)
			EndIf
			For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
				$fileStr = _GUICtrlListViewGetItemText($fileList, $n)
				FileWriteLine($fileHandle, $fileStr)
			Next
		Else
			MsgBox(16, "Error!", "Error opening file for writing. Please try another.")
			Return -1
		EndIf
		FileClose($fileHandle)
		$Unsaved = False
		_GUICtrlStatusBarSetText($StatusBar, "Saved as " & $saveFile, 1)
		
		; add to Recent Files menu
		$found = 0
		For $i = 0 To $maxrecentfiles - 1
			If $saveFile = $recentfiles[$i][1] Then
				$found = 1
				ExitLoop
			EndIf
		Next
		
		If Not $found Then
			$item = GUICtrlCreateMenuItem($saveFile, $RecentMenu, 0)
			
			If $count > $maxrecentfiles - 1 Then
				GUICtrlDelete($recentfiles[$lastindex][0])
			EndIf
			
			$recentfiles[$lastindex][0] = $item
			$recentfiles[$lastindex][1] = $saveFile
			
			$lastindex = $lastindex + 1
			If $lastindex = $maxrecentfiles Then $lastindex = 0
			
			$count = $count + 1
		EndIf

	EndIf
	Return 0
	
EndFunc   ;==>_SaveFile


Func _MonitorCompiles()
	; wait until compiles are finished - monitor status of compiles
	
	While 1
		If GUICtrlRead($Aut2ExeRadio) = $GUI_CHECKED Then $PIDList = ProcessList("Aut2exe.exe")
		If GUICtrlRead($Aut3WrapRadio) = $GUI_CHECKED Then $PIDList = ProcessList("AutoIt3Wrapper.exe")
		$hscPIDList = ProcessList("HelpScr.exe") ; HelpScribble compiler
		$issPIDList = ProcessList("compil32.exe") ; Inno Setup compiler
		
 		$compilerCount = $hscPIDList[0][0] + $issPIDList[0][0] + $PIDList[0][0] ; all compilers
				
		If $compilerCount = 0 Or ($compilerCount = 2 And $PIDList[0][0] = 2 And @Compiled = 0 And GUICtrlRead($Aut3WrapRadio) = $GUI_CHECKED) Then
			_GUICtrlStatusBarSetText($StatusBar, "Finished Making files", 1)
			ExitLoop
		ElseIf $compilerCount > 2 And @Compiled = 0 And GUICtrlRead($Aut3WrapRadio) = $GUI_CHECKED Then
			_GUICtrlStatusBarSetText($StatusBar, "Please wait - Making " & $compilerCount - 2 & " file(s)...", 1)
		Else
			_GUICtrlStatusBarSetText($StatusBar, "Please wait - Making " & $compilerCount & " file(s)...", 1)
		EndIf
		
	WEnd
	Return
EndFunc   ;==>_MonitorCompiles


Func _LimitCompiles($max)
	; allow only $max number of simultaneous compile processes to run

	While 1
		If GUICtrlRead($Aut2ExeRadio) = $GUI_CHECKED Then $PIDList = ProcessList("Aut2exe.exe")
		If GUICtrlRead($Aut3WrapRadio) = $GUI_CHECKED Then $PIDList = ProcessList("AutoIt3Wrapper.exe")
		$hscPIDList = ProcessList("HelpScr.exe") ; HelpScribble compiler
		$issPIDList = ProcessList("compil32.exe") ; Inno Setup compiler
		
 		$compilerCount = $hscPIDList[0][0] + $issPIDList[0][0] + $PIDList[0][0] ; all compilers

		
		If $compilerCount < $max Or ($compilerCount < $max + 2 And @Compiled = 0 And GUICtrlRead($Aut3WrapRadio) = $GUI_CHECKED) Then
			ExitLoop
		EndIf
	WEnd
	
	Return
EndFunc   ;==>_LimitCompiles


Func _MoveDown($n)
	; move selected record down
	
	$record = _GUICtrlListViewGetItemText($fileList, $n)
	_GUICtrlListViewDeleteItem($fileList, $n)
	_GUICtrlListViewInsertItem($fileList, $n + 1, $record)
	_GUICtrlListViewSetItemSelState($fileList, $n + 1, 1, 1)
	GUICtrlSetState ($fileList,$GUI_FOCUS)
	
EndFunc   ;==>_MoveDown

Func _MoveUp($n)
	; move selected record up

	$record = _GUICtrlListViewGetItemText($fileList, $n)
	_GUICtrlListViewDeleteItem($fileList, $n)
	_GUICtrlListViewInsertItem($fileList, $n - 1, $record)
	_GUICtrlListViewSetItemSelState($fileList, $n - 1, 1, 1)
	GUICtrlSetState ($fileList,$GUI_FOCUS)
	
EndFunc   ;==>_MoveUp


Func _OpenFile($openFile = "")
	;$openFile = FileOpenDialog($fileOpenMAKTitle, @ScriptDir, "MAKE files (*.mak)|All files (*.*)")
	If $openFile = "" Then $openFile = FileOpenDialog($fileOpenMAKTitle, "", "MAKE files (*.mak)|All files (*.*)")
	If @error <> 1 Then
		If _GUICtrlListViewGetItemCount($fileList) > 0 Then
			If MsgBox(36, "Append?", "Do you wish to append from the file (Yes) or overwrite (No)?") = 7 Then
				GUISetState(@SW_LOCK)
				_GUICtrlListViewDeleteAllItems($fileList)
				GUISetState(@SW_UNLOCK)
			EndIf
		EndIf
		$fileHandle = FileOpen($openFile, 0)
		If $fileHandle <> -1 Then
			; read compiler choice from first line
			$compiler = FileReadLine($fileHandle, 1)
			If StringLen($compiler) = 1 Then
				If $compiler = 0 Then
					GUICtrlSetState($Aut2ExeRadio, $GUI_CHECKED)
				Else
					GUICtrlSetState($Aut3WrapRadio, $GUI_CHECKED)
				EndIf
				$j = 2
			Else
				$j = 1
			EndIf
			
			While 1
				$fileLine = FileReadLine($fileHandle, $j)
				If @error = -1 Then ; end of file
					ExitLoop
				Else ; read lines from file to listview
					;MsgBox(0, "Line", $fileLine)
					GUICtrlCreateListViewItem($fileLine, $fileList)
					GUICtrlSetBkColor(-1, $color)
					$j += 1
				EndIf
			WEnd
		Else
			MsgBox(16, "Error!", "Error opening file for writing. Please try another.")
		EndIf
		FileClose($fileHandle)
		GUISetState(@SW_LOCK)
		For $n = 0 To _GUICtrlListViewGetItemCount($fileList) - 1
			_GUICtrlListViewSetItemText($fileList, $n, 0, $n)
		Next
		GUISetState(@SW_UNLOCK)
		_GUICtrlStatusBarSetText($StatusBar, _GUICtrlListViewGetItemCount($fileList) & " files in list", 0)
		_GUICtrlStatusBarSetText($StatusBar, "Opened " & $openFile, 1)
		_GUICtrlListViewSetColumnWidth($fileList, 1, $LVSCW_AUTOSIZE)
		_GUICtrlListViewSetColumnWidth($fileList, 2, $LVSCW_AUTOSIZE)
		
		; add to Recent Files list
		$found = 0
		For $i = 0 To $maxrecentfiles - 1
			If $openFile = $recentfiles[$i][1] Then
				$found = 1
				ExitLoop
			EndIf
		Next

		If Not $found Then
			$item = GUICtrlCreateMenuItem($openFile, $RecentMenu, 0)

			If $count > $maxrecentfiles - 1 Then
				GUICtrlDelete($recentfiles[$lastindex][0])
			EndIf

			$recentfiles[$lastindex][0] = $item
			$recentfiles[$lastindex][1] = $openFile

			$lastindex = $lastindex + 1
			If $lastindex = $maxrecentfiles Then $lastindex = 0

			$count = $count + 1
		EndIf
	EndIf
	
EndFunc   ;==>_OpenFile


Func _AssociateMAKFiles()
	
	#cs
		
		[HKEY_CLASSES_ROOT\.mak]
		@="makefile"
		[HKEY_CLASSES_ROOT\makefile]
		@="Open Mak File"
		[HKEY_CLASSES_ROOT\makefile\shell]
		[HKEY_CLASSES_ROOT\makefile\shell\open]
		[HKEY_CLASSES_ROOT\makefile\shell\open\command]
		@="C:\Documents and Settings\gallaghers-dog\My Documents\AutoIt Scripts\MAKEme!.exe" "%1"
		
	#ce
	
	RegWrite("HKCR\.mak", "", "REG_SZ", "makefile")
	RegWrite("HKCR\makefile", "", "REG_SZ", "Open Mak file")
	$cmd = '"' & @ScriptDir & '\MAKEme!.exe" "%1"'
	RegWrite("HKCR\makefile\shell\open\command", "", "REG_SZ", $cmd)

EndFunc   ;==>_AssociateMAKFiles


Func _RemoveMAKFileAssociation()

	RegDelete("HKCR\.mak")
	RegWrite("HKCR\makefile")

EndFunc   ;==>_RemoveMAKFileAssociation


Func _SaveToINI()
	; save settings to INI file

	$iniFile = FileOpen($iniFileName, 2)
	If $iniFile = -1 Then ; cannot save - return -1
		Return -1
	EndIf
	; number of recent files
	IniWrite($iniFileName, "RecentFiles", 0, $Inimaxrecentfiles)
	
	For $k = 1 To $Inimaxrecentfiles
		If $recentfiles[$k-1][1] = "" Then
			ContinueLoop
		Else
			IniWrite($iniFileName, "RecentFiles", $k, $recentfiles[$k-1][1])
		EndIf
	Next
	
	; file locations
	IniWrite($iniFileName, "FileLocations", "Aut2Exe", $Aut2exeFolder)
	IniWrite($iniFileName, "FileLocations", "AutoIt3Wrapper", $AutoIt3WrapperFolder)
	IniWrite($iniFileName, "FileLocations", "HelpScribble", $hscFolder)
	IniWrite($iniFileName, "FileLocations", "InnoSetup", $issFolder)
	
	; compiler limits
	IniWrite($iniFileName, "CompileLimit", "Limit", $limitCompile)	
	
	If Not FileClose($iniFile) Then Return -1
	
	Return 1
EndFunc   ;==>_SaveToINI