#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.12.0
	Author:         Muhammed DEMÝRBAÞ
	
	::: Script Function:
	Using Microsoft Word, merges DOC files in a specified folder
	adding to end of another DOC file
	
	::: Return Codes:
	0	Success
	-1	Canceled "Choose source folder" dialog
	-2	Canceled "Choose destination file" dialog
	-3	Microsoft Word Application couldn't be started
	-4	Destination file coulnd't be opened or created
	
	::: Remarks
	If
	
#ce ----------------------------------------------------------------------------

#include <Word.au3> ; for _Word* functions
#include <File.au3> ; for _FileWriteLog function

; Global strings
Dim $agStrings[2][26]

$LangTR = 1
$LangEN = 0
$LNG = $LangTR ; SELECT YOUR LANGUAGE

$agStrings[$LangTR][00] = "DOC Ulayýcý 1.0"
$agStrings[$LangTR][01] = "Program baþladý"
$agStrings[$LangTR][02] = "Birleþtirilecek wordleri içeren klasör?"
$agStrings[$LangTR][03] = "Kaynak klasör: "
$agStrings[$LangTR][04] = "Hedef dosya nereye kaydedilecek?"
$agStrings[$LangTR][05] = "Tüm dosyalar"
$agStrings[$LangTR][06] = $agStrings[$LangTR][00] & " - Hata"
$agStrings[$LangTR][07] = "Hedef dosya kaynak klasör içinde olamaz. Lütfen farklý bir konuma kaydetmeyi deneyin."
$agStrings[$LangTR][08] = "Hedef dosya  : "
$agStrings[$LangTR][09] = "HATA! winword.exe'yi baþlatma baþarýsýz!"
$agStrings[$LangTR][10] = "HATA! Hedef dosyayý açma baþarýsýz!"
$agStrings[$LangTR][11] = "HATA! Dosya açýlamadý: "
$agStrings[$LangTR][12] = "Dosya açýldý: "
$agStrings[$LangTR][13] = "HATA! Pencereye geçme baþarýsýz: "
$agStrings[$LangTR][14] = "HATA! Dosyayý kapatma baþarýsýz: "
$agStrings[$LangTR][15] = "Kaydedildi"
$agStrings[$LangTR][16] = "Klasörün taranmasý bitti: "
$agStrings[$LangTR][17] = "HATA! Hedef dosyayý kaydetme baþarýsýz: "
$agStrings[$LangTR][18] = "HATA! Hedef dosyayý kapatma baþarýsýz: "
$agStrings[$LangTR][19] = "HATA! winword.exe'yi sonlandýrma baþarýsýz!"
$agStrings[$LangTR][20] = "Ýþlem tamamlandý."
$agStrings[$LangTR][21] = ">>> SON >>>"
$agStrings[$LangTR][22] = ">>> ERKEN SONLANDIRMA >>>"
$agStrings[$LangTR][23] = "Açýldý (1/3)"
$agStrings[$LangTR][24] = "Ulandý (2/3)"
$agStrings[$LangTR][25] = "Kaydedildi (3/3)"
$agStrings[$LangEN][00] = "DOC Merger 1.0"
$agStrings[$LangEN][01] = "Program started"
$agStrings[$LangEN][02] = "Where is the folder that contains doc's to merge?"
$agStrings[$LangEN][03] = "Source folder selected: "
$agStrings[$LangEN][04] = "Where will the destination file be saved?"
$agStrings[$LangEN][05] = "All files"
$agStrings[$LangEN][06] = $agStrings[$LangEN][00] & " - Error"
$agStrings[$LangEN][07] = "Destination file couldn't be inside source folder. Please try to save to a different place."
$agStrings[$LangEN][08] = "Destination file selected: "
$agStrings[$LangEN][09] = "ERROR! Starting winword.exe failed"
$agStrings[$LangEN][10] = "ERROR! Opening destination file failed"
$agStrings[$LangEN][11] = "ERROR! File couldn't be opened: "
$agStrings[$LangEN][12] = "File opened: "
$agStrings[$LangEN][13] = "ERROR! Attaching to window failed: "
$agStrings[$LangEN][14] = "ERROR! Closing the file failed: "
$agStrings[$LangEN][15] = "Saved"
$agStrings[$LangEN][16] = "Scanning the folder finished: "
$agStrings[$LangEN][17] = "ERROR! Saving the destination file failed: "
$agStrings[$LangEN][18] = "ERROR! Closing the destination file failed: "
$agStrings[$LangEN][19] = "ERROR! Failed to terminate winword.exe"
$agStrings[$LangEN][20] = "Process completed."
$agStrings[$LangEN][21] = ">>> END >>>"
$agStrings[$LangEN][22] = ">>> ABORTED >>>"
$agStrings[$LangEN][23] = "Opened (1/3)"
$agStrings[$LangEN][24] = "Merged (2/3)"
$agStrings[$LangEN][25] = "Saved (3/3)"

$sLogPath = @ScriptDir & "\DOCUlayici_Log.txt"
$sDestFileName = "Birleþtirilmiþ.doc"
$sDestFilePath = @ScriptDir & "\" & $sDestFileName

_FileWriteLog($sLogPath, "================================================================================")
_FileWriteLog($sLogPath, $agStrings[$LNG][01])

; Ask folder that contains documents to merge
$sSourceFolder = FileSelectFolder($agStrings[$LNG][02], "", 5, @ScriptDir)
If @error Then Exit -1

If StringRight($sSourceFolder, 1) <> "\" Then $sSourceFolder &= "\"

_FileWriteLog($sLogPath, $agStrings[$LNG][03] & $sSourceFolder)

; Ask destination file
$sDestFilePath = FileSaveDialog($agStrings[$LNG][04], "", "Word (*.doc)|" & $agStrings[$LNG][05] & "(*.*)", 2, $sDestFileName)
If @error Then Exit -2

; $sDestFilePath can not be in $sSourceFolder folder
While $sDestFilePath = $sSourceFolder & $sDestFileName
	MsgBox(32, $agStrings[$LNG][06], $agStrings[$LNG][07])

	$sDestFilePath = FileSaveDialog($agStrings[$LNG][04], "", "Word (*.doc)|" & $agStrings[$LNG][05] & "(*.*)", 2, $sDestFileName)
	If @error Then Exit -2

	$sDestFileName = StringMid($sDestFilePath, StringInStr($sDestFilePath, "\", 1, -1) + 1)
WEnd

; Add .doc extension if it is necessary
If StringRight($sDestFilePath, 4) <> ".doc" Then
	$sDestFilePath &= ".doc"
	$sDestFileName &= ".doc"
EndIf

_FileWriteLog($sLogPath, $agStrings[$LNG][08] & $sDestFilePath)

; Start winword
$oDestWordApp = _WordCreate("", 0, 0, 0)
If @error Then
	_FileWriteLog($sLogPath, $agStrings[$LNG][09])
	Exit -3
EndIf

; Open destination file in winword
$oDestWordDoc = _WordDocOpen($oDestWordApp, $sDestFilePath, 0, 0, 0, 1, 0)
If @error Then
	_FileWriteLog($sLogPath, $agStrings[$LNG][10])
	_WordQuit($oDestWordApp, 0)
	Exit -4
EndIf

; Scan folder and process all doc files
$hSearchHandle = FileFindFirstFile($sSourceFolder & "*.doc")
$sSourFileName = FileFindNextFile($hSearchHandle)
While Not @error
	$sSourFilePath = $sSourceFolder & $sSourFileName


	; Open current file in winword
	$oSourWordDoc = _WordDocOpen($oDestWordApp, $sSourFilePath, 0, 0, 1, 0, 0)
	If @error Then
		ContinueLoop _FileWriteLog($sLogPath, $agStrings[$LNG][11] & $sSourFileName)
	Else
		_FileWriteLog($sLogPath, $agStrings[$LNG][12] & $sSourFileName)
	EndIf

	TrayTip($agStrings[$LNG][00], $sSourFileName & @CR & $agStrings[$LNG][23], 10, 16)

	; Go to end of SaveFile and paste data
	$oSourWordApp = _WordAttach($sSourFileName, "FileName")
	If @error Then ContinueLoop _FileWriteLog($sLogPath, $agStrings[$LNG][13] & $sSourFileName)

	; Select all text and copy to clipboard
	$oSourWordApp.Selection.WholeStory
	$oSourWordApp.Selection.Copy

	; Close current file
	_WordDocClose($oSourWordDoc, 0)
	If @error Then ContinueLoop _FileWriteLog($sLogPath, $agStrings[$LNG][14] & $sSourFileName)

	; Attach to DestFile
	$oDestWordApp = _WordAttach($sDestFileName, "FileName")
	If @error Then ContinueLoop _FileWriteLog($sLogPath, $agStrings[$LNG][13] & $sDestFileName)

	; Go to end of DestFile and paste data
	$oDestWordApp.Selection.EndKey(6)
	$oDestWordApp.Selection.Paste

	TrayTip($agStrings[$LNG][00], $sSourFileName & @CR & $agStrings[$LNG][24], 10, 16)

	; Try to save destinaton file after changing for each source file
	If _WordDocSave($oDestWordDoc) = 1 Then _FileWriteLog($sLogPath, $agStrings[$LNG][15])

	TrayTip($agStrings[$LNG][00], $sSourFileName & @CR & $agStrings[$LNG][25], 10, 16)

	; Get next file from folder
	$sSourFileName = FileFindNextFile($hSearchHandle)
WEnd
FileClose($hSearchHandle)

_FileWriteLog($sLogPath, $agStrings[$LNG][16] & $sSourceFolder)

; Save changes without taking to care if it is saved before or not
If _WordDocSave($oDestWordDoc) = 1 Then
	_FileWriteLog($sLogPath, $agStrings[$LNG][15])
Else
	_FileWriteLog($sLogPath, $agStrings[$LNG][17] & $sDestFileName)
EndIf

; Close destination file and quit word
_WordDocClose($oDestWordDoc, -1, 0)
If @error Then _FileWriteLog($sLogPath, $agStrings[$LNG][18] & $sDestFileName)

_WordQuit($oDestWordApp)
If @error Then _FileWriteLog($sLogPath, $agStrings[$LNG][19])

MsgBox(32, $agStrings[$LNG][00], $agStrings[$LNG][20])
Exit 0

Func OnAutoItExit()
	Local $StrNum = 22
	If (@exitMethod = 0 Or @exitMethod = 1) And @exitCode = 0 Then $StrNum = 21
	_FileWriteLog($sLogPath, $agStrings[$LNG][$StrNum])
	_FileWriteLog($sLogPath, "")
EndFunc   ;==>OnAutoItExit