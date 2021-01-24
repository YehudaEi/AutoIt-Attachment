#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.12.0
	Author:         Muhammed DEMÝRBAÞ
	
	::: Script Function:
	Microsoft Word'ü kullanarak
	bir klasör içindeki DOC uzantýlý dosyalarý
	baþka bir DOC dosyasýnda birleþtirir
	
	::: Return Codes:
	+1	Ýþlem Baþarýlý
	-1	Klasör seçme diyalogu iptal edildi
	-2	Hedef dosya seçme diyalogu iptal edildi
	-3	Hedef dosya oluþturulamadý/açýlamadý
	-4	Microsoft Word açýlamadý
	-5	Microsoft Word yanýt vermiyor, iþleme baþlanamadý
	-6	Microsoft Word yanýt vermiyor, kayýt yapýlamadý
	
#ce ----------------------------------------------------------------------------

#include <File.au3>

Opt("OnExitFunc", "BeforeExit")
Opt("SendKeyDelay", 10)
Opt("SendKeyDownDelay", 10)

Dim $Sleep = 1000
Dim $Errors = ""
Dim $ErrNum = 0
Dim $Path
Dim $FileName = "Birleþtirilmiþ.doc"
Dim $SaveFile = @ScriptDir & "\" & $FileName
Dim $Header, $HeaderTmp, $src

$Path = FileSelectFolder("Birleþtirilecek wordleri içeren klasör?", "", 5, @ScriptDir)
If @error Then FatalError(-1)
$Path &= "\"

$SaveFile = FileSaveDialog("Hedef dosya nereye kaydedilecek?", "", "Word (*.doc)|Tüm dosyalar(*.*)", 18, $FileName)
If @error Then FatalError(-2)

While $SaveFile = $Path & $FileName
	MsgBox(32, "Hata", "Hedef dosya kaynak klasör içinde olamaz. Lütfen farklý bir konuma kaydetmeyi deneyin.")
	$SaveFile = FileSaveDialog("Hedef dosya nereye kaydedilecek?", "", "Word (*.doc)|Tüm dosyalar(*.*)", 18, $FileName)
	If @error Then FatalError(-2)
	$FileName = StringMid($SaveFile, StringInStr($SaveFile, "\", 1, -1) + 1)
WEnd

If StringRight($SaveFile, 4) <> ".doc" Then $SaveFile &= ".doc"
If StringRight($FileName, 4) <> ".doc" Then $FileName &= ".doc"

If _FileCreate($SaveFile) <> 1 Then FatalError(-3, "ÝÞLEM TAMAMLANAMADI. Hedef dosya açýlamýyor: " & StringTrimRight($FileName, 4))
If ExecuteWord($SaveFile) <> 1 Then FatalError(-4, "ÝÞLEM TAMAMLANAMADI. Microsoft Word açýlamýyor")

$Header = $FileName & " - Microsoft Word"
WinWaitActive($Header, "", 5000)
If WinActivate($Header) = 0 Then FatalError(-5, "ÝÞLEM TAMAMLANAMADI. Pencere etkinleþtirilemiyor: " & StringTrimRight($FileName, 4))
WinWaitActive($Header)

$src = FileFindFirstFile($Path & "\*.doc")
While 1
	Local $file = FileFindNextFile($src)
	If @error = -1 Then ExitLoop
	
	If ExecuteWord($Path & $file) <> 1 Then ContinueLoop Error("MS Word açýlamýyor: " & StringTrimRight($file, 4))
	$HeaderTmp = $file & " - Microsoft Word"
	
	WinWaitActive($HeaderTmp, "", 5000)
	If WinActivate($HeaderTmp) = 0 Then ContinueLoop Error("Pencere etkinleþtirilemiyor: " & StringTrimRight($file, 4))
	WinWaitActive($HeaderTmp)
	
	Send_WinWaitActive("^a", $HeaderTmp)
	Send_WinWaitActive("^c", $HeaderTmp)
	SendKeepActive($HeaderTmp)
	Send("^w")
	WinWaitClose($HeaderTmp)
	
	If WinActivate($Header) = 0 Then ContinueLoop Error("Pencere etkinleþtirilemiyor: " & StringTrimRight($FileName, 4))
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
	Error("ÝÞLEM TAMAMLANAMADI. Pencere etkinleþtirilemiyor: " & StringTrimRight($FileName, 4))
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
		MsgBox(32, "DOC Birleþtirici", "DOC Birleþtirici iþinin bitirdi!")
	ElseIf $Errors <> "" Then
		MsgBox(32, "DOC Birleþtirici", "Program boyunca þu hatalar oluþtu:" & @CR & @CR & $Errors)
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