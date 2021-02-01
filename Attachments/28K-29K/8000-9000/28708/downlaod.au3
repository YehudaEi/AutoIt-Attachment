#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#Include <Constants.au3>
#NoTrayIcon

Opt('MustDeclareVars', 1)

Local $progressbar1,$var,$String,$String2,$var2,$hex,$SRando,$show,$msc,$Sleep,$Statu, $sdf,$sdf2,$URLFile, $saveas, $size, $begin, $s ,$GetActive ,$dif ,$o , $Timer , $FileSize , $Downloading ,$Progress ,$i , $percent ,$Cal ,$p ,$e, $Speed ,$sr ,$y , $timeleft,$ET,$KBLeft,$T,$r,$bak


While $String <= 0
$bak = ClipGet()
$URLFile = InputBox("Download Manager", "URL File to Download", $bak, "")
If @Error = 1 Then
    MsgBox(0, "Error", "You sure you want Exit.")
	Exit
EndIf
	$String = StringInStr ($URLFile,"http://") Or StringInStr ($URLFile,"ftp://")
If  $String = 0 Then
MsgBox(0, "Error", "You didn't enter any URL in Box Try again.")
EndIf
WEnd
$var =  StringRight($URLFile,5)
$var2 = Random (0,10000,1)
$saveas = InputBox("Download Manager", "Save As..... ", "D:\" & $var2 & $var , "")
If @Error = 1 Then
	MsgBox(0, "Error", "You sure you want Exit.")
	    Exit
	$String2 = StringInStr ($saveas,":\")
ElseIf  @Error = 0 Then
MsgBox(0, "Error", "You File Will Be Save in : " & @ScriptDir & "\" & $saveas )
	EndIf
$size  =  InetGetSize($URLFile)
$begin = TimerInit()
$s = Int ($size / 1024)
$msc = InetGet($URLFile, $saveas , 1, 1)




	GUICreate("Downlaod Manager", 320, 155)
$Progress = GUICtrlCreateProgress(10, 5, 300, 20, $PBS_SMOOTH)
$FileSize =	   GUICtrlCreateLabel("File Size (KB) :", 10, 30, 200, 30) ; first cell 70 width
$Downloading = GUICtrlCreateLabel("Downloading (KB) :", 10, 45, 200, 30) ; next line
$Timer  =	   GUICtrlCreateLabel("Timer (Sec) :", 10, 60, 200, 30)
$Cal  =	   GUICtrlCreateLabel("% (Sec) :", 10, 75, 200, 30)
$Speed  =	   GUICtrlCreateLabel("Speed :", 10, 90, 200, 30)
$timeleft  =	   GUICtrlCreateLabel("Expectant Time In :", 10, 105, 200, 30)
$ET  =	   GUICtrlCreateLabel("Time Left :", 10, 120, 200, 30)
$KBLeft  =	   GUICtrlCreateLabel("KB Left :", 10, 135, 200, 30)
$Statu = GUICtrlCreateLabel("State",180, 40, 300, 70)

	           GUISetState()

If $msc = 0 Then
	$sdf = "Could not connect" & @CRLF & "to web server." & @CRLF & "Failed download file" & @CRLF & "will Try again Now."
Else
	$sdf2 = "scfull connect to web server." & @CRLF & " Downloading File Now"
EndIf

While @InetGetActive

$GetActive = (@InetGetBytesRead / 1024)
$percent = ($GetActive / $s ) *100
$dif = TimerDiff($begin)
$p = Int ($percent)
$o = Round ($dif / 1000 , 2)
$e = Int ($GetActive / $o)
$y = Round ( ($s / ($e * 60)) ,2  )
$r = Int ( $T / $e)
$T = Int  (( $size - @InetGetBytesRead ) /1024)
$show  = Hex($GetActive, 2)

GUICtrlSetData($Progress, $percent)
GUICtrlSetData($FileSize , "File Size :" & $s & " KB" )
GUICtrlSetData($Downloading , "Downloading :" & $GetActive & " KB" )
GUICtrlSetData($Timer ,"Timer :" & $o & " Sec" )
GUICtrlSetData($Cal ,"Complete :" & $p & " %" )
GUICtrlSetData($Speed , "Speed :" & $e  & " Kb/Sec")
GUICtrlSetData($ET , "Expectant Time In :" & $y  & " Min")
GUICtrlSetData($timeleft , "Time Left :" & $r  & " Sec")
GUICtrlSetData($KBLeft , "KB Left :" & $T   & " KB")
GUICtrlSetData($Statu , $sdf & $sdf2 & @CRLF & $show )
Sleep (500)

WEnd

$dif = TimerDiff($begin)
MsgBox(4096, "Download Complete", "URL :" & $URLFile & @CRLF & "Save As :" & $saveas & @CRLF & "File Size (KB) :" & $s & @CRLF & "Time to finish (Sec) :" & $o)
