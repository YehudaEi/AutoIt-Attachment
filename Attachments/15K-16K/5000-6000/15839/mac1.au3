;
;
; Made by Cramaboule
; Woks in XP, Vista
; in any languages...
;
;
;
;
;





#include <GUIConstants.au3>


Call ("Getmacaddress")

$gui = GUICreate("GUI", 500,400)

	For $i = 1 To $split[0][0]
		GUICtrlCreateLabel($split[$i][1]&" :", 10, ($i*25))
		GUICtrlCreateInput ( $split[$i][2], 310, ($i*25),120 ,-1,$ES_READONLY)
	Next
GUISetState (@SW_SHOW)

While 1
    $msg = GUIGetMsg()
    
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend




Func Getmacaddress()
	ProcessClose("cmd.exe")
	If FileExists ( @AppDataDir&"\autoit\mac.txt" ) Then
		FileDelete ( @AppDataDir&"\autoit\mac.txt" )
	EndIf
	DirCreate(@AppDataDir&"\autoit")
	Opt("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced
	RunWait(@ComSpec & " /c ipconfig /all>"&Chr(34)&@AppDataDir&"\autoit\mac.txt"&Chr(34),"",@SW_HIDE) ; Write a file with all the MAC addresses
	ProcessClose("cmd.exe")
	$file = FileOpen(@AppDataDir&"\autoit\mac.txt", 0)
	; Check if file opened for reading OK
	If $file = -1 Then
		MsgBox(48, "Error:", "Unable to open file.")
		Exit
	EndIf
	$message = @CRLF & @CRLF
	Global $split[90][10] ; split -> take only the mac address => see "$i-=1" lower. Used for display in the GUI
	Dim $all[99][10] ; all -> take everything
	Dim $seq[10] ; the whole line in sequences
	$j=1 ; nb of coma, segment...
	$i=0 ; Nb of line if no more line @error = -1
	$l=0
	$line=""
	$oldline=""
	$oldline1=""
	While 1
		$oldline1 = $oldline; On some computer the name of the MAC Address is on a new line !...
		$oldline = $line; ... with 2 '@LF'
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop ; if there is no line any more in the file
		;MsgBox(0, "ggg", $line)
		$seq= StringSplit($line, ":")
		If $seq[0]>1 Then ; if line is not empty (more than 1 ":")
			$l+=1
			$i+=1
			For $r=0 To $seq[0]
				$split[$i][$r]=$seq[$r] ; split -> take only the mac address => see "$i-=1" lower
				$all[$l][$r]=$seq[$r]  ; all -> take everything
			Next
		EndIf
		If @error <> 1 Then ; @error is at 1 if $seq[0] =1 no "," found
			If StringMid($seq[2], 4, 1)= "-" Then ; if there is a "-" in the seq nb 2, 4th character wich is the mad address then
				$split[$i][2]=StringTrimLeft($split[$i][2], 1); mac address
				$split[$i][1]=StringTrimLeft($all[$l-1][2], 1); name of mac address
				If $split[$i][1] = "" Then
					While StringLeft($oldline1,1) = " "
						$oldline1=StringTrimLeft($oldline1,1)
						;MsgBox(0, "ggg", $oldline1)
					WEnd
					$split[$i][1] = $oldline1
				EndIf
				$message &= $split[$i][1]&@CRLF&$split[$i][2]&@CRLF
				$split[0][0]=$i
				;MsgBox(0,"rr", $message)
			Else
				$i-=1
			EndIf
		EndIf
	Wend
	FileClose($file)
	ProcessClose(@AppDataDir&"\autoit\mac.txt")
	FileDelete ( @AppDataDir&"\autoit\mac.txt")
EndFunc