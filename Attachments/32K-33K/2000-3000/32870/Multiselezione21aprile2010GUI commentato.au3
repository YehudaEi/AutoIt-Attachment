#include <GuiConstants.au3>;necessari per le gui
GUICreate("Multiselezione by NATTA",300,230);gui principale
GUISetState(@SW_SHOW)
$bottone1=GUICtrlCreateButton("Opzione 1",10,10)
GUICtrlCreateLabel("Aprire il notepad e scrivere l'ora e la data, poi chiuderlo"&@CRLF&"senza salvarlo",15,40)
$bottone2=GUICtrlCreateButton("Opzione 2",10,80)
GUICtrlCreateLabel("Aprire la calcolatrice e eseguire un calcolo a scelta tra"&@CRLF&"2 operatori con le 4 operazioni di base",15,110)
$bottone3=GUICtrlCreateButton("Opzione 3",10,150)
$ss=GUICtrlCreateLabel("Aprire il notepad, scrivere l'ora e la data, il sistema"&@CRLF&"operativo e chiudere senza salvare",15,180)

While 1;controlla con guigetmsg di continuo gli eventi (ES Se clicco su un bottone)
    $Scelta = GUIGetMsg()

    If $Scelta = $GUI_EVENT_CLOSE Then ExitLoop;se clicco sulla x rossa chiude il programma

Select;select, conrolla cosa ho cliccato, se il primo bottone, il secondo ecc ecc o anche sui label o sulla gui e agisce
	Case $Scelta=$bottone1;di conseguenza
		BlockInput(1);Blocca l'intervento dell'utente finchè non riscrivo che è 0
		Run("notepad.exe")
		WinWaitActive("Senza nome - Blocco note")
		Send("Ora e data "&@CRLF&"{F5}")
		Sleep(1500)
		WinClose("Senza nome - Blocco note")
		WinWaitActive("Blocco note")
		Send("!n");Invia comandi, ! corrisponde a alt, quindi !n è come premere alt più n insieme
		BlockInput(0)
	Case $Scelta=$bottone2
#Cs
Nota: In questo ciclo, è da notare che si richiede dei numeri (1,2,3,4 nella prima inputbox, gli operatori nella seconda e terza
Le inputbox, come descritto nell'help, restituiscono ciò che è scritto nell'inputbox come STRINGA, quindi, se mettiamo il numero
3 nell'input box, è preso come "3" e non come 3, che è diverso. "3" è convertito nel corrispettivo esadecimale 0x33, mentre
il numero 3 da solo, è letto come 0x00000003. Nella stringa If Not StringIsInt($operatore2) or $operatore2<1 or $operatore2>4 Then
come negli altri 2 If del caso $Scelta=$bottone2, Bisogna esaminare quindi $operatore2 con StringIsInt. Non si può esaminare con
IsNumber() perchè sono stringhe, mentre IsNumber() non converte, come molte funzioni native, le stringhe in numeri automaticamente,
ma le legge per quel che sono, stringhe e non numeri. Una soluzione è quindi convertire le stringhe con Number() e poi esaminarle
con IsNumber(), oppure esaminarle con StringIsInt che controlla se una stringa contiene un numero intero.
Maggiori Informazioni qui: http://www.autoitscript.com/forum/index.php?showtopic=113437
#Ce
		While 1;Ciclo A, tiene sottocontrollo le 3 opzioni delle inputbox, più l'apertura della calcolatrice e l'invio dei dati
			While 1;Ciclo B1, c'e n'e ognuno per ogni inputbox, serve perchè se vado all'errore, ripete l'inputbox corrente, vedi B2
		$operatore2=InputBox("Scegliere","1.Moltiplicazione"&@CRLF&"2.Divisione"&@CRLF&"3.Addizione"&@CRLF&"4.Sottrazione")
	         If @error Then ExitLoop
			 If Not StringIsInt($operatore2) or $operatore2<1 or $operatore2>4 Then
			 Msgbox(0, "Errore", "Devi Scegliere un numero tra 1 e 4")
			 ContinueLoop;necessario non ho capito perchè
			 Endif
				 ExitLoop;necessario, chiude il ciclo B1 altrimenti parte la prima inputbox all'infinito
			 Wend;fine ciclo B1
			 While 1;Ciclo B2 Ripete questo ciclo e questa inputbox finchè non si dà il valore corretto, in modo da non
		$operatore1=InputBox("Inserire il primo operatore numerico","Primo Operatore:");ricominciare dalla prina (Ciclo B1)
			 If @error Then ExitLoop
			 If Not StringIsInt($operatore1) Then
			 Msgbox(0, "Errore", "Non hai inserito un numero intero")
			 ContinueLoop
			 Endif
			     ExitLoop;necessario, chiude il ciclo B2 altrimenti parte la prima inputbox all'infinito
			 Wend;fine ciclo B2
			 While 1;Ciclo B3, come gli altri se qui inseriamo un valore errato, richiede il secondo operatore invece di
		$operatore3=InputBox("Inserire il primo operatore numerico","Secondo Operatore:");ricominciare dalla prima inputbox
	         If @error Then ExitLoop
			 If Not StringIsInt($operatore3) Then
			 Msgbox(0, "Errore", "Non hai inserito un numero intero")
			 ContinueLoop
			 Endif
			     ExitLoop;necessario, chiude il ciclo B3 altrimenti parte la prima inputbox all'infinito
			 Wend;Fine ciclo B3
	Run("Calc.exe")
	WinWaitActive("Calcolatrice");aspetta che sia attiva la finestra della calcolatrice prima di proseguire
	AutoItSetOption("SendKeyDelay",200);Regola l'intervallo di digitazione di autoit (invia un tasto ogni 200 ms), al posto
	BlockInput(1);di AutoItSetOption si può usare Opt()
	Switch $operatore2;switch della prima inputbox, esegue l'operazione richiesta
		Case 1
			Send($operatore1&"*"&$operatore3&"=");La flag 1 in Send, permette l'invio di pressioni di tasto così come sono
		Case 2
			Send($operatore1&"/"&$operatore3&"=");ovvero annullando le hotkey come ! che corrisponde ad alt o ^ che
		Case 3
			Send($operatore1&"+"&$operatore3&"=",1); corrisponde a CTRL. Quindi un invio di !^n con la flag 1, invierà proprio
		Case 4
			Send($operatore1&"-"&$operatore3&"=");  !^n e non ALT+CTRL+n. In questo caso il programma presentava il seguente
	EndSwitch;bug: al caso 3, addizione, se per esempio si dava 33 e 33 come operatori, invece di digitare 33+33= digitava
	BlockInput(0); 333, perchè + corrisponde a SHIFT. Questo si risolve con la flag 1, di sintassi Send ("keys", 1)
	Sleep(6000)
	WinClose("Calcolatrice")
	ExitLoop
	WEnd;Fine Ciclo A
	Case $Scelta=$bottone3
		BlockInput(1)
		Run("notepad.exe")
		WinWaitActive("Senza nome - Blocco note")
		Send("Ora e data"&@CRLF&"{F5}"&@CRLF&"Sistema operativo"&@CRLF&@OSVersion)
		Sleep(1500)
		Winclose("Senza nome - Blocco note")
		WinWaitActive("Blocco note")
		Send("!n")
		BlockInput(0)
EndSelect
WEnd