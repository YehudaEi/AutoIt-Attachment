Dim $all

$open = FileOpen(@DesktopDir & "\testpic1.JPG", 16)
$write = BinaryToString(FileRead($open))

$File = "test.ini"; name of ini file, or alternate data stream (NTFS)

;Make Sure The Program Is Compiled
If @Compiled And DriveGetFileSystem(StringLeft(@AutoItExe,3)) == "NTFS" And IsAdmin() Then
    $inifileloc = @AutoItExe & ':' & $File;We can use ADS, location of ADS
Else;Do no use ADS
    MsgBox(0, "", "You need to compile this, it requires the compiled exe file" & @CRLF & @CRLF & "Or you need to run this on a NTFS drive" & @CRLF & @CRLF & "Or You might need Administor Rights")
	Exit
EndIf

;write ini file (picname is the keyname, can be an variable)
$write = StringReplace($write, Chr(0), "#$")

$i = 1
Do
	IniWrite($inifileloc, "section" & $i, "picname", StringLeft($write, 150))
	$write = StringTrimLeft($write, 150)
	$i = $i + 1
Until StringLen($write) = 0 or $write = ""

$number = IniReadSectionNames($inifileloc)
For $j = 1 To $number[0]
	$var = IniReadSection($inifileloc, $number[$j])
	$all = $all & $var[1][1]
Next

;Display the contents of the INI file
If @error Then
    MsgBox(4096, "", "Error occurred, probably no INI file.")
EndIf

$all = StringReplace($all, "#$", Chr(0))
$writable = fileopen(@DesktopDir & "\testpic1-NEW.JPG", 26)
filewrite($writable, $all)
fileclose($writable)