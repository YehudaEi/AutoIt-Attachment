;Quick buttons by !=
;NEED IMAGEMAGICK (GPL) CONVERT.EXE, VCOMP90.DLL, MICROSOFT.VC90.OPENMP.MANIFEST IN SCRIPT FOLDER OR %PATH% ENVIROMENT VARIABLE (included)
;Coords are horizontal pos, vertical pos, horizontal size and vertical size
;Font names with no spaces, use - in names.
;Background optios are normal, radial or plasma
;Always use $BS_BITMAP in button style
;Uses _MouseHover.au3 and _PressDetect.au3 - Author: marfdaman (Marvin) Changeds to fit my needs.


#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <Misc.au3>
#include <Array.au3>
#include-once

$dll = DllOpen("user32.dll")

Local $ControlID, $Global_I = 0, $__ControlID, $HoverActive = 0, $Temp_Found = 0
Local $HoverArray[99][4]; Size fixed to manage 99 controls. Increase if necessary
Local $szTemp_Array[5]; Size changed
Local $Pressed; Mouse click
Local $ImgFolder = "GuiImgs\";Use \ at end
Local $DEBUG = 1; Make a log of images generateds
IF $DEBUG = 1 Then FileDelete("ExecCmds.txt"); Make a new log when necessary, dont fill your disks with descartable information
DirCreate($ImgFolder)
;Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui
$Main_Gui = GUICreate("Quick buttons", 600, 520,-1,-1)
IF NOT FileExists($ImgFolder&'Back.bmp') Then RunWait('convert -size 600x520 gradient:brown-black -font "Edwardian-Script-ITC" -pointsize 72 -fill gold -annotate +155+160 "Quick Buttons" -alpha off '&$ImgFolder&'back.bmp', "", @SW_HIDE)
$Background = GUICtrlCreatePic($ImgFolder&'\back.bmp', 0, 0, 600, 520)
GUICtrlSetState(-1, $GUI_DISABLE)

GuiCtrlCreateLabel('Hold "CTRL" and exit to delete all images.', 50, 20, 550, 30)
GUICtrlSetBkColor( -1, $GUI_BKCOLOR_TRANSPARENT )
Guictrlsetcolor (-1, 0xFFFFFF)
GUICtrlSetFont(-1, 18, 400, 2)



$_bttype = BitOR($BS_FLAT,$BS_CENTER,$BS_BITMAP)
;For the normal button
;name%text # horizontal,vertical,size,size # font name,size,color # background type,color1,color2
;For the focused button
;-%text # horizontal,vertical,size,size # font name,size,color # background type,color1,color2
;For the pressed button
;_%text # horizontal,vertical,size,size # font name,size,color # background type,color1,color2
$01_B = IM_Button('01_B%TST01#20%50%100%40#Arial%22%black#random%red%black', _
						'-%TST02#20%50%100%40#Arial%24%white#random%blue%black', _
						'_%TST03#20%50%100%40#Arial%26%black#random%green%black', _
						$_bttype,'button')
$02_B = IM_Button('02_B%one#30%100%80%30#garamond%18%white#random%red%black', _
						'-%two#30%100%80%30#garamond%14%black#random%blue%black', _
						'_%three#30%100%80%30#garamond%20%red#random%green%black', _
						$_bttype,'button')
$03_B = IM_Button('03_B%001#40%150%80%20#Arial%10%red#random%red%black', _
						'-%010#40%150%80%20#Arial%14%red#random%blue%black', _
						'_%100#40%150%80%20#Arial%12%red#random%green%black', _
						$_bttype,'button')
$04_B = IM_Button('04_B%11111111#50%180%100%20#verdana%10%white#random%red%black', _
						'-%2222222#50%180%100%20#verdana%14%white#random%blue%black', _
						'_%333333#50%180%100%20#verdana%12%white#random%green%black', _
						$_bttype,'button')
$05_B = IM_Button('05_B%I#60%210%80%25#tahoma%10%blue#random%red%black', _
						'-%II#60%210%80%25#tahoma%14%blue#random%blue%black', _
						'_%III#60%210%80%25#tahoma%12%blue#random%green%black', _
						$_bttype,'button')
$06_B = IM_Button('06_B%All#70%240%75%40#gigi%22%lime#random%red%black', _
					'-%About#70%240%75%40#gigi%24%white#random%blue%black', _
					'_%AutoIt#70%240%75%40#gigi%20%green#random%green%black', _
						$_bttype,'button')

$_bttype = BitOR($BS_CENTER,$BS_BITMAP)

$07_B = IM_Button('07_B%ON#60%280%90%35#Lucida-Console%18%black#random%red%black', _
						'-%OFF#60%280%90%35#Lucida-Console%18%black#random%blue%black', _
						'_%???#60%280%90%35#Lucida-Console%20%black#random%green%black', _
						$_bttype,'button')
$08_B = IM_Button('08_B%XYZ#90%320%100%40#Arial%18%white#random%red%black', _
						'-%ABC#90%320%100%40#Arial%20%white#random%blue%black', _
						'_%123#90%320%100%40#Arial%22%white#random%green%black', _
						$_bttype,'button')
;Theme
$_bttype = BitOR($BS_FLAT,$BS_BITMAP)
$ThemeStand='120%30#Arial%18%white#radial%aqua%black'
$ThemeOver='120%30#Arial-black%14%yellow#radial%blue%black'
$ThemeClick='120%30#Arial-black%16%white#radial%green%black'
$09_B = IM_Button('09_B%Super#60%370%'&$ThemeStand, _
						'-%Hyper#000%000%'&$ThemeOver, _
						'_%Mega#000%000%'&$ThemeClick, _
						$_bttype,'button')
$10_B = IM_Button('10_B%Garamond#60%410%'&$ThemeStand, _
						'-%Georgia#000%000%'&$ThemeOver, _
						'_%Eras#00%000%'&$ThemeClick, _
						$_bttype,'button')
$11_B = IM_Button('11_B%Forte#60%450%'&$ThemeStand, _
						'-%Elephant#00%000%'&$ThemeOver, _
						'_%Arial Black#00%00%'&$ThemeClick, _
						$_bttype,'button')
;Theme
$12_B = IM_Button('12_B%WAIT#130%50%80%30#Arial%20%brown#random%red%black', _
						'-%FOCUS#130%50%80%30#Arial%14%brown#random%blue%black', _
						'_%CLICKED#130%50%80%30#Arial%16%brown#random%green%black', _
						$_bttype,'button')
$13_B = IM_Button('13_B%SF#220%70%30%30#Blackadder-ITC%18%white#random%red%black', _
						'-%MK#220%70%30%30#Blackadder-ITC%18%white#random%blue%black', _
						'_%GG#220%70%30%30#Blackadder-ITC%22%white#random%green%black', _
						$_bttype,'button')

$_bttype = BitOR($BS_CENTER,$BS_BITMAP)

$normal = IM_Button('normal%normal#270%50%50%50#Arial%10%white#normal%red%black', _
						'-%normal#270%50%50%50#Arial%12%white#normal%blue%black', _
						'_%normal#270%50%50%50#Arial%14%white#normal%green%black', _
						$_bttype,'button')
$radial = IM_Button('radial%radial#330%50%50%50#Arial%10%white#radial%red%black', _
						'-%radial#330%50%50%50#Arial%14%white#radial%blue%black', _
						'_%radial#330%50%50%50#Arial%12%white#radial%green%black', _
						$_bttype,'button')
$plasma = IM_Button('plasma%plasma#390%50%50%50#Arial%10%white#plasma%red%black', _
						'-%plasma#390%50%50%50#Arial%14%white#plasma%blue%black', _
						'_%plasma#390%50%50%50#Arial%12%white#plasma%green%black', _
						$_bttype,'button')

$14_b = IM_Button('14_b%#180%200%90%30#Arial%18%brown#random%yellow%pink', _
						'-%#180%200%90%30#Arial%20%green#random%black%black', _
						'_%#180%200%90%30#garamond%20%red#random%aqua%aqua', _
						$_bttype,'button')
$15_b = IM_Button('15_b%Quick#160%250%50%50#Bodoni-MT%18%brown#plasma%lime%blue', _
						'-%and#160%250%50%50#Arial%20%green#plasma%black%black', _
						'_%Easy#160%250%50%50#garamond%20%red#plasma%aqua%aqua', _
						$_bttype,'button')
$16_b = IM_Button('16_b%COME#210%280%100%35#Arial%18%brown#plasma%yellow%yellow', _
						'-%CLICK#210%280%100%35#Arial%20%green#plasma%black%black', _
						'_%DRAG#210%280%100%35#garamond%20%red#plasma%aqua%aqua', _
						$_bttype,'button')
$anyvar = IM_Button('anyvar%Z#230%320%30%30#Georgia%28%black#radial%lime%pink', _
						'-%Y#230%320%30%30#Georgia%36%black#radial%red%yellow', _
						'_%X#230%320%30%30#Georgia%26%black#plasma%blue%aqua', _
						$_bttype,'button')
$17_B = IM_Button('17_b%unknown#190%350%90%30#verdana%18%white#radial%yellow%blue', _
						'-%device#190%350%90%30#verdana%20%green#radial%black%red', _
						'_%problem#190%350%90%30#arial%18%yellow#plasma%blue%pink', _
						$_bttype,'button')
$18_B = IM_Button('18_b%welcome#190%400%100%35#verdana%18%black#radial%brown%gray', _
						'-%home#000%000%100%35#verdana%20%white#plasma%blue%pink', _
						'_%again#000%000%100%35#arial%16%yellow#radial%black%pink', _
						$_bttype,'button')
$19_B = IM_Button('19_b%#200%450%25%25#verdana%18%white#radial%black%red', _
						'-%#000%000%25%25#verdana%24%white#radial%black%green', _
						'_%#000%000%25%25#verdana%24%yellow#radial%black%blue', _
						$_bttype,'button')
$XX01Button = IM_Button('XYZ%XXX#280%445%75%30#arial%20%black#radial%green%black', _
						'-%YYY#000%000%75%30#arial%20%white#radial%red%black', _
						'_%ZZZ#000%000%75%30#arial%20%white#radial%blue%black', _
							$_bttype)
$ExitButton = IM_Button('ExitButton%Exit#280%480%75%30#arial%20%black#radial%green%black', _
						'-%Exit#000%000%75%30#arial%20%white#radial%red%black', _
						'_%Bye#000%000%75%30#arial%20%white#radial%blue%black', _
						$_bttype,'button')


;flag Buttons
GuiCtrlCreateLabel('Button flags.', 360, 170, 550, 30)
GUICtrlSetBkColor( -1, $GUI_BKCOLOR_TRANSPARENT )
Guictrlsetcolor (-1, 0xFFFFFF)
GUICtrlSetFont(-1, 18, 400, 2,"Tahoma")
$_FlagButton01 = IM_Flag_Button('01Aflag%Q#300%205%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'manual')
$_FlagButton02 = IM_Flag_Button('01Aflag%Q#360%205%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'manual')

$_FlagButton03 = IM_Flag_Button('01Aflag%Q#420%205%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'manual')
$_FlagButton04 = IM_Flag_Button('01Aflag%Q#480%205%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'manual')
$_FlagButton05 = IM_Flag_Button('01Aflag%Q#540%205%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'manual')
$ChkFlags = IM_Button('ChkBts%Check#400%260%90%30#verdana%20%yellow#radial%purple%black', _
						'-%flag#400%260%90%30#verdana%20%yellow#radial%purple%black', _
						'_%button#400%260%90%30#verdana%20%yellow#radial%purple%black', _
						$_bttype,'button')


;Easy flag buttons
GuiCtrlCreateLabel('Auto button flags.', 360, 290, 550, 30)
GUICtrlSetBkColor( -1, $GUI_BKCOLOR_TRANSPARENT )
Guictrlsetcolor (-1, 0xFFFFFF)
GUICtrlSetFont(-1, 18, 400, 2,"Tahoma")

$01EasyFlag = IM_Flag_Button('01Aflag%Q#300%325%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'EasyFlag')
$02EasyFlag = IM_Flag_Button('02Aflag%Q#360%325%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'EasyFlag')
$03EasyFlag = IM_Flag_Button('03Aflag%Q#420%325%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'EasyFlag')
$04EasyFlag = IM_Flag_Button('04Aflag%Q#480%325%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'EasyFlag')
$05EasyFlag = IM_Flag_Button('05Aflag%Q#540%325%50%50#wingdings-3%24%yellow#radial%red%black', _
					'-%P#000%000%50%50#wingdings-3%24%white#radial%green%black', _
						'---', _
						$_bttype,'EasyFlag')
;check auto flag buttons
$ChkEasyFlags = IM_Button('ChkBts%Check#400%385%90%30#verdana%20%yellow#radial%purple%black', _
						'-%flag#400%385%90%30#verdana%20%yellow#radial%purple%black', _
						'_%button#400%385%90%30#verdana%20%yellow#radial%purple%black', _
						$_bttype,'button')


GUISetState()
;Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui-Gui

;Main loop - Main loop - Main loop - Main loop - Main loop - Main loop - Main loop - Main loop
While 1
    _ProcessHover()
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE OR $msg = $ExitButton
            If NOT @Compiled AND _IsPressed("11", $dll) Then; Delete indexed images and background
             	For $i = 0 To UBound($HoverArray)-1
					FileDelete ($ImgFolder&$HoverArray[$i][0]&'.bmp')
					FileDelete ($ImgFolder&$HoverArray[$i][0]&'-.bmp')
					FileDelete ($ImgFolder&$HoverArray[$i][0]&'_.bmp')
				Next
				FileDelete ($ImgFolder&'Back.bmp')
            EndIf
            ExitLoop
        ;flag Buttons
        Case $msg = $_FlagButton01
            ChngBtFlag($_FlagButton01)
        Case $msg = $_FlagButton02
            ChngBtFlag($_FlagButton02)
        Case $msg = $_FlagButton03
            ChngBtFlag($_FlagButton03)
        Case $msg = $_FlagButton04
            ChngBtFlag($_FlagButton04)
        Case $msg = $_FlagButton05
            ChngBtFlag($_FlagButton05)
		Case $msg = $ChkEasyFlags
            MsgBox(8192, "Values", GUICtrlRead($01EasyFlag)&"#"&GUICtrlRead($02EasyFlag)& _
            "#"&GUICtrlRead($03EasyFlag)&"#"&GUICtrlRead($04EasyFlag)&"#"&GUICtrlRead($05EasyFlag))
        Case $msg = $ChkFlags
            MsgBox(8192, "Values", GUICtrlRead($_FlagButton01)&"#"&GUICtrlRead($_FlagButton02)& _
            "#"&GUICtrlRead($_FlagButton03)&"#"&GUICtrlRead($_FlagButton04)&"#"&GUICtrlRead($_FlagButton05))
    EndSelect
WEnd
;Main loop - Main loop - Main loop - Main loop - Main loop - Main loop - Main loop - Main loop

;Functions-Functions-Functions-Functions-Functions-Functions-Functions-Functions-Functions-Functions
;################################################################################
Func _HoverAddCtrl($___ControlID,$name,$type)
	$HoverArray[$___ControlID][0]=$___ControlID
	$HoverArray[$___ControlID][1]=$name
	$HoverArray[$___ControlID][2]=$type
EndFunc
;################################################################################
Func _HoverCheck()
    $HoverData = GUIGetCursorInfo()
    If Not IsArray($HoverData) Then
		IF NOT WinActive ("Quick buttons") Then Sleep(500)
    Else
        $Temp_Found = 0
        For $i = 1 To UBound($HoverArray)-1
            If $HoverData[4] = $HoverArray[$i][0] Then
                $Temp_Found = $i
            EndIf
        Next
				$szTemp_Array[1] = $HoverArray[$Global_I][0]
				$szTemp_Array[2] = $HoverArray[$Global_I][1]
                $szTemp_Array[3] = $HoverArray[$Global_I][2]
				$szTemp_Array[4] = $HoverData[2]&$HoverData[3]
        Select
            Case $Temp_Found = 0 And $HoverActive = 1 Or $Temp_Found <> 0 And $Temp_Found <> $Global_I And $HoverActive = 1
                $HoverActive = 0
                $Temp_Found = 0
                $szTemp_Array[0] = "LostHover"

                Return $szTemp_Array
            Case $Temp_Found > 0 And $HoverActive = 0
                $Global_I = $Temp_Found
                $HoverActive = 1
                $Temp_Found = 0
                $szTemp_Array[0] = "AcquiredHover"
                $szTemp_Array[1] = $HoverArray[$Global_I][0]
				$szTemp_Array[2] = $HoverArray[$Global_I][1]
                $szTemp_Array[3] = $HoverArray[$Global_I][2]
                Return $szTemp_Array
            Case $HoverData[2] = 1 AND $Pressed = 0
                $szTemp_Array[0] = "Clicked"

                Return $szTemp_Array
            Case $HoverData[2] = 0 AND $Pressed = 1
                $szTemp_Array[0] = "UnClicked"

                Return $szTemp_Array
        EndSelect
    EndIf
EndFunc
;################################################################################
Func _ProcessHover()
    $ControlInfo = _HoverCheck()
	If IsArray($ControlInfo) Then
		;_ArrayDisplay($ControlInfo)
		If $ControlInfo[0] = "AcquiredHover" Then
			$Pressed = 0
            For $q=1 to UBound($HoverArray)-1
                Switch $ControlInfo[1]
					Case $HoverArray[$q][0]
						Select
							Case $ControlInfo[3] = 'EasyFlag';Action for any indexed EasyFlag button when focused
								IF GUICtrlRead($ControlInfo[1]) = 0 Then
									GUICtrlSetImage($ControlInfo[1], $ImgFolder&$ControlInfo[1]&"-.bmp")
									GUICtrlSetData ($ControlInfo[1], "1")
								Else
									GUICtrlSetImage($ControlInfo[1], $ImgFolder&$ControlInfo[1]&".bmp")
									GUICtrlSetData ($ControlInfo[1], "0")
								EndIf
							Case $ControlInfo[3] = 'button';Default action for any indexed button when focused
								GUICtrlSetImage ($ControlInfo[1],$ImgFolder&$ControlInfo[1]&'-.bmp',0)

						EndSelect
				EndSwitch
            Next
        EndIf
		If $ControlInfo[0] = "LostHover" Then
			$Pressed = 2
            For $q=1 to UBound($HoverArray)-1
                Switch $ControlInfo[1]
                    Case $HoverArray[$q][0]
						Select
							Case $ControlInfo[3] = 'label';Default action for any indexed label when lost focus
								Guictrlsetcolor ($ControlInfo[1], 0x000000)
								GUICtrlSetFont(-1, 8, 400, 1, "Arial")
							Case $ControlInfo[3] = 'button';Default action for any indexed button when lost focus
								GUICtrlSetImage ($ControlInfo[1],$ImgFolder&$ControlInfo[1]&'.bmp',0)
						EndSelect
                EndSwitch
            Next
		EndIf
		If $ControlInfo[0] = "Clicked" Then
			$Pressed = 1
			For $q=1 to UBound($HoverArray)-1
                Switch $ControlInfo[1]
                    Case $HoverArray[$q][0]
						Select
							Case $ControlInfo[3] = 'button';Default action for any indexed button when clicked
								GUICtrlSetImage ($ControlInfo[1],$ImgFolder&$ControlInfo[1]&'_.bmp',0)
						EndSelect
                EndSwitch
            Next
		EndIf
		If $ControlInfo[0] = "UnClicked" Then
			$Pressed = 0
            For $q=1 to UBound($HoverArray)-1
                Switch $ControlInfo[1]
                    Case $HoverArray[$q][0]
						Select
							Case $ControlInfo[3] = 'button';Default action for any indexed button when relesead
								GUICtrlSetImage ($ControlInfo[1],$ImgFolder&$ControlInfo[1]&'-.bmp',0)
						EndSelect
                EndSwitch
            Next
		EndIf
    EndIf
EndFunc
;################################################################################
Func ChngBtFlag($CtrlFlag)
    If GUICtrlRead($CtrlFlag) = 0 Then
        GUICtrlSetImage($CtrlFlag, $ImgFolder&$CtrlFlag&"-.bmp")
        GUICtrlSetData ($CtrlFlag, "1")
    Else
        GUICtrlSetImage($CtrlFlag, $ImgFolder&$CtrlFlag&".bmp")
        GUICtrlSetData ($CtrlFlag, "0")
    EndIf
EndFunc
;################################################################################
Func IM_Button($Img01='01_B%TST01#20%50%100%40#Arial%22%black#random%red%black',$Img02='-%BBB,100%100%50%30,arial%20%black,radial%blue%black',$Img03='_%BBB,100%100%50%30,arial%20%black,radial%red%black',$Options=896,$type='button')
    $01ImgArray=StringSplit ($Img01,'#' ,0)
		$01NameArray=StringSplit ($01ImgArray[1],'%' ,0)
		$01SizeArray=StringSplit ($01ImgArray[2],'%' ,0)
	$IM_B = GUICtrlCreateButton($01NameArray[1], $01SizeArray[1], $01SizeArray[2], $01SizeArray[3],$01SizeArray[4], $Options)
        _HoverAddCtrl($IM_B,$01NameArray[1],$type)
	If NOT FileExists($ImgFolder&$IM_B&'.bmp') Then
		EasyImgs($Img01,$Options)
		IF $DEBUG Then FileWriteLine("ExecCmds.txt", $ImgFolder&$01NameArray[1]&'.bmp'&' renamed to '&$ImgFolder&$IM_B&'.bmp')
		FileMove ($ImgFolder&$01NameArray[1]&'.bmp', $ImgFolder&$IM_B&'.bmp' , 1)
		IF $Img02 <> '---' Then EasyImgs($IM_B&$Img02,$Options)
		IF $Img03 <> '---' Then EasyImgs($IM_B&$Img03,$Options)
		IF $DEBUG Then FileWriteLine("ExecCmds.txt", '-+--+--'&$IM_B&'--+-'&'-+--+--'&$IM_B&'--+-'&'-+--+--'&$IM_B&'--+-'&'-+--+--'&$IM_B&'--+-'&'-+--+--'&$IM_B&'--+-')
	EndIf
	GUICtrlSetImage ($IM_B,$ImgFolder&$IM_B&'.bmp',0)
	Return $IM_B
EndFunc
;################################################################################
Func IM_Flag_Button($Img01='AAA%AAA,10%10%75%50,arial%20%black,radial%green%black',$Img02='-%BBB#100%100%75%50#Arial%22%black#radial%blue%black',$Img03='_%CCC#100%100%75%50#Arial%22%black#radial%red%black',$Options=896,$type='button')
    $01ImgArray=StringSplit ($Img01,'#' ,0)
		$01NameArray=StringSplit ($01ImgArray[1],'%' ,0)
		$01SizeArray=StringSplit ($01ImgArray[2],'%' ,0)
	$IM_B = GUICtrlCreateButton('0', $01SizeArray[1], $01SizeArray[2], $01SizeArray[3],$01SizeArray[4], $Options)
        _HoverAddCtrl($IM_B,$01NameArray[1],$type)
	If NOT FileExists($ImgFolder&$IM_B&'.bmp') Then
		EasyImgs($Img01,$Options)
		IF $DEBUG Then FileWriteLine("ExecCmds.txt", $ImgFolder&$01NameArray[1]&'.bmp'&' renamed to '&$ImgFolder&$IM_B&'.bmp')
		FileMove ($ImgFolder&$01NameArray[1]&'.bmp', $ImgFolder&$IM_B&'.bmp' , 1)
		IF $Img02 <> '---' Then EasyImgs($IM_B&$Img02,$Options)
		IF $Img03 <> '---' Then EasyImgs($IM_B&$Img03,$Options)
		IF $DEBUG Then FileWriteLine("ExecCmds.txt", '-+--+--'&$IM_B&'--+-'&'-+--+--'&$IM_B&'--+-'&'-+--+--'&$IM_B&'--+-'&'-+--+--'&$IM_B&'--+-'&'-+--+--'&$IM_B&'--+-')
	EndIf
	GUICtrlSetImage ($IM_B,$ImgFolder&$IM_B&'.bmp',0)
	Return $IM_B
EndFunc
;################################################################################
Func EasyImgs($TMPArray,$Options)
    $TMPArray=StringSplit ($TMPArray,'#' ,0)
		$NameArray=StringSplit ($TMPArray[1],'%' ,0)
		$SizeArray=StringSplit ($TMPArray[2],'%' ,0)
		$FontArray=StringSplit ($TMPArray[3],'%' ,0)
		$BackArray=StringSplit ($TMPArray[4],'%' ,0)
		$Convert = 'Convert'
		$Convert &= ' -size '&$SizeArray[3]&'X'&$SizeArray[4]
		IF $BackArray[1] = 'random' Then
			$RandType=Random(1,3,1)
			$RandColor01='rgb('&Random(0,255,1)&','&Random(0,255,1)&','&Random(0,255,1)&')'
			$RandColor02='rgb('&Random(0,255,1)&','&Random(0,255,1)&','&Random(0,255,1)&')'
			IF $RandType = 1 Then $Convert &= ' gradient:'& $RandColor01&"-"&$RandColor02
			IF $RandType = 2 Then $Convert &= ' plasma:'& $RandColor01&"-"&$RandColor02
			IF $RandType = 3 Then $Convert &= ' radial-gradient:'& $RandColor01&"-"&$RandColor02
		Else
			IF $BackArray[1] = "normal" Then $Convert &= ' gradient:'& $BackArray[2]&"-"&$BackArray[3]
			IF $BackArray[1] = "plasma" Then $Convert &= ' plasma:'& $BackArray[2]&"-"&$BackArray[3]
			IF $BackArray[1] = "radial" Then $Convert &= ' radial-gradient:'& $BackArray[2]&"-"&$BackArray[3]
		EndIf
		$Convert &= ' -font "'&$FontArray[1]&'"'&' -pointsize '&$FontArray[2]
		$Convert &= ' -fill '&$FontArray[3]
		$Convert &= ' -gravity center '
		$Convert &= ' -annotate +0+0 "'&$NameArray[2]&'"'
		$Convert &= ' -alpha off '
		$Convert &= ' "'&$ImgFolder&$NameArray[1]&'.bmp"'
		IF $DEBUG Then FileWriteLine("ExecCmds.txt", $Convert)
		$MakeImg = RunWait($Convert, "", @SW_HIDE)
EndFunc

#cs

#ce
