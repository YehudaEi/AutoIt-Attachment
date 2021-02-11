#include <extprop.au3>
$filename = FileOpenDialog("PaperCut - Open file",@DesktopDir,"All (*.*)")
$array = StringSplit(_GetExtProperty($filename,31), ' x ', 1)
$iwidth = $array[1]

$iheight = $array[2]
MsgBox(1,"",  $array[0] & " " & $array[1] & " " & $array[2])

$align = InputBox("Landscape or portrait..", "Should the A4 be in Landscape or Portrait mode? 1 = Portrait, 2 = Landscape")
$type = InputBox("Type of cuts?", "1 = Dpi, 2 = Height in cm, 3 = Width in cm")
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
		$width = $iwidth / $dpi * 2.54
		$xpaper = $width / $x

		$xseg = $iwidth / $xpaper
		$height = $iheight / $dpi * 2.54
		$ypaper = $height / $y
		$yseg = $iheight / $ypaper
		If $xpaper >= 1 Then
			if floor($xpaper) > 0 Then
			Dim $xcuts[Floor($xpaper)]
			For $i = 0 To Floor($xpaper) - 1
				$xcuts[$i] = $xseg * ($i + 1)
			Next
			EndIf
		EndIf
		If $ypaper >= 1 Then
			if floor($ypaper) > 0 Then
			Dim $ycuts[Floor($ypaper)]
			For $i = 0 To Floor($ypaper) - 1
				$ycuts[$i] = $yseg * ($i + 1)
			Next
			EndIf
		EndIf
	Case "2"
		$height = InputBox("Height", "What height should it be? In cm")
		$ypaper = $height / $y
		$yseg = $iheight / $ypaper
		$xseg = $yseg * $x / $y
		$width = 0.5
		$whidth = $iwidth / $xseg * $x
		$dpi = $iheight / $height * 2.54
		$xpaper = $width / $x
		If $xpaper >= 1 Then
			Dim $xcuts[Floor($xpaper)]
			For $i = 0 To Floor($xpaper) - 1
				$xcuts[$i] = $xseg * ($i + 1)
			Next
		EndIf
		If $ypaper >= 1 Then
			Dim $ycuts[Floor($ypaper)]
			For $i = 0 To Floor($ypaper) - 1
				$ycuts[$i] = $yseg * ($i + 1)
			Next
		EndIf
	Case "3"
		$width = InputBox("Width", "What width should it be? In cm")
		$xpaper = $width / $x
		$xseg = $iwidth / $xpaper
		$yseg = $xseg * $y / $x
		$height = $iheight / $yseg * $y
		$dpi = $iwidth / $width * 2.54
		$ypaper = $height / $y
		If $xpaper > 0 Then
			Dim $xcuts[Floor($xpaper)]
			For $i = 0 To Floor($xpaper) - 1
				$xcuts[$i] = $xseg * ($i + 1)
			Next
		EndIf
		If $ypaper > 0 Then
			Dim $ycuts[Floor($ypaper)]
			For $i = 0 To Floor($ypaper) - 1
				$ycuts[$i] = $yseg * ($i + 1)
			Next
		EndIf
EndSwitch

If $ypaper > 1 Then
;	If Floor($yseg) > $iheight Then
		$message = "Y section is " & Round($yseg, 1) & "px large and the cuts are as folows:"
		For $i = 0 To Floor($ypaper) - 1
			if round($ycuts[$i],1) < $iheight Then
			$message = $message & @CRLF & "cut " & $i + 1 & " = " & Round($ycuts[$i], 1) & "px."
			EndIf
		Next
;	Else
;		$message = $message & @CRLF & "There is no cuts on the height."
;	EndIf
Else
	$message = "There is no cuts on the height."
EndIf
MsgBox(1,"error",$xpaper)
If $xpaper > 1 Then
;	If Floor($xseg) > $iwidth Then
		$message = $message & @CRLF & "X section is " & Round($xseg, 1) & "px large and the cuts are as follows:"
		For $i = 0 To Floor($xpaper) - 1
			if round($xcuts[$i],1) < $iwidth Then
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
MsgBox(1, "What to do..", $message)

$file = FileOpen(@DesktopDir & "\open_with_imagecut.icut",2)

if $align = 1 Then
	$write = "SPLT 1.1" & @CRLF & $filename & @CRLF & "0" & @CRLF & floor($xpaper)
	For $i = 0 To Floor($xpaper) - 1
		$write = $write & @CRLF & 10-$i & " "  & Round($xcuts[$i]) & " 1 2"
	Next
	$write = $write & @CRLF & @CRLF & floor($ypaper)
	For $i = 0 To Floor($ypaper) - 1
		$write = $write & @CRLF & 10-$i & " " & Round($ycuts[$i]) & " 3 4"
	Next
Else
	$write = "SPLT 1.1" & @CRLF & $filename & @CRLF & "0" & @CRLF & floor($xpaper)
	For $i = 0 To Floor($xpaper) - 1
		$write = $write & @CRLF & 10-$i & " " & Round($xcuts[$i]) & " 1 2"
	Next
	$write = $write & @CRLF & @CRLF & floor($ypaper)
	For $i = 0 To Floor($ypaper) - 1
		$write = $write & @CRLF & 10-$i & " "  & Round($ycuts[$i]) & " 3 4"
	Next
EndIf
FileWrite($file,$write)
FileClose($file)