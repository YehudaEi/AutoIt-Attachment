#include <WinAPI.au3>



#CS List of Functions
	_IMAPI2_AddFileToFS				(15/8-08)
	_IMAPI2_AddFolderToFS			(16/6-08)
	_IMAPI2_BurnFSToDrive			(16/6-08)
	_IMAPI2_BurnImageToDrive		(15/8-08)
	_IMAPI2_CreateFSForDrive		(16/6-08)
	_IMAPI2_CreateFSForMedia		(14/8-08)
	_IMAPI2_CreateDirectoryInFS		(06/6-09)
	_IMAPI2_DriveClose				(16/6-08)
	_IMAPI2_DriveEject				(16/6-08)
	_IMAPI2_DriveEraseDisc			(16/6-08)
	_IMAPI2_DriveGetLetter			(16/6-08)
	_IMAPI2_DriveGetMedia			(16/6-08)
	_IMAPI2_DriveGetObj				(16/6-08)
	_IMAPI2_DriveGetProductId		(20/6-09)
	_IMAPI2_DriveGetSpeeds			(08/7-08)
	_IMAPI2_DriveGetSupportedMedia	(14/8-08)
	_IMAPI2_DriveMediaIsBlank		(14/8-08)
	_IMAPI2_DrivesGetID				(16/6-08)
	_IMAPI2_DriveGetVendorId		(20/6-09)
	_IMAPI2_FSCountDirectories		(15/8-08)
	_IMAPI2_FSCountFiles			(15/8-08)
	_IMAPI2_FSItemExists			(15/8-08)
	_IMAPI2_RemoveFolderFromFS		(08/7-08)
	_IMAPI2_RemoveFileFromFS		(06/6-09)
	_IMAPI2_DriveMediaFreeSpace		(15/8-08)
	_IMAPI2_DriveMediaTotalSpace	(15/8-08)
	_IMAPI2_WaveIsValid				(10/9-08)
#CE



Global $IMAPI2_Error = ObjEvent("AutoIt.Error", "_IMAPI2_COM_Error")
Global $IMAPI2_ErrorCode
Global $IMAPI2_UserCallback

#Region IMAPI2 Constants
Global Const $IMAPI_MEDIA_TYPE_UNKNOWN = 0x00
Global Const $IMAPI_MEDIA_TYPE_CDROM = 0x01
Global Const $IMAPI_MEDIA_TYPE_CDR = 0x02
Global Const $IMAPI_MEDIA_TYPE_CDRW = 0x03
Global Const $IMAPI_MEDIA_TYPE_DVDROM = 0x04
Global Const $IMAPI_MEDIA_TYPE_DVDRAM = 0x05
Global Const $IMAPI_MEDIA_TYPE_DVDPLUSR = 0x06
Global Const $IMAPI_MEDIA_TYPE_DVDPLUSRW = 0x07
Global Const $IMAPI_MEDIA_TYPE_DVDPLUSR_DUALLAYER = 0x08
Global Const $IMAPI_MEDIA_TYPE_DVDDASHR = 0x09
Global Const $IMAPI_MEDIA_TYPE_DVDDASHRW = 0x0A
Global Const $IMAPI_MEDIA_TYPE_DVDDASHR_DUALLAYER = 0x0B
Global Const $IMAPI_MEDIA_TYPE_DISK = 0x0C
Global Const $IMAPI_MEDIA_TYPE_DVDPLUSRW_DUALLAYER = 0x0D
Global Const $IMAPI_MEDIA_TYPE_HDDVDROM = 0x0E
Global Const $IMAPI_MEDIA_TYPE_HDDVDR = 0x0F
Global Const $IMAPI_MEDIA_TYPE_HDDVDRAM = 0x10
Global Const $IMAPI_MEDIA_TYPE_BDROM = 0x11
Global Const $IMAPI_MEDIA_TYPE_BDR = 0x12
Global Const $IMAPI_MEDIA_TYPE_BDRE = 0x13
Global Const $IMAPI_MEDIA_TYPE_MAX = 0x13

Global Const $IMAPI_SECTOR_SIZE = 2048
Global Const $IMAPI_SECTORS_PER_SECOND_AT_1X_CD = 75
Global Const $IMAPI_SECTORS_PER_SECOND_AT_1X_DVD = 680
#EndRegion IMAPI2 Constants




; #FUNCTION# ;===============================================================================
;
; Name...........: _IMAPI2_DrivesGetID
; Description ...: Returns the unique id for all the drives on the system
; Syntax.........: _IMAPI2_GetDrivesID()
; Parameters ....:
; Return values .: Success - An array with all the unique ids for the drives on the system (element 0 is count)
;                : Failure -
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_StartDrive
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _IMAPI2_DrivesGetID()
	Local $oDiscmaster, $iCount
	$oDiscmaster = ObjCreate("IMAPI2.MsftDiscMaster2")
	If Not IsObj($oDiscmaster) Then Return -1
	$iCount = $oDiscmaster.Count()
	Local $sArray[$iCount + 1]
	$sArray[0] = $iCount
	For $i = 1 To $iCount
		$sArray[$i] = $oDiscmaster.Item($i - 1)
	Next
	$oDiscmaster = ""
	Return $sArray
EndFunc   ;==>_IMAPI2_DrivesGetID

; #FUNCTION# ;===============================================================================
;
; Name...........: _IMAPI2_WaveIsValid
; Description ...: Checks if a wave file is valid for writing as audio track on cd-r
; Syntax.........: MAPI2_WaveIsValid($sFileName)
; Parameters ....:
; Return values .: Success - Returns true if the file is a valid 16-bit 44,1 kHz stereo track
;                : Failure - False
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _IMAPI2_WaveIsValid($sFileName)
	Local $NULL
	Local $hFileHandle
	Local $WAVE_HEADER = DllStructCreate("char ChunkID[4];int ChunkSize;char Format[4];char Subchunk1ID[4];" & _
			"int Subchunk1Size;short AudioFormat;short NumChannels;int SampleRate;" & _
			"int ByteRate;short BlockAlign;short BitsPerSample;char Subchunk2ID[4];" & _
			"int Subchunk2Size")
	$hFileHandle = _WinAPI_CreateFile($sFileName, 2, 2, 2)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "ChunkID"), 4, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "ChunkSize"), 4, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "Format"), 4, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "Subchunk1ID"), 4, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "Subchunk1Size"), 4, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "AudioFormat"), 2, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "NumChannels"), 2, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "SampleRate"), 4, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "ByteRate"), 4, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "BlockAlign"), 2, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "BitsPerSample"), 2, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "Subchunk2ID"), 4, $NULL)
	_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($WAVE_HEADER, "Subchunk2Size"), 4, $NULL) ; 44 offset
	_WinAPI_CloseHandle($hFileHandle)
	If DllStructGetData($WAVE_HEADER, "AudioFormat") = 1 And DllStructGetData($WAVE_HEADER, "SampleRate") = 44100 And _
			DllStructGetData($WAVE_HEADER, "BitsPerSample") = 16 And DllStructGetData($WAVE_HEADER, "NumChannels") = 2 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_IMAPI2_WaveIsValid



Func _IMAPI2_BurnAudioCD($oRecorder, $aWaveFiles)
	Local $hFileHandle
	Local $NULL
	Local $hDummyStruct = DllStructCreate("byte[44]")
	Local $hWaveData
	Local $oTrackAtOnce = ObjCreate("IMAPI2.MsftDiscFormat2TrackAtOnce")
	$oTrackAtOnce.ClientName = @AutoItVersion
	$oTrackAtOnce.recorder = $oRecorder
	$oTrackAtOnce.PrepareMedia()
	For $i = 0 To UBound($aWaveFiles) - 1
		If _IMAPI2_WaveIsValid($aWaveFiles[$i]) Then
			$hFileHandle = _WinAPI_CreateFile($aWaveFiles[$i], 2, 2, 2)
			_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($hDummyStruct), 44, $NULL)
			$hWaveData = DllStructCreate("ushort[" & (FileGetSize($aWaveFiles[$i]) - 44) / 2 & "]")
			_WinAPI_ReadFile($hFileHandle, DllStructGetPtr($hWaveData), DllStructGetSize($hWaveData), $NULL)
			_WinAPI_CloseHandle($hFileHandle)
			$hFileHandle = $hFileHandle = _WinAPI_CreateFile(@TempDir & "\~raw.data", 2, 4, 4)
			_WinAPI_WriteFile($hFileHandle, DllStructGetPtr($hWaveData), DllStructGetSize($hWaveData), $NULL)
			_WinAPI_CloseHandle($hFileHandle)
		EndIf
	Next
EndFunc   ;==>_IMAPI2_BurnAudioCD






; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_DriveGetObj
; Description ...: Get the object of a drive using the unique id for the drive
; Syntax.........: _IMAPI2_DriveGetObj($sUniqueId)
; Parameters ....: $sUniqueId - Unique id for the drive to get object
; Return values .: Success - Object to the drive
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_GetDrivesID
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_DriveGetObj($sUniqueId)
	Local $oRecorder = ObjCreate("IMAPI2.MsftDiscRecorder2")
	$oRecorder.InitializeDiscRecorder($sUniqueId)
	Return $oRecorder
EndFunc   ;==>_IMAPI2_DriveGetObj



; #FUNCTION# ;===============================================================================
;
; Name...........: _IMAPI2_DriveGetMedia
; Description ...: Returns the type of media inserted in a drive
; Syntax.........: _IMAPI2_DriveGetMedia(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: Success - A code corresponding to one of the constants at the top of this UDF
;				.; Failure - -1 (Drive may not be ready!)
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_StartDrive
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _IMAPI2_DriveGetMedia(ByRef $oRecorder)
	$IMAPI2_ErrorCode = 0
	Local $oMediaObj = ObjCreate("IMAPI2.MsftDiscFormat2Data")
	Local $iCode
	$oMediaObj.recorder = $oRecorder
	$oMediaObj.ClientName = @AutoItVersion
	$iCode = Hex($oMediaObj.CurrentPhysicalMediaType())
	$oMediaObj = ""
	If $IMAPI2_ErrorCode <> 0 Then Return -1
	Return $iCode
EndFunc   ;==>_IMAPI2_DriveGetMedia


Func _IMAPI2_DriveGetSpeeds(ByRef $oRecorder)
	Local $oSpeedObj = ObjCreate("IMAPI2.MsftDiscFormat2Data")
	Local $iArray
	$oSpeedObj.recorder = $oRecorder
	$oSpeedObj.ClientName = @AutoItVersion
	$iArray = $oSpeedObj.SupportedWriteSpeeds()
	$oSpeedObj = ""
	Return $iArray
EndFunc   ;==>_IMAPI2_DriveGetSpeeds


; #FUNCTION# ;===============================================================================
;
; Name...........: _IMAPI2_DriveGetSupportedMedia
; Description ...: Returns an array of supported media, refer to the constants at the top of the UDF for information
; Syntax.........: _IMAPI2_DriveGetSupportedMedia(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: Success - An array of media constants
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_StartDrive
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _IMAPI2_DriveGetSupportedMedia(ByRef $oRecorder)
	Local $oMediaObj = ObjCreate("IMAPI2.MsftDiscFormat2Data")
	$oMediaObj.recorder = $oRecorder
	Local $iArray = $oMediaObj.SupportedMediaTypes()
	For $i = 0 To UBound($iArray) - 1
		$iArray[$i] = Hex($iArray[$i], 2)
	Next
	$oMediaObj = ""
	Return $iArray
EndFunc   ;==>_IMAPI2_DriveGetSupportedMedia


; #FUNCTION# ;===============================================================================
;
; Name...........: _IMAPI2_DriveMediaIsBlank
; Description ...: Used to check if the inserted media is blank
; Syntax.........: _IMAPI2_DriveMediaIsBlank(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: Success - True if media is blank, false otherwise.
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_StartDrive
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _IMAPI2_DriveMediaIsBlank(ByRef $oRecorder)
	Local $oMediaObj = ObjCreate("IMAPI2.MsftDiscFormat2Data")
	$oMediaObj.recorder = $oRecorder
	Local $iResult = $oMediaObj.MediaPhysicallyBlank()
	$oMediaObj = ""
	Return $iResult
EndFunc   ;==>_IMAPI2_DriveMediaIsBlank


; #FUNCTION# ;===============================================================================
;
; Name...........: _IMAPI2_DriveMediaFreeSpace
; Description ...: Gets the number of free bytes on the currently inserted media in drive
; Syntax.........: _IMAPI2_DriveMediaFreeSpace(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: Success - Number of free bytes on the inserted media
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_StartDrive
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _IMAPI2_DriveMediaFreeSpace(ByRef $oRecorder)
	Local $oMediaObj = ObjCreate("IMAPI2.MsftDiscFormat2Data")
	Local $iFreeSpace
	$oMediaObj.recorder = $oRecorder
	$iFreeSpace = $oMediaObj.FreeSectorsOnMedia() * $IMAPI_SECTOR_SIZE
	Return $iFreeSpace
EndFunc   ;==>_IMAPI2_DriveMediaFreeSpace

; #FUNCTION# ;===============================================================================
;
; Name...........: _IMAPI2_DriveMediaTotalSpace
; Description ...: Gets the total size of media in drive, in bytes
; Syntax.........: __IMAPI2_DriveMediaTotalSpace(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: Success - Number of bytes on the currently inserted media
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_StartDrive
; Link ..........;
; Example .......; No
;
; ;==========================================================================================
Func _IMAPI2_DriveMediaTotalSpace(ByRef $oRecorder)
	Local $oMediaObj = ObjCreate("IMAPI2.MsftDiscFormat2Data")
	Local $iFreeSpace
	$oMediaObj.recorder = $oRecorder
	$iFreeSpace = $oMediaObj.TotalSectorsOnMedia() * $IMAPI_SECTOR_SIZE
	Return $iFreeSpace
EndFunc   ;==>_IMAPI2_DriveMediaTotalSpace






; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_DriveGetLetter
; Description ...: Gets the letter of a drive using the object for the drive
; Syntax.........: _IMAPI2_DriveGetLetter(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: Success - Letter
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_DriveGetObj
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_DriveGetLetter(ByRef $oRecorder)
	Local $sTemp = $oRecorder.VolumePathNames
	Return StringLeft($sTemp[0], 1)
EndFunc   ;==>_IMAPI2_DriveGetLetter

; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_DriveEject
; Description ...: Ejects the tray of a drive
; Syntax.........: _IMAPI2_DriveEject(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_DriveGetObj
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_DriveEject(ByRef $oRecorder)
	$oRecorder.EjectMedia()
EndFunc   ;==>_IMAPI2_DriveEject


; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_DriveClose
; Description ...: Close the tray of a drive
; Syntax.........: _IMAPI2_DriveCLose(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_DriveGetObj
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_DriveClose(ByRef $oRecorder)
	$oRecorder.CloseTray()
EndFunc   ;==>_IMAPI2_DriveClose

; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_CreateDirectoryInFS
; Description ...: Creates a directory in the specified file system
; Syntax.........: _IMAPI2_CreateDirectoryInFS(ByRef $oFileSystem, $sDirName)
; Parameters ....: $oFileSystem - The file system
;                  $sDirName 	- Relative path in fs to the dir
; Return values .: Success - None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_CreateFSForDrive
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_CreateDirectoryInFS($oFileSystem,$sDirName)
	Local $oRootDir=$oFileSystem.Root
	$oRootDir.AddDirectory($sDirName)
EndFunc



; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_CreateFSForDrive
; Description ...: Creates a filesystem which can hold files that later can be burnt to a drive
; Syntax.........: _IMAPI2_CreateFSForDrive(ByRef $oRecorder, $sDiscname)
; Parameters ....: $oRecorder - Object of the drive
;                  $sDiscname - The name of the future disc
; Return values .: Success - A filesystem object
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_DriveGetObj
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_CreateFSForDrive(ByRef $oRecorder, $sDiscname)
	Local $oFileSystem = ObjCreate("IMAPI2FS.MsftFileSystemImage")
	$oFileSystem.ChooseImageDefaults($oRecorder)
	$oFileSystem.VolumeName = $sDiscname
	Return $oFileSystem
EndFunc   ;==>_IMAPI2_CreateFSForDrive

; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_CreateFSForMedia
; Description ...: Creates a filesystem which can hold files that later can be burnt to a drive
; Syntax.........: _IMAPI2_CreateFSForDrive(ByRef $oRecorder, $sDiscname)
; Parameters ....: $iMediaType - One of the constants defined at the top of the UDF
;                  $sDiscname - The name of the future disc
; Return values .: Success - A filesystem object
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_DriveGetObj
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_CreateFSForMedia($iMediaType, $sDiscname)
	Local $oFileSystem = ObjCreate("IMAPI2FS.MsftFileSystemImage")
	$oFileSystem.ChooseImageDefaultsForMediaType($iMediaType)
	$oFileSystem.VolumeName = $sDiscname
	Return $oFileSystem
EndFunc   ;==>_IMAPI2_CreateFSForMedia

; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_FSCountFiles
; Description ...: Counts the number of files in a filesystem
; Syntax.........: _IMAPI2_FSCountFiles(ByRef $oFileSystem)
; Parameters ....: $oFileSystem - The FS to count files in
; Return values .: Success - Number of files
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_CreateFSForMedia, _IMAPI2_CreateFSForDrive
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_FSCountFiles($oFileSystem)
	Return $oFileSystem.FileCount()
EndFunc   ;==>_IMAPI2_FSCountFiles

; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_FSCountDirectories
; Description ...: Counts the number of directories in a filesystem
; Syntax.........: _IMAPI2_FSCountDirectories(ByRef $oFileSystem)
; Parameters ....: $oFileSystem - The FS to count directories in
; Return values .: Success - Number of directories
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_CreateFSForMedia, _IMAPI2_CreateFSForDrive
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_FSCountDirectories(ByRef $oFileSystem)
	Return $oFileSystem.DirectoryCount()
EndFunc   ;==>_IMAPI2_FSCountDirectories

; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_FSItemExists
; Description ...: Checks to see if a an item in a filsystem oject exists
; Syntax.........: _IMAPI2_FSItemExists(ByRef $oFileSystem)
; Parameters ....: $oFileSystem - The FS to count files in
;				.; $sItemName - THe name of the item
; Return values .: Success - 1 if the item is a directory, 2 if the item is a file, 0 if item not found
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_CreateFSForMedia, _IMAPI2_CreateFSForDrive
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_FSItemExists(ByRef $oFileSystem, $sItemName)
	Return $oFileSystem.Exists($sItemName)
EndFunc   ;==>_IMAPI2_FSItemExists



; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_AddFolderToFS
; Description ...: Adds a folder to an existing filesystem object
; Syntax.........: _IMAPI2_AddFolderToFS(ByRef $oFileSystem, $sPath)
; Parameters ....: $oFileSystem - A filesystem object returned by _IMAPI2_CreateFSForDrive
;                  $sPath - Folder to add to the filsystem object
; Return values .: None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......: You cannot use relative paths
; Related .......: _IMAPI2_CreateFSForDrive
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_AddFolderToFS(ByRef $oFileSystem, $sPath)
	Local $oRootDir
	$oRootDir = $oFileSystem.Root
	$oRootDir.AddTree($sPath, False)
EndFunc   ;==>_IMAPI2_AddFolderToFS


; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_AddFileToFS
; Description ...: Adds a file to an existing filesystem object
; Syntax.........: _IMAPI2_AddFolderToFS(ByRef $oFileSystem, $sFileName, $sDestinationDir)
; Parameters ....: $oFileSystem - A filesystem object returned by _IMAPI2_CreateFSForDrive
;                  $sFileName - File to add to the filsystem object
;				   $sDestinationDir - Foler in the fs where the file is added
; Return values .: None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......: You cannot use relative paths
;				.: Due to how the IStream interface works the entire file is buffered into memory, therefore big files is not recomended to add with this function
; Related .......: _IMAPI2_CreateFSForDrive
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_AddFileToFS(ByRef $oFileSystem, $sFileName, $sDestinationDir)
	Local $oRootDir, $oStream
	$oRootDir = $oFileSystem.Root
	$oStream = ObjCreate("ADODB.Stream")
	$oStream.Open
	$oStream.Type = 1
	$oStream.LoadFromFile($sFileName)
	$oRootDir.AddFile($sDestinationDir, $oStream)
EndFunc   ;==>_IMAPI2_AddFileToFS



; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_RemoveFolderFromFS
; Description ...: Removes a folder from an existing filesystem object
; Syntax.........: _IMAPI2_RemoveFolderFromFS(ByRef $oFileSystem, $sPath)
; Parameters ....: $oFileSystem - A filesystem object returned by _IMAPI2_CreateFSForDrive
;                  $sPath - Folder to remove to the filsystem object
; Return values .: None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_CreateFSForDrive
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_RemoveFolderFromFS(ByRef $oFileSystem, $sPath)
	Local $oRootDir
	$oRootDir = $oFileSystem.Root
	$oRootDir.RemoveTree($sPath, False)
EndFunc   ;==>_IMAPI2_RemoveFolderFromFS

; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_RemoveFileFromFS
; Description ...: Removes a file from an existing filesystem object
; Syntax.........: _IMAPI2_RemoveFileFromFS(ByRef $oFileSystem, $sPath)
; Parameters ....: $oFileSystem - A filesystem object returned by _IMAPI2_CreateFSForDrive
;                  $sPath - File to remove to the filsystem object
; Return values .: None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _IMAPI2_CreateFSForDrive
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_RemoveFileFromFS(ByRef $oFileSystem, $sPath)
	Local $oRootDir
	$oRootDir = $oFileSystem.Root
	$oRootDir.Remove($sPath, False)
EndFunc   ;==>_IMAPI2_RemoveFolderFromFS

; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_BurnFSToDrive
; Description ...: Burns the contents of a filesystem object into a empty disc
; Syntax.........: _IMAPI2_BurnFSToDrive(ByRef $oFileSystem, ByRef $oRecorder[, $sFunction])
; Parameters ....: $oFileSystem - A filesystem object returned by _IMAPI2_CreateFSForDrive
;                  $oRecorder - A object to a drive
;                  $oFunction - Function that will be called during the burning to get the progress of the burning
; Return values .: Success - 0
;                  Failure - Error code in Hex format, check http://msdn.microsoft.com/en-us/library/aa364892(VS.85).aspx for values
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......: The callback function must take an array as parameter, this is the structure of the array:
;                  $array[0]: The current action of the drive
;                  $array[1]: Remaining time
;                  $array[2]: Elapsed time
;                  $array[3]: Total estimated time
; Related .......: _IMAPI2_CreateFSForDrive, $IMAPI2_DriveGetObj
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_BurnFSToDrive(ByRef $oFileSystem, ByRef $oRecorder, $sFunction = "")

	Local $oResult, $vStream, $iTemp
	Local $oWriter = ObjCreate("IMAPI2.MsftDiscFormat2Data")
	$oWriter.recorder = $oRecorder
	$oWriter.ClientName = @AutoItVersion
	$oResult = $oFileSystem.CreateResultImage()
	$vStream = $oResult.ImageStream
	$IMAPI2_UserCallback = $sFunction
	ObjEvent($oWriter, "_IMAPI2_")
	$oWriter.write($vStream)
	If $IMAPI2_ErrorCode Then
		$iTemp = $IMAPI2_ErrorCode
		$IMAPI2_ErrorCode = 0
		Return $iTemp
	EndIf
	$oWriter = ""
EndFunc   ;==>_IMAPI2_BurnFSToDrive

; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_BurnImageToDrive
; Description ...: Burns a image file to media in specified drive
; Syntax.........: _BurnImageToDrive(ByRef $oRecorder, $sImage[, $sFunction=""])
; Parameters ....: $oRecorder - Drive that is going to burn the image
;                  $sImage - Path to the image file
;                  $oFunction - Function that will be called during the burning to get the progress of the burning
; Return values .: Success - 0
;                  Failure - Error code in Hex format, check http://msdn.microsoft.com/en-us/library/aa364892(VS.85).aspx for values
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......: The callback function must take an array as parameter, this is the structure of the array:
;                  $array[0]: The current action of the drive
;                  $array[1]: Remaining time
;                  $array[2]: Elapsed time
;                  $array[3]: Total estimated time
;
;				   Due to how the IStream interface works the entire image is loaded into memory
; Related .......: _IMAPI2_CreateFSForDrive, $IMAPI2_DriveGetObj
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_BurnImageToDrive(ByRef $oRecorder, $sImage, $sFunction = "")
	Local $oStream, $iTemp
	Local $oWriter = ObjCreate("IMAPI2.MsftDiscFormat2Data")
	$oWriter.recorder = $oRecorder
	$oWriter.ClientName = @AutoItVersion
	$oStream = ObjCreate("ADODB.Stream")
	$oStream.Open
	$oStream.Type = 1
	$oStream.LoadFromFile($sImage)
	$IMAPI2_UserCallback = $sFunction
	ObjEvent($oWriter, "_IMAPI2_")
	$oWriter.write($oStream)
	If $IMAPI2_ErrorCode Then
		$iTemp = $IMAPI2_ErrorCode
		$IMAPI2_ErrorCode = 0
		Return $iTemp
	EndIf
	$oWriter = ""
EndFunc   ;==>_IMAPI2_BurnImageToDrive


; #FUNCTION# ====================================================================================================================
; Name...........: _IMAPI2_DriveEraseDisc
; Description ...: Erase a cd-rw or dvd-rw in the drive
; Syntax.........: _IMAPI2_AddFolderToFS(ByRef $oRecorder)
; Parameters ....: $oRecorder - The recorder in which the disc lies that will be erased
; Return values .: None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......: No progress update...yet
; Related .......: _IMAPI2_CreateFSForDrive
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _IMAPI2_DriveEraseDisc(ByRef $oRecorder)
	Local $oEraseObj = ObjCreate("IMAPI2.MsftDiscFormat2Erase")
	$oEraseObj.ClientName = @AutoItVersion
	$oEraseObj.recorder = $oRecorder
	$oEraseObj.EraseMedia()
	$oEraseObj = ""
EndFunc   ;==>_IMAPI2_DriveEraseDisc


; #FUNCTION# =====================================================================
; Name...........: _IMAPI2_DriveGetVendorId
; Description ...: Gets the VendorId of a drive using the object for the drive
; Syntax.........: _IMAPI2_DriveGetVendorId(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: Success - VendorId
; Author ........: FrouFrou
; Modified.......:
; Remarks .......: derived from Imapi2 UDFs by Andreas Karlsson (monoceres)
; Related .......: _IMAPI2_DriveGetObj
; Link ..........;
; Example .......; No
; ===============================================================================
Func _IMAPI2_DriveGetVendorId(ByRef $oRecorder)
    Local $sTemp = $oRecorder.VendorId
    Return ($sTemp)
EndFunc  ;==>_IMAPI2_DriveGetVendorId

; #FUNCTION# =====================================================================
; Name...........: _IMAPI2_DriveProductId
; Description ...: Gets the ProductId of a drive using the object for the drive
; Syntax.........: _IMAPI2_DriveProductId(ByRef $oRecorder)
; Parameters ....: $oRecorder - Object of the drive
; Return values .: Success - ProductId
; Author ........: FrouFrou
; Modified.......:
; Remarks .......: derived from Imapi2 UDFs by Andreas Karlsson (monoceres)
; Related .......: _IMAPI2_DriveGetObj
; Link ..........;
; Example .......; No
; ================================================================================
Func _IMAPI2_DriveGetProductId(ByRef $oRecorder)
    Local $sTemp = $oRecorder.ProductId
    Return ($sTemp)
EndFunc  ;==>_IMAPI2_DriveGetProductId







; Helper func, no peeking :P
Func _IMAPI2_Update($oObjThatFired, $oProgress)
	Local $vArray[4]
	$vArray[0] = $oProgress.CurrentAction
	$vArray[1] = $oProgress.RemainingTime
	$vArray[2] = $oProgress.ElapsedTime
	$vArray[3] = $oProgress.TotalTime
	If $IMAPI2_UserCallback Then
		Call($IMAPI2_UserCallback, $vArray)
	EndIf
	$oObjThatFired = ""
EndFunc   ;==>_IMAPI2_Update


; Worlds greatest error handling....NOT
Func _IMAPI2_COM_Error()
	$IMAPI2_ErrorCode = 0
	If IsObj($IMAPI2_Error) Then
		$IMAPI2_ErrorCode = Hex($IMAPI2_Error.number)
		$IMAPI2_Error.clear
	EndIf
EndFunc   ;==>_IMAPI2_COM_Error

