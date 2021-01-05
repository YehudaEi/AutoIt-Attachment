#include <GUIConstants.au3>
#include <file.au3>
Opt ("GUIOnEventMode", 1)


Dim $filename = "C:\popup.txt", $backup = FileRead( $filename, FileGetSize( $filename))
Dim $num = 30, $title[$num], $temp = "", $count = 0

For $i = 1 to $num - 1
	$title[$i] = _randthing( 50, 200)
	$t2 = GUICreate( $title[$i])
	GUISetState()
	GUISetOnEvent( $GUI_EVENT_CLOSE, "_count", $t2)
	$temp &= $title[$i] & @lf
Next

FileDelete( $filename)
FileWrite( $filename, $temp)

Do
	ToolTip( "count = " & $count)
	Sleep( 100)
Until $count = ($num - 1)


FileDelete( $filename)
FileWrite( $filename, $backup)


Func _count()
	$count += 1
EndFunc


Func _randthing( $minlen, $maxlen)
	Dim $ret
	For $i = 1 To Random( $minlen, $maxlen, 1)
		If Random( 0, 1, 1) = 1 Then
			$ret &= Chr( Random( 97, 122, 1))
		Else
			$ret &= Random( 0, 9, 1)
		EndIf
	Next
	Return $ret
EndFunc
