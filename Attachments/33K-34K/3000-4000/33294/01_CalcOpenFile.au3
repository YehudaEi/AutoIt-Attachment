#Include <OOoCOM_UDF.au3>


$a = 0 ; linha da tabela
$b = 0 ; loop



local $fn = @ScriptDir & "\teste.xls"

Dim $OpenPar[3] ; параметры открытия: потенциальные, но в реальности ещё не работают
   $OpenPar[0] = setProp("ReadOnly", True)
    $OpenPar[1] = setProp("Password", False) ;setzt das passwort des dokuments
    $OpenPar[2] = setProp("Hidden", True)
	;$OpenPar[4] = $CurCom = _OOInit(False, True, True) 
 
$oCurCom = _OOoCalc_Open($fn)
$value = _OOoCalc_ReadCell ($oCurCom, 0, 0, 0)
MsgBox(1, "AutoIt", $value)

Exit