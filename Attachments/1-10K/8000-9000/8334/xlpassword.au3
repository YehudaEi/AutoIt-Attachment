;xlpassword.au3
#include"ExcelCom.au3"
global $oXLApp
$PassPath="c:\backup\password1.xls"
$OrigPath=$PassPath
$NewPath="c:\backup\book3.xls"
$OrigNew=$NewPath
$NewPath2="c:\backup\book4.xls"
$Pass1="hi"
$PassWrite="hi"
_XLReadPassword( $PassPath,$NewPath, $Pass1 , $PassWrite , 1)
_XLshow($PassPath,1)
MsgBox(0,"","You can now use $NewPath as the functioning copy; save later")
;==============================================================
;processes with $PassPath [is now actually the proxy]
;==============================================================
_XLSaveAsPassword( $PassPath,$OrigPath, $Pass1 , $PassWrite , 1)
_XLSaveAsPassword( $OrigNew,$NewPath2, $Pass1 , $PassWrite , 1)
_XLshow($OrigNew,1)
msgbox (0," visible if shown", "Proxy file still present, opens OK")
_XLshow($NewPath2,1)
msgbox (0," visible if shown", "Demo 2nd password file has password (as does orig and now changed Password file), opens OK")
if IsObj($oXLApp) then 	$oXLApp.quit
_XLexit($NewPath,0); no changes and close workboot; not  Excel
