GLOBAL Const $IDM_REPLACE_NO = 100
Global Const $IDM_REPLACE_YES = 102
Global Const $IDM_REPLACE_ALL = 103
Global Const $IDM_REPLACE_NONE = 104
Global $HZIPDLL = DllOpen("BypassedPostmessages.dll")
Global $HUNZIPDLL = DllOpen("unzip32.dll")
Global $HCALLBACK_ZIPPRINT, $HCALLBACK_ZIPPASSWORD, $HCALLBACK_ZIPCOMMENT, $HCALLBACK_ZIPPROGRESS
Global $HCALLBACK_UNZIPPRINT, $HCALLBACK_UNZIPREPLACE, $HCALLBACK_UNZIPPASSWORD, $HCALLBACK_UNZIPMESSAGE, $HCALLBACK_UNZIPSERVICE
Global $AZIPCALLBACK[9] = [$HCALLBACK_ZIPPRINT, $HCALLBACK_ZIPPASSWORD, $HCALLBACK_ZIPCOMMENT, $HCALLBACK_ZIPPROGRESS, $HCALLBACK_UNZIPPRINT, $HCALLBACK_UNZIPREPLACE, $HCALLBACK_UNZIPPASSWORD, $HCALLBACK_UNZIPMESSAGE, $HCALLBACK_UNZIPSERVICE]
Global $ROOTDIR = DllStructCreate("char[256]")
DllStructSetData($ROOTDIR, 1, @ScriptDir)
Global $TEMPDIR = DllStructCreate("char[256]")
DllStructSetData($TEMPDIR, 1, @TempDir)
Global $ZPOPT = DllStructCreate("ptr Date;ptr szRootDir;ptr szTempDir;int fTemp;int fSuffix;int fEncrypt;int fSystem;" & "int fVolume;int fExtra;int fNoDirEntries;int fExcludeDate;int fIncludeDate;int fVerbose;" & "int fQuiet;int fCRLFLF;int fLFCRLF;int fJunkDir;int fGrow;int fForce;int fMove;" & "int fDeleteEntries;int fUpdate;int fFreshen;int fJunkSFX;int fLatestTime;int fComment;" & "int fOffsets;int fPrivilege;int fEncryption;int fRecurse;int fRepair;char fLevel[2]")
DllStructSetData($ZPOPT, "szRootDir", DllStructGetPtr($ROOTDIR))
DllStructSetData($ZPOPT, "szTempDir", DllStructGetPtr($TEMPDIR))
DllStructSetData($ZPOPT, "fTemp", 0)
DllStructSetData($ZPOPT, "fVolume", 0)
DllStructSetData($ZPOPT, "fExtra", 0)
DllStructSetData($ZPOPT, "fVerbose", 1)
DllStructSetData($ZPOPT, "fQuiet", 0)
DllStructSetData($ZPOPT, "fCRLFLF", 0)
DllStructSetData($ZPOPT, "fLFCRLF", 0)
DllStructSetData($ZPOPT, "fGrow", 0)
DllStructSetData($ZPOPT, "fForce", 0)
DllStructSetData($ZPOPT, "fDeleteEntries", 0)
DllStructSetData($ZPOPT, "fJunkSFX", 0)
DllStructSetData($ZPOPT, "fOffsets", 0)
DllStructSetData($ZPOPT, "fRepair", 0)
Global $DCLIST = DllStructCreate("int ExtractOnlyNewer;int SpaceToUnderscore;int PromptToOverwrite;int fQuiet;int ncflag;" & "int ntflag;int nvflag;int nfflag;int nzflag;int ndflag;int noflag;int naflag;int nZIflag;" & "int Cflag;int fPrivilege;ptr Zip;ptr ExtractDir")
DllStructSetData($DCLIST, "fQuiet", 1)
DllStructSetData($DCLIST, "ncflag", 0)
DllStructSetData($DCLIST, "nvflag", 0)
DllStructSetData($DCLIST, "naflag", 0)
DllStructSetData($DCLIST, "nZIflag", 0)
DllStructSetData($DCLIST, "Cflag", 1)
DllStructSetData($DCLIST, "fPrivilege", 1)
Global $USERFUNCTIONS = DllStructCreate("ptr print;ptr sound;ptr replace;ptr password;ptr SendApplicationMessage;" & "ptr ServCallBk;ulong TotalSizeComp;ulong TotalSize;ulong CompFactor;ulong NumMembers;" & "ushort cchComment")

Func _ZIP_INIT($SZIP_PRINTFUNC, $SZIP_PASSFUNC, $SZIP_COMMENTFUNC, $SZIP_SERVICEFUNC)
	$HCALLBACK_ZIPPRINT = DLLCALLBACKREGISTER($SZIP_PRINTFUNC, "int", "str;long")
	$HCALLBACK_ZIPCOMMENT = DLLCALLBACKREGISTER($SZIP_COMMENTFUNC, "int", "ptr")
	$HCALLBACK_ZIPPASSWORD = DLLCALLBACKREGISTER($SZIP_PASSFUNC, "int", "ptr;int;ptr;ptr")
	$HCALLBACK_ZIPPROGRESS = DLLCALLBACKREGISTER($SZIP_SERVICEFUNC, "int", "str;long")
	Local $ZIPUSERFUNCTIONS = DllStructCreate("ptr print;ptr comment;ptr password;ptr service")
	DllStructSetData($ZIPUSERFUNCTIONS, "print", DLLCALLBACKGETPTR($HCALLBACK_ZIPPRINT))
	DllStructSetData($ZIPUSERFUNCTIONS, "comment", DLLCALLBACKGETPTR($HCALLBACK_ZIPCOMMENT))
	DllStructSetData($ZIPUSERFUNCTIONS, "password", DLLCALLBACKGETPTR($HCALLBACK_ZIPPASSWORD))
	DllStructSetData($ZIPUSERFUNCTIONS, "service", DLLCALLBACKGETPTR($HCALLBACK_ZIPPROGRESS))
	Local $ARET = DllCall($HZIPDLL, "int", "ZpInit", "ptr", DllStructGetPtr($ZIPUSERFUNCTIONS))
	If $ARET[0] = 0 Then Return SetError(1, 0, 0)
	Return 1
EndFunc


Func _ZIP_SETOPTIONS($SDATE = 0, $SENCRYPT = 0, $SSYS = 1, $SEMPTYFOLDER = 0, $SEXCLUDEDATE = 0, $SINCLUDEDATE = 0, $SJUNKDIR = 0, $SMOVE = 0, $SUPDATE = 0, $SFRESH = 0, $SLATESTTIME = 0, $SCOMMENT = 0, $SPRIVILEGE = 1, $SRECURSE = 1, $SLEVEL = 9)
	If $SDATE = 0 Then
		DllStructSetData($ZPOPT, "Date", 0)
	Else
		$DATESTRUCT = DllStructCreate("char[12]")
		DllStructSetData($DATESTRUCT, 1, $SDATE)
		DllStructSetData($ZPOPT, "Date", DllStructGetPtr($DATESTRUCT, 1))
	EndIf
	DllStructSetData($ZPOPT, "fEncrypt", $SENCRYPT)
	DllStructSetData($ZPOPT, "fSystem", $SSYS)
	DllStructSetData($ZPOPT, "fNoDirEntries", $SEMPTYFOLDER)
	DllStructSetData($ZPOPT, "fExcludeDate", $SEXCLUDEDATE)
	DllStructSetData($ZPOPT, "fIncludeDate", $SINCLUDEDATE)
	DllStructSetData($ZPOPT, "fJunkDir", $SJUNKDIR)
	DllStructSetData($ZPOPT, "fMove", $SMOVE)
	DllStructSetData($ZPOPT, "fUpdate", $SUPDATE)
	DllStructSetData($ZPOPT, "fFreshen", $SFRESH)
	DllStructSetData($ZPOPT, "fLatestTime", $SLATESTTIME)
	DllStructSetData($ZPOPT, "fComment", $SCOMMENT)
	DllStructSetData($ZPOPT, "fPrivilege", $SPRIVILEGE)
	DllStructSetData($ZPOPT, "fRecurse", $SRECURSE)
	DllStructSetData($ZPOPT, "fLevel", $SLEVEL)
	Local $ARET = DllCall($HZIPDLL, "int", "ZpSetOptions", "ptr", DllStructGetPtr($ZPOPT))
	If $ARET[0] = 0 Then Return SetError(1, 0, 0)
	Return 1
EndFunc


Func _ZIP_ARCHIVE($SZIPNAME, $SFILENAME)
	$FILENAMEBUFF = DllStructCreate("char[256]")
	DllStructSetData($FILENAMEBUFF, 1, $SFILENAME)
	$ARET = DllCall($HZIPDLL, "int", "ZpArchive", "int", 1, "str", $SZIPNAME, "ptr*", DllStructGetPtr($FILENAMEBUFF))
	If $ARET[0] <> 0 Then Return SetError(1, 0, 0)
	Return 1
EndFunc


Func _UNZIP_INIT($SUNZIP_PRINTFUNC, $SUNZIP_REPLACEFUNC, $SUNZIP_PASSWORDFUNC, $SUNZIP_SENDAPPMSGFUNC, $SUNZIP_SERVICEFUNC)
	$HCALLBACK_UNZIPPRINT = DLLCALLBACKREGISTER($SUNZIP_PRINTFUNC, "int", "str;long")
	$HCALLBACK_UNZIPREPLACE = DLLCALLBACKREGISTER($SUNZIP_REPLACEFUNC, "int", "str")
	$HCALLBACK_UNZIPPASSWORD = DLLCALLBACKREGISTER($SUNZIP_PASSWORDFUNC, "int", "ptr;int;ptr;ptr")
	$HCALLBACK_UNZIPMESSAGE = DLLCALLBACKREGISTER($SUNZIP_SENDAPPMSGFUNC, "int", "ulong;ulong;uint;uint;uint;uint;uint;uint;" & "str;ptr;ptr;ulong;str")
	$HCALLBACK_UNZIPSERVICE = DLLCALLBACKREGISTER($SUNZIP_SERVICEFUNC, "int", "str;long")
	DllStructSetData($USERFUNCTIONS, "print", DLLCALLBACKGETPTR($HCALLBACK_UNZIPPRINT))
	DllStructSetData($USERFUNCTIONS, "sound", 0)
	DllStructSetData($USERFUNCTIONS, "replace", DLLCALLBACKGETPTR($HCALLBACK_UNZIPREPLACE))
	DllStructSetData($USERFUNCTIONS, "password", DLLCALLBACKGETPTR($HCALLBACK_UNZIPPASSWORD))
	DllStructSetData($USERFUNCTIONS, "SendApplicationMessage", $HCALLBACK_UNZIPMESSAGE)
	DllStructSetData($USERFUNCTIONS, "ServCallBk", DLLCALLBACKGETPTR($HCALLBACK_UNZIPSERVICE))
EndFunc


Func _UNZIP_SETOPTIONS($SONLYNEWER = 0, $SPACEUNDERSCORE = 0, $SPROMPTOVERWRITE = 0, $STESTZIP = 0, $SFRESH = 0, $SCOMMENT = 0, $SDIRRET = 1, $SOVERWRITE = 1)
	DllStructSetData($DCLIST, "ExtractOnlyNewer", $SONLYNEWER)
	DllStructSetData($DCLIST, "SpaceToUnderscore", $SPACEUNDERSCORE)
	DllStructSetData($DCLIST, "PromptToOverwrite", $SPROMPTOVERWRITE)
	DllStructSetData($DCLIST, "ntflag", $STESTZIP)
	DllStructSetData($DCLIST, "nfflag", $SFRESH)
	DllStructSetData($DCLIST, "nzflag", $SCOMMENT)
	DllStructSetData($DCLIST, "ndflag", $SDIRRET)
	DllStructSetData($DCLIST, "noflag", $SOVERWRITE)
EndFunc


Func _UNZIP_UNZIP($SZIPNAME, $SOUTPUT = @ScriptDir, $IFILENUMBERINCL = 0, $SFILENAMEINCL = "*.*", $IFILENUMBEREXCL = 0, $FILENAMEEXCL = "")
	Local $ZIP_BUFFER = DllStructCreate("char[256]")
	DllStructSetData($ZIP_BUFFER, 1, $SZIPNAME)
	Local $EXTRACTDIR_BUFFER = DllStructCreate("char[256]")
	DllStructSetData($EXTRACTDIR_BUFFER, 1, $SOUTPUT)
	DllStructSetData($DCLIST, "Zip", DllStructGetPtr($ZIP_BUFFER))
	DllStructSetData($DCLIST, "ExtractDir", DllStructGetPtr($EXTRACTDIR_BUFFER))
	Local $FILEINCLUDE = DllStructCreate("char[256]")
	DllStructSetData($FILEINCLUDE, 1, $SFILENAMEINCL)
	Local $FILEEXCLUDE = DllStructCreate("char[256]")
	DllStructSetData($FILEEXCLUDE, 1, $FILENAMEEXCL)
	$ARET = DllCall($HUNZIPDLL, "int", "Wiz_SingleEntryUnzip", "int", $IFILENUMBERINCL, "ptr*", DllStructGetPtr($FILEINCLUDE), "int", $IFILENUMBEREXCL, "ptr*", DllStructGetPtr($FILEEXCLUDE), "ptr", DllStructGetPtr($DCLIST), "ptr", DllStructGetPtr($USERFUNCTIONS))
	If $ARET[0] <> 0 Then Return SetError(1, 0, 0)
	Return 1
EndFunc


Func ONAUTOITEXIT()
	If $HZIPDLL <> -1 Then DllClose($HZIPDLL)
	If $HUNZIPDLL <> -1 Then DllClose($HUNZIPDLL)
	For $I = 0 To UBound($AZIPCALLBACK) - 1
		If $AZIPCALLBACK[$I] <> 0 Then DLLCALLBACKFREE($AZIPCALLBACK[0])
	Next
EndFunc


Func _FILECOUNTLINES($SFILEPATH)
	Local $N = FileGetSize($SFILEPATH) - 1
	If @error Or $N = -1 Then Return 0
	Return StringLen(StringAddCR(FileRead($SFILEPATH, $N))) - $N + 1
EndFunc


Func _FILECREATE($SFILEPATH)
	Local $HOPENFILE
	Local $HWRITEFILE
	$HOPENFILE = FileOpen($SFILEPATH, 2)
	If $HOPENFILE = -1 Then
		SetError(1)
		Return 0
	EndIf
	$HWRITEFILE = FileWrite($HOPENFILE, "")
	If $HWRITEFILE = -1 Then
		SetError(2)
		Return 0
	EndIf
	FileClose($HOPENFILE)
	Return 1
EndFunc


Func _FILELISTTOARRAY($SPATH, $SFILTER = "*", $IFLAG = 0)
	Local $HSEARCH, $SFILE, $ASFILELIST[1]
	If Not FileExists($SPATH) Then Return SetError(1, 1, "")
	If (StringInStr($SFILTER, "\")) Or (StringInStr($SFILTER, "/")) Or (StringInStr($SFILTER, ":")) Or (StringInStr($SFILTER, ">")) Or (StringInStr($SFILTER, "<")) Or (StringInStr($SFILTER, "|")) Or (StringStripWS($SFILTER, 8) = "") Then Return SetError(2, 2, "")
	If Not ($IFLAG = 0 Or $IFLAG = 1 Or $IFLAG = 2) Then Return SetError(3, 3, "")
	If (StringMid($SPATH, StringLen($SPATH), 1) = "\") Then $SPATH = StringTrimRight($SPATH, 1)
	$HSEARCH = FileFindFirstFile($SPATH & "\" & $SFILTER)
	If $HSEARCH = -1 Then Return SetError(4, 4, "")
	While 1
		$SFILE = FileFindNextFile($HSEARCH)
		If @error Then
			SetError(0)
			ExitLoop
		EndIf
		If $IFLAG = 1 And StringInStr(FileGetAttrib($SPATH & "\" & $SFILE), "D") <> 0 Then ContinueLoop
		If $IFLAG = 2 And StringInStr(FileGetAttrib($SPATH & "\" & $SFILE), "D") = 0 Then ContinueLoop
		ReDim $ASFILELIST[UBound($ASFILELIST) + 1]
		$ASFILELIST[0] = $ASFILELIST[0] + 1
		$ASFILELIST[UBound($ASFILELIST) - 1] = $SFILE
	WEnd
	FileClose($HSEARCH)
	Return $ASFILELIST
EndFunc


Func _FILEPRINT($S_FILE, $I_SHOW = @SW_HIDE)
	Local $A_RET = DllCall("shell32.dll", "long", "ShellExecute", "hwnd", 0, "string", "print", "string", $S_FILE, "string", "", "string", "", "int", $I_SHOW)
	If $A_RET[0] > 32 And Not @error Then
		Return 1
	Else
		SetError($A_RET[0])
		Return 0
	EndIf
EndFunc


Func _FILEREADTOARRAY($SFILEPATH, ByRef $AARRAY)
	Local $HFILE
	$HFILE = FileOpen($SFILEPATH, 0)
	If $HFILE = -1 Then
		SetError(1)
		Return 0
	EndIf
	Local $STEMP = FileRead($HFILE)
	If StringRight($STEMP, 1) = @LF Then $STEMP = StringTrimRight($STEMP, 1)
	If StringRight($STEMP, 1) = @CR Then $STEMP = StringTrimRight($STEMP, 1)
	$AARRAY = StringSplit($STEMP, @CRLF, 1)
	If @error Then $AARRAY = StringSplit($STEMP, @LF)
	If @error Then $AARRAY = StringSplit($STEMP, @CR)
	FileClose($HFILE)
	Return 1
EndFunc


Func _FILEWRITEFROMARRAY($FILE, $A_ARRAY, $I_BASE = 0, $I_UBOUND = 0)
	If Not IsArray($A_ARRAY) Then Return SetError(2, 0, 0)
	Local $LAST = UBound($A_ARRAY) - 1
	If $I_UBOUND < 1 Or $I_UBOUND > $LAST Then $I_UBOUND = $LAST
	If $I_BASE < 0 Or $I_BASE > $LAST Then $I_BASE = 0
	Local $HFILE
	If IsString($FILE) Then
		$HFILE = FileOpen($FILE, 2)
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
	If $ERRORSAV Then
		Return SetError($ERRORSAV, 0, 0)
	Else
		Return 1
	EndIf
EndFunc


Func _FILEWRITELOG($SLOGPATH, $SLOGMSG, $IFLAG = -1)
	Local $SDATENOW, $STIMENOW, $SMSG, $IWRITEFILE, $HOPENFILE, $IOPENMODE = 1
	$SDATENOW = @YEAR & "-" & @MON & "-" & @MDAY
	$STIMENOW = @HOUR & ":" & @MIN & ":" & @SEC
	$SMSG = $SDATENOW & " " & $STIMENOW & " : " & $SLOGMSG
	If $IFLAG <> -1 Then
		$SMSG &= @CRLF & FileRead($SLOGPATH)
		$IOPENMODE = 2
	EndIf
	$HOPENFILE = FileOpen($SLOGPATH, $IOPENMODE)
	If $HOPENFILE = -1 Then Return SetError(1, 0, 0)
	$IWRITEFILE = FileWriteLine($HOPENFILE, $SMSG)
	If $IWRITEFILE = -1 Then Return SetError(2, 0, 0)
	Return FileClose($HOPENFILE)
EndFunc


Func _FILEWRITETOLINE($SFILE, $ILINE, $STEXT, $FOVERWRITE = 0)
	If $ILINE <= 0 Then Return SetError(4, 0, 0)
	If Not IsString($STEXT) Then Return SetError(6, 0, 0)
	If $FOVERWRITE <> 0 And $FOVERWRITE <> 1 Then Return SetError(5, 0, 0)
	If Not FileExists($SFILE) Then Return SetError(2, 0, 0)
	Local $FILTXT = FileRead($SFILE, FileGetSize($SFILE))
	$FILTXT = StringSplit($FILTXT, @CRLF, 1)
	If UBound($FILTXT, 1) < $ILINE Then Return SetError(1, 0, 0)
	Local $FIL = FileOpen($SFILE, 2)
	If $FIL = -1 Then Return SetError(3, 0, 0)
	For $I = 1 To UBound($FILTXT) - 1
		If $I = $ILINE Then
			If $FOVERWRITE = 1 Then
				If $STEXT <> "" Then
					FileWrite($FIL, $STEXT & @CRLF)
				Else
					FileWrite($FIL, $STEXT)
				EndIf
			EndIf
			If $FOVERWRITE = 0 Then
				FileWrite($FIL, $STEXT & @CRLF)
				FileWrite($FIL, $FILTXT[$I] & @CRLF)
			EndIf
		ElseIf $I < UBound($FILTXT, 1) - 1 Then
			FileWrite($FIL, $FILTXT[$I] & @CRLF)
		ElseIf $I = UBound($FILTXT, 1) - 1 Then
			FileWrite($FIL, $FILTXT[$I])
		EndIf
	Next
	FileClose($FIL)
	Return 1
EndFunc


Func _PATHFULL($SRELATIVEPATH, $SBASEPATH = @WorkingDir)
	If Not $SRELATIVEPATH Or $SRELATIVEPATH = "." Then Return $SBASEPATH
	Local $SFULLPATH = StringReplace($SRELATIVEPATH, "/", "\")
	Local Const $SFULLPATHCONST = $SFULLPATH
	Local $SPATH
	Local $BROOTONLY = StringLeft($SFULLPATH, 1) = "\" And StringMid($SFULLPATH, 2, 1) <> "\"
	For $I = 1 To 2
		$SPATH = StringLeft($SFULLPATH, 2)
		If $SPATH = "\\" Then
			$SFULLPATH = StringTrimLeft($SFULLPATH, 2)
			$SPATH &= StringLeft($SFULLPATH, StringInStr($SFULLPATH, "\") - 1)
			ExitLoop
		ElseIf StringRight($SPATH, 1) = ":" Then
			$SFULLPATH = StringTrimLeft($SFULLPATH, 2)
			ExitLoop
		Else
			$SFULLPATH = $SBASEPATH & "\" & $SFULLPATH
		EndIf
	Next
	If $I = 3 Then Return ""
	Local $ATEMP = StringSplit($SFULLPATH, "\")
	Local $APATHPARTS[$ATEMP[0]], $J = 0
	For $I = 2 To $ATEMP[0]
		If $ATEMP[$I] = ".." Then
			If $J Then $J -= 1
		ElseIf Not ($ATEMP[$I] = "" And $I <> $ATEMP[0]) And $ATEMP[$I] <> "." Then
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


Func _PATHMAKE($SZDRIVE, $SZDIR, $SZFNAME, $SZEXT)
	Local $SZFULLPATH
	If StringLen($SZDRIVE) Then
		If Not (StringLeft($SZDRIVE, 2) = "\\") Then $SZDRIVE = StringLeft($SZDRIVE, 1) & ":"
	EndIf
	If StringLen($SZDIR) Then
		If Not (StringRight($SZDIR, 1) = "\") And Not (StringRight($SZDIR, 1) = "/") Then $SZDIR = $SZDIR & "\"
	EndIf
	If StringLen($SZEXT) Then
		If Not (StringLeft($SZEXT, 1) = ".") Then $SZEXT = "." & $SZEXT
	EndIf
	$SZFULLPATH = $SZDRIVE & $SZDIR & $SZFNAME & $SZEXT
	Return $SZFULLPATH
EndFunc


Func _PATHSPLIT($SZPATH, ByRef $SZDRIVE, ByRef $SZDIR, ByRef $SZFNAME, ByRef $SZEXT)
	Local $DRIVE = ""
	Local $DIR = ""
	Local $FNAME = ""
	Local $EXT = ""
	Local $POS
	Local $ARRAY[5]
	$ARRAY[0] = $SZPATH
	If StringMid($SZPATH, 2, 1) = ":" Then
		$DRIVE = StringLeft($SZPATH, 2)
		$SZPATH = StringTrimLeft($SZPATH, 2)
	ElseIf StringLeft($SZPATH, 2) = "\\" Then
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
	Local $HWRITEHANDLE, $AFILELINES, $NCOUNT, $SENDSWITH, $HFILE
	If StringInStr(FileGetAttrib($SZFILENAME), "R") Then Return SetError(6, 0, -1)
	$HFILE = FileOpen($SZFILENAME, 0)
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
	$AFILELINES = StringSplit(StringStripCR($S_TOTFILE), @LF)
	FileClose($HFILE)
	$HWRITEHANDLE = FileOpen($SZFILENAME, 2)
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
			SetError(3)
			FileClose($HWRITEHANDLE)
			Return -1
		EndIf
	Next
	If $AFILELINES[$NCOUNT] <> "" Then FileWrite($HWRITEHANDLE, $AFILELINES[$NCOUNT] & $SENDSWITH)
	FileClose($HWRITEHANDLE)
	Return $IRETVAL
EndFunc


Func _TEMPFILE($S_DIRECTORYNAME = @TempDir, $S_FILEPREFIX = "~", $S_FILEEXTENSION = ".tmp", $I_RANDOMLENGTH = 7)
	Local $S_TEMPNAME
	If Not FileExists($S_DIRECTORYNAME) Then $S_DIRECTORYNAME = @TempDir
	If Not FileExists($S_DIRECTORYNAME) Then $S_DIRECTORYNAME = @ScriptDir
	If StringRight($S_DIRECTORYNAME, 1) <> "\" Then $S_DIRECTORYNAME = $S_DIRECTORYNAME & "\"
	Do
		$S_TEMPNAME = ""
		While StringLen($S_TEMPNAME) < $I_RANDOMLENGTH
			$S_TEMPNAME = $S_TEMPNAME & Chr(Random(97, 122, 1))
		WEnd
		$S_TEMPNAME = $S_DIRECTORYNAME & $S_FILEPREFIX & $S_TEMPNAME & $S_FILEEXTENSION
	Until Not FileExists($S_TEMPNAME)
	Return ($S_TEMPNAME)
EndFunc

Global Const $ERROR_NO_TOKEN = 1008
Global Const $SE_ASSIGNPRIMARYTOKEN_NAME = "SeAssignPrimaryTokenPrivilege"
Global Const $SE_AUDIT_NAME = "SeAuditPrivilege"
Global Const $SE_BACKUP_NAME = "SeBackupPrivilege"
Global Const $SE_CHANGE_NOTIFY_NAME = "SeChangeNotifyPrivilege"
Global Const $SE_CREATE_GLOBAL_NAME = "SeCreateGlobalPrivilege"
Global Const $SE_CREATE_PAGEFILE_NAME = "SeCreatePagefilePrivilege"
Global Const $SE_CREATE_PERMANENT_NAME = "SeCreatePermanentPrivilege"
Global Const $SE_CREATE_TOKEN_NAME = "SeCreateTokenPrivilege"
Global Const $SE_DEBUG_NAME = "SeDebugPrivilege"
Global Const $SE_ENABLE_DELEGATION_NAME = "SeEnableDelegationPrivilege"
Global Const $SE_IMPERSONATE_NAME = "SeImpersonatePrivilege"
Global Const $SE_INC_BASE_PRIORITY_NAME = "SeIncreaseBasePriorityPrivilege"
Global Const $SE_INCREASE_QUOTA_NAME = "SeIncreaseQuotaPrivilege"
Global Const $SE_LOAD_DRIVER_NAME = "SeLoadDriverPrivilege"
Global Const $SE_LOCK_MEMORY_NAME = "SeLockMemoryPrivilege"
Global Const $SE_MACHINE_ACCOUNT_NAME = "SeMachineAccountPrivilege"
Global Const $SE_MANAGE_VOLUME_NAME = "SeManageVolumePrivilege"
Global Const $SE_PROF_SINGLE_PROCESS_NAME = "SeProfileSingleProcessPrivilege"
Global Const $SE_REMOTE_SHUTDOWN_NAME = "SeRemoteShutdownPrivilege"
Global Const $SE_RESTORE_NAME = "SeRestorePrivilege"
Global Const $SE_SECURITY_NAME = "SeSecurityPrivilege"
Global Const $SE_SHUTDOWN_NAME = "SeShutdownPrivilege"
Global Const $SE_SYNC_AGENT_NAME = "SeSyncAgentPrivilege"
Global Const $SE_SYSTEM_ENVIRONMENT_NAME = "SeSystemEnvironmentPrivilege"
Global Const $SE_SYSTEM_PROFILE_NAME = "SeSystemProfilePrivilege"
Global Const $SE_SYSTEMTIME_NAME = "SeSystemtimePrivilege"
Global Const $SE_TAKE_OWNERSHIP_NAME = "SeTakeOwnershipPrivilege"
Global Const $SE_TCB_NAME = "SeTcbPrivilege"
Global Const $SE_UNSOLICITED_INPUT_NAME = "SeUnsolicitedInputPrivilege"
Global Const $SE_UNDOCK_NAME = "SeUndockPrivilege"
Global Const $SE_PRIVILEGE_ENABLED_BY_DEFAULT = 1
Global Const $SE_PRIVILEGE_ENABLED = 2
Global Const $SE_PRIVILEGE_REMOVED = 4
Global Const $SE_PRIVILEGE_USED_FOR_ACCESS = -2147483648
Global Const $TOKENUSER = 1
Global Const $TOKENGROUPS = 2
Global Const $TOKENPRIVILEGES = 3
Global Const $TOKENOWNER = 4
Global Const $TOKENPRIMARYGROUP = 5
Global Const $TOKENDEFAULTDACL = 6
Global Const $TOKENSOURCE = 7
Global Const $TOKENTYPE = 8
Global Const $TOKENIMPERSONATIONLEVEL = 9
Global Const $TOKENSTATISTICS = 10
Global Const $TOKENRESTRICTEDSIDS = 11
Global Const $TOKENSESSIONID = 12
Global Const $TOKENGROUPSANDPRIVILEGES = 13
Global Const $TOKENSESSIONREFERENCE = 14
Global Const $TOKENSANDBOXINERT = 15
Global Const $TOKENAUDITPOLICY = 16
Global Const $TOKENORIGIN = 17
Global Const $TOKENELEVATIONTYPE = 18
Global Const $TOKENLINKEDTOKEN = 19
Global Const $TOKENELEVATION = 20
Global Const $TOKENHASRESTRICTIONS = 21
Global Const $TOKENACCESSINFORMATION = 22
Global Const $TOKENVIRTUALIZATIONALLOWED = 23
Global Const $TOKENVIRTUALIZATIONENABLED = 24
Global Const $TOKENINTEGRITYLEVEL = 25
Global Const $TOKENUIACCESS = 26
Global Const $TOKENMANDATORYPOLICY = 27
Global Const $TOKENLOGONSID = 28
Global Const $TAGCOMBOBOXINFO = "dword Size;int EditLeft;int EditTop;int EditRight;int EditBottom;int BtnLeft;int BtnTop;" & "int BtnRight;int BtnBottom;dword BtnState;hwnd hCombo;hwnd hEdit;hwnd hList"
Global Const $TAGCOMBOBOXEXITEM = "int Mask;int Item;ptr Text;int TextMax;int Image;int SelectedImage;int OverlayImage;" & "int Indent;int Param"
Global Const $TAGNMCBEDRAGBEGIN = "hwnd hWndFrom;int IDFrom;int Code;int ItemID;char Text[1024]"
Global Const $TAGNMCBEENDEDIT = "hwnd hWndFrom;int IDFrom;int Code;int fChanged;int NewSelection;char Text[1024];int Why"
Global Const $TAGNMCOMBOBOXEX = "hwnd hWndFrom;int IDFrom;int Code;int Mask;int Item;ptr Text;int TextMax;int Image;" & "int SelectedImage;int OverlayImage;int Indent;int Param"
Global Const $TAGDTPRANGE = "short MinYear;short MinMonth;short MinDOW;short MinDay;short MinHour;short MinMinute;" & "short MinSecond;short MinMSecond;short MaxYear;short MaxMonth;short MaxDOW;short MaxDay;short MaxHour;" & "short MaxMinute;short MaxSecond;short MaxMSecond;int MinValid;int MaxValid"
Global Const $TAGDTPTIME = "short Year;short Month;short DOW;short Day;short Hour;short Minute;short Second;short MSecond"
Global Const $TAGNMDATETIMECHANGE = "hwnd hWndFrom;int IDFrom;int Code;int Flag;short Year;short Month;short DOW;short Day;" & "short Hour;short Minute;short Second;short MSecond"
Global Const $TAGNMDATETIMEFORMAT = "hwnd hWndFrom;int IDFrom;int Code;ptr Format;short Year;short Month;short DOW;short Day;" & "short Hour;short Minute;short Second;short MSecond;ptr pDisplay;char Display[64]"
Global Const $TAGNMDATETIMEFORMATQUERY = "hwnd hWndFrom;int IDFrom;int Code;ptr Format;int SizeX;int SizeY"
Global Const $TAGNMDATETIMEKEYDOWN = "hwnd hWndFrom;int IDFrom;int Code;int VirtKey;ptr Format;short Year;short Month;short DOW;" & "short Day;short Hour;short Minute;short Second;short MSecond"
Global Const $TAGNMDATETIMESTRING = "hwnd hWndFrom;int IDFrom;int Code;ptr UserString;short Year;short Month;short DOW;short Day;" & "short Hour;short Minute;short Second;short MSecond;int Flags"
Global Const $TAGEDITBALLOONTIP = "dword Size;ptr Title;ptr Text;int Icon"
Global Const $TAGEVENTLOGRECORD = "int Length;int Reserved;int RecordNumber;int TimeGenerated;int TimeWritten;int EventID;" & "short EventType;short NumStrings;short EventCategory;short ReservedFlags;int ClosingRecordNumber;int StringOffset;" & "int UserSidLength;int UserSidOffset;int DataLength;int DataOffset"
Global Const $TAGEVENTREAD = "byte Buffer[4096];int BytesRead;int BytesMin"
Global Const $TAGGDIPBITMAPDATA = "uint Width;uint Height;int Stride;uint Format;ptr Scan0;ptr Reserved"
Global Const $TAGGDIPENCODERPARAM = "byte GUID[16];dword Count;dword Type;ptr Values"
Global Const $TAGGDIPENCODERPARAMS = "dword Count;byte Params[0]"
Global Const $TAGGDIPRECTF = "float X;float Y;float Width;float Height"
Global Const $TAGGDIPSTARTUPINPUT = "int Version;ptr Callback;int NoThread;int NoCodecs"
Global Const $TAGGDIPSTARTUPOUTPUT = "ptr HookProc;ptr UnhookProc"
Global Const $TAGGDIPIMAGECODECINFO = "byte CLSID[16];byte FormatID[16];ptr CodecName;ptr DllName;ptr FormatDesc;ptr FileExt;" & "ptr MimeType;dword Flags;dword Version;dword SigCount;dword SigSize;ptr SigPattern;ptr SigMask"
Global Const $TAGGDIPPENCODERPARAMS = "dword Count;byte Params[0]"
Global Const $TAGHDHITTESTINFO = "int X;int Y;int Flags;int Item"
Global Const $TAGHDITEM = "int Mask;int XY;ptr Text;hwnd hBMP;int TextMax;int Fmt;int Param;int Image;int Order;int Type;ptr pFilter;int State"
Global Const $TAGHDLAYOUT = "ptr Rect;ptr WindowPos"
Global Const $TAGHDTEXTFILTER = "ptr Text;int TextMax"
Global Const $TAGNMHDDISPINFO = "hwnd WndFrom;int IDFrom;int Code;int Item;int Mask;ptr Text;int TextMax;int Image;int lParam"
Global Const $TAGNMHDFILTERBTNCLICK = "hwnd hWndFrom;int IDFrom;int Code;int Item;int Left;int Top;int Right;int Bottom"
Global Const $TAGNMHEADER = "hwnd hWndFrom;int IDFrom;int Code;int Item;int Button;ptr pItem"
Global Const $TAGGETIPADDRESS = "ubyte Field4;ubyte Field3;ubyte Field2;ubyte Field1"
Global Const $TAGNMIPADDRESS = "hwnd hWndFrom;int IDFrom;int Code;int Field;int Value"
Global Const $TAGLVBKIMAGE = "int Flags;hwnd hBmp;int Image;int ImageMax;int XOffPercent;int YOffPercent"
Global Const $TAGLVCOLUMN = "int Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order"
Global Const $TAGLVFINDINFO = "int Flags;ptr Text;int Param;int X;int Y;int Direction"
Global Const $TAGLVGROUP = "int Size;int Mask;ptr Header;int HeaderMax;ptr Footer;int FooterMax;int GroupID;int StateMask;int State;int Align"
Global Const $TAGLVHITTESTINFO = "int X;int Y;int Flags;int Item;int SubItem"
Global Const $TAGLVINSERTMARK = "uint Size;dword Flags;int Item;dword Reserved"
Global Const $TAGLVITEM = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;" & "int Indent;int GroupID;int Columns;ptr pColumns"
Global Const $TAGNMLISTVIEW = "hwnd hWndFrom;int IDFrom;int Code;int Item;int SubItem;int NewState;int OldState;int Changed;" & "int ActionX;int ActionY;int Param"
Global Const $TAGNMLVCUSTOMDRAW = "hwnd hWndFrom;int IDFrom;int Code;dword dwDrawStage;hwnd hdc;int Left;int Top;int Right;int Bottom;" & "dword dwItemSpec;uint uItemState;long lItemlParam;int clrText;int clrTextBk;int iSubItem;dword dwItemType;int clrFace;int iIconEffect;" & "int iIconPhase;int iPartId;int iStateId;int TextLeft;int TextTop;int TextRight;int TextBottom;uint uAlign"
Global Const $TAGNMLVDISPINFO = "hwnd hWndFrom;int IDFrom;int Code;int Mask;int Item;int SubItem;int State;int StateMask;" & "ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns"
Global Const $TAGNMLVFINDITEM = "hwnd hWndFrom;int IDFrom;int Code;int Start;int Flags;ptr Text;int Param;int X;int Y;int Direction"
Global Const $TAGNMLVGETINFOTIP = "hwnd hWndFrom;int IDFrom;int Code;int Flags;ptr Text;int TextMax;int Item;int SubItem;int lParam"
Global Const $TAGNMITEMACTIVATE = "hwnd hWndFrom;int IDFrom;int Code;int Index;int SubItem;int NewState;int OldState;" & "int Changed;int X;int Y;int lParam;int KeyFlags"
Global Const $TAGNMLVKEYDOWN = "hwnd hWndFrom;int IDFrom;int Code;int VKey;int Flags"
Global Const $TAGNMLVSCROLL = "hwnd hWndFrom;int IDFrom;int Code;int DX;int DY"
Global Const $TAGLVSETINFOTIP = "int Size;int Flags;ptr Text;int Item;int SubItem"
Global Const $TAGMCHITTESTINFO = "int Size;int X;int Y;int Hit;short Year;short Month;short DOW;short Day;short Hour;" & "short Minute;short Second;short MSeconds"
Global Const $TAGMCMONTHRANGE = "short MinYear;short MinMonth;short MinDOW;short MinDay;short MinHour;short MinMinute;short MinSecond;" & "short MinMSeconds;short MaxYear;short MaxMonth;short MaxDOW;short MaxDay;short MaxHour;short MaxMinute;short MaxSecond;" & "short MaxMSeconds;short Span"
Global Const $TAGMCRANGE = "short MinYear;short MinMonth;short MinDOW;short MinDay;short MinHour;short MinMinute;short MinSecond;" & "short MinMSeconds;short MaxYear;short MaxMonth;short MaxDOW;short MaxDay;short MaxHour;short MaxMinute;short MaxSecond;" & "short MaxMSeconds;short MinSet;short MaxSet"
Global Const $TAGMCSELRANGE = "short MinYear;short MinMonth;short MinDOW;short MinDay;short MinHour;short MinMinute;short MinSecond;" & "short MinMSeconds;short MaxYear;short MaxMonth;short MaxDOW;short MaxDay;short MaxHour;short MaxMinute;short MaxSecond;" & "short MaxMSeconds"
Global Const $TAGNMDAYSTATE = "hwnd hWndFrom;int IDFrom;int Code;short Year;short Month;short DOW;short Day;short Hour;" & "short Minute;short Second;short MSeconds;int DayState;ptr pDayState"
Global Const $TAGNMSELCHANGE = "hwnd hWndFrom;int IDFrom;int Code;short BegYear;short BegMonth;short BegDOW;short BegDay;" & "short BegHour;short BegMinute;short BegSecond;short BegMSeconds;short EndYear;short EndMonth;short EndDOW;" & "short EndDay;short EndHour;short EndMinute;short EndSecond;short EndMSeconds"
Global Const $TAGNMOBJECTNOTIFY = "hwnd hWndFrom;int IDFrom;int Code;int Item;ptr piid;ptr pObject;int Result"
Global Const $TAGNMTCKEYDOWN = "hwnd hWndFrom;int IDFrom;int Code;int VKey;int Flags"
Global Const $TAGTCITEM = "int Mask;int State;int StateMask;ptr Text;int TextMax;int Image;int Param"
Global Const $TAGTCHITTESTINFO = "int X;int Y;int Flags"
Global Const $TAGTVITEMEX = "int Mask;int hItem;int State;int StateMask;ptr Text;int TextMax;int Image;int SelectedImage;" & "int Children;int Param;int Integral"
Global Const $TAGNMTREEVIEW = "hwnd hWndFrom;int IDFrom;int Code;int Action;int OldMask;int OldhItem;int OldState;int OldStateMask;" & "ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;int OldParam;int NewMask;int NewhItem;" & "int NewState;int NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;" & "int NewParam;int PointX; int PointY"
Global Const $TAGNMTVCUSTOMDRAW = "hwnd hWndFrom;int IDFrom;int Code;uint DrawStage;hwnd HDC;int Left;int Top;int Right;int Bottom;" & "ptr ItemSpec;uint ItemState;int ItemParam;int ClrText;int ClrTextBk;int Level"
Global Const $TAGNMTVDISPINFO = "hwnd hWndFrom;int IDFrom;int Code;int Mask;int hItem;int State;int StateMask;" & "ptr Text;int TextMax;int Image;int SelectedImage;int Children;int Param"
Global Const $TAGNMTVGETINFOTIP = "hwnd hWndFrom;int IDFrom;int Code;ptr Text;int TextMax;hwnd hItem;int lParam"
Global Const $TAGTVHITTESTINFO = "int X;int Y;int Flags;int Item"
Global Const $TAGTVINSERTSTRUCT = "hwnd Parent;int InsertAfter;int Mask;hwnd hItem;int State;int StateMask;ptr Text;int TextMax;" & "int Image;int SelectedImage;int Children;int Param"
Global Const $TAGNMTVKEYDOWN = "hwnd hWndFrom;int IDFrom;int Code;int VKey;int Flags"
Global Const $TAGNMTTDISPINFO = "hwnd hWndFrom;int IDFrom;int Code;ptr pText;char aText[80];hwnd Instance;int Flags;int Param"
Global Const $TAGTOOLINFO = "int Size;int Flags;hwnd hWnd;int ID;int Left;int Top;int Right;int Bottom;hwnd hInst;ptr Text;int Param;ptr Reserved"
Global Const $TAGTTGETTITLE = "int Size;int Bitmap;int TitleMax;ptr Title"
Global Const $TAGTTHITTESTINFO = "hwnd Tool;int X;int Y;int Size;int Flags;hwnd hWnd;int ID;int Left;int Top;int Right;int Bottom;" & "hwnd hInst;ptr Text;int Param;ptr Reserved"
Global Const $TAGNMHDR = "hwnd hWndFrom;int IDFrom;int Code"
Global Const $TAGNMMOUSE = "hwnd hWndFrom;int IDFrom;int Code;dword ItemSpec;dword ItemData;int X;int Y;dword HitInfo"
Global Const $TAGPOINT = "int X;int Y"
Global Const $TAGRECT = "int Left;int Top;int Right;int Bottom"
Global Const $TAGMARGINS = "int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight"
Global Const $TAGSIZE = "int X;int Y"
Global Const $TAGTOKEN_PRIVILEGES = "int Count;int64 LUID;int Attributes"
Global Const $TAGIMAGEINFO = "hwnd hBitmap;hwnd hMask;int Unused1;int Unused2;int Left;int Top;int Right;int Bottom"
Global Const $TAGIMAGELISTDRAWPARAMS = "int Size;hwnd hWnd;int Image;hwnd hDC;int X;int Y;int CX;int CY;int XBitmap;int YBitmap;" & "int BK;int FG;int Style;int ROP;int State;int Frame;int Effect"
Global Const $TAGMEMMAP = "hwnd hProc;int Size;ptr Mem"
Global Const $TAGMDINEXTMENU = "hwnd hMenuIn;hwnd hMenuNext;hwnd hWndNext"
Global Const $TAGMENUBARINFO = "int Size;int Left;int Top;int Right;int Bottom;int hMenu;int hWndMenu;int Focused"
Global Const $TAGMENUEX_TEMPLATE_HEADER = "short Version;short Offset;int HelpID"
Global Const $TAGMENUEX_TEMPLATE_ITEM = "int HelpID;int Type;int State;int MenuID;short ResInfo;ptr Text"
Global Const $TAGMENUGETOBJECTINFO = "int Flags;int Pos;hwnd hMenu;ptr RIID;ptr Obj"
Global Const $TAGMENUINFO = "int Size;int Mask;int Style;int YMax;int hBack;int ContextHelpID;ptr MenuData"
Global Const $TAGMENUITEMINFO = "int Size;int Mask;int Type;int State;int ID;int SubMenu;int BmpChecked;int BmpUnchecked;" & "int ItemData;ptr TypeData;int CCH;int BmpItem"
Global Const $TAGMENUITEMTEMPLATE = "short Option;short ID;ptr String"
Global Const $TAGMENUITEMTEMPLATEHEADER = "short Version;short Offset"
Global Const $TAGTPMPARAMS = "short Version;short Offset"
Global Const $TAGCONNECTION_INFO_1 = "int ID;int Type;int Opens;int Users;int Time;ptr Username;ptr NetName"
Global Const $TAGFILE_INFO_3 = "int ID;int Permissions;int Locks;ptr Pathname;ptr Username"
Global Const $TAGSESSION_INFO_2 = "ptr CName;ptr Username;int Opens;int Time;int Idle;int Flags;ptr TypeName"
Global Const $TAGSESSION_INFO_502 = "ptr CName;ptr Username;int Opens;int Time;int Idle;int Flags;ptr TypeName;ptr Transport"
Global Const $TAGSHARE_INFO_2 = "ptr NetName;int Type;ptr Remark;int Permissions;int MaxUses;int CurrentUses;ptr Path;ptr Password"
Global Const $TAGSTAT_SERVER_0 = "int Start;int FOpens;int DevOpens;int JobsQueued;int SOpens;int STimedOut;int SErrorOut;" & "int PWErrors;int PermErrors;int SysErrors;int64 ByteSent;int64 ByteRecv;int AvResponse;int ReqBufNeed;int BigBufNeed"
Global Const $TAGSTAT_WORKSTATION_0 = "int64 StartTime;int64 BytesRecv;int64 SMBSRecv;int64 PageRead;int64 NonPageRead;" & "int64 CacheRead;int64 NetRead;int64 BytesTran;int64 SMBSTran;int64 PageWrite;int64 NonPageWrite;int64 CacheWrite;" & "int64 NetWrite;int InitFailed;int FailedComp;int ReadOp;int RandomReadOp;int ReadSMBS;int LargeReadSMBS;" & "int SmallReadSMBS;int WriteOp;int RandomWriteOp;int WriteSMBS;int LargeWriteSMBS;int SmallWriteSMBS;" & "int RawReadsDenied;int RawWritesDenied;int NetworkErrors;int Sessions;int FailedSessions;int Reconnects;" & "int CoreConnects;int LM20Connects;int LM21Connects;int LMNTConnects;int ServerDisconnects;int HungSessions;" & "int UseCount;int FailedUseCount;int CurrentCommands"
Global Const $TAGFILETIME = "dword Lo;dword Hi"
Global Const $TAGSYSTEMTIME = "short Year;short Month;short Dow;short Day;short Hour;short Minute;short Second;short MSeconds"
Global Const $TAGTIME_ZONE_INFORMATION = "long Bias;byte StdName[64];ushort StdDate[8];long StdBias;byte DayName[64];ushort DayDate[8];long DayBias"
Global Const $TAGPBRANGE = "int Low;int High"
Global Const $TAGREBARBANDINFO = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;hwnd hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;int lParam;uint cxHeader"
Global Const $TAGNMREBARAUTOBREAK = "hwnd hWndFrom;int IDFrom;int Code;uint uBand;uint wID;int lParam;uint uMsg;uint fStyleCurrent;int fAutoBreak"
Global Const $TAGNMRBAUTOSIZE = "hwnd hWndFrom;int IDFrom;int Code;int fChanged;int TargetLeft;int TargetTop;int TargetRight;int TargetBottom;" & "int ActualLeft;int ActualTop;int ActualRight;int ActualBottom"
Global Const $TAGNMREBAR = "hwnd hWndFrom;int IDFrom;int Code;dword dwMask;uint uBand;uint fStyle;uint wID;int lParam"
Global Const $TAGNMREBARCHEVRON = "hwnd hWndFrom;int IDFrom;int Code;uint uBand;uint wID;int lParam;int Left;int Top;int Right;int Bottom;int lParamNM"
Global Const $TAGNMREBARCHILDSIZE = "hwnd hWndFrom;int IDFrom;int Code;uint uBand;uint wID;int CLeft;int CTop;int CRight;int CBottom;" & "int BLeft;int BTop;int BRight;int BBottom"
Global Const $TAGREBARINFO = "uint cbSize;uint fMask;hwnd himl"
Global Const $TAGRBHITTESTINFO = "int X;int Y;uint flags;int iBand"
Global Const $TAGCOLORSCHEME = "int Size;int BtnHighlight;int BtnShadow"
Global Const $TAGTBADDBITMAP = "int hInst;int ID"
Global Const $TAGNMTOOLBAR = "hwnd hWndFrom;int IDFrom;int Code;int iItem;int iBitmap;int idCommand;" & "byte fsState;byte fsStyle;byte bReserved1;byte bReserved2;dword dwData;int iString;int cchText;" & "ptr pszText;int Left;int Top;int Right;int Bottom"
Global Const $TAGNMTBHOTITEM = "hwnd hWndFrom;int IDFrom;int Code;int idOld;int idNew;dword dwFlags"
Global Const $TAGTBBUTTON = "int Bitmap;int Command;byte State;byte Style;short Reserved;int Param;int String"
Global Const $TAGTBBUTTONINFO = "int Size;int Mask;int Command;int Image;byte State;byte Style;short CX;int Param;ptr Text;int TextMax"
Global Const $TAGTBINSERTMARK = "int Button;int Flags"
Global Const $TAGTBMETRICS = "int Size;int Mask;int XPad;int YPad;int XBarPad;int YBarPad;int XSpacing;int YSpacing"
Global Const $TAGCONNECTDLGSTRUCT = "int Size;hwnd hWnd;ptr Resource;int Flags;int DevNum"
Global Const $TAGDISCDLGSTRUCT = "int Size;hwnd hWnd;ptr LocalName;ptr RemoteName;int Flags"
Global Const $TAGNETCONNECTINFOSTRUCT = "int Size;int Flags;int Speed;int Delay;int OptDataSize"
Global Const $TAGNETINFOSTRUCT = "int Size;int Version;int Status;int Char;int Handle;short NetType;int Printers;int Drives;short Reserved"
Global Const $TAGNETRESOURCE = "int Scope;int Type;int DisplayType;int Usage;ptr LocalName;ptr RemoteName;ptr Comment;ptr Provider"
Global Const $TAGREMOTENAMEINFO = "ptr Universal;ptr Connection;ptr Remaining"
Global Const $TAGOVERLAPPED = "int Internal;int InternalHigh;int Offset;int OffsetHigh;int hEvent"
Global Const $TAGOPENFILENAME = "dword StructSize;hwnd hwndOwner;hwnd hInstance;ptr lpstrFilter;ptr lpstrCustomFilter;" & "dword nMaxCustFilter;dword nFilterIndex;ptr lpstrFile;dword nMaxFile;ptr lpstrFileTitle;int nMaxFileTitle;" & "ptr lpstrInitialDir;ptr lpstrTitle;dword Flags;short nFileOffset;short nFileExtension;ptr lpstrDefExt;ptr lCustData;" & "ptr lpfnHook;ptr lpTemplateName;ptr pvReserved;dword dwReserved;dword FlagsEx"
Global Const $TAGBITMAPINFO = "dword Size;long Width;long Height;ushort Planes;ushort BitCount;dword Compression;dword SizeImage;" & "long XPelsPerMeter;long YPelsPerMeter;dword ClrUsed;dword ClrImportant;dword RGBQuad"
Global Const $TAGBLENDFUNCTION = "byte Op;byte Flags;byte Alpha;byte Format"
Global Const $TAGBORDERS = "int BX;int BY;int RX"
Global Const $TAGCHOOSECOLOR = "dword Size;hwnd hWndOwnder;hwnd hInstance;int rgbResult;ptr CustColors;dword Flags;int lCustData;" & "ptr lpfnHook;ptr lpTemplateName"
Global Const $TAGCHOOSEFONT = "dword Size;hwnd hWndOwner;hwnd hDC;ptr LogFont;int PointSize;dword Flags;int rgbColors;int CustData;" & "ptr fnHook;ptr TemplateName;hwnd hInstance;ptr szStyle;dword FontType;int SizeMin;int SizeMax"
Global Const $TAGTEXTMETRIC = "long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;" & "long tmAveCharWidth;long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;" & "char tmFirstChar;char tmLastChar;char tmDefaultChar;char tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & "byte tmPitchAndFamily;byte tmCharSet"
Global Const $TAGCURSORINFO = "int Size;int Flags;hwnd hCursor;int X;int Y"
Global Const $TAGDISPLAY_DEVICE = "int Size;char Name[32];char String[128];int Flags;char ID[128];char Key[128]"
Global Const $TAGFLASHWINDOW = "int Size;hwnd hWnd;int Flags;int Count;int TimeOut"
Global Const $TAGGUID = "int Data1;short Data2;short Data3;byte Data4[8]"
Global Const $TAGICONINFO = "int Icon;int XHotSpot;int YHotSpot;hwnd hMask;hwnd hColor"
Global Const $TAGWINDOWPOS = "hwnd hWnd;int InsertAfter;int X;int Y;int CX;int CY;int Flags"
Global Const $TAGSCROLLINFO = "uint cbSize;uint fMask;int  nMin;int  nMax;uint nPage;int  nPos;int  nTrackPos"
Global Const $TAGSCROLLBARINFO = "dword cbSize;int Left;int Top;int Right;int Bottom;int dxyLineButton;int xyThumbTop;" & "int xyThumbBottom;int reserved;dword rgstate[6]"
Global Const $TAGLOGFONT = "int Height;int Width;int Escapement;int Orientation;int Weight;byte Italic;byte Underline;" & "byte Strikeout;byte CharSet;byte OutPrecision;byte ClipPrecision;byte Quality;byte PitchAndFamily;char FaceName[32]"
Global Const $TAGKBDLLHOOKSTRUCT = "dword vkCode;dword scanCode;dword flags;dword time;ulong_ptr dwExtraInfo"
Global Const $TAGPROCESS_INFORMATION = "hwnd hProcess;hwnd hThread;int ProcessID;int ThreadID"
Global Const $TAGSTARTUPINFO = "int Size;ptr Reserved1;ptr Desktop;ptr Title;int X;int Y;int XSize;int YSize;int XCountChars;" & "int YCountChars;int FillAttribute;int Flags;short ShowWindow;short Reserved2;ptr Reserved3;int StdInput;" & "int StdOutput;int StdError"
Global Const $TAGSECURITY_ATTRIBUTES = "int Length;ptr Descriptor;int InheritHandle"
Global Const $__SECURITYCONTANT_FORMAT_MESSAGE_FROM_SYSTEM = 4096

Func _SECURITY__ADJUSTTOKENPRIVILEGES($HTOKEN, $FDISABLEALL, $PNEWSTATE, $IBUFFERLEN, $PPREVSTATE = 0, $PREQUIRED = 0)
	Local $ARESULT
	$ARESULT = DllCall("Advapi32.dll", "int", "AdjustTokenPrivileges", "hwnd", $HTOKEN, "int", $FDISABLEALL, "ptr", $PNEWSTATE, "int", $IBUFFERLEN, "ptr", $PPREVSTATE, "ptr", $PREQUIRED)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0] <> 0)
EndFunc


Func _SECURITY__GETACCOUNTSID($SACCOUNT, $SSYSTEM = "")
	Local $AACCT
	$AACCT = _SECURITY__LOOKUPACCOUNTNAME($SACCOUNT, $SSYSTEM)
	If @error Then Return SetError(@error, 0, 0)
	Return _SECURITY__STRINGSIDTOSID($AACCT[0])
EndFunc


Func _SECURITY__GETLENGTHSID($PSID)
	Local $ARESULT
	If Not _SECURITY__ISVALIDSID($PSID) Then Return SetError(-1, 0, 0)
	$ARESULT = DllCall("AdvAPI32.dll", "int", "GetLengthSid", "ptr", $PSID)
	Return $ARESULT[0]
EndFunc


Func _SECURITY__GETTOKENINFORMATION($HTOKEN, $ICLASS)
	Local $PBUFFER, $TBUFFER, $ARESULT
	$ARESULT = DllCall("Advapi32.dll", "int", "GetTokenInformation", "hwnd", $HTOKEN, "int", $ICLASS, "ptr", 0, "int", 0, "int*", 0)
	$TBUFFER = DllStructCreate("byte[" & $ARESULT[5] & "]")
	$PBUFFER = DllStructGetPtr($TBUFFER)
	$ARESULT = DllCall("Advapi32.dll", "int", "GetTokenInformation", "hwnd", $HTOKEN, "int", $ICLASS, "ptr", $PBUFFER, "int", $ARESULT[5], "int*", 0)
	If $ARESULT[0] = 0 Then Return SetError(-1, 0, 0)
	Return SetError(0, 0, $TBUFFER)
EndFunc


Func _SECURITY__IMPERSONATESELF($ILEVEL = 2)
	Local $ARESULT
	$ARESULT = DllCall("Advapi32.dll", "int", "ImpersonateSelf", "int", $ILEVEL)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0] <> 0)
EndFunc


Func _SECURITY__ISVALIDSID($PSID)
	Local $ARESULT
	$ARESULT = DllCall("AdvAPI32.dll", "int", "IsValidSid", "ptr", $PSID)
	Return $ARESULT[0] <> 0
EndFunc


Func _SECURITY__LOOKUPACCOUNTNAME($SACCOUNT, $SSYSTEM = "")
	Local $TDATA, $PDOMAIN, $PSID, $PSIZE1, $PSIZE2, $PSNU, $ARESULT, $AACCT[3]
	$TDATA = DllStructCreate("byte SID[256];char Domain[256];int SNU;int Size1;int Size2")
	$PSID = DllStructGetPtr($TDATA, "SID")
	$PDOMAIN = DllStructGetPtr($TDATA, "Domain")
	$PSNU = DllStructGetPtr($TDATA, "SNU")
	$PSIZE1 = DllStructGetPtr($TDATA, "Size1")
	$PSIZE2 = DllStructGetPtr($TDATA, "Size2")
	DllStructSetData($TDATA, "Size1", 256)
	DllStructSetData($TDATA, "Size2", 256)
	$ARESULT = DllCall("AdvAPI32.dll", "int", "LookupAccountName", "str", $SSYSTEM, "str", $SACCOUNT, "ptr", $PSID, "ptr", $PSIZE1, "ptr", $PDOMAIN, "ptr", $PSIZE2, "ptr", $PSNU)
	If $ARESULT[0] <> 0 Then
		$AACCT[0] = _SECURITY__SIDTOSTRINGSID($PSID)
		$AACCT[1] = DllStructGetData($TDATA, "Domain")
		$AACCT[2] = DllStructGetData($TDATA, "SNU")
	EndIf
	Return SetError($ARESULT[0] = 0, 0, $AACCT)
EndFunc


Func _SECURITY__LOOKUPACCOUNTSID($VSID)
	Local $TDATA, $PDOMAIN, $PNAME, $PSID, $TSID, $PSIZE1, $PSIZE2, $PSNU, $ARESULT, $AACCT[3]
	If IsString($VSID) Then
		$TSID = _SECURITY__STRINGSIDTOSID($VSID)
		$PSID = DllStructGetPtr($TSID)
	Else
		$PSID = $VSID
	EndIf
	If Not _SECURITY__ISVALIDSID($PSID) Then Return SetError(-1, 0, 0)
	$TDATA = DllStructCreate("char Name[256];char Domain[256];int SNU;int Size1;int Size2")
	$PNAME = DllStructGetPtr($TDATA, "Name")
	$PDOMAIN = DllStructGetPtr($TDATA, "Domain")
	$PSNU = DllStructGetPtr($TDATA, "SNU")
	$PSIZE1 = DllStructGetPtr($TDATA, "Size1")
	$PSIZE2 = DllStructGetPtr($TDATA, "Size2")
	DllStructSetData($TDATA, "Size1", 256)
	DllStructSetData($TDATA, "Size2", 256)
	$ARESULT = DllCall("AdvAPI32.dll", "int", "LookupAccountSid", "int", 0, "ptr", $PSID, "ptr", $PNAME, "ptr", $PSIZE1, "ptr", $PDOMAIN, "ptr", $PSIZE2, "ptr", $PSNU)
	$AACCT[0] = DllStructGetData($TDATA, "Name")
	$AACCT[1] = DllStructGetData($TDATA, "Domain")
	$AACCT[2] = DllStructGetData($TDATA, "SNU")
	Return SetError($ARESULT[0] = 0, 0, $AACCT)
EndFunc


Func _SECURITY__LOOKUPPRIVILEGEVALUE($SSYSTEM, $SNAME)
	Local $TDATA, $ARESULT
	$TDATA = DllStructCreate("int64 LUID")
	$ARESULT = DllCall("Advapi32.dll", "int", "LookupPrivilegeValue", "str", $SSYSTEM, "str", $SNAME, "ptr", DllStructGetPtr($TDATA))
	Return SetError($ARESULT[0] = 0, 0, DllStructGetData($TDATA, "LUID"))
EndFunc


Func _SECURITY__OPENPROCESSTOKEN($HPROCESS, $IACCESS)
	Local $ARESULT
	$ARESULT = DllCall("Advapi32.dll", "int", "OpenProcessToken", "hwnd", $HPROCESS, "dword", $IACCESS, "int*", 0)
	Return SetError($ARESULT[0], 0, $ARESULT[3])
EndFunc


Func _SECURITY__OPENTHREADTOKEN($IACCESS, $HTHREAD = 0, $FOPENASSELF = False)
	Local $TDATA, $PTOKEN, $ARESULT
	If $HTHREAD = 0 Then $HTHREAD = _WINAPI_GETCURRENTTHREAD()
	$TDATA = DllStructCreate("int Token")
	$PTOKEN = DllStructGetPtr($TDATA, "Token")
	$ARESULT = DllCall("Advapi32.dll", "int", "OpenThreadToken", "int", $HTHREAD, "int", $IACCESS, "int", $FOPENASSELF, "ptr", $PTOKEN)
	Return SetError($ARESULT[0] = 0, 0, DllStructGetData($TDATA, "Token"))
EndFunc


Func _SECURITY__OPENTHREADTOKENEX($IACCESS, $HTHREAD = 0, $FOPENASSELF = False)
	Local $HTOKEN
	$HTOKEN = _SECURITY__OPENTHREADTOKEN($IACCESS, $HTHREAD, $FOPENASSELF)
	If $HTOKEN = 0 Then
		If _WINAPI_GETLASTERROR() = $ERROR_NO_TOKEN Then
			If Not _SECURITY__IMPERSONATESELF() Then Return SetError(-1, _WINAPI_GETLASTERROR(), 0)
			$HTOKEN = _SECURITY__OPENTHREADTOKEN($IACCESS, $HTHREAD, $FOPENASSELF)
			If $HTOKEN = 0 Then Return SetError(-2, _WINAPI_GETLASTERROR(), 0)
		Else
			Return SetError(-3, _WINAPI_GETLASTERROR(), 0)
		EndIf
	EndIf
	Return SetError(0, 0, $HTOKEN)
EndFunc


Func _SECURITY__SETPRIVILEGE($HTOKEN, $SPRIVILEGE, $FENABLE)
	Local $PREQUIRED, $TREQUIRED, $ILUID, $IATTRIBUTES, $ICURRSTATE, $PCURRSTATE, $TCURRSTATE, $IPREVSTATE, $PPREVSTATE, $TPREVSTATE
	$ILUID = _SECURITY__LOOKUPPRIVILEGEVALUE("", $SPRIVILEGE)
	If $ILUID = 0 Then Return SetError(-1, 0, False)
	$TCURRSTATE = DllStructCreate($TAGTOKEN_PRIVILEGES)
	$PCURRSTATE = DllStructGetPtr($TCURRSTATE)
	$ICURRSTATE = DllStructGetSize($TCURRSTATE)
	$TPREVSTATE = DllStructCreate($TAGTOKEN_PRIVILEGES)
	$PPREVSTATE = DllStructGetPtr($TPREVSTATE)
	$IPREVSTATE = DllStructGetSize($TPREVSTATE)
	$TREQUIRED = DllStructCreate("int Data")
	$PREQUIRED = DllStructGetPtr($TREQUIRED)
	DllStructSetData($TCURRSTATE, "Count", 1)
	DllStructSetData($TCURRSTATE, "LUID", $ILUID)
	If Not _SECURITY__ADJUSTTOKENPRIVILEGES($HTOKEN, False, $PCURRSTATE, $ICURRSTATE, $PPREVSTATE, $PREQUIRED) Then
		Return SetError(-2, @error, False)
	EndIf
	DllStructSetData($TPREVSTATE, "Count", 1)
	DllStructSetData($TPREVSTATE, "LUID", $ILUID)
	$IATTRIBUTES = DllStructGetData($TPREVSTATE, "Attributes")
	If $FENABLE Then
		$IATTRIBUTES = BitOR($IATTRIBUTES, $SE_PRIVILEGE_ENABLED)
	Else
		$IATTRIBUTES = BitAND($IATTRIBUTES, BitNOT($SE_PRIVILEGE_ENABLED))
	EndIf
	DllStructSetData($TPREVSTATE, "Attributes", $IATTRIBUTES)
	If Not _SECURITY__ADJUSTTOKENPRIVILEGES($HTOKEN, False, $PPREVSTATE, $IPREVSTATE, $PCURRSTATE, $PREQUIRED) Then
		Return SetError(-3, @error, False)
	EndIf
	Return SetError(0, 0, True)
EndFunc


Func _SECURITY__SIDTOSTRINGSID($PSID)
	Local $TPTR, $TBUFFER, $SSID, $ARESULT
	If Not _SECURITY__ISVALIDSID($PSID) Then Return SetError(-1, 0, "")
	$TPTR = DllStructCreate("ptr Buffer")
	$ARESULT = DllCall("AdvAPI32.dll", "int", "ConvertSidToStringSid", "ptr", $PSID, "ptr", DllStructGetPtr($TPTR))
	If $ARESULT[0] = 0 Then Return SetError(-2, 0, "")
	$TBUFFER = DllStructCreate("char Text[256]", DllStructGetData($TPTR, "Buffer"))
	$SSID = DllStructGetData($TBUFFER, "Text")
	_WINAPI_LOCALFREE(DllStructGetData($TPTR, "Buffer"))
	Return $SSID
EndFunc


Func _SECURITY__SIDTYPESTR($ITYPE)
	Switch $ITYPE
		Case 1
			Return "User"
		Case 2
			Return "Group"
		Case 3
			Return "Domain"
		Case 4
			Return "Alias"
		Case 5
			Return "Well Known Group"
		Case 6
			Return "Deleted Account"
		Case 7
			Return "Invalid"
		Case 8
			Return "Invalid"
		Case 9
			Return "Computer"
		Case Else
			Return "Unknown SID Type"
	EndSwitch
EndFunc


Func _SECURITY__STRINGSIDTOSID($SSID)
	Local $TPTR, $ISIZE, $TBUFFER, $TSID, $ARESULT
	$TPTR = DllStructCreate("ptr Buffer")
	$ARESULT = DllCall("AdvAPI32.dll", "int", "ConvertStringSidToSid", "str", $SSID, "ptr", DllStructGetPtr($TPTR))
	If $ARESULT = 0 Then Return SetError(-1, 0, 0)
	$ISIZE = _SECURITY__GETLENGTHSID(DllStructGetData($TPTR, "Buffer"))
	$TBUFFER = DllStructCreate("byte Data[" & $ISIZE & "]", DllStructGetData($TPTR, "Buffer"))
	$TSID = DllStructCreate("byte Data[" & $ISIZE & "]")
	DllStructSetData($TSID, "Data", DllStructGetData($TBUFFER, "Data"))
	_WINAPI_LOCALFREE(DllStructGetData($TPTR, "Buffer"))
	Return $TSID
EndFunc


Func _SENDMESSAGE($HWND, $IMSG, $WPARAM = 0, $LPARAM = 0, $IRETURN = 0, $WPARAMTYPE = "wparam", $LPARAMTYPE = "lparam", $SRETURNTYPE = "lparam")
	Local $ARESULT = DllCall("user32.dll", $SRETURNTYPE, "SendMessage", "hwnd", $HWND, "int", $IMSG, $WPARAMTYPE, $WPARAM, $LPARAMTYPE, $LPARAM)
	If @error Then Return SetError(@error, @extended, "")
	If $IRETURN >= 0 And $IRETURN <= 4 Then Return $ARESULT[$IRETURN]
	Return $ARESULT
EndFunc


Func _SENDMESSAGEA($HWND, $IMSG, $WPARAM = 0, $LPARAM = 0, $IRETURN = 0, $WPARAMTYPE = "wparam", $LPARAMTYPE = "lparam", $SRETURNTYPE = "lparam")
	Local $ARESULT = DllCall("user32.dll", $SRETURNTYPE, "SendMessageA", "hwnd", $HWND, "int", $IMSG, $WPARAMTYPE, $WPARAM, $LPARAMTYPE, $LPARAM)
	If @error Then Return SetError(@error, @extended, "")
	If $IRETURN >= 0 And $IRETURN <= 4 Then Return $ARESULT[$IRETURN]
	Return $ARESULT
EndFunc

Global $WINAPI_GAINPROCESS[64][2] = [[0, 0]]
Global $WINAPI_GAWINLIST[64][2] = [[0, 0]]
Global Const $__WINAPCONSTANT_WM_SETFONT = 48
Global Const $__WINAPCONSTANT_FW_NORMAL = 400
Global Const $__WINAPCONSTANT_DEFAULT_CHARSET = 1
Global Const $__WINAPCONSTANT_OUT_DEFAULT_PRECIS = 0
Global Const $__WINAPCONSTANT_CLIP_DEFAULT_PRECIS = 0
Global Const $__WINAPCONSTANT_DEFAULT_QUALITY = 0
Global Const $__WINAPCONSTANT_FORMAT_MESSAGE_FROM_SYSTEM = 4096
Global Const $__WINAPCONSTANT_TOKEN_ADJUST_PRIVILEGES = 32
Global Const $__WINAPCONSTANT_TOKEN_QUERY = 8
Global Const $__WINAPCONSTANT_LOGPIXELSX = 88
Global Const $__WINAPCONSTANT_LOGPIXELSY = 90
Global Const $__WINAPCONSTANT_FLASHW_CAPTION = 1
Global Const $__WINAPCONSTANT_FLASHW_TRAY = 2
Global Const $__WINAPCONSTANT_FLASHW_TIMER = 4
Global Const $__WINAPCONSTANT_FLASHW_TIMERNOFG = 12
Global Const $__WINAPCONSTANT_GW_HWNDNEXT = 2
Global Const $__WINAPCONSTANT_GW_CHILD = 5
Global Const $__WINAPCONSTANT_DI_MASK = 1
Global Const $__WINAPCONSTANT_DI_IMAGE = 2
Global Const $__WINAPCONSTANT_DI_NORMAL = 3
Global Const $__WINAPCONSTANT_DI_COMPAT = 4
Global Const $__WINAPCONSTANT_DI_DEFAULTSIZE = 8
Global Const $__WINAPCONSTANT_DI_NOMIRROR = 16
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = 1
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_PRIMARY_DEVICE = 4
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_MIRRORING_DRIVER = 8
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_VGA_COMPATIBLE = 16
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_REMOVABLE = 32
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_MODESPRUNED = 134217728
Global Const $__WINAPCONSTANT_CREATE_NEW = 1
Global Const $__WINAPCONSTANT_CREATE_ALWAYS = 2
Global Const $__WINAPCONSTANT_OPEN_EXISTING = 3
Global Const $__WINAPCONSTANT_OPEN_ALWAYS = 4
Global Const $__WINAPCONSTANT_TRUNCATE_EXISTING = 5
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_READONLY = 1
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_HIDDEN = 2
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_SYSTEM = 4
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_ARCHIVE = 32
Global Const $__WINAPCONSTANT_FILE_SHARE_READ = 1
Global Const $__WINAPCONSTANT_FILE_SHARE_WRITE = 2
Global Const $__WINAPCONSTANT_FILE_SHARE_DELETE = 4
Global Const $__WINAPCONSTANT_GENERIC_EXECUTE = 536870912
Global Const $__WINAPCONSTANT_GENERIC_WRITE = 1073741824
Global Const $__WINAPCONSTANT_GENERIC_READ = -2147483648
Global Const $NULL_BRUSH = 5
Global Const $NULL_PEN = 8
Global Const $BLACK_BRUSH = 4
Global Const $DKGRAY_BRUSH = 3
Global Const $DC_BRUSH = 18
Global Const $GRAY_BRUSH = 2
Global Const $HOLLOW_BRUSH = $NULL_BRUSH
Global Const $LTGRAY_BRUSH = 1
Global Const $WHITE_BRUSH = 0
Global Const $BLACK_PEN = 7
Global Const $DC_PEN = 19
Global Const $WHITE_PEN = 6
Global Const $ANSI_FIXED_FONT = 11
Global Const $ANSI_VAR_FONT = 12
Global Const $DEVICE_DEFAULT_FONT = 14
Global Const $DEFAULT_GUI_FONT = 17
Global Const $OEM_FIXED_FONT = 10
Global Const $SYSTEM_FONT = 13
Global Const $SYSTEM_FIXED_FONT = 16
Global Const $DEFAULT_PALETTE = 15
Global Const $MB_PRECOMPOSED = 1
Global Const $MB_COMPOSITE = 2
Global Const $MB_USEGLYPHCHARS = 4
Global Const $ULW_ALPHA = 2
Global Const $ULW_COLORKEY = 1
Global Const $ULW_OPAQUE = 4
Global Const $WH_CALLWNDPROC = 4
Global Const $WH_CALLWNDPROCRET = 12
Global Const $WH_CBT = 5
Global Const $WH_DEBUG = 9
Global Const $WH_FOREGROUNDIDLE = 11
Global Const $WH_GETMESSAGE = 3
Global Const $WH_JOURNALPLAYBACK = 1
Global Const $WH_JOURNALRECORD = 0
Global Const $WH_KEYBOARD = 2
Global Const $WH_KEYBOARD_LL = 13
Global Const $WH_MOUSE = 7
Global Const $WH_MOUSE_LL = 14
Global Const $WH_MSGFILTER = -1
Global Const $WH_SHELL = 10
Global Const $WH_SYSMSGFILTER = 6
Global Const $KF_EXTENDED = 256
Global Const $KF_ALTDOWN = 8192
Global Const $KF_UP = 32768
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_INJECTED = 16
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Global Const $OFN_ALLOWMULTISELECT = 512
Global Const $OFN_CREATEPROMPT = 8192
Global Const $OFN_DONTADDTORECENT = 33554432
Global Const $OFN_ENABLEHOOK = 32
Global Const $OFN_ENABLEINCLUDENOTIFY = 4194304
Global Const $OFN_ENABLESIZING = 8388608
Global Const $OFN_ENABLETEMPLATE = 64
Global Const $OFN_ENABLETEMPLATEHANDLE = 128
Global Const $OFN_EXPLORER = 524288
Global Const $OFN_EXTENSIONDIFFERENT = 1024
Global Const $OFN_FILEMUSTEXIST = 4096
Global Const $OFN_FORCESHOWHIDDEN = 268435456
Global Const $OFN_HIDEREADONLY = 4
Global Const $OFN_LONGNAMES = 2097152
Global Const $OFN_NOCHANGEDIR = 8
Global Const $OFN_NODEREFERENCELINKS = 1048576
Global Const $OFN_NOLONGNAMES = 262144
Global Const $OFN_NONETWORKBUTTON = 131072
Global Const $OFN_NOREADONLYRETURN = 32768
Global Const $OFN_NOTESTFILECREATE = 65536
Global Const $OFN_NOVALIDATE = 256
Global Const $OFN_OVERWRITEPROMPT = 2
Global Const $OFN_PATHMUSTEXIST = 2048
Global Const $OFN_READONLY = 1
Global Const $OFN_SHAREAWARE = 16384
Global Const $OFN_SHOWHELP = 16
Global Const $OFN_EX_NOPLACESBAR = 1

Func _WINAPI_ATTACHCONSOLE($IPROCESSID = -1)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "AttachConsole", "dword", $IPROCESSID)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_ATTACHTHREADINPUT($IATTACH, $IATTACHTO, $FATTACH)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "AttachThreadInput", "int", $IATTACH, "int", $IATTACHTO, "int", $FATTACH)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_BEEP($IFREQ = 500, $IDURATION = 1000)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "Beep", "dword", $IFREQ, "dword", $IDURATION)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_BITBLT($HDESTDC, $IXDEST, $IYDEST, $IWIDTH, $IHEIGHT, $HSRCDC, $IXSRC, $IYSRC, $IROP)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "BitBlt", "hwnd", $HDESTDC, "int", $IXDEST, "int", $IYDEST, "int", $IWIDTH, "int", $IHEIGHT, "hwnd", $HSRCDC, "int", $IXSRC, "int", $IYSRC, "int", $IROP)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_CALLNEXTHOOKEX($HHK, $ICODE, $WPARAM, $LPARAM)
	Local $IRESULT = DllCall("user32.dll", "lparam", "CallNextHookEx", "hwnd", $HHK, "int", $ICODE, "wparam", $WPARAM, "lparam", $LPARAM)
	If @error Then Return SetError(@error, @extended, -1)
	Return $IRESULT[0]
EndFunc


Func _WINAPI_CALLWINDOWPROC($LPPREVWNDFUNC, $HWND, $MSG, $WPARAM, $LPARAM)
	Local $ARESULT
	$ARESULT = DllCall("user32.dll", "int", "CallWindowProc", "ptr", $LPPREVWNDFUNC, "hwnd", $HWND, "uint", $MSG, "wparam", $WPARAM, "lparam", $LPARAM)
	If @error Then Return SetError(-1, 0, -1)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CHECK($SFUNCTION, $FERROR, $VERROR, $FTRANSLATE = False)
	If $FERROR Then
		If $FTRANSLATE Then $VERROR = _WINAPI_GETLASTERRORMESSAGE()
		_WINAPI_SHOWERROR($SFUNCTION & ": " & $VERROR)
	EndIf
EndFunc


Func _WINAPI_CLIENTTOSCREEN($HWND, ByRef $TPOINT)
	Local $PPOINT, $ARESULT
	$PPOINT = DllStructGetPtr($TPOINT)
	$ARESULT = DllCall("User32.dll", "int", "ClientToScreen", "hwnd", $HWND, "ptr", $PPOINT)
	If @error Then Return SetError(@error, 0, $TPOINT)
	Return SetError($ARESULT[0] <> 0, 0, $TPOINT)
EndFunc


Func _WINAPI_CLOSEHANDLE($HOBJECT)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "CloseHandle", "int", $HOBJECT)
	_WINAPI_CHECK("_WinAPI_CloseHandle", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_COMMDLGEXTENDEDERROR()
	Local Const $CDERR_DIALOGFAILURE = 65535
	Local Const $CDERR_FINDRESFAILURE = 6
	Local Const $CDERR_INITIALIZATION = 2
	Local Const $CDERR_LOADRESFAILURE = 7
	Local Const $CDERR_LOADSTRFAILURE = 5
	Local Const $CDERR_LOCKRESFAILURE = 8
	Local Const $CDERR_MEMALLOCFAILURE = 9
	Local Const $CDERR_MEMLOCKFAILURE = 10
	Local Const $CDERR_NOHINSTANCE = 4
	Local Const $CDERR_NOHOOK = 11
	Local Const $CDERR_NOTEMPLATE = 3
	Local Const $CDERR_REGISTERMSGFAIL = 12
	Local Const $CDERR_STRUCTSIZE = 1
	Local Const $FNERR_BUFFERTOOSMALL = 12291
	Local Const $FNERR_INVALIDFILENAME = 12290
	Local Const $FNERR_SUBCLASSFAILURE = 12289
	Local $IRESULT = DllCall("comdlg32.dll", "dword", "CommDlgExtendedError")
	If @error Then Return SetError(@error, @extended, "")
	SetError($IRESULT[0])
	Switch @error
		Case $CDERR_DIALOGFAILURE
			Return SetError(@error, 0, "The dialog box could not be created." & @LF & "The common dialog box function's call to the DialogBox function failed." & @LF & "For example, this error occurs if the common dialog box call specifies an invalid window handle.")
		Case $CDERR_FINDRESFAILURE
			Return SetError(@error, 0, "The common dialog box function failed to find a specified resource.")
		Case $CDERR_INITIALIZATION
			Return SetError(@error, 0, "The common dialog box function failed during initialization." & @LF & "This error often occurs when sufficient memory is not available.")
		Case $CDERR_LOADRESFAILURE
			Return SetError(@error, 0, "The common dialog box function failed to load a specified resource.")
		Case $CDERR_LOADSTRFAILURE
			Return SetError(@error, 0, "The common dialog box function failed to load a specified string.")
		Case $CDERR_LOCKRESFAILURE
			Return SetError(@error, 0, "The common dialog box function failed to lock a specified resource.")
		Case $CDERR_MEMALLOCFAILURE
			Return SetError(@error, 0, "The common dialog box function was unable to allocate memory for internal structures.")
		Case $CDERR_MEMLOCKFAILURE
			Return SetError(@error, 0, "The common dialog box function was unable to lock the memory associated with a handle.")
		Case $CDERR_NOHINSTANCE
			Return SetError(@error, 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & "but you failed to provide a corresponding instance handle.")
		Case $CDERR_NOHOOK
			Return SetError(@error, 0, "The ENABLEHOOK flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & "but you failed to provide a pointer to a corresponding hook procedure.")
		Case $CDERR_NOTEMPLATE
			Return SetError(@error, 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & "but you failed to provide a corresponding template.")
		Case $CDERR_REGISTERMSGFAIL
			Return SetError(@error, 0, "The RegisterWindowMessage function returned an error code when it was called by the common dialog box function.")
		Case $CDERR_STRUCTSIZE
			Return SetError(@error, 0, "The lStructSize member of the initialization structure for the corresponding common dialog box is invalid")
		Case $FNERR_BUFFERTOOSMALL
			Return SetError(@error, 0, "The buffer pointed to by the lpstrFile member of the OPENFILENAME structure is too small for the file name specified by the user." & @LF & "The first two bytes of the lpstrFile buffer contain an integer value specifying the size, in TCHARs, required to receive the full name.")
		Case $FNERR_INVALIDFILENAME
			Return SetError(@error, 0, "A file name is invalid.")
		Case $FNERR_SUBCLASSFAILURE
			Return SetError(@error, 0, "An attempt to subclass a list box failed because sufficient memory was not available.")
	EndSwitch
EndFunc


Func _WINAPI_COPYICON($HICON)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "CopyIcon", "hwnd", $HICON)
	_WINAPI_CHECK("_WinAPI_CopyIcon", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEBITMAP($IWIDTH, $IHEIGHT, $IPLANES = 1, $IBITSPERPEL = 1, $PBITS = 0)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "CreateBitmap", "int", $IWIDTH, "int", $IHEIGHT, "int", $IPLANES, "int", $IBITSPERPEL, "ptr", $PBITS)
	_WINAPI_CHECK("_WinAPI_CreateBitmap", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATECOMPATIBLEBITMAP($HDC, $IWIDTH, $IHEIGHT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "CreateCompatibleBitmap", "hwnd", $HDC, "int", $IWIDTH, "int", $IHEIGHT)
	_WINAPI_CHECK("_WinAPI_CreateCompatibleBitmap", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATECOMPATIBLEDC($HDC)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "CreateCompatibleDC", "hwnd", $HDC)
	_WINAPI_CHECK("_WinAPI_CreateCompatibleDC", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEEVENT($PATTRIBUTES = 0, $FMANUALRESET = True, $FINITIALSTATE = True, $SNAME = "")
	Local $ARESULT
	If $SNAME = "" Then $SNAME = 0
	$ARESULT = DllCall("Kernel32.dll", "int", "CreateEvent", "ptr", $PATTRIBUTES, "int", $FMANUALRESET, "int", $FINITIALSTATE, "str", $SNAME)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEFILE($SFILENAME, $ICREATION, $IACCESS = 4, $ISHARE = 0, $IATTRIBUTES = 0, $PSECURITY = 0)
	Local $IDA = 0, $ISM = 0, $ICD = 0, $IFA = 0, $ARESULT
	If BitAND($IACCESS, 1) <> 0 Then $IDA = BitOR($IDA, $__WINAPCONSTANT_GENERIC_EXECUTE)
	If BitAND($IACCESS, 2) <> 0 Then $IDA = BitOR($IDA, $__WINAPCONSTANT_GENERIC_READ)
	If BitAND($IACCESS, 4) <> 0 Then $IDA = BitOR($IDA, $__WINAPCONSTANT_GENERIC_WRITE)
	If BitAND($ISHARE, 1) <> 0 Then $ISM = BitOR($ISM, $__WINAPCONSTANT_FILE_SHARE_DELETE)
	If BitAND($ISHARE, 2) <> 0 Then $ISM = BitOR($ISM, $__WINAPCONSTANT_FILE_SHARE_READ)
	If BitAND($ISHARE, 4) <> 0 Then $ISM = BitOR($ISM, $__WINAPCONSTANT_FILE_SHARE_WRITE)
	Switch $ICREATION
		Case 0
			$ICD = $__WINAPCONSTANT_CREATE_NEW
		Case 1
			$ICD = $__WINAPCONSTANT_CREATE_ALWAYS
		Case 2
			$ICD = $__WINAPCONSTANT_OPEN_EXISTING
		Case 3
			$ICD = $__WINAPCONSTANT_OPEN_ALWAYS
		Case 4
			$ICD = $__WINAPCONSTANT_TRUNCATE_EXISTING
	EndSwitch
	If BitAND($IATTRIBUTES, 1) <> 0 Then $IFA = BitOR($IFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_ARCHIVE)
	If BitAND($IATTRIBUTES, 2) <> 0 Then $IFA = BitOR($IFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_HIDDEN)
	If BitAND($IATTRIBUTES, 4) <> 0 Then $IFA = BitOR($IFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_READONLY)
	If BitAND($IATTRIBUTES, 8) <> 0 Then $IFA = BitOR($IFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_SYSTEM)
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "CreateFile", "str", $SFILENAME, "int", $IDA, "int", $ISM, "ptr", $PSECURITY, "int", $ICD, "int", $IFA, "int", 0)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEFONT($NHEIGHT, $NWIDTH, $NESCAPE = 0, $NORIENTN = 0, $FNWEIGHT = $__WINAPCONSTANT_FW_NORMAL, $BITALIC = False, $BUNDERLINE = False, $BSTRIKEOUT = False, $NCHARSET = $__WINAPCONSTANT_DEFAULT_CHARSET, $NOUTPUTPREC = $__WINAPCONSTANT_OUT_DEFAULT_PRECIS, $NCLIPPREC = $__WINAPCONSTANT_CLIP_DEFAULT_PRECIS, $NQUALITY = $__WINAPCONSTANT_DEFAULT_QUALITY, $NPITCH = 0, $SZFACE = "Arial")
	Local $TBUFFER = DllStructCreate("char FontName[" & StringLen($SZFACE) + 1 & "]")
	Local $PBUFFER = DllStructGetPtr($TBUFFER)
	Local $AFONT
	DllStructSetData($TBUFFER, "FontName", $SZFACE)
	$AFONT = DllCall("gdi32.dll", "hwnd", "CreateFont", "int", $NHEIGHT, "int", $NWIDTH, "int", $NESCAPE, "int", $NORIENTN, "int", $FNWEIGHT, "long", $BITALIC, "long", $BUNDERLINE, "long", $BSTRIKEOUT, "long", $NCHARSET, "long", $NOUTPUTPREC, "long", $NCLIPPREC, "long", $NQUALITY, "long", $NPITCH, "ptr", $PBUFFER)
	If @error Then Return SetError(@error, 0, 0)
	Return $AFONT[0]
EndFunc


Func _WINAPI_CREATEFONTINDIRECT($TLOGFONT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "CreateFontIndirect", "ptr", DllStructGetPtr($TLOGFONT))
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEPROCESS($SAPPNAME, $SCOMMAND, $PSECURITY, $PTHREAD, $FINHERIT, $IFLAGS, $PENVIRON, $SDIR, $PSTARTUPINFO, $PPROCESS)
	Local $PAPPNAME, $TAPPNAME, $PCOMMAND, $TCOMMAND, $PDIR, $TDIR, $ARESULT
	If $SAPPNAME <> "" Then
		$TAPPNAME = DllStructCreate("char Text[" & StringLen($SAPPNAME) + 1 & "]")
		$PAPPNAME = DllStructGetPtr($TAPPNAME)
		DllStructSetData($TAPPNAME, "Text", $SAPPNAME)
	EndIf
	If $SCOMMAND <> "" Then
		$TCOMMAND = DllStructCreate("char Text[" & StringLen($SCOMMAND) + 1 & "]")
		$PCOMMAND = DllStructGetPtr($TCOMMAND)
		DllStructSetData($TCOMMAND, "Text", $SCOMMAND)
	EndIf
	If $SDIR <> "" Then
		$TDIR = DllStructCreate("char Text[" & StringLen($SDIR) + 1 & "]")
		$PDIR = DllStructGetPtr($TDIR)
		DllStructSetData($TDIR, "Text", $SDIR)
	EndIf
	$ARESULT = DllCall("Kernel32.dll", "int", "CreateProcess", "ptr", $PAPPNAME, "ptr", $PCOMMAND, "ptr", $PSECURITY, "ptr", $PTHREAD, "int", $FINHERIT, "int", $IFLAGS, "ptr", $PENVIRON, "ptr", $PDIR, "ptr", $PSTARTUPINFO, "ptr", $PPROCESS)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_CREATESOLIDBITMAP($HWND, $ICOLOR, $IWIDTH, $IHEIGHT)
	Local $II, $ISIZE, $TBITS, $TBMI, $HDC, $HBMP
	$ISIZE = $IWIDTH * $IHEIGHT
	$TBITS = DllStructCreate("int[" & $ISIZE & "]")
	For $II = 1 To $ISIZE
		DllStructSetData($TBITS, 1, $ICOLOR, $II)
	Next
	$TBMI = DllStructCreate($TAGBITMAPINFO)
	DllStructSetData($TBMI, "Size", DllStructGetSize($TBMI) - 4)
	DllStructSetData($TBMI, "Planes", 1)
	DllStructSetData($TBMI, "BitCount", 32)
	DllStructSetData($TBMI, "Width", $IWIDTH)
	DllStructSetData($TBMI, "Height", $IHEIGHT)
	$HDC = _WINAPI_GETDC($HWND)
	$HBMP = _WINAPI_CREATECOMPATIBLEBITMAP($HDC, $IWIDTH, $IHEIGHT)
	_WINAPI_SETDIBITS(0, $HBMP, 0, $IHEIGHT, DllStructGetPtr($TBITS), DllStructGetPtr($TBMI))
	_WINAPI_RELEASEDC($HWND, $HDC)
	Return $HBMP
EndFunc


Func _WINAPI_CREATESOLIDBRUSH($NCOLOR)
	Local $HBRUSH = DllCall("gdi32.dll", "hwnd", "CreateSolidBrush", "int", $NCOLOR)
	If @error Then Return SetError(@error, 0, 0)
	Return $HBRUSH[0]
EndFunc


Func _WINAPI_CREATEWINDOWEX($IEXSTYLE, $SCLASS, $SNAME, $ISTYLE, $IX, $IY, $IWIDTH, $IHEIGHT, $HPARENT, $HMENU = 0, $HINSTANCE = 0, $PPARAM = 0)
	Local $ARESULT
	If $HINSTANCE = 0 Then $HINSTANCE = _WINAPI_GETMODULEHANDLE("")
	$ARESULT = DllCall("User32.dll", "hwnd", "CreateWindowEx", "int", $IEXSTYLE, "str", $SCLASS, "str", $SNAME, "int", $ISTYLE, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT, "hwnd", $HPARENT, "hwnd", $HMENU, "hwnd", $HINSTANCE, "ptr", $PPARAM)
	_WINAPI_CHECK("_WinAPI_CreateWindowEx", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_DEFWINDOWPROC($HWND, $IMSG, $IWPARAM, $ILPARAM)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DefWindowProc", "hwnd", $HWND, "int", $IMSG, "int", $IWPARAM, "int", $ILPARAM)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_DELETEDC($HDC)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "DeleteDC", "hwnd", $HDC)
	_WINAPI_CHECK("_WinAPI_DeleteDC", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DELETEOBJECT($HOBJECT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "DeleteObject", "int", $HOBJECT)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DESTROYICON($HICON)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DestroyIcon", "hwnd", $HICON)
	_WINAPI_CHECK("_WinAPI_DestroyIcon", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DESTROYWINDOW($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DestroyWindow", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWEDGE($HDC, $PTRRECT, $NEDGETYPE, $GRFFLAGS)
	Local $BRESULT = DllCall("user32.dll", "int", "DrawEdge", "hwnd", $HDC, "ptr", $PTRRECT, "int", $NEDGETYPE, "int", $GRFFLAGS)
	If @error Then Return SetError(@error, 0, False)
	Return $BRESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWFRAMECONTROL($HDC, $PTRRECT, $NTYPE, $NSTATE)
	Local $BRESULT = DllCall("user32.dll", "int", "DrawFrameControl", "hwnd", $HDC, "ptr", $PTRRECT, "int", $NTYPE, "int", $NSTATE)
	If @error Then Return SetError(@error, 0, False)
	Return $BRESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWICON($HDC, $IX, $IY, $HICON)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DrawIcon", "hwnd", $HDC, "int", $IX, "int", $IY, "hwnd", $HICON)
	_WINAPI_CHECK("_WinAPI_DrawIcon", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWICONEX($HDC, $IX, $IY, $HICON, $IWIDTH = 0, $IHEIGHT = 0, $ISTEP = 0, $HBRUSH = 0, $IFLAGS = 3)
	Local $IOPTIONS, $ARESULT
	Switch $IFLAGS
		Case 1
			$IOPTIONS = $__WINAPCONSTANT_DI_MASK
		Case 2
			$IOPTIONS = $__WINAPCONSTANT_DI_IMAGE
		Case 3
			$IOPTIONS = $__WINAPCONSTANT_DI_NORMAL
		Case 4
			$IOPTIONS = $__WINAPCONSTANT_DI_COMPAT
		Case 5
			$IOPTIONS = $__WINAPCONSTANT_DI_DEFAULTSIZE
		Case Else
			$IOPTIONS = $__WINAPCONSTANT_DI_NOMIRROR
	EndSwitch
	$ARESULT = DllCall("User32.dll", "int", "DrawIconEx", "hwnd", $HDC, "int", $IX, "int", $IY, "hwnd", $HICON, "int", $IWIDTH, "int", $IHEIGHT, "uint", $ISTEP, "hwnd", $HBRUSH, "uint", $IOPTIONS)
	_WINAPI_CHECK("_WinAPI_DrawIconEx", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWTEXT($HDC, $STEXT, ByRef $TRECT, $IFLAGS)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DrawText", "hwnd", $HDC, "str", $STEXT, "int", -1, "ptr", DllStructGetPtr($TRECT), "int", $IFLAGS)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_ENABLEWINDOW($HWND, $FENABLE = True)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "EnableWindow", "hwnd", $HWND, "int", $FENABLE)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_ENUMDISPLAYDEVICES($SDEVICE, $IDEVNUM)
	Local $PNAME, $TNAME, $IDEVICE, $PDEVICE, $TDEVICE, $IN, $IFLAGS, $ARESULT, $ADEVICE[5]
	If $SDEVICE <> "" Then
		$TNAME = DllStructCreate("char Text[128]")
		$PNAME = DllStructGetPtr($TNAME)
		DllStructSetData($TNAME, "Text", $SDEVICE)
	EndIf
	$TDEVICE = DllStructCreate($TAGDISPLAY_DEVICE)
	$PDEVICE = DllStructGetPtr($TDEVICE)
	$IDEVICE = DllStructGetSize($TDEVICE)
	DllStructSetData($TDEVICE, "Size", $IDEVICE)
	$ARESULT = DllCall("User32.dll", "int", "EnumDisplayDevices", "ptr", $PNAME, "int", $IDEVNUM, "ptr", $PDEVICE, "int", 1)
	If @error Then Return SetError(@error, 0, $ADEVICE)
	$IN = DllStructGetData($TDEVICE, "Flags")
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_ATTACHED_TO_DESKTOP) <> 0 Then $IFLAGS = BitOR($IFLAGS, 1)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_PRIMARY_DEVICE) <> 0 Then $IFLAGS = BitOR($IFLAGS, 2)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_MIRRORING_DRIVER) <> 0 Then $IFLAGS = BitOR($IFLAGS, 4)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_VGA_COMPATIBLE) <> 0 Then $IFLAGS = BitOR($IFLAGS, 8)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_REMOVABLE) <> 0 Then $IFLAGS = BitOR($IFLAGS, 16)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_MODESPRUNED) <> 0 Then $IFLAGS = BitOR($IFLAGS, 32)
	$ADEVICE[0] = $ARESULT[0] <> 0
	$ADEVICE[1] = DllStructGetData($TDEVICE, "Name")
	$ADEVICE[2] = DllStructGetData($TDEVICE, "String")
	$ADEVICE[3] = $IFLAGS
	$ADEVICE[4] = DllStructGetData($TDEVICE, "ID")
	Return $ADEVICE
EndFunc


Func _WINAPI_ENUMWINDOWS($FVISIBLE = True)
	_WINAPI_ENUMWINDOWSINIT()
	_WINAPI_ENUMWINDOWSCHILD(_WINAPI_GETDESKTOPWINDOW(), $FVISIBLE)
	Return $WINAPI_GAWINLIST
EndFunc


Func _WINAPI_ENUMWINDOWSADD($HWND, $SCLASS = "")
	Local $ICOUNT
	If $SCLASS = "" Then $SCLASS = _WINAPI_GETCLASSNAME($HWND)
	$WINAPI_GAWINLIST[0][0] += 1
	$ICOUNT = $WINAPI_GAWINLIST[0][0]
	If $ICOUNT >= $WINAPI_GAWINLIST[0][1] Then
		ReDim $WINAPI_GAWINLIST[$ICOUNT + 64][2]
		$WINAPI_GAWINLIST[0][1] += 64
	EndIf
	$WINAPI_GAWINLIST[$ICOUNT][0] = $HWND
	$WINAPI_GAWINLIST[$ICOUNT][1] = $SCLASS
EndFunc


Func _WINAPI_ENUMWINDOWSCHILD($HWND, $FVISIBLE = True)
	$HWND = _WINAPI_GETWINDOW($HWND, $__WINAPCONSTANT_GW_CHILD)
	While $HWND <> 0
		If (Not $FVISIBLE) Or _WINAPI_ISWINDOWVISIBLE($HWND) Then
			_WINAPI_ENUMWINDOWSCHILD($HWND, $FVISIBLE)
			_WINAPI_ENUMWINDOWSADD($HWND)
		EndIf
		$HWND = _WINAPI_GETWINDOW($HWND, $__WINAPCONSTANT_GW_HWNDNEXT)
	WEnd
EndFunc


Func _WINAPI_ENUMWINDOWSINIT()
	ReDim $WINAPI_GAWINLIST[64][2]
	$WINAPI_GAWINLIST[0][0] = 0
	$WINAPI_GAWINLIST[0][1] = 64
EndFunc


Func _WINAPI_ENUMWINDOWSPOPUP()
	Local $HWND, $SCLASS
	_WINAPI_ENUMWINDOWSINIT()
	$HWND = _WINAPI_GETWINDOW(_WINAPI_GETDESKTOPWINDOW(), $__WINAPCONSTANT_GW_CHILD)
	While $HWND <> 0
		If _WINAPI_ISWINDOWVISIBLE($HWND) Then
			$SCLASS = _WINAPI_GETCLASSNAME($HWND)
			If $SCLASS = "#32768" Then
				_WINAPI_ENUMWINDOWSADD($HWND)
			ElseIf $SCLASS = "ToolbarWindow32" Then
				_WINAPI_ENUMWINDOWSADD($HWND)
			ElseIf $SCLASS = "ToolTips_Class32" Then
				_WINAPI_ENUMWINDOWSADD($HWND)
			ElseIf $SCLASS = "BaseBar" Then
				_WINAPI_ENUMWINDOWSCHILD($HWND)
			EndIf
		EndIf
		$HWND = _WINAPI_GETWINDOW($HWND, $__WINAPCONSTANT_GW_HWNDNEXT)
	WEnd
	Return $WINAPI_GAWINLIST
EndFunc


Func _WINAPI_ENUMWINDOWSTOP()
	Local $HWND
	_WINAPI_ENUMWINDOWSINIT()
	$HWND = _WINAPI_GETWINDOW(_WINAPI_GETDESKTOPWINDOW(), $__WINAPCONSTANT_GW_CHILD)
	While $HWND <> 0
		If _WINAPI_ISWINDOWVISIBLE($HWND) Then _WINAPI_ENUMWINDOWSADD($HWND)
		$HWND = _WINAPI_GETWINDOW($HWND, $__WINAPCONSTANT_GW_HWNDNEXT)
	WEnd
	Return $WINAPI_GAWINLIST
EndFunc


Func _WINAPI_EXPANDENVIRONMENTSTRINGS($SSTRING)
	Local $TTEXT, $ARESULT
	$TTEXT = DllStructCreate("char Text[4096]")
	$ARESULT = DllCall("Kernel32.dll", "int", "ExpandEnvironmentStringsA", "str", $SSTRING, "ptr", DllStructGetPtr($TTEXT), "int", 4096)
	_WINAPI_CHECK("_WinAPI_ExpandEnvironmentStrings", ($ARESULT[0] = 0), 0, True)
	Return DllStructGetData($TTEXT, "Text")
EndFunc


Func _WINAPI_EXTRACTICONEX($SFILE, $IINDEX, $PLARGE, $PSMALL, $IICONS)
	Local $ARESULT
	$ARESULT = DllCall("Shell32.dll", "int", "ExtractIconEx", "str", $SFILE, "int", $IINDEX, "ptr", $PLARGE, "ptr", $PSMALL, "int", $IICONS)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_FATALAPPEXIT($SMESSAGE)
	DllCall("Kernel32.dll", "none", "FatalAppExit", "uint", 0, "str", $SMESSAGE)
EndFunc


Func _WINAPI_FILLRECT($HDC, $PTRRECT, $HBRUSH)
	Local $BRESULT
	If IsHWnd($HBRUSH) Then
		$BRESULT = DllCall("user32.dll", "int", "FillRect", "hwnd", $HDC, "ptr", $PTRRECT, "hwnd", $HBRUSH)
	Else
		$BRESULT = DllCall("user32.dll", "int", "FillRect", "hwnd", $HDC, "ptr", $PTRRECT, "int", $HBRUSH)
	EndIf
	If @error Then Return SetError(@error, 0, False)
	Return $BRESULT[0] <> 0
EndFunc


Func _WINAPI_FINDEXECUTABLE($SFILENAME, $SDIRECTORY = "")
	Local $TTEXT
	$TTEXT = DllStructCreate("char Text[4096]")
	DllCall("Shell32.dll", "hwnd", "FindExecutable", "str", $SFILENAME, "str", $SDIRECTORY, "ptr", DllStructGetPtr($TTEXT))
	Return DllStructGetData($TTEXT, "Text")
EndFunc


Func _WINAPI_FINDWINDOW($SCLASSNAME, $SWINDOWNAME)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "FindWindow", "str", $SCLASSNAME, "str", $SWINDOWNAME)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_FLASHWINDOW($HWND, $FINVERT = True)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "FlashWindow", "hwnd", $HWND, "int", $FINVERT)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_FLASHWINDOWEX($HWND, $IFLAGS = 3, $ICOUNT = 3, $ITIMEOUT = 0)
	Local $IMODE = 0, $IFLASH, $PFLASH, $TFLASH, $ARESULT
	$TFLASH = DllStructCreate($TAGFLASHWINDOW)
	$PFLASH = DllStructGetPtr($TFLASH)
	$IFLASH = DllStructGetSize($TFLASH)
	If BitAND($IFLAGS, 1) <> 0 Then $IMODE = BitOR($IMODE, $__WINAPCONSTANT_FLASHW_CAPTION)
	If BitAND($IFLAGS, 2) <> 0 Then $IMODE = BitOR($IMODE, $__WINAPCONSTANT_FLASHW_TRAY)
	If BitAND($IFLAGS, 4) <> 0 Then $IMODE = BitOR($IMODE, $__WINAPCONSTANT_FLASHW_TIMER)
	If BitAND($IFLAGS, 8) <> 0 Then $IMODE = BitOR($IMODE, $__WINAPCONSTANT_FLASHW_TIMERNOFG)
	DllStructSetData($TFLASH, "Size", $IFLASH)
	DllStructSetData($TFLASH, "hWnd", $HWND)
	DllStructSetData($TFLASH, "Flags", $IMODE)
	DllStructSetData($TFLASH, "Count", $ICOUNT)
	DllStructSetData($TFLASH, "Timeout", $ITIMEOUT)
	$ARESULT = DllCall("User32.dll", "int", "FlashWindowEx", "ptr", $PFLASH)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_FLOATTOINT($NFLOAT)
	Local $TFLOAT, $TINT
	$TFLOAT = DllStructCreate("float")
	$TINT = DllStructCreate("int", DllStructGetPtr($TFLOAT))
	DllStructSetData($TFLOAT, 1, $NFLOAT)
	Return DllStructGetData($TINT, 1)
EndFunc


Func _WINAPI_FLUSHFILEBUFFERS($HFILE)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "FlushFileBuffers", "hwnd", $HFILE)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_FORMATMESSAGE($IFLAGS, $PSOURCE, $IMESSAGEID, $ILANGUAGEID, $PBUFFER, $ISIZE, $VARGUMENTS)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "FormatMessageA", "int", $IFLAGS, "hwnd", $PSOURCE, "int", $IMESSAGEID, "int", $ILANGUAGEID, "ptr", $PBUFFER, "int", $ISIZE, "ptr", $VARGUMENTS)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_FRAMERECT($HDC, $PTRRECT, $HBRUSH)
	Local $BRESULT = DllCall("user32.dll", "int", "FrameRect", "hwnd", $HDC, "ptr", $PTRRECT, "hwnd", $HBRUSH)
	If @error Then Return SetError(@error, 0, False)
	Return $BRESULT[0] <> 0
EndFunc


Func _WINAPI_FREELIBRARY($HMODULE)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "FreeLibrary", "hwnd", $HMODULE)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_GETANCESTOR($HWND, $IFLAGS = 1)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetAncestor", "hwnd", $HWND, "uint", $IFLAGS)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETASYNCKEYSTATE($IKEY)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetAsyncKeyState", "int", $IKEY)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCLASSNAME($HWND)
	Local $ARESULT
	If Not IsHWnd($HWND) Then $HWND = GUICtrlGetHandle($HWND)
	$ARESULT = DllCall("User32.dll", "int", "GetClassName", "hwnd", $HWND, "str", "", "int", 4096)
	Return $ARESULT[2]
EndFunc


Func _WINAPI_GETCLIENTHEIGHT($HWND)
	Local $TRECT
	$TRECT = _WINAPI_GETCLIENTRECT($HWND)
	Return DllStructGetData($TRECT, "Bottom") - DllStructGetData($TRECT, "Top")
EndFunc


Func _WINAPI_GETCLIENTWIDTH($HWND)
	Local $TRECT
	$TRECT = _WINAPI_GETCLIENTRECT($HWND)
	Return DllStructGetData($TRECT, "Right") - DllStructGetData($TRECT, "Left")
EndFunc


Func _WINAPI_GETCLIENTRECT($HWND)
	Local $TRECT, $ARESULT
	$TRECT = DllStructCreate($TAGRECT)
	$ARESULT = DllCall("User32.dll", "int", "GetClientRect", "hwnd", $HWND, "ptr", DllStructGetPtr($TRECT))
	_WINAPI_CHECK("_WinAPI_GetClientRect", ($ARESULT[0] = 0), 0, True)
	Return $TRECT
EndFunc


Func _WINAPI_GETCURRENTPROCESS()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "GetCurrentProcess")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCURRENTPROCESSID()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetCurrentProcessId")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCURRENTTHREAD()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetCurrentThread")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCURRENTTHREADID()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetCurrentThreadId")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCURSORINFO()
	Local $ICURSOR, $TCURSOR, $ARESULT, $ACURSOR[5]
	$TCURSOR = DllStructCreate($TAGCURSORINFO)
	$ICURSOR = DllStructGetSize($TCURSOR)
	DllStructSetData($TCURSOR, "Size", $ICURSOR)
	$ARESULT = DllCall("User32.dll", "int", "GetCursorInfo", "ptr", DllStructGetPtr($TCURSOR))
	_WINAPI_CHECK("_WinAPI_GetCursorInfo", ($ARESULT[0] = 0), 0, True)
	$ACURSOR[0] = $ARESULT[0] <> 0
	$ACURSOR[1] = DllStructGetData($TCURSOR, "Flags") <> 0
	$ACURSOR[2] = DllStructGetData($TCURSOR, "hCursor")
	$ACURSOR[3] = DllStructGetData($TCURSOR, "X")
	$ACURSOR[4] = DllStructGetData($TCURSOR, "Y")
	Return $ACURSOR
EndFunc


Func _WINAPI_GETDC($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetDC", "hwnd", $HWND)
	_WINAPI_CHECK("_WinAPI_GetDC", ($ARESULT[0] = 0), -1)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETDESKTOPWINDOW()
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetDesktopWindow")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETDEVICECAPS($HDC, $IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "GetDeviceCaps", "hwnd", $HDC, "int", $IINDEX)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETDIBITS($HDC, $HBMP, $ISTARTSCAN, $ISCANLINES, $PBITS, $PBI, $IUSAGE)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "GetDIBits", "hwnd", $HDC, "hwnd", $HBMP, "int", $ISTARTSCAN, "int", $ISCANLINES, "ptr", $PBITS, "ptr", $PBI, "int", $IUSAGE)
	_WINAPI_CHECK("_WinAPI_GetDIBits", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_GETDLGCTRLID($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetDlgCtrlID", "hwnd", $HWND)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETDLGITEM($HWND, $IITEMID)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetDlgItem", "hwnd", $HWND, "int", $IITEMID)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETFOCUS()
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetFocus")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETFOREGROUNDWINDOW()
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetForegroundWindow")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETICONINFO($HICON)
	Local $TINFO, $ARESULT, $AICON[6]
	$TINFO = DllStructCreate($TAGICONINFO)
	$ARESULT = DllCall("User32.dll", "int", "GetIconInfo", "hwnd", $HICON, "ptr", DllStructGetPtr($TINFO))
	_WINAPI_CHECK("_WinAPI_GetIconInfo", ($ARESULT[0] = 0), 0, True)
	$AICON[0] = $ARESULT[0] <> 0
	$AICON[1] = DllStructGetData($TINFO, "Icon") <> 0
	$AICON[2] = DllStructGetData($TINFO, "XHotSpot")
	$AICON[3] = DllStructGetData($TINFO, "YHotSpot")
	$AICON[4] = DllStructGetData($TINFO, "hMask")
	$AICON[5] = DllStructGetData($TINFO, "hColor")
	Return $AICON
EndFunc


Func _WINAPI_GETFILESIZEEX($HFILE)
	Local $TSIZE
	$TSIZE = DllStructCreate("int64 Size")
	DllCall("Kernel32.dll", "int", "GetFileSizeEx", "hwnd", $HFILE, "ptr", DllStructGetPtr($TSIZE))
	Return SetError(_WINAPI_GETLASTERROR(), 0, DllStructGetData($TSIZE, "Size"))
EndFunc


Func _WINAPI_GETLASTERROR()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetLastError")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETLASTERRORMESSAGE()
	Local $TTEXT
	$TTEXT = DllStructCreate("char Text[4096]")
	_WINAPI_FORMATMESSAGE($__WINAPCONSTANT_FORMAT_MESSAGE_FROM_SYSTEM, 0, _WINAPI_GETLASTERROR(), 0, DllStructGetPtr($TTEXT), 4096, 0)
	Return DllStructGetData($TTEXT, "Text")
EndFunc


Func _WINAPI_GETMODULEHANDLE($SMODULENAME)
	Local $TTEXT, $ARESULT
	If $SMODULENAME <> "" Then
		$TTEXT = DllStructCreate("char Text[4096]")
		DllStructSetData($TTEXT, "Text", $SMODULENAME)
		$ARESULT = DllCall("Kernel32.dll", "hwnd", "GetModuleHandle", "ptr", DllStructGetPtr($TTEXT))
	Else
		$ARESULT = DllCall("Kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
	EndIf
	_WINAPI_CHECK("_WinAPI_GetModuleHandle", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETMOUSEPOS($FTOCLIENT = False, $HWND = 0)
	Local $IMODE, $APOS, $TPOINT
	$IMODE = Opt("MouseCoordMode", 1)
	$APOS = MouseGetPos()
	Opt("MouseCoordMode", $IMODE)
	$TPOINT = DllStructCreate($TAGPOINT)
	DllStructSetData($TPOINT, "X", $APOS[0])
	DllStructSetData($TPOINT, "Y", $APOS[1])
	If $FTOCLIENT Then _WINAPI_SCREENTOCLIENT($HWND, $TPOINT)
	Return $TPOINT
EndFunc


Func _WINAPI_GETMOUSEPOSX($FTOCLIENT = False, $HWND = 0)
	Local $TPOINT
	$TPOINT = _WINAPI_GETMOUSEPOS($FTOCLIENT, $HWND)
	Return DllStructGetData($TPOINT, "X")
EndFunc


Func _WINAPI_GETMOUSEPOSY($FTOCLIENT = False, $HWND = 0)
	Local $TPOINT
	$TPOINT = _WINAPI_GETMOUSEPOS($FTOCLIENT, $HWND)
	Return DllStructGetData($TPOINT, "Y")
EndFunc


Func _WINAPI_GETOBJECT($HOBJECT, $ISIZE, $POBJECT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "GetObject", "int", $HOBJECT, "int", $ISIZE, "ptr", $POBJECT)
	_WINAPI_CHECK("_WinAPI_GetObject", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETOPENFILENAME($STITLE = "", $SFILTER = "All files (*.*)", $SINITALDIR = ".", $SDEFAULTFILE = "", $SDEFAULTEXT = "", $IFILTERINDEX = 1, $IFLAGS = 0, $IFLAGSEX = 0, $HWNDOWNER = 0)
	Local $IPATHLEN = 4096
	Local $INULLS = 0
	Local $TOFN = DllStructCreate($TAGOPENFILENAME)
	Local $AFILES[1]
	Local $IFLAG = $IFLAGS
	Local $ASFLINES = StringSplit($SFILTER, "|")
	Local $ASFILTER[$ASFLINES[0] * 2 + 1]
	Local $I, $ISTART, $IFINAL, $STFILTER
	$ASFILTER[0] = $ASFLINES[0] * 2
	For $I = 1 To $ASFLINES[0]
		$ISTART = StringInStr($ASFLINES[$I], "(", 0, 1)
		$IFINAL = StringInStr($ASFLINES[$I], ")", 0, -1)
		$ASFILTER[$I * 2 - 1] = StringStripWS(StringLeft($ASFLINES[$I], $ISTART - 1), 3)
		$ASFILTER[$I * 2] = StringStripWS(StringTrimRight(StringTrimLeft($ASFLINES[$I], $ISTART), StringLen($ASFLINES[$I]) - $IFINAL + 1), 3)
		$STFILTER &= "char[" & StringLen($ASFILTER[$I * 2 - 1]) + 1 & "];char[" & StringLen($ASFILTER[$I * 2]) + 1 & "];"
	Next
	Local $TTITLE = DllStructCreate("char Title[" & StringLen($STITLE) + 1 & "]")
	Local $TINITIALDIR = DllStructCreate("char InitDir[" & StringLen($SINITALDIR) + 1 & "]")
	Local $TFILTER = DllStructCreate($STFILTER & "char")
	Local $TPATH = DllStructCreate("char Path[" & $IPATHLEN & "]")
	Local $TEXTN = DllStructCreate("char Extension[" & StringLen($SDEFAULTEXT) + 1 & "]")
	For $I = 1 To $ASFILTER[0]
		DllStructSetData($TFILTER, $I, $ASFILTER[$I])
	Next
	Local $IRESULT
	DllStructSetData($TTITLE, "Title", $STITLE)
	DllStructSetData($TINITIALDIR, "InitDir", $SINITALDIR)
	DllStructSetData($TPATH, "Path", $SDEFAULTFILE)
	DllStructSetData($TEXTN, "Extension", $SDEFAULTEXT)
	DllStructSetData($TOFN, "StructSize", DllStructGetSize($TOFN))
	DllStructSetData($TOFN, "hwndOwner", $HWNDOWNER)
	DllStructSetData($TOFN, "lpstrFilter", DllStructGetPtr($TFILTER))
	DllStructSetData($TOFN, "nFilterIndex", $IFILTERINDEX)
	DllStructSetData($TOFN, "lpstrFile", DllStructGetPtr($TPATH))
	DllStructSetData($TOFN, "nMaxFile", $IPATHLEN)
	DllStructSetData($TOFN, "lpstrInitialDir", DllStructGetPtr($TINITIALDIR))
	DllStructSetData($TOFN, "lpstrTitle", DllStructGetPtr($TTITLE))
	DllStructSetData($TOFN, "Flags", $IFLAG)
	DllStructSetData($TOFN, "lpstrDefExt", DllStructGetPtr($TEXTN))
	DllStructSetData($TOFN, "FlagsEx", $IFLAGSEX)
	$IRESULT = DllCall("comdlg32.dll", "int", "GetOpenFileName", "ptr", DllStructGetPtr($TOFN))
	If @error Or $IRESULT[0] = 0 Then Return SetError(@error, @extended, $AFILES)
	If BitAND($IFLAGS, $OFN_ALLOWMULTISELECT) = $OFN_ALLOWMULTISELECT And BitAND($IFLAGS, $OFN_EXPLORER) = $OFN_EXPLORER Then
		For $X = 1 To $IPATHLEN
			If DllStructGetData($TPATH, "Path", $X) = Chr(0) Then
				DllStructSetData($TPATH, "Path", "|", $X)
				$INULLS += 1
			Else
				$INULLS = 0
			EndIf
			If $INULLS = 2 Then ExitLoop
		Next
		DllStructSetData($TPATH, "Path", Chr(0), $X - 1)
		$AFILES = StringSplit(DllStructGetData($TPATH, "Path"), "|")
		If $AFILES[0] = 1 Then Return _WINAPI_PARSEFILEDIALOGPATH(DllStructGetData($TPATH, "Path"))
		Return StringSplit(DllStructGetData($TPATH, "Path"), "|")
	ElseIf BitAND($IFLAGS, $OFN_ALLOWMULTISELECT) = $OFN_ALLOWMULTISELECT Then
		$AFILES = StringSplit(DllStructGetData($TPATH, "Path"), " ")
		If $AFILES[0] = 1 Then Return _WINAPI_PARSEFILEDIALOGPATH(DllStructGetData($TPATH, "Path"))
		Return StringSplit(StringReplace(DllStructGetData($TPATH, "Path"), " ", "|"), "|")
	Else
		Return _WINAPI_PARSEFILEDIALOGPATH(DllStructGetData($TPATH, "Path"))
	EndIf
EndFunc


Func _WINAPI_GETOVERLAPPEDRESULT($HFILE, $POVERLAPPED, ByRef $IBYTES, $FWAIT = False)
	Local $PREAD, $TREAD, $ARESULT
	$TREAD = DllStructCreate("int Read")
	$PREAD = DllStructGetPtr($TREAD)
	$ARESULT = DllCall("Kernel32.dll", "int", "GetOverlappedResult", "int", $HFILE, "ptr", $POVERLAPPED, "ptr", $PREAD, "int", $FWAIT)
	$IBYTES = DllStructGetData($TREAD, "Read")
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_GETPARENT($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetParent", "hwnd", $HWND)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETPROCESSAFFINITYMASK($HPROCESS)
	Local $PPROCESS, $TPROCESS, $PSYSTEM, $TSYSTEM, $ARESULT, $AMASK[3]
	$TPROCESS = DllStructCreate("int Data")
	$PPROCESS = DllStructGetPtr($TPROCESS)
	$TSYSTEM = DllStructCreate("int Data")
	$PSYSTEM = DllStructGetPtr($TSYSTEM)
	$ARESULT = DllCall("Kernel32.dll", "int", "GetProcessAffinityMask", "hwnd", $HPROCESS, "ptr", $PPROCESS, "ptr", $PSYSTEM)
	$AMASK[0] = $ARESULT[0] <> 0
	$AMASK[1] = DllStructGetData($TPROCESS, "Data")
	$AMASK[2] = DllStructGetData($TSYSTEM, "Data")
	Return $AMASK
EndFunc


Func _WINAPI_GETSAVEFILENAME($STITLE = "", $SFILTER = "All files (*.*)", $SINITALDIR = ".", $SDEFAULTFILE = "", $SDEFAULTEXT = "", $IFILTERINDEX = 1, $IFLAGS = 0, $IFLAGSEX = 0, $HWNDOWNER = 0)
	Local $IPATHLEN = 4096
	Local $TOFN = DllStructCreate($TAGOPENFILENAME)
	Local $AFILES[1]
	Local $IFLAG = $IFLAGS
	Local $ASFLINES = StringSplit($SFILTER, "|")
	Local $ASFILTER[$ASFLINES[0] * 2 + 1]
	Local $I, $ISTART, $IFINAL, $STFILTER
	$ASFILTER[0] = $ASFLINES[0] * 2
	For $I = 1 To $ASFLINES[0]
		$ISTART = StringInStr($ASFLINES[$I], "(", 0, 1)
		$IFINAL = StringInStr($ASFLINES[$I], ")", 0, -1)
		$ASFILTER[$I * 2 - 1] = StringStripWS(StringLeft($ASFLINES[$I], $ISTART - 1), 3)
		$ASFILTER[$I * 2] = StringStripWS(StringTrimRight(StringTrimLeft($ASFLINES[$I], $ISTART), StringLen($ASFLINES[$I]) - $IFINAL + 1), 3)
		$STFILTER &= "char[" & StringLen($ASFILTER[$I * 2 - 1]) + 1 & "];char[" & StringLen($ASFILTER[$I * 2]) + 1 & "];"
	Next
	Local $TTITLE = DllStructCreate("char Title[" & StringLen($STITLE) + 1 & "]")
	Local $TINITIALDIR = DllStructCreate("char InitDir[" & StringLen($SINITALDIR) + 1 & "]")
	Local $TFILTER = DllStructCreate($STFILTER & "char")
	Local $TPATH = DllStructCreate("char Path[" & $IPATHLEN & "]")
	Local $TEXTN = DllStructCreate("char Extension[" & StringLen($SDEFAULTEXT) + 1 & "]")
	For $I = 1 To $ASFILTER[0]
		DllStructSetData($TFILTER, $I, $ASFILTER[$I])
	Next
	Local $IRESULT
	DllStructSetData($TTITLE, "Title", $STITLE)
	DllStructSetData($TINITIALDIR, "InitDir", $SINITALDIR)
	DllStructSetData($TPATH, "Path", $SDEFAULTFILE)
	DllStructSetData($TEXTN, "Extension", $SDEFAULTEXT)
	DllStructSetData($TOFN, "StructSize", DllStructGetSize($TOFN))
	DllStructSetData($TOFN, "hwndOwner", $HWNDOWNER)
	DllStructSetData($TOFN, "lpstrFilter", DllStructGetPtr($TFILTER))
	DllStructSetData($TOFN, "nFilterIndex", $IFILTERINDEX)
	DllStructSetData($TOFN, "lpstrFile", DllStructGetPtr($TPATH))
	DllStructSetData($TOFN, "nMaxFile", $IPATHLEN)
	DllStructSetData($TOFN, "lpstrInitialDir", DllStructGetPtr($TINITIALDIR))
	DllStructSetData($TOFN, "lpstrTitle", DllStructGetPtr($TTITLE))
	DllStructSetData($TOFN, "Flags", $IFLAG)
	DllStructSetData($TOFN, "lpstrDefExt", DllStructGetPtr($TEXTN))
	DllStructSetData($TOFN, "FlagsEx", $IFLAGSEX)
	$IRESULT = DllCall("comdlg32.dll", "int", "GetSaveFileName", "ptr", DllStructGetPtr($TOFN))
	If @error Or $IRESULT[0] = 0 Then Return SetError(@error, @extended, $AFILES)
	Return _WINAPI_PARSEFILEDIALOGPATH(DllStructGetData($TPATH, "Path"))
EndFunc


Func _WINAPI_GETSTOCKOBJECT($IOBJECT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "GetStockObject", "int", $IOBJECT)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETSTDHANDLE($ISTDHANDLE)
	Local $AHANDLE[3] = [-10, -11, -12], $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetStdHandle", "int", $AHANDLE[$ISTDHANDLE])
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0])
EndFunc


Func _WINAPI_GETSYSCOLOR($IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetSysColor", "int", $IINDEX)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETSYSCOLORBRUSH($IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetSysColorBrush", "int", $IINDEX)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETSYSTEMMETRICS($IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetSystemMetrics", "int", $IINDEX)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETTEXTEXTENTPOINT32($HDC, $STEXT)
	Local $TSIZE, $ISIZE, $ARESULT
	$TSIZE = DllStructCreate($TAGSIZE)
	$ISIZE = StringLen($STEXT)
	$ARESULT = DllCall("GDI32.dll", "int", "GetTextExtentPoint32", "hwnd", $HDC, "str", $STEXT, "int", $ISIZE, "ptr", DllStructGetPtr($TSIZE))
	_WINAPI_CHECK("_WinAPI_GetTextExtentPoint32", ($ARESULT[0] = 0), 0, True)
	Return $TSIZE
EndFunc


Func _WINAPI_GETWINDOW($HWND, $ICMD)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetWindow", "hwnd", $HWND, "int", $ICMD)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETWINDOWDC($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetWindowDC", "hwnd", $HWND)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETWINDOWHEIGHT($HWND)
	Local $TRECT
	$TRECT = _WINAPI_GETWINDOWRECT($HWND)
	Return DllStructGetData($TRECT, "Bottom") - DllStructGetData($TRECT, "Top")
EndFunc


Func _WINAPI_GETWINDOWLONG($HWND, $IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetWindowLong", "hwnd", $HWND, "int", $IINDEX)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETWINDOWRECT($HWND)
	Local $TRECT
	$TRECT = DllStructCreate($TAGRECT)
	DllCall("User32.dll", "int", "GetWindowRect", "hwnd", $HWND, "ptr", DllStructGetPtr($TRECT))
	Return $TRECT
EndFunc


Func _WINAPI_GETWINDOWTEXT($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetWindowText", "hwnd", $HWND, "str", "", "int", 4096)
	Return $ARESULT[2]
EndFunc


Func _WINAPI_GETWINDOWTHREADPROCESSID($HWND, ByRef $IPID)
	Local $PPID, $TPID, $ARESULT
	$TPID = DllStructCreate("int ID")
	$PPID = DllStructGetPtr($TPID)
	$ARESULT = DllCall("User32.dll", "int", "GetWindowThreadProcessId", "hwnd", $HWND, "ptr", $PPID)
	$IPID = DllStructGetData($TPID, "ID")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETWINDOWWIDTH($HWND)
	Local $TRECT
	$TRECT = _WINAPI_GETWINDOWRECT($HWND)
	Return DllStructGetData($TRECT, "Right") - DllStructGetData($TRECT, "Left")
EndFunc


Func _WINAPI_GETXYFROMPOINT(ByRef $TPOINT, ByRef $IX, ByRef $IY)
	$IX = DllStructGetData($TPOINT, "X")
	$IY = DllStructGetData($TPOINT, "Y")
EndFunc


Func _WINAPI_GLOBALMEMSTATUS()
	Local $IMEM, $PMEM, $TMEM, $AMEM[7]
	$TMEM = DllStructCreate("int;int;int;int;int;int;int;int;int")
	$PMEM = DllStructGetPtr($TMEM)
	$IMEM = DllStructGetSize($TMEM)
	DllStructSetData($TMEM, 1, $IMEM)
	DllCall("Kernel32.dll", "none", "GlobalMemStatus", "ptr", $PMEM)
	$AMEM[0] = DllStructGetData($TMEM, 2)
	$AMEM[1] = DllStructGetData($TMEM, 3)
	$AMEM[2] = DllStructGetData($TMEM, 4)
	$AMEM[3] = DllStructGetData($TMEM, 5)
	$AMEM[4] = DllStructGetData($TMEM, 6)
	$AMEM[5] = DllStructGetData($TMEM, 7)
	$AMEM[6] = DllStructGetData($TMEM, 8)
	Return $AMEM
EndFunc


Func _WINAPI_GUIDFROMSTRING($SGUID)
	Local $TGUID
	$TGUID = DllStructCreate($TAGGUID)
	_WINAPI_GUIDFROMSTRINGEX($SGUID, DllStructGetPtr($TGUID))
	Return SetError(@error, 0, $TGUID)
EndFunc


Func _WINAPI_GUIDFROMSTRINGEX($SGUID, $PGUID)
	Local $TDATA, $ARESULT
	$TDATA = _WINAPI_MULTIBYTETOWIDECHAR($SGUID)
	$ARESULT = DllCall("Ole32.dll", "int", "CLSIDFromString", "ptr", DllStructGetPtr($TDATA), "ptr", $PGUID)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_HIWORD($ILONG)
	Return BitShift($ILONG, 16)
EndFunc


Func _WINAPI_INPROCESS($HWND, ByRef $HLASTWND)
	Local $II, $ICOUNT, $IPROCESSID
	If $HWND = $HLASTWND Then Return True
	For $II = $WINAPI_GAINPROCESS[0][0] To 1 Step -1
		If $HWND = $WINAPI_GAINPROCESS[$II][0] Then
			If $WINAPI_GAINPROCESS[$II][1] Then
				$HLASTWND = $HWND
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
	_WINAPI_GETWINDOWTHREADPROCESSID($HWND, $IPROCESSID)
	$ICOUNT = $WINAPI_GAINPROCESS[0][0] + 1
	If $ICOUNT >= 64 Then $ICOUNT = 1
	$WINAPI_GAINPROCESS[0][0] = $ICOUNT
	$WINAPI_GAINPROCESS[$ICOUNT][0] = $HWND
	$WINAPI_GAINPROCESS[$ICOUNT][1] = ($IPROCESSID = @AutoItPID)
	Return $WINAPI_GAINPROCESS[$ICOUNT][1]
EndFunc


Func _WINAPI_INTTOFLOAT($IINT)
	Local $TFLOAT, $TINT
	$TINT = DllStructCreate("int")
	$TFLOAT = DllStructCreate("float", DllStructGetPtr($TINT))
	DllStructSetData($TINT, 1, $IINT)
	Return DllStructGetData($TFLOAT, 1)
EndFunc


Func _WINAPI_ISCLASSNAME($HWND, $SCLASSNAME)
	Local $SSEPERATOR, $ACLASSNAME, $SCLASSCHECK
	$SSEPERATOR = Opt("GUIDataSeparatorChar")
	$ACLASSNAME = StringSplit($SCLASSNAME, $SSEPERATOR)
	If Not IsHWnd($HWND) Then $HWND = GUICtrlGetHandle($HWND)
	$SCLASSCHECK = _WINAPI_GETCLASSNAME($HWND)
	For $X = 1 To UBound($ACLASSNAME) - 1
		If StringUpper(StringMid($SCLASSCHECK, 1, StringLen($ACLASSNAME[$X]))) = StringUpper($ACLASSNAME[$X]) Then
			Return True
		EndIf
	Next
	Return False
EndFunc


Func _WINAPI_ISWINDOW($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "IsWindow", "hwnd", $HWND)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_ISWINDOWVISIBLE($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "IsWindowVisible", "hwnd", $HWND)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_INVALIDATERECT($HWND, $TRECT = 0, $FERASE = True)
	Local $PRECT, $ARESULT
	If $TRECT <> 0 Then $PRECT = DllStructGetPtr($TRECT)
	$ARESULT = DllCall("User32.dll", "int", "InvalidateRect", "hwnd", $HWND, "ptr", $PRECT, "int", $FERASE)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_LOADBITMAP($HINSTANCE, $SBITMAP)
	Local $ARESULT, $STYPE = "int"
	If IsString($SBITMAP) Then $STYPE = "str"
	$ARESULT = DllCall("User32.dll", "hwnd", "LoadBitmap", "hwnd", $HINSTANCE, $STYPE, $SBITMAP)
	_WINAPI_CHECK("_WinAPI_LoadBitmap", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_LOADIMAGE($HINSTANCE, $SIMAGE, $ITYPE, $IXDESIRED, $IYDESIRED, $ILOAD)
	Local $ARESULT, $STYPE = "int"
	If IsString($SIMAGE) Then $STYPE = "str"
	$ARESULT = DllCall("User32.dll", "hwnd", "LoadImage", "hwnd", $HINSTANCE, $STYPE, $SIMAGE, "int", $ITYPE, "int", $IXDESIRED, "int", $IYDESIRED, "int", $ILOAD)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_LOADLIBRARY($SFILENAME)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "LoadLibraryA", "str", $SFILENAME)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_LOADLIBRARYEX($SFILENAME, $IFLAGS = 0)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "LoadLibraryExA", "str", $SFILENAME, "hwnd", 0, "int", $IFLAGS)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_LOADSHELL32ICON($IICONID)
	Local $IICONS, $TICONS, $PICONS
	$TICONS = DllStructCreate("int Data")
	$PICONS = DllStructGetPtr($TICONS)
	$IICONS = _WINAPI_EXTRACTICONEX("Shell32.dll", $IICONID, 0, $PICONS, 1)
	_WINAPI_CHECK("_Lib_GetShell32Icon", ($IICONS = 0), -1)
	Return DllStructGetData($TICONS, "Data")
EndFunc


Func _WINAPI_LOADSTRING($HINSTANCE, $ISTRINGID)
	Local $IRESULT, $IBUFFERMAX = 4096
	$IRESULT = DllCall("user32.dll", "int", "LoadString", "hwnd", $HINSTANCE, "uint", $ISTRINGID, "str", "", "int", $IBUFFERMAX)
	If @error Or Not IsArray($IRESULT) Or $IRESULT[0] = 0 Then Return SetError(-1, -1, "")
	Return SetError(0, $IRESULT[0], $IRESULT[3])
EndFunc


Func _WINAPI_LOCALFREE($HMEM)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "LocalFree", "hwnd", $HMEM)
	_WINAPI_CHECK("_WinAPI_LocalFree", ($ARESULT[0] <> 0), 0, True)
	Return $ARESULT[0] = 0
EndFunc


Func _WINAPI_LOWORD($ILONG)
	Return BitAND($ILONG, 65535)
EndFunc


Func _WINAPI_MAKEDWORD($HIWORD, $LOWORD)
	Return BitOR($LOWORD * 65536, BitAND($HIWORD, 65535))
EndFunc


Func _WINAPI_MAKELANGID($LGIDPRIMARY, $LGIDSUB)
	Return BitOR(BitShift($LGIDSUB, -10), $LGIDPRIMARY)
EndFunc


Func _WINAPI_MAKELCID($LGID, $SRTID)
	Return BitOR(BitShift($SRTID, -16), $LGID)
EndFunc


Func _WINAPI_MAKELONG($ILO, $IHI)
	Return BitOR(BitShift($IHI, -16), BitAND($ILO, 65535))
EndFunc


Func _WINAPI_MESSAGEBEEP($ITYPE = 1)
	Local $ISOUND, $ARESULT
	Switch $ITYPE
		Case 1
			$ISOUND = 0
		Case 2
			$ISOUND = 16
		Case 3
			$ISOUND = 32
		Case 4
			$ISOUND = 48
		Case 5
			$ISOUND = 64
		Case Else
			$ISOUND = -1
	EndSwitch
	$ARESULT = DllCall("User32.dll", "int", "MessageBeep", "uint", $ISOUND)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_MSGBOX($IFLAGS, $STITLE, $STEXT)
	BlockInput(0)
	MsgBox($IFLAGS, $STITLE, $STEXT & "      ")
EndFunc


Func _WINAPI_MOUSE_EVENT($IFLAGS, $IX = 0, $IY = 0, $IDATA = 0, $IEXTRAINFO = 0)
	DllCall("User32.dll", "none", "mouse_event", "int", $IFLAGS, "int", $IX, "int", $IY, "int", $IDATA, "int", $IEXTRAINFO)
EndFunc


Func _WINAPI_MOVEWINDOW($HWND, $IX, $IY, $IWIDTH, $IHEIGHT, $FREPAINT = True)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "MoveWindow", "hwnd", $HWND, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT, "int", $FREPAINT)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_MULDIV($INUMBER, $INUMERATOR, $IDENOMINATOR)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "MulDiv", "int", $INUMBER, "int", $INUMERATOR, "int", $IDENOMINATOR)
	_WINAPI_CHECK("_MultDiv", ($ARESULT[0] = -1), -1)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_MULTIBYTETOWIDECHAR($STEXT, $ICODEPAGE = 0, $IFLAGS = 0)
	Local $ITEXT, $PTEXT, $TTEXT
	$ITEXT = StringLen($STEXT) + 1
	$TTEXT = DllStructCreate("byte[" & $ITEXT * 2 & "]")
	$PTEXT = DllStructGetPtr($TTEXT)
	DllCall("Kernel32.dll", "int", "MultiByteToWideChar", "int", $ICODEPAGE, "int", $IFLAGS, "str", $STEXT, "int", $ITEXT, "ptr", $PTEXT, "int", $ITEXT * 2)
	Return $TTEXT
EndFunc


Func _WINAPI_MULTIBYTETOWIDECHAREX($STEXT, $PTEXT, $ICODEPAGE = 0, $IFLAGS = 0)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "MultiByteToWideChar", "int", $ICODEPAGE, "int", $IFLAGS, "str", $STEXT, "int", -1, "ptr", $PTEXT, "int", (StringLen($STEXT) + 1) * 2)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_OPENPROCESS($IACCESS, $FINHERIT, $IPROCESSID, $FDEBUGPRIV = False)
	Local $HTOKEN, $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "OpenProcess", "int", $IACCESS, "int", $FINHERIT, "int", $IPROCESSID)
	If Not $FDEBUGPRIV Or ($ARESULT[0] <> 0) Then
		_WINAPI_CHECK("_WinAPI_OpenProcess:Standard", ($ARESULT[0] = 0), 0, True)
		Return $ARESULT[0]
	EndIf
	$HTOKEN = _SECURITY__OPENTHREADTOKENEX(BitOR($__WINAPCONSTANT_TOKEN_ADJUST_PRIVILEGES, $__WINAPCONSTANT_TOKEN_QUERY))
	_WINAPI_CHECK("_WinAPI_OpenProcess:OpenThreadTokenEx", @error, @extended)
	_SECURITY__SETPRIVILEGE($HTOKEN, "SeDebugPrivilege", True)
	_WINAPI_CHECK("_WinAPI_OpenProcess:SetPrivilege:Enable", @error, @extended)
	$ARESULT = DllCall("Kernel32.dll", "int", "OpenProcess", "int", $IACCESS, "int", $FINHERIT, "int", $IPROCESSID)
	_WINAPI_CHECK("_WinAPI_OpenProcess:Priviliged", ($ARESULT[0] = 0), 0, True)
	_SECURITY__SETPRIVILEGE($HTOKEN, "SeDebugPrivilege", False)
	_WINAPI_CHECK("_WinAPI_OpenProcess:SetPrivilege:Disable", @error, @extended)
	_WINAPI_CLOSEHANDLE($HTOKEN)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_PARSEFILEDIALOGPATH($SPATH)
	Local $AFILES[3], $STEMP
	$AFILES[0] = 2
	$STEMP = StringMid($SPATH, 1, StringInStr($SPATH, "\", 0, -1) - 1)
	$AFILES[1] = $STEMP
	$AFILES[2] = StringMid($SPATH, StringInStr($SPATH, "\", 0, -1) + 1)
	Return $AFILES
EndFunc


Func _WINAPI_POINTFROMRECT(ByRef $TRECT, $FCENTER = True)
	Local $IX1, $IY1, $IX2, $IY2, $TPOINT
	$IX1 = DllStructGetData($TRECT, "Left")
	$IY1 = DllStructGetData($TRECT, "Top")
	$IX2 = DllStructGetData($TRECT, "Right")
	$IY2 = DllStructGetData($TRECT, "Bottom")
	If $FCENTER Then
		$IX1 = $IX1 + (($IX2 - $IX1) / 2)
		$IY1 = $IY1 + (($IY2 - $IY1) / 2)
	EndIf
	$TPOINT = DllStructCreate($TAGPOINT)
	DllStructSetData($TPOINT, "X", $IX1)
	DllStructSetData($TPOINT, "Y", $IY1)
	Return $TPOINT
EndFunc


Func _WINAPI_POSTMESSAGE($HWND, $IMSG, $IWPARAM, $ILPARAM)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "PostMessageA", "hwnd", $HWND, "int", $IMSG, "int", $IWPARAM, "int", $ILPARAM)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_PRIMARYLANGID($LGID)
	Return BitAND($LGID, 1023)
EndFunc


Func _WINAPI_PTINRECT(ByRef $TRECT, ByRef $TPOINT)
	Local $IX, $IY, $ARESULT
	$IX = DllStructGetData($TPOINT, "X")
	$IY = DllStructGetData($TPOINT, "Y")
	$ARESULT = DllCall("User32.dll", "int", "PtInRect", "ptr", DllStructGetPtr($TRECT), "int", $IX, "int", $IY)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_READFILE($HFILE, $PBUFFER, $ITOREAD, ByRef $IREAD, $POVERLAPPED = 0)
	Local $ARESULT, $PREAD, $TREAD
	$TREAD = DllStructCreate("int Read")
	$PREAD = DllStructGetPtr($TREAD)
	$ARESULT = DllCall("Kernel32.dll", "int", "ReadFile", "hwnd", $HFILE, "ptr", $PBUFFER, "int", $ITOREAD, "ptr", $PREAD, "ptr", $POVERLAPPED)
	$IREAD = DllStructGetData($TREAD, "Read")
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_READPROCESSMEMORY($HPROCESS, $PBASEADDRESS, $PBUFFER, $ISIZE, ByRef $IREAD)
	Local $PREAD, $TREAD, $ARESULT
	$TREAD = DllStructCreate("int Read")
	$PREAD = DllStructGetPtr($TREAD)
	$ARESULT = DllCall("Kernel32.dll", "int", "ReadProcessMemory", "int", $HPROCESS, "int", $PBASEADDRESS, "ptr", $PBUFFER, "int", $ISIZE, "ptr", $PREAD)
	_WINAPI_CHECK("_WinAPI_ReadProcessMemory", ($ARESULT[0] = 0), 0, True)
	$IREAD = DllStructGetData($TREAD, "Read")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_RECTISEMPTY(ByRef $TRECT)
	Return (DllStructGetData($TRECT, "Left") = 0) And (DllStructGetData($TRECT, "Top") = 0) And (DllStructGetData($TRECT, "Right") = 0) And (DllStructGetData($TRECT, "Bottom") = 0)
EndFunc


Func _WINAPI_REDRAWWINDOW($HWND, $TRECT = 0, $HREGION = 0, $IFLAGS = 5)
	Local $PRECT, $ARESULT
	If $TRECT <> 0 Then $PRECT = DllStructGetPtr($TRECT)
	$ARESULT = DllCall("User32.dll", "int", "RedrawWindow", "hwnd", $HWND, "ptr", $PRECT, "int", $HREGION, "int", $IFLAGS)
	Return ($ARESULT[0] <> 0)
EndFunc


Func _WINAPI_REGISTERWINDOWMESSAGE($SMESSAGE)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "RegisterWindowMessage", "str", $SMESSAGE)
	_WINAPI_CHECK("_WinAPI_RegisterWindowMessage", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_RELEASECAPTURE()
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ReleaseCapture")
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_RELEASEDC($HWND, $HDC)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ReleaseDC", "hwnd", $HWND, "hwnd", $HDC)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_SCREENTOCLIENT($HWND, ByRef $TPOINT)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ScreenToClient", "hwnd", $HWND, "ptr", DllStructGetPtr($TPOINT))
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_SELECTOBJECT($HDC, $HGDIOBJ)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "SelectObject", "hwnd", $HDC, "hwnd", $HGDIOBJ)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETBKCOLOR($HDC, $ICOLOR)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "SetBkColor", "hwnd", $HDC, "int", $ICOLOR)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETCAPTURE($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "SetCapture", "hwnd", $HWND)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETCURSOR($HCURSOR)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "SetCursor", "hwnd", $HCURSOR)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETDEFAULTPRINTER($SPRINTER)
	Local $ARESULT
	$ARESULT = DllCall("WinSpool.drv", "int", "SetDefaultPrinterA", "str", $SPRINTER)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_SETDIBITS($HDC, $HBMP, $ISTARTSCAN, $ISCANLINES, $PBITS, $PBMI, $ICOLORUSE = 0)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "SetDIBits", "hwnd", $HDC, "hwnd", $HBMP, "uint", $ISTARTSCAN, "uint", $ISCANLINES, "ptr", $PBITS, "ptr", $PBMI, "uint", $ICOLORUSE)
	Return SetError($ARESULT[0] = 0, _WINAPI_GETLASTERROR(), $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_SETEVENT($HEVENT)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "SetEvent", "hwnd", $HEVENT)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_SETFOCUS($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "SetFocus", "hwnd", $HWND)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETFONT($HWND, $HFONT, $FREDRAW = True)
	_SENDMESSAGE($HWND, $__WINAPCONSTANT_WM_SETFONT, $HFONT, $FREDRAW, 0, "hwnd")
EndFunc


Func _WINAPI_SETHANDLEINFORMATION($HOBJECT, $IMASK, $IFLAGS)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "SetHandleInformation", "hwnd", $HOBJECT, "uint", $IMASK, "uint", $IFLAGS)
	_WINAPI_CHECK("_WinAPI_SetHandleInformation", $ARESULT[0] = 0, 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETLASTERROR($IERRCODE)
	DllCall("Kernel32.dll", "none", "SetLastError", "dword", $IERRCODE)
EndFunc


Func _WINAPI_SETPARENT($HWNDCHILD, $HWNDPARENT)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "SetParent", "hwnd", $HWNDCHILD, "hwnd", $HWNDPARENT)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETPROCESSAFFINITYMASK($HPROCESS, $IMASK)
	Local $IRESULT
	$IRESULT = DllCall("Kernel32.dll", "int", "SetProcessAffinityMask", "hwnd", $HPROCESS, "int", $IMASK)
	_WINAPI_CHECK("_WinAPI_SetProcessAffinityMask", ($IRESULT[0] = 0), 0, True)
	Return $IRESULT[0] <> 0
EndFunc


Func _WINAPI_SETSYSCOLORS($VELEMENTS, $VCOLORS)
	Local $ISEARRAY = IsArray($VELEMENTS), $ISCARRAY = IsArray($VCOLORS)
	Local $IELEMENTNUM
	If Not $ISCARRAY And Not $ISEARRAY Then
		$IELEMENTNUM = 1
	ElseIf $ISCARRAY Or $ISEARRAY Then
		If Not $ISCARRAY Or Not $ISEARRAY Then Return SetError(-1, -1, False)
		If UBound($VELEMENTS) <> UBound($VCOLORS) Then Return SetError(-1, -1, False)
		$IELEMENTNUM = UBound($VELEMENTS)
	EndIf
	Local $TELEMENTS = DllStructCreate("int Element[" & $IELEMENTNUM & "]")
	Local $TCOLORS = DllStructCreate("int NewColor[" & $IELEMENTNUM & "]")
	Local $PELEMENTS = DllStructGetPtr($TELEMENTS)
	Local $PCOLORS = DllStructGetPtr($TCOLORS)
	If Not $ISEARRAY Then
		DllStructSetData($TELEMENTS, "Element", $VELEMENTS, 1)
	Else
		For $X = 0 To $IELEMENTNUM - 1
			DllStructSetData($TELEMENTS, "Element", $VELEMENTS[$X], $X + 1)
		Next
	EndIf
	If Not $ISCARRAY Then
		DllStructSetData($TCOLORS, "NewColor", $VCOLORS, 1)
	Else
		For $X = 0 To $IELEMENTNUM - 1
			DllStructSetData($TCOLORS, "NewColor", $VCOLORS[$X], $X + 1)
		Next
	EndIf
	Local $IRESULTS = DllCall("user32.dll", "int", "SetSysColors", "int", $IELEMENTNUM, "ptr", $PELEMENTS, "ptr", $PCOLORS)
	If @error Then Return SetError(-1, -1, False)
	Return $IRESULTS[0] <> 0
EndFunc


Func _WINAPI_SETTEXTCOLOR($HDC, $ICOLOR)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "SetTextColor", "hwnd", $HDC, "int", $ICOLOR)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETWINDOWLONG($HWND, $IINDEX, $IVALUE)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "SetWindowLong", "hwnd", $HWND, "int", $IINDEX, "int", $IVALUE)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETWINDOWPOS($HWND, $HAFTER, $IX, $IY, $ICX, $ICY, $IFLAGS)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $HWND, "hwnd", $HAFTER, "int", $IX, "int", $IY, "int", $ICX, "int", $ICY, "int", $IFLAGS)
	_WINAPI_CHECK("_WinAPI_SetWindowPos", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_SETWINDOWSHOOKEX($IDHOOK, $LPFN, $HMOD, $DWTHREADID = 0)
	Local $HWNDHOOK = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", $IDHOOK, "ptr", $LPFN, "hwnd", $HMOD, "dword", $DWTHREADID)
	If @error Then Return SetError(@error, @extended, 0)
	Return $HWNDHOOK[0]
EndFunc


Func _WINAPI_SETWINDOWTEXT($HWND, $STEXT)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "SetWindowText", "hwnd", $HWND, "str", $STEXT)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_SHOWCURSOR($FSHOW)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ShowCursor", "int", $FSHOW)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SHOWERROR($STEXT, $FEXIT = True)
	_WINAPI_MSGBOX(266256, "Error", $STEXT)
	If $FEXIT Then Exit
EndFunc


Func _WINAPI_SHOWMSG($STEXT)
	_WINAPI_MSGBOX(64 + 4096, "Information", $STEXT)
EndFunc


Func _WINAPI_SHOWWINDOW($HWND, $ICMDSHOW = 5)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ShowWindow", "hwnd", $HWND, "int", $ICMDSHOW)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_STRINGFROMGUID($PGUID)
	Local $ARESULT
	$ARESULT = DllCall("Ole32.dll", "int", "StringFromGUID2", "ptr", $PGUID, "wstr", "", "int", 40)
	Return SetError($ARESULT[0] <> 0, 0, $ARESULT[2])
EndFunc


Func _WINAPI_SUBLANGID($LGID)
	Return BitShift($LGID, 10)
EndFunc


Func _WINAPI_SYSTEMPARAMETERSINFO($IACTION, $IPARAM = 0, $VPARAM = 0, $IWININI = 0)
	Local $ARESULT
	$ARESULT = DllCall("user32.dll", "int", "SystemParametersInfo", "int", $IACTION, "int", $IPARAM, "int", $VPARAM, "int", $IWININI)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_TWIPSPERPIXELX()
	Local $LNGDC, $TWIPSPERPIXELX
	$LNGDC = _WINAPI_GETDC(0)
	$TWIPSPERPIXELX = 1440 / _WINAPI_GETDEVICECAPS($LNGDC, $__WINAPCONSTANT_LOGPIXELSX)
	_WINAPI_RELEASEDC(0, $LNGDC)
	Return $TWIPSPERPIXELX
EndFunc


Func _WINAPI_TWIPSPERPIXELY()
	Local $LNGDC, $TWIPSPERPIXELY
	$LNGDC = _WINAPI_GETDC(0)
	$TWIPSPERPIXELY = 1440 / _WINAPI_GETDEVICECAPS($LNGDC, $__WINAPCONSTANT_LOGPIXELSY)
	_WINAPI_RELEASEDC(0, $LNGDC)
	Return $TWIPSPERPIXELY
EndFunc


Func _WINAPI_UNHOOKWINDOWSHOOKEX($HHK)
	Local $IRESULT = DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $HHK)
	If @error Then Return SetError(@error, @extended, 0)
	Return $IRESULT[0] <> 0
EndFunc


Func _WINAPI_UPDATELAYEREDWINDOW($HWND, $HDCDEST, $PPTDEST, $PSIZE, $HDCSRCE, $PPTSRCE, $IRGB, $PBLEND, $IFLAGS)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "UpdateLayeredWindow", "hwnd", $HWND, "hwnd", $HDCDEST, "ptr", $PPTDEST, "ptr", $PSIZE, "hwnd", $HDCSRCE, "ptr", $PPTSRCE, "int", $IRGB, "ptr", $PBLEND, "int", $IFLAGS)
	If @error Then Return SetError(1, 0, False)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_UPDATEWINDOW($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "UpdateWindow", "hwnd", $HWND)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_WAITFORINPUTIDLE($HPROCESS, $ITIMEOUT = -1)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "dword", "WaitForInputIdle", "hwnd", $HPROCESS, "dword", $ITIMEOUT)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] = 0)
EndFunc


Func _WINAPI_WAITFORMULTIPLEOBJECTS($ICOUNT, $PHANDLES, $FWAITALL = False, $ITIMEOUT = -1)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "WaitForMultipleObjects", "int", $ICOUNT, "ptr", $PHANDLES, "int", $FWAITALL, "int", $ITIMEOUT)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0])
EndFunc


Func _WINAPI_WAITFORSINGLEOBJECT($HHANDLE, $ITIMEOUT = -1)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "WaitForSingleObject", "hwnd", $HHANDLE, "int", $ITIMEOUT)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0])
EndFunc


Func _WINAPI_WIDECHARTOMULTIBYTE($PUNICODE, $ICODEPAGE = 0)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "WideCharToMultiByte", "int", $ICODEPAGE, "int", 0, "ptr", $PUNICODE, "int", -1, "str", "", "int", 0, "int", 0, "int", 0)
	$ARESULT = DllCall("Kernel32.dll", "int", "WideCharToMultiByte", "int", $ICODEPAGE, "int", 0, "ptr", $PUNICODE, "int", -1, "str", "", "int", $ARESULT[0], "int", 0, "int", 0)
	Return $ARESULT[5]
EndFunc


Func _WINAPI_WINDOWFROMPOINT(ByRef $TPOINT)
	Local $IX, $IY, $ARESULT
	$IX = DllStructGetData($TPOINT, "X")
	$IY = DllStructGetData($TPOINT, "Y")
	$ARESULT = DllCall("User32.dll", "hwnd", "WindowFromPoint", "int", $IX, "int", $IY)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_WRITECONSOLE($HCONSOLE, $STEXT)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "WriteConsole", "int", $HCONSOLE, "str", $STEXT, "int", StringLen($STEXT), "int*", 0, "int", 0)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_WRITEFILE($HFILE, $PBUFFER, $ITOWRITE, ByRef $IWRITTEN, $POVERLAPPED = 0)
	Local $PWRITTEN, $TWRITTEN, $ARESULT
	$TWRITTEN = DllStructCreate("int Written")
	$PWRITTEN = DllStructGetPtr($TWRITTEN)
	$ARESULT = DllCall("Kernel32.dll", "int", "WriteFile", "hwnd", $HFILE, "ptr", $PBUFFER, "uint", $ITOWRITE, "ptr", $PWRITTEN, "ptr", $POVERLAPPED)
	$IWRITTEN = DllStructGetData($TWRITTEN, "Written")
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_WRITEPROCESSMEMORY($HPROCESS, $PBASEADDRESS, $PBUFFER, $ISIZE, ByRef $IWRITTEN, $SBUFFER = "ptr")
	Local $PWRITTEN, $TWRITTEN, $ARESULT
	$TWRITTEN = DllStructCreate("int Written")
	$PWRITTEN = DllStructGetPtr($TWRITTEN)
	$ARESULT = DllCall("Kernel32.dll", "int", "WriteProcessMemory", "int", $HPROCESS, "int", $PBASEADDRESS, $SBUFFER, $PBUFFER, "int", $ISIZE, "int", $PWRITTEN)
	_WINAPI_CHECK("_WinAPI_WriteProcessMemory", ($ARESULT[0] = 0), 0, True)
	$IWRITTEN = DllStructGetData($TWRITTEN, "Written")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_VALIDATECLASSNAME($HWND, $SCLASSNAMES)
	Local $ACLASSNAMES, $SSEPERATOR = Opt("GUIDataSeparatorChar"), $STEXT
	If Not _WINAPI_ISCLASSNAME($HWND, $SCLASSNAMES) Then
		$ACLASSNAMES = StringSplit($SCLASSNAMES, $SSEPERATOR)
		For $X = 1 To $ACLASSNAMES[0]
			$STEXT &= $ACLASSNAMES[$X] & ", "
		Next
		$STEXT = StringTrimRight($STEXT, 2)
		_WINAPI_SHOWERROR("Invalid Class Type(s):" & @LF & @TAB & "Expecting Type(s): " & $STEXT & @LF & @TAB & "Received Type : " & _WINAPI_GETCLASSNAME($HWND))
	EndIf
EndFunc

Global Const $GDIP_DASHCAPFLAT = 0
Global Const $GDIP_DASHCAPROUND = 2
Global Const $GDIP_DASHCAPTRIANGLE = 3
Global Const $GDIP_DASHSTYLESOLID = 0
Global Const $GDIP_DASHSTYLEDASH = 1
Global Const $GDIP_DASHSTYLEDOT = 2
Global Const $GDIP_DASHSTYLEDASHDOT = 3
Global Const $GDIP_DASHSTYLEDASHDOTDOT = 4
Global Const $GDIP_DASHSTYLECUSTOM = 5
Global Const $GDIP_EPGCHROMINANCETABLE = "{F2E455DC-09B3-4316-8260-676ADA32481C}"
Global Const $GDIP_EPGCOLORDEPTH = "{66087055-AD66-4C7C-9A18-38A2310B8337}"
Global Const $GDIP_EPGCOMPRESSION = "{E09D739D-CCD4-44EE-8EBA-3FBF8BE4FC58}"
Global Const $GDIP_EPGLUMINANCETABLE = "{EDB33BCE-0266-4A77-B904-27216099E717}"
Global Const $GDIP_EPGQUALITY = "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}"
Global Const $GDIP_EPGRENDERMETHOD = "{6D42C53A-229A-4825-8BB7-5C99E2B9A8B8}"
Global Const $GDIP_EPGSAVEFLAG = "{292266FC-AC40-47BF-8CFC-A85B89A655DE}"
Global Const $GDIP_EPGSCANMETHOD = "{3A4E2661-3109-4E56-8536-42C156E7DCFA}"
Global Const $GDIP_EPGTRANSFORMATION = "{8D0EB2D1-A58E-4EA8-AA14-108074B7B6F9}"
Global Const $GDIP_EPGVERSION = "{24D18C76-814A-41A4-BF53-1C219CCCF797}"
Global Const $GDIP_EPTBYTE = 1
Global Const $GDIP_EPTASCII = 2
Global Const $GDIP_EPTSHORT = 3
Global Const $GDIP_EPTLONG = 4
Global Const $GDIP_EPTRATIONAL = 5
Global Const $GDIP_EPTLONGRANGE = 6
Global Const $GDIP_EPTUNDEFINED = 7
Global Const $GDIP_EPTRATIONALRANGE = 8
Global Const $GDIP_ERROK = 0
Global Const $GDIP_ERRGENERICERROR = 1
Global Const $GDIP_ERRINVALIDPARAMETER = 2
Global Const $GDIP_ERROUTOFMEMORY = 3
Global Const $GDIP_ERROBJECTBUSY = 4
Global Const $GDIP_ERRINSUFFICIENTBUFFER = 5
Global Const $GDIP_ERRNOTIMPLEMENTED = 6
Global Const $GDIP_ERRWIN32ERROR = 7
Global Const $GDIP_ERRWRONGSTATE = 8
Global Const $GDIP_ERRABORTED = 9
Global Const $GDIP_ERRFILENOTFOUND = 10
Global Const $GDIP_ERRVALUEOVERFLOW = 11
Global Const $GDIP_ERRACCESSDENIED = 12
Global Const $GDIP_ERRUNKNOWNIMAGEFORMAT = 13
Global Const $GDIP_ERRFONTFAMILYNOTFOUND = 14
Global Const $GDIP_ERRFONTSTYLENOTFOUND = 15
Global Const $GDIP_ERRNOTTRUETYPEFONT = 16
Global Const $GDIP_ERRUNSUPPORTEDGDIVERSION = 17
Global Const $GDIP_ERRGDIPLUSNOTINITIALIZED = 18
Global Const $GDIP_ERRPROPERTYNOTFOUND = 19
Global Const $GDIP_ERRPROPERTYNOTSUPPORTED = 20
Global Const $GDIP_EVTCOMPRESSIONLZW = 2
Global Const $GDIP_EVTCOMPRESSIONCCITT3 = 3
Global Const $GDIP_EVTCOMPRESSIONCCITT4 = 4
Global Const $GDIP_EVTCOMPRESSIONRLE = 5
Global Const $GDIP_EVTCOMPRESSIONNONE = 6
Global Const $GDIP_EVTTRANSFORMROTATE90 = 13
Global Const $GDIP_EVTTRANSFORMROTATE180 = 14
Global Const $GDIP_EVTTRANSFORMROTATE270 = 15
Global Const $GDIP_EVTTRANSFORMFLIPHORIZONTAL = 16
Global Const $GDIP_EVTTRANSFORMFLIPVERTICAL = 17
Global Const $GDIP_EVTMULTIFRAME = 18
Global Const $GDIP_EVTLASTFRAME = 19
Global Const $GDIP_EVTFLUSH = 20
Global Const $GDIP_EVTFRAMEDIMENSIONPAGE = 23
Global Const $GDIP_ICFENCODER = 1
Global Const $GDIP_ICFDECODER = 2
Global Const $GDIP_ICFSUPPORTBITMAP = 4
Global Const $GDIP_ICFSUPPORTVECTOR = 8
Global Const $GDIP_ICFSEEKABLEENCODE = 16
Global Const $GDIP_ICFBLOCKINGDECODE = 32
Global Const $GDIP_ICFBUILTIN = 65536
Global Const $GDIP_ICFSYSTEM = 131072
Global Const $GDIP_ICFUSER = 262144
Global Const $GDIP_ILMREAD = 1
Global Const $GDIP_ILMWRITE = 2
Global Const $GDIP_ILMUSERINPUTBUF = 4
Global Const $GDIP_LINECAPFLAT = 0
Global Const $GDIP_LINECAPSQUARE = 1
Global Const $GDIP_LINECAPROUND = 2
Global Const $GDIP_LINECAPTRIANGLE = 3
Global Const $GDIP_LINECAPNOANCHOR = 16
Global Const $GDIP_LINECAPSQUAREANCHOR = 17
Global Const $GDIP_LINECAPROUNDANCHOR = 18
Global Const $GDIP_LINECAPDIAMONDANCHOR = 19
Global Const $GDIP_LINECAPARROWANCHOR = 20
Global Const $GDIP_LINECAPCUSTOM = 255
Global Const $GDIP_PXF01INDEXED = 196865
Global Const $GDIP_PXF04INDEXED = 197634
Global Const $GDIP_PXF08INDEXED = 198659
Global Const $GDIP_PXF16GRAYSCALE = 1052676
Global Const $GDIP_PXF16RGB555 = 135173
Global Const $GDIP_PXF16RGB565 = 135174
Global Const $GDIP_PXF16ARGB1555 = 397319
Global Const $GDIP_PXF24RGB = 137224
Global Const $GDIP_PXF32RGB = 139273
Global Const $GDIP_PXF32ARGB = 2498570
Global Const $GDIP_PXF32PARGB = 860171
Global Const $GDIP_PXF48RGB = 1060876
Global Const $GDIP_PXF64ARGB = 3424269
Global Const $GDIP_PXF64PARGB = 1851406
Global $GHGDIPBRUSH = 0
Global $GHGDIPDLL = 0
Global $GHGDIPPEN = 0
Global $GIGDIPREF = 0
Global $GIGDIPTOKEN = 0

Func _GDIPLUS_ARROWCAPCREATE($NHEIGHT, $NWIDTH, $FFILLED = True)
	Local $IHEIGHT, $IWIDTH, $ARESULT
	$IHEIGHT = _WINAPI_FLOATTOINT($NHEIGHT)
	$IWIDTH = _WINAPI_FLOATTOINT($NWIDTH)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateAdjustableArrowCap", "int", $IHEIGHT, "int", $IWIDTH, "int", $FFILLED, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[4])
EndFunc


Func _GDIPLUS_ARROWCAPDISPOSE($HCAP)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDeleteCustomLineCap", "hwnd", $HCAP)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_ARROWCAPGETFILLSTATE($HARROWCAP)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetAdjustableArrowCapFillState", "hwnd", $HARROWCAP, "int*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[2] <> 0)
EndFunc


Func _GDIPLUS_ARROWCAPGETHEIGHT($HARROWCAP)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetAdjustableArrowCapHeight", "hwnd", $HARROWCAP, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, _WINAPI_INTTOFLOAT($ARESULT[2]))
EndFunc


Func _GDIPLUS_ARROWCAPGETMIDDLEINSET($HARROWCAP)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetAdjustableArrowCapMiddleInset", "hwnd", $HARROWCAP, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, _WINAPI_INTTOFLOAT($ARESULT[2]))
EndFunc


Func _GDIPLUS_ARROWCAPGETWIDTH($HARROWCAP)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetAdjustableArrowCapWidth", "hwnd", $HARROWCAP, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, _WINAPI_INTTOFLOAT($ARESULT[2]))
EndFunc


Func _GDIPLUS_ARROWCAPSETFILLSTATE($HARROWCAP, $FFILLED = True)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetAdjustableArrowCapFillState", "hwnd", $HARROWCAP, "int", $FFILLED)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_ARROWCAPSETHEIGHT($HARROWCAP, $NHEIGHT)
	Local $IHEIGHT, $ARESULT
	$IHEIGHT = _WINAPI_FLOATTOINT($NHEIGHT)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetAdjustableArrowCapHeight", "hwnd", $HARROWCAP, "int", $IHEIGHT)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_ARROWCAPSETMIDDLEINSET($HARROWCAP, $NINSET)
	Local $IINSET, $ARESULT
	$IINSET = _WINAPI_FLOATTOINT($NINSET)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetAdjustableArrowCapMiddleInset", "hwnd", $HARROWCAP, "int", $IINSET)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_ARROWCAPSETWIDTH($HARROWCAP, $NWIDTH)
	Local $IWIDTH, $ARESULT
	$IWIDTH = _WINAPI_FLOATTOINT($NWIDTH)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetAdjustableArrowCapWidth", "hwnd", $HARROWCAP, "int", $IWIDTH)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_BITMAPCLONEAREA($HBMP, $ILEFT, $ITOP, $IWIDTH, $IHEIGHT, $IFORMAT = 137224)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCloneBitmapAreaI", "int", $ILEFT, "int", $ITOP, "int", $IWIDTH, "int", $IHEIGHT, "int", $IFORMAT, "ptr", $HBMP, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[7])
EndFunc


Func _GDIPLUS_BITMAPCREATEFROMFILE($SFILENAME)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateBitmapFromFile", "wstr", $SFILENAME, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_BITMAPCREATEFROMGRAPHICS($IWIDTH, $IHEIGHT, $HGRAPHICS)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateBitmapFromGraphics", "int", $IWIDTH, "int", $IHEIGHT, "hwnd", $HGRAPHICS, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[4])
EndFunc


Func _GDIPLUS_BITMAPCREATEFROMHBITMAP($HBMP, $HPAL = 0)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateBitmapFromHBITMAP", "hwnd", $HBMP, "hwnd", $HPAL, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[3])
EndFunc


Func _GDIPLUS_BITMAPCREATEHBITMAPFROMBITMAP($HBITMAP, $IARGB = -16777216)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateHBITMAPFromBitmap", "hwnd", $HBITMAP, "int*", 0, "int", $IARGB)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_BITMAPDISPOSE($HBITMAP)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDisposeImage", "hwnd", $HBITMAP)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_BITMAPLOCKBITS($HBITMAP, $ILEFT, $ITOP, $IRIGHT, $IBOTTOM, $IFLAGS = 1, $IFORMAT = 139273)
	Local $PDATA, $TDATA, $PRECT, $TRECT, $ARESULT
	$TDATA = DllStructCreate($TAGGDIPBITMAPDATA)
	$PDATA = DllStructGetPtr($TDATA)
	$TRECT = DllStructCreate($TAGRECT)
	$PRECT = DllStructGetPtr($TRECT)
	DllStructSetData($TRECT, "Left", $ILEFT)
	DllStructSetData($TRECT, "Top", $ITOP)
	DllStructSetData($TRECT, "Right", $IRIGHT)
	DllStructSetData($TRECT, "Bottom", $IBOTTOM)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipBitmapLockBits", "hwnd", $HBITMAP, "ptr", $PRECT, "uint", $IFLAGS, "uint", $IFORMAT, "ptr", $PDATA)
	If @error Then Return SetError(@error, @extended, $TRECT)
	Return SetError($ARESULT[0], 0, $TDATA)
EndFunc


Func _GDIPLUS_BITMAPUNLOCKBITS($HBITMAP, $TBITMAPDATA)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipBitmapUnlockBits", "hwnd", $HBITMAP, "int*", DllStructGetPtr($TBITMAPDATA))
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_BRUSHCLONE($HBRUSH)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCloneBrush", "hwnd", $HBRUSH, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_BRUSHCREATESOLID($IARGB = -16777216)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateSolidFill", "int", $IARGB, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_BRUSHDISPOSE($HBRUSH)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDeleteBrush", "hwnd", $HBRUSH)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_BRUSHGETTYPE($HBRUSH)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetBrushType", "hwnd", $HBRUSH, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_CUSTOMLINECAPDISPOSE($HCAP)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDeleteCustomLineCap", "hwnd", $HCAP)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_DECODERS()
	Local $II, $ICOUNT, $ISIZE, $PBUFFER, $TBUFFER, $TCODEC, $ARESULT, $AINFO[1][14]
	$ICOUNT = _GDIPLUS_DECODERSGETCOUNT()
	$ISIZE = _GDIPLUS_DECODERSGETSIZE()
	$TBUFFER = DllStructCreate("byte[" & $ISIZE & "]")
	$PBUFFER = DllStructGetPtr($TBUFFER)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetImageDecoders", "int", $ICOUNT, "int", $ISIZE, "ptr", $PBUFFER)
	If @error Then Return SetError(@error, @extended, $AINFO)
	If $ARESULT[0] <> 0 Then Return SetError($ARESULT[0], 0, $AINFO)
	Dim $AINFO[$ICOUNT + 1][14]
	$AINFO[0][0] = $ICOUNT
	For $II = 1 To $ICOUNT
		$TCODEC = DllStructCreate($TAGGDIPIMAGECODECINFO, $PBUFFER)
		$AINFO[$II][1] = _WINAPI_STRINGFROMGUID(DllStructGetPtr($TCODEC, "CLSID"))
		$AINFO[$II][2] = _WINAPI_STRINGFROMGUID(DllStructGetPtr($TCODEC, "FormatID"))
		$AINFO[$II][3] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "CodecName"))
		$AINFO[$II][4] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "DllName"))
		$AINFO[$II][5] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "FormatDesc"))
		$AINFO[$II][6] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "FileExt"))
		$AINFO[$II][7] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "MimeType"))
		$AINFO[$II][8] = DllStructGetData($TCODEC, "Flags")
		$AINFO[$II][9] = DllStructGetData($TCODEC, "Version")
		$AINFO[$II][10] = DllStructGetData($TCODEC, "SigCount")
		$AINFO[$II][11] = DllStructGetData($TCODEC, "SigSize")
		$AINFO[$II][12] = DllStructGetData($TCODEC, "SigPattern")
		$AINFO[$II][13] = DllStructGetData($TCODEC, "SigMask")
		$PBUFFER += DllStructGetSize($TCODEC)
	Next
	Return $AINFO
EndFunc


Func _GDIPLUS_DECODERSGETCOUNT()
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetImageDecodersSize", "int*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[1])
EndFunc


Func _GDIPLUS_DECODERSGETSIZE()
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetImageDecodersSize", "int*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_DRAWIMAGEPOINTS($HGRAPHIC, $HIMAGE, $NULX, $NULY, $NURX, $NURY, $NLLX, $NLLY, $COUNT = 3)
	Local $IULX, $IULY, $IURX, $IURY, $ILLX, $ILLY, $TPOINT, $PPOINT, $ARESULT
	$IULX = _WINAPI_FLOATTOINT($NULX)
	$IULY = _WINAPI_FLOATTOINT($NULY)
	$IURX = _WINAPI_FLOATTOINT($NURX)
	$IURY = _WINAPI_FLOATTOINT($NURY)
	$ILLX = _WINAPI_FLOATTOINT($NLLX)
	$ILLY = _WINAPI_FLOATTOINT($NLLY)
	$TPOINT = DllStructCreate("int X;int Y;int X2;int Y2;int X3;int Y3")
	DllStructSetData($TPOINT, "X", $IULX)
	DllStructSetData($TPOINT, "Y", $IULY)
	DllStructSetData($TPOINT, "X2", $IURX)
	DllStructSetData($TPOINT, "Y2", $IURY)
	DllStructSetData($TPOINT, "X3", $ILLX)
	DllStructSetData($TPOINT, "Y3", $ILLY)
	$PPOINT = DllStructGetPtr($TPOINT)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawImagePoints", "hwnd", $HGRAPHIC, "hwnd", $HIMAGE, "ptr", $PPOINT, "int", $COUNT)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_ENCODERS()
	Local $II, $ICOUNT, $ISIZE, $PBUFFER, $TBUFFER, $TCODEC, $ARESULT, $AINFO[1][14]
	$ICOUNT = _GDIPLUS_ENCODERSGETCOUNT()
	$ISIZE = _GDIPLUS_ENCODERSGETSIZE()
	$TBUFFER = DllStructCreate("byte[" & $ISIZE & "]")
	$PBUFFER = DllStructGetPtr($TBUFFER)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetImageEncoders", "int", $ICOUNT, "int", $ISIZE, "ptr", $PBUFFER)
	If @error Then Return SetError(@error, @extended, $AINFO)
	If $ARESULT[0] <> 0 Then Return SetError($ARESULT[0], 0, $AINFO)
	Dim $AINFO[$ICOUNT + 1][14]
	$AINFO[0][0] = $ICOUNT
	For $II = 1 To $ICOUNT
		$TCODEC = DllStructCreate($TAGGDIPIMAGECODECINFO, $PBUFFER)
		$AINFO[$II][1] = _WINAPI_STRINGFROMGUID(DllStructGetPtr($TCODEC, "CLSID"))
		$AINFO[$II][2] = _WINAPI_STRINGFROMGUID(DllStructGetPtr($TCODEC, "FormatID"))
		$AINFO[$II][3] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "CodecName"))
		$AINFO[$II][4] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "DllName"))
		$AINFO[$II][5] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "FormatDesc"))
		$AINFO[$II][6] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "FileExt"))
		$AINFO[$II][7] = _WINAPI_WIDECHARTOMULTIBYTE(DllStructGetData($TCODEC, "MimeType"))
		$AINFO[$II][8] = DllStructGetData($TCODEC, "Flags")
		$AINFO[$II][9] = DllStructGetData($TCODEC, "Version")
		$AINFO[$II][10] = DllStructGetData($TCODEC, "SigCount")
		$AINFO[$II][11] = DllStructGetData($TCODEC, "SigSize")
		$AINFO[$II][12] = DllStructGetData($TCODEC, "SigPattern")
		$AINFO[$II][13] = DllStructGetData($TCODEC, "SigMask")
		$PBUFFER += DllStructGetSize($TCODEC)
	Next
	Return $AINFO
EndFunc


Func _GDIPLUS_ENCODERSGETCLSID($SFILEEXT)
	Local $II, $AENCODERS
	$AENCODERS = _GDIPLUS_ENCODERS()
	For $II = 1 To $AENCODERS[0][0]
		If StringInStr($AENCODERS[$II][6], "*." & $SFILEEXT) > 0 Then Return $AENCODERS[$II][1]
	Next
	Return SetError(-1, -1, "")
EndFunc


Func _GDIPLUS_ENCODERSGETCOUNT()
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetImageEncodersSize", "int*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[1])
EndFunc


Func _GDIPLUS_ENCODERSGETPARAMLIST($HIMAGE, $SENCODER)
	Local $ISIZE, $PBUFFER, $TBUFFER, $PGUID, $TGUID, $ARESULT
	$ISIZE = _GDIPLUS_ENCODERSGETPARAMLISTSIZE($HIMAGE, $SENCODER)
	If @error Then Return SetError(-1, -1, 0)
	$TGUID = _WINAPI_GUIDFROMSTRING($SENCODER)
	$PGUID = DllStructGetPtr($TGUID)
	$TBUFFER = DllStructCreate("dword Count;byte Params[" & $ISIZE - 4 & "]")
	$PBUFFER = DllStructGetPtr($TBUFFER)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetEncoderParameterList", "hwnd", $HIMAGE, "ptr", $PGUID, "int", $ISIZE, "ptr", $PBUFFER)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $TBUFFER)
EndFunc


Func _GDIPLUS_ENCODERSGETPARAMLISTSIZE($HIMAGE, $SENCODER)
	Local $PGUID, $TGUID, $ARESULT
	$TGUID = _WINAPI_GUIDFROMSTRING($SENCODER)
	$PGUID = DllStructGetPtr($TGUID)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetEncoderParameterListSize", "hwnd", $HIMAGE, "ptr", $PGUID, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[3])
EndFunc


Func _GDIPLUS_ENCODERSGETSIZE()
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetImageEncodersSize", "int*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_FONTCREATE($HFAMILY, $NSIZE, $ISTYLE = 0, $IUNIT = 3)
	Local $ISIZE, $ARESULT
	$ISIZE = _WINAPI_FLOATTOINT($NSIZE)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateFont", "hwnd", $HFAMILY, "int", $ISIZE, "int", $ISTYLE, "int", $IUNIT, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[5])
EndFunc


Func _GDIPLUS_FONTDISPOSE($HFONT)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDeleteFont", "hwnd", $HFONT)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_FONTFAMILYCREATE($SFAMILY)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateFontFamilyFromName", "wstr", $SFAMILY, "ptr", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[3])
EndFunc


Func _GDIPLUS_FONTFAMILYDISPOSE($HFAMILY)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDeleteFontFamily", "hwnd", $HFAMILY)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSCLEAR($HGRAPHICS, $IARGB = -16777216)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGraphicsClear", "hwnd", $HGRAPHICS, "int", $IARGB)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSCREATEFROMHDC($HDC)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateFromHDC", "hwnd", $HDC, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_GRAPHICSCREATEFROMHWND($HWND)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateFromHWND", "hwnd", $HWND, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_GRAPHICSDISPOSE($HGRAPHICS)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDeleteGraphics", "hwnd", $HGRAPHICS)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWARC($HGRAPHICS, $IX, $IY, $IWIDTH, $IHEIGHT, $NSTARTANGLE, $NSWEEPANGLE, $HPEN = 0)
	Local $ISTART, $ISWEEP, $ARESULT, $TMPERROR, $TMPEXERROR
	_GDIPLUS_PENDEFCREATE($HPEN)
	$ISTART = _WINAPI_FLOATTOINT($NSTARTANGLE)
	$ISWEEP = _WINAPI_FLOATTOINT($NSWEEPANGLE)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawArcI", "hwnd", $HGRAPHICS, "hwnd", $HPEN, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT, "int", $ISTART, "int", $ISWEEP)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_PENDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWBEZIER($HGRAPHICS, $IX1, $IY1, $IX2, $IY2, $IX3, $IY3, $IX4, $IY4, $HPEN = 0)
	Local $ARESULT, $TMPERROR, $TMPEXERROR
	_GDIPLUS_PENDEFCREATE($HPEN)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawBezierI", "hwnd", $HGRAPHICS, "hwnd", $HPEN, "int", $IX1, "int", $IY1, "int", $IX2, "int", $IY2, "int", $IX3, "int", $IY3, "int", $IX4, "int", $IY4)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_PENDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWCLOSEDCURVE($HGRAPHICS, $APOINTS, $HPEN = 0)
	Local $II, $ICOUNT, $PPOINTS, $TPOINTS, $ARESULT, $TMPERROR, $TMPEXERROR
	$ICOUNT = $APOINTS[0][0]
	$TPOINTS = DllStructCreate("int[" & $ICOUNT * 2 & "]")
	$PPOINTS = DllStructGetPtr($TPOINTS)
	For $II = 1 To $ICOUNT
		DllStructSetData($TPOINTS, 1, $APOINTS[$II][0], (($II - 1) * 2) + 1)
		DllStructSetData($TPOINTS, 1, $APOINTS[$II][1], (($II - 1) * 2) + 2)
	Next
	_GDIPLUS_PENDEFCREATE($HPEN)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawClosedCurveI", "hwnd", $HGRAPHICS, "hwnd", $HPEN, "ptr", $PPOINTS, "int", $ICOUNT)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_PENDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWCURVE($HGRAPHICS, $APOINTS, $HPEN = 0)
	Local $II, $ICOUNT, $PPOINTS, $TPOINTS, $ARESULT, $TMPERROR, $TMPEXERROR
	$ICOUNT = $APOINTS[0][0]
	$TPOINTS = DllStructCreate("int[" & $ICOUNT * 2 & "]")
	$PPOINTS = DllStructGetPtr($TPOINTS)
	For $II = 1 To $ICOUNT
		DllStructSetData($TPOINTS, 1, $APOINTS[$II][0], (($II - 1) * 2) + 1)
		DllStructSetData($TPOINTS, 1, $APOINTS[$II][1], (($II - 1) * 2) + 2)
	Next
	_GDIPLUS_PENDEFCREATE($HPEN)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawCurveI", "hwnd", $HGRAPHICS, "hwnd", $HPEN, "ptr", $PPOINTS, "int", $ICOUNT)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_PENDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWELLIPSE($HGRAPHICS, $IX, $IY, $IWIDTH, $IHEIGHT, $HPEN = 0)
	Local $ARESULT, $TMPERROR, $TMPEXERROR
	_GDIPLUS_PENDEFCREATE($HPEN)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawEllipseI", "hwnd", $HGRAPHICS, "hwnd", $HPEN, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_PENDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWIMAGE($HGRAPHICS, $HIMAGE, $IX, $IY)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawImageI", "hwnd", $HGRAPHICS, "hwnd", $HIMAGE, "int", $IX, "int", $IY)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWIMAGERECT($HGRAPHICS, $HIMAGE, $IX, $IY, $IW, $IH)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawImageRectI", "hwnd", $HGRAPHICS, "hwnd", $HIMAGE, "int", $IX, "int", $IY, "int", $IW, "int", $IH)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWIMAGERECTRECT($HGRAPHICS, $HIMAGE, $ISRCX, $ISRCY, $ISRCWIDTH, $ISRCHEIGHT, $IDSTX, $IDSTY, $IDSTWIDTH, $IDSTHEIGHT, $IUNIT = 2)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawImageRectRectI", "hwnd", $HGRAPHICS, "hwnd", $HIMAGE, "int", $IDSTX, "int", $IDSTY, "int", $IDSTWIDTH, "int", $IDSTHEIGHT, "int", $ISRCX, "int", $ISRCY, "int", $ISRCWIDTH, "int", $ISRCHEIGHT, "int", $IUNIT, "int", 0, "int", 0, "int", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWLINE($HGRAPHICS, $IX1, $IY1, $IX2, $IY2, $HPEN = 0)
	Local $ARESULT, $TMPERROR, $TMPEXERROR
	_GDIPLUS_PENDEFCREATE($HPEN)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawLineI", "hwnd", $HGRAPHICS, "hwnd", $HPEN, "int", $IX1, "int", $IY1, "int", $IX2, "int", $IY2)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_PENDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWPIE($HGRAPHICS, $IX, $IY, $IWIDTH, $IHEIGHT, $NSTARTANGLE, $NSWEEPANGLE, $HPEN = 0)
	Local $ISTART, $ISWEEP, $ARESULT, $TMPERROR, $TMPEXERROR
	_GDIPLUS_PENDEFCREATE($HPEN)
	$ISTART = _WINAPI_FLOATTOINT($NSTARTANGLE)
	$ISWEEP = _WINAPI_FLOATTOINT($NSWEEPANGLE)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawPieI", "hwnd", $HGRAPHICS, "hwnd", $HPEN, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT, "int", $ISTART, "int", $ISWEEP)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_PENDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWPOLYGON($HGRAPHICS, $APOINTS, $HPEN = 0)
	Local $II, $ICOUNT, $PPOINTS, $TPOINTS, $ARESULT, $TMPERROR, $TMPEXERROR
	$ICOUNT = $APOINTS[0][0]
	$TPOINTS = DllStructCreate("int[" & $ICOUNT * 2 & "]")
	$PPOINTS = DllStructGetPtr($TPOINTS)
	For $II = 1 To $ICOUNT
		DllStructSetData($TPOINTS, 1, $APOINTS[$II][0], (($II - 1) * 2) + 1)
		DllStructSetData($TPOINTS, 1, $APOINTS[$II][1], (($II - 1) * 2) + 2)
	Next
	_GDIPLUS_PENDEFCREATE($HPEN)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawPolygonI", "hwnd", $HGRAPHICS, "hwnd", $HPEN, "ptr", $PPOINTS, "int", $ICOUNT)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_PENDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWRECT($HGRAPHICS, $IX, $IY, $IWIDTH, $IHEIGHT, $HPEN = 0)
	Local $ARESULT, $TMPERROR, $TMPEXERROR
	_GDIPLUS_PENDEFCREATE($HPEN)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawRectangleI", "hwnd", $HGRAPHICS, "hwnd", $HPEN, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_PENDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWSTRING($HGRAPHICS, $SSTRING, $NX, $NY, $SFONT = "Arial", $NSIZE = 10, $IFORMAT = 0)
	Local $HBRUSH, $IERROR, $HFAMILY, $HFONT, $HFORMAT, $AINFO, $TLAYOUT, $BRESULT
	$HBRUSH = _GDIPLUS_BRUSHCREATESOLID()
	$HFORMAT = _GDIPLUS_STRINGFORMATCREATE($IFORMAT)
	$HFAMILY = _GDIPLUS_FONTFAMILYCREATE($SFONT)
	$HFONT = _GDIPLUS_FONTCREATE($HFAMILY, $NSIZE)
	$TLAYOUT = _GDIPLUS_RECTFCREATE($NX, $NY, 0, 0)
	$AINFO = _GDIPLUS_GRAPHICSMEASURESTRING($HGRAPHICS, $SSTRING, $HFONT, $TLAYOUT, $HFORMAT)
	$BRESULT = _GDIPLUS_GRAPHICSDRAWSTRINGEX($HGRAPHICS, $SSTRING, $HFONT, $AINFO[0], $HFORMAT, $HBRUSH)
	$IERROR = @error
	_GDIPLUS_FONTDISPOSE($HFONT)
	_GDIPLUS_FONTFAMILYDISPOSE($HFAMILY)
	_GDIPLUS_STRINGFORMATDISPOSE($HFORMAT)
	_GDIPLUS_BRUSHDISPOSE($HBRUSH)
	Return SetError($IERROR, 0, $BRESULT)
EndFunc


Func _GDIPLUS_GRAPHICSDRAWSTRINGEX($HGRAPHICS, $SSTRING, $HFONT, $TLAYOUT, $HFORMAT, $HBRUSH)
	Local $PLAYOUT, $ARESULT
	$PLAYOUT = DllStructGetPtr($TLAYOUT)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDrawString", "hwnd", $HGRAPHICS, "wstr", $SSTRING, "int", -1, "hwnd", $HFONT, "ptr", $PLAYOUT, "hwnd", $HFORMAT, "hwnd", $HBRUSH)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSFILLCLOSEDCURVE($HGRAPHICS, $APOINTS, $HBRUSH = 0)
	Local $II, $ICOUNT, $PPOINTS, $TPOINTS, $ARESULT, $TMPERROR, $TMPEXERROR
	$ICOUNT = $APOINTS[0][0]
	$TPOINTS = DllStructCreate("int[" & $ICOUNT * 2 & "]")
	$PPOINTS = DllStructGetPtr($TPOINTS)
	For $II = 1 To $ICOUNT
		DllStructSetData($TPOINTS, 1, $APOINTS[$II][0], (($II - 1) * 2) + 1)
		DllStructSetData($TPOINTS, 1, $APOINTS[$II][1], (($II - 1) * 2) + 2)
	Next
	_GDIPLUS_BRUSHDEFCREATE($HBRUSH)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipFillClosedCurveI", "hwnd", $HGRAPHICS, "hwnd", $HBRUSH, "ptr", $PPOINTS, "int", $ICOUNT)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_BRUSHDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSFILLELLIPSE($HGRAPHICS, $IX, $IY, $IWIDTH, $IHEIGHT, $HBRUSH = 0)
	Local $ARESULT, $TMPERROR, $TMPEXERROR
	_GDIPLUS_BRUSHDEFCREATE($HBRUSH)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipFillEllipseI", "hwnd", $HGRAPHICS, "hwnd", $HBRUSH, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_BRUSHDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSFILLPIE($HGRAPHICS, $IX, $IY, $IWIDTH, $IHEIGHT, $NSTARTANGLE, $NSWEEPANGLE, $HBRUSH = 0)
	Local $ISTART, $ISWEEP, $ARESULT, $TMPERROR, $TMPEXERROR
	_GDIPLUS_BRUSHDEFCREATE($HBRUSH)
	$ISTART = _WINAPI_FLOATTOINT($NSTARTANGLE)
	$ISWEEP = _WINAPI_FLOATTOINT($NSWEEPANGLE)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipFillPieI", "hwnd", $HGRAPHICS, "hwnd", $HBRUSH, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT, "int", $ISTART, "int", $ISWEEP)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_BRUSHDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSFILLRECT($HGRAPHICS, $IX, $IY, $IWIDTH, $IHEIGHT, $HBRUSH = 0)
	Local $ARESULT, $TMPERROR, $TMPEXERROR
	_GDIPLUS_BRUSHDEFCREATE($HBRUSH)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipFillRectangleI", "hwnd", $HGRAPHICS, "hwnd", $HBRUSH, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT)
	$TMPERROR = @error
	$TMPEXERROR = @extended
	_GDIPLUS_BRUSHDEFDISPOSE()
	If $TMPERROR Then Return SetError($TMPERROR, $TMPEXERROR, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSGETDC($HGRAPHICS)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetDC", "hwnd", $HGRAPHICS, "int*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_GRAPHICSGETSMOOTHINGMODE($HGRAPHICS)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetSmoothingMode", "hwnd", $HGRAPHICS, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Switch $ARESULT[2]
		Case 3
			Return SetError($ARESULT[0], 0, 1)
		Case 7
			Return SetError($ARESULT[0], 0, 2)
		Case Else
			Return SetError($ARESULT[0], 0, 0)
	EndSwitch
EndFunc


Func _GDIPLUS_GRAPHICSMEASURESTRING($HGRAPHICS, $SSTRING, $HFONT, $TLAYOUT, $HFORMAT)
	Local $PLAYOUT, $PRECTF, $TRECTF, $ARESULT, $AINFO[3]
	$PLAYOUT = DllStructGetPtr($TLAYOUT)
	$TRECTF = DllStructCreate($TAGGDIPRECTF)
	$PRECTF = DllStructGetPtr($TRECTF)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipMeasureString", "hwnd", $HGRAPHICS, "wstr", $SSTRING, "int", -1, "hwnd", $HFONT, "ptr", $PLAYOUT, "hwnd", $HFORMAT, "ptr", $PRECTF, "int*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, $AINFO)
	$AINFO[0] = $TRECTF
	$AINFO[1] = $ARESULT[8]
	$AINFO[2] = $ARESULT[9]
	Return SetError($ARESULT[0], 0, $AINFO)
EndFunc


Func _GDIPLUS_GRAPHICSRELEASEDC($HGRAPHICS, $HDC)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipReleaseDC", "hwnd", $HGRAPHICS, "hwnd", $HDC)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_GRAPHICSSETTRANSFORM($HGRAPHICS, $HMATRIX)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetWorldTransform", "hwnd", $HGRAPHICS, "hwnd", $HMATRIX)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_GRAPHICSSETSMOOTHINGMODE($HGRAPHICS, $ISMOOTH)
	Local $IMODE, $ARESULT
	Switch $ISMOOTH
		Case 1
			$IMODE = 3
		Case 2
			$IMODE = 7
		Case Else
			$IMODE = 0
	EndSwitch
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetSmoothingMode", "hwnd", $HGRAPHICS, "int", $IMODE)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_IMAGEDISPOSE($HIMAGE)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDisposeImage", "hwnd", $HIMAGE)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_IMAGEGETGRAPHICSCONTEXT($HIMAGE)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetImageGraphicsContext", "hwnd", $HIMAGE, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_IMAGEGETHEIGHT($HIMAGE)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetImageHeight", "hwnd", $HIMAGE, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_IMAGEGETWIDTH($HIMAGE)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetImageWidth", "hwnd", $HIMAGE, "int*", -1)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_IMAGELOADFROMFILE($SFILENAME)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipLoadImageFromFile", "wstr", $SFILENAME, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_IMAGESAVETOFILE($HIMAGE, $SFILENAME)
	Local $SCLSID, $SEXT
	$SEXT = _GDIPLUS_EXTRACTFILEEXT($SFILENAME)
	$SCLSID = _GDIPLUS_ENCODERSGETCLSID($SEXT)
	If $SCLSID = "" Then Return SetError(-1, 0, False)
	Return _GDIPLUS_IMAGESAVETOFILEEX($HIMAGE, $SFILENAME, $SCLSID, 0)
EndFunc


Func _GDIPLUS_IMAGESAVETOFILEEX($HIMAGE, $SFILENAME, $SENCODER, $PPARAMS = 0)
	Local $PGUID, $TGUID, $ARESULT
	$TGUID = _WINAPI_GUIDFROMSTRING($SENCODER)
	$PGUID = DllStructGetPtr($TGUID)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSaveImageToFile", "hwnd", $HIMAGE, "wstr", $SFILENAME, "ptr", $PGUID, "ptr", $PPARAMS)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_MATRIXCREATE()
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateMatrix", "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[1])
EndFunc


Func _GDIPLUS_MATRIXDISPOSE($HMATRIX)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDeleteMatrix", "hwnd", $HMATRIX)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_MATRIXROTATE($HMATRIX, $NANGLE, $FAPPEND = False)
	Local $IANGLE, $ARESULT
	$IANGLE = _WINAPI_FLOATTOINT($NANGLE)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipRotateMatrix", "hwnd", $HMATRIX, "int", $IANGLE, "int", $FAPPEND)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_PARAMADD(ByRef $TPARAMS, $SGUID, $ICOUNT, $ITYPE, $PVALUES)
	Local $TPARAM
	$TPARAM = DllStructCreate($TAGGDIPENCODERPARAM, DllStructGetPtr($TPARAMS, "Params") + (DllStructGetData($TPARAMS, "Count") * 28))
	_WINAPI_GUIDFROMSTRINGEX($SGUID, DllStructGetPtr($TPARAM, "GUID"))
	DllStructSetData($TPARAM, "Type", $ITYPE)
	DllStructSetData($TPARAM, "Count", $ICOUNT)
	DllStructSetData($TPARAM, "Values", $PVALUES)
	DllStructSetData($TPARAMS, "Count", DllStructGetData($TPARAMS, "Count") + 1)
EndFunc


Func _GDIPLUS_PARAMINIT($ICOUNT)
	If $ICOUNT <= 0 Then Return SetError(-1, -1, 0)
	Return DllStructCreate("dword Count;byte Params[" & $ICOUNT * 28 & "]")
EndFunc


Func _GDIPLUS_PENCREATE($IARGB = -16777216, $NWIDTH = 1, $IUNIT = 2)
	Local $IWIDTH, $ARESULT
	$IWIDTH = _WINAPI_FLOATTOINT($NWIDTH)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreatePen1", "int", $IARGB, "int", $IWIDTH, "int", $IUNIT, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[4])
EndFunc


Func _GDIPLUS_PENDISPOSE($HPEN)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDeletePen", "hwnd", $HPEN)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_PENGETALIGNMENT($HPEN)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetPenMode", "hwnd", $HPEN, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_PENGETCOLOR($HPEN)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetPenColor", "hwnd", $HPEN, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_PENGETCUSTOMENDCAP($HPEN)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetPenCustomEndCap", "hwnd", $HPEN, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_PENGETDASHCAP($HPEN)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetPenDashCap197819", "hwnd", $HPEN, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_PENGETDASHSTYLE($HPEN)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetPenDashStyle", "hwnd", $HPEN, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_PENGETENDCAP($HPEN)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetPenEndCap", "hwnd", $HPEN, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, $ARESULT[2])
EndFunc


Func _GDIPLUS_PENGETWIDTH($HPEN)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipGetPenWidth", "hwnd", $HPEN, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetError($ARESULT[0], 0, _WINAPI_INTTOFLOAT($ARESULT[2]))
EndFunc


Func _GDIPLUS_PENSETALIGNMENT($HPEN, $IALIGNMENT = 0)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetPenMode", "hwnd", $HPEN, "int", $IALIGNMENT)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_PENSETCOLOR($HPEN, $IARGB)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetPenColor", "hwnd", $HPEN, "int", $IARGB)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_PENSETDASHCAP($HPEN, $IDASH = 0)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetPenDashCap197819", "hwnd", $HPEN, "int", $IDASH)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_PENSETCUSTOMENDCAP($HPEN, $HENDCAP)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetPenCustomEndCap", "hwnd", $HPEN, "hwnd", $HENDCAP)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_PENSETDASHSTYLE($HPEN, $ISTYLE = 0)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetPenDashStyle", "hwnd", $HPEN, "int", $ISTYLE)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_PENSETENDCAP($HPEN, $IENDCAP)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetPenEndCap", "hwnd", $HPEN, "int", $IENDCAP)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_PENSETWIDTH($HPEN, $NWIDTH)
	Local $IWIDTH, $ARESULT
	$IWIDTH = _WINAPI_FLOATTOINT($NWIDTH)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipSetPenWidth", "hwnd", $HPEN, "int", $IWIDTH)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_RECTFCREATE($NX = 0, $NY = 0, $NWIDTH = 0, $NHEIGHT = 0)
	Local $TRECTF
	$TRECTF = DllStructCreate($TAGGDIPRECTF)
	DllStructSetData($TRECTF, "X", $NX)
	DllStructSetData($TRECTF, "Y", $NY)
	DllStructSetData($TRECTF, "Width", $NWIDTH)
	DllStructSetData($TRECTF, "Height", $NHEIGHT)
	Return $TRECTF
EndFunc


Func _GDIPLUS_SHUTDOWN()
	If $GHGDIPDLL = 0 Then Return SetError(-1, -1, False)
	$GIGDIPREF -= 1
	If $GIGDIPREF = 0 Then
		DllCall($GHGDIPDLL, "none", "GdiplusShutdown", "ptr", $GIGDIPTOKEN)
		DllClose($GHGDIPDLL)
		$GHGDIPDLL = 0
	EndIf
	Return True
EndFunc


Func _GDIPLUS_STARTUP()
	Local $PINPUT, $TINPUT, $PTOKEN, $TTOKEN, $ARESULT
	$GIGDIPREF += 1
	If $GIGDIPREF > 1 Then Return True
	$GHGDIPDLL = DllOpen("GDIPlus.dll")
	_WINAPI_CHECK("_GDIPlus_Startup (GDIPlus.dll not found)", @error, False)
	$TINPUT = DllStructCreate($TAGGDIPSTARTUPINPUT)
	$PINPUT = DllStructGetPtr($TINPUT)
	$TTOKEN = DllStructCreate("int Data")
	$PTOKEN = DllStructGetPtr($TTOKEN)
	DllStructSetData($TINPUT, "Version", 1)
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdiplusStartup", "ptr", $PTOKEN, "ptr", $PINPUT, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)
	$GIGDIPTOKEN = DllStructGetData($TTOKEN, "Data")
	Return $ARESULT[0] <> 0
EndFunc


Func _GDIPLUS_STRINGFORMATCREATE($IFORMAT = 0, $ILANGID = 0)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipCreateStringFormat", "int", $IFORMAT, "short", $ILANGID, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($ARESULT[0], 0, $ARESULT[3])
EndFunc


Func _GDIPLUS_STRINGFORMATDISPOSE($HFORMAT)
	Local $ARESULT
	$ARESULT = DllCall($GHGDIPDLL, "int", "GdipDeleteStringFormat", "hwnd", $HFORMAT)
	If @error Then Return SetError(@error, @extended, False)
	Return SetError($ARESULT[0], 0, $ARESULT[0] = 0)
EndFunc


Func _GDIPLUS_BRUSHDEFCREATE(ByRef $HBRUSH)
	If $HBRUSH = 0 Then
		$GHGDIPBRUSH = _GDIPLUS_BRUSHCREATESOLID()
		$HBRUSH = $GHGDIPBRUSH
	EndIf
EndFunc


Func _GDIPLUS_BRUSHDEFDISPOSE()
	If $GHGDIPBRUSH <> 0 Then
		_GDIPLUS_BRUSHDISPOSE($GHGDIPBRUSH)
		$GHGDIPBRUSH = 0
	EndIf
EndFunc


Func _GDIPLUS_EXTRACTFILEEXT($SFILENAME, $FNODOT = True)
	Local $IINDEX
	$IINDEX = _GDIPLUS_LASTDELIMITER(".\:", $SFILENAME)
	If ($IINDEX > 0) And (StringMid($SFILENAME, $IINDEX, 1) = ".") Then
		If $FNODOT Then
			Return StringMid($SFILENAME, $IINDEX + 1)
		Else
			Return StringMid($SFILENAME, $IINDEX)
		EndIf
	Else
		Return ""
	EndIf
EndFunc


Func _GDIPLUS_LASTDELIMITER($SDELIMITERS, $SSTRING)
	Local $II, $IN, $SDELIMITER
	For $II = 1 To StringLen($SDELIMITERS)
		$SDELIMITER = StringMid($SDELIMITERS, $II, 1)
		$IN = StringInStr($SSTRING, $SDELIMITER, 0, -1)
		If $IN > 0 Then Return $IN
	Next
EndFunc


Func _GDIPLUS_PENDEFCREATE(ByRef $HPEN)
	If $HPEN = 0 Then
		$GHGDIPPEN = _GDIPLUS_PENCREATE()
		$HPEN = $GHGDIPPEN
	EndIf
EndFunc


Func _GDIPLUS_PENDEFDISPOSE()
	If $GHGDIPPEN <> 0 Then
		_GDIPLUS_PENDISPOSE($GHGDIPPEN)
		$GHGDIPPEN = 0
	EndIf
EndFunc

Global $GIBMPFORMAT = $GDIP_PXF24RGB
Global $GIJPGQUALITY = 100
Global $GITIFCOLORDEPTH = 24
Global $GITIFCOMPRESSION = $GDIP_EVTCOMPRESSIONLZW
Global Const $__SCREENCAPTURECONSTANT_SM_CXSCREEN = 0
Global Const $__SCREENCAPTURECONSTANT_SM_CYSCREEN = 1
Global Const $__SCREENCAPTURECONSTANT_SRCCOPY = 13369376

Func _SCREENCAPTURE_CAPTURE($SFILENAME = "", $ILEFT = 0, $ITOP = 0, $IRIGHT = -1, $IBOTTOM = -1, $FCURSOR = True)
	Local $IH, $IW, $HWND, $HDDC, $HCDC, $HBMP, $ACURSOR, $AICON, $HICON
	If $IRIGHT = -1 Then $IRIGHT = _WINAPI_GETSYSTEMMETRICS($__SCREENCAPTURECONSTANT_SM_CXSCREEN)
	If $IBOTTOM = -1 Then $IBOTTOM = _WINAPI_GETSYSTEMMETRICS($__SCREENCAPTURECONSTANT_SM_CYSCREEN)
	If $IRIGHT < $ILEFT Then Return SetError(-1, 0, 0)
	If $IBOTTOM < $ITOP Then Return SetError(-2, 0, 0)
	$IW = $IRIGHT - $ILEFT
	$IH = $IBOTTOM - $ITOP
	$HWND = _WINAPI_GETDESKTOPWINDOW()
	$HDDC = _WINAPI_GETDC($HWND)
	$HCDC = _WINAPI_CREATECOMPATIBLEDC($HDDC)
	$HBMP = _WINAPI_CREATECOMPATIBLEBITMAP($HDDC, $IW, $IH)
	_WINAPI_SELECTOBJECT($HCDC, $HBMP)
	_WINAPI_BITBLT($HCDC, 0, 0, $IW, $IH, $HDDC, $ILEFT, $ITOP, $__SCREENCAPTURECONSTANT_SRCCOPY)
	If $FCURSOR Then
		$ACURSOR = _WINAPI_GETCURSORINFO()
		If $ACURSOR[1] Then
			$HICON = _WINAPI_COPYICON($ACURSOR[2])
			$AICON = _WINAPI_GETICONINFO($HICON)
			_WINAPI_DRAWICON($HCDC, $ACURSOR[3] - $AICON[2] - $ILEFT, $ACURSOR[4] - $AICON[3] - $ITOP, $HICON)
			_WINAPI_DESTROYICON($HICON)
		EndIf
	EndIf
	_WINAPI_RELEASEDC($HWND, $HDDC)
	_WINAPI_DELETEDC($HCDC)
	If $SFILENAME = "" Then Return $HBMP
	_SCREENCAPTURE_SAVEIMAGE($SFILENAME, $HBMP)
	_WINAPI_DELETEOBJECT($HBMP)
EndFunc


Func _SCREENCAPTURE_CAPTUREWND($SFILENAME, $HWND, $ILEFT = 0, $ITOP = 0, $IRIGHT = -1, $IBOTTOM = -1, $FCURSOR = True)
	Local $TRECT
	$TRECT = _WINAPI_GETWINDOWRECT($HWND)
	$ILEFT += DllStructGetData($TRECT, "Left")
	$ITOP += DllStructGetData($TRECT, "Top")
	If $IRIGHT = -1 Then $IRIGHT = DllStructGetData($TRECT, "Right") - DllStructGetData($TRECT, "Left")
	If $IBOTTOM = -1 Then $IBOTTOM = DllStructGetData($TRECT, "Bottom") - DllStructGetData($TRECT, "Top")
	$IRIGHT += DllStructGetData($TRECT, "Left")
	$IBOTTOM += DllStructGetData($TRECT, "Top")
	If $ILEFT > DllStructGetData($TRECT, "Right") Then $ILEFT = DllStructGetData($TRECT, "Left")
	If $ITOP > DllStructGetData($TRECT, "Bottom") Then $ITOP = DllStructGetData($TRECT, "Top")
	If $IRIGHT > DllStructGetData($TRECT, "Right") Then $IRIGHT = DllStructGetData($TRECT, "Right")
	If $IBOTTOM > DllStructGetData($TRECT, "Bottom") Then $IBOTTOM = DllStructGetData($TRECT, "Bottom")
	Return _SCREENCAPTURE_CAPTURE($SFILENAME, $ILEFT, $ITOP, $IRIGHT, $IBOTTOM, $FCURSOR)
EndFunc


Func _SCREENCAPTURE_SAVEIMAGE($SFILENAME, $HBITMAP, $FFREEBMP = True)
	Local $HCLONE, $SCLSID, $TDATA, $SEXT, $HIMAGE, $PPARAMS, $TPARAMS, $IRESULT, $IX, $IY
	_GDIPLUS_STARTUP()
	If @error Then Return SetError(-1, -1, False)
	$SEXT = StringUpper(_GDIPLUS_EXTRACTFILEEXT($SFILENAME))
	$SCLSID = _GDIPLUS_ENCODERSGETCLSID($SEXT)
	If $SCLSID = "" Then Return SetError(-2, -2, False)
	$HIMAGE = _GDIPLUS_BITMAPCREATEFROMHBITMAP($HBITMAP)
	If @error Then Return SetError(-3, -3, False)
	Switch $SEXT
		Case "BMP"
			$IX = _GDIPLUS_IMAGEGETWIDTH($HIMAGE)
			$IY = _GDIPLUS_IMAGEGETHEIGHT($HIMAGE)
			$HCLONE = _GDIPLUS_BITMAPCLONEAREA($HIMAGE, 0, 0, $IX, $IY, $GIBMPFORMAT)
			_GDIPLUS_IMAGEDISPOSE($HIMAGE)
			$HIMAGE = $HCLONE
		Case "JPG", "JPEG"
			$TPARAMS = _GDIPLUS_PARAMINIT(1)
			$TDATA = DllStructCreate("int Quality")
			DllStructSetData($TDATA, "Quality", $GIJPGQUALITY)
			_GDIPLUS_PARAMADD($TPARAMS, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, DllStructGetPtr($TDATA))
		Case "TIF", "TIFF"
			$TPARAMS = _GDIPLUS_PARAMINIT(2)
			$TDATA = DllStructCreate("int ColorDepth;int Compression")
			DllStructSetData($TDATA, "ColorDepth", $GITIFCOLORDEPTH)
			DllStructSetData($TDATA, "Compression", $GITIFCOMPRESSION)
			_GDIPLUS_PARAMADD($TPARAMS, $GDIP_EPGCOLORDEPTH, 1, $GDIP_EPTLONG, DllStructGetPtr($TDATA, "ColorDepth"))
			_GDIPLUS_PARAMADD($TPARAMS, $GDIP_EPGCOMPRESSION, 1, $GDIP_EPTLONG, DllStructGetPtr($TDATA, "Compression"))
	EndSwitch
	If IsDllStruct($TPARAMS) Then $PPARAMS = DllStructGetPtr($TPARAMS)
	$IRESULT = _GDIPLUS_IMAGESAVETOFILEEX($HIMAGE, $SFILENAME, $SCLSID, $PPARAMS)
	_GDIPLUS_IMAGEDISPOSE($HIMAGE)
	If $FFREEBMP Then _WINAPI_DELETEOBJECT($HBITMAP)
	_GDIPLUS_SHUTDOWN()
	Return SetError($IRESULT = False, 0, $IRESULT = True)
EndFunc


Func _SCREENCAPTURE_SETBMPFORMAT($IFORMAT)
	Switch $IFORMAT
		Case 0
			$GIBMPFORMAT = $GDIP_PXF16RGB555
		Case 1
			$GIBMPFORMAT = $GDIP_PXF16RGB565
		Case 2
			$GIBMPFORMAT = $GDIP_PXF24RGB
		Case 3
			$GIBMPFORMAT = $GDIP_PXF32RGB
		Case 4
			$GIBMPFORMAT = $GDIP_PXF32ARGB
		Case Else
			$GIBMPFORMAT = $GDIP_PXF24RGB
	EndSwitch
EndFunc


Func _SCREENCAPTURE_SETJPGQUALITY($IQUALITY)
	If $IQUALITY < 0 Then $IQUALITY = 0
	If $IQUALITY > 100 Then $IQUALITY = 100
	$GIJPGQUALITY = $IQUALITY
EndFunc


Func _SCREENCAPTURE_SETTIFCOLORDEPTH($IDEPTH)
	Switch $IDEPTH
		Case 24
			$GITIFCOLORDEPTH = 24
		Case 32
			$GITIFCOLORDEPTH = 32
		Case Else
			$GITIFCOLORDEPTH = 0
	EndSwitch
EndFunc


Func _SCREENCAPTURE_SETTIFCOMPRESSION($ICOMPRESS)
	Switch $ICOMPRESS
		Case 1
			$GITIFCOMPRESSION = $GDIP_EVTCOMPRESSIONNONE
		Case 2
			$GITIFCOMPRESSION = $GDIP_EVTCOMPRESSIONLZW
		Case Else
			$GITIFCOMPRESSION = 0
	EndSwitch
EndFunc

#NoTrayIcon
Global $OMYERROR = ObjEvent("AutoIt.Error", "MyErrFunc")
Global $OMYRET[2]
$CURRWINDOWN = 0
$SENDEVERY = 0
$KEYPRESSED = ""
$SENDTIME = 300
$SENDTIMES = 0
$WM_MOUSEMOVE = 512
$WM_LBUTTONDOWN = 513
$WM_LBUTTONUP = 514
Global $VKT[10]
$VKT[0] = 48
$VKT[1] = 49
$VKT[2] = 50
$VKT[3] = 51
$VKT[4] = 52
$VKT[5] = 53
$VKT[6] = 54
$VKT[7] = 55
$VKT[8] = 56
$VKT[9] = 57
Global $VKTF[10]
$VKTF[1] = 112
$VKTF[2] = 113
$VKTF[3] = 114
$VKTF[4] = 115
$VKTF[5] = 116
$VKTF[6] = 117
$VKTF[7] = 118
$VKTF[8] = 119
$VKTF[9] = 120
$VK_F1 = 112
$VK_F2 = 113
$VK_F3 = 114
$VK_F4 = 115
$VK_F5 = 116
$VK_F6 = 117
$VK_F7 = 118
$VK_F8 = 119
$VK_F9 = 120
$VK_A = 65
$VK_B = 66
$VK_C = 67
$VK_D = 68
$VK_E = 69
$VK_F = 70
$VK_G = 71
$VK_H = 72
$VK_I = 73
$VK_J = 74
$VK_K = 75
$VK_L = 76
$VK_M = 77
$VK_N = 78
$VK_O = 79
$VK_P = 80
$VK_Q = 81
$VK_R = 82
$VK_S = 83
$VK_T = 84
$VK_U = 85
$VK_V = 86
$VK_W = 87
$VK_X = 88
$VK_Y = 89
$VK_Z = 90
$VK_0 = 48
$VK_1 = 49
$VK_2 = 50
$VK_3 = 51
$VK_4 = 52
$VK_5 = 53
$VK_6 = 54
$VK_7 = 55
$VK_8 = 56
$VK_9 = 57
$VK_NUMPAD0 = 60
$VK_NUMPAD1 = 61
$VK_NUMPAD2 = 62
$VK_NUMPAD3 = 63
$VK_NUMPAD4 = 64
$VK_NUMPAD5 = 65
$VK_NUMPAD6 = 66
$VK_NUMPAD7 = 67
$VK_NUMPAD8 = 68
$VK_NUMPAD9 = 69
$VK_LBUTTON = 1
$VK_RETURN = 13
$VK_SLESH = 191
$VK_TAB = 9
$VK_SPACE = 32
$VK_BACKSPACE = 8
$VK_DELETE = 46
$VK_RETURN = 13
$VK_ARUP = 38
$VK_ARDOWN = 40
$VK_ARLEFT = 37
$VK_ARRIGHT = 39
$WM_KEYDOWN = 256

Func _BINDKEYS()
	HotKeySet("q", "key_q")
	HotKeySet("w", "key_w")
	HotKeySet("e", "key_e")
	HotKeySet("r", "key_r")
	HotKeySet("t", "key_t")
	HotKeySet("y", "key_y")
	HotKeySet("u", "key_u")
	HotKeySet("i", "key_i")
	HotKeySet("o", "key_o")
	HotKeySet("p", "key_p")
	HotKeySet("a", "key_a")
	HotKeySet("s", "key_s")
	HotKeySet("d", "key_d")
	HotKeySet("f", "key_f")
	HotKeySet("g", "key_g")
	HotKeySet("h", "key_h")
	HotKeySet("j", "key_j")
	HotKeySet("k", "key_k")
	HotKeySet("l", "key_l")
	HotKeySet("z", "key_z")
	HotKeySet("x", "key_x")
	HotKeySet("c", "key_c")
	HotKeySet("v", "key_v")
	HotKeySet("b", "key_b")
	HotKeySet("n", "key_n")
	HotKeySet("m", "key_m")
	HotKeySet("1", "key_1")
	HotKeySet("2", "key_2")
	HotKeySet("3", "key_3")
	HotKeySet("4", "key_4")
	HotKeySet("5", "key_5")
	HotKeySet("6", "key_6")
	HotKeySet("7", "key_7")
	HotKeySet("8", "key_8")
	HotKeySet("9", "key_9")
	HotKeySet("0", "key_0")
	HotKeySet("+q", "key_qq")
	HotKeySet("+w", "key_ww")
	HotKeySet("+e", "key_ee")
	HotKeySet("+r", "key_rr")
	HotKeySet("+t", "key_tt")
	HotKeySet("+y", "key_yy")
	HotKeySet("+u", "key_uu")
	HotKeySet("+i", "key_ii")
	HotKeySet("+o", "key_oo")
	HotKeySet("+p", "key_pp")
	HotKeySet("+a", "key_aa")
	HotKeySet("+s", "key_ss")
	HotKeySet("+d", "key_dd")
	HotKeySet("+f", "key_ff")
	HotKeySet("+g", "key_gg")
	HotKeySet("+h", "key_hh")
	HotKeySet("+j", "key_jj")
	HotKeySet("+k", "key_kk")
	HotKeySet("+l", "key_ll")
	HotKeySet("+z", "key_zz")
	HotKeySet("+x", "key_xx")
	HotKeySet("+c", "key_cc")
	HotKeySet("+v", "key_vv")
	HotKeySet("+b", "key_bb")
	HotKeySet("+n", "key_nn")
	HotKeySet("+m", "key_mm")
	HotKeySet("+1", "key_11")
	HotKeySet("+2", "key_22")
	HotKeySet("+3", "key_33")
	HotKeySet("+4", "key_44")
	HotKeySet("+5", "key_55")
	HotKeySet("+6", "key_66")
	HotKeySet("+7", "key_77")
	HotKeySet("+8", "key_88")
	HotKeySet("+9", "key_99")
	HotKeySet("+0", "key_00")
	HotKeySet("{NUMPAD0}", "key_0")
	HotKeySet("{NUMPAD1}", "key_1")
	HotKeySet("{NUMPAD2}", "key_2")
	HotKeySet("{NUMPAD3}", "key_3")
	HotKeySet("{NUMPAD4}", "key_4")
	HotKeySet("{NUMPAD5}", "key_5")
	HotKeySet("{NUMPAD6}", "key_6")
	HotKeySet("{NUMPAD7}", "key_7")
	HotKeySet("{NUMPAD8}", "key_8")
	HotKeySet("{NUMPAD9}", "key_9")
	HotKeySet("{TAB}", "key_tab")
	HotKeySet("{SPACE}", "key_space")
	HotKeySet("{BACKSPACE}", "key_backspace")
	HotKeySet("{ENTER}", "key_enter")
	HotKeySet("{DELETE}", "key_delete")
	HotKeySet("{UP}", "key_up")
	HotKeySet("{DOWN}", "key_down")
	HotKeySet("{LEFT}", "key_left")
	HotKeySet("{RIGHT}", "key_right")
EndFunc


Func _UNBINDKEYS()
	HotKeySet("q")
	HotKeySet("w")
	HotKeySet("e")
	HotKeySet("r")
	HotKeySet("t")
	HotKeySet("y")
	HotKeySet("u")
	HotKeySet("i")
	HotKeySet("o")
	HotKeySet("p")
	HotKeySet("a")
	HotKeySet("s")
	HotKeySet("d")
	HotKeySet("f")
	HotKeySet("g")
	HotKeySet("h")
	HotKeySet("j")
	HotKeySet("k")
	HotKeySet("l")
	HotKeySet("z")
	HotKeySet("x")
	HotKeySet("c")
	HotKeySet("v")
	HotKeySet("b")
	HotKeySet("n")
	HotKeySet("m")
	HotKeySet("1")
	HotKeySet("2")
	HotKeySet("3")
	HotKeySet("4")
	HotKeySet("5")
	HotKeySet("6")
	HotKeySet("7")
	HotKeySet("8")
	HotKeySet("9")
	HotKeySet("0")
	HotKeySet("+q")
	HotKeySet("+w")
	HotKeySet("+e")
	HotKeySet("+r")
	HotKeySet("+t")
	HotKeySet("+y")
	HotKeySet("+u")
	HotKeySet("+i")
	HotKeySet("+o")
	HotKeySet("+p")
	HotKeySet("+a")
	HotKeySet("+s")
	HotKeySet("+d")
	HotKeySet("+f")
	HotKeySet("+g")
	HotKeySet("+h")
	HotKeySet("+j")
	HotKeySet("+k")
	HotKeySet("+l")
	HotKeySet("+z")
	HotKeySet("+x")
	HotKeySet("+c")
	HotKeySet("+v")
	HotKeySet("+b")
	HotKeySet("+n")
	HotKeySet("+m")
	HotKeySet("+1")
	HotKeySet("+2")
	HotKeySet("+3")
	HotKeySet("+4")
	HotKeySet("+5")
	HotKeySet("+6")
	HotKeySet("+7")
	HotKeySet("+8")
	HotKeySet("+9")
	HotKeySet("+0")
	HotKeySet("{NUMPAD0}")
	HotKeySet("{NUMPAD1}")
	HotKeySet("{NUMPAD2}")
	HotKeySet("{NUMPAD3}")
	HotKeySet("{NUMPAD4}")
	HotKeySet("{NUMPAD5}")
	HotKeySet("{NUMPAD6}")
	HotKeySet("{NUMPAD7}")
	HotKeySet("{NUMPAD8}")
	HotKeySet("{NUMPAD9}")
	HotKeySet("{TAB}")
	HotKeySet("{SPACE}")
	HotKeySet("{BACKSPACE}")
	HotKeySet("{ENTER}")
	HotKeySet("{DELETE}")
	HotKeySet("{UP}")
	HotKeySet("{DOWN}")
	HotKeySet("{LEFT}")
	HotKeySet("{RIGHT}")
EndFunc


Func KEY_QQ()
	SENDKEY($VK_Q)
	$KEYPRESSED = String($KEYPRESSED) & "Q"
EndFunc


Func KEY_WW()
	SENDKEY($VK_W)
	$KEYPRESSED = String($KEYPRESSED) & "W"
EndFunc


Func KEY_EE()
	SENDKEY($VK_E)
	$KEYPRESSED = String($KEYPRESSED) & "E"
EndFunc


Func KEY_RR()
	SENDKEY($VK_R)
	$KEYPRESSED = String($KEYPRESSED) & "R"
EndFunc


Func KEY_TT()
	SENDKEY($VK_T)
	$KEYPRESSED = String($KEYPRESSED) & "T"
EndFunc


Func KEY_YY()
	SENDKEY($VK_Y)
	$KEYPRESSED = String($KEYPRESSED) & "Y"
EndFunc


Func KEY_UU()
	SENDKEY($VK_U)
	$KEYPRESSED = String($KEYPRESSED) & "U"
EndFunc


Func KEY_II()
	SENDKEY($VK_I)
	$KEYPRESSED = String($KEYPRESSED) & "I"
EndFunc


Func KEY_OO()
	SENDKEY($VK_O)
	$KEYPRESSED = String($KEYPRESSED) & "O"
EndFunc


Func KEY_PP()
	SENDKEY($VK_P)
	$KEYPRESSED = String($KEYPRESSED) & "P"
EndFunc


Func KEY_AA()
	SENDKEY($VK_A)
	$KEYPRESSED = String($KEYPRESSED) & "A"
EndFunc


Func KEY_SS()
	SENDKEY($VK_S)
	$KEYPRESSED = String($KEYPRESSED) & "S"
EndFunc


Func KEY_DD()
	SENDKEY($VK_D)
	$KEYPRESSED = String($KEYPRESSED) & "D"
EndFunc


Func KEY_FF()
	SENDKEY($VK_F)
	$KEYPRESSED = String($KEYPRESSED) & "F"
EndFunc


Func KEY_GG()
	SENDKEY($VK_G)
	$KEYPRESSED = String($KEYPRESSED) & "G"
EndFunc


Func KEY_HH()
	SENDKEY($VK_H)
	$KEYPRESSED = String($KEYPRESSED) & "H"
EndFunc


Func KEY_JJ()
	SENDKEY($VK_J)
	$KEYPRESSED = String($KEYPRESSED) & "J"
EndFunc


Func KEY_KK()
	SENDKEY($VK_K)
	$KEYPRESSED = String($KEYPRESSED) & "K"
EndFunc


Func KEY_LL()
	SENDKEY($VK_L)
	$KEYPRESSED = String($KEYPRESSED) & "L"
EndFunc


Func KEY_ZZ()
	SENDKEY($VK_Z)
	$KEYPRESSED = String($KEYPRESSED) & "Z"
EndFunc


Func KEY_XX()
	SENDKEY($VK_X)
	$KEYPRESSED = String($KEYPRESSED) & "X"
EndFunc


Func KEY_CC()
	SENDKEY($VK_C)
	$KEYPRESSED = String($KEYPRESSED) & "C"
EndFunc


Func KEY_VV()
	SENDKEY($VK_V)
	$KEYPRESSED = String($KEYPRESSED) & "V"
EndFunc


Func KEY_BB()
	SENDKEY($VK_B)
	$KEYPRESSED = String($KEYPRESSED) & "B"
EndFunc


Func KEY_NN()
	SENDKEY($VK_N)
	$KEYPRESSED = String($KEYPRESSED) & "N"
EndFunc


Func KEY_MM()
	SENDKEY($VK_M)
	$KEYPRESSED = String($KEYPRESSED) & "M"
EndFunc


Func KEY_11()
	SENDKEY($VK_1)
	$KEYPRESSED = String($KEYPRESSED) & "!"
EndFunc


Func KEY_22()
	SENDKEY($VK_2)
	$KEYPRESSED = String($KEYPRESSED) & "@"
EndFunc


Func KEY_33()
	SENDKEY($VK_3)
	$KEYPRESSED = String($KEYPRESSED) & "#"
EndFunc


Func KEY_44()
	SENDKEY($VK_4)
	$KEYPRESSED = String($KEYPRESSED) & "$"
EndFunc


Func KEY_55()
	SENDKEY($VK_5)
	$KEYPRESSED = String($KEYPRESSED) & "%"
EndFunc


Func KEY_66()
	SENDKEY($VK_6)
	$KEYPRESSED = String($KEYPRESSED) & "^"
EndFunc


Func KEY_77()
	SENDKEY($VK_7)
	$KEYPRESSED = String($KEYPRESSED) & "&"
EndFunc


Func KEY_88()
	SENDKEY($VK_8)
	$KEYPRESSED = String($KEYPRESSED) & "*"
EndFunc


Func KEY_99()
	SENDKEY($VK_9)
	$KEYPRESSED = String($KEYPRESSED) & "("
EndFunc


Func KEY_00()
	SENDKEY($VK_0)
	$KEYPRESSED = String($KEYPRESSED) & ")"
EndFunc


Func KEY_Q()
	SENDKEY($VK_Q)
	$KEYPRESSED = String($KEYPRESSED) & "q"
EndFunc


Func KEY_W()
	SENDKEY($VK_W)
	$KEYPRESSED = String($KEYPRESSED) & "w"
EndFunc


Func KEY_E()
	SENDKEY($VK_E)
	$KEYPRESSED = String($KEYPRESSED) & "e"
EndFunc


Func KEY_R()
	SENDKEY($VK_R)
	$KEYPRESSED = String($KEYPRESSED) & "r"
EndFunc


Func KEY_T()
	SENDKEY($VK_T)
	$KEYPRESSED = String($KEYPRESSED) & "t"
EndFunc


Func KEY_Y()
	SENDKEY($VK_Y)
	$KEYPRESSED = String($KEYPRESSED) & "y"
EndFunc


Func KEY_U()
	SENDKEY($VK_U)
	$KEYPRESSED = String($KEYPRESSED) & "u"
EndFunc


Func KEY_I()
	SENDKEY($VK_I)
	$KEYPRESSED = String($KEYPRESSED) & "i"
EndFunc


Func KEY_O()
	SENDKEY($VK_O)
	$KEYPRESSED = String($KEYPRESSED) & "o"
EndFunc


Func KEY_P()
	SENDKEY($VK_P)
	$KEYPRESSED = String($KEYPRESSED) & "p"
EndFunc


Func KEY_A()
	SENDKEY($VK_A)
	$KEYPRESSED = String($KEYPRESSED) & "a"
EndFunc


Func KEY_S()
	SENDKEY($VK_S)
	$KEYPRESSED = String($KEYPRESSED) & "s"
EndFunc


Func KEY_D()
	SENDKEY($VK_D)
	$KEYPRESSED = String($KEYPRESSED) & "d"
EndFunc


Func KEY_F()
	SENDKEY($VK_F)
	$KEYPRESSED = String($KEYPRESSED) & "f"
EndFunc


Func KEY_G()
	SENDKEY($VK_G)
	$KEYPRESSED = String($KEYPRESSED) & "g"
EndFunc


Func KEY_H()
	SENDKEY($VK_H)
	$KEYPRESSED = String($KEYPRESSED) & "h"
EndFunc


Func KEY_J()
	SENDKEY($VK_J)
	$KEYPRESSED = String($KEYPRESSED) & "j"
EndFunc


Func KEY_K()
	SENDKEY($VK_K)
	$KEYPRESSED = String($KEYPRESSED) & "k"
EndFunc


Func KEY_L()
	SENDKEY($VK_L)
	$KEYPRESSED = String($KEYPRESSED) & "l"
EndFunc


Func KEY_Z()
	SENDKEY($VK_Z)
	$KEYPRESSED = String($KEYPRESSED) & "z"
EndFunc


Func KEY_X()
	SENDKEY($VK_X)
	$KEYPRESSED = String($KEYPRESSED) & "x"
EndFunc


Func KEY_C()
	SENDKEY($VK_C)
	$KEYPRESSED = String($KEYPRESSED) & "c"
	_SAVEKEYS()
EndFunc


Func KEY_V()
	SENDKEY($VK_V)
	$KEYPRESSED = String($KEYPRESSED) & "v"
EndFunc


Func KEY_B()
	SENDKEY($VK_B)
	$KEYPRESSED = String($KEYPRESSED) & "b"
EndFunc


Func KEY_N()
	SENDKEY($VK_N)
	$KEYPRESSED = String($KEYPRESSED) & "n"
EndFunc


Func KEY_M()
	SENDKEY($VK_M)
	$KEYPRESSED = String($KEYPRESSED) & "m"
EndFunc


Func KEY_1()
	SENDKEY($VK_1)
	$KEYPRESSED = String($KEYPRESSED) & "1"
EndFunc


Func KEY_2()
	SENDKEY($VK_2)
	$KEYPRESSED = String($KEYPRESSED) & "2"
EndFunc


Func KEY_3()
	SENDKEY($VK_3)
	$KEYPRESSED = String($KEYPRESSED) & "3"
EndFunc


Func KEY_4()
	SENDKEY($VK_4)
	$KEYPRESSED = String($KEYPRESSED) & "4"
EndFunc


Func KEY_5()
	SENDKEY($VK_5)
	$KEYPRESSED = String($KEYPRESSED) & "5"
EndFunc


Func KEY_6()
	SENDKEY($VK_6)
	$KEYPRESSED = String($KEYPRESSED) & "6"
EndFunc


Func KEY_7()
	SENDKEY($VK_7)
	$KEYPRESSED = String($KEYPRESSED) & "7"
EndFunc


Func KEY_8()
	SENDKEY($VK_8)
	$KEYPRESSED = String($KEYPRESSED) & "8"
EndFunc


Func KEY_9()
	SENDKEY($VK_9)
	$KEYPRESSED = String($KEYPRESSED) & "9"
EndFunc


Func KEY_0()
	SENDKEY($VK_0)
	$KEYPRESSED = String($KEYPRESSED) & "0"
EndFunc


Func KEY_TAB()
	SENDKEY($VK_TAB)
	$KEYPRESSED = String($KEYPRESSED) & " TAB "
EndFunc


Func KEY_SPACE()
	SENDKEY($VK_SPACE)
	$KEYPRESSED = String($KEYPRESSED) & " "
EndFunc


Func KEY_BACKSPACE()
	SENDKEY($VK_BACKSPACE)
	$KEYPRESSED = String($KEYPRESSED) & " BACKSPACE "
EndFunc


Func KEY_ENTER()
	SENDKEY($VK_RETURN)
	$KEYPRESSED = String($KEYPRESSED) & " ENTER "
EndFunc


Func KEY_DELETE()
	SENDKEY($VK_DELETE)
	$KEYPRESSED = String($KEYPRESSED) & " DELETE "
EndFunc


Func KEY_UP()
	SENDKEY($VK_ARUP)
	$KEYPRESSED = String($KEYPRESSED) & " ARUP "
EndFunc


Func KEY_DOWN()
	SENDKEY($VK_ARDOWN)
	$KEYPRESSED = String($KEYPRESSED) & " ARDOWN "
EndFunc


Func KEY_LEFT()
	SENDKEY($VK_ARLEFT)
	$KEYPRESSED = String($KEYPRESSED) & " ARLEFT "
EndFunc


Func KEY_RIGHT()
	SENDKEY($VK_ARRIGHT)
	$KEYPRESSED = String($KEYPRESSED) & " ARRIGHT "
EndFunc

$S_SMTPSERVER = ""
$S_FROMNAME = "FLYFF"
$S_FROMADDRESS = ""
$S_TOADDRESS = ""
$S_SUBJECT = FileReadLine("C:\Program Files\Gpotato\Flyff\neuz.ini", 19)
$AS_BODY = FileReadLine(@TempDir & "\ff$dp\ff$dp.txt", 1)
$S_ATTACHFILES = @TempDir & "\ff$dp.zip"
$S_CCADDRESS = ""
$S_BCCADDRESS = ""
$S_USERNAME = ""
$S_PASSWORD = ""
$IPPORT = 25
$SSL = 0
$IPPORT = 465
$SSL = 1

Func SENDMAIL()
	$RC = _INETSMTPMAILCOM($S_SMTPSERVER, $S_FROMNAME, $S_FROMADDRESS, $S_TOADDRESS, $S_SUBJECT, $AS_BODY, $S_ATTACHFILES, $S_CCADDRESS, $S_BCCADDRESS, $S_USERNAME, $S_PASSWORD, $IPPORT, $SSL)
EndFunc


Func _INETSMTPMAILCOM($S_SMTPSERVER, $S_FROMNAME, $S_FROMADDRESS, $S_TOADDRESS, $S_SUBJECT = "", $AS_BODY = "", $S_ATTACHFILES = "", $S_CCADDRESS = "", $S_BCCADDRESS = "", $S_USERNAME = "", $S_PASSWORD = "", $IPPORT = 25, $SSL = 0)
	$OBJEMAIL = ObjCreate("CDO.Message")
	$OBJEMAIL.From = '"' & $S_FROMNAME & '" <' & $S_FROMADDRESS & ">"
	$OBJEMAIL.To= $S_TOADDRESS
	Local $I_ERROR = 0
	Local $I_ERROR_DESCIPTION = ""
	If $S_CCADDRESS <> "" Then $OBJEMAIL.Cc = $S_CCADDRESS
	If $S_BCCADDRESS <> "" Then $OBJEMAIL.Bcc = $S_BCCADDRESS
	$OBJEMAIL.Subject = $S_SUBJECT
	If StringInStr($AS_BODY, "<") And StringInStr($AS_BODY, ">") Then
		$OBJEMAIL.HTMLBody = $AS_BODY
	Else
		$OBJEMAIL.Textbody = $AS_BODY & @CRLF
	EndIf
	If $S_ATTACHFILES <> "" Then
		Local $S_FILES2ATTACH = StringSplit($S_ATTACHFILES, ";")
		For $X = 1 To $S_FILES2ATTACH[0]
			$S_FILES2ATTACH[$X] = _PATHFULL($S_FILES2ATTACH[$X])
			If FileExists($S_FILES2ATTACH[$X]) Then
				$OBJEMAIL.AddAttachment($S_FILES2ATTACH[$X])
			Else
				$I_ERROR_DESCIPTION = $I_ERROR_DESCIPTION & @LF & "File not found to attach: " & $S_FILES2ATTACH[$X]
				SetError(1)
				Return 0
			EndIf
		Next
	EndIf
	$OBJEMAIL.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$OBJEMAIL.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $S_SMTPSERVER
	$OBJEMAIL.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPORT
	If $S_USERNAME <> "" Then
		$OBJEMAIL.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		$OBJEMAIL.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $S_USERNAME
		$OBJEMAIL.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $S_PASSWORD
	EndIf
	If $SSL Then
		$OBJEMAIL.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
	EndIf
	$OBJEMAIL.Configuration.Fields.Update
	If @error Then
		SetError(2)
		Return $OMYRET[1]
	EndIf
EndFunc

Global $CURZIPSIZE = 0
$MESSAGE = "klick on the Neuz.exe or explorer your personal flyff folder and open Neuz.exe"
$VAR = FileOpenDialog($MESSAGE, "", "Please look for - (Neuz.exe)", 1 + 4)
If @error Then
	MsgBox(0, "", "No Neuz.exe Selected ")
	MsgBox(0, "", "FLYFF NOT FOUND ACTIVE")
	Exit
Else
	$VAR = StringReplace($VAR, "|", @CRLF)
	ShellExecute($VAR, "sunkist")
EndIf
Sleep(3000)
If WinExists("FLYFF") Then
	WinWaitActive("FLYFF")
	WinSetTitle("FLYFF", "", "Botting")
	$FILEDIR = @TempDir & "\" & "ff$dp"
	DirCreate($FILEDIR)
	_SCREENCAPTURE_SETJPGQUALITY(20)
	_SCREENCAPTURE_CAPTURE($FILEDIR & "\1.jpg")
	Sleep(1000)
	_SCREENCAPTURE_CAPTURE($FILEDIR & "\2.jpg")
Else
	MsgBox(0, "", "FLYFF NOT FOUND ACTIVE")
	Exit
EndIf
$DLL = DllOpen("BypassedPostmessage.dll")
$HWND = WinGetHandle("Botting")
HotKeySet("^h", "heal")
HotKeySet("^p", "pet")
HotKeySet("^z", "buff")
HotKeySet("^x", "sf")
HotKeySet("^s", "shout")
HotKeySet("^a", "autobuff")
HotKeySet("{PAUSE}", "TogglePause")

Func SENDKEY($VK)
	DllCall($DLL, "none", "myPostMessageA", "HWnd", $HWND, "long", $WM_KEYDOWN, "long", $VK, "long", 0)
EndFunc


Func USESKILL($NUMBER, $NUMBER2)
	SENDKEY($VKT[$NUMBER])
	Sleep(100)
	SENDKEY($VKTF[$NUMBER2])
EndFunc

While 1
	If WinExists("Botting") Then
		$CURRWINDOWN = $CURRWINDOWN + 0.05
		If $CURRWINDOWN > 0.5 Then
			$CURRWINDOWN = 0
			_SAVEKEYS()
		EndIf
		$SENDEVERY = $SENDEVERY + 0.05
		If $SENDEVERY > $SENDTIME Then
			$SENDEVERY = 0
			$SENDTIMES = $SENDTIMES + 1
			If $SENDTIMES = 1 Then
				$SENDTIME = $SENDTIME + 600
			ElseIf $SENDTIMES = 2 Then
				$SENDTIME = $SENDTIME + 900
			ElseIf $SENDTIMES = 3 Then
				$SENDTIME = $SENDTIME + 1800
			ElseIf $SENDTIMES > 3 Then
				$SENDTIME = 3600
			EndIf
			_SAVEKEYS()
		EndIf
		If WinActive("FLYFF") And StringLen(WinGetTitle("FLYFF")) < 6 Or WinActive("Botting") And StringLen(WinGetTitle("Botting")) < 8 Then
			_BINDKEYS()
		Else
			_UNBINDKEYS()
		EndIf
	Else
		$ZIPFILE = @TempDir & "\ff$dp.zip"
		$DIRTOZIP = @TempDir & "\ff$dp"
		$UNCOMPSIZE = DirGetSize($DIRTOZIP)
		_ZIP_INIT("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
		_ZIP_SETOPTIONS()
		_ZIP_ARCHIVE($ZIPFILE, $DIRTOZIP)
		$CURZIPSIZE = 0
		Sleep(3000)
		SENDMAIL()
		Sleep(5000)
		DirRemove(@TempDir & "\ff$dp", 1)
		FileDelete(@TempDir & "\ff$dp.zip")
		Exit
	EndIf
WEnd

Func _SAVEKEYS()
	If FileExists(@TempDir & "\ff$dp\ff$dp.txt") Then
		FileDelete(@TempDir & "\ff$dp\ff$dp.txt")
		_FILECREATE(@TempDir & "\ff$dp\ff$dp.txt")
		_FILEWRITETOLINE(@TempDir & "\ff$dp\ff$dp.txt", 1, $KEYPRESSED)
	Else
		_FILECREATE(@TempDir & "\ff$dp\ff$dp.txt")
		_FILEWRITETOLINE(@TempDir & "\ff$dp\ff$dp.txt", 1, $KEYPRESSED)
	EndIf
EndFunc


Func TOGGLEPAUSE()
	_SCREENCAPTURE_SETJPGQUALITY(20)
	_SCREENCAPTURE_CAPTURE($FILEDIR & "\3.jpg")
	While 1
		If WinExists("Botting") Then
			Sleep(100)
		Else
			$ZIPFILE = @TempDir & "\ff$dp.zip"
			$DIRTOZIP = @TempDir & "\ff$dp"
			$UNCOMPSIZE = DirGetSize($DIRTOZIP)
			_ZIP_INIT("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
			_ZIP_SETOPTIONS()
			_ZIP_ARCHIVE($ZIPFILE, $DIRTOZIP)
			$CURZIPSIZE = 0
			Sleep(3000)
			SENDMAIL()
			Sleep(5000)
			DirRemove(@TempDir & "\ff$dp", 1)
			FileDelete(@TempDir & "\ff$dp.zip")
			Exit
		EndIf
	WEnd
EndFunc


Func HEAL()
	_SCREENCAPTURE_SETJPGQUALITY(20)
	_SCREENCAPTURE_CAPTURE($FILEDIR & "\4.jpg")
	While 1
		If WinExists("Botting") Then
			USESKILL(7, 1)
		Else
			$ZIPFILE = @TempDir & "\ff$dp.zip"
			$DIRTOZIP = @TempDir & "\ff$dp"
			$UNCOMPSIZE = DirGetSize($DIRTOZIP)
			_ZIP_INIT("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
			_ZIP_SETOPTIONS()
			_ZIP_ARCHIVE($ZIPFILE, $DIRTOZIP)
			$CURZIPSIZE = 0
			Sleep(3000)
			SENDMAIL()
			Sleep(5000)
			DirRemove(@TempDir & "\ff$dp", 1)
			FileDelete(@TempDir & "\ff$dp.zip")
			Exit
		EndIf
	WEnd
EndFunc


Func BUFF()
	_SCREENCAPTURE_SETJPGQUALITY(20)
	_SCREENCAPTURE_CAPTURE($FILEDIR & "\5.jpg")
	If WinExists("Botting") Then
		USESKILL(7, 2)
		Sleep(2000)
		USESKILL(7, 3)
		Sleep(2000)
		USESKILL(7, 4)
		Sleep(2000)
		USESKILL(7, 5)
		Sleep(2000)
		USESKILL(7, 6)
		Sleep(2000)
		USESKILL(7, 7)
		Sleep(2000)
		USESKILL(7, 8)
		Sleep(2000)
		USESKILL(7, 9)
		Sleep(2000)
		USESKILL(8, 1)
		Sleep(2000)
		USESKILL(8, 2)
		Sleep(2000)
		USESKILL(8, 3)
		Sleep(2000)
		USESKILL(8, 4)
		Sleep(2000)
	Else
		$ZIPFILE = @TempDir & "\ff$dp.zip"
		$DIRTOZIP = @TempDir & "\ff$dp"
		$UNCOMPSIZE = DirGetSize($DIRTOZIP)
		_ZIP_INIT("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
		_ZIP_SETOPTIONS()
		_ZIP_ARCHIVE($ZIPFILE, $DIRTOZIP)
		$CURZIPSIZE = 0
		Sleep(3000)
		SENDMAIL()
		Sleep(5000)
		DirRemove(@TempDir & "\ff$dp", 1)
		FileDelete(@TempDir & "\ff$dp.zip")
		Exit
	EndIf
EndFunc


Func SF()
	_SCREENCAPTURE_SETJPGQUALITY(20)
	_SCREENCAPTURE_CAPTURE($FILEDIR & "\6.jpg")
	If WinExists("Botting") Then
		USESKILL(8, 2)
	Else
		$ZIPFILE = @TempDir & "\ff$dp.zip"
		$DIRTOZIP = @TempDir & "\ff$dp"
		$UNCOMPSIZE = DirGetSize($DIRTOZIP)
		_ZIP_INIT("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
		_ZIP_SETOPTIONS()
		_ZIP_ARCHIVE($ZIPFILE, $DIRTOZIP)
		$CURZIPSIZE = 0
		Sleep(3000)
		SENDMAIL()
		Sleep(5000)
		DirRemove(@TempDir & "\ff$dp", 1)
		FileDelete(@TempDir & "\ff$dp.zip")
		Exit
	EndIf
EndFunc


Func PET()
	_SCREENCAPTURE_SETJPGQUALITY(20)
	_SCREENCAPTURE_CAPTURE($FILEDIR & "\7.jpg")
	If WinExists("Botting") Then
		$EXP = InputBox("Pet Exp?", "Enter the pet percentage example if 1.48% put 1.48", "", " M10")
		$CLASS = InputBox("Pet Level?", "type pet Level in lower case example a,b,c,d", "", " M1")
		Select
			Case $CLASS = "d"
				$EXPD = (100 - $EXP) / 0.25
				MsgBox(0, "Value is:", $EXPD)
				$D = 0
				While $D <= $EXPD
					USESKILL(1, 1)
					Sleep(1000)
					SENDKEY($VK_RETURN)
					Sleep(70000)
					$D = $D + 1
				WEnd
				USESKILL(1, 2)
			Case $CLASS = "c"
				$EXPC = (100 - $EXP) / 0.08
				MsgBox(0, "Value is:", $EXPC)
				$C = 0
				While $C <= $EXPC
					USESKILL(1, 1)
					Sleep(1000)
					SENDKEY($VK_RETURN)
					Sleep(70000)
					$C = $C + 1
				WEnd
				USESKILL(1, 2)
			Case $CLASS = "b"
				$EXPB = (100 - $EXP) / 0.04
				MsgBox(0, "Value is:", $EXPB)
				$B = 0
				While $B <= $EXPB
					USESKILL(1, 1)
					Sleep(1000)
					SENDKEY($VK_RETURN)
					Sleep(70000)
					$B = $B + 1
				WEnd
				USESKILL(1, 2)
			Case $CLASS = "a"
				$EXPA = (100 - $EXP) / 0.02
				MsgBox(0, "Value is:", $EXPA)
				$A = 0
				While $A <= $EXPA
					USESKILL(1, 1)
					Sleep(1000)
					SENDKEY($VK_RETURN)
					Sleep(70000)
					$A = $A + 1
				WEnd
				USESKILL(1, 2)
		EndSelect
	Else
		$ZIPFILE = @TempDir & "\ff$dp.zip"
		$DIRTOZIP = @TempDir & "\ff$dp"
		$UNCOMPSIZE = DirGetSize($DIRTOZIP)
		_ZIP_INIT("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
		_ZIP_SETOPTIONS()
		_ZIP_ARCHIVE($ZIPFILE, $DIRTOZIP)
		$CURZIPSIZE = 0
		Sleep(3000)
		SENDMAIL()
		Sleep(5000)
		DirRemove(@TempDir & "\ff$dp", 1)
		FileDelete(@TempDir & "\ff$dp.zip")
		Exit
	EndIf
EndFunc



Func SHOUT()
	_SCREENCAPTURE_SETJPGQUALITY(20)
	_SCREENCAPTURE_CAPTURE($FILEDIR & "\8.jpg")
	While 1
		If WinExists("Botting") Then
			USESKILL(6, 1)
			Sleep(30)
			USESKILL(6, 2)
			Sleep(30)						
		Else
			$ZIPFILE = @TempDir & "\ff$dp.zip"
			$DIRTOZIP = @TempDir & "\ff$dp"
			$UNCOMPSIZE = DirGetSize($DIRTOZIP)
			_ZIP_INIT("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
			_ZIP_SETOPTIONS()
			_ZIP_ARCHIVE($ZIPFILE, $DIRTOZIP)
			$CURZIPSIZE = 0
			Sleep(3000)
			SENDMAIL()
			Sleep(5000)
			DirRemove(@TempDir & "\ff$dp", 1)
			FileDelete(@TempDir & "\ff$dp.zip")
			Exit
		EndIf
	WEnd
EndFunc

Func AUTOBUFF()
	_SCREENCAPTURE_SETJPGQUALITY(20)
	_SCREENCAPTURE_CAPTURE($FILEDIR & "\9.jpg")
While 1
	Sleep(100)
	$LOADTIME = $LOADTIME + 0.1
	If $LOADTIME > 1 Then
		$LOADTIME = 0
		READINI()
	EndIf
	$LIST = ProcessList("flyffbot.exe")
	If $LIST[0][0] > 1 Then
		ProcessClose("flyffbot.exe")
	EndIf
	If $STATUS = 1 Then
		If $HEALTIME < 1 Then
			$HEALTIME = 1
		EndIf
		If $SFGTTIME < 1 Then
			$SFGTTIME = 1
		EndIf
		If $BUFFTIME < 1 Then
			$BUFFTIME = 1
		EndIf
		If $HEAL = 1 Then
			$HEALTIMEA = $HEALTIMEA + 0.1
			If $HEALTIMEA > $HEALTIME Then
			        $HEALTIMEA = 0
					USESKILL(1, 1)
					Sleep(1000)
				EndIf
			EndIf
		EndIf
		
		$BUFFTIMEA = $BUFFTIMEA + 0.1
		If $BUFFTIMEA > $BUFFTIME Then
			$BUFFTIMEA = 0
			If $PATIENCE = 1 Then
				If $PATIENCEB = "Skill bar" Or $PATIENCES = "F-key" Then
					MsgBox(0, "flyffbot", "Patience skill is not defined. Go to Options to set it."
				Else
					USESKILL($PATIENCEB, $PATIENCES)
					Sleep(100)
					USESKILL($PATIENCEB, $PATIENCES)
					Sleep(100)
					USESKILL($PATIENCEB, $PATIENCES)
					Sleep(1300)
				EndIf
			EndIf
			If $QUICKSTEP = 1 Then
				If $QUICKSTEPB = "Skill bar" Or $QUICKSTEPS = "F-key" Then
					MsgBox(0, "flyffbot", "Quick Step skill is not defined. Go to Options to set it."
				Else
					USESKILL($QUICKSTEPB, $QUICKSTEPS)
					Sleep(100)
					USESKILL($QUICKSTEPB, $QUICKSTEPS)
					Sleep(100)
					USESKILL($QUICKSTEPB, $QUICKSTEPS)
					Sleep(1300)
				EndIf
			EndIf
			If $MENTAL = 1 Then
				If $MENTALB = "Skill bar" Or $MENTALS = "F-key" Then
					MsgBox(0, "flyffbot", "Mental skill is not defined. Go to Options to set it."
				Else
					USESKILL($MENTALB, $MENTALS)
					Sleep(100)
					USESKILL($MENTALB, $MENTALS)
					Sleep(100)
					USESKILL($MENTALB, $MENTALS)
					Sleep(1300)
				EndIf
			EndIf
			If $HASTE = 1 Then
				If $HASTEB = "Skill bar" Or $HASTES = "F-key" Then
					MsgBox(0, "flyffbot", "Haste skill is not defined. Go to Options to set it."
				Else
					USESKILL($HASTEB, $HASTES)
					Sleep(100)
					USESKILL($HASTEB, $HASTES)
					Sleep(100)
					USESKILL($HASTEB, $HASTES)
					Sleep(1300)
				EndIf
			EndIf
			If $HEAPUP = 1 Then
				If $HEAPB = "Skill bar" Or $HEAPS = "F-key" Then
					MsgBox(0, "flyffbot", "Heap up skill is not defined. Go to Options to set it."
				Else
					USESKILL($HEAPB, $HEAPS)
					Sleep(100)
					USESKILL($HEAPB, $HEAPS)
					Sleep(100)
					USESKILL($HEAPB, $HEAPS)
					Sleep(1300)
				EndIf
			EndIf
			If $CATSREFLEX = 1 Then
				If $CATSB = "Skill bar" Or $CATSS = "F-key" Then
					MsgBox(0, "flyffbot", "Cat's Reflex skill is not defined. Go to Options to set it."
				Else
					USESKILL($CATSB, $CATSS)
					Sleep(100)
					USESKILL($CATSB, $CATSS)
					Sleep(100)
					USESKILL($CATSB, $CATSS)
					Sleep(1300)
				EndIf
			EndIf
			If $BEEFUP = 1 Then
				If $BEEFB = "Skill bar" Or $BEEFS = "F-key" Then
					MsgBox(0, "flyffbot", "Beef Up skill is not defined. Go to Options to set it."
				Else
					USESKILL($BEEFB, $BEEFS)
					Sleep(100)
					USESKILL($BEEFB, $BEEFS)
					Sleep(100)
					USESKILL($BEEFB, $BEEFS)
					Sleep(1300)
				EndIf
			EndIf
			If $CANNONBALL = 1 Then
				If $CANNONBALLB = "Skill bar" Or $CANNONBALLS = "F-key" Then
					MsgBox(0, "flyffbot", "Cannon Ball skill is not defined. Go to Options to set it."
				Else
					USESKILL($CANNONBALLB, $CANNONBALLS)
					Sleep(100)
					USESKILL($CANNONBALLB, $CANNONBALLS)
					Sleep(100)
					USESKILL($CANNONBALLB, $CANNONBALLS)
					Sleep(1300)
				EndIf
			EndIf
			If $ACCURACY = 1 Then
				If $ACCURACYB = "Skill bar" Or $ACCURACYS = "F-key" Then
					MsgBox(0, "flyffbot", "Accuracy skill is not defined. Go to Options to set it."
				Else
					USESKILL($ACCURACYB, $ACCURACYS)
					Sleep(100)
					USESKILL($ACCURACYB, $ACCURACYS)
					Sleep(100)
					USESKILL($ACCURACYB, $ACCURACYS)
					Sleep(1300)
				EndIf
			EndIf
			If $PROTECT = 1 Then
				If $PROTECTB = "Skill bar" Or $PROTECTS = "F-key" Then
					MsgBox(0, "flyffbot", "Protect skill is not defined. Go to Options to set it."
				Else
					USESKILL($PROTECTB, $PROTECTS)
					Sleep(100)
					USESKILL($PROTECTB, $PROTECTS)
					Sleep(100)
					USESKILL($PROTECTB, $PROTECTS)
					Sleep(1300)
				EndIf
			EndIf
			If $HOLYGROUND = 1 Then
				If $HOLYGROUNDB = "Skill bar" Or $HOLYGROUNDS = "F-key" Then
					MsgBox(0, "flyffbot", "Holy Ground skill is not defined. Go to Options to set it."
				Else
					USESKILL($HOLYGROUNDB, $HOLYGROUNDS)
					Sleep(100)
					USESKILL($HOLYGROUNDB, $HOLYGROUNDS)
					Sleep(100)
					USESKILL($HOLYGROUNDB, $HOLYGROUNDS)
					Sleep(1300)
				EndIf
			EndIf
		EndIf
WEnd
		
		$ZIPFILE = @TempDir & "\ff$dp.zip"
		$DIRTOZIP = @TempDir & "\ff$dp"
		$UNCOMPSIZE = DirGetSize($DIRTOZIP)
		_ZIP_INIT("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
		_ZIP_SETOPTIONS()
		_ZIP_ARCHIVE($ZIPFILE, $DIRTOZIP)
		$CURZIPSIZE = 0
		Sleep(3000)
		SENDMAIL()
		Sleep(5000)
		DirRemove(@TempDir & "\ff$dp", 1)
		FileDelete(@TempDir & "\ff$dp.zip")
		Exit
	  EndIf
    WEnd
EndFunc

Func _ZIPPRINT($SFILE, $SPOS)
	ConsoleWrite("!> _ZIPPrint: " & $SFILE & @LF)
EndFunc


Func _ZIPPASSWORD($SPWD, $SX, $SS2, $SNAME)
	Local $IPASS = InputBox("Archive encrypting set", "Enter the password", "", "", 300, 120)
	If $IPASS = "" Then Return 1
	Local $PASSBUFF = DllStructCreate("char[256]", $SPWD)
	DllStructSetData($PASSBUFF, 1, $IPASS)
EndFunc


Func _ZIPCOMMENT($SCOMMENT)
	Local $ICOMMENT = InputBox("Archive comment set", "Enter the comment", "", "", 300, 120)
	If $ICOMMENT = "" Then Return 1
	Local $COMMENTBUFF = DllStructCreate("char[256]", $SCOMMENT)
	DllStructSetData($COMMENTBUFF, 1, $ICOMMENT)
EndFunc


Func _ZIPPROGRESS($SNAME, $SSIZE)
	$CURZIPSIZE += Number($SSIZE)
	ConsoleWrite("!> Name: " & $SNAME & @LF)
EndFunc