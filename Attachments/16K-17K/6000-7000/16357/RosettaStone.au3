;===================================================
; Rosetta Stone v1.21 multilingual by jennico © 30.8.2007
; Baisic script from: ATranslation by Valery Ivanov, 15 March 2007
; Initiated by AzKay: http://www.autoitscript.com/forum/index.php?showtopic=35834
; Idea by gary frost
; lots of features added and fixed errors
; contact: jennicoattminusonlinedotde
;===================================================
#include <GUIConstants.au3>
Opt("TrayAutoPause",0)
Opt("TrayMenuMode",1)
Opt("TrayOnEventMode",1)
;--------------------------------------------------
Dim $Help,$ErrorSet,$EmbedSet,$TargetContent,$Idiom[9],$Words[9],$FromTo[9],$ResultContent,$x=" ",$_IEStatus_Success=0,$_IEStatus_GeneralError,$_IEErrorNotify=True,$__IEAU3Debug=False,$_IEStatus_InvalidObjectType,$__IELoadWaitTimeout=300000
$Words[1]="Deutsch|Englisch|Franzˆsisch|Holl‰ndisch|Italienisch|Portugiesisch|Spanisch|Griechisch|Russisch|Japanisch|Koreanisch|Chinesisch (einf.)|Chinesisch (trad.)|&Wiederherstellen|&Minimieren|&Stilles ‹bersetzen|Zwischenablage im &Tooltip anzeigen|Lexikon|Diese Auswahl muss zwischen¸bersetzt werden:|&Automatisch|‹bersetzung|Eingabe|Warten|E&rsetzen|&Kopieren|&Beenden|Status|Fehler !|Verbindungsfehler, kein Internet ?|Zwischenablage|&‹bersetzen|‹bersetzungsproblem, falsche Sprachauswahl ?|Fertig|‹bersetzung ist in der Zwischenablage| ( Englisch zwischen¸bersetzt )|Verbindungsaufbau gescheitert !|Sprache|‹ber|&Lˆschen|‹bersetzen|Stilles ‹bersetzen|bitte warten|Zwischenablage wird ¸bersetzt|&Hilfe (in Englisch)|E&nglisch|de%2Fen|( Franzˆsisch zwischen¸bersetzt )|Die Zwischenablage ist leer !|Bitte w‰hlen Sie Ihre Sprache aus"
$Words[2]="German|English|French|Dutch|Italian|Portuguese|Spanish|Greek|Russian|Japanese|Korean|Chinese (simpl.)|Chinese (trad.)|&Restore|&Minimize|&Silent Mode|Clipboard in &Tool Tip|Dictionary|This choice must be intertranslated:|A&utomatic|Translation|Input|Waiting|&Replace|&Copy|Ex&it|State|Error !|Connection error, no Internet ?|Clipboard|Tr&anslate It|Translation problem, wrong linguistic choice ?|Ready|Translation in clipboard|  ( English intertranslated )|Connection failed !|Language|About|D&elete|Translating|Silent Mode|please wait|Translating clipboard|&Help|E&nglish|en%2Ffr|   ( French intertranslated )|Clipboard is empty !|Please select your language"
$Words[3]="Allemand|Anglais|FranÁais|NÈerlandais|Italien|Portugais|Espagnol|Grec|Russe|Japonais|CorÈen|Chinois (simpl.)|Chinois (trad.)|&Restituer|&Minimiser|Mode &Silencieux|Clipboard au &Tool Tip|Dictionnaire|Ce choix doit Ítre intertraduit:|A&utomatique|Traduction|EntrÈe|Attente|&Remplacer|&Copie|Sort&ie|Statut|Erreur !|Erreur de connexion, aucun Internet ?|Clipboard|Tr&aduisez-le !|ProblËme de traduction, choix mal linguistique ?|PrÍt|Traduction dans le Clipboard|  ( intertraduit a l'anglais )|Connexion a ÈchouÈ !|Langue|De Rosetta Stone|&Effacer|Traduis|Mode Silencieux|attendez s'il vous plaÓt|Traduis le clipboard|L'ai&de (en anglais)|A&nglais|fr%2Fen|  ( intertraduit au franÁais )|Le Clipboard est vide !|Choisissez S.V.P. votre langue"
$Words[4]="Duits|Engels|Frans|Nederlands|Italiaans|Portugees|Spaans|Grieks|Rus|Japans|Koreaans|Chinese (eenv.)|Chinese (trad.)|He&rstel|&Minimaliseer|&Stille Wijze|Klembord aan &Tool Tip|Woordenboek|Deze keus moet zijn tussen-vertaalt:|A&utomatisch|Vertaling|Input|Wachten|Ve&rvang|&KopiÎren|U&itgang|Statuut|Fout !|De fout van de verbinding, geen Internet ?|Klembord|Vert&alen|Vertaal probleem, verkeerde taalkundige keus ?|Klaar|Vertaling in klembord|(in het Engels tussen-vertaalt)|Ontbroken verbinding !|Taal|Over|Schrapp&en|Vertaalend|Stille Wijze|gelieve te wachten|Vertalend klembord|&Hulp (in het Engels)|E&ngels|nl%2Fen|(in het Frans tussen-vertaalt)|Het klembord is leeg !|Gelieve te selecteren uw taal"
$Words[5]="Tedesco|Inglese|Francese|Olandese|Italiano|Portoghese|Spagnolo|Greco|Russo|Giapponese|Coreano|Cinese (sempl.)|Cinese (trad.)|&Restore|&Minimizzi|Modo &Silenzioso|Clipboard al &Tool Tip|Dizionario|Questa scelta deve essere fra-tradotta:|A&utomatico|Traduzione|Input|Attesa|S&ostituisca|&Copiare|R&imuova|Dichiari|Errore !|Errore del collegamento, nessun Internet ?|Clipboard|Tr&aducalo !|Problema di traduzione, scelta linguistica di torto ?|Aspetti|Traduzione in clipboard|  ( fra-tradotta in inglese )|Collegamento Ë venuto a mancare !|Lingua|Circa|Canc&ellar|Traducendo|Modo Silenzioso|prego attesa|Traducendo el clipboard|Aiuto (in inglese) &H|I&nglese|it%2Fen| ( fra-tradotta in Francese )|Il clipboard Ë vuoto !|Selezioni prego la vostra lingua"
$Words[6]="Alem„o|InglÍs|FrancÍs|HolandÍs|Italiano|PortuguÍs|Espanhol|Grego|Russo|JaponÍs|Coreano|ChinÍs (simpl.)|ChinÍs (trad.)|&Restaurar|&Minimizar|Modo &Silencioso|Prancheta a &Tool Tip|Dicion·rio|Esta escolha deve ser intertraduzida:|A&utom·tico|TraduÁ„o|Entrada|Espera|Substitui&r|&CÛpiar|Sa&Ìda|Estatuto|Erro !|Erro de conex„o, nenhuma Internet ?|Prancheta|Tr&aduza-o !|Problema de traduÁ„o, escolha mal ling¸Ìstica ?|Pronto|TraduÁ„o em prancheta|  ( intertraduzido em InglÍs )|Conex„o falhou !|LÌngua|De Rosetta Stone|&Elimin·|Traduzindo|Modo Silencioso|por favor espere|Traduzindo a prancheta|Aju&da (em inglÍs)|I&nglÍs|pt%2Fen|( intertraduzido em FrancÍs )|A prancheta È vazia !|Por favor selecione a sua lÌngua"
$Words[7]="Alem·n|InglÈs|FrancÈs|HolandÈs|Italiano|PortuguÈs|EspaÒol|Griego|Ruso|JaponÈs|Coreano|Chino (simpl.)|Chino (trad.)|&Restaurar|&Minimizar|Manera &Silenciosa|Clipboard en &Tool Tip|Diccionario|Esta opciÛn debe ser intertraducida:|A&utom·tico|TraducciÛn|Entrada|Esperando|Sustitui&r|&Copiar|Sal&ida|Estado|° Error !|Error de conexiÛn, ø ning˙n Internet ?|Clipboard|° Tr&ad˙zcalo !|Problema de traducciÛn, ø opciÛn ling¸Ìstica incorrecta ?|Listo|TraducciÛn en clipboard|  ( intertraducido en InglÈs )|° ConexiÛn fallÛ !|Idioma|Sobre|&Borrar|Traduciendo|Manera Silenciosa|por favor espere|Traduciendo el clipboard|Ayu&da (en inglÈs)|I&nglÈs|es%2Fen| ( intertraducido en FrancÈs )|° El clipboard est· vacÌo !|Por favor seleccione su lengua"
$Words[8]="√ÂÒÏ·ÌÈÍ‹|¡„„ÎÈÍ‹|√·ÎÎÈÍ‹|œÎÎ·Ì‰ÈÍ‹|…Ù·ÎÈÍ‹|–ÔÒÙÔ„·ÎÎÈÍ‹|…Û·ÌÈÍ‹|≈ÎÎÁÌÈÍ‹|—˘ÛÈÍ‹|√È·˘Ì›ÊÈÍ·| ÔÒÂ‹ÙÈÍ·| ÈÌ›ÊÈÍ· (·ÎÔÔÈ.)| ÈÌ›ÊÈÍ· (·Ò·‰ÔÛ.)|≈·Ì·ˆÔÒ‹|≈Î·˜ÈÛÙÔÔﬂÁÛÁ|¡Ë¸Òı‚Ô|Clipboard in Tool Tip|ÀÂÓÈÍ¸|¡ıÙﬁ Á ÂÈÎÔ„ﬁ Ò›ÂÈ Ì· ÂﬂÌ·È ÏÂÙ·ˆÒ·ÛÏ›ÌÁ ÂÛ˘ÙÂÒÈÍ‹:|¡ıÙ¸Ï·Ù·|ÃÂÙ‹ˆÒ·ÛÁ|≈ÈÛ·„˘„ﬁ|¡Ì·ÏÔÌﬁ|¡ÌÙÈÍ·Ù‹ÛÙ·ÛÁ|¡ÌÙÈ„Ò·ˆﬁ|∏ÓÔ‰ÔÚ| ·Ù‹ÛÙ·ÛÁ|Ûˆ‹ÎÏ· !|–Ò¸‚ÎÁÏ· Û˝Ì‰ÂÛÁÚ, ı‹Ò˜ÂÈ Û˝Ì‰ÂÛÁ ÏÂ ÙÔ ‰È·‰ﬂÍÙıÔ;|Clipboard|ÏÂÙ·ˆÒ‹ÛÙÂ ‘Ô !|–Ò¸‚ÎÁÏ· ÏÂÙ‹ˆÒ·ÛÁÚ, Î·ÌË·ÛÏ›ÌÁ ÂÈÎÔ„ﬁ „Î˛ÛÛ·Ú;|∏ÙÔÈÏÔ|¡ÌÙÈ„Ò·ˆﬁ ÏÂÙ‹ˆÒ·ÛÁÚ|(ÏÂÙ‹ˆÒ·ÛÏ›ÌÔ ÂÛ˘ÙÂÒÈÍ‹ ÛÙ· ·„„ÎÈÍ‹)|”˝Ì‰ÂÛÁ ·›Ùı˜Â !|„Î˛ÛÛ·|ÂÒﬂÔı|‰È·„Ò‹¯ÙÂ|ÃÂÙ·ˆÒ‹ÊÂÙÂ|¡Ë¸Òı‚Ô|·Ò·Í·Î˛ ÂÒÈÏ›ÌÂÙÂ|ÃÂÙ·ˆÒ‹ÊÂÙÂ ÏÂÙ‹ˆÒ·ÛÁÚ|¬ÔﬁËÂÈ· (ÛÙ· ·„„ÎÈÍ‹)|¡„„ÎÈÍ‹|el%2Fen|(ÏÂÙ‹ˆÒ·ÛÏ›ÌÔ ÂÛ˘ÙÂÒÈÍ‹ ÛÙ· „·ÎÎÈÍ‹)|Clipboard is empty !|Please select your language"
$FromTo[1]="DeEn|DeFr|EnDe|EnFr|EnGr|EnHo|EnIt|EnJa|EnKo|EnPo|EnRu|EnSp|EnCh|FrDe|FrEn|FrGr|FrHo|FrIt|FrPo|FrSp|GrEn|GrFr|HoEn|HoFr|ItEn|ItFr|JaEn|KoEn|PoEn|PoFr|RuEn|SpEn|SpFr|ChEn"
$FromTo[2]="GeEn|GeFr|EnGe|EnFr|EnGr|EnDu|EnIt|EnJa|EnKo|EnPo|EnRu|EnSp|EnCh|FrGe|FrEn|FrGr|FrDu|FrIt|FrPo|FrSp|GrEn|GrFr|DuEn|DuFr|ItEn|ItFr|JaEn|KoEn|PoEn|PoFr|RuEn|SpEn|SpFr|ChEn"
$FromTo[3]="AlAn|AlFr|AnAl|AnFr|AnGr|AnNÈ|AnIt|AnJa|AnCo|AnPo|AnRu|AnEs|AnCh|FrAl|FrAn|FrGr|FrNÈ|FrIt|FrPo|FrEs|GrAn|GrFr|NÈAn|NÈFr|ItAn|ItFr|JaAn|C0An|PoAn|PoFr|RuAn|EsAn|EsFr|ChAn"
$FromTo[4]="DuEn|DuFr|EnDu|EnFr|EnGr|EnNe|EnIt|EnJa|EnKo|EnPo|EnRu|EnSp|EnCh|FrDu|FrEn|FrGr|FrNe|FrIt|FrPo|FrSp|GrEn|GrFr|NeEn|NeFr|ItEn|ItFr|JaEn|KoEn|PoEn|PoFr|RuEn|SpEn|SpFr|ChEn"
$FromTo[5]="TeIn|TeFr|InTe|InFr|InGr|InOl|InIt|InGi|InCo|InPo|InRu|InSp|InCi|FrTe|FrIn|FrGr|FrOl|FrIt|FrPo|FrSp|GrIn|GrFr|OlIn|OlFr|ItIn|ItFr|GiIn|CoIn|PoIn|PoFr|RuIn|SpIn|SpFr|CiIn"
$FromTo[6]="AlIn|AlFr|InAl|InFr|InGr|InHo|InIt|InJa|InCo|InPo|InRu|InEs|InCh|FrAl|FrIn|FrGr|FrHo|FrIt|FrPo|FrEs|GrIn|GrFr|HoIn|HoFr|ItIn|ItFr|JaIn|CoIn|PoIn|PoFr|RuIn|EsIn|EsFr|ChIn"
$FromTo[7]="AlIn|AlFr|InAl|InFr|InGr|InHo|InIt|InJa|InCo|InPo|InRu|InEs|InCh|FrAl|FrIn|FrGr|FrHo|FrIt|FrPo|FrEs|GrIn|GrFr|HoIn|HoFr|ItIn|ItFr|JaIn|CoIn|PoIn|PoFr|RuIn|EsIn|EsFr|ChIn"
$FromTo[8]="√Â¡„|√Â√·|¡„√Â|¡„√·|¡„≈Î|¡„œÎ|¡„…Ù|¡„√È|¡„ Ô|¡„–Ô|¡„—˘|¡„…Û|¡„ È|√·√Â|√·¡„|√·≈Î|√·œÎ|√·…Ù|√·–Ô|√·…Û|≈Î¡„|≈Î√·|œÎ¡„|œÎ√·|…Ù¡„|…Ù√·|√È¡„| Ô¡„|–Ô¡„|–Ô√·|—˘¡„|…Û¡„|…Û√·| È¡„"
$Default=IniRead("RosettaStone.ini","Sprache","Default","")
If $Default="" Or Number($Default)=0 Or Number($Default)>8 Then $Default=_Abfrage()
SoundPlay(@WindowsDir&"\media\chimes.wav")
$Wort=StringSplit($Words[$Default],"|")
$From=StringLeft($Words[$Default],StringInStr($Words[$Default],")",1,2))
$a=IniRead("RosettaStone.ini","Sprache","Ein","")
If $a="" Or StringInStr($Words[$Default],$a)=0 Then $a=$Wort[$Default]
$b=IniRead("RosettaStone.ini","Sprache","Aus","")
If $b="" Or StringInStr($Words[$Default],$b)=0 Then $b=$Wort[($Default=2)+2]
$To=StringReplace($From,$b&"|","")
$From=StringReplace($From,$a&"|","")
$Language=$Wort[46]
$oHTTP=ObjCreate("winhttp.winhttprequest.5.1")
$sIEUserErrorHandler="_Error"
$oIEErrorHandler=ObjEvent("AutoIt.Error","_Error")
SetError(0)
If IsObj($oIEErrorHandler)=0 Then
	_IEErrorNotify("Error","_IEPropertySet","$_IEStatus_GeneralError","Error Handler Not Registered - Check existance of error function")
	SetError($_IEStatus_GeneralError,1)
EndIf
;--------------------------------------------------
TraySetClick(8)
TraySetIcon("RosettaStone.exe")
$Maximize=TrayCreateItem($Wort[14])
	TrayItemSetOnEvent(-1,"_Maxi")
$Minimize=TrayCreateItem($Wort[15])
	TrayItemSetOnEvent(-1,"_Mini")
TrayCreateItem("")
$Silent=TrayCreateItem($Wort[16])
	TrayItemSetOnEvent(-1,"_Silent")
TrayCreateItem("")
$ClipMode=IniRead("RosettaStone.ini","Sprache","Clp","")
$ClipTool=TrayCreateItem($Wort[17])
	TrayItemSetOnEvent(-1,"_ClipTool")
	TrayItemSetState(-1,$ClipMode)
TrayCreateItem("")
$Sprache=TrayCreateMenu($Wort[37])
	For $i=1 To 8
		$c=StringSplit($Words[$i],"|")
		$Idiom[$i]=TrayCreateItem($c[$i],$Sprache,-1,1)
		TrayItemSetOnEvent(-1,"_Sprache")
	Next
	TrayItemSetState($Idiom[$Default],1)
TrayCreateItem("")
$Hilfe=TrayCreateItem($Wort[44])
	TrayItemSetOnEvent(-1,"_Help")
TrayCreateItem("")
$About=TrayCreateItem($Wort[38])
	TrayItemSetOnEvent(-1,"_About")
TrayCreateItem("")
$Exit=TrayCreateItem($Wort[26])
	TrayItemSetOnEvent(-1,"_Exit")
TraySetOnEvent(-7,"_Maxi")
TraySetOnEvent(-13,"_Silent")
;--------------------------------------------------
$RoSto=GUICreate(" Rosetta Stone v1.21  ©  2007 by jennico",400,450,-1,-1,-1,$WS_EX_ACCEPTFILES)
GUISetFont(9,400,-1,"MS Sans Serif")
GUISetIcon("RosettaStone.exe",0)
$Lexikon=GUICtrlCreateLabel($Wort[18]&":",10,13,80,20)
	GUICtrlSetFont(-1,-1,800,4)
GUICtrlCreateLabel("ó",192,14,10,12)
	GUICtrlSetFont(-1,8,800,-1,"Tahoma")
$Auswahl=GUICtrlCreateLabel($Wort[19],0,45,300,15,$SS_RIGHT)
	GUICtrlSetState(-1,$GUI_HIDE)
$Radio1=GUICtrlCreateRadio($Wort[45],310,35,120,20)
	GUICtrlSetState(-1,$GUI_HIDE)
	GUICtrlSetState(-1,$GUI_CHECKED)
$Radio2=GUICtrlCreateRadio("&"&$Wort[3],310,52,120,20)
	GUICtrlSetState(-1,$GUI_HIDE)
$Flag1=GUICtrlCreateCombo($a,94,10,95,20,BitOR($CBS_DROPDOWNLIST,$WS_VSCROLL))
	GUICtrlSetData(-1,$From,$a)
$Flag2=GUICtrlCreateCombo($b,205,10,95,20,BitOR($CBS_DROPDOWNLIST,$WS_VSCROLL))
	GUICtrlSetData(-1,$To,$b)
$AutoRefresh=GUICtrlCreateCheckbox($Wort[20],310,10,100,20)
	GUICtrlSetState(-1,IniRead("RosettaStone.ini","Sprache","Rfr","0")=1)
;--------------------------------------------------
$Output=GUICtrlCreateLabel($Wort[21]&":",10,265,100,15)
	GUICtrlSetFont(-1,-1,700,4)
$Zwischen=GUICtrlCreateLabel("",110,265,185,15)
	GUICtrlSetState(-1,$GUI_HIDE)
$Result=GUICtrlCreateEdit("",10,280,380,130,BitOR($ES_READONLY,$WS_VSCROLL))
	GUICtrlSetData(-1,IniRead("RosettaStone.ini","Vorher","Aus",""))
;--------------------------------------------------
$Input=GUICtrlCreateLabel($Wort[22]&":",10,70,380,20)
	GUICtrlSetFont(-1,-1,700,4)
$Target=GUICtrlCreateEdit("",10,85,380,130,BitOR($ES_MULTILINE,$ES_AUTOVSCROLL,$WS_VSCROLL))
	If $Default=1 Then GUICtrlSetData(-1,"Der Mond ist aufgegangen, die goldenen Sternlein prangen am Himmel hell und klar. Der Wald steht schwarz und schweiget und aus den Wiesen steiget der weiﬂe Nebel wunderbar. Weiﬂt Du wieviel Sternlein stehen an dem groﬂen weiten Himmelszelt ? Gott der Herr hat sie gez‰hlet dass ihm auch keines fehlet an der ganzen groﬂen Zahl.")	
	If IniRead("RosettaStone.ini","Vorher","Ein","") Then GUICtrlSetData(-1,IniRead("RosettaStone.ini","Vorher","Ein",""))
	GUICtrlSetState(-1,$GUI_DROPACCEPTED)
;--------------------------------------------------
$Status=GUICtrlCreateLabel($Wort[27]&": "&$Wort[23]&"...",10,234,280,22)
	GUICtrlSetFont(-1,11,600,2)
$Icon=GUICtrlCreateIcon(@WindowsDir&"\Cursors\hourglas.ani",0,178,228)
$Ersetzen=GUICtrlCreateButton($Wort[24],290,219,100,21)
$Kopieren=GUICtrlCreateButton($Wort[25],290,255,100,21)
	GUICtrlSetState(-1,$GUI_DISABLE)
;--------------------------------------------------
$Loschen=GUICtrlCreateButton($Wort[39],10,420,100,21)
$Translate=GUICtrlCreateButton($Wort[31],150,420,100,21,$BS_DEFPUSHBUTTON)
	GUICtrlSetFont(-1,-1,700)
	If $a=$b Then GUICtrlSetState(-1,$GUI_DISABLE)
$Beenden=GUICtrlCreateButton($Wort[26],290,420,100,21)
GUISetState()
;--------------------------------------------------
While 1
	$Msg=GUIGetMsg()
	If WinActive($RoSto) Then _HotKeySet()
	If WinActive($RoSto)=0 Then _HotKeyUnSet()
	If WinGetState($RoSto)=23 Then 
		TrayItemSetState($Minimize,128)	
	Else
		TrayItemSetState($Minimize,64)
	EndIf
	If $x<>GUICtrlRead($Target) Then
		If GUICtrlRead($Target) And GUICtrlRead($Flag1)<>GUICtrlRead($Flag2) Then GUICtrlSetState($Translate,$GUI_ENABLE)
		If GUICtrlRead($Target)="" Then GUICtrlSetState($Translate,$GUI_DISABLE)
	EndIf
	$x=GUICtrlRead($Target)
	If $ClipMode=1 And WinActive($RoSto) And WinGetState($RoSto)=15 And ClipGet() Then
		$size=WinGetPos($RoSto)
		ToolTip(_Split(),$size[0]+$size[2]-20,$size[1]+$size[3]-225,$Wort[30],1,5)
	Else
		ToolTip("")
	EndIf	
	If $Help Then
		If $Msg=$Close Or ($Msg=$GUI_EVENT_CLOSE And WinActive($GUI)) Then
			GUIDelete($GUI)
			WinActivate($RoSto)
			$Help=0
			$msg=""
		EndIf
	EndIf
	If $Msg=$Beenden Or $Msg=$GUI_EVENT_CLOSE Then _Exit()
	If $Msg=$Kopieren Then ClipPut($ResultContent)
	If $Msg=$Ersetzen Then GUICtrlSetData($Target,ClipGet())
	If $Msg=$Translate Then _TranslateIt()
	If $Msg=$Loschen Then _Loschen()
	If $Msg=$Flag1 Or $Msg=$Flag2 Then _Auswahl()
	If ($Msg=$Flag2 Or $Msg=$Radio1 Or $Msg=$Radio2) And GUICtrlRead($AutoRefresh)=1 Then _TranslateIt()
WEnd
;--------------------------------------------------
Func _Exit()
	$oHTTP.abort()
	$oHTTP=0
	IniWrite("RosettaStone.ini","Sprache","Default",$Default)
	IniWrite("RosettaStone.ini","Sprache","Ein",GUICtrlRead($Flag1))
	IniWrite("RosettaStone.ini","Sprache","Aus",GUICtrlRead($Flag2))
	IniWrite("RosettaStone.ini","Sprache","Clp",$ClipMode)
	IniWrite("RosettaStone.ini","Sprache","Rfr",GUICtrlRead($AutoRefresh))
	IniWrite("RosettaStone.ini","Vorher","Ein",GUICtrlRead($Target))
	IniWrite("RosettaStone.ini","Vorher","Aus",$ResultContent)
	SoundPlay(@WindowsDir&"\media\notify.wav",1)
	Exit	
EndFunc

Func _Error()
	$ErrorSet=1
	SoundPlay(@WindowsDir&"\media\notify.wav")
	GUICtrlSetData($Result,"")
	GUICtrlSetData($Status,$Wort[27]&": "&$Wort[28])
	GUICtrlSetColor($Status,0xF20000)
	GUICtrlSetData($Result,"..."&$Wort[29])
EndFunc

Func _Split()
	$a=ClipGet()
	$b=StringLen($a)
	$d=80
	If $b>2000 Then $d=200
	If $b>$d Then
		For $i=1 To Int($b/$d)
			$c=$i*$d
			While 1
				If StringMid($a,$c,1)=" " Then
					$a=StringReplace($a,$c,@LF)
					ExitLoop
				EndIf
				$c+=1
			WEnd
		Next
	EndIf
	Return $a	
EndFunc

Func _Loschen()
	GUICtrlSetData($Target,"")
	GUICtrlSetData($Result,"")
	GUICtrlSetState($Kopieren,$GUI_DISABLE)
	If $EmbedSet Then _Embed()
	GUICtrlSetState($Target,256)
	WinActivate($RoSto)
EndFunc

Func _Embed()
	GUICtrlDelete($GUIActiveX)
	GUICtrlSetState($Result,$GUI_SHOW)
	$EmbedSet=0
EndFunc

Func _Auswahl()
	If StringInStr($FromTo[$Default],StringLeft(GUICtrlRead($Flag1),2)&StringLeft(GUICtrlRead($Flag2),2)) Or GUICtrlRead($Flag1)=GUICtrlRead($Flag2) Then
		GUICtrlSetState($Radio1,$GUI_CHECKED)
		GUICtrlSetState($Auswahl,$GUI_HIDE)
		GUICtrlSetState($Radio2,$GUI_HIDE)
		GUICtrlSetState($Radio1,$GUI_HIDE)
	ElseIf StringInStr($FromTo[$Default],StringLeft(GUICtrlRead($Flag1),2)&"Fr") And StringInStr($FromTo[$Default],"Fr"&StringLeft(GUICtrlRead($Flag2),2)) Or StringInStr($FromTo[$Default],StringLeft(GUICtrlRead($Flag1),2)&"√·") And StringInStr($FromTo[$Default],"√·"&StringLeft(GUICtrlRead($Flag2),2)) Then
		GUICtrlSetState($Auswahl,$GUI_SHOW)
		GUICtrlSetState($Radio2,$GUI_SHOW)
		GUICtrlSetState($Radio1,$GUI_SHOW)
		GUICtrlSetState($Radio2,$GUI_ENABLE)
	Else
		GUICtrlSetState($Auswahl,$GUI_SHOW)
		GUICtrlSetState($Radio2,$GUI_SHOW)
		GUICtrlSetState($Radio1,$GUI_SHOW)
		GUICtrlSetState($Radio1,$GUI_CHECKED)
		GUICtrlSetState($Radio2,$GUI_DISABLE)
	EndIf
	$x=" "
	If GUICtrlRead($Flag1)=GUICtrlRead($Flag2) Then GUICtrlSetState($Translate,$GUI_DISABLE)
	If GUICtrlRead($Flag1)<>GUICtrlRead($Flag2) And GUICtrlRead($Target) Then GUICtrlSetState($Translate,$GUI_ENABLE)
	GUICtrlSetState($Zwischen,$GUI_HIDE)
EndFunc

Func _TranslateIt()
	If $EmbedSet Then _Embed()
	GUICtrlSetImage($Icon,@WindowsDir&"\Cursors\globe.ani")
	GUICtrlSetState($Translate,$GUI_DISABLE)
	GUICtrlSetState($Beenden,$GUI_DISABLE)
	GUICtrlSetData($Status,$Wort[27]&": "&$Wort[40]&"...")
	GUICtrlSetColor($Status,0x42619C)
	GUICtrlSetData($Result,"")
	$ErrorSet=0
	$TargetContent=GUICtrlRead($Target)
	IniWrite("RosettaStone.ini","Sprache","Default",$Default)
	IniWrite("RosettaStone.ini","Sprache","Ein",GUICtrlRead($Flag1))
	IniWrite("RosettaStone.ini","Sprache","Aus",GUICtrlRead($Flag2))
	IniWrite("RosettaStone.ini","Sprache","Clp",$ClipMode)
	IniWrite("RosettaStone.ini","Sprache","Rfr",GUICtrlRead($AutoRefresh))
	IniWrite("RosettaStone.ini","Vorher","Ein",$TargetContent)
	If GUICtrlGetState($Auswahl)=96 Then
		$Language=StringLower(StringLeft(GUICtrlRead($Flag1),2))&"%2F"&StringLower(StringLeft(GUICtrlRead($Flag2),2))
		If $Default=8 Then $Language=StringLeft(GUICtrlRead($Flag1),2)&"%2F"&StringLeft(GUICtrlRead($Flag2),2)
		$ResultContent=_Senden($TargetContent)
	Else
		$a="en"
		If GUICtrlRead($Radio2)=1 Then $a="fr"
		$Language=StringLower(StringLeft(GUICtrlRead($Flag1),2))&"%2F"&$a
		If $Default=8 Then $Language=StringLeft(GUICtrlRead($Flag1),2)&"%2F"&$a
		$ResultContent=_Senden($TargetContent)
		$TargetContent=$ResultContent
		$Language=$a&"%2F"&StringLower(StringLeft(GUICtrlRead($Flag2),2))
		If $Default=8 Then $Language=$a&"%2F"&StringLeft(GUICtrlRead($Flag2),2)
		$ResultContent=_Senden($TargetContent)
	EndIf
	$oHTTP.Abort()
	If $ErrorSet=0 Then
		SoundPlay(@WindowsDir&"\media\chimes.wav")
		GUICtrlSetData($Status,$Wort[27]&": "&$Wort[33])
		GUICtrlSetColor($Status,0x000000)
		GUICtrlSetData($Result,$ResultContent)
		If $ResultContent=$TargetContent Then 
			SoundPlay(@WindowsDir&"\media\notify.wav")
			GUICtrlSetData($Status,$Wort[27]&": "&$Wort[28])
			GUICtrlSetColor($Status,0xF20000)
			GUICtrlSetData($Result,"..."&$Wort[32])
		ElseIf GUICtrlGetState($Auswahl)=80 Then
			GUICtrlSetData($Zwischen,$Wort[35])	
			If GUICtrlRead($Radio2)=1 Then GUICtrlSetData($Zwischen,$Wort[47])	
			GUICtrlSetState($Zwischen,$GUI_SHOW)
			IniWrite("RosettaStone.ini","Vorher","Aus",$ResultContent)
		EndIf
	EndIf
	$x=" "
	GUICtrlSetState($Translate,$GUI_ENABLE)
	GUICtrlSetState($Beenden,$GUI_ENABLE)
	If $EmbedSet=0 Then GUICtrlSetState($Kopieren,$GUI_ENABLE)
	GUICtrlSetImage($Icon,@WindowsDir&"\Cursors\hourglas.ani")
EndFunc

Func _Senden($TargetContent)
	$Language=StringReplace($Language,"ge","de",1,1)
	$Language=StringReplace($Language,"al","de",1,1)
	If $Default=4 Then $Language=StringReplace($Language,"du","de",1,1)
	$Language=StringReplace($Language,"te","de",1,1)
	$Language=StringReplace($Language,"an","en",1,1)
	$Language=StringReplace($Language,"in","en",1,1)
	$Language=StringReplace($Language,"ho","nl",1,1)
	If $Default=2 Then $Language=StringReplace($Language,"du","nl",1,1)
	$Language=StringReplace($Language,"nÈ","nl",1,1)
	$Language=StringReplace($Language,"ne","nl",1,1)
	$Language=StringReplace($Language,"ol","nl",1,1)
	$Language=StringReplace($Language,"po","pt",1,1)
	$Language=StringReplace($Language,"sp","es",1,1)
	$Language=StringReplace($Language,"gr","el",1,1)
	$Language=StringReplace($Language,"gi","ja",1,1)
	$Language=StringReplace($Language,"co","ko",1,1)
	$Language=StringReplace($Language,"ci","ch",1,1)
	If $Default=8 Then
		$Language=StringReplace($Language,"√Â","de",1,1)
		$Language=StringReplace($Language,"¡„","en",1,1)
		$Language=StringReplace($Language,"√·","fr",1,1)
		$Language=StringReplace($Language,"œÎ","nl",1,1)
		$Language=StringReplace($Language,"…Ù","it",1,1)
		$Language=StringReplace($Language,"–Ô","pt",1,1)
		$Language=StringReplace($Language,"…Û","es",1,1)
		$Language=StringReplace($Language,"≈Î","el",1,1)
		$Language=StringReplace($Language,"—˘","ru",1,1)
		$Language=StringReplace($Language,"√È","ja",1,1)
		$Language=StringReplace($Language," Ô","ko",1,1)
		$Language=StringReplace($Language," È","ch",1,1)
	EndIf
	If StringInStr($Language,"ch") Then
		$Language=StringReplace($Language,"ch","zh",1,1)
		If StringInStr(GUICtrlRead($Flag1),"d.)") Or StringInStr(GUICtrlRead($Flag2),"d.)") Then $Language=StringReplace($Language,"zh","zt",1,1)
		If StringInStr(GUICtrlRead($Flag1),"Û.)") Or StringInStr(GUICtrlRead($Flag2),"Û.)") Then $Language=StringReplace($Language,"zh","zt",1,1)
	EndIf
	If $ErrorSet=0 Then	
		If StringInStr("elrujakozhzt",StringRight($Language,2)) Then
			$oIE=_IECreateEmbedded()
			Global $GUIActiveX=GUICtrlCreateObj($oIE,10,280,380,130)
			_IENavigate($oIE,"http://freetranslation.paralink.com/target.asp?actions=translate&source="&$TargetContent&"&dir="&$Language)
			GUICtrlSetState($Result,$GUI_HIDE)
			$EmbedSet=1
			Return " "
		Else
			$oHTTP.Open("GET","http://freetranslation.paralink.com/target.asp?actions=translate&source="&$TargetContent&"&dir="&$Language)
			$oHTTP.Send()
			$HTMLSource=$oHTTP.Responsetext
			$ResultContent=_StringBetween($HTMLSource,' onfocus="onFocus(1)">',"</textarea>")
			$ResultContent=StringReplace($ResultContent,@LF," ")
			Return $ResultContent
		EndIf
	EndIf
EndFunc

Func _StringBetween($s,$f,$t)
    $x=StringInStr($s,$f)+StringLen($f)
    $y=StringInStr(StringTrimLeft($s,$x),$t)
    Return StringMid($s,$x,$y)
EndFunc

Func _IsPressed($s_hexKey)
	$a_R=DllCall("user32.dll","int","GetAsyncKeyState","int","0x"&$s_hexKey)
	If Not @error And BitAND($a_R[0],0x8000)=0x8000 Then Return 1
	Return 0
EndFunc

Func _IEErrorNotify($s_severity,$s_func,$s_status="",$s_message="")
	If $_IEErrorNotify Or $__IEAU3Debug Then
		Local $sStr="--> IE.au3 "&$s_severity&" from function "&$s_func
		If Not String($s_status)="" Then $sStr&=", "&$s_status
		If Not String($s_message)="" Then $sStr&=" ("&$s_message&")"
		ConsoleWrite($sStr&@CR)
	EndIf
	Return 1
EndFunc

Func _IECreateEmbedded()
	$o_object=ObjCreate("Shell.Explorer.2")
	If Not IsObj($o_object) Then
		_IEErrorNotify("Error","_IECreateEmbedded","","WebBrowser Object Creation Failed")
		SetError($_IEStatus_GeneralError)
		Return 0
	EndIf
	SetError($_IEStatus_Success)
	Return $o_object
EndFunc

Func _IENavigate(ByRef $o_object,$s_Url,$f_wait=1)
	If Not IsObj($o_object) Then
		_IEErrorNotify("Error","_IENavigate","$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType,1)
		Return 0
	EndIf
	If Not _IEIsObjType($o_object,"documentContainer") Then
		_IEErrorNotify("Error","_IENavigate","$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	$o_object.navigate($s_Url)
	If $f_wait Then
		_IELoadWait($o_object)
		SetError(@error)
		Return -1
	EndIf
	SetError($_IEStatus_Success)
	Return -1
EndFunc

Func _IELoadWait(ByRef $o_object,$i_delay=0,$i_timeout=-1)
	If Not IsObj($o_object) Then
		_IEErrorNotify("Error","_IELoadWait","$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType,1)
		Return 0
	EndIf
	If Not _IEIsObjType($o_object,"browserdom") Then
		_IEErrorNotify("Error","_IELoadWait","$_IEStatus_InvalidObjectType",ObjName($o_object))
		SetError($_IEStatus_InvalidObjectType,1)
		Return 0
	EndIf
	Local $oTemp,$f_Abort=False,$i_ErrorStatusCode=$_IEStatus_Success
	Local $_status=_IEInternalErrorHandlerRegister()
	If Not $_status Then _IEErrorNotify("Warning","_IELoadWait","Cannot register internal error handler, cannot trap COM errors","Use _IEErrorHandlerRegister() to register a user error handler")
	Local $f_NotifyStatus=__IEErrorNotify()
	__IEErrorNotify(False)
	Sleep($i_delay)
	$IELoadWaitTimer=TimerInit()
	If $i_timeout=-1 Then $i_timeout=$__IELoadWaitTimeout
	Switch ObjName($o_object)
		Case "IWebBrowser2"
			Do
				If TimerDiff($IELoadWaitTimer)>$i_timeout Then
					$i_ErrorStatusCode=$_IEStatus_LoadWaitTimeout
					$f_Abort=True
				EndIf
				Sleep(100)
			Until String($o_object.readyState)="complete" Or $o_object.readyState=4 Or $f_Abort
			Do
				If TimerDiff($IELoadWaitTimer)>$i_timeout Then
					$i_ErrorStatusCode=$_IEStatus_LoadWaitTimeout
					$f_Abort=True
				EndIf
				Sleep(100)
			Until String($o_object.document.readyState)="complete" Or $o_object.document.readyState=4 Or $f_Abort
		Case "DispHTMLWindow2"
			Do
				If @error=$_IEStatus_ComError And ($IEComErrorNumber=169  Or String($IEComErrorDescription)="Access is denied.") Then
					$i_ErrorStatusCode=$_IEStatus_AccessIsDenied
					$f_Abort=True
				EndIf
				If TimerDiff($IELoadWaitTimer)>$i_timeout Then
					$i_ErrorStatusCode=$_IEStatus_LoadWaitTimeout
					$f_Abort=True
				EndIf
				Sleep(100)
			Until String($o_object.document.readyState)="complete" Or $o_object.document.readyState=4 Or $f_Abort
			Do
				If @error=$_IEStatus_ComError And ($IEComErrorNumber=169  Or String($IEComErrorDescription)="Access is denied.") Then
					$i_ErrorStatusCode=$_IEStatus_AccessIsDenied
					$f_Abort = True
				EndIf
				If TimerDiff($IELoadWaitTimer)>$i_timeout Then
					$i_ErrorStatusCode=$_IEStatus_LoadWaitTimeout
					$f_Abort=True
				EndIf
				Sleep(100)
			Until String($o_object.top.document.readyState)="complete" Or $o_object.top.document.readyState=4 Or $f_Abort
		Case "DispHTMLDocument"
			$oTemp=$o_object.parentWindow
			Do
				If @error=$_IEStatus_ComError And ($IEComErrorNumber=169  Or String($IEComErrorDescription)="Access is denied.") Then
					$i_ErrorStatusCode=$_IEStatus_AccessIsDenied
					$f_Abort=True
				EndIf
				If TimerDiff($IELoadWaitTimer)>$i_timeout Then
					$i_ErrorStatusCode=$_IEStatus_LoadWaitTimeout
					$f_Abort=True
				EndIf
				Sleep(100)
			Until String($oTemp.document.readyState)="complete" Or $oTemp.document.readyState=4 Or $f_Abort
			Do
				If @error=$_IEStatus_ComError And ($IEComErrorNumber=169  Or String($IEComErrorDescription)="Access is denied.") Then
					$i_ErrorStatusCode=$_IEStatus_AccessIsDenied
					$f_Abort=True
				EndIf
				If TimerDiff($IELoadWaitTimer)>$i_timeout Then
					$i_ErrorStatusCode=$_IEStatus_LoadWaitTimeout
					$f_Abort=True
				EndIf
				Sleep(100)
			Until (String($oTemp.top.document.readyState) = "complete" Or $oTemp.top.document.readyState = 4 Or $f_Abort)
		Case Else
			$oTemp=$o_object.document.parentWindow
			Do
				If @error=$_IEStatus_ComError And ($IEComErrorNumber=169  Or String($IEComErrorDescription)="Access is denied.") Then
					$i_ErrorStatusCode=$_IEStatus_AccessIsDenied
					$f_Abort=True
				EndIf
				If TimerDiff($IELoadWaitTimer)>$i_timeout Then
					$i_ErrorStatusCode=$_IEStatus_LoadWaitTimeout
					$f_Abort=True
				EndIf
				Sleep(100)
			Until String($oTemp.document.readyState)="complete" Or $oTemp.document.readyState=4 Or $f_Abort
			Do
				If @error=$_IEStatus_ComError And ($IEComErrorNumber=169  Or String($IEComErrorDescription)="Access is denied.") Then
					$i_ErrorStatusCode=$_IEStatus_AccessIsDenied
					$f_Abort=True
				EndIf
				If TimerDiff($IELoadWaitTimer)>$i_timeout Then
					$i_ErrorStatusCode=$_IEStatus_LoadWaitTimeout
					$f_Abort=True
				EndIf
				Sleep(100)
			Until String($oTemp.top.document.readyState)="complete" Or $o_object.top.document.readyState=4 Or $f_Abort
	EndSwitch
	__IEErrorNotify($f_NotifyStatus)
	_IEInternalErrorHandlerDeRegister()
	Switch $i_ErrorStatusCode
		Case $_IEStatus_Success
			SetError($_IEStatus_Success)
			Return 1
		Case $_IEStatus_LoadWaitTimeout
			_IEErrorNotify("Warning","_IELoadWait","$_IEStatus_LoadWaitTimeout")
			SetError($_IEStatus_LoadWaitTimeout,3)
			Return 0
		Case $_IEStatus_AccessIsDenied
			_IEErrorNotify("Warning","_IELoadWait","$_IEStatus_AccessIsDenied","Cannot verify readyState.  Likely casue: cross-site scripting security restriction.")
			SetError($_IEStatus_AccessIsDenied)
			Return 0
		Case Else
			_IEErrorNotify("Error","_IELoadWait","$_IEStatus_GeneralError","Invalid Error Status - Notify IE.au3 developer")
			SetError($_IEStatus_GeneralError)
			Return 0
	EndSwitch
EndFunc

Func __IEErrorNotify($f_notify=-1)
	Switch Number($f_notify)
		Case (-1)
			Return $_IEErrorNotify
		Case 0
			$_IEErrorNotify=False
			Return 1
		Case 1
			$_IEErrorNotify=True
			Return 1
		Case Else
			_IEErrorNotify("Error","_IEErrorNotify","$_IEStatus_InvalidValue")
			Return 0
	EndSwitch
EndFunc

Func _IEIsObjType(ByRef $o_object,$s_type)
	If Not IsObj($o_object) Then
		SetError($_IEStatus_InvalidDataType,1)
		Return 0
	EndIf
	$_status=_IEInternalErrorHandlerRegister()
	If Not $_status Then _IEErrorNotify("Warning","internal function __IEIsObjType","Cannot register internal error handler, cannot trap COM errors","Use _IEErrorHandlerRegister() to register a user error handler")
	$f_NotifyStatus=__IEErrorNotify()
	__IEErrorNotify(False)
	Local $s_Name=String(ObjName($o_object)),$objectOK=False,$oTemp
	Switch $s_type
		Case "browserdom"
			$oTemp=$o_object.document
			If _IEIsObjType($o_object,"documentcontainer") Then
				$objectOK=True
			ElseIf _IEIsObjType($o_object,"document") Then
				$objectOK=True
			ElseIf _IEIsObjType($oTemp,"document") Then
				$objectOK=True
			EndIf
		Case "browser"
			If ($s_Name="IWebBrowser2") Or ($s_Name="IWebBrowser") Then $objectOK=True
		Case "window"
			If $s_Name="DispHTMLWindow2" Then $objectOK=True
		Case "documentContainer"
			If _IEIsObjType($o_object,"window") Or _IEIsObjType($o_object,"browser") Then $objectOK=True
		Case "document"
			If $s_Name="DispHTMLDocument" Then $objectOK=True
		Case "table"
			If $s_Name="DispHTMLTable" Then $objectOK=True
		Case "form"
			If $s_Name="DispHTMLFormElement" Then $objectOK=True
		Case "forminputelement"
			If $s_Name="DispHTMLInputElement" Or $s_Name="DispHTMLSelectElement" Or $s_Name="DispHTMLTextAreaElement" Then $objectOK=True
		Case "elementcollection"
			If $s_Name="DispHTMLElementCollection" Then $objectOK=True
		Case "formselectelement"
			If $s_Name="DispHTMLSelectElement" Then $objectOK=True
		Case Else
			SetError($_IEStatus_InvalidValue,2)
			Return 0
	EndSwitch
	__IEErrorNotify($f_NotifyStatus)
	_IEInternalErrorHandlerDeRegister()
	If $objectOK Then
		SetError($_IEStatus_Success)
		Return 1
	Else
		SetError($_IEStatus_InvalidObjectType,1)
		Return 0
	EndIf
EndFunc

Func _IEInternalErrorHandlerRegister()
	$sCurrentErrorHandler=ObjEvent("AutoIt.Error")
	If $sCurrentErrorHandler<>"" And Not IsObj($oIEErrorHandler) Then
		SetError($_IEStatus_GeneralError)
		Return 0
	EndIf
	$oIEErrorHandler=""
	$oIEErrorHandler=ObjEvent("AutoIt.Error","_IEInternalErrorHandler")
	If IsObj($oIEErrorHandler) Then
		SetError($_IEStatus_Success)
		Return 1
	Else
		SetError($_IEStatus_GeneralError)
		Return 0
	EndIf
EndFunc

Func _IEInternalErrorHandlerDeRegister()
	$oIEErrorHandler=""
	If $sIEUserErrorHandler<>"" Then
		$oIEErrorHandler=ObjEvent("AutoIt.Error",$sIEUserErrorHandler)
	EndIf
	SetError($_IEStatus_Success)
	Return 1
EndFunc

Func _Maxi()
	Do
	Until _IsPressed("01")=0
	For $i=1 To 20
		If _IsPressed("01") Then Return
		Sleep(10)
	Next
	WinSetState($RoSto,"",@SW_RESTORE)
	WinActivate($RoSto)
EndFunc

Func _Mini()
	WinSetState($RoSto,"",@SW_MINIMIZE)
EndFunc

Func _Silent()
	TrayTip($Wort[41],"..."&$Wort[42]&"...  ("&$Wort[43]&")",200,17)
	GUICtrlSetData($Target,ClipGet())
	_TranslateIt()
	If $ErrorSet=0 Then ClipPut($ResultContent)
	TrayTip($Wort[41],$Wort[33]&" !  ("&$Wort[34]&")",10,17)
	if $Default=7 Then TrayTip("° "&$Wort[41],$Wort[33]&" !  ("&$Wort[34]&")",10,17)
	If $ResultContent=$TargetContent Then TrayTip($Wort[41],$Wort[28]&"  ("&$Wort[32]&")",10,19)
	If $ErrorSet Then TrayTip($Wort[41],$Wort[28]&"  ("&$Wort[36]&")",10,19)
	If WinGetState($RoSto)<16 Then WinActivate($RoSto)
EndFunc

Func _ClipTool()
	If $ClipMode=1 Then
		$ClipMode=0
		TrayItemSetState($ClipTool,4)
	Else
		If ClipGet() Then
			$ClipMode=1
			TrayItemSetState($ClipTool,1)
		Else
			TrayTip($Wort[30],$Wort[48],10,1)
		EndIf
	EndIf	
	WinActivate($RoSto)
EndFunc

Func _About()
	MsgBox(270400,"About","Rosetta Stone v1.21        "&@LF&"© 2007  by jennico"&@LF&@LF&"Credits to:"&@LF&"Valery Ivanov"&@LF&"AzKay"&@LF&"Gary Frost")
	WinActivate($RoSto)
EndFunc

Func _HotKeySet()
	If $Default=5 Then
		HotKeySet("!o","_Ersetzen")
	Else
		HotKeySet("!r","_Ersetzen")
	EndIf
	If $Default=1 Or $Default=4 Then
		HotKeySet("!k","_Kopieren")
	Else
		HotKeySet("!c","_Kopieren")
	EndIf
	If $Default=1 Then
		HotKeySet("!l","_Loschen")
	ElseIf $Default=7 Then
		HotKeySet("!b","_Loschen")
	Else
		HotKeySet("!e","_Loschen")
	EndIf
	If $Default=1 Then
		HotKeySet("!a","_Auto")
		HotKeySet("!b","_Exit")
		HotKeySet("!¸","_TranslateIt")
		HotKeySet("!w","_Maxi")
	Else
		HotKeySet("!u","_Auto")
		HotKeySet("!i","_Exit")
		HotKeySet("!a","_TranslateIt")
		HotKeySet("!r","_Maxi")
	EndIf
	If $Default=3 Or $Default>5 Then
		HotKeySet("!d","_Help")
	Else
		HotKeySet("!h","_Help")
	EndIf	
	HotKeySet("!n","_Radio1")
	HotKeySet("!f","_Radio2")
	HotKeySet("!t","_ClipTool")
	HotKeySet("!m","_Mini")
	HotKeySet("{ENTER}","_TranslateIt")
	HotKeySet("!s","_Silent")
EndFunc

Func _HotKeyUnSet()
	HotKeySet("!a")
	If $Default=1 Then HotKeySet("!r")
	HotKeySet("!k")
	HotKeySet("!c")
	HotKeySet("!l")
	HotKeySet("!u")
	HotKeySet("!¸")
	HotKeySet("!e")
	HotKeySet("!a")
	HotKeySet("!b")
	HotKeySet("!i")
	HotKeySet("!n")
	HotKeySet("!d")
	HotKeySet("!f")	
	HotKeySet("!t")
	HotKeySet("!m")
	HotKeySet("!h")
	HotKeySet("!o")
	HotKeySet("{ENTER}")
EndFunc

Func _Auto()
	If GUICtrlRead($AutoRefresh)=1 Then
		GUICtrlSetState($AutoRefresh,$GUI_UNCHECKED)
	Else
		GUICtrlSetState($AutoRefresh,$GUI_CHECKED)
	EndIf
EndFunc

Func _Ersetzen()
	GUICtrlSetData($Target,ClipGet())
EndFunc

Func _Kopieren()
	ClipPut($ResultContent)
EndFunc

Func _Radio1()
	If GUICtrlGetState($Auswahl)=80 Then
		GUICtrlSetState($Radio1,$GUI_CHECKED)
		If GUICtrlRead($AutoRefresh)=1 Then _TranslateIt()
	EndIf
EndFunc

Func _Radio2()
	If GUICtrlGetState($Radio2)=80 Then
		GUICtrlSetState($Radio2,$GUI_CHECKED)
		If GUICtrlRead($AutoRefresh)=1 Then _TranslateIt()
	EndIf
EndFunc

Func _Abfrage()
	$a=1
	If StringInStr("0409,0809,0c09,1009,1409,1809,1c09,2009,2409,2809,2c09,3009,3409",@OSLang) Then $a=2
	If StringInStr("040c,080c,0c0c,100c,140c,180c",@OSLang) Then $a=3
	If @OSLang="0413" Or @OSLang="0813" Then $a=4
	If @OSLang="0410" Or @OSLang="0810" Then $a=5
	If @OSLang="0416" Or @OSLang="0816" Then $a=6
	If StringInStr("040a,080a,0c0a,100a,140a,180a,1c0a,200a,240a,280a,2c0a,300a,340a,380a,3c0a,400a,440a,480a,4c0a,500a",@OSLang) Then $a=7
	If @OSLang="408" Or @OSLang="0408" Then $a=8
	$b=StringSplit($Words[$a],"|")
	TraySetIcon("RosettaStone.exe")
	GUICreate(" Rosetta Stone v1.21",200,250)
	GUISetIcon("RosettaStone.exe",0)
	GUICtrlCreateGroup($b[49],10,15,180,205)
	Dim $Radio[9]
	For $i=1 To 8
		$b=StringSplit($Words[$i],"|")
		$Radio[$i]=GUICtrlCreateRadio($b[$i],30,$i*20+17,140,20)
	Next
	GUICtrlSetState($Radio[$a],$GUI_CHECKED)
	$Button=GUICtrlCreateButton("OK",60,210,80,23,$BS_DEFPUSHBUTTON)
	GUISetState()
	Do
		$msg=GUIGetMsg()
		If $Msg=$GUI_EVENT_CLOSE Then Exit
	Until $msg=$Button
	For $i=1 To 8
		If GUICtrlRead($Radio[$i])=1 Then $a=$i 
	Next
	GUIDelete()
	FileCreateShortcut(@ScriptDir&"\RosettaStone.exe",@ProgramsDir&"\Rosetta Stone","","","",@ScriptDir&"\RosettaStone.exe","",0)
	Return $a
EndFunc

Func _Sprache()
	For $i=1 To 8
		If TrayItemGetState($Idiom[$i])=65 Then $Default=$i
	Next
	$fileopen=FileOpen("RosettaStone.ini",2)
	FileWrite($fileopen,$Default)
	FileClose($fileopen)
	$Wort=StringSplit($Words[$Default],"|")
	$From=StringLeft($Words[$Default],StringInStr($Words[$Default],"d.)")+2)
	If $Default=8 Then $From=StringLeft($Words[$Default],StringInStr($Words[$Default],"Û.)")+2)
	$To=StringReplace($From,$Wort[($Default=2)+2]&"|","")
	$From=StringReplace($From,$Wort[$Default]&"|","")
	$Language=$Wort[46]
	$x=" "
	GUICtrlSetData($Lexikon,$Wort[18]&":")
	GUICtrlSetData($Auswahl,$Wort[19])
	GUICtrlSetState($Auswahl,$GUI_HIDE)
	GUICtrlSetData($Radio1,$Wort[45])
	GUICtrlSetState($Radio1,$GUI_HIDE)
	GUICtrlSetState($Radio1,$GUI_CHECKED)
	GUICtrlSetData($Radio2,"&"&$Wort[3])
	GUICtrlSetState($Radio2,$GUI_HIDE)
	GUICtrlDelete($Flag1)
	$Flag1=GUICtrlCreateCombo($Wort[$Default],94,10,95,20,BitOR($CBS_DROPDOWNLIST,$WS_VSCROLL))
	GUICtrlSetData(-1,$From,$Wort[$Default])
	GUICtrlDelete($Flag2)
	$Flag2=GUICtrlCreateCombo($Wort[($Default=2)+2],205,10,95,20,BitOR($CBS_DROPDOWNLIST,$WS_VSCROLL))
	GUICtrlSetData(-1,$To,$Wort[($Default=2)+2])
	GUICtrlSetData($AutoRefresh,$Wort[20])
	GUICtrlSetData($Output,$Wort[21]&":")
	GUICtrlSetData($Zwischen,"")
	GUICtrlSetState($Zwischen,$GUI_HIDE)
	GUICtrlSetData($Input,$Wort[22]&":")
	GUICtrlSetData($Status,$Wort[27]&": "&$Wort[23]&"...")
	GUICtrlSetData($Ersetzen,$Wort[24])
	GUICtrlSetData($Kopieren,$Wort[25])
	GUICtrlSetData($Loschen,$Wort[39])
	GUICtrlSetData($Translate,$Wort[31])
	GUICtrlSetData($Beenden,$Wort[26])
	TrayItemSetText($Maximize,$Wort[14])
	TrayItemSetText($Minimize,$Wort[15])
	TrayItemSetText($Silent,$Wort[16])
	TrayItemSetText($ClipTool,$Wort[17])
	TrayItemSetText($Sprache,$Wort[37])
	For $i=1 To 7
		$a=StringSplit($Words[$i],"|")
		TrayItemSetText($Idiom[$i],$a[$i])
	Next
	TrayItemSetText($Hilfe,$Wort[44])
	TrayItemSetText($About,$Wort[38])
	TrayItemSetText($Exit,$Wort[26])
	_HotKeyUnSet()
	WinActivate($RoSto)
EndFunc

Func _Help()
	$Text=@CRLF&'0. Introduction To Rosetta Stone'
	$Text&=@CRLF&'=========================='
	$Text&=@CRLF&@CRLF&'Rosetta Stone is an online translation tool with advanced, very comfortabel features. It is able to translate texts of nearly any size (in fact there seems to be a limit) from 13 languages to 13 languages with astonishing grammatical abilities.'
	$Text&=@CRLF&@CRLF&'Rosetta Stone v1.21 now supports eight interface languages: German, English, French, Dutch, Italian, Portuguese, Spanish, Greek'
	$Text&=@CRLF&@CRLF&'Although AutoIt does not (yet) support Unicode or non-Latin characters Rosetta Stone v1.21 now is able to diplay results in Russian, Greek, Japanese, Korean and Chinese characters. If you want use this feature you have to install the Asian language support from the WinXP CD (Control Panel -> Region Settings -> Languages).'
	$Text&=@CRLF&@CRLF&'Rosetta Stone allows you to translate entire texts "on the fly" by reading and writing to the clipboard in "silent mode" (without the interface).'
	$Text&=@CRLF&@CRLF&'Have fun !'
	$Text&=@CRLF&@CRLF&@CRLF&'1. The Graphical User Interface'
	$Text&=@CRLF&'========================='
	$Text&=@CRLF&@CRLF&'Be sure to enter your texts orthographically correct or you will receive really weird translations !'
	$Text&=@CRLF&@CRLF&'You can select out of 13 input and 13 output languages. Some combinations cannot be translated directly. Rosetta Stone then will automatically use a "transit" language and will give you a choice in case that there are several options. Usually English will be the better transit language, but in some cases you can select French instead and compare the significance of the translations (Radio buttons).'
	$Text&=@CRLF&@CRLF&'On typing text be aware not to use the Return button, because Return initializes the translation.'
	$Text&=@CRLF&@CRLF&' ó   Checkbox "Automatic" : => forces Rosetta Stone to translate the input text immediately on change of result or transit language without using the translate button.'
	$Text&=@CRLF&@CRLF&' ó   Button "Replace" : => exchanges the input text with clipboard text.'
	$Text&=@CRLF&@CRLF&' ó   Button "Copy" : => copies result text to clipboard. This does not work with Russian, Greek and Asian characters, but you can copy them manually.'
	$Text&=@CRLF&@CRLF&' ó   Button "Delete" : => deletes both edit box texts.'
	$Text&=@CRLF&@CRLF&' ó   Button "Translate It" : => Translate It !'
	$Text&=@CRLF&@CRLF&@CRLF&'Possible (silent) error messages:'
	$Text&=@CRLF&@CRLF&' ó  no connection to translation service: check internet connection, try again later (heavy traffic / busy ?), or text too long.'
	$Text&=@CRLF&@CRLF&' ó  no translation possible: check if you selected the wrong input language ?'
    $Text&=@CRLF&@CRLF&' ó  returns only question marks: you have to install the appropriate foreign language pack (see above).'
    $Text&=@CRLF&@CRLF&' ó  "Service not available"'
	$Text&=@CRLF&@CRLF&@CRLF&'2. The Tray functions'
	$Text&=@CRLF&'================='
	$Text&=@CRLF&@CRLF&' =   Left click on tray icon will maximize and activate Rosetta Stone.'
	$Text&=@CRLF&@CRLF&' =   Double click on on tray icon will automatically translate the clipboard content "on the fly" and in "silent mode". The translation will automatically be copied to the clipboard. This function is also available while the main window is minimized. A tooltip window and notification sound will inform you about the process result. the silent mode can be also activated by using the global hotkey "cntrl + S". This feature is extremely useful when you have to translate a text without losing focus on your work. Just mark and copy the text, activate silent mode and copy the result from the clipboard into in your text. This feature will not work with Russian, Greek and Asian characters, but you can still copy them manually from the interface.'
	$Text&=@CRLF&@CRLF&' =   Right click on tray icon opens advanced options.'
	$Text&=@CRLF&@CRLF&'	ó  Exit'
	$Text&=@CRLF&@CRLF&'	ó  About'
	$Text&=@CRLF&@CRLF&'	ó  Help (this file)'
	$Text&=@CRLF&@CRLF&'	ó  Language Selection'
	$Text&=@CRLF&@CRLF&'	ó  Show clipboard text in a tooltip window.'
	$Text&=@CRLF&@CRLF&'This will display the clipboard content neatly "line feeded" in a balloon window near the "Replace" button, so you will be enabled to manage your clipboard. the tooltip will be hidden when Rosetta Stone is not active or minimized. This function is very useful, but a little bit ugly, so i left it as an option and not as default.'
	$Text&=@CRLF&@CRLF&'	ó  Silent mode translation (see above)'
	$Text&=@CRLF&@CRLF&'	ó  Minimize Rosetta Stone'
	$Text&=@CRLF&@CRLF&'	ó  Restore ( and activate ) Rosetta Stone'
	$Text&=@CRLF&@CRLF&@CRLF&'3. Hotkeys'
	$Text&=@CRLF&'========='
	$Text&=@CRLF&@CRLF&'All functions are "hotkeyed" by "alt" + the corresponding underlined character. All hotkeys will be deactivated while Rosetta Stone is not active or minimized ( with the exception of Silent Mode "alt + s" and Restore "alt + r" (in German "alt + w"), which will be globally available ! ).'
	$Text&=@CRLF&@CRLF&@CRLF&'4. Troubleshooting'
	$Text&=@CRLF&'==============='
	$Text&=@CRLF&@CRLF&'On translating to non-Latin characters (Greek, Russian, Asian languages) the output box display might be interferred by "Microsoft Script Debugger". The corresponding process is named "vs7jit.exe". On this event confirm to open the debugger, go to Extras -> Options -> Debugger and deactivate debugging.'
	$Text&=@CRLF&@CRLF&@CRLF&'I recommend downloading the entire "RosettaStone.exe" in order to obtain a more beautiful icon than the AutoIt default one. I guarantee that the .exe does not contain malicious functions and is exactly the same as the .au3. If you doubt you can leave the .exe untouched in the same folder just using the .au3 which will retrieve the Rosetta Stone icon from the .exe.'
	$Text&=@CRLF&@CRLF&@CRLF&'peace on earth jennico'
	Global $GUI=GUICreate(" Help for Rosetta Stone v1.21  ©  2007 by jennico",400,450,-1,-1,-1)
	GUISetIcon("RosettaStone.exe",0)
	GUICtrlCreateEdit($Text,10,10,380,400,BitOR($ES_READONLY,$WS_VSCROLL))
	Global $Close=GUICtrlCreateButton("Close Help",150,420,100,21,$BS_DEFPUSHBUTTON)
		GUICtrlSetFont(-1,-1,700)	
	GUISetState()
	$Help=1
EndFunc