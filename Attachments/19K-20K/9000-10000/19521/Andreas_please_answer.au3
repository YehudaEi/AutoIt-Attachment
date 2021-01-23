#include <GUIConstants.au3>
Opt("GUIONEventMode",1)
Global $expl="This program will read your mind with the help of mind reading servers. The technique was first discovered in 2000 by google and is today considered very safe"
$expl&=@CRLF&"In the first field you must fill in the phrase ""Andreas please answer:"" this is to please Andreas for giving the right answer, in the second field you input in your question"
Global $idata=""
Global $string="Andreas please answer:",$stringpos
Global $realstring
Global $activated=False, $i2activated=False
Global $answers[10]=["Huh?","You're too dumb","Andreas doesn't like you","You don't believe enough","That's not  question is it?","What????","Stop it!","God Morning","Sorry, I was sleeping"]
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Andreas answers", 400, 327, 193, 125)
GUICtrlCreateLabel($expl,10,10,380,80)
$input = GUICtrlCreateInput($idata,10,110,380,50)
GUICtrlSetFont(-1,24,400)
$input2 = GUICtrlCreateInput("",10,170,380,50)
GUICtrlSetFont(-1,24,400)
$button=GUICtrlCreateButton("Check answer",10,234,100,30)
GUICtrlSetOnEvent(-1,"_getanswer")
$label=GUICtrlCreateLabel("",120,234,236,80)
GUICtrlSetFont(-1,20,400)
GUISetOnEvent($GUI_EVENT_CLOSE,"close")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
Sleep(2)
if $activated And StringRight(GUICtrlRead($input),1)="." Then 
 $activated=False
 $stringpos+=1
 $idata&=StringMid($string,$stringpos,1)
 GUICtrlSetData($input,$idata)
 EndIf
If StringLen($input)=0 Then $activated=False

If GUICtrlRead($input)="." Then
	$activated=True
EndIf


If $activated Then	

If StringLen(GUICtrlRead($input))<StringLen($idata) Then
	$idata=GUICtrlRead($input)
	$stringpos-=1
	$realstring=StringTrimRight($realstring,1)
	If StringLen($input)=0 Then $activated=False
ElseIf GUICtrlRead($input)<>$idata Then
	$realstring&=StringRight(GUICtrlRead($input),1)
	$stringpos+=1
	$idata&=StringMid($string,$stringpos,1)
	GUICtrlSetData($input,$idata)
	
EndIf

EndIf


If $i2activated=False And StringRight(GUICtrlRead($input),1)=":" Then 
Send("{TAB}")
$i2activated=True
EndIf

WEnd

Func _getanswer()
	If GUICtrlRead($input)<>$string Then
		MsgBox(16,"Wrong","You must please Andreas by using the right standard phrase!")
		Return
	EndIf
	
	GUICtrlSetData($label,"Contacting psychic mainframe...")
	Sleep(Random(1000,4000,1))
	GUICtrlSetData($label,"Retrieving data...")
	Sleep(Random(2000,6500,1))
	
	If $realstring="" Then
		GUICtrlSetData($label,$answers[Random(0,9,1)])
	Else
		GUICtrlSetData($label,StringTrimLeft($realstring,1))
	EndIf
	$stringpos=0
	$realstring=""
	GUICtrlSetData($input,"")
	GUICtrlSetData($input2,"")
	$idata=""
	$activated=False
	
EndFunc

Func close ()
	Exit
EndFunc


