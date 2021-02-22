;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Ce scenario a été generé automatiquement par le generateur version 3.0
;Mis à jour le 04/07/2011 par Malossane Timothée
;Propriétaire du présent programme: PSIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Region START NE PAS TOUCHER
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                          NE PAS TOUCHER CI DESSOUS                                           ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
$start = StringSplit(@ScriptName, ".")
Global $nom = $start[1] ;Mettre ici le nom de l'appli, c'est a dire le nom de CE fichier (ou encore le nom du .ini qui doit etre le même que le nom de ce fichier
Global $_FF_COM_TRACE = FALSE

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "FF.au3"
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <IE.au3>
#include <Misc.au3>
#include <String.au3>
#include <Constants.au3>
Opt("WinTitleMatchMode", -1) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
Opt("TrayIconDebug", 1)

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                Declaration des Variables                        ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
Global $texte = '', $oIE, $t, $erreur_de_simulation = 0,$temps,$code,$erreur_sql = "",$file,$erreur_ie = 0,$cerbereID = '';necessaires
Global $temps_total = 0, $deja_connect = 0, $object,$contremesure1 = 0,$ErrorOutputOld = "";necessaires
Local $i = 1

If $log Then
	$file = FileOpen(@ScriptDir & "\" & $nom & ".log", 1)
	_log( @CRLF & @CRLF & @CRLF & _
			"///////////////////////////////////////////////////////////////////////////" & _
			@CRLF & @MDAY & "/" & @MON & "/" & @YEAR & "  " & @HOUR & ':' & @MIN & ':' & @SEC & "-----Debut De La Session " & _
			@CRLF & "///////////////////////////////////////////////////////////////////////////" & @CRLF)
EndIf

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                Demarrage de l'application                       ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
_new_FF()
_demarrage()
For $i = 1 to $nombre_verifs
	Call("_action"&$i)
Next
;_fin()

#EndRegion STOP NE PAS TOUCHER
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                          FIN NE PAS TOUCHER CI DESSOUS                                       ;
;                   Vous pouvez maintenant modifier les actions ci-dessous                     ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;

#Region ACTIONS
Func _action1()
	$t = TimerInit()
	;-----------------
	;actions
	_FFLoadWait()
	_FFOpenURL(Eval('adresse1'))
	_FFLoadWait()
	;-----------------
	_verif(1)
EndFunc   ;==>_action1

Func _action2()
	;MsgBox(0,"","Debut Action 2")
	$t = TimerInit()
	;-----------------
	;actions
	_FFLoadWait()
	Sleep(200)
	$sInput = _FFObjGet("login", "name")
	$sInput2 = _FFObjGet("password", "name")
	Sleep(200)
	_FFObj($sInput, "value", 'login')
	_FFObj($sInput2, "value", 'password')
	Sleep(200)
	_FFFormSubmit()
	_FFLoadWait()
	;-----------------
	_verif(2)
EndFunc   ;==>_action2

Func _action3()
	;MsgBox(0,"","Debut Action 3")
	$t = TimerInit()
	;-----------------
	;actions
	Sleep(2000)
	;WinActivate("Tableau de bord")
	_FFWindowSelect("TableauDeBord","href")
	Sleep(1000)
	_FFLoadWait()
	Sleep(2000)
	_FFLoadWait()
	;-----------------
	_verif(3)
EndFunc   ;==>_action3

Func _action4()
	_FFLoadWait()
	Sleep(1000)
	;-----------------
	;actions
	_FFClick("x-btn-text", "class", 5) ; Dosn't WORK !
	Sleep(1000)
	_FFClick("x-btn-text", "class", 51) ; Dosn't WORK !
	$t = TimerInit()
	Sleep(100)
	_FFLoadWait()
	_verif(4)
EndFunc   ;==>_action3

#EndRegion ACTIONS
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                                       Fonctions                                              ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;

Func _verif($code);Fonction qui vérifie à chaque étape si tout s'est bien passé
	$load_wait = _FFLoadWait(0, $TimeOut * 1000) ; ICI on attend que Internet charge la page, avec le timeout
	Switch $code
		Case 1;Si Action 1, on fait ca
			If Round(TimerDiff($t) * 0.001, 2) > $TimeOut Then ; Si au bout de $TimeOut secondes le temps devient supérieur,
				$texte = Execute($erreur0) & @CRLF
				$erreur_de_simulation = 1
			EndIf ; On sort de la boucle infinie
			While 1 ; Boucle pseudo infinie
				$temps = Round(TimerDiff($t) * 0.001, 2);On calcule le temps ecoulé
				Sleep(10); On repose un peu le processeur
				If $erreur_ie <> 0 Then
					$texte = 'Erreur ' & $erreur_ie & ' à l ouverture de la page ' & $code & '. Programme arreté au bout de ' & $temps & ' secondes.' & @CRLF
					$erreur_de_simulation = 1
					ExitLoop ; On sort de la boucle infinie
				ElseIf (StringInStr(_FFReadHTML(), _array("testP1", 1))) Then
					;MsgBox(0,"","Mot clef trouve"&_array("testP1", 1))
					$texte = Execute($erreur2) & @CRLF
					ExitLoop ; On sort de la boucle infinie
				ElseIf $temps > $TimeOut Then ; Si au bout de $TimeOut secondes le temps devient supérieur,
					$texte = Execute($erreur5) & @CRLF
					$erreur_de_simulation = 1
					ExitLoop ; On sort de la boucle infinie
				EndIf
			WEnd
		Case 2;Si Action 2, on fait ca
			If Round(TimerDiff($t) * 0.001, 2) > $TimeOut Then ; Si au bout de $TimeOut secondes le temps devient supérieur,
				$texte = Execute($erreur0) & @CRLF
				$erreur_de_simulation = 1
			EndIf ; On sort de la boucle infinie
			While 1 ; Boucle pseudo infinie
				$temps = Round(TimerDiff($t) * 0.001, 2);On calcule le temps ecoulé
				Sleep(10); On repose un peu le processeur
				If $erreur_ie <> 0 Then
					$texte = 'Erreur ' & $erreur_ie & ' à l ouverture de la page ' & $code & '. Programme arreté au bout de ' & $temps & ' secondes.' & @CRLF
					$erreur_de_simulation = 1
					ExitLoop ; On sort de la boucle infinie
				ElseIf StringInStr(_FFReadText(14), _array("testP2", 1)) Then
					$texte = Execute($erreur2) & @CRLF
					ExitLoop ; On sort de la boucle infinie
				ElseIf $temps > $TimeOut Then ; Si au bout de $TimeOut secondes le temps devient supérieur,
					$texte = Execute($erreur5) & @CRLF
					$erreur_de_simulation = 1
					ExitLoop ; On sort de la boucle infinie
				EndIf
			WEnd

		Case 3;Si Action 3, on fait ca
			If Round(TimerDiff($t) * 0.001, 2) > $TimeOut Then ; Si au bout de $TimeOut secondes le temps devient supérieur,
				$texte = Execute($erreur0) & @CRLF
				$erreur_de_simulation = 1
			EndIf ; On sort de la boucle infinie
			While 1 ; Boucle pseudo infinie
				$temps = Round(TimerDiff($t) * 0.001, 2);On calcule le temps ecoulé
				Sleep(500); On repose un peu le processeur
				If $erreur_ie <> 0 Then
					$texte = 'Erreur ' & $erreur_ie & ' à l ouverture de la page ' & $code & '. Programme arreté au bout de ' & $temps & ' secondes.' & @CRLF
					$erreur_de_simulation = 1
					ExitLoop ; On sort de la boucle infinie
				ElseIf StringInStr(_FFReadText(14), _array("testP3", 1)) Then
					$texte = Execute($erreur2) & @CRLF
					ExitLoop ; On sort de la boucle infinie
				ElseIf StringInStr(_FFReadText(14), "Agent déjà connecté") Then
					Send("{enter}")
					_FFLoadWait()
					Sleep(300)
					_FFOpenURL("http://.../Deconnexion.jsp")
					$texte = Execute($erreur3) & @CRLF
					$erreur_de_simulation = 1
					ExitLoop ; On sort de la boucle infinie
				ElseIf $temps > $TimeOut*2 Then ; Si au bout de $TimeOut secondes le temps devient supérieur,
					$texte = Execute($erreur5) & @CRLF
					$erreur_de_simulation = 1
					ExitLoop ; On sort de la boucle infinie
				EndIf
			WEnd

		Case 4;Si Action 4, on fait ca
			If Round(TimerDiff($t) * 0.001, 2) > $TimeOut Then ; Si au bout de $TimeOut secondes le temps devient supérieur,
				$texte = Execute($erreur0) & @CRLF
				$erreur_de_simulation = 1
			EndIf ; On sort de la boucle infinie
			While 1 ; Boucle pseudo infinie
				$temps = Round(TimerDiff($t) * 0.001, 2);On calcule le temps ecoulé
				Sleep(10); On repose un peu le processeur
				If $erreur_ie <> 0 Then
					$texte = 'Erreur ' & $erreur_ie & ' à l ouverture de la page ' & $code & '. Programme arreté au bout de ' & $temps & ' secondes.' & @CRLF
					$erreur_de_simulation = 1
					ExitLoop ; On sort de la boucle infinie
				ElseIf (StringInStr(_FFReadHTML(), _array("testP4", 1))) Then
					$texte = Execute($erreur2) & @CRLF
					ExitLoop ; On sort de la boucle infinie
				ElseIf $temps > $TimeOut Then ; Si au bout de $TimeOut secondes le temps devient supérieur,
					$texte = Execute($erreur5) & @CRLF
					$erreur_de_simulation = 1
					ExitLoop ; On sort de la boucle infinie
				EndIf
			WEnd
	EndSwitch

	If $erreur_de_simulation = 1 Then ; SI pour n'importe quelle action, on a une erreur de simulation,  alors...
		;...
		If $log Then _log( $texte)

		If $contremesure AND Not $contremesure1 Then
			;...
		Else
			If $requete Then _sql() ; On lance la fonction qui gere la requete de sortie
			_Quitter()
		EndIf
	Else ; SI il n'y a pas eu d'erreur de simulation pendant l'action, alors
		If $log Then _log($texte)
		$temps_total += $temps ; On additione le temps pour à la fin posseder le temps total
	EndIf

	Return 0
EndFunc   ;==>_verif

#Region START NE PAS TOUCHER
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
;                              NE PAS TOUCHER CI-DESSOUS                                       ;
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&;
Func _sql() ; On cherche toutes les infos necessaires, puis on envoie la requete
	;Send Results
EndFunc   ;==>_sql
Func _demarrage()
	If _FFIsConnected() Then
		_FFAction("Fullscreen", TRUE);On met en plein ecran
		_FFAction("PM", TRUE);On met en plein ecran
	Else
		$texte = "Erreur à l'ouverture de Firefox"
		If $log Then
			_log( $texte)
		EndIf
		_Quitter()
	EndIf
	Sleep(1000)
EndFunc   ;==>_demarrage
Func _fin()
	;...
	If $requete then _sql() ; Si on veut inserer la requete, alors on lance la fonction
	_Quitter()
EndFunc
Func _log($texte)
	If Int(FileGetSize(@ScriptDir & "\" & $nom & ".log") / 1024) >= 1000 Then
		$f_texte = FileRead(@ScriptDir & "\" & $nom & ".log")
		$f_o = FileOpen(@ScriptDir & "\" & $nom & ".log", 2)
		$f_new_texte = StringMid($f_texte,Int(StringLen($f_texte) / 2))
		FileWrite($f_o, $f_new_texte)
		FileClose($f_o)
	EndIf
	ConsoleWrite($texte)
	FileWrite($file,$texte)
EndFunc
Func  _SmtpMail($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject , $as_Body, $s_AttachFiles, $s_CcAddress, $s_BccAddress, $s_Username, $s_Password ,$IPPort, $ssl)
    $objEmail = ObjCreate("CDO.Message")
	$objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
    $objEmail.To = $s_ToAddress
    Local $i_Error = 0
    Local $i_Error_desciption = ""
    If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
    If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
    $objEmail.Subject = $s_Subject
    If StringInStr($as_Body,"<") and StringInStr($as_Body,">") Then
        $objEmail.HTMLBody = $as_Body
    Else
        $objEmail.Textbody = $as_Body & @CRLF
    EndIf
    If $s_AttachFiles <> "" Then
        Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
        For $x = 1 To $S_Files2Attach[0]
            $S_Files2Attach[$x] = _PathFull ($S_Files2Attach[$x])
            If FileExists($S_Files2Attach[$x]) Then
                $objEmail.AddAttachment ($S_Files2Attach[$x])
            Else
                $i_Error_desciption = $i_Error_desciption & @lf & 'File not found to attach: ' & $S_Files2Attach[$x]
                SetError(1)
                return 0
            EndIf
        Next
    EndIf
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $Ssl Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
    $objEmail.Configuration.Fields.Update
    $objEmail.Send
    if @error then
        SetError(2)
        return 0
    EndIf
	Return 1
EndFunc
Func MyErrFunc()
	; Important: the error object variable MUST be named $oIEErrorHandler
	$ErrorScriptline = $oIEErrorHandler.scriptline
	$ErrorNumber = $oIEErrorHandler.number
	$ErrorNumberHex = Hex($oIEErrorHandler.number, 8)
	$ErrorDescription = StringStripWS($oIEErrorHandler.description, 2)
	$ErrorWinDescription = StringStripWS($oIEErrorHandler.WinDescription, 2)
	$ErrorSource = $oIEErrorHandler.Source
	$ErrorHelpFile = $oIEErrorHandler.HelpFile
	$ErrorHelpContext = $oIEErrorHandler.HelpContext
	$ErrorLastDllError = $oIEErrorHandler.LastDllError
	$ErrorOutput = @CRLF
	$ErrorOutput &= "--> COM Error Encountered in " & @ScriptName & @CR
	$ErrorOutput &= "----> $ErrorScriptline = " & $ErrorScriptline & @CR
	$ErrorOutput &= "----> $ErrorNumberHex = " & $ErrorNumberHex & @CR
	$ErrorOutput &= "----> $ErrorNumber = " & $ErrorNumber & @CR
	$ErrorOutput &= "----> $ErrorWinDescription = " & $ErrorWinDescription & @CR
	$ErrorOutput &= "----> $ErrorDescription = " & $ErrorDescription & @CR
	$ErrorOutput &= "----> $ErrorSource = " & $ErrorSource & @CR
	$ErrorOutput &= "----> $ErrorHelpFile = " & $ErrorHelpFile & @CR
	$ErrorOutput &= "----> $ErrorHelpContext = " & $ErrorHelpContext & @CR
	$ErrorOutput &= "----> $ErrorLastDllError = " & $ErrorLastDllError
	If $log And $ErrorOutput <> $ErrorOutputOld Then
		_log($ErrorOutput)
		$ErrorOutputOld = $ErrorOutput
	EndIf
	SetError(1)
	Return
EndFunc   ;==>MyErrFunc
Func _DateFormat($func)
	Local $split,$texte = ""

	$split = StringRegExp($func,"([0-9]{1,4})",3)

If IsArray($split) And @error = 0 then $texte &= $split[2]&"-"&$split[1]&"-"&$split[0]&" "&$split[3]&":"&$split[4]&":"&$split[5]
	 Return $texte
 EndFunc
Func _array($func, $t)
	$func2 = StringSplit(Eval($func), ",")
	Return $func2[$t]
EndFunc   ;==>_array
Func _new_FF()
	_Kill_IE(1)
	_FFStart()
EndFunc
Func _Kill_IE($func = 0)
	Local $1,$2,$3,$4
	$from = @ScriptDir
	$to = @AutoItExe
	$path2 = _PathSplit(_PathFull($from & "\" & _PathGetRelative($from,$to)),$1,$2,$3,$4)
	$path = $1 &""& $2 & "process\....exe"
	If $func = 1 Then
		If FileExists($path) Then RunWait($path & " -k firefox.exe", "", @SW_HIDE)
	Else
		$t = TimerInit()
		_FFQuit()
		While ProcessExists("firefox.exe") And TimerDiff($t) <= 5000
			ProcessClose("firefox.exe")
			If FileExists($path) Then RunWait($path & " -k " & ProcessExists("firefox.exe"), "", @SW_HIDE)
		WEnd
		;...
	EndIf
EndFunc   ;==>_Kill_IE
Func _Quitter()
	If $log Then
		_log(@CRLF & @CRLF & @CRLF & _
				"///////////////////////////////////////////////////////////////////////////" & _
				@CRLF & @MDAY & @MON & @YEAR & "  " & @HOUR & ':' & @MIN & ':' & @SEC & "-----Fin de la session " & _
				@CRLF & "///////////////////////////////////////////////////////////////////////////")
	EndIf
	FileClose($file)
	_Kill_IE()
	Exit
EndFunc   ;==>_Quitter

#EndRegion


