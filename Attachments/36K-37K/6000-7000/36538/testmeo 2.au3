#include <GUIConstants.au3>
#Include <File.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#Include <Array.au3>
#include<Date.au3>
#include<Excel.au3>
global $hden,$mden,$hve,$mve,$tglams,$tglamc,$tglam,$hdens,$hves,$hdenc,$hvec,$i
GUICreate( "my bot", 500 , 760)
GUICtrlCreateLabel("comp1:", 0, 0, 43, 16)
$button_1 = GUICtrlCreateButton ("Start",  10, 20, 70)
$button_3 = GUICtrlCreateButton ( "rest",  250, 20, 70)
$button_2 = GUICtrlCreateButton ("Stop",  90, 20, 70 )
$button_4 = GUICtrlCreateButton ("Broken",  170, 20, 70 )
GUICtrlCreateLabel("comp2:", 0, 55, 43, 16)
$button_5 = GUICtrlCreateButton ("start",  10, 70, 70)
$button_7 = GUICtrlCreateButton ( "rest",  250, 70, 70)
$button_6 = GUICtrlCreateButton ("stop",  90, 70, 70 )
$button_8 = GUICtrlCreateButton ("Broken",  170, 70, 70 )
GUISetState ()
While 1
        $msg = GUIGetMsg() ; this checks for a message/input from the GUI.
        Select
                Case $msg = $GUI_EVENT_CLOSE 
                        Exit ; this states, on an exit event, exit the loop.
					Case $msg = $button_2
					giove()
                    case $msg = $button_1
                     gioden()
                        case $msg = $button_3
                        cophep()
						 case $msg = $button_4
                        Khongphep()
						Case $msg = $button_6
					giove1()
                    case $msg = $button_5
                     gioden1()
                        case $msg = $button_7
                        cophep1()
						 case $msg = $button_8
                        Khongphep1()
						
						EndSelect
Wend



func gioden()
   $hden= @HOUR
   $mden =@MIN
   $hden= $hden+$mden/60
   if $hden <12 Then
	  $hdens=$hden
   EndIf
    if $hden >12 Then
	  $hdenc=$hden
   EndIf
   $hdens=8 ; set for test
   $hdenc=13 ; set for test
  
EndFunc

func giove()
   $hve= @HOUR
   $mve =@MIN
   $day=@MDAY
   $hve= $hve+$mve/60
  $hves=11 ; set for test
  $hvec=17;set for test
	  $tglams= $hves - $hdens
      $tglamc = $hvec - $hdenc
	  $tglam= $tglamc + $tglams
 $sFilePath1 = "test.xls" 
$oExcel = _ExcelBookOpen($sFilePath1,0)
   _ExcelWriteCell($oExcel, $tglam, $day, 5) ;Write to the Cell
   _ExcelBookClose($oExcel)
EndFunc

func khongphep()
   $day=@MDAY
    $sFilePath1 = "test.xls" 
$oExcel = _ExcelBookOpen($sFilePath1,0)
   _ExcelWriteCell($oExcel, 0 , $day, 5) ;Write to the Cell
   _ExcelBookClose($oExcel)
EndFunc

func cophep()
   $day=@MDAY
    $sFilePath1 = "test.xls" 
$oExcel = _ExcelBookOpen($sFilePath1,0)
   _ExcelWriteCell($oExcel, 100 , $day, 5) ;Write to the Cell
   _ExcelBookClose($oExcel)
EndFunc


func gioden1()
   $hden= @HOUR
   $mden =@MIN
   $hden= $hden+$mden/60
   if $hden <12 Then
	  $hdens=$hden
   EndIf
    if $hden >12 Then
	  $hdenc=$hden
   EndIf
   $hdens=8 ; set for test
   $hdenc=13 ; set for test
  
EndFunc

func giove1()
   $hve= @HOUR
   $mve =@MIN
   $day=@MDAY
   $hve= $hve+$mve/60
  $hves=11 ; set for test
  $hvec=17;set for test
	  $tglams= $hves - $hdens
      $tglamc = $hvec - $hdenc
	  $tglam= $tglamc + $tglams
 $sFilePath1 = "test.xls" 
$oExcel = _ExcelBookOpen($sFilePath1,0)
   _ExcelWriteCell($oExcel, $tglam, $day, 4) ;Write to the Cell
   _ExcelBookClose($oExcel)
EndFunc

func khongphep1()
   $day=@MDAY
    $sFilePath1 = "test.xls" 
$oExcel = _ExcelBookOpen($sFilePath1,0)
   _ExcelWriteCell($oExcel, 0 , $day, 4) ;Write to the Cell
   _ExcelBookClose($oExcel)
EndFunc

func cophep1()
   $day=@MDAY
    $sFilePath1 = "test.xls" 
$oExcel = _ExcelBookOpen($sFilePath1,0)
   _ExcelWriteCell($oExcel, 100 , $day, 4) ;Write to the Cell
   _ExcelBookClose($oExcel)
EndFunc