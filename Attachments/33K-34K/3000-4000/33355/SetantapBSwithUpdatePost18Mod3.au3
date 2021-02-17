; MAIN: Open Setanta Website and Save Each Javascript Generated EPG File for TVxB to Process
;
; This script is to download a series of webpages for a TV EPG, that can processed by TVxB, a "scraper" which uses wget. 
; The TV EPG site to scrape uses Javascript, so the wget doesn't work. This script:
; 1. Loads                                              which loads today's EPG.
; 2. Save that web page to a local dir in the format TVxb-Setanta.hk-20110215.html so that TVxB can parse it.
; 3. Clicks the NEXT date which uses Javascript in the form javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay','') to load the next days page.
; 4. Saves that web page to a local dir in the fromat TVxb-Setanta.hk-20110216.html, Web Page, HTML Only so that TVxB can parse it.
; 5. Repeat
; 
; You can use the InetGet or the InetRead function in .au3 to download files from websites, but need Javascript so need to open page instead.
;
#include <Date.au3>
#include <IE.au3>
$savedate = _NowCalcDate()
$odates = _NowCalcDate()
$WebTitle="NOT Internet Explorer"
;$savedate = StringLeft(_DateAdd( 'h',8, _NowCalc()),10); Adds 8 hours to GMT to get HK Current Time
; Only needed if offset in posted times but Setantas Says HK Time ???
;
_IEErrorHandlerRegister() 
ConsoleWrite("Debug: Main Routine Setanta Window" & @LF)
;
; With these two lines you can see it working **
$oIE = _IECreate()
_IENavigate($oIE,"                                            "); _IE that navigates to the first page and waits until "done". ; Opens Setanta Website ...
;
; ** Alternatively with just these two lines it will work silently without opening IE Window
;$oIE = _IECreate("                                            ",0,0); Open WebPage (Was just $oIE = _IECreate())
;_IELoadWait($oIE); _IE  loads page and waits until REALLY "DONE" to avoid "The Requested Resource Is in Use" Error Messages ...
; NOTE: Several IE.au3 functions call _IELoadWait() automatically (e.g. _IECreate(), _IENavigate() etc.). 
;
$hIE = _IEPropertyGet($oIE, "hwnd"); get the 'handle' (hwnd) for the IE window opened.
;
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl01$btnDay','')",0); Invoke Javascript command to get this days' program
SaveTVxBhtml() ; Call Save Subroutine, to save it and then Move onto the next day using Javascript command; Save it; etc etc
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl03$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl04$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl05$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl06$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$btnNextWeek','')",0)	; This line Takes you to the NEXT Week
; Then go all through the buttons again
Sleep(3000)
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl00$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl01$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay','')",0)
SaveTVxBhtml() 
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl03$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl04$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl05$btnDay','')",0)
SaveTVxBhtml()
_IENavigate($oIE,"javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl06$btnDay','')",0)
SaveTVxBhtml()
;
; Finally, close the Webpages
;
WinActivate($hIE)
WinWaitActive($hIE)
;
_IEQuit ($oIE)
;
Func SaveTVxBhtml()
GetDateofCurrentlyLoadedPage()
_IEErrorHandlerRegister() 
ConsoleWrite("Debug: SaveTVxBhtml Routine" & @LF)
sleep(3000)
$sHTML = _IEDocReadHTML($oIE)
filewrite("C:\Users\Kristian\Desktop\SetantaCache\TVxb-setanta.hk-" & stringreplace($savedate,"/","") & ".htm",$sHTML)
ConsoleWrite("SaveDate=" & $savedate & @CRLF)
$savedate = _DateAdd("d",1,$savedate)
sleep(2000)
EndFunc
;
Func GetDateofCurrentlyLoadedPage() ; Doesn't seem to work as when source is viewed 'class="selected"' always seems to default to todays date.
ConsoleWrite("Debug: GetDateofCurrentlyLoadedPage Routine" & @LF)
sleep(3000)
$sHTML = _IEdocReadHTML ($oIE)
$html = StringSplit($sHTML, @CRLF)
for $line in $html
 if Stringinstr($line, 'class="selected"',0,1) then
  $odates = StringRight( StringTrimRight($line, 13), 3)
  msgbox(0,"", $odates)
  exitloop
 endif
NEXT
;ConsoleWrite("DateCurrPage=" & $odates & @CRLF)
EndFunc