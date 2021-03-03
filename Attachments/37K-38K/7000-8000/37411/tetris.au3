#include <GuiConstants.au3>
#Include <Misc.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>

#NoTrayIcon

;tao khoi dong
SoundPlay(@ScriptDir&"\music\Bao Thy - Bao Dem Em Khoc.wav")
$GUIMAIN=GUICreate("Xep Gach by SangProNhat",166+234,299,-1,-1,$WS_POPUP)
GUISetBkColor(0x000000)
$Img1=GUICtrlCreatePic(@ScriptDir&"\data\screen1.jpg",0,0,166,299)
$Img2=GuiCtrlCreatePic(@ScriptDir&"\data\screen2.jpg",166,205,234,34)
$Img3=GuiCtrlCreatePic(@ScriptDir&"\data\title.jpg",150,-25,250,150)
$Bt1=GUICtrlCreateButton("",190,125,189,42,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir&"\data\bt1.bmp")
$Bt2=GUICtrlCreateButton("",190,170,189,42,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir&"\data\diemso.bmp")
$Bt3=GUICtrlCreateButton("",190,240,189,42,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir&"\data\thoat.bmp")
;------------------
Local $MANGCHINH[10][20][2] ; 10x20
Local $ArrTruyXuat[3][3]
Local $DSPIC_T[4]
Local $COGACH=0,$BATDAU=0
Local $bx,$by,$DONE=0,$RETRAI=1,$REPHAI=1
Local $ChoiLai,$TamDung,$DiemSo,$Thoat,$LBD,$LBL,$NAME,$LBT
loCal $SCORE=0,$LINE=0,$SPEED=500,$MAU,$LOAI

For $i=0 to 9 step 1
   for $j=0 to 19 step 1
	  $MANGCHINH[$i][$j][0]=0
   Next
next

GuiSetState()

While 1
 $MSG=GUIGetMsg()
 If $MSG=$Bt1 then
	KHOITAO()
	$BATDAU=1
 ElseIF $MSG=$Bt3 Then
	Exit
 Elseif $MSG=$Bt2 Then
 $STR=""
For $i=1 to 5 step 1
$str=$str&IniRead(@ScriptDir&"\highscore\score.ini","HANG "&$i,"TEN","")&@TAB&IniRead(@ScriptDir&"\highscore\score.ini","HANG "&$i,"Diem","")&@CRLF
next
MsgBox(0,"Diem cao nhat: ",$str)
 Endif
 IF $BATDAU=1 then
If $COGACH=0 then
  TAOGACH()
  $COGACH=1
Endif
$RETRAI=1
$REPHAI=1
$TM=0
$SPEED=500
$time=TimerInit()
Do
	IF _IsPressed(25) then 
				DC_DK_T()
				IF $RETRAI<>0 Then
				 $bx=$bx-1
				 MOVEGACH()
				 $TM=$SPEED-TimerDiff($time)
				 ExitLoop
			    Endif
    Elseif _IsPressed(27) then 
				DC_DK_P()
				IF $REPHAI<>0 Then
				   $bx=$bx+1
				   MOVEGACH()
				   $TM=$SPEED-TimerDiff($time)
				   ExitLoop
			    Endif
    Elseif _IsPressed(26) Then
			   XOAY()
			   MOVEGACH()
			   $TM=$SPEED-TimerDiff($time)
			   ExitLoop
   ElseIF _IsPressed(28) Then
			$SPEED=50   
   EndIf
	Switch GUIGETMSG()
 Case $ChoiLai
	 KHOIDONGLAI()
 Case $TamDung
	Do 
	   Sleep(10)
   Until GUIGETMSG()=$TamDung
 Case $DiemSo	
$STR=""
For $i=1 to 5 step 1
$str=$str&IniRead(@ScriptDir&"\highscore\score.ini","HANG "&$i,"TEN","")&@TAB&IniRead(@ScriptDir&"\highscore\score.ini","HANG "&$i,"Diem","")&@CRLF
next
MsgBox(0,"Diem cao nhat: ",$str)
 Case $Thoat
	Exit
     EndSwitch
Until TimerDiff($time)>$SPEED
  Sleep($TM)
  $by=$by+1
  DONE()
IF $DONE=1 Then
$k=0
For $i=0 to UBound($ArrTruyXuat,1)-1 step 1
   for $j=0 to UBound($ArrTruyXuat,2)-1 step 1
	  IF $ArrTruyXuat[$i][$j]=1 Then
		  $x=$bx+$i
		  $y=$by+$j-1
		  $MANGCHINH[$x][$y][0]=1
		  $MANGCHINH[$x][$y][1]= $DSPIC_T[$k]
		  $k=$k+1
	  EndIf
   Next
Next
$COGACH=0
$DONE=0
Else
  MOVEGACH()
Endif
GHIDIEM()
  EndIf
WEnd

Func KHOITAO()
GUIDelete($GUIMAIN)
GUICtrlDelete($Img1)
GUICtrlDelete($Img2)
GUICtrlDelete($Img3)
GUICtrlDelete($Bt1)
GUICtrlDelete($Bt2)
GUICtrlDelete($Bt3)

$GUIMAIN=GUICreate("Xep Gach by SangProNhat",600,500+70,-1,-1,$WS_POPUP)

GUISetBkColor(0x000000)
$Img1=GuiCtrlCreatePic(@ScriptDir&"\data\left.jpg",10,10,52/2,1100/2)
$Img2=GuiCtrlCreatePic(@ScriptDir&"\data\right.jpg",10+250+52/2,10,48/2,1100/2)
$Img3=GuiCtrlCreatePic(@ScriptDir&"\data\top.jpg",10,10,600/2,25)
$Img4=GuiCtrlCreatePic(@ScriptDir&"\data\bot.jpg",10,10+500+25,600/2,25)
$Img5=GuiCtrlCreatePic(@ScriptDir&"\data\diem.jpg",400,150,133,57)
$Img6=GuiCtrlCreatePic(@ScriptDir&"\data\lines.jpg",400,150+87,133,57)

$ChoiLai=GUICtrlCreateButton("",370,150+87*2,189,42,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir&"\data\again.bmp")
$TamDung=GUICtrlCreateButton("",370,150+87*2+62,189,42,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir&"\data\pause.bmp")
$DiemSo=GUICtrlCreateButton("",370,150+87*2+62*2,189,42,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir&"\data\diemso.bmp")
$Thoat=GUICtrlCreateButton("",370,150+87*2+62*3,189,42,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir&"\data\thoat.bmp")

$LBD= GUICtrlCreateLabel("000000",420,162,100,25,$SS_CENTER)
GUICtrlSetBkColor(-1,0x000000)
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetFont(-1,20,"Arial Black")

$LBT= GUICtrlCreateLabel("",400,10,100,25,$SS_CENTER)
GUICtrlSetBkColor(-1,0x000000)
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetFont(-1,20,"Arial Black")

$LBL= GUICtrlCreateLabel("000",430,162+87,75,25,$SS_CENTER)
GUICtrlSetBkColor(-1,0x000000)
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetFont(-1,20,"Arial Black")

GUICtrlCreatePIC(@ScriptDir&"\data\title.jpg",360,40,200,100)

$NAME=InputBox("Yeu cau !!","Nhap ten vao day de bat dau: ")
GuiCtrlSetData($LBT,$NAME)
GuiSetState()

EndFunc


Func TAOGACH()
;7 loai 1x4,2x2,3x2 có 5 
				  For $i=0 to UBound($ArrTruyXuat,1)-1 step 1
					 for $j=0 to UBound($ArrTruyXuat,2)-1 step 1
						$ArrTruyXuat[$i][$j]=0
					 Next
				  Next  
$MAU=random(1,4,1)
$LOAI=random(1,7,1)
 $bx=4
 $by=0
If $LOAI=1 Then
   ReDIM $ArrTruyXuat[1][4]
   for $i=0 to 3 step 1
	  $ArrTruyXuat[0][$i]=1
   Next
Elseif $LOAI=2 Then
   ReDim $ArrTruyXuat[2][2] 
   $ArrTruyXuat[0][0]=1     
   $ArrTruyXuat[0][1]=1
   $ArrTruyXuat[1][0]=1
   $ArrTruyXuat[1][1]=1
Elseif $LOAI=3 Then
   ReDim $ArrTruyXuat[3][2]
   $ArrTruyXuat[0][0]=1
   $ArrTruyXuat[1][0]=1
   $ArrTruyXuat[2][0]=1
   $ArrTruyXuat[0][1]=0
   $ArrTruyXuat[1][1]=0
   $ArrTruyXuat[2][1]=1
Elseif $LOAI=4 Then
   ReDim $ArrTruyXuat[3][2]
   $ArrTruyXuat[0][0]=1
   $ArrTruyXuat[1][0]=1
   $ArrTruyXuat[2][0]=1
   $ArrTruyXuat[0][1]=1
   $ArrTruyXuat[1][1]=0
   $ArrTruyXuat[2][1]=0
Elseif $LOAI=5 Then
   ReDim $ArrTruyXuat[3][2]
   $ArrTruyXuat[0][0]=1
   $ArrTruyXuat[1][0]=1
   $ArrTruyXuat[2][0]=1
   $ArrTruyXuat[0][1]=0
   $ArrTruyXuat[1][1]=1
   $ArrTruyXuat[2][1]=0
Elseif $LOAI=6 Then
   ReDim $ArrTruyXuat[3][2]
   $ArrTruyXuat[0][0]=0
   $ArrTruyXuat[1][0]=1
   $ArrTruyXuat[2][0]=1
   $ArrTruyXuat[0][1]=1
   $ArrTruyXuat[1][1]=1
   $ArrTruyXuat[2][1]=0
Elseif $LOAI=7 Then
   ReDim $ArrTruyXuat[3][2]
   $ArrTruyXuat[0][0]=1
   $ArrTruyXuat[1][0]=1
   $ArrTruyXuat[2][0]=0
   $ArrTruyXuat[0][1]=0
   $ArrTruyXuat[1][1]=1
   $ArrTruyXuat[2][1]=1
EndIf

If $MAU=1 then 
   $FILE=@ScriptDir&"\data\gachdo.jpg"
Elseif $MAU=2 then 
   $FILE=@ScriptDir&"\data\gachnau.jpg"
Elseif $MAU=3 then 
   $FILE=@ScriptDir&"\data\gachtim.jpg"
Elseif $MAU=4 then 
   $FILE=@ScriptDir&"\data\gachxanh.jpg"
EndIf

$k=0
For $i=0 to UBound($ArrTruyXuat,1)-1 step 1
   for $j=0 to UBound($ArrTruyXuat,2)-1 step 1
	  IF $ArrTruyXuat[$i][$j]=1 Then
		 If $MANGCHINH[$bx+$i][$by+$j][0]=1 Then
			GAMEOVER()
		 ExitLoop
		 EndIF
		 $DSPIC_T[$k]=GuiCtrlCreatePic($FILE,25*($bx+$i)+36,($by+$j)*25+35,25,25)
		 $k=$k+1
	  EndIf
   Next
Next


EndFunc

Func MOVEGACH()
$k=0
For $i=0 to UBound($ArrTruyXuat,1)-1 step 1
   for $j=0 to UBound($ArrTruyXuat,2)-1 step 1
	  IF $ArrTruyXuat[$i][$j]=1 Then
		 GuiCtrlSetPos($DSPIC_T[$k],25*($bx+$i)+36,($by+$j)*25+35)
		 $k=$k+1
	  EndIf
   Next
Next
SoundPlay(@ScriptDir&"\music\start.wav")
EndFunc
	  
Func DONE()
For $i=0 to UBound($ArrTruyXuat,1)-1 step 1
   for $j=0 to UBound($ArrTruyXuat,2)-1 step 1
	  IF $ArrTruyXuat[$i][$j]=1 Then
		 $x=$bx+$i
		 $y=$by+$j
		 IF $y>19 Then
			$DONE=1
		 elseif $MANGCHINH[$x][$y][0]=1 Then
			$DONE=1
	     endif
	  EndIf
   Next
Next
SoundPlay(@ScriptDir&"\music\game.wav")
EndFunc

Func DC_DK_T()
			      For $i=0 to UBound($ArrTruyXuat,1)-1 step 1
					 for $j=0 to UBound($ArrTruyXuat,2)-1 step 1
						IF $ArrTruyXuat[$i][$j]=1 Then
							$x=$bx+$i-1
							$y=$by+$j
						     IF $x<0 or $MANGCHINH[$x][$y][0]=1 Then
								$RETRAI=0
						     Endif
						EndIf
					 Next
				  Next  
EndFunc
			   
Func DC_DK_P()			   
			   For $i=0 to UBound($ArrTruyXuat,1)-1 step 1
					 for $j=0 to UBound($ArrTruyXuat,2)-1 step 1
						IF $ArrTruyXuat[$i][$j]=1 Then
							$x=$bx+$i+1
							$y=$by+$j
						     IF $x>9 or $MANGCHINH[$x][$y][0]=1 Then
								$REPHAI=0
							  Endif
						EndIf
					 Next
				  Next  
EndFunc			
			   
Func XOAY()
; xoay 90 do ma tran chieu kim dong Ho
 $OK=1
 DIM $ARRTAM[UBound($ArrTruyXuat,2)][UBound($ArrTruyXuat,1)] 
			   For $i=0 to UBound($ArrTruyXuat,2)-1 step 1
					 for $j=0 to UBound($ArrTruyXuat,1)-1 step 1
						$ARRTAM[$i][$j]=$ArrTruyXuat[$j][UBound($ArrTruyXuat,2)-$i-1]
					 Next
			   Next  ;khoi tao mang phu
			;	   0 1 2
			;	0  x x x
			;	1  x o o 
			;	   0 1
			;	0  x x
			;	1  o x
			;   2  o x
			     For $i=0 to UBound($ARRTAM,1)-1 step 1
					 for $j=0 to UBound($ARRTAM,2)-1 step 1
						IF $ARRTAM[$i][$j]=1 Then
							$x=$bx+$i
							$y=$by+$j
							IF $x>9 or $y>19 or $MANGCHINH[$x][$y][0]=1 Then
							   $OK=0
						    EndIf
						EndIf
					 Next
				  Next
				  IF $OK=1 then
				  ReDim $ArrTruyXuat[UBound($ArrTruyXuat,2)][UBound($ArrTruyXuat,1)] 
				  $ArrTruyXuat=$ARRTAM
				  EndIf
EndFunc				  

Func GHIDIEM()
   Dim $XY[4]
for $i=0 to UBound($MANGCHINH,2)-1 step 1
   IF CHECK($i) = 1 Then
	  for $j=0 to UBound($MANGCHINH,1)-1  step 1
		 Sleep(50)
		 GUICtrlDelete($MANGCHINH[$j][$i][1])
	  Next
	  for $a=$i to 1 step -1
			for $j=0 to UBound($MANGCHINH,1)-1  step 1
			   $MANGCHINH[$j][$a][0]=$MANGCHINH[$j][$a-1][0]
			   $MANGCHINH[$j][$a][1]=$MANGCHINH[$j][$a-1][1]
			   if $MANGCHINH[$j][$a-1][1]<>0 then 
			   $XY=ControlGetPos("Xep Gach by SangProNhat","",$MANGCHINH[$j][$a-1][1])
			   IF not @error then
			   GUICtrlSetPos($MANGCHINH[$j][$a-1][1],$XY[0],$XY[1]+25)
			   Endif
			   EndIF
			Next
		 Next
	  TANGDIEM()
	  SoundPlay(@ScriptDir&"\music\newalert.wav")
	  EndIf
Next  
  EndFunc

Func CHECK($h)
for $m=0 to UBound($MANGCHINH,1)-1
	IF   $MANGCHINH[$m][$h][0]<>1 Then
	   Return 0
    EndIf
 Next
 Return 1
 EndFunc
		 
Func TANGDIEM()
$SCORE=$SCORE+10
$LINE=$LINE+1
GuiCtrlSetData($LBD,$SCORE)
GuiCtrlSetData($LBL,$LINE)
EndFunc

Func GAMEOVER()
$CALL=   MsgBox(4,"Ban da thua !!!","Ban co muon choi lai không ?")
   If $CALL = 6 Then
	  SAVE()
	  KHOIDONGLAI()
   Elseif $CALL=7
	  SAVE()
	  Exit
   EndIf
EndFunc

Func KHOIDONGLAI()
for $i=0 to 9 step 1
   for $j=0 to 19 step 1
	  $MANGCHINH[$i][$j][0]=0
	  GuiCtrlDelete( $MANGCHINH[$i][$j][1])
	  $MANGCHINH[$i][$j][1]=0
   Next
Next
for $i=0 to 3 step 1
   GUICtrlDelete($DSPIC_T[$i])
   $DSPIC_T[$i]=0
next
REDIM $MANGCHINH[10][20][2] ; 10x20
REDIM $ArrTruyXuat[3][3]
REDIM $DSPIC_T[4]
$COGACH=0
$DONE=0
GuiCtrlSetData($LBD,0)
GuiCtrlSetData($LBL,0)
$SCORE=0
$LINE=0
$SPEED=500
$NAME=InputBox("Yeu cau !!","Nhap ten vao day de bat dau: ")
GuiCtrlSetData($LBT,$NAME)
EndFunc

Func SAVE()
$DIEM1=IniRead(@ScriptDir&"\highscore\score.ini","HANG 1","Diem","")
$DIEM2=IniRead(@ScriptDir&"\highscore\score.ini","HANG 2","Diem","")
$DIEM3=IniRead(@ScriptDir&"\highscore\score.ini","HANG 3","Diem","")
$DIEM4=IniRead(@ScriptDir&"\highscore\score.ini","HANG 4","Diem","")
$DIEM5=IniRead(@ScriptDir&"\highscore\score.ini","HANG 5","Diem","")
If $SCORE>$DIEM1 then
   for $i=5 to 2 step -1
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG "&$i,"Ten",IniRead(@ScriptDir&"\highscore\score.ini","HANG "&($i-1),"Ten",""))
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG "&$i,"Diem",IniRead(@ScriptDir&"\highscore\score.ini","HANG "&($i-1),"Diem",""))
   NExt
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 1","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 1","Diem",$SCORE)	
Elseif $SCORE>$DIEM2 then
   for $i=4 to 2 step -1
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG "&$i,"Ten",IniRead(@ScriptDir&"\highscore\score.ini","HANG "&($i-1),"Ten",""))
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG "&$i,"Diem",IniRead(@ScriptDir&"\highscore\score.ini","HANG "&($i-1),"Diem",""))
   NExt
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 4","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 4","Diem",$SCORE)	
Elseif $SCORE>$DIEM3 then
   for $i=3 to 2 step -1
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG "&$i,"Ten",IniRead(@ScriptDir&"\highscore\score.ini","HANG "&($i-1),"Ten",""))
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG "&$i,"Diem",IniRead(@ScriptDir&"\highscore\score.ini","HANG "&($i-1),"Diem",""))
   NExt
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 3","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 3","Diem",$SCORE)	
Elseif $SCORE>$DIEM4 then
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 1","Ten",IniRead(@ScriptDir&"\highscore\score.ini","HANG 2","Ten",""))
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 1","Diem",IniRead(@ScriptDir&"\highscore\score.ini","HANG 2","Diem","")	)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 2","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 2","Diem",$SCORE)
Elseif $SCORE>$DIEM5 then
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 1","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 1","Diem",$SCORE)	   
ENDIF
   
EndFunc

 