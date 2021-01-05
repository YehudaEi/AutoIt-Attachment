$Timer = TimerInit()
$sString = "Encrypting 1 Encrypting 2 Encrypting 3 Encrypting 4 Encrypting 5"
$arString = StringSplit ( $sString, "" )

;===============================================================================
; Encrypting        														
;===============================================================================
Local $sTemp = "", $iASCII = 0, $i = 0

For $i = 1 to $arString[0]
	$iPadding = 9
	
	If Mod($i, 2) = 1 Then $iPadding = 3
	
	$iASCII = ASC ( $arString[$i] ) + $iPadding
    
    $sTemp = Chr( $iASCII ) & $sTemp
Next

$sString = $sTemp

MsgBox("","Encrypted", $sString & @LF & StringLen ( $sString ) & " characters in " & Round(TimerDiff ( $Timer )) & " ms")

;===============================================================================
; Decrypting     														
;===============================================================================
Local $sTemp = "", $iASCII = 0, $i = 0, $Timer = 0

$Timer = TimerInit()

$arString = StringSplit ( $sString, "" )
$ModOffset = Mod ( StringLen( $sString ), 2 ) 

For $i = $arString[0] to 1 Step -1
	$iPadding = 9
	
	If Mod($i, 2) = $ModOffset Then $iPadding = 3
		
    $iASCII = ASC ( $arString[$i] ) - $iPadding
    
    $sTemp = $sTemp & Chr( $iASCII )
Next

MsgBox("","Decrypted", $sTemp & @LF & StringLen ( $sString ) & " characters in " & Round(TimerDiff ( $Timer )) & " ms")