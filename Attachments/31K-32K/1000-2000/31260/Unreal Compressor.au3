#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Archive2.ico
#AutoIt3Wrapper_outfile=..\Unreal Compressor.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.4.0
 Author:         [ADP]-Dirty
 Script Function:
	Template AutoIt script.
#ce ----------------------------------------------------------------------------
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <GuiStatusBar.au3>
#Include <File.au3>
#include <Sound.au3>
	#include <CompressUT2004Function.au3>
	#include <CompressUT3Function.au3>


FileInstall ('MMGreetingsComrads.wav', @TempDir & '/MMGreetingsComrads.wav',1)
FileInstall ('MMSeeya.wav', @TempDir & '/MMSeeya.wav',1)
FileInstall ('MMSorry.wav', @TempDir & '/MMSorry.wav',1)
FileInstall ('MMSweet.wav', @TempDir & '/MMSweet.wav')
FileInstall ('MMYouSuckB.wav', @TempDir & '/MMYouSuckB.wav',1)
FileInstall ('MMNice.wav', @TempDir & '/MMNice.wav',1)
FileInstall ('MMSearchAndDestroy.wav', @TempDir & '/MMSearchAndDestroy.wav',1)
FileInstall ('MMGotIt.wav', @TempDir & '/MMGotIt.wav',1)
FileInstall ('MMYouSuckB.wav', @TempDir & '/MMYouSuckB.wav',1)

FileInstall ('MMFinally.wav', @TempDir & '/MMFinally.wav',1)
FileInstall ('MMIHateWhenThatHappens.wav', @TempDir & '/MMIHateWhenThatHappens.wav',1)
FileInstall ('MMINeedSomeBackup.wav', @TempDir & '/MMINeedSomeBackup.wav',1)
FileInstall ('MMLetsRockB.wav', @TempDir & '/MMLetsRockB.wav',1)
FileInstall ('MMSonOfABitch.wav', @TempDir & '/MMSonOfABitch.wav',1)
FileInstall ('01_UT2007_MenuTheme.wav', @TempDir & '/01_UT2007_MenuTheme.wav',1)
FileInstall ('MMNext.wav', @TempDir & '/MMNext.wav',1)
FileInstall ('ut301.wav', @TempDir & '/ut301.wav',1)
FileInstall ('ut200401.wav', @TempDir & '/ut200401.wav',1)
FileInstall ('Empty.wav', @TempDir & '/Empty.wav',1)
FileInstall ('ut2004MenuMusic.wav', @TempDir & '/ut2004MenuMusic.wav',1)
FileInstall ('autoitimage.jpg', @TempDir & '/autoitimage.jpg',1)

AutoItSetOption("WinTitleMatchMode", 2)
Opt("GUIDataSeparatorChar", @CRLF)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)
TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitFunction") ;About is the function name
TraySetState(1)

;Variables
Global $DeleteAfterCompress,$Title,$MSGERROR,$MsgTitle,$UT3MusicOnItem,$UT3MusicOFFItem,$UT2004MusicOFFItem,$UT2004MusicOnItem,$UT3IsPlaying,$UT2004IsPlaying,$UT3MusicOption,$UT3MusicFunction
$OS = @OSVersion
$UT3CompressedFilesXPCooked = (@UserProfileDir & "\My Documents\My Games\Unreal Tournament 3\UTGame\Unpublished\") ;this cvariable only good for UT3. UT2004 uses current system folder
$UT3CompressedFilesXP = (@UserProfileDir & "\My Documents\My Games\Unreal Tournament 3\UTGame\Unpublished\CookedPC\")
$UT3CompressedFilesVistaCooked = (@UserProfileDir & "\Documents\My Games\Unreal Tournament 3\UTGame\Unpublished\")
$UT3CompressedFilesVista = (@UserProfileDir & "\Documents\My Games\Unreal Tournament 3\UTGame\Unpublished\CookedPC\")
$aboutmessage = ("Unreal compressos V1.2.3 made by [ADP]-Dirty AKA Dirty_tampon AKA www.adrenalineparty.com" & @CRLF & "File is absolutely free to use/modify by anyone due to it being an open source program coded using AUTOIT programming language." & @CRLF & "Please report any issues to dirty@adrenalineparty.com and or visit my page at www.adrenalineparty.com for updates on this and many other apps." & @CRLF & "Thank you for using my app's")

$Title = @ScriptName ;get script full name including extension
$MsgTitle = StringLeft ($Title,17) ;read only first 17 characters of the filename
$MSGERROR = (@CRLF & "Error " & @ScriptName & " Line #" & @ScriptLineNumber) ;used to make mesage error shorter.

$UT3com = IniRead (@ScriptDir & "\Settings.ini", "UT3","comPath","")
$UT3Output = IniRead (@ScriptDir & "\Settings.ini", "UT3","OutputPath","")
$UT3FileList = (@ScriptDir & "\UT3FileList.txt")
$UT3ReadFileList = FileRead ($UT3FileList)
$UT2004UCC = IniRead (@ScriptDir & "\Settings.ini", "UT2004","UCCPath","")
$UT2004Output = IniRead (@ScriptDir & "\Settings.ini", "UT2004","OutputPath","")
$UT2004FileList = (@ScriptDir & "\UT2004FileList.txt")
$UT2004ReadFileList = FileRead ($UT2004FileList)

;GUI
$MainGUI = GUICreate ("Unreal Compressor.",400,420,-1,-1)
;GUI components
	#Region ;UT3
GUICtrlCreateTab (0,0,400,150)
GUICtrlCreateTabItem("Unreal Tournament 3")
GUICtrlCreateGroup ("",5,25,390,120)
GUICtrlCreateLabel ("Path to UT3.com.",10,40)
$UT3comPathEdit = GUICtrlCreateInput ($UT3com,10,60,320,20)
$UT3ComBrowser = GUICtrlCreateButton ("Browse",330,60,60,20)
GUICtrlSetTip ($UT3ComBrowser, "Press this button to browse for UT3.com file")
GUICtrlCreateLabel ("Output compressed files.",10,90)
$UT3OutputPathEdit = GUICtrlCreateInput ($UT3Output,10,110,320,20)
$UT3OutputBrowser = GUICtrlCreateButton ("Browse",330,110,60,20)
GUICtrlSetTip ($UT3OutputBrowser, "Press this button to browse for folder where to place compressed .uz3 files")
GUICtrlCreateGroup ("",5,150,390,230)
GUICtrlCreateLabel ("File's to compress   ---------->---------->---------->---------->---------->",10,163)
$UT3FileBrowser = GUICtrlCreateButton ("Browse",290,160,100,20)
GUICtrlSetTip ($UT3FileBrowser, "Press this button to browse for files you wish to compress.")
$UT3List = GUICtrlCreateEdit ($UT3ReadFileList,10,180,380,192)
$UT3Compress = GUICtrlCreateButton ("Compress",5,380,100,40)
GUICtrlSetTip ($UT3Compress, "Press this button to start.")
GUICtrlSetFont ($UT3Compress,12)
$UT3Save = GUICtrlCreateButton ("Save File list",105,390,190,20)
GUICtrlSetTip ($UT3Save, "Press this button to save curent UT3 file list.")
$UT3Clear = GUICtrlCreateButton ("Clear",295,380,100,40)
GUICtrlSetTip ($UT3Clear, "Press this button to clear Output and file list.")
GUICtrlSetFont ($UT3Clear,12)
#EndRegion

	#Region ;UT2004
GUICtrlCreateTab (100,0,400,200)
GUICtrlCreateTabItem("Unreal Tournament 2004")
GUICtrlCreateGroup ("",5,25,390,120)
GUICtrlCreateLabel ("UT2004 System folder",10,40)
$UT2004SystemPathEdit = GUICtrlCreateInput ($UT2004UCC,10,60,320,20)
$UT2004UCCBrowser = GUICtrlCreateButton ("Browse",330,60,60,20)
GUICtrlSetTip ($UT2004UCCBrowser, "Press this button to browse for UCC.exe file")
GUICtrlCreateLabel ("Output compressed files.",10,90)
$UT2004OutputPathEdit = GUICtrlCreateInput ($UT2004Output,10,110,320,20)
$UT2004OutputBrowser = GUICtrlCreateButton ("Browse",330,110,60,20)
GUICtrlSetTip ($UT2004OutputBrowser, "Press this button to browse for folder where to place compressed .uz2 files")
GUICtrlCreateGroup ("",5,150,390,230)
GUICtrlCreateLabel ("File's to compress   ---------->---------->---------->---------->---------->",10,163)
$UT2004FileBrowser = GUICtrlCreateButton ("Browse",290,160,100,20)
GUICtrlSetTip ($UT2004FileBrowser, "Press this button to browse for files you wish to compress.")
$UT2004List = GUICtrlCreateEdit ($UT2004ReadFileList,10,180,380,192)
$UT2004Compress = GUICtrlCreateButton ("Compress",5,380,100,40)
GUICtrlSetTip ($UT2004Compress, "Press this button to start.")
GUICtrlSetFont ($UT2004Compress,12)
$UT2004Save = GUICtrlCreateButton ("Save File list",105,390,190,20)
;$DeleteAfterCompress = GUICtrlCreateCheckbox ("Delete source files ?",110,390)

GUICtrlSetTip ($UT2004Save, "Press this button to save curent UT2004 file list.")
$UT2004Clear = GUICtrlCreateButton ("Clear",295,380,100,40)
GUICtrlSetTip ($UT2004Clear, "Press this button to clear Output and file list.")
GUICtrlSetFont ($UT2004Clear,12)

#EndRegion

GUICtrlCreateTabItem("About")    ; end tabitem definition
GUICtrlCreateGroup ("",5,25,390,120)
GUICtrlCreateLabel ($aboutmessage,15,35,380,100)
GUICtrlCreateGroup ("------------------------------------This program was written using-------------------------------------",10,155,380,225)
GUICtrlCreatePic (@TempDir & '/autoitimage.jpg',20,170,360,200)
GUISetState (@SW_SHOW, $MainGUI)

SoundPlay (@TempDir & '/MMGreetingsComrads.wav')
#Region ;UT3 shit goes here
While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
	Case $GUI_EVENT_CLOSE
		SoundPlay (@TempDir & '/MMSeeya.wav',1)
           Exit
;====UT3 Cases
	   Case $UT3ComBrowser
		   SoundPlay (@TempDir & '/MMSearchAndDestroy.wav',1)
		   SoundPlay (@TempDir & '/01_UT2007_MenuTheme.wav')
		   $UT3comFileopendialog = FileOpenDialog ("Localte UT3.com", "", "UT3.com (UT3.com)", 1,"",$MainGUI)
		   If @error Then
			   SoundPlay (@TempDir & '/MMSonOfABitch.wav')
			   MsgBox (64, $MsgTitle, "No file selected. Please try again.","",$MainGUI)
			   SoundPlay (@TempDir & '/MMSorry.wav')
		   Else
			   SoundPlay (@TempDir & '/MMNice.wav')
			   GUICtrlSetData ($UT3comPathEdit, $UT3comFileopendialog)
			   IniWrite (@ScriptDir & "\Settings.ini","UT3","comPath",$UT3comFileopendialog)
		   EndIf

	   Case $UT3OutputBrowser
		   SoundPlay (@TempDir & '/MMSearchAndDestroy.wav')
		   $UT3OutputFileopendialog = FileSelectFolder ("Chose output directory to result .uz3 files.",@DesktopDir,1+2+4,'',$MainGUI)
			If @error Then
				SoundPlay (@TempDir & '/MMYouSuckB.wav')
			   MsgBox (64, $MsgTitle, "No file selected: Please try again.","",$MainGUI)
			   SoundPlay (@TempDir & '/MMIHateWhenThatHappens.wav')
		   Else
			   SoundPlay (@TempDir & '/MMNice.wav')
			   GUICtrlSetData ($UT3OutputPathEdit, $UT3OutputFileopendialog)
			   IniWrite (@ScriptDir & "\Settings.ini","UT3","OutputPath",$UT3OutputFileopendialog)
		   EndIf

	   Case $UT3FileBrowser
			SoundPlay (@TempDir & '/MMSearchAndDestroy.wav')
			$UT3FilesBrowser = FileOpenDialog ("Select files", "", "UT3 files (*.upk;*.u;*.ut3)",1+4)
			If @error Then
			   SoundPlay (@TempDir & '/MMYouSuckB.wav')
			   MsgBox (64, $MsgTitle, "No files selected: Please try again.","",$MainGUI)
			   SoundPlay (@TempDir & '/MMSorry.wav')
			Else ;Add file

				If StringInStr($UT3FilesBrowser, "|") Then; Multiple files selected so transform into array
					$FindBrakeUT3 = StringInStr ($UT3FilesBrowser, "|") ;When $FindBrake reaches 1st | it counts how many strings to reach it.
					$UT3MultipleTrim = StringLeft ($UT3FilesBrowser,$FindBrakeUT3 -1) ;Using returned # of characters trim string
					FileWrite (@ScriptDir & "\UT3CompressPaths.txt",$UT3MultipleTrim & @CRLF)  ;write result
					$aFileList = StringSplit($UT3FilesBrowser, "|") ; Now add the filenames into the edit, preceded with the path and ending with @CRLF
					For $i = 2 To $aFileList[0]
						GUICtrlSetData($UT3List, '"' & $aFileList[1] &'\' & $aFileList[$i] & '"' & @crlf, "EDIT")
					Next
				Else; Only a single file selected, so add directly to the edit
					GUICtrlSetData($UT3List, '"' & $UT3FilesBrowser & '"' & @crlf, "EDIT")
					$PathOnlyUT3 = StringLeft($UT3FilesBrowser, StringInStr($UT3FilesBrowser, "\", 0, -1)-1) ;String left till 1st \
					FileWrite (@ScriptDir & "\UT3CompressPaths.txt",$PathOnlyUT3  & @CRLF)
				EndIf
				SoundPlay (@TempDir & '/MMSweet.wav')
			EndIf
			$ReadFileAgainUT3 = FileRead (@ScriptDir & "\UT3CompressPaths.txt")
		Case $UT3Compress
			$CheckUT3PathToUT3com = GUICtrlRead ($UT3comPathEdit)
		   $CheckUT3Output =  GUICtrlRead ($UT3OutputPathEdit)
		   $CheckUT3List = GUICtrlRead ($UT3List)
		If $CheckUT3PathToUT3com = "" And $CheckUT3Output > "" And $CheckUT3List > "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UT3.com path is not defined.","",$MainGUI)
		ElseIf $CheckUT3PathToUT3com > "" And $CheckUT3Output = "" And $CheckUT3List > "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UT3 Output is not defined.","",$MainGUI)
		ElseIf $CheckUT3PathToUT3com > "" And $CheckUT3Output > "" And $CheckUT3List = "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: No files selected. Select files first and try again.","",$MainGUI)
		ElseIf $CheckUT3PathToUT3com = "" And $CheckUT3Output = "" And $CheckUT3List > "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UT3.com path and output are not defined.","",$MainGUI)
		ElseIf $CheckUT3PathToUT3com > "" And $CheckUT3Output = "" And $CheckUT3List = "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UT3 output is not defined and no files selected.","",$MainGUI)
		ElseIf $CheckUT3PathToUT3com = "" And $CheckUT3Output > "" And $CheckUT3List = "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UT3.com path is not defined and no files selected.","",$MainGUI)
		ElseIf $CheckUT3PathToUT3com = "" And $CheckUT3Output = "" And $CheckUT3List = "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UT3.com path and output are not defined. No files selected.","",$MainGUI)
		ElseIf $CheckUT3PathToUT3com > "" And $CheckUT3Output > "" And $CheckUT3List > "" Then
			CompressUT3Function()
		EndIf
		Case $UT3Save
			SoundPlay (@TempDir & '/MMINeedSomeBackup.wav')
			$readListUT3 = GUICtrlRead ($UT3List)
			If $readListUT3 > "" Then
				$OpenFileList = FileOpen ($UT3FileList,2+8)
				FileClose ($OpenFileList)
				$WriteUT3FileList = FileWrite ($UT3FileList, $readListUT3)
				MsgBox (64,@ScriptName,"Saved to: " & @ScriptDir & "\UT3FileList.txt","",$MainGUI)
				FileDelete(@TempDir & "\UT3CompressPaths.txt")
				FileDelete(@ScriptDir & "\UT3CompressPaths.txt")
				FileWrite (@TempDir & "\UT3CompressPaths.txt",$readListUT3)
				$LinetoreadUT3 = '1'
				While 1 ;Modify path files and remove file names and quotes
					$ReadPathFileUT3 = FileReadLine (@TempDir & "\UT3CompressPaths.txt",$LinetoreadUT3)
					If $ReadPathFileUT3 = "" Then
						ExitLoop
					ElseIf $ReadPathFileUT3 > "" Then
						$RemoveQuoteUT3 = StringReplace ($ReadPathFileUT3,'"',"")
						$FindUT3 = StringLeft ($RemoveQuoteUT3,StringInStr ($RemoveQuoteUT3,'\',0,-1)-1) ;move to left as much as stringinstr ount says when it fnds \ symbol. and add 1 more to remove last \
						FileWrite (@ScriptDir & "\UT3CompressPaths.txt",$FindUT3 & @CRLF)
						Assign ("LinetoreadUT3",Number ($LinetoreadUT3 + 1))
					EndIf
				WEnd
			Else
				SoundPlay (@TempDir & '/MMSorry.wav')
			EndIf
		Case $UT3Clear
		   SoundPlay (@TempDir & '/MMGotIt.wav')
		   GUICtrlSetData ($UT3OutputPathEdit,"")
		   GUICtrlSetData ($UT3List,"")
		   $UT3OpenToClear = FileOpen ($UT3FileList,2+8)
		   FileClose ($UT3OpenToClear)
		   MsgBox (64,@ScriptName,"Cleared")
;===UT2004 Cases===
		Case $UT2004UCCBrowser
		   SoundPlay (@TempDir & '/MMSearchAndDestroy.wav',1)
		   SoundPlay (@TempDir & '/ut2004MenuMusic.wav')
		   $UT2004SystemFolderOpendialog = FileSelectFolder ("Select UT2004 System folder","",'','',$MainGUI)
		   If @error Then
			   SoundPlay (@TempDir & '/MMSonOfABitch.wav')
			   MsgBox (64, $MsgTitle, "No file selected. Please try again.","",$MainGUI)
			   SoundPlay (@TempDir & '/MMSorry.wav')
		   Else
			   SoundPlay (@TempDir & '/MMNice.wav')
			   GUICtrlSetData ($UT2004SystemPathEdit, $UT2004SystemFolderOpendialog & "\UCC.exe")
			   IniWrite (@ScriptDir & "\Settings.ini","UT2004","UCCPath",GUICtrlRead ($UT2004SystemPathEdit))
		   EndIf

	   Case $UT2004OutputBrowser
		   SoundPlay (@TempDir & '/MMSearchAndDestroy.wav')
		   $UT2004OutputFileopendialog = FileSelectFolder ("Chose output directory to result .uz2 files.",@DesktopDir,1+2+4,'',$MainGUI)
			If @error Then
				SoundPlay (@TempDir & '/MMYouSuckB.wav')
			   MsgBox (64, $MsgTitle, "No file selected: Please try again.","",$MainGUI)
			   SoundPlay (@TempDir & '/MMIHateWhenThatHappens.wav')
		   Else
			   SoundPlay (@TempDir & '/MMNice.wav')
			   GUICtrlSetData ($UT2004OutputPathEdit, $UT2004OutputFileopendialog)
			   IniWrite (@ScriptDir & "\Settings.ini","UT2004","OutputPath",$UT2004OutputFileopendialog)
		   EndIf

	   Case $UT2004FileBrowser
		   SoundPlay (@TempDir & '/MMSearchAndDestroy.wav')
		   $UT2004FilesBrowser = FileOpenDialog ("Select files", "", "UT2004 files (*.ukx;*.u;*.utx;*.usx;*.uax;*.upl;*.ut2;*.ucl)",1+4)
		   If @error Then
			   SoundPlay (@TempDir & '/MMYouSuckB.wav')
			   MsgBox (64, $MsgTitle, "No files selected: Please try again.","",$MainGUI)
			   SoundPlay (@TempDir & '/MMSorry.wav')
		   Else
				If StringInStr ($UT2004FilesBrowser, "|") Then; Multiple files selected so transform into array
					$FindBrake = StringInStr ($UT2004FilesBrowser, "|") ;When $FindBrake reaches 1st | it counts how many strings to reach it.
					$UT2004MultipleTrim = StringLeft ($UT2004FilesBrowser,$FindBrake -1) ;Using returned # of characters trim string
					FileWrite (@ScriptDir & "\UT2004CompressPaths.txt",$UT2004MultipleTrim & @CRLF)  ;write result
					$aUT2004FileList = StringSplit($UT2004FilesBrowser, "|") ; Now add the filenames into the edit, preceded with the path and ending with @CRLF
				For $i = 2 To $aUT2004FileList[0]
					GUICtrlSetData($UT2004List, '"' & $aUT2004FileList[1] &'\' & $aUT2004FileList[$i] & '"' & @crlf, "EDIT")
				Next
				Else; Only a single file selected, so add directly to the edit
					GUICtrlSetData($UT2004List, '"' & $UT2004FilesBrowser & '"' & @CRLF,"edit")
					$PathOnly = StringLeft($UT2004FilesBrowser, StringInStr($UT2004FilesBrowser, "\", 0, -1)-1) ;String left till 1st \
					FileWrite (@ScriptDir & "\UT2004CompressPaths.txt",$PathOnly  & @CRLF)
				EndIf
				SoundPlay (@TempDir & '/MMSweet.wav')
			EndIf
			$ReadFileAgain = FileRead (@ScriptDir & "\UT2004CompressPaths.txt")
	   Case $UT2004Compress
		   $CheckUT2004PathToUT2004UCC = GUICtrlRead ($UT2004SystemPathEdit)
		   $CheckUT2004Output =  GUICtrlRead ($UT2004OutputPathEdit)
		   $CheckUT2004List = GUICtrlRead ($UT2004List)
		If $CheckUT2004PathToUT2004UCC = "" And $CheckUT2004Output > "" And $CheckUT2004List > "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UCC.exe path is not defined.","",$MainGUI)
		ElseIf $CheckUT2004PathToUT2004UCC > "" And $CheckUT2004Output = "" And $CheckUT2004List > "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UT2004 Output is not defined.","",$MainGUI)
		ElseIf $CheckUT2004PathToUT2004UCC > "" And $CheckUT2004Output > "" And $CheckUT2004List = "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: No files selected. Select files first and try again.","",$MainGUI)
		ElseIf $CheckUT2004PathToUT2004UCC = "" And $CheckUT2004Output = "" And $CheckUT2004List > "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UCC.exe path and output are not defined.","",$MainGUI)
		ElseIf $CheckUT2004PathToUT2004UCC > "" And $CheckUT2004Output = "" And $CheckUT2004List = "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UT2004 output is not defined and no files selected.","",$MainGUI)
		ElseIf $CheckUT2004PathToUT2004UCC = "" And $CheckUT2004Output > "" And $CheckUT2004List = "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UCC.exe path is not defined and no files selected.","",$MainGUI)
		ElseIf $CheckUT2004PathToUT2004UCC = "" And $CheckUT2004Output = "" And $CheckUT2004List = "" Then
			SoundPlay (@TempDir & '/MMYouSuckB.wav')
			MsgBox (16,@ScriptName, "Error: UCC.exe path and output are not defined. No files selected.","",$MainGUI)
		ElseIf $CheckUT2004PathToUT2004UCC > "" And $CheckUT2004Output > "" And $CheckUT2004List > "" Then
		CompressUT2004Function()
	EndIf
	   Case $UT2004Save
			SoundPlay (@TempDir & '/MMINeedSomeBackup.wav')
			$readList = GUICtrlRead ($UT2004List)
			If $readList > "" Then
				$OpenFileList = FileOpen ($UT2004FileList,2+8)
				FileClose ($OpenFileList)
				$WriteUT2004FileList = FileWrite ($UT2004FileList, $readList)
				MsgBox (64,@ScriptName,"Saved to: " & @ScriptDir & "\UT2004FileList.txt","",$MainGUI)
				FileDelete(@TempDir & "\UT2004CompressPaths.txt")
				FileDelete(@ScriptDir & "\UT2004CompressPaths.txt")
				FileWrite (@TempDir & "\UT2004CompressPaths.txt",$readList)
				$Linetoread = '1'
				While 1 ;Modify path files and remove file names and quotes
					$ReadPathFile = FileReadLine (@TempDir & "\UT2004CompressPaths.txt",$Linetoread)
					If $ReadPathFile = "" Then
						ExitLoop
					ElseIf $ReadPathFile > "" Then
						$RemoveQuote = StringReplace ($ReadPathFile,'"',"")
						$Find = StringLeft ($RemoveQuote,StringInStr ($RemoveQuote,'\',0,-1)-1) ;move to left as much as stringinstr ount says when it fnds \ symbol. and add 1 more to remove last \
						FileWrite (@ScriptDir & "\UT2004CompressPaths.txt",$Find & @CRLF)
						Assign ("Linetoread",Number ($Linetoread + 1))
					EndIf
				WEnd
			Else
				SoundPlay (@TempDir & '/MMSorry.wav')
			EndIf
	Case $UT2004Clear
		SoundPlay (@TempDir & '/MMGotIt.wav')
		GUICtrlSetData ($UT2004OutputPathEdit,"")
		GUICtrlSetData ($UT2004List,"")
		$UT2004OpenToClear = FileOpen ($UT2004FileList,2+8)
		FileClose ($UT2004OpenToClear)
		FileDelete (@ScriptDir & "\UT2004CompressPaths.txt") ;Erase path list
		FileDelete (@ScriptDir & "\UT2004FileList.txt") ;Erase path list
		MsgBox (64,@ScriptName,"Cleared")
EndSwitch
WEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func StopUT3MusicFunction()
	SoundPlay (@TempDir & '/Empty.wav',1)
	Assign ("UT3IsPlaying", "Yes")
EndFunc

Func StartUT3MusicFunction()
	SoundPlay (@TempDir & '/ut301.wav')
	Assign ("UT3IsPlaying", "Yes")
EndFunc
	#EndRegion

#Region ;UT2004 shit goes here
Func StopUT2004MusicFunction()
	SoundPlay (@TempDir & '/Empty.wav',1)
	Assign ("UT2004IsPlaying", "Yes")
EndFunc

Func StartUT2004MusicFunction()
	SoundPlay (@TempDir & '/ut200401.wav')
	Assign ("UT2004IsPlaying", "Yes")
EndFunc
	#EndRegion


Func Exitfunction()
	Exit
EndFunc
