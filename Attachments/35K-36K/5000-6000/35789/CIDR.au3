#Include<Array.au3>
#include<Date.au3>
#include<File.au3>

dim $Oct[4]
dim $Parts[2]
dim $Nmask
Dim $StrIP
Dim $Bin
Dim $Bin1
Dim $BinIP
Dim $Net
Dim $Nodes
Dim $DecIP[6]
Dim $NoOfIPs
Dim $Skipped
Dim $Written
Dim $Cidr
Dim $Begin
Dim $TDiff
Dim $NewContent
Dim $CheckDuplicate = "Yes"  ;"Yes" = Will Check    "No" = Wont Check
;Dim $CheckDuplicate = "No"  ;"Yes" = Will Check    "No" = Wont Check

$Begin = TimerInit()
$Skipped = 0
$Written = 0
$NewContent = ""

if Not _FileReadToArray("cidr.txt", $Cidr) Then
	MsgBox(4096,"Error", " Error reading CIDR to Array     error:" & @error)
	Exit
EndIf
For $xcounter = 1 to $Cidr[0]
	$StrIP = $Cidr[$xcounter]
	$Parts = StringSplit($StrIP,"/")
	$Nmask = $Parts[2]
	$Oct = StringSplit($Parts[1],".")

	Call ("_ToBinary2", $Oct[1])
	while StringLen($Bin) < 8
		$Bin = "0" & $Bin
	WEnd
	$BinIP = $Bin
	Call ("_ToBinary2", $Oct[2])
	while StringLen($Bin) < 8
		$Bin = "0" & $Bin
	WEnd
	$BinIP = $BinIP & $Bin
	Call ("_ToBinary2", $Oct[3])
	while StringLen($Bin) < 8
		$Bin = "0" & $Bin
	WEnd
	$BinIP = $BinIP & $Bin
	Call ("_ToBinary2", $Oct[4])
	while StringLen($Bin) < 8
		$Bin = "0" & $Bin
	WEnd
	$BinIP = $BinIP & $Bin
	$Net = StringLeft($BinIP, $Nmask)
	$Nodes = StringRight($BinIP, 32-$Nmask)
	$x = StringLen($Nodes)
	$NoOfIPs = 1
	for $i = 1 to $x
		$NoOfIPs = $NoOfIPs * 2
	Next

	Call ("_todecimal", $BinIP)

	;Get current contents of file
	$CurrContent = FileRead("GreyList.txt")
	$DateSet = _DateDiff( 'D',"1900/01/01 00:00:00", _NowCalc())
	$DateSet = $DateSet + 365 ;Add 365 Days to the date

	; Send IP Range to text file
	if FileExists($xcounter & ".txt") Then FileDelete($xcounter & ".txt")
	$File =FileOpen($xcounter & ".txt", 1)

	; Check if file opened for writing OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf

	ProgressOn("Writing to file " & $xcounter & " of " & $Cidr[0], "Writing " & $NoOfIPs & " IP Addresses", "", -1, -1, 16+2)
	For $LineCounter = 0 to $NoOfIPs - 1 
		Call ("_ToBinary2", $LineCounter)
		while StringLen($Bin) < StringLen($Nodes)
			$Bin = "0" & $Bin
		WEnd
		$BinIP = $Net & $Bin
		Call ("_todecimal", $BinIP)
		If $CheckDuplicate = "Yes" then
			if StringInStr($CurrContent, $DecIP[5] & "~") = 0 Then
				FileWriteLine($file, $DecIP[5] & "~" & $DateSet)
	;			$CurrContent = $CurrContent & $DecIP[5]
				$Written = $Written + 1
				
			Else
				$Skipped = $Skipped + 1
			EndIf
		Else
			FileWriteLine($file, $DecIP[5] & "~" & $DateSet)
			$Written = $Written + 1
		EndIf	
		$PC = $LineCounter / $NoOfIPs * 100
		ProgressSet( $PC, $LineCounter)
	Next
	FileClose($file)
	ProgressSet(100 , "Complete", $StrIP & " - " & $xcounter & " of " & $Cidr[0])
	sleep(2000)
	ProgressOff()
Next

;combine the text files into the allow list
For $xcounter = 1 to $Cidr[0]
	$FileNew = FileRead($xcounter & ".txt")
	$NewContent = $NewContent & $FileNew
	FileDelete($xcounter & ".txt")
Next
$File = FileOpen("GreyList.txt",1)
FileWrite($File, $NewContent)
FileClose($File)

$TDiff = TimerDiff($Begin)
MsgBox(1,"Complete Report", $Written & " Written" & @CR & $Skipped & " Skipped" & @CR & "Time Taken " & $TDiff)
Exit

Func _ToBinary2($DecNum)
	; Calculate number of Binary positions
	$count = 0
	$UNum = 0
	$Bin1 = ""
	while $UNum <= $DecNum
		$count = $count + 1
		$UNum = $UNum * 2
		if $UNum = 0 then $UNum = 1
	WEnd
	$count = $count - 1
	if $count = 0 then $count = 1
	
	While $count > 0
		$x = 1
		for $i = 2 to $count
			$x = $x * 2
		Next
		if $DecNum >= $x Then
			$Bin1 = $Bin1 & "1"
			$DecNum = $DecNum - $x
		Else
			$Bin1 = $Bin1 & "0"
		EndIf
		$count = $count - 1
	WEnd
			
	$Bin = $Bin1
	Return $Bin
EndFunc


Func _ToDecimal($BinNum)
	; split the binary to 4 groups of 8
	$oct[1] = StringLeft($BinNum,8)
	$oct[2] = StringMid($BinNum,9,8)
	$oct[3] = StringMid($BinNum,17,8)
	$oct[4] = StringRight($BinNum,8)
	for $x = 1 to 4
		$count = 1
		$Dec = 0
		for $i = 8 to 1 step -1
 			$Dec = $Dec + (StringMid($Oct[$x], $i, 1) * $count)
			$count = $count * 2
		Next
		$DecIP[$x] = $Dec
	Next
	$DecIP[5] = $DecIP[1] & "." & $DecIP[2] & "." & $DecIP[3] & "." & $DecIP[4] 
EndFunc