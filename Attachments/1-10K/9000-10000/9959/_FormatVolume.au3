;===============================================================================
;
; Function Name:	_FormatVolume()
; Description:		Format a volume with multiple parameter options
; Parameter(s):		$s_Computer	- Specifies the computer to perform the format operation
;					$s_Drive	- Specifies the drive letter to format (e.g. D:)
;					$s_Label	- Optional: specifies the label to get the formated drive
;									"" = (Default) Blank volume label
;					$s_FS		- Optional: specifies file system
;									fat = format drive using the fat file system
;									fat32 = format drive using the fat32 file system
;									ntfs = (Default) format drive with ntfs
;					$b_Quick	- Optional: specifies whether to use quick formatting
;									0 = (Default) do not use quick formatting
;									1 = use quick formatting
;					$i_ClusterSize	- Optional: specifies allocation unit size
;									"" = (Default) windows picks default based on the size of the volume
;									512 = 512 bytes
;									1024 = 1024 bytes
;									2048 = 2048 bytes
;									4096 = 4096 bytes
;					$b_Compress	- Optional: specifies whether to use volume compression
;									0 = (Default) do not use compression
;									1 = use compression
; Requirement(s):	AutoIt3 Beta with COM support (post 3.1.1), Windows Server "Longhorn" or Windows Server 2003
; Remark(s):		http://msdn.microsoft.com/library/default.asp?url=/library/en-us/wmisdk/wmi/format_method_in_class_win32_volume.asp
; Return Value(s):	On Success	- Returns 1
;					On Failure	- Returns 0 and sets @ERROR
;					@ERROR	- 0 = No Error
;							- 1 = Volume not found
;							- 2 = Error formatting volume
;							- 3 = Invalid parameter
; Author(s):		big_daddy
;
;===============================================================================
;
Func _FormatVolume($s_Computer, $s_Drive, $s_Label = "", $s_FS = "NTFS", $b_Quick = 0, $i_ClusterSize = "", $b_Compress = 0)
	
	Switch $b_Quick
		Case 0
			$b_Quick = False
		Case 1
			$b_Quick = True
		Case Else
			SetError(3)
			Return 0
	EndSwitch
	
	Switch $b_Compress
		Case 0
			$b_Compress = False
		Case 1
			$b_Compress = True
		Case Else
			SetError(3)
			Return 0
	EndSwitch
	
	$oWMI = ObjGet("winmgmts:\\" & $s_Computer & "\root\cimv2")
	$colVol = $oWMI.ExecQuery ("select * from Win32_Volume where Name = '" & $s_Drive & "\\'")
	If $colVol.Count <> 1 Then
		SetError(1)
		Return 0
	Else
		For $oVol In $colVol
			$i_RC = $oVol.Format ($s_FS, $b_Quick, $i_ClusterSize, $s_Label, $b_Compress)
			If $i_RC <> 0 Then
				SetError(2)
				Return 0
			Else
				Return 1
			EndIf
		Next
	EndIf
	
EndFunc   ;==>_FormatVolume