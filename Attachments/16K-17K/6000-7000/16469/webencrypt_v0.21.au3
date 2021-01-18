#include <String.au3>
#include <IE.au3>
#Include <Constants.au3>
#NoTrayIcon

Global $title = "Cyber's encryptweb v0.21"



$return = MsgBox(3, $title, "The webpage is a URL? Press no for file, cancel for blank page")

if $return = 6 Then
	$spasstemp = InputBox($title, "Insert URL")
ElseIf $return = 2 Then
	
Else
	$url = FileOpenDialog("",@ScriptDir,"All (*.*)")
EndIf

if $return <> 2 Then
	Global $s_EncryptPassword = InputBox($title, "Write the decrypt/encrypt password","","*")
	Global $oIE = _IECreate($url, 1)
Else
	Global $s_EncryptPassword = ""
	Global $oIE = _IECreate()
	_IEDocWriteHTML($oIE, _getTemplate())
EndIf



;~ _IEPropertySet ( $oIE, "title", $title)

;~ MsgBox(0,_IEPropertyGet ( $oIE, "locationurl"),_IEPropertyGet ( $oIE, "busy"))

$old = ""



Global $enc_act = 1

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.

$actchange   = TrayCreateItem("Auto Decrypting")
if $return <> 2 then
	TrayItemSetState(-1, $TRAY_CHECKED)
Else
	$enc_act = 0
EndIf

TrayCreateItem("")
$manual = TrayCreateMenu("Manual")
$man_dec = TrayCreateItem("Decrypt", $manual)
$man_enc = TrayCreateItem("Encrypt", $manual)
TrayCreateItem("")
$save = TrayCreateMenu("Save page")
$sav_dec = TrayCreateItem("Decrypt", $save)
$sav_enc = TrayCreateItem("Encrypt", $save)
TrayCreateItem("")
$exititem       = TrayCreateItem("Exit")

TraySetState()

$diablecount = 0
While 1
	
	if _IEPropertyGet ( $oIE, "readystate")= 0 Then
		$diablecount += 1
	Else
		$diablecount = 0
	EndIf
	
	if $diablecount = 10 Then
		TrayTip($title, "Explorer is terminated",1)
		Sleep(3000)
		
		for $i=3 to 1 step -1
			TrayTip($title, "Exiting: " & $i, 1)
			Sleep(1000)
		Next
		Exit
	EndIf
	
	
	
	if _IEPropertyGet ( $oIE, "locationurl") <> $old AND $enc_act = 1 Then
		_decript()
	EndIf
	
	
	
	
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
        Case $msg = $actchange

			if TrayItemGetState($actchange) = 68 Then
;~ 				MsgBox(0,"","U")
				$enc_act = 1
				TrayItemSetState($actchange, $TRAY_CHECKED)
			Elseif TrayItemGetState($actchange) = 65 Then
;~ 			MsgBox(0,"","C")
				$enc_act = 0
				TrayItemSetState($actchange, $TRAY_UNCHECKED)
			EndIf
		Case $msg = $sav_enc
			_save(1)
		Case $msg = $sav_dec
			_save(0)
        Case $msg = $man_dec
			_decript()
		Case $msg = $man_enc
			_encript()
        Case $msg = $exititem
            ExitLoop
	EndSelect
	

	
	
WEnd


Func _save($enc)
	if $enc = 1 Then
		$sHTML = _IEDocReadHTML ($oIE)
		
		
		
		
		
		if $s_EncryptPassword = "" OR MsgBox(260, $title, "Change encrypt password?") = 6 Then
			$sTemp = InputBox($title, "Write new password","","*")

		Else
			$sTemp = $s_EncryptPassword
		EndIf
		

		$files = FileSaveDialog("",@ScriptDir, "All (*.*)")
		_IEDocWriteHTML($oIE, "<h3>Encrypting in progress.....</h3>")
		
		
		$ex =_StringEncrypt ( 1, $sHTML, $sTemp)
		
		$file = FileOpen($files, 2)

		FileWrite($file, $ex)

		FileClose($file)
		
		_IEDocWriteHTML($oIE, $sHTML)
	Else
		$sHTML = _IEDocReadHTML ($oIE)
;~ 		MsgBox(0,"",$sHTML)
		$files = FileSaveDialog("",@ScriptDir, "All (*.*)")

		$file = FileOpen($files, 2)

		FileWrite($file, $sHTML)

		FileClose($file)
	EndIf
EndFunc

Func _decript()
	
	
	if $s_EncryptPassword = "" Then
		Global $s_EncryptPassword = InputBox($title, "Write new password","","*")
	EndIf
	
	
	
	$sHTML = _IEDocReadHTML ($oIE)
;~ 	MsgBox(0,"",$sHTML)
		$sHTML = StringReplace($sHTML, "<html>","")
		$sHTML = StringReplace($sHTML, "</html>","")
		$sHTML = StringReplace($sHTML, "<body>","")
		$sHTML = StringReplace($sHTML, "</body>","")
		$sHTML = StringReplace($sHTML, "<head>","")
		$sHTML = StringReplace($sHTML, "</head>","")
		;~ $sHTML = StringMid($sHTML, 1, StringLen($sHTML)-2)
		$sHTML = StringMid($sHTML, 3)

;~ 	MsgBox(0,"",$sHTML)	

		_IEDocWriteHTML($oIE, "<h3>Decrypting in progress.....</h3>")

		$ex =_StringEncrypt ( 0, $sHTML, $s_EncryptPassword)
		;~ MsgBox(0,StringLen($exX) & " " & StringLen($sHTML), $exX & @CRLF & "|" & $sHTML & "|")
		;~ MsgBox(0,"",$ex)

		_IEDocWriteHTML($oIE, $ex)
		
		$old = _IEPropertyGet ( $oIE, "locationurl")
EndFunc


Func _encript()
	
	
	$sHTML = _IEDocReadHTML ($oIE)
		_IEDocWriteHTML($oIE, "<h3>Encrypting in progress.....</h3>")

		$ex =_StringEncrypt ( 1, $sHTML, $s_EncryptPassword)
		;~ MsgBox(0,StringLen($exX) & " " & StringLen($sHTML), $exX & @CRLF & "|" & $sHTML & "|")
		;~ MsgBox(0,"",$ex)

		_IEDocWriteHTML($oIE, $ex)
		
		$old = _IEPropertyGet ( $oIE, "locationurl")
EndFunc
	


Func _getTemplate()

Return "<h2>" & $title & "</h2>	<br>	<h3>Encrypt a webpage</h3>	<dir>	<li>Enter an URL in the addressbar and press return	<li>If you want encrypt this page, click on ""Cyber's encryptweb"" icon on traybar	<li>select <i>Save page</i> -> <i>Encrypt</i>	<li>write a password for encoding and the location of new file	<li>encrypt IT!	</dir>	<br>	<h3>Decrypt (and view) a webpage</h3>	<dir>	<li>Enter an URL in the addressbar and press return (local file is accepted)	<li>if the website is encrypted, click on ""Cyber's encryptweb"" icon on traybar	<li>now you can activate the autodecrypter, press on ""Auto decrypt""	<li>or you can decrypt the page manually, press on <i>Manual</i> -> <i>Decrypt</i>	<li>Read IT!	</dir>	<br><br><br><b>by col Cyber</b>"


EndFunc
