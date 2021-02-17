#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.6.1
 Author:         chiller

 Script Function:
	FTP Upload tool
#ce ----------------------------------------------------------------------------
#include <FTP.au3>
#include <FTPEx.au3>
#include <Array.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>

$width = '500'
$height = '250'
$FileOrFolder = 'nd'
;MsgBox(4, "", $FileOrFolder) ;testeintrag
$server = InputBox("FTP Server", "Bitte den gewünschten FTP Server angeben (z.B. hillercn.homedns.org):", "10.50.21.108", "", $width, $height) ;Eingabe der FTP Server URL
if @error = '1' Then Exit
$ftpuser = InputBox("FTP Benutzernamen", "Geben Sie Ihren FTP Benutzernamen ein (z.B. chiller):", "Administrator", "", $width, $height) ; Eingabe des FTP Benutzers
if @error = '1' Then Exit
$ftppw = InputBox("FTP Passwort", "Bitte geben Sie Ihr FTP Passwort ein:", "", "*", $width, $height) ; Eingabe des FTP Passworts
if @error = '1' Then Exit
$message = "Ctrl oder Shift drücken um mehrere Dateien zu markieren"

;While $FileOrFolder Not "datei" Or $FileOrFolder Not "Datei" Or $FileOrFolder Not "verzeichnis" Or $FileOrFolder Not "Verzeichnis"
; $FileOrFolder = InputBox("Datei(en) oder Verzeichnis hochladen?", "Geben Sie das Wort 'Datei' bzw. 'Verzeichnis' ein:", "Datei", "", $width, $height)
; MsgBox(4, "", $FileOrFolder) ;testeintrag
;WEnd

Opt('MustDeclareVars', 1)
;Example()
;Func Example()
	Local $button_1, $group_1, $radio_1, $radio_2, $radio_3
	Local $radioval1, $radioval2, $msg
	Local $auswahl, $message, $datei, $verzeichnis

	Opt("GUICoordMode", 1)
	GUICreate("Was soll übertragen werden?", $width, $height)

	; Create the controls
	$button_1 = GUICtrlCreateButton("&Bestätigen", 30, 190, 120, 40)
	$group_1 = GUICtrlCreateGroup("Auswahl:", 30, 20, $width-60, $height-100)
	GUIStartGroup()
	$radio_1 = GUICtrlCreateRadio("&Datei(en) (Bild01.jpg, Bild02.jpg, ...)", 50, 50, $width -40, 20)
	$radio_2 = GUICtrlCreateRadio("&Verzeichnis (C:\MeineBilder\)", 50, 80, $width -40, 20)
	$radio_3 = GUICtrlCreateRadio("&Archiv (*.zip, *.rar)", 50, 110, $width -40, 20)


	; Init our vars that we will use to keep track of GUI events
	$radioval1 = 0    ; We will assume 0 = first radio button selected, 2 = last button
	$radioval2 = 2


	GUISetState() ;Zeigt die GUI


	While $msg <> $button_1
		$msg = GUIGetMsg()
		Select
			Case $msg = $button_1
				$auswahl = $radioval1
			Case $msg >= $radio_1 And $msg <= $radio_3
				$radioval1 = $msg - $radio_1
		EndSelect
	WEnd

If $auswahl = "0" Then
	$datei = FileOpenDialog($message, "C:\", "Images (*.jpg;*.bmp;*.png )|Videos (*.avi;*.mpg)", 1 + 4 )
	If @error Then
		MsgBox(4096,"","Fehler: Es wurde keine Auswahl getroffen!")
	Else
		$datei = StringReplace($datei, "|", @CRLF)
		MsgBox(4096,"","Auswahl: " & $datei)
	EndIf
EndIf
If  $auswahl = "1" Then
	$verzeichnis = FileSelectFolder("Verzeichnis auswählen", "")
	If @error Then
		MsgBox(4096, "", "Fehler: Es wurde keine Auswahl getroffen!")
	Else
		MsgBox(4096, "", "Auswahl: " & $verzeichnis)
	EndIf
EndIf
If $auswahl = "2" Then
	$datei = FileOpenDialog("Archiv auswählen", "C:\", "Archiv (*.zip;*rar)", 1)
	If @error Then
		MsgBox(4096,"","Fehler: Es wurde keine Auswahl getroffen!")
	Else
		$datei = StringReplace($datei, "|", @CRLF)
		MsgBox(4096,"","Auswahl: " & $datei)
			$Open = _FTPOpen("MyFTP_Control")
			$Conn = _FTPConnect($Open, $server, $ftpuser, $ftppw)
			$Ftpp = _FtpPutFile($Conn, $datei, $datei)
			$Ftpc = _FTPClose($Open)
	EndIf
EndIf


MsgBox(0, "$auswahl", $auswahl)

;EndFunc   ;==>Example