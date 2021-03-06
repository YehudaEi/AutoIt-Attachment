#include <OutlookEX.au3>
Global $oOutlook = _OL_Open()
;===========
; Plain Text
;===========
$oItem = $oOutlook.CreateItem(0)
$oItem.BodyFormat = $olFormatPlain
$oItem.GetInspector
$sBody = $oItem.Body
$oItem.Body = "Mail Text" & $sBody
$oItem.Subject = "Subject"
$oItem.Display

;=====
; HTML
;=====
$oItem = $oOutlook.CreateItem(0)
$oItem.BodyFormat = $olFormatHTML
$oItem.GetInspector
$sBody = $oItem.HTMLBody
$oItem.HTMLBody = "<b>Mail</b> Text" & $sBody
$oItem.Subject = "Subject"
$oItem.Display

;==========
; Rich Text
;==========
$oItem = $oOutlook.CreateItem(0)
$oItem.BodyFormat = $olFormatRichText
$oItem.GetInspector
$sBody = $oItem.HTMLBody
$oItem.HTMLBody = "<b>Mail</b> Text" & $sBody
$oItem.Subject = "Subject"
$oItem.Display