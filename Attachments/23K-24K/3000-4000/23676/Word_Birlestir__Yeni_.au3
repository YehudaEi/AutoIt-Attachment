#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.12.0
	Author:         Muhammed DEM�RBA�
	
	::: Script Function:
	Microsoft Word'� kullanarak
	bir klas�r i�indeki DOC uzant�l� dosyalar�
	ba�ka bir DOC dosyas�nda birle�tirir
	
	::: Return Codes:
	+1	��lem Ba�ar�l�
	-1	Klas�r se�me diyalogu iptal edildi
	-2	Hedef dosya se�me diyalogu iptal edildi
	-3	Hedef dosya olu�turulamad�/a��lamad�
	-4	Microsoft Word a��lamad�
	-5	Microsoft Word yan�t vermiyor, i�leme ba�lanamad�
	-6	Microsoft Word yan�t vermiyor, kay�t yap�lamad�
	
#ce ----------------------------------------------------------------------------

#include <File.au3>

Opt("OnExitFunc", "BeforeExit")
Opt("SendKeyDelay", 10)
Opt("SendKeyDownDelay", 10)

Dim $Sleep = 1000
Dim $Errors = ""
Dim $ErrNum = 0
Dim $Path
Dim $FileName = "Birle�tirilmi�.doc"
Dim $SaveFile = @ScriptDir & "\" & $FileName
Dim $Header, $HeaderTmp, $src

$Path = FileSelectFolder("Birle�tirilecek wordleri i�eren klas�r?", "", 5, @ScriptDir)
If @error Then FatalError(-1)
$Path &= "\"

$SaveFile = FileSaveDialog("Hedef dosya nereye kaydedilecek?", "", "Word (*.doc)|T�m dosyalar(*.*)", 18, $FileName)
If @error Then FatalError(-2)

While $SaveFile = $Path & $FileName
	MsgBox(32, "Hata", "Hedef dosya kaynak klas�r i�inde olamaz. L�tfen farkl� bir konuma kaydetmeyi deneyin.")
	$SaveFile = FileSaveDialog("Hedef dosya nereye kaydedilecek?", "", "Word (*.doc)|T�m dosyalar(*.*)", 18, $FileName)
	If @error Then FatalError(-2)
	$FileName = StringMid($SaveFile, StringInStr($SaveFile, "\", 1, -1) + 1)
WEnd

If StringRight($SaveFile, 4) <> ".doc" Then $SaveFile &= ".doc"
If StringRight($FileName, 4) <> ".doc" Then $FileName &= ".doc"

If _FileCreate($SaveFile) <> 1 Then FatalError(-3, "��LEM TAMAMLANAMADI. Hedef dosya a��lam�yor: " & StringTrimRight($FileName, 4))
If ExecuteWord($SaveFile) <> 1 Then FatalError(-4, "��LEM TAMAMLANAMADI. Microsoft Word a��lam�yor")

$Header = $FileName & " - Microsoft Word"
WinWaitActive($Header, "", 5000)
If WinActivate($Header) = 0 Then FatalError(-5, "��LEM TAMAMLANAMADI. Pencere etkinle�tirilemiyor: " & StringTrimRight($FileName, 4))
WinWaitActive($Header)

$src = FileFindFirstFile($Path & "\*.doc")
While 1
	Local $file = FileFindNextFile($src)
	If @error = -1 Then ExitLoop
	
	If ExecuteWord($Path & $file) <> 1 Then ContinueLoop Error("MS Word a��lam�yor: " & StringTrimRight($file, 4))
	$HeaderTmp = $file & " - Microsoft Word"
	
	WinWaitActive($HeaderTmp, "", 5000)
	If WinActivate($HeaderTmp) = 0 Then ContinueLoop Error("Pencere etkinle�tirilemiyor: " & StringTrimRight($file, 4))
	WinWaitActive($HeaderTmp)
	
	Send_WinWaitActive("^a", $HeaderTmp)
	Send_WinWaitActive("^c", $HeaderTmp)
	SendKeepActive($HeaderTmp)
	Send("^w")
	WinWaitClose($HeaderTmp)
	
	If WinActivate($Header) = 0 Then ContinueLoop Error("Pencere etkinle�tirilemiyor: " & StringTrimRight($FileName, 4))
	WinWaitActive($Header)
	
	Send_WinWaitActive("^{END}", $Header)
	Send_WinWaitActive("^{END}{ENTER}{+}{+}", $Header)
	Send_WinWaitActive(StringTrimRight($file, 4), $Header)
	Send_WinWaitActive("^{END}{ENTER}{ENTER}", $Header)
	Send_WinWaitActive("^{END}^v", $Header)
	ClipPut("")
	WinWaitActive($Header)
WEnd

If WinActivate($Header) = 0 Then
	Error("��LEM TAMAMLANAMADI. Pencere etkinle�tirilemiyor: " & StringTrimRight($FileName, 4))
	Exit -6
EndIf
WinWaitActive($Header)
Send_WinWaitActive("^s", $Header)

WinClose($Header)
WinWaitClose($HeaderTmp)
Exit 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FUNCIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func Error($str)
	$ErrNum += 1
	$Errors &= @TAB & $str & @CR
	Return 1
EndFunc   ;==>Error

Func BeforeExit()
	If $ErrNum = 0 Then
		MsgBox(32, "DOC Birle�tirici", "DOC Birle�tirici i�inin bitirdi!")
	ElseIf $Errors <> "" Then
		MsgBox(32, "DOC Birle�tirici", "Program boyunca �u hatalar olu�tu:" & @CR & @CR & $Errors)
	EndIf
EndFunc   ;==>BeforeExit

Func Send_WinWaitActive($SendStr, $WinHeader)
	WinWaitActive($WinHeader, "", 5000)
	SendKeepActive($WinHeader)
	Send($SendStr)
	WinWaitActive($WinHeader)
EndFunc   ;==>Send_WinWaitActive

Func FatalError($ReturnCode, $ErrorStr = "")
	$ErrNum += 1
	If $ErrorStr <> "" Then Error($ErrorStr)
	Exit $ReturnCode
EndFunc   ;==>FatalError

Func ExecuteWord($FileToOpen)
	Return ShellExecute("winword.exe", """" & $FileToOpen & """")
EndFunc   ;==>ExecuteWord