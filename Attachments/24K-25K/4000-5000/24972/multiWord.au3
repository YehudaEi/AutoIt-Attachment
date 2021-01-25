#NoTrayIcon
#include <GUIConstants.au3>
#include <Array.au3>

HotKeySet("^!f", "showFind")

Dim $find[5]
Dim $word[5]
Dim $findLen[5]
Dim $cur[5]

Global $curVisible = false

;~ Create the GUI
GUICreate("Find Multiple Words", 320, 190, @DesktopWidth / 2 - 160, @DesktopHeight / 2 - 45)
$word[0] = GUICtrlCreateInput("", 10, 5, 300, 20)
$word[1] = GUICtrlCreateInput("", 10, 35, 300, 20)
$word[2] = GUICtrlCreateInput("", 10, 65, 300, 20)
$word[3] = GUICtrlCreateInput("", 10, 95, 300, 20)
$word[4] = GUICtrlCreateInput("", 10, 125, 300, 20)
$btn = GUICtrlCreateButton("&Find", 250, 165, 60, 20)
GuiCtrlSetState(-1, 512) ;this sets the Find button as the accept button for the ENTER key
$label = GUICtrlCreateLabel("",10, 165, 200, 20)

$msg = 0
While 1
    $msg = GUIGetMsg()
    Select
		
	Case $msg = $GUI_EVENT_CLOSE
		;hide the window, this also allows using the ESC key
		showFind()
		
    Case $msg = $btn		
		;grabs the words the user typed in
        For $i = 0 To 4
            $cur[$i] = 0
			$find[$i] = GUICtrlRead($word[$i])
        Next
		
		;this puts each word in order with no blank indexes in the array
        $wordsLen = 0
        For $i = 0 To 4
            If $find[$i] <> "" Then
                $findLen[$i] = StringLen($find[$i])
			Else
;~ 				rearrange as necessary to prevent empty indexes
				For $j = 1 To (4-$i)
					If $find[$i+$j] <> "" Then
						$find[$i] = $find[$i+$j]
						$findLen[$i] = StringLen($find[$i])
						$find[$i+$j] = ""
						ExitLoop
					EndIf
				Next
            EndIf
        Next
		
		;this sets two variables that hold the amount of words searched for, and the length of all the strings together
		For $i = 0 To 4
			If $find[$i] = "" Then
				$amtWords = $i-1
				ExitLoop
			Else
				$wordsLen = $wordsLen + $findLen[$i]
			EndIf
		Next
		If $find[4] <> "" Then
			$amtWords = 4
		EndIf
		
		;makes sure there is at least one word searched for
        If $wordsLen > 1 Then
			GUICtrlSetData( $label, "Searching...") ;so the user knows something is actually happening

			$html = FileOpen("results.html", 2);creates an html file
	   
			Send("!{TAB}")
			Send("^a")
			Send("^c")
			Send("!{TAB}")
			$document = ClipGet();grabs all text from the most recent window
			
			Dim $results[20000][$amtWords + 1]
			Dim $match[1000][2]
			
			;searches the entire document while keeping track of how many times each one is found, and where it is found
            For $pos = 0 To StringLen($document)
                For $i = 0 To $amtWords
                    If $findLen[$i] > 0 Then
                        $testString = StringMid($document, $pos, $findLen[$i])
                        If $testString = $find[$i] Then
                            $results[$cur[$i]][$i] = $pos
                            $cur[$i] += 1
                        EndIf
                    EndIf
                Next
            Next
           
		    ;if one of the words was not found, tell the user and exit the search
			$notFound = false
			For $i = 0 To $amtWords
				If $cur[$i] = 0 Then
					MsgBox(4096, "Not Found", "The word '" & $find[$i] & "' was not found." & @CRLF & "Please choose a new word or remove it from the search box.")
					GUICtrlSetData( $label, "");clear the label
					$notFound = true
					ExitLoop
				EndIf
			Next
			
			If $notFound = false Then
	;~ 		    find the word found the least amount of times
				$leastWord = 0
				For $i = 1 To $amtWords
					If $cur[$i] < $cur[$leastWord] Then
						$leastWord = $i
					EndIf
				Next

				Dim $closest[$amtWords + 1]
				Dim $curPosLow[$amtWords + 1]
				
				
				$curMatch = 0
	;~ 			for each lowest count word
				For $eachLeastWord = 0 To $cur[$leastWord]
	;~ 				for each other word
					For $otherWord = 0 To $amtWords
	;~ 					perform these operations on each word per lowest count word excluding it
						$closest[$otherWord] = 100000
						If $otherWord <> $leastWord Then
	;~ 						for each item of each word excluding the lowest count word
							For $eachOtherWord = 0 To $cur[$otherWord]
	;~ 							Distance between current low count word and current word in column, always positive
								$dist = Abs($results[$eachLeastWord][$leastWord] - $results[$eachOtherWord][$otherWord])
								If $closest[$otherWord] > $dist Then
									$closest[$otherWord] = $dist
	;~ 								this gives us the position of each closest word
									$curPosLow[$otherWord] = $results[$eachOtherWord][$otherWord]
								EndIf
							Next
						Else
							$curPosLow[$otherWord] = $results[$eachLeastWord][$leastWord]
						EndIf
					Next
	;~ 				now that we have an array with the smallest distances, we can recreate the sentence the words are found in
	
	;~ 				first find the smallest value out of all the words
					$curSmall = 100000
					For $l = 0 To $amtWords
						If $curSmall > $curPosLow[$l] Then
							$curSmall = $curPosLow[$l] 
						EndIf
					Next
	;~ 				then the largest value out of all the words
					$curLarge = 0
					$curWordLarge = 0
					For $l = 0 To $amtWords
						If $curLarge < $curPosLow[$l] Then
							$curLarge = $curPosLow[$l]
							$curWordLarge = $l
						EndIf
					Next
					
					;then grab the string starting at the farthest left word, and ending by the farthest right word
					$foundPhrase = StringMid($document, $curSmall, ($curLarge - $curSmall) + $findLen[$curWordLarge])
					$foundPhrase = StringReplace($foundPhrase, @CRLF, "")
					$foundPhrase = StringReplace($foundPhrase, @CR, "")
					$foundPhrase = StringReplace($foundPhrase, @LF, "")
					
					;find the length of the words found, over the length of the phrase in percentage, to two decimal places
					$foundPercent = Round(((($wordsLen + $amtWords) / (StringLen($foundPhrase))) * 100), 2)
					
					;if there is a lack of spaces, it may go over 100
					If $foundPercent > 100 Then
						$foundPercent = 100
					EndIf
					
					;store the percentage
					$match[$curMatch][0] = $foundPercent
					
					;mark each found word as bold and red
					For $w = 0 To $amtWords
						$foundPhrase = StringReplace($foundPhrase, $find[$w], "<font color=red><b>" & $find[$w] & "</b></font>")
					Next
					
					;store the phrase
					$match[$curMatch][1] = $foundPhrase
					;increment the counter
					$curMatch += 1
				Next
				
				;the last two are always garbage, so clear them out
				$match[$curMatch][0] = ""
				$match[$curMatch][1] = ""
				$match[$curMatch - 1][0] = ""
				$match[$curMatch - 1][1] = ""
				
				;order the array descending to show the highest percentage matches first
				_ArraySort($match, 1, 0, 0, 0)
				
				;fixes the last two "extra" finds by leaving them off
				$curMatch = $curMatch - 2
				
				;start the page with the amount of results
				$finalResult = "<font size=5><b>" & ($curMatch + 1) & " results have been found: </b></font><br /><br />"
				For $i = 0 To $curMatch
					;concatenate each found result with proper Result headers
					$finalResult = $finalResult & "<b>Result " & ($i + 1) & ", <i>" & $match[$i][0] & "%</i> Match: </b><br />" & $match[$i][1] & "<br /><br />"
				Next
				
				;put together a string of the searched words, seperated by commas
				$searchedWords = ""
				For $i = 0 To $amtWords
					$searchedWords = $searchedWords & $find[$i] & ", "
				Next
				
				;start the html page with a proper title, then the results in the body, then close the html code
				FileWriteLine($html, "<html><head><title>" & ($curMatch + 1) & " Results For: " & StringMid($searchedWords, 1, StringLen($searchedWords) - 2) & "</title></head><body>" & @CRLF)
				FileWriteLine($html, $finalResult)
				FileWriteLine($html, "</body></html>")
				;close the html file
				FileClose($html)
				
				;hide the window
				showFind()
				
				;open the html file in the default browser
				ShellExecute("results.html")
				
				GUICtrlSetData( $label, "")
			EndIf
        Else
            MsgBox(4096, "Please...", "Please enter at least one word.")
        EndIf
    EndSelect
WEnd

Func showFind()
    If $curVisible = false Then
		$curVisible = true
		;show the find window
		GUISetState(@SW_SHOW)
	Else
		$curVisible = False
		;hide the window
		GUISetState(@SW_HIDE)
	EndIf
EndFunc