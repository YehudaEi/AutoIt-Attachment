#Region ;**** 参数创建于 ACNWrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\windows\system32\SHELL32.dll
#AutoIt3Wrapper_UseUPX=n
#AutoIt3Wrapper_Res_Comment=数控定制请联系我
#AutoIt3Wrapper_Res_Description=13877492840  qq306000250
#AutoIt3Wrapper_Res_FileVersion=0.1.0.0
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
; *** ACNWrapper开始添加 ***

; *** ACNWrapper结束添加 ***
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#Region ### START Koda GUI section ##
$Form1_1 = GUICreate("your tools", 435, 430, 908, 220)
$Label1 = GUICtrlCreateLabel("move to axis", 40, 136, 76, 16)
$Label2 = GUICtrlCreateLabel("F_mach3 speed", 34, 104, 82, 16)
$Label3 = GUICtrlCreateLabel("Z axis /tools down/total", 8, 248, 157, 16)
$Label4 = GUICtrlCreateLabel("A axis total deg", 8, 216, 115, 16)
$Label5 = GUICtrlCreateLabel("the main driving axis", 192, 136, 146, 16)
$Label6 = GUICtrlCreateLabel("per step deep", 16, 304, 100, 16)
$Label7 = GUICtrlCreateLabel("", 192, 216, 16, 40)
$Label8 = GUICtrlCreateLabel("BY you", 8, 360, 188, 40)
$Button1 = GUICtrlCreateButton("gen the G code", 256, 304, 105, 57)
$afrom = GUICtrlCreateInput("0", 120, 216, 65, 19)
$ato = GUICtrlCreateInput("3600", 208, 216, 57, 19)
$fspeed = GUICtrlCreateInput("800", 120, 104, 65, 19)
$fromx = GUICtrlCreateInput("x", 120, 136, 65, 19)
$zfrom = GUICtrlCreateInput("0", 120, 272, 65, 19)
$zstep = GUICtrlCreateInput("-0.3", 120, 304, 65, 19)
$zto = GUICtrlCreateInput("-2", 208, 272, 57, 19)
$Label9 = GUICtrlCreateLabel("to", 193, 272, 16, 17)
$initcode = GUICtrlCreateInput("g0 x0 y0 z0 a0", 120, 64, 209, 19)
$Label10 = GUICtrlCreateLabel("init header", 40, 64, 68, 17)
$Label11 = GUICtrlCreateLabel("total cutting lenth", 0, 168, 120, 16)
$slong = GUICtrlCreateInput("10", 120, 168, 65, 19)
$Input1 = GUICtrlCreateInput("c:\cccc.txt", 119, 14, 209, 19)
$Label12 = GUICtrlCreateLabel("save to", 62, 12, 52, 17)
$Button2 = GUICtrlCreateButton("select path", 340, 11, 80, 25)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			

		Case $Button2
			$filename = FileSaveDialog("please select a place to place the code file", @AppDataCommonDir, " (*.txt)", 2)
			; 选项 2 = 除非选择一个有效的路径/文件,或者按下取消按钮,对话框不能关闭.

			If @error Then
				MsgBox(4096, "", "you have no set filename")
			Else

			EndIf
			GUICtrlSetData($Input1, $filename)
			$codefile = GUICtrlRead($Input1)
			
		Case $Button1
			
			$codefile = GUICtrlRead($Input1)
			FileClose($codefile)
			FileDelete($codefile)
			
			
			
			
			
			
			
			
			;读取 输入从这里开始写入
			$x1 = GUICtrlRead($slong)
			$x0 = 0
			$a0 = GUICtrlRead($afrom)
			$a1 = GUICtrlRead($ato)
			$z0 = GUICtrlRead($zfrom)
			$z1 = GUICtrlRead($zto)
			$zst = GUICtrlRead($zstep)
			$filename = GUICtrlRead($Input1)
			$MyDocsFolder = ""

			$a = $a0
			$freq = GUICtrlRead($fspeed)
			
			
			$isaxis = GUICtrlRead($fromx)
			$intcode = GUICtrlRead($initcode)
			
			If FileOpen($codefile, 1) = -1 Then
				
				MsgBox(0, "bug", "close app and come again")
				Exit
			EndIf
			
			FileWriteLine($codefile, $intcode & " f" & $freq)
			
			
			
			
			
			
			
			For $i = $z0 To $z1 Step $zst
				
				$zs = Round($i, 4)
				Select
					Case $a = $a0
						
						
						$doit = FileWriteLine($codefile, "g1 z" & $zs)
						$doit = FileWriteLine($codefile, $isaxis & "0" & " " & "a" & $a)
						
						$a = $a1

					Case $a = $a1
						$doit = FileWriteLine($codefile, "g1 z" & $zs)
						$doit = FileWriteLine($codefile, $isaxis & $x1 & " " & "a" & $a & " " & "z" & $zs)

						$a = $a0


				EndSelect


			Next
			Select
				Case $a = $a0
					
					
					$doit = FileWriteLine($codefile, "g1 z" & $z1)
					$doit = FileWriteLine($codefile, $isaxis & "0" & " " & "a" & $a)
					
					$a = $a1

				Case $a = $a1
					$doit = FileWriteLine($codefile, "g1 z" & $z1)
					$doit = FileWriteLine($codefile, $isaxis & $x1 & " " & "a" & $a & " " & "z" & $z1)

					$a = $a0


			EndSelect
			
			$doit = FileWriteLine($codefile, "g1 z10")
			$doit = FileWriteLine($codefile, "g0 x0")
			FileClose($codefile)

			ShellExecute($codefile)





	EndSwitch
WEnd
