#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Radio.ico
;#AutoIt3Wrapper_Run_Debug_Mode=Y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

;#cs
_COMError_Notify(2)

Func _COMError_Notify($iDebug, $sDebugFile = Default)

	Static Local $avDebugState[3] = [0, "", 0] ; Debugstate, Debugfile and AutoIt.Error object
	If $sDebugFile = Default Or $sDebugFile = "" Then $sDebugFile = @ScriptDir & "\COMError_Debug.txt"
	If Not IsInt($iDebug) Or $iDebug < -1 Or $iDebug > 3 Then Return SetError(1, 0, 0)
	Switch $iDebug
		Case -1
			Return $avDebugState
		Case 0
			$avDebugState[0] = 0
			$avDebugState[1] = ""
			$avDebugState[2] = 0
		Case Else
			If $iDebug = 2 And $sDebugFile = "" Then Return SetError(4, 0, 0)
			; A COM error handler will be initialized only if one does not exist
			If ObjEvent("AutoIt.Error") = "" Then
				$avDebugState[2] = ObjEvent("AutoIt.Error", "__COMError_Handler") ; Creates a custom error handler
				If @error <> 0 Then Return SetError(2, @error, 0)
				$avDebugState[0] = $iDebug
				$avDebugState[1] = $sDebugFile
				Return SetError(0, 1, 1)
			ElseIf ObjEvent("AutoIt.Error") = "__COMError_Handler" Then
				Return SetError(0, 0, 1) ; COM error handler already set by a previous call to this function
			Else
				Return SetError(3, 0, 0) ; COM error handler already set to another function
			EndIf
	EndSwitch
	Return

EndFunc   ;==>_COMError_Notify

Func __COMError_Handler($oCOMError)

	Local $sTitle = "AutoIt COM error handler"
	Local $avDebugState = _COMError_Notify(-1)
	Local $sError = "Error encountered in " & @ScriptName & ":" & @CRLF & _
			"  @AutoItVersion = " & @AutoItVersion & @CRLF & _
			"  @AutoItX64 = " & @AutoItX64 & @CRLF & _
			"  @Compiled = " & @Compiled & @CRLF & _
			"  @OSArch = " & @OSArch & @CRLF & _
			"  @OSVersion = " & @OSVersion & @CRLF & _
			"  Scriptline = " & $oCOMError.Scriptline & @CRLF & _
			"  NumberHex = " & Hex($oCOMError.Number, 8) & @CRLF & _
			"  Number = " & $oCOMError.Number & @CRLF & _
			"  WinDescription = " & StringStripWS($oCOMError.WinDescription, 2) & @CRLF & _
			"  Description = " & StringStripWS($oCOMError.Description, 2) & @CRLF & _
			"  Source = " & $oCOMError.Source & @CRLF & _
			"  HelpFile = " & $oCOMError.HelpFile & @CRLF & _
			"  HelpContext = " & $oCOMError.HelpContext & @CRLF & _
			"  LastDllError = " & $oCOMError.LastDllError & @CRLF
	Switch $avDebugState[0]
		Case 1
			MsgBox(64, $sTitle & '1', $sError)
			ConsoleWrite($sTitle & " - " & $sError & @CRLF)
		Case 2
			MsgBox(64, $sTitle & '2', $sError)
			ConsoleWrite($sTitle & @CRLF & $sError)
		Case 3
			MsgBox(64, $sTitle & '3', $sError)
			FileWrite($avDebugState[1], @YEAR & "." & @MON & "." & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " " & $sTitle & _
					" - " & $sError & @CRLF)
	EndSwitch

EndFunc   ;==>__COMError_Handler
;#ce

#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>

#include <GUIStatusBar.au3>
#include <GuiListView.au3>
#include <String.au3>
#include <File.au3>
#include <Misc.au3>
#include <Date.au3>
#include <IE.au3>

HotKeySet("{ESC}", "_Terminate")
If Not _Singleton(@ScriptName, 1) Then Exit

Dim $Sec, $Min, $Hour, $Time, $_ButtonWidth = 157, $_X = 370, $_Spaces = '        '
Dim $_Text = @CRLF & $_Spaces & '_ ESC for Quit'
Dim $_DurationDiff, $_DurationMs, $_GetItem, $_RandomMode = 1
Global $_LastUkTopChartsListArray[1], $_RandomArray[1], $_DurationArray[1]
Global $_Duration, $_UpDateDate, $_LastChartPageSourceCode, $_Invert = True, $_InvertTimerInit = TimerInit(), $_StatusBar, $_Loop, $oIE
Global $_StatusParts[1] = [500], $_TempStatus[1] = [""]
;
;
; added for _LCT
$sChildsName = ''
Global $font = "Comic Sans MS", $PicSplash, $Pic_Default = 'SkyLanders.jpg', $iReward = 0
; Check
Global $_InputCheck = '', $_ButtonCheck, $_GuiName = '', $_LableNameCheck = '', $bQuit = False
Global $sNameHolder = ''
Global $sAnswer = '', $bPassed = False
; Element Air
;
Global $_GuiAir
Global $_ButtonAirSwarm, $_ButtonAirLightCoreJetVac, $_ButtonAirSonicBoom, $_ButtonAirWhirlwind, $_ButtonAirLightningRod, $_ButtonAirJetVac
Global $_LableAirSwarm, $_LableAirLightCoreJetVac, $_LableAirSonicBoom, $_LableAirWhirlwind, $_LableAirLightningRod, $_LableAirJetVac
; Element UnDead
;
Global $_GuiUnDead
Global $_ButtonUnDeadEyeBrawl, $_ButtonUnDeadLightCoreHex, $_ButtonUnDeadCynder, $_ButtonUnDeadChopChop, $_ButtonUnDeadHex, $_ButtonUnDeadFrightRider
Global $_LableUnDeadEyeBrawl, $_LableUnDeadLightCoreHex, $_LableUnDeadCynder, $_LableUnDeadChopChop, $_LableUnDeadHex, $_LableUnDeadFrightRider
; Element Water
;
Global $_GuiWater
Global $_ButtonWaterThumpback, $_ButtonWaterLightCoreChill, $_ButtonWaterSlamBam, $_ButtonWaterZap, $_ButtonWaterGillGrunt, $_ButtonWaterChill
Global $_LableWaterThumpback, $_LableWaterLightCoreChill, $_LableWaterSlamBam, $_LableWaterZap, $_LableWaterGillGrunt, $_LableWaterChill
; Element Life
;
Global $_GuiLife
Global $_ButtonLifeTreeRex, $_ButtonLifeLightCoreShroomboom, $_ButtonLifeStealthElf, $_ButtonLifeZook, $_ButtonLifeStumpSmash, $_ButtonLifeShroomboom
Global $_LableLifeTreeRex, $_LableLifeLightCoreShroomboom, $_LableLifeStealthElf, $_LableLifeZook, $_LableLifeStumpSmash, $_LableLifeShroomboom
; Element Magic
;
Global $_GuiMagic
Global $_ButtonMagicNinjini, $_ButtonMagicLightCorePopfizz, $_ButtonMagicSpyro, $_ButtonMagicWreckingBall, $_ButtonMagicDoubleTrouble, $_ButtonMagicPopfizz
Global $_LableMagicNinjini, $_LableMagicLightCorePopfizz, $_LableMagicSpyro, $_LableMagicWreckingBall, $_LableMagicDoubleTrouble, $_LableMagicPopfizz
; Element Magic
;
Global $_GuiFire
Global $_ButtonFireHotHead, $_ButtonFireLightCoreEruptor, $_ButtonFireIgnitor, $_ButtonFireFlameslinger, $_ButtonFireHotDog, $_ButtonFireEruptor
Global $_LableFireHotHead, $_LableFireLightCoreEruptor, $_LableFireIgnitor, $_LableFireFlameslinger, $_LableFireHotDog, $_LableFireEruptor
; Element Life
;
Global $_GuiEarth
Global $_ButtonEarthCrusher, $_ButtonEarthLightCorePrismBreak, $_ButtonEarthTerrafin, $_ButtonEarthBash, $_ButtonEarthFlashwing, $_ButtonEarthPrismBreak
Global $_LableEarthCrusher, $_LableEarthLightCorePrismBreak, $_LableEarthTerrafin, $_LableEarthBash, $_LableEarthFlashwing, $_LableEarthPrismBreak
; Element Tech
;
Global $_GuiTech
Global $_ButtonTechBouncer, $_ButtonTechLightCoreDrobot, $_ButtonTechDrillSergeant, $_ButtonTechTriggerHappy, $_ButtonTechSprocket, $_ButtonTechDrobot
Global $_LableTechBouncer, $_LableTechLightCoreDrobot, $_LableTechDrillSergeant, $_LableTechTriggerHappy, $_LableTechSprocket, $_LableTechDrobot
;
;
#cs
	$return = FileInstall('Air2.jpg', @ScriptDir & '\' & 'Air2.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Air2.jpg') Then MsgBox('', 'failed to copy/install file', 'Air2.jpg')
	$return = FileInstall('AirSymbolSkylanders.png', @ScriptDir & '\' & 'AirSymbolSkylanders.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'AirSymbolSkylanders.png') Then MsgBox('', 'failed to copy/install file', 'AirSymbolSkylanders.png')
	$return = FileInstall('Bash.jpg', @ScriptDir & '\' & 'Bash.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Bash.jpg') Then MsgBox('', 'failed to copy/install file', 'Bash.jpg')
	$return = FileInstall('Bash.png', @ScriptDir & '\' & 'Bash.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Bash.png') Then MsgBox('', 'failed to copy/install file', 'Bash.png')
	$return = FileInstall('Bouncer.jpg', @ScriptDir & '\' & 'Bouncer.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Bouncer.jpg') Then MsgBox('', 'failed to copy/install file', 'Bouncer.jpg')
	$return = FileInstall('Bouncer.png', @ScriptDir & '\' & 'Bouncer.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Bouncer.png') Then MsgBox('', 'failed to copy/install file', 'Bouncer.png')
	$return = FileInstall('Button_Air.jpg', @ScriptDir & '\' & 'Button_Air.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_Air.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_Air.jpg')
	$return = FileInstall('Button_Air_2.jpg', @ScriptDir & '\' & 'Button_Air_2.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_Air_2.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_Air_2.jpg')
	$return = FileInstall('Button_Earth.jpg', @ScriptDir & '\' & 'Button_Earth.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_Earth.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_Earth.jpg')
	$return = FileInstall('Button_Fire.jpg', @ScriptDir & '\' & 'Button_Fire.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_Fire.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_Fire.jpg')
	$return = FileInstall('Button_Life.jpg', @ScriptDir & '\' & 'Button_Life.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_Life.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_Life.jpg')
	$return = FileInstall('Button_Magic.jpg', @ScriptDir & '\' & 'Button_Magic.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_Magic.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_Magic.jpg')
	$return = FileInstall('Button_Tech.jpg', @ScriptDir & '\' & 'Button_Tech.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_Tech.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_Tech.jpg')
	$return = FileInstall('Button_UnDead.jpg', @ScriptDir & '\' & 'Button_UnDead.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_UnDead.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_UnDead.jpg')
	$return = FileInstall('Button_Water.jpg', @ScriptDir & '\' & 'Button_Water.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_Water.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_Water.jpg')
	$return = FileInstall('Button_Water_ThumpBack.jpg', @ScriptDir & '\' & 'Button_Water_ThumpBack.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Button_Water_ThumpBack.jpg') Then MsgBox('', 'failed to copy/install file', 'Button_Water_ThumpBack.jpg')
	$return = FileInstall('Chill.jpg', @ScriptDir & '\' & 'Chill.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Chill.jpg') Then MsgBox('', 'failed to copy/install file', 'Chill.jpg')
	$return = FileInstall('Chill.png', @ScriptDir & '\' & 'Chill.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Chill.png') Then MsgBox('', 'failed to copy/install file', 'Chill.png')
	$return = FileInstall('Chop_Chop.jpg', @ScriptDir & '\' & 'Chop_Chop.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Chop_Chop.jpg') Then MsgBox('', 'failed to copy/install file', 'Chop_Chop.jpg')
	$return = FileInstall('Chop_Chop.png', @ScriptDir & '\' & 'Chop_Chop.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Chop_Chop.png') Then MsgBox('', 'failed to copy/install file', 'Chop_Chop.png')
	$return = FileInstall('Crusher.jpg', @ScriptDir & '\' & 'Crusher.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Crusher.jpg') Then MsgBox('', 'failed to copy/install file', 'Crusher.jpg')
	$return = FileInstall('Crusher.png', @ScriptDir & '\' & 'Crusher.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Crusher.png') Then MsgBox('', 'failed to copy/install file', 'Crusher.png')
	$return = FileInstall('Cynder.jpg', @ScriptDir & '\' & 'Cynder.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Cynder.jpg') Then MsgBox('', 'failed to copy/install file', 'Cynder.jpg')
	$return = FileInstall('Cynder.png', @ScriptDir & '\' & 'Cynder.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Cynder.png') Then MsgBox('', 'failed to copy/install file', 'Cynder.png')
	$return = FileInstall('Double_Trouble.jpg', @ScriptDir & '\' & 'Double_Trouble.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Double_Trouble.jpg') Then MsgBox('', 'failed to copy/install file', 'Double_Trouble.jpg')
	$return = FileInstall('Double_Trouble.png', @ScriptDir & '\' & 'Double_Trouble.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Double_Trouble.png') Then MsgBox('', 'failed to copy/install file', 'Double_Trouble.png')
	$return = FileInstall('Drill_Sergeant.jpg', @ScriptDir & '\' & 'Drill_Sergeant.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Drill_Sergeant.jpg') Then MsgBox('', 'failed to copy/install file', 'Drill_Sergeant.jpg')
	$return = FileInstall('Drill_Sergeant.png', @ScriptDir & '\' & 'Drill_Sergeant.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Drill_Sergeant.png') Then MsgBox('', 'failed to copy/install file', 'Drill_Sergeant.png')
	$return = FileInstall('Drobot.jpg', @ScriptDir & '\' & 'Drobot.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Drobot.jpg') Then MsgBox('', 'failed to copy/install file', 'Drobot.jpg')
	$return = FileInstall('Drobot.png', @ScriptDir & '\' & 'Drobot.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Drobot.png') Then MsgBox('', 'failed to copy/install file', 'Drobot.png')
	$return = FileInstall('Earth2.jpg', @ScriptDir & '\' & 'Earth2.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Earth2.jpg') Then MsgBox('', 'failed to copy/install file', 'Earth2.jpg')
	$return = FileInstall('EarthSymbolSkylanders.png', @ScriptDir & '\' & 'EarthSymbolSkylanders.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'EarthSymbolSkylanders.png') Then MsgBox('', 'failed to copy/install file', 'EarthSymbolSkylanders.png')
	$return = FileInstall('Eruptor.jpg', @ScriptDir & '\' & 'Eruptor.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Eruptor.jpg') Then MsgBox('', 'failed to copy/install file', 'Eruptor.jpg')
	$return = FileInstall('Eruptor.png', @ScriptDir & '\' & 'Eruptor.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Eruptor.png') Then MsgBox('', 'failed to copy/install file', 'Eruptor.png')
	$return = FileInstall('Eye_Brawl.jpg', @ScriptDir & '\' & 'Eye_Brawl.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Eye_Brawl.jpg') Then MsgBox('', 'failed to copy/install file', 'Eye_Brawl.jpg')
	$return = FileInstall('Eye_Brawl.png', @ScriptDir & '\' & 'Eye_Brawl.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Eye_Brawl.png') Then MsgBox('', 'failed to copy/install file', 'Eye_Brawl.png')
	$return = FileInstall('Fire2.jpg', @ScriptDir & '\' & 'Fire2.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Fire2.jpg') Then MsgBox('', 'failed to copy/install file', 'Fire2.jpg')
	$return = FileInstall('FireSymbolSkylanders.png', @ScriptDir & '\' & 'FireSymbolSkylanders.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'FireSymbolSkylanders.png') Then MsgBox('', 'failed to copy/install file', 'FireSymbolSkylanders.png')
	$return = FileInstall('Flameslinger.jpg', @ScriptDir & '\' & 'Flameslinger.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Flameslinger.jpg') Then MsgBox('', 'failed to copy/install file', 'Flameslinger.jpg')
	$return = FileInstall('Flameslinger.png', @ScriptDir & '\' & 'Flameslinger.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Flameslinger.png') Then MsgBox('', 'failed to copy/install file', 'Flameslinger.png')
	$return = FileInstall('Flashwing.jpg', @ScriptDir & '\' & 'Flashwing.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Flashwing.jpg') Then MsgBox('', 'failed to copy/install file', 'Flashwing.jpg')
	$return = FileInstall('Flashwing.png', @ScriptDir & '\' & 'Flashwing.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Flashwing.png') Then MsgBox('', 'failed to copy/install file', 'Flashwing.png')
	$return = FileInstall('Flashwing_Jade.jpg', @ScriptDir & '\' & 'Flashwing_Jade.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Flashwing_Jade.jpg') Then MsgBox('', 'failed to copy/install file', 'Flashwing_Jade.jpg')
	$return = FileInstall('Fright_Rider.jpg', @ScriptDir & '\' & 'Fright_Rider.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Fright_Rider.jpg') Then MsgBox('', 'failed to copy/install file', 'Fright_Rider.jpg')
	$return = FileInstall('Fright_Rider.png', @ScriptDir & '\' & 'Fright_Rider.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Fright_Rider.png') Then MsgBox('', 'failed to copy/install file', 'Fright_Rider.png')
	$return = FileInstall('Gill_Grunt.jpg', @ScriptDir & '\' & 'Gill_Grunt.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Gill_Grunt.jpg') Then MsgBox('', 'failed to copy/install file', 'Gill_Grunt.jpg')
	$return = FileInstall('Gill_Grunt.png', @ScriptDir & '\' & 'Gill_Grunt.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Gill_Grunt.png') Then MsgBox('', 'failed to copy/install file', 'Gill_Grunt.png')
	$return = FileInstall('Granite_Crusher.jpg', @ScriptDir & '\' & 'Granite_Crusher.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Granite_Crusher.jpg') Then MsgBox('', 'failed to copy/install file', 'Granite_Crusher.jpg')
	$return = FileInstall('Hex.jpg', @ScriptDir & '\' & 'Hex.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Hex.jpg') Then MsgBox('', 'failed to copy/install file', 'Hex.jpg')
	$return = FileInstall('Hex.png', @ScriptDir & '\' & 'Hex.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Hex.png') Then MsgBox('', 'failed to copy/install file', 'Hex.png')
	$return = FileInstall('Hot_Dog.jpg', @ScriptDir & '\' & 'Hot_Dog.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Hot_Dog.jpg') Then MsgBox('', 'failed to copy/install file', 'Hot_Dog.jpg')
	$return = FileInstall('Hot_Dog.png', @ScriptDir & '\' & 'Hot_Dog.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Hot_Dog.png') Then MsgBox('', 'failed to copy/install file', 'Hot_Dog.png')
	$return = FileInstall('Hot_Head.jpg', @ScriptDir & '\' & 'Hot_Head.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Hot_Head.jpg') Then MsgBox('', 'failed to copy/install file', 'Hot_Head.jpg')
	$return = FileInstall('Hot_Head.png', @ScriptDir & '\' & 'Hot_Head.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Hot_Head.png') Then MsgBox('', 'failed to copy/install file', 'Hot_Head.png')
	$return = FileInstall('Ignitor.jpg', @ScriptDir & '\' & 'Ignitor.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Ignitor.jpg') Then MsgBox('', 'failed to copy/install file', 'Ignitor.jpg')
	$return = FileInstall('Ignitor.png', @ScriptDir & '\' & 'Ignitor.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Ignitor.png') Then MsgBox('', 'failed to copy/install file', 'Ignitor.png')
	$return = FileInstall('Jet_Vac.jpg', @ScriptDir & '\' & 'Jet_Vac.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Jet_Vac.jpg') Then MsgBox('', 'failed to copy/install file', 'Jet_Vac.jpg')
	$return = FileInstall('Jet_Vac.png', @ScriptDir & '\' & 'Jet_Vac.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Jet_Vac.png') Then MsgBox('', 'failed to copy/install file', 'Jet_Vac.png')
	$return = FileInstall('Legendary_Bouncer.jpg', @ScriptDir & '\' & 'Legendary_Bouncer.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Legendary_Bouncer.jpg') Then MsgBox('', 'failed to copy/install file', 'Legendary_Bouncer.jpg')
	$return = FileInstall('Legendary_Trigger_Happy.jpg', @ScriptDir & '\' & 'Legendary_Trigger_Happy.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Legendary_Trigger_Happy.jpg') Then MsgBox('', 'failed to copy/install file', 'Legendary_Trigger_Happy.jpg')
	$return = FileInstall('Life2.jpg', @ScriptDir & '\' & 'Life2.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Life2.jpg') Then MsgBox('', 'failed to copy/install file', 'Life2.jpg')
	$return = FileInstall('LifeSymbolSkylanders.png', @ScriptDir & '\' & 'LifeSymbolSkylanders.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'LifeSymbolSkylanders.png') Then MsgBox('', 'failed to copy/install file', 'LifeSymbolSkylanders.png')
	$return = FileInstall('LightCore_Chill.jpg', @ScriptDir & '\' & 'LightCore_Chill.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'LightCore_Chill.jpg') Then MsgBox('', 'failed to copy/install file', 'LightCore_Chill.jpg')
	$return = FileInstall('Lightcore_Chill.png', @ScriptDir & '\' & 'Lightcore_Chill.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Chill.png') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Chill.png')
	$return = FileInstall('LightCore_Drobot.jpg', @ScriptDir & '\' & 'LightCore_Drobot.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'LightCore_Drobot.jpg') Then MsgBox('', 'failed to copy/install file', 'LightCore_Drobot.jpg')
	$return = FileInstall('Lightcore_Drobot.png', @ScriptDir & '\' & 'Lightcore_Drobot.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Drobot.png') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Drobot.png')
	$return = FileInstall('LightCore_Eruptor.jpg', @ScriptDir & '\' & 'LightCore_Eruptor.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'LightCore_Eruptor.jpg') Then MsgBox('', 'failed to copy/install file', 'LightCore_Eruptor.jpg')
	$return = FileInstall('Lightcore_Eruptor.png', @ScriptDir & '\' & 'Lightcore_Eruptor.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Eruptor.png') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Eruptor.png')
	$return = FileInstall('LightCore_Hex.jpg', @ScriptDir & '\' & 'LightCore_Hex.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'LightCore_Hex.jpg') Then MsgBox('', 'failed to copy/install file', 'LightCore_Hex.jpg')
	$return = FileInstall('Lightcore_Hex.png', @ScriptDir & '\' & 'Lightcore_Hex.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Hex.png') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Hex.png')
	$return = FileInstall('LightCore_Jet_Vac.jpg', @ScriptDir & '\' & 'LightCore_Jet_Vac.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'LightCore_Jet_Vac.jpg') Then MsgBox('', 'failed to copy/install file', 'LightCore_Jet_Vac.jpg')
	$return = FileInstall('Lightcore_Jet_Vac.png', @ScriptDir & '\' & 'Lightcore_Jet_Vac.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Jet_Vac.png') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Jet_Vac.png')
	$return = FileInstall('Lightcore_Pop_fizz.jpg', @ScriptDir & '\' & 'Lightcore_Pop_fizz.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Pop_fizz.jpg') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Pop_fizz.jpg')
	$return = FileInstall('Lightcore_Pop_fizz.png', @ScriptDir & '\' & 'Lightcore_Pop_fizz.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Pop_fizz.png') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Pop_fizz.png')
	$return = FileInstall('LightCore_Prism_Break.jpg', @ScriptDir & '\' & 'LightCore_Prism_Break.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'LightCore_Prism_Break.jpg') Then MsgBox('', 'failed to copy/install file', 'LightCore_Prism_Break.jpg')
	$return = FileInstall('Lightcore_Prism_Break.png', @ScriptDir & '\' & 'Lightcore_Prism_Break.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Prism_Break.png') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Prism_Break.png')
	$return = FileInstall('Lightcore_Shroomboom.jpg', @ScriptDir & '\' & 'Lightcore_Shroomboom.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Shroomboom.jpg') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Shroomboom.jpg')
	$return = FileInstall('Lightcore_Shroomoom.png', @ScriptDir & '\' & 'Lightcore_Shroomoom.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightcore_Shroomoom.png') Then MsgBox('', 'failed to copy/install file', 'Lightcore_Shroomoom.png')
	$return = FileInstall('Lightning_Rod.jpg', @ScriptDir & '\' & 'Lightning_Rod.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightning_Rod.jpg') Then MsgBox('', 'failed to copy/install file', 'Lightning_Rod.jpg')
	$return = FileInstall('Lightning_Rod.png', @ScriptDir & '\' & 'Lightning_Rod.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Lightning_Rod.png') Then MsgBox('', 'failed to copy/install file', 'Lightning_Rod.png')
	$return = FileInstall('Magic2.jpg', @ScriptDir & '\' & 'Magic2.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Magic2.jpg') Then MsgBox('', 'failed to copy/install file', 'Magic2.jpg')
	$return = FileInstall('MagicSymbolSkylanders.png', @ScriptDir & '\' & 'MagicSymbolSkylanders.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'MagicSymbolSkylanders.png') Then MsgBox('', 'failed to copy/install file', 'MagicSymbolSkylanders.png')
	$return = FileInstall('Ninjini.jpg', @ScriptDir & '\' & 'Ninjini.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Ninjini.jpg') Then MsgBox('', 'failed to copy/install file', 'Ninjini.jpg')
	$return = FileInstall('Ninjini.png', @ScriptDir & '\' & 'Ninjini.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Ninjini.png') Then MsgBox('', 'failed to copy/install file', 'Ninjini.png')
	$return = FileInstall('Pop_fizz.jpg', @ScriptDir & '\' & 'Pop_fizz.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Pop_fizz.jpg') Then MsgBox('', 'failed to copy/install file', 'Pop_fizz.jpg')
	$return = FileInstall('Pop_fizz.png', @ScriptDir & '\' & 'Pop_fizz.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Pop_fizz.png') Then MsgBox('', 'failed to copy/install file', 'Pop_fizz.png')
	$return = FileInstall('PrismBreak.png', @ScriptDir & '\' & 'PrismBreak.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'PrismBreak.png') Then MsgBox('', 'failed to copy/install file', 'PrismBreak.png')
	$return = FileInstall('Prism_Break.jpg', @ScriptDir & '\' & 'Prism_Break.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Prism_Break.jpg') Then MsgBox('', 'failed to copy/install file', 'Prism_Break.jpg')
	$return = FileInstall('Shroomboom.jpg', @ScriptDir & '\' & 'Shroomboom.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Shroomboom.jpg') Then MsgBox('', 'failed to copy/install file', 'Shroomboom.jpg')
	$return = FileInstall('Shroomboom.png', @ScriptDir & '\' & 'Shroomboom.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Shroomboom.png') Then MsgBox('', 'failed to copy/install file', 'Shroomboom.png')
	$return = FileInstall('SkyLanders.jpg', @ScriptDir & '\' & 'SkyLanders.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'SkyLanders.jpg') Then MsgBox('', 'failed to copy/install file', 'SkyLanders.jpg')
	$return = FileInstall('Slam_Bam.jpg', @ScriptDir & '\' & 'Slam_Bam.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Slam_Bam.jpg') Then MsgBox('', 'failed to copy/install file', 'Slam_Bam.jpg')
	$return = FileInstall('Slam_Bam.png', @ScriptDir & '\' & 'Slam_Bam.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Slam_Bam.png') Then MsgBox('', 'failed to copy/install file', 'Slam_Bam.png')
	$return = FileInstall('Smile.jpg', @ScriptDir & '\' & 'Smile.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Smile.jpg') Then MsgBox('', 'failed to copy/install file', 'Smile.jpg')
	$return = FileInstall('Sonic_Boom.jpg', @ScriptDir & '\' & 'Sonic_Boom.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Sonic_Boom.jpg') Then MsgBox('', 'failed to copy/install file', 'Sonic_Boom.jpg')
	$return = FileInstall('Sonic_Boom.png', @ScriptDir & '\' & 'Sonic_Boom.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Sonic_Boom.png') Then MsgBox('', 'failed to copy/install file', 'Sonic_Boom.png')
	$return = FileInstall('Sprocket.jpg', @ScriptDir & '\' & 'Sprocket.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Sprocket.jpg') Then MsgBox('', 'failed to copy/install file', 'Sprocket.jpg')
	$return = FileInstall('Sprocket.png', @ScriptDir & '\' & 'Sprocket.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Sprocket.png') Then MsgBox('', 'failed to copy/install file', 'Sprocket.png')
	$return = FileInstall('Spyro.jpg', @ScriptDir & '\' & 'Spyro.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Spyro.jpg') Then MsgBox('', 'failed to copy/install file', 'Spyro.jpg')
	$return = FileInstall('Spyro.png', @ScriptDir & '\' & 'Spyro.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Spyro.png') Then MsgBox('', 'failed to copy/install file', 'Spyro.png')
	$return = FileInstall('Stealth_Elf.jpg', @ScriptDir & '\' & 'Stealth_Elf.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Stealth_Elf.jpg') Then MsgBox('', 'failed to copy/install file', 'Stealth_Elf.jpg')
	$return = FileInstall('Stealth_Elf.png', @ScriptDir & '\' & 'Stealth_Elf.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Stealth_Elf.png') Then MsgBox('', 'failed to copy/install file', 'Stealth_Elf.png')
	$return = FileInstall('Stump_Smash.jpg', @ScriptDir & '\' & 'Stump_Smash.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Stump_Smash.jpg') Then MsgBox('', 'failed to copy/install file', 'Stump_Smash.jpg')
	$return = FileInstall('Stump_Smash.png', @ScriptDir & '\' & 'Stump_Smash.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Stump_Smash.png') Then MsgBox('', 'failed to copy/install file', 'Stump_Smash.png')
	$return = FileInstall('Swarm.jpg', @ScriptDir & '\' & 'Swarm.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Swarm.jpg') Then MsgBox('', 'failed to copy/install file', 'Swarm.jpg')
	$return = FileInstall('Swarm.png', @ScriptDir & '\' & 'Swarm.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Swarm.png') Then MsgBox('', 'failed to copy/install file', 'Swarm.png')
	$return = FileInstall('Tech2.jpg', @ScriptDir & '\' & 'Tech2.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Tech2.jpg') Then MsgBox('', 'failed to copy/install file', 'Tech2.jpg')
	$return = FileInstall('TechSymbolSkylanders.png', @ScriptDir & '\' & 'TechSymbolSkylanders.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'TechSymbolSkylanders.png') Then MsgBox('', 'failed to copy/install file', 'TechSymbolSkylanders.png')
	$return = FileInstall('Terrafin.jpg', @ScriptDir & '\' & 'Terrafin.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Terrafin.jpg') Then MsgBox('', 'failed to copy/install file', 'Terrafin.jpg')
	$return = FileInstall('Terrafin.png', @ScriptDir & '\' & 'Terrafin.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Terrafin.png') Then MsgBox('', 'failed to copy/install file', 'Terrafin.png')
	$return = FileInstall('Thumpback.jpg', @ScriptDir & '\' & 'Thumpback.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Thumpback.jpg') Then MsgBox('', 'failed to copy/install file', 'Thumpback.jpg')
	$return = FileInstall('Thumpback.png', @ScriptDir & '\' & 'Thumpback.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Thumpback.png') Then MsgBox('', 'failed to copy/install file', 'Thumpback.png')
	$return = FileInstall('Tree_Rex.jpg', @ScriptDir & '\' & 'Tree_Rex.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Tree_Rex.jpg') Then MsgBox('', 'failed to copy/install file', 'Tree_Rex.jpg')
	$return = FileInstall('Tree_Rex.png', @ScriptDir & '\' & 'Tree_Rex.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Tree_Rex.png') Then MsgBox('', 'failed to copy/install file', 'Tree_Rex.png')
	$return = FileInstall('Trigger_Happy.jpg', @ScriptDir & '\' & 'Trigger_Happy.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Trigger_Happy.jpg') Then MsgBox('', 'failed to copy/install file', 'Trigger_Happy.jpg')
	$return = FileInstall('Trigger_Happy.png', @ScriptDir & '\' & 'Trigger_Happy.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Trigger_Happy.png') Then MsgBox('', 'failed to copy/install file', 'Trigger_Happy.png')
	$return = FileInstall('Undead2.jpg', @ScriptDir & '\' & 'Undead2.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Undead2.jpg') Then MsgBox('', 'failed to copy/install file', 'Undead2.jpg')
	$return = FileInstall('UndeadSymbolSkylanders.png', @ScriptDir & '\' & 'UndeadSymbolSkylanders.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'UndeadSymbolSkylanders.png') Then MsgBox('', 'failed to copy/install file', 'UndeadSymbolSkylanders.png')
	$return = FileInstall('Water2.jpg', @ScriptDir & '\' & 'Water2.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Water2.jpg') Then MsgBox('', 'failed to copy/install file', 'Water2.jpg')
	$return = FileInstall('WaterSymbolSkylanders.png', @ScriptDir & '\' & 'WaterSymbolSkylanders.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'WaterSymbolSkylanders.png') Then MsgBox('', 'failed to copy/install file', 'WaterSymbolSkylanders.png')
	$return = FileInstall('Whirlwind.jpg', @ScriptDir & '\' & 'Whirlwind.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Whirlwind.jpg') Then MsgBox('', 'failed to copy/install file', 'Whirlwind.jpg')
	$return = FileInstall('Whirlwind.png', @ScriptDir & '\' & 'Whirlwind.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Whirlwind.png') Then MsgBox('', 'failed to copy/install file', 'Whirlwind.png')
	$return = FileInstall('Wrecking_Ball.jpg', @ScriptDir & '\' & 'Wrecking_Ball.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Wrecking_Ball.jpg') Then MsgBox('', 'failed to copy/install file', 'Wrecking_Ball.jpg')
	$return = FileInstall('Wrecking_Ball.png', @ScriptDir & '\' & 'Wrecking_Ball.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Wrecking_Ball.png') Then MsgBox('', 'failed to copy/install file', 'Wrecking_Ball.png')
	$return = FileInstall('Zap.jpg', @ScriptDir & '\' & 'Zap.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Zap.jpg') Then MsgBox('', 'failed to copy/install file', 'Zap.jpg')
	$return = FileInstall('Zap.png', @ScriptDir & '\' & 'Zap.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Zap.png') Then MsgBox('', 'failed to copy/install file', 'Zap.png')
	$return = FileInstall('Zook.jpg', @ScriptDir & '\' & 'Zook.jpg', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Zook.jpg') Then MsgBox('', 'failed to copy/install file', 'Zook.jpg')
	$return = FileInstall('Zook.png', @ScriptDir & '\' & 'Zook.png', 1)
	If Not $return And Not FileExists(@ScriptDir & '\' & 'Zook.png') Then MsgBox('', 'failed to copy/install file', 'Zook.png')

#ce
;
;
Opt("TrayMenuMode", 1)
TraySetIcon("Shell32.dll", -138)
TraySetToolTip("   _LCD" & @CRLF & StringStripWS($_Text, 7))
TraySetState(4)
OnAutoItExitRegister("_OnAutoItExit")
;
Local $begin = TimerInit(), $dif
Local $bNotConnect = False
Do
	Sleep(1000)
	ToolTip($_Spaces & 'Waiting for Internet connection', @DesktopWidth / 2 - 100, 0, 'LCT', 1, 4)

	$dif = TimerDiff($begin)
	ConsoleWrite('!> ' & Int($dif / 1000) & @CRLF)
	If Int($dif / 1000) >= 5 Then
		$bNotConnect = True
	EndIf

Until _IsConnected() Or $bNotConnect = True

ToolTip('')
If $bNotConnect = True Then MsgBox('', 'Not Connected to internet!', 'Some features are turned off - internet is need to run all features')
Opt("GuiOnEventMode", 1)
Global $_GuiTitle = '_LCT SkyLander', $HeaderTitle = StringUpper('SkyLanders')

$hGUI = GUICreate($_GuiTitle, 1300, 700) ; 1300, 900) ;,0,0,$WS_POPUP);, @DesktopWidth-704, @DesktopHeight - 400 )
GUISetBkColor(0xFFD900)
GUISetIcon("Shell32.dll", -138)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")

; image -->> 'http://s1213.beta.photobucket.com/user/kmkcorp/media/SkylandersGiants/elementswater.jpg.html'

$_LableElement = GUICtrlCreateLabel($HeaderTitle, 450, 5, 800, 50, $SS_CENTER)
GUICtrlSetFont(-1, 30, 400, 2, "Comic Sans MS")

If FileExists(@ScriptDir & '\' & 'Button_Water.jpg') Then
	$_ButtonWater = GUICtrlCreatePic(@ScriptDir & '\' & 'Button_Water.jpg', 40, 10, 150, 150)
	GUICtrlSetOnEvent($_ButtonWater, "_Water")
Else
	$_ButtonWater = GUICtrlCreateButton('Water', 40, 10, 150, 150)
	GUICtrlSetOnEvent($_ButtonWater, "_Water")
EndIf
;
If FileExists(@ScriptDir & '\' & 'Button_Air.jpg') Then
	$_ButtonAir = GUICtrlCreatePic(@ScriptDir & '\' & 'Button_Air.jpg', 210, 10, 150, 150)
	GUICtrlSetOnEvent($_ButtonAir, "_Air")
Else
	$_ButtonAir = GUICtrlCreateButton('AIR', 210, 10, 150, 150)
	GUICtrlSetOnEvent($_ButtonAir, "_Air")
EndIf
;
If FileExists(@ScriptDir & '\' & 'Button_Earth.jpg') Then
	$_ButtonEarth = GUICtrlCreatePic(@ScriptDir & '\' & 'Button_Earth.jpg', 40, 170, 150, 150)
	GUICtrlSetOnEvent($_ButtonEarth, "_Earth")
Else
	$_ButtonEarth = GUICtrlCreateButton('Earth', 40, 170, 150, 150)
	GUICtrlSetOnEvent($_ButtonEarth, "_Earth")
EndIf
;
If FileExists(@ScriptDir & '\' & 'Button_Fire.jpg') Then
	$_ButtonFire = GUICtrlCreatePic(@ScriptDir & '\' & 'Button_Fire.jpg', 210, 170, 150, 150)
	GUICtrlSetOnEvent($_ButtonFire, "_Fire")
Else
	$_ButtonFire = GUICtrlCreateButton('Fire', 210, 170, 150, 150)
	GUICtrlSetOnEvent($_ButtonFire, "_Fire")
EndIf
;
If FileExists(@ScriptDir & '\' & 'Button_Tech.jpg') Then
	$_ButtonTech = GUICtrlCreatePic(@ScriptDir & '\' & 'Button_Tech.jpg', 40, 330, 150, 150)
	GUICtrlSetOnEvent($_ButtonTech, "_Tech")
Else
	$_ButtonTech = GUICtrlCreateButton('Tech', 40, 330, 150, 150)
	GUICtrlSetOnEvent($_ButtonTech, "_Tech")
EndIf
;
;#cs
If FileExists(@ScriptDir & '\' & 'Button_Magic.jpg') Then
	$_ButtonMagic = GUICtrlCreatePic(@ScriptDir & '\' & 'Button_Magic.jpg', 210, 330, 150, 150)
	GUICtrlSetOnEvent($_ButtonMagic, "_Magic")
Else
	$_ButtonMagic = GUICtrlCreateButton('Magic', 210, 330, 150, 150)
	GUICtrlSetOnEvent($_ButtonMagic, "_Magic")
EndIf
;
If FileExists(@ScriptDir & '\' & 'Button_Life.jpg') Then
	$_ButtonLife = GUICtrlCreatePic(@ScriptDir & '\' & 'Button_Life.jpg', 40, 490, 150, 150)
	GUICtrlSetOnEvent($_ButtonLife, "_Life")
Else
	$_ButtonLife = GUICtrlCreateButton('Life', 40, 490, 150, 150)
	GUICtrlSetOnEvent($_ButtonLife, "_Life")
EndIf
;#ce
;
If FileExists(@ScriptDir & '\' & 'Button_UnDead.jpg') Then
	$_ButtonUnDead = GUICtrlCreatePic(@ScriptDir & '\' & 'Button_UnDead.jpg', 210, 490, 150, 150)
	GUICtrlSetOnEvent($_ButtonUnDead, "_UnDead")
Else
	$_ButtonUnDead = GUICtrlCreateButton('UnDead', 210, 490, 150, 150)
	GUICtrlSetOnEvent($_ButtonUnDead, "_UnDead")
EndIf
;
;
$PicSplash = GUICtrlCreatePic($Pic_Default, 450, 75, 800, 500)

$_LableName = GUICtrlCreateLabel('', 450, 590, 800, 50, $SS_CENTER)
GUICtrlSetFont(-1, 30, 400, 2, "Comic Sans MS")

$_StatusBar = _GUICtrlStatusBar_Create($hGUI, $_StatusParts, $_TempStatus, $SBARS_SIZEGRIP)
_GUICtrlStatusBar_SetMinHeight($_StatusBar, 40)
$_Icons = _WinAPI_LoadShell32Icon(128)
_GUICtrlStatusBar_SetIcon($_StatusBar, 0, $_Icons)

GUISetState(@SW_SHOW)
;
;
;
;; Links to youtube videos
; SPECIAL+
; http://www.youtube.com/watch?feature=player_embedded&v=ROhZJ_AIFTY ; skylander song (robot singing)
; https://www.youtube.com/watch?v=ROhZJ_AIFTY ; skylander song (robot singing)without adds
; http://www.youtube.com/watch?feature=player_embedded&v=w_YLRzhKszU ; commercial for giants
; http://www.youtube.com/watch?feature=player_embedded&v=eiT2moq7K0o ; commercial for giants 2
; http://www.youtube.com/watch?feature=player_embedded&v=SgnqHJQ84bg ; walk through from first skylanders
;http://www.youtube.com/watch?feature=player_embedded&v=68Qp2uiFidc ; legendayr bouncer
$sReward = 'https://www.youtube.com/v/ROhZJ_AIFTY' ; skylander song (robot singing)
$sreward2 = 'https://www.youtube.com/v/6km_xKhQyIw' ; chapt 11 walk through 20 mins with drill boss
$sReward3 = 'https://www.youtube.com/v/_XUUGg3jPws' ;chapt 16 walk through
;;;
;
;Air Elements
$sSwarm = 'http://www.youtube.com/v/JrMsYUGOvEE' ; ; Swarm Air  - GOOD
$sLightCoreJetVac = 'http://www.youtube.com/v/fljeEE2eAT4' ; LightCore Jet Vac Air
$sSonicBoom = 'http://www.youtube.com/v/Qjfeoz2HxO0' ; Sonic Boom
$sWhirlwind = 'http://www.youtube.com/v/he1hr-Ca7l4' ; Whirlwind
$sLightningRod = 'http://www.youtube.com/v/Hg2gUXxdhkM' ; Lightning Rod
$sJetVac = 'http://www.youtube.com/v/XbCDijoiijk' ; Jet Vac
;
; UnDead Elements
$sEyeBrawl = 'http://www.youtube.com/v/hdy5YBq4KQ8' ; Eye Brawler undead
$sLightCoreHex = 'http://www.youtube.com/v/SLpaesnFyoU' ;Lightcore Hex undead
$sCynder = 'http://www.youtube.com/v/iBlqxUFefXg' ; Cynder undead
$sChopChop = 'http://www.youtube.com/v/rOsbxvfvdIg' ; Chop Chop undead
$sHex = 'http://www.youtube.com/v/ROFcwumJWk8' ; Hex undead
$sFrightRider = 'http://www.youtube.com/v/LFYXvXdV-Yw' ; Fright Rider undead
;
; Water Elements
$sThumpback = 'http://www.youtube.com/v/gKjEjCcoDYQ' ; Thumpback Water  - GOOD
$sLightcoreChill = 'http://www.youtube.com/v/A2XsKzsm4DY' ; Lightcore chill Water
$sSlamBam = 'http://www.youtube.com/v/tsK6Xi27Gr0' ; Slam Bam water
;http://www.youtube.com/v/-6g_aBcYdnw ; another Slam Bam Water
$sZap = 'http://www.youtube.com/v/4c5gVs2cxm0' ; Zap Water
$sGillGrunt = 'http://www.youtube.com/v/nGivyHgAI-s' ; Gill Grunt Water
$sChill = 'http://www.youtube.com/v/zwuEgFY8g7c' ; Chill water
;
; Life Elements
$sTreeRex = 'http://www.youtube.com/v/jCPCSEAVv-U' ; Crusher Life  - GOOD
$sLightcoreShroomboom = 'http://www.youtube.com/v/Askgt6BR4DQ' ; lightcore shroomboom Life
$sStealthElf = 'http://www.youtube.com/v/uNgH8wkNViM' ; stealth elf life
$sZook = 'http://www.youtube.com/v/K8Xn-iudRVA' ; zook life
$sStumpSmash = 'http://www.youtube.com/v/rArknXHI8uY' ; stump smash life
$sShroomboom = 'http://www.youtube.com/v/vqJxEkM-Y-g' ; shroomboom life
;
; Magic Elements
$sNinJini = 'http://www.youtube.com/v/nII0XvH5XMY' ; NinJini magic - GOOD
$sLightcorePopfizz = 'http://www.youtube.com/v/xk51-6nDpLI' ; LightCore_Pop_fizz magic
$sSpyro = 'http://www.youtube.com/v/bmWEpnLNxN8' ;spyro magic
$sWreckingBall = 'http://www.youtube.com/v/py7nvjUhzZg' ; wrecking ball magic
$sDoubleTrouble = 'http://www.youtube.com/v/Rh5hAJbJ-l0' ;Double Trouble magic
$sPopfizz = 'http://www.youtube.com/v/r7HWQkwmXzM' ; pop fizz magic
;
; Fire Elements
$sHotHead = 'http://www.youtube.com/v/9cmj5sFzxV0' ; Hot Head Fire  - GOOD
$sLightCoreEruptor = 'http://www.youtube.com/vy5X_k7s2fAE' ; LightCorevEruptor fire
$sIgnitor = 'http://www.youtube.com/v/4nb6HLw3KSs' ; ignitor fire
$sFlameslinger = 'http://www.youtube.com/v/WjMcBb1LMlw' ; Flameslinger fire
$sHotDog = 'http://www.youtube.com/v/Y47i8fD8ggs' ; Hot dog fire
$sEruptor = 'http://www.youtube.com/v/MtW5M9Rdfos' ; Eruptor fire
;
; Earth Elements
$sCrusher = 'http://www.youtube.com/v/WfKkfd9ul9Y' ; Crusher Earth - GOOD
$sLightCorePrismBreak = 'http://www.youtube.com/v/tmMGA4hDrB0' ; Lightcore prism break earth
$sTerrafin = 'http://www.youtube.com/v/SnDe1iFbRqc' ;  Terrafin earth
$sBash = 'http://www.youtube.com/v/i_93cu4H8-I' ; bash earh
$sFlashwing = 'http://www.youtube.com/v/rh6rZmFkr_w' ; flashwing earth
$sPrismBreak = 'http://www.youtube.com/v/2ylhOJXK4nc' ; prism break earth
;
; Tech Elements
$sBouncer = 'http://www.youtube.com/v/eG5F-7ryrMc' ; Bouncer Tech  - GOOD
$sLightCoreDrobot = 'http://www.youtube.com/v/EW2AbDIbr-Q' ; lightcore drobot tech
$sDrillSergeant = 'http://www.youtube.com/v/QZlcZvlKYTU' ; Drill Sergeant tech
$sTriggerHappy = 'http://www.youtube.com/v/55GpiKs8odM' ; Trigger happy tech
$sSprocket = 'http://www.youtube.com/v/el2S18aq-K0' ; Sprocket tech
$sDrobot = 'http://www.youtube.com/v/gFMStT8JQRI'

; still need to finish the ramdom list of URLs
;
$sGiants = $sTreeRex & ',' & $sSwarm & ',' & $sThumpback & ',' & $sBouncer & ',' & $sCrusher & ',' & $sNinJini & ',' & $sEyeBrawl & ',' & $sHotHead
$sAir = $sLightCoreJetVac & ',' & $sSonicBoom & ',' & $sWhirlwind & ',' & $sLightningRod & ',' & $sJetVac
$sUnDead = $sLightCoreHex & ',' & $sCynder & ',' & $sChopChop & ',' & $sHex & ',' & $sFrightRider

$sCharacters = $sGiants & ',' & $sAir & ',' & $sUnDead & ','

$_LastUkTopChartsListArray = StringSplit($sCharacters, ',')
;_ArrayDisplay($_LastUkTopChartsListArray)
_ArrayDelete($_LastUkTopChartsListArray, UBound($_LastUkTopChartsListArray))
;_ArrayDisplay($_LastUkTopChartsListArray)

While 1
	Sleep(20)

	Do
		$_R = _Randomize($_LastUkTopChartsListArray[0])
	Until $_R <= UBound($_LastUkTopChartsListArray) - 1

	$_YoutubeEmbedUrl = $_LastUkTopChartsListArray[$_R]
	$_Text2 = $_YoutubeEmbedUrl

	;_GUICtrlStatusBar_SetText($_StatusBar, $_Spaces & ' Waiting for Next Video...', 0)
	;$Flash = _GuiCtrlCreateFlash($_YoutubeEmbedUrl)
	#cs
		$_DurationInit = TimerInit()
		$_DurationDiff = 0
		_WinSetOnTopOneTime($_GuiTitle)
		$_Loop = 1

		$count = 0

		While $_Loop
		$count += 1
		ConsoleWrite('!>' & $count & @CRLF)

		If $_DurationDiff > $_DurationMs Then
		$oIE.Stop
		$_Loop = 0
		_GUICtrlStatusBar_SetText($_StatusBar, '', 0)
		ExitLoop
		EndIf
		Sleep(20)
		$_DurationMs = $_Duration * 1000
		If $_Duration Then $_DurationDiff = Round(TimerDiff($_DurationInit))
		_TicksToTime($_DurationMs - $_DurationDiff, $Hour, $Min, $Sec)
		If $_Text2 Then _GUICtrlStatusBar_SetText($_StatusBar, $_Spaces & 'Top N?' & $_R & ' - ' & $_Text2 & ' - ' & StringFormat("%02i:%02i", $Min, $Sec), 0)
		WEnd
	#ce
WEnd
;
;
;
Func _Terminate()
	;MsgBox(0, "GUI Event", "Exiting...")
	Switch @GUI_WinHandle
		Case $_GuiName
			GUISetState(@SW_HIDE, $_GuiName)
			GUIDelete($_GuiName)

			GUICtrlSetData($_LableElement, StringUpper($HeaderTitle))
			GUICtrlSetData($_LableName, '')
			;#cs
			If $bNotConnect Or Not IsObj($oIE) Then
				GUICtrlSetImage($PicSplash, 'skylanders.jpg')
			Else
				ShowHTML('SkyLanders')
			EndIf
			_EnableMainGUI($_GuiTitle, True)

			; zero out score for bypassing typing answer
			$iReward = 0

		Case $_GuiAir
			GUISetState(@SW_HIDE, $_GuiAir)
			GUIDelete($_GuiAir)
			;GUICtrlSetData($_LableElement, StringUpper($HeaderTitle))
			;GUICtrlSetData($_LableName, '')
			#cs
				If $bNotConnect Or Not IsObj($oIE) Then
				GUICtrlSetImage($PicSplash, 'skylanders.jpg')
				Else
				ShowHTML('SkyLanders')
				EndIf
			#ce
			_EnableMainGUI($_GuiTitle, True)
		Case $_GuiUnDead
			GUISetState(@SW_HIDE, $_GuiUnDead)
			GUIDelete($_GuiUnDead)
			;GUICtrlSetData($_LableElement, StringUpper($HeaderTitle))
			;GUICtrlSetData($_LableName, '')
			#cs
				If $bNotConnect Or Not IsObj($oIE) Then
				GUICtrlSetImage($PicSplash, 'skylanders.jpg')
				Else
				ShowHTML('SkyLanders')
				EndIf
			#ce
			_EnableMainGUI($_GuiTitle, True)
		Case $_GuiWater
			GUISetState(@SW_HIDE, $_GuiWater)
			GUIDelete($_GuiWater)
			;GUICtrlSetData($_LableElement, StringUpper($HeaderTitle))
			;GUICtrlSetData($_LableName, '')
			#cs
				If $bNotConnect Or Not IsObj($oIE) Then
				GUICtrlSetImage($PicSplash, 'skylanders.jpg')
				Else
				ShowHTML('SkyLanders')
				EndIf
			#ce
			_EnableMainGUI($_GuiTitle, True)
		Case $_GuiLife
			GUISetState(@SW_HIDE, $_GuiLife)
			GUIDelete($_GuiLife)
			;GUICtrlSetData($_LableElement, StringUpper($HeaderTitle))
			;GUICtrlSetData($_LableName, '')
			#cs
				If $bNotConnect Or Not IsObj($oIE) Then
				GUICtrlSetImage($PicSplash, 'skylanders.jpg')
				Else
				ShowHTML('SkyLanders')
				EndIf
			#ce
			_EnableMainGUI($_GuiTitle, True)
		Case $_GuiMagic
			GUISetState(@SW_HIDE, $_GuiMagic)
			GUIDelete($_GuiMagic)
			;GUICtrlSetData($_LableElement, StringUpper($HeaderTitle))
			;GUICtrlSetData($_LableName, '')
			#cs
				If $bNotConnect Or Not IsObj($oIE) Then
				GUICtrlSetImage($PicSplash, 'skylanders.jpg')
				Else
				ShowHTML('SkyLanders')
				EndIf
			#ce
			_EnableMainGUI($_GuiTitle, True)

		Case $_GuiFire
			GUISetState(@SW_HIDE, $_GuiFire)
			GUIDelete($_GuiFire)
			;GUICtrlSetData($_LableElement, StringUpper($HeaderTitle))
			;GUICtrlSetData($_LableName, '')
			#cs
				If $bNotConnect Or Not IsObj($oIE) Then
				GUICtrlSetImage($PicSplash, 'skylanders.jpg')
				Else
				ShowHTML('SkyLanders')
				EndIf
			#ce
			_EnableMainGUI($_GuiTitle, True)

		Case $_GuiEarth
			GUISetState(@SW_HIDE, $_GuiEarth)
			GUIDelete($_GuiEarth)
			;GUICtrlSetData($_LableElement, StringUpper($HeaderTitle))
			;GUICtrlSetData($_LableName, '')
			#cs
				If $bNotConnect Or Not IsObj($oIE) Then
				GUICtrlSetImage($PicSplash, 'skylanders.jpg')
				Else
				ShowHTML('SkyLanders')
				EndIf
			#ce
			_EnableMainGUI($_GuiTitle, True)

		Case $_GuiTech
			GUISetState(@SW_HIDE, $_GuiTech)
			GUIDelete($_GuiTech)
			;GUICtrlSetData($_LableElement, StringUpper($HeaderTitle))
			;GUICtrlSetData($_LableName, '')
			#cs
				If $bNotConnect Or Not IsObj($oIE) Then
				GUICtrlSetImage($PicSplash, 'skylanders.jpg')
				Else
				ShowHTML('SkyLanders')
				EndIf
			#ce
			_EnableMainGUI($_GuiTitle, True)
		Case Else
			;MsgBox(0, "GUI Event", "You clicked CLOSE in the main window! Exiting...")
			If $bNotConnect Or Not IsObj($oIE) Then
				Exit
			Else
				If $_Loop Then
					$oIE.Stop
					$oIE = 0
				EndIf
				FileDelete(@TempDir & '\*.html')
				Exit
			EndIf
	EndSwitch

	_EnableMainGUI($_GuiTitle, True)

EndFunc   ;==>_Terminate
;
Func __CheckAnswer()
	If StringUpper(GUICtrlRead($_InputCheck)) = StringUpper($sNameHolder) And $sNameHolder <> '' Then
		GUISetState(@SW_HIDE, $_GuiName)
		GUIDelete($_GuiName)

		_EnableMainGUI($_GuiTitle, False)

		Switch $sNameHolder
			; Air Elements
			Case 'Swarm'
				MsgBox('', '$sSwarm ' & $sSwarm, 'Swarm')
				; Giant Swarm
				_GuiCtrlCreateFlash2($sSwarm)
				GUICtrlSetData($_LableName, StringUpper('Swarm'))
				$bPassed = True
			Case 'LightCore Jet Vac'
				;MsgBox('', '', 'LightCore Jet Vac')
				; LightCore_Jet_Vac
				_GuiCtrlCreateFlash($sLightCoreJetVac)
				GUICtrlSetData($_LableName, StringUpper('LightCore Jet Vac'))
				$bPassed = True
			Case 'Sonic Boom'
				;MsgBox('', '', 'Sonic Boom')
				; Sonic_Boom
				_GuiCtrlCreateFlash($sSonicBoom)
				GUICtrlSetData($_LableName, StringUpper('Sonic Boom'))
				$bPassed = True
			Case 'Whirlwind'
				;MsgBox('', '', 'Whirlwind')
				; Whirlwind
				_GuiCtrlCreateFlash($sWhirlwind)
				GUICtrlSetData($_LableName, StringUpper('Whirlwind'))
				$bPassed = True
			Case 'Lightning Rod'
				;MsgBox('', '', 'Lightning Rod')
				; Lightning Rod
				_GuiCtrlCreateFlash($sLightningRod)
				GUICtrlSetData($_LableName, StringUpper('Lightning Rod'))
				$bPassed = True
			Case 'Jet Vac'
				;MsgBox('', '', 'Jet Vac')
				; Jet Vac
				_GuiCtrlCreateFlash($sJetVac)
				GUICtrlSetData($_LableName, StringUpper('Jet Vac'))
				$bPassed = True
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;; UnDead Characters
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			Case 'Eye Brawl'
				;MsgBox('', '', 'Eye Brawl')
				; Eye Brawl
				_GuiCtrlCreateFlash($sEyeBrawl)
				GUICtrlSetData($_LableName, StringUpper('Eye Brawl'))
				$bPassed = True
			Case 'LightCore Hex'
				;MsgBox('', '', 'LightCoreHex')
				; LightCoreHex
				_GuiCtrlCreateFlash($sLightCoreHex)
				GUICtrlSetData($_LableName, StringUpper('LightCore Hex'))
				$bPassed = True
			Case 'Cynder'
				;MsgBox('', '', 'Cynder')
				; Cynder
				_GuiCtrlCreateFlash($sCynder)
				GUICtrlSetData($_LableName, StringUpper('Cynder'))
				$bPassed = True
			Case 'Chop Chop'
				;MsgBox('', '', 'Chop Chop')
				; Chop Chop
				_GuiCtrlCreateFlash($sChopChop)
				GUICtrlSetData($_LableName, StringUpper('Chop Chop'))
				$bPassed = True
			Case 'Hex'
				;MsgBox('', '', 'Hex')
				; Hex
				_GuiCtrlCreateFlash($sHex)
				GUICtrlSetData($_LableName, StringUpper('Hex'))
				$bPassed = True
			Case 'Fright Rider'
				;MsgBox('', '', 'Fright Rider')
				; Fright Rider
				_GuiCtrlCreateFlash($sFrightRider)
				GUICtrlSetData($_LableName, StringUpper('Fright Rider'))
				$bPassed = True
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;; Water Characters
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			Case 'Thumpback'
				;MsgBox('', '', 'Thumpback')
				; Thumpback
				_GuiCtrlCreateFlash($sThumpback)
				GUICtrlSetData($_LableName, (StringUpper('Thumpback')))
				$bPassed = True
			Case 'Lightcore Chill'
				;MsgBox('', '', 'Lightcore Chill')
				; Lightcore Chill
				_GuiCtrlCreateFlash($sLightcoreChill)
				GUICtrlSetData($_LableName, StringUpper('Lightcore Chill'))
				$bPassed = True
			Case 'Slam Bam'
				;MsgBox('', '', 'Slam Bam')
				; Slam Bam
				_GuiCtrlCreateFlash($sSlamBam)
				GUICtrlSetData($_LableName, StringUpper('Slam Bam'))
				$bPassed = True
			Case 'Zap'
				;MsgBox('', '', 'Zap')
				; Zap
				_GuiCtrlCreateFlash($sZap)
				GUICtrlSetData($_LableName, StringUpper('Zap'))
				$bPassed = True
			Case 'Gill Grunt'
				;MsgBox('', '', 'Gill Grunt')
				; Gill Grunt
				_GuiCtrlCreateFlash($sGillGrunt)
				GUICtrlSetData($_LableName, StringUpper('Gill Grunt'))
				$bPassed = True
			Case 'Chill'
				;MsgBox('', '', 'Chill')
				; Chill
				$_GUIActiveX = _GuiCtrlCreateFlash($sChill)
				#cs
					If IsArray($_GUIActiveX) Then
					_ArrayDisplay($_GUIActiveX)
					Else
					MsgBox('',GUICtrlRead($_GUIActiveX),$_GUIActiveX)
					$_GUIActiveX = ''
					EndIf
				#ce
				GUICtrlSetData($_LableName, StringUpper('Chill'))
				$bPassed = True
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;; Life Characters
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			Case 'Tree Rex'
				;MsgBox('', '', 'Tree Rex')
				; Tree Rex
				_GuiCtrlCreateFlash($sTreeRex)
				GUICtrlSetData($_LableName, (StringUpper('Tree Rex')))
				$bPassed = True
			Case 'LightCore Shroomboom'
				;MsgBox('', '', 'LightCore Shroomboom')
				; LightCore Shroomboom
				_GuiCtrlCreateFlash($sLightcoreShroomboom)
				GUICtrlSetData($_LableName, (StringUpper('LightCore Shroomboom')))
				$bPassed = True
			Case 'Stealth Elf'
				;MsgBox('', '', 'Stealth Elf)
				; Stealth Elf
				_GuiCtrlCreateFlash($sStealthElf)
				GUICtrlSetData($_LableName, (StringUpper('Stealth Elf')))
				$bPassed = True
			Case 'Zook'
				;MsgBox('', '', 'Zook)
				; Zook
				_GuiCtrlCreateFlash($sZook)
				GUICtrlSetData($_LableName, (StringUpper('Zook')))
				$bPassed = True
			Case 'Stump Smash'
				;MsgBox('', '', 'Stump Smash')
				; Stump Smash
				_GuiCtrlCreateFlash($sStumpSmash)
				GUICtrlSetData($_LableName, (StringUpper('Stump Smash')))
				$bPassed = True
			Case 'Shroomboom'
				;MsgBox('', '', 'Shroomboom')
				; Shroomboom
				_GuiCtrlCreateFlash($sShroomboom)
				GUICtrlSetData($_LableName, (StringUpper('Shroomboom')))
				$bPassed = True
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;; Magic Characters
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			Case 'Ninjini'
				;MsgBox('', '', 'Ninjin')
				; Ninjin
				_GuiCtrlCreateFlash($sNinJini)
				GUICtrlSetData($_LableName, (StringUpper('Ninjini')))
				$bPassed = True
			Case 'Lightcore Pop fizz'
				;MsgBox('', '', 'Lightcore Pop fizz')
				; Lightcore Pop fizz
				_GuiCtrlCreateFlash($sLightcorePopfizz)
				GUICtrlSetData($_LableName, (StringUpper('Lightcore Pop fizz')))
				$bPassed = True
			Case 'Spyro'
				;MsgBox('', '', 'Spyro')
				; Spyro
				_GuiCtrlCreateFlash($sSpyro)
				GUICtrlSetData($_LableName, (StringUpper('Spyro')))
				$bPassed = True
			Case 'Wrecking Ball'
				;MsgBox('', '', 'Wrecking Ball')
				; Wrecking Ball
				_GuiCtrlCreateFlash($sWreckingBall)
				GUICtrlSetData($_LableName, (StringUpper('Wrecking Ball')))
				$bPassed = True
			Case 'Double Trouble'
				;MsgBox('', '', 'Double Trouble')
				; Double Trouble
				_GuiCtrlCreateFlash($sDoubleTrouble)
				GUICtrlSetData($_LableName, (StringUpper('Double Trouble')))
				$bPassed = True
			Case 'Pop fizz'
				;MsgBox('', '', 'Pop fizz')
				; Pop fizz
				_GuiCtrlCreateFlash($sPopfizz)
				GUICtrlSetData($_LableName, (StringUpper('Pop fizz')))
				$bPassed = True
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;; Fire Characters
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			Case 'Hot Head'
				;MsgBox('', '', 'Hot Head')
				; Hot Head
				_GuiCtrlCreateFlash($sHotHead)
				GUICtrlSetData($_LableName, (StringUpper('Hot Head')))
				$bPassed = True
			Case 'LightCore Eruptor'
				;MsgBox('', '', 'LightCore Eruptor')
				; LightCore Eruptor
				_GuiCtrlCreateFlash($sLightCoreEruptor)
				GUICtrlSetData($_LableName, (StringUpper('LightCore Eruptor')))
				$bPassed = True
			Case 'Ignitor'
				;MsgBox('', '', 'Ignitor')
				; Ignitor
				_GuiCtrlCreateFlash($sIgnitor)
				GUICtrlSetData($_LableName, (StringUpper('Ignitor')))
				$bPassed = True
			Case 'Flameslinger'
				;MsgBox('', '', 'Flameslinger')
				; Flameslinger
				_GuiCtrlCreateFlash($sFlameslinger)
				GUICtrlSetData($_LableName, (StringUpper('Flameslinger')))
				$bPassed = True
			Case 'Hot Dog'
				;MsgBox('', '', 'Hot Dog')
				; Hot Dog
				_GuiCtrlCreateFlash($sHotDog)
				GUICtrlSetData($_LableName, (StringUpper('Hot Dog')))
				$bPassed = True
			Case 'Eruptor'
				;MsgBox('', '', 'Eruptor')
				; Eruptor
				_GuiCtrlCreateFlash($sEruptor)
				GUICtrlSetData($_LableName, (StringUpper('Eruptor')))
				$bPassed = True
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;; Earth Characters
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			Case 'Crusher'
				;MsgBox('', '', 'Crusher')
				; Crusher
				_GuiCtrlCreateFlash($sCrusher)
				GUICtrlSetData($_LableName, (StringUpper('Crusher')))
				$bPassed = True
			Case 'LightCore Prism Break'
				;MsgBox('', '', 'LightCore Prism Break')
				; LightCore Prism Break
				_GuiCtrlCreateFlash($sLightCorePrismBreak)
				GUICtrlSetData($_LableName, (StringUpper('LightCore Prism Break')))
				$bPassed = True
			Case 'Terrafin'
				;MsgBox('', '', 'Terrafin')
				; Terrafin
				_GuiCtrlCreateFlash($sTerrafin)
				GUICtrlSetData($_LableName, (StringUpper('Terrafin')))
				$bPassed = True
			Case 'Bash'
				;MsgBox('', '', 'Bash')
				; Bash
				_GuiCtrlCreateFlash($sBash)
				GUICtrlSetData($_LableName, (StringUpper('Bash')))
				$bPassed = True
			Case 'Flashwing'
				;MsgBox('', '', 'Flashwing')
				; Flashwing
				_GuiCtrlCreateFlash($sFlashwing)
				GUICtrlSetData($_LableName, (StringUpper('Flashwing')))
				$bPassed = True
			Case 'Prism Break'
				;MsgBox('', '', 'Prism Break')
				; Prism Break
				_GuiCtrlCreateFlash($sPrismBreak)
				GUICtrlSetData($_LableName, (StringUpper('Prism Break')))
				$bPassed = True
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;;;; Earth Characters
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			Case 'Bouncer'
				;MsgBox('', '', 'Bouncer')
				; Bouncer
				_GuiCtrlCreateFlash($sBouncer)
				GUICtrlSetData($_LableName, (StringUpper('Bouncer')))
				$bPassed = True
			Case 'Lightcore Drobot'
				;MsgBox('', '', 'Lightcore Drobot')
				; Lightcore Drobot
				_GuiCtrlCreateFlash($sLightCoreDrobot)
				GUICtrlSetData($_LableName, (StringUpper('Lightcore Drobot')))
				$bPassed = True
			Case 'Drill Sergeant'
				;MsgBox('', '', 'Drill Sergeant')
				; Drill Sergeant
				_GuiCtrlCreateFlash($sDrillSergeant)
				GUICtrlSetData($_LableName, (StringUpper('Drill Sergeant')))
				$bPassed = True
			Case 'Trigger Happy'
				;MsgBox('', '', 'Trigger Happy')
				; Trigger Happy
				_GuiCtrlCreateFlash($sTriggerHappy)
				GUICtrlSetData($_LableName, (StringUpper('Trigger Happy')))
				$bPassed = True
			Case 'Sprocket'
				;MsgBox('', '', 'Sprocket')
				; Sprocket
				_GuiCtrlCreateFlash($sSprocket)
				GUICtrlSetData($_LableName, (StringUpper('Sprocket')))
				$bPassed = True
			Case 'Drobot'
				;MsgBox('', '', 'Drobot')
				; Drobot
				_GuiCtrlCreateFlash($sDrobot)
				GUICtrlSetData($_LableName, (StringUpper('Drobot')))
				$bPassed = True
				;
				;
			Case Else
				_EnableMainGUI($_GuiTitle, False)
				GUISetState(@SW_HIDE, $_GuiName)
				MsgBox('', 'Data Not Found', 'The Character Name was not found' & @CRLF & @CRLF & '- please make sure it is added  -->>' & $sNameHolder)
				GUISetState(@SW_SHOW, $_GuiName)

				_EnableMainGUI($_GuiTitle, False)
				;
				$iReward = 0
		EndSwitch

		If $bPassed Then
			$iReward += 1
			If Mod($iReward, 3) = 0 Then
				GUICtrlSetData($_LableElement, $sChildsName & ' -->> 3 Times')
				_GuiCtrlCreateFlash($sReward)
				GUICtrlSetData($_LableName, StringUpper('Drill Boss Song'))
			EndIf
			If Mod($iReward, 9) = 0 Then
				GUICtrlSetData($_LableElement, 'Logan Cole Thompson -->> 9 Times')
				_GuiCtrlCreateFlash($sreward2)
				GUICtrlSetData($_LableName, StringUpper('Chapt 11 Walk Through with Drill Boss Song'))
			EndIf
			If Mod($iReward, 17) = 0 Then
				GUICtrlSetData($_LableElement, 'Logan Cole Thompson -->> 20 Times')
				_GuiCtrlCreateFlash($sReward3)
				GUICtrlSetData($_LableName, StringUpper('Chapt 16 Walk Through'))
			EndIf


			$bPassed = False
		EndIf
		$sAnswer = ''
		$sNameHolder = ''
	Else
		_EnableMainGUI($_GuiTitle, False)
		GUISetState(@SW_HIDE, $_GuiName)
		MsgBox(262144, 'SORRY', 'THE CODE ENTERED WAS NOT CORRECT - CHANGE IT TO ' & StringUpper($sNameHolder))
		GUISetState(@SW_SHOW, $_GuiName)
		; put the answer back to blank
		GUICtrlSetData($_InputCheck, '')

		_EnableMainGUI($_GuiTitle, False)
		WinActivate($_GuiName)
		$iReward = 0

		$sAnswer = ''
		$sNameHolder = ''

		; bypass last call to activate main gui
		Return
	EndIf

	_EnableMainGUI($_GuiTitle, True)

EndFunc   ;==>__CheckAnswer
;
Func _EnableMainGUI($hMainGUI, $bEnable = False)
	If $bEnable Then WinSetState($hMainGUI, '', @SW_ENABLE)
	WinActivate($hMainGUI)
EndFunc   ;==>_EnableMainGUI
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func _CheckErrors($_ERROR)
	MsgBox('', 'ERROR', 'ERROR ' & $_ERROR)
EndFunc   ;==>_CheckErrors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;
Func SpeakName($sName)
	_SpeechGet($sName)
	_EnableMainGUI($_GuiTitle, True)
EndFunc   ;==>SpeakName
;
Func CharacterAttributes(ByRef $GUI, $sType, $sShowName, $Pic_JPG, $Pic_PNG, $sStory)
	ConsoleWrite('!> Called - ' & 'CharacterAttributes' & @CRLF)
	;
	; hide and delete calling gui
	GUISetState(@SW_HIDE, $GUI)
	GUIDelete($GUI)

	;
	GUICtrlSetData($_LableName, StringUpper($sShowName))
	If $bNotConnect Or Not IsObj($oIE) Then
		;MsgBox('', $sShowName, 'pop')
		GUICtrlSetImage($PicSplash, $Pic_JPG)
		_SpeechGet($sStory)
	Else
		;MsgBox('', $sShowName, 'pop')
		ShowHTML($Pic_PNG, '.png')
		_SpeechGet($sStory, 1)
	EndIf
	GetSkyLanderName(StringUpper($sType), $sShowName)
	;
	ConsoleWrite('!> Ending called funciont: ' & 'CharacterAttributes' & @CRLF)
	;
EndFunc   ;==>CharacterAttributes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func MakeCharGUI(ByRef $ButtonControlName, $sShowName, $sPic_JPG, $OnEvent, $iLeftPic, $iTopPic, $iWidthPic, $iHeightPic, ByRef $LableControlName, $iLeftLable, $iTopLable, $iWidthLable, $iHeightLable)
	ConsoleWrite('!> Called - ' & 'MakeCharGUI' & @CRLF)
	;
	If FileExists($sPic_JPG) Then
		$ButtonControlName = GUICtrlCreatePic($sPic_JPG, $iLeftPic, $iTopPic, $iWidthPic, $iHeightPic)
		If @error Then _CheckErrors(@error)
		GUICtrlSetOnEvent($ButtonControlName, $OnEvent)
		If @error Then _CheckErrors(@error)
		If StringLen($sShowName) > 10 Then
			; StringMid($sShowName, 0, StringInStr($sShowName)
			; StringUpper($sShowName)

			$LableControlName = GUICtrlCreateLabel(StringUpper(StringUpper($sShowName)), $iLeftLable, $iTopLable, $iWidthLable, $iHeightLable)
			If @error Then _CheckErrors(@error)
			GUICtrlSetOnEvent($LableControlName, $OnEvent)
			If @error Then _CheckErrors(@error)
			GUICtrlSetFont(-1, 20, 400, 1, $font)
			If @error Then _CheckErrors(@error)
		Else
			$LableControlName = GUICtrlCreateLabel(StringUpper($sShowName), $iLeftLable, $iTopLable, $iWidthLable, $iHeightLable)
			If @error Then _CheckErrors(@error)
			GUICtrlSetOnEvent($LableControlName, $OnEvent)
			If @error Then _CheckErrors(@error)
			GUICtrlSetFont(-1, 20, 400, 1, $font)
			If @error Then _CheckErrors(@error)
		EndIf
	Else
		;MsgBox('', 'Missing Image', 'Using buttons instead of images, as they are not installed', 1)
		$ButtonControlName = GUICtrlCreateButton($sShowName, $iLeftPic, $iTopPic, $iWidthPic, $iHeightPic)
		GUICtrlSetOnEvent($ButtonControlName, $OnEvent)
	EndIf
	;
	ConsoleWrite('!> Ending called function: ' & 'MakeCharGUI' & @CRLF)
	;
EndFunc   ;==>MakeCharGUI
;
;;;;;;;;;;;;;;;;;;;;;;;;;;
; below should be done - maybe some tweaking???
;;;;;;;;;;;;;;;;;;;;;;;;;;
;

Func __Tech()
	ConsoleWrite('!> Called - ' & '__Life' & @CRLF)
	;
	Local $sStoryBouncer = 'Bouncer Story' & '|' & "Long ago, Bouncer was an All-Star Roboto Ball player.  But when the evil Arkeyan Empire destroyed his home town, and discontinued the games, he was converted into a security-bot, and stationed in the mines.  It was there that Bouncer encountered dozens of Mabu prisoners, who remembered him fondly from his playing days. He quickly became a bit of a celebrity around the mines, and it was not long before this new adulation, convinced him that he could be just as much of a hero in life. as he was on the field.  Thus, he decided to join the Skylanders, and take a stand against the evil, Arkeyan overlords."
	Local $sStoryLightcoreDrobot = 'Lightcore Drobot Story' & '|' & "Dragons are smart, but none so much as Drobot. He was born in the highest reaches of Skylands, where dragons spent all their time competing in aerial battles. But Drobot was more interested in taking things apart, to see how they worked. While exploring one day, he came upon some mysterious technology, which he used to assemble a robotic suit. Features include laser beams that shoot from his eyes, flight enhancement technology, a vocal synthesizer that gives him a deep booming voice, and the ability to shoot spinning gears.  With such power, more than most other dragons, Drobot joined the Skylanders to help protect the residents of Skylands."
	Local $sStoryDrillSergeant = 'Drill Sergeant Story' & '|' & "Like many Arkeyan artifacts, Drill Sergeant was buried for centuries. A a long forgotten remnant of an ancient powerful civilization. It was only a chance collision with a burrowing Terrafin, that led to his systems firing up again. By Arkeyan custom, Drill Sergeant was then obligated to become Terrafin?s servant. This did not sit well with the dirt shark, so his first order as master, was for Drill Sergeant to not serve him at all. A command he continues to follow zealously to this day."
	Local $sStoryTriggerHappy = 'Trigger Happy Story' & '|' & "Trigger Happy is more than his name it is his solution to every problem. Nobody knows from where he came. He just showed up one day in a small village, saving it from a group of terrorizing bandits, by blasting gold coins everywhere with his custom-crafted shooters. Similar tales were soon heard from other villages, and his legend quickly grew. Now everyone in all of Skylands, knows of the crazy goldslinger, that will take down any bad guy, usually without bothering to aim."
	Local $sStorySprocket = 'Sprocket Story' & '|' & "Sprocket was raised with all the privileges of a rich, proper Goldling. But she cared little for fancy things. Instead, she spent most of her time growing up in her uncle's workshop, learning how to build and fix his many mechanical inventions. But everything changed on the day her uncle mysteriously vanished.  When she eventually discovered, that Kaos had been behind his disappearance, she constructed a battle suit and went after him, leaving the luxury and comfort of her family's wealth behind. From that moment on, Sprocket was dedicated to fighting the forces of evil, while never losing hope, that she would be reunited with her beloved uncle."
	Local $sStoryDrobot = 'Drobot Story' & '|' & "Dragons are smart, but none so much as Drobot. He was born in the highest reaches of Skylands, where dragons spent all their time competing in aerial battles. But Drobot was more interested in taking things apart, to see how they worked. While exploring one day, he came upon some mysterious technology, which he used to assemble a robotic suit. Features include laser beams that shoot from his eyes, flight enhancement technology, a vocal synthesizer that gives him a deep booming voice, and the ability to shoot spinning gears.  With such power, more than most other dragons, Drobot joined the Skylanders to help protect the residents of Skylands."
	;
	Local $Pic_Bouncer = @ScriptDir & '\Bouncer.jpg'
	Local $Pic_LightcoreDrobot = @ScriptDir & '\LightCore_Drobot.jpg'
	Local $Pic_DrillSergeant = @ScriptDir & '\Drill_Sergeant.jpg'
	Local $Pic_TriggerHappy = @ScriptDir & '\Trigger_Happy.jpg'
	Local $Pic_Sprocket = @ScriptDir & '\Sprocket.jpg'
	Local $Pic_Drobot = @ScriptDir & '\Drobot.jpg'
	;
	ConsoleWrite('!> Killing GUI-Tech- ' & 'Still in function __Tech' & @CRLF)
	;
	;
	Switch @GUI_CtrlId
		Case $_ButtonTechBouncer
			CharacterAttributes($_GuiTech, 'Tech', 'Bouncer', $Pic_Bouncer, 'Bouncer', $sStoryBouncer)
		Case $_LableTechBouncer
			SpeakName('Bouncer')
			;
		Case $_ButtonTechLightCoreDrobot
			CharacterAttributes($_GuiTech, 'Tech', 'Lightcore Drobot', $Pic_LightcoreDrobot, 'Lightcore_Drobot', $sStoryLightcoreDrobot)
		Case $_LableTechLightCoreDrobot
			SpeakName('Drobot')
			;
		Case $_ButtonTechDrillSergeant
			CharacterAttributes($_GuiTech, 'Tech', 'Drill Sergeant', $Pic_DrillSergeant, 'Drill_Sergeant', $sStoryDrillSergeant)
		Case $_LableTechDrillSergeant
			SpeakName('Drill Sergeant')
			;
		Case $_ButtonTechTriggerHappy
			CharacterAttributes($_GuiTech, 'Tech', 'Trigger Happy', $Pic_TriggerHappy, 'Trigger_Happy', $sStoryTriggerHappy)
		Case $_LableTechTriggerHappy
			SpeakName('Trigger Happy')
			;
		Case $_ButtonTechSprocket
			CharacterAttributes($_GuiTech, 'Tech', 'Sprocket', $Pic_Sprocket, 'Sprocket', $sStorySprocket)
		Case $_LableTechSprocket
			SpeakName('Sprocket')
			;
		Case $_ButtonTechDrobot
			CharacterAttributes($_GuiTech, 'Tech', 'Drobot', $Pic_Drobot, 'Drobot', $sStoryDrobot)
		Case $_LableTechDrobot
			SpeakName('Drobot')
			;
			;
		Case Else
			ConsoleWrite('!> Nothing MATCHED in button clicked: ' & '__Tech' & @CRLF)
			MsgBox('', '__Tech', 'Nothing MATCHED in button ' & @GUI_CtrlId)
	EndSwitch
	ConsoleWrite('!> Ending called function: ' & '__Tech' & @CRLF)
EndFunc   ;==>__Tech
;
Func _Tech()
	Local $iPad = 10, $iTop = 25
	GUISetState(@SW_DISABLE, $_GuiTitle)
	GUICtrlSetData($_LableElement, 'Tech')
	$_GuiLife = GUICreate('Tech Element', 970, 250, -1, -1, $WS_SYSMENU + $WS_CAPTION, $WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")
	;
	MakeCharGUI($_ButtonTechBouncer, 'Bouncer', 'Bouncer.jpg', "__Tech", $iPad + 0, $iTop, 150, 150, $_LableTechBouncer, $iPad + 10, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonTechLightCoreDrobot, 'LightCore Drobot', 'LightCore_Drobot.jpg', "__Tech", $iPad + 160, $iTop, 150, 150, $_LableTechLightCoreDrobot, $iPad + 155, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonTechDrillSergeant, 'Drill Sergeant', 'Drill_Sergeant.jpg', "__Tech", $iPad + 320, $iTop, 150, 150, $_LableTechDrillSergeant, $iPad + 325, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonTechTriggerHappy, 'Trigger Happy', 'Trigger_Happy.jpg', "__Tech", $iPad + 480, $iTop, 150, 150, $_LableTechTriggerHappy, $iPad + 495, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonTechSprocket, 'Sprocket', 'Sprocket.jpg', "__Tech", 640 + $iPad, $iTop, 150, 150, $_LableTechSprocket, $iPad + 645, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonTechDrobot, 'Drobot', 'Drobot.jpg', "__Tech", $iPad + 800, $iTop, 150, 150, $_LableTechDrobot, $iPad + 825, 155 + $iTop, 150, 100)
	;
	GUISetState(@SW_SHOW, $_GuiTech)

EndFunc   ;==>_Tech
;
Func __Earth()
	ConsoleWrite('!> Called - ' & '__Life' & @CRLF)
	;
	Local $sStoryCrusher = 'Crusher Story' & '|' & "Crusher knew from the moment he put on his father's mining helmet, that his true passion in life was crushing rocks. He was fascinated with rock-lore and traveled all throughout Skylands, in search of rare minerals to pulverize, with his powerful hand-crafted rock hammer, which he also named Crusher. But along his travels, he discovered that the evil Arkeyan King, was also searching for rocks, to melt down into weapons of war. Crusher's fury built up like an avalanche. After all, crushing was his job! So he put aside his life?s passion, and decided to use his hammer for a greater purpose, crushing Arkeyan Robots!"
	Local $sStoryLightcorePrismBreak = 'Lightcore Prism Break Story' & '|' & "Prism Break was once a fearsome rock golem who did not like to be disturbed. Then, an accidental cave-in left him buried underground. One hundred years later, a mining expedition, digging for valuable jewels discovered him by chance, with a well-placed blow from a pick axe, something Prism Break does n0t talk about. After 100 years of solitude, he found that the pressure of the earth, had transformed him emotionally, as well as physically, turning his crude rocky arms into incredible gems, with powerful energy. Grateful for being free of his earthly prison, Prism Break decided to put his new abilities to good use, and dedicated himself to protecting Skylands."
	Local $sStoryTerrafin = 'Terrafin Story' & '|' & "Terrafin hails from The Dirt Seas, where it was common to swim, bathe, and even snorkel beneath the ground.  But a powerful explosion in the sky, created a blast wave, that turned the ocean of sand into a vast sheet of glass, putting an end to Terrafin?s duty as the local lifeguard. Not one to stay idle, the brawny dirt shark found himself training in the art of boxing, and not long after he was local champ. Fighters came from all around to challenge him, but it was a chance meeting, with a great Portal Master, that led him to give up his title for a greater purpose."
	Local $sStoryBash = 'Bash Story' & '|' & "Bash spent most of his early dragonhood staring into the sky, watching the flying creatures of Skylands soar amongst the clouds. Determined to join them, he learned how to curl himself into a ball, and roll with incredible momentum in a vain attempt to take flight. Over the years, his skin hardened, forming a natural protective armor, unlike any other creature. He now thunders through Skylands, leaving a wake of destruction against any who threaten it. Despite his thick skin, he still gets a bit touchy about his inability to fly."
	Local $sStoryFlashwing = 'Flashwing Story' & '|' & "Flashwing's true origins are a mystery. But her first appearance came, when Bash made a wish that he could fly, and looked up to see a shooting star streak across the sky, and land in a valley below. In the center of the glowing impact crater was a large, brilliant geode, which suddenly cracked open to reveal Flashwing. Bash may not have soared that day, but his heart sure did, because Flashwing was beautifuL and lethal. As soon as Bash stepped closer, the gem dragon turned towards him. Not knowing if he was friend or foe, she blasted him off of the cliff, with a full force laser pulse from her tail!  Perhaps Bash flew that day after all."
	Local $sStoryPrismBreak = 'Prism Break Story' & '|' & "Prism Break was once a fearsome rock golem who did not like to be disturbed. Then, an accidental cave-in left him buried underground. One hundred years later, a mining expedition, digging for valuable jewels discovered him by chance, with a well-placed blow from a pick axe, something Prism Break does n0t talk about. After 100 years of solitude, he found that the pressure of the earth, had transformed him emotionally, as well as physically, turning his crude rocky arms into incredible gems, with powerful energy. Grateful for being free of his earthly prison, Prism Break decided to put his new abilities to good use, and dedicated himself to protecting Skylands."
	;
	Local $Pic_Crusher = @ScriptDir & '\Crusher.jpg'
	Local $Pic_LightcorePrismBreak = @ScriptDir & '\LightCore_Prism_Break.jpg'
	Local $Pic_Terrafin = @ScriptDir & '\Terrafin.jpg'
	Local $Pic_Bash = @ScriptDir & '\Bash.jpg'
	Local $Pic_Flashwing = @ScriptDir & '\Flashwing.jpg'
	Local $Pic_PrismBreak = @ScriptDir & '\Prism_Break.jpg'
	;
	ConsoleWrite('!> Killing GUI-Earth- ' & 'Still in function __Earth' & @CRLF)
	;
	;
	Switch @GUI_CtrlId
		Case $_ButtonEarthCrusher
			CharacterAttributes($_GuiEarth, 'Earth', 'Crusher', $Pic_Crusher, 'Crusher', $sStoryCrusher)
		Case $_LableEarthCrusher
			SpeakName('Crusher')
			;
		Case $_ButtonEarthLightCorePrismBreak
			CharacterAttributes($_GuiEarth, 'Earth', 'Lightcore Prism Break', $Pic_LightcorePrismBreak, 'Lightcore_Prism_Break', $sStoryLightcorePrismBreak)
		Case $_LableEarthLightCorePrismBreak
			SpeakName('LightCore Prism Break')
			;
		Case $_ButtonEarthTerrafin
			CharacterAttributes($_GuiEarth, 'Earth', 'Terrafin', $Pic_Terrafin, 'Terrafin', $sStoryTerrafin)
		Case $_LableEarthTerrafin
			SpeakName('Terrafin')
			;
		Case $_ButtonEarthBash
			CharacterAttributes($_GuiEarth, 'Earth', 'Bash', $Pic_Bash, 'Bash', $sStoryBash)
		Case $_LableEarthBash
			SpeakName('Bash')
			;
		Case $_ButtonEarthFlashwing
			CharacterAttributes($_GuiEarth, 'Earth', 'Flashwing', $Pic_Flashwing, 'Flashwing', $sStoryFlashwing)
		Case $_LableEarthFlashwing
			SpeakName('Flashwing')
			;
		Case $_ButtonEarthPrismBreak
			CharacterAttributes($_GuiEarth, 'Earth', 'Prism Break', $Pic_PrismBreak, 'Prism_Break', $sStoryPrismBreak)
		Case $_LableEarthPrismBreak
			SpeakName('Prism Break')
			;
			;
		Case Else
			ConsoleWrite('!> Nothing MATCHED in button clicked: ' & '__Earth' & @CRLF)
			MsgBox('', '__Earth', 'Nothing MATCHED in button ' & @GUI_CtrlId)
	EndSwitch
	ConsoleWrite('!> Ending called function: ' & '__Earth' & @CRLF)
EndFunc   ;==>__Earth
;
Func _Earth()
	Local $iPad = 10, $iTop = 25
	GUISetState(@SW_DISABLE, $_GuiTitle)
	GUICtrlSetData($_LableElement, 'Earth')
	$_GuiLife = GUICreate('Earth Element', 970, 250, -1, -1, $WS_SYSMENU + $WS_CAPTION, $WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")
	;
	MakeCharGUI($_ButtonEarthCrusher, 'Crusher', 'Crusher.jpg', "__Earth", $iPad + 0, $iTop, 150, 150, $_LableEarthCrusher, $iPad + 10, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonEarthLightCorePrismBreak, 'LightCore Prism Break', 'LightCore_Prism_Break.jpg', "__Earth", $iPad + 160, $iTop, 150, 150, $_LableEarthLightCorePrismBreak, $iPad + 148, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonEarthTerrafin, 'Terrafin', 'Terrafin.jpg', "__Earth", $iPad + 320, $iTop, 150, 150, $_LableEarthTerrafin, $iPad + 325, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonEarthBash, 'Bash', 'Bash.jpg', "__Earth", $iPad + 480, $iTop, 150, 150, $_LableEarthBash, $iPad + 510, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonEarthFlashwing, 'Flashwing', 'Flashwing.jpg', "__Earth", 640 + $iPad, $iTop, 150, 150, $_LableEarthFlashwing, $iPad + 630, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonEarthPrismBreak, 'Prism Break', 'Prism_Break.jpg', "__Earth", $iPad + 800, $iTop, 150, 150, $_LableEarthPrismBreak, $iPad + 825, 155 + $iTop, 150, 100)
	;
	GUISetState(@SW_SHOW, $_GuiEarth)

EndFunc   ;==>_Earth
;
;
Func __Fire()
	ConsoleWrite('!> Called - ' & '__Life' & @CRLF)
	;
	Local $sStoryHotHead = 'Hot Head Story' & '|' & 'Hot Head had always been a short tempered fire giant. But it was when magical oil was discovered in Skylands, that fuel was really added to the fire. As exciting as the discovery was, the celebration lasted only 5 minutes, coming to an abrupt halt when Hot Head needed to cool off, and plunged into the thick black pool, causing the entire island to explode!  Though it would be another 2,000 years, before magical oil was discovered again, the impact that it had on Hot Head was immediate. He was instantly infused with magical oil, giving him the ability to generate an infinite supply of fuel. making him incredibly volatile, highly combustible, and ready to torch anything that got in his way.'
	Local $sStoryLightcoreEruptor = 'Lightcore Eruptor Story' & '|' & 'Eruptor is a force of nature, hailing from a species that lived deep in the underground. of a floating volcanic island, until a massive eruption launched their entire civilization to the surface. He is a complete hot head, steaming, fuming, and quite literally erupting over almost anything. To help control his temper, he likes to relax in lava pools, particularly because there are no crowds.'
	Local $sStoryIgnitor = 'Ignitor Story' & '|' & "On his first quest as a knight, Ignitor was tricked, by a cunning witch into wearing a magical suit of armor, that he was told would resist fire from a dragon.  But as it turned out, it was made of cursed steel.  He journeyed to a dragon's lair, where a single blast of fire transformed him into a blazing spirit, binding him to the suit of armor for eternity.  Despite this setback, Ignitor remains a spirited knight, who is always fired up to protect Skylands from evil, and find the witch that tricked him."
	Local $sStoryFlameslinger = 'Flameslinger Story' & '|' & 'Flameslinger is an Elven archer with incredible aim. In fact, he is so good that he wears a blindfold just to prove it. When he was young, he rescued a fire spirit from a watery doom, and was gifted an enchanted bow, and magical fire boots, that he now masterfully uses to defeat evil throughout Skylands. With the scorched earth he leaves behind, you can always tell where he has been.'
	Local $sStoryHotDog = 'Hot Dog Story' & '|' & "Hot Dog was born in the belly of the Popcorn Volcano. While on a nearby mission, a team of Skylanders had come across the stray fire pup, when the volcano erupted and Hot Dog came rocketing, straight into their camp, accidentally setting Gill Grunt's tent on fire. Using his nose for danger, he helped the Skylanders complete their mission,- even pouncing on a lava golem, like a blazing comet when it threatened his new friends. After displaying such loyalty and bravery, Hot Dog was brought back to Eon's Citadel, where he became a Skylander, and then he proceeded to bury Eon's staff."
	Local $sStoryEruptor = 'Lightcore Eruptor Story' & '|' & 'Eruptor is a force of nature, hailing from a species that lived deep in the underground. of a floating volcanic island, until a massive eruption launched their entire civilization to the surface. He is a complete hot head, steaming, fuming, and quite literally erupting over almost anything. To help control his temper, he likes to relax in lava pools, particularly because there are no crowds.'
	;
	Local $Pic_HotHead = @ScriptDir & '\Hot_Head.jpg'
	Local $Pic_LightcoreEruptor = @ScriptDir & '\LightCore_Eruptor.jpg'
	Local $Pic_Ignitor = @ScriptDir & '\Ignitor.jpg'
	Local $Pic_Flameslinger = @ScriptDir & '\Flameslinger.jpg'
	Local $Pic_HotDog = @ScriptDir & '\Hot_Dog.jpg'
	Local $Pic_Eruptor = @ScriptDir & '\Eruptor.jpg'
	;
	ConsoleWrite('!> Killing GUI-Fire- ' & 'Still in function __Fire' & @CRLF)
	;
	;
	Switch @GUI_CtrlId
		Case $_ButtonFireHotHead
			CharacterAttributes($_GuiFire, 'Fire', 'Hot Head', $Pic_HotHead, 'Hot_Head', $sStoryHotHead)
		Case $_LableFireHotHead
			SpeakName('Hot Head')
			;
		Case $_ButtonFireLightCoreEruptor
			CharacterAttributes($_GuiFire, 'Fire', 'Lightcore Eruptor', $Pic_LightcoreEruptor, 'Lightcore_Eruptor', $sStoryLightcoreEruptor)
		Case $_LableFireLightCoreEruptor
			SpeakName('LightCore Eruptor')
			;
		Case $_ButtonFireIgnitor
			CharacterAttributes($_GuiFire, 'Fire', 'Ignitor', $Pic_Ignitor, 'Ignitor', $sStoryIgnitor)
		Case $_LableFireIgnitor
			SpeakName('Ignitor')
			;
		Case $_ButtonFireFlameslinger
			CharacterAttributes($_GuiFire, 'Fire', 'Flameslinger', $Pic_Flameslinger, 'Flameslinger', $sStoryFlameslinger)
		Case $_LableFireFlameslinger
			SpeakName('Flameslinger')
			;
		Case $_ButtonFireHotDog
			CharacterAttributes($_GuiFire, 'Fire', 'Hot Dog', $Pic_HotDog, 'Hot_Dog', $sStoryHotDog)
		Case $_LableFireHotDog
			SpeakName('Hot Dog')
			;
		Case $_ButtonFireEruptor
			CharacterAttributes($_GuiFire, 'Fire', 'Eruptor', $Pic_Eruptor, 'Eruptor', $sStoryEruptor)
		Case $_LableFireEruptor
			SpeakName('Eruptor')
			;
			;
		Case Else
			ConsoleWrite('!> Nothing MATCHED in button clicked: ' & '__Fire' & @CRLF)
			MsgBox('', '__Fire', 'Nothing MATCHED in button ' & @GUI_CtrlId)
	EndSwitch
	ConsoleWrite('!> Ending called function: ' & '__Fire' & @CRLF)
EndFunc   ;==>__Fire
;
Func _Fire()
	Local $iPad = 10, $iTop = 25
	GUISetState(@SW_DISABLE, $_GuiTitle)
	GUICtrlSetData($_LableElement, 'Fire')
	$_GuiLife = GUICreate('Fire Element', 970, 250, -1, -1, $WS_SYSMENU + $WS_CAPTION, $WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")
	;
	MakeCharGUI($_ButtonFireHotHead, 'Hot Head', 'Hot_Head.jpg', "__Fire", $iPad + 0, $iTop, 150, 150, $_LableFireHotHead, $iPad + 10, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonFireLightCoreEruptor, 'LightCore Eruptor', 'LightCore_Eruptor.jpg', "__Fire", $iPad + 160, $iTop, 150, 150, $_LableFireLightCoreEruptor, $iPad + 160, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonFireIgnitor, 'Ignitor', 'Ignitor.jpg', "__Fire", $iPad + 320, $iTop, 150, 150, $_LableFireIgnitor, $iPad + 330, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonFireFlameslinger, 'Flame slinger', 'Flameslinger.jpg', "__Fire", $iPad + 480, $iTop, 150, 150, $_LableFireFlameslinger, $iPad + 480, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonFireHotDog, 'Hot Dog', 'Hot_Dog.jpg', "__Fire", 640 + $iPad, $iTop, 150, 150, $_LableFireHotDog, $iPad + 655, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonFireEruptor, 'Eruptor', 'Eruptor.jpg', "__Fire", $iPad + 800, $iTop, 150, 150, $_LableFireEruptor, $iPad + 815, 155 + $iTop, 150, 100)
	;
	GUISetState(@SW_SHOW, $_GuiFire)

EndFunc   ;==>_Fire
;
;
Func __Magic()
	ConsoleWrite('!> Called - ' & '__Life' & @CRLF)
	;
	Local $sStoryNinJini = 'Ninjini Story' & '|' & "Ninjini was the most renowned magical ninja from ancient times, long before the Arkeyans ever rose to power. But a dark sorceress, who was jealous of Ninjini's skill as a warrior, trapped her within an enchanted bottle, to be imprisoned for all of eternity. Time stretched on, yet Ninjini remained steadfast and determined to escape, even mastering the dual sword technique, within the solitude of her bottle. Over the years, her strength continued to grow until alas, through sheer force of will, she broke free!  From that moment on, Ninjini made it her mission, to help those in need as one of the first Skylanders, always carrying that enchanted bottle, as a reminder of her own resilience."
	Local $sStoryLightcorePopfizz = 'Lightcore Pop fizz Story' & '|' & 'Nobody is quite sure who Pop fizz was before he became an alchemist, least of all Pop fizz himself. After many years of experimenting with magical potions, his appearance has changed quite significantly. In fact, no one even knows his original color. But it is widely known that he is a little crazy, his experiments are reckless, and the accidents they cause are too numerous to measure.  Understandably, he has had a difficult time finding lab partners, or anyone that even wants to be near him. In hopes of making himself more appealing to others, he attempted to create the most effective charm potion ever, but that just turned him into a big, wild, berserker. Or maybe that is just how he saw, the potion working in the first place.'
	Local $sStorySpyro = 'Spyro Story' & '|' & 'Spyro hails from a rare line of magical purple dragons, that come from a faraway land few have ever traveled. It has been said that the Scrolls, of the Ancients mention Spyro prominently, and the old Portal Masters having chronicled, his many exciting adventures and heroic deeds. Finally, it was Master Eon himsel,f who reached out, and invited him to join the Skylanders. From then on, evil faced a new enemy, and the Skylanders gained a valued ally.'
	Local $sStoryWreckingBall = 'Wrecking Ball Story' & '|' & "Wrecking Ball was once a tiny grub worm, about to become the main ingredient, in an old wizard?s cauldron of magic stew. But when he was dropped in, the wizard was shocked to see, the little grub devour all of the soup, and emerge from the cauldron 20 times larger, and with a long, sticky tongue. The poor old wizard was even more surprised seconds later, when Wrecking Ball proceeded to swallow him whole. Eventually he ran, quite literally, into the powerful Portal Master Eon, who was intrigued by how he came to be, and impressed with his unique abilities."
	Local $sStoryDoubleTrouble = ' Double Trouble Story' & '|' & 'Double Trouble was an adept spellcaster. On an expedition to find exotic ingredients for his potions, he traveled in search of a rare lily that was said to multiply the power of any spell. So thrilled was he when he found it, Double Trouble instantly ate the plant, and performed a spell. Suddenly, there was a loud pop, and then another, and another, until Double Trouble was surrounded by exact copies of himself. As it turned out, he had misunderstood the details about exactly what would multiply. But it did not matter, for he quickly realized the clones were delightful companions, never mind that they were only half his size and would explode on contact.'
	Local $sStoryPopfizz = ' Pop fizz Story' & '|' & 'Nobody is quite sure who Pop fizz was before he became an alchemist, least of all Pop fizz himself. After many years of experimenting with magical potions, his appearance has changed quite significantly. In fact, no one even knows his original color. But it is widely known that he is a little crazy, his experiments are reckless, and the accidents they cause are too numerous to measure.  Understandably, he has had a difficult time finding lab partners, or anyone that even wants to be near him. In hopes of making himself more appealing to others, he attempted to create the most effective charm potion ever, but that just turned him into a big, wild, berserker. Or maybe that is just how he saw, the potion working in the first place.'
	;
	Local $Pic_Ninjini = @ScriptDir & '\Ninjini.jpg'
	Local $Pic_LightcorePopfizz = @ScriptDir & '\LightCore_Pop_fizz.jpg'
	Local $Pic_Spyro = @ScriptDir & '\Spyro.jpg'
	Local $Pic_WreckingBall = @ScriptDir & '\Wrecking_Ball.jpg'
	Local $Pic_DoubleTrouble = @ScriptDir & '\Double_Trouble.jpg'
	Local $Pic_Popfizz = @ScriptDir & '\Pop_fizz.jpg'
	;
	ConsoleWrite('!> Killing GUI-Magic- ' & 'Still in function __Magic' & @CRLF)
	;
	;
	Switch @GUI_CtrlId
		Case $_ButtonMagicNinjini
			CharacterAttributes($_GuiMagic, 'Magic', 'Ninjini', $Pic_Ninjini, 'Ninjini', $sStoryNinJini)
		Case $_LableMagicNinjini
			SpeakName('Ninjini')
			;
		Case $_ButtonMagicLightCorePopfizz
			CharacterAttributes($_GuiMagic, 'Magic', 'Lightcore Pop fizz', $Pic_LightcorePopfizz, 'Lightcore_Pop_fizz', $sStoryLightcorePopfizz)
		Case $_LableMagicLightCorePopfizz
			SpeakName('LightCore Pop fizz')
			;
		Case $_ButtonMagicSpyro
			CharacterAttributes($_GuiMagic, 'Magic', 'Spyro', $Pic_Spyro, 'Spyro', $sStorySpyro)
		Case $_LableMagicSpyro
			SpeakName('Spyro')
			;
		Case $_ButtonMagicWreckingBall
			CharacterAttributes($_GuiMagic, 'Magic', 'Wrecking Ball', $Pic_WreckingBall, 'Wrecking_Ball', $sStoryWreckingBall)
		Case $_LableMagicWreckingBall
			SpeakName('Wrecking Ball')
			;
		Case $_ButtonMagicDoubleTrouble
			CharacterAttributes($_GuiMagic, 'Magic', 'Double Trouble', $Pic_DoubleTrouble, 'Double_Trouble', $sStoryDoubleTrouble)
		Case $_LableMagicDoubleTrouble
			SpeakName('Double Trouble')
			;
		Case $_ButtonMagicPopfizz
			CharacterAttributes($_GuiMagic, 'Magic', 'Pop fizz', $Pic_Popfizz, 'Pop_fizz', $sStoryPopfizz)
		Case $_LableMagicPopfizz
			SpeakName('Pop fizz')
			;
			;
		Case Else
			ConsoleWrite('!> Nothing MATCHED in button clicked: ' & '__Magic' & @CRLF)
			MsgBox('', '__Magic', 'Nothing MATCHED in button ' & @GUI_CtrlId)
	EndSwitch
	ConsoleWrite('!> Ending called function: ' & '__Magic' & @CRLF)
EndFunc   ;==>__Magic
;
Func _Magic()
	Local $iPad = 10, $iTop = 25
	GUISetState(@SW_DISABLE, $_GuiTitle)
	GUICtrlSetData($_LableElement, 'MAGIC')
	$_GuiLife = GUICreate('Magic Element', 970, 250, -1, -1, $WS_SYSMENU + $WS_CAPTION, $WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")
	;
	MakeCharGUI($_ButtonMagicNinjini, 'Ninjini', 'Ninjini.jpg', "__Magic", $iPad + 0, $iTop, 150, 150, $_LableMagicNinjini, $iPad + 10, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonMagicLightCorePopfizz, 'LightCore Pop fizz', 'LightCore_Pop_fizz.jpg', "__Magic", $iPad + 160, $iTop, 150, 150, $_LableMagicLightCorePopfizz, $iPad + 160, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonMagicSpyro, 'Spyro', 'Spyro.jpg', "__Magic", $iPad + 320, $iTop, 150, 150, $_LableMagicSpyro, $iPad + 350, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonMagicWreckingBall, 'Wrecking Ball', 'Wrecking_Ball.jpg', "__Magic", $iPad + 480, $iTop, 150, 150, $_LableMagicWreckingBall, $iPad + 480, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonMagicDoubleTrouble, 'Double Trouble', 'Double_Trouble.jpg', "__Magic", 640 + $iPad, $iTop, 150, 150, $_LableMagicDoubleTrouble, $iPad + 655, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonMagicPopfizz, 'Pop fizz', 'Pop_fizz.jpg', "__Magic", $iPad + 800, $iTop, 150, 150, $_LableMagicPopfizz, $iPad + 815, 155 + $iTop, 150, 100)
	;
	GUISetState(@SW_SHOW, $_GuiMagic)

EndFunc   ;==>_Magic
;
;
Func __Life()
	ConsoleWrite('!> Called - ' & '__Life' & @CRLF)
	;
	Local $sStoryTreeRex = 'Tree Rex Story' & '|' & 'Long before the Giants protected Skylands, Tree Rex was a majestic tree living peacefully in the ancient woods.  But this tranquil existence came to an end, when the Arkeyans built a nearby factory, to produce war machines. After years of his soil being poisoned by the magic, and tech waste from the factory, he mutated into who he is now, a powerful Giant who will crush anything, that threatens the natural order of things.'
	Local $sStoryLightCoreShroomboom = 'Lightcore Shroomboom Story' & '|' & 'Shroomboom was most unfortunate, to have been born in a pizza topping garden belonging to Kaos. Growing up among his fellow fungi, he knew it was only a matter of time, before a late night craving would bring about their demise. So Shroomboom took a twig, and a strand of spider web and made a slingshot. One by one, he launched all of his friends, over the garden fence, before flinging himself over to join them. Then he guided them all to the edge of the island, and leapt to freedom, using his mushroom cap to catch a friendly breeze. Now as a member of the Skylanders, Shroomboom continues to perform courageous deeds, but he can be hard to find on pizza night.'
	Local $sStoryStealthElf = 'Stealth Elf Story' & '|' & 'As a small child, Stealth Elf awoke one morning inside the hollow of an old tree, with no memory of how she got there.  She was taken in by an unusually stealthy, ninja-like forest creature in the deep forest.  Under his tutelage, she has spent the majority of her life, training in the art of stealth fighting.  After completing her training, she became a Skylander, and set out into the world to uncover the mystery behind, her origins.'
	Local $sStoryZook = 'Zook Story' & '|' & 'Zook hails from a strange and unusual species called Bambazookers, who once lived their entire lives standing in place, until Zook discovered they could walk, simply by stepping out of the mud.  After that, he became a wandering hero, using his hand-carved bamboo tube, as a bazooka that fires special explosive thorns.  Campfire songs were even written about him.  Now, Zook spends his time as a Skylander, figuring he can be an even bigger hero, and have even more songs written about him.'
	Local $sStoryStumpSmash = 'Stump Smash Story' & '|' & 'Stump Smash was once a magical tree, that spent most of his time sleeping peacefully, in the forests of Skylands.  Then one day he awoke, to discover his entire forest had been chopped down, and logged by trolls, himself included.  His long branches were gone, leaving him with only powerful mallets for hands, which he used to smash the troll tree-cutting machines.  Although still grumpy about what happened to him, Stump Smash has vowed to protect Skyland, against those who would do it harm especially trolls.'
	Local $sStoryShroomboom = 'Shroomboom Story' & '|' & 'Shroomboom was most unfortunate, to have been born in a pizza topping garden belonging to Kaos. Growing up among his fellow fungi, he knew it was only a matter of time, before a late night craving would bring about their demise. So Shroomboom took a twig, and a strand of spider web, and made a slingshot. One by one, he launched all of his friends over the garden fence, before flinging himself over to join them. Then he guided them all, to the edge of the island and leapt to freedom, using his mushroom cap to catch a friendly breeze. Now as a member of the Skylanders, Shroomboom continues to perform courageous deeds, but he can be hard to find on pizza night.'
	;
	Local $Pic_TreeRex = @ScriptDir & '\Tree_Rex.jpg'
	Local $Pic_LightcoreShroomboom = @ScriptDir & '\LightCore_Shroomboom.jpg'
	Local $Pic_StealthElf = @ScriptDir & '\Stealth_Elf.jpg'
	Local $Pic_Zook = @ScriptDir & '\Zook.jpg'
	Local $Pic_StumpSmash = @ScriptDir & '\Stump_Smash.jpg'
	Local $Pic_Shroomboom = @ScriptDir & '\Shroomboom.jpg'
	;
	ConsoleWrite('!> Killing GUI-LIFE- ' & 'Still in function __Life' & @CRLF)
	;
	;
	Switch @GUI_CtrlId
		Case $_ButtonLifeTreeRex
			CharacterAttributes($_GuiLife, 'Life', 'Tree Rex', $Pic_TreeRex, 'Tree_Rex', $sStoryLightCoreShroomboom)
		Case $_LableLifeTreeRex
			SpeakName('Tree Rex')
			;
		Case $_ButtonLifeLightCoreShroomboom
			CharacterAttributes($_GuiLife, 'Life', 'LightCore Shroomboom', $Pic_LightcoreShroomboom, 'LightCore_Shroomboom', $sStoryLightCoreShroomboom)
		Case $_LableLifeLightCoreShroomboom
			SpeakName('LightCore Shroomboom')
			;
		Case $_ButtonLifeStealthElf
			CharacterAttributes($_GuiLife, 'Life', 'Stealth Elf', $Pic_StealthElf, 'Stealth_Elf', $sStoryStealthElf)
		Case $_LableLifeStealthElf
			SpeakName('Stealth Elf')
			;
		Case $_ButtonLifeZook
			CharacterAttributes($_GuiLife, 'Life', 'Zook', $Pic_Zook, 'Zook', $sStoryZook)
		Case $_LableLifeZook
			SpeakName('Zook')
			;
		Case $_ButtonLifeStumpSmash
			CharacterAttributes($_GuiLife, 'Life', 'Stump Smash', $Pic_StumpSmash, 'Stump_Smash', $sStoryStumpSmash)
		Case $_LableLifeStumpSmash
			SpeakName('Stump Smash')
			;
		Case $_ButtonLifeShroomboom
			CharacterAttributes($_GuiLife, 'Life', 'Shroomboom', $Pic_Shroomboom, 'Shroomboom', $sStoryShroomboom)
		Case $_LableLifeShroomboom
			SpeakName('Shroomboom')
			;
			;
		Case Else
			ConsoleWrite('!> Nothing MATCHED in button clicked: ' & '__Life' & @CRLF)
			MsgBox('', '__Life', 'Nothing MATCHED in button ' & @GUI_CtrlId)
	EndSwitch
	ConsoleWrite('!> Ending called function: ' & '__Life' & @CRLF)
EndFunc   ;==>__Life
;
Func _Life()
	Local $iPad = 10, $iTop = 25
	GUISetState(@SW_DISABLE, $_GuiTitle)
	GUICtrlSetData($_LableElement, 'LIFE')
	$_GuiLife = GUICreate('Life Element', 970, 250, -1, -1, $WS_SYSMENU + $WS_CAPTION, $WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")
	;
	MakeCharGUI($_ButtonLifeTreeRex, 'Tree Rex', 'Tree_Rex.jpg', "__Life", $iPad + 0, $iTop, 150, 150, $_LableLifeTreeRex, $iPad + 10, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonLifeLightCoreShroomboom, 'LightCore Shroomboom', 'LightCore_Shroomboom.jpg', "__Life", $iPad + 160, $iTop, 150, 150, $_LableLifeLightCoreShroomboom, $iPad + 160, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonLifeStealthElf, 'Stealth Elf', 'Stealth_Elf.jpg', "__Life", $iPad + 320, $iTop, 150, 150, $_LableLifeStealthElf, $iPad + 340, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonLifeZook, 'Zook', 'Zook.jpg', "__Life", 480 + $iPad, $iTop, 150, 150, $_LableLifeZook, 515 + $iPad, 155 + $iTop, 200, 100)
	MakeCharGUI($_ButtonLifeStumpSmash, 'Stump Smash', 'Stump_Smash.jpg', "__Life", 640 + $iPad, $iTop, 150, 150, $_LableLifeStumpSmash, 670 + $iPad, 155 + $iTop, 150, 100)
	MakeCharGUI($_ButtonLifeShroomboom, 'Shroomboom', 'Shroomboom.jpg', "__Life", 800 + $iPad, $iTop, 150, 150, $_LableLifeShroomboom, 775 + $iPad, 155 + $iTop, 200, 100)
	;
	GUISetState(@SW_SHOW, $_GuiLife)

EndFunc   ;==>_Life
;
;
Func __Water()
	Local $sStoryThumpback = 'Thumpback Story' & '|' & "Thumpback was once a crew member of The Phantom Tide, the most fearsome pirate ship in all of Skylands. But the actual pirating part about being a pirate, didn't interest Thumpback so much as the benefits, that came with traveling on a large ship. After all, his real passion was fishing. But when his chance came to finally ensnare, the most elusive creature in the sky, the Leviathan Cloud Crab, he was pulled over board and carried off into the horizon. This was actually quite fortunate, because sometime later The Phantom Tide, and its entire crew were banished to the Chest of Exile. Thumpback?s pirating days were over, but his legend as one of the first Skylanders, had only just begun."
	Local $sStoryLightCoreChill = 'Lightcore Chill Story' & '|' & "Chill was the sworn guardian and personal protector of the Snow Queen. As captain of the queen's guard, her many heroic deeds, had earned her the respect of the entire Ice Kingdom.  But when the Cyclops army, began to expand their empire into the northern realms, the Snow Queen was taken prisoner during her watch, and Chill has never forgiven herself for letting it happen. Ashamed and embarrassed, she left the Ice Kingdom behind, and swore never to return, until she could reclaim her honor. Now as a member of the Skylanders, she remains courageous and strong, while always on the lookout, for her lost queen."
	Local $sStorySlamBam = 'Slam Bam Story' & '|' & "Slam Bam lived alone on a floating glacier in a remote region of Skylands, where he spent his time ice surfing, eating snow cones, and sculpting amazing ice statues. It was a peaceful life, until Kaos destroyed the glacier, stranding Slam Bam on an iceberg that drifted through the skies for days. He awoke on Eon?s Island, where he was taken in and trained to become a Skylander. Now his ice sculptures serve as a frosty prison. for any evil-doer that gets in his way."
	Local $sStoryZap = 'Zap Story' & '|' & 'Zap was born into the royal family of water dragons, but a riptide washed him to a distant sea, where he was raised by electric eels. Growing up, he excelled in everything and even created a special gold harness, that allows him to carry an endless electrical charge, and shock things at a great distance. Zap also proved to be a gifted racer, outstripping any opponent with the possible exception of the dolphins. With them, it became a good natured challenge, to see who could keep up with Zap. But an electric current in his wake, often reminded them who they were dealing with. Despite his mischievous streak, Zap grew to be a true protector of the seas, and Skylands.'
	Local $sStoryGillGrunt = 'Gill Grunt Story' & '|' & 'Gill Grunt was a brave soul who joined the Gillmen military in search of adventure. While journeying through a misty lagoon in the clouds, he met an enchanting mermaid. He vowed to return to her after his tour. Keeping his promise, he came back to the lagoon years later, only to learn a nasty band of pirates had kidnapped the mermaid. Heartbroken, Gill Grunt began searching all over Skylands. Though he had yet to find her, he joined the Skylanders to help protect others from such evil, while still keeping an ever-watchful eye, for the beautiful mermaid and the pirates who took her.'
	Local $sStoryChill = 'Chill Story' & '|' & "Chill was the sworn guardian and personal protector of the Snow Queen. As captain of the queen's guard, her many heroic deeds, had earned her the respect of the entire Ice Kingdom.  But when the Cyclops army, began to expand their empire into the northern realms, the Snow Queen was taken prisoner during her watch, and Chill has never forgiven herself for letting it happen. Ashamed and embarrassed, she left the Ice Kingdom behind, and swore never to return, until she could reclaim her honor. Now as a member of the Skylanders, she remains courageous and strong, while always on the lookout, for her lost queen."
	;
	Local $Pic_Thumpback = @ScriptDir & '\Thumpback.jpg'
	Local $Pic_LightcoreChill = @ScriptDir & '\LightCore_Chill.jpg'
	Local $Pic_SlamBam = @ScriptDir & '\Slam_Bam.jpg'
	Local $Pic_Zap = @ScriptDir & '\Zap.jpg'
	Local $Pic_GillGrunt = @ScriptDir & '\Gill_Grunt.jpg'
	Local $Pic_Chill = @ScriptDir & '\Chill.jpg'
	;

	;GUISetState(@SW_HIDE, $_GuiWater)
	;	GUIDelete($_GuiWater)

	;
	;
	Switch @GUI_CtrlId
		Case $_ButtonWaterThumpback
			GUICtrlSetData($_LableName, StringUpper('Thumpback'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'Thumpback', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_Thumpback)
				_SpeechGet($sStoryThumpback)
			Else
				;MsgBox('', 'Thumpback', 'pop')
				ShowHTML('Thumpback', '.png')
				_SpeechGet($sStoryThumpback, 1)
			EndIf

			GetSkyLanderName(StringUpper('Water'), StringUpper('Thumpback'))

		Case $_ButtonWaterLightCoreChill
			GUICtrlSetData($_LableName, StringUpper('LightCore Chill'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'LightCoreChill', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_LightcoreChill)
				_SpeechGet($sStoryLightCoreChill)
			Else
				;MsgBox('', 'LightCoreChill', 'pop')
				ShowHTML('LightCore_Chill', '.png')
				_SpeechGet($sStoryLightCoreChill, 1)
			EndIf

			GetSkyLanderName(StringUpper('Water'), StringUpper('LightCore Chill'))

		Case $_ButtonWaterSlamBam
			GUICtrlSetData($_LableName, StringUpper('Slam Bam'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'Slam Bam ', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_SlamBam)
				_SpeechGet($sStorySlamBam)
			Else
				;MsgBox('', 'Slam Bam ', 'pop')
				ShowHTML('Slam_Bam', '.png')
				_SpeechGet($sStorySlamBam, 1)
			EndIf

			GetSkyLanderName(StringUpper('Water'), StringUpper('Slam Bam'))

		Case $_ButtonWaterZap
			GUICtrlSetData($_LableName, StringUpper('Zap'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'Zap', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_Zap)
				_SpeechGet($sStoryZap)
			Else
				;MsgBox('', 'Zap', 'pop')
				ShowHTML('Zap', '.png')
				_SpeechGet($sStoryZap, 1)
			EndIf

			GetSkyLanderName(StringUpper('Water'), 'Zap')

		Case $_ButtonWaterGillGrunt
			GUICtrlSetData($_LableName, StringUpper('Gill Grunt'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'Gill Grunt', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_GillGrunt)
				_SpeechGet($sStoryGillGrunt)
			Else
				;MsgBox('', 'Gill Grunt', 'pop')
				ShowHTML('Gill_Grunt', '.png')
				_SpeechGet($sStoryGillGrunt, 1)
			EndIf

			GetSkyLanderName(StringUpper('Water'), 'Gill Grunt')

		Case $_ButtonWaterChill
			GUICtrlSetData($_LableName, StringUpper('Chill'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'Chill', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_Chill)
				_SpeechGet($sStoryChill)
			Else
				;MsgBox('', 'Chill', 'pop')
				ShowHTML('Chill', '.png')
				_SpeechGet($sStoryChill, 1)
			EndIf

			GetSkyLanderName(StringUpper('Water'), 'Chill')

	EndSwitch

EndFunc   ;==>__Water
;
Func _Water()
	Local $iPad = 10, $iTop = 25
	GUISetState(@SW_DISABLE, $_GuiTitle)

	GUICtrlSetData($_LableElement, 'WATER')
	$_GuiUnDead = GUICreate('Water Element', 970, 250, -1, -1, $WS_SYSMENU + $WS_CAPTION, $WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")

	If FileExists(@ScriptDir & '\' & 'Thumpback.jpg') Then
		$_ButtonWaterThumpback = GUICtrlCreatePic(@ScriptDir & '\' & 'Thumpback.jpg', 0 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterThumpback, "__Water")
		GUICtrlCreateLabel(StringUpper('Thumpback'), $iPad - 10, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonWaterThumpback = GUICtrlCreateButton('Thumpback', 0 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterThumpback, "__Water")
	EndIf

	If FileExists(@ScriptDir & '\' & 'LightCore_Chill.jpg') Then
		$_ButtonWaterLightCoreChill = GUICtrlCreatePic(@ScriptDir & '\' & 'LightCore_Chill.jpg', 160 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterLightCoreChill, "__Water")
		GUICtrlCreateLabel(StringUpper('Lightcore Chill'), 160 + $iPad, 155 + $iTop, 150, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonWaterLightCoreChill = GUICtrlCreateButton('LightCore Chill', 160 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterLightCoreChill, "__Water")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Slam_Bam.jpg') Then
		$_ButtonWaterSlamBam = GUICtrlCreatePic(@ScriptDir & '\' & 'Slam_Bam.jpg', 320 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterSlamBam, "__Water")
		GUICtrlCreateLabel(StringUpper('Slam Bam'), 325 + $iPad, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonWaterSlamBam = GUICtrlCreateButton('Slam Bam', 320 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterSlamBam, "__Water")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Zap.jpg') Then
		$_ButtonWaterZap = GUICtrlCreatePic(@ScriptDir & '\' & 'Zap.jpg', 480 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterZap, "__Water")
		GUICtrlCreateLabel(StringUpper('Zap'), 530 + $iPad, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonWaterZap = GUICtrlCreateButton('Zap', 480 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterZap, "__Water")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Gill_Grunt.jpg') Then
		$_ButtonWaterGillGrunt = GUICtrlCreatePic(@ScriptDir & '\' & 'Gill_Grunt.jpg', 640 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterGillGrunt, "__Water")
		GUICtrlCreateLabel(StringUpper('Gill Grunt'), 635 + $iPad, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonWaterGillGrunt = GUICtrlCreateButton('Gill Grunt', 640 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterGillGrunt, "__Water")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Chill.jpg') Then
		$_ButtonWaterChill = GUICtrlCreatePic(@ScriptDir & '\' & 'Chill.jpg', 800 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterChill, "__Water")
		GUICtrlCreateLabel(StringUpper('Chill'), 830 + $iPad, 155 + $iTop, 150, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonWaterChill = GUICtrlCreateButton('Chill', 800 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonWaterChill, "__Water")
	EndIf

	GUISetState(@SW_SHOW, $_GuiUnDead)

EndFunc   ;==>_Water
;
Func __UnDead()
	Local $sStoryEyeBrawl = 'Eye-Brawl Story' & '|' & 'Throughout history, there have been many epic battles, though none more bizarre than the legendary brawl between the headless giant, and the infamous flying eyeball. It all started with a staring contest, but with the headless giant having no eyes, and the flying eyeball unable to blink, it soon escalated into an all out war, as the two rivals fought fiercely throughout the land of the undead, for over a hundred years!  With neither opponent backing down, the two combatants were eventually struck with the realization, that if they were to combine their formidable powers, they would be a force to be reckoned with. By teaming up, the infamous flying eyeball and the headless giant, became known as Eye-Brawl and one of the most powerful Skylanders ever known!'
	Local $sStoryLightCoreHex = 'Lightcore Hex Story' & '|' & 'Long ago, Hex was a gifted and powerful sorceress who traveled deep into the underworld, to confront the Undead Dragon King named Malefor, who made several attempts to capture her to learn her secrets. Though she successfully battled the dragon, Hex returned from the underworld changed and having unwillingly joined the ranks of the Undead.  Many are wary of her since her transformation, suspecting she has used her powerful magic for evil purposes.  But Eon trusts her, and views her as a most valuable Skylander ally.'
	Local $sStoryCynder = 'Cynder Story' & '|' & 'While just an egg, Cynder was stolen by the henchmen of an evil dragon named Malefor and raised to do his bidding. For years, she spread fear throughout the land until she was defeated by Spyro the dragon and freed from the grip of Malefor. But dark powers still flow through her, and despite her desire to make amends for her past, most Skylanders try to keep a safe distance? just in case.'
	Local $sstoryChopChop = 'Chop Chop Story' & '|' & 'Chop Chop was once an elite warrior belonging to the ancient race of Arkeyan beings. Like many of the Arkeyans, he was created from a hybrid of elements and in his case, undead magic and technology. Chop Chop is a relentless, highly-skilled solider who wields a sword and shield made of an indestructible metal. With the Arkeyans having vanished long ago, Chop Chop wandered Skylands for centuries looking for his creators. Eventually, he was found by Eon and recruited as a Skylander.'
	Local $sStoryHex = 'Hex Story' & '|' & 'Long ago, Hex was a gifted and powerful sorceress who traveled deep into the underworld, to confront the Undead Dragon King named Malefor, who made several attempts to capture her to learn her secrets. Though she successfully battled the dragon, Hex returned from the underworld changed and having unwillingly joined the ranks of the Undead.  Many are wary of her since her transformation, suspecting she has used her powerful magic for evil purposes.  But Eon trusts her, and views her as a most valuable Skylander ally.'
	Local $sStoryFrightRider = 'Fright Rider Story' & '|' & 'Rider and his magnificent ostrich, Fright, were the finest jousting team in all of Skylands. But after winning the championship for the 3rd straight year, a jealous competitor placed a curse on the elf, that sent him to the Land of the Undead. Not wanting to be without his partner, Fright, who up until this point had been afraid of nearly everything, ate a bag of skele-oats that turned him into a skeleton, so that he could brave the journey to the underworld, to save his friend. Grateful for being rescued, Fright Rider returned to the surface dedicated to helping others, and while still dominating an occasional jousting tournament from time to time!'

	Local $Pic_EyeBrawl = @ScriptDir & '\Eye_Brawl.jpg'
	Local $Pic_LightcoreHex = @ScriptDir & '\LightCore_Hex.jpg'
	Local $Pic_Cynder = @ScriptDir & '\Cynder.jpg'
	Local $Pic_ChopChop = @ScriptDir & '\Chop_Chop.jpg'
	Local $Pic_Hex = @ScriptDir & '\Hex.jpg'
	Local $Pic_FrightRider = @ScriptDir & '\Fright_Rider.jpg'

	;	GUISetState(@SW_HIDE, $_GuiUnDead)
	;	GUIDelete($_GuiUnDead)

	Switch @GUI_CtrlId
		Case $_ButtonUnDeadEyeBrawl
			GUICtrlSetData($_LableName, StringUpper('Eye Brawl'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'EyeBrawl', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_EyeBrawl)
				_SpeechGet($sStoryEyeBrawl)
			Else
				;MsgBox('', 'EyeBrawl', 'pop')
				ShowHTML('Eye_Brawl', '.png')
				_SpeechGet($sStoryEyeBrawl, 1)
			EndIf

			GetSkyLanderName(StringUpper('Undead'), StringUpper('Eye Brawl'))
		Case $_ButtonUnDeadLightCoreHex
			GUICtrlSetData($_LableName, StringUpper('LightCore Hex'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'LightCoreHex', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_LightcoreHex)
				_SpeechGet($sStoryLightCoreHex)
			Else
				;MsgBox('', 'LightCoreHex', 'pop')
				ShowHTML('LightCore_Hex', '.png')
				_SpeechGet($sStoryLightCoreHex, 1)
			EndIf

			GetSkyLanderName(StringUpper('Undead'), StringUpper('LightCore Hex'))

		Case $_ButtonUnDeadCynder
			GUICtrlSetData($_LableName, StringUpper('Cynder'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'Cynder', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_Cynder)
				_SpeechGet($sStoryCynder)
			Else
				;MsgBox('', 'Cynder', 'pop')
				ShowHTML('Cynder', '.png')
				_SpeechGet($sStoryCynder, 1)
			EndIf

			GetSkyLanderName(StringUpper('Undead'), StringUpper('Cynder'))

		Case $_ButtonUnDeadChopChop
			GUICtrlSetData($_LableName, StringUpper('Chop Chop'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'ChopChop', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_ChopChop)
				_SpeechGet($sstoryChopChop)
			Else
				;MsgBox('', 'ChopChop', 'pop')
				ShowHTML('Chop_Chop', '.png')
				_SpeechGet($sstoryChopChop, 1)
			EndIf

			GetSkyLanderName(StringUpper('Undead'), 'Chop Chop')

		Case $_ButtonUnDeadHex
			GUICtrlSetData($_LableName, StringUpper('Hex'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'Hex', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_Hex)
				_SpeechGet($sStoryHex)
			Else
				;MsgBox('', 'Hex', 'pop')
				ShowHTML('Hex', '.png')
				_SpeechGet($sStoryHex, 1)
			EndIf

			GetSkyLanderName(StringUpper('Undead'), 'Hex')

		Case $_ButtonUnDeadFrightRider
			GUICtrlSetData($_LableName, StringUpper('Fright Rider'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'Fright_Rider', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_FrightRider)
				_SpeechGet($sStoryFrightRider)
			Else
				;MsgBox('', 'Fright_Rider', 'pop')
				ShowHTML('Fright_Rider', '.png')
				_SpeechGet($sStoryFrightRider, 1)
			EndIf

			GetSkyLanderName(StringUpper('Undead'), 'Fright Rider')

	EndSwitch

EndFunc   ;==>__UnDead
;
Func _UnDead()
	Local $iPad = 10, $iTop = 25
	GUISetState(@SW_DISABLE, $_GuiTitle)

	GUICtrlSetData($_LableElement, 'UNDEAD')
	$_GuiUnDead = GUICreate('Undead Element', 970, 250, -1, -1, $WS_SYSMENU + $WS_CAPTION, $WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")

	If FileExists(@ScriptDir & '\' & 'Eye_Brawl.jpg') Then
		$_ButtonUnDeadEyeBrawl = GUICtrlCreatePic(@ScriptDir & '\' & 'Eye_Brawl.jpg', 0 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadEyeBrawl, "__UnDead")
		GUICtrlCreateLabel(StringUpper('Eye Brawl'), 20 + $iPad, 155 + $iTop, 150, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonUnDeadEyeBrawl = GUICtrlCreateButton('Eye Brawl', 0 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadEyeBrawl, "__UnDead")
	EndIf

	If FileExists(@ScriptDir & '\' & 'LightCore_Hex.jpg') Then
		$_ButtonUnDeadLightCoreHex = GUICtrlCreatePic(@ScriptDir & '\' & 'LightCore_Hex.jpg', 160 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadLightCoreHex, "__UnDead")
		GUICtrlCreateLabel(StringUpper('Lightcore Hex'), 160 + $iPad, 155 + $iTop, 150, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonUnDeadLightCoreHex = GUICtrlCreateButton('LightCore Hex', 160 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadLightCoreHex, "__UnDead")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Cynder.jpg') Then
		$_ButtonUnDeadCynder = GUICtrlCreatePic(@ScriptDir & '\' & 'Cynder.jpg', 320 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadCynder, "__UnDead")
		GUICtrlCreateLabel(StringUpper('Cynder'), 350 + $iPad, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonUnDeadCynder = GUICtrlCreateButton('Cynder', 320 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadCynder, "__UnDead")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Chop_Chop.jpg') Then
		$_ButtonUnDeadChopChop = GUICtrlCreatePic(@ScriptDir & '\' & 'Chop_Chop.jpg', 480 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadChopChop, "__UnDead")
		GUICtrlCreateLabel(StringUpper('Chop Chop'), 480 + $iPad, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonUnDeadChopChop = GUICtrlCreateButton('Chop Chop', 480 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadChopChop, "__UnDead")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Hex.jpg') Then
		$_ButtonUnDeadHex = GUICtrlCreatePic(@ScriptDir & '\' & 'Hex.jpg', 640 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadHex, "__UnDead")
		GUICtrlCreateLabel(StringUpper('Hex'), 685 + $iPad, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonUnDeadHex = GUICtrlCreateButton('Hex', 640 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadHex, "__UnDead")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Fright_Rider.jpg') Then
		$_ButtonUnDeadFrightRider = GUICtrlCreatePic(@ScriptDir & '\' & 'Fright_Rider.jpg', 800 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadFrightRider, "__UnDead")
		GUICtrlCreateLabel(StringUpper('Fright Rider'), 830 + $iPad, 155 + $iTop, 150, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonUnDeadFrightRider = GUICtrlCreateButton('Fright Rider', 800 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonUnDeadFrightRider, "__UnDead")
	EndIf

	GUISetState(@SW_SHOW, $_GuiUnDead)

EndFunc   ;==>_UnDead
;
;
Func __Air()
	Local $sStorySwarm = 'Swarm Story' & '|' & 'Swarm was once a prince from a proud race of mysterious insect warriors, that had built their entire civilization inside a giant honeycombed pyramid. Growing up as one of the nine thousand members of the royal family, he was never permitted to leave the hive. But unlike his brethren, there was a magical quality to Swarm, that caused him to grow much larger than the rest of his kind. No longer able to fit amongst the rest of his colony, the young prince broke the long standing tradition and stepped out into the open world, where his size and strength would be put to good use, in the legendary battle between the Giants and the Arkeyans.'
	Local $sStoryLightcoreJetVac = 'Lightcore Jet-Vac Story' & '|' & 'Jet-Vac was the greatest, most daring flying ace in all of Windham. He was given his magical wings when he was young, as was the tradition for all Sky Barons. But when his homeland was raided, he chose to sacrifice his wings to a young mother so she could fly her children to safety. This act of nobility caught the attention of Master Eon, who sought out the young Sky Baron and presented him with a gift, a powerful vacuum device, that would allow him to soar through the skies once again. Jet-Vac accepted the gift with gratitude, and now daringly fights evil alongside the other Skylanders.'
	Local $sStorySonicBoom = 'Sonic Boom Story' & '|' & 'Long ago, Sonic Boom took refuge high atop a mountain peak, in the far reaches of Skylands, hoping to keep her griffin hatchlings safe. But despite her precautions, a devious wizard tracked her down and placed a wicked curse on the griffin eggs. Once hatched, the young hatchlings can live for only mere moments, before they magically return to their shells. only to be hatched again in an endless cycle. Wanting to prevent such evil from happening to others, Sonic Boom joined the Skylanders, and has trained her young to defend Skylands each time they are hatched.'
	Local $sStoryWhirlwind = 'Whirlwind Story' & '|' & 'Whirlwind is an air dragon with unicorn ancestry, and two species that could not be more opposite in nature, which made her never quite fit in with either group.  Other dragons were envious of her beauty, while unicorns shunned her for her ability to fly.  But Whirlwind found peace within the dark and stormy clouds, where she learned to harness the tempest power within her.  Despite her turbulent youth, she was the first to defend both dragons, and unicorns when the trolls began hunting them, unleashing her ferocity in a brilliant and powerful rainbow, that could be seen throughout many regions of Skylands.  From that day forward, evil-doers would quake when dark clouds brewed, and run from the rainbow that followed the storm.'
	Local $sStoryLightningRod = 'Lightning Rod Story' & '|' & 'Lightning Rod once lived in the majestic Cloud Kingdom, where his countless acts of heroism, along with his winning smile and electric physique, made him the most famous storm giant in the realm. He was a true celebrity, and the palace halls were littered with statues of the chiseled hero. But all the praise and admiration could never quite satisfy Rod, who yearned for something more. As luck would have it, he met an adventurous young dragon named Spyro, who told him fantastic stories of faraway places and dangerous adventures. Rod was spellbound, and he set off with Spyro, to seek an audience with Eon to join the Skylanders.'
	Local $sStoryJetVac = 'Jet-Vac Story' & '|' & 'Jet-Vac was the greatest, most daring flying ace in all of Windham. He was given his magical wings when he was young, as was the tradition for all Sky Barons. But when his homeland was raided, he chose to sacrifice his wings to a young mother so she could fly her children to safety. This act of nobility caught the attention of Master Eon, who sought out the young Sky Baron and presented him with a gift, a powerful vacuum device, that would allow him to soar through the skies once again. Jet-Vac accepted the gift with gratitude, and now daringly fights evil alongside the other Skylanders.'

	Local $Pic_Swarm = @ScriptDir & '\Swarm.jpg'
	Local $Pic_LightcoreJetVac = @ScriptDir & '\LightCore_Jet_Vac.jpg'
	Local $Pic_SonicBoom = @ScriptDir & '\Sonic_Boom.jpg'
	Local $Pic_Whirewind = @ScriptDir & '\Whirlwind.jpg'
	Local $Pic_LightningRod = @ScriptDir & '\Lightning_Rod.jpg'
	Local $Pic_JetVac = @ScriptDir & '\Jet_Vac.jpg'

	;	GUISetState(@SW_HIDE, $_GuiAir)
	;	GUIDelete($_GuiAir)

	Switch @GUI_CtrlId
		Case $_ButtonAirSwarm
			GUICtrlSetData($_LableName, StringUpper('Swarm'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'swarm', 'pop no internet')
				GUICtrlSetImage($PicSplash, $Pic_Swarm)
				_SpeechGet($sStorySwarm)
			Else
				;MsgBox('', 'swarm', 'pop')
				ShowHTML('Swarm', '.png')
				_SpeechGet($sStorySwarm, 1)
			EndIf

			GetSkyLanderName(StringUpper('Air'), StringUpper('Swarm'))

		Case $_ButtonAirLightCoreJetVac
			GUICtrlSetData($_LableName, StringUpper('LightCore Jet Vac'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'LightCore Jet Vac', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_LightcoreJetVac)
				_SpeechGet($sStoryLightcoreJetVac)
			Else
				;MsgBox('', 'LightCore Jet Vac', 'pop')
				ShowHTML('LightCore_Jet_Vac', '.png')
				_SpeechGet($sStoryLightcoreJetVac, 1)
			EndIf

			GetSkyLanderName(StringUpper('Air'), 'LightCore Jet Vac')

		Case $_ButtonAirSonicBoom
			GUICtrlSetData($_LableName, StringUpper('Sonic Boom'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'SonicBoom', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_SonicBoom)
				_SpeechGet($sStorySonicBoom)
			Else
				;MsgBox('', 'SonicBoom', 'pop')
				ShowHTML('Sonic_Boom', '.png')
				_SpeechGet($sStorySonicBoom, 1)
			EndIf

			GetSkyLanderName(StringUpper('Air'), 'Sonic Boom')

		Case $_ButtonAirWhirlwind
			GUICtrlSetData($_LableName, StringUpper('Whirlwind'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'Whirlwind', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_Whirewind)
				_SpeechGet($sStoryWhirlwind)
			Else
				;MsgBox('', 'Whirlwind', 'pop')
				ShowHTML('Whirlwind', '.png')
				_SpeechGet($sStoryWhirlwind, 1)
			EndIf

			GetSkyLanderName(StringUpper('Air'), 'Whirlwind')

		Case $_ButtonAirLightningRod
			GUICtrlSetData($_LableName, StringUpper('Lightning Rod'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'LightningRod', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_LightningRod)
				_SpeechGet($sStoryLightningRod)
			Else
				;MsgBox('', 'LightningRod', 'pop')
				ShowHTML('Lightning_Rod', '.png')
				_SpeechGet($sStoryLightningRod, 1)
			EndIf

			GetSkyLanderName(StringUpper('Air'), 'Lightning Rod')

		Case $_ButtonAirJetVac
			GUICtrlSetData($_LableName, StringUpper('Jet Vac'))
			If $bNotConnect Or Not IsObj($oIE) Then
				;MsgBox('', 'JetVac', 'pop')
				GUICtrlSetImage($PicSplash, $Pic_JetVac)
				_SpeechGet($sStoryJetVac)
			Else
				;MsgBox('', 'JetVac', 'pop')
				ShowHTML('Jet_Vac', '.png')
				_SpeechGet($sStoryJetVac, 1)
			EndIf

			GetSkyLanderName(StringUpper('Air'), 'Jet Vac')

	EndSwitch

EndFunc   ;==>__Air
;
Func _Air()
	Local $iPad = 10, $iTop = 25
	GUISetState(@SW_DISABLE, $_GuiTitle)


	GUICtrlSetData($_LableElement, 'AIR')

	$_GuiAir = GUICreate('Air Element', 970, 250, -1, -1, $WS_SYSMENU + $WS_CAPTION, $WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")

	If FileExists(@ScriptDir & '\' & 'Swarm.jpg') Then
		$_ButtonAirSwarm = GUICtrlCreatePic(@ScriptDir & '\' & 'Swarm.jpg', 0 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirSwarm, "__Air")
		GUICtrlCreateLabel(StringUpper('Swarm'), 20 + $iPad, 155 + $iTop, 150, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonAirSwarm = GUICtrlCreateButton('Swarm', 0 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirSwarm, "__Air")
	EndIf

	If FileExists(@ScriptDir & '\' & 'LightCore_Jet_Vac.jpg') Then
		$_ButtonAirLightCoreJetVac = GUICtrlCreatePic(@ScriptDir & '\' & 'LightCore_Jet_Vac.jpg', 160 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirLightCoreJetVac, "__Air")
		GUICtrlCreateLabel(StringUpper('Lightcore Jet Vac'), 160 + $iPad, 155 + $iTop, 150, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonAirLightCoreJetVac = GUICtrlCreateButton('LightCore Jet Vac', 160 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirLightCoreJetVac, "__Air")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Sonic_Boom.jpg') Then
		$_ButtonAirSonicBoom = GUICtrlCreatePic(@ScriptDir & '\' & 'Sonic_Boom.jpg', 320 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirSonicBoom, "__Air")
		GUICtrlCreateLabel(StringUpper('Sonic Boom'), 350 + $iPad, 155 + $iTop, 150, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonAirSonicBoom = GUICtrlCreateButton('Sonic Boom', 320 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirSonicBoom, "__Air")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Whirlwind.jpg') Then
		$_ButtonAirWhirlwind = GUICtrlCreatePic(@ScriptDir & '\' & 'Whirlwind.jpg', 480 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirWhirlwind, "__Air")
		GUICtrlCreateLabel(StringUpper('Whirlwind'), 460 + $iPad, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonAirWhirlwind = GUICtrlCreateButton('Whirlwind', 480 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirWhirlwind, "__Air")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Lightning_Rod.jpg') Then
		$_ButtonAirLightningRod = GUICtrlCreatePic(@ScriptDir & '\' & 'Lightning_Rod.jpg', 640 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirLightningRod, "__Air")
		GUICtrlCreateLabel(StringUpper('Lightning Rod'), 645 + $iPad, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonAirLightningRod = GUICtrlCreateButton('Lightning Rod', 640 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirLightningRod, "__Air")
	EndIf

	If FileExists(@ScriptDir & '\' & 'Jet_Vac.jpg') Then
		$_ButtonAirJetVac = GUICtrlCreatePic(@ScriptDir & '\' & 'Jet_Vac.jpg', 800 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirJetVac, "__Air")
		GUICtrlCreateLabel(StringUpper('Jet Vac'), 830 + $iPad, 155 + $iTop, 200, 100)
		GUICtrlSetFont(-1, 20, 400, 1, $font)
	Else
		$_ButtonAirJetVac = GUICtrlCreateButton('Jet Vac', 800 + $iPad, $iTop, 150, 150)
		GUICtrlSetOnEvent($_ButtonAirJetVac, "__Air")
	EndIf
	GUISetState(@SW_SHOW, $_GuiAir)
EndFunc   ;==>_Air
;
Func GetSkyLanderName($sTitle, $sName)
	;MsgBox('', '', 'need to fix this for each element - gui name and closing previous window')
	Local $iSubLeft = 0
	; activate main gui
	WinActivate($_GuiTitle)

	; change global variables to match name being passed
	$sAnswer = $sName
	$sNameHolder = $sName

	If StringLen($sName) <= 7 Then
		$iSubGuiLength = 400
		$iSubGuiHeight = 200

		$iSubLeft = 5
		$iSubLenght = 380
		$iSubCharLength = 50

		$iSubButtonLeft = 150
	Else
		$iSubGuiLength = 450
		$iSubGuiHeight = 200

		$iSubLeft = Int(StringLen($sName) * .5) * 10
		$iSubLenght = 430
		$iSubCharLength = 50

		$iSubButtonLeft = 175
	EndIf
	$sTitle = StringUpper($sTitle)
	$sName = StringUpper($sName)
	$_GuiName = GUICreate($sTitle & ' ELEMENT -> ' & $sName, $iSubGuiLength, $iSubGuiHeight, -1, -1, $WS_SYSMENU + $WS_CAPTION, $WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Terminate")

	$_LableNameCheck = GUICtrlCreateLabel(StringUpper($sName), 10, 5, $iSubLenght, $iSubCharLength, $SS_CENTER) ; + $SS_GRAYFRAME)
	GUICtrlSetFont(-1, 20, 400, 1, $font)

	$_InputCheck = GUICtrlCreateInput('', 10, 100, $iSubLenght, $iSubCharLength, $ES_UPPERCASE + $ES_CENTER)
	GUICtrlSetFont(-1, 20, 400, 1, $font)

	$_ButtonCheck = GUICtrlCreateButton('CHECK', $iSubButtonLeft, 150, 100, 30, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent($_ButtonCheck, '__CheckAnswer')

	GUISetState(@SW_SHOW, $_GuiName)

EndFunc   ;==>GetSkyLanderName

Func _GuiCtrlCreateFlash2($_FlashUrl, $_EmbedWidth = 870, $_EmbedHeight = 525, $_Left = 400, $_Top = 65)
	Local $_GUIActiveX, $_HtmlCode, $_OpenFile
	If Not IsObj($oIE) Then
		MsgBox('', '', 'creating obj sheel.explorere.2')
		$oIE = ObjCreate("Shell.Explorer.2")
	EndIf
	$_GUIActiveX = GUICtrlCreateObj($oIE, $_Left, $_Top, $_EmbedWidth, $_EmbedHeight)
	$_HtmlCode = '<object width="' & $_EmbedWidth & '" height="' & $_EmbedHeight & '">'
	$_HtmlCode &= '<param name="movie" value="' & $_FlashUrl & '?autoplay=1"></param>'
	$_HtmlCode &= '<param name="allowScriptAccess" value="always"></param>'
	$_HtmlCode &= '<embed src="' & $_FlashUrl & '?autoplay=1" type="application/x-shockwave-flash" allowscriptaccess="always" width="' & $_EmbedWidth - 27 & '" height="' & $_EmbedHeight - 27 & '">'
	$_HtmlCode &= '</embed>'
	$_HtmlFilePath = @TempDir & "\AutoItFlash.html"
	$_OpenFile = FileOpen($_HtmlFilePath, 2)
	FileWrite($_OpenFile, $_HtmlCode)
	FileClose($_OpenFile)
	$oIE.navigate($_HtmlFilePath)
	$oIE.document.body.scroll = "no"
	FileDelete($_HtmlFilePath)
	Return $_GUIActiveX
EndFunc   ;==>_GuiCtrlCreateFlash2


Func _GuiCtrlCreateFlash($_FlashUrl, $_EmbedWidth = 870, $_EmbedHeight = 525, $_Left = 400, $_Top = 65)
	; special help from Wakillon (as part of his code)
	If $bNotConnect Then Return
	Local $_GUIActiveX, $_HtmlCode, $_OpenFile
	If Not IsObj($oIE) Then
		$oIE = ObjCreate("Shell.Explorer.2")
		;If @error Then MsgBox('',@error,'error message')
	Else
		MsgBox('', '', '')
	EndIf
	;
	$_GUIActiveX = GUICtrlCreateObj($oIE, $_Left, $_Top, $_EmbedWidth, $_EmbedHeight)
	$_HtmlCode = '<object width="' & $_EmbedWidth & '" height="' & $_EmbedHeight & '">'
	$_HtmlCode &= '<param name="movie" value="' & $_FlashUrl & '?autoplay=1"></param>'
	$_HtmlCode &= '<param name="allowScriptAccess" value="always"></param>'
	$_HtmlCode &= '<embed src="' & $_FlashUrl & '?autoplay=1" type="application/x-shockwave-flash" allowscriptaccess="always" width="' & $_EmbedWidth - 27 & '" height="' & $_EmbedHeight - 27 & '">'
	$_HtmlCode &= '</embed>'
	$_HtmlFilePath = ''
	$_HtmlFilePath = @ScriptDir & "\AutoItFlash.html"
	$_OpenFile = FileOpen($_HtmlFilePath, 2)
	FileWrite($_OpenFile, $_HtmlCode)
	FileClose($_OpenFile)
	$oIE.navigate($_HtmlFilePath)
	;If @error Then MsgBox('','','error message')
	$oIE.document.body.scroll = "no"
	FileDelete($_HtmlFilePath)
	#cs
		$_SourceCode = _GetSourceCode ( $_FlashUrl )
		$_AllowEmbed = StringInStr ( $_SourceCode, 'attribution content=' ) + StringInStr ( $_SourceCode, "ALLOW_EMBED': false" )
		If $_AllowEmbed = 0 Then
		$_Duration = $_DurationArray[$_I]
		MsgBox('','$_Duration',$_Duration)
		;Return $_UrlToExtract
		EndIf

	#ce

	Return $_GUIActiveX
EndFunc   ;==>_GuiCtrlCreateFlash
;
Func _GetSourceCode($_Url)
	$_InetRead = InetRead($_Url)
	If Not @error Then
		$_BinaryToString = BinaryToString($_InetRead)
		If Not @error Then Return $_BinaryToString
	EndIf
EndFunc   ;==>_GetSourceCode
;
Func ShowHTML($pic, $sType = '.jpg')
	Local $_HtmlCode = ''
	$_HtmlCode &= '<!DOCTYPE html>'
	$_HtmlCode &= '<html lang="en-US">'
	$_HtmlCode &= '<head>'
	$_HtmlCode &= '<title>' & $pic & '</title>'
	$_HtmlCode &= '</head>'
	$_HtmlCode &= '<body>'
	$_HtmlCode &= '<img src="' & $pic & $sType & '"  width="825" height="475" alt="' & $pic & '">'
	$_HtmlCode &= '</body>'
	$_HtmlCode &= '<script>document.body.style.overflow = "hidden";</script>'
	$_HtmlCode &= '</html>'

	$_HtmlFilePath = @ScriptDir & "\" & $pic & ".html"
	$_OpenFile = FileOpen($_HtmlFilePath, 2)
	FileWrite($_OpenFile, $_HtmlCode)
	FileClose($_OpenFile)
	$oIE.navigate($_HtmlFilePath)
	$oIE.document.body.scroll = "no"
	FileDelete($_HtmlFilePath)
EndFunc   ;==>ShowHTML



Func _Randomize($_Max = 100)
	Do
		$_Random = Random(1, $_Max, 1)
	Until Not _AlreadyInArray($_RandomArray, $_Random)
	_ArrayAdd($_RandomArray, $_Random)
	$_RandomArray[0] = UBound($_RandomArray) - 1
	If $_RandomArray[0] >= $_Max Then ReDim $_RandomArray[1]
	Return $_Random
EndFunc   ;==>_Randomize

Func _AlreadyInArray($_SearchArray, $_Item)
	$_Index = _ArraySearch($_SearchArray, $_Item)
	If @error Then
		Return False
	Else
		If $_Index <> 0 Then
			Return True
		Else
			Return False
		EndIf
	EndIf
EndFunc   ;==>_AlreadyInArray

Func _IsArrayEmpty($_EmptyArray)
	Local $_V = UBound($_EmptyArray) - 1, $_P
	If $_V = 0 Then Return True
	For $_F = 1 To $_V
		If $_EmptyArray[$_F] = '' Then $_P = $_P + 1
	Next
	If $_P = $_V Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_IsArrayEmpty

Func _IsConnected()
	$_SrcFilePath = _TempFile(@TempDir & "\", '~google_', ".src", 7)
	Local $IsConnected = InetGet("http://www.google.com", $_SrcFilePath, 1, 1)
	Local $_Info
	Do
		$_Info = InetGetInfo($IsConnected)
		Sleep(50)
	Until $_Info[2] = True
	InetClose($IsConnected)
	_Delete($_SrcFilePath)
	If $_Info[3] <> True Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_IsConnected

Func _IsValidUrl($_IsValidUrl)
	$_Size = InetGetSize($_IsValidUrl)
	If $_Size <> 0 Then Return 1
EndFunc   ;==>_IsValidUrl

Func _Delete($_FullPath)
	$_DeleteInit = TimerInit()
	While FileExists($_FullPath)
		If StringInStr(FileGetAttrib($_FullPath), "D") Then
			DirRemove($_FullPath, 1)
		Else
			FileDelete($_FullPath)
		EndIf
		If TimerDiff($_DeleteInit) > 5000 Then Return 0
	WEnd
	Return 1
EndFunc   ;==>_Delete

Func _WinSetOnTopOneTime($_WinTitle)
	WinWait($_WinTitle, "", 2)
	WinSetOnTop($_WinTitle, "", 1)
	Sleep(250)
	WinSetOnTop($_WinTitle, "", 0)
	WinActivate($_WinTitle, "")
EndFunc   ;==>_WinSetOnTopOneTime



Func _OnAutoItExit()
	Opt("TrayIconHide", 0)
	Local $_Space = ""
	If @OSVersion = "WIN_XP" Then $_Space = "        "
	TrayTip("_LCT", $_Space & "by nitekram", 1, 1)
	;Sleep(2000)
	TrayTip('', '', 1, 1)
EndFunc   ;==>_OnAutoItExit


;function
;writtenby: XY16
;name: _SpeechGet
;description: generates speech and outputs it to the speakers.
;usage: _SpeechGet($Text, $Engine)
;$Text = the text to speak.
;$Engine = the speech engine to use, 0 = microsoft speech API 5x, 1 = Google translation API. 0 is default.
;returns 0 if no errors, 1 for errors.

Func _SpeechGet($Text, $Mode = "0")
	$aText = StringSplit($Text, '|')
	; activate main gui so that it can show when this message shows
	WinActivate($_GuiTitle)
	; hide the calling gui
	GUISetState(@SW_HIDE, @GUI_WinHandle)
	If StringInStr($Text, '|') Then
		If MsgBox(262144 + 4, 'Story?', 'Do you want to hear ' & $aText[1]) <> 6 Then
			Return
		EndIf
	EndIf
	GUISetState(@SW_SHOW, @GUI_WinHandle)

	WinActivate($_GuiTitle)

	If $Text = "" Then Return 1
	If $Mode > 1 Or $Mode < 0 Then Return 1

	If $Mode = "0" Then
		;create speech object
		Local $Voice = ObjCreate("Sapi.SpVoice")
		If Not IsObj($Voice) Then Return 1
	EndIf

	If $Mode = "0" Then
		$Voice.Rate = 1.25
		$Voice.Volume = 100
		;speak the text
		If StringInStr($Text, '|') Then
			$aText = StringSplit($Text, '|')
			$Text = $aText[2]
		EndIf
		$Voice.Speak($Text)
		$Voice = 0
		Return 0
	Else
		$aText = StringSplit($Text, '|')
		$aText = StringSplit($aText[2], ' ')

		Local $sTextToSend = ''
		For $x = 1 To UBound($aText) - 1
			$sTextToSend &= $aText[$x] & '+'
			If StringInStr($aText[$x], ',') Or StringInStr($aText[$x], '.') Or StringInStr($aText[$x], '!') Then
				;use the google translation api to get the speech
				InetGet("http://translate.google.com/translate_tts?ie=UTF-8&tl=en&q=" & $sTextToSend, @ScriptDir & "\tempspeech.mp3", 0)
				;play the downloaded speech
				SoundPlay(@ScriptDir & "\tempspeech.mp3", 1)
				;delete the temporary file
				FileDelete(@ScriptDir & "\tempspeech.mp3")
				$sTextToSend = ''
			EndIf
		Next
		Return 0
	EndIf
EndFunc   ;==>_SpeechGet