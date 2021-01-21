#include <Array.au3>
#include <File.au3>

Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)

;HotKeySet("{F2}", "Test")  ; Used to record letters when i was making this.
HotKeySet("{F4}", "Cheat") ; Cheat at Texttwist :)

; X Values
$ONE_LEFT = 267
$ONE_CEN = 274
$ONE_RIGHT = 282


; Y Values
$ONE_TOP = 343
$ONE_MID = 354
$ONE_BOTTOM = 364

; Extra checks, because H and N look the same with the above coords.
$ONE_CHECK1 = 271
$ONE_CHECK2 = 347
Dim $Letter1[10][3]

; Scan the little grey balls to see what letter they contain.
Func ScanLetter()
	
	$Letter1[0][0] = PixelGetColor($ONE_LEFT, $ONE_TOP)
	$Letter1[0][1] = $ONE_LEFT
	$Letter1[0][2] = $ONE_TOP

	$Letter1[1][0] = PixelGetColor($ONE_CEN, $ONE_TOP)
	$Letter1[1][1] = $ONE_CEN
	$Letter1[1][2] = $ONE_TOP

	$Letter1[2][0] = PixelGetColor($ONE_RIGHT, $ONE_TOP)
	$Letter1[2][1] = $ONE_RIGHT
	$Letter1[2][2] = $ONE_TOP

	$Letter1[3][0] = PixelGetColor($ONE_LEFT, $ONE_MID)
	$Letter1[3][1] = $ONE_LEFT
	$Letter1[3][2] = $ONE_MID

	$Letter1[4][0] = PixelGetColor($ONE_CEN, $ONE_MID)
	$Letter1[4][1] = $ONE_CEN
	$Letter1[4][2] = $ONE_MID

	$Letter1[5][0] = PixelGetColor($ONE_RIGHT, $ONE_MID)
	$Letter1[5][1] = $ONE_RIGHT
	$Letter1[5][2] = $ONE_MID

	$Letter1[6][0] = PixelGetColor($ONE_LEFT, $ONE_BOTTOM)
	$Letter1[6][1] = $ONE_LEFT
	$Letter1[6][2] = $ONE_BOTTOM

	$Letter1[7][0] = PixelGetColor($ONE_CEN, $ONE_BOTTOM)
	$Letter1[7][1] = $ONE_CEN
	$Letter1[7][2] = $ONE_BOTTOM

	$Letter1[8][0] = PixelGetColor($ONE_RIGHT, $ONE_BOTTOM)
	$Letter1[8][1] = $ONE_RIGHT
	$Letter1[8][2] = $ONE_BOTTOM

	$Letter1[9][0] = PixelGetColor($ONE_CHECK1, $ONE_CHECK2)
	$Letter1[9][1] = $ONE_CHECK1
	$Letter1[9][2] = $ONE_CHECK2

EndFunc   ;==>ScanLetter


Func Test()
	Local $SkipFlag = False
	
	$str = InputBox("", "letter; ")
	$strsec = IniReadSectionNames("Letters.txt")
	If IsArray($strsec) Then
		For $x = 1 To $strsec[0]
			If $strsec[$x] = $str Then
				$SkipFlag = True
			EndIf
		Next
	EndIf
	
	If $SkipFlag = False Then
		Sleep(1000)
		ScanLetter()
		For $x = 0 To 9
			MouseMove($Letter1[$x][1], $Letter1[$x][2])
			IniWrite("Letters.txt", $str, $x, Hex($Letter1[$x][0], 6))
		Next
	EndIf
	$SkipFlag = False
EndFunc   ;==>Test


Func GetLetters()
	Global $CompleteString = 0
	
	For $i = 0 To 5
		$CompleteString = $CompleteString & ScanLetterMain()
		$ONE_LEFT += 54
		$ONE_CEN += 54
		$ONE_RIGHT += 54
		$ONE_CHECK1 += 54
	Next
	
	$ONE_LEFT = 267
	$ONE_CEN = 274
	$ONE_RIGHT = 282
	$ONE_CHECK1 = 271
	
	Return $CompleteString
EndFunc   ;==>GetLetters


Func Cheat()
	Local $file[_FileCountLines("sort.txt") + 1]
	Local $z = 1
	
	_FileReadToArray("sort.txt", $file)
	
	
	While 1
		Local $Letters = "", $x = "", $y = "", $WordArray = "", $Word = "", $Outofwords = False
		$CompleteString = ""

		$Word = GetLetters()
		ConsoleWrite("Scanned letters: " & $Word & @CRLF)

		While 1
			While 1
				Local $str = ""

				If $z = $file[0] Then
					$Outofwords = True
					ExitLoop 2
				EndIf

				$line = $file[$z]
				
				$WordSize = StringLen($line)
				$DictArray = StringSplit($line, "")
				$WordArray = StringSplit($Word, "")
				
				
				For $x = 1 To $DictArray[0]
					For $y = 1 To $WordArray[0]
						If $DictArray[$x] = $WordArray[$y] Then
							$str = $str & $DictArray[$x]
							$WordArray[$y] = ""
							$DictArray[$x] = ""
						EndIf
					Next
				Next
				$z += 1
				If StringLen($str) = $WordSize Then ExitLoop
			WEnd
			

			$answer = StringSplit($str, "")

			For $i = 1 To StringLen($str)
				Send($answer[$i])
				Sleep(75)
			Next
			Send("{ENTER}")
			Sleep(100)
			
			If PixelGetColor(225, 310) = 16777215 Then
				Sleep(5000)
				MouseClick("LEFT", 337, 359)
				Sleep(2000)
				ExitLoop
			EndIf

		WEnd
		
		If $Outofwords = True Then
			While 1
				
			If PixelGetColor(225, 310) = 16777215 Then
				Sleep(5000)
				MouseClick("LEFT", 337, 359)
				Sleep(2000)
				ExitLoop
			EndIf
		WEnd
	EndIf
	
	$z = 1

	WEnd

EndFunc   ;==>Cheat



Func ScanLetterMain()
	Local $Count = 0
	Local $x = 0
	Local $y = 0
	Local $strsec = 0
	ScanLetter()
	;Sleep(1000)
	
	Local $strsec = IniReadSectionNames("Letters.txt")
	For $x = 1 To $strsec[0]
		For $y = 0 To 9
			If IniRead("Letters.txt", $strsec[$x], $y, "") = Hex($Letter1[$y][0], 6) Then
				$Count += 1
			EndIf
		Next
		If $Count = 10 Then
			Return $strsec[$x]
			ExitLoop
		EndIf
		$Count = 0
	Next
EndFunc   ;==>ScanLetterMain

While 1
	sleep(100)
WEnd
