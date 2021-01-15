#include-once
#include <Array.au3>
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Function that quickly searches in square or circle. Requires a dll file.
;
; ------------------------------------------------------------------------------


;===============================================================================
;
; Function Name:    _fastSearch
; Description:      Function that quickly searches in square or circle. Requires a dll file.
; Parameter(s):     $left - X cooridinate value for left edge of box to be searched
;                   $top - Y cooridinate value for top edge of box to be searched
;                   $width - width in pixels of box to be searched
;					$height - height in pixels of box to be searched
;					$color - color that we are looking for, in hex or decimal
;					$StepX (optional) - step in the x direction, default is 1
;					$StepY (optional) - step in the y direction, default is 1
;					$Radius (optional - radius of the circle to be searched, if searching a circle default is -1, meaning search a square
; Requirement(s):   fast pixel search dll.dll
; Return Value(s):  an array containing the (X, Y) for the color found, both are -1 if not found
; Author(s):        BlahBlahBlah5038 with help form Lazycat, november, and Richard Robertson
;
;===============================================================================

func _fastSearch ($left ,$top ,$width ,$height ,$color ,$StepX =1 ,$StepY = 1, $Radius = -1)
	
$storage = DllCall("fast_pixel_search_dll.dll", "int", "SearchRegion", "int", $left, "int", $top, "int", $width, "int",$height, "int", $color, "int", $StepX, "int" , $StepY, "int", $Radius)
$returnValue = $storage[0]
$test  = BitAND (98304, $returnValue)
if $test = 98304 then 
$notFound= _ArrayCreate (-1,-1)
	return $notFound
	Else
$Y = BitAND (32767,$returnValue)
$X  = BitAND (4294836224, $returnValue)
$X = ($X)/131072 
$Found= _ArrayCreate ($X,$Y)
Return $Found
EndIf
EndFunc

