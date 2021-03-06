#include <GuiConstants.au3>
#Include <Misc.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>


#Notrayicon


$GUI=GuiCreate("Rắn săn mồi - Phiên bản 1.0 by SangProNhat",500,600*5/8)
$WINB=WinGetPos("Rắn săn mồi - Phiên bản 1.0 by SangProNhat")
$Main=GUICtrlCreatePic(@ScriptDir&"\data\sceen.jpg",0,0,500,600*5/8)
SoundPlay(@ScriptDir&"\music\wmpaud1.wav")
DIM $MENU,$NEWGAME,$PAUSE,$DIEMSO,$EXIT
Global $BATDAU=0
Global $SAN[40][30]
DIM $DAU[1][3],$THAN[1][3],$CU[1][3]
DIM $DAI=0,$FOOD,$TOCDO,$NAME
DIM $nx,$ny
$TAMDUNG=0
DIM $LB
For $i=0 to 39 step 1
	for $j=0 to 29 step 1
		$SAN[$i][$j]=1
	Next
Next

GUISetState()
While 1
   IF $BATDAU=1 then
   GUICtrlSetData($LB,"  Người chơi: "&$NAME&@CRLF&"  Diem :"&(($DAI+1)*$TOCDO+$DAI+1))
   IF _IsPressed(28) then 
	  $nx=0
	  $ny=1
   ElseIF _IsPressed(26) Then
	   $nx=0
	   $ny=-1
   ElseIF _IsPressed(25) Then
	  $nx=-1
	  $ny=0
   ElseIF _IsPressed(27) Then
	  $nx=1
	  $ny=0
   ELSEIF _IsPressed(20) Then
	  Do 
		 Sleep(100)
	  Until _IsPressed(20)
   EndIF
   ;-------------------------MAIN
$THAN[0][0]=$DAU[0][0]
$THAN[0][1]=$DAU[0][1]
$DAU[0][0]=$DAU[0][0]+$nx
$DAU[0][1]=$DAU[0][1]+$ny
$CU[0][0]=$THAN[$DAI][0]
$CU[0][1]=$THAN[$DAI][1]
$CU[0][2]=$THAN[$DAI][2]
	  Select 
		 Case $DAU[0][0]>39 or $DAU[0][0]<0 or $DAU[0][1]>29 or $DAU[0][1]<0
		  SoundPlay(@ScriptDir&"\music\tada.wav")
			  GAMEOVER()
		 Case $SAN[$DAU[0][0]][$DAU[0][1]]=0 and ($nx<>0 or $ny<>0)
			   SoundPlay(@ScriptDir&"\music\tada.wav")
			   GAMEOVER()
		 Case $SAN[$DAU[0][0]][$DAU[0][1]]<>0
		 SoundPlay(@ScriptDir&"\music\start.wav")		  
		 IF $SAN[$DAU[0][0]][$DAU[0][1]]=2 Then
			SoundPlay(@ScriptDir&"\music\chimes.wav")
			$SAN[$DAU[0][0]][$DAU[0][1]]=0
			GuiCtrlDelete($FOOD)
			Do
				  $a=random(0,39,1)
				  $b=random(0,29,1)
			Until $SAN[$a][$b]=1
			 $FOOD=  GuiCtrlCreatePic(@ScriptDir&"\data\food.jpg",112+$a*12,92+$b*12,12,12)
			$DAI=$DAI+1
			REDIM $THAN[$DAI+1][3]
			$SAN[$a][$b]=2
			$CU[0][0]=$THAN[$DAI][0]
			$CU[0][1]=$THAN[$DAI][1]
			$CU[0][2]=$THAN[$DAI][2]
		 ENDIF	
		 $SAN[$DAU[0][0]][$DAU[0][1]]=0
		 GUICtrlDelete($DAU[0][2])
		 $DAU[0][2]=GuiCtrlCreatePic(@ScriptDir&"\data\head.jpg",112+$DAU[0][0]*12,92+12*$DAU[0][1],12,12)
		 IF $DAI>0 then
		 $THAN[0][2]=GuiCtrlCreatePic(@ScriptDir&"\data\body.jpg",112+$THAN[0][0]*12,92+12*$THAN[0][1],12,12)
		 for $i=$DAI to 1 Step -1
			$THAN[$i][0]=$THAN[$i-1][0]
			$THAN[$i][1]=$THAN[$i-1][1]
			$THAN[$i][2]=$THAN[$i-1][2]
		 NEXT
		 ENDIF
		 GUICtrlDelete($CU[0][2])
		 $SAN[$CU[0][0]][$CU[0][1]]=1
   EndSelect
	Sleep(100)  
   ;------------------------------
   SWitch GUIgetMSG()
    Case $NEWGAME
		 RESET()
	 Case $PAUSE
		 Do 
			 sleep(100)
		 Until _IsPressed(20)
	 Case $EXIT
		 Exit
	 Case $DIEMSO
		 BANGDIEM()
	EndSwitch
   ENDIF
   $MSG=GUIGetMsg()
   IF $BATDAU=0 then 
	   $POS=MouseGetPos()
	   $WIN=WinGetPos("Rắn săn mồi - Phiên bản 1.0 by SangProNhat")
	   IF ($POS[0]>=570-$WINB[0]+$WIN[0] and $POS[0]<=729-$WINB[0]+$WIN[0] and $POS[1]>=294-$WINB[1]+$WIN[1] and $POS[1]<=335-$WINB[1]+$WIN[1]) OR ($POS[0]>=577-$WINB[0]+$WIN[0] and $POS[0]<=727-$WINB[0]+$WIN[0] and $POS[1]>=365-$WINB[1]+$WIN[1] and $POS[1]<=402-$WINB[1]+$WIN[1]) OR ($POS[0]>=548-$WINB[0]+$WIN[0] and $POS[0]<=727-$WINB[0]+$WIN[0] and $POS[1]>=438-$WINB[1]+$WIN[1] and $POS[1]<=473-$WINB[1]+$WIN[1]) Then
		   GUICtrlSetCursor($Main,0)
		Else
		   GUICtrlSetCursor($Main,2)
		EndIF
		if $MSG= $Main Then
			$POS=MouseGetPos()
			$WIN=WinGetPos("Rắn săn mồi - Phiên bản 1.0 by SangProNhat")
			IF ($POS[0]>=570-$WINB[0]+$WIN[0] and $POS[0]<=729-$WINB[0]+$WIN[0] and $POS[1]>=294-$WINB[1]+$WIN[1] and $POS[1]<=335-$WINB[1]+$WIN[1]) Then
				BATDAU()
			elseif ($POS[0]>=577-$WINB[0]+$WIN[0] and $POS[0]<=727-$WINB[0]+$WIN[0] and $POS[1]>=365-$WINB[1]+$WIN[1] and $POS[1]<=402-$WINB[1]+$WIN[1]) Then
				BANGDIEM()
			elseif ($POS[0]>=548-$WINB[0]+$WIN[0] and $POS[0]<=727-$WINB[0]+$WIN[0] and $POS[1]>=438-$WINB[1]+$WIN[1] and $POS[1]<=473-$WINB[1]+$WIN[1]) Then
				Exit
			ENDIF
		EndIF
   ENDIF
   Select
	  Case $MSG=$GUI_EVENT_CLOSE
		 Exit
   EndSelect
WEnd

Func BATDAU()
$BATDAU=1
$NAME=InputBox("Nhập tên người chơi ;","Your name ?? :")
GUICtrlDelete($Main)
GUIDelete($GUI)
$GUI=GuiCreate("Rắn săn mồi - Phiên bản 1.0 by SangProNhat",685,547+20)
GuiSetState()
GuiSetBkcolor(0x771f1e)

$MENU=GUICtrlCreateMenu("Trò chơi")
$NEWGAME=GUICtrlCreateMenuItem("Chơi mới",$MENU)
$PAUSE=GUICtrlCreateMenuItem("Tạm dừng",$MENU)
$DIEMSO=GUICtrlCreateMenuItem("Điểm số",$MENU)
$EXIT=GUICtrlCreateMenuItem("Thoát",$MENU)

GuiCtrlCreatePic(@ScriptDir&"\data\top.jpg",0,0,685,92)
GuiCtrlCreatePic(@ScriptDir&"\data\left.jpg",0,0,112,547)
GuiCtrlCreatePic(@ScriptDir&"\data\bot.jpg",0,454,685,92)
GuiCtrlCreatePic(@ScriptDir&"\data\right.jpg",593,0,91,547)
$LB=GUICtrlCreateLabel("",0,0,100,28)
GUICtrlSetBkColor($LB,0xffffff)
TAO()
EndFunc
;~ -------------------------------------------------------------------
Func TAO()
;-------------food
$a=random(0,39,1)
$b=random(0,29,1)
$SAN[$a][$b]=2
$FOOD=GuiCtrlCreatePic(@ScriptDir&"\data\food.jpg",112+$a*12,92+$b*12,12,12)
;-----------Ra

Do
$a=random(0,39,1)
$b=random(0,29,1)
Until $SAN[$a][$b]=1
$SAN[$a][$b]=0
$DAU[0][0]=$a
$DAU[0][1]=$b
$DAU[0][2]=GuiCtrlCreatePic(@ScriptDir&"\data\head.jpg",112+$a*12,92+$b*12,12,12)


EndFunc

Func GAMEOVER()
$DIEM=$DAI+1
$DIEM=$DIEM*$TOCDO+$DIEM
Msgbox(0,"Xin chia buồn !! Bạn đã thua !!","Người chơi: "&$NAME&@CRLF&"Số điểm đạt được: "&$DIEM)
$DIEM1=IniRead(@ScriptDir&"\highscore\score.ini","HANG 1","Diem","")
$DIEM2=IniRead(@ScriptDir&"\highscore\score.ini","HANG 2","Diem","")
$DIEM3=IniRead(@ScriptDir&"\highscore\score.ini","HANG 3","Diem","")
$DIEM4=IniRead(@ScriptDir&"\highscore\score.ini","HANG 4","Diem","")
$DIEM5=IniRead(@ScriptDir&"\highscore\score.ini","HANG 5","Diem","")

IF $DIEM>$DIEM1 then 
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 1","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 1","Diem",$DIEM)
elseIF $DIEM>$DIEM2 then
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 2","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 2","Diem",$DIEM)
elseIF $DIEM>$DIEM3 then
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 3","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 3","Diem",$DIEM)
elseIF $DIEM>$DIEM4 then
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 4","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 4","Diem",$DIEM)
elseIF $DIEM>$DIEM5 then
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 5","Ten",$NAME)
   IniWrite(@ScriptDir&"\highscore\score.ini","HANG 5","Diem",$DIEM)
ENDIF
$A=Msgbox(4,"Bạn co muốn chơi lại không ?","Hãy chọn một trong 2 phương án")
IF $A=6 then 
   RESET()
else 
   MSGBOX(0,"Chú ý !","Chào tạm biệt !!! ")
   Exit
ENDIF
ENDFUNC

Func RESET()
For $i=0 to 39 step 1
	for $j=0 to 29 step 1
		$SAN[$i][$j]=1
	Next
 Next 
GUICtrlDelete($FOOD)
GUICTRlDELETE($DAU[0][2])
for $i=0 to $DAI step 1
GUICtrlDelete($THAN[$i][2])
Next
REDIM $DAU[1][3],$THAN[1][3],$CU[1][3]
$DAI=0
$FOOD=0
$NAME=0
$nx=0
$ny=0
$NAME=InputBox("Nhập tên người chơi ;","Your name ?? :")
TAO()
ENDFUNC

Func BANGDIEM()
	$STR=""
For $i=1 to 5 step 1
$str=$str&IniRead(@ScriptDir&"\highscore\score.ini","HANG "&$i,"TEN","")&@TAB&IniRead(@ScriptDir&"\highscore\score.ini","HANG "&$i,"Diem","")&@CRLF
next
MsgBox(0,"Điểm cao nhất: ",$str)
ENDFUNC


