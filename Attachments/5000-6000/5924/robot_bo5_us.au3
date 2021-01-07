;Monitoring BI Servers
;BO 5 robot
;Script written by Fabien Lepicard
;Business Intelligence Tools
;3M
;this script is the robot engine for BO 5 US environment
;=================================================================================================================================================================================

; Define includes
#include <IE.au3>
#include <Date.au3>
#include <File_Ressources_BO5US.au3>
;=================================================================================================================================================================================

; Define Script options

; This tells AutoIt how to match window titles.
AutoItSetOption("WinTitleMatchMode", 2)
; See the help file for details of other matching modes.

; This line just complicates my explanation of what is going on.
AutoItSetOption("WinDetectHiddenText", 1)
; Wait until the end of the script for more info on this.

; This tells AutoIt how to match window text.
AutoItSetOption("WinTextMatchMode", 1)
; See the help file for details of other matching modes.

; This tells AutoIt how long to pause after a successful window-related operation.
AutoItSetOption("WinWaitDelay", 1) ; (milliseconds)
; See the help file for more details.

; hide icon tray
AutoItSetOption("TrayIconHide",1)

; Get the mouse out of the way.
MouseMove(0, 0, 10)
; If the mouse happens to be where a link could appear in the web page then it could mess up this script.
;=================================================================================================================================================================================

; Initializing variables
Global $url=ReadValueIniFile("BO5-US.ini","BO5-US","url","null")
If $url=="null" Then
	SetError(1)
EndIf
manageERR()

Global $login=ReadValueIniFile("BO5-US.ini","BO5-US","login","null")
If $login=="null" Then
	SetError(1)
EndIf
manageERR()

Global $pwd=ReadValueIniFile("BO5-US.ini","BO5-US","pwd","null")
If $pwd=="null" Then
	SetError(1)
EndIf
manageERR()

Global $timeout=ReadValueIniFile("BO5-US.ini","BO5-US","timeout","null")
If $timeout=="null" Then
	SetError(1)
EndIf
manageERR()

Global $country=ReadValueIniFile("BO5-US.ini","BO5-US","country","null")
If $country=="null" Then
	SetError(1)
EndIf
manageERR()

Global $place=ReadValueIniFile("BO5-US.ini","BO5-US","place","null")
If $place=="null" Then
	SetError(1)
EndIf
manageERR()

Global $report=ReadValueIniFile("BO5-US.ini","BO5-US","report","null")
manageERR()

Global $application=ReadValueIniFile("BO5-US.ini","BO5-US","application","null")
manageERR()

; BEGIN SCRIPT
;=================================================================================================================================================================================
$timerBeginTimeout=_NowCalc()
; BEGIN STEP 1 : Create a new instance of Internet Explorer
$IE_BO5US = _IECreate ()
manageERR()
; initializing the variable $startLogon
$startLogon= _NowCalc()
; navigate to the Webi index page
_IENavigate($IE_BO5US, $url)
manageERR()
; wait for a window with "InfoView Home Page" in the title
WinWait("InfoView Home Page", "")
; active that window - just in case
WinActivate("InfoView Home Page", "")
; wait until that window is active
WinWaitActive("InfoView Home Page", "")
; waiting for complete loading of the page
_IELoadWait($IE_BO5US)
manageERR()
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then
		
	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	
	Exit
	
EndIf
; END STEP 1
;=================================================================================================================================================================================
$timerBeginTimeout=_NowCalc()
; BEGIN STEP 2 : Click on LOGIN button to log on the server
_IEClickImg($IE_BO5US, "LogInButton_WEN.gif", "src",0,0)
manageERR()
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then

	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	Exit
	
EndIf
; END STEP 2
;=================================================================================================================================================================================
; BEGIN STEP 3 : Entering credentials
$timerBeginTimeout=_NowCalc()
WinWait("Connect to euspwebi", "")
; active that window - just in case
WinActivate("Connect to euspwebi", "")
; wait until that window is active
WinWaitActive("Connect to euspwebi", "")
; entering username and password thus click on OK to validate
ControlSetText("Connect to euspwebi", "", "Edit2", $login)
ControlSetText("Connect to euspwebi", "", "Edit3", $pwd)
ControlClick("Connect to euspwebi", "", "Button2")
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then

	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	Exit
	
EndIf
; END STEP 3
;=================================================================================================================================================================================
; BEGIN STEP 4 : Click on Corporate Documents link in the left frame which name is navigationbar
$timerBeginTimeout=_NowCalc()
WinWait("Welcome eupirobo", "")
; active that window - just in case
WinActivate("Welcome eupirobo", "")
; wait until that window is active
WinWaitActive("Welcome eupirobo", "")
; waiting for complete loading of the page
_IELoadWait($IE_BO5US)
manageERR()
; initializing pointer on the good frame
$FrameNavigationBar=_IEFrameGetObjByName($IE_BO5US, "navigationbar")
manageERR()
; clicking on the link
_IEClickImg($FrameNavigationBar, "d_corporate_WEN.gif", "src",0,0)
manageERR()
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then

	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	Exit
	
EndIf
; END STEP 4
;=================================================================================================================================================================================
; BEGIN STEP 5 : Click on Allegheny product medium in the main frame which name is documentlist
$timerBeginTimeout=_NowCalc()
WinWait("Corporate documents available to eupirobo", "")
; active that window - just in case
WinActivate("Corporate documents available to eupirobo", "")
; wait until that window is active
WinWaitActive("Corporate documents available to eupirobo", "")
; waiting for complete loading of the page
_IELoadWait($IE_BO5US)
manageERR()
; initializing pointer on the good frame
$FrameAlleghenyProductMedium=_IEFrameGetObjByName($IE_BO5US, "documentlist")
manageERR()
; clicking on the link
_IEClickLinkByText($FrameAlleghenyProductMedium, $report)
manageERR()
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then

	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	Exit
	
EndIf
; END STEP 5
;=================================================================================================================================================================================
$timerBeginTimeout=_NowCalc()
; BEGIN STEP 6 : Refresh the list of documents by clicking on the refresh button in the top bar frame which is contains in the main frame which name is documentview
WinWait("Document Results Allegheny product medium", "")
; active that window - just in case
WinActivate("Document Results Allegheny product medium", "")
; wait until that window is active
WinWaitActive("Document Results Allegheny product medium", "")
; waiting for complete loading of the page
$timerBeginTimeout=_NowCalc()
_IELoadWait($IE_BO5US)
manageERR()
; initializing pointer on the main frame
$Frame=_IEFrameGetObjByName($IE_BO5US, "documentview")
manageERR()
; initializing pointer on the good frame in the main frame
$FrameRefresh=_IEFrameGetObjByName($Frame, "topbar")
manageERR()
; clicking on the link to refresh the list of the documents
_IEClickImg($FrameRefresh, "ButtonRefresh_WEN.gif", "src",0,0)
manageERR()
; initializing the variable $startRefresh
$startRefresh = _NowCalc()
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then

	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	Exit
	
EndIf
; END STEP 6
;=================================================================================================================================================================================
$timerBeginTimeout=_NowCalc()
; BEGIN STEP 7 : Click on Logout on the left frame which name is navigationbar
; waiting for complete loading of the page
_IELoadWait($Frame)
manageERR()
; initializing the variable $endRefresh
$endRefresh = _NowCalc()
; calaculate the difference between the startRefresh and the endRefresh
$deltaRefresh =_DateDiff("s", $startRefresh, $endRefresh)
; initializing pointer on the good frame
$FrameLogout=_IEFrameGetObjByName($IE_BO5US, "navigationbar")
manageERR()
; clicking on the link
_IEClickImg($FrameLogout, "d_logout_WEN.gif", "src",0,0)
manageERR()
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then

	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	
	Exit
	
EndIf
; END STEP 7
;=================================================================================================================================================================================
$timerBeginTimeout=_NowCalc()
; BEGIN STEP 8 : Click on the "Yes" button to confirm logout which is contains in the frame which name is logoutapplication
_IELoadWait($IE_BO5US)
manageERR()
; initializing pointer on the good frame
$FrameButtonLogout=_IEFrameGetObjByName($IE_BO5US, "logoutapplication")
manageERR()
; initializing pointer on the form in the frame
$Form=_IEFormGetObjByName($FrameButtonLogout,"LogoutForm",0)
manageERR()
; initializing pointer on the button in the form in the frame
$ButtonLogout=_IEFormElementGetObjByName($Form,"LOGOUT")
manageERR()
; click on the button to confirm the logout
$ButtonLogout.click 
manageERR()
; submit the form
_IEFormSubmit($Form)
manageERR()
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then

	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	Exit
	
EndIf
; END STEP 8
;=================================================================================================================================================================================
; BEGIN STEP 9 : Exit browser and display duration
; waiting for complete loading of the page
$timerBeginTimeout=_NowCalc()
_IELoadWait($IE_BO5US)
manageERR()
; initializing the variable $endRefresh
$endLogon = _NowCalc()
; calculate the difference between the startLogon and the endLogon
$deltaLogon =_DateDiff("s", $startLogon, $endLogon)
; kill Internet Explorer process properly
_IEQuit($IE_BO5US)
manageERR()
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then
	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	Exit
EndIf
; END STEP 9
;=================================================================================================================================================================================
; BEGIN STEP 10 : Save datas in a file before dumping them in the database
$timerBeginTimeout=_NowCalc()
WriteDataFile($startLogon, $endLogon, $deltaLogon, $startRefresh, $endRefresh, $deltaRefresh, getStatus(True), $country, $place, @IPAddress1, $report, $application)
manageERR()
$timerEndTimeout=_NowCalc()
if ((calcTimeout($timerBeginTimeout,$timerEndTimeout,$timeout))==True) Then
	WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
	_IEQuit($IE_BO5US)
	Exit
EndIf
; END STEP 10
;=================================================================================================================================================================================

; END SCRIPT
;=================================================================================================================================================================================
; Script Functions
Func getStatus($bool)
	
	if ($bool==True) then
		
		Return 1
		
	Else
		
		Return 0
		
	EndIf
	
EndFunc

Func calcTimeout($t1,$t2,$timeout)

$dd=_DateDiff("s", $t1, $t2)

	if($dd>=$timeout) Then
	
		Return True
		
	Else
		
		return False
		
	EndIf

EndFunc

Func manageERR()
	
	If @error==1 Then
		$startLogon= _NowCalc()
		$timeout= "500"
		$country="ERROR"
		$place="ERROR"
		$report="ERROR"
		$application="BO5-US"
		WriteDataFile($startLogon, $startLogon, $timeout, $startLogon, $startLogon, $timeout, getStatus(False), $country, $place, @IPAddress1, $report, $application)
		Exit
	EndIf

EndFunc