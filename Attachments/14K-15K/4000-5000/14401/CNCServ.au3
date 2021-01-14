#cs

Concious serveris (+klientas)
Versija 0.1 BETA
concious@gmail.com

#ce


Select
	Case @Compiled
		TraySetIcon("CNCServ.exe", 161)
	Case Not @Compiled
		If FileGetSize("Ikona.ico") > 20 * 1024 Then TraySetIcon("Ikona.ico")
EndSelect

Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
TraySetToolTip("Concious serveris ir klientas" & @CRLF & "TIK NESITIKËK, KAD KAS NORS VEIKS")

#include <GUIConstants.au3>
Dim $VIPA, $VPortas
Dim $Duomenys
Dim $IvVIPA, $IvVPortas
Dim $Vykdyti
Dim $PN_VIPA = @IPAddress1, $PN_VPortas = 33891 ; Kintamøjø reikðmës pagal nutylëjimà. Esant reikalui pakeisti
Dim $GUIZinute



$Duomenys = GUICreate("Concious serveris: duomenys", 402, 111)
GUICtrlCreateLabel("Serverio tinklo sàsajos lokalus IP adresas:", 8, 8, 201, 17)
$IvVIPA = GUICtrlCreateInput($PN_VIPA, 216, 8, 129, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlCreateLabel("Portas, kurio klausytis:", 8, 40, 109, 17)
$IvVPortas = GUICtrlCreateInput($PN_VPortas, 128, 40, 73, 21, -1, $WS_EX_CLIENTEDGE)
$Vykdyti = GUICtrlCreateButton("GERAI", 104, 64, 193, 41, $BS_DEFPUSHBUTTON)
GUISetState()

While 1
	$GUIZinute = GUIGetMsg()
	If $GUIZinute <> "" Then
		$VIPA = GUICtrlRead($IvVIPA)
		$VPortas = GUICtrlRead($IvVPortas)
		Select
			Case $GUIZinute = $Vykdyti
				GUIDelete($Duomenys)
				ExitLoop
			Case $GUIZinute = $GUI_EVENT_CLOSE
				MsgBox(64, "Nurodytø duomenø nenaudosiu", "Tavo nurodyti duomenys (lokalus IP adresas: " & $VIPA & _
						", lokalus portas: " & $VPortas & ") nebus naudojami." & @CRLF & "Bus naudojami duomenys pagal nutylëjimà:" & _
						@CRLF & "         Lokalus IP adresas: " & $PN_VIPA & @CRLF & "         Lokalus portas: " & $PN_VPortas & _
						@CRLF & 'Jei norëjai naudoti savo nurodytus duomenis, reikëjo spausti "GERAI".')
				$VIPA = $PN_VIPA
				$VPortas = $PN_VPortas
				GUIDelete($Duomenys)
				ExitLoop
		EndSelect
	EndIf		
WEnd




Dim $ServLangas, $Pirmyn
Global $Ivestis, $Isvestis

$ServLangas = GUICreate("Concious serveris", 729, 544)

GUICtrlCreateLabel("Concious serveris", 200, 16, 330, 43)
GUICtrlSetFont(-1, 30, 800, 2, "Aharoni")
GUICtrlSetTip(-1, "Èia yra nevëkðliðka Concious (Kosto J.) programa: serveris + klientas")

GUICtrlCreateLabel("v0.1 BETA", 536, 32, 56, 17)
GUICtrlSetTip(-1, "Versija 0.1.0 SuperDuperBeta ExtremelyUnstable. Tûkstanèiai bug'ø")

$Isvestis = GUICtrlCreateEdit("[Serveris]: Apdoroju GUI...", 0, 64, 729, 449, $ES_READONLY + $WS_VSCROLL + $WS_HSCROLL + $WS_EX_CLIENTEDGE)
GUICtrlSetFont(-1, 6, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x008000)
$Ivestis = GUICtrlCreateInput("", 0, 520, 729, 24, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_FOCUS)
$Pirmyn = GUICtrlCreateButton("Paslëptas", 0, -50, 50, 20, $BS_DEFPUSHBUTTON)


Opt("GUIOnEventMode", 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Uzdaryti")
GUICtrlSetOnEvent($Pirmyn, "Siusti")


GUISetState()


Global $GalimuSusijSk = 2 ; Keisti pagal poreikius
Dim $GSSk2 = $GalimuSusijSk + 1
Dim $PagrSoketas
Global $AktyvusSoketas[$GSSk2]

GUICtrlSetData($Isvestis, "[Serveris]: Inicijuoju TCP sesijà..." & @CRLF & GUICtrlRead($Isvestis))




TCPStartup()
If @error Then
	MsgBox(16, "Blogai", "Nepavyko startuoti TCP serviso... :(((")
	Exit
EndIf

GUICtrlSetData($Isvestis, "[Serveris]: Pradedu klausytis " & $VIPA & ":" & $VPortas & "..." & @CRLF & GUICtrlRead($Isvestis))

$PagrSoketas = TCPListen($VIPA, $VPortas)
If @error Then
	MsgBox(16, "Blogai", "Nepavyko inicijuoti " & $VIPA & ":" & $VPortas & " klausymosi... :(((" & @CRLF & "WSA klaidos numeris: " & $PagrSoketas)
	TCPShutdown()
	Exit
EndIf

GUICtrlSetData($Isvestis, "[Serveris]: VISKAS GERAI. Operuoju normaliai... :)" & @CRLF & GUICtrlRead($Isvestis))
TrayTip("Viskas normaliai", "Ok, viskas lyg ir gerai." & @CRLF & "Klausausi " & $VIPA & ":" & $VPortas & "..." & @CRLF & "Bet dël viso pikto bûk nusiteikæs pesimistiðkai...", 10)



Dim $Sk
For $Sk = 1 To $GalimuSusijSk
	$AktyvusSoketas[$Sk] = -1
Next


Global $NIPA[$GSSk2], $NPortas[$GSSk2]
Dim $Duom[$GSSk2]
Global $PatsPrisijungiau





While 1
	For $Sk = 1 To $GalimuSusijSk
		$Duom[$Sk] = ""
		Select
			Case $AktyvusSoketas[$Sk] = -1
				$AktyvusSoketas[$Sk] = TCPAccept($PagrSoketas)
				If $AktyvusSoketas[$Sk] <> -1 Then ; Valio, turim ryðá :)
					$NIPA[$Sk] = Soketas_i_IPA($AktyvusSoketas[$Sk])
					If $PatsPrisijungiau = $NIPA[$Sk] Then ; Kà tik ágalinom duomenø gavimà ið maðinos, prie kurios patys prisijungëm.
						$PatsPrisijungiau = ""
					Else
						GUICtrlSetData($Isvestis, "[Serveris]: Prisijungë " & $NIPA[$Sk] & @CRLF & GUICtrlRead($Isvestis))
					EndIf
				EndIf
			Case $AktyvusSoketas[$Sk] <> -1
				$Duom[$Sk] = TCPRecv($AktyvusSoketas[$Sk], 1024)
				Select
				Case @error ; Basta su ðituo soketu. Nutolusi maðina nebenori bendrauti.
						TCPCloseSocket($AktyvusSoketas[$Sk])
						$AktyvusSoketas[$Sk] = -1
						GUICtrlSetData($Isvestis, "[Serveris]: Atsijungë " & $NIPA[$Sk] & @CRLF & GUICtrlRead($Isvestis))
						$NIPA[$Sk] = ""
					Case Not @error
						If $Duom[$Sk] <> "" Then ; Gavom dovanø.
							If $Duom[$Sk] = "{Kosto sisteminis} ate" Then
								TCPCloseSocket($AktyvusSoketas[$Sk])
								$AktyvusSoketas[$Sk] = -1
								GUICtrlSetData($Isvestis, "[Serveris]: " & $NIPA[$Sk] & " graþiai atsisveikino ir atsijungë" & @CRLF & GUICtrlRead($Isvestis))
								$NIPA[$Sk] = ""
							Else
								GUICtrlSetData($Isvestis, "[" & $NIPA[$Sk] & "]: " & $Duom[$Sk] & @CRLF & GUICtrlRead($Isvestis))
							EndIf
						EndIf
				EndSelect
		EndSelect
	Next
WEnd



Func Soketas_i_IPA($Soketas)
	Local $SoketoAdresas = DLLStructCreate("short; ushort; uint; char[8]")
    Local $Reiksme = DLLCall("Ws2_32.dll", "int", "getpeername", "int", $Soketas, "ptr", DLLStructGetPtr($SoketoAdresas), "int_ptr", _
			DLLStructGetSize($SoketoAdresas))
    If Not @error And $Reiksme[0] = 0 Then
        $Reiksme = DLLCall("Ws2_32.dll", "str", "inet_ntoa", "int", DLLStructGetData($SoketoAdresas, 3))
        If Not @error Then $Reiksme = $Reiksme[0]
    Else
        $Reiksme = 0
    EndIf
    $SoketoAdresas = 0
    Return $Reiksme
EndFunc



Func Uzdaryti()
	TCPShutdown()
	Exit
EndFunc



Func Siusti()
	If(WinActive("Concious serveris", "Concious serveris") And ControlGetFocus("Concious serveris", "Concious serveris") = "Edit2" And _
				GUICtrlRead($Ivestis) <> "") Then
		Local $Sk, $DuomSiunt = GUICtrlRead($Ivestis)
		GUICtrlSetData($Ivestis, "")
		Select
			Case StringLeft($DuomSiunt, 7) = "prisij "
				Local $DS2 = StringTrimLeft($DuomSiunt, 7)
				If Not StringInStr($DS2, ":") = 0 Then
					$DSDalys = StringSplit($DS2, ":")
					If $DSDalys[0] = 2 Then
						Local $_NIPA = TCPNameToIP($DSDalys[1])
						Local $_NPortas = $DSDalys[2]
						For $Sk = 1 To $GalimuSusijSk
							If($NIPA[$Sk] = $_NIPA And $NPortas[$Sk] = $_NPortas) Then
								GUICtrlSetData($Isvestis, "[Serveris]: Prie " & $_NIPA & " portu " & $_NPortas & " jau prisijungta" & @CRLF & GUICtrlRead($Isvestis))
								Return
							EndIf
						Next
						Local $Laisvas = RastiLaisva($GalimuSusijSk)
						Select
							Case $Laisvas = -1
								GUICtrlSetData($Isvestis, "[Serveris]: Pasiektas maksimalus susijungimø skaièius (" & $GalimuSusijSk & ") :(" & @CRLF & GUICtrlRead($Isvestis))
							Case Else
								$NIPA[$Laisvas] = $_NIPA
								$NPortas[$Laisvas] = $_NPortas
								$AktyvusSoketas[$Laisvas] = TCPConnect($NIPA[$Laisvas], $NPortas[$Laisvas])
								Select
									Case @error
										GUICtrlSetData($Isvestis, "[Serveris]: Nepavyko prisijungti prie " & $NIPA[$Laisvas] & @CRLF & GUICtrlRead($Isvestis))
										$AktyvusSoketas[$Laisvas] = -1
										$NIPA[$Laisvas] = -1
									Case Not @error
										$PatsPrisijungiau = $NIPA[$Laisvas]
										GUICtrlSetData($Isvestis, "[Serveris]: Sëkmingai prisijungta prie " & $NIPA[$Laisvas] & @CRLF & GUICtrlRead($Isvestis))
								EndSelect
						EndSelect
					EndIf
				EndIf

			Case StringLeft($DuomSiunt, 6) = "atsij "
				Local $DS2 = StringTrimLeft($DuomSiunt, 6)
				If Not StringInStr($DS2, ":") = 0 Then
					$DSDalys = StringSplit($DS2, ":")
					If $DSDalys[0] = 2 Then
						Local $_NIPA = TCPNameToIP($DSDalys[1])
						Local $_NPortas = $DSDalys[2]
						For $Sk = 1 To $GalimuSusijSk
							If($NIPA[$Sk] = $_NIPA And $NPortas[$Sk] = $_NPortas) Then
								TCPSend($AktyvusSoketas[$Sk], "{Kosto sisteminis} ate")
								TCPCloseSocket($AktyvusSoketas[$Sk])
								$AktyvusSoketas[$Sk] = -1
								$NIPA[$Sk] = ""
								GUICtrlSetData($Isvestis, "[Serveris]: Sëkmingai atsijungta nuo " & $_NIPA & " portu " & $_NPortas & @CRLF & GUICtrlRead($Isvestis))
								Return
							EndIf
						Next
						GUICtrlSetData($Isvestis, "[Serveris]: Nëra prisijungta prie " & $_NIPA & " portu " & $_NPortas & @CRLF & GUICtrlRead($Isvestis))
					EndIf
				EndIf

			Case Else
				$DuomSiunt = StringReplace( $DuomSiunt, "<nauja>", @CRLF ) ; patobulinimas.
				Local $Gavejai = "["
				For $Sk = 1 To $GalimuSusijSk
					If $AktyvusSoketas[$Sk] <> -1 Then
						TCPSend($AktyvusSoketas[$Sk], $DuomSiunt)
						Select
							Case @error
								TCPCloseSocket($AktyvusSoketas[$Sk])
								$AktyvusSoketas[$Sk] = -1
								GUICtrlSetData($Isvestis, "[Serveris]: Atsijungë " & $NIPA[$Sk] & @CRLF & GUICtrlRead($Isvestis))
								$NIPA[$Sk] = ""
							Case Not @error
								$Gavejai = $Gavejai & " " & $NIPA[$Sk]
						EndSelect
					EndIf
				Next
				If $Gavejai <> "[" Then GUICtrlSetData($Isvestis, $VIPA & " > " & $Gavejai & " ]: " & $DuomSiunt & @CRLF & GUICtrlRead($Isvestis))
		EndSelect
	EndIf
EndFunc



Func RastiLaisva($IkiKiek)
	Local $Skaicius
	For $Skaicius = 1 To $IkiKiek
		If $AktyvusSoketas[$Skaicius] = -1 Then Return $Skaicius
	Next
	Return -1
EndFunc