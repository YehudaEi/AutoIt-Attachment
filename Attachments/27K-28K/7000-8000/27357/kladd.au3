#Include <Array.au3>

$regex = StringRegExp("<font color=#666666>@</font><font color=#a7b767>@@</font><font color=#123456>@</font><br><font color=#a11167>@@</font><font color=#3636a6>@@@</font><br>", '(?:(?:(?:<font color=#)([[:xdigit:]]{6})(?:>)([@]{1,})(?:</font>)){1,}(<br>)){1,}', 3)
MsgBox(0,"@Error",@Error)
_ArrayDisplay($regex, "$regex")

;~ $asResult = StringRegExp("You deflect 36 of Gnarly Monster's 279 damage.", '([0-9]{1,3})(?: damage)', 1)
;~ _ArrayDisplay($asResult, "$asResult")