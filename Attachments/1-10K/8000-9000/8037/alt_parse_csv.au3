; AutoIt 3 code to read a .csv file line by line
;
; notes
;  1. this does not rely purely on - StringSplit($line, ",") which does NOT handle quoted fields with commas correctly
;  2. it assumes that the first line of the .csv file contains column headings
;  3. this version contains FileWrite instructions so you may see the input and output to validate the code

;example of .csv data handled (plus semi-colon)

;C1,C2,C3,C4,C5,C6,C7
;1,2,Hello world,wow, asdasd asdasd,,
;"Hello, World",wow, asdasd asdasd,,,,
;"Hello1, World1",wow1, asdasd1 asdasd1,,,,
;"Hello2, World2",wow2, asdasd2 asdasd2,,,,
;This is Field1,Field2,Field3,Field4,field5,field6,"Field7,8,9"


Dim $handle, $file, $line, $l, $f, $result, $len, $part


$file = FileOpen("trial.csv", 0) ; input file

; Check if file opened for reading OK
If $file = -1 Then
   MsgBox(0, "Error", "Unable to open file.")
   Exit
EndIf

$handle = FileOpen("trial.txt", 2) ; output file


While 1 ; Read in lines of text until the EOF is reached

   $line = FileReadLine($file)
   If @error = -1 Then ExitLoop

   FileWrite($handle, $line & @CRLF)

   $l = $l + 1
   $f = 0

   ;for MANY .csv files, the first line contains the headings - this is assumed here
   if $l = 1 then
      $Heading = StringSplit($line, ",")
      $Column = $Heading

   else ; data rows (not headings)

      ; test if the file line contains a quote, if it does do not use -StringSplit- on comma
      $result = StringInStr($line, """")
      if $result > 0 then

         $len = StringLen($line)

         While StringLen($line) > 0
            if StringMid($line, 1, 1 ) = """" then ; field is quoted, so goto next quote
      
               $f = $f + 1
               $part = StringMid($line,2, StringInStr($line,"""",1,2)-2)
               $line = StringMid($line, StringLen($part) + 4)
               $Column[$f] = $part
      
      
            else ; unquoted field, goto next comma   
      
               $f = $f + 1
               $part = StringMid($line,1, StringInStr($line,",",1,1)-1)
               $line = StringMid($line, StringLen($part) + 2)
               $Column[$f] = $part
      
      
            endif
         Wend

      else ; otherwise the file line has no quotes and we can -StringSpilt- using comma

         $Column = StringSplit($line, ",")

      endif ; do lines contain quoted fields


   endif ; heading or data row

   for $i = 1 to $Column[0]
      FileWrite($handle, $Column[$i] & "|")
   next
   FileWrite($handle, @CRLF & @CRLF)

wend ; finish reading input file


FileClose($handle) ; output file


;example output, note the use of | as alternative deleimiter

;C1,C2,C3,C4,C5,C6,C7
;C1|C2|C3|C4|C5|C6|C7|
;
;1,2,Hello world,wow, asdasd asdasd,,
;1|2|Hello world|wow| asdasd asdasd|||
;
;"Hello, World",wow, asdasd asdasd,,,,
;Hello, World|wow| asdasd asdasd|||||
;
;"Hello1, World1",wow1, asdasd1 asdasd1,,,,
;Hello1, World1|wow1| asdasd1 asdasd1|||||
;
;"Hello2, World2",wow2, asdasd2 asdasd2,,,,
;Hello2, World2|wow2| asdasd2 asdasd2|||||
;
;This is Field1,Field2,Field3,Field4,field5,field6,"Field7,8,9"
;This is Field1|Field2|Field3|Field4|field5|field6|Field7,8,9|
;
