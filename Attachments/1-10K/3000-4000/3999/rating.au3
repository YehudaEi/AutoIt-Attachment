; Rating.au3 1.0 - Ben Shepherd (bjs54@dl.ac.uk) 1 September 2005
; Increases the rating of a JPG file, stored as a comment in the file.
; Rating is 1-5; wraps back to 1 if it's already 5; default is 4.
; (We assume non-rated JPGs are average, i.e. 3.)
; Intended to be run as a context-menu item in Explorer, 
; or as an external editor in IrfanView (www.irfanview.com).
; (Properties -> Misc 2 -> External editor, and then SHIFT-E on the image.)
; The rating information could be used to create 'top-rated' slideshows.
; (i.e. showing off just the best photos to friends.)

; requires JHead (http://www.sentex.net/~mwandel/jhead/)
#include <file.au3>
#include <array.au3>

$jheadpath = "E:\jhead.exe"
$commentfile = @TempDir & "\comment.txt"
$files = $CmdLine
$nfiles  = $files [0]
For $i = 1 To $nfiles
	If FileExists ($files [$i]) Then
		;ClipPut ($jheadpath & ' -cs "' & $commentfile & '" "' & $files[$i] & '"')
		RunWait ($jheadpath & ' -cs "' & $commentfile & '" "' & $files[$i] & '"', "", @SW_HIDE)
		$comment = FileRead ($commentfile, FileGetSize ($commentfile))
		;MsgBox (0, "comment read", $comment)
		$p = StringInStr ($comment, "Rating: ")
		If $p > 0 Then
			$rating = Number (StringTrimLeft ($comment, $p + 7))
			;MsgBox (0, "rating", $rating)
			$rating = $rating + 1
			If $rating > 5 Then $rating = 1
			; preserve anything else in the comment string - it might not just contain rating info
			$comment = StringLeft ($comment, $p - 1) & "Rating: " & $rating & StringTrimLeft ($comment, $p + 8)
			;MsgBox (0, "comment to write", $comment)
		Else
			$comment = "Rating: 4 " & $comment
		EndIf
		; The -cl option adds the comment to the file. The -ft option preserves the file time, stamping it from the EXIF time.
		RunWait ($jheadpath & ' -cl "' & $comment & '" -ft "' & $files[$i] & '"', "", @SW_HIDE)
		SplashTextOn ("Rating", $comment, 100, 20, -1, -1, 1)
		; make sure the message stays
		Sleep (1000)
		; clean up
		FileDelete ($commentfile)
	Else
		MsgBox (0, "Rating", "File " & $files [$i] & " does not exist!")
	EndIf
Next