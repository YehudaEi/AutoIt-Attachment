#cs
vi:ts=4 sw=4:
Stack functions based on SumTingWong's Stack functions:
http://www.autoitscript.com/forum/index.php?showtopic=6899&hl=

By: Ejoc
Version 1.3

Major difference is that the intial stack doesnt need to be an array,
it just needs to be declared.  There is significantly less ReDim's which
should improve code execution times, on a test I ran my code executed more
then twice as fast.

UDFs included In this file:
	_NewStack($initalSize=0)
	_PopStack(ByRef $vaStack, ByRef $vValue)
	_PushStack(ByRef $vaStack, $vValue)
	_PeekStack(ByRef $vsStack, $ByRef $vValue)
	_Pop(ByRef $vValue)
	_Push($vValue)
	_Peek(ByRef $vValue)
#ce
#include-once

Global $_Ejocs_Internal_Stack

;======================================================================
;	_NewStack($InitalSize=0)
;	InitalSize		: default 0  Using a Larger number would improve
;					  _Push execution times, A number close to the max
;					  number of elements you'll have would be ideal
;	Return			: A new Array
;	Example	$myStack = _NewStack()
;======================================================================
Func _NewStack($InitalSize=0)
	Local $array
	Dim $array[$InitalSize+1]
	$array[0]	= 0
	Return $array
EndFunc

;======================================================================
;	_PopStack
;	ByRef vaStack	: The stack
;	ByRef vValue	: The variable the stack element will be pop into
;	Return			: 1 if there was an element 0 if the stack is empty
;	Example	If _PopStack($myStack,$item) Then MsgBox(0,"",$item)
;======================================================================
Func _PopStack(ByRef $vaStack, ByRef $vValue)
	Local $iStackIndex
  
	If Not IsArray($vaStack) Or Not $vaStack[0] Then return 0
	$iStackIndex	= $vaStack[0]
	$vaStack[0]		= $iStackIndex - 1
	$vValue			= $vaStack[$iStackIndex]
	If $iStackIndex = 1 Then
		ReDim $vaStack[1]
		$vaStack[0]	= 0
	Endif
	Return 1
EndFunc

;======================================================================
;	_PushStack
;	ByRef vaStack	: The Stack
;	vValue			: The element to push onto the stack
;	Return			: none
;	Example _PushStack($myStack,"Example")
;======================================================================
Func _PushStack(ByRef $vaStack, $vValue)
	Local $iStackIndex,$iStackLen

	If Not IsArray($vaStack) Then
		Dim $vaStack[10]
		$vaStack[0]	= 0
   	Else
		$iStackLen	= UBound($vaStack)
		if ($vaStack[0] + 1) >= $iStackLen Then
			ReDim $vaStack[$iStackLen + 10]
		Endif
	EndIf

	$iStackIndex			= $vaStack[0] + 1
	$vaStack[$iStackIndex]	= $vValue
	$vaStack[0]				= $iStackIndex
EndFunc

;======================================================================
;	_PeekStack
;	ByRef vaStack	: The stack
;	ByRef vValue	: The variable the stack element will be placed into
;	Return			: 1 if there was an element 0 if the stack is empty
;	Example	If _PeakStack($myStack,$item) Then MsgBox(0,"",$item)
;======================================================================
Func _PeekStack(ByRef $vaStack, ByRef $vValue)
	Local $iStackIndex
  
	If Not IsArray($vaStack) Or Not $vaStack[0] Then return 0
	$iStackIndex	= $vaStack[0]
	$vValue			= $vaStack[$iStackIndex]
	Return 1
EndFunc

;======================================================================
;	_Pop
;	ByRef vValue	: The variable the stack element will be pop into
;	Return			: 1 if there was an element 0 if the stack is empty
;	Example	If _Pop($item) Then MsgBox(0,"",$item)
;======================================================================
Func _Pop(ByRef $vValue)
	Return _PopStack($_Ejocs_Internal_Stack,$vValue)
EndFunc

;======================================================================
;	_Push
;	vValue			: The element to push onto the stack
;	Return			: none
;	Example _Push("Example")
;======================================================================
Func _Push($vValue)
	_PushStack($_Ejocs_Internal_Stack,$vValue)
EndFunc

;======================================================================
;	_Peek
;	ByRef vValue	: The variable the stack element will be placed into
;	Return			: 1 if there was an element 0 if the stack is empty
;	Example	If _Peak($item) Then MsgBox(0,"",$item)
;======================================================================
Func _Peek(ByRef $vValue)
	Return _PeekStack($_Ejocs_Internal_Stack,$vValue)
EndFunc
