; _GetSubnetMask()
; 
; Author: RìggníX
;                           
; 
; 	$return = subnet mask
; 

Func GetSubnetMask()
	$cmd = Run("ipconfig",@WorkingDir,@SW_HIDE,2)
	$ipconfigvar = StdOutRead($cmd)
	
	$subnetstart = StringInStr($ipconfigvar, ". : 255.")
	$subnetend = StringInStr($ipconfigvar, @CR, 0, 5)
	$subnetlenght = $subnetend - $subnetstart
	$subnetmask1 = StringMid($ipconfigvar, $subnetstart + 4, 15)
	$subnetmask = StringStripCR($subnetmask1)
	
	Return $subnetmask
EndFunc