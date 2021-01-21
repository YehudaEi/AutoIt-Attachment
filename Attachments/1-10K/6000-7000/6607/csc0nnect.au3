;; c0unter - c0nnect
;; By Nick " Str!ke " Kamoen

             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             ;;;Nick;Kamoen;Software;;;;;;;;;;
             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             ;;;;;;Deepdesigns.nl;;;;;;;;;;;;;
             ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
 
#include <GUIConstants.au3>
Global $patherz, $nr, $spr, $rn, $cmd, $upd
GUICreate("c0unter - c0nnect", 350, 350)

;; Other

GuiCtrlCreatePic("header.jpg",0,0, 0,0)
TrayTip("c0unter - c0nnect", "By Nick [Str!ke] Kamoen ", 0, 64)

;; Gui stuff
$hlfol = RegRead("HKEY_CURRENT_USER\Software\Valve\Steam", "ModInstallPath")
$csfol = StringReplace($hlfol, "half-life", "counter-strike\cstrike")


$text1 = GuiCtrlCreateLabel("Steam Path", 210, 60 )

$text2 = GuiCtrlCreateLabel("Play Name", 210, 80 )

$text3 = GuiCtrlCreateLabel("Play IP", 210, 100 )

$text4 = GuiCtrlCreateLabel("Server Password", 210, 120 )

$text5 = GuiCtrlCreateLabel("Rcon Password", 210, 140 )

$text6 = GuiCtrlCreateLabel("Rate", 210, 160 )

$text7 = GuiCtrlCreateLabel("Cmd Rate", 210, 180 )

$text8 = GuiCtrlCreateLabel("Update Rate", 210, 200 )

$ButtonSave = GuiCtrlCreateButton("Save Settings", 100, 220, 100, 20)

$buttonplay = GuiCtrlCreateButton("Play!", 0, 220, 100, 20)

;; Ini

$Path = Iniread("settings.ini", "Main", "$Path", $csfol)

$name = Iniread("settings.ini", "Main", "$name", "Your Name")

$ip = Iniread("settings.ini", "Main", "$ip", "Your Ip")

$spw = Iniread("settings.ini", "Main", "$spw", "Server Password [ If Needed ]")

$rnp = Iniread("settings.ini", "Main", "$rnp", "")

$ir = Iniread("settings.ini", "Main", "$ir", "Rate (Default: 25000) ")

$cmdr = Iniread("settings.ini", "Main", "$cmdr", "cl_cmdrate (Best: 101) ") 

$updr = Iniread("settings.ini", "Main", "$updr", "cl_updaterate (Best: 101) ") 

GUISetState(@SW_SHOW)


;; Input

$InputPath = GuiCtrlCreateInput($Path, 0, 60, 200, 20)

$Inputname = GuiCtrlCreateInput($name, 0, 80, 200, 20)

$Inputip = GuiCtrlCreateInput($ip, 0, 100, 200, 20)

$inputspw = GuiCtrlCreateInput($spw, 0, 120, 200, 20)

$inputrp = GuiCtrlCreateInput($rnp, 0, 140, 200, 20, 0x21) 

$inputrate = GuiCtrlCreateInput($ir, 0, 160, 200, 20) 

$inputcmdr = GuiCtrlCreateInput($cmdr, 0, 180, 200, 20) 

$inputupdr = GuiCtrlCreateInput($updr, 0, 200, 200, 20) 

;; While

GuiSetState()

 While 1

     $msg = GuiGetMsg()

     Select

 Case $msg = $ButtonSave
     
$pr = GUICtrlRead($InputPath)

$nr = GUICtrlRead($Inputname)

$ip = GUICtrlRead($Inputip)

$spr = GUICtrlRead($inputspw)

$rn = GUICtrlRead($inputrp)

$ir = GUICtrlRead($inputrate)

$cmd = GUICtrlRead($inputcmdr)

$upd = GUICtrlRead($inputupdr)
$patherz = GuiCtrlRead($InputPath)


      Iniwrite("settings.ini", "Main", "$Path", $pr)

      Iniwrite("settings.ini", "Main", "$name", $nr)

      Iniwrite("settings.ini", "Main", "$ip", $ip) 

      Iniwrite("settings.ini", "Main", "$spw", $spr)

      Iniwrite("settings.ini", "Main", "$rnp", $rn)

      Iniwrite("settings.ini", "Main", "$ir", $ir)

      Iniwrite("settings.ini", "Main", "$cmdr", $cmd)

      Iniwrite("settings.ini", "Main", "$updr", $upd)

 Case $msg = $Buttonplay
            TrayTip("c0unter - c0nnect", "Launching Counter - Strike", 0, 64)
            run( GuiCtrlRead($InputPath)&"Steam.exe -applaunch 10 +connect " & $ip & " +name " & $nr & " +password " & $spr & " +rcon_password " & $rn & " +rate " & $ir & " +cl_cmdrate " & $cmd & " +cl_updaterate " & $upd ) 
            GUISetState(@SW_HIDE)
     

Case $msg = $GUI_EVENT_CLOSE

  ExitLoop
 
      endSelect
wend