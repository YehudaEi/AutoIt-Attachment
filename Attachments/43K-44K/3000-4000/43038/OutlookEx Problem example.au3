
#include <GUIConstantsEx.au3>
#include <ListviewConstants.au3>
#include <GUIListBox.au3>
#include <GuiListView.au3>
#include <StaticConstants.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <OutlookEX.au3>
#include <GuiEdit.au3>
#include <Constants.au3>
#include <Array.au3>

Global $TrayTooltip, $DOSSIER_Outlook, $Nombredejours, $OptionNotifTempsReel, $date, $hListView = -9999, $hZoneDeTexte = -9999, $hGUI = -9999, $LabCas = 0, $LabOuvrirMail = 0

Global $oMyError = ObjEvent("AutoIt.Error", "_ErrorHTTP"); Interception des erreurs autoit !!
Global $oOutlook, $oOApp = ObjCreate("Outlook.Application")
Global $test = ObjEvent($oOApp, "oOApp_")
Global $listofmail, $listofmailInbox ;

While 1
 Listes_mails()
 Exit
	Sleep(100)
WEnd


Func Listes_mails()
	ConsoleWrite("Listes_mails() " & @crlf )
	Local $Folder
	Local $oOutlook = _OL_Open()
	$Folder = _OL_FolderAccess($oOutlook, "", $olFolderInbox)

	; THIS REQUEST IS OK:
	$listofmailInbox = _OL_ItemFind($oOutlook, $Folder[1], $olMail, "[ReceivedTime]>'2013-12-26 10:00' And [ReceivedTime]<'2014-01-07 16:59'", "", "", "ConversationTopic,SenderName,CreationTime,Body,EntryID", "CreationTime,True", 1)
	ConsoleWrite("Size of array: Ubound($listofmailInbox):" & UBound($listofmailInbox) & "||" & UBound($listofmailInbox,2) & @crlf )

;~ 	_ArrayDisplay($listofmailInbox)   ; Uncomment to display result.
;~ 	msgbox(1,"","Just to make a pause between requests")

	$listofmailInbox = ''; reset array
	; THIS NEXT REQUEST IS NOT OK, ONLY FIRST DATE CHANGE. FROM '2013-12-26 10:00' to '2014-01-02 10:00'
	ConsoleWrite("!! Next request !!" & @CRLF)
	$listofmailInbox = _OL_ItemFind($oOutlook, $Folder[1], $olMail, "[ReceivedTime]>'2014-01-02 10:00' And [ReceivedTime]<'2014-01-07 16:59'", "", "", "ConversationTopic,SenderName,CreationTime,Body,EntryID", "CreationTime,True", 1)
	ConsoleWrite("Size of array: Ubound($listofmailInbox):" & UBound($listofmailInbox) & "||" & UBound($listofmailInbox,2)& @crlf)
;~ 	_ArrayDisplay($listofmailInbox)   ; Uncomment to display result.
	_OL_Close($oOutlook)
EndFunc   ;==>Listes_mails


