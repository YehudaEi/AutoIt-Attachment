#include <GuiConstants.au3>
#include <Date.au3>

#include <Array.au3>
#include <Constants.au3>
#include <string.au3>
#include <IE.au3>
#Include <GuiStatusBar.au3>
#include <GuiListView.au3>

#include <A3LMenu.au3>
#include <A3LTreeView.au3>

Global $foo, $Total = 0, $enTotal = 0, $Phijo1, $Debug = 0, $exititem, $Abort=0, $ActLog=1
Local $opLimite = 0 , $TomAn = 5

Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[3] = [110, 435, -1]
Local $a_PartsText[3] = ["", "", ""]

AutoItSetOption("WinTitleMatchMode", 3)
; Busqueda por titulo de ventana exacto.

;;;; Opt("OnExitFunc", "endscript")
;;;;

Global $verIE, $Lang

TraySetToolTip("Modulo de Busquedas")
TraySetState()	; Show the tray icon
;;;

$PVEZ=1

TCPStartUp()
$modo_eje = 0
$f_tryAttach = 0
$fvisible = 1
;;$fvisible = 1
$fwait = 0
$fmtsal = "Blink"
;;;;
;;;;
;   Fin del proceso de busqueda
;;;;
;;;; $ret = MAIN_ESPACENET("new", $opLimite , $TomAn, "espacenet")
;;;Func MAIN_ESPACENET($accion, $opLimite, $Ciclo, $server)

Dim $Nopub[1]
Dim $PDAN[1]

Global $criterio, $verIE, $Lang

If $verIE = 6 Then
	$WinFin = "Microsoft Internet Explorer"
Else
	$WinFin = "Windows Internet Explorer"
EndIf

Global $oIE

$f_tryAttach = 0

$fvisible = 0
$fwait = 0

;; Variable for error proccess
$MAXREINT=10

$EspaUrl="http://v3.espacenet.com/results?sf=a&FIRST=1&CY=es&LG=es&DB=EPODOC&TI=hair&AB=&PN=&AP=&PR=&PD=&PA=&IN=&EC=&IC=&=&=&=&=&="

$oIE = _IECreate ( $EspaUrl,$f_tryAttach,$fvisible,$fwait)

_IELoadWait ($oIE)

Do
	$ret = WinWait ("esp@cenet vista de resultados - " & $WinFin,"",5)
	If Not __IEIsObjType($oIE, "browser") Then
		_IEQuit ($oIE)
		MsgBox(4128,"Error Condition","Unable navigation")
		Exit
	EndIf
Until $ret = 1

WinSetState("esp@cenet vista de resultados - " & $WinFin, "", @SW_HIDE)

;;$WinAct = "Modulo de Busquedas en Internet"

_IEAction ($oIE,"invisible")

;;WinActivate($WinAct)

_IELoadWait ($oIE)

$oResultado = _IETagNameGetCollection ($oIE, "strong",0)
If $oResultado.innerTEXT = "LISTA DE RESULTADOS" Then
	$oResultado = _IETagNameGetCollection ($oIE, "strong",1)
	$Estimado = $oResultado.innerTEXT
	;;MsgBox(0,"","resultado = " & $Estimado)
EndIf

$prox = 1

$VcookPGS = 30

While $prox

	;;;VentanActiva()

	$veces=1

	$urlactual = _IEPropertyGet($oIE,"locationurl")
	
	While $veces < $MAXREINT		

		$oLinks = _IELinkGetCollection ($oIE)
	
		$errNAV = @error
			
		If $errNAV Then
			;;; Abnormal Condition.
			MsgBox(4128,"Error Condition","Unable navigation")
			Exit
		Else
			$iNumLinks = @extended
			ExitLoop
		EndIf
	WEnd
	
	$anterior = ""
	$sgte = 0
	$enpag = 0
	
	For $oLink In $oLinks
		
		If $enpag = 30 Then  ;; Reach max number of records for each page
			ExitLoop
		EndIf

		$patron = StringMid ($oLink.href,1,35)

		If  $patron = "http://v3.espacenet.com/textdoc?DB=" Then
			If $oLink.href = $anterior Then
				$Ndoc = StringMid ($oLink.href,36,100) ; Ej:   EPODOC&IDX=US2007081968&F=0
				$arr = StringSplit ($Ndoc,"&")   ; =>  arr[2] = IDX=US2007081968
				$Ndoc = StringMid ($arr[2],5,99)
				
				If _ArraySearch($Nopub,$Ndoc) = -1 Then
				;; MAIN Process ....
					_ArrayAdd($Nopub,$Ndoc)
				Else
					;; Record was proccessed previously
				EndIf
				$enpag += 1
			Else
				$anterior = $oLink.href
			EndIf
		Else ; Check for next page
			If Not $sgte And Not $enpag Then
				$patron =  StringMid ($oLink.title,1,5)
				If $patron = "alt-2" Then
					$sgte = $oLink.href
				EndIf
			EndIf
		EndIf
	Next
	
	If $sgte Then 
		
		If Not Nav_Sgte($sgte) Then
			ExitLoop 2	
		EndIf
		;; _IELoadWait ($oIE)
		$prox = 1
	EndIf

WEnd

_IEQuit ($oIE) ; Cierra instancia del Internet Explorer


;;;
; Fin de rutina MAIN_ESPACENET
;;;

;;; EndFunc


Func Nav_Sgte($sgte)
	Global $foo, $Abort, $oIE, $WinFin
	
	;; Variante con cantidad de reitentos posibles en caso de Error en la navegacion
		$veces=1
		
		$MAXREINT = 10
		
		While $veces < $MAXREINT 
						
			;; $VentanActiva = WinGetTitle("")
			
			_IENavigate ($oIE,$sgte)
			
			;;If $VentanActiva = "esp@cenet vista de resultados - " & $WinFin Or _ 
			;;  $VentanActiva = "esp@cenet Visualizar documento - " & $WinFin Then
			;;	VentanActiva()
				
			;;Else
				;;WinActivate($VentanActiva)
			;; EndIf
			
			$errNAV = @error
			
			If Not $errNAV Then 
				ExitLoop
			Else 
				;; Error condition process
				
				$veces += 1
				
				Sleep($veces * 5000)
				
			EndIf
		WEnd
		
		If $veces = $MAXREINT Then
			MsgBox(4128,"Error Condition","Unable navigation")
			Exit
		EndIf

	_IELoadWait ($oIE)
	
	Return 1
	
EndFunc

Func OnAutoItStart()
 Global $verIE, $Lang
 
; Busqueda por titulo de ventana exacto.
AutoItSetOption("WinTitleMatchMode", 3)

$verIE = StringMid(RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer", "Version"),1,1)

If $verIE = 6 Then
	$WinFin = "Microsoft Internet Explorer"
ElseIf 7 Then
	$WinFin = "Windows Internet Explorer"
Else
	$msg = "Version de Internet Explorer no reconocida" 
	MsgBox(4128,"Condicion Erronea",$msg)
	Exit
EndIf

; Chequea que no exista una pagina con resultados de busqueda...

$handle = WinGetHandle("esp@cenet vista de resultados - " & $WinFin)

If $handle <> "" Then
	$msg = "Antes de comenzar es necesario cerrar ventana con resultados de busqueda anterior" 
	MsgBox(4128,"Condicion Erronea",$msg)
	Exit
EndIf

; Lista los procesos MuestraFormulario.exe para ver si esta aplicacion esta ya en ejecucion
;$list = ProcessList("MuestraFormular")
$list = ProcessList("BusPa.exe")
$list1 = ProcessList("BusPa_New.exe")
If $list[0][0] > 1 Or $list1[0][0] > 1 Then
	$msg = "Imposible ejecutar aplicacion por segunda vez" 
	MsgBox(4128,"Condicion Erronea",$msg)
	Exit
EndIf

Select
	Case StringInStr("040a,080a,0c0a,100a,140a,180a,1c0a,200a,240a,280a,2c0a,300a,340a,380a,3c0a,400a,440a,480a,4c0a,500a", @OSLang)
		$Lang = "esp"
	Case StringInStr("0409,0809,0c09,1009,1409,1809,1c09,2009,2409,2809,2c09,3009,3409", @OSLang)
        $Lang = "eng"
    Case Else
        $msg = "Imposible ejecutar aplicacion por idioma utilizado en el equipo" 
		MsgBox(4128,"Condicion Erronea",$msg)
		Exit
EndSelect

ProcessSetPriority ("Modulo de Busquedas en Internet",4)

EndFunc

Func VentanActiva()
	$aWinList = WinList()
	For $i = 1 to $aWinList[0][0]
	; Only display visble windows that have a title
		;If $aWinList[$i][0] <> "" AND BitAnd( WinGetState($aWinList[$i][1]), 2 ) Then
		;;El sigte es mejor porque ignora las ventanas que roban el top en Z-Order de Windows
		;; Como el administrador de tareas (Ctrl-Alt-Del), AutoIt info, etc 	
		If $aWinList[$i][0] <> '' And BitAND(WinGetState($aWinList[$i][0]), 2) Then
			;;If $aWinList[$i][0] <> "Program Manager" And _

		If  $aWinList[$i][0] <> "Administrador de Tareas de Windows" And $aWinList[$i][0] <> "Windows Task Manager" Then
				WinActivate($aWinList[$i][1])
				;;_API_SetFocus($aWinList[$i][1])
				Return $aWinList[$i][0]
				; Retorna focus a ventana que lo tenia
			EndIf
		EndIf
	Next
EndFunc

