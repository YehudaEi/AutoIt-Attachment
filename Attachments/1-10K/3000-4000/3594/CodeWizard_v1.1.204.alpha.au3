;===============================================================================
;
; Nom du logiciel :				CodeWizard.exe																	Non-officiel	07/2005
; Description:      			Aide à la génération de Boite de dialogue										Officiel		02/2005
;
; Parametre(s):     			/StdOut [optional - from command line]											Officiel		02/2005
; 									Copie le code AutoIt généré dans la Console ou le press-papier
; 
; Dépendance :   				Aucune																			Officiel		02/2005
; Valeurs retournée :  			Aucune																			Officiel		02/2005
; Auteur :        				Giuseppe Criaco																	Officiel		02/2005
;
; Version : 					v1.1.204.alpha																	Non-officiel	07/2005
;
; Historique : 					
; 								v1.1.204.alpha		Optimisation du INIREAD										Non-officiel	07/2005
; 													Extériorisation des commentaires 
; 														avec stockage dans le fichier INI en INIREAD
; 								v1.1.203.alpha		Extériorisation de la francisation							Officiel		07/2005
; 													Suppression des commentaires
; 													Suppression des #Region
; 								v1.1.202.alpha		Correction de l'interface pour la francisation				Non-officiel	07/2005
; 													Adaptation du design
;								v1.1.201.alpha		Francisation de l'interface									Non-officiel	07/2005
;													Suppression des paramètres régionnaux						
; 								v1.1.1				Correction de problèmes										Officiel		02/2005
; 													Quitte le script après la copie - Ajout								
; 								v1.1.				Correction de problèmes										Officiel		02/2005
; 													Information de ressources ajoutées							
; 													Région ... EndRegion ajoutés sur Fin de Ligne				
; 								v1.0 				Version initiale											Officiel		02/2005
; 


#NoTrayIcon
#include <GUIConstants.au3>
#include <Constants.au3>

Global $iMFlag, $Button, $sMsgBox, $asMsgText, $sOutType, $sMText, $sIPwdChr, $sIWidth, $sIHeight, $sILeft, $sITop, $sInputBox, _
   $asIPromptText, $sIPrompt, $sMFlag, $sMComment, $Version, $Lang, $IniFile
   
$IniFile = "codewizard.ini"
$Lang = IniRead($IniFile, "setting", "Lang", "")
$Version = IniRead($IniFile, "setting", "Ver", "")


$sOutType = "ClipBoard"
If $CmdLine[0] = 1 Then
   If $CmdLine[1] = "/StdOut" Then
	  $sOutType = "Console"
   EndIf
EndIf

GUICreate(IniRead($IniFile, "setting", "Name", "") & " " & $Version, 460, 540, -1, -1, $WS_POPUP + $WS_BORDER)

$tab = GUICtrlCreateTab (10, 5, 440, 495) ; will create a Tab object
	GUICtrlSetFont(-1, 8, -1, -1, "Tahoma")

;MessageBox Tab Item Objects ---------------------------------------------------------------------------------------
$tabMsgBox = GUICtrlCreateTabitem (IniRead($IniFile, $Lang, "tabMsgBox", ""))
	GUICtrlSetFont(-1, 8, -1, -1, "Tahoma")

;Text Group
GUICtrlCreateGroup(IniRead($IniFile, $Lang, "Group1", ""), 20, 40, 205, 65)
$txtMTitle = GUICtrlCreateInput("", 30, 70, 185, 20)
	GUICtrlSetState ( -1, $GUI_FOCUS)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsGroup1", ""))
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateLabel(IniRead($IniFile, $Lang, "Label1Group1", ""), 20, 120, 30)
$txtMText = GUICtrlCreateEdit("", 20, 135, 420, 70, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "Tips1Group1", ""))

;Icons Group
GUICtrlCreateGroup(IniRead($IniFile, $Lang, "IconGroup", ""), 235, 40, 205, 65)
$chkMWarning = GUICtrlCreateCheckbox ("", 255, 55, 40, 40, $BS_PUSHLIKE+$BS_ICON)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "IconAttention", ""))
	GUICtrlSetImage (-1, "user32.dll",1)
$chkMQuestion = GUICtrlCreateCheckbox ("", 295, 55, 40, 40, $BS_PUSHLIKE+$BS_ICON)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "IconInformation", ""))
	GUICtrlSetImage (-1, "user32.dll", 2)
$chkMCritical = GUICtrlCreateCheckbox ("", 335, 55, 40, 40, $BS_PUSHLIKE+$BS_ICON)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "IconCritical", ""))
	GUICtrlSetImage (-1, "user32.dll", 3)
$chkMInfo = GUICtrlCreateCheckbox ("", 375, 55, 40, 40, $BS_PUSHLIKE+$BS_ICON)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "IconCritical", ""))
	GUICtrlSetImage (-1, "user32.dll", 4)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Options Group
GUICtrlCreateGroup(IniRead($IniFile, $Lang, "OptionGroup", ""), 235, 320, 205, 70)
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "OptionDelai", ""), 245, 345, 40, 20)
$txtMTimeout = GUICtrlCreateInput("", 245, 360, 70, 20, $ES_NUMBER)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsOptionDelai", ""))
$chkMConstants = GUICtrlCreateCheckbox(IniRead($IniFile, $Lang, "CheckBoxConstant", ""),330, 362, 90)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsCheckBoxConstant", ""))
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Buttons 
GUICtrlCreateGroup(IniRead($IniFile, $Lang, "ButtonGroup", ""), 20, 220, 205, 170)
$optMOK = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "RadioBtOK", ""), 30, 240, 100, 20, $BS_FLAT)
	GUICtrlSetState(-1, $GUI_CHECKED)
$optMYesNo = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "RadioBtYN", ""), 30, 260, 100, 20, $BS_FLAT)
$optMOKCancel = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "RadioBtOA", ""), 30, 280, 100, 20, $BS_FLAT)
$optMYesNoCancel = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "RadioBtYNC", ""), 30, 300, 105, 20, $BS_FLAT)
$optMAbortRetryIgnore = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "RadioBtARI", ""), 30, 320, 180, 20, $BS_FLAT)
$optMRetryCancel = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "RadioBtRA", ""), 30, 340, 110, 20, $BS_FLAT)
$optMCancelTryContinue = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "RadioBtARC", ""), 30, 360, 180, 20, $BS_FLAT)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Modality Group
GUICtrlCreateGroup(IniRead($IniFile, $Lang, "ModalityGroup", ""), 20, 400, 205, 90)
$optApplication = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "ModalApplication", ""), 30, 420, 100, 20, $BS_FLAT)
	GUICtrlSetState(-1, $GUI_CHECKED)
$optMSysModal = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "ModalSystem", ""), 30, 440, 100, 20, $BS_FLAT)
$optMTaskModal = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "ModalTask", ""), 30, 460, 100, 20, $BS_FLAT)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Miscellaneous Group
GUICtrlCreateGroup(IniRead($IniFile, $Lang, "MiscGroup", ""),235, 400, 205, 90)
$chkMTopMost = GUICtrlCreateCheckbox(IniRead($IniFile, $Lang, "AttrTopMost", ""), 245, 425, 140, 20)
$chkMRightJust = GUICtrlCreateCheckbox(IniRead($IniFile, $Lang, "AttrAlignRight", ""), 245, 455, 170, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Default buttons Group
GUICtrlCreateGroup(IniRead($IniFile, $Lang, "DefBtGroup", ""), 235, 220, 205, 90)
$optMFirst = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "FirstBt", ""), 245, 240, 130, 20, $BS_FLAT)
	GUICtrlSetState(-1, $GUI_CHECKED)
$optMSecond = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "SecBt", ""), 245, 260, 130, 20, $BS_FLAT)
	GUICtrlSetState(-1, $GUI_DISABLE)
$optMThird = GUICtrlCreateRadio(IniRead($IniFile, $Lang, "ThiBt", ""), 245, 280, 130, 20, $BS_FLAT)
	GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlSetState ( $txtMTitle, $GUI_FOCUS)

GUICtrlCreateTabitem ("")    ; end tabitem definition

;InputBox Tab Item Objects -----------------------------------------------------------------------------------------
$tabInputBox = GUICtrlCreateTabitem (IniRead($IniFile, $Lang, "tabInputBox", ""))

; Text Objects
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "Group1", ""), 20, 60, 30)
$txtITitle = GUICtrlCreateInput("", 20, 75, 420, 20)
	GUICtrlSetState ( -1, $GUI_FOCUS)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsGroup1a", ""))
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "Label1Group1a", ""), 20, 120, 50)
$txtIPrompt = GUICtrlCreateEdit("", 20, 135, 420, 70, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsLabel1Group1a", ""))
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "DefTxt", ""), 20, 230, 100)
$txtIDefault = GUICtrlCreateInput("", 20, 245, 420, 20)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsDefTxt", ""))

;Options Group
GUICtrlCreateGroup(IniRead($IniFile, $Lang, "OptionGroup2", ""), 20, 290, 420, 70)
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "EntryLong", ""), 30, 310, 100)
$txtIChrLen = GUICtrlCreateInput("", 30, 325, 70, 20, $ES_NUMBER)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsEntryLong", ""))
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "ChrPwd", ""), 140, 310, 100)
$txtIPwdChr = GUICtrlCreateInput("", 140, 325, 70, 20)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsChrPwd", ""))
	GuiCtrlSetLimit($txtIPwdChr, 1, 0)
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "OptionDelai", ""), 250, 310, 100)
$txtITimeOut = GUICtrlCreateInput("", 250, 325, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsOptionDelai2", ""))
$chkIMandatory = GUICtrlCreateCheckbox (IniRead($IniFile, $Lang, "Manda", ""), 350,325, 75, 20)
GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsManda", ""))
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Position Group
GUICtrlCreateGroup(IniRead($IniFile, $Lang, "PosGroup", ""), 20, 390, 420, 70)
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "Width", ""), 30, 410, 100)
$txtIWidth = GUICtrlCreateInput("", 30, 425, 70, 20, $ES_NUMBER)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsWidth", ""))
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "Heigth", ""), 140, 410, 100)
$txtIHeight = GUICtrlCreateInput("", 140, 425, 70, 20, $ES_NUMBER)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsHeigth", ""))
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "Left", ""), 250, 410, 100)
$txtILeft = GUICtrlCreateInput("", 250, 425, 70, 20, $ES_NUMBER)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsLeft", ""))
GUICtrlCreateLabel(IniRead($IniFile, $Lang, "Top", ""), 360, 410, 60)
$txtITop = GUICtrlCreateInput("", 360, 425, 70, 20, $ES_NUMBER)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsTop", ""))
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateTabitem ("")    ; end tabitem definition

;Buttons ------------------------------------------------------------------------------------------------------------
$btnPreview = GUICtrlCreateButton(IniRead($IniFile, $Lang, "bt_Preview", ""), 10, 510, 100, 20, $BS_FLAT)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "Tipsbt_Preview", ""))
$btnCopy = GUICtrlCreateButton(IniRead($IniFile, $Lang, "bt_Copy", ""), 120, 510, 100, 20, $BS_FLAT)
If $sOutType = IniRead($IniFile, $Lang, "InfoConsole", "Console") Then ; Laisser par défaut la valeur Console
   GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "TipsInfoConsole", ""))
Else
   GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "OtherTips", ""))
EndIf
$btnExit = GUICtrlCreateButton(IniRead($IniFile, $Lang, "bt_Quiet", ""), 230, 510, 100, 20, $BS_FLAT)
	GUICtrlSetTip(-1, IniRead($IniFile, $Lang, "Tipsbt_Quiet", ""))
$Button = $optMOK

GuiSetState ()

; Run the GUI until the dialog is closed
While 1
   $msg = GUIGetMsg()
    
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $btnExit
		 Exit
      
	  Case Else
		 If GUICtrlRead($tab) = 0 Then
			_MsgBoxMgt($msg)	;MessageBox Wizard
		 Else
			_InputBoxMgt($msg)	;InputBox Wizard
		 EndIf
		 
   EndSelect
   
Wend

Func _MsgBoxMgt($msg)
   Select
	  Case $msg = $chkMWarning
		 GUICtrlSetState($chkMQuestion, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMCritical, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMInfo, $GUI_UNCHECKED)
	  
	  Case $msg = $chkMQuestion
		 GUICtrlSetState($chkMWarning, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMCritical, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMInfo, $GUI_UNCHECKED)
	  
	  Case $msg = $chkMCritical
		 GUICtrlSetState($chkMWarning, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMQuestion, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMInfo, $GUI_UNCHECKED)
	  
	  Case $msg = $chkMInfo
		 GUICtrlSetState($chkMWarning, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMQuestion, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMCritical, $GUI_UNCHECKED)
	  
      Case $msg = $optMOK
         $Button = $optMOK
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_DISABLE)
         GUICtrlSetState($optMThird, $GUI_DISABLE)
         
      Case $msg = $optMOkCancel
         $Button = $optMOkCancel
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_DISABLE)
         
      Case $msg = $optMYesNo
         $Button = $optMYesNo
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_DISABLE)
         
      Case $msg = $optMYesNoCancel
         $Button = $optMYesNoCancel
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_ENABLE)
         
      Case $msg = $optMAbortRetryIgnore
         $Button = $optMAbortRetryIgnore
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_ENABLE)
         
      Case $msg = $optMRetryCancel
         $Button = $optMRetryCancel
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_DISABLE)
         
      Case $msg = $optMCancelTryContinue
         $Button = $optMCancelTryContinue
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_ENABLE)
         
      Case $msg = $btnPreview						;Preview Button
         MsgBox(_SetFlag(), GUICtrlRead($txtMTitle), GUICtrlRead($txtMText), GUICtrlRead($txtMTimeout))
  
      Case $msg = $btnCopy							;Copy Button
         $asMsgText = StringSplit(GUICtrlRead($txtMText), @CRLF, 1)
         If $asMsgText[0] = 1 Then
            $sMText = GUICtrlRead($txtMText)
         Else
            $sText = $asMsgText[1]
            
            For $iCtr = 2 To $asMsgText[0]
               $sMText = $sMText & Chr(34) & " & @CRLF & " & Chr(34) & $asMsgText[$iCtr]
            Next
            
         EndIf
		 
		 $sMComment = ""
         
		 Select
            Case $Button = $optMOK
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox =  "MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 " & "; " & IniRead($IniFile, $Lang, "InfoOptionDelai", "") & " " & GUICtrlRead($txtMTimeOut)  & @CRLF & @CRLF & _
                        "   Case Else                " & "; " & IniRead($IniFile, $Lang, "RadioBtOK", "") & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
               
            Case $Button = $optMOkCancel
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 1 " & "; " & IniRead($IniFile, $Lang, "RadioBtOK", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 " & "; " & IniRead($IniFile, $Lang, "Info1", "") & @CRLF & @CRLF & _
                        "EndSelect"            
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 1 " & "; " & IniRead($IniFile, $Lang, "RadioBtOK", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 " & "; " & IniRead($IniFile, $Lang, "Info1", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 " & "; " & IniRead($IniFile, $Lang, "InfoOptionDelai", "") & " " & GUICtrlRead($txtMTimeOut) & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
               
            Case $Button = $optMYesNo
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 " & "; " & IniRead($IniFile, $Lang, "Info2", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 " & "; " & IniRead($IniFile, $Lang, "Info3", "") & @CRLF & @CRLF & _
                        "EndSelect"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 " & "; " & IniRead($IniFile, $Lang, "Info2", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 " & "; " & IniRead($IniFile, $Lang, "Info3", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 " & "; " & IniRead($IniFile, $Lang, "InfoOptionDelai", "") & " " & GUICtrlRead($txtMTimeOut) & @CRLF & @CRLF & _
                        "EndSelect"
               EndIf
               
            Case $Button = $optMYesNoCancel
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 " & "; " & IniRead($IniFile, $Lang, "Info2", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 " & "; " & IniRead($IniFile, $Lang, "Info3", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 " & "; " & IniRead($IniFile, $Lang, "Info1", "") & @CRLF & @CRLF & _
                        "EndSelect"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 " & "; " & IniRead($IniFile, $Lang, "Info2", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 " & "; " & IniRead($IniFile, $Lang, "Info3", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 " & "; " & IniRead($IniFile, $Lang, "Info1", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 " & "; " & IniRead($IniFile, $Lang, "InfoOptionDelai", "") & " " & GUICtrlRead($txtMTimeOut) & @CRLF & @CRLF & _
                        "EndSelect"
               EndIf
               
            Case $Button = $optMAbortRetryIgnore
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 3 " & "; " & IniRead($IniFile, $Lang, "InfoAbort", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 " & "; " & IniRead($IniFile, $Lang, "InfoRetry", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 5 " & "; " & IniRead($IniFile, $Lang, "InfoIgnore", "") & @CRLF & @CRLF & _
                        "EndSelect"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 3 " & "; " & IniRead($IniFile, $Lang, "InfoAbort", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 " & "; " & IniRead($IniFile, $Lang, "InfoRetry", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 5 " & "; " & IniRead($IniFile, $Lang, "InfoIgnore", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 " & "; " & IniRead($IniFile, $Lang, "InfoOptionDelai", "") & " " & GUICtrlRead($txtMTimeOut) & @CRLF & @CRLF & _
                        "EndSelect"
               EndIf
               
            Case $Button = $optMRetryCancel
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 " & "; " & IniRead($IniFile, $Lang, "InfoRetry", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 " & "; " & IniRead($IniFile, $Lang, "Info1", "") & @CRLF & @CRLF & _
                        "EndSelect"            
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 " & "; " & IniRead($IniFile, $Lang, "InfoRetry", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 " & "; " & IniRead($IniFile, $Lang, "Info1", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 " & "; " & IniRead($IniFile, $Lang, "InfoOptionDelai", "") & " " & GUICtrlRead($txtMTimeOut) & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
               
            Case $Button = $optMCancelTryContinue
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 " & "; " & IniRead($IniFile, $Lang, "Info1", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 10 " & "; " & IniRead($IniFile, $Lang, "InfoTryAgain", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 11 " & "; " & IniRead($IniFile, $Lang, "InfoContinue", "") & @CRLF & @CRLF & _
                        "EndSelect"            
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2  " & "; " & IniRead($IniFile, $Lang, "Info1", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 10 " & "; " & IniRead($IniFile, $Lang, "InfoTryAgain", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 11 " & "; " & IniRead($IniFile, $Lang, "InfoContinue", "") & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 " & "; " & IniRead($IniFile, $Lang, "InfoOptionDelai", "") & " " & GUICtrlRead($txtMTimeOut) & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
         EndSelect

		 If GUICtrlRead($chkMConstants) = $GUI_CHECKED Then
			$sMsgBox = "#include <Constants.au3>" & @CRLF & @CRLF & $sMsgBox
			$sMsgBox = StringReplace($sMsgBox, "1 ;OK", "$IDOK")
			$sMsgBox = StringReplace($sMsgBox, "2 " & "; " & IniRead($IniFile, $Lang, "Info1", ""), "$IDCANCEL")
			$sMsgBox = StringReplace($sMsgBox, "3 " & "; " & IniRead($IniFile, $Lang, "InfoAbort", ""), "$IDABORT")
			$sMsgBox = StringReplace($sMsgBox, "4 " & "; " & IniRead($IniFile, $Lang, "InfoRetry", ""), "$IDRETRY")
			$sMsgBox = StringReplace($sMsgBox, "5 " & "; " & IniRead($IniFile, $Lang, "InfoIgnore", ""), "$IDIGNORE")			
			$sMsgBox = StringReplace($sMsgBox, "6 " & "; " & IniRead($IniFile, $Lang, "Info2", ""), "$IDYES")
			$sMsgBox = StringReplace($sMsgBox, "7 " & "; " & IniRead($IniFile, $Lang, "Info3", ""), "$IDNO")

		 EndIf

		 $sMsgBox = _MComments() & $sMsgBox	& @CRLF & "#EndRegion --- CodeWizard generated code End ---" & @CRLF ;Comment string with MessageBox features

		 If $sOutType = "Console" Then
			ConsoleWrite(StringReplace($sMsgBox, @CRLF, @LF)) 
			Exit
		 Else
			ClipPut($sMsgBox)
		 Endif
   EndSelect
EndFunc   

Func _InputBoxMgt($msg)
   Select
      Case $msg = $btnPreview
		 _Position()
         InputBox(GUICtrlRead($txtITitle), GUICtrlRead($txtIPrompt), GUICtrlRead($txtIDefault), _PwdChr(), _
			$sIWidth, $sIHeight, $sILeft, $sITop, GUICtrlRead($txtITimeOut))
		 
      Case $msg = $btnCopy
		_Position()
		_PwdChr()
         $asIPromptText = StringSplit(GUICtrlRead($txtIPrompt), @CRLF, 1)
         If $asIPromptText[0] = 1 Then
            $sIPrompt = GUICtrlRead($txtIPrompt)
         Else
            $sIPrompt = $asIPromptText[1]
            
            For $iCtr = 2 To $asIPromptText[0]
               $sIPrompt = $sIPrompt & Chr(34) & " & @CRLF & " & Chr(34) & $asIPromptText[$iCtr]
            Next
            
         EndIf
		 
		 _IComments()	;Comment string with InputBox features
		 
		 If GUICtrlRead($txtITimeout) = "" Then
			$sInputBox = $sInputBox & "Dim $iInputBoxAnswer" & @CRLF & _
			   "$iInputBoxAnswer = InputBox(" & Chr(34) & GUICtrlRead($txtITitle) & Chr(34) & "," & Chr(34) & $sIPrompt _
			   & Chr(34) & ","  & Chr(34) & GUICtrlRead($txtIDefault) & Chr(34) & "," & Chr(34) & $sIPwdChr & Chr(34) & "," & _
			   Chr(34) & $sIWidth & Chr(34) &  "," & Chr(34) & $sIHeight & Chr(34) & "," & Chr(34) & $sILeft & Chr(34) & "," _
			   & Chr(34) & $sITop & Chr(34) & ")" & @CRLF & _
			   "Select" & @CRLF & _
			   "   Case @Error = 0 " & "; " & IniRead($IniFile, $Lang, "InfoReturnOK", "") & @CRLF & @CRLF & _
			   "   Case @Error = 1 " & "; " & IniRead($IniFile, $Lang, "InfoReturnCancel", "") & @CRLF & @CRLF & _
			   "   Case @Error = 3 " & "; " & IniRead($IniFile, $Lang, "InfoFailedInput", "") & @CRLF & @CRLF & _
			   "EndSelect"            
		 Else   
			$sInputBox = $sInputBox & "Dim $iInputBoxAnswer" & @CRLF & _
			   "$iInputBoxAnswer = InputBox(" & Chr(34) & GUICtrlRead($txtITitle) & Chr(34) & "," & Chr(34) & $sIPrompt _
			   & Chr(34) & ","  & Chr(34) & GUICtrlRead($txtIDefault) & Chr(34) & "," & Chr(34) & $sIPwdChr & Chr(34) & "," & _
			   Chr(34) & $sIWidth & Chr(34) &  "," & Chr(34) & $sIHeight & Chr(34) & "," & Chr(34) & $sILeft & Chr(34) & "," _
			   & Chr(34) & $sITop & Chr(34) & "," & Chr(34) & GUICtrlRead($txtITimeOut) & Chr(34) & ")" & @CRLF & _
			   "Select" & @CRLF & _
			   "   Case @Error = 0 " & "; " & IniRead($IniFile, $Lang, "InfoReturnOK", "") & @CRLF & @CRLF & _
			   "   Case @Error = 1 " & "; " & IniRead($IniFile, $Lang, "InfoReturnCancel", "") & @CRLF & @CRLF & _
			   "   Case @Error = 2 " & "; " & IniRead($IniFile, $Lang, "InfoReturnTimeOut", "") & @CRLF & @CRLF & _
			   "   Case @Error = 3 " & "; " & IniRead($IniFile, $Lang, "InfoFailedInput", "") & @CRLF & @CRLF & _
			   "EndSelect"            
		 EndIf
		 
		 $sInputBox = $sInputBox & @CRLF & "#EndRegion --- CodeWizard generated code End ---" & @CRLF
		 
		 If $sOutType = "Console" Then
			ConsoleWrite(StringReplace($sInputBox, @CRLF, @LF)) 
			Exit
		 Else
			ClipPut($sInputBox)
		 Endif
   
   EndSelect
   
EndFunc   
		 
Func _SetFlag()
   ;Buttons
   $sMComment = $sMComment & " Buttons="

   Select
      Case GUICtrlRead($optMOkCancel) = $GUI_CHECKED			; Two push buttons: OK and Cancel
         $iMFlag = 1
		 $sMFlag = "$MB_OKCANCEL"
		 $sMComment = $sMComment & "OK and Cancel,"
      Case GUICtrlRead($optMYesNo) = $GUI_CHECKED				; Two push buttons: Yes and No
         $iMFlag = 4
		 $sMFlag = "$MB_YESNO"
		 $sMComment = $sMComment & "Yes and No,"
      Case GUICtrlRead($optMYesNoCancel) = $GUI_CHECKED			; Three push buttons: Yes, No, and Cancel
         $iMFlag = 3
		 $sMFlag = "$MB_YESNOCANCEL"
		 $sMComment = $sMComment & "Yes, No, and Cancel,"
      Case GUICtrlRead($optMAbortRetryIgnore) = $GUI_CHECKED	; Three push buttons: Abort, Retry, and Ignore	
         $iMFlag = 2
		 $sMFlag = "$MB_ABORTRETRYIGNORE"		
		 $sMComment = $sMComment & "Abort, Retry, and Ignore,"
      Case GUICtrlRead($optMRetryCancel) = $GUI_CHECKED			; Two push buttons: Retry and Cancel
         $iMFlag = 5
		 $sMFlag = "$MB_RETRYCANCEL"
		 $sMComment = $sMComment & "Retry and Cancel,"
      Case GUICtrlRead($optMCancelTryContinue) = $GUI_CHECKED	; Three push buttons: Cancel, Try Again, Continue
         $iMFlag = 6
		 $sMFlag = "$MB_CANCELTRYCONTINUE"
		 $sMComment = $sMComment & "Cancel, Try Again, Continue,"
	  Case Else													; One push button: OK
         $iMFlag = 0
		 $sMFlag = "$MB_OK"
		 $sMComment = $sMComment & "OK,"
   EndSelect
   
   ;Default Button
   Select
      Case GUICtrlRead($optMSecond) = $GUI_CHECKED					; The second button is the default button
         $iMFlag = $iMFlag + 256
		 $sMFlag = $sMFlag & " + " & "$MB_DEFBUTTON2"
		 $sMComment = $sMComment & " Default Button=Second,"
      Case GUICtrlRead($optMThird) = $GUI_CHECKED					; The third button is the default button
         $iMFlag = $iMFlag + 512
		 $sMFlag = $sMFlag & " + " & "$MB_DEFBUTTON3"
		 $sMComment = $sMComment & " Default Button=Third,"
	  Case Else														; The first button is the default button
		 If $sMFlag <> $MB_OK Then $sMComment = $sMComment & " Default Button=First,"
   EndSelect

   ;Icons
   $sMComment = $sMComment & " Icon="

   Select
      Case GUICtrlRead($chkMWarning) = $GUI_CHECKED				; Exclamation-point icon
         $iMFlag = $iMFlag + 48
		 $sMFlag = $sMFlag & " + " & "$MB_ICONEXCLAMATION"
		 $sMComment = $sMComment & "Warning,"
      Case GUICtrlRead($chkMInfo) = $GUI_CHECKED				; Icon consisting of an 'i' in a circle
         $iMFlag = $iMFlag + 64
		 $sMFlag = $sMFlag & " + " & "$MB_ICONASTERISK"
		 $sMComment = $sMComment & "Info,"
      Case GUICtrlRead($chkMCritical) = $GUI_CHECKED			; Stop-sign icon
         $iMFlag = $iMFlag + 16
		 $sMFlag = $sMFlag & " + " & "$MB_ICONHAND"
		 $sMComment = $sMComment & "Critical,"
      Case GUICtrlRead($chkMQuestion) = $GUI_CHECKED			; Question-mark icon
         $iMFlag = $iMFlag + 32
		 $sMFlag = $sMFlag & " + " & "$MB_ICONQUESTION"
		 $sMComment = $sMComment & "Question,"
	  Case Else													; None
		 $sMComment = $sMComment & "None,"
   EndSelect
   
   ;Modality
   Select
      Case GUICtrlRead($optMSysModal) = $GUI_CHECKED			; System modal
         $iMFlag = $iMFlag + 4096
		 $sMFlag = $sMFlag & " + " & "$MB_SYSTEMMODAL"
		 $sMComment = $sMComment & " Modality=System Modal,"
      Case GUICtrlRead($optMTaskModal) = $GUI_CHECKED			; Task modal
         $iMFlag = $iMFlag + 8192
		 $sMFlag = $sMFlag & " + " & "$MB_TASKMODAL"
		 $sMComment = $sMComment & " Modality=Task Modal,"
   EndSelect
   
   ;Timeout
   If GUICtrlRead($txtMTimeout) <> "" Then $sMComment = $sMComment & " Timeout=" & GUICtrlRead($txtMTimeout) & " ss,"
   
   ;Miscellaneous
   If GUICtrlRead($chkMTopMost) = $GUI_CHECKED Then 			; MsgBox has top-most attribute set
	  $iMFlag = $iMFlag + 262144
	  $sMFlag = $sMFlag & " + " & "262144"						
	  $sMComment = $sMComment & " Miscellaneous=Top-most attribute,"
   EndIf

   If GUICtrlRead($chkMRightJust) = $GUI_CHECKED Then 			; Title and text are right-justified
	  $iMFlag = $iMFlag + 524288
	  $sMFlag = $sMFlag & " + " & "524288"						
	  
	  If GUICtrlRead($chkMTopMost) = $GUI_CHECKED Then
		 $sMComment = StringTrimRight($sMComment, 1) & " and Title/text right-justified,"
	  Else
		 $sMComment = $sMComment & " Miscellaneous=Title/text right-justified,"		 
	  EndIf
   EndIf

   If GUICtrlRead($chkMConstants) = $GUI_CHECKED And $msg = $btnCopy Then
	  Return $sMFlag
   Else
	  Return $iMFlag
   EndIf
EndFunc   ;==>_SetFlag

Func _PwdChr()
   If GUICtrlRead($txtIPwdChr) = "" Then
	  $sIPwdChr = " " 
   Else
	  $sIPwdChr = GUICtrlRead($txtIPwdChr)
   EndIf
   
   If GUICtrlRead($chkIMandatory) = $GUI_CHECKED Then
	  $sIPwdChr = $sIPwdChr & "M"
	EndIf  
   
   $sIPwdChr = $sIPwdChr & GUICtrlRead($txtIChrLen)

   Return $sIPwdChr
EndFunc   

Func _Position()
   If GUICtrlRead($txtIWidth) = "" Then
		 $sIWidth = "-1"
   Else
		 $sIWidth = GUICtrlRead($txtIWidth)
   EndIf
   
   If GUICtrlRead($txtIHeight) = "" Then
		 $sIHeight = "-1"
   Else
		 $sIHeight = GUICtrlRead($txtIHeight)
   EndIf
  
  If GUICtrlRead($txtILeft) = "" Then
		 $sILeft = "-1"
   Else
		 $sILeft = GUICtrlRead($txtILeft)
   EndIf
   
   If GUICtrlRead($txtITop) = "" Then
		 $sITop = "-1"
   Else
		 $sITop = GUICtrlRead($txtITop)
   EndIf
	  
   Return $sIWidth
   Return $sIHeight
   Return $sILeft
   Return $sITop
EndFunc   

Func _MComments()
   Local $sTmpComment
   
   If GUICtrlRead($txtMTitle) <> "" Then 
	  $sTmpComment = ";MsgBox features: Title=Yes,"  
   Else
	  $sTmpComment = ";MsgBox features: Title=No," 
   EndIf
	  
   If $sMText <> "" Then 
	  $sTmpComment = $sTmpComment & " Text=Yes,"  
   Else
	  $sTmpComment = $sTmpComment & " Text=No,"  
   EndIf

   $sMComment = "#Region --- CodeWizard generated code Start ---" & @CRLF & $sTmpComment & 	$sMComment		;Header of the comment string
   $sMComment = StringTrimRight($sMComment, 1)	;Remove the last comma

   $sMComment = $sMComment & @CRLF
	  
   Return $sMComment
EndFunc   

Func _IComments()
   ;Header of comment
   $sInputBox = "#Region --- CodeWizard generated code Start ---" & @CRLF & _	
	  ";InputBox features:" & $sInputBox	
   
   If GUICtrlRead($txtITitle) <> "" Then 
	  $sInputBox = $sInputBox & " Title=Yes,"
   Else
	  $sInputBox = $sInputBox & " Title=No,"
   EndIf
	  
   If $sIPrompt <> "" Then 
	  $sInputBox = $sInputBox & " Prompt=Yes,"
   Else
	  $sInputBox = $sInputBox & " Prompt=No,"
   EndIf

   If GUICtrlRead($txtIDefault) <> "" Then
	  $sInputBox = $sInputBox & " Default Text=Yes,"
   Else
	  $sInputBox = $sInputBox & " Default Text=No,"
   EndIf

   If GUICtrlRead($txtIChrLen) <> "" Then $sInputBox = $sInputBox & " Input Length=" & GUICtrlRead($txtIChrLen) & ","
   If GUICtrlRead($txtIPwdChr) <> "" Then $sInputBox = $sInputBox & " Pwd Char=" &  GUICtrlRead($txtIPwdChr) & ","
   If GUICtrlRead($txtITimeOut) <> "" Then $sInputBox = $sInputBox & " TimeOut=" &  GUICtrlRead($txtITimeOut) & " ss,"
   If GUICtrlRead($chkIMandatory) = $GUI_CHECKED Then $sInputBox = $sInputBox & " Mandatory," 
   If $sIWidth <> "-1" Then $sInputBox = $sInputBox & " Width=" &  $sIWidth & ","
   If $sIHeight <> "-1" Then $sInputBox = $sInputBox & " Height=" &  $sIHeight & ","
   If $sILeft <> "-1" Then $sInputBox = $sInputBox & " Left=" &  $sILeft & ","
   If $sITop <> "-1" Then $sInputBox = $sInputBox & " Top=" &  $sITop & ","
   
   $sInputBox = StringTrimRight($sInputBox, 1)		;Remove the last comma
   $sInputBox = $sInputBox & @CRLF 
	  
   Return $sInputBox
EndFunc   