; MAIN: Open Setanta Website and Save Each Javascript Generated EPG File for TVxB to Process
;
; This script is to download a series of webpages for a TV EPG, that can processed by TVxB, a "scraper" which uses wget. 
; The TV EPG site to scrape uses Javascript, so the wget doesn't work. This script:
; 1. Loads http://www.setanta.com/HongKong/TV-Listings/ which loads today's EPG.
; 2. Save that web page to a local dir in the format TVxb-Setanta.hk-20110215.html so that TVxB can parse it.
; 3. Clicks the NEXT date which uses Javascript in the form javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay','') to load the next days page.
; 4. Saves that web page to a local dir in the fromat TVxb-Setanta.hk-20110216.html, Web Page, HTML Only so that TVxB can parse it.
; 5. Repeat
; 
; You can use the InetGet or the InetRead function in .au3 to download files from websites, but need Javascript so need to open instead.
;
#include <Date.au3>
#include <IE.au3>

;$savedate = _NowCalcDate()
$savedate = StringLeft(_DateAdd( 'h',6, _NowCalc()),10)
;
_IEErrorHandlerRegister() 
ConsoleWrite("Debug: Main Routine Setanta Window" & @LF)
;
$oIE = _IECreate("http://www.setanta.com/HongKong/TV-Listings/",0,0); Open WebPage (Was just $oIE = _IECreate())
;
_IELoadWait($oIE); _IE  loads page and waits until REALLY "Done" to avoid "The Requested Resource Is in Use" Error Messages ...
$hIE = _IEPropertyGet($oIE, "hwnd"); get the 'handle' (hwnd) for the IE window opened.
;
SaveTVxBhtml(); Save the page by calling the Save Routine; InetGet is no good for Javascript pages as for urls only
;
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay','')",0); Return from Save routine and move onto the next day using Javascript command
SaveTVxBhtml() ; Call Save Subroutine again, to save it and then Move onto the next day using Javascript command; Save it; etc etc
;
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl03$btnDay','')",0); The ",0)" addition 
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl04$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl05$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl06$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$btnNextWeek','')",0)
;
; Finally, close the Webpages
;
; $hIE = _IEPropertyGet($oIE, "hwnd");
;
WinActivate($hIE)
WinWaitActive($hIE)
;
_IEQuit ($oIE)
;
Func SaveTVxBhtml()
;$SaveDate = @YEAR&@MON&$MDAYALT
;
_IEErrorHandlerRegister() 
;$OverWriteYes = _IEPropertyGet($oIE, "DirectUIHWND1"); get the 'handle' (DirectUIHWND1) of the IE Overwrite Dialog Window
;
WinActivate($hIE)
WinWaitActive($hIE)
ConsoleWrite("Debug: Setanta Save File Section" & @LF)
;
ControlSend($hIE, "", "", "!f") ; File (Same as Alt-F)
ControlSend($hIE, "", "", "a") ; SaveAs (A with Alt-F Open = As)
;
WinWait("Save Webpage", "", 5); Wait for the "Save Webpage" Box to Come Up; Noye that in IE6 it might read "Save Web Page"
$hSave = WinGetHandle("Save Webpage", "") ; Assign handle of the "Save Webpage" Box to a variable
WinActivate($hSave); Activate that page
;
ControlFocus($hSave, "", "Edit1"); Switch Focus to Filename within the "Save Webpage" Box Window
ControlSend($hSave, "", "[CLASS:Edit; INSTANCE:1]", "TVxb-setanta.hk-" & stringreplace($savedate,"/","-")); Input Filename
WinActivate($hSave); Activate the Save Box to be Sure
Sleep (1000); Give it a sec to ensure no keystrokes lost
ControlFocus($hSave, "", "ComboBox2"); Switch Focus to ComboBox
ControlCommand($hSave, "", "[CLASS:ComboBox; INSTANCE:2]", "SelectString", "Webpage, HTML only"); Switch Selection to Webpage, HTML ONLY in the Type Dropdown
WinActivate($hSave); Activate the Save Box AGAIN to be Sure!
ControlClick($hSave, "", "[CLASS:Button; TEXT:&Save; INSTANCE:1]"); If the Overwrite Dialog Doesn't come up, Save it anyway! 
;
If WinExists ("Confirm Save As") Then
;WinWait("Confirm Save As", "", 5); Wait for "Confirm Save As" Box to Come Up 
;$hClickYesToOverwrite = WinGetHandle("Confirm Save As", "") ; Assign handle of the Save Web page Box to a variable
;WinActivate($hClickYesToOverwrite); Activate that page
;Sleep (1000); Give it a sec to ensure no keystrokes lost
;ControlClick($hClickYesToOverwrite, "", "[CLASS:Button1; TEXT:&Yes; INSTANCE:1]"); Just Say YES ... save the beasty
Sleep(1000)
Send("!Y"); Alternative EASY Method to Click YES
;
EndIf

$savedate = _DateAdd("d",1,$savedate)
;
sleep(3000)

EndFunc