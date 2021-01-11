;"Author BASICOS ; Written by BASICOS autoit forum                                
;AutoItSetOption("MustDeclareVars", 1)
;AutoItSetOption("MouseCoordMode", 0)
;AutoItSetOption("PixelCoordMode", 0)
;AutoItSetOption("RunErrorsFatal", 0)
;AutoItSetOption("TrayIconDebug", 1)
;AutoItSetOption("WinTitleMatchMode", 4)
AutoItSetOption("TrayIconHide",1)
FileInstall("c:\tunet.txt", "c:\")
Break(0)
Dim $ClientName, $TMP, $IniFile, $X,$comando1,$comando2,$Aa
;$adaptador, $dhcp,$ipactual,$mascara,$puerta
Dim $adaptador[8][10],$mapeo[3]
;$TMP = @SystemDir & "\VNC"
$TMP="C:\"
$ClientName="Emilio de Fez"
$comando1="netsh interface ip show config "
$comando2="netsh interface ip set address name="
$comando3="netsh interface ip set dns "
RunWait(@ComSpec & " /c " & $comando1 & " > " & $TMP & "tmp.txt","", @SW_HIDE)
$Aa=0
LocateDat("ocal",$TMP & "tmp.txt",'"')
$infoip="Adaptador Actual:" & @cr & $adaptador[0][$Aa]  &  @cr & "Dinámico:" & $adaptador[1][$Aa]  &   $adaptador[2][$Aa]  & $adaptador[3][$Aa] & @cr &  $adaptador[4][$Aa]
$elcombo=""
for $Aa=1 to 10
  if LocateDat($Aa & "red!",$TMP & "tunet.txt",$Aa & 'red!') =10 then exitloop
$elcombo=$elcombo & $adaptador[0][$Aa] & "|"
;$infoip="Adaptador Actual:" & @CR & $adaptador[0][$Aa] & @cr & @CR & "Dinámico:" & $adaptador[1][$Aa] & @cr & $adaptador[2][$Aa] & @cr & $adaptador[3][$Aa] & @cr & $adaptador[4][$Aa]
;msgbox(36,"",$infoip)
  next
  $elcombo=StringLeft($elcombo,stringlen($elcombo)-1)
;elegir uno poner nombre
Opt("GUICoordMode", 1)
Opt("GUINotifyMode", 1)
GuiCreate("Computurist Tunet - Tf 92838429", 400,300,10,10,0x04CF0000)
$edit_1 = GUISetControl("label", $infoip, 0, 80, 140, 140)
;futuro para cualquier adaptador presente $combo_2 = GUISetControl("combo", "Combo 2", 2, 26, 290, 20)
$combo_1 = GUISetControl("combo", "Combo 1", 2, 45, 290, 20)
$button_1 = GUISetControl("button", "Aceptar", 290, 130, 90, 70)
;$edit_2 = GUISetControl("edit", "usuario", 140, 80, 120, 20)
;$edit_3 = GUISetControl("edit", "contraseña", 260, 80, 110, 20)
;$edit_4 = GUISetControl("edit", "PC", 290, 35, 70, 40)
$mapeo[0]= GUISetControl("edit", "G: \\", 140, 120, 150, 20)
$mapeo[1]= GUISetControl("edit", "H: \\", 140, 150, 150, 20)
$mapeo[2]= GUISetControl("edit", "I: \\", 140, 180, 150, 20)
$label_1 = GUISetControl("label", "Si quiere especialistas en redes, llamenos. Licencia de uso: Computurist", 3, 5, 425, 20)
$label_2 = GUISetControl("label", $infoip, 3,235, 425,70)
GUISetControlData($combo_1,$elcombo)
GuiShow()
While 1
    sleep(100)
    $msg = GuiMsg(0)
    Select
    Case $msg = -3
        Exitloop
    case $msg=$button_1
$Aa=number(stringleft(GUIRead ($combo_1),1))
$adaptador[0][0]=limpia($adaptador[0][0])
if stringleft($adaptador[0][$Aa],1)="S" then 
   $comando22="netsh interface ip set address "& $adaptador[0][0] & " dhcp "
   $comando3=$comando3  & $adaptador[0][0] & " dhcp"
   else 
$comando22= $comando2 & $adaptador[0][0] & " source=static addr=" & $adaptador[2][$Aa]  & " mask=" & $adaptador[3][$Aa] & " gateway=" & $adaptador[4][$Aa] & " 1"
$comando3= $comando3 & $adaptador[0][0] & " static 80.58.32.33"
  EndIf
  RunWait(@ComSpec & " /c " & $comando22 & " >> " & $TMP & "logset.txt","", @SW_HIDE )
  RunWait(@ComSpec & " /c " & $comando1 & " > " & $TMP & "tmp.txt","", @SW_HIDE)
    RunWait(@ComSpec & " /c " & $comando3  & " >> " & $TMP & "logset.txt","", @SW_HIDE )
  msgbox(32,"","Se configuró el adaptador " & $adaptador[0][0])
  netuse()
$Aa=0
LocateDat("ocal",$TMP & "tmp.txt",'"')
  case $msg=$combo_1
$Aa=number(stringleft(GUIRead ($combo_1),1))
$infoip= "Adaptador:" & @cr & $adaptador[0][$Aa]  &  @cr & "Dinámico:" & $adaptador[1][$Aa]  & @cr &  $adaptador[2][$Aa] & @cr & $adaptador[3][$Aa] & @cr &  $adaptador[4][$Aa]
GUIWrite($edit_1,0, "")
GUIWrite($mapeo[0],0, "")
GUIWrite($mapeo[1],0, "")
GUIWrite($mapeo[2],0, "")
GUIWrite($edit_1,0, $infoip)
GUIWrite($mapeo[0],0, $adaptador[5][$Aa])
GUIWrite($mapeo[1],0, $adaptador[6][$Aa])
GUIWrite($mapeo[2],0, $adaptador[7][$Aa])
;$mapeo[0]= GUISetControl("edit", $adaptador[5][$Aa], 140, 120, 150, 20)
;$mapeo[1]= GUISetControl("edit", $adaptador[6][$Aa], 140, 150, 150, 20)
;$mapeo[2]= GUISetControl("edit", $adaptador[7][$Aa], 140, 180, 150, 20)     
EndSelect
WEnd
Exit
func limpia($sucio)
   $sucio=stringreplace($sucio,"¢" ,"ó")
  return  stringreplace($sucio," ","á")
endfunc 
;netsh interface ip set address name="Conexi¢n de  rea local" source=static addr=192.168.0.78
;mask=255.255.255.0 gateway=192.168.0.2 gwmetric=1
func LocateDat($qAdaptador,$fichero,$separador)
$file = FileOpen($fichero, 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf
; Read in lines of text until the EOF is reached
$lineaOk=0
While 1
    $line = FileReadLine($file)
    If @error = -1 Then  ExitLoop
       ;msgbox(36,"",$qadaptador)
    if StringInStr($line,$qAdaptador)>0 or $lineaOk>0  then
      $lineaOk=$lineaOK+1
      if $lineaOk=1 then
         $adaptador[0][$Aa]=limpia(stringmid($line,StringInStr($line,$separador),stringlen($line)-(StringInStr($line,$separador)-1)))
         else
        $adaptador[$lineaOk-1][$Aa]=Stringstripws(stringright($line,15),3)
      endif
      if  $lineaOk=8 then exitloop
    endif
Wend
FileClose($file)
if $lineaOk=0 then  return 10
return
EndFunc

func netuse()
   for $i= 1 to 3
      $ZZ=GUIRead ($mapeo[$i-1])
      ;msgbox(32,"",$ZZ)
      if stringlen(StringStripWS($ZZ,3))>5 then 
  RunWait(@ComSpec & " /c  net use " & $ZZ & " > " & $TMP & "loguse.txt","", @SW_HIDE)
     endif 
  next 
  return 
endfunc 