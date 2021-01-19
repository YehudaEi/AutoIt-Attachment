; ----------------------------------------------------------------------------
;
; Script Function:
;	converts any file (including  exe's) into a text file that will 
;   pass through most e-mail filters
;	(some do not like double file extensions e.g. filename.exe.txt
;    so the file may need to be renamed)
;
;   To re-create the original file, simply rename the .txt file to a .bat
;   and execute it.
;   The batch file leaves a single .txt temporary file behind, 
;   simply delete it
;
;Notes
; the file must be split into chunks no larger than 40k for processing. This is fairly 
; quick. The creation of the text file is not to shabby either, but the subsequent 
; conversion  back to a binary file can be a little slow so remember this when 
; using it on larger files
;
;IMPORTANT.
; I use 'encbin.com' and 'decbin.com' to do the real work
; Both of these are (C) Copyright 2002 Terry Newton
; and have been released to the public domain.
;
; (This scripts creates them for you)
;
; ----------------------------------------------------------------------------
$g_szVersion = "Passthrough v1.3 )"
$fext = ".txt" 
$filename = ""
$ofile = ""
$prgfile = ""
$ChunkSize = 40000	; THIS MUST BE NO LARGER THAN 40k otherwise encbin and decbin will not cope.
$ChunkFilePrefix = "PA5H2E5N9G"

$decb =  "decbin.com"
$encb =  "encbin.com"

MakeChunks()	; select a a file and break it down into chunks
Makeit()		; create encbin & decbin
Top()			; create the header of the batch File
Body()			; create the body of the File (this is what takes most of the time)
tail()			; the tailend	
tidy()			; a little tidying up.
Exit
;===============================================================================
;Functions start here
;=============================
Func MakeChunks()

	$filename = FileOpenDialog("Choose File", "", "All files (*.*)", 1)
	If @error Then
		MsgBox(4096,"","No File chosen")
		exit
	EndIf

	$filesize = FileGetSize($filename)
	If $filesize < 1 Then
		MsgBox(4096,"","File to small")
		exit
	EndIf
	If $filesize < $ChunkSize Then
		$ChunkSize  = $filesize
	EndIf
	
	$prgfile=shrtnm($filename) ;original filename without the path
	
	$ihandle = FileOpen($filename,16)
	If $ihandle = -1 Then
		MsgBox(0, "Error", "Unable to open input file.")
		Exit
	EndIf

	$loop = 1
	While 1
		$chunkname = @ScriptDir & "\" & $ChunkFilePrefix & "chunk" & $loop
		$ohandle = FileOpen($chunkname,2)
		If $ohandle= -1 Then
			MsgBox(0, "Error", "Unable to open output file.")
			Exit
		EndIf

		$filein = FileRead($ihandle,$ChunkSize)	
		If @error = -1 Then ExitLoop
				
		FileWrite($ohandle,$filein)
		FileClose($ohandle)
		$loop += 1
	WEnd
	FileClose($ohandle)
	FileClose($ihandle)

EndFunc
;=============================
Func Makeit()
FileChangeDir ( @scriptdir )
	$handle=FileOpen($decb,2)
	FileWriteline($handle,"`h}aXP5y`P]4nP_XW(F4(F6(F=(FF)FH(FL(Fe(FR0FTs*}`A?+,")
	FileWriteline($handle,"fkOU):G*@Crv,*t$HU[rlf~#IubfRfXf(V#fj}fX4{PY$@fPfZsZ$:NvN$")
	FileWriteline($handle,"9AyroNB-)dOKwK0rRkfTbi)ws_~[[q9wE'sqlu1sY*Bsfe=@ziNS1a)88e")
	FileWriteline($handle,"f9RTL)9Z{3INBD?o6@MDLO{Zz4Q23E-'09NX9@Vz(42A7c8zMS:u$w6k5Q")
	FileWriteline($handle,"N,h:le)~gF?tutTyxoe5UiIdtn';0rJ1q:{7;lAl']y:yTjZBbOo?QRIdN")
	FileWriteline($handle,"$Bp@P/nAp_r0*4f'XcF4q3o?$_t5lx$Q-OxSfUNQ__Gd~$Q-Oxgkx=LGHU")
	FileWriteline($handle,"S)$C6P8#")
	FileClose($handle)

	$handle=FileOpen(@ScriptDir & "\encbin.tmp",2)
	FileWriteline($handle,"AALIxnCmeRf0\Uf0pWjXYBlxr0MyG02u022nc1Z5Z0r4G2ldMAj[8F34dd")
	FileWriteline($handle,"Z1Z0r4G2ld6Aj[8F34Ed3EmbG02lJpNl0jjjCt9v0407ZvjtS3I0j7rvLv")
	FileWriteline($handle,"G203l0wUDv20F42eD3ZujTS6fmprbD2e4uwp39gwYdfDfAdng0f1f0ZF2t")
	FileWriteline($handle,"04bemDCXj0C0LHtA2701ZsG0SFdfW]6630Jf36S6W1f0rJ2fMfQYW1YAoO")
	FileWriteline($handle,"EAt0y[36S6W1[8LRi3}")
	FileClose($handle)
	
	$cmdl =   $decb & "<" & "encbin.tmp>" &  $encb 
	RunWait(@COMSPEC & " /c " & $cmdl,"", @SW_HIDE)
	
EndFunc
;============================
Func Top()
	$ofile = fileopen($prgfile & $fext,2)
	FileWriteLine($ofile  ,"@echo off")
	FileWriteLine($ofile    ,"::---------------------")
	FileWriteLine($ofile   ,": DO NOT EDIT THiS FILE IN ANY MANNER AT ALL ")
	FileWriteLine($ofile   ,": Rename this to a .bat file and execute it")
	FileWriteLine($ofile   ,": to re-create the executable")
	FileWriteLine($ofile   ,"::---------------------")
	FileWriteLine($ofile  ,":")
	FileWriteLine($ofile   ,"set out=""" & $prgfile & """") 
	FileWriteLine($ofile   ,"set dec=decbin.com")
	FileWriteLine($ofile   ,"set tmpf=""" & $prgfile & "tmp.txt" & """") 
	FileWriteLine($ofile   ,":")
	FileWriteLine($ofile   ,"::---------------------")
	FileWriteLine($ofile   ,"ECHO :::::::::::::::::::::")
	FileWriteLine($ofile   ,"ECHO : Busy creating     :")
	FileWriteLine($ofile   ,"ECHO : %out% ")
	FileWriteLine($ofile   ,"ECHO :::::::::::::::::::::")
	FileWriteLine($ofile   ,":")
	FileWriteLine($ofile   ,"::---------------------")
	FileWriteLine($ofile   ,": Creating some temporary files")
	FileWriteLine($ofile   ,"::---------------------")
	FileWriteLine($ofile   ,"::---------------------")
	FileWriteLine($ofile  ,"ECHO:`h}aXP5y`P]4nP_XW(F4(F6(F=(FF)FH(FL(Fe(FR0FTs*}`A?+,>%dec%")
	FileWriteLine($ofile   ,"ECHO:fkOU):G*@Crv,*t$HU[rlf~#IubfRfXf(V#fj}fX4{PY$@fPfZsZ$:NvN$>>%dec%")
	FileWriteLine($ofile  ,"ECHO:9AyroNB-)dOKwK0rRkfTbi)ws_~[[q9wE'sqlu1sY*Bsfe=@ziNS1a)88e>>%dec%")
	FileWriteLine($ofile  ,"ECHO:f9RTL)9Z{3INBD?o6@MDLO{Zz4Q23E-'09NX9@Vz(42A7c8zMS:u$w6k5Q>>%dec%")
	FileWriteLine($ofile ,"ECHO:N,h:le)~gF?tutTyxoe5UiIdtn';0rJ1q:{7;lAl']y:yTjZBbOo?QRIdN>>%dec%")
	FileWriteLine($ofile ,"ECHO:$Bp@P/nAp_r0*4f'XcF4q3o?$_t5lx$Q-OxSfUNQ__Gd~$Q-Oxgkx=LGHU>>%dec%")
	FileWriteLine($ofile ,"ECHO:S)$C6P8#>>%dec%")
	FileWriteLine($ofile ,"::---------------------")
	FileWriteLine($ofile ,"if EXIST %tmpf%  del %tmpf%")
	FileWriteLine($ofile ,"if EXIST %out%  del %out%")
EndFunc
;============================
Func Body()
	$lper = 1
	While 1
	If FileExists(@ScriptDir & "\" & $ChunkFilePrefix & "chunk" & $lper) Then
		$files = $ChunkFilePrefix & "chunk" & $lper 
		If FileGetSize($files) > 0 Then
;~ 			MsgBox(0,"Processing...","Processing file : " & $files)
			$cmdl = "encbin.com<" & $files & ">" & $files & ".enc"
			RunWait(@COMSPEC & " /c " & $cmdl,"", @SW_HIDE)
			$efile = FileOpen($files & ".enc",0)
			While 1
				$line = FileReadLine( $efile)
				If @error = -1 Then ExitLoop 
				FileWriteLine($ofile  ,"ECHO:" & $line & ">> %tmpf%")	
			Wend	
			FileWriteLine($ofile  ,"decbin<%tmpf%>>%out%")
			FileWriteLine($ofile  ,"ECHO.>%tmpf%")
			FileClose($efile)
		EndIf
	Else
		ExitLoop
	EndIf
	$lper += 1
	WEnd
EndFunc
;============================
Func Tail()
	FileWriteLine($ofile  ,"::---------------------")
	FileWriteLine($ofile  ,"ECHO :")	
	FileWriteLine($ofile  ,"ECHO ::::::::::::::::::::")
	FileWriteLine($ofile  ,"ECHO : %out% created ")
	FileWriteLine($ofile  ,"ECHO :")
	FileWriteLine($ofile  ,"ECHO :Please delete %tmpf%")
	FileWriteLine($ofile  ,"ECHO ::::::::::::::::::::")
	FileWriteLine($ofile  ,"::---------------------")
	FileWriteLine($ofile  ,"del %dec%")
	FileWriteLine($ofile  ,"pause")
	FileClose ($ofile)
	Endfunc
;============================
Func Tidy()

	filedelete($ChunkFilePrefix & "chunk*.*")
	filedelete("decbin.com")
	filedelete("encbin.tmp")
	filedelete("encbin.com")
	
	MsgBox(4096,"",$prgfile & ".txt created")
	
EndFunc
;============================
Func shrtnm($longname)
	Return stringright ($longname,stringlen($longname)-stringinstr($longname,"\",0,-1))
endFunc 
;============================
