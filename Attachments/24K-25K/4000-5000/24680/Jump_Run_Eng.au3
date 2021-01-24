#include <GUIConstants.au3>
#include <Array.au3>
#include <Misc.au3>
global $jump=0
global $lives=2

;======Objekt Array======
dim $Objekte[1][7]
$Objekte[0][0]=0

dim $ObjectGroup[1]
$ObjectGroup[0]=0
;======Objekt Array======

;========agaric Array=========
dim $agarics[1][5]
$agarics[0][0]=0
;========agaric Array=========

global $box=@scriptdir & "\bilder\kiste.jpg"
global $boxbg=@scriptdir & "\bilder\kisteBG.jpg"
;global $ich=@scriptdir & "\bilder\ich.gif"
global $cross=@scriptdir & "\bilder\ichkreuz.jpg"


Opt("GUIOnEventMode", 1)
$wuff=GUICreate("Oger's Jump & Run", 500, 500)
_SetPlayingField(0,0,500,500)  ;Creating the playingfield

$displaylives=GuiCtrlCreateLabel("Lives: " & $lives,440,5)
$displaytimer=GuiCtrlCreateLabel("Time: 0.00000",440,30)
;;;;;;;;;;;;;Create the boxes in the background
dim $bg[3]
$bg[0]=_CreateObject($boxbg,100,399,50,50,"bg",0)
$bg[1]=_CreateObject($boxbg,150,399,50,50,"bg",0)
$bg[2]=_CreateObject($boxbg,200,399,50,50,"bg",0)
_SetObjectSize($bg[2],20,20)

;;;;;;;;;;;we create the object group $character
dim $character[3]
$character[0]=_CreateObject($cross,197,449,17,17,"character",2)
$character[1]=_CreateObject($cross,180,466,51,17,"character",2)
$character[2]=_CreateObject($cross,197,483,17,17,"character",2)



;;;;;;;;;;;;;boxes in the foreground
_CreateObject($box,51,399,50,50,"box",1)
_CreateObject($box,51,350,50,50,"box",1)
_CreateObject($box,51,300,50,50,"box",1)

_CreateObject($box,250,399,50,50,"box",1)
_CreateObject($box,300,399,50,50,"box",1)
_CreateObject($box,375,300,25,50,"box",1)

_CreateObject($box,250,250,50,50,"box",1)
_CreateObject($box,200,200,50,50,"box",1)
_CreateObject($box,150,150,50,50,"box",1)



;;;;;;;;;;;;Creating the arm
$Arm=_CreateObject(@scriptdir &"\bilder\hebelA.gif",65,275,25,25,"hebel",0)
$ArmPressed=false

;;;;;;;;;;;;creating the first agaric
global $agaric[2]
$agaric[0]=_CreateObject(@scriptdir & "\bilder\hut.gif",455,460,40,20,"cap",0) ;;the cap (class cap)
$agaric[1]=_CreateObject(@scriptdir & "\bilder\pilz.gif",460,480,30,20,"dead",0)  ;;the clade? (class dead)
_SetObjectGroup($agaric)  ;this is important for _GetObjectGroup() !
_Setagaric($agaric,300,455,3,"l") ;the agaric is allocated to the agaric array

;;;;;;;;;;;;;;;;;creating the second agaric
global $agaricB[2]
$agaricB[0]=_CreateObject(@scriptdir & "\bilder\hut.gif",0,460,40,20,"cap",0) ;;the cap (class cap)
$agaricB[1]=_CreateObject(@scriptdir & "\bilder\pilz.gif",5,480,30,20,"dead",0) ;;the clade? (class dead)
_SetObjectGroup($agaricB)  ;this is important for _GetObjectGroup() !
_Setagaric($agaricB,0,200,3,"r")  ;the agaric is allocated to the agaric array

guisetbkcolor(0xABCDEF)
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "_close")


func _close()
	exit
endfunc

$runde=0

while 1
	sleep(33)
	$runde=$runde+1
	switch $runde
		case 5
		$time=timerinit()
		$runde=0
	endswitch
	
	switch $ArmPressed
		case false ;if the arm wasn't pressed
			select  
				case _ObjectTouchObjectGroup($Arm,$character)<>0  ;the arm touch the character
					$ArmPressed=true
					_ObjectSetPicture($Arm,@scriptdir &"\bilder\hebelB.gif")  ;change the picture of the arm
					_ObjectGroupSetPicture($bg,$box) ;change the picture of the boxes
					_ObjectGroupSetTyp($bg,1) ;change the status of the boxes to 1 (foreground)
			endselect
	Endswitch
	
	select 
		case _ispressed(25) ;left arrow
			_MoveObjectGroup($character,"x",-4)  ;the characteren object group is moved the the left
		case _ispressed(27);right arrow
			_MoveObjectGroup($character,"x",4)  ;the characteren object group is moved the the right
		
	Endselect
	

	$stop=_ObjectGroupTouch($character)  ;the characteren object group touch something
	select 
		case $stop=0 and $jump=0 
			$jump=1
	endselect
	
	_jump()
	
	$Pagaric=_ObjectTouchClass($character[2],"cap") ;$character[2]=the bottom rectangle of the character      if this touch a cap class object...
	select 
		case $Pagaric<>0
			$objectagaric=_GetObjectGroup($Pagaric)  ;get the other objects of the agaric
			_DeleteObjectGroup($objectagaric)    ;the agaric group is removed
			_Deleteagaric($objectagaric) ;delte the agaric from the agaric array
	Endselect
	
	;=========the character dyies==========
	select
		case _ObjectGroupTouchClass($character,"dead")<> 0  ;;;;;if the object group $character touch an object with the class "dead"
		
		 _DeleteObjectGroup($character)  ;delete the character
		 ;Ddelete the agarics
		_DeleteObjectGroup($agaric)
		_Deleteagaric($agaric)
		_DeleteObjectGroup($agaricB)
		_Deleteagaric($agaricB)
		
		 $lives=$lives-1
		 if $lives<>-1 Then
			 Guictrlsetdata($displaylives,"Lives: " & $lives)
		 Else
			 Msgbox(0,"Game Over","You lost:D")
			 exit
		endif
		 sleep(1000)
		 ;creating the charcater
		$character[0]=_CreateObject($cross,197,449,17,17,"character",2)
		$character[1]=_CreateObject($cross,180,466,51,17,"character",2)
		$character[2]=_CreateObject($cross,197,483,17,17,"character",2)
		
		
		;creting the agarics
		$agaric[0]=_CreateObject(@scriptdir & "\bilder\hut.gif",455,460,40,20,"cap",0)
		$agaric[1]=_CreateObject(@scriptdir & "\bilder\pilz.gif",460,480,30,20,"dead",0)
		_SetObjectGroup($agaric)
		_Setagaric($agaric,300,455,3,"l")

		$agaricB[0]=_CreateObject(@scriptdir & "\bilder\hut.gif",0,460,40,20,"cap",0)
		$agaricB[1]=_CreateObject(@scriptdir & "\bilder\pilz.gif",5,480,30,20,"dead",0) 
		_SetObjectGroup($agaricB)
		_Setagaric($agaricB,0,200,3,"r")
		
		switch $ArmPressed
			case true
				$ArmPressed=false
				_ObjectSetPicture($Arm,@scriptdir &"\bilder\hebelA.gif")  ;change the picture of the arm
				_ObjectGroupSetPicture($bg,$boxbg) ;change the picture of the boxes
				_ObjectGroupSetTyp($bg,0) ;set the status of the objects to 0 (background)
		endswitch
		$jump=1
	endselect
	
	_Moveagarics() ;move all agarics
	switch $runde
		case 0
		GUIctrlsetdata($displaytimer,"Time "& round(timerdiff($time),2))
	endswitch
	
wend


func _jump()
	select
		case $jump=0 or $jump=1
			Select
				case _ispressed(20) 
					$jump=-20  ;space is pressed
			endselect
	Endselect
	
	select
		case $jump <> 0 
		
		Select
			case $jump < 0
				$stop=_MoveObjectGroup($character,"y",$jump) ;move the object group to the top
				$jump=$jump+2
				select 
					case $jump=0 or $stop<>0 
						$jump=2
				endselect
			case $jump > 0
		
				$stop=_MoveObjectGroup($character,"y",$jump) ;move the object group to the bottom
				$jump=$jump+2
				select 
					case $stop<>0  
						$jump=0
				EndSelect
					
		endselect
			
	endselect
endfunc
;===================================================================================================================================================
;=======================================================================AGARIC FUNCTIONS===========================================================
;===================================================================================================================================================

;==============================================Functions====================================
;	_Setagaric()
;	_Deleteagaric()
;	_Moveagaric()
;==============================================Functions====================================

;===============================================================================
; Function Name:  	_Setagaric()
; Description:      Chart a new agaric in the agaric array
; Parameter(s):     $Array		- the object array of the agarics
;					$Xa			- X(a) the agaric can't move more to the left side than this point
;					$Xb			- X(b) the agaric can't move more to the right side than this point
;					$speed		- the movement speed of the agaric
;					$direction	- "l" for left and "r" for right
; Requirement(s):   A new AutoIt version
; Return Value(s):  On Success - 
;                   On Failure 	- 
; Author(s):        Oger-Lord
;===============================================================================
func _Setagaric($array,$Xa,$Xb,$speed,$direction)
	
	local $i=1
	while $i<ubound($agarics) ;run to the $agaric array
		switch $agarics[$i][0]
		case ""  ;search an empty entry
			local $string=_GetObjectGroupString($array)    ;change the object array into a string
			;enter the values
			$agarics[$i][0]=$string   ;object group as string
			$agarics[$i][1]=$Xa
			$agarics[$i][2]=$Xb
			$agarics[$i][3]=$speed
			$agarics[$i][4]=$direction

			$i=100000
		endswitch
		$i=$i+1
	wend
	
	select
	case $i<>100001 ;there was no empty element
		local $string=_GetObjectGroupString($array) ;change the object array into a string
		local $avAdd[5] = [$string,$Xa,$Xb,$speed,$direction] ;enter the values in an array
		__ArrayAdd($agarics, $avAdd, False) ;add the array
		$agarics[0][0] = $agarics[0][0] +1
	endselect
endfunc

;===============================================================================
; Function Name:  	_Deleteagaric()
; Description:      delete an agaric from the array
; Parameter(s):     $Array		- Die object array
; Requirement(s):   A new AutoIt version
; Return Value(s):  On Success - 
;                   On Failure 	- 
; Author(s):        Oger-Lord
;===============================================================================
func _Deleteagaric($array)
	local $string=_GetObjectGroupString($array) ;change the object array into a string
	local $i=1
	
	while $i<ubound($agarics)
		switch $agarics[$i][0]
			case $string  ;if this is the right entry
				$agarics[$i][0]=""  ;set the value to "" (empty)
				$i=10000
		endswitch
		$i=$i+1
	wend
endfunc

;===============================================================================
; Function Name:  	_Moveagaric()
; Description:      Move all agarics in the array
; Parameter(s):     
; Requirement(s):   A new AutoIt version
; Return Value(s):  On Success - 
;                   On Failure 	- 
; Author(s):        Oger-Lord
;===============================================================================
func _Moveagarics()
	for $r=1 to ubound($agarics)-1 ;run the array
		switch $agarics[$r][0]
			case ""  ;the entry is not empty
			case else
				local $array=_GetObjectGroupArray($agarics[$r][0]) ;get with the string the object array
				local $koordinaten=_GetObjectPosition($array[0])  ;get the position of the object group
				
				select
					case $koordinaten[0]<=$agarics[$r][1]   ;if the cap go too far left
						$agarics[$r][4]="r"  ;set the direction to "r" 
					case $koordinaten[0]>=$agarics[$r][2] ;if the cap go too far right
						$agarics[$r][4]="l" ;set the direction to "l" 
				EndSelect
				
				switch $agarics[$r][4]
					case "r" ;if the dircetion is "r"
						_MoveObjectGroup($array,"x",$agarics[$r][3]) ;move the agaric to the right side
					case "l" ;if the dircetion is "l"
						_MoveObjectGroup($array,"x",0-$agarics[$r][3])  ;move the agaric to the left side
				endswitch
		endswitch
	next
EndFunc

;===================================================================================================================================================
;=======================================================================OBJEKT FUNKTIONEN===========================================================
;===================================================================================================================================================

;==============================================Funktionen====================================
;	_SetPlayingField()

;	_CreateObject()
;	_MoveObject()
;	_ObjectTouch()
;	_DeleteObject()
;	_ObjectTouchClass()
;	_GetObjectPosition()
;	_TeleportObject()
;	_ObjectSetPicture()
;	_ObjectSetClass()
;	_ObjectSetTyp()
;	_ObjectTouchObject()
;	_SetObjectSize()

;	_SetObjectGroup()
;	_MoveObjectGroup()
;	_ObjectGroupTouch()
;	_ObjectTouchObjectGroup()
;	_ObjectGroupTouchClass()
;	_GetObjectGroup()
;	_DeleteObjectGroup()
;	_GetObjectGroupString()
;	_GetObjectGroupArray()
;	_TeleportObjectGroup()
;	_GetObjectGroupPosition()
;	_ObjectGroupSetPicture()
;	_ObjectGroupSetClass()
;	_ObjectGroupSetTyp()


;==============================================Funktionen====================================


;===============================================================================
; Function Name:  	_SetPlayingField()
; Description:      Gibt die Position des Spielfelds auf dem GUI an
; Parameter(s):     $x			- X Koordinate
;					$y			- Y Koordinate
;					$breite		- Breite des Feldes
;					$hoehe		- Höhe des Feldes
; Requirement(s):   A new AutoIt version
; Return Value(s):  On Success - 
;                   On Failure 	- 
; Author(s):        Oger-Lord
;===============================================================================
func _SetPlayingField($x,$y,$breite,$hoehe)
	$Objekte[0][1]=$x
	$Objekte[0][2]=$y
	$Objekte[0][3]=$breite
	$Objekte[0][4]=$hoehe
EndFunc

;===============================================================================
; Function Name:  	_CreateObject()
; Description:      Erstellt ein Objekt auf der Oberfläche
; Parameter(s):     $path		- Pfad zur Bilddatei
;					$x			- X Koordinate
;					$y			- Y Koordinate
;					$breite		- Breite des Objekts
;					$hoehe		- Höhe des Objekts
;					$klasse		- Klassen Name
;					$art		- 0=Hintergrund   1=Gegenstand    2=Bewegtes Objekt
; Requirement(s):   A new AutoIt version
; Return Value(s):	Handle
; Author(s):        Oger-Lord
;===============================================================================
func _CreateObject($path,$x,$y,$breite,$hoehe,$klasse,$art)
	local $i=1
	$x=$x+$Objekte[0][1]
	$y=$y+$Objekte[0][2]
	while $i<ubound($Objekte)
		switch $Objekte[$i][0]
		case ""
			$Objekte[$i][0]=Guictrlcreatepic($path,$x,$y,$breite,$hoehe)
			$Objekte[$i][1]=$x
			$Objekte[$i][2]=$y
			$Objekte[$i][3]=$breite
			$Objekte[$i][4]=$hoehe
			$Objekte[$i][5]=$klasse
			$Objekte[$i][6]=$art
			return $i
			$i=100000
		endswitch
		$i=$i+1
	wend
	
	select
	case $i<>100001
		local $avAdd[7] = [$path,$x,$y,$breite,$hoehe,$klasse,$art]
		__ArrayAdd($Objekte, $avAdd, False)
		$Objekte[0][0] = $Objekte[0][0] +1
		$Objekte[$Objekte[0][0]][0]=Guictrlcreatepic($path,$x,$y,$breite,$hoehe)
		return $Objekte[0][0]
	endselect
endfunc


;===============================================================================
; Function Name:  	_SetObjectGroup()
; Description:      Legt eine Objektgruppe fest (nicht zwingend notwendig)
; Parameter(s):     $array		- Objekt Array
; Requirement(s):   A new AutoIt version
; Return Value(s):	
; Author(s):        Oger-Lord
;===============================================================================
func _SetObjectGroup($array)
	local $string=""
	for $r=0 to ubound($array)-1
		$string=$string & " " & $array[$r]
	next
	
	local $r=1
	while $r < ubound($ObjectGroup)
		switch $ObjectGroup[$r]
			case ""
				$ObjectGroup[$r]=$string
				$r=10000
		endswitch
		$r=$r+1
	wend
	
	Select
		case $r <> 10001
			_arrayadd($ObjectGroup,$string)
	endselect
endfunc

;===============================================================================
; Function Name:  	_MoveObjectGroup()
; Description:      Bewegt eine Object Array
; Parameter(s):     $array		- Die zu bewegende Objekt Array
;					$direction	- "x" oder "y"
;					$pixel		- Die Anzahl der Pixel die die Objekte bewegt werden sollen
; Requirement(s):   A new AutoIt version
; Return Value(s):	Erfolgreich: 0  Ansonsten: Anzahl der Zusammenstöße
; Author(s):        Oger-Lord
;===============================================================================
func _MoveObjectGroup($array,$direction,$pixel)
	local $ausnahmen=""
	for $r=0 to ubound($array)-1
		$ausnahmen=$ausnahmen & " " & $array[$r]
	next
	
	
	local $koordinaten[ubound($array)][3]
	local $schlecht=0
	for $r=0 to ubound($array)-1
		local $koord=_ObjectTouch($array[$r],$ausnahmen,$direction,$pixel,2)
		$schlecht=$schlecht + $koord[2]
		$koordinaten[$r][0]=$koord[0]
		$koordinaten[$r][1]=$koord[1]
		$koordinaten[$r][2]=$koord[2]
	next
	
	switch $schlecht
		case 0
		for $r=0 to ubound($array)-1

			$Objekte[$array[$r]][1]=$koordinaten[$r][0]
			$Objekte[$array[$r]][2]=$koordinaten[$r][1]
			Guictrlsetpos($Objekte[$array[$r]][0],$koordinaten[$r][0],$koordinaten[$r][1])

		next	
	endswitch
	return $schlecht
endfunc

;===============================================================================
; Function Name:  	_ObjectGroupTouch()
; Description:      Berührt eine Objekt Array gerade etwas?
; Parameter(s):     $array		- Die zu überprüfende Objekt Array
; Requirement(s):   A new AutoIt version
; Return Value(s):	Berührt nichts: 0  Ansonsten: 1
; Author(s):        Oger-Lord
;===============================================================================
func _ObjectGroupTouch($array)
	local $ausnahmen=""
	for $r=0 to ubound($array)-1
		$ausnahmen=$ausnahmen & " " & $array[$r]
	next
	

	local $schlecht=0
	for $r=0 to ubound($array)-1
		local $koord=_ObjectTouch($array[$r],$ausnahmen)
		$schlecht=$schlecht + $koord
	next
	
	switch $schlecht
	case 0
		return 0
	case else
		return 1
	endswitch
endfunc


;===============================================================================
; Function Name:  	_MoveObject()
; Description:      Bewegt eine Object
; Parameter(s):     $number		- Das zu bewegende Objekt
;					$direction	- "x" oder "y"
;					$pixel		- Die Anzahl der Pixel die die Objekte bewegt werden sollen
; Requirement(s):   A new AutoIt version
; Return Value(s):	Erfolgreich: 0  Ansonsten: Anzahl der Zusammenstöße
; Author(s):        Oger-Lord
;===============================================================================
func _MoveObject($number,$direction,$pixel)
	local $koordinaten=_ObjectTouch($number,"",$direction,$pixel,2)
	
	$Objekte[$number][1]=$koordinaten[0]
	$Objekte[$number][2]=$koordinaten[1]
	
	Guictrlsetpos($Objekte[$number][0],$koordinaten[0],$koordinaten[1])
	return $koordinaten[2]
endfunc


;===============================================================================
; Function Name:  	_TeleportObject()
; Description:      Teleportiert ein Object zu einer andere Koordinate, fals möglich
; Parameter(s):     $number		- Das zu bewegende Objekt
;					$x			- Die X Koordinate des Zielpunkts
;					$y			- Die Y Koordinate des Zielpunkts
; Requirement(s):   A new AutoIt version
; Return Value(s):	Erfolgreich: 1  Ansonsten: 0
; Author(s):        Oger-Lord
;===============================================================================
func _TeleportObject($number,$x,$y)
	$altX=$Objekte[$number][1]
	$altY=$Objekte[$number][2]
	
	$Objekte[$number][1]=$x+$Objekte[0][1]
	$Objekte[$number][2]=$y+$Objekte[0][2]
	
	local $wert=_ObjectTouch($number)
	
	if $wert=0 then
		Guictrlsetpos($Objekte[$number][0],$x,$y)
		return 1
	else
		$Objekte[$number][1]=$altX
		$Objekte[$number][2]=$altY
		return 0
	EndIf
	
endfunc


;===============================================================================
; Function Name:  	_TeleportObjectGroup()
; Description:      Teleportiert ein Objekt Gruppe zu einer andere Koordinate, fals möglich
; Parameter(s):     $array		- Die zu bewegende Objekt Gruppe
;					$x			- Die X Koordinate des Zielpunkts
;					$y			- Die Y Koordinate des Zielpunkts
; Requirement(s):   A new AutoIt version
; Return Value(s):	Erfolgreich: 1  Ansonsten: 0
; Author(s):        Oger-Lord
;===============================================================================
func _TeleportObjectGroup($array,$x,$y)
	
	local $koordalt=_GetObjectGroupPosition($array)
	$x=$x-$koordalt[0]
	$y=$y-$koordalt[1]
	
	local $ausnahmen=""
	for $r=0 to ubound($array)-1
		$ausnahmen=$ausnahmen & " " & $array[$r]
	next
	
	
	local $koordinaten[ubound($array)][3]
	local $schlecht=0
	for $r=0 to ubound($array)-1
		$Objekte[$array[$r]][1]=$Objekte[$array[$r]][1]-$x
		$Objekte[$array[$r]][2]=$Objekte[$array[$r]][2]-$y
		
		local $wert=_ObjectTouch($array[$r],$ausnahmen)
		$schlecht=$schlecht + $wert
	next
	
	switch $schlecht
		case 0
			for $r=0 to ubound($array)-1
				Guictrlsetpos($Objekte[$array[$r]][0],$Objekte[$array[$r]][1],$Objekte[$array[$r]][2])
			next
			return 1
		case Else
			for $r=0 to ubound($array)-1
				$Objekte[$array[$r]][1]=$Objekte[$array[$r]][1]+$x
				$Objekte[$array[$r]][2]=$Objekte[$array[$r]][2]+$x
			next
			return 0
	endswitch
endfunc


;===============================================================================
; Function Name:  	_ObjectTouch()
; Description:      Berührt ein Object gerade etwas?
; Parameter(s):     $number		- Das zu überprüfende Object
; Requirement(s):   A new AutoIt version
; Return Value(s):	Berührt nichts: 0  Ansonsten: 1
; Author(s):        Oger-Lord
;===============================================================================
func _ObjectTouch($number,$ausnahmen="",$direction="",$pixel=0,$art=1)

	$x=$Objekte[$number][1]
	$y=$Objekte[$number][2]
	local $return=0
	
	switch $direction
		case "x"
			$x=$x+$pixel
		Case "y"
			$y=$y+$pixel
	endswitch
	
	switch $Objekte[$number][6]
	case 2
		
		select
			case $x<$Objekte[0][1]
				$x=$Objekte[0][1]
				$return=1
				
			case $x>$Objekte[0][1]+$Objekte[0][3]-$Objekte[$number][3]
				$x=$Objekte[0][1]+$Objekte[0][3]-$Objekte[$number][3]
				$return=1
				
			case $y<$Objekte[0][2]
				$y=$Objekte[0][2]
				$return=1

			case $y>$Objekte[0][2]+$Objekte[0][4]-$Objekte[$number][4]
				$y= $Objekte[0][2]+$Objekte[0][4]-$Objekte[$number][4]
				$return=1
		endselect
	
	Endswitch
	
	select
		case $Objekte[$number][6]<>0 and $return=0
		
			for $r=1 to $Objekte[0][0]
				
				select
				case $return=0 and $r <> $number and $Objekte[$r][0]<>"" and $Objekte[$r][6]<>0 and stringinstr($ausnahmen,$r)=0
						select
							case $x  >= $Objekte[$r][1] + $Objekte[$r][3] or $Objekte[$r][1] >= $x + $Objekte[$number][3] or $y >= $Objekte[$r][2] + $Objekte[$r][4] or $Objekte[$r][2] >= $y + $Objekte[$number][4]
						case else
								switch $art
									case 1
										return 1
									case else
										local $koordinaten[3]
										$koordinaten[0]=$Objekte[$number][1]
										$koordinaten[1]=$Objekte[$number][2]
										$koordinaten[2]=1
										return $koordinaten
								endswitch
					endselect
				endselect
			next
	endselect
	
		
		
	switch $art
		case 1
			return $return
		case else
			local $koordinaten[3]
			$koordinaten[0]=$x
			$koordinaten[1]=$y
			$koordinaten[2]=$return
			return $koordinaten
	endswitch
		
endfunc

;===============================================================================
; Function Name:  	_ObjectGroupTouchClass()
; Description:      Berührt eine Object Array gerade eine Klasse?
; Parameter(s):     $array		- Die zu überprüfende Object Array
;					$klasse		- Die zu überprüfende Klasse
; Requirement(s):   A new AutoIt version
; Return Value(s):	Berührt nichts: 0  Ansonsten: 1
; Author(s):        Oger-Lord
;===============================================================================
func _ObjectGroupTouchClass($array,$klasse)

	for $i=0 to ubound($array)-1
		Select
			case $Objekte[$array[$i]][6]<>0
			for $r=1 to $Objekte[0][0]
				Select
				case $r<>$array[$i] and $Objekte[$r][5]=$klasse
					select
					case $Objekte[$array[$i]][1]  >= $Objekte[$r][1] + $Objekte[$r][3] or $Objekte[$r][1] >= $Objekte[$array[$i]][1] + $Objekte[$array[$i]][3] or $Objekte[$array[$i]][2] >= $Objekte[$r][2] + $Objekte[$r][4] or $Objekte[$r][2] >= $Objekte[$array[$i]][2] + $Objekte[$array[$i]][4]
					case else
						return 1
						
					endselect
				endselect
			next
		endselect
	Next
	return 0
endfunc

;===============================================================================
; Function Name:  	_ObjectTouchClass()
; Description:      Berührt ein Object gerade eine Klasse?
; Parameter(s):     $number		- Das zu überprüfende Object
;					$klasse		- Die zu überprüfende Klasse
; Requirement(s):   A new AutoIt version
; Return Value(s):	Berührt nichts: 0  Ansonsten: Object Nummer des Klassen Objects
; Author(s):        Oger-Lord
;===============================================================================
func _ObjectTouchClass($number,$klasse,$rueckgabe=0)

	
		for $r=1 to $Objekte[0][0]
			select
			case $r<>$number and $Objekte[$r][5]=$klasse
				select
				case $Objekte[$number][1]  >= $Objekte[$r][1] + $Objekte[$r][3] or $Objekte[$r][1] >= $Objekte[$number][1] + $Objekte[$number][3] or $Objekte[$number][2] >= $Objekte[$r][2] + $Objekte[$r][4] or $Objekte[$r][2] >= $Objekte[$number][2] + $Objekte[$number][4]
				case else
					return $r
					
				endselect
			endselect
		next
	

	return 0
endfunc



;===============================================================================
; Function Name:  	_ObjectTouchObjectGroup()
; Description:      Berührt ein Object gerade eine Ojekt Gruppe?
; Parameter(s):     $number		- Das zu überprüfende Object
;					$array		- Die zu überprüfende Objekt Gruppe
; Requirement(s):   A new AutoIt version
; Return Value(s):	Berührt nichts: 0  Ansonsten: Object Nummer des Objekts aus der Gruppe
; Author(s):        Oger-Lord
;===============================================================================
func _ObjectTouchObjectGroup($number,$array)

		for $r=0 to ubound($array)-1
			select
			case $array[$r]<>$number
				select
				case $Objekte[$number][1]  >= $Objekte[$array[$r]][1] + $Objekte[$array[$r]][3] or $Objekte[$array[$r]][1] >= $Objekte[$number][1] + $Objekte[$number][3] or $Objekte[$number][2] >= $Objekte[$array[$r]][2] + $Objekte[$array[$r]][4] or $Objekte[$array[$r]][2] >= $Objekte[$number][2] + $Objekte[$number][4]
				case else
					return $array[$r]
					
				endselect
			endselect
		next

	return 0
endfunc


;===============================================================================
; Function Name:  	_ObjectTouchObject()
; Description:      Berührt ein Object gerade eine Ojekt Gruppe?
; Parameter(s):     $number		- Das zu überprüfende Object
;					$numberB	- Das zweite Objekt
; Requirement(s):   A new AutoIt version
; Return Value(s):	Berührt nichts: 0  Ansonsten: 1
; Author(s):        Oger-Lord
;===============================================================================
func _ObjectTouchObject($number,$numberB)
	select
		case $numberB<>$number
			select
				case $Objekte[$number][1]  >= $Objekte[$numberB][1] + $Objekte[$numberB][3] or $Objekte[$numberB][1] >= $Objekte[$number][1] + $Objekte[$number][3] or $Objekte[$number][2] >= $Objekte[$numberB][2] + $Objekte[$numberB][4] or $Objekte[$numberB][2] >= $Objekte[$number][2] + $Objekte[$number][4]
				case else
					return 1
					
			endselect
		endselect
	return 0
endfunc 

;===============================================================================
; Function Name:  	__DeleteObject()
; Description:      Berührt ein Object gerade eine Klasse?
; Parameter(s):     $number		- Das zu löschende Object
; Requirement(s):   A new AutoIt version
; Return Value(s):	
; Author(s):        Oger-Lord
;===============================================================================
func _DeleteObject($number)
	Guictrldelete($Objekte[$number][0])
	$Objekte[$number][0]=""
	$Objekte[$number][1]=""
	$Objekte[$number][2]=""
	$Objekte[$number][3]=""
	$Objekte[$number][4]=""
	$Objekte[$number][5]=""
	$Objekte[$number][6]=""
endfunc


;===============================================================================
; Function Name:  	_DeleteObjectGroup()
; Description:      Berührt ein Object gerade eine Klasse?
; Parameter(s):     $array		- Die zu löschende Object Array
; Requirement(s):   A new AutoIt version
; Return Value(s):	
; Author(s):        Oger-Lord
;===============================================================================
func _DeleteObjectGroup($array)
	for $r=0 to ubound($array)-1
		Guictrldelete($Objekte[$array[$r]][0])
		for $i=0 to 6
			$Objekte[$array[$r]][$i]=""
		Next
	next
	
	local $string=""
	for $r=0 to ubound($array)-1
		$string=$string & " " & $array[$r]
	next
	
	for $i=1 to ubound($ObjectGroup)-1
		switch $ObjectGroup[$i]
			case $string
			$ObjectGroup[$i]=""
		endswitch
	next
endfunc

;===============================================================================
; Function Name:  	_GetObjectGroupString()
; Description:      Wandelt eine Objekt Array in einen String um.
;					Dies ist für eine Array von Object Gruppen wichtig!
; Parameter(s):     $array		- Die umzuwandelnde Object Array
; Requirement(s):   A new AutoIt version
; Return Value(s):	Den erstellten String
; Author(s):        Oger-Lord
;===============================================================================
func _GetObjectGroupString($array)
	local $string=""
	for $r=0 to ubound($array)-1
		$string=$string & " " & $array[$r]
	next
	return $string
EndFunc


;===============================================================================
; Function Name:  	_GetObjectGroupArray()
; Description:      Wandelt einen Objekt Gruppen String der mit _GetObjectGroupString() erstellt
;					wurde wieder in eine Array um!
; Parameter(s):     $string		- Den umzuwandelnde String
; Requirement(s):   A new AutoIt version
; Return Value(s):	Die Object Array
; Author(s):        Oger-Lord
;===============================================================================
func _GetObjectGroupArray($string)
	local $array=stringsplit($string," ")
	_arraydelete( $array,0)
	_arraydelete( $array,0)
	return $array
endfunc

;===============================================================================
; Function Name:  	_GetObjectGroup()
; Description:      Findet die Zusammengehörenden Onjekte heraus
; Parameter(s):     $number		- Das Object, wessen Gruppenmitglieder ermittelt werden sollen
; Requirement(s):   A new AutoIt version
; Return Value(s):	Keine Gruppe: 0 Ansonsten: Array der Onjekte
; Author(s):        Oger-Lord
;===============================================================================
func _GetObjectGroup($number)
	
	for $i=1 to ubound($ObjectGroup)-1
		if stringinstr($ObjectGroup[$i],$number)<>0 Then
			local $array=stringsplit($ObjectGroup[$i]," ")
			_arraydelete( $array,0)
			_arraydelete( $array,0)
			return $array
		endif
	Next
	
	return 0
EndFunc


;===============================================================================
; Function Name:  	_SetObjectSize()
; Description:      Gibt den oberen linken Punkt des Objects aus
; Parameter(s):     $number		- Das Object, wessen Punkt ermittelt werden sollen
; Requirement(s):   A new AutoIt version
; Return Value(s):	$array[0]=X und $array[1]=Y
; Author(s):        Oger-Lord
;===============================================================================
func _SetObjectSize($number,$breite,$hoehe)
	local $altx = $Objekte[$number][1]
	local $alty = $Objekte[$number][2]
	local $altbreite = $Objekte[$number][3]
	local $althoehe = $Objekte[$number][4]
	
	
	$Objekte[$number][1]=$Objekte[$number][1]-(($breite-$Objekte[$number][3])/2)
	$Objekte[$number][3]=$breite
	
	$Objekte[$number][2]=$Objekte[$number][2]-(($hoehe-$Objekte[$number][4])/2)
	$Objekte[$number][4]=$hoehe

	local $wert=_ObjectTouch($number)

	Switch $wert
		case 0
				Guictrlsetpos($Objekte[$number][0],$Objekte[$number][1],$Objekte[$number][2],$Objekte[$number][3],$Objekte[$number][4])
				return 1
		case 1
			$Objekte[$number][1]=$altx
			$Objekte[$number][2]=$alty
			$Objekte[$number][3]=$altbreite
			$Objekte[$number][4]=$althoehe
			return 0
	endswitch
EndFunc


;===============================================================================
; Function Name:  	_GetObjectPosition()
; Description:      Gibt den oberen linken Punkt des Objects aus
; Parameter(s):     $number		- Das Object, wessen Punkt ermittelt werden sollen
; Requirement(s):   A new AutoIt version
; Return Value(s):	$array[0]=X und $array[1]=Y
; Author(s):        Oger-Lord
;===============================================================================
func _GetObjectPosition($number)
	local $array[2]
	$array[0]=$Objekte[$number][1]-$Objekte[0][1]
	$array[1]=$Objekte[$number][2]-$Objekte[0][2]
	return $array
EndFunc


;===============================================================================
; Function Name:  	_GetObjectGroupPosition()
; Description:      Gibt den oberen linken Punkt der Objekt Gruppe aus
; Parameter(s):     $array		- Das Object Array, wessen Punkt ermittelt werden sollen
; Requirement(s):   A new AutoIt version
; Return Value(s):	$array[0]=X und $array[1]=Y
; Author(s):        Oger-Lord
;===============================================================================
func _GetObjectGroupPosition($array)
	local $koord[2]
	$koord[0]=10000
	$koord[1]=10000
	
	for $r=0 to ubound($array)-1
		select
			case $Objekte[$array[$r]][1] < $koord[0]
				$koord[0]=$Objekte[$array[$r]][1]
			case $Objekte[$array[$r]][2] < $koord[1]
				$koord[1]=$Objekte[$array[$r]][2]
		endselect
	next
	return $koord
EndFunc

;===============================================================================
; Function Name:  	_ObjectSetPicture()
; Description:      Ändert das Bild eines Objekts
; Parameter(s):     $number		- Das betroffene Object
;					$image		- Der Pfad zum Bild
; Requirement(s):   A new AutoIt version
; Return Value(s):	
; Author(s):        Oger-Lord
;===============================================================================
func _ObjectSetPicture($number,$image)
	GuictrlsetImage($Objekte[$number][0],$image)
endfunc


func _ObjectGroupSetPicture($array,$image)
	for $r=0 to ubound($array)-1
		GuictrlsetImage($Objekte[$array[$r]][0],$image)
	next
endfunc


;===============================================================================
; Function Name:  	_ObjectSetClass()
; Description:      Ändert die Klasse eines Objekts
; Parameter(s):     $number		- Das betroffene Object
;					$class		- Der Name der neuen Klasse
; Requirement(s):   A new AutoIt version
; Return Value(s):	
; Author(s):        Oger-Lord
;===============================================================================
func _ObjectSetClass($number,$class)
	$Objekte[$number][5]=$class
endfunc

func _ObjectGroupSetClass($array,$class)
	for $r=0 to ubound($array)-1
		$Objekte[$array[$r]][5]=$class
	next
endfunc


;===============================================================================
; Function Name:  	_ObjectSetTyp()
; Description:      Ändert nachträglich die Art eines Objektes.
;					(Letzter Mitgegebener wert bei _CreateObjekt)
; Parameter(s):     $number		- Das betroffene Object
;					$typ		- Die Nummer des neuen Ryps (0,1 oder 2)
; Requirement(s):   A new AutoIt version
; Return Value(s):	
; Author(s):        Oger-Lord
;===============================================================================
func _ObjectSetTyp($number,$typ)
	$Objekte[$number][6]=$typ
endfunc

func _ObjectGroupSetTyp($array,$typ)
	for $r=0 to ubound($array)-1
		$Objekte[$array[$r]][6]=$typ
	next
endfunc


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ARRAY ADD 2D;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func __ArrayAdd(ByRef $avArray, $vValue, $NestArray = True)
    Local $iBoundArray0, $iBoundArray1, $iBoundArray2, $iBoundValue1
    
    If IsArray($avArray) = 0 Then Return SetError(1, 0, -1); $avArray is not an array
    
    $iBoundArray0 = UBound($avArray, 0); No. of dimesions in array
    If $iBoundArray0 > 2 Then Return SetError(1, 1, -1); $avArray is more than 2D
    
    $iBoundArray1 = UBound($avArray, 1); Size of array in first dimension
    If $iBoundArray0 = 2 Then $iBoundArray2 = UBound($avArray, 2); Size of array in second dimension
    
    If ($iBoundArray0 = 1) Or (IsArray($vValue) = 0) Or $NestArray Then
; If input array is 1D, or $vValue is not an array, or $NestArray = True (default) then save $vValue literally
        If $iBoundArray0 = 1 Then
    ; Add to 1D array
            ReDim $avArray[$iBoundArray1 + 1]
            $avArray[$iBoundArray1] = $vValue
        Else
    ; Add to 2D array at [n][0]
            ReDim $avArray[$iBoundArray1 + 1][$iBoundArray2]
            $avArray[$iBoundArray1][0] = $vValue
        EndIf
    Else
; If input array is 2D, and $vValue is an array, and $NestArray = False,
;   then $vValue is a 1D array of values to add as a new row.
        If UBound($vValue, 0) <> 1 Then Return SetError(1, 2, -1); $vValue array is not 1D
        $iBoundValue1 = UBound($vValue, 1)
        If $iBoundArray2 < $iBoundValue1 Then Return SetError(1, 3, -1); $vValue array has too many elements
        ReDim $avArray[$iBoundArray1 + 1][$iBoundArray2]
        For $n = 0 To $iBoundValue1 - 1
            $avArray[$iBoundArray1][$n] = $vValue[$n]
        Next
    EndIf
    
; Return index of new last row in $avArray
    Return $iBoundArray1
EndFunc ;==>__ArrayAdd