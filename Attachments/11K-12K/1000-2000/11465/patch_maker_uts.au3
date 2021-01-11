If $CmdLine[0] <> 2 Then Exit
$uts = $CmdLine[1]
$ini_exe = $CmdLine[2]

$txt = @MDAY & '.' & @MON & '.' & @YEAR & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & @CRLF & @CRLF

$pripona = StringRight(@ScriptName, 4) ; .exe nebo .au3
$log = StringReplace(@ScriptName,$pripona,'.log')

If FileExists($ini_exe) Then FileDelete($ini_exe) ; aby se neobjevila hlaska pro potvrzeni prepsani existujiciho souboru

$wizard = RegRead("HKEY_CURRENT_USER\SOFTWARE\Clickteam\Patch Maker\General", "wizard")
RegWrite("HKEY_CURRENT_USER\SOFTWARE\Clickteam\Patch Maker\General", "wizard", "REG_DWORD", 0)
	
Run("C:\Program Files\Patch Maker\PatchMaker.exe")

WinWaitActive("Clickteam Patch Maker")

Send("^o") ; Ctrl+O Open
WinWaitActive("Open")
ControlSetText("Open", "", "Edit1", $uts)
Send("{Enter}")

WinWaitActive("Clickteam Patch Maker")

Send("^b") ; Ctrl+B Build
WinWaitActive("Uložit jako")
ControlSetText("Uložit jako", "", "Edit1", $ini_exe)
Send("{Enter}")

; pockat az se dokonci build
While ControlListView("Clickteam Patch Maker", "", "SysListView321", "FindItem", "Result:") < 0
	Sleep(250)
WEnd

; zapsat vysledek do LOG souboru
$txt &= 'File' & @TAB & 'Packed' & @TAB & 'Size' & @TAB & 'Ratio' & @TAB & 'Action' & @CRLF
$txt &= '----' & @TAB & '------' & @TAB & '----' & @TAB & '-----' & @TAB & '------' & @CRLF
$pocet = ControlListView("Clickteam Patch Maker", "", "SysListView321","GetItemCount")

For $i = 0 To $pocet - 1
	$radek = ''
	For $j = 0 To 4
		$radek &= ControlListView("Clickteam Patch Maker", "", "SysListView321","GetText",$i,$j) & @TAB
	Next
	$radek = StringTrimRight($radek,1) & @CRLF
	$txt &= $radek
Next

$txt &= @CRLF & $ini_exe & @CRLF
$txt &= @CRLF & @MDAY & '.' & @MON & '.' & @YEAR & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & @CRLF
$txt &= @CRLF & '*****' & @CRLF & @CRLF

FileWrite($log, $txt)
WinKill("Clickteam Patch Maker", "")

RegWrite("HKEY_CURRENT_USER\SOFTWARE\Clickteam\Patch Maker\General", "wizard", "REG_DWORD", $wizard)
