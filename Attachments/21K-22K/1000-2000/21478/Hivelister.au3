#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ID_Card_256x256_blue.ico
#AutoIt3Wrapper_Outfile=Hivelister.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=Lists SID's from the registry, to aid in associating files to users
#AutoIt3Wrapper_Res_Description=Hivelister Ver2
#AutoIt3Wrapper_Res_Fileversion=2
#AutoIt3Wrapper_Res_LegalCopyright=All rights reserved Richard Easton 2008
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/cs=1 /cn=1 /cf=1 /cv=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         RichE <rich.easton@gmail.com>
;
; Script Function:
;	list SID's of useracounts.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
$DESTINATION = @TempDir & "\hllogo.jpg"

;splash start
FileInstall("hllogo.jpg", $DESTINATION)
SplashImageOn("", $DESTINATION, 500, 100, "-1", "-1", 1 + 2)
Sleep(3000)
SplashOff()
;splash end
$file = FileSaveDialog("Choose a name.", @DesktopDir, "document (*.doc)", 3, "hivelist_for_" & @ComputerName & ".doc")

If FileExists($file) Then
	MsgBox(0, "Warning!", "A hivelist for this Computername already exists, please rename or remove.", 10)
Else
	FileWriteLine($file, "<p><center><FONT FACE='verdana' SIZE='+4' COLOR='BLUE'><U>HIVELISTER</U><font size='-2'>&trade;</font></FONT></CENTER></p><BR>")
	FileWriteLine($file, "<FONT FACE='verdana' size='-1'>The following Security IDentifiers (SID's) where found on <B>" & @ComputerName & "</B> on the <B>" & @MDAY & "/" & @MON & "/" & @YEAR & "</B> at <B>" & @HOUR & ":" & @MIN & "</B>.")
	FileWriteLine($file, "<BR>")
	FileWriteLine($file, "<BR>")
	FileWriteLine($file, "<table width='80%' align='center' border='0' cellpadding='4' cellspacing='1' bgcolor='#000000'>")
	$i = 1
	Do
		$var = RegEnumVal("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\hivelist\", $i)
		$hlr = RegRead("HKLM\SYSTEM\CurrentControlSet\Control\hivelist\", $var)
		If StringInStr($var, "\registry\user\") Then
			If StringInStr($var, "\registry\user\s-1-5-19") Or StringInStr($var, "\registry\user\s-1-5-20") Or StringInStr($var, "\registry\user\.default") Or StringInStr($var, "class") Then
				$i = $i + 1
			Else
				FileWriteLine($file, "<TR bgcolor='#efefef'><TD><B>SID:</B> " & $var & "</TD></TR>" & @CRLF & "<TR bgcolor='#f7f7f7'><TD><B>UserProfile:</B> " & $hlr & "</TD></TR>")
				$i = $i + 1
			EndIf
		Else
			$i = $i + 1
		EndIf
	Until StringInStr($var, "No more data is available")
	
	FileWriteLine($file, "</table>")
	FileWriteLine($file, "<BR>")
	FileWriteLine($file, "<BR>")
	FileWriteLine($file, "<FONT SIZE='-1' FACE='VERDANA'>This doucment was produced by <B>Hivelister&copy;</B> written by <a href='mailto:rich.easton@gmail.com'>Richard Easton</A> 2007</FONT>")
EndIf

Run(@ProgramFilesDir & "\Internet Explorer\IEXPLORE.EXE " & $file, "", @SW_MAXIMIZE)
Exit