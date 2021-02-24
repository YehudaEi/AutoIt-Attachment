
#Region
#AutoIt3Wrapper_outfile=CPUINFO.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Fileversion=1.0.0.7
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion
Sleep(20000)
Global Const $FC_NOOVERWRITE = 0
Global Const $FC_OVERWRITE = 1
Global Const $FT_MODIFIED = 0
Global Const $FT_CREATED = 1
Global Const $FT_ACCESSED = 2
Global Const $FO_READ = 0
Global Const $FO_APPEND = 1
Global Const $FO_OVERWRITE = 2
Global Const $FO_BINARY = 16
Global Const $FO_UNICODE = 32
Global Const $FO_UTF16_LE = 32
Global Const $FO_UTF16_BE = 64
Global Const $FO_UTF8 = 128
Global Const $FO_UTF8_NOBOM = 256
Global Const $EOF = -1
Global Const $FD_FILEMUSTEXIST = 1
Global Const $FD_PATHMUSTEXIST = 2
Global Const $FD_MULTISELECT = 4
Global Const $FD_PROMPTCREATENEW = 8
Global Const $FD_PROMPTOVERWRITE = 16
Global Const $CREATE_NEW = 1
Global Const $CREATE_ALWAYS = 2
Global Const $OPEN_EXISTING = 3
Global Const $OPEN_ALWAYS = 4
Global Const $TRUNCATE_EXISTING = 5
Global Const $INVALID_SET_FILE_POINTER = -1
Global Const $FILE_BEGIN = 0
Global Const $FILE_CURRENT = 1
Global Const $FILE_END = 2
Global Const $FILE_ATTRIBUTE_READONLY = 1
Global Const $FILE_ATTRIBUTE_HIDDEN = 2
Global Const $FILE_ATTRIBUTE_SYSTEM = 4
Global Const $FILE_ATTRIBUTE_DIRECTORY = 16
Global Const $FILE_ATTRIBUTE_ARCHIVE = 32
Global Const $FILE_ATTRIBUTE_DEVICE = 64
Global Const $FILE_ATTRIBUTE_NORMAL = 128
Global Const $FILE_ATTRIBUTE_TEMPORARY = 256
Global Const $FILE_ATTRIBUTE_SPARSE_FILE = 512
Global Const $FILE_ATTRIBUTE_REPARSE_POINT = 1024
Global Const $FILE_ATTRIBUTE_COMPRESSED = 2048
Global Const $FILE_ATTRIBUTE_OFFLINE = 4096
Global Const $FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = 8192
Global Const $FILE_ATTRIBUTE_ENCRYPTED = 16384
Global Const $FILE_SHARE_READ = 1
Global Const $FILE_SHARE_WRITE = 2
Global Const $FILE_SHARE_DELETE = 4
Global Const $GENERIC_ALL = 268435456
Global Const $GENERIC_EXECUTE = 536870912
Global Const $GENERIC_WRITE = 1073741824
Global Const $GENERIC_READ = -2147483648

Func _FILECOUNTLINES($SFILEPATH)
	Local $HFILE = FileOpen($SFILEPATH, $FO_READ)
	If $HFILE = -1 Then Return SetError(1, 0, 0)
	Local $SFILECONTENT = StringStripWS(FileRead($HFILE), 2)
	FileClose($HFILE)
	Local $ATMP
	If StringInStr($SFILECONTENT, @LF) Then
		$ATMP = StringSplit(StringStripCR($SFILECONTENT), @LF)
	ElseIf StringInStr($SFILECONTENT, @CR) Then
		$ATMP = StringSplit($SFILECONTENT, @CR)
	Else
		If StringLen($SFILECONTENT) Then
			Return 1
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return $ATMP[0]
EndFunc


Func _FILECREATE($SFILEPATH)
	Local $HOPENFILE = FileOpen($SFILEPATH, $FO_OVERWRITE)
	If $HOPENFILE = -1 Then Return SetError(1, 0, 0)
	Local $HWRITEFILE = FileWrite($HOPENFILE, "")
	FileClose($HOPENFILE)
	If $HWRITEFILE = -1 Then Return SetError(2, 0, 0)
	Return 1
EndFunc


Func _FILELISTTOARRAY($SPATH, $SFILTER = "*", $IFLAG = 0)
	Local $HSEARCH, $SFILE, $SFILELIST, $SDELIM = "|"
	$SPATH = StringRegExpReplace($SPATH, "[\\/]+\z", "") & "\"
	If Not FileExists($SPATH) Then Return SetError(1, 1, "")
	If StringRegExp($SFILTER, "[\\/:><\|]|(?s)\A\s*\z") Then Return SetError(2, 2, "")
	If Not ($IFLAG = 0 Or $IFLAG = 1 Or $IFLAG = 2) Then Return SetError(3, 3, "")
	$HSEARCH = FileFindFirstFile($SPATH & $SFILTER)
	If @error Then Return SetError(4, 4, "")
	While 1
		$SFILE = FileFindNextFile($HSEARCH)
		If @error Then ExitLoop
		If ($IFLAG + @extended = 2) Then ContinueLoop
		$SFILELIST &= $SDELIM & $SFILE
	WEnd
	FileClose($HSEARCH)
	If Not $SFILELIST Then Return SetError(4, 4, "")
	Return StringSplit(StringTrimLeft($SFILELIST, 1), "|")
EndFunc


Func _FILEPRINT($S_FILE, $I_SHOW = @SW_HIDE)
	Local $A_RET = DllCall("shell32.dll", "int", "ShellExecuteW", "hwnd", 0, "wstr", "print", "wstr", $S_FILE, "wstr", "", "wstr", "", "int", $I_SHOW)
	If @error Then Return SetError(@error, @extended, 0)
	If $A_RET[0] <= 32 Then Return SetError(10, $A_RET[0], 0)
	Return 1
EndFunc


Func _FILEREADTOARRAY($SFILEPATH, ByRef $AARRAY)
	Local $HFILE = FileOpen($SFILEPATH, $FO_READ)
	If $HFILE = -1 Then Return SetError(1, 0, 0)
	Local $AFILE = FileRead($HFILE, FileGetSize($SFILEPATH))
	If StringRight($AFILE, 1) = @LF Then $AFILE = StringTrimRight($AFILE, 1)
	If StringRight($AFILE, 1) = @CR Then $AFILE = StringTrimRight($AFILE, 1)
	FileClose($HFILE)
	If StringInStr($AFILE, @LF) Then
		$AARRAY = StringSplit(StringStripCR($AFILE), @LF)
	ElseIf StringInStr($AFILE, @CR) Then
		$AARRAY = StringSplit($AFILE, @CR)
	Else
		If StringLen($AFILE) Then
			Dim $AARRAY[2] = [1, $AFILE]
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return 1
EndFunc


Func _FILEWRITEFROMARRAY($FILE, $A_ARRAY, $I_BASE = 0, $I_UBOUND = 0)
	If Not IsArray($A_ARRAY) Then Return SetError(2, 0, 0)
	Local $LAST = UBound($A_ARRAY) - 1
	If $I_UBOUND < 1 Or $I_UBOUND > $LAST Then $I_UBOUND = $LAST
	If $I_BASE < 0 Or $I_BASE > $LAST Then $I_BASE = 0
	Local $HFILE
	If IsString($FILE) Then
		$HFILE = FileOpen($FILE, $FO_OVERWRITE)
	Else
		$HFILE = $FILE
	EndIf
	If $HFILE = -1 Then Return SetError(1, 0, 0)
	Local $ERRORSAV = 0
	For $X = $I_BASE To $I_UBOUND
		If FileWrite($HFILE, $A_ARRAY[$X] & @CRLF) = 0 Then
			$ERRORSAV = 3
			ExitLoop
		EndIf
	Next
	If IsString($FILE) Then FileClose($HFILE)
	If $ERRORSAV Then Return SetError($ERRORSAV, 0, 0)
	Return 1
EndFunc


Func _FILEWRITELOG($SLOGPATH, $SLOGMSG, $IFLAG = -1)
	Local $IOPENMODE = $FO_APPEND
	Local $SDATENOW = @YEAR & "-" & @MON & "-" & @MDAY
	Local $STIMENOW = @HOUR & ":" & @MIN & ":" & @SEC
	Local $SMSG = $SDATENOW & " " & $STIMENOW & " : " & $SLOGMSG
	If $IFLAG <> -1 Then
		$SMSG &= @CRLF & FileRead($SLOGPATH)
		$IOPENMODE = $FO_OVERWRITE
	EndIf
	Local $HOPENFILE = FileOpen($SLOGPATH, $IOPENMODE)
	If $HOPENFILE = -1 Then Return SetError(1, 0, 0)
	Local $IWRITEFILE = FileWriteLine($HOPENFILE, $SMSG)
	Local $IRET = FileClose($HOPENFILE)
	If $IWRITEFILE = -1 Then Return SetError(2, $IRET, 0)
	Return $IRET
EndFunc


Func _FILEWRITETOLINE($SFILE, $ILINE, $STEXT, $FOVERWRITE = 0)
	If $ILINE <= 0 Then Return SetError(4, 0, 0)
	If Not IsString($STEXT) Then
		$STEXT = String($STEXT)
		If $STEXT = "" Then Return SetError(6, 0, 0)
	EndIf
	If $FOVERWRITE <> 0 And $FOVERWRITE <> 1 Then Return SetError(5, 0, 0)
	If Not FileExists($SFILE) Then Return SetError(2, 0, 0)
	Local $SREAD_FILE = FileRead($SFILE)
	Local $ASPLIT_FILE = StringSplit(StringStripCR($SREAD_FILE), @LF)
	If UBound($ASPLIT_FILE) < $ILINE Then Return SetError(1, 0, 0)
	Local $HFILE = FileOpen($SFILE, $FO_OVERWRITE)
	If $HFILE = -1 Then Return SetError(3, 0, 0)
	$SREAD_FILE = ""
	For $I = 1 To $ASPLIT_FILE[0]
		If $I = $ILINE Then
			If $FOVERWRITE = 1 Then
				If $STEXT <> "" Then $SREAD_FILE &= $STEXT & @CRLF
			Else
				$SREAD_FILE &= $STEXT & @CRLF & $ASPLIT_FILE[$I] & @CRLF
			EndIf
		ElseIf $I < $ASPLIT_FILE[0] Then
			$SREAD_FILE &= $ASPLIT_FILE[$I] & @CRLF
		ElseIf $I = $ASPLIT_FILE[0] Then
			$SREAD_FILE &= $ASPLIT_FILE[$I]
		EndIf
	Next
	FileWrite($HFILE, $SREAD_FILE)
	FileClose($HFILE)
	Return 1
EndFunc


Func _PATHFULL($SRELATIVEPATH, $SBASEPATH = @WorkingDir)
	If Not $SRELATIVEPATH Or $SRELATIVEPATH = "."  Then Return $SBASEPATH
	Local $SFULLPATH = StringReplace($SRELATIVEPATH, "/", "\")
	Local Const $SFULLPATHCONST = $SFULLPATH
	Local $SPATH
	Local $BROOTONLY = StringLeft($SFULLPATH, 1) = "\"  And StringMid($SFULLPATH, 2, 1) <> "\"
	For $I = 1 To 2
		$SPATH = StringLeft($SFULLPATH, 2)
		If $SPATH = "\\"  Then
			$SFULLPATH = StringTrimLeft($SFULLPATH, 2)
			Local $NSERVERLEN = StringInStr($SFULLPATH, "\") - 1
			$SPATH = "\\" & StringLeft($SFULLPATH, $NSERVERLEN)
			$SFULLPATH = StringTrimLeft($SFULLPATH, $NSERVERLEN)
			ExitLoop
		ElseIf StringRight($SPATH, 1) = ":"  Then
			$SFULLPATH = StringTrimLeft($SFULLPATH, 2)
			ExitLoop
		Else
			$SFULLPATH = $SBASEPATH & "\" & $SFULLPATH
		EndIf
	Next
	If $I = 3 Then Return ""
	If StringLeft($SFULLPATH, 1) <> "\"  Then
		If StringLeft($SFULLPATHCONST, 2) = StringLeft($SBASEPATH, 2) Then
			$SFULLPATH = $SBASEPATH & "\" & $SFULLPATH
		Else
			$SFULLPATH = "\" & $SFULLPATH
		EndIf
	EndIf
	Local $ATEMP = StringSplit($SFULLPATH, "\")
	Local $APATHPARTS[$ATEMP[0]], $J = 0
	For $I = 2 To $ATEMP[0]
		If $ATEMP[$I] = ".."  Then
			If $J Then $J -= 1
		ElseIf Not ($ATEMP[$I] = "" And $I <> $ATEMP[0]) And $ATEMP[$I] <> "."  Then
			$APATHPARTS[$J] = $ATEMP[$I]
			$J += 1
		EndIf
	Next
	$SFULLPATH = $SPATH
	If Not $BROOTONLY Then
		For $I = 0 To $J - 1
			$SFULLPATH &= "\" & $APATHPARTS[$I]
		Next
	Else
		$SFULLPATH &= $SFULLPATHCONST
		If StringInStr($SFULLPATH, "..") Then $SFULLPATH = _PATHFULL($SFULLPATH)
	EndIf
	While StringInStr($SFULLPATH, ".\")
		$SFULLPATH = StringReplace($SFULLPATH, ".\", "\")
	WEnd
	Return $SFULLPATH
EndFunc


Func _PATHGETRELATIVE($SFROM, $STO)
	If StringRight($SFROM, 1) <> "\"  Then $SFROM &= "\"
	If StringRight($STO, 1) <> "\"  Then $STO &= "\"
	If $SFROM = $STO Then Return SetError(1, 0, StringTrimRight($STO, 1))
	Local $ASFROM = StringSplit($SFROM, "\")
	Local $ASTO = StringSplit($STO, "\")
	If $ASFROM[1] <> $ASTO[1] Then Return SetError(2, 0, StringTrimRight($STO, 1))
	Local $I = 2
	Local $IDIFF = 1
	While 1
		If $ASFROM[$I] <> $ASTO[$I] Then
			$IDIFF = $I
			ExitLoop
		EndIf
		$I += 1
	WEnd
	$I = 1
	Local $SRELPATH = ""
	For $J = 1 To $ASTO[0]
		If $I >= $IDIFF Then
			$SRELPATH &= "\" & $ASTO[$I]
		EndIf
		$I += 1
	Next
	$SRELPATH = StringTrimLeft($SRELPATH, 1)
	$I = 1
	For $J = 1 To $ASFROM[0]
		If $I > $IDIFF Then
			$SRELPATH = "..\" & $SRELPATH
		EndIf
		$I += 1
	Next
	If StringRight($SRELPATH, 1) == "\"  Then $SRELPATH = StringTrimRight($SRELPATH, 1)
	Return $SRELPATH
EndFunc


Func _PATHMAKE($SZDRIVE, $SZDIR, $SZFNAME, $SZEXT)
	If StringLen($SZDRIVE) Then
		If Not (StringLeft($SZDRIVE, 2) = "\\") Then $SZDRIVE = StringLeft($SZDRIVE, 1) & ":"
	EndIf
	If StringLen($SZDIR) Then
		If Not (StringRight($SZDIR, 1) = "\") And Not (StringRight($SZDIR, 1) = "/") Then $SZDIR = $SZDIR & "\"
	EndIf
	If StringLen($SZEXT) Then
		If Not (StringLeft($SZEXT, 1) = ".") Then $SZEXT = "." & $SZEXT
	EndIf
	Return $SZDRIVE & $SZDIR & $SZFNAME & $SZEXT
EndFunc


Func _PATHSPLIT($SZPATH, ByRef $SZDRIVE, ByRef $SZDIR, ByRef $SZFNAME, ByRef $SZEXT)
	Local $DRIVE = ""
	Local $DIR = ""
	Local $FNAME = ""
	Local $EXT = ""
	Local $POS
	Local $ARRAY[5]
	$ARRAY[0] = $SZPATH
	If StringMid($SZPATH, 2, 1) = ":"  Then
		$DRIVE = StringLeft($SZPATH, 2)
		$SZPATH = StringTrimLeft($SZPATH, 2)
	ElseIf StringLeft($SZPATH, 2) = "\\"  Then
		$SZPATH = StringTrimLeft($SZPATH, 2)
		$POS = StringInStr($SZPATH, "\")
		If $POS = 0 Then $POS = StringInStr($SZPATH, "/")
		If $POS = 0 Then
			$DRIVE = "\\" & $SZPATH
			$SZPATH = ""
		Else
			$DRIVE = "\\" & StringLeft($SZPATH, $POS - 1)
			$SZPATH = StringTrimLeft($SZPATH, $POS - 1)
		EndIf
	EndIf
	Local $NPOSFORWARD = StringInStr($SZPATH, "/", 0, -1)
	Local $NPOSBACKWARD = StringInStr($SZPATH, "\", 0, -1)
	If $NPOSFORWARD >= $NPOSBACKWARD Then
		$POS = $NPOSFORWARD
	Else
		$POS = $NPOSBACKWARD
	EndIf
	$DIR = StringLeft($SZPATH, $POS)
	$FNAME = StringRight($SZPATH, StringLen($SZPATH) - $POS)
	If StringLen($DIR) = 0 Then $FNAME = $SZPATH
	$POS = StringInStr($FNAME, ".", 0, -1)
	If $POS Then
		$EXT = StringRight($FNAME, StringLen($FNAME) - ($POS - 1))
		$FNAME = StringLeft($FNAME, $POS - 1)
	EndIf
	$SZDRIVE = $DRIVE
	$SZDIR = $DIR
	$SZFNAME = $FNAME
	$SZEXT = $EXT
	$ARRAY[1] = $DRIVE
	$ARRAY[2] = $DIR
	$ARRAY[3] = $FNAME
	$ARRAY[4] = $EXT
	Return $ARRAY
EndFunc


Func _REPLACESTRINGINFILE($SZFILENAME, $SZSEARCHSTRING, $SZREPLACESTRING, $FCASENESS = 0, $FOCCURANCE = 1)
	Local $IRETVAL = 0
	Local $NCOUNT, $SENDSWITH
	If StringInStr(FileGetAttrib($SZFILENAME), "R") Then Return SetError(6, 0, -1)
	Local $HFILE = FileOpen($SZFILENAME, $FO_READ)
	If $HFILE = -1 Then Return SetError(1, 0, -1)
	Local $S_TOTFILE = FileRead($HFILE, FileGetSize($SZFILENAME))
	If StringRight($S_TOTFILE, 2) = @CRLF Then
		$SENDSWITH = @CRLF
	ElseIf StringRight($S_TOTFILE, 1) = @CR Then
		$SENDSWITH = @CR
	ElseIf StringRight($S_TOTFILE, 1) = @LF Then
		$SENDSWITH = @LF
	Else
		$SENDSWITH = ""
	EndIf
	Local $AFILELINES = StringSplit(StringStripCR($S_TOTFILE), @LF)
	FileClose($HFILE)
	Local $HWRITEHANDLE = FileOpen($SZFILENAME, $FO_OVERWRITE)
	If $HWRITEHANDLE = -1 Then Return SetError(2, 0, -1)
	For $NCOUNT = 1 To $AFILELINES[0]
		If StringInStr($AFILELINES[$NCOUNT], $SZSEARCHSTRING, $FCASENESS) Then
			$AFILELINES[$NCOUNT] = StringReplace($AFILELINES[$NCOUNT], $SZSEARCHSTRING, $SZREPLACESTRING, 1 - $FOCCURANCE, $FCASENESS)
			$IRETVAL = $IRETVAL + 1
			If $FOCCURANCE = 0 Then
				$IRETVAL = 1
				ExitLoop
			EndIf
		EndIf
	Next
	For $NCOUNT = 1 To $AFILELINES[0] - 1
		If FileWriteLine($HWRITEHANDLE, $AFILELINES[$NCOUNT]) = 0 Then
			FileClose($HWRITEHANDLE)
			Return SetError(3, 0, -1)
		EndIf
	Next
	If $AFILELINES[$NCOUNT] <> "" Then FileWrite($HWRITEHANDLE, $AFILELINES[$NCOUNT] & $SENDSWITH)
	FileClose($HWRITEHANDLE)
	Return $IRETVAL
EndFunc


Func _TEMPFILE($S_DIRECTORYNAME = @TempDir, $S_FILEPREFIX = "~", $S_FILEEXTENSION = ".tmp", $I_RANDOMLENGTH = 7)
	If Not FileExists($S_DIRECTORYNAME) Then $S_DIRECTORYNAME = @TempDir
	If Not FileExists($S_DIRECTORYNAME) Then $S_DIRECTORYNAME = @ScriptDir
	If StringRight($S_DIRECTORYNAME, 1) <> "\"  Then $S_DIRECTORYNAME = $S_DIRECTORYNAME & "\"
	Local $S_TEMPNAME
	Do
		$S_TEMPNAME = ""
		While StringLen($S_TEMPNAME) < $I_RANDOMLENGTH
			$S_TEMPNAME = $S_TEMPNAME & Chr(Random(97, 122, 1))
		WEnd
		$S_TEMPNAME = $S_DIRECTORYNAME & $S_FILEPREFIX & $S_TEMPNAME & $S_FILEEXTENSION
	Until Not FileExists($S_TEMPNAME)
	Return $S_TEMPNAME
EndFunc

Global $MODEL
Dim $WBEMFLAGRETURNIMMEDIATELY = 16
Dim $WBEMFLAGFORWARDONLY = 32
Global Const $OBJECTCLASS = "Win32_ComputerSystem"
Global Const $OBJECTCLASSBIOS = "Win32_SystemEnclosure"
Dim $OBJWMI = ObjGet("winmgmts:\\localhost\root\CIMV2")
Dim $OBJITEMS = $OBJWMI.ExecQuery ("SELECT * FROM " & $OBJECTCLASS, "WQL", $WBEMFLAGRETURNIMMEDIATELY + $WBEMFLAGFORWARDONLY)
Dim $OBJITEM
If IsObj($OBJITEMS) Then
	For $OBJITEM In $OBJITEMS
		$MODEL = $OBJITEM.Model
		$MODEL = StringStripWS($MODEL, 3)
	Next
EndIf
Dim $OBJITEMSBIOS = $OBJWMI.ExecQuery ("SELECT * FROM " & $OBJECTCLASSBIOS, "WQL", $WBEMFLAGRETURNIMMEDIATELY + $WBEMFLAGFORWARDONLY)
Dim $OBJITEMBIOS
If IsObj($OBJITEMSBIOS) Then
	For $OBJITEMBIOS In $OBJITEMSBIOS
		$SERVICETAG = $OBJITEMBIOS.serialnumber
		$SERVICETAG = StringStripWS($SERVICETAG, 3)
	Next
EndIf
Opt("TrayMenuMode", 1)
TraySetIcon("Shell32.dll", 24)
$HOSTITEM = TrayCreateItem("Host Name:  " & @ComputerName)
$IPITEM = TrayCreateItem("IP Address:  " & @IPAddress1)
$MODELITEM = TrayCreateItem("Computer Model:  " & $MODEL)
$SERVICETAGITEM = TrayCreateItem("Service Tag Number:  " & $SERVICETAG)
TraySetState()
While 1
	$MSG = TrayGetMsg()
	Select
		Case $MSG = 0
			ContinueLoop
		Case $MSG = $HOSTITEM
			MsgBox(64, "", "Host Name:  " & @ComputerName, 9)
		Case $MSG = $IPITEM
			MsgBox(64, "", "IP Address:  " & @IPAddress1, 9)
		Case $MSG = $MODELITEM
			MsgBox(64, "", "Computer Model:  " & $MODEL, 9)
		Case $MSG = $SERVICETAGITEM
			MsgBox(64, "", "Service Tag Number:  " & $SERVICETAG, 9)
	EndSelect
WEnd