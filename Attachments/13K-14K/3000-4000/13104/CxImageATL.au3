#include <GUIConstants.au3>

$Form1 = GUICreate("CxImage", 633, 454, 193, 115,$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPCHILDREN )
Dim $filemenu = GUICtrlCreateMenu ("&File")
Dim $fileitem = GUICtrlCreateMenuitem ("Open",$filemenu)
Dim $widthTh,$heightTh
$Height1=150
$Width1=150
$Obj1_ctrl = GUICtrlCreatePic("",120, 32,$Width1,$Height1)

GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
			
		Case $fileitem
			;MsgBox(0,"","msg")
			$file = FileOpenDialog("Choose file...",@ScriptDir,"Picture Files (*.*)")
			If @error <> 1 Then pic_Open($file)
		
    EndSwitch
WEnd

Func pic_Open($file)
	GUICtrlDelete($Obj1_ctrl)
	$newFile = resample($file,$Width1,$Height1)
	$Obj1_ctrl = GUICtrlCreatePic(@ScriptDir & "\cximage5.jpg",120, 32,$widthTh,$heightTh)
	;MsgBox(0,"",$file)
EndFunc

Func resample($file,$Width1,$Height)
$objCxImage = ObjCreate("CxImageATL.CxImage")

;$objCxImage.Destroy()
$objCxImage.Load($file,2)
;$objCxImage.RotateLeft()
$objCxImage.IncreaseBpp(24)
	$widthOrig = $objCxImage.GetWidth()
	$heightOrig = $objCxImage.GetHeight()
	;MsgBox(0,"",$widthOrig & "x" & $heightOrig)
	 $fx = $widthOrig/$Width1
	 $fy = $heightOrig/$Height1 ;subsample factors
	 ;MsgBox(0,"",$fx & "x" & $fy)
	 ; must fit in thumbnail size
	 If $fx>$fy Then 
		 $f=$fx 
	 Else 
		 $f=$fy  ; Max(fx,fy)
		 EndIf
	 
	 $widthTh = Int($widthOrig/$f)
	 $heightTh = Int($heightOrig/$f)
 

$objCxImage.Resample($widthTh,$heightTh,2)
$objCxImage.SetJpegQuality(100)
$objCxImage.Save(@ScriptDir & "\cximage5.jpg", 2)	
$objCxImage.Destroy()	
EndFunc
