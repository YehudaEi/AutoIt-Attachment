

#include <Excel.au3>

;;TO STOP THE SCRIPT FROM RUNNING;;
Func Terminate()
	Exit 0
EndFunc

HotKeySet("{ESC}", "Terminate")

;;;;;;;; START THE SCRIPT HERE;;;;;;;;;;;;;;;


;ACTIVATE CLIENT'S DATABASE SYSTEM (LINKS PROVIDED ON REFUND SCHEDULE);

Local $ExcelFilePath = "D:\Users\US33852\Desktop\AutoIT Scripts\Presentation\2009 Refund Spreadsheet.xlsx"
$RefundSchedule=_ExcelBookOpen($ExcelFilePath)

Local $ExcelRow = 2
Local $ExcelRow2 = 1


DO
WinActivate("Microsoft Excel - 2009 Refund Spreadsheet.xlsx")
WinWait("Microsoft Excel - 2009 Refund Spreadsheet.xlsx")

Sleep(2000)

;CLICK THE LINK TO ACCESS CLIENT'S DATABASE;

MouseClick("left",1589,813) ;Location to scroll down to next cell

$PicCapture= PixelChecksum(1053,188,1188,248)
MouseClick("left",1291,193)

;Location to click hyperlink

$Loopcounter= 0
While $PicCapture=PixelChecksum(1053,188,1188,248)
	Sleep(1000)
	$Loopcounter=$Loopcounter+1
	If $Loopcounter=5 Then
		MouseClick("left",1291,193) ;Location to click hyperlink
		$Loopcounter=0
		EndIf
	WEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;TO TAKE INTO ACCOUNT MISSING INVOICES;;;
			If WinExists("Microsoft Excel") Then
				WinActivate("Microsoft Excel")
				Send("{ENTER}")
				WinActivate("Microsoft Excel - 2009 Refund Spreadsheet.xlsx")
				WinWait("Microsoft Excel - 2009 Refund Spreadsheet.xlsx")
				_ExcelWriteCell($RefundSchedule,"Could not Pull",$ExcelRow2,12)
				Sleep(2000)
				MouseClick("left",1589,813)
				$Loopcounter= 0
				$PicCapture= PixelChecksum(1053,188,1188,248)
					While $PicCapture=PixelChecksum(1053,188,1188,248)
						Sleep(1000)
						$Loopcounter=$Loopcounter+1
							If $Loopcounter=5 Then
								MouseClick("left",1291,193) ;Location to click hyperlink
								$Loopcounter=0
							EndIf
					WEnd

			EndIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Setting window matching to any string in window;
	AutoItSetOption("WinTitleMatchMode",2)
	WinActivate("Bluebeam")
	WinWait("Bluebeam")
	Sleep(3000)

;SAVE INVOICE TO GT INVOICE FOLDER;
	send("+^s")
	WinActivate("Save File")
	WinWait("Save File")
	Sleep(2500)
	Send("{TAB 2}")
	Send("{ENTER}")

	Sleep(1500)
	MouseClick(729.180)
	Send("D:\Users\US33852\Desktop\AutoIT Scripts\Presentation\GT Invoice Folder")
	Send("{Enter}")
	Sleep(3500)
	Send("{Enter}")
	Sleep(3500)
	Send("!{ESCAPE}")

$ExcelRow = ($ExcelRow + 1)
$ExcelRow2 = ($ExcelRow2 + 1)
AutoItSetOption("WinTitleMatchMode",1)

$CellValue = _ExcelReadCell($RefundSchedule,$ExcelRow,13)


Until  $CellValue = ""


MsgBox(0,"It's Working","It's Working")
