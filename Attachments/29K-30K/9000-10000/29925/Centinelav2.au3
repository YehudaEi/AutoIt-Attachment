#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=D:\binoculars.ico
#AutoIt3Wrapper_Res_LegalCopyright=Juan Miguel Gonzalez
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Date.au3>
#include 'CommMG.au3'
#Include <String.au3>
#include <ListboxConstants.au3>
#include <Constants.au3>
#NoTrayIcon

$envio = False
$check = False
$conteo = 0
Global $sNumberToDial , $ncentro , $sms =""

$comando1 = "AT"
$comando2 = "AT+CGMI"  ;fabricante
$comando3 = "AT+CGMM" ; modelo
$comando4 = "AT+CGMR"  ; version soft
$comando5 = "AT+CSQ" ; calidad de señal
$comando6 = "AT+CMGF=1"  ; compatible con SMS
$comando7 = "AT+CSCA=" &  chr(34) & $ncentro & chr(34) ; Centro de SMS
$comando8 = "AT+CMGW=" & chr(34) & $sNumberToDial & Chr(34) ; guarda el mensaje
$comando9 = "AT+CMSS=0" ; Envia el mensaje
$comando10 = "AT+CMGD=1,4" ; borrar mensajes
dim $FromModem
dim  $COMdisp , $orden , $compatible, $temp , $num1 , $num2 , $num3 , $num4, $num5 , $port, $operadorseleccionado
$tiempoping = 5000

GUICreate("Centinela", 535, 500)

$progressbar = GUICtrlCreateProgress( 95 , 360 , 125 , 20)
$configbutton= GUICtrlCreateButton( "Configuracion", 20 ,430)


$eventos = GUICtrlCreateList("" , 120 , 400, 380 , 90 , $WS_VSCROLL  )
GUICtrlSetLimit($eventos, 10)
GUISetState()

$tempname = @MDAY & "_" & @mon & "_" & @Year & "_errorlog.txt" ; save errors to log

Global $IP[15] = ["172.16.0.2", "172.16.0.3", "172.16.0.4", "172.16.0.5", "172.16.0.6", "172.16.0.7", "172.16.0.8", "172.16.0.9", "172.16.0.10", "172.16.0.11", "172.16.0.12", "172.16.0.13", "172.16.0.14", "172.16.0.15" , "172.16.0.16"]
Global $nombres[15] = ["Canaveral" , "Jardines del Rocio fase 1" , "Jardines del Rocio fase 3" , "Arqueta esquina edf Juan Carlos I" , "Plazamar" , "Torres de Colon" , "La noria", "Duque de Ahumada" , "Barraca de Poniente" , "Pueblo Rocio" , "Noria nueva" , "Bazar San Juan" , "Pje Edif Trinidad" , "Los Alaches", "El Mirador chalets"]
Global $box[15], $label[15] , $errors[15]



For $n = 0 To 14
    $box[$n] = GUICtrlCreateCheckbox($IP[$n], 50, 30 + 20 * $n, 120, 20)
    $label[$n] = GUICtrlCreateLabel("   --", 180, 30 + 20 * $n, 50)
Next
GUICtrlCreateLabel( "Log:" , 375 , 29)
$boton1 = GUICtrlCreateButton("Iniciar", 234, 270)
$boton2 = GUICtrlCreateButton("Detener", 230, 300)
$boton3 = GUICtrlCreateButton("Limpiar", 455, 335)

$c = GUICtrlCreateGraphic( 40 , 20 , 250, 320 )

GUICtrlsetstate($progressbar , $GUI_HIDE)
    GUICtrlSetColor(-1, 0)
	$list = GUICtrlCreateList("" , 300 , 50, 200 , 280  )

GUICTrlSetData ($eventos, "                                          == Centinela ==")
GUICTrlSetData ($eventos, "                     por Juan Miguel Gonzalez. Marzo/2010")
GUICTrlSetData ($eventos, "  ")


If not Fileexists("Centinela.ini") Then
Config()
Else
GUICTrlSetData ($eventos, "Archivo INI de configuracion cargado.    " & @Hour & ":" & @MIN & ":" & @SEC)
EndIf

Cargarconfig()
prueba()

Global $count = 0;
While 1



	For $i = 1 to 100

	$msg = GUIGetMsg()

    If $msg = $GUI_EVENT_CLOSE Then Exit

    If $msg = $configbutton Then
	GUICTrlSetData ($eventos, "")

	Config()

	GUICTrlSetData ($eventos, "Archivo INI de configuracion guardado.    " & @Hour & ":" & @MIN & ":" & @SEC)
	Cargarconfig()
	prueba()
	Endif
	If $msg = $boton3 Then GUICtrlSetData($list, "")

    If $msg = $boton1 Then
		GUICtrlsetstate($progressbar , $GUI_SHOW)
		GUICtrlsetstate($configbutton , $GUI_DISABLE)
		$stopped = False


    For $n = 0 To 14
    GUICtrlSetState($box[$n], $GUI_DISABLE)
    Next
        If $stopped = False Then
        pin()
		AdlibRegister("pin", 20000)
        Endif
    ElseIf $msg = $boton2 Then
		GUICtrlsetstate($progressbar , $GUI_HIDE)
		GUICtrlsetstate($configbutton , $GUI_ENABLE)

    $stopped = True


    For $n = 0 To 14
    GUICtrlSetState($box[$n], $GUI_ENABLE)
    Next
EndIf


Next

If $envio = True and $compatible = True Then
	GUICtrlSetData( $eventos , "Se intentara enviar SMS de alerta a las " & @Hour & ":" & @MIN & ":" & @SEC)

		leeINIyenvia()
          $envio = False
		  $sms = ""

        Endif

WEnd

Func pin()

If $stopped = false then
	If GUICtrlRead($box[$count]) = 1 Then

      $pin = Ping($IP[$count])
	  If $pin <> 0 Then
		  GUICtrlSetData($list, @Hour & ":" & @MIN & ":" & @SEC & "        " & $IP[$count] & "        " & $pin & " ms") ; print in the list time,IP and ping
	      $errors[$count] = 0

      Endif

	If $pin = @error Or $pin = 0 Then ; cant do ping
         GUICtrlSetData($label[$count], "ERROR")
	     Beep(500, 150)
		 GUICtrlSetData($list, @Hour & ":" & @MIN & ":" & @SEC & "        " & $IP[$count] & "        ERROR") ; print in the list time, IP and ERROR
		 $errors[$count] += 1 ; increase counter
	     Filewrite( $tempname , @Hour & ":" & @MIN & ":" & @SEC & " | " & $IP[$count] & @CRLF) ; write error to the log

		If $errors[$count] = 3  Then ; on 3 errors
			Beep(700, 250)
			Sleep(200)
			Beep(700, 250)
			Sleep(200)
			Beep(700, 250)
			GUICtrlSetdata($eventos , "Detectados 3 errores consecutivos en " & $IP[$count] & " a las " & @Hour & ":" & @MIN & ":" & @SEC)
			Filewrite( $tempname , @Hour & ":" & @MIN & ":" & @SEC & " | " & "3 CONSECUTIVOS EN " & $IP[$count]  & @CRLF) ; write alarm!

		Endif
			If $errors[$count] = 3 And @HOUR > 8 Then ; on 3 errors
			 $sms =  $sms & $nombres[$count] & ", "


			 $errors[$count] = 0
            Endif


	    Else
         GUICtrlSetData($label[$count], $pin & " ms")
        EndIf
    EndIf

    $count += 1
	GUICtrlsetdata($progressbar , $count * 6.66)
    If $count > 14 Then
	 $count = 0
	 If not $sms = "" Then
		 $temp = $conteo
		Switch $temp

			Case 1 to 12
		          $conteo +=  1
			 Case  13
				  $envio = True
				  $conteo = 1
	        Case  0
			      $envio = True
	              $conteo +=  1

         EndSwitch
	       if $sms = "" Then
		    $conteo = 0
		    $envio = False
           Endif
	 Endif
	Endif
Endif
EndFunc ;==>pin



Func Config()
	$Configuracion = GUICreate("Configuracion" , 350 , 300)
	GUISetState()
	GUICtrlCreateLabel("Puerto de conexion del modem:", 60 , 30)
	$COMdisp = GUICtrlCreateCombo("", 220, 25 ,60, 20)
	$portlist = _CommListPorts(0);find the available COM ports and write them into the ports combo
    If @error = 1 Then
        MsgBox(0, 'Error', 'Problema detectando puertos')
        Exit
    EndIf


    For $pl = 1 To $portlist[0]
        GUICtrlSetData($COMdisp, $portlist[$pl]);_CommListPorts())
    Next
    GUICtrlSetData($COMdisp, "COM1" & $port);show the first port found

	$Guardar = GUICtrlCreateButton( "Guardar" , 250 , 250)
	$op = GUICtrlCreateCombo($operadorseleccionado, 210, 70, 70 , 25)
	GUICtrlCreatelabel("Operador del modem GSM:" , 70 ,75)

	GUICtrlSetData( $op , "Movistar")
    GUICtrlSetData( $op , "Vodafone")
	GUICtrlSetData( $op , "Orange")
	GUICtrlSetData( $op , "Yoigo")
	GUICtrlSetData( $op , "Simyo")


	GUICtrlCreatelabel ("Numero 1:", 40, 125 + 25 )
	$numinput1 = GUICtrlCreateInput($num1,100 , 120 + 25 , 70, 20)
	GUICtrlCreatelabel ("Numero 2:", 40, 125 + 50 )
	$numinput2 = GUICtrlCreateInput($num2,100 , 120 + 50 , 70, 20)
	GUICtrlCreatelabel ("Numero 3:", 40, 125 + 75 )
	$numinput3 = GUICtrlCreateInput($num3,100 , 120 + 75 , 70, 20)
	GUICtrlCreatelabel ("Numero 4:", 40, 125 + 100 )
	$numinput4 = GUICtrlCreateInput($num4,100 , 120 + 100 , 70, 20)
	GUICtrlCreatelabel ("Numero 5:", 40, 125 + 125 )
	$numinput5 = GUICtrlCreateInput($num5,100 , 120 + 125 , 70, 20)


	While 1

	$msg2 = Guigetmsg($Configuracion)
If $msg2 = $Guardar Then
    _FileCreate("Centinela.ini")
    $num1 = GUICtrlRead($numinput1)
	$num2 = GUICtrlRead($numinput2)
	$num3 = GUICtrlRead($numinput3)
	$num4 = GUICtrlRead($numinput4)
	$num5 = GUICtrlRead($numinput5)


	$port = StringReplace(GUICtrlRead($COMdisp), 'COM', '')
	$operadorseleccionado = GUICtrlRead($op)
	FileWriteLine("Centinela.ini" , $port)
	FileWriteLine("Centinela.ini" , $operadorseleccionado)

		If StringLen ($num1) = 9 and StringLeft($num1,1) = "6"  Then FilewriteLine("Centinela.ini" , $num1)
	    If StringLen ($num2) = 9 and StringLeft($num2,1) = "6"  Then FilewriteLine("Centinela.ini" , $num2)
		If StringLen ($num3) = 9 and StringLeft($num3,1) = "6"  Then FilewriteLine("Centinela.ini" , $num3)
		If StringLen ($num4) = 9 and StringLeft($num4,1) = "6"  Then FilewriteLine("Centinela.ini" , $num4)
		If StringLen ($num5) = 9 and StringLeft($num5,1) = "6"  Then FilewriteLine("Centinela.ini" , $num5)

    Exitloop
Endif
	Wend
	GuiDelete($Configuracion)


	EndFunc



Func enviasms()

$orden = $comando8 ;enviar sms

COM()


$orden = $comando9
COMR()
If StringInStr($FromModem, "OK") Then GUICTrlSetData ($eventos, "SMS enviado [" & @Hour & ":" & @MIN & ":" & @SEC & "]")
If StringInStr($FromModem, "ERROR") Then GUICTrlSetData ($eventos, "Error al enviar SMS")

$orden = $comando10
COMR()

EndFunc



Func prueba()

$orden = $comando1
COMR()
If $check = True Then GUICTrlSetData ($eventos, "Modem detectado en COM" & $port)
$check = False

$orden = $comando2
COMR()
$a = StringTrimleft( $FromModem, 10)
$b = StringTrimRight( $a , 8)
GUICTrlSetData ($eventos, "Detectado " & $b)

$orden = $comando4
COMR()
$a = StringTrimleft( $FromModem, 10)
$b = StringTrimRight( $a , 8)
GUICTrlSetData ($eventos, "Modelo: " & $b)

$orden = $comando3
COMR()
$a = StringTrimleft( $FromModem, 10)
$b = StringTrimRight( $a , 8)
GUICTrlSetData ($eventos, "Version: " & $b)


$orden = $comando5
COMR()
$a = StringTrimleft( $FromModem, 14)
$b = StringTrimRight( $a , 11)
GUICTrlSetData ($eventos, "Señal: " & 3.22 * $b & "%")

$orden = $comando6
COMR()
If StringInStr($FromModem, "OK") Then
GUICTrlSetData ($eventos, "Modem soporta envio de SMS")
$compatible = True
Endif
If StringInStr($FromModem, "ERROR") Then
GUICTrlSetData ($eventos, "Modem NO SOPORTA envio de SMS")
Exit
Endif


$orden = $comando10
COMR()

EndFunc

Func COM()

	;Centro mensajes
$com = ObjCreate ("MSCommLib.MSComm")
	With $com
        .CommPort = $port
        .PortOpen = True
        .Settings = "9600,N,8,1"
        .InBufferCount = 0
        .Output = "AT+CSCA=" &  chr(34) & $ncentro & chr(34) & @CR
    EndWith






	$orden = "AT+CMGW=" & chr(34) & $sNumberToDial & Chr(34)
$com = ObjCreate ("MSCommLib.MSComm")

	With $com
        .CommPort = $port
        .PortOpen = True
        .Settings = "9600,N,8,1"
        .InBufferCount = 0
        .Output = "AT+CMGW=" & chr(34) & $sNumberToDial & Chr(34) & @CR
    EndWith

    $begin = TimerInit()
   While 1
        If $com.InBufferCount Then
            $FromModem = $FromModem & $com.Input;
            If StringInStr($FromModem, "OK") Then
			 $Check = True
			 ExitLoop
			Elseif StringInStr($FromModem, "ERROR " )Then
			 ExitLoop
Endif
        EndIf
WEnd



$com = ObjCreate ("MSCommLib.MSComm")

	With $com
        .CommPort = $port
        .PortOpen = True
        .Settings = "9600,N,8,1"
        .InBufferCount = 0
        .Output = $sms & Chr(26)
    EndWith

EndFunc


Func COMR()


$FromModem=""
    $com = ObjCreate ("MSCommLib.MSComm")

    With $com
        .CommPort = $port
        .PortOpen = True
        .Settings = "9600,N,8,1"
        .InBufferCount = 0
        .Output = $orden & @CR
    EndWith

    $begin = TimerInit()
   While 1
        If $com.InBufferCount Then
            $FromModem = $FromModem & $com.Input;
            If StringInStr($FromModem, "OK") Then
			 $Check = True
			 ExitLoop
			Elseif StringInStr($FromModem, "ERROR")Then
			 ExitLoop
Endif
        EndIf
	Wend
EndFunc

Func Cargarconfig()
$port = FileReadLine("Centinela.ini" ,1)
If $port <= 0 or $port > 99 Then
	Msgbox(4096, "Error" , "No se ha podido cargar archivo INI correctamente. El programa se cerrara.")
		Exit
	Else
		GUICtrlSetData($eventos , "Puerto seleccionado: COM" & $port)
Endif

$operadorseleccionado = FileReadLine("Centinela.ini" ,2)
Switch $operadorseleccionado
	Case "Movistar"
		$ncentro = "+34609090909"
	Case "Vodafone"
		$ncentro = "+34607003110"
	Case "Orange"
		$ncentro = "+34656000311"
	Case "Yoigo"
		$ncentro = "+34622996111"
	Case "Simyo"
		$ncentro = "+34644109030"
	Case Else
		Msgbox(4096, "Error" , "No se ha podido cargar archivo INI correctamente. El programa se cerrara.")
		Exit
EndSwitch
GUICtrlSetData($eventos , "Operador del modem GSM: " & $operadorseleccionado)



For $i = 3 to 7
		$temp = FileReadLine("Centinela.ini", $i)
		If $temp <>"" Then GUICtrlSetData($eventos , $temp & " cargado.")
	Next
EndFunc


Func leeINIyenvia()

For $i = 3 to 7
		$temp = FileReadLine("Centinela.ini", $i)
		If $temp <>"" Then
		GUICtrlSetData($eventos , "Intentando enviar SMS a " & $temp & " a las " & @Hour & ":" & @MIN & ":" & @SEC)
		$sNumberToDial = String($temp)
		$sms = "Posible averia. NO hay respuesta de " & $sms

		enviasms()
		Endif
	Next
EndFunc
