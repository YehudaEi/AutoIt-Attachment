#include <WMMedia.au3>

$sFilename = FileOpenDialog("Select an MP3 File To Use.", @WorkingDir, "Mp3s(*.mp3)", 3)
If @error Then Exit
WMStartPlayer()
$sObj = WMOpenFile($sFilename)
WMPlay($sFilename)

For $i = 0 To 100
	WmSetVolume(100 - $i)
	Sleep(100)
Next
For $i = 0 To 100
	WmSetVolume($i)
	Sleep(100)
Next

WMFastForward()
ConsoleWrite(" : FF")
Sleep(3000)
WMReverse()
ConsoleWrite(" : RR")
Sleep(3000)
WMPause()
ConsoleWrite(" : Pause")
Sleep(3000)
WMResume()
ConsoleWrite(" : Resume")
Sleep(3000)
WMStop()
ConsoleWrite(" : Stop")
Sleep(3000)
WMPlay($sFilename)
ConsoleWrite(" : Play")
Sleep(3000)
WMSetPosition(100)
ConsoleWrite(" : Set Pos")

MsgBox(0, "Song Data",  "Duration - " & WMGetDuration($sObj) & @LF & _
						"Artist - " & WmGetArtist($sObj) & @LF & _
						"Album - " & WmGetAlbum($sObj) & @LF & _
						"Title - " & WmGetTitle($sObj) & @LF & _
						"Bitrate - " & WmGetBitrate($sObj) & @LF & _
						"MediaType - " & WmGetMediaType($sObj) & @LF & _
						"FileSize - " & WmGetFileSize($sObj) & @LF & _ 
						"FileType - " & WmGetFileType($sObj) & @LF & _
						"Category - " & WMGetCategory($sObj) & @LF & _
						"Genre - " & WMGetGenre($sObj) & @LF & _
						"Year - " & WMGetYear($sObj) & @LF & _
						"State - " & WMGetState())
$sObj = 0
WMClosePlayer()




