;Scrpit to scan network with nmap
;Puts results in a text File called fw-results.txt
;Opens fwiplist.txt, compares to results.txt, removes ips that responded, saves new
;fwiplist.txt, deletes fw-results.txt
#include <IE.au3>
#include <String.au3>
#include <Array.au3>
#Include <File.au3>


$file = FileOpen ("E:\documents\fwiplist1.txt",2)
$file1 = FileOpen ("E:\documents\results.txt",0) 
$file1 = FileRead ($file1)
$fileread = Fileread ($file)
$x = _FileCountLines ("E:\documents\fwiplist1.txt")


;   If FileRead ($file) = FileRead ($file1) Then
;   MsgBox (0,"","Files are the Same.")
;   Else	
;   MsgBox (0,"","Files are Different.")
;   EndIf


$i = 1
$j = 1
Do
                $line = FileReadLine($file1, $i)
				$line1 = FileReadLine
                $result = StringInStr ($file, $line)
                if $result > 0 Then
                                FileWrite($file2, $line & @CRLF)
                EndIf
                $i = $i + 1
until $i = $x







FileClose($file)
FileClose($file1)
FileDelete ($file1)
