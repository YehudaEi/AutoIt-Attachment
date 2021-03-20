#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <Array.au3>

#Region ### START Koda GUI section ### Form=c:\users\u053862\documents\marcel\project database pikk\form1.kxf
$Form1_1 = GUICreate("Database PIKK", 426, 522, 193, 125)
$label1 = GUICtrlCreateLabel("NAMA", 16, 24, 35, 17)
$label2 = GUICtrlCreateLabel("NO. KONTRAK", 16, 56, 78, 17)
$Label3 = GUICtrlCreateLabel(":", 112, 24, 7, 17)
$Label4 = GUICtrlCreateLabel(":", 112, 56, 7, 17)
$InputNama = GUICtrlCreateInput("", 128, 24, 169, 21)
$InputKontrak = GUICtrlCreateInput("", 128, 56, 169, 21)
$Button1 = GUICtrlCreateButton("&Search", 312, 24, 97, 25)
$Button2 = GUICtrlCreateButton("&Print", 312, 54, 97, 25)
$Group1 = GUICtrlCreateGroup(" Data Debitur ", 8, 0, 409, 137)
$Label9 = GUICtrlCreateLabel(":", 113, 91, 7, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label5 = GUICtrlCreateLabel("KONFIRMASI I", 8, 168, 76, 17)
$Input3 = GUICtrlCreateInput("", 8, 186, 401, 75)

$Label6 = GUICtrlCreateLabel("KONFIRMASI I", 8, 276, 76, 17)

$Input4 = GUICtrlCreateInput("", 8, 291, 401, 75)

$Label7 = GUICtrlCreateLabel("KONFIRMASI I", 8, 376, 76, 17)

$Input5 = GUICtrlCreateInput("", 8, 396, 401, 75)

$Update = GUICtrlCreateButton("&UPDATE", 336, 488, 73, 25)



$Label8 = GUICtrlCreateLabel("FILE CABANG", 16, 92, 73, 17)
$Input6 = GUICtrlCreateInput("", 128, 88, 169, 21)

$Button4 = GUICtrlCreateButton("&Browse", 312, 89, 97, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


While 1
	$nMsg = GUIGetMsg()
   
   Select

			;Check if user clicked on the close button
			Case $nmsg = $GUI_EVENT_CLOSE
				;Destroy the GUI including the controls
				GUIDelete()
				;Exit the script
				Exit

				;Check if user clicked on the "OK" button
			Case $nmsg = $Button1
				MsgBox(64, "New GUI", "Anda telah menekan tombol SEARCH!")

				;Check if user clicked on the "CANCEL" button
			Case $nmsg = $Button2
				MsgBox(64, "New GUI", "Anda telah menekan tombol PRINT!")
			
			Case $nmsg = $Button4
					
			   $buka = fileopendialog("Browse","C:\","Excel Document (*.Xls)")
			   guictrlsetdata($Input6,$buka)
			   
			   $Baca = guictrlread($Input6)
			   $bukaexcel = _ExcelBookOpen($Baca)
			   $bacaexcel1 = _ExcelReadCell($bukaexcel, "f2");<-membaca baris ke 3 kolom 2
			   guictrlsetdata($input3,$bacaexcel1);<-menuliskan pada input box apa yang dibaca pada $bacaexcel
			   $bacaexcel2 = _ExcelReadCell($bukaexcel, "g2");<-membaca baris ke 3 kolom 3
			   guictrlsetdata($input4,$bacaexcel2)
			   $bacaexcel3 = _ExcelReadCell($bukaexcel, "h2");<-membaca baris ke 3 kolom 7
			   guictrlsetdata($input5,$bacaexcel3)
			Case $nmsg = $Update
			   $CekBacaCell = guictrlread($InputNama)
			   ;$oExcel.Cells.Find("text",Default, $xlValues, $xlPart, $xlByRows, $xlNext).Activate

			   $bacaCell = _ExcelReadArray($CekBacaCell, 1, 1, 5,1)
			   _ArrayDisplay($bacaCell, "Vertical")
			   ;MsgBox(0, "", "Nama yang dimaksud = " & @CRLF & $bacaCell, 2)
			;	  If $bacaCell = 1 Then
			;		 MsgBox(4096, "", "ADA")
			;	  Else
			;		 MsgBox(4096, "", "Tidak ada")
			;	  EndIf

			   
			 ;  $aArray = _ExcelReadSheetToArray($bukaexcel, 1, 1) ;baca excel dari kolom 1 & baris 1
			 ;  _ArrayDisplay($aArray, "Array with Column shifting");<- mendisplay dari $aArray
			 ; _ExcelWriteCell($bukaexcel, guictrlread($input3), "f2") ;menulis tulisan yang diambil dari inputbox3 ke kolom 1,1
			 ;  _ExcelWriteCell($bukaexcel, guictrlread($Input4), "g2")
			 ;  _ExcelWriteCell($bukaexcel, guictrlread($Input5), "h2")
			 ;  _ExcelBookSave($bukaexcel)
			 ;  _ExcelBookClose($bukaexcel);<-untuk nutup excel
			 
			 
			 
			_ExcelBookClose($bukaexcel) ; And finally we close out   
	EndSelect


WEnd
