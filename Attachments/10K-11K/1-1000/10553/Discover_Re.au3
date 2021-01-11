#region ------------------------  TO DO LIST  ---------------------------
#CS
	**Fix vehicle selection in additional insured box**
	**Verify: Montana, Wyoming, Utah (UT problem with Med Pay limit)
	**go thru all comments to check for commented code excluded for testing

	-Fix default values
	-Add PIP dialogs
	-Add various auto form dialogs for respective states
#CE
#endregion --------------------  END TO DO LIST  ------------------------
#region ------------------------  HEADER AND GLOBAL DECLARATIONS  -------
#include <GuiConstants.au3>
#include <Array.au3>

Opt("WinWaitDelay", 200)
Opt("SendKeyDelay", 8)
Opt("WinTitleMatchMode",2)
Opt("MouseCoordMode",0)

Global $wndDiscoverRe = "C:\WINNT\system32\cmd.exe - \\Remote, 128-bit SSL/TLS."
Global $wndRateWindow = "Target Premium: "
Global $NumberOfVehicles = 0
Global $currentVehicle = 0
Global $tierLevel = 2
Global $ratedPremium = -1
Global $finalPremium = -1
Global $modification = 1.00
Global $bolChangeMod = "false"
Global $lienholderFilepath = "lienholders.dat"
Global $genPolNum = ""
#endregion --------------------  END HEADER AND GLOBAL DECLARATIONS  ----
#region ------------------------  GUI DECLARTIONS  ----------------------
	#region ------------------------  MAIN WINDOW  --------------------------
	;GuiCreate("Discover Re Wizard", 500, 475,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	GuiCreate("Discover Re Wizard", 500, 475,@DesktopWidth-505, 0 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
		
	$mnuFile = GUICtrlCreateMenu ("&File")
		$mnuItmOpen 	= GUICtrlCreateMenuitem ("Open",			$mnuFile)
		$mnuItmSave		= GUICtrlCreateMenuitem ("Save",			$mnuFile)
		$mnuItmRestore 	= GUICtrlCreateMenuitem ("Restore",			$mnuFile)
		$mnuItmLookup	= GUICtrlCreateMenuitem	("Client Lookup", 	$mnuFile)
		$mnuItmSep1		= GUICtrlCreateMenuitem ("",				$mnuFile,4)
		$mnuItmTest		= GUICtrlCreateMenuitem ("Test", 			$mnuFile)
		$mnuItmSep2		= GUICtrlCreateMenuitem ("",				$mnuFile,6)
		$mnuItmExit 	= GUICtrlCreateMenuitem ("Exit",			$mnuFile)
		
	#endregion ------------------------  END MAIN WINDOW  ----------------------
	#region ------------------------  GUI TREE LISTINGS  --------------------
	$treDisplay = 	 GuiCtrlCreateTreeview(10, 10, 200, 430, BitOr($TVS_HASBUTTONS,$TVS_HASLINES,$TVS_LINESATROOT,$TVS_DISABLEDRAGDROP,$TVS_SHOWSELALWAYS),$WS_EX_CLIENTEDGE)
	$treItmGeneral = GUICtrlCreateTreeViewitem ("General",$treDisplay)
	$treItmComInfo = GUICtrlCreateTreeViewitem ("Common Info",$treDisplay)
	$treItmPolInfo = GUICtrlCreateTreeViewitem ("Policy Info",$treDisplay)
	$treItmVehInfo = GUICtrlCreateTreeViewitem ("Vehichle Info",$treDisplay)
	$treItmVehNum1 = GUICtrlCreateTreeViewitem ("Vehichle One",$treItmVehInfo)
	$treItmVehNum2 = GUICtrlCreateTreeViewitem ("Vehichle Two",$treItmVehInfo)
	$treItmVehNum3 = GUICtrlCreateTreeViewitem ("Vehichle Three",$treItmVehInfo)
	$treItmVehNum4 = GUICtrlCreateTreeViewitem ("Vehichle Four",$treItmVehInfo)
	#endregion --------------------  END GUI TREE LISTINGS  -----------------
	#region ------------------------  GUI GENERAL INFO  ---------------------
																	;Left, 	Top, 	Width, 	Height
	$Operator = GUICtrlCreateInput ("",								250,	80 ,	60,		20)
	$SlpModfr = GUICtrlCreateInput ("1",							250,	125,	60,		20)
																	;Left,	Top,	Width,	Height
	$lblOperator = GUICtrlCreateLabel ("Operator Initials",			250,	65,		-1,		15)
	$lblSlpModfr = GUICtrlCreateLabel ("Modify Delay",				250,	110,	-1,		15)
	#endregion --------------------  END GUI GENERAL INFO  ------------------
	#region ------------------------  GUI COMMON INFO  ----------------------
																	;Left, 	Top, 	Width, Height
	$fName = GUICtrlCreateInput ("",	 							225,	30 ,	100,	20)
	$mName = GUICtrlCreateInput ("", 								330,	30 ,	40 ,	20)
	$lName = GUICtrlCreateInput ("",	 							380,	30 ,	100,	20)
	$address1 = GUICtrlCreateInput ("",				 				225,	75 ,	255,	20)
	$address2= GUICtrlCreateInput ("",	 							225,	120 ,	255,	20)
	$city = GUICtrlCreateInput ("",		 							225,	165 ,	130,	20)
	$state = GUICtrlCreateInput ("",								375,	165,	40 ,	20)
	$zip = GUICtrlCreateInput ("",		 							430,	165,	50 ,	20)
	$effDate =GUICtrlCreateInput ("06",								225,	210,	100,	20)
	$dealerType = GUICtrlCreateInput ("D", 							375,	210,	40 ,	20)
	$DLNumber = GUICtrlCreateInput ("",			 					225,	300,	150,	20)
	$DOB = GUICtrlCreateInput ("",		 							385,	300,	100 ,	20)

																	;Left,	Top,	Width,	Height
	$lblFName = GUICtrlCreateLabel ("First",						225,	15,		-1,		15)
	$lblFName = GUICtrlCreateLabel ("Middle",						330,	15,		-1,		15)
	$lblFName = GUICtrlCreateLabel ("Last",							380,	15,		-1,		15)
	$lblAddy1 = GUICtrlCreateLabel ("Address 1",					225,	60,		-1,		15)
	$lblAddy2 = GUICtrlCreateLabel ("Address 2",					225,	105,	-1,		15)
	$lblCity  = GUICtrlCreateLabel ("City",							225,	150,	-1,		15)
	$lblState = GUICtrlCreateLabel ("State",						375,	150,	-1,		15)
	$lblZip   = GUICtrlCreateLabel ("Zip",							430,	150,	-1,		15)
	$lblEffDt = GUICtrlCreateLabel ("Eff Date (MMDDYY)",			225,	195,	-1,		15)
	$lblDealr = GUICtrlCreateLabel ("Dealer Type",					375,	195,	-1,		15)

	$lblDLNum = GUICtrlCreateLabel ("Driver's License Number",		225,	285,	-1,		15)
	$lblDOB   = GUICtrlCreateLabel ("Date Of Birth",				385,	285,	-1,		15)

	#endregion --------------------  END GUI COMMON INFO  -------------------
	#region ------------------------  GUI POLICY INFO  ----------------------
																	;Left,	Top,	Width,	Height
	$chkHiredAuto = GUICtrlCreateCheckbox("Hired Auto", 			255,	15,		80, 	25,		$BS_RIGHT)
	$chkLiab = GUICtrlCreateCheckbox("Liab",   						255,	55, 	80, 	25, 	$BS_RIGHT)
	$Liab = GUICtrlCreateInput ("1000",								350,	55,		80,		20)
	$chkPIP = GUICtrlCreateCheckbox("PIP",  	   					255,	95,		80,		25,		$BS_RIGHT)
	$chkMed = GUICtrlCreateCheckbox("Med Pay",  					255,	135,	80,		25,		$BS_RIGHT)
	$Med  = GUICtrlCreateInput ("5000",								350,	135,	80,		20)
	$chkUM = GUICtrlCreateCheckbox("UM",							255,	175,	80,		25,		$BS_RIGHT)
	$UM  = GUICtrlCreateInput ("1000",								350,	175,	80,		20)
	$chkComp = GUICtrlCreateCheckbox("Comp",						255,	215,	80,		25,		$BS_RIGHT)
	$Comp = GUICtrlCreateInput ("500",								350,	215,	80,		20)
	$chkColl = GUICtrlCreateCheckbox("Coll",						255,	255,	80,		25,		$BS_RIGHT)
	$Coll = GUICtrlCreateInput ("500",								350,	255,	80,		20)
	$fleet = 2  ;no more than 4 vehicles, so always fleet code '2'
																	;Left,	Top,	Width,	Height
	$premium = GUICtrlCreateInput ("1",		 						350,	315,	80 ,	20)
	$lblPrem  = GUICtrlCreateLabel ("Target Premium",				350,	300,	-1,		15)
	#endregion --------------------  END GUI POLICY INFO  -------------------
	#region ------------------------  DECLARE AUTO ARRAYS  ------------------
	Dim $autoCity[4]
	Dim $autoZip[4]
	Dim $autoType[4]
	Dim $autoYear[4]
	Dim $autoPrice[4]
	Dim $autoMake[4]
	Dim $autoModel[4]
	Dim $autoVIN[4]
	Dim $autoCode[4]
	Dim $lblVehCity[4]
	Dim $lblVehZip[4]
	Dim $lblVehType[4]
	Dim $lblVehYear[4]
	Dim $lblVehPrice[4]
	Dim $lblVehMake[4]
	Dim $lblVehModel[4]
	Dim $lblVehVIN[4]
	Dim $lblVehCode[4]
	Dim $chkAutoLiab[4]
	Dim $chkAutoMed[4]
	Dim $chkAutoUM[4]
	Dim $chkAutoComp[4]
	Dim $chkAutoColl[4]
	Dim $chkRental[4]
	Dim $cmbLienholder[4]
	Dim $lblLienholder[4]
	Dim $chkLienholder[4]
	
	Dim $lienName[4]
	Dim $lienAddress[4]
	Dim $lienCity[4]
	Dim $lienState[4]
	Dim $lienZip[4]
	#endregion --------------------  END DECLARE AUTO ARRAYS  ------------------
	#region ------------------------  GUI VEHICLE 1 INFO  -------------------
																	;Left,	Top,	Width,	Height
	$autoCity[0]  = GUICtrlCreateInput ("",		 					225,	30 ,	100,	20)
	$autoZip[0] = GUICtrlCreateInput ("",	 						385,	30,		50 ,	20)
	$autoType[0] = GUICtrlCreateCombo ("01", 						225,	75,		40,		200) ; create first item
	GUICtrlSetData(-1,"02|03|04|05|06|07|08|09|10","03") ; add other item snd set a new default
	;$autoType[0] = GUICtrlCreateInput ("3",							225,	75,		40,		20)
	$autoYear[0] = GUICtrlCreateInput ("",		 					285,	75,		40,		20)
	$autoPrice[0]= GUICtrlCreateInput ("",		 					385,	75,		50 ,	20)
	$autoMake[0] = GUICtrlCreateInput ("FREIGHTLINER",  			225,	120,	100,	20)
	$autoModel[0] = GUICtrlCreateInput ("", 						335,	120,	100,	20)
	$autoVIN[0] = GUICtrlCreateInput ("",					 		225,	165,	150,	20)
	$autoCode[0] = GUICtrlCreateInput ("23199", 					385,	165,	50,		20)

																	;Left,	Top,	Width,	Height
	$lblVehCity[0]  = GUICtrlCreateLabel ("City",  	  				225,	15,		-1,		15)
	$lblVehZip[0]   = GUICtrlCreateLabel ("Zip",  	  				385,	15,		-1,		15)
	$lblVehType[0]  = GUICtrlCreateLabel ("Type",  	  				225,	60,		-1,		15)
	$lblVehYear[0]  = GUICtrlCreateLabel ("Year",  	  				285,	60,		-1,		15)
	$lblVehPrice[0] = GUICtrlCreateLabel ("Price",  	  			385,	60,		-1,		15)
	$lblVehMake[0]  = GUICtrlCreateLabel ("Make",  	  				225,	105,	-1,		15)
	$lblVehModel[0] = GUICtrlCreateLabel ("Model",  	  			335,	105,	-1,		15)
	$lblVehVIN[0]   = GUICtrlCreateLabel ("VIN",  	  				225,	150,	-1,		15)
	$lblVehCode[0]  = GUICtrlCreateLabel ("Code",  	  				385,	150,	-1,		15)

	$chkAutoLiab[0] = GUICtrlCreateCheckbox("Liability",			225,	210,	75,		25,		$BS_RIGHT)
	$chkAutoMed[0]  = GUICtrlCreateCheckbox("Med Pay",				225,	240,	75,		25,		$BS_RIGHT)
	$chkAutoUM[0] 	= GUICtrlCreateCheckbox("UM",					225,	270,	75,		25,		$BS_RIGHT)
	$chkAutoComp[0]	= GUICtrlCreateCheckbox("Comp",					350,	210,	75,		25,		$BS_RIGHT)
	$chkAutoColl[0]	= GUICtrlCreateCheckbox("Coll",					350,	240,	75,		25,		$BS_RIGHT)

	$chkRental[0] 	= GUICtrlCreateCheckbox ("Rental", 				350,	270,	75,		25,		$BS_RIGHT)
 	$lblLienholder[0] = GUICtrlCreateLabel ("",						225,	350,	200,	60)
	$cmbLienholder[0] = GUICtrlCreateCombo ("None", 				225,	325,	200,	250) 	
	$chkLienholder[0] = GUICtrlCreateCheckbox ("Lienholder",		225,	300,	75,		25,		$BS_RIGHT)
	#endregion --------------------  END GUI VEHICLE 1 INFO  ----------------
	#region ------------------------  GUI VEHICLE 2 INFO  -------------------
																	;Left,	Top,	Width,	Height
	$autoCity[1]  = GUICtrlCreateInput ("", 						225,	30 ,	100,	20)
	$autoZip[1] = GUICtrlCreateInput ("", 							385,	30,		50 ,	20)
	$autoType[1] = GUICtrlCreateCombo ("01", 						225,	75,		40,		200) ; create first item
	GUICtrlSetData(-1,"02|03|04|05|06|07|08|09|10","03") ; add other item snd set a new default
	;$autoType[1] = GUICtrlCreateInput ("",							225,	75,		40,		20)
	$autoYear[1] = GUICtrlCreateInput ("",	 						285,	75,		40,		20)
	$autoPrice[1]= GUICtrlCreateInput ("",	 						385,	75,		50 ,	20)
	$autoMake[1] = GUICtrlCreateInput ("",  						225,	120,	100,	20)
	$autoModel[1] = GUICtrlCreateInput ("", 						335,	120,	100,	20)
	$autoVIN[1] = GUICtrlCreateInput ("", 							225,	165,	150,	20)
	$autoCode[1] = GUICtrlCreateInput ("", 							385,	165,	50,		20)

																	;Left,	Top,	Width,	Height
	$lblVehCity[1]  = GUICtrlCreateLabel ("City",  	  				225,	15,		-1,		15)
	$lblVehZip[1]   = GUICtrlCreateLabel ("Zip",  	  				385,	15,		-1,		15)
	$lblVehType[1]  = GUICtrlCreateLabel ("Type",  	  				225,	60,		-1,		15)
	$lblVehYear[1]  = GUICtrlCreateLabel ("Year",  	  				285,	60,		-1,		15)
	$lblVehPrice[1] = GUICtrlCreateLabel ("Price",  	  			385,	60,		-1,		15)
	$lblVehMake[1]  = GUICtrlCreateLabel ("Make",  	  				225,	105,	-1,		15)
	$lblVehModel[1] = GUICtrlCreateLabel ("Model",  	  			335,	105,	-1,		15)
	$lblVehVIN[1]   = GUICtrlCreateLabel ("VIN",  	  				225,	150,	-1,		15)
	$lblVehCode[1]  = GUICtrlCreateLabel ("Code",  	  				385,	150,	-1,		15)

	$chkAutoLiab[1] = GUICtrlCreateCheckbox("Liability",			225,	210,	75,		25,		$BS_RIGHT)
	$chkAutoMed[1]  = GUICtrlCreateCheckbox("Med Pay",				225,	240,	75,		25,		$BS_RIGHT)
	$chkAutoUM[1] 	= GUICtrlCreateCheckbox("UM",					225,	270,	75,		25,		$BS_RIGHT)
	$chkAutoComp[1]	= GUICtrlCreateCheckbox("Comp",					350,	210,	75,		25,		$BS_RIGHT)
	$chkAutoColl[1]	= GUICtrlCreateCheckbox("Coll",					350,	240,	75,		25,		$BS_RIGHT)

	$chkRental[1] 	= GUICtrlCreateCheckbox ("Rental", 				350,	270,	75,		25,		$BS_RIGHT)
	$lblLienholder[1] = GUICtrlCreateLabel ("",						225,	350,	200,	60)
	$cmbLienholder[1] = GUICtrlCreateCombo ("None", 				225,	325,	200,	250) 	
	$chkLienholder[1] = GUICtrlCreateCheckbox ("Lienholder",		225,	300,	75,		25,		$BS_RIGHT)
	#endregion --------------------  END GUI VEHICLE 2 INFO  ----------------
	#region ------------------------  GUI VEHICLE 3 INFO  -------------------
																	;Left,	Top,	Width,	Height
	$autoCity[2]  = GUICtrlCreateInput ("", 						225,	30 ,	100,	20)
	$autoZip[2] = GUICtrlCreateInput ("", 							385,	30,		50 ,	20)
	$autoType[2] = GUICtrlCreateCombo ("01", 						225,	75,		40,		200) ; create first item
	GUICtrlSetData(-1,"02|03|04|05|06|07|08|09|10","03") ; add other item snd set a new default
	;$autoType[2] = GUICtrlCreateInput ("3",							225,	75,		40,		20)
	$autoYear[2] = GUICtrlCreateInput ("",	 						285,	75,		40,		20)
	$autoPrice[2]= GUICtrlCreateInput ("",	 						385,	75,		50 ,	20)
	$autoMake[2] = GUICtrlCreateInput ("",  						225,	120,	100,	20)
	$autoModel[2] = GUICtrlCreateInput ("", 						335,	120,	100,	20)
	$autoVIN[2] = GUICtrlCreateInput ("", 							225,	165,	150,	20)
	$autoCode[2] = GUICtrlCreateInput ("", 							385,	165,	50,		20)

																	;Left,	Top,	Width,	Height
	$lblVehCity[2]  = GUICtrlCreateLabel ("City",  	  				225,	15,		-1,		15)
	$lblVehZip[2]   = GUICtrlCreateLabel ("Zip",  	  				385,	15,		-1,		15)
	$lblVehType[2]  = GUICtrlCreateLabel ("Type",  	  				225,	60,		-1,		15)
	$lblVehYear[2]  = GUICtrlCreateLabel ("Year",  	  				285,	60,		-1,		15)
	$lblVehPrice[2] = GUICtrlCreateLabel ("Price",  	  			385,	60,		-1,		15)
	$lblVehMake[2]  = GUICtrlCreateLabel ("Make",  	  				225,	105,	-1,		15)
	$lblVehModel[2] = GUICtrlCreateLabel ("Model",  	  			335,	105,	-1,		15)
	$lblVehVIN[2]   = GUICtrlCreateLabel ("VIN",  	  				225,	150,	-1,		15)
	$lblVehCode[2]  = GUICtrlCreateLabel ("Code",  	  				385,	150,	-1,		15)

	$chkAutoLiab[2] = GUICtrlCreateCheckbox("Liability",			225,	210,	75,		25,		$BS_RIGHT)
	$chkAutoMed[2]  = GUICtrlCreateCheckbox("Med Pay",				225,	240,	75,		25,		$BS_RIGHT)
	$chkAutoUM[2] 	= GUICtrlCreateCheckbox("UM",					225,	270,	75,		25,		$BS_RIGHT)
	$chkAutoComp[2]	= GUICtrlCreateCheckbox("Comp",					350,	210,	75,		25,		$BS_RIGHT)
	$chkAutoColl[2]	= GUICtrlCreateCheckbox("Coll",					350,	240,	75,		25,		$BS_RIGHT)

	$chkRental[2] 	= GUICtrlCreateCheckbox ("Rental", 				350,	270,	75,		25,		$BS_RIGHT)
	$lblLienholder[2] = GUICtrlCreateLabel ("",						225,	350,	200,	60)
	$cmbLienholder[2] = GUICtrlCreateCombo ("None", 				225,	325,	200,	250) 	
	$chkLienholder[2] = GUICtrlCreateCheckbox ("Lienholder",		225,	300,	75,		25,		$BS_RIGHT)
	#endregion --------------------  END GUI VEHICLE 3 INFO  ----------------
	#region ------------------------  GUI VEHICLE 4 INFO  -------------------
																	;Left,	Top,	Width,	Height
	$autoCity[3]  = GUICtrlCreateInput ("", 						225,	30 ,	100,	20)
	$autoZip[3] = GUICtrlCreateInput ("", 							385,	30,		50 ,	20)
	$autoType[3] = GUICtrlCreateCombo ("01", 						225,	75,		40,		200) ; create first item
	GUICtrlSetData(-1,"02|03|04|05|06|07|08|09|10","03") ; add other item snd set a new default
	;$autoType[3] = GUICtrlCreateInput ("3",							225,	75,		40,		20)
	$autoYear[3] = GUICtrlCreateInput ("",	 						285,	75,		40,		20)
	$autoPrice[3]= GUICtrlCreateInput ("",	 						385,	75,		50 ,	20)
	$autoMake[3] = GUICtrlCreateInput ("",  						225,	120,	100,	20)
	$autoModel[3] = GUICtrlCreateInput ("", 						335,	120,	100,	20)
	$autoVIN[3] = GUICtrlCreateInput ("", 							225,	165,	150,	20)
	$autoCode[3] = GUICtrlCreateInput ("", 							385,	165,	50,		20)

																	;Left,	Top,	Width,	Height
	$lblVehCity[3]  = GUICtrlCreateLabel ("City",  	  				225,	15,		-1,		15)
	$lblVehZip[3]   = GUICtrlCreateLabel ("Zip",  	  				385,	15,		-1,		15)
	$lblVehType[3]  = GUICtrlCreateLabel ("Type",  	  				225,	60,		-1,		15)
	$lblVehYear[3]  = GUICtrlCreateLabel ("Year",  	  				285,	60,		-1,		15)
	$lblVehPrice[3] = GUICtrlCreateLabel ("Price",  	  			385,	60,		-1,		15)
	$lblVehMake[3]  = GUICtrlCreateLabel ("Make",  	  				225,	105,	-1,		15)
	$lblVehModel[3] = GUICtrlCreateLabel ("Model",  	  			335,	105,	-1,		15)
	$lblVehVIN[3]   = GUICtrlCreateLabel ("VIN",  	  				225,	150,	-1,		15)
	$lblVehCode[3]  = GUICtrlCreateLabel ("Code",  	  				385,	150,	-1,		15)

	$chkAutoLiab[3] = GUICtrlCreateCheckbox("Liability",			225,	210,	75,		25,		$BS_RIGHT)
	$chkAutoMed[3]  = GUICtrlCreateCheckbox("Med Pay",				225,	240,	75,		25,		$BS_RIGHT)
	$chkAutoUM[3] 	= GUICtrlCreateCheckbox("UM",					225,	270,	75,		25,		$BS_RIGHT)
	$chkAutoComp[3]	= GUICtrlCreateCheckbox("Comp",					350,	210,	75,		25,		$BS_RIGHT)
	$chkAutoColl[3]	= GUICtrlCreateCheckbox("Coll",					350,	240,	75,		25,		$BS_RIGHT)

	$chkRental[3] 	= GUICtrlCreateCheckbox ("Rental", 				350,	270,	75,		25,		$BS_RIGHT)
	$lblLienholder[3] = GUICtrlCreateLabel ("",						225,	350,	200,	60)
	$cmbLienholder[3] = GUICtrlCreateCombo ("None", 				225,	325,	200,	250) 	
	$chkLienholder[3] = GUICtrlCreateCheckbox ("Lienholder",		225,	300,	75,		25,		$BS_RIGHT)
	#endregion --------------------  END GUI VEHICLE 4 INFO  ----------------
	#region ------------------------  GUI BUTTONS  --------------------------
	$btnRenew = GUICtrlCreateButton("Renew",						225, 	415, 	40)
	$btnQuote = GUICtrlCreateButton("Quote",						350, 	415, 	40)
	$btnIsse = GUICtrlCreateButton("Issue",							400, 	415, 	40)
	#endregion --------------------  END GUI BUTTONS  -----------------------

#endregion --------------------  END GUI DECLARTIONS  -------------------
#region ------------------------  MAIN LOOP  ----------------------------
ReadPrefs()
LoadLienholderData()
GuiSetState()
GUIHideCtrls()
GUIShowItems($Operator, $lblSlpModfr) ;General info
;FillDefaultValues()
While 1
	$msg = GuiGetMsg()
	$formattedState = StringLower(GUICtrlRead($state))

	
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $mnuItmExit ;close app
			DirCreate(@AppDataDir&"\Discover Re Wizzard")
			WriteFile(@AppDataDir&"\Discover Re Wizzard\restore.dat") ;save data to restore file on exit
			WritePrefs()
			ExitLoop
		Case $msg = $GUI_EVENT_MOUSEMOVE
			UpdateLienholderData()
		Case $msg = $treItmGeneral
			GUIHideCtrls()
			GUIShowItems($Operator, $lblSlpModfr) ;General info

		Case $msg = $treItmComInfo
			GUIHideCtrls()
			GUIShowItems($fName,$lblDOB) ;common info

		Case $msg = $treItmPolInfo
			GUIHideCtrls()
			GUIShowItems($chkHiredAuto,$lblPrem) ;policy info

		Case $msg = $treItmVehNum1
			GUIHideCtrls()
			GUIShowItems($autoCity[0],$cmbLienholder[0]) ;vehicle 1

		Case $msg = $treItmVehNum2
			GUIHideCtrls()
			GUIShowItems($autoCity[1],$cmbLienholder[1]) ;vehicle 2

		Case $msg = $treItmVehNum3
			GUIHideCtrls()
			GUIShowItems($autoCity[2],$cmbLienholder[2]) ;vehicle 3

		Case $msg = $treItmVehNum4
			GUIHideCtrls()
			GUIShowItems($autoCity[3],$cmbLienholder[3]) ;vehicle 4

		Case $msg = $mnuItmRestore
			ReadFile(@AppDataDir&"\Discover Re Wizzard\restore.dat")
			
		Case $msg = $mnuItmSave
			$defaultName = StringUpper(GUICtrlRead($lName))&", "&StringUpper(GUICtrlRead($fName))&" "&StringUpper(GUICtrlRead($mName))
			$fileSave = FileSaveDialog("Save", "J:\Public\Discover Re Wizard\Saved\", "Clients (*.drw)",-1, $defaultName&".drw")
			WriteFile($fileSave)
			
		Case $msg = $mnuItmOpen
			$fileOpen = FileOpenDialog("Open", "J:\Public\Discover Re Wizard\Saved\","Clients (*.drw)",1)
			ReadFile($fileOpen)
		
		Case $msg = $mnuItmLookup		
			ClientLookup()
		Case $msg = $mnuItmTest
			;nothing atm
		Case $msg = $btnRenew
			StartRenew()
		Case $msg = $btnQuote
			StartQuote()		
		Case $msg = $btnIsse
			StartIssue()
	EndSelect

WEnd
#endregion --------------------  END MAIN LOOP  -------------------------
#region ------------------------  FUNCTION LIST  ------------------------
	Func StartRenew()
		WriteFile(@AppDataDir&"\Discover Re Wizzard\restore.dat") ;save data to restore file on exit
		If 	Validation() = -1 Then Return
		Opt("SendKeyDelay", 5 + (GUICtrlRead($SlpModfr) * 5))
		CommonInfo()
		Sleep( ($SlpModfr*150) + 850)
		PolicyInfo()
		Sleep( ($SlpModfr*150) + 850)
		AutoInfo()
		Sleep( ($SlpModfr*150) + 850)
		AddVehicles()
		Sleep( ($SlpModfr*150) + 850)
		ChangePremium()
		SetActiveWindow($wndDiscoverRe)
		Send("{DOWN}{ENTER}") ;quit to main screen
		Sleep( ($SlpModfr*250) + 2000)
		Issue()
		Sleep( ($SlpModfr*150) + 850)
		DMVReporting()
		Sleep( ($SlpModfr*150) + 400)
		AutoForm()
		Sleep( ($SlpModfr*150) + 400)
		FillAutoFormData()
		Sleep( ($SlpModfr*150) + 400)
		WriteFile("J:\Public\Discover Re Wizard\Renewed\"&StringUpper(GUICtrlRead($lName))&", "&StringUpper(GUICtrlRead($fName))&" "&StringUpper(GUICtrlRead($mName))&".drw")
		FileWriteLine("J:\Public\Discover Re Wizard\Electronic Policy List.txt", "cd ..")
		FileWriteLine("J:\Public\Discover Re Wizard\Electronic Policy List.txt", "cd "&$genPolNum)
		FileWriteLine("J:\Public\Discover Re Wizard\Electronic Policy List.txt", "mget *.pdf")
		FileWriteLine("J:\Public\Discover Re Wizard\Electronic Policy List.txt", "")
		PrintPolicy()
		Exit
	EndFunc
	Func StartQuote()
			WriteFile(@AppDataDir&"\Discover Re Wizzard\restore.dat") ;save data to restore file on exit
			If 	Validation() = -1 Then Return
			Opt("SendKeyDelay", 5 + (GUICtrlRead($SlpModfr) * 5))
			CommonInfo()
			Sleep( ($SlpModfr*50) + 1750)
			PolicyInfo()
			Sleep( ($SlpModfr*50) + 1750)
			AutoInfo()
			Sleep( ($SlpModfr*50) + 1750)
			AddVehicles()
			Sleep( ($SlpModfr*50) + 1750)
			ChangePremium()
			Sleep( ($SlpModfr*50) + 1750)
			QuotePrintDetailSheet()
	EndFunc
	Func StartIssue()
		WriteFile(@AppDataDir&"\Discover Re Wizzard\restore.dat") ;save data to restore file on exit
		If 	Validation() = -1 Then Return
		Issue()
		Sleep( ($SlpModfr*50) + 1750)
		DMVReporting()
		Sleep( ($SlpModfr*50) + 500)
		AutoForm()
		Sleep( ($SlpModfr*50) + 500)
		FillAutoFormData()
	EndFunc
	Func GUIShowItems($showStart,$showEnd)
		Local $ctrl
		;Show controls from param1 to param2
		For $ctrl = $showStart To $showEnd
			GUICtrlSetState ($ctrl,$GUI_SHOW)
		Next
	EndFunc
	Func GUIHideItems($hideStart,$hideEnd)
		Local $ctrl
		;Hide controls from param1 to param2
		For $ctrl = $hideStart To $hideEnd
			GUICtrlSetState ($ctrl,$GUI_HIDE)
		Next
	EndFunc
	Func GUIHideCtrls()
		GUIHideItems($Operator,$chkLienholder[3])
		;GUIHideItems($Operator,$lblDOB) ; common info
		;GUIHideItems($chkHiredAuto,$chkLienholder[3]) ; policy info
	EndFunc
	Func SetActiveWindow($wndTitle)
		If Not WinExists($wndTitle) Then
			MsgBox(48,"Error", $wndTitle & " does not exsist!")
		Else
			WinWait($wndTitle,"")
			If Not WinActive($wndTitle,"") Then WinActivate($wndTitle,"")
			WinWaitActive($wndTitle,"")
		EndIf
	EndFunc
	Func AmountOfVehicles()
		Select
			Case GUICtrlRead($autoVIN[0]) = ""
				$NumberOfVehicles = 0
				;Exit
			Case GUICtrlRead($autoVIN[1]) = ""
				$NumberOfVehicles = 1
			Case GUICtrlRead($autoVIN[2]) = ""
				$NumberOfVehicles = 2
			Case GUICtrlRead($autoVIN[3]) = ""
				$NumberOfVehicles = 3
			Case Else
				$NumberOfVehicles = 4
		EndSelect
	EndFunc
	Func FillDefaultValues()
;		GUICtrlSetState ($chkPIP, $GUI_CHECKED)
;		GUICtrlSetState ($chkMed, $GUI_CHECKED)
;		GUICtrlSetState ($chkHiredAuto, $GUI_CHECKED)
		GUICtrlSetState ($chkLiab, $GUI_CHECKED)
		GUICtrlSetState ($chkUM, $GUI_CHECKED)
		GUICtrlSetState ($chkComp, $GUI_CHECKED)
		GUICtrlSetState ($chkColl, $GUI_CHECKED)

		GUICtrlSetState ($chkAutoColl[0], $GUI_CHECKED)
		GUICtrlSetState ($chkAutoComp[0], $GUI_CHECKED)
		GUICtrlSetState ($chkAutoLiab[0], $GUI_CHECKED)
;		GUICtrlSetState ($chkAutoMed[0], $GUI_CHECKED)
		GUICtrlSetState ($chkAutoUM[0], $GUI_CHECKED)
;		GUICtrlSetState ($chkLienholder[0], $GUI_CHECKED)
;		GUICtrlSetState ($chkRental[0], $GUI_CHECKED)
	EndFunc
	Func GetUpperMod()
		Select
			Case $formattedState = "al" Or $formattedState = "az" Or $formattedState = "ca" Or _
				 $formattedState = "co" Or $formattedState = "ct" Or $formattedState = "de" Or _
				 $formattedState = "fl" Or $formattedState = "ia" Or $formattedState = "ks" Or _
				 $formattedState = "la" Or $formattedState = "mi" Or $formattedState = "mo" Or _
				 $formattedState = "nj" Or $formattedState = "nm" Or $formattedState = "nd" Or _
				 $formattedState = "oh" Or $formattedState = "or" Or $formattedState = "sd" Or _
				 $formattedState = "tx" Or $formattedState = "ut" Or $formattedState = "wa" Or _
				 $formattedState = "wa"
				Return 1.25

			Case $formattedState = "ak" Or $formattedState = "ar" Or $formattedState = "id" Or _
				 $formattedState = "il" Or $formattedState = "in" Or $formattedState = "ky" Or _
				 $formattedState = "me" Or $formattedState = "md" Or $formattedState = "mn" Or _
				 $formattedState = "ms" Or $formattedState = "mt" Or $formattedState = "nv" Or _
				 $formattedState = "nh" Or $formattedState = "nc" Or $formattedState = "ok" Or _
				 $formattedState = "pa" Or $formattedState = "ri" Or $formattedState = "tn" Or _
				 $formattedState = "vt" Or $formattedState = "va" Or $formattedState = "wv" Or _
				 $formattedState = "wi" Or $formattedState = "wy"
				Return 1.40

			Case $formattedState = "ga" Or $formattedState = "ny"
				Return 1.16  ;supposed to be 1.15, changed due to wierd rounding error

			Case $formattedState = "ma" Or $formattedState = "sc"
				Return 1.25

			Case $formattedState = "hi" Or $formattedState = "ne"
				Return 1.00

			Case Else
				MsgBox(48, "Error", "This state is missing")
				SetActiveWindow($wndDiscoverRe)

		EndSelect

	EndFunc
	Func GetLowerMod()
		Select
			Case $formattedState = "al" Or $formattedState = "az" Or $formattedState = "ca" Or _
				 $formattedState = "co" Or $formattedState = "ct" Or $formattedState = "de" Or _
				 $formattedState = "fl" Or $formattedState = "ia" Or $formattedState = "ks" Or _
				 $formattedState = "la" Or $formattedState = "mi" Or $formattedState = "mo" Or _
				 $formattedState = "nj" Or $formattedState = "nm" Or $formattedState = "nd" Or _
				 $formattedState = "oh" Or $formattedState = "or" Or $formattedState = "sd" Or _
				 $formattedState = "tx" Or $formattedState = "ut" Or $formattedState = "wa" Or _
				 $formattedState = "wa"
				Return .75

			Case $formattedState = "ak" Or $formattedState = "ar" Or $formattedState = "id" Or _
				 $formattedState = "il" Or $formattedState = "in" Or $formattedState = "ky" Or _
				 $formattedState = "me" Or $formattedState = "md" Or $formattedState = "mn" Or _
				 $formattedState = "ms" Or $formattedState = "mt" Or $formattedState = "nv" Or _
				 $formattedState = "nh" Or $formattedState = "nc" Or $formattedState = "ok" Or _
				 $formattedState = "pa" Or $formattedState = "ri" Or $formattedState = "tn" Or _
				 $formattedState = "vt" Or $formattedState = "va" Or $formattedState = "wv" Or _
				 $formattedState = "wi" Or $formattedState = "wy"
				Return .60

			Case $formattedState = "ga" Or $formattedState = "ny"
				 Return .85

			Case $formattedState = "ma" Or $formattedState = "sc"
				Return .60

			Case $formattedState = "hi" Or $formattedState = "ne"
				Return 1.00

			Case Else
				MsgBox(48, "Error", "This state is missing")
				SetActiveWindow($wndDiscoverRe)

		EndSelect

	EndFunc
	Func ChangePremium()
			
		;-----------------------
		Sleep( ($SlpModfr*50) + 3500)
		$_buffPrem = ReadConsoleText(340,195,390,200)
		$_buffPrem = StringReplace($_buffPrem, ",", "")		
		;-----------------------
		
		$wndRatePremium = GUICreate("Target Premium: " & GUICtrlRead($premium), 300, 200)
		$numOfModChanges = 0

		GUISetState (@SW_SHOW)

		$sldMod = GUICtrlCreateSlider (10,35,170,20);10,100,170,20)
		GUICtrlSetLimit($sldMod,GetUpperMod()*100,GetLowerMod()*100)	; change min/max value
		$lblMod = GUICtrlCreateLabel ("Modification: " & $sldMod/100, 10, 15, -1, 15) ;10, 80, -1, 15)
		$lblCurrentMod = GUICtrlCreateLabel("1.00", 150, 15, -1, 15)
		$btnMod = GUICtrlCreateButton("Apply", 220, 35, 60)


		$sldTier = GUICtrlCreateSlider (10,100,170,20);10,170,170,20)
		GUICtrlSetLimit($sldTier,4,1)	; change min/max value
		$lblTier = GUICtrlCreateLabel("Current Tier: " & $tierLevel,  10, 80, -1, 15);10, 150, -1, 15)
		$lblCurrentTier = GUICtrlCreateLabel("2", 150, 80, -1, 15)
		$btnTier = GUICtrlCreateButton("Apply", 220, 100, 60)


		$lblRatedPrem = GUICtrlCreateLabel("Rated Premium", 10, 150, -1, 15);10, 15, -1, 15)
		;$ratedPremium = GUICtrlCreateInput(GUICtrlRead($premium), 10, 170, 100, 20);10, 30, 100, 20)
		$ratedPremium = GUICtrlCreateInput($_buffPrem, 10, 170, 100, 20);10, 30, 100, 20)

		$mod = GUICtrlRead($premium) / $ratedPremium
		$lblTarget	  = GUICtrlCreateLabel("Target Mod: " , 125, 150, -1, 15);10, 15, -1, 15)
		$lblTargetMod = GUICtrlCreateLabel( $mod, 			125, 170, -1, 15);10, 15, -1, 15)

		$btnContinue = GUICtrlCreateButton("Continue", 220, 160, 60)

		While 1
			$event = GUIGetMsg()

			Select
				Case $event = $GUI_EVENT_CLOSE
					ExitLoop
				Case $event = $GUI_EVENT_MOUSEMOVE
					GUICtrlSetData($lblMod, "Modification: " & GUICtrlRead($sldMod)/100)
					GUICtrlSetData($lblTier, "Tier: " & GUICtrlRead($sldTier))
					GUICtrlSetData($lblCurrentMod, $modification)
					GUICtrlSetData($lblCurrentTier, $tierLevel)
					$mod = GUICtrlRead($premium) / GUICtrlRead($ratedPremium)
					$mod = StringFormat("%.3f",$mod) ;format mod to 3 decimal places
					$mod = StringFormat("%.4s",$mod) ;format mod to string because of stupid rounding issues
					GUICtrlSetData($lblTargetMod, $mod)

				Case $event = $btnContinue
					;$finalPremium = InputBox("Final Premium", "What is the final premium?","")
					Sleep( ($SlpModfr*50) + 500)
					$_buffPrem = ReadConsoleText(340,195,390,200)
					$_buffPrem = StringReplace($_buffPrem, ",", "")
					$finalPremium = $_buffPrem
					If $finalPremium = -1 Then $finalPremium = InputBox("Final Premium", "What is the final premium?","")
					
					SetActiveWindow($wndDiscoverRe)
					Send("{ENTER}")
					Sleep( ($SlpModfr*50) + 200)
;~ 					Send("{DOWN}{ENTER}")
					ExitLoop
				Case $event = $btnTier
					$tierLevel = GUICtrlRead($sldTier)
					If $numOfModChanges < 1 Then
						ChangeTier($tierLevel)
					Else
						ReChangeTier($tierLevel)
					EndIf
					GUISetState (@SW_SHOW)

				Case $event = $btnMod
					$modification = GUICtrlRead($sldMod)
					$modification = $modification / 100
					$modification = StringFormat("%.3f",$modification) ;format mod to 3 decimal places
					$modification = StringFormat("%.4s",$modification) ;format mod to string because of stupid rounding issues
					If $numOfModChanges < 1 Then
						ChangeMod($modification)
					Else
						ReChangeMod($modification)
					EndIf
					$numOfModChanges = $numOfModChanges + 1
					GUISetState (@SW_SHOW)

			EndSelect
		Wend
		GUIDelete($wndRatePremium)
		SetActiveWindow($wndDiscoverRe)
	EndFunc
	Func LoadLienholderData()
	$aryLienholderNames = IniReadSectionNames($lienholderFilepath)
		If @error Then 
			MsgBox(48, "Error", "Error occured while loading lienholder data.")
		Else
		For $i = 1 To  _ArrayMaxIndex($aryLienholderNames,0,1)
			GUICtrlSetData($cmbLienholder[0], $aryLienholderNames[$i], "None")
			GUICtrlSetData($cmbLienholder[1], $aryLienholderNames[$i], "None")
			GUICtrlSetData($cmbLienholder[2], $aryLienholderNames[$i], "None")
			GUICtrlSetData($cmbLienholder[3], $aryLienholderNames[$i], "None")
		Next
	EndIf
	EndFunc
	Func UpdateLienholderData()
		For $i = 0 To 3
			$lienName[$i] = 	GUICtrlRead($cmbLienholder[$i])
			$lienAddress[$i] = 	IniRead($lienholderFilepath, GUICtrlRead($cmbLienholder[$i]), "address", "")
			$lienCity[$i] = 	IniRead($lienholderFilepath, GUICtrlRead($cmbLienholder[$i]), "city", "")
			$lienState[$i] = 	IniRead($lienholderFilepath, GUICtrlRead($cmbLienholder[$i]), "state", "")
			$lienZip[$i] = 		IniRead($lienholderFilepath, GUICtrlRead($cmbLienholder[$i]), "zip", "")

			GUICtrlSetData( $lblLienholder[$i], $lienAddress[$i] & @CR & $lienCity[$i] & "   " & $lienState[$i] & @CR & $lienZip[$i])
			
			If $lienName[$i] = "None" Then
				GUICtrlSetState ($chkLienholder[$i], $GUI_UNCHECKED)
			Else
				GUICtrlSetState ($chkLienholder[$i], $GUI_CHECKED)
			EndIf
		Next
	EndFunc
	Func FillAutoFormData()
		If GUICtrlRead($chkLienholder[0]) = 1 Or GUICtrlRead($chkLienholder[1]) = 1  Or GUICtrlRead($chkLienholder[2]) = 1  Or GUICtrlRead($chkLienholder[3]) = 1 Then
			AdditionalInsured()
			Send("{DOWN}")
		EndIf
		
		DesignatedInsured()
		
		Send("{ENTER}e")  ;exit screen
			
	EndFunc
	Func WriteFile($fp)
		$restoreFile = FileOpen($fp, 2) ;open file, erasing contents

			;Common Info
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($fName)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($mName)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($lName)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($address1)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($address2)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($city)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($state)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($zip)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($effDate)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($dealerType)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($DLNumber)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($DOB)))

			;Policy Info
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkHiredAuto)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkLiab)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($Liab)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkPIP)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkMed)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($Med)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkUM)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($UM)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkComp)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($Comp)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkColl)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($Coll)))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($premium)))
			
			;Vehicle Info 1
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoCity[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoZip[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoType[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoYear[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoPrice[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoMake[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoModel[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoVIN[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoCode[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoLiab[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoMed[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoUM[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoComp[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoColl[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkRental[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkLienholder[0])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($cmbLienholder[0])))
			
			;Vehicle Info 2
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoCity[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoZip[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoType[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoYear[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoPrice[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoMake[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoModel[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoVIN[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoCode[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoLiab[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoMed[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoUM[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoComp[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoColl[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkRental[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkLienholder[1])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($cmbLienholder[1])))
			
			;Vehicle Info 3
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoCity[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoZip[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoType[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoYear[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoPrice[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoMake[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoModel[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoVIN[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoCode[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoLiab[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoMed[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoUM[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoComp[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoColl[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkRental[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkLienholder[2])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($cmbLienholder[2])))
			
			;Vehicle Info 4
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoCity[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoZip[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoType[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoYear[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoPrice[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoMake[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoModel[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoVIN[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($autoCode[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoLiab[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoMed[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoUM[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoComp[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkAutoColl[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkRental[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($chkLienholder[3])))
			FileWriteLine($restoreFile, StringUpper(GUICtrlRead($cmbLienholder[3])))
			
			;Misc
			FileWriteLine($restoreFile, StringUpper($tierLevel))
			FileWriteLine($restoreFile, StringUpper($modification))
			FileWriteLine($restoreFile, StringUpper($finalPremium))
			FileWriteLine($restoreFile, StringUpper($genPolNum))
			
			
		FileClose($restoreFile)

	EndFunc
	Func ReadFile($fp)
		$restoreFile = FileOpen($fp, 0) ;open file, read only
		
		If $restoreFile = -1 Then 
			MsgBox(0, "Error", "Error reading the file.")
			Return
		EndIf
	
			;Common Info
			GUICtrlSetData($fName, FileReadLine($restoreFile,					1))
			GUICtrlSetData($mName, FileReadLine($restoreFile,					2))
			GUICtrlSetData($lName, FileReadLine($restoreFile,					3))
			GUICtrlSetData($address1, FileReadLine($restoreFile,				4))
			GUICtrlSetData($address2, FileReadLine($restoreFile,				5))
			GUICtrlSetData($city, FileReadLine($restoreFile,					6))
			GUICtrlSetData($state, FileReadLine($restoreFile,					7))
			GUICtrlSetData($zip, FileReadLine($restoreFile,						8))
			GUICtrlSetData($effDate, FileReadLine($restoreFile,					9))
			GUICtrlSetData($dealerType, FileReadLine($restoreFile,				10))
			GUICtrlSetData($DLNumber, FileReadLine($restoreFile,				11))
			GUICtrlSetData($DOB, FileReadLine($restoreFile,						12))

			;Policy Info
			GUICtrlSetState($chkHiredAuto, FileReadLine($restoreFile,			13))
			GUICtrlSetState($chkLiab, FileReadLine($restoreFile,				14))
			GUICtrlSetData($Liab, FileReadLine($restoreFile,					15))
			GUICtrlSetState($chkPIP, FileReadLine($restoreFile,					16))
			GUICtrlSetState($chkMed, FileReadLine($restoreFile,					17))
			GUICtrlSetData($Med, FileReadLine($restoreFile,						18))
			GUICtrlSetState($chkUM, FileReadLine($restoreFile,					19))
			GUICtrlSetData($UM, FileReadLine($restoreFile,						20))
			GUICtrlSetState($chkComp, FileReadLine($restoreFile,				21))
			GUICtrlSetData($Comp, FileReadLine($restoreFile,					22))
			GUICtrlSetState($chkColl, FileReadLine($restoreFile,				23))
			GUICtrlSetData($Coll, FileReadLine($restoreFile,					24))
			GUICtrlSetData($premium, FileReadLine($restoreFile,					25))
			
			;Vehicle Info 1
			GUICtrlSetData($autoCity[0], FileReadLine($restoreFile,				26))
			GUICtrlSetData($autoZip[0], FileReadLine($restoreFile,				27))
			GUICtrlSetData($autoType[0], FileReadLine($restoreFile,				28))
			GUICtrlSetData($autoYear[0], FileReadLine($restoreFile,				29))
			GUICtrlSetData($autoPrice[0], FileReadLine($restoreFile,			30))
			GUICtrlSetData($autoMake[0], FileReadLine($restoreFile,				31))
			GUICtrlSetData($autoModel[0], FileReadLine($restoreFile,			32))
			GUICtrlSetData($autoVIN[0], FileReadLine($restoreFile,				33))
			GUICtrlSetData($autoCode[0], FileReadLine($restoreFile,				34))
			GUICtrlSetState($chkAutoLiab[0], FileReadLine($restoreFile,			35))
			GUICtrlSetState($chkAutoMed[0], FileReadLine($restoreFile,			36))
			GUICtrlSetState($chkAutoUM[0], FileReadLine($restoreFile,			37))
			GUICtrlSetState($chkAutoComp[0], FileReadLine($restoreFile,			38))
			GUICtrlSetState($chkAutoColl[0], FileReadLine($restoreFile,			39))
			GUICtrlSetState($chkRental[0], FileReadLine($restoreFile,			40))
			GUICtrlSetState($chkLienholder[0], FileReadLine($restoreFile,		41))
			GUICtrlSetData($cmbLienholder[0], FileReadLine($restoreFile,		42))
			
			;Vehicle Info 2
			GUICtrlSetData($autoCity[1], FileReadLine($restoreFile,				43))
			GUICtrlSetData($autoZip[1], FileReadLine($restoreFile,				44))
			GUICtrlSetData($autoType[1], FileReadLine($restoreFile,				45))
			GUICtrlSetData($autoYear[1], FileReadLine($restoreFile,				46))
			GUICtrlSetData($autoPrice[1], FileReadLine($restoreFile,			47))
			GUICtrlSetData($autoMake[1], FileReadLine($restoreFile,				48))
			GUICtrlSetData($autoModel[1], FileReadLine($restoreFile,			49))
			GUICtrlSetData($autoVIN[1], FileReadLine($restoreFile,				50))
			GUICtrlSetData($autoCode[1], FileReadLine($restoreFile,				51))
			GUICtrlSetState($chkAutoLiab[1], FileReadLine($restoreFile,			52))
			GUICtrlSetState($chkAutoMed[1], FileReadLine($restoreFile,			53))
			GUICtrlSetState($chkAutoUM[1], FileReadLine($restoreFile,			54))
			GUICtrlSetState($chkAutoComp[1], FileReadLine($restoreFile,			55))
			GUICtrlSetState($chkAutoColl[1], FileReadLine($restoreFile,			56))
			GUICtrlSetState($chkRental[1], FileReadLine($restoreFile,			57))
			GUICtrlSetState($chkLienholder[1], FileReadLine($restoreFile,		58))
			GUICtrlSetData($cmbLienholder[1], FileReadLine($restoreFile,		59))
			
			;Vehicle Info 3
			GUICtrlSetData($autoCity[2], FileReadLine($restoreFile,				60))
			GUICtrlSetData($autoZip[2], FileReadLine($restoreFile,				61))
			GUICtrlSetData($autoType[2], FileReadLine($restoreFile,				62))
			GUICtrlSetData($autoYear[2], FileReadLine($restoreFile,				63))
			GUICtrlSetData($autoPrice[2], FileReadLine($restoreFile,			64))
			GUICtrlSetData($autoMake[2], FileReadLine($restoreFile,				65))
			GUICtrlSetData($autoModel[2], FileReadLine($restoreFile,			66))
			GUICtrlSetData($autoVIN[2], FileReadLine($restoreFile,				67))
			GUICtrlSetData($autoCode[2], FileReadLine($restoreFile,				68))
			GUICtrlSetState($chkAutoLiab[2], FileReadLine($restoreFile,			69))
			GUICtrlSetState($chkAutoMed[2], FileReadLine($restoreFile,			70))
			GUICtrlSetState($chkAutoUM[2], FileReadLine($restoreFile,			71))
			GUICtrlSetState($chkAutoComp[2], FileReadLine($restoreFile,			72))
			GUICtrlSetState($chkAutoColl[2], FileReadLine($restoreFile,			73))
			GUICtrlSetState($chkRental[2], FileReadLine($restoreFile,			74))
			GUICtrlSetState($chkLienholder[2], FileReadLine($restoreFile,		75))
			GUICtrlSetData($cmbLienholder[2], FileReadLine($restoreFile,		76))
			
			;Vehicle Info 4
			GUICtrlSetData($autoCity[3], FileReadLine($restoreFile,				77))
			GUICtrlSetData($autoZip[3], FileReadLine($restoreFile,				78))
			GUICtrlSetData($autoType[3], FileReadLine($restoreFile,				79))
			GUICtrlSetData($autoYear[3], FileReadLine($restoreFile,				80))
			GUICtrlSetData($autoPrice[3], FileReadLine($restoreFile,			81))
			GUICtrlSetData($autoMake[3], FileReadLine($restoreFile,				82))
			GUICtrlSetData($autoModel[3], FileReadLine($restoreFile,			83))
			GUICtrlSetData($autoVIN[3], FileReadLine($restoreFile,				84))
			GUICtrlSetData($autoCode[3], FileReadLine($restoreFile,				85))
			GUICtrlSetState($chkAutoLiab[3], FileReadLine($restoreFile,			86))
			GUICtrlSetState($chkAutoMed[3], FileReadLine($restoreFile,			87))
			GUICtrlSetState($chkAutoUM[3], FileReadLine($restoreFile,			88))
			GUICtrlSetState($chkAutoComp[3], FileReadLine($restoreFile,			89))
			GUICtrlSetState($chkAutoColl[3], FileReadLine($restoreFile,			90))
			GUICtrlSetState($chkRental[3], FileReadLine($restoreFile,			91))
			GUICtrlSetState($chkLienholder[3], FileReadLine($restoreFile,		92))
			GUICtrlSetData($cmbLienholder[3], FileReadLine($restoreFile,		93))
			
			;Misc
			
		FileClose($restoreFile)
	EndFunc
	Func WritePrefs()
		$prefsFile = FileOpen(@AppDataDir&"\Discover Re Wizzard\prefs.dat", 2) ;open file, erasing contents
				
		;General
		FileWriteLine($prefsFile, GUICtrlRead($Operator))
		FileWriteLine($prefsFile, GUICtrlRead($SlpModfr))
		
		;Window Position
;~ 		$winPos = WinGetPos("Discover Re Wizard")
		
;~ 		FileWriteLine($prefsFile, $winPos[0]) ;x
;~ 		FileWriteLine($prefsFile, $winPos[1]) ;y
		
		FileClose($prefsFile)
	EndFunc
	Func ReadPrefs()
		$prefsFile = FileOpen(@AppDataDir&"\Discover Re Wizzard\prefs.dat", 0) ;open file, read only
		
		If $prefsFile = -1 Then 
			Return
		EndIf
		
		;General
		GUICtrlSetData($Operator, FileReadLine($prefsFile, 1)) 
		GUICtrlSetData($SlpModfr, FileReadLine($prefsFile, 2))
		
;~ 		If FileReadLine($prefsFile, 3) <> -4 And FileReadLine($prefsFile, 4) <> -4 Then
;~ 			WinMove("Discover Re Wizard", "", FileReadLine($prefsFile, 3), FileReadLine($prefsFile, 4),500, 515)
;~ 		EndIf
		FileClose($prefsFile)		
	EndFunc
	Func ClientLookup()
		$input = InputBox("Name", "Enter First and Last Name")

		$dataFile = FileOpen("J:\Public\Discover Re Wizard\clients.dat",0)

		While 1
			$line = FileReadLine($dataFile)
			If @error = -1 Then ExitLoop
			$aryData = StringSplit($line, "	")
			
			$tmpFullName = $aryData[1] &" "& $aryData[3]
			
			;If StringInStr($aryData[3], $input) <> 0 Then
			If $input = $tmpFullName Then
				;$aryData = StringSplit($line, "	")
				
				GUICtrlSetData($fName, $aryData[1])
				GUICtrlSetData($mName, $aryData[2])
				GUICtrlSetData($lName, $aryData[3])

				GUICtrlSetData($address1, $aryData[4])
				GUICtrlSetData($address2, $aryData[5])
				GUICtrlSetData($city, $aryData[6])
				GUICtrlSetData($state, $aryData[7])
				GUICtrlSetData($zip, $aryData[8])
				
				GUICtrlSetData($DLNumber, $aryData[10])
				GUICtrlSetData($effDate, $aryData[11]+1)
				
				If $aryData[13] = "Y" Then GUICtrlSetState ($chkHiredAuto, $GUI_CHECKED)
				
				If $aryData[14] <> "" Then
					GUICtrlSetState($chkLiab, $GUI_CHECKED)
					GUICtrlSetState($chkAutoLiab[0], $GUI_CHECKED)
					GUICtrlSetData($Liab, $aryData[14]/1000)
				Else
					GUICtrlSetState($chkLiab, $GUI_UNCHECKED)
					GUICtrlSetState($chkAutoLiab[0], $GUI_UNCHECKED)
					GUICtrlSetData($Liab, "0")
				EndIf
				If $aryData[15] <> "" Then
					GUICtrlSetState($chkUM, $GUI_CHECKED)
					GUICtrlSetState($chkAutoUM[0], $GUI_CHECKED)
					GUICtrlSetData($UM, $aryData[15]/1000)
				Else
					GUICtrlSetState($chkUM, $GUI_UNCHECKED)
					GUICtrlSetState($chkAutoUM[0], $GUI_UNCHECKED)
					GUICtrlSetData($UM, 0)
				EndIf				
				If $aryData[16] <> "" Then
					GUICtrlSetState($chkComp, $GUI_CHECKED)
					GUICtrlSetState($chkAutoComp[0], $GUI_CHECKED)
					GUICtrlSetData($Comp, $aryData[16])
				Else
					GUICtrlSetState($chkComp, $GUI_UNCHECKED)
					GUICtrlSetState($chkAutoComp[0], $GUI_UNCHECKED)
					GUICtrlSetData($Comp, "0")
				EndIf				
				If $aryData[17] <> "" Then
					GUICtrlSetState($chkColl, $GUI_CHECKED)
					GUICtrlSetState($chkAutoColl[0], $GUI_CHECKED)
					GUICtrlSetData($Coll, $aryData[17])
				Else
					GUICtrlSetState($chkColl, $GUI_UNCHECKED)
					GUICtrlSetState($chkAutoColl[0], $GUI_UNCHECKED)
					GUICtrlSetData($Coll, "0")
				EndIf
				
				GUICtrlSetData($autoCity[0], $aryData[6])
				GUICtrlSetData($autoZip[0], $aryData[8])
				GUICtrlSetData($autoYear[0], StringRight($aryData[18],2))
				GUICtrlSetData($autoMake[0], $aryData[19])
				GUICtrlSetData($autoModel[0], $aryData[20])
				GUICtrlSetData($autoVIN[0], $aryData[21])
				If $aryData[22] <> "" Then
					GUICtrlSetData($cmbLienholder[0], $aryData[22])
					GUICtrlSetState($chkLienholder[0], $GUI_CHECKED)
				Else
					GUICtrlSetData($cmbLienholder[0], "None")
					GUICtrlSetState($chkLienholder[0], $GUI_UNCHECKED)
				EndIf
				
				ExitLoop
			EndIf
			
		Wend
	EndFunc
	Func ReadConsoleText($x1, $y1, $x2, $y2)
		BlockInput(1)
		SetActiveWindow($wndDiscoverRe)
		ClipPut("")
		
		MouseClickDrag("left", $x1, $y1, $x2, $y2, 1)
		Sleep( ($SlpModfr*15) + 100)
		MouseClick("right")
		
		Sleep( ($SlpModfr*15) + 100)
		$buff = ClipGet()
		$buff = StringStripWS($buff, 1)
		$buff = StringStripWS($buff, 2)
		
		Sleep( ($SlpModfr*15) + 100)
		
		BlockInput(0)
		Return $buff

	EndFunc
	Func Validation()
	$dataError = ""
	$errorCode = 0
	
		;General Settings
		$dataError = $dataError & "General Settings: " & @CR 
		If StringLen(GUICtrlRead($Operator)) <> 2 Then 
			$dataError = $dataError & "Operator must contain only 2 characters."
			$errorCode = -1
		EndIf
		
		;Common Info Settings
		$dataError = $dataError &@CR&@CR& "Common Info:" & @CR
		If GUICtrlRead($city) = "" Then 
			$dataError = $dataError  & "You must enter a city"
			$errorCode = -1
		EndIf
		If GUICtrlRead($state) = "" Then 
			$dataError = $dataError & @CR & "You must enter a state"
			$errorCode = -1
		EndIf
		If GUICtrlRead($zip) = "" Then 
			$dataError = $dataError & @CR & "You must enter a zip code"
			$errorCode = -1
		EndIf
		If StringLen(GUICtrlRead($state)) <> 2 Then	
			$dataError = $dataError & @CR & "Improper State Format"
			$errorCode = -1
		EndIf
		If Stringlen(GUICtrlRead($zip)) <> 5 Or StringIsDigit(GUICtrlRead($zip)) = 0 Then 
			$dataError = $dataError & @CR & "Improper Zip Code Format"
			$errorCode = -1
		EndIf
		If GUICtrlRead($effDate) = "" Then 
			$dataError = $dataError & @CR & "You must enter an effective date"
			$errorCode = -1
		EndIf
		If Stringlen(GUICtrlRead($effDate)) <> 6 Or StringIsDigit(GUICtrlRead($effDate)) = 0 Then 
			$dataError = $dataError & @CR & "Improper effective date format(MMDDYYYY)"
			$errorCode = -1
		EndIf
		If GUICtrlRead($dealerType) = "" Then 
			$dataError = $dataError & @CR & "You must enter a dealer type"
			$errorCode = -1
		EndIf
		
		If 	GUICtrlRead($state) = "ar" Or GUICtrlRead($state) = "az" Or GUICtrlRead($state) = "co" Or GUICtrlRead($state) = "ct" Or _
			GUICtrlRead($state) = "dc" Or GUICtrlRead($state) = "fl" Or GUICtrlRead($state) = "ga" Or GUICtrlRead($state) = "ks" Or _
			GUICtrlRead($state) = "ky" Or GUICtrlRead($state) = "la" Or GUICtrlRead($state) = "ma" Or GUICtrlRead($state) = "md" Or _
			GUICtrlRead($state) = "me" Or GUICtrlRead($state) = "nc" Or GUICtrlRead($state) = "nm" Or GUICtrlRead($state) = "nv" Or _
			GUICtrlRead($state) = "ny" Or GUICtrlRead($state) = "or" Or GUICtrlRead($state) = "pa" Or GUICtrlRead($state) = "ut" Or _
			GUICtrlRead($state) = "va" Then
			If GUICtrlRead($DLNumber) = "" Then
				$dataError = $dataError & @CR & "You must enter a driver's license number for this state."
				$errorCode = -1
			EndIf
			If GUICtrlRead($DOB) = "" Then
				$dataError = $dataError & @CR & "You must enter a date of birth for this state."
				$errorCode = -1
			EndIf
		EndIf

		;Vehicle One Info
		$dataError = $dataError &@CR&@CR& "Vehicle One:" & @CR
		If GUICtrlRead($autoCity[0]) = "" Then 
			$dataError = $dataError & "You must enter a city"
			$errorCode = -1
		EndIf
		If GUICtrlRead($autoZip[0]) = "" Then 
			$dataError = $dataError & @CR & "You must enter a zip code"
			$errorCode = -1
		EndIf
		If Stringlen(GUICtrlRead($autoZip[0])) <> 5 Or StringIsDigit(GUICtrlRead($autoZip[0])) = 0 Then 
			$dataError = $dataError & @CR & "Improper Zip Code Format"
			$errorCode = -1
		EndIf
		If GUICtrlRead($autoType[0]) = "" Then 
			$dataError = $dataError & @CR & "You must enter a vehicle type"
			$errorCode = -1
		EndIf
		If GUICtrlRead($autoYear[0]) = "" Then 
			$dataError = $dataError & @CR & "You must enter a year"
			$errorCode = -1
		EndIf
		If Stringlen(GUICtrlRead($autoYear[0])) <> 2 Or StringIsDigit(GUICtrlRead($autoYear[0])) = 0 Then 
			$dataError = $dataError & @CR & "Improper effective date format(YY)"
			$errorCode = -1
		EndIf
		If GUICtrlRead($autoPrice[0]) = "" Then 
			$dataError = $dataError & @CR & "You must enter a vehicle price"
			$errorCode = -1
		EndIf
		If StringIsDigit(GUICtrlRead($autoPrice[0])) = 0 Then 
			$dataError = $dataError & @CR & "Improper price format"
			$errorCode = -1
		EndIf
		If GUICtrlRead($autoMake[0]) = "" Then 
			$dataError = $dataError & @CR & "You must enter a vehicle make"
			$errorCode = -1
		EndIf
		If GUICtrlRead($autoCode[0]) = "" Then 
			$dataError = $dataError & @CR & "You must enter a vehicle code"
			$errorCode = -1
		EndIf

		;Vehicle Two Info
		If GUICtrlRead($autoZip[1]) <> "" Then
			$dataError = $dataError &@CR&@CR& "Vehicle Two:" & @CR
			If GUICtrlRead($autoCity[1]) = "" Then 
				$dataError = $dataError & "You must enter a city"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoZip[1]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a zip code"
				$errorCode = -1
			EndIf
			If Stringlen(GUICtrlRead($autoZip[1])) <> 5 Or StringIsDigit(GUICtrlRead($autoZip[1])) = 0 Then 
				$dataError = $dataError & @CR & "Improper Zip Code Format"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoType[1]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a vehicle type"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoYear[1]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a year"
				$errorCode = -1
			EndIf
			If Stringlen(GUICtrlRead($autoYear[1])) <> 2 Or StringIsDigit(GUICtrlRead($autoYear[1])) = 0 Then 
				$dataError = $dataError & @CR & "Improper effective date format(YY)"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoPrice[1]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a vehicle price"
				$errorCode = -1
			EndIf
			If StringIsDigit(GUICtrlRead($autoPrice[1])) = 0 Then 
				$dataError = $dataError & @CR & "Improper price format"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoMake[1]) = "" Then
				$dataError = $dataError & @CR & "You must enter a vehicle make"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoCode[1]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a vehicle code"
				$errorCode = -1
			EndIf
		EndIf

		;Vehicle Three Info
		If GUICtrlRead($autoZip[2]) <> "" Then
			$dataError = $dataError &@CR&@CR& "Vehicle Three:" & @CR
			If GUICtrlRead($autoCity[2]) = "" Then 
				$dataError = $dataError & "You must enter a city"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoZip[2]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a zip code"
				$errorCode = -1
			EndIf
			If Stringlen(GUICtrlRead($autoZip[2])) <> 5 Or StringIsDigit(GUICtrlRead($autoZip[2])) = 0 Then 
				$dataError = $dataError & @CR & "Improper Zip Code Format"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoType[2]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a vehicle type"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoYear[2]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a year"
				$errorCode = -1
			EndIf
			If Stringlen(GUICtrlRead($autoYear[2])) <> 2 Or StringIsDigit(GUICtrlRead($autoYear[2])) = 0 Then 
				$dataError = $dataError & @CR & "Improper effective date format(YY)"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoPrice[2]) = "" Then
				$dataError = $dataError & @CR & "You must enter a vehicle price"
				$errorCode = -1
			EndIf
			If StringIsDigit(GUICtrlRead($autoPrice[2])) = 0 Then 
				$dataError = $dataError & @CR & "Improper price format"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoMake[2]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a vehicle make"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoCode[2]) = "" Then
				$dataError = $dataError & @CR & "You must enter a vehicle code"
				$errorCode = -1
			EndIf
		EndIf

		;Vehicle Four Info
		If GUICtrlRead($autoZip[3]) <> "" Then
			$dataError = $dataError &@CR&@CR& "Vehicle Four:" & @CR
			If GUICtrlRead($autoCity[3]) = "" Then 
				$dataError = $dataError & "You must enter a city"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoZip[3]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a zip code"
				$errorCode = -1
			EndIf
			If Stringlen(GUICtrlRead($autoZip[3])) <> 5 Or StringIsDigit(GUICtrlRead($autoZip[3])) = 0 Then 
				$dataError = $dataError & @CR & "Improper Zip Code Format"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoType[3]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a vehicle type"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoYear[3]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a year"
				$errorCode = -1
			EndIf
			If Stringlen(GUICtrlRead($autoYear[3])) <> 2 Or StringIsDigit(GUICtrlRead($autoYear[3])) = 0 Then 
				$dataError = $dataError & @CR & "Improper effective date format(YY)"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoPrice[3]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a vehicle price"
				$errorCode = -1
			EndIf
			If StringIsDigit(GUICtrlRead($autoPrice[3])) = 0 Then 
				$dataError = $dataError & @CR & "Improper price format"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoMake[3]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a vehicle make"
				$errorCode = -1
			EndIf
			If GUICtrlRead($autoCode[3]) = "" Then 
				$dataError = $dataError & @CR & "You must enter a vehicle code"
				$errorCode = -1
			EndIf
		EndIf

		;Non-required
	
		If $errorCode = -1 Then
			MsgBox(0,"Error - Data Validation", $dataError)
			Return -1
		Else
			Return 0
		EndIf
	EndFunc
#endregion --------------------  FUNCTION LIST  ------------------------
#region ------------------------  SCRIPT LIST  -------------------------
Func CommonInfo()

	SetActiveWindow($wndDiscoverRe)
	;Get to common info screen
	Send("{DOWN}{ENTER}")
	Send("{DOWN}{ENTER}")

	;Start entering data
	Send(GUICtrlRead($lName) & ", " & GUICtrlRead($fName) & "{SPACE}" & GUICtrlRead($mName) & "{ENTER}")
	Sleep( ($SlpModfr*50) + 350 + ($SlpModfr * 5))
	Send(GUICtrlRead($address1) & "{ENTER}")
	Send(GUICtrlRead($address2) & "{ENTER}")
	Send(GUICtrlRead($city) & "{ENTER}")
	Send(GUICtrlRead($state) & "{ENTER}")
	Send(GUICtrlRead($zip) & "{ENTER}")
	Send(GUICtrlRead($city) & "{ENTER}")
	Send(GUICtrlRead($dealerType) & "{ENTER}")
	Send("{DOWN}{ENTER}")
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Send(GUICtrlRead($effDate) & "06{ENTER}")
	Send("47" & "{ENTER}")
	Send("6" & "{ENTER}")
	Send("n" & "{ENTER}")
	Send(GUICtrlRead($state) & "{ENTER}")

	If $formattedState = "or" Then Send("10{ENTER}") ;oregon
	If $formattedState = "ky" Then Send("{DOWN}{ENTER}{ENTER}{UP}{ENTER}")  ;kentucky

	Send(GUICtrlRead($Operator) & "{ENTER}")
	Send(GUICtrlRead($Operator) & "{ENTER}")
	Send("0000303" & "{ENTER}" &"{ENTER}")
	Send("Y" & "{ENTER}")
	Send("15." & "{ENTER} & {ENTER}")

	;next screen
	Send("N")
EndFunc
Func PolicyInfo()
	;Liability
	If GUICtrlRead($chkLiab) = 1 Then
		Send("7")
		If GUICtrlRead($chkHiredAuto) = 1 Then Send(",8")
		Send("{ENTER}{ENTER}" & GUICtrlRead($Liab) & "{ENTER}{ENTER}");liab
	Else
		Send("{ENTER}{ENTER}" & GUICtrlRead($Liab) & "{ENTER}{ENTER}");liab
	EndIf

	;PIP
	If GUICtrlRead($chkPIP) = 1 Then
		If $formattedState = "tx" Then
			Send("7")
			Send("{ENTER}");pip (w/o addtional)
		Else
			Send("7")
			Send("{ENTER}{ENTER}");pip
		EndIf
	Else
		Send("{ENTER}")
	EndIf

	;Med Pay
	If GUICtrlRead($chkMed) = 1 Then
		Send("7")
		Send("{ENTER}" & GUICtrlRead($Med) & "{ENTER}");med
	Else
		Send("{ENTER}")
	EndIf

	;Uninsured Motorist
	If GUICtrlRead($chkUM) = 1 Then
		Send("7")
		Send("{ENTER}")
	Else
		Send("{ENTER}{ENTER}")
	EndIf

	;Comp
	If GUICtrlRead($chkComp) = 1 Then
		Send("7")
		If GUICtrlRead($chkHiredAuto) = 1 Then Send(",8")
		Send("{ENTER}" & GUICtrlRead($Comp) & "{ENTER}");comp
		If $formattedState = "ma" Then
			;Do nothing
		Else
			Send("{ENTER}") ; s/p symbol
		EndIf
	Else
		Send("{ENTER}{ENTER}")
	EndIf

	;Collision
	If GUICtrlRead($chkColl) = 1 Then
		Send("7")
		If GUICtrlRead($chkHiredAuto) = 1 Then Send(",8")
		Send("{ENTER}" & GUICtrlRead($Coll) & "{ENTER}{ENTER}");coll
	Else
		Send("{ENTER}{ENTER}")
	EndIf

	Send(GUICtrlRead($fleet) & "{ENTER}");fleet

	Send("{ENTER}{ENTER}N");next screen
EndFunc
Func AutoInfo()
	SetActiveWindow($wndDiscoverRe)
	Send("{ENTER}" & GUICtrlRead($autoZip[0]) & "{ENTER}") ;zip

	If ReadConsoleText(175,160,430,160) = "COMMUNITY NAMES" Then
		If ReadConsoleText(175,215,430,215) = GUICtrlRead($autoCity[0]) Then 
			Send("{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,235,430,235) = GUICtrlRead($autoCity[0]) Then
			Send("{DOWN}{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,255,430,255) = GUICtrlRead($autoCity[0]) Then
			Send("{DOWN}{DOWN}{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,275,430,275) = GUICtrlRead($autoCity[0]) Then
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,295,430,295) = GUICtrlRead($autoCity[0]) Then
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,315,430,315) = GUICtrlRead($autoCity[0]) Then
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
		Else
			MsgBox(0,"Error", "Could not find city, please select it manually and click OK to continue")
		EndIf
	EndIf

	$_buffCity = ReadConsoleText(550,125,760,130)
	$_buffZip  = ReadConsoleText(180,160,220,170)
	If StringLower($_buffCity) <> StringLower(GUICtrlRead($autoCity[0])) Then
		MsgBox(32, "Verification", "City: " & $_buffCity)
	EndIf
	If StringLower($_buffZip) <> StringLower(GUICtrlRead($autoZip[0])) Then
		MsgBox(32, "Verification", "Zip: "&$_buffZip)
	EndIf

	If $formattedState = "ma" Then
		Send("{ENTER}") ;type of policy
	EndIf

	SetActiveWindow($wndDiscoverRe)
	Sleep( ($SlpModfr*50) + 150)
	Send("{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}")
	Send("{ENTER}") ;move to hired auto (if no hired auto, moves to PIP or UM)

	If GUICtrlRead($chkHiredAuto) = 1 Then
		Sleep( ($SlpModfr*50) + 750)
		Send("y{ENTER}")
		Send("acv{ENTER}")
		Send("100{ENTER}")
		Send("acv{ENTER}")
		Send("500{ENTER}")		;Send(GUICtrlRead($Coll)"{ENTER}")
		If $formattedState = "tx" Then
			Send("{ENTER}")
		EndIf
		Send("1{ENTER}")
		Send("if{SPACE}any{ENTER}")
		Send("10{ENTER}")
		Send("1{ENTER}")
		Send("if{SPACE}any{ENTER}")
		Send("15{ENTER}")
	EndIf
	
	If GUICtrlRead($chkPIP) = 1 Then
;~ 		If  $formattedState = "de" Or $formattedState = "fl" Or $formattedState = "hi" Or _
;~ 			$formattedState = "ks" Or $formattedState = "ky" Or $formattedState = "md" Or _
;~ 			$formattedState = "ma" Or $formattedState = "mi" Or $formattedState = "mn" Or _
;~ 			$formattedState = "ny" Or $formattedState = "nd" Or $formattedState = "pa" Or _
;~ 			$formattedState = "sd" Or $formattedState = "tx" Or $formattedState = "ut" Or _
;~ 			$formattedState = "wa" Then
		If  $formattedState = "de" Or _
			$formattedState = "ks" Or $formattedState = "ky" Or $formattedState = "md" Or _
			$formattedState = "ma" Or $formattedState = "mi" Or $formattedState = "mn" Or _
			$formattedState = "nd" Or $formattedState = "pa" Or _
			$formattedState = "sd" Or $formattedState = "ut" Or _
			$formattedState = "wa" Then
				MsgBox(64, "Manual Entry", "Manual entry is required for this PIP section."&@CR&"Please click OK when finished")
		ElseIf $formattedState = "nj" Then
			MsgBox(64, "Manual Entry", "Manual entry is required for this PIP section."&@CR&"Please click OK when finished")
		EndIf
	EndIf
	
	SetActiveWindow($wndDiscoverRe)
	Send("{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}")
	Sleep( ($SlpModfr*50) + 750)

	;*******  UM  ************
	Select
		Case $formattedState = "ak" Or $formattedState = "ar" Or _
			 $formattedState = "in" Or $formattedState = "oh" Or _
			 $formattedState = "ri"
			Send("2{ENTER}")
			Send(GUICtrlRead($UM)&"{ENTER}")
			Send("y")
			Send("{ENTER}")
			Send("{ENTER}")

		Case  $formattedState = "al" Or $formattedState = "co" Or _
			  $formattedState = "ks" Or $formattedState = "md" Or _
			  $formattedState = "me" Or $formattedState = "mi" Or _
			  $formattedState = "mt" Or $formattedState = "ne" Or _
			  $formattedState = "nh" Or $formattedState = "nj" Or _
			  $formattedState = "nv" Or $formattedState = "ny" Or _
			  $formattedState = "ok" Or $formattedState = "vt" Or _
			  $formattedState = "wy"
			Send("1{ENTER}")
			Send(GUICtrlRead($UM)&"{ENTER}")
			Send("y")

		Case  $formattedState = "az" Or $formattedState = "ct" Or _
			  $formattedState = "fl" Or $formattedState = "id" Or _
			  $formattedState = "ia" Or $formattedState = "ky" Or _
			  $formattedState = "mo" Or $formattedState = "nc" Or _
			  $formattedState = "nd" Or $formattedState = "nm" Or _
			  $formattedState = "sc" Or $formattedState = "sd" Or _
			  $formattedState = "va" Or $formattedState = "wi" Or _
			  $formattedState = "de" Or $formattedState = "tx"
			Send("1{ENTER}")
			Send(GUICtrlRead($UM)&"{ENTER}")
			Send("y{ENTER}")

		Case  $formattedState = "ca" Or $formattedState = "il"  Or _
			  $formattedState = "or" Or $formattedState = "tn"  Or _
			  $formattedState = "wa"
			Send("2{ENTER}")
			Send(GUICtrlRead($UM)&"{ENTER}")
			Send("y{ENTER}")

		Case  $formattedState = "ga"
			Send("1{ENTER}")
			Send(GUICtrlRead($UM)&"{ENTER}")
			Send("y{ENTER}")
			Send("1{ENTER}")

		Case  $formattedState = "pa" Or $formattedState = "mn"
			Send("1{ENTER}")
			Send(GUICtrlRead($UM)&"{ENTER}")
			Send("y{ENTER}{ENTER}")

		Case  $formattedState = "la"
			Send("2{ENTER}")
			Send(GUICtrlRead($UM)&"{ENTER}")
			Send("y{ENTER}{ENTER}")

		Case  $formattedState = "ms"
			Send("2{ENTER}")
			Send(GUICtrlRead($UM)&"{ENTER}")
			Send("y{ENTER}")
			Send("y{ENTER}")
			
		Case  $formattedState = "wv"
			Send("1{ENTER}")
			Send(GUICtrlRead($UM)&"{ENTER}{ENTER}")
		
	Case $formattedState = "ut"
			Send("2{ENTER}{SPACE}")
			Send(GUICtrlRead($UM)&"{ENTER}")
			Send("y{ENTER}{ENTER}")
			
		Case  $formattedState = "ma"
			MsgBox(64,"Manual Entry", "Manual entry required for UM/UIM section of this state")
	
		Case Else
			MsgBox(32,"","What state is this?")
			SetActiveWindow($wndDiscoverRe)
	EndSelect

	Send("{ENTER}")
	Send("{ENTER}")
	Send("{ENTER}")
	Send("{ENTER}")
	Send("2{ENTER}{ENTER}") ;start at tier 2

	SetActiveWindow($wndDiscoverRe)
	Send("{ENTER}") ;next screen
EndFunc
Func VehicleInfo($i)
	SetActiveWindow($wndDiscoverRe)
	Send("{ENTER}")
	Send(GUICtrlRead($autoZip[$i]))
	Send("{ENTER}")

	If ReadConsoleText(175,160,430,160) = "COMMUNITY NAMES" Then
		If ReadConsoleText(175,215,430,215) = GUICtrlRead($city) Then 
			Send("{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,235,430,235) = GUICtrlRead($city) Then
			Send("{DOWN}{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,255,430,255) = GUICtrlRead($city) Then
			Send("{DOWN}{DOWN}{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,275,430,275) = GUICtrlRead($city) Then
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,295,430,295) = GUICtrlRead($city) Then
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
		ElseIf ReadConsoleText(175,315,430,315) = GUICtrlRead($city) Then
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
		Else
			MsgBox(0,"Error", "Could not find city, please select it manually and click OK to continue")
		EndIf
	EndIf

	$_buffTer  = ReadConsoleText(680,180,700,185)
	If StringLower($_buffTer) = "" Then
		MsgBox(32, "Verification", "Please verify city have been entered correctly.")
	EndIf
	Sleep( ($SlpModfr*50) + 150)
	
	SetActiveWindow($wndDiscoverRe)
	Send("{DOWN}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}")
	Send(GUICtrlRead($autoType[$i]) & "{ENTER}")
	Send(GUICtrlRead($autoYear[$i]) & "{ENTER}")
	Send(GUICtrlRead($autoMake[$i]) & "{ENTER}")
	Send(GUICtrlRead($autoModel[$i]) & "{ENTER}")
	Send(GUICtrlRead($autoVIN[$i]) & "{ENTER}")
	Send(GUICtrlRead($autoCode[$i]) & "{ENTER}")
	Send("{ENTER}")		;dump operator (answers no)
	If $formattedState = "ma" Then 
		Send("9{ENTER}") ;pre-inspection
	EndIf
	If $formattedState = "ri" Then 
		Send("7{ENTER}") ;pre-inspection
	EndIf
	If $formattedState = "ny" Or $formattedState = "sc" Or $formattedState = "wa" Then 
		Send("{ENTER}")
	EndIf
	If $formattedState = "mn" Then
		Send("{ENTER}{ENTER}")
	EndIf
	If $formattedState = "mi" Then 
		Send("{ENTER}")
	EndIf
	If $formattedState = "nd" Then ;removed "mi", may need to add it again - if so, remove above if statement
		MsgBox(64,"Manual Entry", "Manual entry is required for the rest of the" &@CR& "Vehicle Class Code Information screen." &@CR& "Click OK to continue")
	EndIf
	SetActiveWindow($wndDiscoverRe)
	Send("N")		;next screen
	Sleep( ($SlpModfr*50) + 500)
	;**************  OPTIONS  ******************
	SetActiveWindow($wndDiscoverRe)
	;Liability
	If GUICtrlRead($chkAutoLiab[$i]) = 1 Then
		Send("y{ENTER}")
		If $formattedState = "fl" Or $formattedState = "ky" Or $formattedState = "md" Or $formattedState = "ny" Then 
			Send("{ENTER}") ;oper
		ElseIf $formattedState = "ma" Then
			Send("y{ENTER}")
		ElseIf $formattedState = "mn" Then
			Send("y{ENTER}{ENTER}")
		EndIf
		If $formattedState = "ks" Then
			If GUICtrlRead($chkPIP) = 1 Then 
				Send("y{ENTER}{ENTER}")
			Else
				Send("n{ENTER}")
			EndIf
		EndIf
	Else
		Send("n{ENTER}")
		If $formattedState = "fl" Then Send("{ENTER}") ;oper
	EndIf

	;Med
	If GUICtrlRead($chkAutoMed[$i]) = 1 Then
		Send("y{ENTER}")
	Else
		Send("n{ENTER}")
	EndIf

	;UM
	If GUICtrlRead($chkAutoUM[$i]) = 1 Then
		Send("y{ENTER}")
		If $formattedState = "ks" Or $formattedState = "md" Or $formattedState = "mn" Or $formattedState = "tx" Or $formattedState = "wa"  Or $formattedState = "ut" Then 
			Send("y{ENTER}") ;individual/couple
		EndIf
	Else
		Send("n{ENTER}")
	EndIf
	
	If $formattedState = "ny" Then
		If GUICtrlRead($chkHiredAuto) = 1 Then
			Send("y{ENTER}")
		Else
			Send("n{ENTER}")
		EndIf
	EndIf

	;Comp
	If GUICtrlRead($chkAutoComp[$i]) = 1 Then
		Send("y{ENTER}")
		Send("a{ENTER}");hire valuation
		Send(GUICtrlRead($autoPrice[$i]) & "{ENTER}")
		If $formattedState = "ky" Or $formattedState = "ct" Or $formattedState = "la" Or $formattedState = "ri" Then 
			Send("{ENTER}")
		EndIf
		If $formattedState = "ma" Then Send("{ENTER}{ENTER}")
		If $formattedState = "mn" Then Send("{ENTER}")
	Else
		Send("n{ENTER}")
	EndIf

	;Coll
	If GUICtrlRead($chkAutoColl[$i]) = 1 Then
		Send("y{ENTER}")
		Send("a{ENTER}");hire valuation
		If $formattedState = "ma" Then Send("{ENTER}{ENTER}")
		If $formattedState = "mi" Then Send("1{ENTER}")
	Else
		Send("n{ENTER}")
	EndIf

	;Lienholder
	If $formattedState = "ny" Then Send("{ENTER}")
	If GUICtrlRead($chkAutoLiab[$i]) = 1 Then
		If GUICtrlRead($chkLienholder[$i]) = 1 Then
			Send("y{ENTER}")
		Else
			Send("n{ENTER}")
		EndIf
	EndIf
	
	;Rental
	If GUICtrlRead($chkRental[$i]) = 1 Then
		Send("y{ENTER}")
		Send("{DOWN}{ENTER}")
		Send("{ENTER}60{ENTER}60{ENTER}n")
		Send("{ENTER}")
	Else
		Send("n{ENTER}")
	EndIf

	Send("{SPACE}");..press any key to continue
EndFunc
Func AddVehicles()
	AmountOfVehicles()

	If GUICtrlRead($autoZip[0]) = "" Then
		;Do nothing because of stupid If Not String bug
	Else
		VehicleInfo(0)
	EndIf


	If GUICtrlRead($autoZip[1]) = "" Then
		;Do nothing because of stupid If Not String bug
	Else
		SetActiveWindow($wndDiscoverRe)
		Send("n")
		Sleep( ($SlpModfr*50) + 1000)
		Send("{ENTER}")
		VehicleInfo(1)
	EndIf

	If GUICtrlRead($autoZip[2]) = "" Then
		;Do nothing because of stupid If Not String bug
	Else
		SetActiveWindow($wndDiscoverRe)
		Send("n")
		Sleep( ($SlpModfr*50) + 1000)
		Send("{ENTER}")
		VehicleInfo(2)
	EndIf

	If GUICtrlRead($autoZip[3]) = "" Then
		;Do nothing because of stupid If Not String bug
	Else
		SetActiveWindow($wndDiscoverRe)
		Send("n")
		Sleep( ($SlpModfr*50) + 1000)
		Send("{ENTER}")
		VehicleInfo(3)
	EndIf

	;Rate policy
	Send("r")

EndFunc
Func ChangeTier($t)
	SetActiveWindow($wndDiscoverRe)

	Send("{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{SPACE}c12{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{ENTER}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send($t)
	Send("{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{SPACE}{ENTER}r")
	Sleep( ($SlpModfr*50) + 100)
	
	SetActiveWindow($wndRateWindow)
EndFunc
Func ReChangeTier($t)
	SetActiveWindow($wndDiscoverRe)

	Send("{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{SPACE}c12{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{ENTER}{ENTER}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send($t)
	Send("{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{SPACE}{ENTER}r")
	Sleep( ($SlpModfr*50) + 100)
	
	SetActiveWindow($wndRateWindow)
EndFunc
Func ChangeMod($m)
	SetActiveWindow($wndDiscoverRe)

	Send("{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{SPACE}c12{ENTER}y{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 750)
	Send("{ENTER}" & $m)
	Sleep( ($SlpModfr*50) + 100)
	Send("{ENTER}{ENTER}{ENTER}{ENTER}")
	Sleep( ($SlpModfr*50) + 500)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 750)
	Send("{ENTER}" & $m)
	Sleep( ($SlpModfr*50) + 100)
	Send("{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{SPACE}{ENTER}r")
	
	SetActiveWindow($wndRateWindow)
EndFunc
Func ReChangeMod($m)
	SetActiveWindow($wndDiscoverRe)

	Send("{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{SPACE}c12{ENTER}y{ENTER}")
	Sleep( ($SlpModfr*50) + 100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 750)
	Send("c1{ENTER}{ENTER}")
	Send($m)
	Sleep( ($SlpModfr*50) + 100)
	Send("{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}")
	Sleep( ($SlpModfr*50) + 500)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep( ($SlpModfr*50) + 750)
	Send("c1{ENTER}{ENTER}")
	Send($m)
	Sleep( ($SlpModfr*50) + 100)
	Send("{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{SPACE}{ENTER}r")
	
	SetActiveWindow($wndRateWindow)
EndFunc
Func LookUpName()
	SetActiveWindow($wndDiscoverRe)	

	Send("{DOWN}{DOWN}{ENTER}")
	Send(GUICtrlRead($lName) & ", " & GUICtrlRead($fName) & "{SPACE}" & GUICtrlRead($mName) & "{ENTER}")

	$OK = -1
	Do
		Sleep( ($SlpModfr*50) + 1500)
		$dialog = ReadConsoleText(587,409,782,423)
		
		If StringInStr($dialog, "OUTPUT") Then $dialog = 7
		;MsgBox(0,"","Proceeding")
		
		SetActiveWindow($wndDiscoverRe)
		If $dialog = 7 Then ;no
			;loop
			Send("{DOWN}")
			Sleep( ($SlpModfr*50) + 300)
			Send("{UP}")
		Else
			;continue
			Send("{ENTER}")
			$OK = 0
		EndIf
	Until $OK = 0
EndFunc
Func Issue()
	
	If $formattedState = "ny" Then 
		Send("{SPACE}")
		Sleep( ($SlpModfr*50) + 100)
	EndIf
	
	LookUpName()

	SetActiveWindow($wndDiscoverRe)

	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

	;Generate Policy Number
	Send("d{ENTER}")
	Send("d{ENTER}")
	Send("{ENTER}")
	Send("c11{ENTER}")
	Send("277{ENTER}");test with 999
	Send("a{ENTER}")
	Send("g{ENTER}")
	Sleep( ($SlpModfr*50) + 2500)

;	MsgBox(48,"Policy Number", "Please record the generated policy number, and click OK.")
	TrayTip("Client Detail", "Rated Premium: "&$ratedPremium&@CR&"Mod: "&$modification&@CR&"Tier: "&$tierLevel&@CR&"Final Premium: "&$finalPremium&@CR&"Policy Number: "&$genPolNum,30)

	
	$genPolNum = ReadConsoleText(218,320,315,333)
	;$genPolNum = InputBox("Policy Number", "Please enter the generated policy number.",$tmpPolNum)
	SetActiveWindow($wndDiscoverRe)

	Send("{ENTER}")
	Send("p{ENTER}")
	Send("{ESC}")
	Send("{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}")
	Send("1{ENTER}{ENTER}{ENTER}")
	Send("{DOWN}{ENTER}")
	Send("{DOWN}{DOWN}{ENTER}")
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Send("{ENTER}{ENTER}n")
	Sleep( ($SlpModfr*50) + 3000)

	Send("{DOWN}{DOWN}{ENTER}")
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Send("10{ENTER}")
	Send("0{ENTER}")
	Sleep( ($SlpModfr*50) + 500)

	Send("{ENTER}")
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Send("5251{ENTER}")
	Send("{ENTER}")
EndFunc
Func DMVReporting()
	SetActiveWindow($wndDiscoverRe)
	
	;move to DMV Reporting
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	
		For $i = 1 to $NumberOfVehicles

			For $j = 1 to $i   ;Select vehicle
				Send("{DOWN}")
			Next
		
			Send("{ENTER}")    ;Goto info screen

			If 	GUICtrlRead($state) = "ar" Or GUICtrlRead($state) = "az" Or GUICtrlRead($state) = "co" Or GUICtrlRead($state) = "ct" Or _
				GUICtrlRead($state) = "dc" Or GUICtrlRead($state) = "fl" Or GUICtrlRead($state) = "ga" Or GUICtrlRead($state) = "ks" Or _
				GUICtrlRead($state) = "ky" Or GUICtrlRead($state) = "la" Or GUICtrlRead($state) = "ma" Or GUICtrlRead($state) = "md" Or _
				GUICtrlRead($state) = "me" Or GUICtrlRead($state) = "nc" Or GUICtrlRead($state) = "nm" Or GUICtrlRead($state) = "nv" Or _
				GUICtrlRead($state) = "ny" Or GUICtrlRead($state) = "or" Or GUICtrlRead($state) = "pa" Or GUICtrlRead($state) = "ut" Or _
				GUICtrlRead($state) = "va" Then

			   Send("{ENTER}1{ENTER}")
			   Send("n{ENTER}")
			   Send(GUICtrlRead($lName) & "{ENTER}")
			   Send(GUICtrlRead($fName) & "{ENTER}")
			   Send(GUICtrlRead($mName) & "{ENTER}")
			   Send(GUICtrlRead($address1) & "{ENTER}")
			   Send(GUICtrlRead($address2) & "{ENTER}")
			   Send(GUICtrlRead($city) & "{ENTER}")
			   Send(GUICtrlRead($state) & "{ENTER}")
			   Send(GUICtrlRead($zip) & "{ENTER}n")
			   Send(GUICtrlRead($dlNumber) & "{ENTER}")
			   
			    If $formattedState = "md" Then
				   Send(GUICtrlRead($state)&"{ENTER}")
				EndIf
			   
			   Send(GUICtrlRead($DOB) & "{ENTER}")

				If $formattedState = "ny" Then
						Send("m{ENTER}")
						Send("2{ENTER}") ;2-commercial 3-hired auto
				EndIf

			   Send("{ENTER}n")

			Else  ;DMV reporting not required
				Send("{ENTER}{ENTER}{ENTER}")
			EndIf

		Next

		Send("{ENTER}")  ;quit
EndFunc
Func AutoForm()
	SetActiveWindow($wndDiscoverRe)

	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Send("{DOWN}{DOWN}{ENTER}")

	If GUICtrlRead($chkLienholder[0]) = 1 Or GUICtrlRead($chkLienholder[1]) = 1  Or GUICtrlRead($chkLienholder[2]) = 1  Or GUICtrlRead($chkLienholder[3]) = 1 Then
		Send("{DOWN}")
	EndIf

	Select
		Case  $formattedState = "al"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ak"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)

		Case  $formattedState = "az"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ar"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ca"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "co"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ct"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "de"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)

		Case  $formattedState = "fl"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ga"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "id"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)

		Case  $formattedState = "in"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "il"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			
		Case  $formattedState = "ia"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ks"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)

		Case  $formattedState = "ky"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "la"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "me"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ma"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)

		Case  $formattedState = "ms"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "md"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "mi"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "mo"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "mn"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ne"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "nv"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "nh"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "nj"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "nm"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ny"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "nc"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "nd"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)
		
		Case  $formattedState = "oh"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ok"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "or"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ri"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "pa"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "sc"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			
		Case  $formattedState = "sd"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)

		Case  $formattedState = "tn"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "tx"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "ut"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "vt"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "va"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)

		Case  $formattedState = "wa"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "wi"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

		Case  $formattedState = "wv"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)
		
		Case $formattedState = "wy"
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
			MsgBox(48,"Verification", "Please verify the proper forms have been selected, and click OK.")
			SetActiveWindow($wndDiscoverRe)

		Case Else
			MsgBox(32,"UM/UIM","What state is this?")
			SetActiveWindow($wndDiscoverRe)

	EndSelect

	Send("{ESCAPE}")
EndFunc
Func AdditionalInsured()
	SetActiveWindow($wndDiscoverRe)
	$insuredState = $formattedState

	If $insuredState = "ma" Then ;$insuredState = "ct" Or 
		MsgBox(64, "", "Manual entry is required for the rest of this state.")
		Return
	EndIf

	Send("{DOWN}{ENTER}")				;select additional

	Send($lienName[0]&"{ESC}")			;name
	Send($lienAddress[0]&"{ESC}")		;addy
	Send($lienCity[0]&"{ENTER}")		;city
	Send($lienState[0]&"{ENTER}")		;state
	Send($lienZip[0]&"{ENTER}")			;zip	

	Select
		Case $insuredState = "ak" Or $insuredState = "ca" Or $insuredState = "ga" Or $insuredState = "la" Or $insuredState = "nh" Or $insuredState = "ny" Or $insuredState = "or"
			Send("{ENTER}")	;blanket description
			Send("   "&"{ESCAPE}{ENTER}{ESC}")
		Case Else ;al, az, ar
			Send("{ENTER}{ESC}")						;select vehicle (first vehicle only)
	EndSelect

	Send(GUICtrlRead($Liab)*1000&"{ENTER}")				;liability
	
	If $insuredState = "va" Then
		Send(GUICtrlRead($Med)&"{ENTER}{ENTER}")		;Medical Expense
	EndIf

	Select
		Case $insuredState = "ak" Or $insuredState = "ca" Or $insuredState = "ga" Or $insuredState = "la" Or $insuredState = "nh" Or $insuredState = "ny" Or $insuredState = "or"
			Send("{ENTER}") 	;pip limit
	EndSelect

	Send(GUICtrlRead($comp)&"{ENTER}")			;comp
	Send(GUICtrlRead($coll)&"{ENTER}")			;coll
	Send("0{ESC}")								;schol
	Send("ee")									;exit

	Send("e")									;exit Additional

	;DesignatedInsured()
	
	If $insuredState = "la" Or $insuredState = "md" Or $insuredState = "nh" Or $insuredState = "va" Or $insuredState = "mn" Or $insuredState = "tx" Then
		MsgBox(64, "", "Manual entry is required for the rest of this state.")
		Return
	EndIf
		
EndFunc
Func DesignatedInsured()
	Opt("SendKeyDelay", 1 * $SlpModfr)

	$line1 = "SNAP-ON INCORPORATED AND ITS SUBSIDIARIES"
	$line2 = "PO BOX 1430"
	$line3 = "KENOSHA, WI 53141-1430"

	Send("{DOWN}{ENTER}")						;select designated
	Send($line1 & "{ENTER}")
	Send($line2 & "{ENTER}")
	Send($line3)
	Send("{ESCAPE}")							;Exit text area
	Send("ee")									;Exit

	Opt("SendKeyDelay", 5 + ($SlpModfr * 5))
EndFunc
Func PrintPolicy()
	SetActiveWindow($wndDiscoverRe)
	Send("{DOWN}{ENTER}") ;main screen
EndFunc
Func QuotePrintDetailSheet()
	SetActiveWindow($wndDiscoverRe)

	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}") ;print/view output
	Send("{DOWN}{DOWN}{ENTER}");detail (all)
	Send("{UP}{UP}{UP}{ENTER}");quit
	Send("y{ENTER}");confirm
	Sleep( ($SlpModfr*50) + 3500)
	Send("{DOWN}{ENTER}");print output
	Sleep( ($SlpModfr*50) + 4500)
	Send("{DOWN}{ENTER}");done
EndFunc
#endregion ---------------------  SCRIPT LIST  -------------------------