
;Include constants
#include <GUIConstants.au3>
#include <file.au3>

;Initialize variables
Global $GUIWidth
Global $GUIHeight

$GUIWidth = 600
$GUIHeight = 650

;Create window
GUICreate("Files", $GUIWidth, $GUIHeight)

;Create a button#1
$1_Btn = GUICtrlCreateButton("File 1", 0, 0, 150, 25,)

;Create a button#2
$2_Btn = GUICtrlCreateButton("File 2", 0, 25, 150, 25)

;Create a button#3
$3_Btn = GUICtrlCreateButton("File 3", 0, 50, 150, 25)

;Create a button#4
$4_Btn = GUICtrlCreateButton("File 4", 0, 75, 150, 25)

;Create a button#5
$5_Btn = GUICtrlCreateButton("File 5", 0, 100, 150, 25)

;Create a button#6
$6_Btn = GUICtrlCreateButton("File 6", 0, 125, 150, 25)

;Create a button#6
$7_Btn = GUICtrlCreateButton("File 7", 0, 150, 150, 25)

;Create a button#6
$8_Btn = GUICtrlCreateButton("File 8", 0, 175, 150, 25)

;Create a button#6
$9_Btn = GUICtrlCreateButton("File 9", 0, 200, 150, 25)

;Create a button#6
$10_Btn = GUICtrlCreateButton("File 10", 0, 225, 150, 25)

;Create a button#6
$11_Btn = GUICtrlCreateButton("File 11", 0, 250, 150, 25)

;Create a button#6
$12_Btn = GUICtrlCreateButton("File 12", 0, 275, 150, 25)

;Create a button#6
$13_Btn = GUICtrlCreateButton("File 13", 0, 300, 150, 25)

;Create a button#6
$14_Btn = GUICtrlCreateButton("File 14", 0, 325, 150, 25)

;Create a button#6
$15_Btn = GUICtrlCreateButton("File 15", 0, 350, 150, 25)

;Create a button#6
$16_Btn = GUICtrlCreateButton("File 16", 0, 375, 150, 25)

;Create a button#6
$17_Btn = GUICtrlCreateButton("File 17", 0, 400, 150, 25)

;Create a button#6
$18_Btn = GUICtrlCreateButton("File 18", 0, 425, 150, 25)

;Create a button#6
$19_Btn = GUICtrlCreateButton("File 19", 0, 450, 150, 25)

;Create a button#6
$20_Btn = GUICtrlCreateButton("File 20", 0, 475, 150, 25)

;Create a button#6
$21_Btn = GUICtrlCreateButton("File 21", 0, 500, 150, 25)

;Create a button#6
$22_Btn = GUICtrlCreateButton("File 22", 0, 525, 150, 25)

;Create a button#6
$23_Btn = GUICtrlCreateButton("File 23", 0, 550, 150, 25)

;Create a button#6
$24_Btn = GUICtrlCreateButton("File 24", 0, 575, 150, 25)

;Create a button#6
$25_Btn = GUICtrlCreateButton("File 25", 300, 0, 150, 25)

;Create a button#6
$26_Btn = GUICtrlCreateButton("File 26", 300, 25, 150, 25)

;Create a button#6
$27_Btn = GUICtrlCreateButton("File 27", 300, 50, 150, 25)

;Create a button#6
$28_Btn = GUICtrlCreateButton("File 28", 300, 75, 150, 25)

;Create a button#6
$29_Btn = GUICtrlCreateButton("File 29", 300, 100, 150, 25)

;Create a button#6
$30_Btn = GUICtrlCreateButton("File 30", 300, 125, 150, 25)

;Create a button#6
$31_Btn = GUICtrlCreateButton("File 31", 300, 150, 150, 25)

;Create a button#6
$32_Btn = GUICtrlCreateButton("File 32", 300, 175, 150, 25)

;Create a button#6
$33_Btn = GUICtrlCreateButton("File 33", 300, 200, 150, 25)

;Create a button#6
$34_Btn = GUICtrlCreateButton("File 34", 300, 225, 150, 25)

;Create a button#6
$35_Btn = GUICtrlCreateButton("File 35", 300, 250, 150, 25)

;Create a button#6
$36_Btn = GUICtrlCreateButton("File 36", 300, 275, 150, 25)

;Create a button#6
$37_Btn = GUICtrlCreateButton("File 37", 300, 300, 150, 25)

;Create a button#6
$38_Btn = GUICtrlCreateButton("File 38", 300, 325, 150, 25)

;Create a button#6
$39_Btn = GUICtrlCreateButton("File 39", 300, 350, 150, 25)

;Create a button#6
$40_Btn = GUICtrlCreateButton("File 40", 300, 375, 150, 25)

;Create a button#6
$41_Btn = GUICtrlCreateButton("File 41", 300, 400, 150, 25)

;Create a button#6
$42_Btn = GUICtrlCreateButton("File 42", 300, 425, 150, 25)

;Create a button#6
$43_Btn = GUICtrlCreateButton("File 43", 300, 450, 150, 25)

;Create a button#6
$44_Btn = GUICtrlCreateButton("File 44", 300, 475, 150, 25)

;Create a button#6
$45_Btn = GUICtrlCreateButton("File 45", 300, 500, 150, 25)

;Create a button#6
$46_Btn = GUICtrlCreateButton("File 46", 300, 525, 150, 25)

;Create a button#6
$47_Btn = GUICtrlCreateButton("File 47", 300, 550, 150, 25)

;Create a button#6
$48_Btn = GUICtrlCreateButton("File 48", 300, 575, 150, 25)

;Get the list
InetGet("                                                     ", "order.txt", 1, 0)



GUISetState(@SW_SHOW)

$file = FileOpen("order.txt", 0)


; Read in 1 character at a time until the EOF is reached

$line = FileReadLine($file, 1)
    GuiCtrlSetData(3, $line)

$line1 = FileReadLine($file, 2)
    GuiCtrlSetData(4, $line1)

$line2 = FileReadLine($file, 3)
    GuiCtrlSetData(5, $line2)

$line3 = FileReadLine($file, 4)
    GuiCtrlSetData(6, $line3)

$line4 = FileReadLine($file, 5)
    GuiCtrlSetData(7, $line4)

$line5 = FileReadLine($file, 6)
    GuiCtrlSetData(8, $line5)

$line6 = FileReadLine($file, 7)
    GuiCtrlSetData(9, $line6)

$line7 = FileReadLine($file, 8)
    GuiCtrlSetData(10, $line7)

$line8 = FileReadLine($file, 9)
    GuiCtrlSetData(11, $line8)

$line9 = FileReadLine($file, 10)
    GuiCtrlSetData(12, $line9)

$line10 = FileReadLine($file, 11)
    GuiCtrlSetData(13, $line10)

$line11 = FileReadLine($file, 12)
    GuiCtrlSetData(14, $line11)

$line12 = FileReadLine($file, 13)
    GuiCtrlSetData(15, $line12)

$line13 = FileReadLine($file, 14)
    GuiCtrlSetData(16, $line13)

$line14 = FileReadLine($file, 15)
    GuiCtrlSetData(17, $line14)

$line15 = FileReadLine($file, 16)
    GuiCtrlSetData(18, $line15)

$line16 = FileReadLine($file, 17)
    GuiCtrlSetData(19, $line16)

$line17 = FileReadLine($file, 18)
    GuiCtrlSetData(20, $line17)

$line18 = FileReadLine($file, 19)
    GuiCtrlSetData(21, $line18)

$line19 = FileReadLine($file, 20)
    GuiCtrlSetData(22, $line19)

$line20 = FileReadLine($file, 21)
    GuiCtrlSetData(23, $line20)

$line21 = FileReadLine($file, 22)
    GuiCtrlSetData(24, $line21)

$line22 = FileReadLine($file, 23)
    GuiCtrlSetData(25, $line22)

$line23 = FileReadLine($file, 24)
    GuiCtrlSetData(26, $line23)

$line24 = FileReadLine($file, 25)
    GuiCtrlSetData(27, $line24)

$line25 = FileReadLine($file, 26)
    GuiCtrlSetData(28, $line25)

$line26 = FileReadLine($file, 27)
    GuiCtrlSetData(29, $line26)

$line27 = FileReadLine($file, 28)
    GuiCtrlSetData(30, $line27)

$line28 = FileReadLine($file, 29)
    GuiCtrlSetData(31, $line28)

$line29 = FileReadLine($file, 30)
    GuiCtrlSetData(32, $line29)

$line30 = FileReadLine($file, 31)
    GuiCtrlSetData(33, $line30)

$line31 = FileReadLine($file, 32)
    GuiCtrlSetData(34, $line31)

$line32 = FileReadLine($file, 33)
    GuiCtrlSetData(35, $line32)

$line33 = FileReadLine($file, 34)
    GuiCtrlSetData(36, $line33)

$line34 = FileReadLine($file, 35)
    GuiCtrlSetData(37, $line34)

$line35 = FileReadLine($file, 36)
    GuiCtrlSetData(38, $line35)

$line36 = FileReadLine($file, 37)
    GuiCtrlSetData(39, $line36)

$line37 = FileReadLine($file, 38)
    GuiCtrlSetData(40, $line37)

$line38 = FileReadLine($file, 39)
    GuiCtrlSetData(41, $line38)

$line39 = FileReadLine($file, 40)
    GuiCtrlSetData(42, $line39)

$line40 = FileReadLine($file, 41)
    GuiCtrlSetData(43, $line40)

$line41 = FileReadLine($file, 42)
    GuiCtrlSetData(44, $line41)

$line42 = FileReadLine($file, 43)
    GuiCtrlSetData(45, $line42)

$line43 = FileReadLine($file, 44)
    GuiCtrlSetData(46, $line43)

$line44 = FileReadLine($file, 45)
    GuiCtrlSetData(47, $line44)

$line45 = FileReadLine($file, 46)
    GuiCtrlSetData(48, $line45)

$line46 = FileReadLine($file, 47)
    GuiCtrlSetData(49, $line46)

$line47 = FileReadLine($file, 48)
    GuiCtrlSetData(50, $line47)

$line48 = FileReadLine($file, 49)
    GuiCtrlSetData(51, $line48)

$line49 = FileReadLine($file, 50)
    GuiCtrlSetData(52, $line49)


FileClose($file)
;FileDelete("order.txt")



;Show window/Make the window visible
GUISetState(@SW_SHOW)

;Loop until:
;- user presses Esc
;- user presses Alt+F4
;- user clicks the close button
While 1
  ;After every loop check if the user clicked something in the GUI window
   $msg = GUIGetMsg()

   Select
   
     ;Check if user clicked on the close button
      Case $msg = $GUI_EVENT_CLOSE
        ;Destroy the GUI including the controls
         GUIDelete()
        ;Exit the script
         Exit
         
     ;Check if user clicked on "Any" button
      Case $msg = $1_Btn
         GUICtrlCreateLabel (" Ordered", 150, 0, 150, 25, $BS_CENTER)
         $title = GUICtrlRead("3")         
         FileWrite("order.txt", "$title")

      ;Check if user clicked on the "Get" button
      Case $msg = $2_Btn
         GUICtrlCreateLabel (" Ordered", 150, 25, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $3_Btn
         GUICtrlCreateLabel (" Ordered", 150, 50, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $4_Btn
         GUICtrlCreateLabel (" Ordered", 150, 75, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $5_Btn
         GUICtrlCreateLabel (" Ordered", 150, 100, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $6_Btn
         GUICtrlCreateLabel (" Ordered", 150, 125, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $7_Btn
         GUICtrlCreateLabel (" Ordered", 150, 150, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $8_Btn
         GUICtrlCreateLabel (" Ordered", 150, 175, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $9_Btn
         GUICtrlCreateLabel (" Ordered", 150, 200, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $10_Btn
         GUICtrlCreateLabel (" Ordered", 150, 225, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $11_Btn
         GUICtrlCreateLabel (" Ordered", 150, 250, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $12_Btn
         GUICtrlCreateLabel (" Ordered", 150, 275, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $13_Btn
         GUICtrlCreateLabel (" Ordered", 150, 300, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $14_Btn
         GUICtrlCreateLabel (" Ordered", 150, 325, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $15_Btn
         GUICtrlCreateLabel (" Ordered", 150, 350, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $16_Btn
         GUICtrlCreateLabel (" Ordered", 150, 375, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $17_Btn
         GUICtrlCreateLabel (" Ordered", 150, 400, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $18_Btn
         GUICtrlCreateLabel (" Ordered", 150, 425, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $19_Btn
         GUICtrlCreateLabel (" Ordered", 150, 450, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $20_Btn
         GUICtrlCreateLabel (" Ordered", 150, 475, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $21_Btn
         GUICtrlCreateLabel (" Ordered", 150, 500, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $22_Btn
         GUICtrlCreateLabel (" Ordered", 150, 525, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $23_Btn
         GUICtrlCreateLabel (" Ordered", 150, 550, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $24_Btn
         GUICtrlCreateLabel (" Ordered", 150, 575, 150, 25, $BS_CENTER)

;Check if user clicked on "Any" button
      Case $msg = $25_Btn
         GUICtrlCreateLabel (" Ordered", 450, 0, 150, 25, $BS_CENTER)         

      ;Check if user clicked on the "Get" button
      Case $msg = $26_Btn
         GUICtrlCreateLabel (" Ordered", 450, 25, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $27_Btn
         GUICtrlCreateLabel (" Ordered", 450, 50, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $28_Btn
         GUICtrlCreateLabel (" Ordered", 450, 75, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $29_Btn
         GUICtrlCreateLabel (" Ordered", 450, 100, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $30_Btn
         GUICtrlCreateLabel (" Ordered", 450, 125, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $31_Btn
         GUICtrlCreateLabel (" Ordered", 450, 150, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $32_Btn
         GUICtrlCreateLabel (" Ordered", 450, 175, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $33_Btn
         GUICtrlCreateLabel (" Ordered", 450, 200, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $34_Btn
         GUICtrlCreateLabel (" Ordered", 450, 225, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $35_Btn
         GUICtrlCreateLabel (" Ordered", 450, 250, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $36_Btn
         GUICtrlCreateLabel (" Ordered", 450, 275, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $37_Btn
         GUICtrlCreateLabel (" Ordered", 450, 300, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $38_Btn
         GUICtrlCreateLabel (" Ordered", 450, 325, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $39_Btn
         GUICtrlCreateLabel (" Ordered", 450, 350, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $40_Btn
         GUICtrlCreateLabel (" Ordered", 450, 375, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $41_Btn
         GUICtrlCreateLabel (" Ordered", 450, 400, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $42_Btn
         GUICtrlCreateLabel (" Ordered", 450, 425, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $43_Btn
         GUICtrlCreateLabel (" Ordered", 450, 450, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $44_Btn
         GUICtrlCreateLabel (" Ordered", 450, 475, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $45_Btn
         GUICtrlCreateLabel (" Ordered", 450, 500, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $46_Btn
         GUICtrlCreateLabel (" Ordered", 450, 525, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $47_Btn
         GUICtrlCreateLabel (" Ordered", 450, 550, 150, 25, $BS_CENTER)

      ;Check if user clicked on the "Get" button
      Case $msg = $48_Btn
         GUICtrlCreateLabel (" Ordered", 450, 575, 150, 25, $BS_CENTER)

      
         
   EndSelect

WEnd