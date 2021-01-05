#include <InetConstants.au3>
#include <Misc.au3>
#NoTrayIcon

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

Func _RoundDown($nVar, $iCount)
    Return Round((Int($nVar * (10 ^ $iCount))) / (10 ^ $iCount), $iCount)
EndFunc

Func _getSubDirName($i)
	If $i < 1000 Then
		Return("1-1000")
	ElseIf $i < 10000 Then
		Return (_RoundDown(($i / 1000), 0) & "000-" & (_RoundDown(($i / 1000), 0)+1) & "000")
	ElseIf $i < 100000 Then
		Return (_RoundDown(($i / 1000), 0) & "K-" & (_RoundDown(($i / 1000), 0)+1) & "K")
	ElseIf $i < 1000000 Then
		Return (_RoundDown(($i / 1000), 0) & "M-" & (_RoundDown(($i / 1000), 0)+1) & "M")
	Else
		Return ""
	EndIf
EndFunc

Func _Exit()
	MsgBox(0, "AutoIt Attachment", "Aborted.")
	Exit
EndFunc

If _Singleton("AutoIt-Attachment", 1) = 0 Then
	MsgBox(0, "AutoIt Attachment", "The script already running")
	Exit
EndIf

Local $iStart = Number(IniRead("config.ini", "General", "Start", "0"))
Local $iLen = Number(IniRead("config.ini", "General", "Length", "10"))
Local Const $sBaseUrl = "https://www.autoitscript.com/forum/applications/core/interface/file/attachment.php?id="

For $i = $iStart To $iStart + $iLen
	Local $sDirName = @ScriptDir & "\Attachments\" & _getSubDirName($i) & "\" & $i
	DirCreate($sDirName)
	Local $sBaseName = HTTPFileName($sBaseUrl & $i)
	If @error Then $sBaseName = $i
	Local $sFilePath = $sDirName & "\" & $sBaseName
	Local $hDownload = InetGet($sBaseUrl & $i, $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
	Do
		Sleep(250)
	Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)
	InetClose($hDownload)

	If Not DirGetSize($sDirName, 1)[1] And Not DirGetSize($sDirName, 1)[2] Then
		DirRemove($sDirName)
	Else
		RunWait("git add .", @ScriptDir, @SW_HIDE)
		RunWait("git commit -m ""add " & $sBaseName & """ -m ""From the link: " & $sBaseUrl & $i & """", @ScriptDir, @SW_HIDE)
	EndIf

	IniWrite("config.ini", "General", "Start", $i + 1)
Next

MsgBox(0, "AutoIt Attachment", "Done. (" & $iStart & " - " & ($iStart + $iLen) & ")")
