
#Region --- Header ---
#comments-start
	Title:			Batch Print
	Filename:		Batch Print.au3
	Description:	Tool to aid in the batch printing of files.
	Author(s):		Scott Forehand (RagnaroktA) stforehand@gmail.com
	Version:		2.0
	Last Update:	5/10/2007
	Requirements:	AutoIt v3.2 +, Developed/Tested on WindowsXP Professional Service Pack 2
	Notes:			
#comments-end
#EndRegion --- Header ---

#Region --- Compiler Directives ---
	;** This is a list of compiler directives used by CompileAU3.exe.
	;** comment the lines you don't need or else it will override the default settings
		; #Compiler_Prompt=y              							; y=show compile menu
	;** AUT2EXE settings
		; #Compiler_AUT2EXE=
		#Compiler_Icon='F:\Development Library\AutoIt\Projects\Batch Print\Decompiled\Bin\Batch Print.ico'              		; Filename of the Ico file to use
		; #Compiler_OutFile=              							; Target exe filename.
		; #Compiler_OutFile_Type=         							; a3x=small AitoIt3 file;  exe=Standalone executable(Default)
		#Compiler_Compression=4         							; Compression parameter 0-4  0=Low 2=normal 4=High
		#Compiler_Allow_Decompile=y      							; y=allow decompile
		; #Compiler_PassPhrase=           							; Password to use for compilation
	;** Target program Resource info
		#Compiler_Res_Comment=Tool to aid in the batch printing of files.
		#Compiler_Res_Description=
		#Compiler_Res_Fileversion=2.0
		; #Compiler_Res_LegalCopyright=
	; Free form resource fields ... max 15
		; #Compiler_Res_Field=Email|							 	; Free format fieldname|fieldvalue (custompcs@charter.net)
		#Compiler_Res_Field=Release Date|1/11/2007  				; Free format fieldname|fieldvalue
		#Compiler_Res_Field=Update Date|5/10/2007					; Free format fieldname|fieldvalue
		#Compiler_Res_Field=Internal Name|Batch Print.exe 			; Free format fieldname|fieldvalue
		#Compiler_Res_Field=Status|		 							; Free format fieldname|fieldvalue
	; AU3CHECK settings
		#Compiler_Run_AU3Check=y        							; Run au3check before compilation
		#Compiler_AU3Check_Dat=      								; Override the default au3check definition
	; RUN BEFORE AND AFTER definitions
	; The following directives can contain:
	; %in% , %out%, %icon% which will be replaced by the fullpath\filename.
	; %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.
		#Compiler_Run_Before=           							; Process to run before compilation - you can have multiple records that will be processed in sequence
		; #Compiler_Run_After=move '%out%' '%scriptdir%'  			; Process to run after compilation - you can have multiple records that will be processed in sequence
		#Compiler_Run_After=move 'F:\Development Library\AutoIt\Projects\Batch Print\Decompiled\Batch Print.exe' 'F:\Development Library\AutoIt\Projects\Batch Print\Compiled' ; process to run after compilation - you can have multiple records that will be processed in sequence
#EndRegion --- Compiler Directives End ---

#Region --- Includes ---
	;----- Standard Includes -----
	#include <GuiConstants.au3>
	#include <GuiListView.au3>
	#include <Misc.au3>
	#include <Inet.au3>
	#include <File.au3>
	#include <Constants.au3>
	#include <Array.au3>

	;----- Non-Standard Includes -----

#EndRegion --- Includes ---

#Region --- Globals, Variables, and Constants ---
	Global $G_MY_FIRSTCTRLID	= 5000
	Global $G_MY_LASTCTRLID		= 6000
	Global $G_MY_CTRLID			= $G_MY_FIRSTCTRLID
	Global $sTitle				= 'Batch Print Wizard'
	Global $sVersion			= '2.0'
	Global $sBuild				= ''
	Global $sHelpFile			= FileGetShortName(@UserProfileDir & '\Application Data\Batch Print\Batch Print Help.chm')
	
	Global $picBatchPrint			= @UserProfileDir & '\Application Data\Batch Print\Batch Print.jpg'
	Global $picBatchPrintLogo		= @UserProfileDir & '\Application Data\Batch Print\Batch Print Logo.jpg'
	Global $sGUI1Description		= 'This wizard helps you batch print all of the files in the directory specified.' & _
								  @CRLF & @CRLF & _
								  'Please ensure that if you use IP, or network printing, you have enabled Printer Pooling on the desired Printer in the Printer Properties.' & _
								  @CRLF & @CRLF & @CRLF & @CRLF & @CRLF & _
								  'To continue, click Next.'
	Global $sGUI2Note				= 'You may batch print files from one or more directories.'
	Global $sGUI3Note				= ''
	Global $sGUIFinishDescription	= 'You have successfully completed the ' & $sTitle & '. To immediately print files in another directory, check the checkbox below to restart the wizard.'
	Global $sGUIFinishDescription2	= 'To complete this wizard, click Finish.'

	Global $iGUI

	Global Const $Cursor_WAIT		= 15
	Global Const $Cursor_ARROW		= 2

	#Region --- GUI 1 Creation Declares ---
		Global $hGUI, $hGUI1Dummy1, $sGUI1Description, $btnGUIHelp, $btnGUIBack, $btnGUINext, $btnGUICancel, $hGUI1Dummy2
	#EndRegion --- GUI 1 Creation Declares ---

	#Region --- GUI 2 Creation Declares ---
		Global $hGUI2Dummy1, $lblGUI2Header, $lblGUI2HeaderMessage, $picGUI2HeaderPic, $sGUI2Note, $hGUI2Dummy2, $cmbGUI2Port, $ibGUI2Directory1, $btnGUI2Directory1Browse, $ibGUI2Directory2, $btnGUI2Directory2Browse, $ibGUI2Directory3, $btnGUI2Directory3Browse, $ibGUI2Directory4, $btnGUI2Directory4Browse, $ibGUI2Directory5, $btnGUI2Directory5Browse
	#EndRegion --- GUI 2 Creation Declares ---

	#Region --- GUI 3 Creation Declares ---
		Global $hGUI3Dummy1, $lblGUI3Header, $lblGUI3HeaderMessage, $picGUI3HeaderPic, $lvFiles, $hGUI3Dummy2
	#EndRegion --- GUI 3 Creation Declares ---

	#Region --- GUI Finish Creation Declares ---
		Global $hGUIFinishDummy1, $btnGUIFinish, $ckbGUIFinishRunAgain, $hGUIFinishDummy2	
	#EndRegion --- GUI Finish Creation Declares ---

#EndRegion --- Globals, Variables, and Constants ---

#Region --- Options ---
	#NoTrayIcon
	Opt('GUICoordMode', 1) 				;1 = Absolute coordinates / 0 = Relative position to the start of the last control / 2 = Cell positionining relative to current cell
	Opt('GUIOnEventMode', 1) 			;1 = Enable Enables OnEvent functions notifications / 0 = Disable (Default) Disables OnEvent functions notifications
	;Opt('MustDeclareVars', 1) 			;1 = Variables must be pre-declared / 0 = Variables don't need to be pre-declared (Default)
	Opt('RunErrorsFatal', 0) 			;1 = Fatal set / 0 = Silent set @error
	Opt('GUICloseOnESC', 0) 			;1 = ESC  closes / 0 = ESC won't close
	Opt('GUIResizeMode', 1) 			;0 = No resizing / <1024 Special resizing
	Opt('OnExitFunc','OnAutoItExit')	;'OnAutoItExit' called
	Opt('TrayOnEventMode',1)
	Opt('TrayMenuMode',1)
#EndRegion --- Options ---

#Region --- GUI Preprocessing ---
	_CheckRunning('627452103', $sTitle)
	_CheckAdmin()
	_GUIPrep()
; 	_CreateINI()
; 	_ReadINI()
; 	TCPStartup()
#EndRegion --- GUI Preprocessing ---

#Region --- GUI Creation ---
	#Region --- GUI 1 ---
		$hGUI = GUICreate($sTitle, 500, 365)
			GUISetIcon('F:\Development Library\AutoIt\Projects\Batch Print\Decompiled\Bin\Batch Print.ico')

		$hGUI1Dummy1 = GUICtrlCreateDummy()
			$iGUI = 'GUI1'
			GUICtrlCreatePic($picBatchPrint, 0, 0, 170, 318)
			GUICtrlCreateLabel($sTitle, 185, 10, 300, 30)
				GUICtrlSetFont(-1, 10, 650)
			GUICtrlCreateLabel($sGUI1Description, 185, 35, 300, 295)
		$hGUI1Dummy2 = GUICtrlCreateDummy()

		GUICtrlCreateGroup('', -2, 312, 508, 100)
		GUICtrlCreateGroup('', -99, -99, 1, 1) ; Close Group

; 		GUICtrlCreateLabel('Copyright © 2007 Scott Forehand' & @CRLF & _
; 						   'All Rights Reserved', 5, 322, 240, 60)

		$btnGUIHelp = GUICtrlCreateButton('&Help', 10, 331, 75, 24, $BS_ICON)

		$btnGUIBack = GUICtrlCreateButton('< &Back', 254, 331, 75, 24)
			GUICtrlSetState($btnGUIBack, $GUI_DISABLE)
		$btnGUINext = GUICtrlCreateButton('&Next >', 330, 331, 75, 24, $BS_DEFPUSHBUTTON)
			GUICtrlSetState($btnGUINext, $GUI_FOCUS)
		$btnGUICancel = GUICtrlCreateButton('&Cancel', 415, 331, 75, 24)
	#EndRegion --- GUI 1 ---

	#Region --- GUI 2 ---
		$hGUI2Dummy1 = GUICtrlCreateDummy()
			GUICtrlCreateLabel('', 0, 0, 500, 62)
				GUICtrlSetBkColor(-1, '0xFFFFFF')
			GUICtrlCreateLabel('Choose the port && directories.', 10, 10, 300, 30)
				GUICtrlSetFont(-1, 10, 600)
				GUICtrlSetBkColor(-1, '0xFFFFFF')
			GUICtrlCreatePic($picBatchPrintLogo, 436, 4, 60, 54)
			GUICtrlCreateGroup('', -4, -8, 508, 70)
			GUICtrlCreateGroup('', -99, -99, 1, 1) ; Close Group

			$cmbGUI2Port = GUICtrlCreateCombo("", 60, 80, 120, 30)
				GUICtrlSetData($cmbGUI2Port, "LPT1:|LPT2:|LPT3:|COM1:|COM2:|COM3:|COM4:", "LPT1:")

			$ibGUI2Directory1 = GUICtrlCreateInput('', 60, 110, 300, 23)
			$btnGUI2Directory1Browse = GUICtrlCreateButton('Bro&wse...', 365, 110, 75, 23)

			$ibGUI2Directory2 = GUICtrlCreateInput('', 60, 140, 300, 23)
			$btnGUI2Directory2Browse = GUICtrlCreateButton('Bro&wse...', 365, 140, 75, 23)

			$ibGUI2Directory3 = GUICtrlCreateInput('', 60, 170, 300, 23)
			$btnGUI2Directory3Browse = GUICtrlCreateButton('Bro&wse...', 365, 170, 75, 23)

			$ibGUI2Directory4 = GUICtrlCreateInput('', 60, 200, 300, 23)
			$btnGUI2Directory4Browse = GUICtrlCreateButton('Bro&wse...', 365, 200, 75, 23)

			$ibGUI2Directory5 = GUICtrlCreateInput('', 60, 230, 300, 23)
			$btnGUI2Directory5Browse = GUICtrlCreateButton('Bro&wse...', 365, 230, 75, 23)

			GUICtrlCreateLabel('Note:', 50, 270, 30, 20)
				GUICtrlSetColor(-1,0xFF0000)
			GUICtrlCreateLabel($sGUI2Note, 80, 270, 400, 20)

		$hGUI2Dummy2 = GUICtrlCreateDummy()
	#EndRegion --- GUI 2 ---

	#Region --- GUI 3 ---
		$hGUI3Dummy1 = GUICtrlCreateDummy()
			GUICtrlCreateLabel('', 0, 0, 500, 62)
				GUICtrlSetBkColor(-1, '0xFFFFFF')
			GUICtrlCreateLabel('Print the files.', 10, 10, 300, 30)
				GUICtrlSetFont(-1, 10, 600)
				GUICtrlSetBkColor(-1, '0xFFFFFF')
			GUICtrlCreatePic($picBatchPrintLogo, 436, 4, 60, 54)
			GUICtrlCreateGroup('', -4, -8, 508, 70)
			GUICtrlCreateGroup('', -99, -99, 1, 1) ; Close Group

			$lvFiles = GUICtrlCreateListView('No.|Directory|File', 60, 80, 380, 150)
				GUICtrlSendMsg($lvFiles, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
				GUICtrlSendMsg($lvFiles, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
				_GUICtrlListViewSetColumnWidth ($lvFiles, 0, 36)
				_GUICtrlListViewSetColumnWidth ($lvFiles, 1, 190)
				_GUICtrlListViewSetColumnWidth ($lvFiles, 2, 150)

		$hGUI3Dummy2 = GUICtrlCreateDummy()
	#EndRegion --- GUI 3 ---

	#Region --- GUI Finish ---
		$hGUIFinishDummy1 = GUICtrlCreateDummy()
			GUICtrlCreatePic($picBatchPrint, 0, 0, 170, 318)
			GUICtrlCreateLabel($sTitle, 185, 10, 300, 30)
				GUICtrlSetFont(-1, 10, 650)
			GUICtrlCreateLabel($sGUIFinishDescription, 185, 35, 300, 100)
			$ckbGUIFinishRunAgain = GUICtrlCreateCheckbox('Run the wizard again', 185, 180, 300, 20)
			GUICtrlCreateLabel($sGUIFinishDescription2, 185, 295, 300, 20)
		$hGUIFinishDummy2 = GUICtrlCreateDummy()
	#EndRegion --- GUI Finish ---

; 	#Region --- GUI Template ---
; 		$hGUICFDummy1 = GUICtrlCreateDummy()
; 			GUICtrlCreateLabel('', 0, 0, 500, 62)
; 				GUICtrlSetBkColor(-1 , '0xFFFFFF')
; 			GUICtrlCreateLabel('Define custom settings.', 10, 10, 300, 30)
; 				GUICtrlSetFont (-1, 10, 600)
; 				GUICtrlSetBkColor(-1 , '0xFFFFFF')
; 			GUICtrlCreatePic($picBatchPrintLogo, 436, 4, 60, 54)
; 			GUICtrlCreateGroup('', -4, -8, 508, 70)
; 			GUICtrlCreateGroup('', -99, -99, 1, 1) ; Close Group
; 		$hGUICFDummy2 = GUICtrlCreateDummy()
; 	#EndRegion --- GUI Template ---

	;Set GUI Events

	GUICtrlSetOnEvent($btnGUIHelp, '_GUIEventHandler')
	GUICtrlSetOnEvent($btnGUIBack, '_GUIEventHandler')
	GUICtrlSetOnEvent($btnGUINext, '_GUIEventHandler')
	GUICtrlSetOnEvent($btnGUICancel, '_GUIEventHandler')
	GUICtrlSetOnEvent($cmbGUI2Port, '_GUIEventHandler')
	GUICtrlSetOnEvent($btnGUI2Directory1Browse, '_GUIEventHandler')
	GUICtrlSetOnEvent($btnGUI2Directory2Browse, '_GUIEventHandler')
	GUICtrlSetOnEvent($btnGUI2Directory3Browse, '_GUIEventHandler')
	GUICtrlSetOnEvent($btnGUI2Directory4Browse, '_GUIEventHandler')
	GUICtrlSetOnEvent($btnGUI2Directory5Browse, '_GUIEventHandler')

	GUISetOnEvent($GUI_EVENT_CLOSE, '_SysEventHandler', $hGUI)
		
	GUIChangeItems($hGUI2Dummy1, $hGUI2Dummy2, '', '')
	GUIChangeItems($hGUI3Dummy1, $hGUI3Dummy2, '', '')
	GUIChangeItems($hGUIFinishDummy1, $hGUIFinishDummy2, '', '')

	GUISetState()
#EndRegion --- --- GUI Creation ---

While 1
	Sleep(20)
	If $iGUI = 'GUI3' Then
		; _Print()
		If $ibGUI2Directory1 <> "" Then
			$ibGUI2Directory1Data = GUICtrlRead($ibGUI2Directory1)
			_ListFiles($ibGUI2Directory1Data)
		Else
		Endif
; 		If $ibGUI2Directory2 <> "" Then
; 			$ibGUI2Directory2Data = GUICtrlRead($ibGUI2Directory2)
; 			_ListFiles($ibGUI2Directory2Data)
; 		Else
; 		Endif
; 		If $ibGUI2Directory3 <> "" Then
; 			$ibGUI2Directory3Data = GUICtrlRead($ibGUI2Directory3)
; 			_ListFiles($ibGUI2Directory3Data)
; 		Else
; 		Endif
; 		If $ibGUI2Directory4 <> "" Then
; 			$ibGUI2Directory4Data = GUICtrlRead($ibGUI2Directory4)
; 			_ListFiles($ibGUI2Directory4Data)
; 		Else
; 		Endif
; 		If $ibGUI2Directory5 <> "" Then
; 			$ibGUI2Directory5Data = GUICtrlRead($ibGUI2Directory5)
; 			_ListFiles($ibGUI2Directory5Data)
; 		Else
; 		Endif

	Endif
Wend

#Region --- Process Events ---
	Func _GUIEventHandler()
		Switch @GUI_CtrlId
			Case $btnGUICancel
				_TerminateWizard($hGUI)

			Case $btnGUIHelp
				If FileExists($sHelpFile) Then
					Run(@ComSpec & " /c " & $sHelpFile, "", @SW_HIDE)
				Else
					Msgbox(48, $sTitle, "Unable To Locate Help File!")
				Endif

			Case $btnGUIBack
				If $iGUI = 'GUI1' Then
					
				Elseif $iGUI = 'GUI2' Then
					$iGUI = 'GUI1'
					GUIChangeItems($hGUI2Dummy1, $hGUI2Dummy2, $hGUI1Dummy1, $hGUI1Dummy2)
					GUICtrlSetState($btnGUIBack, $GUI_DISABLE)
				Elseif $iGUI = 'GUI3' Then
					$iGUI = 'GUI2'
					GUIChangeItems($hGUI3Dummy1, $hGUI3Dummy2, $hGUI2Dummy1, $hGUI2Dummy2)
					GUICtrlSetState($btnGUIBack, $GUI_DISABLE)
				Else
				Endif

			Case $btnGUINext
				If $iGUI = 'GUI1' Then
					$iGUI = 'GUI2'
					GUIChangeItems($hGUI1Dummy1, $hGUI1Dummy2, $hGUI2Dummy1, $hGUI2Dummy2)
					GUICtrlSetState($btnGUIBack, $GUI_ENABLE)
				Elseif $iGUI = 'GUI2' Then
					$iGUI = 'GUI3'
					GUIChangeItems($hGUI2Dummy1, $hGUI2Dummy2, $hGUI3Dummy1, $hGUI3Dummy2)
					GUICtrlSetState($btnGUIBack, $GUI_ENABLE)
				Elseif $iGUI = 'GUI3' Then
					$iGUI = 'GUIFinish'
					GUIChangeItems($hGUI2Dummy1, $hGUI2Dummy2, $hGUIFinishDummy1, $hGUIFinishDummy2)
					GUICtrlSetState($btnGUIBack, $GUI_DISABLE)
					GUICtrlSetState($btnGUINext, $GUI_HIDE)
					GUICtrlSetState($btnGUIFinish, $GUI_SHOW)
					GUICtrlSetState($btnGUICancel, $GUI_DISABLE)
				Else
					_TerminateApp()
				Endif

			Case $cmbGUI2Port

			Case $btnGUI2Directory1Browse
				$sFDestination = FileSelectFolder('Select print location...', @DesktopDir, 1+2)
				If $sFDestination <> '' Then
					GUICtrlSetData($ibGUI2Directory1, $sFDestination)
				EndIf

			Case $btnGUI2Directory2Browse
				$sFDestination = FileSelectFolder('Select print location...', @DesktopDir, 1+2)
				If $sFDestination <> '' Then
					GUICtrlSetData($ibGUI2Directory2, $sFDestination)
				EndIf

			Case $btnGUI2Directory3Browse
				$sFDestination = FileSelectFolder('Select print location...', @DesktopDir, 1+2)
				If $sFDestination <> '' Then
					GUICtrlSetData($ibGUI2Directory3, $sFDestination)
				EndIf

			Case $btnGUI2Directory4Browse
				$sFDestination = FileSelectFolder('Select print location...', @DesktopDir, 1+2)
				If $sFDestination <> '' Then
					GUICtrlSetData($ibGUI2Directory4, $sFDestination)
				EndIf

			Case $btnGUI2Directory5Browse
				$sFDestination = FileSelectFolder('Select print location...', @DesktopDir, 1+2)
				If $sFDestination <> '' Then
					GUICtrlSetData($ibGUI2Directory5, $sFDestination)
				EndIf
		EndSwitch
	EndFunc ; ==> _GUIEventHandler

	Func _SysEventHandler()
		Switch @GUI_CtrlId
			Case $GUI_EVENT_CLOSE
				_TerminateWizard(@GUI_WinHandle)

			Case $GUI_EVENT_MINIMIZE
			Case $GUI_EVENT_RESTORE
			Case $GUI_EVENT_MAXIMIZE
			Case $GUI_EVENT_PRIMARYDOWN
			Case $GUI_EVENT_PRIMARYUP
			Case $GUI_EVENT_SECONDARYDOWN
			Case $GUI_EVENT_SECONDARYUP
			Case $GUI_EVENT_MOUSEMOVE
			Case $GUI_EVENT_RESIZED
			Case $GUI_EVENT_DROPPED
		EndSwitch
	EndFunc ; ==> _SysEventHandler
#EndRegion --- Process Events ---

#Region --- Check Running ---
	Func _CheckRunning($sSemaphore, $sProgramName) ;_CheckRunning('123456789', $sTitle) ; Creates A Unique Value
		DllCall('kernel32.dll', 'int', 'CreateSemaphore', 'int', 0, 'long', 1, 'long', 1, 'str', $sSemaphore)
		Local $lastError = DllCall('kernel32.dll', 'int', 'GetLastError'), $ERROR_ALREADY_EXISTS = 183
	
		If $lastError[0] = $ERROR_ALREADY_EXISTS Then
			Local $nRunning = MsgBox(16+4, $sProgramName, 'An instance of this program is already running! Would you like to open a new instance?')
				If $nRunning = 6 Then
					; Do Nothing, Open New Instance
				Else
					_TerminateApp()
				Endif
			AutoItWinSetTitle($sProgramName)
			WinActivate($sProgramName)
		EndIf
		_ReleaseMemory()
	EndFunc ; ==> _CheckRunning
#EndRegion --- Check Running ---

#Region --- Check Administrative Privileges ---
	Func _CheckAdmin()
		If Not IsAdmin() Then
			MsgBox(48, $sTitle, 'The current account does not have administrative privileges on this machine.' & @CRLF & @CRLF & 'This wizard will now exit.')
			_TerminateApp()
		Endif
	EndFunc ; ==> _CheckAdmin
#EndRegion --- Check Administrative Privileges ---

#Region --- GUI Functions ---
	Func _GUIPrep()
		If Not FileExists(@UserProfileDir & '\Application Data\Batch Print') Then DirCreate(@UserProfileDir & '\Application Data\Batch Print')
		FileInstall('F:\Development Library\AutoIt\Projects\Batch Print\Decompiled\Bin\Batch Print.jpg', @UserProfileDir & '\Application Data\Batch Print\Batch Print.jpg')
		FileInstall('F:\Development Library\AutoIt\Projects\Batch Print\Decompiled\Bin\Batch Print Logo.jpg', @UserProfileDir & '\Application Data\Batch Print\Batch Print Logo.jpg')
		FileInstall('F:\Development Library\AutoIt\Projects\Batch Print\Decompiled\Bin\psexec.exe', @UserProfileDir & '\Application Data\Batch Print\psexec.exe')
		If @Compiled Then
			Sleep(1000)
		EndIf
	EndFunc ; ==> _GUIPrep

	Func GUIChangeItems($StartHide, $EndHide, $StartShow, $EndShow)
	    Local $iDX
	    
	    For $iDX = $StartHide To $EndHide
	        GUICtrlSetState ($iDX, $GUI_HIDE)
	    Next
	    For $iDX = $StartShow To $EndShow
	        GUICtrlSetState ($iDX, $GUI_SHOW)
	    Next    
	EndFunc

	Func _ReleaseMemory()
		Local $aiReturn = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
		Return $aiReturn[0]
	EndFunc ; ==> _ReleaseMemory

	Func _ProgressOn(ByRef $s_mainlabel, ByRef $s_sublabel, ByRef $s_control, $s_main, $s_sub, $x, $y, $fSmooth = 0)
		$s_mainlabel = GUICtrlCreateLabel($s_main, $x, $y, StringLen($s_main) * 10, 20)
		If $s_mainlabel = 0 Then
			SetError(1)
			Return 0
		EndIf
		GUICtrlSetFont($s_mainlabel, 10, 600)
		If StringInStr(@OSTYPE, "WIN32_NT") And $fSmooth = 1 Then
			$prev = DllCall("uxtheme.dll", "int", "GetThemeAppProperties");, "int", 0)
			DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
		EndIf
		$s_control = GUICtrlCreateProgress($x, $y + 20, 380, 20, $PBS_SMOOTH)
		If StringInStr(@OSTYPE, "WIN32_NT") And $fSmooth = 1 Then
			DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", $prev[0])
		EndIf
		If $s_control = 0 Then
			SetError(1)
			Return 0
		EndIf
		$s_sublabel = GUICtrlCreateLabel($s_sub, $x, $y + 45)
		If $s_sublabel = 0 Then
			SetError(1)
			Return 0
		EndIf
		Dim $a_info[5]
		$a_info[0] = $s_control
		$a_info[1] = $s_mainlabel
		$a_info[2] = $s_sublabel
		$a_info[3] = $x
		$a_info[4] = $y
		Return $a_info
	EndFunc   ;==>_ProgressOn

	Func _ProgressSet($a_info, $i_per, $s_sub = "", $s_main = "")
		If $s_main = "" Then $s_main = GUICtrlRead($a_info[1])
		If $s_sub = "" Then $s_sub = GUICtrlRead($a_info[2])
		$set1 = GUICtrlSetData($a_info[0], $i_per)
		$set2 = GUICtrlSetData($a_info[1], $s_main)
		$set3 = GUICtrlSetData($a_info[2], $s_sub)
		GUICtrlSetPos($a_info[2], $a_info[3], $a_info[4]+45, StringLen($s_sub)*6)
		GUICtrlSetPos($a_info[1], $a_info[3], $a_info[4], StringLen($s_main)*10)
		If ($set1 = 0) Or ($set2 = 0) Or ($set3 = 0) Then
			SetError(1)
			Return 0
		EndIf
		If ($set1 = -1) Or ($set2 = -1) Or ($set3 = -1) Then
			SetError(1)
			Return 0
		EndIf
		Return 1
	EndFunc

	Func _ProgressOff($a_info)
		$del1 = GUICtrlDelete($a_info[1])
		$del2 = GUICtrlDelete($a_info[2])
		$del3 = GUICtrlDelete($a_info[0])

		If ($del1 = 0) Or ($del2 = 0) Or ($del3 = 0) Then
			SetError(1)
			Return 0
		EndIf
	EndFunc ; ==> _ProgressOff

	Func _MarqueeProgressOn(ByRef $s_mainlabel, ByRef $s_sublabel, ByRef $s_control, $s_main, $s_sub, $x, $y, $fSmooth = 0)
	    Local Const $PBS_MARQUEE = 0x08
		$s_mainlabel = GUICtrlCreateLabel($s_main, $x, $y, StringLen($s_main) * 10, 20)
		If $s_mainlabel = 0 Then
			SetError(1)
			Return 0
		EndIf
		GUICtrlSetFont($s_mainlabel, 10, 600)
		If StringInStr(@OSTYPE, "WIN32_NT") And $fSmooth = 1 Then
			$prev = DllCall("uxtheme.dll", "int", "GetThemeAppProperties");, "int", 0)
			DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
		EndIf
		$s_control = GUICtrlCreateProgress($x, $y + 20, 380, 20, BitOr($PBS_MARQUEE, $PBS_SMOOTH))
		If StringInStr(@OSTYPE, "WIN32_NT") And $fSmooth = 1 Then
			DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", $prev[0])
		EndIf
		If $s_control = 0 Then
			SetError(1)
			Return 0
		EndIf
		$s_sublabel = GUICtrlCreateLabel($s_sub, $x, $y + 45)
		If $s_sublabel = 0 Then
			SetError(1)
			Return 0
		EndIf
		Dim $a_info[5]
		$a_info[0] = $s_control
		$a_info[1] = $s_mainlabel
		$a_info[2] = $s_sublabel
		$a_info[3] = $x
		$a_info[4] = $y
		Return $a_info
	EndFunc   ;==>_MarqueeProgressOn

	Func _MarqueeProgressSet($a_info, $s_sub = "", $s_main = "", $f_Mode = 1, $i_Time = 100)
	    Local Const $WM_USER = 0x0400
	    Local Const $PBM_SETMARQUEE = ($WM_USER + 10)
	    
		If $s_main = "" Then $s_main = GUICtrlRead($a_info[1])
		If $s_sub = "" Then $s_sub = GUICtrlRead($a_info[2])
		$set1 = GUICtrlSendMsg($a_info[0], $PBM_SETMARQUEE, $f_Mode, Number($i_Time))
		$set2 = GUICtrlSetData($a_info[1], $s_main)
		$set3 = GUICtrlSetData($a_info[2], $s_sub)
		GUICtrlSetPos($a_info[2], $a_info[3], $a_info[4]+45, StringLen($s_sub)*6)
		GUICtrlSetPos($a_info[1], $a_info[3], $a_info[4], StringLen($s_main)*10)
	
		If ($set1 = 0) Or ($set2 = 0) Or ($set3 = 0) Then
			SetError(1)
			Return 0
		EndIf
		If ($set1 = -1) Or ($set2 = -1) Or ($set3 = -1) Then
			SetError(1)
			Return 0
		EndIf
		Return 1
	EndFunc ; ==> _MarqueeProgressSet

	Func _GUICleanup()
		If @Compiled Then
			FileDelete(@UserProfileDir & '\Application Data\Batch Print\Batch Print.jpg')
			FileDelete(@UserProfileDir & '\Application Data\Batch Print\Batch Print Logo.jpg')
			Sleep(1000)
		EndIf
	EndFunc ; ==> _GUIPrep
#EndRegion --- GUI Functions ---

#Region --- Printing Functions ---
Func _ListFiles($sPath)
    Local $aFileList, $i = 1
    $aFileList = _FileListToArray($sPath, "*", 1)
    If @error Then
        MsgBox(48, $sTitle, "Error listing files:" & @CRLF & _
                "Directory: " & $sPath & @CRLF & _
                "@error = " & @error)
       ; Exit
    EndIf
    For $i = 1 To $aFileList[0]
        $lvFilesItem = GUICtrlCreateListViewItem($i & "|" & $sPath & "|" & StringStripCR($aFileList[$i]), $lvFiles)
        ;         If $lvEven Then
        ;             $lvEven = 0
        ;         Else
        ;             $lvEven = 1
        ;             GUICtrlSetBkColor($lvItem, $GUIBkColor)
        ;         EndIf
    Next
    ; _ArrayDisplay($aFileList, "$FileList")
EndFunc   ;==>_ListFiles

	Func _ListFiles2($sPath)
		Local $aFileList, $i = 1
		$aFileList = _FileListToArray($sPath, "*", 1)
; 		If @error = 1 Then
; 			MsgBox(48, $sTitle, "No files were found in the directory specified." & @CRLF & @CRLF & $sPath)
; 			Exit
; 		Endif

		For $i = 1 To $aFileList[0]
			$lvFilesItem = GUICtrlCreateListViewItem($i & "|" & $sPath & "|" & StringStripCR($aFileList[$i]), $lvFiles)
	
	; 		If $lvEven Then
	; 			$lvEven = 0
	; 		Else
	; 			$lvEven = 1
	; 			GUICtrlSetBkColor($lvItem, $GUIBkColor)
	; 		EndIf
		Next
		; _ArrayDisplay($aFileList, "$FileList")
	EndFunc ; ==> _ListFiles

	Func _Print()
		Local $sOptions = ''
		Local $cGUIProgressBar = _MarqueeProgressOn($lblGUIMainText, $lblGUISubText, $cGUIProgressBar, 'Printing Files...', '', 60, 160, 0)
		_MarqueeProgressSet($cGUIProgressBar, '', 'Printing Files...', 1, 100)

; For each file in directory, print file using dll call

; cd\temp\camra
; copy *.txt lpt1
; pause
; echo off
; echo. 
; echo.
; echo ***************************
; echo **** Look / see if all ****
; echo ***** files printed ... ***
; echo ***************************
; echo.
; echo.
; echo *** Process Completed !!! ***
; echo.
; echo on
; pause
; cd\

        _ProgressOff($cGUIProgressBar)

		$iGUI = 'GUIFinish'
		GUIChangeItems($hGUI2Dummy1, $hGUI2Dummy2, $hGUIFinishDummy1, $hGUIFinishDummy2)
		GUICtrlSetState($btnGUIBack, $GUI_DISABLE)
		GUICtrlSetData($btnGUINext, '&Finish')
		GUICtrlSetState($btnGUINext, $GUI_ENABLE)
		GUICtrlSetState($btnGUICancel, $GUI_DISABLE)
		_ReleaseMemory()
	EndFunc ; ==> _Print
#EndRegion --- Printing Functions ---

#Region --- Restart Program ---
	Func _RestartProgram() ; Thanks UP_NORTH
	    If @Compiled = 1 Then
	        Run(FileGetShortName(@ScriptFullPath))
	    Else
	        Run(FileGetShortName(@AutoItExe) & ' ' & FileGetShortName(@ScriptFullPath))
	    EndIf
	    Exit
	EndFunc ; ==> _RestartProgram
#EndRegion --- Restart Program ---

#Region --- Terminate Application ---
	Func _TerminateWizard($hGUI)
		GUISetState(@SW_DISABLE, $hGUI)
		$ExitBox = MsgBox(32+4, 'Exit Wizard', 'Are you sure you want to exit the wizard?')
		If $ExitBox = 6 Then
			_TerminateApp()
		ElseIf $ExitBox = 7 Then
			GUISetState(@SW_ENABLE, $hGUI)
			GUISetState(@SW_SHOW, $hGUI)
			WinActivate($hGUI)
		EndIf
	EndFunc ; ==> _TerminateWizard

	Func _TerminateApp()
		If BitAND(GUICtrlRead($ckbGUIFinishRunAgain), $GUI_CHECKED) Then
			_GUICleanup()
			_RestartProgram()
	 	Else
			_GUICleanup()
			Exit
		Endif
	EndFunc ; ==> _TerminateApp
#EndRegion --- Terminate Application ---