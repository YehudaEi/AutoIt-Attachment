
You need a copy of dbase.exe and libraries (dbase III plus tested) 
for working with clipper,dbase IV,Xbase in general you should make some small
changes that fit the dbase.exe interpreter ENGINE.

;FUNCTION DBASEREPLA:REPLACE With
	;UPDATE OR INSERT ONE OR MANY RECORDS in

;ARGS CODE REPLACE DATABASE FIELDS FILTER 

Func dbaserepla($WBASED, $WREPLACEFIELDS, $WFORCOND, $FILE2, $SIAPPEND) ; P MOVI
   If $WREPLACEFIELDS = "" Or $WBASED = "" Then Return "params error"
   $WREPLA = StringSplit($WREPLACEFIELDS, ";")
   $WREPLA1 = ""
   $WVALUEMACROS = ""
   $WNUMYFECHA = ""
   For $ID = 1 To $WREPLA[0]
      If $WREPLA[$ID] <> "" Then
         $WVALUEMACROS = $WVALUEMACROS & 'a' & $ID & '=FIELD(' & $ID & ')«'
         $WREPLA1 = $WREPLA1 & 'Repla &a' & $ID & '. WITH "' & StringLeft($WREPLA[$ID], 240) & '" ' & $WFORCOND & '«'
		 ; this is not needed it translates for num type, and date type
         $WNUMYFECHA = $WNUMYFECHA & 'if field(' & $ID & ')="PRECIO"«REPLA PRECION WITH VAL(PRECIO)«ENDIF' & '«if field(' & $ID & ')="FECHA"«REPLA FECHAD WITH CTOD(FECHA)«ENDIF«'
      EndIf
   Next
   $WREPLA1 = StringLeft($WREPLA1, StringLen($WREPLA1) - 1)
   $WAPPEND = ""
   If $SIAPPEND = 1 Then $WAPPEND = "«APPEND BLANK"
   $WDEVUELVE = DBASE ("USE " & $WBASED & "«set alter on" & $WAPPEND & "«" & $WVALUEMACROS & $WREPLA1 & "«" & $WNUMYFECHA & "«set alter off", $FILE2)
EndFunc   ;==>dbaserepla

;example:  dbaserepla("movi", $WTITULO & ";" & @HOUR & ':' & @MIN & ';' & @MDAY & '/' & @MON & '/' & StringRight(@YEAR, 2) & ';' & $WCOMANDOS[1] & ';' & StringRight($WCOMANDO, StringLen($WCOMANDO) - 6), "", "", 1)
  
;EXAMPLE: StringStripWS(dbase($WDELSEND, ""),4) 



;EXPLAIN FUNC DBDO .. execute an external prg 

;prg file eldo
;wparam: what ever opcional params(which will be replaced and used in anyway inside of the prg)

;return what ever is PROGRAMMED TO BE RETURNED

Func DBDO($ELDO, $WPARAM)
   $WELDO = file2string($ELDO)
   $WPARAMS = StringSplit(StringStripCR($WPARAM), ";")
   For $IPAR = 1 To $WPARAMS[0] 
      $WIPAR = String($IPAR)
      If $IPAR < 10 Then $WIPAR = "0" & String($IPAR)
      $WELDO = StringReplace($WELDO, "PARAM" & $WIPAR, $WPARAMS[$IPAR])
   Next
   $WELDOS = StringSplit(StringStripCR($WELDO), @LF)
   $WDELSEND = $WELDOS[1]
   For $ISES = 2 To $WELDOS[0]
      $WDELSEND = $WDELSEND & "«" & $WELDOS[$ISES]
   Next 
   Return StringStripWS(dbase($WDELSEND, ""),4) 
EndFunc   ;==>DBDO

$whateverReturnString = dbDO ("slcobro.prg", $WTITULO & ';' & @HOUR & ':' & @MIN & ';' & @MDAY & '/' & @MON & '/' & StringRight(@YEAR, 2) & ';' & $WCOMANDOS[1] & ';' & $WCOMANDOS[2] & $WCOMANDOS[3] & $WCOMANDOS[4] & ';' & Number($WCOMANDOS[4]) & ';' & $WPIN)



;Main func: takes some code into var welsend and then execute this dbase language code, optiona file output

Func dbase($WELSEND, $WFILEOPCIONAL)
   $WFICHERO = Createnombretemp("temp", ".csv")
   $WCAB = "SET BELL OFF«SET STATUS OFF«SET SCORE OFF«SET ESCAPE OFF«SET DELE ON«"
   $WCAB = $WCAB & "SET CONFIRM OFF«set talk off«set headings off«set date italian«set echo off«"
   $FILEALT = "set alternate to " & $WFICHERO & "«"
   $FILENOALT = "«set alternate to«use«close all«CLOSE DATA««QUIT"
   If Not StringInStr($WELSEND, "set alter") Then 
      $FILEALT = $FILEALT & "set alter on«"
      $FILENOALT = "«set alter off" & $FILENOALT
   EndIf 
   If FileExists($WFICHERO) Then FileDelete($WFICHERO)
   $WPRG = $WCAB & $FILEALT & $WELSEND & $FILENOALT
   creado($WPRG, "z")
   $PID = Run("dBase.exe z", @ScriptDir)
   Sleep(1000)
   WinEspera("dBase", "", 5)
   Send("{ENTER}")
   ProcessWaitClose($PID)
   $WELBUFFER = file2string($WFICHERO)
   If $WFILEOPCIONAL <> "" Then 
      FileCopy($WFICHERO, $WFILEOPCIONAL)
      If StringStripWS($WELBUFFER, 2) = "" Then $WELBUFFER = "No se encuentran informaciÛn para esta consulta de " & $WFILEOPCIONAL
   EndIf 
   Return StringLeft($WELBUFFER, StringLen($WELBUFFER) - 1)
EndFunc   ;==>dbase

;FUNC FOR dbase which create a temp file name

Func Createnombretemp($WTEMPDIR, $PEXTENSION)
   If Not FileExists($WTEMPDIR) Then DirCreate($WTEMPDIR)
   While 1
      $PELFICHERO = String(Int(Random(100000, 999999))) & $PEXTENSION
      If Not FileExists($WTEMPDIR & "\" & $PELFICHERO) Then ExitLoop 
   Wend 
   Return $WTEMPDIR & "\" & $PELFICHERO
EndFunc   ;==>Createnombretemp


;example of a select into ayuda with filter $wfor(var) :

;$SelectReturnString = DBASE ("USE AYUDA«set alter on«LIST OFF  DESCRIP FOR " & $WFOR & "«set alter off", "ayuda")
