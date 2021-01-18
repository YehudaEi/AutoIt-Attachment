#cs

TIFF2JPGS
---------
Multi-Page TIFF to separate JPG file converter


THIS SCRIPT NEEDS THE FREEIMAGE LIBRARY DLL FILE (FreeImage.dll) IN THE SCRIPT DIRECTORY
I got my copy at http://freeimage.sourceforge.net/download.html



Background
----------
I needed a stupid utility to do a very simple task: split multi-pages TIFF files into separate JPG files.
Did some research on Download.com and Google, and except for gazillions of useless shareware, there was nothing good/simple enough for me.
No way I'm going to pay 20$ for such a basic task.

So I found this freeware library (FreeImage), and wrote this simple script.
I actually spent more time figuring out how to use DllCall than writing the script ;-)



Usage
-----
Start the script - you get a "OpenFile" dialog, where you pick your TIFF file.
Then the process automatically starts, and a message box appears at the end when the process is done.

The output JPG files are saved in the same directory as the input TIFF file.
The name of the output JPG are generated based on the input TIFF file name.

So it's as simple as it gets:
-start
-pick input file
-click ok when it's done


Future plans
------------
I plan to put this on download.com as a shareware and ask 20$ to get the full version ;-)


Questions / Comments:
---------------------
Post them on AutoIT forum!




Notes
-----
This script seems prone to crashes.
For some reasons, sometimes I add messages boxes or other lines of codes playing with variables,
and the end result is AutoIT crashing when the script ends.

If someone notice something obviously stupid/wrong in my DLL Calls, please post such comment/fixes on
AutoIT forum! I did this mostly by trial-and-error, and once it worked, I stopped changing my code!

#ce


;Input file to split
$input = FileOpenDialog("Choose a TIFF file", @ScriptDir, "TIFF files (*.TIF)")


;Output file convention is simple: I remove the extension, append an underscore '_'.
;The loop (below) will further append the page number and add the ".jpg" extension.
;If I picked a file named "IMAGE.TIF", the output will be "IMAGE_1.JPG", "IMAGE_2.JPG" and so on.
$output = StringTrimRight($input,4) & "_"


;Filename of the FreeImage Dll.
$FI_DLL = @ScriptDir & "\FreeImage.dll"


;Theses are constants used by FreeImage.
;I got the values from the header file (FreeImage.h) included with the FreeImage dll download.
Global const $FIF_JPEG	= 2
Global const $FIF_TIFF	= 18


;Some basic check... does the TIFF file exists?
if FileExists($input) then
	
	;Yet another check - does the FreeImage DLL is there?
	if FileExists($FI_DLL) then
				
		;At this point, I start the process!
		
		
		;Opens the FreeImage DLL
		$FI = DllOpen($FI_DLL)

		;Initialize the library (mandatory according to the documentation0
		DllCall($FI,"none","_FreeImage_Initialise@4","dword",1)

		;Opens the input TIFF file.
		$TIFF_IMAGE = DllCall($FI,"long_ptr","_FreeImage_OpenMultiBitmap@24","dword", $FIF_TIFF, "str", $input, "dword", 0, "dword", 1, "dword", 0, "dword", 0)

		;Gets the number of pages from the TIFF image
		$PAGE_COUNT = DllCall($FI, "int", "_FreeImage_GetPageCount@4", "long_ptr", $TIFF_IMAGE[0])

		;Page index are 0-based. For a loop, I'll need to go from 0 to (PAGE_COUNT -1)
		$PAGE_COUNT = $PAGE_COUNT[0] -1

		;The way FreeImage lib works, you need to "lock" a single page at a time to work with it.
		;I understands that this will actually copy the page into a separate bitmap, so I can play with it
		;In my case, I just want to save each page into an individual JPG file
		for $i = 0 to $PAGE_COUNT
			
			;Get a page from the multi-page TIFF file
			$BITMAP = DllCall($FI, "long_ptr", "_FreeImage_LockPage@8", "long_ptr", $TIFF_IMAGE[0], "dword", $i)
			
			;Save it as a JPG file
			$ret = DllCall($FI, "dword", "_FreeImage_Save@16","dword", $FIF_JPEG, "long_ptr", $BITMAP[0], "str", $output & $i & ".jpg", "dword", 0)

			;Unlock the page.
			$ret = DllCall($FI, "none", "_FreeImage_UnlockPage@12", "long_ptr", $TIFF_IMAGE[0], "long_ptr", $BITMAP[0], "dword", 0)
			
			;Free the RAM? AutoIT tends to crash at the end if I do not do this (Can't tell - I'm no developper)
			$BITMAP = 0
		next
		
		MsgBox(64,"Info","Process is done." & @crlf & $input & " were splitted into " & $PAGE_COUNT+1 & " individual JPG files")
		
		;Close the TIFF file
		$ret = DllCall($FI,"long","_FreeImage_CloseMultiBitmap@8","long_ptr", $TIFF_IMAGE[0], "dword", 0)

		;Again, if I do not reassign some variables like this, I usually have a crash when the program ends.
		$TIFF_IMAGE = 0

		;This will "DeInitialize" the FreeImage lib
		;I *think* this does more or less the same as DllClose(), but I can be wrong.
		DllCall($FI,"none","_FreeImage_DeInitialise@0")

	Else
		MsgBox(16,"FreeImage DLL not found","The FreeImage DLL was not found in the script directory." & @crlf & "(" & $FI_DLL & ")" & @crlf & @crlf & "You can get if from this website:" & @crlf & "http://freeimage.sourceforge.net/download.html")
	EndIf
Else
	MsgBox(16,"File not found","You should have a TIFF file named " & $input & " in this script directory. Check this and try again")
EndIf
