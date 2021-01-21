#include <Array.au3>
#include <File.au3>
#include <GUIConstants.au3>

Opt("TrayIconDebug", 1)

$Form1 = GUICreate("Daoc Chat Log Parser 0.1", 361, 37, 191, 125, BitOR($WS_CAPTION,$WS_BORDER,$WS_CLIPSIBLINGS))

$prgProgress = GUICtrlCreateProgress(8, 8, 345, 17)
GUISetState(@SW_SHOW)

;Info arrays
Dim $sSpellCount[1]
$sSpellCount[0] = "init"
Dim $sDmgMax
Dim $sDmgCount
Dim $sDmgDeflected
Dim $sDmgCrit
Dim $sMobDmgMax
Dim $sMobDmgCount
Dim $sMobDmgDeflected
Dim $sExp[2]
Dim $sLootMoney[3]
Dim $sMobs[1]
$sMobs[0] = "init"

$file = FileOpen(@ScriptDir & "\chat.log", 0)

	$TotalLines = _FileCountLines(@ScriptDir & "\chat.log")
	$CurrentLine = 1

$a = 100
$oldtime = _Msec()
$checktime = 0
$currenttime = 0
$blah = 0
$mtexp = 0
While 1 ; Not StringInStr($test, "*** Chat Log Closed")
	
	; Check how many lines are being read per second.
$currenttime = _Msec()
	If $currentline > $a Then
		$checktime = $currenttime - $oldtime ; 100-200=-100
		
		If $checktime > 0 Then
			$checktime = 1000 - $checktime 
		EndIf
		
		If $checktime < 1000 Then
			$checktime = 1000 - $checktime
		EndIf
		
		$a = $a + 100
		
	;	$blah = $TotalLines / 100
	;	$blah = $blah * $checktime
	;	$blah = Int($blah)
	;	$blah = $blah / 1000
	;	$blah = Int($blah)
		
		$oldtime = _Msec()
	EndIf
		
	$test = FileReadLine($file)
	If @error = -1 Then ExitLoop
	GUICtrlSetData($prgProgress, 100 * ($CurrentLine / $TotalLines))
	
	ToolTip("At line: " & $CurrentLine & " Total Lines to read: " & $TotalLines & " Reading 100 lines @ " & $checktime & " miliseconds." & " sExp: " & $sExp,0,0)
	
	
    $aCast = StringRegExp($test, "\[([0-9:]*?)\] You cast a (.*?) Spell!", 1)
    If IsArray($aCast) Then
        $notFound = 1
        For $i = 0 To UBound($sSpellCount)-1
            $tmp = $sSpellCount[$i]
            If IsArray($tmp) Then
                If $tmp[0] == $aCast[1] Then
                    $tmp[1] += 1
                    $sSpellCount[$i] = $tmp
                    $notFound = 0
                EndIf
            EndIf
        Next
        If $notFound == 1 Then
            If UBound($sSpellCount) >= 1 And $sSpellCount[0] <> "init" Then
                ReDim $sSpellCount[UBound($sSpellCount)+1]
            EndIf
            Dim $tmp[2]
            $tmp[0] = $aCast[1]
            $tmp[1] = 1
            $sSpellCount[UBound($sSpellCount)-1] = $tmp
        EndIf
    EndIf
    $aBlocked = StringRegExp($test, "\[([0-9:]*?)\] ([a-zA-Z ]*?) attacks you and you (.*?) the blow!", 1)
    If IsArray($aBlocked) Then
        
    EndIf
    $aTarget = StringRegExp($test, "\[([0-9:]*?)\] You enter combat mode and target \[the (.*?)\]", 1)
    If IsArray($aTarget) Then
        
    EndIf
    $aPerformSkill = StringRegExp($test, "\[([0-9:]*?)\] You perform your (.*?) perfectly. \(+(.*?)\)", 1)
    If IsArray($aPerformSkill) Then
        
    EndIf
    ;$aAttack = StringRegExp($test, "\[([0-9:]*?)\] You attack ([a-zA-Z ]*?) with your .*? and hit for (.*?) \((.*?)\) damage!", 1)
	$aAttack = StringRegExp($test, "\[([0-9:]*?)\] You attack ([a-zA-Z ]*?) with your (.*?) and hit for (.*?) \((.*?)\) damage!", 1)
    If IsArray($aAttack) Then
        If $aAttack[2] > $sDmgMax Then
            $sDmgMax = $aAttack[2]
        EndIf
        $sDmgCount += $aAttack[2]
        $sDmgDeflected += $aAttack[3]
    EndIf
    $aMiss = StringRegExp($test, "\[([0-9:]*?)\] You miss!", 1)
    If IsArray($aMiss) Then
        
    EndIf
    $aMobMiss = StringRegExp($test, "\[([0-9:]*?)\] ([a-zA-Z ]*?) attacks you and misses!", 1)
    If IsArray($aMobMiss) Then
        
    EndIf
    $aCrit = StringRegExp($test, "\[([0-9:]*?)\] You critical hit for an additional (.*?) damage!", 1)
    If IsArray($aCrit) Then
        $sDmgCrit += $aCrit[1]
    EndIf
    $aHeal = StringRegExp($test, "\[([0-9:]*?)\] You heal yourself for (.*?) hit points.", 1)
    If IsArray($aHeal) Then
        
    EndIf
    $aMobDies = StringRegExp($test, "\[([0-9:]*?)\] ([a-zA-Z ]*?) dies!", 1)
    If IsArray($aMobDies) Then
        $notFound = 1
        For $i = 0 To UBound($sMobs)-1
            $tmp = $sMobs[$i]
            If IsArray($tmp) Then
                If $tmp[0] == $aMobDies[1] Then
                    $tmp[1] += 1
                    $sMobs[$i] = $tmp
                    $notFound = 0
                EndIf
            EndIf
        Next
        If $notFound == 1 Then
            If UBound($sMobs) >= 1 And $sMobs[0] <> "init" Then
                ReDim $sMobs[UBound($sMobs)+1]
            EndIf
            Dim $tmp[2]
            $tmp[0] = $aMobDies[1]
            $tmp[1] = 1
            $sMobs[UBound($sMobs)-1] = $tmp
        EndIf
    EndIf
	
	
	;$aExp = StringRegExp($test, "\[([0-9:]*?)\] You get ([0-9,]*?) experience points. \(([0-9,]*?) ([0-9,]*?) bonus\)", 1)
	$aExp = StringRegExp($test, " You get ([0-9,]*?) experience points. ", 3)
   If IsArray($aExp) Then
		;MsgBox(0,"", "$aExp: " & $aExp)
		
	   		$convert = StringReplace($aExp[0], ",", "")
			$aExp[0] = $convert
	   
		$mtexp = $mtexp + $aExp[0]	; Monster Total Experience
		;$monsterexp = $monsterexp + 1
		MsgBox(0,"", "Total exp: " & $mtexp)
		
		

	EndIf
    $aTaskExp = StringRegExp($test, "\[([0-9:]*?)\] You have completed your task and earn ([0-9,]*?) experience!", 1)
    If IsArray($aTaskExp) Then
        
    EndIf
    $aLootMoneyC = StringRegExp($test, "\[([0-9:]*?)\] You pick up ([0-9,]*?) copper pieces.", 1)
    If IsArray($aLootMoneyC) Then
        
    EndIf
    $aLootMoneySC = StringRegExp($test, "\[([0-9:]*?)\] You pick up ([0-9,]*?) silver, and ([0-9,]*?) copper pieces.", 1)
    If IsArray($aLootMoneySC) Then
        
    EndIf
    $aLootMoneyGSC = StringRegExp($test, "\[([0-9:]*?)\] You pick up ([0-9,]*?) gold, ([0-9,]*?) silver, and ([0-9,]*?) copper pieces.", 1)
    If IsArray($aLootMoneyGSC) Then
        
    EndIf
    $aTaskMoneyC = StringRegExp($test, "\[([0-9:]*?)\] You have completed your task and earn ([0-9,]*?) copper pieces!", 1)
    If IsArray($aTaskMoneyC) Then
        
    EndIf
    $aTaskMoneySC = StringRegExp($test, "\[([0-9:]*?)\] You have completed your task and earn ([0-9,]*?) silver, and ([0-9,]*?) copper pieces!", 1)
    If IsArray($aTaskMoneySC) Then
        
    EndIf
    $aTaskMoneyGSC = StringRegExp($test, "\[([0-9:]*?)\] You have completed your task and earn ([0-9,]*?) gold, ([0-9,]*?) silver, and ([0-9,]*?) copper pieces!", 1)
    If IsArray($aTaskMoneyGSC) Then
        
    EndIf
    $aLoot = StringRegExp($test, "\[([0-9:]*?)\] ([a-zA-Z ]*?) drops (.*?), which you pick up.", 1)
    If IsArray($aLoot) Then
        
    EndIf
    $aMobAttack = StringRegExp($test, "\[([0-9:]*?)\] ([a-zA-Z ]*?) hits your ([a-zA-Z ]*?) for (.*?) \((.*?)\) damage!", 1)
    If IsArray($aMobAttack) Then
        If $aMobAttack[3] > $sMobDmgMax Then
            $sMobDmgMax = $aMobAttack[3]
        EndIf
        $sMobDmgCount += $aMobAttack[3]
        $sMobDmgDeflected += $aMobAttack[4]
    EndIf
	
	$CurrentLine = $CurrentLine + 1
;_ArrayDisplay($aCast, "")
;_ArrayDisplay($aBlocked, "")
;_ArrayDisplay($aTarget, "")
;_ArrayDisplay($aPerformSkill, "")
;_ArrayDisplay($aAttackMob, "")
;_ArrayDisplay($aMiss, "")
;_ArrayDisplay($aMobMiss, "")
;_ArrayDisplay($aCrit, "")
;_ArrayDisplay($aHeal, "")
;_ArrayDisplay($aMobDies, "")
;_ArrayDisplay($aExp, "")
;_ArrayDisplay($aLootMoneyC, "")
;_ArrayDisplay($aLootMoneySC, "")
;_ArrayDisplay($aLootMoneyGSC, "")
;_ArrayDisplay($aLoot, "")
;_ArrayDisplay($aMobAttack, "")
;_ArrayDisplay($aTaskMoneyC, "")
;_ArrayDisplay($aTaskMoneySC, "")
;_ArrayDisplay($aTaskMoneyGSC, "")
;_ArrayDisplay($aTaskExp, "")
    
WEnd
$file = FileOpen(@ScriptDir & "\spamhere.log", 2)
write("DAMAGE TOTALS")
write("-------------")
write("Maximum Damage: " & $sDmgMax)
write("Total Damage from Crits: " & $sDmgCrit)
write("Total Damage: " & $sDmgCount)
write("Total Damage mobs resisted: " & $sDmgDeflected)
write("-------------")
write("Maximum Mob Damage: " & $sMobDmgMax)
write("Total Mob Damage: " & $sMobDmgCount)
write("Total Mob Damage you resisted: " & $sMobDmgDeflected)
write("")
write("MOBS")
write("-------------")
write("    [0]= Name of Mob")
write("    [1]= Number of Times Killed")
write("-------------")
write(_ArrayDisplay2($sMobs, "Mobs Killed", 0))
write("SPELLS")
write("-------------")
write("    [0]= Name of Spell")
write("    [1]= Number of Casts")
write("-------------")
write(_ArrayDisplay2($sSpellCount, "Spells Casted", 0))
write("-------------")
write("EXPERIENCE")
write("		[0]= Experience")
write("		[1]= Experience 2")
write("-------------")
write(_ArrayDisplay2($sExp, "Experience", 0))


FileClose($file)

Func _ArrayDisplay2($arr, $title, $flag)
    $str = ""
    If IsArray($arr) Then
        For $i = 0 To UBound($arr)-1
            $str &= "[" & $i & "]= "
            $str &= _ArrayDisplay2Sub($arr[$i], 1)
            $str &= @CRLF
        Next
        If $flag == 1 Then
            MsgBox(0, $title, $str)
        EndIf
    Else
        If $flag == 1 Then
            MsgBox(0, $title, $arr)
        EndIf
    EndIf
    Return $str
EndFunc
        
Func _ArrayDisplay2Sub($arr, $count)
    $str = ""
    If IsArray($arr) Then
        For $i = 0 to UBound($arr)-1
            $str &= @CRLF
            For $c = 1 To $count
                $str &= "    "
            Next
            $str &= "[" & $i & "]= "
            $str &= _ArrayDisplay2Sub($arr[$i], $count+1)
        Next
        Return $str
    Else
        Return $arr
    EndIf
EndFunc

Func write($str)
    FileWriteLine($file, $str & @CRLF)
EndFunc

Func _MSec()
    Local $stSystemTime = DllStructCreate('ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort')
    DllCall('kernel32.dll', 'none', 'GetSystemTime', 'ptr', DllStructGetPtr($stSystemTime))

    $sMilliSeconds = StringFormat('%03d', DllStructGetData($stSystemTime, 8))
    
    $stSystemTime = 0
    
    Return $sMilliSeconds
EndFunc