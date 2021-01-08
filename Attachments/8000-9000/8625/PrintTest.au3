#include <File.au3>

$Loop = 1
While $Loop = 1
$s_serial = InputBox("Kagoor Report File", "Scan Parent Serial Number."&@CRLF&"Then Click OK to proceed.")
	If @error = 1 Then
	$answer = MsgBox(4, "WARNING!", "You pressed 'Cancel', Do you want to Exit?")
	If $answer = 6 Then
		Exit
	EndIf
	Else
	If $s_serial = "" Then
	MsgBox(4096, "ERROR", "You Must Enter a Serial Number- try again!")
		Else
$Loop = 0
	EndIf
EndIf
WEnd

#include <file.au3>
#include <array.au3>
;Search for Serial Number and Create Report
$s_path = "C:\CustomerLogs\"
$a_filelist = _FileListToArray($s_path)
	If (Not IsArray($a_filelist)) Then
	MsgBox (0,"","No Files\Folders Found.")
	Exit
EndIf
	For $i = 0 to Ubound($a_filelist)-1
$a_searchresult = StringRegExp($a_filelist[$i],'('&$s_serial&'_[0-9]{1}_[0-9]{14}.log)',1)
	If IsArray($a_searchresult) = 1 Then
	MsgBox(0,"File Found!","File: "&$a_filelist[$i]&" Matches: "&$s_serial&@CRLF&"Copying to "&$s_path&$s_serial&".log",2)
	FileCopy ( $s_path&$a_filelist[$i], $s_path&$s_serial&".log",1)
	EndIf
Next
;Print the Report.
$File = _FilePrint ($s_path&$s_serial&".log")
_FilePrint($File, $i_Show = @SW_HIDE)
    Local $a_Ret = DllCall("shell32.dll", "long", "ShellExecute", _
            "hwnd", 0, _
            "string", "print", _
            "string", $File, _
            "string", "", _
            "string", "", _
            "int", $i_Show)
   If $a_Ret[0] > 32 And Not @error Then
       Return 1
    Else
        SetError($a_Ret[0])
        Return 0
    EndIf


