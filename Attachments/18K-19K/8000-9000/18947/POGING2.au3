#include <GUIConstants.au3>

$Form1_1 = GUICreate("VERVANGINGS MATRIX", 428, 325, 223, 115)
;GUISetIcon("D:\005.ico")
$PageControl1 = GUICtrlCreateTab(8, 8, 396, 256)

;tabblad personeel, naam kiezen, bijhorende functies
$personeel = GUICtrlCreateTabItem("PERSONEEL")
GUICtrlCreateCombo ("", 10,75,150) 
GUICtrlSetData(-1,"Dirk Ingelbrecht|Karim Ouarab|Rudy Raes|Eddy Renaut|David Samyn|Griet Tytgat|Sylvie Vanackere|Frederick Vandeweghe|Guido Vandeweghe|Bernice Vanmoerckerke|François Vanieuwenhuyse|Nico Verhelle|Jaak Vermandere|Geert Vermaut|Sammy Verstraete|Mbarek Boutahiri|Nadine Delvincourt|Touhami Gherab|Josephine Guiliana|Nina Himpe|Amandine Jouretz|Bianca Nevejant|Sabrina Ouzine|Indra Pannecoucke|Chantal Room|ALY|Nahym Ziouche|Selin Ziouche|Ann Debrouwere|Filip Feliers|Pieter Nollet|Pieter Matton|Patrick Stove|Patrick Decroos|Kathy Vanneste|Geert Callewaert")
$Label1 = GUICtrlCreateLabel("NAAM", 48, 56, 35, 17)
$Label2 = GUICtrlCreateLabel("FUNCTIES", 256, 56, 57, 17)
$Label3 = GUICtrlCreateLabel("laatste update 14/02/08", 256, 200, 157, 17)



; tabblad functies,functie uitkiezen,en nammen toewijzen
$TabSheet2 = GUICtrlCreateTabItem("FUNCTIES")
GUICtrlCreateCombo ("", 10,75,160) 
GUICtrlSetData(-1,"aanmaak gelatine|afvullen|afwasmachine|afwassen borden en terrines|branden|controle metaaldetector band 2 (CCP7)|controle metaaldetector productie (CCP3)|controle op etiketteren band 1 (CCP6)|controle op etiketteren band 2 (CCP6)|controle op etiketteren band stock (CCP6)|controle op etiketteren slices en tunnels (CCP6)|controle van klaargemaakte zendingen|controle van vacuumslices + stapeling slices|cutteren|dagelijkse orde frigo vers|decoratie paté|effectieve verzending producten|etiketteren & vepakken slices en tunnels (CCP6)|etiketteren band 1 (CCP6)|etiketteren band 2 (CCP6)|etiketteren band stock (CCP6)|instellen slicer|karren uit snelkoeler halen|met de clarck rijden|paté in snelkoeler plaatsen|paté in stoomkasten steken + instelling stoomkasten|paté op karren zetten|paté uit stoomkasten halen + kerntemperatuur meten (CCP4)|patés in stock plaatsen|patés uit stock halen|preventief onderhoud |Reiniging & Onstmetten|schrepen|sliceblokken op slicer leggen|slices in bakken steken|stapelen dozen band 1|stapelen dozen band 2|stapelen dozen band stock|supervisie afwerking (CCP5)|supervisie etiketteren (CCP 6 + 7)|supervisie productie  (CCP3)|technische dienst algemeen|temperatuur meten in snelkoeler voor decoratie (CCP5)|transport producten naar klanten (CCP 8)|vacuum verpakken|verpakking slicing + instellen dieptrek|volle paletten slices in frigo steken|voorbereiding grondstoffen|voorbereiding hulpstoffen|algemeen beleid|Backups Server|Beheer Computers|Beheer database etikettering|bestellingen opnemen|boekhouding en facturatie|Contact met klanten|Controle binnenkomende grondstoffen(CCP1, CCP2, CCP9)|Controle Reiniging & Ontsmetting|Corrigerende acties ivm Kwaliteit en/of CCP|inkoop grondstoffen / hulpstoffen en verpakkingsmateriaal|klachtenbehandeling|Kwaliteitsdienst|Lid HACCP Team|onthaal|Ontwerp + goedkeuring etiketten|Opstellen + Implementatie HACCP Plan|Opvolgen kwaliteitsysteem|Opvolgen Microbiologische Analyses|personeelsdienst|productontwikkeling|Recall|Regelen transport naar klanten in  België|Regelen transport naar klanten in buitenland|Technische fiches maken|tracering grond en hulpstoffen|transport documenten|verkoop|veterinaire documenten|Vragenlijsten Klanten")
$Label1 = GUICtrlCreateLabel("FUNCTIES", 48, 56, 60, 40)
$Label2 = GUICtrlCreateLabel("NAMEN", 256, 56, 57, 17)






;tabblad reserve (ingave ?)
$TabSheet3 = GUICtrlCreateTabItem("TabSheet3")
GUICtrlCreateTabItem("")


;knoppen
;$Button1 = GUICtrlCreateButton("&OK", 166, 272, 75, 25, 0)
$Button2 = GUICtrlCreateButton("&Stoppen", 246, 272, 75, 25, 0)
;$Button3 = GUICtrlCreateButton("&Help", 328, 272, 75, 25, 0)
GUISetState(@SW_SHOW)


;events
While 1
	$nMsg = GUIGetMsg()
	
	Switch $nMsg
		
		Case $Button2
			Exit
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
