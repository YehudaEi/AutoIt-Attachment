
; http://www.autoitscript.com/forum/index.php?showtopic=74163

#include <Array.au3>

;nom du mod�le de tableau
$TemplateFilePath = "C:\Documents and Settings\GLEIZES\Mes documents\Auto It - VBS\Test_OOo.ods"  ; mod�le
$strFileOut = "C:\Documents and Settings\GLEIZES\Mes documents\Auto It - VBS\Test_OOo_rempli.ods" ; fichier de sauvegarde

;on cr�e l'objet aidant � la manipulation des documents OOo
$objServiceManager = ObjCreate("com.sun.star.ServiceManager")
$Stardesktop = $objServiceManager.createInstance("com.sun.star.frame.Desktop")

;Param�tre d'ouverture 
Local $OpenParam = _ArrayCreate(MakePropertyValue("Hidden", True)) ;FALSE : affichage � l'�cran, TRUE : en cach�  MARCHE PAS !

;Conversion des adresses des fichier mod�le & sauvegarde en adresse URL
$TemplateFilePathURL = Convert2URL($TemplateFilePath)
$strFileOutURL =Convert2URL($strFileOut)

;ouverture du mod�le
$TemplateFile = $Stardesktop.loadComponentFromURL($TemplateFilePathURL, "_blank", 0, $OpenParam)

;S�lection de la feuille � �crire
$oSheet = $TemplateFile.getSheets().getByIndex(0) ; selection par position
;$oSheet = $TemplateFile.getSheets().getByName("aaa") ; selection par nom

;Ecriture dans la feuille
$oSheet.getCellRangeByName("B4").setFormula("test d'�criture")

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


