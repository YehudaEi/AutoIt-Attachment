; World List Splitter
; Created 2005-janvier-13 By Greenseed
; version 0.1 
;MsgBox(4096,"",$_path)

;**************************************************************************************
;*****************************************Debut****************************************
;**************************************************************************************

;declare option
AutoItSetOption ( "trayiconDebug",1 )

;-------Declare Variable---------
$_var1 = 1
$_checkdupe = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
$_bytesread = 0
$_timerdif = 1000
$_filetowrite = ""
$_linetowrite = ""
$_readline = ""
$_line = 1

; Selection du fichier
$_wordfile = FileOpenDialog ( "Choisis Le Fichier De Mots A Spliter", "c:\", "All (*.*)" , 1 + 2)

; calcule le path
$_pos = StringInStr ( $_wordfile, "\" , 0, -1)
$_len = StringLen ( $_wordfile )
$_todelete = $_len - $_pos + 1

; path ou lire et ecrire le fichier
$_path = StringTrimRight ( $_wordfile, $_todelete )

; ouvre le fichier a lire
FileOpen ( $_wordfile, 0 )
$_bytestoread = filegetsize ( $_wordfile )

;ProgressOn ( "title", "maintext" [, "subtext" [, x pos [, y pos [, opt]]]] )
ProgressOn ( "Progression", "", "", 0, 0, 2 + 16)
$_timer = TimerInit()

;ouvre le fichier a ecrire
$_filetowrite = $_path & "\wordsplit_" & $_var1 & ".txt"

Fileopen ( $_filetowrite, 1 )

; check pour une erreur si 1 exit
if @error = 1 then
	MsgBox(4096,"","Exiting Error = 1")
	exit
endif 

_read()
	
func _read()

 ;lit le fichier jusqu'a fin
	While 1
		$_readline = FileReadLine ( $_wordfile, $_line )
		while $_readline = $_checkdupe
			$_Checkdupe = "aaaaaaaaaaaaaaaaaaaaaaaaaa"
			$_line = $_line + 1
	    	$_readline = FileReadLine ( $_wordfile, $_line )
		wend
;check la grosseur du fichier a ecrite si ye plus grand que 10meg il en ouvre un autre
	while Filegetsize ( $_filetowrite ) > 10240000
	    FileClose ( $_filetowrite )
	    $_var1 = $_var1 + 1
		$_filetowrite = $_path & "\wordsplit_" & $_var1 & ".txt"
		Fileopen ( $_filetowrite, 1 )
	wend 

	;Ecrite la ligne au fichier $_filetowrite
	 $_checkdupe = $_readline 
	 $_bytesread = $_bytesread + Stringlen ( $_readline  )
	 FileWriteLine ( $_filetowrite, $_readline  )
	 $_line = $_line + 1
	_progress()
	if @error = -1 then exitloop
	Wend 
	
	;ferme les fichiers et quitte
	fileclose( $_wordfile )
	fileclose( $_filetowrite )
	exit 
endfunc

func _progress()

if Timerdiff($_timer) > $_timerdif then
	$_timerdif = $_timerdif + 1000
	$_pourcent = Int($_bytesread * 100 / $_bytestoread)
	$_speed = round( $_bytesread * 1000 / timerdiff ( $_timer ) / 1024, 2) ; Kbytes/seconde
	$_eta = round ( round ( $_bytestoread - $_bytesread, 0 ) / 1024 / $_speed,2 ) ; seconde
	If $_speed > 1024 Then 
               $_speed = Round($_speed / 1024, 2) & " Mb/Sec"
           Else
               $_speed = $_speed & " Kb/Sec"
    EndIf
    If $_eta > 0 Then
    	If $_eta > 60 Then 
        	$_eta = Round($_eta / 60, 0) & " Min"
        Else
        	$_eta = $_eta & " Sec"
        EndIf
    Else
    	$_eta = ""
    EndIf
	ProgressSet($_pourcent, "Etat: " & $_eta & " @ " & $_speed)
endif
endfunc
	
	

;**************************************************************************************
;*******************************************End****************************************
;**************************************************************************************