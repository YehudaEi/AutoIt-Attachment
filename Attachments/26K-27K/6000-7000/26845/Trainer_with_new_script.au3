#NoTrayIcon; No icon at the bottom of screen
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

Global $Main
Global $ACCT 
Global $Password
Global $Cancelar
Global $CREA =  'http://gohc.ipbfree.com/index.php?act=Reg&CODE=00'
Global $CONF

MainFunc()
#Region  
Func MainFunc()
    Opt('GUICoordMode',1)                                                         
    Opt('GUIOnEventMode',1)                   
   
    $Main   = GUICreate('Logue with your account of Forum',400,250,150,150)
    GUICtrlCreateGroup('',10,2,380,100)                
        GUICtrlCreateLabel('Terms of use of this Software',30,10,340,18)
		GUICtrlSetColor(-1, 0x0012FF)
        GUICtrlSetFont(-1,12,400)
        GUICtrlCreateLabel('To use this software to be Registered in Forum',30,28,340,18)
        GUICtrlSetFont(-1,12,400)
        GUICtrlCreateLabel('After you register, use the login and password',30,46,340,18)
        GUICtrlSetFont(-1,12,400)
        GUICtrlCreateLabel('To open the program',30,64,340,18)
        GUICtrlSetFont(-1,12,400)
        GUICtrlCreateLabel('Team gOHc Thank you for your choice',30,82,340,18)
        GUICtrlSetFont(-1,12,400)
    GUICtrlCreateGroup('',-99,-99,1,1)
    GUICtrlSetBkColor(-1,0x000000)
	
	SplashTextOn('Carregando o Programa','Wait for the program open do not try to close it',400,150,150,150,0,'',22,200)
Sleep(2000)
SplashOff()

       $ACCT  = GUICtrlCreateInput('Your Account Here',120,120,250,18)                  
    $Password  = GUICtrlCreateInput('Your Password Here',120,140,250,18)             
    GUICtrlCreateLabel('Account Name:',5,120,100,12)                    
    GUICtrlCreateLabel('Password:',5,140,100,12)                      						
   
    $CONF   = GUICtrlCreateButton('Open Trainer',120,190,81,33)         
    $CREA   = GUICtrlCreateButton('Creat my Acc',205,190,81,33)                    
   
    GUICtrlSetState($CREA,$GUI_ENABLE)	
	GUISetOnEvent($GUI_EVENT_CLOSE, "onautoitexit")
    GUICtrlSetOnEvent($CREA,'')                                                
    GUISetState(@SW_SHOW)                                                         
   
    While 1                     
        Sleep(10)
    WEnd
EndFunc
#EndRegion  


Opt("guioneventmode", 1); allows us to use GUIsetonevent



$version = "v4.4 "; Put in the version of your trainer here
local $listText, $s_TempText

_Gercheck(); Checks what version you are using 


$ID = _MemoryOpen(ProcessExists("Nksp.exe")); Opens the Last Chaos Memory
if $country = 'BRA' Then; If the country is BRA then
$pointer = 0x105D5398; the pointer is *insert pointer*
$skilladd = _MemoryRead($pointer, $ID) + 0x000FC534; Skill Speed offset
$Attkadd = _MemoryRead($pointer, $ID) + 0x000FC4A8; attack speed offset
$runadd = _MemoryRead($pointer, $ID) + 0x000FC4A0; run speed offset
$rangeadd = _MemoryRead($pointer, $ID) + 0x000FC4A4;  range offset
$Monsadd = _MemoryRead($pointer, $ID) + 0x000FC0E0;  pvp offset
$Petadd = _MemoryRead($pointer, $ID) + 0x000FC4A8; pet lver
ElseIf $country = 'Espanha' Then
$pointer = 0x105D4318; the pointer is *insert pointer*
$skilladd = _MemoryRead($pointer, $ID) + 0x000FC534; Skill Speed offset
$Attkadd = _MemoryRead($pointer, $ID) + 0x000FC4A8; attack speed offset
$runadd = _MemoryRead($pointer, $ID) + 0x000FC4A0; run speed offset
$rangeadd = _MemoryRead($pointer, $ID) + 0x000FC4A4;  range offset
$Monsadd = _MemoryRead($pointer, $ID) + 0x000FC0E0;  pvp offset
$Petadd = _MemoryRead($pointer, $ID) + 0x000FC4A8; pet lver
Endif


$form = GUICreate("LC " & $country & " Hack Public - gOHc -" & $version, 500, 300); Creates a GUI window 
GUISetOnEvent($GUI_EVENT_CLOSE, "onautoitexit"); puts it on the event to close
GUISetBkColor(0xFFFFFF); sets the background color to black
$listText = GUICtrlCreateList("                  - Hack Made - Bode.                         Acesse / Visite nuestro sitio web - www.gOHc.webnode.com -                          Atenção / Atención: Evite usar este software perto de outros players - [Evite el uso de este software en torno a otros jugadores]                                      Este Software é/es totalmente FREE.                                                     Para maiores [más] informações [información] deixe [dejar] mensagens [mensajes] no [en el] Site [sitio web] ( Atravez do Chat )                          Equipe gOHc Agradece sua Escolha . ", 50, 10, 306, 40, 10) ; a label (change it to your name
GUICtrlSetFont(-1, 17, 400, 2, "Impact"); font
GUICtrlSetColor(-1, 0x000000); color  
GUICtrlCreateLabel("Atenção : Se ativar Attack Speed nao ative o Pet Lever",10,280,550)
GUICtrlCreateLabel("Atención: Si activa la Attack Speed no permitir lo Pet Lever",10,260,570)
GUICtrlSetColor(-1, 0x0012FF) 
GUICtrlCreateGroup("Info",348,200,140,80) 
GUICtrlCreateLabel("Ver:",355,215,570)
GUICtrlSetColor(-1, 0x0012FF)
GUICtrlCreateLabel("N°:",355,235,570)
GUICtrlSetColor(-1, 0x0012FF)
GUICtrlCreateLabel("Make:",355,255,570)
GUICtrlSetColor(-1, 0x0012FF)
GUICtrlCreateLabel("Publica Multi-Versao",386,215,570)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlCreateLabel("4.40",386,235,570)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlCreateLabel("06/06/2009",386,255,570)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlCreateButton("Botao",200,300,20)
$Attk = GUICtrlCreateCheckbox("Attack Speed (Low) ", 290, 80, 121, 17) 
GUICtrlCreateGroup("Principais",280,64,180,120) 
GUICtrlSetBkColor(-1, 0xFFFFFF)
$run = GUICtrlCreateCheckbox("Super Run Speed", 290, 140, 121, 17)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Pet = GUICtrlCreateCheckbox("Pet Lever", 290, 160, 121, 17)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$CustomMons = GUICtrlCreateCheckbox("Monster Level", 65, 170, 121, 17)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$range = GUICtrlCreateCheckbox("2x Range", 290, 100, 121, 17)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Customattk = GUICtrlCreateCheckbox("Custom Attack Speed", 65, 110, 121, 17)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Customrun = GUICtrlCreateCheckbox("Custom Run Speed", 65, 140, 121, 17)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$skill = GUICtrlCreateCheckbox("Super Skill", 290, 120, 121, 17)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$CustomRange = GUICtrlCreateCheckbox("Custom Range", 65, 80, 121, 17)
GUICtrlCreateGroup("Custom",50,64,190,140)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$AttackSpeed = GUICtrlCreateInput("1", 190, 110, 41, 21)
$Runspeed = GUICtrlCreateInput("12", 190, 140, 41, 21)
$Range1 = GUICtrlCreateInput("30", 190, 80, 41, 21)
$Mons1 = GUICtrlCreateInput("1", 190, 170, 41, 21)
GUISetState(@SW_SHOW)
While 1
Sleep(250)
     $s_TempText = GUICtrlRead($listText)
     GUICtrlSetData($listText, "|" & StringTrimLeft($s_TempText, 1)  & StringLeft($s_TempText, 1))

   If GUICtrlRead($Attk) = 1 Then
       _MemoryWrite($Attkadd, $ID, 8)
   EndIf
   If GUICtrlRead($run) = 1 Then
       _MemoryWrite($runadd, $ID, 15, 'float')
   EndIf
   If GUICtrlRead($Pet) = 1 Then
       _MemoryWrite($Petadd, $ID, 35)
   EndIf
   If GUICtrlRead($CustomMons) = 1 Then
       _MemoryWrite($Monsadd, $ID, GUICtrlRead($Mons1))
   EndIf
   If GUICtrlRead($range) = 1 Then
       _MemoryWrite($rangeadd, $ID, 30, 'float')
   EndIf
   If GUICtrlRead($skill) = 1 Then
       _MemoryWrite($skilladd, $ID, 2)
   EndIf
   If GUICtrlRead($Customattk) = 1 Then
       _MemoryWrite($Attkadd, $ID, GUICtrlRead($AttackSpeed))
   EndIf
   If GUICtrlRead($Customrun) = 1 Then
       _MemoryWrite($runadd, $ID, GUICtrlRead($Runspeed), 'float')
   EndIf
   If GUICtrlRead($CustomRange) = 1 Then
       _MemoryWrite($rangeadd, $ID, GUICtrlRead($Range1), 'float')
   EndIf
WEnd




Func _MemoryOpen($iv_Pid, $iv_DesiredAccess = 0x1F0FFF, $if_InheritHandle = 1)
   
   If Not ProcessExists($iv_Pid) Then
       SetError(1)
       Return 0
   EndIf
   
   Local $ah_Handle[2] = [DllOpen('kernel32.dll')]
   
   If @error Then
       SetError(2)
       Return 0
   EndIf
   
   Local $av_OpenProcess = DllCall($ah_Handle[0], 'int', 'OpenProcess', 'int', $iv_DesiredAccess, 'int', $if_InheritHandle, 'int', $iv_Pid)
   
   If @error Then
       DllClose($ah_Handle[0])
       SetError(3)
       Return 0
   EndIf
   
   $ah_Handle[1] = $av_OpenProcess[0]
   
   Return $ah_Handle
   
EndFunc  ;==>_MemoryOpen
Func _MemoryRead($iv_Address, $ah_Handle, $sv_Type = 'dword')
   
   If Not IsArray($ah_Handle) Then
       SetError(1)
       Return 0
   EndIf
   
   Local $v_Buffer = DllStructCreate($sv_Type)
   
   If @error Then
       SetError(@error + 1)
       Return 0
   EndIf
   
   DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
   
   If Not @error Then
       Local $v_Value = DllStructGetData($v_Buffer, 1)
       Return $v_Value
   Else
       SetError(6)
       Return 0
   EndIf
   
EndFunc  ;==>_MemoryRead
Func _MemoryWrite($iv_Address, $ah_Handle, $v_Data, $sv_Type = 'dword')
   
   If Not IsArray($ah_Handle) Then
       SetError(1)
       Return 0
   EndIf
   
   Local $v_Buffer = DllStructCreate($sv_Type)
   
   If @error Then
       SetError(@error + 1)
       Return 0
   Else
       DllStructSetData($v_Buffer, 1, $v_Data)
       If @error Then
           SetError(6)
           Return 0
       EndIf
   EndIf
   
   DllCall($ah_Handle[0], 'int', 'WriteProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
   
   If Not @error Then
       Return 1
   Else
       SetError(7)
       Return 0
   EndIf
   
EndFunc  ;==>_MemoryWrite


Func _gercheck()
   Local $ChangeText[3] = ['', 'Brasil', 'Español']
   $iMsg = _MsgBoxEx(4, 'Hack Public v4.4 by gOHc ', 'Escolha a versao que voce usa / Elija la versión que uso', 0, $ChangeText)
   If $iMsg = 6 Then
               Global $country = 'BRA'
           EndIf
		   If $iMsg = 7 Then
               Global $country = 'Espanha'
               
           EndIf

		
               

EndFunc 


Func _MsgBoxEx($iFlag, $sTitle, $sText, $iTime = 0, $sCIDChange = '')
   Local $_MsgBox_ = '"' & "ConsoleWrite(MsgBox(" & $iFlag & ', ""' & $sTitle & '"", ""' & $sText & '"", ' & $iTime & '"))'
   Local $iPID = Run(@AutoItExe & ' /AutoIt3ExecuteLine ' & $_MsgBox_, '', @SW_SHOW, 6)
   Do
       Sleep(10)
   Until WinExists($sTitle)
   If IsArray($sCIDChange) Then
       For $iCC = 1 To UBound($sCIDChange) - 1
           ControlSetText($sTitle, '', 'Button' & $iCC, $sCIDChange[$iCC])
       Next
   Else
       ControlSetText($sTitle, '', 'Button1', $sCIDChange)
   EndIf
   While ProcessExists($iPID)
       Local $iStdOut = StdoutRead($iPID)
       If Number($iStdOut) Then Return $iStdOut
       Sleep(10)
   WEnd
   If IsArray($sCIDChange) Then Return SetError(1, 0, 2)
   Return SetError(1, 0, 1)
EndFunc  ;==>_MsgBoxEx

Func onautoitexit()
   Exit
EndFunc  ;==>onautoitexit