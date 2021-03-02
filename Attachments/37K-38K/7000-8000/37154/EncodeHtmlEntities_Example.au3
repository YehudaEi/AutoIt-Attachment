#include "EncodeHtmlEntities.au3"

$txt="&lt;&Auml;&ouml;&uuml;&gt;"
_HtmlEntities_Decode($txt)
MsgBox(0,"Decode",$txt)
_HtmlEntities_Encode($txt)
MsgBox(0,"Encode",$txt)