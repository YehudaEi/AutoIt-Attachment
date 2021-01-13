#include <GUIConstants.au3>
#Include <GuiList.au3>
Opt("TrayAutoPause",0)

global $last=0,$suits[2][3],$sum=0,$suitsum=0

guicreate("Suitcase",900,490)
GUISetBkColor(0x0400bf)
$newbn=GUICtrlCreateButton("New game",630,10,150,20)
$newsuits=GUICtrlCreateInput("",790,10,100,20)
$listevent=GUICtrlCreateList("",630,240,260,250,$WS_VSCROLL)
$listprize=GUICtrlCreateList("",630,40,260,190,bitor($WS_VSCROLL,0x0002,0x4000,3))
GUICtrlCreateGraphic(620,0,280,500)
GUICtrlSetBkColor(-1,0xffffff)
GUISetState()

while 1
	$msg=GUIGetMsg()
	Select
		case $msg=-3
			Exit
		case $msg=$newbn
			if Number(guictrlread($newsuits)) then
			createsuit(guictrlread($newsuits))
			endif
	endselect
	for $i=1 to $last
		if $msg=$suits[$i][0] then
			$sum=$sum-$suits[$i][1]
			$suitsum=$suitsum-1
			guictrlsetstate($suits[$i][0],128)
			for $j=1 to $last 
				if $suits[$i][1]=$suits[$j][2] then
					_GUICtrlListReplaceString($listprize,$j-1,$suits[$i][1]&"         Opened")
				endif
			next
			if $suitsum=0 then
				_GUICtrlListAddItem($listevent,"You have opened case "&$i)
				_GUICtrlListAddItem($listevent,"It contained "&$suits[$i][1])
				_GUICtrlListAddItem($listevent,$suitsum&" cases still left")
				_GUICtrlListAddItem($listevent,"You have won "&$suits[$i][1])
			else
				_GUICtrlListAddItem($listevent,"You have opened case "&$i)
				_GUICtrlListAddItem($listevent,"It contained "&$suits[$i][1])
				_GUICtrlListAddItem($listevent,$suitsum&" cases still left")
				_GUICtrlListAddItem($listevent,"Offered money: "&round($sum/$suitsum))	
				_GUICtrlListAddItem($listevent,"--------------------------------------------------------------")
			endif
		EndIf
	next
wend

func createsuit($newsuits)
	local $raw=1,$integer,$j=0,$p=0,$amount1,$amount2,$i
	GUISetState(@SW_DISABLE)
	ProgressOn("Setting up game", "", "0 percent")
	_GUICtrlListClear($listevent)
	_GUICtrlListClear($listprize)
	$sum=0
	for $i=1 to $last
		guictrldelete($suits[$i][0])
	next
	dim $suits[$newsuits+1][3]
	$last=$newsuits
	$suitsum=$newsuits
	$integer=int(Sqrt($newsuits))
	if $integer*Ceiling(Sqrt($newsuits)) >= $newsuits then $raw=0
	$amount1=int(600/$integer)
	$amount2=int(470/Ceiling(Sqrt($newsuits)+$raw))
	for $i=1 to $newsuits
		$suits[$i][0]=GUICtrlCreateButton($i,10+$p*$amount1,10+$j*$amount2,$amount1,$amount2)
		$suits[$i][1]=random(1,1000000,1)
		$sum=$sum+$suits[$i][1]
		_GUICtrlListAddItem($listprize,string($suits[$i][1]))
		ProgressSet(round($i/$last,1)*100,round($i/$last,1)*100 &" percent")
		$p=$p+1
		if mod($i,$integer)=0 then
			$j=$j+1
			$p=0
		endif
	next
	for $i=0 to $last-1
		$suits[$i+1][2]=_GUICtrlListGetText($listprize,$i)
	next
	ProgressOff()
	GUISetState(@SW_ENABLE)
	_GUICtrlListAddItem($listevent,"New game with: "&$last&" cases")
	_GUICtrlListAddItem($listevent,"Offered money: "&round($sum/$last))
	_GUICtrlListAddItem($listevent,"--------------------------------------------------------------")
endfunc