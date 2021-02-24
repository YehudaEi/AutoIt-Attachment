; #INDEX# =======================================================================================================================
; Title .........: CreateFilesEmbedded
; Module ........: Main
; Author ........: João Carlos (jscript) - (C) DVI-Informática 2008.6-2011.4, dvi-suporte@hotmail.com
; Support .......:
; AutoIt Version.: 3.3.0.0++
; Language ......: Portuguese
; Description ...: Template for create files embedded in your escript.
; Free Software .: Redistribute and change under these terms:
;               This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
;       as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
;
;               This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
;       of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
;
;               You should have received a copy of the GNU General Public License along with this program.
;               If not, see <http://www.gnu.org/licenses/>.
; http://www.autoitscript.com/forum/topic/132564-createfilesembeddedau3-better-than-fileinstall/
; ===============================================================================================================================
#region AutoIt3Wrapper directives section
;** This is a list of compiler directives used by AutoIt3Wrapper.exe.
;** comment the lines you don't need or else it will override the default settings
; ================================================================================================================================================
;** AUTOIT3 settings
;#AutoIt3Wrapper_UseX64=												;(Y/N) Use X64 versions for AutoIt3_x64 or AUT2EXE_x64. Default=N
;#AutoIt3Wrapper_Version=												;(B/P) Use Beta or Production for AutoIt3 and AUT2EXE. Default is P
;#AutoIt3Wrapper_Run_Debug_Mode=y										;(Y/N) Run Script with console debugging. Default=N
;#AutoIt3Wrapper_Run_SciTE_Minimized=									;(Y/N) Minimize SciTE while script is running. Default=n
;#AutoIt3Wrapper_Run_SciTE_OutputPane_Minimized=						;(Y/N) Toggle SciTE output pane at run time so its not shown. Default=n
;#AutoIt3Wrapper_Autoit3Dir=											;Optionally override the base AutoIt3 install directory.
;#AutoIt3Wrapper_Aut2exe=												;Optionally override the Aut2exe.exe to use for this script
;#AutoIt3Wrapper_AutoIt3=												;Optionally override the Autoit3.exe to use for this script
; ================================================================================================================================================
;** AUT2EXE settings
#AutoIt3Wrapper_Icon=.\Resources\Icon\32x32.ico							;Filename of the Ico file to use
#AutoIt3Wrapper_OutFile=CreateFilesEmbedded.exe							;Target exe/a3x filename.
;#AutoIt3Wrapper_OutFile_Type=											;a3x=small AutoIt3 file;  exe=Standalone executable (Default)
;#AutoIt3Wrapper_OutFile_X64=											;Target exe filename for X64 compile.
#AutoIt3Wrapper_Compression=4											;Compression parameter 0-4  0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=y												;(Y/N) Compress output program.  Default=Y
;#AutoIt3Wrapper_UPX_Parameters=										;Override the default setting for UPX.
;#AutoIt3Wrapper_Change2CUI=											;(Y/N) Change output program to CUI in stead of GUI. Default=N
;#AutoIt3Wrapper_Compile_both=											;(Y/N) Compile both X86 and X64 in one run. Default=N
; ================================================================================================================================================
;** Target program Resource info
#AutoIt3Wrapper_Res_Comment=This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY ;Comment field
#AutoIt3Wrapper_Res_Description=Create files embedded in your escript.	;Description field
#AutoIt3Wrapper_Res_LegalCopyright=(C) DVI-Informática 2008.6-2011.9	;Copyright field
#AutoIt3Wrapper_Res_Fileversion=1.15.0911.2600							;File Version
#AutoIt3Wrapper_Res_Language=1046										;Resource Language code . default 2057=English (United Kingdom)
;#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=							;(Y/N/P) AutoIncrement FileVersion After Aut2EXE is finished. default=N
;                                                 				P=Prompt, Will ask at Compilation time if you want to increase the versionnumber
#AutoIt3Wrapper_Res_ProductVersion=1.15.0911.2600						;Product Version. Default is the AutoIt3 version used.
;#AutoIt3Wrapper_res_requestedExecutionLevel=							;None, asInvoker, highestAvailable or requireAdministrator   (default=None)
;#AutoIt3Wrapper_res_Compatibility=										;Vista,Windows7        Both allowed separated by a comma     (default=None)
;#AutoIt3Wrapper_Res_SaveSource= 										;(Y/N) Save a copy of the Scriptsource in the EXE resources. default=N
; If _Res_SaveSource=Y the content of Scriptsource depends on the _Run_Obfuscator and #obfuscator_parameters directives:
;
;    If _Run_Obfuscator=Y then
;       If #obfuscator_parameters=/STRIPONLY then Scriptsource is stripped script & stripped includes
;       If #obfuscator_parameters=/STRIPONLYINCLUDES then Scriptsource is original script & stripped includes
;       With any other parameters, the SaveSource directive is ignored as obfuscation is intended to protect the source
;   If _Run_Obfuscator=N or is not set then
;       Scriptsource is original script only
; Autoit3Wrapper indicates the SaveSource action taken in the SciTE console during compilation
; See SciTE4AutoIt3 Helpfile for more detail on Obfuscator parameters
;
; free form resource fields ... max 15
;     you can use the following variables:
;     %AutoItVer% which will be replaced with the version of AutoIt3
;     %date% = PC date in short date format
;     %longdate% = PC date in long date format
;     %time% = PC timeformat
#AutoIt3Wrapper_Res_Field=Compiler version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=CompanyName|Digital - Vídeo/Informática.
#AutoIt3Wrapper_Res_Field=InternalName|CreateFilesEmbedded.exe
#AutoIt3Wrapper_Res_Field=LegalTrademarks|Alguns ítens pertencem a Microsoft Corp., os demais, pertencem aos seus respectivos proprietários. - Todos os direitos reservados.
;#AutoIt3Wrapper_Res_Field=ProductName|
#AutoIt3Wrapper_Res_Field=OriginalFilename|
; DigitalProductID is StringToBinary(@ScriptName)
#AutoIt3Wrapper_Res_Field=DigitalProductID|0x4E657453656E642E657865
#AutoIt3Wrapper_Res_Field=DateBuild|%longdate%
; Add extra ICO files to the resources which can be used with TraySetIcon(@ScriptFullPath, 5) etc
; list of filename of the Ico files to be added, First one will have number 5, then 6 ..etc
;#AutoIt3Wrapper_Res_Icon_Add=                   		; Filename[,LanguageCode] of ICO to be added.
; Add extra files to the resources
;#AutoIt3Wrapper_Res_File_Add=							; Filename[,Section [,ResName[,LanguageCode]]] to be added.
; ================================================================================================================================================
; Tidy Settings
;#AutoIt3Wrapper_Run_Tidy=                       		;(Y/N) Run Tidy before compilation. default=N
;#AutoIt3Wrapper_Tidy_Stop_OnError=						;(Y/N) Continue when only Warnings. default=Y
;#Tidy_Parameters=										;Tidy Parameters...see SciTE4AutoIt3 Helpfile for options
; ================================================================================================================================================
; Obfuscator
;#AutoIt3Wrapper_Run_Obfuscator=y                		;(Y/N) Run Obfuscator before compilation. default=N
;#obfuscator_parameters=/STRIPONLY
; ================================================================================================================================================
; AU3Check settings
;#AutoIt3Wrapper_Run_AU3Check=							;(Y/N) Run au3check before compilation. Default=Y
;#AutoIt3Wrapper_AU3Check_Parameters=					;Au3Check parameters
;#AutoIt3Wrapper_AU3Check_Stop_OnWarning=				;(Y/N) N=Continue on Warnings.(Default) Y=Always stop on Warnings
;#AutoIt3Wrapper_PlugIn_Funcs=							;Define PlugIn function names separated by a Comma to avoid AU3Check errors
; ================================================================================================================================================
; cvsWrapper settings
;#AutoIt3Wrapper_Run_cvsWrapper=						;(Y/N/V) Run cvsWrapper to update the script source. default=N
;                                                		 V=only when version is increased by #AutoIt3Wrapper_Res_FileVersion_AutoIncrement.
;#AutoIt3Wrapper_cvsWrapper_Parameters=          		; /NoPrompt  : Will skip the cvsComments prompt
;                                              		   /Comments  : Text to added in the cvsComments. It can also contain the below variables.
; ================================================================================================================================================
; RUN BEFORE AND AFTER definitions
; The following directives can contain: these variables
;   %in% , %out%, %outx64%, %icon% which will be replaced by the fullpath\filename.
;   %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.
;   %fileversion% is the information from the #AutoIt3Wrapper_Res_Fileversion directive
;   %scitedir% will be replaced by the SciTE program directory
;   %autoitdir% will be replaced by the AutoIt3 program directory
;#AutoIt3Wrapper_Add_Constants=                  ;Add the needed standard constant include files. Will only run one time.
;#AutoIt3Wrapper_Run_Before=                     ;process to run before compilation - you can have multiple records that will be processed in sequence
;#AutoIt3Wrapper_Run_After=                      ;process to run After compilation - you can have multiple records that will be processed in sequence
;#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, MENU,,
;#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, DIALOG,,
;#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, ICONGROUP,162,
;#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, ICONGROUP,164,
;#AutoIt3Wrapper_Run_After="%scitedir%\AutoIt3Wrapper\ResHacker.exe" -delete %out%, %out%, ICONGROUP,169,
; ================================================================================================================================================
#endregion AutoIt3Wrapper directives section
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include ".\Include\_GetOSLangString.au3"
#include ".\Include\UpxLibrary.au3" ; UPX.exe file Embedded!

$Language = _GetOSLangString(@OSLang)
#include <language.au3>

Global $sTitle = "Create Files Embedded - v 0.1b"
Global $iUpxIng = 0, $hFileRead, $iLbl_LineCnv
Global $iFuncOutType = 2, $iUDFDefault = 1, $iIsLZNT = 1, $iLZNTValue = 2

$Form1 = GUICreate($sTitle, 490, 306, -1, -1)
$iGrp_Opt = GUICtrlCreateGroup($a_language[1], 17, 15, 353, 177, BitOR($GUI_SS_DEFAULT_GROUP, $BS_LEFT))
$iRad_Func = GUICtrlCreateRadio($a_language[2], 29, 39, 329, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$iChk_UDF = GUICtrlCreateCheckbox($a_language[3], 45, 63, 313, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Rad_Bin = GUICtrlCreateRadio($a_language[4], 29, 87, 329, 17)
$iChk_LZNT = GUICtrlCreateCheckbox($a_language[5], 29, 131, 305, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateLabel($a_language[6], 45, 157, 108, 17)
$Cmb_LZNT = GUICtrlCreateCombo("", 156, 155, 41, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2", "1")
GUICtrlCreateButton("", 24, 117, 340, 2, -1, $WS_EX_STATICEDGE)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$iBtn_Open = GUICtrlCreateButton($a_language[7], 385, 20, 91, 25)
$iBtn_Embed = GUICtrlCreateButton($a_language[8], 385, 50, 91, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$iBtn_Test = GUICtrlCreateButton($a_language[9], 385, 80, 91, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$iBtn_Default = GUICtrlCreateButton($a_language[10], 385, 166, 91, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateButton("", 7, 211, 475, 2, -1, $WS_EX_STATICEDGE)
GUICtrlSetState(-1, $GUI_DISABLE)
$iLbl_Prog = GUICtrlCreateLabel($a_language[11], 19, 224, 122, 17)
$iPrg_Convert = GUICtrlCreateProgress(16, 248, 353, 17)
$iBtn_Exit = GUICtrlCreateButton($a_language[12], 385, 244, 91, 25)
GUICtrlCreateLabel($a_language[13], 19, 277, 96, 17)
$iLbl_LineCnv = GUICtrlCreateLabel("", 118, 277, 182, 17)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $iBtn_Exit
			Exit
		Case $iBtn_Open
			$sSelectFile = FileOpenDialog($a_language[14], @ScriptDir, "All (*.*)|", 3, "", $Form1)
			If @error = 1 Then ContinueLoop
			If Not FileExists($sSelectFile) Then
				MsgBox(262208, $sTitle, $a_language[15] & "'" & $sSelectFile & "' " & $a_language[16])
				WinSetTitle($Form1, "", $sTitle)
				ContinueLoop
			EndIf
			$iUpxIng = 0
			GUICtrlSetData($iPrg_Convert, 0)
			GUICtrlSetData($iLbl_LineCnv, "")
			GUICtrlSetState($iBtn_Embed, $GUI_ENABLE)
			$aPathSplit = _PathSplitNew($sSelectFile)
			$sFileName = $aPathSplit[3]
			$sFileExt = $aPathSplit[4]
			WinSetTitle($Form1, "", $sFileName & $sFileExt & " - " & $sTitle)
			; Search for MZ signature.
			$hFileOpen = FileOpen($sSelectFile, 0)
			$hFileRead = FileRead($hFileOpen, 2)
			If $hFileRead = "MZ" Or $hFileRead = "BM" Then $iUpxIng = 1
			FileClose($hFileOpen)
		Case $iBtn_Embed
			GUICtrlSetState($iBtn_Open, $GUI_DISABLE)
			If _EmbeddedFile($sSelectFile, $sFileName, $sFileExt) Then
				GUICtrlSetState($iBtn_Test, $GUI_ENABLE)
			Else
				GUICtrlSetState($iBtn_Test, $GUI_DISABLE)
			EndIf
			GUICtrlSetState($iBtn_Open, $GUI_ENABLE)
			GUICtrlSetState($iBtn_Embed, $GUI_DISABLE)
			WinSetTitle($Form1, "", $sTitle)
		Case $iBtn_Test
			If $iFuncOutType <> 2 Then
				MsgBox(4096, $sTitle, $a_language[17])
				GUICtrlSetState($iBtn_Test, $GUI_DISABLE)
				ContinueLoop
			EndIf
			WinSetTitle($Form1, "", $sTitle)
			GUICtrlSetState($iBtn_Test, $GUI_DISABLE)
		Case $iRad_Func
			; $iFuncOutType = 2, saída com função
			$iFuncOutType = _CtrlRead($iRad_Func, $GUI_CHECKED) + 1
			GUICtrlSetState($iChk_UDF, $GUI_ENABLE)
			GUICtrlSetState($iBtn_Default, $GUI_ENABLE)
		Case $iChk_UDF
			$iUDFDefault = _CtrlRead($iChk_UDF, $GUI_CHECKED)
			GUICtrlSetState($iBtn_Default, $GUI_ENABLE)
		Case $Rad_Bin
			; $iFuncOutType = 4, somente saída binária
			$iFuncOutType = _CtrlRead($Rad_Bin, $GUI_CHECKED) + 3
			GUICtrlSetState($iChk_UDF, $GUI_DISABLE)
			GUICtrlSetState($iBtn_Default, $GUI_ENABLE)
		Case $iChk_LZNT
			If GUICtrlRead($iChk_LZNT) = $GUI_CHECKED Then
				$iIsLZNT = 1
				GUICtrlSetState($Cmb_LZNT, $GUI_ENABLE)
			Else
				$iIsLZNT = 0
				GUICtrlSetState($Cmb_LZNT, $GUI_DISABLE)
			EndIf
			GUICtrlSetState($iBtn_Default, $GUI_ENABLE)
		Case $Cmb_LZNT
			If GUICtrlRead($Cmb_LZNT) = 1 Then
				$iLZNTValue = 2
			Else
				$iLZNTValue = 258
			EndIf
		Case $iBtn_Default
			GUICtrlSetState($iBtn_Default, $GUI_DISABLE)
			GUICtrlSetState($Rad_Bin, $GUI_UNCHECKED)
			GUICtrlSetState($iRad_Func, $GUI_CHECKED)
			GUICtrlSetState($iChk_UDF, $GUI_ENABLE)
			GUICtrlSetState($iChk_UDF, $GUI_CHECKED)
			GUICtrlSetState($iChk_LZNT, $GUI_CHECKED)
			GUICtrlSetState($Cmb_LZNT, $GUI_ENABLE)
			GUICtrlSetState($Cmb_LZNT, $GUI_ENABLE)
			GUICtrlSetData($Cmb_LZNT, 1)
	EndSwitch
WEnd

; #FUNCTION# ====================================================================================================================
; Name ..........: _CtrlRead
; Description ...:
; Syntax ........: _CtrlRead( $iCltrlID , $vTypeRead  )
; Parameters ....: $iCltrlID            - A integer value.
;                  $vTypeRead           - A variant value.
; Return values .: None
; Author(s) .....: João Carlos (Jscript FROM Brazil)
; ===============================================================================================================================
Func _CtrlRead($iCltrlID, $vTypeRead)
	If GUICtrlRead($iCltrlID) = $vTypeRead Then Return 1
	Return 0
EndFunc   ;==>_CtrlRead

; #FUNCTION# ====================================================================================================================
; Name ..........: _EmbeddedFile
; Description ...:
; Syntax ........: _EmbeddedFile( $sSelectFile  )
; Parameters ....: $sSelectFile         - A string value.
; Return values .: None
; Author(s) .....: João Carlos (Jscript FROM Brazil)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _EmbeddedFile($sSelectFile, $sFileName, $sFileExt)
	Local $hFileOpen, $sFileSTR, $hSaveAu3File, $Slash, $FunctionName, $iFileSize
	Local $sCurrLine, $sMessage = $a_language[18]
	Local $iProgressStep = 0, $iProgress = 0

	$hSaveAu3File = FileSaveDialog($a_language[19], "", "au3 script (*.au3)", 18, $sFileName & ".au3")
	If @error Then Return 0

	$Slash = StringInStr($hSaveAu3File, "\", 0, -1)
	If Not StringInStr(StringTrimLeft($hSaveAu3File, $Slash), ".") Then $hSaveAu3File &= ".au3"
	If FileExists($hSaveAu3File) Then FileDelete($hSaveAu3File)
	;
	$FunctionName = StringStripWS(StringReplace(StringReplace(StringTrimRight(StringTrimLeft( _
			$hSaveAu3File, $Slash), 4), "-", ""), ".", ""), 8)
	$hSaveAu3File = FileOpen($hSaveAu3File, 2)
	;
	If $iUDFDefault And $iFuncOutType = 2 Then
		FileWriteLine($hSaveAu3File, "#include-once")
		FileWriteLine($hSaveAu3File, "; #INDEX# =======================================================================================================================")
		FileWriteLine($hSaveAu3File, "; Title .........: _" & $FunctionName & "()")
		FileWriteLine($hSaveAu3File, "; AutoIt Version.: " & @AutoItVersion)
		FileWriteLine($hSaveAu3File, "; Language.......: " & _GetOSLangString(@OSLang) & " - " & @OSLang)
		FileWriteLine($hSaveAu3File, "; Description ...: Compressed file embedded")
		FileWriteLine($hSaveAu3File, "; Author ........: " & @UserName)
		FileWriteLine($hSaveAu3File, "; ===============================================================================================================================")
		FileWriteLine($hSaveAu3File, "")
		FileWriteLine($hSaveAu3File, "; #CURRENT# =====================================================================================================================")
		FileWriteLine($hSaveAu3File, "; " & "_" & $FunctionName & "()")
		FileWriteLine($hSaveAu3File, "; ===============================================================================================================================")
		FileWriteLine($hSaveAu3File, "")
		FileWriteLine($hSaveAu3File, "; #INTERNAL_USE_ONLY# ===========================================================================================================")
		FileWriteLine($hSaveAu3File, "; __" & $FunctionName & "()" & " ; _LZNTDecompress renamed!")
		FileWriteLine($hSaveAu3File, "; __" & $FunctionName & "()" & " ; _Base64 renamed!")
		FileWriteLine($hSaveAu3File, "; ===============================================================================================================================")
		FileWriteLine($hSaveAu3File, "")
		FileWriteLine($hSaveAu3File, "; #VARIABLES# ===================================================================================================================")
		FileWriteLine($hSaveAu3File, "; ===============================================================================================================================")
		FileWriteLine($hSaveAu3File, "")
		FileWriteLine($hSaveAu3File, "; #FUNCTION# ====================================================================================================================")
		FileWriteLine($hSaveAu3File, "; Name ..........: _" & $FunctionName & "()")
		FileWriteLine($hSaveAu3File, "; Description ...: Compressed file embedded in your .au3 file")
		FileWriteLine($hSaveAu3File, '; Syntax ........: _' & $FunctionName & '( [ lToSave [, sPath [, lExecute ]]] )')
		FileWriteLine($hSaveAu3File, "; Parameters ....: lToSave             - [optional] If True, save the file, else, return binary data. Default is False.")
		FileWriteLine($hSaveAu3File, ";                  sPath               - [optional] The path of the file to be save. Default is @TempDir")
		FileWriteLine($hSaveAu3File, ";                  lExecute            - [optional] Flag to execute file saved. Default is False")
		FileWriteLine($hSaveAu3File, "; Return values .: Success             - Returns decompressed " & $sFileName & $sFileExt & " binary data or saved.")
		FileWriteLine($hSaveAu3File, ";				     Failure             - Returns 0 and set @error to 1.")
		FileWriteLine($hSaveAu3File, "; Author(s) .....: João Carlos (Jscript FROM Brazil)")
		FileWriteLine($hSaveAu3File, "; Modified ......: ")
		If $iIsLZNT Then
			FileWriteLine($hSaveAu3File, "; Remarks .......: This function uses _LZNTDecompress() and _Base64Decode() by trancexx.")
		Else
			FileWriteLine($hSaveAu3File, "; Remarks .......: This function uses _Base64Decode() by trancexx.")
		EndIf
		FileWriteLine($hSaveAu3File, "; Related .......: ")
		FileWriteLine($hSaveAu3File, "; Link ..........: ")
		FileWriteLine($hSaveAu3File, "; Example .......; _" & $FunctionName & "()")
		FileWriteLine($hSaveAu3File, "; ===============================================================================================================================")
	EndIf
	If $iFuncOutType = 2 Then
		FileWriteLine($hSaveAu3File, "Func _" & $FunctionName & "( $lToSave = False, $sPath = @TempDir, $lExecute = False )")
		FileWriteLine($hSaveAu3File, '	Local $hFileHwnd, $bData, $sFileName = $sPath & "\' & $sFileName & $sFileExt & '"')
		FileWriteLine($hSaveAu3File, "")
	EndIf

	If $iIsLZNT = 1 Then
		GUICtrlSetData($iLbl_LineCnv, $a_language[20])
		; Use UPX if file is PE executable.
		GUICtrlSetData($iPrg_Convert, Random(5, 45, 1))
		If $iUpxIng Then RunWait(_UpxLibrary(True) & " -9 -q -f " & FileGetShortName($sSelectFile), "", @SW_HIDE)
		; Use LZNT native compression.
		GUICtrlSetData($iPrg_Convert, GUICtrlRead($iPrg_Convert) + Random(25, 70, 1))
		$hFileOpen = FileOpen($sSelectFile, 16)
		$sFileSTR = StringReplace(_Base64Encode(_LZNTCompress(FileRead($hFileOpen), $iLZNTValue)), @CRLF, "")
		;$sFileSTR = _LZNTCompress(FileRead($hFileOpen), $iLZNTValue)
		For $i = GUICtrlRead($iPrg_Convert) To 100
			GUICtrlSetData($iPrg_Convert, $i)
			Sleep(Random(100, 350, 1))
		Next
	Else
		$hFileOpen = FileOpen($sSelectFile, 16)
		$sFileSTR = StringReplace(_Base64Encode(FileRead($hFileOpen)), @CRLF, "")
		;$sFileSTR = FileRead($hFileOpen)
	EndIf
	FileWriteLine($hSaveAu3File, '	; Original: ' & $sSelectFile)
	;
	Local $i = 1
	$iProgressStep = 100 / Int(StringLen($sFileSTR) / 501)
	GUICtrlSetData($iPrg_Convert, 0)
	While 1
		$sCurrLine = StringMid($sFileSTR, $i * 501 - 500, 501)
		If $sCurrLine = "" Then ExitLoop
		If $i = 1 Then
			FileWriteLine($hSaveAu3File, '	$bData = "' & $sCurrLine & '"')
		Else
			FileWriteLine($hSaveAu3File, '	$bData &= "' & $sCurrLine & '"')
		EndIf
		$i += 1
		$iProgress += $iProgressStep
		GUICtrlSetData($iPrg_Convert, Int($iProgress))
		GUICtrlSetData($iLbl_LineCnv, $i)
	WEnd
	If $iFuncOutType = 2 Then
		FileWriteLine($hSaveAu3File, "")
		FileWriteLine($hSaveAu3File, '	If $lToSave Then')
		FileWriteLine($hSaveAu3File, '		$hFileHwnd = FileOpen($sFileName, 10)')
		FileWriteLine($hSaveAu3File, '		If @error Then Return SetError(1, 0, 0)')
		If $iIsLZNT Then
			FileWriteLine($hSaveAu3File, '		FileWrite($hFileHwnd, __' & $FunctionName & '(__' & $FunctionName & 'B64($bData)))')
		Else
			FileWriteLine($hSaveAu3File, '		FileWrite($hFileHwnd, __' & $FunctionName & 'B64($bData))')
		EndIf
		FileWriteLine($hSaveAu3File, '		FileClose($hFileHwnd)')
		FileWriteLine($hSaveAu3File, '		If $lExecute Then')
		FileWriteLine($hSaveAu3File, '			RunWait($sFileName, "")')
		FileWriteLine($hSaveAu3File, '			FileDelete($sFileName)')
		FileWriteLine($hSaveAu3File, '			Return 1')
		FileWriteLine($hSaveAu3File, '		EndIf')
		FileWriteLine($hSaveAu3File, '		If FileExists($sFileName) Then Return $sFileName')
		FileWriteLine($hSaveAu3File, '	Else')
		If $iIsLZNT Then
			FileWriteLine($hSaveAu3File, '		Return __' & $FunctionName & '(__' & $FunctionName & 'B64($bData))')
		Else
			FileWriteLine($hSaveAu3File, '		Return __' & $FunctionName & 'B64($bData)')
		EndIf
		FileWriteLine($hSaveAu3File, '	EndIf')
		FileWriteLine($hSaveAu3File, '')
		FileWriteLine($hSaveAu3File, '	Return SetError(1, 0, 0)')
		FileWriteLine($hSaveAu3File, "EndFunc   ;==>_" & $FunctionName)
		If $iIsLZNT Then
			FileWriteLine($hSaveAu3File, "")
			; Base64Decode
			If $iUDFDefault Then
				FileWriteLine($hSaveAu3File, "; #INTERNAL_USE_ONLY# ===========================================================================================================")
				FileWriteLine($hSaveAu3File, '; Name...........: __' & $FunctionName & 'B64')
				FileWriteLine($hSaveAu3File, '; Description ...: Base64 decode input data.')
				FileWriteLine($hSaveAu3File, '; Syntax.........: __' & $FunctionName & 'B64' & '($bBinary)')
				FileWriteLine($hSaveAu3File, '; Parameters ....: $sInput - String data to decode')
				FileWriteLine($hSaveAu3File, '; Return values .: Success - Returns decode binary data.')
				FileWriteLine($hSaveAu3File, ';                          - Sets @error to 0')
				FileWriteLine($hSaveAu3File, ';                  Failure - Returns empty string and sets @error:')
				FileWriteLine($hSaveAu3File, ';                  |1 - Error calculating the length of the buffer needed.')
				FileWriteLine($hSaveAu3File, ';                  |2 - Error decoding.')
				FileWriteLine($hSaveAu3File, '; Author ........: trancexx')
				FileWriteLine($hSaveAu3File, '; Modified ......: João Carlos (Jscript FROM Brazil)')
				FileWriteLine($hSaveAu3File, '; Related .......: _Base64Encode()')
				FileWriteLine($hSaveAu3File, '; ===============================================================================================================================')
			EndIf
			FileWriteLine($hSaveAu3File, 'Func __' & $FunctionName & 'B64($sInput)')
			FileWriteLine($hSaveAu3File, '	Local $struct = DllStructCreate("int")')
			FileWriteLine($hSaveAu3File, '	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _')
			FileWriteLine($hSaveAu3File, '			"str", $sInput, _')
			FileWriteLine($hSaveAu3File, '			"int", 0, _')
			FileWriteLine($hSaveAu3File, '			"int", 1, _')
			FileWriteLine($hSaveAu3File, '			"ptr", 0, _')
			FileWriteLine($hSaveAu3File, '			"ptr", DllStructGetPtr($struct, 1), _')
			FileWriteLine($hSaveAu3File, '			"ptr", 0, _')
			FileWriteLine($hSaveAu3File, '			"ptr", 0)')
			FileWriteLine($hSaveAu3File, '	If @error Or Not $a_Call[0] Then')
			FileWriteLine($hSaveAu3File, '		Return SetError(1, 0, "") ; error calculating the length of the buffer needed')
			FileWriteLine($hSaveAu3File, '	EndIf')
			FileWriteLine($hSaveAu3File, '	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")')
			FileWriteLine($hSaveAu3File, '	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _')
			FileWriteLine($hSaveAu3File, '			"str", $sInput, _')
			FileWriteLine($hSaveAu3File, '			"int", 0, _')
			FileWriteLine($hSaveAu3File, '			"int", 1, _')
			FileWriteLine($hSaveAu3File, '			"ptr", DllStructGetPtr($a), _')
			FileWriteLine($hSaveAu3File, '			"ptr", DllStructGetPtr($struct, 1), _')
			FileWriteLine($hSaveAu3File, '			"ptr", 0, _')
			FileWriteLine($hSaveAu3File, '			"ptr", 0)')
			FileWriteLine($hSaveAu3File, '	If @error Or Not $a_Call[0] Then')
			FileWriteLine($hSaveAu3File, '		Return SetError(2, 0, ""); error decoding')
			FileWriteLine($hSaveAu3File, '	EndIf')
			FileWriteLine($hSaveAu3File, '	Return DllStructGetData($a, 1)')
			FileWriteLine($hSaveAu3File, 'EndFunc   ;==>__' & $FunctionName & 'B64')
			FileWriteLine($hSaveAu3File, "")
			; LZNTCompress
			If $iUDFDefault Then
				FileWriteLine($hSaveAu3File, "; #INTERNAL_USE_ONLY# ===========================================================================================================")
				FileWriteLine($hSaveAu3File, '; Name...........: __' & $FunctionName)
				FileWriteLine($hSaveAu3File, '; Original Name..: _LZNTDecompress')
				FileWriteLine($hSaveAu3File, '; Description ...: Decompresses input data.')
				FileWriteLine($hSaveAu3File, '; Syntax.........: __' & $FunctionName & '($bBinary)')
				FileWriteLine($hSaveAu3File, '; Parameters ....: $vInput - Binary data to decompress.')
				FileWriteLine($hSaveAu3File, '; Return values .: Success - Returns decompressed binary data.')
				FileWriteLine($hSaveAu3File, ';                          - Sets @error to 0')
				FileWriteLine($hSaveAu3File, ';                  Failure - Returns empty string and sets @error:')
				FileWriteLine($hSaveAu3File, ';                  |1 - Error decompressing.')
				FileWriteLine($hSaveAu3File, '; Author ........: trancexx')
				FileWriteLine($hSaveAu3File, '; Related .......: _LZNTCompress')
				FileWriteLine($hSaveAu3File, '; Link ..........; http://msdn.microsoft.com/en-us/library/bb981784.aspx')
				FileWriteLine($hSaveAu3File, '; ===============================================================================================================================')
			EndIf
			FileWriteLine($hSaveAu3File, 'Func __' & $FunctionName & '($bBinary)')
			FileWriteLine($hSaveAu3File, '	$bBinary = Binary($bBinary)')
			FileWriteLine($hSaveAu3File, '	Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")')
			FileWriteLine($hSaveAu3File, '	DllStructSetData($tInput, 1, $bBinary)')
			FileWriteLine($hSaveAu3File, '	Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer')
			FileWriteLine($hSaveAu3File, '	Local $a_Call = DllCall("ntdll.dll", "int", "RtlDecompressBuffer", _')
			FileWriteLine($hSaveAu3File, '			"ushort", 2, _')
			FileWriteLine($hSaveAu3File, '			"ptr", DllStructGetPtr($tBuffer), _')
			FileWriteLine($hSaveAu3File, '			"dword", DllStructGetSize($tBuffer), _')
			FileWriteLine($hSaveAu3File, '			"ptr", DllStructGetPtr($tInput), _')
			FileWriteLine($hSaveAu3File, '			"dword", DllStructGetSize($tInput), _')
			FileWriteLine($hSaveAu3File, '			"dword*", 0)')
			FileWriteLine($hSaveAu3File, '')
			FileWriteLine($hSaveAu3File, '	If @error Or $a_Call[0] Then')
			FileWriteLine($hSaveAu3File, '		Return SetError(1, 0, "") ; error decompressing')
			FileWriteLine($hSaveAu3File, '	EndIf')
			FileWriteLine($hSaveAu3File, '')
			FileWriteLine($hSaveAu3File, '	Local $tOutput = DllStructCreate("byte[" & $a_Call[6] & "]", DllStructGetPtr($tBuffer))')
			FileWriteLine($hSaveAu3File, '')
			FileWriteLine($hSaveAu3File, '	Return SetError(0, 0, DllStructGetData($tOutput, 1))')
			FileWriteLine($hSaveAu3File, 'EndFunc   ;==>__' & $FunctionName)
		EndIf
	EndIf
	FileClose($hFileOpen)
	FileClose($hSaveAu3File)
	Sleep(1000)
	If $iUpxIng Then RunWait(_UpxLibrary(True) & " -d " & FileGetShortName($sSelectFile), "", @SW_HIDE)
	MsgBox(262208, $sTitle & $a_language[21], $a_language[22] & $sFileName & $sFileExt & $a_language[23])

	Return 1
EndFunc   ;==>_EmbeddedFile

;===================================================================================
;
; Description:      Splits a path into the drive, directory, file name and file
;                                       extension parts.  An empty string is set if a part is missing.
; Syntax:           _PathSplitNew( Path )
; Parameter(s):     The path to be split (Can contain a UNC server or drive letter)
;
; Requirement(s):   None
; Return Value(s):  Array with 5 elements where 0 = original path, 1 = drive,
;                                       2 = directory, 3 = filename, 4 = extension
; Author(s):        Valik and modified by JScript FROM BRAZIL
; Note(s):          None
;
;===================================================================================
Func _PathSplitNew($Path)
	; Set local strings to null (We use local strings in case one of the arguments is the same variable)
	Local $drive = "", $dir = "", $fname = "", $ext = "", $pos

	; Create an array which will be filled and returned later
	Local $array[5]
	$array[0] = $Path; $szPath can get destroyed, so it needs set now

	; Get drive letter if present (Can be a UNC server)
	If StringMid($Path, 2, 1) = ":" Then
		$drive = StringLeft($Path, 2)
		$Path = StringTrimLeft($Path, 2)
	ElseIf StringLeft($Path, 2) = "\\" Then
		$Path = StringTrimLeft($Path, 2) ; Trim the \\
		$pos = StringInStr($Path, "\")
		If $pos = 0 Then $pos = StringInStr($Path, "/")
		If $pos = 0 Then
			$drive = "\\" & $Path; Prepend the \\ we stripped earlier
			$Path = ""; Set to null because the whole path was just the UNC server name
		Else
			$drive = "\\" & StringLeft($Path, $pos - 1) ; Prepend the \\ we stripped earlier
			$szPath = StringTrimLeft($Path, $pos - 1)
		EndIf
	EndIf

	; Set the directory and file name if present
	Local $nPosForward = StringInStr($Path, "/", 0, -1)
	Local $nPosBackward = StringInStr($Path, "\", 0, -1)
	If $nPosForward >= $nPosBackward Then
		$pos = $nPosForward
	Else
		$pos = $nPosBackward
	EndIf
	$dir = StringLeft($Path, $pos - 1)
	$fname = StringRight($Path, StringLen($Path) - $pos)

	; If $szDir wasn't set, then the whole path must just be a file, so set the filename
	If StringLen($dir) = 0 Then $fname = $Path

	$pos = StringInStr($fname, ".", 0, -1)
	If $pos Then
		$ext = StringRight($fname, StringLen($fname) - ($pos - 1))
		$fname = StringLeft($fname, $pos - 1)
	EndIf

	; Set the array to what we found
	$array[1] = $drive
	$array[2] = $dir
	$array[3] = $fname
	$array[4] = $ext
	Return $array
EndFunc   ;==>_PathSplitNew

; #FUNCTION# ====================================================================================================================
; Name ..........: _Base64Encode
; Description ...:
; Syntax ........: _Base64Encode( $input )
; Parameters ....: $input               - An integer value.
; Return values .: Success		- Returns None
;				   Failure		- Returns None
; Author ........: trancexx
; Modified ......: João Carlos (Jscript FROM Brazil)
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _Base64Encode( $input )
; ===============================================================================================================================
Func _Base64Encode($input)
    ;$input = Binary($input)
    Local $struct = DllStructCreate("byte[" & BinaryLen($input) & "]")

    DllStructSetData($struct, 1, $input)

    Local $strc = DllStructCreate("int")

    Local $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
            "ptr", DllStructGetPtr($struct), _
            "int", DllStructGetSize($struct), _
            "int", 1, _
            "ptr", 0, _
            "ptr", DllStructGetPtr($strc))

    If @error Or Not $a_Call[0] Then
        Return SetError(1, 0, "") ; error calculating the length of the buffer needed
    EndIf

    Local $a = DllStructCreate("char[" & DllStructGetData($strc, 1) & "]")

    $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
            "ptr", DllStructGetPtr($struct), _
            "int", DllStructGetSize($struct), _
            "int", 1, _
            "ptr", DllStructGetPtr($a), _
            "ptr", DllStructGetPtr($strc))

    If @error Or Not $a_Call[0] Then
        Return SetError(2, 0, ""); error encoding
    EndIf

    Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Encode

; #FUNCTION# ;===============================================================================
; Name...........: _LZNTCompress
; Description ...: Compresses input data.
; Syntax.........: _LZNTCompress ($vInput [, $iCompressionFormatAndEngine])
; Parameters ....: $vInput - Data to compress.
;                  $iCompressionFormatAndEngine - Compression format and engine type. Default is 2 (standard compression). Can be:
;                  |2 - COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_STANDARD
;                  |258 - COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_MAXIMUM
; Return values .: Success - Returns compressed binary data.
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - Error determining workspace buffer size.
;                  |2 - Error compressing.
; Author ........: trancexx
; Related .......: _LZNTDecompress
; Link ..........; http://msdn.microsoft.com/en-us/library/bb981783.aspx
;==========================================================================================
Func _LZNTCompress($vInput, $iCompressionFormatAndEngine = 2)

	If Not ($iCompressionFormatAndEngine = 258) Then
		$iCompressionFormatAndEngine = 2
	EndIf

	Local $bBinary = Binary($vInput)

	Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tInput, 1, $bBinary)

	Local $a_Call = DllCall("ntdll.dll", "int", "RtlGetCompressionWorkSpaceSize", _
			"ushort", $iCompressionFormatAndEngine, _
			"dword*", 0, _
			"dword*", 0)

	If @error Or $a_Call[0] Then
		Return SetError(1, 0, "") ; error determining workspace buffer size
	EndIf

	Local $tWorkSpace = DllStructCreate("byte[" & $a_Call[2] & "]") ; workspace is needed for compression

	Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer

	Local $a_Call = DllCall("ntdll.dll", "int", "RtlCompressBuffer", _
			"ushort", $iCompressionFormatAndEngine, _
			"ptr", DllStructGetPtr($tInput), _
			"dword", DllStructGetSize($tInput), _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword", DllStructGetSize($tBuffer), _
			"dword", 4096, _
			"dword*", 0, _
			"ptr", DllStructGetPtr($tWorkSpace))

	If @error Or $a_Call[0] Then
		Return SetError(2, 0, "") ; error compressing
	EndIf

	Local $tOutput = DllStructCreate("byte[" & $a_Call[7] & "]", DllStructGetPtr($tBuffer))

	Return SetError(0, 0, DllStructGetData($tOutput, 1))

EndFunc   ;==>_LZNTCompress