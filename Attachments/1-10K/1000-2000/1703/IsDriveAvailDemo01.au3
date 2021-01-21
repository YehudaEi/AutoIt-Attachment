;IsDriveAvailDemo01
#include <Array.au3>
#include <GUIConstants.au3>

Dim $FALSE = 0
Dim $TRUE = 1
Dim $NICConnected
Dim $MappingInQ = "\\Tcsrv\S"

Func SOff()
	RunWait("ipconfig /release", "c:/", @SW_HIDE)
	ProcessWaitClose("ipconfig.exe")
	Return $FALSE
EndFunc   ;==>SOff

Func SOn()
	RunWait("ipconfig /renew", "c:/", @SW_HIDE)
	ProcessWaitClose("ipconfig.exe")
	Return $TRUE
EndFunc   ;==>SOn

;^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v

Func O2clams()
	Return FileExists($MappingInQ)
EndFunc   ;==>O2clams
;^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v

Func jdickens()
	$SFound = $FALSE  ;jdickens
	$AllDrives = DriveGetDrive( "all")
	_ArraySort($AllDrives)
	If Not @error Then
		For $i = 1 To $AllDrives[0]
			$AllDrives[$i] = StringUpper($AllDrives[$i])
		Next
		$IndexOfSFound = _ArrayBinarySearch($AllDrives, "S:", 1)
		If $IndexOfSFound = "" And (@error = 0) Then
			$SFound = $FALSE
		    ;MsgBox(0,"","Not Found" & $IndexOfSFound & " " & @error)
		Else
			If $IndexOfSFound > 0 And (@error = 0) Then
				$SFound = $TRUE
		        ;MsgBox(0,"","Found" & $IndexOfSFound & " " & @error)
			EndIf
		EndIf
		Return $SFound
	EndIf
EndFunc   ;==>jdickens
;^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v

Func MappedDriveOnline($drive)  ;Ejoc
	;    MsgBox(0, "", DriveSpaceFree($drive))
	DriveSpaceFree($drive)
	If (@error = 1) And DriveSpaceFree($drive) = 1 Then
		Return $FALSE
	Else
		IF (@error <> 1) And DriveSpaceFree($drive) > 0 Then
			Return $TRUE
		EndIf
	EndIf
EndFunc   ;==>MappedDriveOnline
;^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v

Func CyberSlugOn()
	Return (DriveMapGet("S:") = $MappingInQ)
EndFunc   ;==>CyberSlugOn
;^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v

Func CyberSlugOff()
	Return (DriveMapGet("S:") = "") And (@error = 1)
EndFunc   ;==>CyberSlugOff
;^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v

Func BlueDrache()
	Return FileExists("S:\DontDelete.txt")
EndFunc   ;==>BlueDrache
;^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v^v

$O2clamsSOff = 0
$jdickensSOff = 0
$MappedDriveOnlineSOff = 0
$CyberSlugSOff = 0
$BlueDracheSOff = 0

$O2clamsSOn = 0
$jdickensSOn = 0
$MappedDriveOnlineSOn = 0
$CyberSlugSOn = 0
$BlueDracheSOn = 0

$NumOTries = 1
GUICreate("IsDriveAvail Results")
$mylist = GUICtrlCreateList("", 20, 20, 340, 200)
GUISetState()

For $Tries = 1 To $NumOTries
	$NICConnected = SOff()
	If $NICConnected = O2clams() Then
		$O2clamsSOff = $O2clamsSOff + 1
	EndIf
	
	If $NICConnected = jdickens() Then
		$jdickensSOff = $jdickensSOff + 1
	EndIf
	
	If $NICConnected = MappedDriveOnline("S:\") Then
		$MappedDriveOnlineSOff = $MappedDriveOnlineSOff + 1
	EndIf
	
	If $NICConnected = CyberSlugOff() Then
		$CyberSlugSOff = $CyberSlugSOff + 1
	EndIf
	
	If $NICConnected = BlueDrache() Then
		$BlueDracheSOff = $BlueDracheSOff + 1
	EndIf
	
	
	$NICConnected = SOn()
	If $NICConnected = O2clams() Then $O2clamsSOn = $O2clamsSOn + 1
	
	
	If $NICConnected = jdickens() Then $jdickensSOn = $jdickensSOn + 1
	
	
	If $NICConnected = MappedDriveOnline("S:\") Then $MappedDriveOnlineSOn = $MappedDriveOnlineSOn + 1
	
	
	If $NICConnected = CyberSlugOn() Then $CyberSlugSOn = $CyberSlugSOn + 1
	
	
	If $NICConnected = BlueDrache() Then $BlueDracheSOn = $BlueDracheSOn + 1
	
	GUICtrlSetData($mylist, "")
	GUICtrlSetData($mylist, "$O2clamsSOff, " & $O2clamsSOff & "|")
	GUICtrlSetData($mylist, "$jdickensSOff, " & $jdickensSOff & "|")
	GUICtrlSetData($mylist, "$MappedDriveOnlineSOff, " & $MappedDriveOnlineSOff & "|")
	GUICtrlSetData($mylist, "$CyberSlugSOff, " & $CyberSlugSOff & "|")
	GUICtrlSetData($mylist, "$BlueDracheSOff, " & $BlueDracheSOff & "|")
	
	GUICtrlSetData($mylist, "$O2clamsSOn, " & $O2clamsSOn & "|")
	GUICtrlSetData($mylist, "$jdickensSOn, " & $jdickensSOn & "|")
	GUICtrlSetData($mylist, "$MappedDriveOnlineSOn, " & $MappedDriveOnlineSOn & "|")
	GUICtrlSetData($mylist, "$CyberSlugSOn, " & $CyberSlugSOn & "|")
	GUICtrlSetData($mylist, "$BlueDracheSOn, " & $BlueDracheSOn & "|")
	GUISetState()
	
Next
GUICtrlSetData($mylist, "")
GUICtrlSetData($mylist, "$O2clamsSOff, " & $O2clamsSOff & "|")
GUICtrlSetData($mylist, "$jdickensSOff, " & $jdickensSOff & "|")
GUICtrlSetData($mylist, "$MappedDriveOnlineSOff, " & $MappedDriveOnlineSOff & "|")
GUICtrlSetData($mylist, "$CyberSlugSOff, " & $CyberSlugSOff & "|")
GUICtrlSetData($mylist, "$BlueDracheSOff, " & $BlueDracheSOff & "|")

GUICtrlSetData($mylist, "$O2clamsSOn, " & $O2clamsSOn & "|")
GUICtrlSetData($mylist, "$jdickensSOn, " & $jdickensSOn & "|")
GUICtrlSetData($mylist, "$MappedDriveOnlineSOn, " & $MappedDriveOnlineSOn & "|")
GUICtrlSetData($mylist, "$CyberSlugSOn, " & $CyberSlugSOn & "|")
GUICtrlSetData($mylist, "$BlueDracheSOn, " & $BlueDracheSOn & "|")
GUISetState()

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
	$msg = GUIGetMsg()
	Sleep(100)
	
WEnd
Exit