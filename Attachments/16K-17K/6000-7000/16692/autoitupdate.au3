#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; exit codes:
; 0 - successfully updated
; 1 - no updates available
; 2 - failed to download dat
; 3 - failed to download release
; 4 - failed to download beta
; 5 - failed to download scite version
; 6 - failed to download scite

Opt("TrayAutoPause",0)
$datfile = 'http://www.autoitscript.com/autoit3/files/beta/update.dat'
$sciteversion = 'http://www.autoitscript.com/autoit3/scite/download/scite4autoit3version.ini'
$localsciteversion = @TempDir & '\sciteversion.ini'
$localdat = @TempDir & '\au3_update.dat'
$rel = @TempDir & '\autoitrelease.exe'
$bet = @TempDir & '\autoitbeta.exe'
$sci = @TempDir & '\scite.exe'
HttpSetProxy(0)
If $CmdLine[0] > 1 Then Exit
$param = ""
If $CmdLine[0] Then $param = $CmdLine[1]
If Not InetGet($datfile,$localdat,1) Then
	Exit 2
EndIf
If Not InetGet($sciteversion,$localsciteversion,1) Then
	Exit 5
EndIf
Global $s_ReleaseVer, $s_ReleaseFile, $s_ReleasePage, $i_ReleaseSize, $i_ReleaseDate
Global $s_LatestBetaVer, $s_BetaFile, $s_BetaPage, $i_BetaSize, $i_BetaDate
Global $s_PreBetaVer, $s_PreBetaFile, $s_PreBetaPage, $i_PreBetaSize, $i_PreBetaDate
Global $s_SciTELatest
$s_ReleaseVer = IniRead($localdat, 'AutoIt', 'version', 'Error reading file')
$s_ReleaseFile = IniRead($localdat, 'AutoIt', 'setup', '')
$s_ReleasePage = IniRead($localdat, 'AutoIt', 'index', 'http://www.autoitscript.com')
$i_ReleaseSize = IniRead($localdat, 'AutoIt', 'filesize', 0)
$i_ReleaseDate = IniRead($localdat, 'AutoIt', 'filetime', 0)
$s_LatestBetaVer = IniRead($localdat, 'AutoItBeta', 'version', 'Error reading file')
$s_BetaFile = IniRead($localdat, 'AutoItBeta', 'setup', '')
$s_BetaPage = IniRead($localdat, 'AutoItBeta', 'index', 'http://www.autoitscript.com')
$i_BetaSize = IniRead($localdat, 'AutoItBeta', 'filesize', 0)
$i_BetaDate = IniRead($localdat, 'AutoItBeta', 'filetime', 0)
$s_PreBetaVer = IniRead($localdat, 'AutoItPreBeta', 'version', '')
$s_PreBetaFile = IniRead($localdat, 'AutoItPreBeta', 'setup', '')
$s_PreBetaPage = IniRead($localdat, 'AutoItPreBeta', 'index', 'http://www.autoitscript.com')
$i_PreBetaSize = IniRead($localdat, 'AutoItPreBeta', 'filesize', 0)
$i_PreBetaDate = IniRead($localdat, 'AutoItPreBeta', 'filetime', 0)
$s_SciTELatest = IniRead($localsciteversion, 'SciTE4AutoIt3','date','0/0/0000')
FileDelete($localdat)
Global $s_Au3Path = RegRead('HKLM\Software\AutoIt v3\AutoIt', 'InstallDir')
Global $s_SciTEPath = $s_Au3Path & "\SciTE"
Global $updated = False
If Not @error And FileExists($s_Au3Path & '\AutoIt3.exe') Then
    $s_CurrVer = FileGetVersion($s_Au3Path & "\AutoIt3.exe")    
Else
    $s_Au3Path = 'Installation not found'
    $s_CurrVer = 'Unavailable'    
EndIf
Global $s_BetaPath = RegRead('HKLM\Software\AutoIt v3\AutoIt', 'betaInstallDir')
If Not @error And FileExists($s_BetaPath & '\AutoIt3.exe') Then
    $s_CurrBetaVer = FileGetVersion($s_BetaPath & "\AutoIt3.exe")
Else
    $s_BetaPath = 'Installation not found'
    $s_CurrBetaVer = 'Unavailable'
EndIf
Global $s_SciTEDate = 'x/x/xxxx'
If FileExists($s_SciTEPath & '\SciTe.exe') Then
	$s_SciTEDate = IniRead($s_SciTEPath & '\SciteVersion.ini','SciTE4AutoIt3','date','x/x/xxxx')
EndIf
If $s_CurrVer <>  $s_ReleaseVer OR StringInStr($param,"F") Then
	If Not InetGet($s_ReleaseFile,$rel,1) Then
		Exit 3
	EndIf	
	$updated = True
	RunWait($rel & " /S")
	$updated = True
EndIf
If $s_CurrBetaVer <> $s_LatestBetaVer OR StringInStr($param,"F") Then
	If Not InetGet($s_BetaFile,$bet,1) Then
		Exit 4
	EndIf
	RunWait($bet & " /S")
	$updated = True
EndIf
If $s_SciTEDate <> $s_SciTELatest Then
	If Not InetGet("http://www.autoitscript.com/autoit3/scite/download/SciTE4AutoIt3.exe",$sci,1) Then
		Exit 6
	EndIf	
	RunWait($sci & " /S")
	$updated = True
	RegWrite("HKCR\AutoIt3Script\Shell","","REG_SZ","Edit") ; Change this to "Run" to run scripts by default instead of edit them.  Change back to "Edit" if you want SciTE to open files.	
EndIf
If $updated Then
	Exit 0
Else
	Exit 1
EndIf