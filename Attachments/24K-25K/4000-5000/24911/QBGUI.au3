;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Preprocessor ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#include <GUIConstants.au3>
#include "QuickBooksSDK.au3"

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** File Installations ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Registry Information ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Declare Variables ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Global $m_Height, $m_Width, $m_Title ;m_ = Main Window Variable
Global $sessionMan
Global $conOpen = 0, $sesOpen = 0 ;Boolean Values to check connection and session.

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Define Variables ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

$m_Height = 500
$m_Width  = 500
$m_Title  = 'Halo HOA Management'

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** GUI Creation ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;Create Main Window
$m_HWnd = GUICreate($m_Title, $m_Width, $m_Height)

;Main Window Controls
$mc_HOAListL = GUICtrlCreateLabel("Home Owners Associations", 5, 2)
$mc_HOAList  = GUICtrlCreateList("", 5, 15, ($m_Width / 2 - 10), ($m_Height / 3 - 30))
$mc_HOListL	 = GUICtrlCreateLabel("Home Owners", ($m_Width / 2), 2)
$mc_HOList   = GUICtrlCreateList("", ($m_Width / 2), 15, ($m_Width / 2 - 5), ($m_Height / 3 - 30))

;Preliminary Function Calls
_DoCustomerQueryRq()

GUISetState()

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Main Program Loop ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
WEnd

_OnExit()

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Define Functions ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Func _DoCustomerQueryRq($country = "US", $majorVersion = 1, $minorVersion = 1)
	
	$sessionMan = ObjCreate("qbFC5.QBSessionManager")
	If Not IsObj($sessionMan) Then MsgBox(0, "ERROR", "Session Management: Unable to create object.")
	
	If Not($conOpen) Then $sessionMan.OpenConnection("", $m_Title)
	If Not($sesOpen) Then $sessionMan.BeginSession("", $omDontCare)
	
	$reqMsgSet  = $sessionMan.CreateMsgSetRequest($country, $majorVersion, $minorVersion)
	
	_BuildCustomerQueryRq($reqMsgSet, $country)
EndFunc

Func _BuildCustomerQueryRq($reqMsgSet = "NOTHING", $country = "US")
	If $reqMsgSet = "NOTHING" Then Return
	
	$customerQuery = $reqMsgSet.AppendCustomerQueryRq()
	
	If $country = "US" Then
		$customerQuery.metaData.SetValue(0);$mdNoMetaData)
		$customerQuery.iterator.SetValue(0);$itStart)
		$customerQuery.iteratorID.SetValu("val")
	EndIf
	
	$orCustomerListQueryORElement1 = "ListID"
	If $orCustomerListQueryORElement1 = "ListID" Then
		$customerQuery.ORCustomerListQuery.ListIDList.Add("val")
	ElseIf $orCustomerListQueryORElement1 = "FullName" Then
		$customerQuery.ORCustomerListQuery.FullNameList.Add("val")
	ElseIf $orCustomerListQueryORElement1 = "CustomerListFilter" Then
		$customerQuery.ORCustomerListQuery.CustomerListFilter.MaxReturned.SetValue(10)
		$customerQuery.ORCustomerListQuery.CustomerListFilter.ActiveStatus.SetValue($asActiveOnly)
		$customerQuery.ORCustomerListQuery.CustomerListFilter.FromModifiedDate.SetValue("2003/12/31 09:35", 0)
		$customerQuery.ORCustomerListQuery.CustomerListFilter.ToModifiedDate.SetValue("2003/12/31 09:35", 0)
		
		;Only can set one of the OR elements.
		;We will portray this restriction by an If/Then/Else.
		$orNameFilterORElement2 = "NameFilter"
		If $orNameFilterORElement2 = "NameFilter" Then
			;Set the Value of the INameFilter.MatchCriterion element.
			$customerQuery.ORCustomerListQuery.CustomerListFilter.ORNameFilter.NameFilter.MatchCriterion.SetValue($mcStartsWith)
			;Set the Value of the INameFilter.Name element.
			$customerQuery.ORCustomerListQuery.CustomerListFilter.ORNameFilter.NameFilter.Name.SetValue("val")
		ElseIf $orNameFilterORElement2 = "NameRangeFilter" Then
			;Set the Value of the INameRangeFilter.FromName element.
			$customerQuery.ORCustomerListQuery.CustomerListFilter.ORNameFilter.NameRangeFilter.FromName.SetValue("val")
			;Set the Value of the INameRangeFilter.ToName element.
			$customerQuery.ORCustomerListQuery.CustomerListFilter.ORNameFilter.NameRangeFilter.ToName.SetValue("val")
		EndIf
		
		;Set the value of the ITotalBalanceFilter.Operator element.
		$customerQuery.ORCustomerListQuery.CustomerListFilter.TotalBalanceFilter.Operator.SetValue($oLessThan)
		;Set the value of the ITotalBalanceFilter.Amount element.
		$customerQuery.ORCustomerListQuery.CustomerListFilter.TotalBalanceFilter.Amount.SetValue(2.0)
	EndIf
	
	If $country = "US" Then
		;Set the value of the ICustomerQuery.IncludeRetElementList element.
		$customerQuery.IncludeRetElementList.Add("val")
	EndIf
	
	;Set the value of the ICustomerQuery.OwnerIDList element.
	$customerQuery.OwnerIDList.Add("{22E8C9DC-320B-450d-962A87CF7246D080}")
EndFunc

Func _OnExit()
	If $sesOpen Then
		$sessionMan.EndSession()
		$sesOpen = 0
	EndIf
	If $conOpen Then
		$sessionMan.CloseConnection()
		$conOpen = 0
	EndIf
	
	GUIDelete($m_HWnd)

	Exit
EndFunc