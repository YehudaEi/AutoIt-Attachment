#include "IMAPI2.au3"

; Burns the contents of specified folder into a cd-r/cd-rw in the first drive on the system


$folder = FileSelectFolder("Select folder to burn", "")
If $folder = "" Then Exit

; Get the unique ids of all the drives on the system
$ids = _IMAPI2_DrivesGetID()

; Get the object of the first drive
$drive = _IMAPI2_DriveGetObj($ids[1])
Do
	_IMAPI2_DriveEject($drive)
	MsgBox(64, "Info", "Insert cd-r or cd-rw into drive " & _IMAPI2_DriveGetLetter($drive))
	_IMAPI2_DriveClose($drive)
	Do
		Sleep(1000)
		$code = _IMAPI2_DriveGetMedia($drive)
	Until $code <> -1 ; Wait until the drive is ready
Until $code = $IMAPI_MEDIA_TYPE_CDR Or $code = $IMAPI_MEDIA_TYPE_CDRW ; Force the user to insert cd-r or cd-rw

$fs=_IMAPI2_CreateFSForDrive($drive,"Sample Title") ; Create a filesystem
_IMAPI2_AddFolderToFS($fs,$folder)
_IMAPI2_BurnFSToDrive($fs,$drive,"_Progress")


Func _Progress($array)
	ConsoleWrite("Current action: "&$array[0]&@CRLF)
	ConsoleWrite("Remaing time: "&$array[1]&@CRLF)
	ConsoleWrite("Elapsed time: "&$array[2]&@CRLF)
	ConsoleWrite("Total time: "&$array[3]&@CRLF)
EndFunc

