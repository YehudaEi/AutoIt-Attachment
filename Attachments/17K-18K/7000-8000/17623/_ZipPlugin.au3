;;_ZipPlugin.au3
;functions for _Au3ZipPlugin
#Include-Once
;;supress au3check errors
#compiler_plugin_funcs=_ZipCreate,_ZipAdd,_ZipAddDir,_ZipAddFolder,_ZipGetCount,_ZipGetItemInfo
#compiler_plugin_funcs=_ZipUnZip, _ZipUnZipItem,_ZipClose,_ZipAddFileToZip,_ZipDeleteFile,_ZipFormatMessage,_ZipPluginAbout
;==============================================================================
; AutoIt Version: 	3.2.2.0
; Language: 		English
; Author:		Stephen Podhajecki <gehossafats at netmdc dot com />
; Description: First Incarnation of a Zip plugin for AutoIt V3.
;
;This plugin adds the following commands:
;
; _ZipCreate($NewZipFile)  returns a handle to the zip.
; _ZipAdd($hFile,$SourceFile,$FileNameInsideZip) Needs handle from _ZipCreate.
; _ZipAddDir($hFile,$DirToAdd,$Recursive) Needs handle from _ZipCreate 1 use recursion 0 don't.
; _ZipAddFolder($hFile,$FolderName) Creates an empty folder in the zip Needs handle from _ZipCreate.
; _ZipFormatMessage($ErrorCode) Returns the message that corresponds with the $ErrorCode.
; _ZipClose($hFile) Closes the Zip archive.  Needs handle from _ZipCreate.
;
; _ZipUnZip($ZipFile,$Dest) UnZips the archive to the specified folder.
; _ZipUnZipItem(($ZipFile,$FileNameInsideZip,$Dest) UnZip a single file.

; _ZipGetCount($ZipFile) Retrieves the number of items in the zip
; _ZipGetItemInfo($ZipFile,$iIndex) Returns a ptr to info about a zip item.
; _ZipAddFileToZip($ZipFile,$FileToAdd,$FileNameInsideZip) adds a file to an already existing zip.
; _ZipDeleteFile($ZipFile,$FileNameInsideToDelete) Deletes a file inside the archive.
; _ZipPluginAbout() Returns "About" message string.
;
; No. there is not rar or 7zip support. Just plain old zip.
; No. there is not rar or 7zip support. Just plain old zip.
; No. there is not rar or 7zip support. Just plain old zip.
; No. there is not rar or 7zip support. Just plain old zip.
; No. there is not rar or 7zip support. Just plain old zip.
;==============================================================================
;This UDF provides the following functions to assist with the Zip Plugin functions
; _ZipItemInfo2Array($ZipFile,$Index) Returns a 1 dim array of info for a specific item.
; _ZipList2Array($ZipFile) Retrieves all item file info from zip into a 2 dim array

Global Const $ZIP_INDEX = 0
Global Const $ZIP_NAME = 1
Global Const $ZIP_ATTR = 2
Global Const $ZIP_ATIME = 3
Global Const $ZIP_CTIME = 4
Global Const $ZIP_MTIME = 5
Global Const $ZIP_CSIZE = 6
Global Const $ZIP_USIZE = 7
Global Const $ZIP_INFO_ALL = 255
Global $ZR_RECENT = 1;
ConsoleWrite($ZR_RECENT & @LF)
Local $___DBUG = 1
Local $z_v_ret, $z_x

;===============================================================================
; Function Name	:	_ZipItemInfo2Array
; Description		:	Returns and array of zip item info.
; Parameter(s)		:	$szZipFile	The zip file to get the item info from
;							$index		The index of the item to get.
;
; Requirement(s)	:	Au3Zip.dll  Autoit v3.2.2.0
; Return Value(s)	:	An Single dim Array contain the item info, error 1 and empty on fail.
; User CallTip		:
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:	This function is called by _ZipList2Array()
;===============================================================================
Func _ZipItemInfo2Array($szZipFile, $index)
	Local $z_v_ret, $strList, $zipTemp, $zipItems[8]
	If FileExists($szZipFile) Then
		If $index >= 0 Then
			If $index <= _ZipGetCount ($szZipFile) Then
				$z_v_ret = _ZipGetItemInfo ($szZipFile, $index)
				If $z_v_ret <> 0 Then
					Return _ZipGetInfoFromPtr($z_v_ret)
				EndIf
			EndIf
		EndIf
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_ZipItemInfo2Array


;===============================================================================
; Function Name	:	_ZipGetInfoFromPtr
; Description		:	
; Parameter(s)		:	$zPtr	Pointer to the zip entry struct.
;
; Requirement(s)	:	Au3Zip.dll AutoIt v3.2.20
; Return Value(s)	:	Array of zip item info, @error =1 and 0 on fail
; User CallTip		:	
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:	Called by other fuctions.
;===============================================================================
Func _ZipGetInfoFromPtr($zPtr)
;==============================================================================
;~ typedef struct
;~ { int index;                 // index of this file within the zip
;~   TCHAR name[MAX_PATH];      // filename within the zip
;~   DWORD attr;                // attributes, as in GetFileAttributes.
;~   FILETIME atime,ctime,mtime;// access, create, modify filetimes
;~   long comp_size;            // sizes of item, compressed and uncompressed. These
;~   long unc_size;             // may be -1 if not yet known (e.g. being streamed in)
;~ } ZIPENTRY;
;==============================================================================
	If $zPtr <> 0 Then
		Local $zipItems[8]
		$strList = DllStructCreate("int;char[260];dword;int64;int64;int64;long;long", $zPtr)
		For $z = 1 To 8
			Local $zipTemp = DllStructGetData($strList, $z)
			If $z > 3 And $z < 7 Then
				$zipItems[$z - 1] = _FileTime2SystemTimeZ($zipTemp)
			Else
				$zipItems[$z - 1] = $zipTemp
			EndIf
		Next
		$strList = 0
		Return $zipItems
	EndIf
EndFunc

;===============================================================================
; Function Name	:	_ZipList2Array
; Description		:	Retrieves and formats the Item Info for all items in the zip
;							into a 2 dimensional array.
; Parameter(s)		:	$szZipFile	The ZipFile to retrieve the item info from.
;
; Requirement(s)	:	Au3Zip.dll Autoit v3.2.2.0 or >
; Return Value(s)	:	2 dimensional array on success for empty string and @error =1
; User CallTip		:
; Author(s)			:	Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s)			:
;===============================================================================
Func _ZipList2Array($szZipFile)
	Local $zCount, $zipItems[1][8]
	If FileExists($szZipFile) Then
		$zCount = _ZipGetCount ($szZipFile)
		If $zCount Then
			ReDim $zipItems[$zCount][8]
			For $z_x = 0 To $zCount - 1
				Local $zipTemp = _ZipItemInfo2Array($szZipFile, $z_x)
				If Not (@error) Then
					For $z = 0 To 7
						$zipItems[$z_x][$z] = $zipTemp[$z]
					Next
				EndIf
			Next
		EndIf
		Return $zipItems
	EndIf
	Return SetError(1, 0, "")
EndFunc   ;==>_ZipList2Array
;===============================================================================
; Function Name:	_FileTime2SystemTimeZ
; Description:		Converts and formats Filetime to Systemtime.
; Parameter(s):			$file_t		64 bit filetime returned from zip archive.
; Requirement(s):
; Return Value(s):	Hopefully a nice formatted string mm/dd/yyyy hr:mim:sec[A/P]m
; User CallTip:
; Author(s):		Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s):	99% sure this is correct.
;===============================================================================
Func _FileTime2SystemTimeZ($file_t)
	Local $td, $st, $ft, $vret, $syst, $zone, $hr
	$td = "%s/%s/%s %s:%s:%s%s" ;date and time format
	If $file_t = "" Then Return
	$st = DllStructCreate("short;short;short;short;short;short;short;short")
	$ft = DllStructCreate("dword;dword")
	DllStructSetData($ft, 1, _Lo_dWordZ($file_t))
	DllStructSetData($ft, 2, _Hi_dWordZ($file_t))
	$vret = DllCall("kernel32.dll", "int", "FileTimeToSystemTime", "ptr", DllStructGetPtr($ft), "ptr", DllStructGetPtr($st))
	If IsArray($vret) Then
		$zone = "AM"
		$hr = DllStructGetData($st, 5)
		If $hr > 11 Then $zone = "PM"
		If $hr > 12 Then $hr -= 12
		
		$syst = StringFormat($td, _ZipPZ(DllStructGetData($st, 2)), _
				_ZipPZ(DllStructGetData($st, 4)), _
				DllStructGetData($st, 1), _
				_ZipPZ($hr), _
				_ZipPZ(DllStructGetData($st, 6)), _
				_ZipPZ(DllStructGetData($st, 7)), _
				$zone)
		
		;ConsoleWrite($syst&@LF)
	EndIf
	$st = 0
	$ft = 0
	Return $syst
EndFunc   ;==>_FileTime2SystemTimeZ
;===============================================================================
; Function Name:	_Hi_dWordZ
; Description:	Get Hi order 32 bits from 64 bit number
; Parameter(s):			$file_t		 filetime
; Requirement(s):
; Return Value(s):	Return Hi order 32 bits from 64 bit number
; User CallTip:
; Author(s):		Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s):			used to convert filetime to systemtime.
;===============================================================================
Func _Hi_dWordZ($file_t)
	;ConsoleWrite("Hi :"&$file_t/(2^32)&@LF)
	Return $file_t/ (2 ^ 32)
EndFunc   ;==>_Hi_dWordZ
;===============================================================================
; Function Name:	_Lo_dWordZ
; Description:		Gets low order 32 bits of 64 bit number.
; Parameter(s):			$file_t		 Filetime
; Requirement(s):
; Return Value(s):	Lo order 32 bits of 64 bit number.
; User CallTip:
; Author(s):		Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s):
;===============================================================================
Func _Lo_dWordZ($file_t)
	;ConsoleWrite("Lo:"&abs($file_t - ((2^32) * ($file_t/(2^32))))&@LF)
	Return Abs($file_t - ((2 ^ 32) * ($file_t/ (2 ^ 32))))
EndFunc   ;==>_Lo_dWordZ
;===============================================================================
; Function Name:	_ZipPZ
; Description:		adds a"0" prefix to numbers >=0 and <10
; Parameter(s):			$Value
; Requirement(s):
; Return Value(s):	Modified value.
; User CallTip:
; Author(s):		Stephen Podhajecki <gehossafats at netmdc.com/>
; Note(s):
;===============================================================================
Func _ZipPZ($Value)
	Select
		Case $Value < 0
			Return "00"
		Case $Value < 10
			Return "0" & $Value
	EndSelect
	Return $Value
EndFunc   ;==>_ZipPZ

Func _ZipGetRatio($iVal1, $iVal2)
	if $iVal2 = 0 Then Return 0
	Return Int(100-(($iVal1/$iVal2)*100))
EndFunc
	