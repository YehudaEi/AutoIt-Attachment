
; http://www.autoitscript.com/forum/index.php?showtopic=74163

#include <Array.au3>

;nom du modèle de tableau
$TemplateFilePath = "C:\Documents and Settings\GLEIZES\Mes documents\Auto It - VBS\Test_OOo.ods"  ; modèle
$strFileOut = "C:\Documents and Settings\GLEIZES\Mes documents\Auto It - VBS\Test_OOo_rempli.ods" ; fichier de sauvegarde

;on crée l'objet aidant à la manipulation des documents OOo
$objServiceManager = ObjCreate("com.sun.star.ServiceManager")
$Stardesktop = $objServiceManager.createInstance("com.sun.star.frame.Desktop")

;Paramètre d'ouverture 
Local $OpenParam = _ArrayCreate(MakePropertyValue("Hidden", True)) ;FALSE : affichage à l'écran, TRUE : en caché  MARCHE PAS !

;Conversion des adresses des fichier modèle & sauvegarde en adresse URL
$TemplateFilePathURL = Convert2URL($TemplateFilePath)
$strFileOutURL =Convert2URL($strFileOut)

;ouverture du modèle
$TemplateFile = $Stardesktop.loadComponentFromURL($TemplateFilePathURL, "_blank", 0, $OpenParam)

;Sélection de la feuille à écrire
$oSheet = $TemplateFile.getSheets().getByIndex(0) ; selection par position
;$oSheet = $TemplateFile.getSheets().getByName("aaa") ; selection par nom

;Ecriture dans la feuille
$oSheet.getCellRangeByName("B4").setFormula("test d'écriture")

;Lire des cellules
$cell = $oSheet.getCellRangeByName("A1").formula
;MsgBox(0,"",$cell)

;Sauvegarde
$oSave = _ArrayCreate(MakePropertyValue("FilterName", -1))
$TemplateFile.storeToURL($strFileOutURL,$oSave)

;Fermeture
$TemplateFile.Close(True)

Func MakePropertyValue ($cName, $uValue)
	Local $Pstruc
	$Pstruc = $objServiceManager.Bridge_GetStruct("com.sun.star.beans.PropertyValue")
	$Pstruc.Name = $cName
	$Pstruc.Value = $uValue ; ($uValue)	
	; MsgBox(0,"", $Pstruc.Value)
	Return $Pstruc
EndFunc

Func Convert2URL($fname)
    $fname = StringReplace($fname, ":", "|")
    $fname = StringReplace($fname, " ", "%20")
    $fname = "file:///" & StringReplace($fname, "\", "/")
    Return $fname
EndFunc


