#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

global $data = InputBox(" ","enter your data")
global $file = "myfile.ini"
global $read = ""
global $asection[10]
$asection[0] = "section1"
$asection[1] = "section2"
$asection[2] = "section3"
$asection[3] = "section4"
$asection[4] = "section5"
$asection[5] = "section6"
$asection[6] = "section7"
$asection[7] = "section8"
$asection[8] = "section9"
$asection[9] = "section10"

_store($file,$data,$read,$asection)

Func _Store ($file,$data,$read,$asection)
	$read = IniReadSection($file,$asection[0])
	if @error then 
		iniwrite($file,$asection[0],"data",$data)
		exit
	EndIf
	
	$read = IniReadSection($file,$asection[1])
	if @error then 
		iniwrite($file,$asection[1],"data",$data)
		exit
	EndIf
	
	$read = IniReadSection($file,$asection[2])
	if @error then 
		iniwrite($file,$asection[2],"data",$data)
		exit
	EndIf
	
	$read = IniReadSection($file,$asection[3])
	if @error then 
		iniwrite($file,$asection[3],"data",$data)
		exit
	EndIf
	
	$read = IniReadSection($file,$asection[4])
	if @error then 
		iniwrite($file,$asection[4],"data",$data)
		exit
	EndIf
	
	$read = IniReadSection($file,$asection[5])
	if @error then 
		iniwrite($file,$asection[5],"data",$data)
		exit
	EndIf
	
	$read = IniReadSection($file,$asection[6])
	if @error then 
		iniwrite($file,$asection[6],"data",$data)
		exit
	EndIf
	
	$read = IniReadSection($file,$asection[7])
	if @error then 
		iniwrite($file,$asection[7],"data",$data)
		exit
	EndIf
	
	$read = IniReadSection($file,$asection[8])
	if @error then 
		iniwrite($file,$asection[8],"data",$data)
		exit
	EndIf
	
	$read = IniReadSection($file,$asection[9])
	if @error then 
		iniwrite($file,$asection[9],"data",$data)
		exit
	else 
		MsgBox(0," ","Sections is over")
	EndIf
	
Endfunc ;_store
