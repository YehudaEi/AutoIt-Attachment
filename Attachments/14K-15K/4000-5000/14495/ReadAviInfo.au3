#comments-start
	Sample to read AVI Header Format
	p.t / 6.Mai.2007
	
	http://www.autoitscript.com/forum/index.php?showtopic=45284&hl=
	AVI Header Format
	AVI files contain a 56-byte header, starting at offset 32 within the file.
	
	offset size description
	0 4 time delay between frames in microseconds
	4 4 data rate of AVI data
	8 4 padding multiple size, typically 2048
	12 4 parameter flags
	16 4 number of video frames
	20 4 number of preview frames
	24 4 number of data streams (1 or 2)
	28 4 suggested playback buffer size in bytes
	32 4 width of video image in pixels
	36 4 height of video image in pixels
	40 4 time scale, typically 30
	44 4 data rate (frame rate = data rate / time scale)
	48 4 starting time, typically 0
	52 4 size of AVI data chunk in time scale units
	
	for more infos over "APIFileReadWrite.au3" see
	http://www.autoitscript.com/forum/index.php?showtopic=12604&hl=APIFileReadWrite.au3
	
#ce

#include <String.au3>
#include "APIFileReadWrite.au3"

$file = @WindowsDir &"\Clock.avi"

Dim $description[15] = [ "some File data", "time delay between frames in microseconds", "data rate of AVI data", _
		"padding multiple size, typically 2048", "parameter flags", "number of video frames", "number of preview frames", _
		"number of data streams (1 or 2)", "suggested playback buffer size in bytes", "width of video image in pixels", _
		"height of video image in pixels", "time scale, typically 30", "data rate (frame rate = data rate / time scale)", _
		"starting time, typically 0", "size of AVI data chunk in time scale units"]


$AVIAttrib = "uint;uint;uint;uint;uint;uint;uint;uint;uint;uint;uint;uint;uint;uint"
$AVIBuffer = DllStructCreate("byte[" & 100 & "]")
;====================================================
$pAVIRecord = DllStructGetPtr($AVIBuffer)
$rAVIRecord = DllStructCreate($AVIAttrib, $pAVIRecord)

#region Open Drive
$f = _APIFileOpen ($file)
If $f = "0xFFFFFFFF" Then
	MsgBox(4096, "Error", "Could not open " & $file)
	Exit 1
EndIf
#endregion

$pos=32
_APIFileSetPos($f, $pos)
_BinaryFileRead ($f, $AVIBuffer)
_APIFileClose ($f)

For $i = 1 To UBound($description) - 1
	ConsoleWrite($i & @TAB & DllStructGetData($rAVIRecord,$i) & @TAB & $description[$i] &@CRLF)
Next

