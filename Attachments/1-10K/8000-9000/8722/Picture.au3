; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GuiConstants.au3>

; Variable
 Dim $R[4]
 Dim $Img[25]
 Dim $Inzet
 
 $Inzet = 10
 $Winst = 0
 
 $Blok1 = 0
 $Blok2 = 0
 $Blok3 = 0
 
; set images 
 $Img[1] = "Images\10.jpg"
 $Img[2] = "Images\04.jpg"
 $Img[3] = "Images\05.jpg"
 $Img[4] = "Images\06.jpg"
 $Img[5] = "Images\07.jpg"
 $Img[6] = "Images\08.jpg"
 $Img[7] = "Images\09.jpg"
 $Img[8] = "Images\04.jpg"
 $Img[9] = "Images\10.jpg"
 $Img[10] = "Images\11.jpg"
 $Img[11] = "Images\01.jpg"
 $Img[12] = "Images\04.jpg"
 $Img[13] = "Images\02.jpg"
 $Img[14] = "Images\11.jpg"
 $Img[15] = "Images\09.jpg"
 $Img[16] = "Images\04.jpg"
 $Img[17] = "Images\01.jpg"
 $Img[18] = "Images\03.jpg"
 $Img[19] = "Images\02.jpg"
 $Img[20] = "Images\04.jpg"
 $Img[21] = "Images\09.jpg"
 $Img[22] = "Images\11.jpg"
 $Img[23] = "Images\05.jpg"
 $Img[24] = "Images\04.jpg"
 
 
; GUI
 GuiCreate("Picture", 400, 250)

; Rolbars

; Bovenste 
 GUICtrlCreatePic ( $Img[1], 15, 86, 25, 14 )
 GUICtrlCreatePic ( $Img[2], 55, 86, 25, 14 )
 GUICtrlCreatePic ( $Img[3], 95, 86, 25, 14 )

; Middelste
 GUICtrlCreatePic ( $Img[2], 15, 100, 25, 14 )
 GUICtrlCreatePic ( $Img[3], 55, 100, 25, 14 )
 GUICtrlCreatePic ( $Img[4], 95, 100, 25, 14 )

; Onderste
 GUICtrlCreatePic ( $Img[3], 15, 114, 25, 14 )
 GUICtrlCreatePic ( $Img[4], 55, 114, 25, 14 )
 GUICtrlCreatePic ( $Img[5], 95, 114, 25, 14 )
 
; Mid lijn
 $MidLine = GUICtrlCreateGraphic ( 10, 108 )
 GUICtrlSetGraphic($MidLine,$GUI_GR_LINE, 118,0)
 
; Knop
 $Roll = GUICtrlCreateButton ("Start", 10, 50)
 
GuiSetState()

 While 1
    $msg = GUIGetMsg()
    
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	
	If $msg = $Roll Then
		RollBars1()
	EndIf
Wend


Func RollBars1()
	$R[1] = Random(1, 24, 1)
	$R[2] = Random(1, 24, 1)
	$R[3] = Random(1, 24, 1)

; Bovenste 
 If $R[1] = 1 Then
	$Bovenste1 = 24
 Else
	$Bovenste1 = ($R[1] - 1)
 EndIf
 If $R[2] = 1 Then
	$Bovenste2 = 24
 Else
	$Bovenste2 = ($R[2] - 1)
 EndIf
 If $R[3] = 1 Then
	$Bovenste3 = 24
 Else
	$Bovenste3 = ($R[3] - 1)
 EndIf
 GUICtrlCreatePic ( $Img[$Bovenste1], 15, 86, 25, 14 )
 GUICtrlCreatePic ( $Img[$Bovenste2], 55, 86, 25, 14 )
 GUICtrlCreatePic ( $Img[$Bovenste3], 95, 86, 25, 14 )

; Middelste
 GUICtrlCreatePic ( $Img[$R[1]], 15, 100, 25, 14 )
 GUICtrlCreatePic ( $Img[$R[2]], 55, 100, 25, 14 )
 GUICtrlCreatePic ( $Img[$R[3]], 95, 100, 25, 14 )

; Onderste
 If $R[1] = 24 Then
	$Onderste1 = 1
 Else
	$Onderste1 = ($R[1] + 1)
 EndIf
 If $R[2] = 24 Then
	$Onderste2 = 1
 Else
	$Onderste2 = ($R[2] + 1)
 EndIf
 If $R[3] = 24 Then
	$Onderste3 = 1
 Else
	$Onderste3 = ($R[3] + 1)
 EndIf
 GUICtrlCreatePic ( $Img[$Onderste1], 15, 114, 25, 14 )
 GUICtrlCreatePic ( $Img[$Onderste2], 55, 114, 25, 14 )
 GUICtrlCreatePic ( $Img[$Onderste3], 95, 114, 25, 14 )

EndFunc