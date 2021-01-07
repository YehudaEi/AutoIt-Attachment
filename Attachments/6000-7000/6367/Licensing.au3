; Licensing.au3 enables you to provide product registration for your apps.
; Written by Andy Swarbrick, PopG 2005-6.
; Requires:
; 1. Autoit 3.1.1.102 or better.
; 2. Inno Key Generator                                      -freeware aimed at Inno Setup.  I have no affiliaton with IKG.
; Notes:
; 1. The example test harness writes an encrypted product key to HKCU\Sw\MyApp.  You can choose your own location.  But pretty well you should be able to embed this in your app & go.
; 2. IKG supports a range of registration tests.  I like to simply do time limiting, which I have extended in the harness to give a nonags time slot.
; 3. Read the comments carefully - especially about where the files ISID.IKY and ISID.DLL must be.
; 4. At least you must run the IKG program, create a suitable key and save it in the same folder as ISID.DLL with the name ISID.IKY.
#region 	Init: Includes
	#include-once
	#include <GUIConstants.au3>
	#include <string.au3>
#endregion	Init: Includes
#region		Run: TestHarness
;~ 	If @YEAR>='2006' And @MON>=1 Then		; This If...Endif means that you can provide a start date from when licensing actually starts.
;~ 		Local $User	=''
;~ 		Local $Orgn	=''
;~ 		Local $Ud	=''
;~ 		Local $MAC	=''
;~ 		Local $HDD	=''
;~ 		Local $Prv	='XYXYXYXY-!"£$-JKLIP-POQW-HJKHKHKHKHKH'	; This needs protecting!  Don't tell anyone this.  Make your your scrpt is encrypted before compilation.
;~ 		Local $Pub												; This is the string you give to your customers.
;~ 		Local $Pub	=_StringEncrypt(False,RegRead('hkey_current_user\Software\MyApp','Pub'),$Prv&'fred',4)		;RegRead&Write 'password' MUST be identical.  Corrupt the Prv key to protect it.
;~ 		Local $Valid=_Vlic($User, $Orgn, $Ud, $HDD, $MAC, $Prv, $Pub)	;Validate initially for each execution of your program against the data in the registry.
;~ 		If Not $Valid Then
;~ 			Local $FrmWid=350
;~ 			Local $FrmHig=120
;~ 			Local $Form1	=GUICreate('Product Registration', $FrmWid, $FrmHig, (@DesktopWidth-$FrmWid)/2, (@DesktopHeight-$FrmHig)/2)
;~ 			Local $Label	=GUICtrlCreateLabel('Enter key and click validate to register this product.', 8, 16, 334, 17)
;~ 			Local $Input1	=GUICtrlCreateInput('', 8, 40, 321, 21, -1, $WS_EX_CLIENTEDGE)
;~ 			Local $BtnValid	=GUICtrlCreateButton('&Validate',	32, 80, 100, 25)
;~ 			Local $BtnCanc	=GUICtrlCreateButton('&Cancel',		192, 80, 100, 25)
;~ 			Local $Count=1
;~ 			Local $i
;~ 			GUICtrlSetState($BtnValid,$GUI_DEFBUTTON)
;~ 			GUISetState(@SW_SHOW)
;~ 			While True
;~ 				Local $msg	=GuiGetMsg()
;~ 				Select
;~ 				Case $msg	=$GUI_EVENT_CLOSE Or $msg=$BtnCanc
;~ 					GUICtrlSetState($BtnValid,	$GUI_DISABLE)
;~ 					For $i=5 To 1 Step -1
;~ 						GUICtrlSetData($Label,'Having problems registering?  Email sales@popg.co.uk for help. '&$i)
;~ 						Sleep(1000)
;~ 					Next
;~ 					Exit
;~ 				Case $msg	=$BtnValid
;~ 					$Count=$Count+1
;~ 					If $Count>9 Then Exit
;~ 					GUICtrlSetState($BtnValid,	$GUI_DISABLE)
;~ 					GUICtrlSetState($BtnCanc,	$GUI_DISABLE)
;~ 					$Pub=GUICtrlRead($Input1)
;~ 					If $Count>3 Then Sleep(1000*Random(1,3,True))
;~ 					GUICtrlSetData($Label,'Validating...')
;~ 					Sleep(1000)
;~ 					$Valid=	_Vlic($User, $Orgn, $Ud, $HDD, $MAC, $Prv, $Pub)
;~ 					If $Valid Then
;~ 						RegWrite('hkey_current_user\Software\MyApp','Pub','REG_SZ',_StringEncrypt(True,$Pub,$Prv&'fred',4))
;~ 						For $i=5 To 1 Step -1
;~ 							GUICtrlSetData($Label,'Registration complete.  Thank you for your interest in our products. '&$i)
;~ 							Sleep(1000)
;~ 						Next
;~ 						ExitLoop
;~ 					Else
;~ 						GUICtrlSetData($Label,'Registration code is invalid. Email sales@popg.co.uk for assistance.')
;~ 						GUICtrlSetState($BtnCanc,	$GUI_ENABLE)
;~ 						GUICtrlSetState($BtnValid,	$GUI_ENABLE)
;~ 					EndIf
;~ 				EndSelect
;~ 			WEnd
;~ 			GUICtrlDelete($Form1)
;~ 		EndIf
;~ 	EndIf
;~ 	Exit
#endregion	Run: TestHarness
; _Vlic								Validates a license key produced by IKG.  Returns true if ok.
; 
;
; $User, $Orgn, $Ud, $Hdd, $Mac		Set these as you define then in Inno Key Generator, otherwise leave blank.
; $Prv								The private (application) key from Inno Key Generator.  Burn this into your app.
; $Pub								This is the registration key that IKG creates.  Give this to your user(s).
Func _Vlic($User, $Orgn, $Ud, $HDD, $MAC, $Prv, $Pub)
	Local $Vsn, $Dfl, $Wdr, $Err
	Local $Dfl='ISID.DLL'
	Local $Lky='ISID.IKY'
	; IMPORTANT: When saving a key file place it in the IKG folder below with the ISID.DLL.  Make sure they are together!!!!
	$Err=FileInstall('C:\Program Files\MJ Freelancing\IKG\ISID\ISID.DLL',	@TempDir&'\'&$Dfl,True)			;This file is installed here by 
	$Err=FileInstall('C:\Program Files\MJ Freelancing\IKG\ISID\ISID.IKY',	@TempDir&'\'&$Lky,True)
	Local $Wdr=@WorkingDir
	FileChangeDir('C:\Program Files\MJ Freelancing\IKG\ISID')		;Use FileChangeDir since DllCall ONLY takes a filename, and not a pathname.
;	Private Declare Function ValidateSerialNumber Lib "ISID.DLL" _
;	(ByVal InnoKeyFile As String, ByVal User As String, ByVal Orgn As String, _
;	ByVal ProdCode As String, ByVal HDD As String, ByVal MAC As String, _
;	ByVal PrivateKey As String, ByVal Serial As String) As Boolean
;	(Taken from the IKG help file)
	Local $Vsn=DllCall($Dfl,'int','ValidateSerialNumber', 'str',$Lky, 'str',$User, 'str',$Orgn, 'str',$Ud, 'str',$HDD, 'str',$MAC, 'str',$Prv, 'str',$Pub)
	Local $Ees=@error
	FileChangeDir($Wdr)
	FileDelete(@TempDir&'\'&$Dfl)
	FileDelete(@TempDir&'\'&$Lky)
	If $Ees<>0 Then
		SetError(1)
		Return -1
	Else
		Return $Vsn[0]==1
	EndIf
EndFunc