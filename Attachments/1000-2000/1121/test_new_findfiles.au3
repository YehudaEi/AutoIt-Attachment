; ----------------------------------------------------------------------------

; AutoIt Version: 3.0
; Language:       English
; Platform:       only tested on W98 platform
; Author:         Jean-Louis Balorin
; Function of the script:
; 							test _BrowseThenDo  version 1.0 which:
;											Browse a given Dir and subdir (according to mask) 
;											invoke (actually "Call") user given "dofunc" function for each found file
;							_BrowseThenDo is fully expanded in this script
;							a basic DoFunction is included for test purpose
; ----------------------------------------------------------------------------


#include <file.au3>
#region --------------  special variables needed by Browse Then Do ------------------------------------------
; $BTD_... varaiables
;			are used in _BrowseThenDo to simulate actual parameter to DoFunction  (couldn't make a "Call" with parameters)
; 			used only here and in the DoFunction itself (should not be used somewhere else to avoid potential side-effect problem)
; 			They are declared in the _BrowseThenDo au3 include
; $BTD_file handle of the file being processed
; $BTD_lastnumfileprocessed selfexplanatory can be ued in DoFunction (eg for incrementation purposes)
; $BTD_logfile name of file used to log info within all functions (as semi-column separated text file)
;
Global $BTD_file,$BTD_filename, $BTD_lastnumfileprocessed,$BTD_logfile
#endregion --------------  End special variables needed by Browse Then Do ------------------------------------------


Dim $testdir ="c:\Mes Documents"  ; specify the directory to searchfor testing
Dim $filemask="*.*"                           ; specify the filemask

$BTD_logfile="C:\Mes documents\Auto_IT scripts\BTD findfile list.log"

if Not _FileCreate($BTD_logfile) Then
	MsgBox(0,"Browse Then Do" & "Unable to use " & $logfile)
EndIf
$result=_BrowseThenDo($testdir, $filemask,"justlistfile")

Exit


Func _BrowseThenDo($T_DIR,$T_MASK,$dofuncname)
; ----------------------------------------------------------------------------
; Function:
; 		_BrowseThenDo  version 1.0
; parameters:
;		Browse a given Dir and subdir (according to mask) 
;		invoke (actually "Call") dofunc function for each found file ($dofuncname value name of dofunc witout $sign)
; returns:
;		nothing exit on error (this version)
; credits:
; 		most of the code to walk thru dir is taken from jos van der Zande's findfiles.au3
; pros and cons
;     not self contained (waiting for parameter in call ;-{)}  ) from this "source management"  point view jos's work is far much better
; 		much more performant than jos's code (1/5 cpu, 1/6 elapsed time on a 10 000 file dir!!)
; future developments (to be thought about fisrt!!)
;		$dofunction could be an array of several actions to be applied to each file??
;		some error conditions to be checked (with a max number of error set to stop browsing)??
;		silent browse parameter???
; ----------------------------------------------------------------------------
   Dim $N_DIRNAMES[200000] ; max number of directories that can be scanned
   Local $N_DIRCOUNT = 0
   Local $N_FILE
   Local $N_SEARCH
   Local $N_TFILE
   Local $N_OFILE
   Local $T_FILENAMES
   Local $T_FILECOUNT
   Local $T_DIRCOUNT = 1
   
; start of code   
	$BTD_lastnumfileprocessed=0
	_FileWriteLog($BTD_logfile ,"Start browse" & $T_DIR)

; remove the end \ If specified
   If StringRight($T_DIR,1) = "\" Then $T_DIR = StringTrimRight($T_DIR,1)
   $N_DIRNAMES[$T_DIRCOUNT] = $T_DIR
   ; Exit if base dir doesn't exists
   If Not FileExists($T_DIR) Then Return 0
   ; keep on looping until all directories are scanned
   While $T_DIRCOUNT > $N_DIRCOUNT
      $N_DIRCOUNT = $N_DIRCOUNT + 1
      ; find all subdirs in this directory and save them in a array
      $N_SEARCH = FileFindFirstFile($N_DIRNAMES[$N_DIRCOUNT] & "\*.*")  
      While 1
         $N_FILE = FileFindNextFile($N_SEARCH) 
         If @error Then ExitLoop
         ; skip "." and ".."  references
         If $N_FILE = "." Or $N_FILE = ".." Then ContinueLoop
         $N_TFILE = $N_DIRNAMES[$N_DIRCOUNT] & "\" & $N_FILE
         ; if Directory than add to the list of directories to be processed 
         If StringInStr(FileGetAttrib( $N_TFILE ),"D") > 0 Then
            $T_DIRCOUNT = $T_DIRCOUNT + 1
            $N_DIRNAMES[$T_DIRCOUNT] = $N_TFILE
         EndIf
      Wend
      FileClose($N_SEARCH)
      ; find all Files that mtach the MASK
      $N_SEARCH = FileFindFirstFile($N_DIRNAMES[$N_DIRCOUNT] & "\" & $T_MASK )  
      If $N_SEARCH = -1 Then ContinueLoop
      While 1
         $N_FILE = FileFindNextFile($N_SEARCH) 
         If @error Then ExitLoop
         ; skip "." and ".."  references
         If $N_FILE = "." Or $N_FILE = ".." Then ContinueLoop
         $N_TFILE = $N_DIRNAMES[$N_DIRCOUNT] & "\" & $N_FILE
		 $BTD_filename=$N_TFILE
         ; if file,  process with dofunction
		If StringInStr(FileGetAttrib( $N_TFILE ),"D") = 0 Then
            if Call ($dofuncname) Then
				$BTD_lastnumfileprocessed=$BTD_lastnumfileprocessed +1
			Else
				ExitLoop
			EndIf
		 EndIf
      Wend
      FileClose($N_SEARCH)
   Wend

_FileWriteLog($BTD_logfile,"End browse" & $T_DIR & " Files processed: " & $BTD_lastnumfileprocessed )

EndFunc   ;==>_GetFileList

; very simple dofunction for each file
Func justlistfile ()
	local $nfile
	$nfile=$BTD_lastnumfileprocessed+1
	_FileWriteLog($BTD_logfile,";" & $nfile & ";" & $BTD_filename)
EndFunc
