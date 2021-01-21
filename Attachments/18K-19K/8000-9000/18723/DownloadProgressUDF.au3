; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         IronMan_br - ironbot_br@yahoo.com.br
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstants.au3>
#include <file.au3>

_download_progress("DesktopSnow.zip","http://h1.ripway.com/unauth0rized/Manadar/DesktopSnow.zip")
_download_progress("OldStyleBootMenu.zip","http://h1.ripway.com/unauth0rized/Manadar/bootloader/OldStyleBootMenu.zip")
_download_progress("AutoItBanner.zip","http://h1.ripway.com/unauth0rized/Manadar/AutoItBanner.zip")
;Parameters:
;	$filename = (String) Name of downloaded file
;   $fileurl = (String) urf of file
;
;   Return 1 if download is completed
;   Return 0 if get an error

Func _download_progress($filename, $fileurl)

	Global $file_size_bytes = InetGetSize($fileurl)
	Global $file_size = Round($file_size_bytes/1024, 0)	

	$speedMsg = ""
	$timeLeftMsg = ""
	$percentValue = 0

	InetGet($fileurl, $filename, 1, 1)
    $progressW = ProgressOn("Download", "Downloading " & $filename, "")
	While @InetGetActive
		$iniW = TimerInit()
		$iniDown = @InetGetBytesRead
		Sleep(500)
		$msg_downloading = Round((@InetGetBytesRead/1000), 0) & " / " & $file_size & " kb (" & porcentDown($iniDown, $file_size) & " %)" 
		$dif_time = TimerDiff($iniW)/1000
		$dif_bytes = @InetGetBytesRead - $iniDown
		$velocidade = Round((($dif_bytes / $dif_time) / 1000), 0)
		$progressW = ProgressSet($percentValue , $msg_downloading & "   Speed: " & $speedMsg & @CRLF & "Time Left: " & $timeLeftMsg, "Downloading " & $filename)
	  If ($velocidade > 0) Then
			$kb_remains = $file_size - (Round(@InetGetBytesRead/1000))
			$temp_formatado = time_format(time_to_finish($velocidade, $kb_remains))
			$speedMsg = $velocidade & " kbps"
			$timeLeftMsg = $temp_formatado
			$progressW = ProgressSet($percentValue , $msg_downloading & "   Speed: " & $speedMsg & @CRLF & "Time Left: " & $timeLeftMsg, "Downloading " & $filename)
	  EndIf
		If (@InetGetBytesRead = $file_size_bytes) Then 
			$progressW = ProgressSet($percentValue , $msg_downloading & "   Speed: " & $speedMsg & @CRLF & "Time Left: " & $timeLeftMsg, "Downloading " & $filename)
			Global $OK_download = 1
	    EndIf
	Wend
	If $OK_download = 1 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc



func tempo_decorrido()
	$t = TimerDiff($time_inicio)
	$t = Round($t/1000)
	Return time_format($t)
EndFunc

Func time_to_finish($kbps, $tamanho_arquivo)
	Return Round($tamanho_arquivo / $kbps)
EndFunc

Func add_zero($campo, $tamanho)
 	$dif_s = $tamanho - StringLen($campo)
	If $dif_s > 0 Then
		$temp = ""
		For $i = 1 to $dif_s 
			$temp = $temp & "0"
		Next
	    Return $temp & $campo
	Else
		Return $campo
	EndIf
EndFunc

Func time_format($iTicks)
	$hora = Int($iTicks / 3600)
	$iTicks = Mod($iTicks, 3600)
	$minutos = Int($iTicks / 60)
	$iTicks = Mod($iTicks, 60)
	$segundos = Mod($iTicks, 60)

	If $hora = 0 Then
		Return add_zero($minutos, 2) & "m " & add_zero($segundos, 2) & "s"
	Else
		Return add_zero($hora, 2) & "h " & add_zero($minutos, 2) & "m " & add_zero($segundos, 2) & "s"
	EndIf
EndFunc

Func porcentDown($iniDown, $file_size)
    Return Round( (($iniDown/$file_size_bytes)*100) , 0)	
EndFunc


