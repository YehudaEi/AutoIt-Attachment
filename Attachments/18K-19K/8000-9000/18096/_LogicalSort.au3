#include-once
#cs 				about _LogicalSort()
Script Author:		james3mg
AutoIt Version:		3.2.x and above (probably below as well, not tested)

Description:		Allows you to sort a list of text items 'logially' (ie similar to Win2000 and above's Explorer by default) so that
					embedded numbers (especially multi-digit numbers) are read as numbers, rather than character-by-character.  That is,
					resulting in a sorted list of file1.txt, file2.txt, file10.txt rather than file1.txt, file10.txt, file2.txt.
					Uses ASCII codes for ordering, so may produce some 'illogical' results (ie { | and ~ are actually sorted AFTER
					lowercase letters).  Refer to AutoIt Help's ASCII Characters section to see the order.

Parameters:			$_ls_list		the list to be sorted, either in a pipe (|)-delimited string, or in a single-dimensional array (required)
					$_ls_start		the index number of a 0-based array to begin sorting from.  Usually 0 or 1.  Default is 0.  Useful for
									sorting arrays containing the number of elements in the array in [0], which should not be sorted.  No effect
									if $_ls_list is a string rather than an array.

Return values:
					@error:		return value:		@extended:		meaning:
					0			sorted array		""				success
					1 			original list 		""				bad list - must be an array or pipe-delimited string
					2			original list		""				array has too many dimensions
					3			original list		""				no sorting to be done ($_ls_start too high, or too few elements in the list to be sorted)

Requirements:		None (relies almost exclusively on AutoIt functions UBound() and Asc().

Modifications:		Dec 17, 2007: initial release
					Dec 19, 2007: fixed illogical handling of uppercase and lowercase letters (ALL uppercase letters came before ANY lowercase letters)
#ce
Func _LogicalSort($_ls_list,$_ls_start=0)
#region initial setup and error checking
	Local $_ls_tmp, $_ls_tmp_array, $_ls_longestStrLen=0, $_ls_i, $_ls_n, $_ls_c, $_ls_row, $_ls_col
	If NOT IsArray($_ls_list) AND StringInStr($_ls_list,"|")=0 Then Return(SetError(1,"",$_ls_list));if the list isn't an array or pipe (|)-separated string, exit with an error code of 1
	If NOT IsArray($_ls_list) Then;if the list is a string, then
		$_ls_list=StringSplit($_ls_list,"|");split it at the pipes and make it an array
		For $_ls_i=1 To UBound($_ls_list)-1;for each element in the array
			$_ls_list[$_ls_i-1]=$_ls_list[$_ls_i];move all the numbers 'down' one array index, losing the number stored in [0]
		Next
		ReDim $_ls_list[UBound($_ls_list)-1];get rid of the extra index at the top (end) of the array
		$_ls_start=0;since this parameter has no effect on a string list, override anything they may have entered here so it starts sorting at element 0
	ElseIf UBound($_ls_list,0) <> 1 Then;elseif the array isn't one-dimensional, then
		Return(SetError(2,"",$_ls_list));exit with an error code of 2
	EndIf
	If UBound($_ls_list) <= 1 OR UBound($_ls_list)-1 <= $_ls_start Then Return(SetError(3,"",$_ls_list));if the array doesn't have two or more elements to sort, then exit with error code of 3 (there's no sorting to be done)
	;ok, now the lists are valid, set up and ready to start sorting
#endregion initial setup and error checking
;here's how this works::
;Step 1: make a multi-dimensional array, with each 'row' being one of the list entries, and each column holding either one alpha character, or as many numbers as are consecutive.
;Step 2: go through the first column, starting with entry $_ls_start+1, comparing each entry with the one above it - if the (lower) entry has a smaller Asc() code than the one above it, then move the whole row up and do it again, following the 'moving' element until it doesn't move any higher (correctly ordered or at $_ls_start), then move down to the next element and repeat
;Step 3: for each identical first column, run the sort again on the second column.
;Step 4: for each identical first and second column, run the sort again on the third column, and so on.
;Step 5: recompose each row into a single-dimensional array, and return the final array
#region Step 1
	;first find the longest string:
	For $_ls_i=0 To UBound($_ls_list)-1;for each element in the array (even ones not being sorted)
		If StringLen($_ls_list[$_ls_i]) > $_ls_longestStrLen Then $_ls_longestStrLen=StringLen($_ls_list[$_ls_i]);if the length of the element is the longest one found yet, store the number in $_ls_longestStrLen
	Next
	;now make the array that's one character per cell:
	Dim $_ls_tmp_array[UBound($_ls_list)][$_ls_longestStrLen];this array has enough rows to hold each list item, and enough columns to hold one character in each column per row
	For $_ls_i=0 To UBound($_ls_list)-1;for each element in the array
		$_ls_tmp=StringSplit($_ls_list[$_ls_i],"");split the list item into its characters
		For $_ls_n=1 To $_ls_tmp[0];for each character in the list item
			$_ls_tmp_array[$_ls_i][$_ls_n-1]=$_ls_tmp[$_ls_n];write it into its cell in $_ls_tmp_array
		Next
	Next
	;now combine consecutice digits into a number string in a single cell:
	For $_ls_i=0 To UBound($_ls_tmp_array)-1;for each row (list item)
		For $_ls_n=0 To $_ls_longestStrLen-1;and each column within it
			If 47 < Asc($_ls_tmp_array[$_ls_i][$_ls_n]) AND Asc($_ls_tmp_array[$_ls_i][$_ls_n]) < 58 Then;if the character is a number, then
				If 47 < Asc($_ls_tmp_array[$_ls_i][$_ls_n+1]) AND Asc($_ls_tmp_array[$_ls_i][$_ls_n+1]) < 58 Then;if the next character is also a number, then
					Do
						$_ls_tmp_array[$_ls_i][$_ls_n]&=$_ls_tmp_array[$_ls_i][$_ls_n+1];combine the next number into the current cell
						For $_ls_c=1 To $_ls_longestStrLen-2-$_ls_n;for each remaining character in the string
							$_ls_tmp_array[$_ls_i][$_ls_n+$_ls_c]=$_ls_tmp_array[$_ls_i][$_ls_n+$_ls_c+1];shift it over one to fill the empty cell
						Next
						$_ls_tmp_array[$_ls_i][$_ls_longestStrLen-StringLen($_ls_tmp_array[$_ls_i][$_ls_n])+1]="";erase the latent character at the end of the string
					Until NOT (47 < Asc($_ls_tmp_array[$_ls_i][$_ls_n+1]) AND Asc($_ls_tmp_array[$_ls_i][$_ls_n+1]) < 58) OR $_ls_tmp_array[$_ls_i][$_ls_n+1]="";until the next character isn't a number or the end of the string is reached.
				EndIf
				$_ls_tmp_array[$_ls_i][$_ls_n]=Number($_ls_tmp_array[$_ls_i][$_ls_n]);make the contents of the cell an actual number type, so IsNum() works
			EndIf
		Next
	Next
	;_ArrayDisplay($_ls_tmp_array);check for Step 1 - needs array.au3 included.
#endregion Step 1
#region Steps 2-4
	For $_ls_col=0 To $_ls_longestStrLen-1;for every column (characters or number strings) in the rows,
		For $_ls_i=$_ls_start+1 To UBound($_ls_list)-1;and each sortable list item (row) with a sortable row above it (for comparing to),
			For $_ls_c=0 To $_ls_col-1;check every column leading up to the current one in the current row and the one above it
				If StringLower($_ls_tmp_array[$_ls_i][$_ls_c]) <> StringLower($_ls_tmp_array[$_ls_i-1][$_ls_c]) Then ContinueLoop 2;and if they're not equal at any point, move one row down and continue checking for identical leading cols - no sorting will be done on this one at this point.
			Next
			;getting here means that sorting needs to run on this column-everything's equal leading up to it
			If (IsNumber($_ls_tmp_array[$_ls_i][$_ls_col]) AND NOT IsNumber($_ls_tmp_array[$_ls_i-1][$_ls_col]) AND Asc(String(StringLeft($_ls_tmp_array[$_ls_i][$_ls_col],1))) < Asc(StringLower($_ls_tmp_array[$_ls_i-1][$_ls_col]))) _ ;if the second cell is a number, the first isn't, and the first digit in the number has a smaller ascii code than the character,
			OR (NOT IsNumber($_ls_tmp_array[$_ls_i][$_ls_col]) AND IsNumber($_ls_tmp_array[$_ls_i-1][$_ls_col]) AND Asc(StringLower($_ls_tmp_array[$_ls_i][$_ls_col])) < Asc(String(StringLeft($_ls_tmp_array[$_ls_i-1][$_ls_col],1)))) _;OR the second cell is a character, the first is a number, and the character's ascii code is smaller than the ascii code of the first digit in the number,
			OR (IsNumber($_ls_tmp_array[$_ls_i][$_ls_col]) AND IsNumber($_ls_tmp_array[$_ls_i-1][$_ls_col]) AND $_ls_tmp_array[$_ls_i][$_ls_col] < $_ls_tmp_array[$_ls_i-1][$_ls_col]) _ ;OR they're both numbers and the second is smaller than the first
			OR (NOT IsNumber($_ls_tmp_array[$_ls_i][$_ls_col]) AND NOT IsNumber($_ls_tmp_array[$_ls_i-1][$_ls_col]) AND Asc(StringLower($_ls_tmp_array[$_ls_i][$_ls_col])) < Asc(StringLower($_ls_tmp_array[$_ls_i-1][$_ls_col]))) Then;OR they're both not numbers and the second has a smaller ascii code than the first, THEN
				;ConsoleWrite($_ls_tmp_array[$_ls_i][$_ls_col] & " is smaller than " & $_ls_tmp_array[$_ls_i-1][$_ls_col]&@CRLF);for troubleshooting, I can uncomment this to watch the process in SciTE
				For $_ls_n=0 To $_ls_longestStrLen-1;move the smaller list item up, and the larger one down (switch their places) by:
					$_ls_tmp=$_ls_tmp_array[$_ls_i-1][$_ls_n];1) store each col. of the larger list item
					$_ls_tmp_array[$_ls_i-1][$_ls_n]=$_ls_tmp_array[$_ls_i][$_ls_n];2) replace each col. of the larger list item with the same col. of the smaller list item
					$_ls_tmp_array[$_ls_i][$_ls_n]=$_ls_tmp;3) replace each col. of the original smaller list item with the same col of the larger list item (remembered in the temporary variable)
				Next
				$_ls_i-=2;make the loop keep stepping 'up' the list, one line at a time
				If $_ls_i<$_ls_start Then ContinueLoop 2;don't step 'up' the line so far that you start sorting rows that shouldn't be or exceed the dims of the array.
			EndIf
		Next
	Next
#endregion Steps 2-4
#region Step 5
	For $_ls_i=0 To UBound($_ls_list)-1;for every element in the list (sorted and un-sorted)
		$_ls_list[$_ls_i]="";clear out the listitem's text
		For $_ls_n=0 To $_ls_longestStrLen-1;for every character/number string in each row
			$_ls_list[$_ls_i]&=$_ls_tmp_array[$_ls_i][$_ls_n];add into the final list the next character/number string
		Next
	Next
	$_ls_tmp_array="";free memory-just in case
	Return(SetError(0,"",$_ls_list));exit sucessfully
#endregion Step 5
EndFunc