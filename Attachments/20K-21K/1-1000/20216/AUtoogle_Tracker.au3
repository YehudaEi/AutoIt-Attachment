; AUtoogle Tracker - Google Maps GPS Tracker
; VERSION 1.0.8
; WRITEN BY --- WASEEM CHEHAB 
; E-Mail --- SEESOE@GMAIL.COM
; AUTOIT USER -- SEESOE

#include <file.au3>
#include <FTP.au3>
#include <MATH.au3>
#include <GUIConstants.au3>
#include <staticconstants.au3>
#include <CommMG.au3>

$iniName = "Settings.ini"
$xmlName = "NMEA.xml"

Opt("OnExitFunc","alldone")
HotKeySet("{ESC}","alldone")

#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("AUtoogle Tracker - Google Maps GPS Tracker", 452, 363, 246, 200)
$Group1 = GUICtrlCreateGroup("Device Data", 8, 8, 433, 161)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Labe9 = GUICtrlCreateLabel("COM Port Number", 208, 72, 90, 17)
$CmboPortsAvailable = GUICtrlCreateCombo("", 322, 72, 100, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlCreateLabel("NMEA Data:", 16, 24, 64, 17)
$nmea = GUICtrlCreateLabel("No Signal", 88, 24, 350, 17)
GUICtrlCreateLabel("Satellites:", 31, 48, 44, 17)
$sat = GUICtrlCreateLabel("No Signal", 88, 48, 120, 17)
GUICtrlCreateLabel("Time:", 50, 72, 28, 17)
$ptime = GUICtrlCreateLabel("No Signal", 88, 72, 120, 17)
GUICtrlCreateLabel("Latitude:", 35, 96, 45, 17)
$pLong = GUICtrlCreateLabel(" N/A", 85, 120, 120, 17)
GUICtrlCreateLabel("Longitude:", 26, 120, 54, 17)
$pLat = GUICtrlCreateLabel("N/A", 88, 96, 120, 17)
GUICtrlCreateLabel("Altitude:", 38, 144, 42, 17)
$alt = GUICtrlCreateLabel("N/A", 88, 144, 120, 17)

$Group4 = GUICtrlCreateGroup("COM Port", 176, 48, 265, 121)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$BtnApply = GUICtrlCreateButton("Connect", 322, 122, 100, 30, $BS_FLAT)
$Lstat = GUICtrlCreateLabel("Not Connected", 190, 124, 105, 27, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0xff0000)
GUICtrlSetColor(-1, 0xffffff)

$Group2 = GUICtrlCreateGroup("FTP Connection", 219, 176, 222, 177)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label = GUICtrlCreateLabel("Address", 236, 192, 42, 17)
$ftphost = GUICtrlCreateInput("", 280, 192, 150, 21)
$Labe2 = GUICtrlCreateLabel("Username", 226, 216, 52, 17)
$username = GUICtrlCreateInput("", 280, 216, 150, 21)
$Labe3 = GUICtrlCreateLabel("Password", 226, 240, 50, 17)
$password = GUICtrlCreateInput("", 280, 240, 150, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
$Labe4 = GUICtrlCreateLabel("Directory", 230, 264, 46, 17)
$remotePath = GUICtrlCreateInput("", 280, 264, 150, 21)
$sendnow = GUICtrlCreateButton("Send Now", 357, 288, 73, 25)

$Labe7 = GUICtrlCreateLabel("XML Upload Status", 230, 296, 96, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("XML Data", 8, 176, 201, 177)
$Labe5 = GUICtrlCreateLabel("Marker Name", 16, 192, 68, 17)
$title = GUICtrlCreateInput("", 88, 192, 113, 21)
$Labe6 = GUICtrlCreateLabel("Info Box HTML", 16, 220, 76, 17)
$htmlbox = GUICtrlCreateEdit("", 16, 240, 185, 97)

$Progress1 = GUICtrlCreateProgress(229, 320, 201, 17)
GUICtrlSetData(-1, "35")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Func _xml2ftpU()
	If FileExists( @ScriptDir & '/' & $xmlName) Then
		$Vftphost = GUICtrlRead($ftphost)
		$Vusername = GUICtrlRead($username)
		$Vpassword = GUICtrlRead($password)
		$VremotePath = GUICtrlRead($remotePath)
		$Open = _FTPOpen('MyFTP Control')
		$Conn = _FTPConnect($Open, $Vftphost, $Vusername, $Vpassword)
		$Ftpp = _FtpPutFile($Conn, @ScriptDir & '/' & $xmlName, $VremotePath & $xmlName)
		$Ftpc = _FTPClose($Open)
	EndIf
EndFunc

Func _Dmmm2Dec($degrees, $sw)
    Local $deg = Floor($degrees / 100); decimal degrees
    Local $frac = (($degrees / 100) - $deg) / 0.6; decimal fraction
    Local $ret = Round($deg + $frac, 6); positive return value
    If $sw = "S" Or $sw = "W" Then $ret = $ret * -1; flip sign if south or west
    Return $ret
EndFunc

Func AllDone()
	_Commcloseport()
	Exit
EndFunc


If FileExists( @ScriptDir & '/' & $iniName) Then
	GUICtrlSetData ($CmboPortsAvailable, IniRead ($iniName, "COM", "Port", ""))
	GUICtrlSetData ($ftphost, IniRead ($iniName, "FTP Setup", "Host", ""))
	GUICtrlSetData ($username, IniRead ($iniName, "FTP Setup", "Username", ""))
	GUICtrlSetData ($password, IniRead ($iniName, "FTP Setup", "Password", ""))
	GUICtrlSetData ($remotePath, IniRead ($iniName, "FTP Setup", "Dir", ""))
	GUICtrlSetData ($title, IniRead ($iniName, "Marker", "Name", ""))
	GUICtrlSetData ($htmlbox, IniRead ($iniName, "Marker", "HTML", ""))
EndIf

$portlist = _CommListPorts(0);find the available COM ports and write them into the ports combo
If @error = 1 Then 
	MsgBox(0,'trouble getting portlist','Program will terminate!')
	Exit
EndIf
For $pl = 1 To $portlist[0]
	GUICtrlSetData($CmboPortsAvailable,$portlist[$pl]);_CommListPorts())
Next
GUICtrlSetData($CmboPortsAvailable,$portlist[1]);show the first port found

$connected = False

While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then 
		IniWrite ($iniName, "COM", "Port", GUICtrlRead($CmboPortsAvailable))
		IniWrite ($iniName, "FTP Setup", "Host", GUICtrlRead($ftphost))
		IniWrite ($iniName, "FTP Setup", "Username", GUICtrlRead($username))
		IniWrite ($iniName, "FTP Setup", "Password", GUICtrlRead($password))
		IniWrite ($iniName, "FTP Setup", "Dir", GUICtrlRead($remotePath))
		IniWrite ($iniName, "Marker", "Name", GUICtrlRead($title))
		IniWrite ($iniName, "Marker", "HTML", GUICtrlRead($htmlbox))
		Exit
	EndIf

;Connect Color Changing Lable On Com Connection Status and button press		
    If $msg = $BtnApply Then
        If Not $connected Then
			Local $sportSetError
			$setport = StringReplace(GUICtrlRead($CmboPortsAvailable),'COM','')
            If _CommSetPort($setPort,$sportSetError, 4800, 8, 0, 1, 0) Then
                GUICtrlSetBkColor($BtnApply, 0x00FF00)
                $connected = True
                GUICtrlSetData($BtnApply, "Disconnect")
                GUICtrlSetData($Lstat, "Connected")
			Else
				GUICtrlSetBkColor($Lstat, 0xFF0000)
				$connected = False
				GUICtrlSetData($BtnApply, "Connect")
				GUICtrlSetData($Lstat, "Not Connected")
            EndIf
        Else
			GUICtrlSetBkColor($Lstat, 0xFF0000)
            $connected = False
            GUICtrlSetData($BtnApply, "Connect")
            GUICtrlSetData($Lstat, "Not Connected")
            _Commcloseport()
        EndIf
    EndIf

;send xml file now button
	If $msg = $sendnow Then _xml2ftpU()

;start the string phrasing
	$sData = _CommGetstring()
	If StringInStr($sData, "$GPGGA") Then
		$avData = StringSplit($sData, ",")
			If $avData[0] > 9 Then
				;phrase the time
;				$avtData = StringSplit($avData[2], "")
;				$hour = $avtData[0] & $avtData[1]
;				$avHour = (($hour - 4) - 7)
				;phrase the long lat in final var
				$lat = _Dmmm2Dec(($avData[3]) ,$avData[4])
				$long = _Dmmm2Dec(($avData[5]) ,$avData[6])
				;dsplay the nmea data
				GUICtrlSetData($nmea, $sData)
				GUICtrlSetData($sat, $avData[8])
;				GUICtrlSetData($ptime, $avHour & " : " & $avtData[2] & $avtData[3] & " : " & $avtData[4] & $avtData[5])
				GUICtrlSetData($pLat, $lat)
				GUICtrlSetData($pLong, $long)
				GUICtrlSetData($alt, $avData[10] * 3)
				;xml layout/make
				$htmlxmlbox = GUICtrlRead($htmlbox)
				$tLable = GUICtrlRead($title)
				$hnd = FileOpen ($xmlName, 2)
					FileWrite($hnd, "   <markers>" &@crlf)
					FileWrite($hnd, '     <marker lat="' &$lat& '" lng="' & $long & '" html="' &$htmlxmlbox& '" label="' &$tLable& '" />' &@crlf)
					FileWrite($hnd, "   </markers>")
					FileClose($hnd)
				;fup upload
				_xml2ftpU()
			EndIf
	EndIf
WEnd
Alldone()