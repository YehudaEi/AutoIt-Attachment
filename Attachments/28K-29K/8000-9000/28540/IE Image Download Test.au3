#include <IE.au3>

$Result = _DownloadDeviantArt()
MsgBox(0, "DA Downloader!", $Result)

Func _DownloadDeviantArt()
    $HidPicForm = GUICreate("Downloading...", 400, 400)
    $Obj = _IECreateEmbedded()
    $ActiveX = GUICtrlCreateObj($Obj, 10, 10, 380, 380)
    $s = 1
    For $i = 1 To 5 ; First page is fine, the rest is not :(
        _IENavigate($Obj, "                                                        ")
        _IELoadWait($Obj)

;;;;;;;;;;; ADDED ;;;;;;;;;;;;;;;;
If _IELoadWait($Obj) = 0 Then
        _IENavigate($Obj, "                                                        " & $i)
        _IELoadWait($Obj)
EndIf
;;;;;;;;;;; ADDED ;;;;;;;;;;;;;;;        
        
        $oImgs = _IEImgGetCollection($Obj)
        For $oImg In $oImgs
            If $oImg.src = "                                            " And $oImg.height = 0 And $oImg.width = 0 Then ; Check for pics that are disabled. (I.E. not logged in)
                GUIDelete($HidPicForm)
                Return "Not logged in. Please log in via IE."
            EndIf
        Next
        $oImgs = _IEImgGetCollection($Obj)
        For $oImg In $oImgs
            If $oImg.src = "                                            " Or $oImg.height < 25 And $oImg.width < 25 Then ; Sort out DA original pics.
                $s = $s - 1
            Else
                $Result = StringInStr($oImg.src, ".jpg")
                If Not $Result = 0 Then
                    $StringSplit = StringReplace($oImg.src, "http://th", "http://fc") ; Replace preview adress with real address.
                    $DownloadString = StringReplace($StringSplit, "/150/i/", "/i/") ; Same ^
                    $Download = InetGet($DownloadString,  "C:\Pics\Pic" & $s & ".jpg") ; ******** CHANGED ********
                Else
                    $s = $s - 1
                EndIf
            EndIf
            $s = $s + 1
            ;If $s >= 25 Then ExitLoop ; I can only display 24 pics per page. ; ******** CHANGED ********
        Next
    Next
    GUIDelete($HidPicForm)
    Return "Complete."
EndFunc
 

