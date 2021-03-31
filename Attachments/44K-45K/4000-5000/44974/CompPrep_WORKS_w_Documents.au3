#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.10.2
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>


; Read a list of computer names from a text file on local machine.

Global Const $sCompListFile = @DesktopDir & "\NewComputers.txt"
Global $aCompList = FileReadToArray($sCompListFile)
Global Const $aDataDrv = "\\dktp434932\WLIQ_Class_Folders\Software_Install_Files"

If @error Then
	MsgBox(6, "File Error", "Could Not Open File", 5)
	Exit
EndIf
For $I = 0 To UBound($aCompList) - 1
	CopyFiles($aCompList[$I])
Next

; Copy files to computer names listed in text file read previously.


Func CopyFiles($CompList)
	Local Const $DOCS = "\\" & $CompList & "\C\Users\hesadmin\Documents\INSITE 101"
; Removes existing insite 101  folder
	$rtn00 = DirRemove($DOCS, 1)
	Sleep(10000)
	If $rtn00 = 0 Then
		MsgBox(0, "INSITE 101", "Directory Remove Failed", 5)
	ElseIf $rtn00 = 1 Then
		MsgBox(0, "INSITE 101", "Directory Remove Successful", 5)
	EndIf
	;Copy Class files in the working directory to a new folder/directory called Scripts.
	DirCopy($aDataDrv & "\Documents\INSITE 101", $DOCS, $FC_OVERWRITE)
	If DirGetSize($DOCS) >= 0 Then
		MsgBox(0, "INSITE 101", "Copy Complete", 5)
	ElseIf DirGetSize($DOCS) = @error Then
		MsgBox(0, "INSTIE 101", "Copy Failed!", 5)
	EndIf
EndFunc



; Display the temporary directory.
;	ShellExecute($DOCS)

;EndFunc   ;==>CopyFiles
