;Excel_XL_Embed.au3
;~ #include <GUIConstants.au3>
;~ #include"ExcelCom.au3"
#include"Array2D.au3"
Local $arsArray[9]
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
$arsArray[0] = '0|0|0|0|6|0|0'
$arsArray[1] = '0|0|0|0|6|0|0'
$arsArray[2] = '0|0|0|0|0|3|0'
$arsArray[3] = '0|0|2|5|0|0|0'
$arsArray[4] = '0|7|0|0|0|0|0'; else "" has strings starting at 1; base "1"
$arsArray[5] = '0|0|0|1|2|0|0'
$arsArray[6] = '0|0|2|5|0|0|0'
$arsArray[7] = '0|7|0|0|0|0|0'; else "" has strings starting at 1; base "1"
$arsArray[8] = '0|0|0|1|2|0|0'
$ar2_Array = _Array2DCreateFromArraySt ($arsArray)
$FileName=@ScriptDir&"\book1.xls"
;~ $XLArrayAddress=_XLArrayWrite($ar2_Array,$FileName,2,"A1",0,1)
;~ _XLClose($FileName,0,0,1)
if not FileExists($FileName) then
  Msgbox (0,"Excel File Test","Can't run this test, because it requires an Excel file in "& $FileName)
  Exit
endif
$oExcelDoc = ObjGet($FileName)  ; Get an Excel Object from an existing filename

if IsObj($oExcelDoc) then
        
    ; Create a simple GUI for our output
    GUICreate ( "Embedded ActiveX Test", 640, 580, (@DesktopWidth-640)/2, (@DesktopHeight-580)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPCHILDREN ) 
    ; Create a test File Menu
    $GUI_FileMenu   = GUICtrlCreateMenu     ("&File")
    $GUI_FileNew    = GUICtrlCreateMenuitem ("&New"         ,$GUI_FileMenu)
    $GUI_FileRead   = GUICtrlCreateMenuitem ("&Read"        ,$GUI_FileMenu)
    $GUI_FileSave   = GUICtrlCreateMenuitem ("&Save"        ,$GUI_FileMenu)
    $GUI_FileSaveAs = GUICtrlCreateMenuitem ("Save As..."   ,$GUI_FileMenu)
    $GUI_FileSepa   = GUICtrlCreateMenuitem (""             ,$GUI_FileMenu)    ; create a separator line
    $GUI_FileExit   = GUICtrlCreateMenuitem ("E&xit"        ,$GUI_FileMenu)
    $GUI_ActiveX    = GUICtrlCreateObj    ( $oExcelDoc, 30, 90 , 400 , 300 )
    
    
    GUISetState ()       ;Show GUI
    
    $oExcelDoc.Windows(1).Activate          ; I don't think this is necessary.
    
    ; GUI Message loop
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE or $msg = $GUI_FileExit
                ExitLoop
            Case $msg = $GUI_FileRead
				$s_GUIBookName = $oExcelDoc.Application.ActiveWorkBook.fullname
				$Ar_var = $oExcelDoc.Application.activesheet.UsedRange.value
				_ArrayViewText($Ar_var, '$s_GUIBookName='&$s_GUIBookName)
            Case $msg = $GUI_FileSave
                $oExcelDoc.Save   ; Save the workbook
            Case $msg = $GUI_FileSaveAs
                $NewFileName=FileSaveDialog("Save Worksheet as",@scriptdir,"Excel Files (*.xls)")
                if not @error and $NewFileName <> "" Then
                    $oExcelDoc.SaveAs($NewFileName)  ; Save the workbook under a different name
                EndIf
                
        EndSelect
    Wend

    GUIDelete ()

    ; Don't forget to close your workbook, otherwise Excel will stay in memory after the script exits !
    $oExcelDoc.Close        ; Close the Excel workbook
    
EndIf


Exit

; This is my custom error handler
Func MyErrFunc()

  $HexNumber=hex($oMyError.number,8)

  Msgbox(0,"AutoItCOM Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
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