#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=C:\Mes YDK\WORK\AutoIt v3\All Scripts\Text based Games\Form1.kxf
$Form1 = GUICreate("Pokemon - v1.0", 677, 443, 197, 132)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close",$Form1)
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
$Label1 = GUICtrlCreateLabel("Pokemon text-based...", 8, 8, 220, 25)
$Edit1 = GUICtrlCreateEdit("", 8, 48, 545, 227,$ES_READONLY)
GUICtrlSetBkColor($Edit1,"#000000")
GUICtrlSetColor ( $Edit1, "0x32cd32")
$Radio1 = GUICtrlCreateRadio("Saldýr!", 16, 296, 113, 17)
$Radio2 = GUICtrlCreateRadio("Kaç!", 129, 296, 113, 17)
$Radio3 = GUICtrlCreateRadio("Yakala!", 235, 296, 113, 17)
$Button1 = GUICtrlCreateButton("Devam", 480, 344, 73, 33, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Button1Click")
$Progress1 = GUICtrlCreateProgress(208, 8, 118, 17)
$Progress2 = GUICtrlCreateProgress(400, 8, 118, 17)
$Label2 = GUICtrlCreateLabel("Exp", 344, 8, 36, 17)
$Label3 = GUICtrlCreateLabel("Hp", 160, 8, 36, 17)
$Button2 = GUICtrlCreateButton("Yap", 272, 320, 73, 33, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Button2Click")
GUIctrlsetState($Button2,$GUI_DISABLE)
$Label4 = GUICtrlCreateLabel("My Lvl; ", 560, 48, 76, 17)
$Label5 = GUICtrlCreateLabel("My Hp; ", 560, 72, 76, 17)
$Label6 = GUICtrlCreateLabel("My Exp; ", 560, 96, 76, 17)
$Label7 = GUICtrlCreateLabel("Need; ", 560, 140, 76, 17)
$Label8 = GUICtrlCreateLabel("My Gold; ", 560, 120, 76, 17)
$Button3 = GUICtrlCreateButton("Button3", 600, 256, 65, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Button3Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$myPoke = InputBox("Pokemon","Pokemonunuzun adýný yazýnýz...")
$myTotalExp = 40
$myExp = "1"
$myGold = 100

$myExpPerc = $myExp/$myTotalExp*100
$myLvl = "1"
$myTotalHp = $myLvl*100+5
$myHp = $myLvl*100+5 ;state own hp
$myHpPerc = $myhp/$myTotalHp*100
Global $enemyHp, $enemyName, $enemylvl, $enemyExp, $myLvl, $myHp, $enemyGold
Global $myHpPot, $myMpPot,$myPokeBall
Global $mname1 = "Meow", $mname2 = "Snorlax", $mname3 = "Squirtle", $mname4 = "Balbazar", $mname5 = "Golem", $mname6 = "Pidgeon"
GUICtrlSetData($Progress1,$myHpPerc)
GUICtrlSetData($Progress2,$myExpPerc)
GUICtrlSetData($Edit1,"Merhaba!"&@CRLF&"Yavru pokemonun """&$myPoke&""" ile açýk havada gezintiye çýktýn.")
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"Bu güneþli güzel günde hayatýn için yeni bir karar aldýn."&@crlf&" Bu yavru pokemonunla beraber yepyeni macerlara atýlacak ve pek çok pokemon yakalayacaksýn")

Global $i = 1
While 1

	Sleep(100)
WEnd

Func Button1Click()
	Switch $myExp ; lvl up!
	Case $myExp > 40
		$myLvl = $myLvl+1
		$myTotalExp = 50
		$myExp = 0
	Case $myExp > 50
		$myLvl = $myLvl+1
		$myTotalExp = 70
		$myExp = 0
	Case $myExp > 70
		$myLvl = $myLvl+1
		$myTotalExp = 95
		$myExp = 0
	Case $myExp > 95
		$myLvl = $myLvl+1
		$myTotalExp = 130
		$myExp = 0
	Case $myExp > 130
		$myLvl = $myLvl+1
		$myTotalExp = 280
		$myExp = 0
	Case $myExp > 280
		$myLvl = $myLvl+1
		$myTotalExp = 350
		$myExp = 0
	Case $myExp > 350
		$myLvl = $myLvl+1
		$myTotalExp = 420
		$myExp = 0
	Case $myExp > 420
		$myLvl = $myLvl+1
		$myTotalExp = 500
		$myExp = 0
	Case $myExp > 500
		$myLvl = $myLvl+1
		$myTotalExp = 600
		$myExp = 0
	Case $myExp > 600
		$myLvl = $myLvl+1
		$myTotalExp = 710
		$myExp = 0
	Case $myExp > 710
		$myLvl = $myLvl+1
		$myTotalExp = 820
		$myExp = 0
	Case $myExp > 820
		$myLvl = $myLvl+1
		$myTotalExp = 950
		$myExp = 0
	Case $myExp > 950
		$myLvl = $myLvl+1
		$myTotalExp = 1200
		$myExp = 0
	Case $myExp > 1200
		$myLvl = $myLvl+1
		$myTotalExp = 1500
		$myExp = 0
	Case $myExp > 1500
		$myLvl = $myLvl+1
		$myTotalExp = 1900
		$myExp = 0
	Case $myExp > 1900
		$myLvl = $myLvl+1
		$myTotalExp = 2500
		$myExp = 0
	Case $myExp > 2500
		$myLvl = $myLvl+1
		$myTotalExp = 3300
		$myExp = 0
	Case $myExp > 3300
		$myLvl = $myLvl+1
		$myTotalExp = 4200
		$myExp = 0
	Case $myExp > 4200
		$myLvl = $myLvl+1
		$myTotalExp = 5200
		$myExp = 0
	Case $myExp > 5200
		$myLvl = $myLvl+1
		$myTotalExp = 6300
		$myExp = 0
	Case $myExp > 6300
		$myLvl = $myLvl+1
		$myTotalExp = 7800
		$myExp = 0
	Case $myExp > 7800
		$myLvl = $myLvl+1
		$myTotalExp = 9500
		$myExp = 0
	Case $myExp > 9500
		$myLvl = $myLvl+1
		$myTotalExp = 11500
		$myExp = 0
	Case $myExp > 11500
		$myLvl = $myLvl+1
		$myTotalExp = 13500
		$myExp = 0
	Case $myExp > 13500
		$myLvl = $myLvl+1
		$myTotalExp = 17500
		$myExp = 0
	Case $myExp > 17500
		$myLvl = $myLvl+1
		$myTotalExp = 22500
		$myExp = 0
	Case $myExp > 22500
		$myLvl = $myLvl+1
		$myTotalExp = 26000
		$myExp = 0
	Case $myExp > 26000
		$myLvl = $myLvl+1
		$myTotalExp = 32000
		$myExp = 0
	Case $myExp > 32000
		$myLvl = $myLvl+1
		$myTotalExp = 40000
		$myExp = 0
	Case $myExp > 40000
		$myLvl = $myLvl+1
		$myTotalExp = 50000
		$myExp = 0
	Case $myExp > 50000
		$myLvl = $myLvl+1
		$myTotalExp = 60000
		$myExp = 0
	Case $myExp > 60000
		$myLvl = $myLvl+1
		$myTotalExp = 63000
		$myExp = 0
	Case $myExp > 63000
		$myLvl = $myLvl+1
		$myTotalExp = 77000
		$myExp = 0
	Case $myExp > 77000
		$myLvl = $myLvl+1
		$myTotalExp = 90000
		$myExp = 0
	Case $myExp > 90000
		$myLvl = $myLvl+1
		$myTotalExp = 150000
		$myExp = 0
	Case $myExp > 150000
		$myLvl = $myLvl+1
		$myTotalExp = 200000
		$myExp = 0
	Case $myExp > 200000
		$myLvl = $myLvl+1
		$myTotalExp = 260000
		$myExp = 0
	Case $myExp > 260000
		$myLvl = $myLvl+1
		$myTotalExp = 360000
		$myExp = 0
	Case $myExp > 360000
		$myLvl = $myLvl+1
		$myTotalExp = 430000
		$myExp = 0
	Case $myExp > 430000
		$myLvl = $myLvl+1
		$myTotalExp = 600000
		$myExp = 0
	Case $myExp > 600000
		$myLvl = $myLvl+1
		$myTotalExp = 740000
		$myExp = 0
	Case $myExp > 740000
		$myLvl = $myLvl+1
		$myTotalExp = 900000
		$myExp = 0
	Case $myExp > 900000
		$myLvl = $myLvl+1
		$myTotalExp = 1200000
		$myExp = 0
	Case $myExp > 1200000
		$myLvl = $myLvl+1
		$myExp = 0
EndSwitch
	$selmobname = Random(1,6,1); select mob name numb.
	$enemylvl = Random($myLvl-3,$myLvl+3,1) ;select mob lvl...
	If $enemylvl < 1 Then $enemylvl = 1
	$enemyExp = Random($enemylvl*4+5,$enemylvl*5+5,1) ;determine exp...
	$myHp = $myHp+$myLvl*2+2; heal me little bit.
	$enemyHp = Random($enemylvl*4,$enemylvl*5,1) ;determine enemy hp
	$enemyGold = Random($enemylvl*100+100,$enemylvl*100+230,1)
GUICtrlSetData($label4,"My lvl; "&$myLvl)
GUICtrlSetData($label5,"My hp; "&$myHp)
GUICtrlSetData($label6,"My exp; "&$myExp)
GUICtrlSetData($label7,"Need exp; "&$myTotalExp)
GUICtrlSetData($label8,"My Gold; "&$myGold)
Switch $selmobname ; choose enemymob name.
	Case $selmobname = 1
	$enemyName = $mname1
	Case $selmobname = 2
	$enemyName = $mname2
	Case $selmobname = 3
	$enemyName = $mname3
	Case $selmobname = 4
	$enemyName = $mname4
	Case $selmobname = 5
	$enemyName = $mname5
	Case $selmobname = 6
	$enemyName = $mname6
	EndSwitch
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"Oops! Vahþi bir pokemona rastladýn! Biraz inceleyince bunun bir lvl "&$enemylvl&", "&$enemyName&" olduðunu anladýn.")
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"Kendi evcil pokemonlarýndan, "&$myPoke&" derhal öne atýlýyor ve senin  emirlerini bekliyor.")
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"Pokemonun ne yapmasýný istersiniz?")
;_GUICtrlEdit_AppendText($Edit1, @CRLF&"Oops! Vahþi bir pokemona rastladýn! Biraz inceleyince bunun bir lvl "&$enemylvl&", "&$enemyName&" olduðunu anladýn.")
;_GUICtrlEdit_AppendText($Edit1, @CRLF&"Kendi evcil pokemonlarýndan, "&$myPoke&" derhal öne atýlýyor ve senin  emirlerini bekliyor.")
;_GUICtrlEdit_AppendText($Edit1,@CRLF&"Pokemonun ne yapmasýný istersiniz?")
_GUICtrlEdit_LineScroll ($edit1,_GUICtrlEdit_GetLineCount ($edit1)+1,_GUICtrlEdit_GetLineCount ($edit1)+1)
GUIctrlsetState($Button2,$GUI_ENABLE)
EndFunc

Func Button2Click()
If GUICtrlRead($Radio1) = 1 Then
	;	_GUICtrlEdit_AppendText($Edit1,@CRLF&"myHp; "&$myHp&"EnemyHp; "&$enemyHp&"enemy lvl"&$enemylvl&"my lvl"&$myLvl)
	$myAttPw = Random($myLvl*3+3,$myLvl*4+3,1)
	$enemAttPw = Random($enemylvl*3+2,$enemylvl*4+3,1)
	$enemyHp = $enemyHp-$myAttPw
	$myHp = $myHp-$enemAttPw
Select
	Case $myhp < 1
		GUIctrlsetState($Button2,$GUI_DISABLE)
		$myhp = 100
		$myExp = $myExp - $myTotalExp*2/100
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"myHp; "&$myHp&" oh my god! i died!")
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"You lost"&$enemyExp&" experince points.")
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"Wild "&$enemyName&" runaway.")
;_GUICtrlEdit_AppendText($Edit1,@CRLF&"myHp; "&$myHp&" oh my god! i died!")
_GUICtrlEdit_LineScroll ($edit1,_GUICtrlEdit_GetLineCount ($edit1)+1,_GUICtrlEdit_GetLineCount ($edit1)+1)
;_GUICtrlEdit_AppendText($Edit1,@CRLF&"You lost"&$enemyExp&" experince points.")
;_GUICtrlEdit_AppendText($Edit1,@CRLF&"Wild "&$enemyName&" runaway.")
$myExpPerc = $myExp/$myTotalExp*100
GUICtrlSetData($Progress2,$myExpPerc)
$myHpPerc = $myhp/$myTotalHp*100
GUICtrlSetData($Progress1,$myHpPerc)
GUICtrlSetData($label4,"My lvl; "&$myLvl)
GUICtrlSetData($label5,"My hp; "&$myHp)
GUICtrlSetData($label6,"My exp; "&$myExp)


Case $enemyHp < 1
GUIctrlsetState($Button2,$GUI_DISABLE)
$myExp = $myExp + $enemyExp
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"myHp; "&$myHp&" Congrats! YOU WIN!!!")
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"You earned"&$enemyExp&" experince points.")
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"Your current total experince is; "&$myExp&" experince points.")
;_GUICtrlEdit_AppendText($Edit1,@CRLF&"myHp; "&$myHp&" Congrats! YOU WIN!!!")
_GUICtrlEdit_LineScroll ($edit1,_GUICtrlEdit_GetLineCount ($edit1)+1,_GUICtrlEdit_GetLineCount ($edit1)+1)
;_GUICtrlEdit_AppendText($Edit1,@CRLF&"You earned"&$enemyExp&" experince points.")
;_GUICtrlEdit_AppendText($Edit1,@CRLF&"Your current total experince is; "&$myExp&" experince points.")
$myHpPerc = $myhp/$myTotalHp*100
$myGold = $myGold+$enemyGold
GUICtrlSetData($label8,"My Gold; "&$myGold)
GUICtrlSetData($Progress1,$myHpPerc)
GUICtrlSetData($label4,"My lvl; "&$myLvl)
GUICtrlSetData($label5,"My hp; "&$myHp)
GUICtrlSetData($label6,"My exp; "&$myExp)
$myExpPerc = $myExp/$myTotalExp*100
GUICtrlSetData($Progress2,$myExpPerc)


Case $myhp >= 1 And $enemyHp >= 1
GUICtrlSetData($Edit1,GUICtrlRead($Edit1)&@CRLF&"Still alive both, My hp; "&$myhp&" Enemy hp; "&$enemyHp)
;_GUICtrlEdit_AppendText($Edit1,@CRLF&"Still alive both, My hp; "&$myhp&" Enemy hp; "&$enemyHp)
_GUICtrlEdit_LineScroll ($edit1,_GUICtrlEdit_GetLineCount ($edit1)+1,_GUICtrlEdit_GetLineCount ($edit1)+1)
$myHpPerc = $myhp/$myTotalHp*100
GUICtrlSetData($Progress1,$myHpPerc)
$myExpPerc = $myExp/$myTotalExp*100
GUICtrlSetData($Progress2,$myExpPerc)
GUICtrlSetData($label4,"My lvl; "&$myLvl)
GUICtrlSetData($label5,"My hp; "&$myHp)
GUICtrlSetData($label6,"My exp; "&$myExp)
EndSelect

	EndIf
If GUICtrlRead($Radio2) = 1 Then
	MsgBox(0,"Run","Running tried")
	EndIf
If GUICtrlRead($Radio3) = 1 Then
	MsgBox(0,"Capture","Capture tried")
	EndIf

EndFunc

Func Button3Click()
    $Store = GUICreate("Market", 300, 500, 894, 132, Default,Default,$Form1)
$sLabel1 = GUICtrlCreateLabel("Pokemonlarýnýn bakýmý ve maceranýn devamý için maðazamýzda aradýðýn herþeyi bulabilirsin...", 8, 8, 276, 33)
$sLabel2 = GUICtrlCreateLabel("Hp Pot:", 8, 48, 55, 17)
$sLabel3 = GUICtrlCreateLabel("Mp Pot:", 8, 72, 55, 17)
$sLabel4 = GUICtrlCreateLabel("PokeTopu:", 8, 96, 55, 17)
$sLabel5 = GUICtrlCreateLabel("Gold"&$myGold, 100, 456, 190, 17)
$sLabel6 = GUICtrlCreateLabel("Kasada "&$myHpPot&" adet var.", 180, 48, 80, 17)
$sLabel7 = GUICtrlCreateLabel("Kasada "&$myMpPot&" adet var.", 180, 72, 80, 17)
$sLabel8 = GUICtrlCreateLabel("Kasada "&$myPokeBall&" adet var.", 180, 96, 80, 17)
Global $sInput1 = GUICtrlCreateInput("0", 80, 48, 49, 21)
Global $sInput2 = GUICtrlCreateInput("0", 80, 72, 49, 21)
Global $sInput3 = GUICtrlCreateInput("0", 80, 96, 49, 21)
Global $sButton1 = GUICtrlCreateButton("Satýn Al", 208, 456, 75, 25)
GUICtrlSetOnEvent(-1,"Buy")
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseStore",$Store)
   GUISetState(@SW_SHOW)

EndFunc
Func Buy()
Global $myHpPot = $myHpPot + GUICtrlRead($sInput1)
Global $myMpPot = $myMpPot + GUICtrlRead($sInput2)
Global $myPokeBall = $myHpPot + GUICtrlRead($sInput3)
GUICtrlSetData($sLabel6,"Kasada "&$myHpPot&" adet var.")
GUICtrlSetData($sLabel7,"Kasada "&$myMpPot&" adet var.")
GUICtrlSetData($sLabel8,"Kasada "&$myPokeBall&" adet var.")
EndFunc


Func CloseStore()
    GUIDelete(@GUI_WinHandle)
	EndFunc
Func Form1Maximize()
EndFunc


Func Form1Close()
Exit
EndFunc

Func Form1Minimize()

EndFunc
Func Form1Restore()

EndFunc
