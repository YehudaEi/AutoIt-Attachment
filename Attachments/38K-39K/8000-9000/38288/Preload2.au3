#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GuiEdit.au3>
#include <GuiComboBox.au3>
#include <Constants.au3>
#include <file.au3>

;=====================================START CREATING GUI==============================================================
Run("cmdow.exe " & "0x0015027E /hid")
$GUI = GUICreate("Levix - Server Preload - V1.3", 615, 406, -1, -1)

$START = GUICtrlCreateButton("START", 264, 360, 75, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$GO = 1 ; -----------------------------------------------------------------------Waarde voor de fout afvanging

$CREDITS = GUICtrlCreateLabel("MW", 584, 384, 26, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   GUICtrlSetState($CREDITS, $GUI_DISABLE)

$OSTITLE = GUICtrlCreateLabel("Besturingssysteem:", 48, 16, 112, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   $OSLIST = GUICtrlCreateCombo("", 48, 40, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL)) ; $CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	  $X86 = GUICtrlSetData($OSLIST, "Windows Server 2008 Standard 32Bit", "") ; ----Waarde van het OS pulldown menu
		$X86INSTALL = "X86\Image\W2K8_X86.WIM" ; ------------------------------------Waarde voor het install.cmd script
		$X86ARCH = "32Bit" ; --------------------------------------------------------Waarde voor het install.cmd script
	  $X64 = GUICtrlSetData($OSLIST, "Windows Server 2008 Standard 64Bit", "") ; ----Waarde van het OS pulldown menu
		$X64INSTALL = "X64\Image\W2K8_X64.WIM" ; ------------------------------------Waarde voor het install.cmd script
		$X64ARCH = "64Bit" ; --------------------------------------------------------Waarde voor het install.cmd script

$MODELTITLE = GUICtrlCreateLabel("Server Model:", 312, 16, 83, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   $MODELLIST = GUICtrlCreateCombo("", 312, 40, 153, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL)) ; $CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	  $ML150G6 = GUICtrlSetData($MODELLIST, "ML150   G6", "") ; ---------------------Waarde van het Server Model pulldown menu
	  $SCHEIDING = GUICtrlSetData($MODELLIST, "---------------------------------------------------", "") ; ----------------------Waarde van het Server Model pulldown menu
	  $ML350G5 = GUICtrlSetData($MODELLIST, "ML350   G5", "") ; ---------------------Waarde van het Server Model pulldown menu
	  $ML350G6 = GUICtrlSetData($MODELLIST, "ML350   G6", "") ; ---------------------Waarde van het Server Model pulldown menu
	  $SCHEIDING2 = GUICtrlSetData($MODELLIST, "----------------------------------------------------", "") ; ----------------------Waarde van het Server Model pulldown menu
	  $VIRTUAL = GUICtrlSetData($MODELLIST, "Virtual Server", "") ; ---------------------Waarde van het Server Model pulldown menu
	  $ML150G6COPYX86 = "X86\ML150G6\" ;---------------------------------------------Waarde voor het kopieren van drivers & software
	  $ML150G6COPYX64 = "X64\ML150G6\" ;---------------------------------------------Waarde voor het kopieren van drivers & software
	  $ML350G5COPYX86 = "X86\ML350G5\" ;---------------------------------------------Waarde voor het kopieren van drivers & software
	  $ML350G5COPYX64 = "X64\ML350G5\" ;---------------------------------------------Waarde voor het kopieren van drivers & software
	  $ML350G6COPYX86 = "X86\ML350G6\" ;---------------------------------------------Waarde voor het kopieren van drivers & software
	  $ML350G6COPYX64 = "X64\ML350G6\" ;---------------------------------------------Waarde voor het kopieren van drivers & software
	  
$PARTITIONTITLE = GUICtrlCreateLabel("Partitie Indeling:", 48, 72, 97, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   $PARTITIONLIST = GUICtrlCreateCombo("", 48, 96, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL)) ; $CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	  $WIPE = GUICtrlSetData($PARTITIONLIST, "Wipe" &  "     l  één partitie", "") ;-Waarde van het Partitie Indeling pulldown menu
	  $CUSTOM = GUICtrlSetData($PARTITIONLIST, "Custom" &  "  l  Aangepaste partitie", "") ;Waarde van het Partitie Indeling pulldown menu
   $PARTITION = 1 ;------------------------------------------------------------------Waarde voor het afvangen van het activeren: Pulldown menu Partitie Groote

$PARTITIONSIZETITLE = GUICtrlCreateLabel("Partitie Groote:", 48, 128, 90, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   $PARTITIONSIZELIST = GUICtrlCreateCombo("", 48, 152, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL)) ; $CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	  $HDDSIZE = GUICtrlSetData($PARTITIONSIZELIST, "40 GB|60 GB|80 GB|100 GB|120 GB|160 GB|200 GB|250 GB|300 GB|350 GB|400 GB|450 GB|500 GB", "") ;Waarde van het Partitie Groote pulldown menu
  GUICtrlSetState( $PARTITIONSIZELIST, $GUI_DISABLE)
   

$HOSTNAMETITLE = GUICtrlCreateLabel("Computernaam:", 48, 184, 91, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   $HOSTNAMEINPUT = GUICtrlCreateInput("", 48, 208, 153, 21)
	 ; GUICtrlSetState($HOSTNAMEINPUT, $GUI_DISABLE)
	  
$PASSWORDTITLE = GUICtrlCreateLabel("Administrator Wachtwoord:", 48, 240, 156, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   $PASSWORDINPUT = GUICtrlCreateInput("", 48, 264, 153, 21)
	 ; GUICtrlSetState($PASSWORDINPUT, $GUI_DISABLE)

$LICENSETITLE = GUICtrlCreateLabel("Licentie Sleutel:", 48, 296, 96, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   $LICENSEINPUT = GUICtrlCreateInput("", 48, 320, 153, 21)
	 ; GUICtrlSetState($LICENSEINPUT, $GUI_DISABLE)
   
$LOGGER = GUICtrlCreateLabel("Logboek:", 312, 96, 57, 17)   
   $LOGBOX = GUICtrlCreateEdit("", 312, 120, 290, 217, $ES_READONLY + $ES_AUTOVSCROLL + $ES_MULTILINE) ;$ES_READONLY + $ES_AUTOSCROLL + $ES_MULTILINE is voor het logboek read only en auto scroll te maken
	  GUICtrlSetData(-1, "")

HotKeySet("{ESC}",	"Terminate") ;---------------------------------------------------HotKey voor het afsluiten van het script

GUISetState(@SW_SHOW)

;=====================================END CREATING GUI================================================================
;=====================================START IDLE LOOP=================================================================

While 1
	$Msg = GUIGetMsg()
	Select
		 Case $msg = $START
			START()
		 Case $msg = $GUI_EVENT_CLOSE
			Exit

	EndSelect
	
		 If GUICtrlRead($PARTITIONLIST) = "Custom" &  "  l  Aangepaste partitie" And $PARTITION = 1 Then
				  GUICtrlSetState($PARTITIONSIZELIST, $GUI_ENABLE)
				  $PARTITION = 0
		 ElseIf GUICtrlRead($PARTITIONLIST) <> "Custom" &  "  l  Aangepaste partitie" And $PARTITION = 0 Then
				  GUICtrlSetState($PARTITIONSIZELIST, $GUI_DISABLE)
				  $PARTITION = 1
		 EndIf

WEnd

;=====================================END IDLE LOOP===================================================================
;=====================================START FUNCTION==================================================================
Func START()

;=====================================START ERROR CATCHING============================================================

		$READOS = GUICtrlRead($OSLIST)
		$READMODEL = GUICtrlRead($MODELLIST)
		$READPARTITION = GUICtrlRead($PARTITIONLIST)
		$READSIZE = GUICtrlRead($PARTITIONSIZELIST)
		$READHOSTNAME = GUICtrlRead($HOSTNAMEINPUT)
		$READPASSWORD = GUICtrlRead($PASSWORDINPUT)
		$READLICENSE = GUICtrlRead($LICENSEINPUT)
		 
			If $READOS = "" Then 
				MsgBox(4096, "Let op!", "Kies een besturingssysteem") 
				EndIf
			If $READOS = "" Then
				$GO = 0	
				EndIf
			If $READMODEL = "" Then 
				MsgBox(4096, "Let op!", "Kies een Server Model") 
				EndIf
			If $READMODEL = "---------------------------------------------------" Then
				MsgBox(4096, "Let op!", "Kies een Server Model") 
				EndIf
			If $READMODEL = "---------------------------------------------------" Then
				$GO = 0	
				EndIf
			If $READMODEL = "" Then
				$GO = 0	
				EndIf
			If $READPARTITION = "" Then 
				MsgBox(4096, "Let op!", "Kies een Partitie Indeling") 
				EndIf
			If $READPARTITION = "" Then
				$GO = 0	
				EndIf
			If $READPARTITION = "Custom" &  "  l  Aangepaste partitie" And $READSIZE = "" Then 
				MsgBox(4096, "Let op!", "Kies een Partitie Groote") 
				EndIf
			If $READPARTITION = "Custom" &  "  l  Aangepaste partitie" And $READSIZE = "" Then 
				$GO = 0	
				EndIf

;=====================================END ERROR CATCHING==============================================================

			If $GO = 1 Then 
				GUICtrlSetState( $OSLIST, $GUI_DISABLE) 
			EndIf
			If $GO = 1 Then 
				GUICtrlSetState( $MODELLIST, $GUI_DISABLE) 
				EndIf
			If $GO = 1 Then 
				GUICtrlSetState( $PARTITIONLIST, $GUI_DISABLE) 
				EndIf
			If $GO = 1 Then 
				GUICtrlSetState( $PARTITIONSIZELIST, $GUI_DISABLE)
				EndIf
			If $GO = 1 Then 
				GUICtrlSetState( $HOSTNAMEINPUT, $GUI_DISABLE) 
				EndIf
			If $GO = 1 Then 
				GUICtrlSetState( $PASSWORDINPUT, $GUI_DISABLE) 
				EndIf
			If $GO = 1 Then 
				GUICtrlSetState( $LICENSEINPUT, $GUI_DISABLE)
				EndIf
			If $GO = 1 Then 
				GUICtrlSetState( $PASSWORDINPUT, $GUI_DISABLE) 
				EndIf
			If $GO = 1 Then 
				GUICtrlSetState( $LICENSEINPUT, $GUI_DISABLE) 
				EndIf
			If $GO = 1 Then 
				GUICtrlSetState( $START, $GUI_DISABLE)
				  GUICtrlSetData($START, "Bezig ... !")
				EndIf

;=====================================START WRITING TO LOGBOEK========================================================

			If $GO = 1 Then
				Logb("Gekozen opties:")
				Logb("")
			EndIf
			
			If $GO = 1	And $READOS = "Windows Server 2008 Standard 32Bit" Then
				Logb("Besturingssysteem:  " & $READOS)
			EndIf
			If $GO = 1 And $READOS = "Windows Server 2008 Standard 64Bit" Then
				Logb("Besturingssysteem:  " & $READOS)
			EndIf
			If $GO = 1 And $READMODEL = "ML150   G6" Then
				Logb("Server Model:          " & $READMODEL)
			EndIf
			If $GO = 1 And $READMODEL = "ML350   G5" Then
				Logb("Server Model:          " & $READMODEL)
			EndIf
			If $GO = 1 And $READMODEL = "ML350   G6" Then
				Logb("Server Model:          " & $READMODEL)
			EndIf
			If $GO = 1 And $READMODEL = "Virtual Server" Then
				Logb("Server Model:          " & $READMODEL)
			EndIf
			If $GO = 1 And $READPARTITION = "Wipe" &  "     l  één partitie" Then
				Logb("Partitie Indeling:       " & $READPARTITION)
			EndIf
			If $GO = 1 And $READPARTITION = "Custom" &  "  l  Aangepaste partitie" Then
				Logb("Partitie Indeling:       " & $READPARTITION)
					 Logb("Partitie Groote:        " & $READSIZE)
				 EndIf
				 
			Logb("")
			
			If $GO = 1 And $READHOSTNAME <> "" Then
				Logb("Computernaam:        " & $READHOSTNAME)
			EndIf
			If $GO = 1 And $READPASSWORD <> "" Then
				Logb("Wachtwoord:             " & $READPASSWORD)
			EndIf
			If $GO = 1 And $READLICENSE <> "" Then
				Logb("Licentie:                       " & $READLICENSE)
			EndIf

;=====================================END WRITING TO LOGBOEK FUNCTION=================================================

;=====================================START DISKPART==================================================================
;=====================================START 32BIT=====================================================================
If $READOS = "Windows Server 2008 Standard 32Bit" Then
   
   If $GO = 1 And $READPARTITION = "Custom" &  "  l  Aangepaste partitie" Then
	  $var	= 	GUICtrlRead($READSIZE)
	  $PARTSIZE =	StringTrimRight($READSIZE, 3)
   EndIf
   
	$DP	 = "diskpartx86.txt" ;-------------------------------------------------------Maken van het tekst bestand voor de diskpart
	  If FileExists($DP) Then 
		 FileDelete($DP)
	  EndIf
   $var = FileOpen($DP, 1)		
			If $GO = 1 And $READPARTITION = "Wipe" &  "     l  één partitie" Then
				FileWrite($var, "SELECT DISK 0" & @CRLF)
				FileWrite($var, "CLEAN" & @CRLF)
				FileWrite($var, "CREATE PARTITION PRIMARY" & @CRLF)
				FileWrite($var, "ACTIVE" & @CRLF)
				FileWrite($var, "SELECT PARTITION 1" & @CRLF)
				FileWrite($var, "FORMAT FS=NTFS LABEL=OS QUICK" & @CRLF)
				FileWrite($var, "ASSIGN LETTER=L" & @CRLF)
				FileWrite($var, "EXIT" & @CRLF)
			 EndIf
			 
			If $GO = 1 And $READPARTITION = "Custom" &  "  l  Aangepaste partitie" Then
				FileWrite($var, "SELECT DISK 0" & @CRLF)
				FileWrite($var, "CLEAN" & @CRLF)
				FileWrite($var, "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000" & @CRLF)
				FileWrite($var, "ACTIVE" & @CRLF)
				FileWrite($var, "SELECT PARTITION 1" & @CRLF)
				FileWrite($var, "FORMAT FS=NTFS LABEL=OS QUICK" & @CRLF)
				FileWrite($var, "ASSIGN LETTER=L" & @CRLF)
				FileWrite($var, "CREATE PARTITION PRIMARY" & @CRLF)
				FileWrite($var, "SELECT PARTITION 2" & @CRLF)
				FileWrite($var, "FORMAT FS=NTFS LABEL=DATA QUICK" & @CRLF)
				FileWrite($var, "ASSIGN LETTER=M" & @CRLF)
				FileWrite($var, "EXIT" & @CRLF)
			EndIf
	  FileClose($var)
	  
$var = RunWait("diskpart.exe /s " & $DP)

		 If FileExists($DP) Then 
			FileDelete($DP)
		 EndIf
EndIf
;=====================================END 32BIT=======================================================================
;=====================================START 64BIT=====================================================================


If $READOS = "Windows Server 2008 Standard 64Bit" Then

   If $GO = 1 And $READPARTITION = "Custom" &  "  l  Aangepaste partitie" Then
	  $var	= 	GUICtrlRead($READSIZE)
	  $PARTSIZE =	StringTrimRight($READSIZE, 3)
   EndIf

	$DP = "diskpartx64.txt" ;--------------------------------------------------------Maken van het tekst bestand voor de diskpart
		If 	FileExists($DP) Then 
			FileDelete($DP)
		EndIf
	$var = FileOpen($DP, 1)		
			If $GO = 1 And $READPARTITION = "Wipe" &  "     l  één partitie" Then
			   FileWrite($var, "SELECT DISK 0" & @CRLF)
				FileWrite($var, "CLEAN" & @CRLF)
				FileWrite($var, "CREATE PARTITION PRIMARY SIZE=100" & @CRLF)
				FileWrite($var, "SELECT PARTITION 1" & @CRLF)
				FileWrite($var, "ACTIVE" & @CRLF)
				FileWrite($var, "FORMAT FS=NTFS LABEL=System quick" & @CRLF)
				FileWrite($var, "CREATE PARTITION PRIMARY" & @CRLF)
				FileWrite($var, "SELECT PARTITION 2" & @CRLF)
				FileWrite($var, "FORMAT FS=NTFS LABEL=OS QUICK" & @CRLF)
				FileWrite($var, "ASSIGN LETTER=L" & @CRLF)
				FileWrite($var, "EXIT" & @CRLF)
			 EndIf
			 
			If $GO = 1 And $READPARTITION = "Custom" &  "  l  Aangepaste partitie" Then
				FileWrite($var, "SELECT DISK 0" & @CRLF)
				FileWrite($var, "CLEAN" & @CRLF)
				FileWrite($var, "CREATE PARTITION PRIMARY SIZE=100" & @CRLF)
				FileWrite($var, "SELECT PARTITION 1" & @CRLF)
				FileWrite($var, "ACTIVE" & @CRLF)
				FileWrite($var, "FORMAT FS=NTFS LABEL=System quick" & @CRLF)
				FileWrite($var, "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000" & @CRLF)
				FileWrite($var, "SELECT PARTITION 2" & @CRLF)
				FileWrite($var, "FORMAT FS=NTFS LABEL=OS QUICK" & @CRLF)
				FileWrite($var, "ASSIGN LETTER=L" & @CRLF)
				FileWrite($var, "CREATE PARTITION PRIMARY" & @CRLF)
				FileWrite($var, "SELECT PARTITION 3" & @CRLF)
				FileWrite($var, "FORMAT FS=NTFS LABEL=DATA QUICK" & @CRLF)
				FileWrite($var, "ASSIGN LETTER=M" & @CRLF)
				FileWrite($var, "EXIT" & @CRLF)
			EndIf
	  FileClose($var)
	  
$var = RunWait("diskpart.exe /s " & $DP)


		 If FileExists($DP) Then 
			FileDelete($DP)
		 EndIf		 
EndIf	 
;=====================================END 64BIT=======================================================================
;=====================================END DISKPART====================================================================

;=====================================START INSTALLING IMAGE==========================================================

			If $GO = 1 And $READOS = "Windows Server 2008 Standard 32Bit" Then
				RunWait("installx86.cmd " & $X86INSTALL & " " & $X86ARCH)
			EndIf
			If $GO = 1 And $READOS = "Windows Server 2008 Standard 64Bit" Then
				RunWait("installx64.cmd " & $X64INSTALL & " " & $X64ARCH)
			EndIf
			
;=====================================END INSTALLING IMAGE============================================================
;=====================================START COPYING DRIVERS & SOFTWARE================================================
If $GO = 1 Then
			Logb("")
			Logb("Drivers & Software kopiëren")
			If $READMODEL = "ML150   G6" Then
				Logb("Server Model:          " & $READMODEL)
			EndIf
			If $READMODEL = "ML350   G5" Then
				Logb("Server Model:          " & $READMODEL)
			EndIf
			If $READMODEL = "ML350   G6" Then
				Logb("Server Model:          " & $READMODEL)
			 EndIf

;=====================================START 32BIT=====================================================================
   
   If $READPARTITION = "Wipe" &  "     l  één partitie" Then		 
		 If Not FileExists("L:\Beheer") Then 
			DirCreate("L:\Beheer")
			DirCreate("L:\Beheer\Install-DVD")
		 EndIf
		 $DEST = "L:\Beheer\" ;------------------------------------------------------Waarde voor het kopieren van drivers & software
		 
		 If $READOS = "Windows Server 2008 Standard 32Bit" And $READMODEL = "ML150   G6" Then
			RunWait("Copy-Drivers.cmd " & $ML150G6COPYX86 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X86\Install-DVD\" & " " & "L:\Beheer\Install-DVD\")
		 EndIf
		 
		 If $READOS = "Windows Server 2008 Standard 32Bit" And $READMODEL = "ML350   G5" Then
			RunWait("Copy-Drivers.cmd " & $ML350G5COPYX86 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X86\Install-DVD\" & " " & "L:\Beheer\Install-DVD\")
		 EndIf

		 If $READOS = "Windows Server 2008 Standard 32Bit" And $READMODEL = "ML350   G6" Then
			RunWait("Copy-Drivers.cmd " & $ML350G6COPYX86 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X86\Install-DVD\" & " " & "L:\Beheer\Install-DVD\")
		 EndIf
	   EndIf
	   
      If $READPARTITION = "Custom" &  "  l  Aangepaste partitie" Then		 
		 If Not FileExists("M:\Beheer") Then 
			DirCreate("M:\Beheer")
			DirCreate("M:\Beheer\Install-DVD")
		 EndIf
		 $DEST = "M:\Beheer\" ;------------------------------------------------------Waarde voor het kopieren van drivers & software
		 
		 If $READOS = "Windows Server 2008 Standard 32Bit" And $READMODEL = "ML150   G6" Then
			RunWait("Copy-Drivers.cmd " & $ML150G6COPYX86 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X86\Install-DVD\" & " " & "M:\Beheer\Install-DVD\")
		 EndIf
		 
		 If $READOS = "Windows Server 2008 Standard 32Bit" And $READMODEL = "ML350   G5" Then
			RunWait("Copy-Drivers.cmd " & $ML350G5COPYX86 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X86\Install-DVD\" & " " & "M:\Beheer\Install-DVD\")
		 EndIf

		 If $READOS = "Windows Server 2008 Standard 32Bit" And $READMODEL = "ML350   G6" Then
			RunWait("Copy-Drivers.cmd " & $ML350G6COPYX86 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X86\Install-DVD\" & " " & "M:\Beheer\Install-DVD\")
		 EndIf
	  EndIf
;=====================================END 32BIT=======================================================================
;=====================================START 64BIT=====================================================================
   If $READPARTITION = "Wipe" &  "     l  één partitie" Then		 
		 If Not FileExists("L:\Beheer") Then 
			DirCreate("L:\Beheer")
			DirCreate("L:\Beheer\Install-DVD")
		 EndIf
		 $DEST = "L:\Beheer\" ;------------------------------------------------------Waarde voor het kopieren van drivers & software
		 
		 If $READOS = "Windows Server 2008 Standard 64Bit" And $READMODEL = "ML150   G6" Then
			RunWait("Copy-Drivers.cmd " & $ML150G6COPYX64 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X86\Install-DVD\" & " " & "L:\Beheer\Install-DVD\")
		 EndIf
		 
		 If $READOS = "Windows Server 2008 Standard 64Bit" And $READMODEL = "ML350   G5" Then
			RunWait("Copy-Drivers.cmd " & $ML350G5COPYX64 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X64\Install-DVD\" & " " & "L:\Beheer\Install-DVD\")
		 EndIf
		 
		 If $READOS = "Windows Server 2008 Standard 64Bit" And $READMODEL = "ML350   G6" Then
			RunWait("Copy-Drivers.cmd " & $ML350G6COPYX64 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X64\Install-DVD\" & " " & "L:\Beheer\Install-DVD\")
		 EndIf
   EndIf
   If $READPARTITION = "Custom" &  "  l  Aangepaste partitie" Then		 
		 If Not FileExists("M:\Beheer") Then 
			DirCreate("M:\Beheer")
			DirCreate("M:\Beheer\Install-DVD")
		 EndIf
		 $DEST = "M:\Beheer\" ;------------------------------------------------------Waarde voor het kopieren van drivers & software
		 
		 If $READOS = "Windows Server 2008 Standard 64Bit" And $READMODEL = "ML150   G6" Then
			RunWait("Copy-Drivers.cmd " & $ML150G6COPYX64 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X64\Install-DVD\" & " " & "M:\Beheer\Install-DVD\")
		 EndIf
		 
		 If $READOS = "Windows Server 2008 Standard 64Bit" And $READMODEL = "ML350   G5" Then
			RunWait("Copy-Drivers.cmd " & $ML350G5COPYX64 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X64\Install-DVD\" & " " & "M:\Beheer\Install-DVD\")
		 EndIf	
			
		 If $READOS = "Windows Server 2008 Standard 64Bit" And $READMODEL = "ML350   G6" Then
			RunWait("Copy-Drivers.cmd " & $ML350G6COPYX64 & " " & $DEST)
			FileCopy("Install Drivers.cmd", "L:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\")
			RunWait("Copy-DVD.cmd " & "X64\Install-DVD\" & " " & "M:\Beheer\Install-DVD\")
		 EndIf	
   EndIf
;=====================================END 64BIT=======================================================================
EndIf
;=====================================END COPYING DRIVERS & SOFTWARE==================================================
;=====================================START WRITING AUTOX86===========================================================
Logb("Kopieren unattend.xml")
If $READOS = "Windows Server 2008 Standard 32Bit" Then
	  IF FileExists("XML\X86\unattend.xml") then	
		 FileDelete("XML\X86\unattend.xml")
	  EndIf
Sleep(1000)
	  If Not FileExists("XML\X86\unattend.xml") Then
		 FileCopy("XML\XML-ORIGINAL\X86\unattend.xml", "XML\X86\unattend.xml")
	  EndIf
   $HOSTREAD = GUICtrlRead($HOSTNAMEINPUT)
   $PASSREAD = GUICtrlRead($PASSWORDINPUT)
   $LICREAD = GUICtrlRead($LICENSEINPUT)
   
   	$XML	= "XML\X86\unattend.xml"
	$HOST	= "<Name></Name>"
	$PASS	= "<Password></Password>"
	$LIC	= "<Key></Key>"
	
   $var = FileOpen($XML, 1)
	  _ReplaceStringInFile("XML\X86\unattend.xml", $HOST , "<Name>" & $HOSTREAD & "</Name>")
	  _ReplaceStringInFile("XML\X86\unattend.xml", $PASS , "<Password>" & $PASSREAD & "</Password>")
	  _ReplaceStringInFile("XML\X86\unattend.xml", $LIC , "<Key>" & $LICREAD & "</Key>")
   FileClose($var)
Sleep(1000)
   FileCopy("XML\X86\unattend.xml", "L:\Windows\Panther\unattend.xml", 1)
   FileCopy("XML\X86\unattend.xml", "L:\Windows\System32\Sysprep\unattend.xml", 1)
   FileCopy("XML\X86\unattend.xml", "L:\Windows\System32\Sysprep\Panther\unattend.xml", 1)
EndIf
;=====================================END WRITING AUTOX86=============================================================
;=====================================START WRITING AUTOX64===========================================================
If $READOS = "Windows Server 2008 Standard 64Bit" Then
   	  IF FileExists("XML\X64\unattend.xml") then	
		 FileDelete("XML\X64\unattend.xml")
	  EndIf
Sleep(1000)
	  If Not FileExists("XML\X64\unattend.xml") Then
		 FileCopy("XML\XML-ORIGINAL\X64\unattend.xml", "XML\X64\unattend.xml")
	  EndIf
   $HOSTREAD = GUICtrlRead($HOSTNAMEINPUT)
   $PASSREAD = GUICtrlRead($PASSWORDINPUT)
   $LICREAD = GUICtrlRead($LICENSEINPUT)
   
   	$XML	= "XML\X64\unattend.xml"
	$HOST	= "<Name></Name>"
	$PASS	= "<Password></Password>"
	$LIC	= "<Key></Key>"
	
   $var = FileOpen($XML, 1)
	  _ReplaceStringInFile("XML\X64\unattend.xml", $HOST , "<Name>" & $HOSTREAD & "</Name>")
	  _ReplaceStringInFile("XML\X64\unattend.xml", $PASS , "<Password>" & $PASSREAD & "</Password>")
	  _ReplaceStringInFile("XML\X64\unattend.xml", $LIC , "<Key>" & $LICREAD & "</Key>")
   FileClose($var)
Sleep(1000)
   If FileExists("L:\Windows\Panther\unattend.xml") Then
	  FileDelete("L:\Windows\Panther\unattend.xml")
   EndIf
   FileCopy("XML\X64\unattend.xml", "L:\Windows\Panther\unattend.xml", 1)
   If FileExists("L:\Windows\System32\Sysprep\unattend.xml") Then
	  FileDelete("L:\Windows\System32\Sysprep\unattend.xml")
   EndIf
   FileCopy("XML\X64\unattend.xml", "L:\Windows\System32\Sysprep\unattend.xml", 1)
   If FileExists("L:\Windows\System32\Sysprep\Panther\unattend.xml") Then
	  FileDelete("L:\Windows\System32\Sysprep\Panther\unattend.xml")
   EndIf
   FileCopy("XML\X64\unattend.xml", "L:\Windows\System32\Sysprep\Panther\unattend.xml", 1)
EndIf
;=====================================END WRITING AUTOX64=============================================================

Sleep(5000) ;------------------------------------------------------------------------Wacht 2 seconden voor het herstarten van de pc
Shutdown(2) ;------------------------------------------------------------------------Reboot PC na uitvoeren script

EndFunc

;=====================================END START FUNCTION==============================================================
;=====================================START LOGBOEK FUNCTION==========================================================

Func logb($LOGTEXT)
   _GUICtrlEdit_AppendText($LOGBOX, @CRLF & $LOGTEXT) ;------------------------------Logt alles in het logboek veld
EndFunc

;=====================================END LOGBOEK FUNCTION============================================================