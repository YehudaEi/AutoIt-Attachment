#Include <OOoCOM_UDF.au3>
#Include <File.au3>

local $FFile = @ScriptDir & "\import.xls"

local $temp_file_name = StringRegExp ($FFile,'.*\\(.*?\.[A-z]{3})',1) ; ищу (им€_файла).расширение
   ; среди заголовков типа "import.xls - OpenOffice.org Calc"
local $Our_file = $temp_file_name[0], $value

$oCurCom = _OOoCalc_Attach($Our_file)
if @error or Not IsObj($oCurCom) then _ ; если не открыт Ц открываем нужный нам док
   $oCurCom = _OOoCalc_Open($FFile)

$value = _OOoCalc_ReadCell ($oCurCom, 0, 2, 1)
MsgBox(1, "AutoIt", $value)
Exit