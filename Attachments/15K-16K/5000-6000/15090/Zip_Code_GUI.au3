#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <IE.au3>
#Region ### START Koda GUI section ###
$ZIPCodeGUI = GUICreate("ZIP Code Lookup", 473, 360, -1, -1)
$lblTitle = GUICtrlCreateLabel("ZIP Code Lookup", 137, 5, 206, 33, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
$lblRequired = GUICtrlCreateLabel("* Required Field", 70, 55, 79, 17)
$lblAddr1 = GUICtrlCreateLabel("* Address 1", 70, 78, 58, 17, $SS_RIGHT)
$inpAddr1 = GUICtrlCreateInput("", 131, 75, 284, 21)
GUICtrlSetLimit($inpAddr1, 50)
$lblAddr2 = GUICtrlCreateLabel("Address 2", 77, 102, 51, 17, $SS_RIGHT)
$inpAddr2 = GUICtrlCreateInput("", 131, 100, 84, 21)
$lblCity = GUICtrlCreateLabel("* City", 100, 127, 28, 17, $SS_RIGHT)
$inpCity = GUICtrlCreateInput("", 131, 125, 284, 21)
GUICtrlSetLimit($inpCity, 50)
$lblState = GUICtrlCreateLabel("* State", 92, 152, 36, 17, $SS_RIGHT)
$cboState = GUICtrlCreateCombo("", 131, 150, 42, 25)
GUICtrlSetData(-1, "AL|AK|AS|AZ|AR|CA|CO|CT|DE|DC|FM|FL|GA|GU|HI|ID|IL|IN|IA|KS|KY|LA|ME|MH|MD|MA|MI|MN|MS|MO|MT|NE|NV|NH|NJ|NM|NY|NC|ND|MP|OH|OK|OR|PW|PA|PR|RI|SC|SD|TN|TX|UT|VT|VI|VA|WA|WV|WI|WY|AE|AA|AE|AP")
$lblZip5 = GUICtrlCreateLabel("ZIP Code", 79, 177, 49, 17, $SS_RIGHT)
$inpZIP5 = GUICtrlCreateInput("", 131, 175, 79, 21)
GUICtrlSetLimit($inpZIP5, 10)
$btnSubmit = GUICtrlCreateButton("Submit", 131, 202, 70, 17, 0)
$lvResults = GUICtrlCreateListView("Address 1|Address 2|City, State|ZIP Code", 5, 232, 460, 121)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
      Case $GUI_EVENT_CLOSE
         Exit
      Case $btnSubmit
         Search()
   EndSwitch
WEnd
Func Search()
   SplashTextOn("ZIP Code Lookup", "SEARCHING...", 300, 200)
   _GUICtrlListViewDeleteAllItems($lvResults) ;Clear ListView
   $oIE = _IECreate("http://www.usps.com/zip4", 0, 0) ;Open USPS website in IE
   $oForm = _IEGetObjByName($oIE, "form1") ;Get form object
   $sAddr1 = GUICtrlRead($inpAddr1) ;Get Address 1 string
   $oAddr1 = _IEFormElementGetObjByName($oForm, "address2") ;Get Address 1 input object
   _IEFormElementSetValue($oAddr1, $sAddr1) ;Set Address 1 input value
   $sAddr2 = GUICtrlRead($inpAddr2) ;Get Address 2 string
   $oAddr2 = _IEFormElementGetObjByName($oForm, "address1") ;Get Address 2 input object
   _IEFormElementSetValue($oAddr2, $sAddr2) ;Set Address 2 input value
   $sCity = GUICtrlRead($inpCity) ;Get City string
   $oCity = _IEFormElementGetObjByName($oForm, "city") ;Get City input object
   _IEFormElementSetValue($oCity, $sCity) ;Set City input value
   $sState = GUICtrlRead($cboState) ;Get State string
   $oState = _IEFormElementGetObjByName($oForm, "state") ;Get State input object
   _IEFormElementSetValue($oState, $sState) ;Set State input value
   $sZIP5 = GUICtrlRead($inpZIP5) ;Get ZIP Code string
   $oZIP5 = _IEFormElementGetObjByName($oForm, "zip5") ;Get ZIP Code input object
   _IEFormElementSetValue($oZIP5, $sZIP5) ;Set ZIP Code input value
   _IEFormSubmit($oForm) ;Submit form
   $oTable = _IETableGetCollection($oIE, 0) ;Get first table
   $aTable = _IETableWriteToArray($oTable) ;Write table to array
   Select
      Case StringInStr($aTable[0][0], "Full Address") ;Full address found
         Sleep(1)
      Case StringInStr($aTable[0][0], "NON-DELIVERABLE") ;Non-Deliverable address found
         SplashOff()
         MsgBox(0, "ZIP Code Lookup", "Address is Non-Deliverable!")
      Case StringInStr($aTable[0][0], "entries") ;Multiple entries found
         _IELinkClickByText($oIE, "Show All") ;Click "Show All" link
         $oTable = _IETableGetCollection($oIE, 1) ;Get second table
         $aTable = _IETableWriteToArray($oTable) ;Write table to array
      Case Else
         SplashOff()
         MsgBox(0, "ZIP Code Lookup", "Address Not Found!")
   EndSelect
   _IEQuit($oIE) ;Close IE
   SplashOff()
   For $i = 1 To UBound($aTable, 2) - 2 Step 2 ;Every other row is blank in the table
      $aSplit = StringSplit($aTable[0][$i], @CR) ;Split Address lines and City/State
      For $j = 1 To UBound($aSplit) - 1
         $aSplit[$j] = StringReplace($aSplit[$j], @LF, "") ;Remove linefeed characters
         $aSplit[$j] = StringStripWS($aSplit[$j], 3) ;Remove linefeed characters
      Next
      If StringRegExp($aSplit[UBound($aSplit) - 1], "\w?[0-9]{5}", 0) Then ;Look for ZIP code in City/State field
         ReDim $aSplit[UBound($aSplit) + 1] ;Add one to array
         $aSplit[UBound($aSplit) - 1] = StringRight($aSplit[UBound($aSplit) - 2], 11) ;Set last array to zip only
         $aSplit[UBound($aSplit) - 2] = StringLeft($aSplit[UBound($aSplit) - 2], StringLen($aSplit[UBound($aSplit) - 2]) - 11) ;Set second to last array to City/State
         If UBound($aSplit) - 1 = 3 Then ;Perform action if Address 2 field is populated
            $sList = $aSplit[1] & "||" & $aSplit[2] & "|" & $aSplit[3] ;Address 1| |City,State|ZIP
         Else
            $sList = $aSplit[1] & "||" & $aSplit[2] & $aTable[1][$i] ;Address 1| |City,State|ZIP
         EndIf
      Else
         If UBound($aSplit) - 1 = 3 Then ;Perform action if Address 2 field is populated
            $sList = $aSplit[1] & "|" & $aSplit[2] & "|" & $aSplit[3] & "|" & $aTable[1][$i] ;Address 1|Address 2|City,State|ZIP
         Else
            $sList = $aSplit[1] & "||" & $aSplit[2] & "|" & $aTable[1][$i] ;Address 1| |City,State|ZIP
         EndIf
      EndIf
      GUICtrlCreateListViewItem($sList, $lvResults)
      _GUICtrlListViewSetColumnWidth($lvResults, 0, $LVSCW_AUTOSIZE)
      _GUICtrlListViewSetColumnWidth($lvResults, 1, $LVSCW_AUTOSIZE)
      _GUICtrlListViewSetColumnWidth($lvResults, 2, $LVSCW_AUTOSIZE)
   Next
EndFunc   ;==>Search