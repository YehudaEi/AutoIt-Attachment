#include-once

#include <Array.au3>
#include <GDIPlus.au3>


;#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
; #INDEX# =======================================================================================================================
; Title .........: File_Sequence.au3
; AutoIt Version : v3 or higher
; Language ......: English
; Description ...: Various functions related to file sequences
; Remarks .......: 	If you want to use the functions _FileSequence_Convert or _FileSequence_Resize you need to have IrfanView installed
;					at in the same folder as the script ( @scriptdir ) or you can modify the path below.
; Note ..........:
; Author(s) .....: Joaquim Montserrat (jmon) http://www.jmontserrat.com , Julien Vanhoenacker http://www.juvano.com
; ===============================================================================================================================


; #CURRENT# =====================================================================================================================
; _FileSequence_Convert					- Convert a file sequence to specified file format using IrfanView
; _FileSequence_Copy					- Copy file sequence to another folder
; _FileSequence_Delete					- Delete all file sequence
; _FileSequence_Exists					- Check if the file sequence exists or not
; _FileSequence_Find					- Find file sequences in given directory.
; _FileSequence_FSToRegExp				- Converts a #### in file sequence to string format %04d
; _FileSequence_FSToWildcard			- Converts a #### in file sequence to wildcard ****
; _FileSequence_GetFileName				- Gets the file name and trailing numbers from given file sequence
; _FileSequence_GetImageDimensions		- Gets the image dimension (in pixels) for the first image in the sequence
; _FileSequence_GetParentFolder			- Gets the parent folder for the given file sequence
; _FileSequence_GetRange				- Gets the range for the given file sequence
; _FileSequence_GetSize					- Gets the total size in bytes of the file sequence
; _FileSequence_Move					- Moves the file sequence to another folder
; _FileSequence_Rename					- Rename the file sequence
; _FileSequence_Resize					- Resize a file sequence using Irfan View
; ===============================================================================================================================


;Place here the path to IrfanView:
Global $___PathIrfanView = @ScriptDir & "\IrfanView\i_view32.exe"


; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_Find
; Description ...: Process files from given path to find file sequences.
; Syntax ........: _FileSequence_Find ( $sPath , $fRecursive , $sFilter )
; Parameters ....: $sPath			 - A string folder path (with or without backtrailing slash)
;                  $fRecursive		 - [optional] (Bool) True to search folders within folders (recursive) (Default: True)
;                  $sFilter			 - [optional] (String) a string of images extensions separated by spaces (Default = Default Keyword returns all images type)
; Return values .: Success 		- Returns $aPaths : Array of file sequences
;										  $aPaths[0] returns the number of sequences found
;										  $aPaths[n] returns the file sequence where #n represents the file numbering
;				   Failure		- Returns -1 and sets @error
;									1 = Path doesn't exist
;									2 = $fRecursive Isn't boolean
;									3 = $sFilter Isn't string
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _FileSequence_Find ( "C:\images" , True , "jpg png") = Returns jpg and png image sequences from C:\Images and from every subfolders.
;				   _FileSequence_Find ( "C:\images\myImageSequence_005.tga" ) = Returns sequence in format "C:\images\myImageSequence_###.tga"
; ===============================================================================================================================
Func _FileSequence_Find($sPath, $fRecursive = True, $sFilter = Default)

	;return @error=1 if path doesn't exist
	If Not FileExists($sPath) Then Return SetError(1, 0, -1)
	;return @error=2 if $fRecursive is not boolean
	If Not IsBool($fRecursive) Then Return SetError(2, 0, -1)
	;return @error=3 if $sFilter is not string
	If Not IsString($sFilter) And Not IsKeyword($sFilter) Then Return SetError(3, 0, -1)

	;if $sFilter is Default then $sFilter equals all images type
	If $sFilter = Default Then $sFilter = "png jpg exr dpx tga bmp cin tif gif sgi rla rpf tiff"
	;Replace slashes with backslashes
	$sPath = StringReplace($sPath, "/", "\")
	;Check if path contains or not a backslash at the end
	If StringRight($sPath, 1) = "\" Then $sPath = StringTrimRight($sPath, 1)

	;Declare Array containing the Paths to return
	Local $aPaths[1] = [0]


	If FileGetAttrib($sPath) = 'D' Then
		;if the path is a folder then we process the folder
		___FS_Process_Folder($sPath, $aPaths, $fRecursive, $sFilter)
	Else
		;if not a folder then process as a file
		___FS_Process_File($sPath, $aPaths, $sFilter)
	EndIf


	;we return the Array containing the file sequences
	Return $aPaths

EndFunc   ;==>_FileSequence_Find

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_GetRange
; Description ...: Return first and last frames
; Syntax ........: _FileSequence_GetRange ( $sFileSequencePath )
; Parameters ....: $sPath		- A string file sequence where ### equals the file numbering
; Return values .: Success 		- Returns array where Array[0]= first frame Array[1]= last frame
;				   Failure		- Returns -1 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = $aPath_Split didn't return an Array or created more than 2 split
;									3 = couldn't find first or last frames
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_GetRange ( "C:\images\Image_####.tga" )
; ===============================================================================================================================
Func _FileSequence_GetRange($sFileSequencePath)

	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, -1)


	Local $iMaxArray = 50
	Local $aRange[$iMaxArray]
	$aRange[0] = 0
	Local $sFirstFrame = ""
	Local $sLastFrame = ""


	;get all frame range and store it to array
	Local $sFileSequencePath_Search = StringReplace($sFileSequencePath, "#", "*")
	Local $search = FileFindFirstFile($sFileSequencePath_Search)
	While 1
		Local $file = FileFindNextFile($search)
		If @error Then ExitLoop

		$aRange[0] += 1
		If $aRange[0] + 1 = $iMaxArray Then
			$iMaxArray *= 2
			ReDim $aRange[$iMaxArray + 1]
		EndIf

		$aRange[$aRange[0]] = $file
	WEnd

	If $aRange[0] = 0 Then Return SetError(1, 0, -1)

	;Sort the files
	ReDim $aRange[$aRange[0] + 1]
	_ArraySort($aRange, 0, 1, $aRange[0])

	;get the file numbers
	$sFirstFrame = StringTrimRight($sFileSequencePath, StringLen($aRange[1])) & $aRange[1]
	$sLastFrame = StringTrimRight($sFileSequencePath, StringLen($aRange[$aRange[0]])) & $aRange[$aRange[0]]

	;Return @error=3 if could n't find first or last frame
	If $sFirstFrame = "" Or $sLastFrame = "" Then Return SetError(3, 0, -1)


	;get frame number length
	Local $frame_number_length = StringReplace($sFileSequencePath, "#", "")
	$frame_number_length = @extended
	;return @error=1 if StringReplace didn't do any replacement ($sFileSequencePath isn't formated properly?)
	If $frame_number_length = 0 Then Return SetError(1, 0, -1)


	;build frame numbering to create the split delimiter
	Local $frame_number = ""
	For $i = 1 To $frame_number_length
		$frame_number &= "#"
	Next


	Local $aPath_Split = StringSplit($sFileSequencePath, $frame_number, 1)
	;return @error=2 if $aPath_Split didn't return an Array
	If Not IsArray($aPath_Split) And $aPath_Split[0] <> 2 Then Return SetError(2, 0, -1)


	;Fill the array with first and last frame
	Local $aRet[2]
	Local $iStart = StringLen($aPath_Split[1]) + 1
	$aRet[0] = Int(Number(StringMid($sFirstFrame, $iStart, $frame_number_length)))
	$aRet[1] = Int(Number(StringMid($sLastFrame, $iStart, $frame_number_length)))
	If $aRet[1] = 0 And $aRet[0] > 0 Then $aRet[1] = $aRet[0]

	;Return the array containing the first and last frame of the sequence
	Return $aRet

EndFunc   ;==>_FileSequence_GetRange

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_FSToRegExp
; Description ...: Convert ### file numbering to RegExp %04d
; Syntax ........: _FileSequence_FS_To_RegExp ( $sFileSequencePath )
; Parameters ....: $sPath		- A string file sequence where ### equals the file numbering
; Return values .: Success 		- Returns a string converted
;				   Failure		- Returns -1 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = $aPath_Split didn't return an Array or created more than 2 split
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_FSToRegExp ( "C:\images\Image_####.tga" ) ; Returns : "C:\images\Image_%04d.tga"
; ===============================================================================================================================
Func _FileSequence_FSToRegExp($sFileSequencePath)

	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, -1)

	;get frame number length
	Local $frame_number_length = StringReplace($sFileSequencePath, "#", "")
	$frame_number_length = @extended
	;return @error=1 if StringReplace didn't do any replacement ($sFileSequencePath isn't formated properly?)
	If $frame_number_length = 0 Then Return SetError(1, 0, -1)

	;build frame numbering to create the split delimiter
	Local $frame_number = ""
	For $i = 1 To $frame_number_length
		$frame_number &= "#"
	Next

	Local $aPath_Split = StringSplit($sFileSequencePath, $frame_number, 1)
	;return @error=2 if $aPath_Split didn't return an Array
	If Not IsArray($aPath_Split) And $aPath_Split[0] <> 2 Then Return SetError(2, 0, -1)

	Return $aPath_Split[1] & "%0" & $frame_number_length & "d" & $aPath_Split[2]

EndFunc   ;==>_FileSequence_FSToRegExp

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_FSToWildcard
; Description ...: Convert ### file numbering to wildcard ****
; Syntax ........: _FileSequence_FS_To_RegExp ( $sFileSequencePath )
; Parameters ....: $sPath		- A string file sequence where ### equals the file numbering
; Return values .: Success 		- Returns a string converted
;				   Failure		- Returns -1 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = $aPath_Split didn't return an Array or created more than 2 split
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_FSToWildcard ( "C:\images\Image_####.tga" ) ; Returns : "C:\images\Image_****.tga"
; ===============================================================================================================================
Func _FileSequence_FSToWildcard($sFileSequencePath)

	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, -1)

	;Returns the new string:
	Return StringReplace($sFileSequencePath, "#", "*")
EndFunc   ;==>_FileSequence_FSToWildcard

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_Exists
; Description ...: Check if given file sequence exists or not
; Syntax ........: _FileSequence_Exists ( $sFileSequencePath )
; Parameters ....: $sPath		- A string file sequence where ### equals the file numbering
; Return values .: Success 		- Returns True
;				   Failure		- Returns False
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_Exists ( "C:\images\Image_####.tga" )
; ===============================================================================================================================
Func _FileSequence_Exists($sFileSequencePath)
	Return ___FS_IsFileSequence($sFileSequencePath)
EndFunc   ;==>_FileSequence_Exists

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_Delete
; Description ...: Deletes a all the files of a file sequence
; Syntax ........: _FileSequence_Delete ( $sFileSequencePath )
; Parameters ....: $sPath		- A string file sequence where ### equals the file numbering
; Return values .: Success 		- Returns 1
;				   Failure		- Returns 0 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = given path doesn't exist (result = Files not deleted)
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_Delete ( "C:\images\Image_####.tga" )
; ===============================================================================================================================
Func _FileSequence_Delete($sFileSequencePath)
	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, -1)

	;return @error=1 if $sFileSequencePath couldn't be converted to wildcard
	Local $sequence_path_ready = StringReplace($sFileSequencePath, "#", "*")
	If @extended = 0 Then Return SetError(1, 0, 0)

	If FileDelete($sequence_path_ready) = 1 Then
		Return 1
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc   ;==>_FileSequence_Delete

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_GetParentFolder
; Description ...: returns the parent folder of the given file sequence WITH a backtrailing backslash
; Syntax ........: _FileSequence_GetParentFolder ( $sFileSequencePath )
; Parameters ....: $sPath		- A string file sequence where ### equals the file numbering
; Return values .: Success 		- Returns a string path of the parent folder (without trailing backslash).
;				   Failure		- Returns 0 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = Error While recreating the path
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_GetParentFolder ( "C:\images\Image_####.tga" ) ; Returns : "C:\images\"
; ===============================================================================================================================
Func _FileSequence_GetParentFolder($sFileSequencePath)

	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, -1)

	;split the sequence file to folders
	Local $aFileSplit = StringSplit($sFileSequencePath, "/\")

	;return @error=1 if couldn't split the path
	If Not IsArray($aFileSplit) Or $aFileSplit[0] = 1 Then Return SetError(1, 0, -1)

	;Recreate the path of the parent folder
	Local $sParentFolder = ""
	For $i = 1 To ($aFileSplit[0] - 1)
		If $i = ($aFileSplit[0] - 1) Then
			;if last element then don't add the backslash
			$sParentFolder &= $aFileSplit[$i]
		Else
			$sParentFolder &= $aFileSplit[$i] & "\"
		EndIf
	Next

	If $sParentFolder Then
		;Return the parent folder path
		Return $sParentFolder
	Else
		Return SetError(1, 0, -1)
	EndIf

EndFunc   ;==>_FileSequence_GetParentFolder


; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_GetSize
; Description ...: Return the size in bytes for the given file sequence
; Syntax ........: _FileSequence_GetSize ( $sFileSequencePath )
; Parameters ....: $sPath		- A string file sequence where ### equals the file numbering
; Return values .: Success 		- Returns the size of the file in bytes.
;				   Failure		- Returns 0 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									1 = given path doesn't exist (result = Files not deleted)
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Remarks .......: Divide result by 1024 to get kilobyte equivalent, or divide by 1048576 to get megabyte equivalent.
; Related .......:
; Link ..........:
; Example .......: _FileSequence_GetSize ( "C:\images\Image_####.tga" )
; ===============================================================================================================================
Func _FileSequence_GetSize($sFileSequencePath)
	Local $sequence_path_ready = StringReplace($sFileSequencePath, "#", "*")
	If @extended = 0 Then Return SetError(1, 0, 0)
	Local $search = FileFindFirstFile($sequence_path_ready)
	If $search = -1 Then Return SetError(1, 0, 0)

	Local $iSize = 0
	While 1
		Local $file = FileFindNextFile($search)
		If @error Then
			FileClose($search)
			Return $iSize
		EndIf

		Local $sPath = StringTrimRight($sFileSequencePath, StringLen($file)) & $file
		$iSize += FileGetSize($sPath)
	WEnd
EndFunc   ;==>_FileSequence_GetSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_GetImageDimensions
; Description ...: Get the image dimension for the given file sequence
; Syntax ........: _FileSequence_GetImageDimensions ( $sPath )
; Parameters ....: $sPath		- A string file sequence where ### equals the file numbering or a normal image path
; Return values .: Success 		- Returns $Ret : Array holding the frame size
;										  $Ret[0] Image Size X (Width) (in pixels)
;										  $Ret[1] Image Size Y (Height) (in pixels)
;				   Failure		- Returns an array $Ret[0] = -1 and $Ret[1] = -1 and sets @error
;									1 = Path doesn't exist
;									2 = GDIStartup didn't start
;									3 = File type not supported
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: Only works with Bitmap types: BMP, PNG, GIF, JPEG, TIFF, ICO, EXIF
;					For other formats I suggest using the UDF FreeImage from Floris van den Berg and Hervé Drolon
; Related .......:
; Link ..........:
; Example .......: _FileSequence_GetImageDimensions ( "C:\images_####.jpg" ) Returns $ret[0]=1280 , $ret[1]=720
; ===============================================================================================================================
Func _FileSequence_GetImageDimensions($sPath)

	If ___FS_IsFileSequence($sPath) Then
		Local $aRange = _FileSequence_GetRange($sPath)
		If @error Then Return SetError(1, 0, 0)
		$sPath = _FileSequence_FSToRegExp($sPath)
		$sPath = StringFormat($sPath, $aRange[0])
	EndIf

	;Declare an array holding the default return values:
	Local $Ret[2]
	$Ret[0] = -1
	$Ret[1] = -1

	;Path Check (Return @error = 1 if path doesn't exist):
	If Not FileExists($sPath) Then Return SetError(1, 0, $Ret)

	;Start GDI plus and get the frame size (Return @error = 2 if GDI didn't start):
	Local $fGDIStart = _GDIPlus_Startup()
	If Not $fGDIStart Then Return SetError(2, 0, $Ret)

	Local $hImage = _GDIPlus_ImageLoadFromFile($sPath)
	Local $iFileType = _GDIPlus_ImageGetType($hImage)
	If $iFileType = $GDIP_IMAGETYPE_UNKNOWN Or $iFileType = $GDIP_IMAGETYPE_METAFILE Then Return SetError(3, 0, $Ret)
	$Ret[0] = _GDIPlus_ImageGetWidth($hImage)
	$Ret[1] = _GDIPlus_ImageGetHeight($hImage)
	If $Ret[0] = 0 Or $Ret[1] = 0 Then
		$Ret[0] = -1
		$Ret[1] = -1
		Return SetError(3, 0, $Ret)
	EndIf
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()

	Return $Ret
EndFunc   ;==>_FileSequence_GetImageDimensions


; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_Convert
; Description ...: Convert the given file sequence to desired output
; Syntax ........: _FileSequence_Convert ( $sFileSequencePath , $sFormat )
; Parameters ....: $sFileSequencePath		- A string file sequence where ### equals the file numbering
;                  $sFormat					- String extenstion name ( without preceding '.' )
;                  							= jpg tga tif png ...etc...
;                  $sOutputPath				- String Path to output
;                  $fCreateOutput			- true = (default) do not create output dir
;                  $fRemoveOld				- false = (default) do not remove old sequence
; Return values .: Success 		- Returns the output of the new File sequence in FileSequence format where ### equals the file numbering
;				   Failure		- Returns 0 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = Output doesn't exist ( use $fCreateOutput = True to create ouptut) or $sOutputDir isn't a string
;									3 = Return 1 = Convert done but couldn't remove original folder
;									4 = Irfan View couldn't be found
;									5 = $sFormat isn't a string
;									6 = $fCreateOutput isn't a Bool
;									7 = $fRemoveOld isn't a Bool
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Remarks .......: Uses Irfan View. Iview should be placed at @scriptdir & "\IrfanView
; Related .......:
; Link ..........:
; Example .......: _FileSequence_Convert ( "C:\images\Image_####.tga" , "jpg" , _FileSequence_GetParentFolder ( "C:\images\Image_####.tga" ) & "\Convertion" , true )
; ===============================================================================================================================
Func _FileSequence_Convert($sFileSequencePath, $sFormat, $sOutputDir, $fCreateOutput = True, $fRemoveOld = False)

	;Error Checking
	If Not IsString($sFileSequencePath) Then Return SetError(1, 0, -1)
	If Not IsString($sFormat) Then Return SetError(5, 0, -1)
	If Not IsString($sOutputDir) Then Return SetError(2, 0, -1)
	If Not IsBool($fCreateOutput) Then Return SetError(6, 0, -1)
	If Not IsBool($fRemoveOld) Then Return SetError(7, 0, -1)


	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, -1)

	;Convert the path to wildcard, if error the return
	Local $sSequence_path_ready = StringReplace($sFileSequencePath, "#", "*")
	If @extended = 0 Then Return SetError(1, 0, 0)

	;check Format
	If StringLeft($sFormat, 1) = "." Then StringTrimLeft($sFormat, 1)

	;Check ouptut directory
	$sOutputDir = StringReplace($sOutputDir, "/", "\")
	If StringRight($sOutputDir, 1) = "\" Then $sOutputDir = StringTrimRight($sOutputDir, 1)
	If Not FileExists($sOutputDir) And $fCreateOutput Then
		DirCreate($sOutputDir)
	Else
		SetError(2, 0, 0)
	EndIf

	;Get FileName
	Local $sFileName = _FileSequence_GetFileName($sSequence_path_ready)
	If Not $sFileName Then Return SetError(1, 0, 0)

	;Build the output path
	$sOutputDir &= "\" & $sFileName & "." & $sFormat

	;Irfan View Path
	Local $sIViewPath = $___PathIrfanView
	If Not FileExists($sIViewPath) Then Return SetError(4, 0, 0)

	Local $PID = RunWait(@ComSpec & " /c " & $sIViewPath & " " & $sSequence_path_ready & " /convert=" & $sOutputDir, "", @SW_HIDE)
	If Not @error Then
		If $fRemoveOld And (Not _FileSequence_Delete($sFileSequencePath)) Then
			ProcessClose($PID)
			Return SetError(3, 0, 1)
		EndIf

		;Convert finished not problem
		ProcessClose($PID)
		$sOutputDir = StringReplace($sOutputDir, "*", "#")
		Return $sOutputDir
	Else
		ProcessClose($PID)
		Return SetError(2, 0, 0)
	EndIf

EndFunc   ;==>_FileSequence_Convert

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_Move
; Description ...: Move the given file sequence to another folder
; Syntax ........: _FileSequence_Move ( $sFileSequencePath , $sDestinationDir , $iFlag )
; Parameters ....: $sFileSequencePath		- A string file sequence where ### equals the file numbering
;                  $sDestinationDir			- A string file sequence where ### equals the file numbering
;                  $iFlag					- 0 = (default) do not overwrite existing files
;											  1 = overwrite existing files
;											  8 = Create destination directory structure if it doesn't exist (See Remarks).
; Return values .: Success 		- Returns 1
;				   Failure		- Returns 0 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = $sDestinationDir path doesn't exist or source couldn't be moved or Iflag = 0 and file existed already (result = Files not moved)
;									3 = $sDestinationDir isn't a directory (result = Files not moved)
;									4 = $iFlag isn't an integer or wrong Iflag (See filemove) (result = Files not moved)
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_Move ( "C:\images\Image_####.tga" , "C:\images\Old" , 1+8 )
; ===============================================================================================================================
Func _FileSequence_Move($sFileSequencePath, $sDestinationDir, $iFlag = 0)

	;Error Checking
	If Not IsString($sFileSequencePath) Then Return SetError(1, 0, 0)
	If Not IsString($sDestinationDir) Then Return SetError(3, 0, 0)
	If Not IsInt($iFlag) Then Return SetError(4, 0, 0)

	;Convert slashes
	$sDestinationDir = StringReplace($sDestinationDir, "/", "\")
	;Check if path contains or not a backslash at the end
	If StringRight($sDestinationDir, 1) <> "\" Then $sDestinationDir &= "\"

	;Create Destination Directory if requested
	If $iFlag >= 8 Then DirCreate($sDestinationDir)

	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, 0)
	;return @error=2 if $sDestinationDir doesn't exist
	If Not FileExists($sDestinationDir) Then Return SetError(2, 0, 0)
	;return @error=3 if $sDestinationDir isn't a directory
	If Not FileGetAttrib($sDestinationDir) = 'D' Then Return SetError(3, 0, 0)
	;return @error=4 if Wrong Iflag
	If $iFlag <> 0 And $iFlag <> 1 And $iFlag <> 8 And $iFlag <> 9 Then Return SetError(4, 0, 0)


	;return @error=1 if $sFileSequencePath couldn't be converted to wildcard
	Local $sequence_path_ready = StringReplace($sFileSequencePath, "#", "*")
	If @extended = 0 Then Return SetError(1, 0, 0)


	If FileMove($sequence_path_ready, $sDestinationDir, $iFlag) = 1 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf

EndFunc   ;==>_FileSequence_Move

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_GetFileName
; Description ...: Return the filename and file numbering (without extension and dot)
; Syntax ........: _FileSequence_GetFileName ( $sFileSequencePath )
; Parameters ....: $sFileSequencePath		- A string file sequence where ### equals the file numbering
; Return values .: Success 		- Returns File Name
;				   Failure		- Returns "" and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_GetFileName ( "C:\images\Image_####.tga" ) = Returns : Image_####
; ===============================================================================================================================
Func _FileSequence_GetFileName($sFileSequencePath)

	;Error Checking
	If Not IsString($sFileSequencePath) Then Return SetError(1, 0, "")

	Local $aFileSplit = StringSplit($sFileSequencePath, ".")
	If @error Then Return SetError(1, 0, "")
	Local $iFileExtLen = StringLen($aFileSplit[$aFileSplit[0]])
	Local $aFileSplit = StringSplit($sFileSequencePath, "\")
	If @error Then Return SetError(1, 0, "")
	Local $sFileName = StringTrimRight($aFileSplit[$aFileSplit[0]], $iFileExtLen + 1)

	Return $sFileName

EndFunc   ;==>_FileSequence_GetFileName

; #FUNCTION# ====================================================================================================================
; Name ..........: ; _FileSequence_Rename
; Description ...: Move the given file sequence to another folder
; Syntax ........: _FileSequence_Rename ( $sFileSequencePath , $sNewName , $iFlags = 0 )
; Parameters ....: 	$sFileSequencePath		- A string file sequence where ### equals the file numbering
;                  	$sNewName				- A string New file name followed by ### representing the number of zero desired
;                  	$iFlag					- 0 = (default) do not overwrite existing files
;											  1 = overwrite existing files
;											  8 = Create destination directory structure if it doesn't exist (See Remarks).
;					$iStartNumber			- Integer number to start the file numbering. Default (-1) uses the original file numbering.
; Return values .: Success 		- Returns FileSequence string of the new renamed file
;				   Failure		- Returns 0 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = $sNewName isn't a string
;									3 = $sNewName doesn't have the proper ### representing the file numbers or have less numbers than final frame
;									4 = $iFlag isn't an integer or wrong Iflag (See filemove) (result = Files not moved)
;									5 = source cannot be moved or if dest already exists and flag=0
;									6 = $iStartNumber isn't a number or error with $iStartNumber
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_Rename ( "C:\images\Image_####.tga" , "My_New_Sequence_###" , 1+8 ) = Returns "C:\images\My_New_Sequence_####.tga"
; ===============================================================================================================================
Func _FileSequence_Rename($sFileSequencePath, $sNewName, $iFlag = 0, $iStartNumber = -1)

	;Error Checking
	If Not IsString($sFileSequencePath) Then Return SetError(1, 0, 0)
	If Not IsString($sNewName) Then Return SetError(3, 0, 0)
	If Not IsNumber($iStartNumber) Then Return SetError(6, 0, 0)
	If Not IsInt($iFlag) Then Return SetError(4, 0, 0)

	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, 0)
	;return @error=4 if Wrong Iflag
	If $iFlag <> 0 And $iFlag <> 1 And $iFlag <> 8 And $iFlag <> 9 Then Return SetError(4, 0, 0)

	;return @error=1 if $sFileSequencePath couldn't be converted to wildcard
	Local $sequence_path_ready = StringReplace($sFileSequencePath, "#", "*")
	If @extended = 0 Then Return SetError(1, 0, 0)

	;Get Start Number
	Local $iEndNumber
	Local $aRange = _FileSequence_GetRange($sFileSequencePath)
	If Not IsArray($aRange) Or $aRange = -1 Then SetError(3, 0, 0)
	If $iStartNumber = -1 Then
		;Default = Get From Sequence
		$iStartNumber = $aRange[0]
		$iEndNumber = StringLen($aRange[1])
	Else
		$iEndNumber = StringLen($iStartNumber + $aRange[1])
	EndIf

	;return @error=1 if $sNewName couldn't be converted to wildcard
	$sNewName = StringReplace($sNewName, "#", "*")
	If @extended = 0 Or @extended < $iEndNumber Then Return SetError(3, 0, 0)
	Local $iFileNumberLen = @extended

	;Get Extension
	Local $aFileSplit = StringSplit($sequence_path_ready, ".")
	If @error Then Return SetError(1, 0, 0)
	Local $sFileExt = $aFileSplit[$aFileSplit[0]]

	;Get Folder
	Local $sParentFolder = _FileSequence_GetParentFolder($sFileSequencePath)
	Local $sOutputPath = $sParentFolder & "\" & $sNewName & "." & $sFileExt

	;Search for files to rename
	Local $search = FileFindFirstFile($sequence_path_ready)
	While 1
		Local $file = FileFindNextFile($search)
		If @error Then ExitLoop

		;rename files
		If FileMove($sParentFolder & "\" & $file, StringRegExpReplace($sOutputPath, "(\*{" & $iFileNumberLen & "})", StringFormat("%0" & $iFileNumberLen & "d", $iStartNumber)), $iFlag) Then
			$iStartNumber += 1
			ContinueLoop
		Else
			;if any single error then stop the whole function and return @error=5
			FileClose($search)
			Return SetError(5, 0, 0)
		EndIf
	WEnd

	;NO problems , return the sequence for the new renamed sequence
	FileClose($search)
	$sOutputPath = StringReplace($sOutputPath, "*", "#")
	Return $sOutputPath

EndFunc   ;==>_FileSequence_Rename

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_Resize
; Description ...: Convert the given file sequence to desired output
; Syntax ........: _FileSequence_Resize ( $sFileSequencePath , $iResize )
; Parameters ....: $sFileSequencePath		- A string file sequence where ### equals the file numbering
;                  $iResize_W				- String or integer Resize ex: "100" (for 100px) or "150p" (for 150%) or "150%" (for 150%)
;                  $iResize_H				- String or integer Resize ex: "100" (for 100px) or "150p" (for 150%) or "150%" (for 150%)
;                  $fKeepAspectRatio		- Bool Keep aspect ratio or not.
; Return values .: Success 		- Returns the output of the new File sequence in FileSequence format where ### equals the file numbering
;				   Failure		- Returns 0 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = Error while executing the command.
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Remarks .......: Uses Irfan View. Iview should be placed at @scriptdir & "\IrfanView
; Related .......:
; Link ..........:
; Example .......: 	_FileSequence_Resize ( "C:\images\Image_####.tga" , 1280 , 720 ) --> Resize the image sequence to 1280*720
;					_FileSequence_Resize ( "C:\images\Image_####.tga" , "50p" , "50p" ) --> Resize the image sequence at 50%
;					_FileSequence_Resize ( "C:\images\Image_####.tga" , "50%" , "50%" ) --> Resize the image sequence at 50%
; ===============================================================================================================================
Func _FileSequence_Resize($sFileSequencePath, $vResize_W, $vResize_H, $fKeepAspectRatio = True)

	;Error Checking
	If Not IsString($sFileSequencePath) Then Return SetError(1, 0, -1)


	;IrfanView uses "p" for %
	StringReplace($vResize_W, "%", "p")
	StringReplace($vResize_H, "%", "p")


	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, -1)


	;Get if the user wants to keep aspect ratio or not:
	Local $sKeepAspectRatio = ""
	If $fKeepAspectRatio Then $sKeepAspectRatio = " /aspectratio"


	;Convert the path to wildcard, if error the return
	Local $sSequence_path_ready = StringReplace($sFileSequencePath, "#", "*")
	If @extended = 0 Then Return SetError(1, 0, 0)


	;Irfan View Path
	Local $sIViewPath = $___PathIrfanView
	If Not FileExists($sIViewPath) Then Return SetError(4, 0, 0)


	;Convert:
	Local $PID = RunWait(@ComSpec & ' /c ' & $sIViewPath & ' ' & $sSequence_path_ready & ' /resize=(' & $vResize_W & "," & $vResize_H & ')' & $sKeepAspectRatio & ' /resample /convert=' & $sSequence_path_ready, "", @SW_HIDE)

	If Not @error Then
		;Convert finished not problem
		ProcessClose($PID)
		Return SetError(0, 0, 1)
	Else
		ProcessClose($PID)
		Return SetError(2, 0, 0)
	EndIf

EndFunc   ;==>_FileSequence_Resize

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileSequence_Copy
; Description ...: Copy the given file sequence to another folder
; Syntax ........: _FileSequence_Copy ( $sFileSequencePath , $sDestinationDir , $iFlag )
; Parameters ....: $sFileSequencePath		- A string file sequence where ### equals the file numbering
;                  $sDestinationDir			- A string file sequence where ### equals the file numbering
;                  $iFlag					- 0 = (default) do not overwrite existing files
;											  1 = overwrite existing files
;											  8 = Create destination directory structure if it doesn't exist (See Remarks).
; Return values .: Success 		- Returns 1
;				   Failure		- Returns 0 and sets @error
;									1 = $sFileSequencePath is not a proper file sequence string
;									2 = $sDestinationDir path doesn't exist or source couldn't be moved or Iflag = 0 and file existed already (result = Files not moved)
;									3 = $sDestinationDir isn't a directory (result = Files not moved)
;									4 = $iFlag isn't an integer or wrong Iflag (See filemove) (result = Files not moved)
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: requires a valid file sequence string where ### represents the file numbering
; Related .......:
; Link ..........:
; Example .......: _FileSequence_Copy ( "C:\images\Image_####.tga" , "C:\images\Old" , 1+8 )
; ===============================================================================================================================
Func _FileSequence_Copy($sFileSequencePath, $sDestinationDir, $iFlag = 0)

	;Convert slashes
	$sDestinationDir = StringReplace($sDestinationDir, "/", "\")
	;Check if path contains or not a backslash at the end
	If StringRight($sDestinationDir, 1) <> "\" Then $sDestinationDir &= "\"

	;Create Destination Directory if requested
	If $iFlag >= 8 Then DirCreate($sDestinationDir)

	;return @error=1 if $sFileSequencePath is not a file sequence string
	If Not ___FS_IsFileSequence($sFileSequencePath) Then Return SetError(1, 0, 0)
	;return @error=2 if $sDestinationDir doesn't exist
	If Not FileExists($sDestinationDir) Then Return SetError(2, 0, 0)
	;return @error=3 if $sDestinationDir isn't a directory
	If Not FileGetAttrib($sDestinationDir) = 'D' Then Return SetError(3, 0, 0)
	;return @error=4 if Wrong Iflag
	If $iFlag <> 0 And $iFlag <> 1 And $iFlag <> 8 And $iFlag <> 9 Then Return SetError(4, 0, 0)


	;return @error=1 if $sFileSequencePath couldn't be converted to wildcard
	Local $sequence_path_ready = StringReplace($sFileSequencePath, "#", "*")
	If @extended = 0 Then Return SetError(1, 0, 0)

	If FileCopy($sequence_path_ready, $sDestinationDir, $iFlag) = 1 Then
		Return SetError(0, 0, 1)
	Else
		Return SetError(2, 0, 0)
	EndIf

EndFunc   ;==>_FileSequence_Copy





; #INTERNAL_USE_ONLY#============================================================================================================
;================================================================================================================================
;================================================================================================================================
;================================================================================================================================
;================================================================================================================================




; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: ___FS_Process_File
; Description ...: Find Frame Numbers and Replace with ####
; Syntax ........: ___FS_Process_File ( $file_path , ByRef $aPaths , $sFilter )
; Return values .: Success 		- Returns $file_path_ready
;				   Failure		- Returns @error
;									1 = Path already added
;									2 = File doesn't match Filter
;									3 = File isn't part of a file sequence
;									4 = File Doesn't have proper frame numbers
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func ___FS_Process_File($file_path, ByRef $aPaths, $sFilter)

	;NEED TO CHECK FOR DOUBLES BEFORE PROCESSING
	If ___FS_IsAlreadyAdded($file_path, $aPaths) Then
		Return SetError(1, 0, -1) ;"Skip"
	EndIf

	Local $frame_number_length, $frame_number_replace, $file_path_ready
	Local $file_infos[1]
	Local $file_path_ready = ""

	Local $file_path_elem = StringSplit($file_path, ".")

	;Check if file type is image
	If StringInStr($sFilter, $file_path_elem[$file_path_elem[0]], 0) = 0 Then
		Return SetError(2, 0, -1) ;"Error - This file doesnt seem to be a proper image"
	EndIf

	Local $file_path_lastelem = $file_path_elem[($file_path_elem[0] - 1)]

	;If the frame number are in between 2 points
	If StringIsDigit($file_path_lastelem) = 1 Then

		;get length of frame numbering
		$frame_number_length = StringLen($file_path_lastelem)

		;Check for length of frame number, only 1 will cancel (consider file sequence with only 3 file numbering or more)
		If $frame_number_length < 3 Then
			Return SetError(4, 0, -1) ;"Error - This file doesnt seem to have proper Frame Numbers"
		EndIf

		;Create the replacement string
		For $fn = 1 To $frame_number_length
			$frame_number_replace &= "#"
		Next

		;Recreate the Path
		For $pe = 1 To ($file_path_elem[0] - 2)
			$file_path_ready &= $file_path_elem[$pe] & "."
		Next

		;add frame numbers in format #n
		$file_path_ready &= $frame_number_replace

		;add file extension
		$file_path_ready &= "." & $file_path_elem[$file_path_elem[0]]

		;If Frame Numbers are at the end of a normal string
	ElseIf StringIsDigit(StringRight($file_path_lastelem, 1)) = 1 Then

		;Find How many numbers at the end (check up to 20 digits queued)
		For $fn = 1 To 20
			If StringIsDigit(StringRight($file_path_lastelem, $fn)) = 0 Then
				$frame_number_length = $fn - 1
				ExitLoop
			EndIf
		Next

		;Check for length of frame number, only 1 will cancel
		If $frame_number_length < 3 Then
			Return SetError(4, 0, -1) ;"Error - This file doesnt seem to have proper Frame Numbers"
		EndIf

		;Create the replacement string
		For $fn = 1 To $frame_number_length
			$frame_number_replace &= "#"
		Next

		;Recreate the Path
		For $pe = 1 To ($file_path_elem[0] - 2)
			$file_path_ready &= $file_path_elem[$pe] & "."
		Next

		$file_path_ready &= StringTrimRight($file_path_lastelem, $frame_number_length) & $frame_number_replace
		$file_path_ready &= "." & $file_path_elem[$file_path_elem[0]]
	EndIf


	If ___FS_IsFileSequence($file_path_ready) Then
		;EVERYTHING GOOD, NO Error found, return the result
		$aPaths[0] += 1
		ReDim $aPaths[$aPaths[0] + 1]
		$aPaths[$aPaths[0]] = $file_path_ready
		Return $file_path_ready
	Else
		;Not a file sequence
		Return SetError(3, 0, -1) ;"Error - File is not part of a sequence"
	EndIf
	;Path didnt match any criteria, seems not good, returning error
	Return SetError(4, 0, -1) ;"Error - This file doesnt seem to have proper Frame Numbers"

EndFunc   ;==>___FS_Process_File

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: ___FS_Process_Folder
; Description ...: Process a path and find sequences within
; Syntax ........: ___FS_Process_Folder ( $folder_path , ByRef $aPaths , $fRecursive , $sFilter )
; Parameters ....: None
; Return values .: Success 		- Returns 1
;				   Failure		- Doesn't fail
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func ___FS_Process_Folder($folder_path, ByRef $aPaths, $fRecursive, $sFilter)
	Local $search, $file, $bIsFolder = 0
	$search = FileFindFirstFile($folder_path & "\*.*")
	While 1
		$file = FileFindNextFile($search)
		$bIsFolder = @extended
		If @error Then ExitLoop
		If $bIsFolder And $fRecursive Then ; If directory item is a directory, and if user specified recursive=true then go one level deeper
			___FS_Process_Folder($folder_path & "\" & $file, $aPaths, $fRecursive, $sFilter)
		Else
			___FS_Process_File($folder_path & "\" & $file, $aPaths, $sFilter)
		EndIf
	WEnd
	FileClose($search)
	Return 1
EndFunc   ;==>___FS_Process_Folder

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: ___FS_IsAlreadyAdded
; Description ...: Check if the file sequence has already been added or not
; Syntax ........: ___FS_IsAlreadyAdded ( $search_path , ByRef $aPaths )
; Parameters ....: None
; Return values .: Success 		- Returns true (Sequence was already added)
;				   Failure		- Returns false (Sequence wasn't found)
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func ___FS_IsAlreadyAdded($search_path, ByRef $aPaths)
	Local $search_string, $search
	If $aPaths[0] = 0 Then Return False ;Return False No sequence existing
	For $s = 1 To $aPaths[0]
		$search_string = StringSplit($aPaths[$s], "#")
		$search = StringInStr($search_path, $search_string[1], 0)
		If $search <> 0 Then
			Return True ;Return True (file sequence was already found)
		EndIf
	Next
	Return False ;Return False when we DID NOT FIND ANYTHING (sequence wasn't added)
EndFunc   ;==>___FS_IsAlreadyAdded

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: ___FS_IsFileSequence
; Description ...: Check if the given path is a file sequence or not
; Syntax ........: ___FS_IsFileSequence ( $sequence_path )
; Parameters ....: None
; Return values .: Success 		- Returns True ($sequence_path is a file sequence)
;				   Failure		- Returns false ($sequence_path isn't a file sequence)
; Author(s) .....: Julien Vanhoenacker, Joaquim Montserrat
; Modified ......:
; Remarks .......: Returns False in case less than 2 files were found (not file sequence)
; Related .......:
; Link ..........:
; Example .......: ___FS_IsFileSequence ( "C:\Images\Image_###.tga" ) )
; ===============================================================================================================================
Func ___FS_IsFileSequence($sequence_path)
	Local $sequence_path_ready = StringReplace($sequence_path, "#", "*")
	If @extended = 0 Then Return False
	Local $search = FileFindFirstFile($sequence_path_ready)
	If $search = -1 Then Return False

	Local $filefound = 0
	While 1
		Local $file = FileFindNextFile($search)
		$filefound += 1

		If $filefound > 2 Then
			FileClose($search)
			Return True
		EndIf
		If @error Then
			FileClose($search)
			Return False
		EndIf
	WEnd
EndFunc   ;==>___FS_IsFileSequence



