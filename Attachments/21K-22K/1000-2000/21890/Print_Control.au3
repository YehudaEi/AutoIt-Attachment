#include <GDIPlus.au3>
#Include <WinAPI.au3>
#include <GUIStatusBar.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <PrintWinAPI.au3>

; Initialize error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
$commdlg1=ObjCreate("mscomdlg.commondialog") 

Const $cdlPDReturnDC=256 
Const $cdlPDNoPageNums=8 
Const $cdlPDSelection=1 
Const $cdlPDAllPages=0 

$CommDlg1.Flags = $cdlPDReturnDC + $cdlPDNoPageNums 
;if $textoRTF.SelLength = 0 then
;$CommDlg1.Flags = $CommDlg1.Flags + $cdlPDAllPages 
;Else 
;$CommDlg1.Flags = $CommDlg1.Flags + $cdlPDSelection 
;EndIf 

If $CommDlg1.hdc < 0 Then Exit


;Vars
Dim $oMyError
Dim $i
Dim $j

;Declare objects
$oExcel = ObjCreate("OWC10.spreadsheet") ; Default to Office XP

If not IsObj($oExcel) Then
	$oExcel = ObjCreate("OWC11.spreadsheet") ; Office 2003	
EndIf
IF not IsObj($oExcel) Then
	$oExcel = ObjCreate("OWC9.spreadsheet") ; Office 2000
EndIf
	If IsObj($oExcel) Then
		with $oExcel
			;.Worksheets ("Sheet1").Activate
			;.activesheet.range ("A1:B10").value = "TEST INFO"
			for $i = 1 to 15
				for $j = 1 to 15
				.cells($i,$j).value = $i
				next
			next  
		EndWith
	Else
       MsgBox(0,"Reply","Not an Object",4)
EndIf
   
   ; Calculate the cels B4 & B5
   $oExcel.cells(20,1).value = "=B4+B5"
   ;MsgBox (0,"",$oExcel.cells(20,1).value)
   
   ; Set a variable to cell B5 on Sheet1.
   $rngRandomNum = $oExcel.Worksheets("Sheet1").Range("B22")
   ; Insert a formula into cell B5.
   $rngRandomNum.Formula = "=5*RAND()"

; -------------------------- GUI --------------------------------
$Form1_1 = GUICreate("Printing from AutoIt with WinAPI", 602, 650,(@DesktopWidth-602)/2, (@DesktopHeight-650)/2 , Bitor($WS_OVERLAPPEDWINDOW , $WS_VISIBLE, $WS_CLIPSIBLINGS))
$StatusBar1 = _GUICtrlStatusBar_Create($Form1_1)
_GUICtrlStatusBar_SetSimple($StatusBar1)
_GUICtrlStatusBar_SetText($StatusBar1, " Printing Status Bar Control in AU3 ")
$MyButton1 = GUICtrlCreateButton("Print Control and Export as Image ...", 10, 10, 200, 30, 0)

$hExcel = GUICtrlCreateObj ($oExcel, 10, 50 , 580 , 550)
GUICtrlSetStyle ( $hExcel, $WS_VISIBLE )
GUICtrlSetResizing ($hExcel, $GUI_DOCKAUTO)		; Auto Resize Object

GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $MyButton1
            _PrintControl_And_Export("ATL:38CAE2481","YES","YES") ; ("msctls_statusbar321","NO","YES")
    EndSwitch
WEnd


Func _PrintControl_And_Export($hControl,$sText="NO",$sExport="NO")
_GDIPlus_StartUp()

; ----------------------- Start Export ----------------------
$hWnd = ControlGetHandle("","",$hControl)
$iPos = ControlGetPos("","",$hControl)
$sControlText = ControlGetText("", "", "msctls_statusbar321") ;
ConsoleWrite( $sControlText & @CRLF)
$Width = $iPos[2]
$Height = $iPos[3]

$hDC = _WinAPI_GetDC($hWnd)
$memDC = _WinAPI_CreateCompatibleDC($hDC)
$memBmp = _WinAPI_CreateCompatibleBitmap($hDC, $Width, $Height)
_WinAPI_SelectObject ($memDC, $memBmp)

;~ Func _WinAPI_BitBlt($hDestDC, $iXDest, $iYDest, $iWidth, $iHeight, $hSrcDC, $iXSrc, $iYSrc, $iROP)
_WinAPI_BitBlt($memDC, 0, 0, $Width, $Height, $hDC, 0, 0, $SRCCOPY)

$hImage = _GDIPlus_BitmapCreateFromHBITMAP ($memBmp)

; Save Control to JPG
If $sExport = "YES" Then
_GDIPlus_ImageSaveToFile($hImage, 'status.jpg')
 EndIf

; ----------------------- Start Printing ---------------------- 
$CommDlg1.ShowPrinter 

; Get Default Printer
;$s_DefaultPrinter = _GetDefaultPrinter()   
;$s_PrinterName = InputBox("AutoIt API Printing", "Enter printer name", $s_DefaultPrinter)
;If $s_PrinterName = "" Then Exit

; Create a printer device context
$hPrintDc = $CommDlg1.hDC 	;_WinAPI_CreateDC("winspool", $s_PrinterName)
$hGraphic = _GDIPlus_GraphicsCreateFromHDC ($hPrintDc)
  
; get pixel and twips info
$PixelsPerInchY = _WinAPI_GetDeviceCaps($hPrintDc, $__WINAPCONSTANT_LOGPIXELSY); Get Pixels Per Inch Y
$TwipsPerPixelY = 1440 / $PixelsPerInchY
$PixelsPerInchX = _WinAPI_GetDeviceCaps($hPrintDc, $__WINAPCONSTANT_LOGPIXELSX); Get Pixels Per Inch X
$TwipsPerPixelX = 1440 / $PixelsPerInchX

; get page width and height
$PageWidth = _WinAPI_GetDeviceCaps($hPrintDc, $HORZRES); Get width, in millimeters, of the physical screen
$PageHeight = _WinAPI_GetDeviceCaps($hPrintDc, $VERTRES); Get height, in millimeters, of the physical screen.

; set docinfo
$s_DocName = "Printing from AutoIt with WinAPI"
$DocName = DllStructCreate("char DocName[" & StringLen($s_DocName & chr(0)) & "]")
			DllStructSetData($DocName, "DocName", $s_DocName & chr(0)); Size of DOCINFO structure
$DOCINFO = DllStructCreate($tagDOCINFO); Structure for Print Document info
			DllStructSetData($DOCINFO, "Size", 20); Size of DOCINFO structure
			DllStructSetData($DOCINFO, "DocName", DllStructGetPtr($DocName)); Set name of print job (Optional)

; start new print doc
$result = _WinAPI_StartDoc($hPrintDc, $DOCINFO)
; start new page
$result = _WinAPI_StartPage($hPrintDc)

; Print Control Text
If $sText = "YES" Then
    $hBrush = _GDIPlus_BrushCreateSolid (0x7F00007F)
    $hFormat = _GDIPlus_StringFormatCreate ()
    $hFamily = _GDIPlus_FontFamilyCreate ("Arial")
    $hFont = _GDIPlus_FontCreate ($hFamily, 12, 2)
    $tLayout = _GDIPlus_RectFCreate (50, 50, 600, 20)
    _GDIPlus_GraphicsDrawStringEx ($hGraphic, $sControlText, $hFont, $tLayout, $hFormat, $hBrush)

; Clean up resources
    _GDIPlus_FontDispose ($hFont)
    _GDIPlus_FontFamilyDispose ($hFamily)
    _GDIPlus_StringFormatDispose ($hFormat)
    _GDIPlus_BrushDispose ($hBrush)
EndIf

; Draw one image in another
; $hGraphic = _GDIPlus_ImageGetGraphicsContext ($hImage1)
    _GDIPLus_GraphicsDrawImageRect($hGraphic, $hImage, 50, 100, $Width, $Height)

; Draw a frame around the inserted image
   _GDIPlus_GraphicsDrawRect ($hGraphic, 50, 100, $Width, $Height)

; ------------------------ End of Story -----------------------
; End the page
$result = _WinAPI_EndPage($hPrintDc)

; End the print job
$result = _WinAPI_EndDoc($hPrintDc)

; Delete the printer device context
_WinAPI_DeleteDC($hPrintDc)

; End Rest of Resources
_GDIPlus_GraphicsDispose ($hGraphic)
_GDIPlus_ImageDispose ($hImage)
_WinAPI_ReleaseDC($hWnd, $hDC)
_WinAPI_DeleteDC($memDC)
_WinAPI_DeleteObject ($memBmp)

_GDIPlus_ShutDown()
EndFunc

;------------------------------ Get Default printer --------------------------------
Func _GetDefaultPrinter()
    Local $szDefPrinterName
    Local $Size
    $namesize = DllStructCreate("dword")
    DllCall("winspool.drv", "int", "GetDefaultPrinter", "str", '', "ptr", DllStructGetPtr($namesize))
    $pname = DllStructCreate("char[" & DllStructGetData($namesize, 1) & "]")
    DllCall("winspool.drv", "int", "GetDefaultPrinter", "ptr", DllStructGetPtr($pname), "ptr", DllStructGetPtr($namesize))
    Return DllStructGetData($pname, 1);msgbox(0,dllstructgetdata($namesize,1),DllStructGetData($pname,1))
EndFunc;==>GetDefaultPrinter1


;------------------------------ This is a COM Error handler --------------------------------
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"COM Error Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
			 "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
			 "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
			 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
			 "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
			 "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
			 "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
			 "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
			 "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
			)
  SetError(1)  ; to check for after this function returns
Endfunc
