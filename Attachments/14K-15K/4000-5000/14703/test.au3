AutoItSetOption ( "pixelcoordmode", 1 )
AutoItSetOption ( "WinTitleMatchMode", 3)

$windowname = InputBox ("Table Name", "Enter the name of the table your sitting at.", "", "")
$looprun = 0 
$card1suit = 0
$message = 0

Do
	
WinActivate ($windowname)
WinWaitActive ( $windowname)
WinMove ($windowname, "" ,0,0)
sleep (1000)




$looprun = $looprun + 1

$blank = 0

;gather checksums for each card on the flop
do
	$checksumCARD1 = PixelChecksum ( 178, 208, 190, 220)
	$checksumcard2 = PixelChecksum ( 225, 208, 237, 220)
	$checksumcard3 = PixelChecksum ( 273, 208, 285, 220)


;Checks if there is no card on the table thus program is waiting for flop
If $checksumCARD1 = 2682094159 then
	$blank = "1"
EndIf
If 	$blank = "1" then
	sleep (500) 
	$message = "No Cards... Waiting for flop..."
If $checksumCARD1 > 2682094159 then 
	$blank = "0"
EndIf
if $checksumCARD1 < 2682094159 Then
	$blank = "0"
EndIf

EndIf

#Region --- CodeWizard generated code Start ---
;SpashText features: Title=Yes, Text=Yes, Width=100, Height=50, Always On Top, Center justified text, OS default font
SplashTextOn("Checksum",$message,"200","50","-1","-1",0,"","","")
#EndRegion --- CodeWizard generated code End ---

until $blank = "0"
	

;Test if checksum is recognized
$known = "Unknown"
$2known = "Unknown"
$3known = "Unknown"
$4known = "Unknown"
$5known = "Unknown"

; START CARD KNOWN SEQUENCE, CHECKING FLOP CARDS CHECKSUM AGAINST KNOWN CHECKSUMS

;2 of hearts
If $checksumCARD1 = 3707551378 Then
	$known = "2 Of Hearts"
EndIf
If $checksumCARD2 = 3707551378 Then
	$2known = "2 Of Hearts"
EndIf
If $checksumCARD3 = 3707551378 Then
	$3known = "2 Of Hearts"
EndIf
;If $checksumCARD4 = 3707551378 Then
;	$4known = "2 Of Hearts"
;EndIf
;If $checksumCARD5 = 3707551378 Then
;	$5known = "2 Of Hearts"
;EndIf

;6 of Diamonds
If $checksumCARD1 = 1265419849 Then
	$known = "6 Of Diamonds"
EndIf
If $checksumCARD2 = 1265419849 Then
	$2known = "6 Of Diamonds"
EndIf
If $checksumCARD3 = 1265419849 Then
	$3known = "6 Of Diamonds"
EndIf
;If $checksumCARD4 = 1265419849 Then
;	$4known = "6 Of Diamonds"
;EndIf
;If $checksumCARD5 = 1265419849 Then
;	$5known = "6 Of Diamonds"
;EndIf

;Jack of Spades
If $checksumCARD1 = 1820704219 Then
	$known = "Jack Of Spades"
EndIf
If $checksumCARD2 = 1820704219 Then
	$2known = "Jack of Spades"
EndIf
If $checksumCARD3 = 1820704219 Then
	$3known = "Jack of Spades"
EndIf
;If $checksumCARD4 = 1820704219 Then
;	$4known = "6 Of Diamonds"
;EndIf
;If $checksumCARD5 = 1820704219 Then
;	$5known = "6 Of Diamonds"
;EndIf


$message = "First Card: " & $checksumCARD1 & "  " & $known & @CRLF & "Second Card:  " & $checksumcard2 & "  " & $2known & @CRLF & "Third Card:  " & $checksumcard3 & "  " & $3known & "  " & @CRLF

#Region --- CodeWizard generated code Start ---
;SpashText features: Title=Yes, Text=Yes, Width=100, Height=50, Always On Top, Center justified text, OS default font
SplashTextOn("Checksum",$message,"400","75","-1","-1",0,"","","")
#EndRegion --- CodeWizard generated code End ---








sleep (1500)
until $looprun = 100





	