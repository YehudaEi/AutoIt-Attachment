; #INDEX# =======================================================================================================================
; Title .........: CreateFilesEmbedded
; Module ........: Main
; Author ........: João Carlos (jscript) - (C) DVI-Informática 2008.6-2011.4, dvi-suporte@hotmail.com
; Support .......:
; AutoIt Version.: 3.3.0.0++
; Language ......: English
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
; ===============================================================================================================================

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

; UPX.exe file Embedded!
#include "UpxLibrary.au3"

Global $sTitle = "Create Files Embedded - v 0.1b"
Global $iUpxIng = 0, $hFileRead, $iLbl_LineCnv
Global $iFuncOutType = 2, $iUDFDefault = 1, $iIsLZNT = 1, $iLZNTValue = 2

$Form1 = GUICreate($sTitle, 490, 306, -1, -1)
$iGrp_Opt = GUICtrlCreateGroup("Out file options", 17, 15, 353, 177, BitOR($GUI_SS_DEFAULT_GROUP, $BS_LEFT))
$iRad_Func = GUICtrlCreateRadio("Create a function based on the file output name.", 29, 39, 329, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$iChk_UDF = GUICtrlCreateCheckbox("Add patterns of User Defined Functions (UDF).", 45, 63, 313, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Rad_Bin = GUICtrlCreateRadio("Only create the output file with the binary.", 29, 87, 329, 17)
$iChk_LZNT = GUICtrlCreateCheckbox("Use LZNT compression.", 29, 131, 305, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateLabel("LZNT compression level:", 60, 165, 168, 17)
$Cmb_LZNT = GUICtrlCreateCombo("", 190, 160, 41, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2", "1")
GUICtrlCreateButton("", 24, 117, 340, 2, -1, $WS_EX_STATICEDGE)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$iBtn_Open = GUICtrlCreateButton("&Open file", 385, 20, 91, 25)
$iBtn_Embed = GUICtrlCreateButton("Embed file", 385, 50, 91, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$iBtn_Test = GUICtrlCreateButton("Test", 385, 80, 91, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$iBtn_Default = GUICtrlCreateButton("Default", 385, 166, 91, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateButton("", 7, 211, 475, 2, -1, $WS_EX_STATICEDGE)
GUICtrlSetState(-1, $GUI_DISABLE)
$iLbl_Prog = GUICtrlCreateLabel("Conversion Progress:", 19, 224, 122, 17)
$iPrg_Convert = GUICtrlCreateProgress(16, 248, 353, 17)
$iBtn_Exit = GUICtrlCreateButton("Exit", 385, 244, 91, 25)
GUICtrlCreateLabel("Processed:", 19, 277, 96, 17)
$iLbl_LineCnv = GUICtrlCreateLabel("", 118, 277, 182, 17)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $iBtn_Exit
			Exit
		Case $iBtn_Open
			$sSelectFile = FileOpenDialog("Choose an archive:", @ScriptDir, "All (*.*)|", 3, "", $Form1)
			If @error = 1 Then ContinueLoop
			If Not FileExists($sSelectFile) Then
				MsgBox(262208, $sTitle, "File: " & "'" & $sSelectFile & "' " & " does not exist!")
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
				MsgBox(4096, $sTitle, 'Test : "Create a function based on the output file name" activated!')
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
	Local $sCurrLine, $sMessage = "Please wait, creating file .AU3 -> "
	Local $iProgressStep = 0, $iProgress = 0

	$hSaveAu3File = FileSaveDialog("Save embeded file as", "", "au3 script (*.au3)", 18, $sFileName & ".au3")
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
		FileWriteLine($hSaveAu3File, "; Language.......: " & @OSLang)
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
		FileWriteLine($hSaveAu3File, "; Remarks .......: This function uses _LZNTDecompress by trancexx. http://msdn.microsoft.com/en-us/library/bb981784.aspx")
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
		GUICtrlSetData($iLbl_LineCnv, "Compressing file, please wait...")
		; Use UPX if file is PE executable.
		GUICtrlSetData($iPrg_Convert, Random(5, 45, 1))
		If $iUpxIng Then RunWait(_UpxLibrary(True) & " -9 -q -f " & FileGetShortName($sSelectFile), "", @SW_HIDE)
		; Use LZNT native compression.
		GUICtrlSetData($iPrg_Convert, GUICtrlRead($iPrg_Convert) + Random(25, 70, 1))
		$hFileOpen = FileOpen($sSelectFile, 16)
		$sFileSTR = Hex(_LZNTCompress(FileRead($hFileOpen), $iLZNTValue))
		For $i = GUICtrlRead($iPrg_Convert) To 100
			GUICtrlSetData($iPrg_Convert, $i)
			Sleep(Random(100, 350, 1))
		Next
	Else
		$hFileOpen = FileOpen($sSelectFile, 16)
		$sFileSTR = Hex(FileRead($hFileOpen), $iLZNTValue)
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
			FileWriteLine($hSaveAu3File, '	$bData = "0x' & $sCurrLine & '"')
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
			FileWriteLine($hSaveAu3File, '		FileWrite($hFileHwnd, __' & $FunctionName & '($bData))')
		Else
			FileWriteLine($hSaveAu3File, '		FileWrite($hFileHwnd, $bData)')
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
			FileWriteLine($hSaveAu3File, '		Return __' & $FunctionName & '($bData)')
		Else
			FileWriteLine($hSaveAu3File, '		Return $bData')
		EndIf
		FileWriteLine($hSaveAu3File, '	EndIf')
		FileWriteLine($hSaveAu3File, '')
		FileWriteLine($hSaveAu3File, '	Return SetError(1, 0, 0)')
		FileWriteLine($hSaveAu3File, "EndFunc   ;==>_" & $FunctionName)
		If $iIsLZNT Then
			FileWriteLine($hSaveAu3File, "")
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
			FileWriteLine($hSaveAu3File, '					"ushort", 2, _')
			FileWriteLine($hSaveAu3File, '					"ptr", DllStructGetPtr($tBuffer), _')
			FileWriteLine($hSaveAu3File, '					"dword", DllStructGetSize($tBuffer), _')
			FileWriteLine($hSaveAu3File, '					"ptr", DllStructGetPtr($tInput), _')
			FileWriteLine($hSaveAu3File, '					"dword", DllStructGetSize($tInput), _')
			FileWriteLine($hSaveAu3File, '					"dword*", 0)')
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
	MsgBox(262208, $sTitle & " - Finished!", 'O File "' & $sFileName & $sFileExt & '" was built to au3.')

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

; #FUNCTION# ;===============================================================================
;
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
;
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