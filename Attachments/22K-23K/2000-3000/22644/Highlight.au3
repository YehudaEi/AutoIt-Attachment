#include <Word.au3>

#cs
	Copyright 2008 PoorLuzer@gmail.com
#ce

const $wdFindStop = 0

const $wdAuto = 0

const $wdPink = 5
const $wdRed = 6
const $wdYellow = 7
const $wdGreen = 11
const $wdDarkRed = 13
const $wdDarkYellow = 14
const $wdGray50 = 15
const $wdGray25 = 16 

	MsgBox(0, "ALERT!", "After clicking OK on this message box, immediately bring the WORD window into focus!")

	Sleep(5000)

	$hWndWORD = WinGetHandle("[ACTIVE]", "")

	If 0 == $hWndWORD Then
	
		MsgBox(0, $msgBoxTitle, "WORD Failed!", 5)
		MsgBox(0, $msgBoxTitle, @ERROR)
		Exit
	EndIf
	
	$oWordApp = _WordAttach($hWndWORD, "HWND")
	
	If Not @error Then
	
	    $oDoc = _WordDocGetCollection ($oWordApp, 0)
	    
		If Not @error Then
		
		  MsgBox(64, "Document FileName", $oDoc.FullName)
		Else
			MsgBox(64, "Failed", $oDoc.FullName)
			Exit
		EndIf
	EndIf

	$Rng = $oDoc.Range.Duplicate
	
	With $Rng.Find
	
	    .ClearFormatting()
	    .Format = True
	    .Highlight = True
	    .Wrap = $wdFindStop
	    .Text = ""
	    
	    While $Rng.Find.Execute
	    
	        If $Rng.Find.Found Then
	        
					    If $wdRed == $Rng.HighlightColorIndex Then
					    
	                $Rng.HighlightColorIndex = $wdAuto
	                $Rng.Bold = True
	            EndIf
	        EndIf
	        
	        $Rng.Start = $Rng.End + 1
	        $Rng.End = $oDoc.Range.End
	    WEnd
	EndWith

	MsgBox(64, "Done", $oDoc.FullName)