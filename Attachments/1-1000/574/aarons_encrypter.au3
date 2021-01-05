#include "GUIConstants.au3"

Global $WS_POPUP = 0x80000000
Global $WS_CAPTION = 0x00C00000
Global $WS_SYSMENU = 0x00080000
Global $WS_MINIMIZEBOX = 0x00020000
$style = $WS_POPUP + $WS_CAPTION + $WS_SYSMENU + $WS_MINIMIZEBOX
$window = GUICreate("Aaron's Encrypter", 757, 310, (@DesktopWidth - 757) / 2, (@DesktopHeight - 262) / 2, $style)

Opt ("MustDeclareVars", 1)

Global $text, $text2, $file, $file2, $msg2, $defaultstatus = "Ready", $button_13, $button_14, $button_15, $button_16, $msg, $h, $strg, $chars
Global $input_16, $button_12, $edit_17, $button_17, $progressbar, $statuslabel, $file, $fileopen, $help, $info, $save, $help2, $exit, $hmenu
Global $text3, $text4, $text5, $qn, $text7, $q, $ctrslider, $amount = 6, $what, $p, $1 = .01, $qnz, $start

$button_13 = GUICtrlCreateButton("Save As...", 10, 110, 190, 20)
$button_14 = GUICtrlCreateButton("Decrypt", 10, 140, 190, 20)
$button_15 = GUICtrlCreateButton("Encrypt", 10, 170, 190, 20)
GUICtrlCreateLabel("", 10, 230, 130, 40, 0x07)
GUICtrlCreateLabel("Encrypt! v2.01" & @LF & "Made by: Aaron Antone", 15, 235, 120, 30)
$button_16 = GUICtrlCreateButton("Text from File", 10, 80, 190, 20)
$input_16 = GUICtrlCreateInput("Enter Password", 10, 50, 200, 20)
$button_12 = GUICtrlCreateButton("Clear Box", 10, 200, 190, 20)
$edit_17 = GUICtrlCreateEdit("Text to encrypt", 220, 50, 520, 190, 0x00200000)
$button_17 = GUICtrlCreateButton("Copy to Clipboard", 550, 245, 190, 20)
$ctrslider = GUICtrlCreateSlider(220, 245, 150, 20)
GUICtrlSetLimit($ctrslider, 10, 1)
GUICtrlSetData($ctrslider, 1)
GUICtrlCreateLabel("How secure to cypher?", 375, 245, 170, 20)
$progressbar = GUICtrlCreateProgress(10, 10, 730, 30)
$statuslabel = GUICtrlCreateLabel($defaultstatus, 0, 275, 757, 16, BitOR($SS_SIMPLE, $SS_SUNKEN))
$file = GUICtrlCreateMenu("&File")
$fileopen = GUICtrlCreateMenuitem("Open", $file)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
$help = GUICtrlCreateMenu("?")
$save = GUICtrlCreateMenuitem("Save", $file)
$info = GUICtrlCreateMenuitem("Info", $help)
$help2 = GUICtrlCreateMenuitem("Help", $help)
$exit = GUICtrlCreateMenuitem("Exit", $file)
GUISetState()
$hmenu = DllCall("user32.dll", "long", "GetSystemMenu", "hwnd", $window, "long", 0)
DllCall("user32.dll", "long", "DeleteMenu", "long", $window, "long", 6, "long", 0x2)
DllCall("user32.dll", "long", "DrawMenuBar Lib", "hwnd", $window)


While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = -3
         ExitLoop
      Case $msg = $fileopen
         _TextfromFile()
      Case $msg = $save
         $text = GUIRead($edit_17)
         $file = FileSaveDialog("Save to where", @DesktopDir, "Text files (*.txt)")
         FileWrite($file & ".txt", $text)
      Case $msg = $help2
         Run("notepad.exe Aarons Encrypting Tool ReadMe")
      Case $msg = $exit
         Exit
      Case $msg = $info
         MsgBox(0, "About", "Encrypt! V2.01" & @LF & "Made by : Aaron Antone")
      Case $msg = $button_16
         _TextfromFile()
      Case $msg = $ctrslider
         If $qnz = 0 Then
            MsgBox (0, "Warning", "Changing the amount of security a lot will make long encryptions take a while")
            $qnz = 1
         EndIf
         Global $amount = GUIRead($ctrslider)
         If $amount = 10 Then
            MsgBox (0, "Warning", "You have set the security to full, This will take a LONG time to finish but it will be VERY secure.")
         EndIf
      Case $msg = $button_15
         Global $Passphrase = GUIRead($input_16)
         _encrypt()
      Case $msg = $button_14
         Global $Passphrase = GUIRead($input_16)
         _decrypt()
      Case $msg = $button_13
         $text = GUIRead($edit_17)
         $file = FileSaveDialog("Save to where", @DesktopDir, "Text files (*.txt)")
         FileWrite($file & ".txt", $text)
      Case $msg = $button_12
         GUICtrlSetData($edit_17, "")
      Case $msg = $button_17
         ClipPut(GUIRead($edit_17))
   EndSelect
Wend

Func _TextfromFile()
   $file = FileOpenDialog("Open what file?", @DesktopDir, "Text files (*.txt)")
   If Not @error Then
      $chars = FileRead($file, FileGetSize($file))
      GUICtrlSetData($edit_17, $chars)
   EndIf
EndFunc   ;==>_TextfromFile


Func EncDec($original)
   Dim $modified
   Dim $key = $Passphrase
   Dim $pos_original, $pos_key
   
   For $pos_original = 1 To StringLen($original)
      If $pos_key = StringLen($key) Then
         $pos_key = 1
      Else
         $pos_key = $pos_key + 1
      EndIf
      
      $modified = $modified & Chr(BitXOR(Asc(StringMid($original, $pos_original, 1)), Asc(StringMid($key, $pos_key, 1)), 255))
   Next
   Return $modified
EndFunc   ;==>EncDec


Func RC4($Data, $Phrase, $Decrypt)
   Local $a, $b, $i, $j, $k, $cipherby, $cipher
   Local $tempSwap, $temp, $PLen
   Local $sbox[256], $key[256]
   
   $PLen = StringLen($Phrase)
   For $a = 0 To 255
      $key[$a] = Asc(StringMid($Phrase, Mod($a, $PLen) + 1, 1))
      $sbox[$a] = $a
   Next
   
   $b = 0
   For $a = 0 To 255
      $b = Mod( ($b + $sbox[$a] + $key[$a]), 256)
      $tempSwap = $sbox[$a]
      $sbox[$a] = $sbox[$b]
      $sbox[$b] = $tempSwap
   Next
   
   If $Decrypt Then
      For $a = 1 To StringLen($Data) Step 2
         $i = Mod( ($i + 1), 256)
         $j = Mod( ($j + $sbox[$i]), 256)
         $k = $sbox[Mod( ($sbox[$i] + $sbox[$j]), 256) ]
         $cipherby = BitXOR(Dec(StringMid($Data, $a, 2)), $k)
         $cipher = $cipher & Chr($cipherby)
      Next
   Else
      For $a = 1 To StringLen($Data)
         $i = Mod( ($i + 1), 256)
         $j = Mod( ($j + $sbox[$i]), 256)
         $k = $sbox[Mod( ($sbox[$i] + $sbox[$j]), 256) ]
         $cipherby = BitXOR(Asc(StringMid($Data, $a, 1)), $k)
         $cipher = $cipher & Hex($cipherby, 2)
      Next
   EndIf
   Return $cipher
EndFunc   ;==>RC4

Func _encrypt()
   ;SplashTextOn("Prompt", "Working, this may take several minutes.....", 250, 70, -1, -1, 4, "", 18)
   Global $text = GUIRead($edit_17)
   GUICtrlSetData($statuslabel, "Encrypting")
   Local $pop = 0
   Global $i = 0
   $start = TimerInit()
   For $what = 0 To $amount Step 1
      $1 = percent($what, $amount)
      If $what > 1 Then
         $1 = $1 - 1
      EndIf
      GUICtrlSetData($progressbar, $1)
      $text = EncDec($text)
      $text = RC4($text, $Passphrase, 0)
   Next
   GUICtrlSetData($statuslabel, "Ready       ")
   GUICtrlSetData($edit_17, $text)
   ;SplashOff()
   MsgBox (0, "Prompt", "It took " & TimerDiff($Start) / 1000 & " seconds to encrypt the text")
EndFunc   ;==>_encrypt

Func _decrypt()
   ;SplashTextOn("Prompt", "Working, this may take several minutes.....", 250, 70, -1, -1, 4, "", 18)
   Global $text = GUIRead($edit_17)
   GUICtrlSetData($statuslabel, "Decrypting")
   Global $i = 0
   $start = TimerInit()
   For $what = 0 To $amount Step 1
      $1 = percent($what, $amount)
      If $what > 1 Then
         $1 = $1 - 1
      EndIf
      GUICtrlSetData($progressbar, $1)
      $text = RC4($text, $Passphrase, 1)
      $text = EncDec($text)
   Next
   GUICtrlSetData($statuslabel, "Ready         ")
   GUICtrlSetData($edit_17, $text)
   ;SplashOff()
   MsgBox (0, "Prompt", "It took " & TimerDiff($Start) / 1000 & " seconds to encrypt the text")
EndFunc   ;==>decrypt

Func percent($1, $2)
   $1 = $1 / $2
   $1 = $1 * 100
   Return $1
EndFunc   ;==>percent