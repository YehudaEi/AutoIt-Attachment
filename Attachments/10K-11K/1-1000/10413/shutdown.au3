;************************************ Fichier d'include *********************************************
#include <GUIConstants.au3>

;*******************************  definition des variables  *****************************************
;~ $titre1 = " liste des serveur a rebooter "
;~ $champ01= " toto "
;*******************************  definition des variables  *****************************************

$source = "d:\Documents and Settings\PRCA12751\Mes documents\autoIT\server.txt"
$INI = "d:\Documents and Settings\PRCA12751\Mes documents\autoIT\projet shutdown\shutdown.ini"
$Domaine = ""
$Compte = ""
$PassWord =""
$radio_1=""
$radio_2=""
$path = "d:\Documents and Settings\PRCA12751\Mes documents\autoIT\projet shutdown"
$var = ""

;********************************* Creation de l'interface utilisateur *********************************

GUICreate(" Interface Homme Reboot ", 500,400, @DesktopWidth/2-160, @DesktopHeight/2-45, -1, 0x00000018); WS_EX_ACCEPTFILES

$btn = GUICtrlCreateButton ("Sortie", 20, 370, 60, 20)
$rbt = GUICtrlCreateButton ("reboot", 120, 370, 60, 20)
$maj = GUICtrlCreateButton ("Mise a jour" , 300, 370, 60, 20)
$maj_ini = GUICtrlCreateButton (" INI " , 380, 370, 60, 20)

$01 = GUICtrlCreateInput ( $source,   110,   50, 300, 20)
GUICtrlSetState(-1,$GUI_ACCEPTFILES)
$02 = GUICtrlCreateInput ( $Compte,   110,   90, 300, 20)
$03 = GUICtrlCreateInput ( $Domaine,  110,  130, 300, 20)   
$04 = GUICtrlCreateInput ( $PassWord, 110,  170, 300, 20,$ES_PASSWORD )   ; champ password

GUICtrlCreateGroup ("Option",8, 195, 90, 90)
$radio1 = GUICtrlCreateRadio ("redemarer", 10, 210, 80, 20)
GUICtrlSetState ($radio1,$GUI_CHECKED)
$radio2 = GUICtrlCreateRadio ("arreter ", 10, 250, 50, 20)
GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group


$edit = GUICtrlCreateButton ("edit", 420, 50, 60, 20)

 
GUICtrlCreateLabel ("liste des  machines ",  10, 50, 100)	
GUICtrlCreateLabel ("Compte admin ",  10, 90, 100)	
GUICtrlCreateLabel ("Domaine",  10, 130, 100)	
GUICtrlCreateLabel ("Mots de passe ",  10, 170, 100)	

;~ ****************************************************************************************************

GUICtrlCreateLabel ("groupe disponible",  110, 200, 100)	

$mylist_groupe=GUICtrlCreateList ("", 290,220,140,140)

$var_groupe = IniReadSectionNames($path & "\shutdown.ini")

If @error Then 
    MsgBox(4096, "", "Error occured, probably no INI file.")
Else
    For $j = 1 To $var_groupe[0]
		
		$list_data = GUICtrlSetData($mylist_groupe,$var_groupe[$j],$var_groupe[1])
		
    Next
EndIf

;~ ****************************************************************************************************

GUICtrlCreateLabel ("serveur rebooter", 290, 200, 100) 	

$mylist=GUICtrlCreateList ("", 110,220,140,140)

$serveur_rebooter = $var_groupe[$list_data]

$var = IniReadSection($path & "\shutdown.ini", $serveur_rebooter)
If @error Then 
    MsgBox(4096, "", "Error occured, probably no INI file.")
Else
    For $i = 1 To $var[0][0]
		GUICtrlSetData($mylist,$var[$i][1])
    Next
EndIf

;~ ********************************************************************************************************

GUISetState ()

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
       $msg = GUIGetMsg()
       Select
		            Case $msg = $btn
               exitloop
					Case $msg = $rbt
						lecture()
						reboot($source,$Compte,$Domaine,$PassWord)
					Case $msg = $edit
						lecture()
						$commande= "notepad.exe " & $source
						Run( $commande )
						
					Case $msg = $maj_ini
						lecture()
						$commande= "notepad.exe " & $INI
						Run( $commande )
					case $msg = $maj
												
						$liste = GUICtrlRead ( $mylist_groupe )
						
					$var = IniReadSection($INI, $liste)
						If @error Then 
						MsgBox(4096, "", "Error occured, probably no INI file.")
					Else
;~ 						$var = $var[0][0]
						For $i = 1 To $var[0][0]
						GUICtrlSetData($mylist,$var[$i][1])
					Next
;~ 						EndIf
						GUISetState ()
						EndIf

	
		EndSelect
Wend
      
 
;****************************************************************************************************
;*	                                                                                                *
;*   Fonction d'edition du fichier source                                                           *
;*                                                                                                  *
;****************************************************************************************************
 
Func edit()
	
	
EndFunc

;===============================================================================
;
; Description:      Rlecture de l'interface graphique  
; Syntax:           lecture()
; Parameter(s):     
;                   
; Requirement(s):   None
; Return Value(s):  
;                   
; Author(s):        Raphael COMA (raph@el-coma.com
; Note(s):          
;
;===============================================================================

Func lecture()
	$source  	= GUICtrlRead ($01)
	$Compte	    = GUICtrlRead ($02)
	$Domaine	= GUICtrlRead ($03)
	$PassWord	= GUICtrlRead ($04)
	$radio_1 	= GUICtrlRead ($radio1)
	$radio_2 	= GUICtrlRead ($radio2)
	
	
EndFunc
;===============================================================================
;
; Description:      reboot de serveur  
; Syntax:           reboot(ByRef $_source,ByRef $_Compte, ByRef $_Domaine,ByRef $_PassWord)
; Parameter(s):     $_source, fichier liste des machines a rebooter
;					$_Compte, Compte utilisateur avec droit admin
;					$_Domaine, Domaine du compte
;					$_PassWord, Mots de passe du compe
;                   
; Requirement(s):   None
; Return Value(s):  
;                   
; Author(s):        Raphael COMA (raph@el-coma.com
; Note(s):          
;
;===============================================================================
;****************************************************************************************************
;*	                                                                                                *
;*   Fonction de reboot de serveur                                                                  *
;*                                                                                                  *
;****************************************************************************************************
Func reboot(ByRef $_source,ByRef $_Compte, ByRef $_Domaine,ByRef $_PassWord)
	
	
$file = FileOpen($_source, 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

;~ fichier de log
$Log = FileOpen("Log.txt", 1)

; Check if file opened for reading OK
If $Log = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

; Read in lines of text until the EOF is reached
While 1
	
	$line = FileReadLine($file)
    If @error = -1 Then ExitLoop
	
	RunAsSet($_Compte , $_Domaine , $_PassWord, 0 )
	

If $radio_1 = $GUI_CHECKED Then
	$commande= "shutdown.exe -r -f -m \\" & $line & " -t 5"
	Run( $commande, @SW_HIDE  )
	
ElseIf $radio_2 = $GUI_CHECKED Then
	$commande= "shutdown.exe -s -f -m \\" & $line & " -t 5"
	Run( $commande , @SW_HIDE  )
EndIf
	
FileWriteLine($log,$line &  " commande reboot lancer " & @HOUR &"h" & @Min & "Min" & @SEC  )
;~ FileWriteLine($log, $commande)
;~ FileWriteLine($log," " & $source & " " & $Compte & " " & $Domaine & " " & $PassWord  )

RunAsSet()
	
	
Wend

FileClose($file)
FileClose($log)
	
EndFunc


