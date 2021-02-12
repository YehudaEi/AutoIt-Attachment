#include <IE.au3>

_IEErrorHandlerRegister ("MyErrFunc")

;Variablen
$Username = "arnold@averhoeven.com"
$Password = "asd334"
$AdvTitel = "test"
$Conditie = "Zo goed als nieuw"
$BestemdVoor = "Jongen"
$Type = "Overige typen"
$Levering = "Ophalen of Verzenden"
$Fotopad = "C:\Users\Public\Pictures\"
$FotoFolder = "test 1"

;Inloggen op Marktplaats.nl
$oIE = _IECreate ("http://verkopen.marktplaats.nl/useradmin/mymarktplaats.php")
_IELoadWait ($oIE)
$oForm = _IEFormGetObjByName ($oIE, "dologin")
$oQuery = _IEFormElementGetObjByName ($oForm, "email")
$value = _IEFormElementSetValue($oQuery,$username)
$oQuery = _IEFormElementGetObjByName ($oForm, "password")
$value = _IEFormElementSetValue($oQuery,$Password)

;Geef inlog commando en wacht tot pagina geladen is.
$oSubmit = _IEGetObjByName ($oIE, "send")
_IEAction ($oSubmit, "click")
_IELoadWait ($oIE)

;Start plaatsen nieuwe advertentie
$oSubmit = _IEGetObjByName ($oIE, "create_ad")
_IEAction ($oSubmit, "click")
_IELoadWait ($oIE)

;Vul Groep en Rubriek in
$oDiv = _IEGetObjById ($oIE, "l1")
_ieformelementsetvalue($oDiv, "565")
_IELoadWait ($oIE)

$oDiv = _IEGetObjById ($oIE, "l2")
_ieformelementsetvalue($oDiv, "587")
_IELoadWait ($oIE)
;sleep (5000)

;Submit Groep en Rubriek en wacht op laden nieuwe pagina.
$oInputs = _IETagNameGetCollection ($oIE, "input")
For $oInput In $oInputs
	if  $oInput.type = "submit" Then
		if $oInput.value = "Verder" Then
			$oOutput = _IEAction ($oInput, "click")
			_IELoadWait ($oIE)
		EndIf
	EndIf
Next

;Vul advertentie gegevens In

;Advertentietitel

$oDiv = _IEGetObjById ($oIE, "Title")
_ieformelementsetvalue($oDiv, $AdvTitel)

;Conditie
$oDiv = _IEGetObjById ($oIE, "a1679")
Select
    Case $Conditie = "Nieuw"
         $ConditieValue = "10153"
    Case $Conditie = "Zo goed als nieuw"
         $ConditieValue = "10154"
    Case $Conditie = "gebruikt"
         $ConditieValue = "10155"
EndSelect
_ieformelementsetvalue($oDiv, $ConditieValue)

;Bestemd voor
$oDiv = _IEGetObjById ($oIE, "a2")
Select
    Case $BestemdVoor = "Jongen"
         $BestemdVoorValue = "7"
    Case $BestemdVoor = "Meisje"
         $BestemdVoorValue = "8"
    Case $BestemdVoor = "Jongen of Meisje"
         $BestemdVoorValue = "9"
EndSelect
_ieformelementsetvalue($oDiv, $BestemdVoorValue)

;Type
$oDiv = _IEGetObjById ($oIE, "a3")
Select
    Case $Type = "Broek"
         $TypeValue = "10"
    Case $Type = "Jas"
         $TypeValue = "11"
    Case $Type = "Shirt of Longsleeve"
		 $TypeValue = "12"
	Case $Type = "Trui of Vest"
		 $TypeValue = "13"
	Case $Type = "Jurk of Rok"
		 $TypeValue = "14"
	Case $Type = "Nacht- of Onderkleding"
		 $TypeValue = "15"
	Case $Type = "Overhemd of Blouse"
		 $TypeValue = "16"
	Case $Type = "Sport- of Zwemkleding"
		 $TypeValue = "17"
	Case $Type = "Setje of Pakket"
		 $TypeValue = "18"
	Case $Type = "Overige typen"
		 $TypeValue = "19"
EndSelect
_ieformelementsetvalue($oDiv, $TypeValue)

;Levering
$oDiv = _IEGetObjById ($oIE, "a1816")
Select
    Case $Levering = "Ophalen"
         $LeveringValue = "11671"
    Case $Levering = "Verzenden"
         $LeveringValue = "11672"
    Case $Levering = "Ophalen of Verzenden"
         $LeveringValue = "11673"
EndSelect
_ieformelementsetvalue($oDiv, $LeveringValue)

;Foto's Toevoegen
$oSubmit = _IEGetObjByID ($oIE, "IUBrowseBtn")
_IEAction ($oSubmit, "click")

;Script stops here. Anybody knows why????
msgbox (1,"","hoe kan dit nou")



