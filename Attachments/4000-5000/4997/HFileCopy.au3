Func FileAction($Action, $SourceFile, $DestinationFile)
	
	
	$i = FileGetSize($SourceFile)
	If $i = 0 Then ;File not found or file does not exist
		MsgBox(48, @ScriptName, 'Source File Not Found!')
		Return 0 ;error
	Else		
		
		;Timing	
 		$i = $i / 1024   		
		$i = $i / 1000		
   		$estimate = Round($i)				
   		; $estimate is now a rough estimate of the filesize
   		; string count $i: if $i = 4 (2343 MB) then divide by string count 3.1 (3characters.last character) , example... 2343 / 234.3 will give you ten
   		; if stringcount = 3 example 596 then DIV 59.6, if stringcount 2 example 15 then div by 1.5
   		$c = StringLen($estimate)		
   		$c_left = StringLeft($estimate, ($c - 1))
   		$c_right = StringRight($estimate, 1)
   		$div_nr = $c_left & "." & $c_right   ;The Nr to divide the kilobytes with to get 10.
   		$k = 100 / $div_nr
   		$t = ($div_nr / $k) / 10
		
   		;FileCopy		
		;Copy or Move the File... Depending on $Action
		$procid = Run(@ComSpec & ' /c ' & $Action & ' "' & $SourceFile & '" "' & $DestinationFile & '"', '', @SW_HIDE)
		$t = $t * 1000
		$t = Round($t, -1)
		ProgressOn(@ScriptName, "File " & StringLower($Action) & " in progress...", "0 percent")
		For $z = 1 To 100
			Sleep($t)
			If ProcessExists($procid) Then
				ProgressSet($z, $z & " percent" & Chr(13)  & Chr (13) & 'Source: ' & $SourceFile & Chr(13) & 'Destination: ' & $DestinationFile)
			Else ;File has finished copying and we need to rush the progressbar
				
				For $n = $z To 100
					Sleep(20)
					ProgressSet($n, $n & " percent" & Chr (13) & 'Source: ' & $SourceFile & Chr(13) & 'Destination: ' & $DestinationFile)
					If $n = 100 Then
						$z = 100;
						ProgressSet($z, $z & " percent - Done!")
						Sleep(1000)
						If not (ProcessExists($procid)) Then
							ProgressOff()
						EndIf
					EndIf
					
				Next
			EndIf
			
			
			If ($z = 100) And (ProcessExists($procid)) Then ;Progressbar is at 100% and the file is still copying.
				ProcessWaitClose($procid)
				ProgressSet($z, $z & " percent - Done!")
				Sleep(1000)
			EndIf	
			
		Next
		
	EndIf
	
	
	
EndFunc   ;==>FileAction