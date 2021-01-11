#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.1.1.0
 Author:         tAK Telapis

 Script Function: Grab MegaTokyo Comics
	Template AutoIt script.

NOTES:
	Create the directory c:\MegaTokyo\ before starting this script
	im not sure if it gets auto created. and its neater if it doesnt.
	on the 4th line up from the bottom, $i is matched to a number,
	this number should be set to the number of the most current comic
	as viewable at                          , simple right click the
	current comic, and choose properties. the number is used as part
	of the filename.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; ---------------------------------
; Set main variables here - directory for comics to be saved here, startubg comic number ($i), set file types
; ---------------------------------
$MTFolder = "C:\MegaTokyo\"
$i = 1
$gif = ".gif"
$jpg = ".jpg"

While 1 ; begin the loop
; ---------------------------------
; Set the file name for the comics as 000 is lost in calculations, default to .gif files
; ---------------------------------
$len = StringLen($i)
	If $len = 1 then
		$ComicName = ("000"&$i)
	ElseIf $len = 2 then
		$ComicName = ("00"&$i)
	ElseIf $len = 3 Then
		$ComicName = ("0"&$i)
	EndIf

; ---------------------------------
; Set the URL of the comic wanted, this keeps the InetGet function clean, check if .gif is valid, if not, change to .jpg
; ---------------------------------
$Url = "                                "
$URLSize = InetGetSize("                                "&$ComicName&$gif)
	If $URLSize = 0 then
		$ComicName = ($ComicNAme&$jpg)
	Else
		$ComicName = ($ComicName&$gif)
	EndIf

; ---------------------------------
; get the file, and save it to the MTFolder with the calculated ComicName
; ---------------------------------
InetGet ($url&$ComicName, $MTFolder&$ComicNAme)
; Check to see if the file exists
	If $MTFolder&$ComicName = -1 then
		MsgBox(16, "Error", "Failed to get comic # "&$ComicName)
		Exit
	EndIf
; Check to see that the file has size
$Size = FileGetSize($MTFolder&$ComicName)
	If $Size <= 1 then
		MsgBox(16, "File size is null for", $MTFolder&$ComicName" File size was "&$size)
		Exit
	EndIf
; increase the comic number by 1 to get the next comic
$i = $i + 1
If $i == 887 Then
	MsgBox(0, "End of Comics", "there are only 886 comics at the time of this script, happy reading")
	Exit
EndIf
Wend