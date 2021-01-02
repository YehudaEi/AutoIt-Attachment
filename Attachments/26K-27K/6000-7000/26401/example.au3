; #FUNCTION# ;===============================================================================
;
; Name...........: GetVideoFrame
; Description ...: Gets the frame of specified video file. Using systems available DirectShow filters.
; Syntax.........: GetVideoFrame($sFileName,$dTime,[$iWidth,$iHeight])
; Parameters ....: 	$sFilename	 - Filename of video file.
;                   $dTime  	 - Time in video to grab the frame (can be decimal)
;                   $iWidth   	 - Requested width of the HBITMAP (if this is ommited the standard video size is used.)
;					$iHeight	 - Specifies Height, same as above.
; Return values .: Success - A handle to a bitmap (HBITMAP)
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Invalid amount of parameters
;                  |2 - Unable to open the video
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......: It's your responsibility to clean up the HBITMAP!!!
; Related .......:
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
#AutoIt3Wrapper_Plugin_Funcs= GetVideoFrame
$phandle = PluginOpen("AU3_FrameGrabber.dll")

#include <GDIPlus.au3>

$sFile = FileOpenDialog("Video file", "", "All video files: (*.avi;*.mpeg;*.mpg;*.mp2;*.mp4;*.mov;*.wmv;*.asf;)")
If $sFile <> "" Then

	; Grabs the frame 5 seconds into the video
	$hbitmap = GetVideoFrame($sFile, 5)

	If $hbitmap = 0 Then
		MsgBox(16, "Error", "Unable to open the file!")
	Else
		$sFile=FileSaveDialog("Saving frame","","Jpeg file(*.jpg;)")
		IF StringRight($sFile,4)<>".jpg" THen $sFile&=".jpg"
		_GDIPlus_Startup()
		$bmp=_GDIPlus_BitmapCreateFromHBITMAP($hbitmap)
		_GDIPlus_ImageSaveToFile($bmp,$sFile)
		ShellExecute($sFile)
		_GDIPlus_BitmapDispose($bmp)
		_WinAPI_DeleteObject($hbitmap)

	EndIf
EndIf

PluginClose($phandle)