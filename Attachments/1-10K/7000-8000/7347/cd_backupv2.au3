;*********************************************************
;*** Selective Backup to CDR  
;*** Author Steve Fisher - steve.fisher@fernite.co.uk
;*** Date 9/3/06
;*********************************************************
;*** Uses command line utilities from CDPISAC
;***                   
;*** Follow instalation routines to the letter (esp. ASPI)
;*********************************************************

;Variable section
 
;Paths
$path1="c:\Backup\"
$path2="c:\iso\"
   
;*********************************************
;**** Command Strings to be run from DOS *****
;*********************************************

;Change directory (is this persistent after shell lost ?)
;$cmd1=" /c " & 'cd c:\backup'
   
;Create a textfile of zip files in directory
$cmd2=" /c " & 'dir /b /a-d /o-d > c:\Backup\flist.txt c:\Backup\*.zip'
   
;Make ISO Command line
$cmd3=" /c " & "mkisofs -V CD1 -R -J -v -o c:\backup.iso c:\iso"
 
;Burn ISO to recorder
$cmd4=" /c " & "cdrecord dev=1,1,0  speed=32 -dao fs=4m -eject -v -overburn -data c:\backup.iso"
   

;Create a file list to work with:
FileDelete("c:\Backup\flist.txt")
;Run(@ComSpec & $cmd1, "", @SW_HIDE)
Run(@ComSpec & $cmd2, "", @SW_HIDE)

;Always move this file
filemove($path1 & "backup-fox.rar", $path2 & "backup-fox.rar",1)

;Move relevant files to make ISO
FileOpen("G:\OPERAI~1\Backup\flist.txt",0)

for $i=1 to 10 step 1
	
	;$fname1 = list of files to process
	$fname1=FileReadLine("G:\OPERAI~1\Backup\flist.txt", $i)
	
	;$Fname2 = full path to source file
	$fname2=$path1 & $fname1
	
	;$Fname3= full path to destination file
	$fname3=$path2 & $fname1
	
	;$ext
	$ext=StringRight($fname1,3)
	
	If not StringIsSpace($fname1) Then
       
	   If stringupper($ext)="ZIP" Then
          FileMove($fname2, $fname3, 1)
		  ;MsgBox ( 1, $ext, $fname1 & " " & $Fname2 & " " & $Fname3 & " " & @error)
	   EndIf
	  	  
	EndIf
	
Next

;Make ISO
RunWait(@ComSpec & $cmd3, "", @SW_show)

;Move files back to Original folder
filemove($path2 & "*.rar", $path1 & "*.rar",1)
filemove($path2 & "*.zip", $path1 & "*.zip",1)

;Burn ISO
RunWait(@ComSpec & $cmd4, "", @SW_show)

