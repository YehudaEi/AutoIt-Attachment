#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region Header
#cs
	Title:   		eBay UDF Library for AutoIt3
	Filename:  		eBay.au3
	Description: 	A collection of functions for accessing the eBay API from AutoIT
	Author:   		seangriffin
	Version:  		V0.1
	Last Update: 	23/05/10
	Requirements: 	AutoIt3 3.2 or higher
					a valid eBay Application Key
	Changelog:		
					---------23/05/10---------- v0.1
					Initial release.
					
#ce
#EndRegion Header
#Region Global Variables and Constants
#EndRegion Global Variables and Constants
#Region Core functions
; #FUNCTION# ;===============================================================================
;
; Name...........:	_eBay_GetSingleItem()
; Description ...:	Gets publicly visible details about one listing on eBay.
; Syntax.........:	_eBay_GetSingleItem($appid, $ItemID, $IncludeSelector = "")
; Parameters ....:	$appid				- Your Application ID (AppID).
;										  Obtained by joining the eBay Developers Program.
;					$ItemID				- The item ID that uniquely identifies the item listing for which to retrieve the data.
;					$IncludeSelector	- Defines standard subsets of fields to return within the response.
;										  "" to return a default set of fields.
;										  "Details" to include the most available fields in the response.
;										  "Description" to include the Description field in the response.
;										  "TextDescription" to include the text Description(no html tag) field in the response.
;										  "ShippingCosts" to include basic shipping costs in the response.
;										  "ItemSpecifics" to include ItemSpecifics in the response.
;										  "Variations" to include Variations in the response.
;										  Use a comma to specify multiple values (in which case the results are cumulative).
; Return values .: 	On Success			- Returns a "Scripting.Dictionary" object of details for the listing. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _eBay_GetSingleItem($appid, $ItemID, $IncludeSelector = "")
	
	Local $nv_response = ObjCreate("Scripting.Dictionary")
	
	If StringLen($IncludeSelector) > 0 Then $IncludeSelector = "&IncludeSelector=" & $IncludeSelector
	
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("GET","http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=NV&appid=" & $appid & "&siteid=0&version=515" & $IncludeSelector & "&ItemID=" & $ItemID)
	$oHTTP.Send()
	$HTMLSource = $oHTTP.Responsetext 
	
	; Split the name-value pairs into seperate array items
	$arr = StringSplit($HTMLSource, "&")
;	_ArrayDisplay($arr)

	; Join incorrectly split text (ie. "&amp")
	$i = 0
	While $i < UBound($arr)
		
		$start = $i - 1
		
		While StringLen($arr[$i]) >= 4 and StringCompare(StringLeft($arr[$i], 4), "amp;") = 0
			
			$arr[$start] = $arr[$start] & "&" & $arr[$i]
			_ArrayDelete($arr, $i)
		WEnd
		
		$i = $i + 1
	WEnd
	
	_ArrayDelete($arr, 0)
	
	; for each name-value pair
	For $each in $arr
		
		$seperator_pos = StringInStr($each, "=")
		$name = StringLeft($each, $seperator_pos-1)
		$value = StringMid($each, $seperator_pos+1)
		ConsoleWrite("name:" & $name & "|val:" & $value & @CRLF)

		if StringCompare($name, "Item.TimeLeft") = 0 Then
			
			$timeleft_substr = StringRegExp($value, "[0-9]*Y", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item.TimeLeft.Years") = StringReplace($timeleft_substr[0], "Y", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*M", 1)
			if IsArray($timeleft_substr) and UBound($timeleft_substr) > 1 then $nv_response.item("Item.TimeLeft.Months") = StringReplace($timeleft_substr[0], "M", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*W", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item.TimeLeft.Weeks") = StringReplace($timeleft_substr[0], "W", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*D", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item.TimeLeft.Days") = StringReplace($timeleft_substr[0], "D", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*H", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item.TimeLeft.Hours") = StringReplace($timeleft_substr[0], "H", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*M", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item.TimeLeft.Minutes") = StringReplace($timeleft_substr[0], "M", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*S", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item.TimeLeft.Seconds") = StringReplace($timeleft_substr[0], "S", "")
		Else
				
			$nv_response.item($name) = $value
		EndIf
	Next

	Return $nv_response
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_eBay_GetItemStatus()
; Description ...:	Retrieves Item status information.
; Syntax.........:	_eBay_GetItemStatus($appid, $ItemID)
; Parameters ....:	$appid				- Your Application ID (AppID).
;										  Obtained by joining the eBay Developers Program.
;					$ItemID				- The item ID that uniquely identifies the item listing for which to retrieve the data.
; Return values .: 	On Success			- Returns a "Scripting.Dictionary" object of details for the listing. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _eBay_GetItemStatus($appid, $ItemID)
	
	Local $nv_response = ObjCreate("Scripting.Dictionary")
	
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("GET","http://open.api.ebay.com/shopping?callname=GetItemStatus&responseencoding=NV&appid=" & $appid & "&siteid=0&version=515&ItemID=" & $ItemID)
	$oHTTP.Send()
	$HTMLSource = $oHTTP.Responsetext 
	
	; Split the name-value pairs into seperate array items
	$arr = StringSplit($HTMLSource, "&")
;	_ArrayDisplay($arr)

	; Join incorrectly split text (ie. "&amp")
	$i = 0
	While $i < UBound($arr)
		
		$start = $i - 1
		
		While StringLen($arr[$i]) >= 4 and StringCompare(StringLeft($arr[$i], 4), "amp;") = 0
			
			$arr[$start] = $arr[$start] & "&" & $arr[$i]
			_ArrayDelete($arr, $i)
		WEnd
		
		$i = $i + 1
	WEnd
	
	_ArrayDelete($arr, 0)
	
	; for each name-value pair
	For $each in $arr
		
		$seperator_pos = StringInStr($each, "=")
		$name = StringLeft($each, $seperator_pos-1)
		$value = StringMid($each, $seperator_pos+1)
		ConsoleWrite("name:" & $name & "|val:" & $value & @CRLF)
		
		if StringCompare($name, "Item(0).TimeLeft") = 0 Then
			
			$timeleft_substr = StringRegExp($value, "[0-9]*Y", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item(0).TimeLeft.Years") = StringReplace($timeleft_substr[0], "Y", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*M", 1)
			if IsArray($timeleft_substr) and UBound($timeleft_substr) > 1 then $nv_response.item("Item(0).TimeLeft.Months") = StringReplace($timeleft_substr[0], "M", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*W", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item(0).TimeLeft.Weeks") = StringReplace($timeleft_substr[0], "W", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*D", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item(0).TimeLeft.Days") = StringReplace($timeleft_substr[0], "D", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*H", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item(0).TimeLeft.Hours") = StringReplace($timeleft_substr[0], "H", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*M", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item(0).TimeLeft.Minutes") = StringReplace($timeleft_substr[0], "M", "")
			$timeleft_substr = StringRegExp($value, "[0-9]*S", 1)
			if IsArray($timeleft_substr) then $nv_response.item("Item(0).TimeLeft.Seconds") = StringReplace($timeleft_substr[0], "S", "")
		Else
				
			$nv_response.item($name) = $value
		EndIf
	Next

	Return $nv_response
EndFunc
