;~ Title:Vista Sidebar
;~ Desc:To Do List
;~ Author:Unknown
;~ Edited By:LuckyMurari holmes.santosh (at) gmail (dot) com

Global $title = "VisualPinger v0.9" 

#include <WindowsConstants.au3>
#include <Constants.au3>
#include <GuiConstantsEx.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

#include <GUIConstants.au3>
#include <Misc.au3>
If Not _Singleton($title) Then Exit

Opt("TrayIconDebug", 1)         ;0=no info, 1=debug line info





Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)

TrayCreateItem("New Computer")
TrayItemSetOnEvent(-1, "Newcomputer")

TrayCreateItem("New Temporary Computer")
TrayItemSetOnEvent(-1, "tNewcomputer")

TrayCreateItem("")

TrayCreateItem("Close")
TrayItemSetOnEvent(-1, "Term")

Opt("GUIOnEventMode")

Global $i = 0

Global $msgbox[1][5]
$msgbox[0][0] = 0

Global $msgboxPROC[1][5]
$msgboxPROC[0][0] = 0


$filedati = @ScriptDir & "\pcname.dat" 
Global $LARGEHZZA = 200
Global $ALTZZA = 30
Global $SCARTO = 50
Global $speed = 0
Global $pctemp = 0
Global $LARGEHZZAPROC = 150 ;StringLen($text) * 10
Global $ALTZZAPROC = 20


Do
	$file = FileOpen($filedati, 0)
	If $file = -1 Then
		Do
			$tag = InputBox($title, "Unable to open file. Write first computer name", @ComputerName & ": " & @IPAddress1)
			If StringInStr($tag, ":") = 0 Then
				MsgBox(0, $title, "Error... sintax correct:" & @CRLF & "ALIASNAME:ipaddessORhostname")
			EndIf
		Until StringInStr($tag, ":") > 0
		FileWriteLine($filedati, $tag)
		Sleep(1000)
		$file = FileOpen($filedati, 0)
	EndIf
Until $file <> -1

; Read in lines of text until the EOF is reached
$tTool = TimerInit()

$timefile = FileGetTime($filedati)

If $timefile[0] = @YEAR And $timefile[1] = @MON And $timefile[2] = @MDAY Then
	ToolTip("Press ESC for speed up", @DesktopWidth - 150, @DesktopHeight - 50)
EndIf

HotKeySet("{ESC}", "_Speeed")
While 1
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop
;~ 	if StringLeft($line,1) = "~" Then*
;~ 		if StringTrimLeft($line, 1) = "
;~ 	Else
	$id = _createMSG($line)
;~ 	EndIf
	
	If TimerDiff($tTool) > 5000 Then
		ToolTip("", @DesktopWidth, @DesktopHeight)
	EndIf
WEnd

FileClose($file)
HotKeySet("{ESC}")
ToolTip("", @DesktopWidth, @DesktopHeight)

If $timefile[0] = @YEAR And $timefile[1] = @MON And $timefile[2] = @MDAY Then
	For $s = @DesktopWidth - 150 To @DesktopWidth - 200 Step - 1
		Sleep(1)
		ToolTip("Move mouse here and wait-->", $s, @DesktopHeight - 15)
	Next
	For $s = @DesktopWidth - 200 To @DesktopWidth - 150 Step 1
		Sleep(1)
		ToolTip("Move mouse here and wait-->", $s, @DesktopHeight - 15)
	Next
;~ 	Sleep(5000)
	For $s = @DesktopWidth - 150 To @DesktopWidth - 200 Step - 1
		Sleep(1)
		ToolTip("Move mouse here and wait-->", $s, @DesktopHeight - 15)
	Next
	For $s = @DesktopWidth - 200 To @DesktopWidth - 150 Step 1
		Sleep(1)
		ToolTip("Move mouse here and wait-->", $s, @DesktopHeight - 15)
	Next
	For $s = @DesktopWidth - 150 To @DesktopWidth - 200 Step - 1
		Sleep(1)
		ToolTip("Move mouse here and wait-->", $s, @DesktopHeight - 15)
	Next
	For $s = @DesktopWidth - 200 To @DesktopWidth - 150 Step 1
		Sleep(1)
		ToolTip("Move mouse here and wait-->", $s, @DesktopHeight - 15)
	Next
	Sleep(1000)
	
	ToolTip("", @DesktopWidth - 150, @DesktopHeight - 150)
EndIf

;~ $id = _createMSG("Laura: SC0004842")
;~ $id = _createMSG("Rossana: SC000481a")
;~ $id = _createMSG("Filippo: SC000484D")
;~ $id = _createMSG("Roberto: SC0004862")
;~ $id = _createMSG("Federica: SC0004893")
;~ $id = _createMSG("ExtPC1: SC008790a")
;~ $id = _createMSG("ExtPC2: SC008790b")
;~ $id = _createMSG("ExtPC3: Sc0004816")

;~ $id = _createMSG("ExtPC1: lc008790a")
;~ $id = _createMSG("ExtPC2: lc008790b")
;~ $id = _createMSG("ExtPC3: lc004816")


While 1
;~ 	_MovWinSingle($id)
;~ 	Sleep(5000)
;~ 	$tt = TimerInit()
	_MovWinAll()
;~ 	MsgBox(0,"",TimerDiff($tt))
;~ 	$tt = TimerInit()
	_refreshAll()
;~ 	MsgBox(0,"",TimerDiff($tt))
;~ 	Sleep(10000)
WEnd

Func _Speeed()
	If $speed = 0 Then
		$speed = 1
	Else
		$speed = 0
	EndIf
EndFunc   ;==>_Speeed




Func _createMSG($text)
;~ 	MsgBox(0,"",$msgbox[0][0])
	
	If $msgbox[0][0] > 0 Then
		
		Do
			$cf = 0
			$vertical = Random(0, @DesktopHeight - $SCARTO, 100)
			For $j = 1 To $msgbox[0][0]
				$ptemp = WinGetPos($msgbox[$j][0])
				
				If $vertical >= $ptemp[1] - 30 And $vertical <= $ptemp[1] + $ptemp[3] Then
					$cf = 1
					ExitLoop
				EndIf
			Next
		Until $cf = 0
	Else
		$vertical = Random(0, @DesktopHeight - 30, 1)
	EndIf
	
	
	$msgbox[0][0] = $msgbox[0][0] + 1
	ReDim $msgbox[$msgbox[0][0] + 1][5]
;~ 	MsgBox(0,"",Random(0,@DesktopHeight - 30,1))
	
	
	
	
;~ 	$msgbox[$msgbox[0][0]][0] = GUICreate(TimerInit(),$LARGEHZZA,30,@DesktopWidth,$vertical,$WS_POPUP,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST );+$WS_DISABLED
	$msgbox[$msgbox[0][0]][0] = GUICreate(TimerInit(), $LARGEHZZA, $ALTZZA, @DesktopWidth - $LARGEHZZA, @DesktopHeight - $ALTZZA - $SCARTO, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST);+$WS_DISABLED
	
	GUISetBkColor(0)

	
	
	
	If StringInStr($text, ":") = 0 Then
		$pctemp += 1
		$text = "Temporary(" & $pctemp & "):" & $text
	EndIf
	
	$text = StringStripWS($text, 8)
	$data = StringSplit($text, ":")
	$ip = StringStripWS($data[2], 8)
	
	$msgbox[$msgbox[0][0]][1] = GUICtrlCreateLabel($data[1] & " Ping...", 0, 0, 200, 30)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($msgbox[$msgbox[0][0]][1], 12, 500)
	GUISetState(@SW_SHOWNA)
	WinSetTrans($msgbox[$msgbox[0][0]][0], "", 150)
	
	
	$r = Ping($ip, 50)
;~ 	MsgBox(0,$text & ": " & $r,@error)
;~ 	$tim= TimerInit()
	$msgbox[$msgbox[0][0]][1] = GUICtrlCreateLabel($text, 0, 0, 200, 30)
	$msgbox[$msgbox[0][0]][4] = $data[1]
	GUICtrlSetFont($msgbox[$msgbox[0][0]][1], 12, 500)
	If $r = 0 Then
		$msgbox[$msgbox[0][0]][2] = 0
		GUICtrlSetColor(-1, 0xFF0000)
	Else
		$msgbox[$msgbox[0][0]][2] = 1
		GUICtrlSetColor(-1, 0x00FF00)
	EndIf
;~ 	MsgBox(0,$text,$r & @CRLF & Round(TimerDiff($tim)/1000,4))
	$msgbox[$msgbox[0][0]][3] = $ip
;~ 	MsgBox(0,$ip,$r)


	
;~ 	MsgBox(0,"",$msgbox[0][0])
	$varT = 1
	$mexxT = 0
	For $xv = @DesktopHeight - $ALTZZA - $SCARTO To $vertical Step - 2
		WinMove($msgbox[$msgbox[0][0]][0], "", @DesktopWidth - $LARGEHZZA, $xv)
		If $xv - 50 <= $vertical Then
			If $speed = 0 Then
				Sleep(50)
			EndIf
		Else
			If $mexxT = 2 Then
				If $speed = 0 Then
					Sleep($varT)
				EndIf
				$mexxT = 0
			Else
				$mexxT += 1
			EndIf
		EndIf
		
;~ 		Sleep($varT)
	Next
	If $speed = 0 Then
		Sleep(500)
	EndIf
	For $xv = @DesktopWidth - $LARGEHZZA To @DesktopWidth Step 2
		WinMove($msgbox[$msgbox[0][0]][0], "", $xv, $vertical)
		If $speed = 0 Then
			Sleep(2)
		EndIf
	Next
	
	Return $msgbox[0][0]
EndFunc   ;==>_createMSG


Func _createProcessMSG($text, $mem, $MAXMEM, $procname)
	
	
	
;~ 	$LARGEHZZAPROC = 100

	$val = Round(((@DesktopHeight - $ALTZZAPROC - 50) * $mem) / $MAXMEM)
	
;~ 	MsgBox(0,$mem & " - " & $val,$MAXMEM)
	
	If $msgboxPROC[0][0] > 0 Then
		$try = 0
		Do
			$try += 1
			$cf = 0
;~ 			$vertical = Random(0,@DesktopHeight - 50,1)
			$vertical = $val + (Round($try)) ;Random($val+200,$val + 400,1)
			$orizzontal = Random(0, @DesktopWidth - $LARGEHZZAPROC - $LARGEHZZA, 1)
;~ 				if $orizzontal + $LARGEHZZAPROC <= @DesktopWidth  Then
			For $j = 1 To $msgboxPROC[0][0]
				$ptemp = WinGetPos($msgboxPROC[$j][0])
				
;~ 						$array[0] = X position
;~ 						$array[1] = Y position
;~ 						$array[2] = Width
;~ 						$array[3] = Height

				If $vertical >= $ptemp[1] - $ptemp[3] And $vertical <= $ptemp[1] + $ptemp[3] And $orizzontal >= $ptemp[0] - $ptemp[2] And $orizzontal <= $ptemp[0] + $ptemp[2] Then
;~ 						if $vertical >= $ptemp[1] + $ptemp[3] Then; AND $vertical <= $ptemp[1] AND $orizzontal >= $ptemp[0] + $LARGEHZZAPROC AND $orizzontal <= $ptemp[0] Then
					$cf = 1
					ExitLoop
				EndIf
			Next
;~ 				EndIf
		Until $cf = 0
	Else
;~ 		$vertical = Random(0,@DesktopHeight - 50,1)
;~ 		$orizzontal = Random(0,@DesktopWidth-$LARGEHZZAPROC- $LARGEHZZA,1)
		$vertical = $val ;Random($val+200,$val + 400,1)
		$orizzontal = Random(0, @DesktopWidth - $LARGEHZZAPROC - $LARGEHZZA, 1)
	EndIf
	
	
	$msgboxPROC[0][0] = $msgboxPROC[0][0] + 1
	ReDim $msgboxPROC[$msgboxPROC[0][0] + 1][5]
;~ 	MsgBox(0,"",Random(0,@DesktopHeight - 30,1))
	
	
	
	
;~ 	$msgbox[$msgbox[0][0]][0] = GUICreate(TimerInit(),$LARGEHZZA,30,@DesktopWidth,$vertical,$WS_POPUP,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST );+$WS_DISABLED
	$msgboxPROC[$msgboxPROC[0][0]][0] = GUICreate(TimerInit(), $LARGEHZZAPROC, $ALTZZAPROC, $orizzontal, 0, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST);+$WS_DISABLED
	
	
	
	
	GUISetBkColor(0xFF0000)
	

	
	
;~ 	if StringInStr($text,":") = 0 Then
;~ 		$pctemp += 1
;~ 		$text = "Temporary(" & $pctemp & "):" & $text
;~ 	EndIf
	
;~ 	$text = StringStripWS($text, 8)
;~ 	$data = StringSplit($text, ":")
;~ 	$ip = StringStripWS($data[2], 8)
	
	$msgboxPROC[$msgboxPROC[0][0]][1] = GUICtrlCreateLabel($text, 5, 0, $LARGEHZZAPROC+200, $ALTZZAPROC+200)
	$msgboxPROC[$msgboxPROC[0][0]][2] = $procname
	
	GUICtrlSetFont($msgboxPROC[$msgboxPROC[0][0]][1], 12, 500)
	GUISetState(@SW_SHOWNA)
;~ 	WinSetTrans($msgboxPROC[$msgboxPROC[0][0]][0],"",200)

;~ 	GUICtrlSetColor($msgboxPROC[$msgboxPROC[0][0]][1],Hex ($mem, 2) & "0000") ;0xFF0000)
;~ 	GUICtrlSetColor($msgboxPROC[$msgboxPROC[0][0]][1],"0x000000") ;0xFF0000)
;~ 	GUICtrlSetColor($msgboxPROC[$msgboxPROC[0][0]][1],"0x" & Hex ($val, 2) & "0000") ;0xFF0000)
	GUICtrlSetColor($msgboxPROC[$msgboxPROC[0][0]][1], "0x000000") ;0xFF0000)
;~ 	MsgBox(0,"",$mem * 1000)
	
;~ 	if $r = 0 Then
;~ 		$msgbox[$msgbox[0][0]][2] = 0
;~ 		GUICtrlSetColor(-1,0xFF0000)
;~ 	Else
;~ 		$msgbox[$msgbox[0][0]][2] = 1
;~ 		GUICtrlSetColor(-1,0x00FF00)
;~ 	EndIf
	
;~ 	$r = Ping($ip, 50)
;~ 	MsgBox(0,$text & ": " & $r,@error)
;~ 	$tim= TimerInit()
;~ 	$msgbox[$msgbox[0][0]][1] = GUICtrlCreateLabel($text,0,0,200,30)
;~ 	$msgbox[$msgbox[0][0]][4] = $data[1]
;~ 	GUICtrlSetFont($msgbox[$msgbox[0][0]][1],12,500)


;~ 	$msgbox[$msgbox[0][0]][3] = $ip
;~ 	MsgBox(0,$ip,$r)


	
;~ 	MsgBox(0,"",$msgbox[0][0])
	$POSZProWin = WinGetPos($msgboxPROC[$msgboxPROC[0][0]][0])
	$varT = 1
	$mexxT = 0
	For $xv = $POSZProWin[1] To $vertical Step 2
		WinMove($msgboxPROC[$msgboxPROC[0][0]][0], "", $POSZProWin[0], $xv)
;~ 		if $xv - 50 <= $vertical Then
;~ 			if $speed = 0 Then
;~ 				Sleep(50)
;~ 			EndIf
;~ 		Else
;~ 			if $mexxT = 2 Then
;~ 				if $speed = 0 Then
;~ 					Sleep($varT)
;~ 				EndIf
;~ 				$mexxT = 0
;~ 			Else
;~ 				$mexxT += 1
;~ 			EndIf
;~ 		EndIf
		
;~ 		Sleep($varT)
	Next
;~ 	if $speed = 0 Then
;~ 		Sleep(500)
;~ 	EndIf
;~ 	for $xv = @DesktopWidth-$LARGEHZZA to @DesktopWidth Step 2
;~ 		WinMove($msgbox[$msgbox[0][0]][0], "", $xv, $vertical)
;~ 		if $speed = 0 Then
;~ 			Sleep(2)
;~ 		EndIf
;~ 	Next
	
	Return $msgboxPROC[0][0]
EndFunc   ;==>_createProcessMSG



Func _refreshSingle($winid)
	
	
	
;~ 	for $j = 1 to $msgbox[0][0]
;~ 		$tt = TimerInit()
;~ 		_MovWinAll()
	
;~ 		MsgBox(0,"",TimerDiff($tt))
	$r = Ping($msgbox[$winid][3], 50)
	If @error > 0 Then
		If $msgbox[$winid][2] = 1 Then
			GUICtrlSetColor($msgbox[$winid][1], 0xFF0000)
			$msgbox[$winid][2] = 0
			_MovWinSingle($winid)
		EndIf
	Else
		If $msgbox[$winid][2] = 0 Then
			GUICtrlSetColor($msgbox[$winid][1], 0x00FF00)
			$msgbox[$winid][2] = 1
			_MovWinSingle($winid)
		EndIf
	EndIf
	
;~ 	Next
	
	
;~ 	  WEnd
EndFunc   ;==>_refreshSingle

Func _refreshAll()
	
	
	
	For $j = 1 To $msgbox[0][0]
;~ 		$tt = TimerInit()
		_MovWinAll()
		
;~ 		MsgBox(0,"",TimerDiff($tt))
		$r = Ping($msgbox[$j][3], 50)
		If @error > 0 Then
			If $msgbox[$j][2] = 1 Then
				GUICtrlSetColor($msgbox[$j][1], 0xFF0000)
				$msgbox[$j][2] = 0
				_MovWinSingle($j)
			EndIf
		Else
			If $msgbox[$j][2] = 0 Then
				GUICtrlSetColor($msgbox[$j][1], 0x00FF00)
				$msgbox[$j][2] = 1
				_MovWinSingle($j)
			EndIf
		EndIf
		
	Next
	
	
;~ 	  WEnd
EndFunc   ;==>_refreshAll


Func _MovWinSingle($winid)
;~ 	$LARGEHZZA
	
	
	$winhandle = $msgbox[$winid][0]
	$timer = TimerInit()
	
	$posWin = WinGetPos($winhandle)

;~ 	$verticalRandom = Random(0,@DesktopHeight - $posWin[3],1)
	
;~ 	 While 1
;~ 		$arr=MouseGetPos()
;~ 		 If $arr[0] > @DesktopWidth-10 Then
	For $i = 20 To $posWin[2] Step 20
		Sleep(20)
		WinMove($winhandle, "", @DesktopWidth - $i, $posWin[1])
	Next
	
	Sleep(3000)
	
	For $i = $posWin[2] To 0 Step - 20
		Sleep(20)
		WinMove($winhandle, "", @DesktopWidth - $i, $posWin[1])
	Next

;~ 	 Sleep(500)
	
;~ 	  WEnd
EndFunc   ;==>_MovWinSingle

Func _MovWinAll()

	
	
	
	
	
	
	
	
	$arr = MouseGetPos()
	
	
	
	If $arr[0] > @DesktopWidth - 10 And $arr[1] > @DesktopHeight - 10 Then
		For $xx = 1 To $msgbox[0][0]
			$posWin = WinGetPos($msgbox[$xx][0])
;~ 				MsgBox(0,$msgbox[$xx][0],$posWin[3])
			For $i = 20 To $posWin[2] Step 20
				Sleep(20)
				WinMove($msgbox[$xx][0], "", @DesktopWidth - $i, $posWin[1])
			Next
			$arr = MouseGetPos()
			If $arr[0] < @DesktopWidth - $LARGEHZZA Then
				ExitLoop
			EndIf
		Next
		While 1
			
			Do
				$arr = MouseGetPos()
				Sleep(1000)
				$arr2 = MouseGetPos()
			Until $arr[0] = $arr2[0] And $arr[1] = $arr2[1] Or $arr[0] < @DesktopWidth - $LARGEHZZA
			
			If $arr[0] >= @DesktopWidth - $LARGEHZZA Then
				
				For $xx = 1 To $msgbox[0][0]
					$posiz = WinGetPos($msgbox[$xx][0])
					
;~ 						Sleep(2000)
					
					If $arr[0] >= $posiz[0] And $arr[0] <= $posiz[0] + $posiz[2] And $arr[1] >= $posiz[1] And $arr[1] <= $posiz[1] + $posiz[3] Then
;~ 							Sleep(2000)
;~ 							if $arr[0] >= $posiz[0] AND $arr[0] <= $posiz[0]+$posiz[2] AND $arr[1] >= $posiz[1] AND $arr[1] <= $posiz[1]+$posiz[3] Then
						
						$allProcRem = _getProcess($msgbox[$xx][3])
						
						For $xvPor = 1 To $allProcRem[0][0]
;~ 									MsgBox(0,"",$allProcRem[$xvPor][4])
							_createProcessMSG($allProcRem[$xvPor][0] & @CRLF & "PID: " & $allProcRem[$xvPor][1] & @CRLF & "Memory: " & $allProcRem[$xvPor][4] & " k", $allProcRem[$xvPor][4], $allProcRem[0][1], $allProcRem[$xvPor][0])
						Next
						
						$Exteso = 50
						
;~ 								$mpos = WinGetPos($msgboxPROC[1][0])
;~ 								MsgBox(0,$msgboxPROC[1][0],$mpos[0] & " " & $mpos[1])
						
						Do
							Sleep(2000)
							
							$mpos = MouseGetPos()
							$nisba = 0
							
							For $xx = 1 To $msgboxPROC[0][0]
								$posWinPR = WinGetPos($msgboxPROC[$xx][0])
;~ 										MsgBox(0,WinGetText($msgboxPROC[0][0]),$mpos[0] & " >= " & $posWinPR[0] & " AND " &  $mpos[0] & " <= " & $posWin[0]  & "+" & $posWin[2]  & " AND " & $mpos[1]  & " >= " & $posWin[1]  & " AND " & $mpos[1]  & " <= " & $posWin[1]  & "+" & $posWin[3])
								If $mpos[0] >= $posWinPR[0] And $mpos[0] <= $posWinPR[0] + $posWinPR[2] And $mpos[1] >= $posWinPR[1] And $mpos[1] <= $posWinPR[1] + $posWinPR[3] Then
;~ 											MsgBox(0,"",$msgboxPROC[$xx][2])
;~ 											WinSetTrans($msgboxPROC[$xx][0], "", 250)

									Do
;~ 												$try += 1
										$cf = 0
										$vertical = Random(0, @DesktopHeight - 50 - $Exteso - $ALTZZAPROC, 1)
;~ 												$vertical = $val+ (Round($try)) ;Random($val+200,$val + 400,1)
										$orizzontal = Random(0, @DesktopWidth - $LARGEHZZAPROC - $Exteso - $LARGEHZZA, 1)
;~ 				if $orizzontal + $LARGEHZZAPROC <= @DesktopWidth  Then
										For $j = 1 To $msgboxPROC[0][0]
											$ptemp = WinGetPos($msgboxPROC[$j][0])
											
;~ 						$array[0] = X position
;~ 						$array[1] = Y position
;~ 						$array[2] = Width
;~ 						$array[3] = Height

											If $vertical >= $ptemp[1] - $ptemp[3] And $vertical <= $ptemp[1] + $ptemp[3] And $orizzontal >= $ptemp[0] - $ptemp[2] And $orizzontal <= $ptemp[0] + $ptemp[2] Then
;~ 						if $vertical >= $ptemp[1] + $ptemp[3] Then; AND $vertical <= $ptemp[1] AND $orizzontal >= $ptemp[0] + $LARGEHZZAPROC AND $orizzontal <= $ptemp[0] Then
												$cf = 1
												ExitLoop
											EndIf
										Next
;~ 				EndIf
									Until $cf = 0
									
									$xid = $posWinPR[0]
									$yid = $posWinPR[1]
									
									Do
										If $xid < $orizzontal Then
											$xid += 1
										ElseIf $xid > $orizzontal Then
											$xid -= 1
										EndIf
										
										If $yid < $vertical Then
											$yid += 1
										ElseIf $yid > $vertical Then
											$yid -= 1
										EndIf
										
										WinMove($msgboxPROC[$xx][0], "", $xid, $yid)
										
;~ 												Sleep(1)
									Until $xid = $orizzontal And $yid = $vertical
									
									
									
									$posWinPRc = WinGetPos($msgboxPROC[$xx][0])
									
									For $dx = 1 To $Exteso Step 2
										WinMove($msgboxPROC[$xx][0], "", $posWinPRc[0], $posWinPRc[1], $posWinPRc[2] + $dx, $posWinPRc[3] + $dx)
										Sleep(1)
									Next
;~ 											Sleep(2000)
									
									
									
									
									
									Sleep(1000)
									
									$mpos = MouseGetPos()
;~ 											$nisba = 0
									
									$posWinPRc = WinGetPos($msgboxPROC[$xx][0])
									
									Do
										$mpos = MouseGetPos()
										Sleep(1000)
										
										If $mpos[0] >= $posWinPRc[0] And $mpos[0] <= $posWinPRc[0] + $posWinPRc[2] And $mpos[1] >= $posWinPRc[1] And $mpos[1] <= $posWinPRc[1] + $posWinPRc[3] Then
											
										Else
											ExitLoop
										EndIf
									Until 1 = 2

									
									For $dx = 1 To $Exteso Step 2
										WinMove($msgboxPROC[$xx][0], "", $posWinPRc[0], $posWinPRc[1], $posWinPRc[2] - $dx, $posWinPRc[3] - $dx)
										Sleep(1)
									Next
									
									
									$xid = $posWinPRc[0]
									$yid = $posWinPRc[1]
									
									
									Do
;~ 												MsgBox(0,"",$posWin[1] & "," & $yid)
										If $xid > $posWinPR[0] Then
											$xid -= 1
										ElseIf $xid < $posWinPR[0] Then
											$xid += 1
										EndIf
										
										If $yid > $posWinPR[1] Then
											$yid -= 1
										ElseIf $yid < $posWinPR[1] Then
											$yid += 1
										EndIf
										
										WinMove($msgboxPROC[$xx][0], "", $xid, $yid)
										
;~ 												Sleep(1)
									Until $xid = $posWinPR[0] And $yid = $posWinPR[1]
									
									
									$nisba = 1
								EndIf
							Next
							
							$arrX = MouseGetPos()
						Until $nisba = 0 AND $arrX[0] < @DesktopWidth - $LARGEHZZA
						
						
						
						
						For $xvPor = 1 To $msgboxPROC[0][0]
							$winpo = WinGetPos($msgboxPROC[$xvPor][0])
							
							For $my = $winpo[2] To 0 - $ALTZZAPROC Step -2
								WinMove($msgboxPROC[$xvPor][0],"",$winpo[0], $my)
;~ 								Sleep(1)
							Next
							GUIDelete($msgboxPROC[$xvPor][0])
						Next
						
						$msgboxPROC[0][0] = 0
						
;~ 							EndIf
					EndIf
					
				Next
			EndIf
;~ 				$nMsg = GUIGetMsg()
;~ 				Switch $nMsg
;~ 					Case $msgbox[2][1]
;~ 						MsgBox(0,"","ciao")
;~ 					Case $GUI_EVENT_CLOSE
;~ 						Exit
;~ 				EndSwitch
			
			
			If $arr[0] < @DesktopWidth - $LARGEHZZA Then
				For $xx = 1 To $msgbox[0][0]
					$posWin = WinGetPos($msgbox[$xx][0])
					If $posWin[0] < @DesktopWidth - 1 Then
						For $i = $posWin[2] To 0 Step - 20
							Sleep(10)
							WinMove($msgbox[$xx][0], "", @DesktopWidth - $i, $posWin[1])
						Next
					EndIf
				Next
				ExitLoop
			EndIf
		WEnd
	EndIf
	Sleep(100)
	
;~ 	  WEnd
EndFunc   ;==>_MovWinAll

Func _getProcess($pcname)
	
;~ 	Nome immagine                PID Nome sessione    Sessione Utilizzo mem
;~ 	========================= ====== ================ ======== ============
;~ 	System Idle Process            0 Console                 0         28 K
;~ 	System                         4 Console                 0        240 K
;~ 	smss.exe                     672 Console                 0        404 K


	$command = "tasklist -nh -s " & $pcname
;~ 	MsgBox(0,"",$command)
	$foo = Run(@ComSpec & " " & "/c" & " " & $command, "", @SW_HIDE, $STDOUT_CHILD) ;old

;~ 	MsgBox(0,"",@error)
;~ 	MsgBox(0,"",$foo)
	$return = ""
	While 1
		$return &= StdoutRead($foo)
		
		If @error Then ExitLoop
	WEnd
	
;~ 	MsgBox(0,"",$return)
	$return = StringSplit($return, @CRLF)
	
	Dim $returnProcess[1][5]
	$returnProcess[0][0] = 0
	$MAXMEM = 0
	$t = ""
	For $i = 1 To $return[0]
		If StringStripWS($return[$i], 8) <> "" Then
			$returnProcess[0][0] += 1
			ReDim $returnProcess[$returnProcess[0][0] + 1][5]
			
;~ 			$t &= @CRLF & $return[$i]
			$returnProcess[$returnProcess[0][0]][0] = StringStripWS(StringLeft($return[$i], 25), 7)
			$returnProcess[$returnProcess[0][0]][1] = StringStripWS(StringMid($return[$i], 27, 6), 7)
			$returnProcess[$returnProcess[0][0]][2] = StringStripWS(StringMid($return[$i], 34, 16), 7)
			$returnProcess[$returnProcess[0][0]][3] = StringStripWS(StringMid($return[$i], 51, 8), 7)
			$returnProcess[$returnProcess[0][0]][4] = StringReplace(StringReplace(StringStripWS(StringMid($return[$i], 60, 12), 8), ".", ""), "k", "")
;~ 			MsgBox(0,"",$returnProcess[$returnProcess[0][0]][4] & " > " & $MAXMEM)
			
			If Int($returnProcess[$returnProcess[0][0]][4]) > Int($MAXMEM) Then
				$MAXMEM = $returnProcess[$returnProcess[0][0]][4]
			EndIf
			
			
;~ 			MsgBox(0,"",$returnProcess[$returnProcess[0][0]][0])
;~ 			MsgBox(0,"",$returnProcess[$returnProcess[0][0]][4])
		EndIf
	Next
	
	$returnProcess[0][1] = $MAXMEM
;~ 	MsgBox(0,"",StringLeft($return[3], 25))
	
;~ 	MsgBox(0,"",$returnProcess[$returnProcess[0][0]][0] & "-" & $returnProcess[$returnProcess[0][0]][1])
;~ 	MsgBox(0,"",$t)
	
;~ 	Exit
	Return $returnProcess
	
	
EndFunc   ;==>_getProcess

Func _MovWinMouse($winhandle)

	
	$posWin = WinGetPos($winhandle)
	$verticalRandom = Random(0, @DesktopHeight - $posWin[3], 1)
	
;~ 	 While 1
	$arr = MouseGetPos()
	If $arr[0] > @DesktopWidth - 10 Then
		For $i = 20 To $posWin[2] Step 20
			Sleep(20)
			WinMove($winhandle, "", @DesktopWidth - $i, $verticalRandom)
		Next
		While 1
			$arr = MouseGetPos()
			If $arr[0] < @DesktopWidth - 200 Then
				For $i = $posWin[2] To 0 Step - 20
					Sleep(20)
					WinMove($winhandle, "", @DesktopWidth - $i, $verticalRandom)
				Next
				ExitLoop
			EndIf
		WEnd
	EndIf
	Sleep(500)
	
;~ 	  WEnd
EndFunc   ;==>_MovWinMouse

Func Newcomputer()
	Do
		$tag = InputBox($title, "Write the computer name and the ipaddress/hosname", @ComputerName & ": " & @IPAddress1)
		$error = @error
		If StringInStr($tag, ":") = 0 And $error = 0 Then
			MsgBox(0, $title, "Error... sintax correct:" & @CRLF & "ALIASNAME:ipaddessORhostname")
		EndIf
	Until StringInStr($tag, ":") > 0 Or $error > 0
	
	If $error = 0 Then
		FileWriteLine($filedati, $tag)
		Sleep(1000)
		$id = _createMSG($tag)
		
		_MovWinSingle($id)
	EndIf
EndFunc   ;==>Newcomputer

Func tNewcomputer()
;~     Do
	$tag = InputBox($title, "Write the computer ipaddress/hosname", @IPAddress1)
	$error = @error
;~ 		if StringInStr($tag, ":") = 0 Then
;~ 			MsgBox(0,$title, "Error... sintax correct:" & @CRLF & "ALIASNAME:ipaddessORhostname")
;~ 		EndIf
;~ 	Until StringInStr($tag, ":") > 0
;~ 	FileWriteLine($filedati, $tag)
	If $tag = "" And $error = 0 Then
		Return 0
	EndIf
	
	If $error = 0 Then
		Sleep(1000)
		$id = _createMSG($tag)
		
		_MovWinSingle($id)
	EndIf
EndFunc   ;==>tNewcomputer

Func DelTask()
	MsgBox(0x1, "", "Task delete: " & @GUI_CtrlId)
EndFunc   ;==>DelTask

Func Term()
	Exit
EndFunc   ;==>Term
;~ Func show()
;~ 	For $i=20 To 200 Step 20
;~ 		 WinMove("To Do","",@DesktopWidth-$i,0)
;~ 	 Next
; $arr=MouseGetPos()
; MouseMove(@DesktopWidth,$arr[1])
;~ 	 EndFunc