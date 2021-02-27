
#include <file.au3>
#include <array.au3>

Dim $PS, $szDrive, $szDir, $szFName, $szExt
Const $File = FileOpen(@ScriptDir & "\Barcode.ps", 2)

$PS = ""
$Input = "AutoIT is Great !!"

; Check if file opened for writing OK
If $File = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

$PS = '%!PS-Adobe-2.0'
$PS = $PS & @CRLF & '% --BEGIN TEMPLATE--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --EXOP: includetext guardwhitespace'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '%!'
$PS = $PS & @CRLF & '% --BEGIN SAMPLE--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% We call the procedures like this:'
$PS = $PS & @CRLF & '/Helvetica findfont 10 scalefont setfont'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% Add Rotated Text'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '/Times-Roman findfont'
$PS = $PS & @CRLF & '32 scalefont'
$PS = $PS & @CRLF & 'setfont'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '100 200 translate'
$PS = $PS & @CRLF & '45 rotate'
$PS = $PS & @CRLF & '2 1 scale'
$PS = $PS & @CRLF & 'newpath'
$PS = $PS & @CRLF & '0 0 moveto'
$PS = $PS & @CRLF & '(' & $Input & ') true charpath'
$PS = $PS & @CRLF & '0.5 setlinewidth'
$PS = $PS & @CRLF & '0.4 setgray'
$PS = $PS & @CRLF & 'stroke'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '/inch {72 mul} def	% Convert inches->points (1/72 inch)'
$PS = $PS & @CRLF & '/Helvetica findfont 40 scalefont setfont %use 40 pt Helvetica font'
$PS = $PS & @CRLF & 'newpath			% Start a new path'
$PS = $PS & @CRLF & '1 inch 1 inch moveto	% an inch in from the lower left'
$PS = $PS & @CRLF & '2 inch 1 inch lineto	% bottom side'
$PS = $PS & @CRLF & '2 inch 2 inch lineto	% right side'
$PS = $PS & @CRLF & '1 inch 2 inch lineto	% top side'
$PS = $PS & @CRLF & '20 setlinewidth 	% fat line 20 pts wide'
$PS = $PS & @CRLF & 'closepath		% Automatically add left side to close path'
$PS = $PS & @CRLF & 'stroke			% nothing is drawn until you stroke the path!'
$PS = $PS & @CRLF & '1.5 inch 2 inch moveto %move to new point to start new object'
$PS = $PS & @CRLF & '1 inch  .1 inch rlineto	% bottom side using relative movement'
$PS = $PS & @CRLF & '-.1 inch 1 inch rlineto	% right side "'
$PS = $PS & @CRLF & '-1 inch -.1 inch rlineto 	% top side "'
$PS = $PS & @CRLF & 'closepath		% Automatically add left side to close path'
$PS = $PS & @CRLF & 'gsave			% Save the above path, for later reuse'
$PS = $PS & @CRLF & '.5 .2 0 setrgbcolor	% change the color to brown'
$PS = $PS & @CRLF & 'fill			% Fill in the box '
$PS = $PS & @CRLF & 'grestore		% restore the previous path, to reuse it'
$PS = $PS & @CRLF & '0 0 1 setrgbcolor %blue'
$PS = $PS & @CRLF & '10 setlinewidth 	% 10 pts wide'
$PS = $PS & @CRLF & 'stroke 			%draw the perimeter of the box'
$PS = $PS & @CRLF & '1 inch 1 inch moveto'
$PS = $PS & @CRLF & '52 rotate'
$PS = $PS & @CRLF & '1 0 0 setrgbcolor %red'
$PS = $PS & @CRLF & '(But is it art?) show'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & 'showpage'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --END SAMPLE--'

FileWriteLine($File, $PS)
FileClose($File)

ShellExecuteWait("prfile32.exe","Barcode.ps","")

FileDelete(@scriptdir & "\Barcode.ps")