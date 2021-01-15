#include <Array.au3>
#include <Constants.au3>
#include <string.au3>
#include <IE.au3>

Dim $Nopub[1]

Global $verIE, $Lang, $WinFin, $oIE

$f_tryAttach = 0
$fvisible = 1
$fwait = 0

;;; Prepare URL search for spacenet server
;;; String TI=hair is looking for patents having word hair in tittle 

$EspaUrl="http://v3.espacenet.com/results?sf=a&FIRST=1&CY=es&LG=es&DB=EPODOC&TI=hair&AB=&PN=&AP=&PR=&PD=&PA=&IN=&EC=&IC=&=&=&=&=&="

$oIE = _IECreate ( $EspaUrl,$f_tryAttach,$fvisible,$fwait)

_IELoadWait ($oIE)

;;; Waiting for search results ....
Do
	$ret = WinWait ("esp@cenet vista de resultados - " & $WinFin,"",5)
	If Not __IEIsObjType($oIE, "browser") Then
		_IEQuit ($oIE)
		MsgBox(4128,"Error Condition","Unable navigation")
		Exit
	EndIf
Until $ret = 1

;;WinSetState("esp@cenet vista de resultados - " & $WinFin, "", @SW_HIDE)

_IEAction ($oIE,"invisible")

_IELoadWait ($oIE)

$prox = 1

;;; Begin loop main

While $prox

	$urlactual = _IEPropertyGet($oIE,"locationurl")
	
	$oLinks = _IELinkGetCollection ($oIE)
			
	If @error Then
		;;; Abnormal Condition.
		MsgBox(4128,"Error Condition","Unable navigation")
		Exit
	Else
		$iNumLinks = @extended
	EndIf
	
	$sgte = 0
	$enpag = 0
	
	;;; Loop for each page. It is checking links on page

	For $oLink In $oLinks
		
		$patron = StringMid ($oLink.href,1,35)
		
		;;; Is there any link for patents details ?  
		If  $patron = "http://v3.espacenet.com/textdoc?DB=" Then
				$Ndoc = StringMid ($oLink.href,36,100) ; Ej:   EPODOC&IDX=US2007081968&F=0
				$arr = StringSplit ($Ndoc,"&")   ; =>  arr[2] = IDX=US2007081968
				$Ndoc = StringMid ($arr[2],5,99)
				
				If _ArraySearch($Nopub,$Ndoc) = -1 Then
				;; MAIN Process ....
					_ArrayAdd($Nopub,$Ndoc)
					$enpag += 1
				Else
					;; Record was proccessed previously
				EndIf
		Else 
			;;; Checking for next page link on html page.
			;;; This is identify for link having tittle value equal to "alt-2" 
			If Not $sgte And Not $enpag Then
				$patron =  StringMid ($oLink.title,1,5)
				;;; the tittle's link is equal "alt-2" ???
				If $patron = "alt-2" Then
					;;; Get the link for next page in order to going on
					$sgte = $oLink.href
				EndIf
			EndIf
		EndIf
	Next
	;;; End loop for each page.
	;;;
	
	If $sgte Then 
		;;; Is there next page to process ?
		Nav_Sgte($sgte)
	Else
		ExitLoop   ;;; Exit from main loop.
	EndIf

WEnd
;;; End Main loop

_IEQuit ($oIE) ; Cierra instancia del Internet Explorer

Func Nav_Sgte($sgte)
	Global $Abort, $oIE, $WinFin

		;;; The next navigation event steal focus from any other activate windows
		;;; even when visible property for IE windows is set to off. 

		_IENavigate ($oIE,$sgte)
			
		If  @error Then
			MsgBox(4128,"Error Condition","Unable navigation")
			Exit
		EndIf
	
	Return 1
	
EndFunc

Func OnAutoItStart()
 Global $verIE, $Lang, $WinFin
 
; Busqueda por titulo de ventana exacto.
AutoItSetOption("WinTitleMatchMode", 3)

$verIE = StringMid(RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer", "Version"),1,1)

If $verIE = 6 Then
	$WinFin = "Microsoft Internet Explorer"
ElseIf 7 Then
	$WinFin = "Windows Internet Explorer"
Else
	$msg = "Internet Explorer version is unknown" 
	MsgBox(4128,"Condicion Erronea",$msg)
	Exit
EndIf

; Need to be sure there is not any IE windows having espacenet results...

$handle = WinGetHandle("esp@cenet vista de resultados - " & $WinFin)

If $handle <> "" Then
	$msg = "Unable to start program. There is an espacenet results window yet " 
	MsgBox(4128,"Condicion Erronea",$msg)
	Exit
EndIf

;;; Checking for language, spanish or english..
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

EndFunc
