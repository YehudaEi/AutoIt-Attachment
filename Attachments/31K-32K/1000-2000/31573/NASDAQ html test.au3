#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.2.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
; *******************************************************
; NASDAQ Script to get Outstanding Shares and Institutional Ownership
; *******************************************************
;
#include <IE.au3>
#include <Array.au3>
#include <Excel.au3>
#include <File.au3>

Global $oIE
Global $oForm
Global $oInputs
Global $oTable
Global $oClick
Global $oQuery


; Create a browser window and navigate to NASDAQ.com, Institutional Holdings, with test stock symbol, AKAM
$oIE = _IECreate ("http://www.nasdaq.com/asp/holdings.asp?symbol=AKAM&selected=AKAM&FormType=Institutional")

;BELOW IS THE HTML AREA WITH THE DATA I AM INTERESTED IN (Copied from DebugBar display)
;I'm trying to retrieve the "182" (Shares Outstanding) and the "85.6%" (Institutional Ownership) by
;reading this HTML and searching out those numbers via string functions

;USING THE DebugBar ON THE WEBPAGE PULLED UP BY THIS TEST SCRIPT WILL DISPLAY HTML, INCLUDING THAT COPIED BELOW
;~ <TD class=dkbluemid colSpan=3><B>Company Details</B></TD></TR>
;~ <TR>
;~ <TD class=Holddata noWrap>Total Shares Out Standing (millions): </TD>
;~ <TD class=Holdnum>182 </TD></TR>
;~ <TR>
;~ <TD class=separatorbarsm colSpan=2><IMG src="/media/images/spacer.gif" width=1 height=1></TD></TR>
;~ <TR>
;~ <TD class=Holddata noWrap>Market Capitalization ($ millions): </TD>
;~ <TD class=Holdnum>$8,692 </TD></TR>
;~ <TR>
;~ <TD class=separatorbarsm colSpan=2><IMG src="/media/images/spacer.gif" width=1 height=1></TD></TR>
;~ <TR>
;~ <TD class=Holddata noWrap>Institutional Ownership: </TD>
;~ <TD class=Holdnum>85.6% </TD></TR>
;~ <TR>

;This does not help
;sleep (10000)

;This IFRAME has a name, but the html is not retrieved as it is shown with DebugBar! (innerhtml and innertext return as 0 by the ConsoleWrite)
$oFRAME = _IEGetObjByName ($oIE, "frmMain")
ConsoleWrite($oFRAME.tagname & @CRLF & $oFRAME.innerhtml & @CRLF & $oFRAME.innertext & @CRLF)

;This results in a no-match:
;$oHTML = _IETagNameGetCollection ($oFRAME, "HEAD",0)
;ConsoleWrite($oHTML.tagname & @CRLF & $oHTML.innerhtml & @CRLF & $oHTML.innertext & @CRLF)

;This also results in a no-match:
;$oBODY = _IETagNameGetCollection ($oFRAME, "BODY",0)
;ConsoleWrite($oBODY.tagname & @CRLF & $oBODY.innerhtml & @CRLF & $oBODY.innertext & @CRLF)



;READ THE BODY html AND WRITE TO FILE C:\html read, FOR REFERENCE
;The result does not contain the HTML code copied above that I am interested in!
;****The HTML string is written to the F: drive, filename "html save", as a text file, ON MY SYSTEM.
;I open it with Notepad, and sometimes copy and paste it into Word for easier evaluation.

$HTMLstr=_IEBodyReadHTML ($oIE)

If Not _FileCreate("F:\html save") Then
   MsgBox(4096,"Error", " Error Creating/Resetting log.      error:" & @error)
EndIf

$fileb = FileOpen("F:\html save", 1)
; Check if file opened for writing OK
If $fileb = -1 Then
     MsgBox(0, "Error", "Unable to open file.")
     Exit
 EndIf

FileWrite($fileb, $HTMLstr)
FileClose($fileb)


Exit









