#include <guiconstants.au3>

Global $Current_Orig_X = 100

Global $Current_Orig_Y = 120

Global $Current_New_X = 100

Global $Current_New_Y = 120

Global $Current_Percent = 100

$MainWindow = GUICreate("Aspect Ratio Helper",200,180)

GUICtrlCreateLabel("Original Ratio:",10,10,120,15)

$Orig_X_Ratio = GUICtrlCreateInput("100",10,25,60,20,$ES_NUMBER)

$Orig_Y_Ratio = GUICtrlCreateInput("120",75,25,60,20,$ES_NUMBER)

GUICtrlCreateLabel("New Ratio:",10,60,120,15)

$New_X_Ratio = GUICtrlCreateInput("100",10,75,60,20,$ES_NUMBER)

$New_Y_Ratio = GUICtrlCreateInput("120",75,75,60,20,$ES_NUMBER)

$Set_Percent_Button = GUICtrlCreateButton("Calc Percent",10,120,80,22)

$Percent_Input = GUICtrlCreateInput("100",100,121,60,20,$ES_NUMBER)

$Info_Label = GUICtrlCreateLabel("Ready",10,160,200,15)

GUISetState(@Sw_Show)

While 1
    $msg = GuiGetMsg()
	Select			
	Case $msg = $GUI_EVENT_CLOSE
		Exit
	Case $msg = $Set_Percent_Button
		FindPercents(GUICtrlRead($Percent_Input))
	Case GUICtrlRead($Orig_X_Ratio) <> $Current_Orig_X
;~ 		GUICtrlSetData($New_X_Ratio,GUICtrlRead($Orig_X_Ratio))
        Refresh("x")
		$Current_Orig_X = GUICtrlRead($Orig_X_Ratio)
	Case GUICtrlRead($Orig_Y_Ratio) <> $Current_Orig_Y
;~ 		GUICtrlSetData($New_Y_Ratio,GUICtrlRead($Orig_Y_Ratio))
		Refresh("y")
		$Current_Orig_Y = GUICtrlRead($Orig_Y_Ratio)
	Case GUICtrlRead($New_X_Ratio) <> $Current_New_X
		Refresh("x")
		$Current_New_X = GUICtrlRead($New_X_Ratio)
	Case GUICtrlRead($New_Y_Ratio) <> $Current_New_Y
		Refresh("y")
		$Current_New_Y = GUICtrlRead($New_Y_Ratio)
		
	EndSelect
	
WEnd

Func Refresh($Base)
	If $Base = "x" Then
		$Read_X = GUICtrlRead($New_X_Ratio)
		
		$X_Percent = GUICtrlRead($Orig_X_Ratio) / $Read_X
	    
	 
		$Y_Num = GUICtrlRead($Orig_Y_Ratio) / $X_Percent
		
		GUICtrlSetData($New_Y_Ratio,Round($Y_Num,0))
		
    ElseIf $Base = "y" Then
		$Read_Y = GUICtrlRead($New_Y_Ratio)
		
		$Y_Percent = GUICtrlRead($Orig_Y_Ratio) / $Read_Y
	    
	 
		$X_Num = GUICtrlRead($Orig_X_Ratio) / $Y_Percent
		
		GUICtrlSetData($New_X_Ratio,Round($X_Num,0))
	
	
	EndIf
EndFunc

Func FindPercents($Percent)
	$Read_Org_X = GUICtrlRead($Orig_X_Ratio)
	$Read_Org_Y = GUICtrlRead($Orig_Y_Ratio)
	
    $X_Percent = $Read_Org_X * $Percent
	
	$X_Percent = $X_Percent / 100
	
	GUICtrlSetData($New_X_Ratio,Round($X_Percent,0))
	$Current_New_X = Round($X_Percent,0)
	
	$Y_Percent = $Read_Org_Y * $Percent
	
	$Y_Percent = $Y_Percent / 100
	
	GUICtrlSetData($New_Y_Ratio,Round($Y_Percent,0))
	$Current_New_Y = Round($Y_Percent,0)
	
EndFunc