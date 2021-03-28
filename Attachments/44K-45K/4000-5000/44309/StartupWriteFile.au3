$counter = 1
While $counter = 1 ; loops 

   If("063000" > @HOUR & @MIN & @SEC < "071500" ) Then  ; Determines if the time is between 6:30am and 7:15am  
   
	  FileDelete("test.txt") ; Deletes test.txt file (assuming it is already there)
   
	  $file = FileOpen("test.txt", 1) ; Creates new text.txt file

	  FileWrite($file, "Bla bla bla bla" & " " & @MON & "-" & @MDAY & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "-" & @YEAR & @CRLF)  ; (CRLF = Linebreak)   Writes line and records date and time

	  FileClose($file) ; Closes file
   
   Else				   ; If time is not between 6:30am and 7:15am, sleep for another 15 minutes
   Sleep(900000)
  
WEnd ; ends loop (loop should never end)




#comments-start
#comments-end