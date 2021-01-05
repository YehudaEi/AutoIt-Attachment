#include <InetConstants.au3>

HotKeySet("{esc}", "_Exit")

Func HTTPFileName($sUrl)
    $oHTTP = ObjCreate('winhttp.winhttprequest.5.1')
    $oHTTP.Open('POST', $sUrl, 1)
    $oHTTP.SetRequestHeader('User-Agent','YE Project (+https://github.com/YehudaEi/AutoIt-Attachment)')
    $oHTTP.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
    $oHTTP.Send()
    $oHTTP.WaitForResponse
	If ($oHTTP.Status <> 200) Then Return SetError(1, 0, 0)
    $ContentDisposition = StringRegExp($oHTTP.GetResponseHeader("Content-Disposition"), 'filename="(.*)"',3)
    Return $ContentDisposition[0]
EndFunc

Func _Exit()
	MsgBox(0, "AutoIt Attachment", "Aborted.")
	Exit
EndFunc

Local $iStart = Number(IniRead("config.ini", "General", "Start", "0"))
Local $iLen = Number(IniRead("config.ini", "General", "Length", "10"))
Local Const $sBaseUrl = "https://www.autoitscript.com/forum/applications/core/interface/file/attachment.php?id="

For $i = $iStart To $iStart + $iLen
	DirCreate(@ScriptDir & "\" & $i)
	Local $sBaseName = HTTPFileName($sBaseUrl & $i)
	If @error Then $sBaseName = $i
	Local $sFilePath = @ScriptDir & "\" & $i & "\" & $sBaseName
	Local $hDownload = InetGet($sBaseUrl & $i, $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
	Do
		Sleep(250)
	Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)
	InetClose($hDownload)

	If Not DirGetSize(@ScriptDir & "\" & $i, 1)[1] And Not DirGetSize(@ScriptDir & "\" & $i, 1)[2] Then
		DirRemove(@ScriptDir & "\" & $i)
	Else
		RunWait("git add .", @ScriptDir, @SW_HIDE)
		RunWait("git commit -m ""add " & $sBaseName & """ -m ""From the link: " & $sBaseUrl & $i & """", @ScriptDir, @SW_HIDE)
	EndIf

	IniWrite("config.ini", "General", "Start", $i + 1)
Next

MsgBox(0, "AutoIt Attachment", "Done. (" & $iStart & " - " & ($iStart + $iLen) & ")")
