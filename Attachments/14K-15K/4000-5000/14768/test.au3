AutoItSetOption ( "pixelcoordmode", 2 )
AutoItSetOption ( "WinTitleMatchMode", 2)

$looprun = 0 
$card1suit = 0
$message = 0

$pocketcoord1 = 0
$pocketcoord2 = 0


;;;;;;;;;;;Activate Pokerchamps window
$windowname = Wingettitle ( "PokerChamps" )
WinWait($windowname)	
WinActivate ($windowname)
WinWaitActive ($windowname)
;winmove ($windowname, "",-4,-30)
$clientsize = WinGetClientSize ($windowname)

;$debugmessage = "x:" & $clientsize[0] & "y:" & $clientsize[1]

;;;;;;;;;;;Check if 4 colored deck is on


;mouseclick ( "left", 542,393, 1, 10)
;sleep (200)
;$4suitdeck = PixelChecksum (544,355,566,368)
;
;If $4suitdeck = 944908575 Then
;	mouseclick ( "left", 543, 250, 1, 10)
;EndIf
;if $4suitdeck > 944908575 Then
;	mouseclick ( "left", 555, 362, 1, 10)
;	sleep (200)
;	mouseclick ( "left", 543,250,1,10)
;EndIf
;if $4suitdeck < 944908575 Then
;	mouseclick ( "left", 555, 362, 1, 10)
;	sleep (200)
;	mouseclick ( "left", 543,250,1,10)
;	EndIf
;sleep (200)







Do
	$clientsize = WinGetClientSize ($windowname)

;$debugmessage = "x:" & $clientsize[0] & "y:" & $clientsize[1]

	
	
	;Setting all seats to taken, checksum will prove right or wrong
$seat1 = "Taken"
$seat2 = "Taken"
$seat3 = "Taken"
$seat4 = "Taken"
$seat5 = "Taken"
$seat6 = "Taken"

;FIND MY SEAT
$yourseat1 = pixelchecksum (244,88,329,100)
$yourseat2 = pixelchecksum (478,163,564,175)
$yourseat3 = pixelchecksum (478,275,564,387)
$yourseat4 = pixelchecksum (242,350,328,361)
$yourseat5 = pixelchecksum (6,275,92,387)
$yourseat6 = pixelchecksum (6,163,92,175)


;SEAT 1 CHECK
If $yourseat1 = 2453213556 Then
$seat1 = "Open" 
Else
If $yourseat1 = 2270612917 Then
		$seat1 = "My seat"
	Else
		$seat1 = "Seat Taken"
		EndIf
	endif
	
	If $seat1 = "My seat" Then
	$pocketcoord1 = pixelchecksum (260,48,271,61)
	$pocketcoord2 = pixelchecksum (278,48,289,61)
	EndIf

;;SEAT 2 CHECK
If $yourseat2 = 3840118605 Then
$seat2 = "Open" 
Else
If $yourseat2 = 2981804088 Then
		$seat2 = "My seat"
	Else
		$seat2 = "Seat Taken"
		EndIf
	endif
	
	If $seat2 = "My seat" Then
	$pocketcoord1 = pixelchecksum (496,123,507,136)
	$pocketcoord2 = pixelchecksum (514,123,525,136)
	EndIf

;;SEAT 3 CHECK
If $yourseat3 = 1526443062 Then
$seat3 = "Open" 
Else
If $yourseat3 = 3332421690 Then
		$seat3 = "My seat"
	Else
		$seat3 = "Seat Taken"
		EndIf
	endif
	
	If $seat3 = "My seat" Then
	$pocketcoord1 = PixelChecksum (496,235,507,248)
	$pocketcoord2 = pixelchecksum (514,235,525,248)
EndIf

;;SEAT 4 CHECK
If $yourseat4 = 647863927 Then
$seat4 = "Open" 
Else
If $yourseat4 = 4131399810 Then
		$seat4 = "My seat"
	Else
		$seat4 = "Seat Taken"
		EndIf
	endif
		If $seat4 = "My seat" Then
	$pocketcoord1 = pixelchecksum (258,310,269,323)
	$pocketcoord2 = pixelchecksum (276,310,277,323)
	EndIf


	
;;SEAT 5 CHECK
If $yourseat5 = 3783235164 Then
$seat5 = "Open" 
Else
If $yourseat5 = 2753043796 Then
		$seat5 = "My seat"
	Else
		$seat5 = "Seat Taken"
	EndIf
endif

If $seat5 = "My seat" Then
	$pocketcoord1 = PixelChecksum (22,235,33,248)
	$pocketcoord2 = pixelchecksum (40,235,51,248)
EndIf

	
	
;;SEAT 6 CHECK
If $yourseat6 = 1645911442 Then
$seat6 = "Open" 
Else
If $yourseat6 = 2253043796 Then
		$seat6 = "My seat"
	Else
		$seat6 = "Seat Taken"
		EndIf
	endif

If $seat6 = "My seat" Then
	$pocketcoord1 = pixelchecksum (24,123,33,136)
	$pocketcoord2 = pixelchecksum (40,123,51,136)
	EndIf
	
	

;Primitive counter (refer to end of script for looprun = 100000)
$looprun = $looprun + 1




	
	
	
;Seat Message
$seatmessage = "Seat 1: " & $seat1 & @CRLF & "Seat 2: " & $seat2 & @CRLF & "Seat 3: " & $seat3 & @CRLF & "Seat 4: " & $seat4 & @CRLF & "Seat 5: " & $seat5 & @CRLF & "Seat 6: " & $seat6
	
	
	;gather checksums for each card on the table

	$checksumCARD1 = PixelChecksum ( 175, 179, 186, 192)
	$checksumcard2 = PixelChecksum ( 222, 179, 233, 192)
	$checksumcard3 = PixelChecksum ( 269, 179, 280, 192)
	$checksumcard4 = PixelChecksum ( 316, 179, 327, 192)
    $checksumcard5 = PixelChecksum ( 363, 179, 374, 192)
	$pocket1sum = $pocketcoord1
	$pocket2sum = $pocketcoord2
	
	
;;;Card and suit must be seperated, theres no choice its only way to do accurate calculations.

;Test if checksum is recognized, these "knowns" are to grab the card, suit is seperate but discovered by one checksum
$known = "Unknown"
$2known = "Unknown"
$3known = "Unknown"
$4known = "Unknown"
$5known = "Unknown"
$pocket1 = "?"
$pocket2 = "?"




;discovered suit of cards 
$knownsuit = ""
$2knownsuit = ""
$3knownsuit = ""
$4knownsuit = ""
$5knownsuit = ""
$pocket1suit = ""
$pocket2suit = ""


;:;;;;;;;;;;;;;;;;;;; START CARD KNOWN SEQUENCE, CHECKING BOARD CARDS CHECKSUM AGAINST KNOWN CHECKSUMS

;Check if you have cards in the pocket 


;Check what cards are out...

if $checksumcard1 = 2749334045 Then
	$known = "?"
EndIf

	if $checksumcard2 = 3812267251 Then
	$2known = "?" 
EndIf

	if $checksumcard3 = 1613144577 Then
	$3known = "?"
EndIf

if $checksumcard4 = 1526505814 Then
	$4known = "?"
	EndIf
if $checksumcard5 = 172986399 Then
	$5known = "?"
	EndIf

;;;;;;;;;;;;;;CHECK FOR ANY 2's 
;2 of hearts
If $checksumCARD1 = 297450389 Then
	$known = "2"
	$knownsuit = "h"
EndIf
If $checksumCARD2 = 297450389 Then
	$2known = "2"
	$2knownsuit = "h"
EndIf
If $checksumCARD3 = 297450389 Then
	$3known = "2"
		$3knownsuit = "h"
EndIf
If $checksumCARD4 = 297450389 Then
	$4known = "2"
		$4knownsuit = "h"
EndIf
If $checksumCARD5 = 297450389 Then
	$5known = "2"
		$5knownsuit = "h"
EndIf
If $pocket1sum = 297450389 Then
    $pocket1 = "2"
		$pocket1suit = "h"
	EndIf
If $pocket2sum = 297450389 Then
	$pocket2 = "2"
		$pocket2suit = "h"
EndIf

	

;2 of Spades
If $checksumCARD1 = 2642386433 Then
	$known = "2"
		$knownsuit = "s"
	EndIf
If $checksumCARD2 = 2642386433 Then
	$2known = "2"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 2642386433 Then
	$3known = "2"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 2642386433 Then
	$4known = "2"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 2642386433 Then
	$5known = "2"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 2642386433 Then
    $pocket1 = "2"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 2642386433 Then
	$pocket2 = "2"
	$pocket2suit = "s"
EndIf

;2 of Clubs
If $checksumCARD1 = 4192841102 Then
	$known = "2"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 4192841102 Then
	$2known = "2"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 4192841102 Then
	$3known = "2"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 4192841102 Then
	$4known = "2"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 4192841102 Then
	$5known = "2"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 4192841102 Then
    $pocket1 = "2"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 4192841102 Then
	$pocket2 = "2"
	$pocket2suit = "c"
	EndIf

;2 of Diamonds
If $checksumCARD1 = 3887318331 Then
	$known = "2"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 3887318331 Then
	$2known = "2"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 3887318331 Then
	$3known = "2"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 3887318331 Then
	$4known = "2"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 3887318331 Then
	$5known = "2"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 3887318331 Then
    $pocket1 = "2"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 3887318331 Then
	$pocket2 = "2"
	$pocket2suit = "d"
	EndIf

;;;;;;;;;;;;;;;;;;;Check for ANY 3's
;3 of Clubs
If $checksumCARD1 = 3704140759 Then
	$known = "3"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 3704140759 Then
	$2known = "3"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 3704140759 Then
	$3known = "3"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 3704140759 Then
	$4known = "3"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 3704140759 Then
	$5known = "3"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 3704140759 Then
    $pocket1 = "3"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 3704140759 Then
	$pocket2 = "3"
	$pocket2suit = "c"
	EndIf


;3 of Diamonds
If $checksumCARD1 = 2278738297 Then
	$known = "3"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 2278738297 Then
	$2known = "3"
		$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 2278738297 Then
	$3known = "3"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 2278738297 Then
	$4known = "3"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 2278738297 Then
	$5known = "3"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 2278738297 Then
    $pocket1 = "3"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 2278738297 Then
	$pocket2 = "3"
	$pocket2suit = "d"
	EndIf

;3 of Spades
If $checksumCARD1 = 3596985714 Then
	$known = "3"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 3596985714 Then
	$2known = "3"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 3596985714 Then
	$3known = "3"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 3596985714 Then
	$4known = "3"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 3596985714 Then
	$5known = "3"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 3596985714 Then
    $pocket1 = "3"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 3596985714 Then
	$pocket2 = "3"
	$pocket2suit = "s"
	EndIf

;3 of hearts
If $checksumCARD1 = 2998911163 Then
	$known = "3"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 2998911163 Then
	$2known = "3"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 2998911163 Then
	$3known = "3"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 2998911163 Then
	$4known = "3"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 2998911163 Then
	$5known = "3"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 2998911163 Then
    $pocket1 = "3"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 2998911163 Then
	$pocket2 = "3"
    $pocket2suit = "h"
EndIf


;4 of hearts
If $checksumCARD1 = 4240227343 Then
	$known = "4"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 4240227343 Then
	$2known = "4"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 4240227343 Then
	$3known = "4"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 4240227343 Then
	$4known = "4"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 4240227343 Then
	$5known = "4"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 4240227343 Then
    $pocket1 = "4"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 4240227343 Then
	$pocket2 = "4"
	$pocket2suit = "h"
EndIf

;4 of Diamonds
If $checksumCARD1 = 2716452255 Then
	$known = "4"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 2716452255 Then
	$2known = "4"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 2716452255 Then
	$3known = "4"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 2716452255 Then
	$4known = "4"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 2716452255 Then
	$5known = "4"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 2716452255 Then
    $pocket1 = "4"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 2716452255 Then
	$pocket2 = "4"
	$pocket2suit = "d"
EndIf

;4 of Spades
If $checksumCARD1 = 4023885499 Then
	$known = "4"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 4023885499 Then
	$2known = "4"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 4023885499 Then
	$3known = "4"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 4023885499 Then
	$4known = "4"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 4023885499 Then
	$5known = "4"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 4023885499 Then
    $pocket1 = "4"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 4023885499 Then
	$pocket2 = "4"
	$pocket2suit = "s"
EndIf

;4 of Clubs
If $checksumCARD1 = 266055195 Then
	$known = "4"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 266055195 Then
	$2known = "4"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 266055195 Then
	$3known = "4"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 266055195 Then
	$4known = "4"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 266055195 Then
	$5known = "4"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 266055195 Then
    $pocket1 = "4"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 266055195 Then
	$pocket2 = "4"
	$pocket2suit = "c"
EndIf

;5 of Clubs
If $checksumCARD1 = 1300476527 Then
	$known = "5"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 1300476527 Then
	$2known = "5"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 1300476527 Then
	$3known = "5"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 1300476527 Then
	$4known = "5"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 1300476527 Then
	$5known = "5"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 1300476527 Then
    $pocket1 = "5"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 1300476527 Then
	$pocket2 = "5"
	$pocket2suit = "c"
EndIf

;5 of hearts
If $checksumCARD1 = 299548583 Then
	$known = "5"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 299548583 Then
	$2known = "5"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 299548583 Then
	$3known = "5"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 299548583 Then
	$4known = "5"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 299548583 Then
	$5known = "5"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 299548583 Then
    $pocket1 = "5"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 299548583 Then
	$pocket2 = "5"
	$pocket2suit = "h"
EndIf

;5 of Diamonds
If $checksumCARD1 = 2156316821 Then
	$known = "5"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 2156316821 Then
	$2known = "5"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 2156316821 Then
	$3known = "5"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 2156316821 Then
	$4known = "5"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 2156316821 Then
	$5known = "5"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 2156316821 Then
    $pocket1 = "5"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 2156316821 Then
	$pocket2 = "5"
	$pocket2suit = "d"
EndIf

;5 of spades
If $checksumCARD1 = 1682744276 Then
	$known = "5"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 1682744276 Then
	$2known = "5"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 1682744276 Then
	$3known = "5"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 1682744276 Then
	$4known = "5"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 1682744276 Then
	$5known = "5"
	$pocket1suit = "s"
	EndIf
If $pocket1sum = 1682744276 Then
    $pocket1 = "5"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 1682744276 Then
	$pocket2 = "5"
	$pocket2suit = "s"
EndIf

;6 of spades
If $checksumCARD1 = 1606785286 Then
	$known = "6"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 1606785286 Then
	$2known = "6"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 1606785286 Then
	$3known = "6"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 1606785286 Then
	$4known = "6"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 1606785286 Then
	$5known = "6"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 1606785286 Then
    $pocket1 = "6"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 1606785286 Then
	$pocket2 = "6"
	$pocket2suit = "s"
EndIf

;6 of hearts
If $checksumCARD1 = 1641920543 Then
	$known = "6"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 1641920543 Then
	$2known = "6"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 1641920543 Then
	$3known = "6"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 1641920543 Then
	$4known = "6"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 1641920543 Then
	$5knownsuit = "h"
	$5known = "6"
	EndIf
If $pocket1sum = 1641920543 Then
    $pocket1 = "6"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 1641920543 Then
	$pocket2 = "6"
    $pocket2suit = "h"
EndIf

;6 of Diamonds
If $checksumCARD1 = 3960652399 Then
	$known = "6"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 3960652399 Then
	$2known = "6"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 3960652399 Then
	$3known = "6"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 3960652399 Then
	$4known = "6"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 3960652399 Then
	$5known = "6"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 3960652399 Then
    $pocket1 = "6"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 3960652399 Then
	$pocket2 = "6"
	$pocket2suit = "d"
EndIf

;6 of clubs
If $checksumCARD1 = 637446490 Then
	$known = "6"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 637446490 Then
	$2known = "6"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 637446490 Then
	$3known = "6"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 637446490 Then
	$4known = "6"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 637446490 Then
	$5known = "6"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 637446490 Then
    $pocket1 = "6"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 637446490 Then
	$pocket2 = "6"
	$pocket2suit = "c"
EndIf

;7 of Clubs
If $checksumCARD1 = 115129742 Then
	$known = "7"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 115129742 Then
	$2known = "7"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 115129742 Then
	$3known = "7"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 115129742 Then
	$4knownsuit = "c"
	$4known = "7"
	EndIf
If $checksumCARD5 = 115129742 Then
	$5known = "7"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 115129742 Then
    $pocket1 = "7"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 115129742 Then
	$pocket2 = "7"
	$pocket2suit = "c"
EndIf

;7 of hearts
If $checksumCARD1 = 880396480 Then
	$known = "7"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 880396480 Then
	$2known = "7"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 880396480 Then
	$3known = "7"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 880396480 Then
	$4known = "7"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 880396480 Then
	$5known = "7"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 880396480 Then
    $pocket1 = "7"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 880396480 Then
	$pocket2 = "7"
	$pocket2suit = "h"
EndIf

;7 of diamonds
If $checksumCARD1 = 1587925003 Then
	$known = "7"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 1587925003 Then
	$2known = "7"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 1587925003 Then
	$3known = "7"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 1587925003 Then
	$4known = "7"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 1587925003 Then
	$5known = "7"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 1587925003 Then
    $pocket1 = "7"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 1587925003 Then
	$pocket2 = "7"
	$pocket2suit = "d"
EndIf

;7 of Spades
If $checksumCARD1 = 4032344353 Then
	$known = "7"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 4032344353 Then
	$2known = "7"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 4032344353 Then
	$3known = "7"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 4032344353 Then
	$4known = "7"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 4032344353 Then
	$5known = "7"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 4032344353 Then
    $pocket1 = "7"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 4032344353 Then
	$pocket2 = "7"
	$pocket2suit = "s"
EndIf

;8 of Hearts
If $checksumCARD1 = 4104038525 Then
	$known = "8"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 4104038525 Then
	$2known = "8"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 4104038525 Then
	$3known = "8"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 4104038525 Then
	$4known = "8"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 4104038525 Then
	$5known = "8"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 4104038525 Then
    $pocket1 = "8"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 4104038525 Then
	$pocket2 = "8"
	$pocket2suit = "h"
EndIf

;8 of Diamonds
If $checksumCARD1 = 1467266451 Then
	$known = "8"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 1467266451 Then
	$2known = "8"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 1467266451 Then
	$3known = "8"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 1467266451 Then
	$4known = "8"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 1467266451 Then
	$5known = "8"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 1467266451 Then
    $pocket1 = "8"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 1467266451 Then
	$pocket2 = "8"
    $pocket2suit = "d"
EndIf

;8 of Clubs
If $checksumCARD1 = 4200961597 Then
	$known = "8"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 4200961597 Then
	$2known = "8"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 4200961597 Then
	$3known = "8"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 4200961597 Then
	$4known = "8"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 4200961597 Then
	$5known = "8"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 4200961597 Then
    $pocket1 = "8"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 4200961597 Then
	$pocket2 = "8"
	$pocket2suit = "c"
EndIf

;8 of Spades
If $checksumCARD1 = 3703865876 Then
	$known = "8"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 3703865876 Then
	$2known = "8"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 3703865876 Then
	$3known = "8"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 3703865876 Then
	$4known = "8"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 3703865876 Then
	$5known = "8"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 3703865876 Then
    $pocket1 = "8"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 3703865876 Then
	$pocket2 = "8"
	$pocket2suit = "s"
EndIf

;9 of hearts 
If $checksumCARD1 = 1828304999 Then
	$known = "9"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 1828304999 Then
	$2known = "9"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 1828304999 Then
	$3known = "9"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 1828304999 Then
	$4known = "9"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 1828304999 Then
	$5known = "9"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 1828304999 Then
    $pocket1 = "9"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 1828304999 Then
	$pocket2 = "9"
	$pocket2suit = "h"
EndIf

;9 of Diamonds
If $checksumCARD1 = 3024863902 Then
	$known = "9"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 3024863902 Then
	$2known = "9"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 3024863902 Then
	$3known = "9"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 3024863902 Then
	$4known = "9"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 3024863902 Then
	$5known = "9"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 3024863902 Then
    $pocket1 = "9"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 3024863902 Then
	$pocket2 = "9"
	$pocket2suit = "d"
EndIf

;9 of SPades
If $checksumCARD1 = 2879953242 Then
	$known = "9"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 2879953242 Then
	$2known = "9"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 2879953242 Then
	$3known = "9"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 2879953242 Then
	$4known = "9"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 2879953242 Then
	$5known = "9"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 2879953242 Then
    $pocket1 = "9"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 2879953242 Then
	$pocket2 = "9"
	$pocket2suit = "s"
EndIf

;9 of Clubs
If $checksumCARD1 = 1416014250 Then
	$known = "9"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 1416014250 Then
	$2known = "9"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 1416014250 Then
	$3known = "9"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 1416014250 Then
	$4known = "9"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 1416014250 Then
	$5known = "9"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 1416014250 Then
    $pocket1 = "9"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 1416014250 Then
	$pocket2 = "9"
	$pocket2suit = "c"
EndIf

;10 of hearts 
If $checksumCARD1 = 1166904616 Then
	$known = "10"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 1166904616 Then
	$2known = "10"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 1166904616 Then
	$3known = "10"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 1166904616 Then
	$4known = "10"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 1166904616 Then
	$5known = "10"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 1166904616 Then
    $pocket1 = "10"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 1166904616 Then
	$pocket2 = "10"
	$pocket2suit = "h"
EndIf

;10 of Diamonds
If $checksumCARD1 = 2099486523 Then
	$known = "10"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 2099486523 Then
	$2known = "10"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 2099486523 Then
	$3known = "10"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 2099486523 Then
	$4known = "10"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 2099486523 Then
	$5known = "10"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 2099486523 Then
    $pocket1 = "10"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 2099486523 Then
	$pocket2 = "10"
	$pocket2suit = "d"
EndIf

;10 of SPades
If $checksumCARD1 = 3657063050 Then
	$known = "10"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 3657063050 Then
	$2known = "10"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 3657063050 Then
	$3known = "10"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 3657063050 Then
	$4known = "10"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 3657063050 Then
	$5known = "10"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 3657063050 Then
    $pocket1 = "10"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 3657063050 Then
	$pocket2 = "10"
	$pocket2suit = "s"
EndIf

;10 of Clubs
If $checksumCARD1 = 39023864 Then
	$known = "10"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 39023864 Then
	$2known = "10"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 39023864 Then
	$3known = "10"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 39023864 Then
	$4known = "10"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 39023864 Then
	$5known = "10"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 39023864 Then
    $pocket1 = "10"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 39023864 Then
	$pocket2 = "10"
	$pocket2suit = "c"
EndIf

;Jack of Hearts
If $checksumCARD1 = 1850527098 Then
	$known = "J"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 1850527098 Then
	$2known = "J"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 1850527098 Then
	$3known = "J"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 1850527098 Then
	$4known = "J"
	$4knownsuit = "h"
    EndIf
If $checksumCARD5 = 1850527098 Then
	$5known = "J"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 1850527098 Then
    $pocket1 = "J"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 1850527098 Then
	$pocket2 = "J"
	$pocket2suit = "h"
EndIf

;Jack of Diamonds
If $checksumCARD1 = 3782661097 Then
	$known = "J"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 3782661097 Then
	$2known = "J"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 3782661097 Then
	$3known = "J"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 3782661097 Then
	$4known = "J"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 3782661097 Then
	$5known = "J"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 3782661097 Then
    $pocket1 = "J"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 3782661097 Then
	$pocket2 = "J"
   $pocket2suit = "d"
EndIf

;Jack of Spades
If $checksumCARD1 = 845658147 Then
	$known = "J"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 845658147 Then
	$2known = "J"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 845658147 Then
	$3known = "J"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 845658147 Then
	$4known = "J"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 845658147 Then
	$5known = "J"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 845658147 Then
    $pocket1 = "J"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 845658147 Then
	$pocket2 = "J"
    $pocket2suit = "s"
EndIf

;Jack of Clubs
If $checksumCARD1 = 1856029518 Then
	$known = "J"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 1856029518 Then
	$2known = "J"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 1856029518 Then
	$3known = "J"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 1856029518 Then
	$4known = "J"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 1856029518 Then
	$5known = "J"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 1856029518 Then
    $pocket1 = "J"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 1856029518 Then
	$pocket2 = "J"
	$pocket2suit = "c"
EndIf

;Queen of Hearts
If $checksumCARD1 = 1296997091 Then
	$known = "Q"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 1296997091 Then
	$2known = "Q"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 1296997091 Then
	$3known = "Q"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 1296997091 Then
	$4known = "Q"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 1296997091 Then
	$5known = "Q"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 1296997091 Then
    $pocket1 = "Q"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 1296997091 Then
	$pocket2 = "Q"
	$pocket2suit = "h"
EndIf

;Queen of Diamonds
If $checksumCARD1 = 3224152688 Then
	$known = "Q"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 3224152688 Then
	$2known = "Q"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 3224152688 Then
	$3known = "Q"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 3224152688 Then
	$4known = "Q"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 3224152688 Then
	$5known = "Q"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 3224152688 Then
    $pocket1 = "Q"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 3224152688 Then
	$pocket2 = "Q"
	$pocket2suit = "d"
EndIf

;Queen of Spades
If $checksumCARD1 = 1999793728 Then
	$known = "Q"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 1999793728 Then
	$2known = "Q"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 1999793728 Then
	$3known = "Q"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 1999793728 Then
	$4known = "Q"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 1999793728 Then
	$5known = "Q"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 1999793728 Then
    $pocket1 = "Q"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 1999793728 Then
	$pocket2 = "Q"
	$pockte2suit = "s"
EndIf

;Queen of Clubs
If $checksumCARD1 = 2907866532 Then
	$known = "Q"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 2907866532 Then
	$2known = "Q"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 2907866532 Then
	$3known = "Q"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 2907866532 Then
	$4known = "Q"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 2907866532 Then
	$5known = "Q"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 2907866532 Then
    $pocket1 = "Q"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 2907866532 Then
	$pocket2 = "Q"
	$pocket2suit = "c"
EndIf

;King of Hearts 
If $checksumCARD1 = 1877061243 Then
	$known = "K"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 1877061243 Then
	$2known = "K"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 1877061243 Then
	$3known = "K"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 1877061243 Then
	$4known = "K"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 1877061243 Then
	$5known = "K"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 1877061243 Then
    $pocket1 = "K"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 1877061243 Then
	$pocket2 = "K"
	$pocket2suit = "h"
EndIf

;King of Diamonds
If $checksumCARD1 = 3601119864 Then
	$known = "K"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 3601119864 Then
	$2known = "K"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 3601119864 Then
	$3known = "K"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 3601119864 Then
	$4known = "K"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 3601119864 Then
	$5known = "K"
	$5knownsuit = "d"
	EndIf
If $pocket1sum = 3601119864 Then
    $pocket1 = "K"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 3601119864 Then
	$pocket2 = "K"
    $pocket2suit = "d"
EndIf

;King of Spades
If $checksumCARD1 = 476744417 Then
	$known = "K"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 476744417 Then
	$2known = "K"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 476744417 Then
	$3known = "K"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 476744417 Then
	$4known = "K"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 476744417 Then
	$5known = "K"
	$5knownsuit = "s"
	EndIf
If $pocket1sum = 476744417 Then
    $pocket1 = "K"
	$pocket1suit = "s"
	EndIf
If $pocket2sum = 476744417 Then
	$pocket2 = "K"
	$pocket2suit = "s"
EndIf

;King of Clubs
If $checksumCARD1 = 1540791706 Then
	$known = "K"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 1540791706 Then
	$2known = "K"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 1540791706 Then
	$3known = "K"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 1540791706 Then
	$4known = "K"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 1540791706 Then
	$5known = "K"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 1540791706 Then
    $pocket1 = "Kc"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 1540791706 Then
	$pocket2 = "K"
	$pocket2suit = "c"
EndIf

;Ace of Hearts
If $checksumCARD1 = 2483794973 Then
	$known = "A"
	$knownsuit = "h"
	EndIf
If $checksumCARD2 = 2483794973 Then
	$2known = "A"
	$2knownsuit = "h"
	EndIf
If $checksumCARD3 = 2483794973 Then
	$3known = "A"
	$3knownsuit = "h"
	EndIf
If $checksumCARD4 = 2483794973 Then
	$4known = "A"
	$4knownsuit = "h"
	EndIf
If $checksumCARD5 = 2483794973 Then
	$5known = "A"
	$5knownsuit = "h"
	EndIf
If $pocket1sum = 2483794973 Then
    $pocket1 = "A"
	$pocket1suit = "h"
	EndIf
If $pocket2sum = 2483794973 Then
	$pocket2 = "A"
	$pocket2suit = "h"
EndIf

;Ace of Diamonds
If $checksumCARD1 = 1337114398 Then
	$known = "A"
	$knownsuit = "d"
	EndIf
If $checksumCARD2 = 1337114398 Then
	$2known = "A"
	$2knownsuit = "d"
	EndIf
If $checksumCARD3 = 1337114398 Then
	$3known = "A"
	$3knownsuit = "d"
	EndIf
If $checksumCARD4 = 1337114398 Then
	$4known = "A"
	$4knownsuit = "d"
	EndIf
If $checksumCARD5 = 1337114398 Then
	$5known = "A"
   $knownsuit = "d"
	EndIf
If $pocket1sum = 1337114398 Then
    $pocket1 = "A"
	$pocket1suit = "d"
	EndIf
If $pocket2sum = 1337114398 Then
	$pocket2 = "A"
	$pocket2suit = "d"
EndIf

;Ace of Spades
If $checksumCARD1 = 1032557339 Then
	$known = "A"
	$knownsuit = "s"
	EndIf
If $checksumCARD2 = 1032557339 Then
	$2known = "A"
	$2knownsuit = "s"
	EndIf
If $checksumCARD3 = 1032557339 Then
	$3known = "A"
	$3knownsuit = "s"
	EndIf
If $checksumCARD4 = 1032557339 Then
	$4known = "A"
	$4knownsuit = "s"
	EndIf
If $checksumCARD5 = 1032557339 Then
	$5known = "A"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 1032557339 Then
    $pocket1 = "A"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 1032557339 Then
	$pocket2 = "A"
	$pocket2suit = "c"
EndIf

;Ace of clubs
If $checksumCARD1 = 927900785 Then
	$known = "A"
	$knownsuit = "c"
	EndIf
If $checksumCARD2 = 927900785 Then
	$2known = "A"
	$2knownsuit = "c"
	EndIf
If $checksumCARD3 = 927900785 Then
	$3known = "A"
	$3knownsuit = "c"
	EndIf
If $checksumCARD4 = 927900785 Then
	$4known = "A"
	$4knownsuit = "c"
	EndIf
If $checksumCARD5 = 927900785 Then
	$5known = "A"
	$5knownsuit = "c"
	EndIf
If $pocket1sum = 927900785 Then
    $pocket1 = "A"
	$pocket1suit = "c"
	EndIf
If $pocket2sum = 927900785 Then
	$pocket2 = "A"
	$pocket2suit = "c"
EndIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;END DISCOVER KNOWN CARDS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;HAND CALCULATIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$handrank = "Unknown"


$paircount = 0

;;;;;;;;;;;;;;;;;***CHECK IF ONE OR TWO PAIR****;;;;;;;;;;;;;;;;;;;;;;;
;if $pocket1 = $pocket2 Then
;	$paircount = 1
;EndIf

;;;;check if first card has paired
if $pocket1 = $known Then
	$paircount = $paircount + 1
EndIf

if $pocket1 = $2known Then
	$paircount = $paircount + 1
EndIf

if $pocket1 = $3known Then
	$paircount = $paircount + 1
EndIf

if $pocket1 = $4known Then
	$paircount = $paircount + 1
EndIf

if $pocket1 = $5known Then
	$paircount = $paircount + 1
EndIf
;;;;check if 2nd pocket card has paired
if $pocket2 = $known Then
	$paircount = $paircount + 1
EndIf

if $pocket2 = $2known Then
	$paircount = $paircount + 1
EndIf

if $pocket2 = $3known Then
	$paircount = $paircount + 1
EndIf

if $pocket2 = $4known Then
	$paircount = $paircount + 1
EndIf

if $pocket2 = $5known Then
	$paircount = $paircount + 1
EndIf

;;;;check if board has paired
if $known = $2known Then
	$paircount = $paircount + 1
EndIf

if $known = $3known Then
	$paircount = $paircount + 1
EndIf

if $known = $4known Then
	$paircount = $paircount + 1
EndIf

if $known = $5known Then
	$paircount = $paircount + 1
EndIf

	   if $paircount = 1 Then
		   $handrank = "One Pair..."
	   else 
		   if $paircount = 2 Then
			$handrank = "Two Pair"
					else
			if $paircount = 3 Then
				$handrank = "Three of a Kind"
				else
		   $handrank = "Waiting..."
		   Endif
	   EndIf
	EndIf
;;;;;;;;;;;TWO PAIR;;;;;;;;;;;;;;



$pocketmessage = "Pocket Cards: " & @crlf & $pocket1 & $pocket1suit & "   "  & $pocket2 & $pocket2suit & @crlf & @crlf 
$boardmessage = "Board Cards: " & @crlf & $known & $knownsuit & "   "  & $2known & $2knownsuit & "   "  & $3known & $3knownsuit & "   "  & $4known & $4knownsuit & "   "  & $5known & $5knownsuit & @crlf & @crlf 
$handrankmessage = "Hand Rank: " & $handrank & @crlf

;OLD FORMATTED MESSAGE
;$pocketmessage = $pocket1sum & "  " & $pocket1 & @crlf & $pocket2sum & "  " & $pocket2

;OLD FORMATTED MESSAGE
$message = "First Card: " & $checksumCARD1 & "  " & $known & @CRLF & "Second Card:  " & $checksumcard2 & "  " & $2known & @CRLF & "Third Card:  " & $checksumcard3 & "  " & $3known & "  " & @CRLF & "Fourth Card:  " & $checksumcard4 & "  " & $4known & @CRLF & "Fifth Card:  " & $checksumcard5 & "  " & $5known & @CRLF    

;$myseatmessage = $yourseat1 & @CRLF & $yourseat2 & @CRLF & $yourseat3 & @CRLF & $yourseat4 & @CRLF & $yourseat5 & @CRLF & $yourseat6 

#Region --- CodeWizard generated code Start ---
;ToolTip features: Text=Yes, X Coordinate=Yes, Y Coordinate=Yes, Title=Yes, Info icon, Center the tip at the x,y coordinates
If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
$sToolTipAnswer = ToolTip( $pocketmessage & $boardmessage & $handrankmessage & @crlf & $seatmessage & @crlf & $message & @CRLF ,900,300,$windowname,1,2)
#EndRegion --- CodeWizard generated code End ---



until $looprun = 10000