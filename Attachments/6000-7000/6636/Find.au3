; ----------------------------------------------------------------------------
; AutoIt Version: 3.1.1.105 -beta-
; Author:   laine@intergate.com <Laine Houghton>
;
; Script Function:
;
; ----------------------------------------------------------------------------

Global $inFile

Global $FindFirst="gallery.php?gid="
Global $FindNext="<center>&nbsp;"
Global $Array1=1
Global $array2=1
Global $FirstArray[300]
Global $SecondArray[300]

$inFile=FileOpen(@ScriptDir&"\SampleSource.txt",0)
If $inFile = -1 Then
    MsgBox(16, "Error", "Unable to open file.")
    Exit
EndIf
FindFirst()
$FirstArray[0]=$Array1
$SecondArray[0]=$array2

#include <File.au3>
_FileWriteFromArray(@ScriptDir&"\Array1.txt", $FirstArray, 1)
_FileWriteFromArray(@ScriptDir&"\Array2.txt", $SecondArray, 1)
Exit


Func FindFirst()
	While 1
		$line=FileReadLine($inFile)
		If @error=-1 Then
			ExitLoop
		EndIf
		For $i=0 To StringLen($line) - StringLen($FindFirst)
			$Find= StringMid($line,$i,StringLen($FindFirst))
			If $FindFirst=$Find Then
				$i += StringLen($FindFirst)
				$Find =StringMid($line,$i,6)
				$FirstArray[$Array1]= $Find
				$Array1 +=1
				FindNext()
			EndIf
		Next		
WEnd
EndFunc

Func FindNext()
	While 1
		$line=FileReadLine($inFile)
		If @error=-1 Then
			ExitLoop
		EndIf
		For $i=0 To StringLen($line) - StringLen($FindNext)
			$Find= StringMid($line,$i,StringLen($FindNext))
			If $FindNext=$Find Then
				$i += StringLen($FindNext)
				$Find=""
				$c =StringMid($line,$i,1)
				While StringIsInt($c)
					$Find &= $c
					$i +=1
					$c =StringMid($line,$i,1)
				WEnd				
				$SecondArray[$Array2]= $Find
				$Array2 +=1
			EndIf
		Next
	ExitLoop		
WEnd
EndFunc