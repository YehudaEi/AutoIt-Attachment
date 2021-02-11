#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <extprop.au3>
#include <Array.au3>
Global $iwidth
Global $iheight
Global $file
Global $message
Global $align
Global $area
Global $dpi
Global $array[3]
Global $filename
Global $height
Global $width
Global $i
Global $x
Global $y
Global $type
Global $xpaper
Global $ypaper
Global $yseg
Global $paper
Global $write
Global $xseg

MsgBox(0,"PaperCut","This program creates an project file for the image splitting program 'ImageCut'. You should know that this program might be (and probably is) full of bugs..")
if @error then Exit
$filename = FileOpenDialog("PaperCut - Open file", @DesktopDir, "All (*.*)")
if @error then Exit
If InputBox("PaperCut", "Are you awesome(a.k.a does this shitty program work like it did on my computer)? 1 - Yes, 2 - No") Then
	if @error then Exit
	$array = StringSplit(_GetExtProperty($filename, 31), ' x ', 1)

	$iwidth = Number(StringTrimLeft(BinaryToString(StringToBinary($array[1])), 1))

	$iheight = $array[2]
Else
	$iwidth = InputBox("PaperCut", "Input Width:")
	if @error then Exit
	$iheight = InputBox("PaperCut", "Input Height:")
	if @error then Exit
EndIf
$align = InputBox("Landscape or portrait..", "Should the A4 be in Landscape or Portrait mode? 1 = Portrait, 2 = Landscape")
if @error then Exit
$type = InputBox("Type of cuts?", "1 = Dpi, 2 = Height in cm, 3 = width in cm")
if @error then Exit
$message = ""

If $align = 1 Then
	$y = 29.7
	$x = 21
Else
	$y = 21
	$x = 29.7
EndIf

Switch $type
	Case "1"
		$dpi = InputBox("Dpi", "what dpi should the printed image be?")
		if @error then Exit
		$width = $iwidth / $dpi * 2.54
		$xpaper = $width / $x
		$xseg = $iwidth / $xpaper
		$height = $iheight / $dpi * 2.54
		$ypaper = $height / $y
		$yseg = $iheight / $ypaper
		If $xpaper >= 1 Then
			If Floor($xpaper) > 0 Then
				Global $xcuts[Floor($xpaper)]
				For $i = 0 To Floor($xpaper) - 1
					$xcuts[$i] = $xseg * ($i + 1)
				Next
			EndIf
		EndIf
		If $ypaper >= 1 Then
			If Floor($ypaper) > 0 Then
				Global $ycuts[Floor($ypaper)]
				For $i = 0 To Floor($ypaper) - 1
					$ycuts[$i] = $yseg * ($i + 1)
				Next
			EndIf
		EndIf
	Case "2"
		$height = InputBox("Height", "What height should it be? In cm")
		if @error then Exit
		$ypaper = $height / $y
		$yseg = $iheight / $ypaper
		$xseg = $yseg * $x / $y
		$width = 0.5
		$width = $iwidth / $xseg * $x
		$dpi = $iheight / $height * 2.54
		$xpaper = $width / $x
		If $xpaper >= 1 Then
			Global $xcuts[Floor($xpaper)]
			For $i = 0 To Floor($xpaper) - 1
				$xcuts[$i] = $xseg * ($i + 1)
			Next
		EndIf
		If $ypaper >= 1 Then
			Global $ycuts[Floor($ypaper)]
			For $i = 0 To Floor($ypaper) - 1
				$ycuts[$i] = $yseg * ($i + 1)
			Next
		EndIf
	Case "3"
		$width = InputBox("width", "What width should it be? In cm")
		if @error then Exit
		$xpaper = $width / $x
		$xseg = $iwidth / $xpaper
		$yseg = $xseg * $y / $x
		$height = $iheight / $yseg * $y
		$dpi = $iwidth / $width * 2.54
		$ypaper = $height / $y
		If $xpaper >= 1 Then
			Global $xcuts[Floor($xpaper)]
			For $i = 0 To Floor($xpaper) - 1
				$xcuts[$i] = $xseg * ($i + 1)
			Next
		EndIf
		If $ypaper >= 1 Then
			Global $ycuts[Floor($ypaper)]
			For $i = 0 To Floor($ypaper) - 1
				$ycuts[$i] = $yseg * ($i + 1)
			Next
		EndIf
EndSwitch

If $ypaper > 1 Then
	;	If Floor($yseg) > $iheight Then
	$message = "Y section is " & Round($yseg, 1) & "px large and the cuts are as folows:"
	For $i = 0 To Floor($ypaper) - 1
		If Round($ycuts[$i], 1) < $iheight Then
			$message = $message & @CRLF & "cut " & $i + 1 & " = " & Round($ycuts[$i], 1) & "px."
		EndIf
	Next
	;	Else
	;		$message = $message & @CRLF & "There is no cuts on the height."
	;	EndIf
Else
	$message = "There is no cuts on the height."
EndIf
If $xpaper > 1 Then
	;	If Floor($xseg) > $iwidth Then
	$message = $message & @CRLF & "X section is " & Round($xseg, 1) & "px large and the cuts are as follows:"
	For $i = 0 To Floor($xpaper) - 1
		If Round($xcuts[$i], 1) < $iwidth Then
			$message = $message & "" & @CRLF & "cut " & $i + 1 & " = " & Round($xcuts[$i], 1) & "px."
		EndIf
	Next
	;	Else
	;		$message = $message & @CRLF & "There is no cuts on the width."
	;	EndIf
Else
	$message = $message & @CRLF & "There is no cuts on the width."
EndIf
$message = $message & @CRLF & "The dpi is " & Round($dpi, 1) & "dpi." & @CRLF & "The height of the printed image is " & Round($height, 1) & "cm, the width is " & Round($width, 1) & "cm." & @CRLF & "This picture requires "
$paper = Ceiling($xpaper) * Ceiling($ypaper)
$area = $xpaper * $ypaper
$message = $message & $paper & " paper"
If $paper <> 1 Then
	$message = $message & "s"
EndIf
$message = $message & ". The printing area is " & Round($area, 1) & " papers."
MsgBox(0, "What to do..", $message)

$file = FileOpen(@DesktopDir & "\open_with_imagecut.icut", 2)

If $align = 1 Then
	$write = "SPLT 1.1" & @CRLF & $filename & @CRLF & "0" & @CRLF & Floor($xpaper)
	For $i = 0 To Floor($xpaper) - 1
		$write = $write & @CRLF & 10 - $i & " " & Round($xcuts[$i]) & " 1 2"
	Next
	$write = $write & @CRLF & @CRLF & Floor($ypaper)
	For $i = 0 To Floor($ypaper) - 1
		$write = $write & @CRLF & 10 - $i & " " & Round($ycuts[$i]) & " 3 4"
	Next
Else
	$write = "SPLT 1.1" & @CRLF & $filename & @CRLF & "0" & @CRLF & Floor($xpaper)
	For $i = 0 To Floor($xpaper) - 1
		$write = $write & @CRLF & 10 - $i & " " & Round($xcuts[$i]) & " 1 2"
	Next
	$write = $write & @CRLF & @CRLF & Floor($ypaper)
	For $i = 0 To Floor($ypaper) - 1
		$write = $write & @CRLF & 10 - $i & " " & Round($ycuts[$i]) & " 3 4"
	Next
EndIf
FileWrite($file, $write)
FileClose($file)