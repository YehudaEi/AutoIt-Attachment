#comments-start
**************************************************************************************************************************************
AutoIt Information
--------------------------------------------------------------------------------------------------------------------------------------
   AutoIt Version:   3.0
   Language:         English
   Platform:         Win9x/NT

======================================================================================================================================
Script Information
--------------------------------------------------------------------------------------------------------------------------------------
   Name:             ArrayExamples.au3
   Author:           Matthew Babcock (MPCS)
   Date:             09/08/2004
   
   Purpose:
      This script was created to show basic examples of how to use an array, UBound(), and the For statement.

======================================================================================================================================
Function Directory
--------------------------------------------------------------------------------------------------------------------------------------
   PrintArray()      This function is used to output the array to a text file named "test.txt" in the script root directory
   
======================================================================================================================================
Change Log
--------------------------------------------------------------------------------------------------------------------------------------
   09/08/2004: Created ArrayExamples.au3
               Created function PrintArray v. 1.0
   
**************************************************************************************************************************************
#comments-end

; Variable declaration
Dim $Test_arr[5] ; Five (5) dimensional array, with elements 0,1,2,3,4
Dim $i

; Call the PrintArray function to show that the array is initialized to '0'
;        $Test_arr[0] = 0
;        $Test_arr[1] = 0
;        $Test_arr[2] = 0
;        $Test_arr[3] = 0
;        $Test_arr[4] = 0
PrintArray()

; Set each element to the number '1'
;        $Test_arr[0] = 1
;        $Test_arr[1] = 1
;        $Test_arr[2] = 1
;        $Test_arr[3] = 1
;        $Test_arr[4] = 1
$Test_arr[0] = 1
$Test_arr[1] = 1
$Test_arr[2] = 1
$Test_arr[3] = 1
$Test_arr[4] = 1

PrintArray()

; Loop through assigning the element number as the value (Element = Value)
;        $Test_arr[0] = 0
;        $Test_arr[1] = 1
;        $Test_arr[2] = 2
;        $Test_arr[3] = 3
;        $Test_arr[4] = 4
For $i = 0 to UBound($Test_arr) - 1

   $Test_arr[$i] = $i
   
Next

PrintArray()

; Loop through assigning the element number + 1 as the value (Value = Element + 1)
;        $Test_arr[0] = 1
;        $Test_arr[1] = 2
;        $Test_arr[2] = 3
;        $Test_arr[3] = 4
;        $Test_arr[4] = 5
For $i = 0 to UBound($Test_arr) - 1

   $Test_arr[$i] = $i + 1
   
Next

PrintArray()

; Loop through assinging a random number ( < 10 ) to each element of the array
;        $Test_arr[0] = ?
;        $Test_arr[1] = ?
;        $Test_arr[2] = ?
;        $Test_arr[3] = ?
;        $Test_arr[4] = ?
For $i = 0 to UBound($Test_arr) - 1

   $Test_arr[$i] = Int(Random( 0, 10 ))
   
Next

PrintArray()

; The string split function is used to divide a string into an array
; based on the seperating character (delimeter). The first element
; $Test_arr[0] contains the number of delimeted strings, and the others
; contain the strings in order. In this example,
;        $Test_arr[0] = 4
;        $Test_arr[1] = This
;        $Test_arr[2] = is
;        $Test_arr[3] = a
;        $Test_arr[4] = test
$Test_arr = StringSplit( "This is a test", " " )

PrintArray()

; An array can be erased by setting it equal to something
;        $Test_arr[0] = < Error >
;        $Test_arr[1] = < Error >
;        $Test_arr[2] = < Error >
;        $Test_arr[3] = < Error >
;        $Test_arr[4] = < Error >
$Test_arr = -1

PrintArray()

Func PrintArray()

   FileWriteLine( "test.txt", "Element" & @TAB & @TAB & "Value" )
   
   ; The for loop increments the variable with every pass, until the condition is met. 
   ; UBound() is a function that returns the highest element of the array + 1; in this example 5
   For $i = 0 to UBound($Test_arr) - 1
      
      FileWriteLine( "test.txt", $i & @TAB & @TAB & $Test_arr[$i] )
   
   Next

   FileWriteLine( "test.txt", "" )

EndFunc

#comments-start

By using this code module you take full responsibility the the reproductions of is use. Midwest PC Specialists, Matthew J. Babcock
and their subsidaries take no resonsibility or offer any kind of warrenty for this file. 

© 2004 Midwest PC Specialists & Matthew J. Babcock. This file and the code module it represents may only be used for educational
purposes. It may be distributed freely as long as the entire file, and this disclaimer are passed along with it. By breaking this
disclaimer you will forget any knowledge of this document or the AutoIt Language. lol

© AutoIt is a trademark of Hiddensoft and is in no way related to Midwest PC Specialists, Matthew J. Babcock, or any of their
subsidaries.

#comments-end