#include <GUIConstants.au3>
#include <filelinesearch.au3>
#include <removeHTML.au3>
#include <searchnum.au3>
#include <stringstripmid.au3>
#include <array.au3>
#include <string.au3>
#include <file.au3>
#include <guiListview.au3>
#include <guilist.au3>
#include <misc.au3>
#include <inet.au3>
#include <compinfo.au3>
#include <IE.au3>
#include <date.au3>
#Include <GuiCombo.au3>

;formatoriginal()
hotkeyset("{tab}","tabforward")

$version = 57
;$version = 51
progressset(35)
_filecreate("C:\Program Files\Scheduler Pro\classes\crnfile.html")
global $quickexit = 0
global $oMyError = ObjEvent("AutoIt.Error","MyErrorFunc")
Global $finalclasslist = ''
global $visualschedule[5][9]
global $tempvisual[5][9]
global $crnfile = ''
global $fontpoint =18/800*@desktopwidth
global $schedulenum = 0
global $seenthisbefore = 0
global $faded = 1
global $donethisbefore = 0
global $seenthisbeforehere = 0
global $classtochange = 1
global $activegui = 1
global $disable = 0
global $id =''
global $pin=''
global $h_adj = @desktopheight / 1280
global $w_adj = @desktopwidth / 800
global $testsem_jones = 0
global $name_ip[1]
global $Jones_sems=0
global $jones_find=0 
global $schedules =0
global $jones_loadsch=0
global $allsemster_jones =''

opt("GUIOnEventMode",1)
GUICtrlSetOnEvent($GUI_EVENT_CLOSE,"exit_schedulerpro_event")

fileinstall("schedule_original.html","C:\Program Files\Scheduler Pro\schedule_original.html")
dirremove("C:\Program Files\Scheduler Pro\classes",1)

$y = stringregexp(_inetgetsource("                            "),"version (.*?)<",3)
if IsArray($y) = 0 then 
	msgbox(0,"Upgrade Error","There was an error when upgrading the program. Please uninstall and download the new installation file.")
	Exit
	EndIf
$x = stringregexp($y[0],".[0-9]{2}",3)
$x = stringformat("%i",stringreplace($x[0],".",""))

if $version < $x then 
	if fileexists("C:\Program Files\Scheduler Pro\setup.exe") = 1 then 
		run("C:\Program Files\Scheduler Pro\setup.exe 1")
		Exit
	EndIf
	progressoff()
	progressoff()
	Msgbox(0,"Upgrade Available","You are running Beta Version 3.0."&$version&", which is an outdated version. New features and bug fixes await you in Beta Version 3.0."&$x&" which will be installed right now.")
	progresson("Downloading Installer File","","Downloading the newest version of SchedulerPro...")
	progressset(50)
	inetget("                                      ","C:\Program Files\Scheduler Pro\setup.exe")
	run("C:\Program Files\Scheduler Pro\setup.exe 1")
	Exit
	progressoff()
EndIf

progresson("Loading...","")
progressset(10,"Loading Scheduler Pro")
;Opt("OnExitFunc")
processclose("iexplore.exe")
progressset(30)

; --------------fileinstall start -------------
#Compiler_Icon=globe.ico
#compiler_allow_decompile=y
DirCreate("C:\Program Files\Scheduler Pro\buildings")
DirCreate("C:\Program Files\Scheduler Pro\classes")
DirCreate("C:\Program Files\Scheduler Pro\plugins")
DirCreate("C:\Program Files\Scheduler Pro\ratings")
DirCreate("C:\Program Files\Scheduler Pro\Saved Schedules")
_FiletypeAssociation(".pro", "schedulerpro.document", "C:\Program Files\Scheduler Pro\scheduler.exe", "Scheduler Pro File")
fileinstall("i_view32.exe","C:\Program Files\Scheduler Pro\i_view32.exe")
fileinstall("buildings.txt","C:\Program Files\Scheduler Pro\buildings.txt")
fileinstall("effects.dll","C:\Program Files\Scheduler Pro\plugins\effects.dll")
fileinstall("captdll.dll","C:\Program Files\Scheduler Pro\captdll.dll")
fileinstall("veale.jpg","C:\Program Files\Scheduler Pro\buildings\veale.jpg")
fileinstall("error.jpg","C:\Program Files\Scheduler Pro\buildings\error.jpg")
filecopy("C:\Program Files\Scheduler Pro\schedule_original.html","C:\Program Files\Scheduler Pro\schedule.html",1)

;---------------install end--------------------


progressset(45)

if @compiled = 1 then testserver()

progressset(50, "Creating GUI")
#region GUI
$htmlschedule = _IEcreateembedded()
filecopy("C:\Program Files\Scheduler Pro\schedule_original.html","C:\Program Files\Scheduler Pro\schedule.html",1)
filecopy("C:\Program Files\Scheduler Pro\schedule_original.html","C:\Program Files\Scheduler Pro\schedule_show.html",1)
GUICreate("Schedule", 1280,800,0,0)
$GUIActiveX = GUICtrlCreateObj($htmlschedule, 0,0,1280,800)
guisetstate()

_IENavigate ($htmlschedule, "C:\Program Files\Scheduler Pro\schedule.html")

#region autoschedule
progressset(55,"Getting Registered XP User's Name")
$studentname = getname()
progressset(60,"Drawing GUI...")

$gui = GUICreate("Scheduler Pro - " & $studentname, 800, 377, (@DesktopWidth / 2) - 400, (@DesktopHeight / 2) - 200, $WS_VISIBLE + $WS_OVERLAPPEDWINDOW)
$_trackmenu = GUICtrlCreateMenu("File")
$mapall = GUICtrlCreateMenuitem("Map All Buildings", $_trackmenu)
GUICtrlCreateMenuitem("", $_trackmenu)
guictrlsetstate($mapall,$GUI_DISABLE)
$_print = GUICtrlCreateMenuitem("Print", $_trackmenu)
GUICtrlCreateMenuitem("", $_trackmenu)
$_clearschedule = GUICtrlCreateMenuitem("Clear Schedule", $_trackmenu)
GUICtrlCreateMenuitem("", $_trackmenu)
$_saveitem = GUICtrlCreateMenuitem("Save", $_trackmenu)
$_loaditem = GUICtrlCreateMenuitem("Open", $_trackmenu)
GUICtrlCreateMenuitem("", $_trackmenu)
$_sendfeedback = GUICtrlCreateMenuitem("Send Feedback", $_trackmenu)
GUICtrlCreateMenuitem("", $_trackmenu)
$_exititem = GUICtrlCreateMenuitem("Exit", $_trackmenu)

progressset(65)

$solarmenu = guictrlcreatemenu("Solar")
$solar = GUICtrlCreateMenuitem("Output Schedule to Solar ", $solarmenu)
$solarlogin = GUICtrlCreateMenuitem("Log into Solar at 7:00 AM", $solarmenu)
GUICtrlCreateMenuitem("", $solarmenu)
$installopal = GUICtrlCreateMenuitem("Install Opal Plugin for Solar", $solarmenu)
$jonesmenu = guictrlcreatemenu("Scheduler Jones")
$load_jones_menu = GUICtrlCreateMenuitem("Load Scheduler Jones Schedule", $jonesmenu)
$save_jones_menu = GUICtrlCreateMenuitem("Save As Scheduler Jones Schedule", $jonesmenu)
GUICtrlCreateMenuitem("", $jonesmenu)
$find_jones_menu = GUICtrlCreateMenuitem("Find Online Schedules", $jonesmenu)
$about = guictrlcreatemenu("About")
$aboutprog = GUICtrlCreateMenuitem("About", $about)
$tab = GUICtrlCreateTab(1, 5, 398*2, 350, $TCS_RIGHTJUSTIFY)

$tab_0 = GUICtrlCreateTabItem("Find Schedules")
GUICtrlCreateGroup("Find Individual Class Info",400,30,390,320)
$tab_adj = -10
$dept = GUICtrlCreateCombo("",400+ 80, 40-$tab_adj, 54, 20)
GUICtrlSetState(-1, $GUI_FOCUS)
GUICtrlSetData(-1, "ABLE|ACCT|AMST|ANTH|APMU|ARAB|ARSC|ARTH|ARTS|ASIA|ASTR|BAFI|BETH|BIOC|BIOL|BLAW|CHEM|CHIN|CHST|CIA|CLSC|COSI|DANC|DEND|DENT|EBME|ECHE|ECIV|ECON|EDMP|EDUC|EECS|EMAC|EMAE|EMBA|EMSE|ENGL|ENGR|ENTP|EPBI|EPOM|ESTD|ETHS|FRCH|FSCC|FSNA|FSSO|GEOL|GERO|GREK|GRMN|HBRW|HSMC|HSTY|IIME|ITAL|JAPN|JDST|LATN|LAWS|LHRP|MAND|MATH|MBAC|MEDII|MGMT|MIDS|MKMR|MUAP|MUAR|MUCP|MUDE|MUED|MUEN|MUGN|MUHI|MULI|MUPD|MURP|MUTH|MUHI|MUSC|NEUR|NTRN|NUND|NUNI|NUNP|NURS|OPMT|OPRE|ORBH|PHED|PHIL|PHRM|PHYS|PLCY|POSC|PSCL|QUMM|RLGN|RUSN|SASS|SOCI|SPAN|SSBT|STAT|THTR|UNIV|USNA|USSO|USSY|WLIT|WMST|", "")
$num = GUICtrlCreatecombo("",400+ 135, 40-$tab_adj, 40, 21)
GUICtrlCreateLabel("Class Code", 400+10, 44-$tab_adj)
$findCRN = GUICtrlCreateButton("Find", 400+180, 40-$tab_adj, 30, 21, $BS_DEFPUSHBUTTON)
$course_title = guictrlcreatelabel("", 630,40-$tab_adj,150)
guictrlsetfont(-1,12)
$crn = GUICtrlCreateCombo("", 400+80, 70-$tab_adj, 95, 21)
GUICtrlCreateLabel("Refrence #",400+ 10, 74-$tab_adj)
$professorrate = GUICtrlCreateButton("Rate",400+ 180, 99-$tab_adj, 30, 21)
$professorinput = GUICtrlCreateInput("",400+ 80, 99-$tab_adj, 95, 21)
GUICtrlSetData($professorinput, "")
GUICtrlCreateLabel("Professor", 400+10, 103-$tab_adj)
$buildinginput = GUICtrlCreateInput("", 400+80, 129-$tab_adj, 95, 21)
GUICtrlCreateLabel("Building",400+ 10, 132-$tab_adj)
$findbuilding = GUICtrlCreateButton("Map", 400+180, 129-$tab_adj, 30, 21)
If FileExists("C:\Program Files\Scheduler Pro\buildings\veale.jpg") = 0 Then InetGet("http://www.cwru.edu/pix/buildings/veale.jpg", "C:\Program Files\Scheduler Pro\buildings\veale.jpg")

$buildingname = String("Veale")
$buildingpic = GUICtrlCreatePic("C:\Program Files\Scheduler Pro\buildings\veale.jpg",400+230, 150-$tab_adj, 150, 120)
$buildinglabel = GUICtrlCreateLabel($buildingname, 400+230, 130-$tab_adj, 100)

$get_description = guictrlcreatebutton("Get Description",400+230,99-$tab_adj,780-630,21)

$buildinginput2 = GUICtrlCreateInput("",400+ 80, 159-$tab_adj, 95, 21)
GUICtrlCreateLabel("Rec Building", 400+10, 162-$tab_adj)

$daysinput = GUICtrlCreateInput("", 400+80, 188-$tab_adj, 130, 21)
GUICtrlCreateLabel("Class Days", 400+10, 191-$tab_adj)

$timesinput = GUICtrlCreateInput("", 400+80, 217-$tab_adj, 130, 21)
GUICtrlCreateLabel("Class Times", 400+10, 220-$tab_adj)

$Credithours = GUICtrlCreateInput("", 400+80, 246-$tab_adj, 25, 21)
GUICtrlCreateLabel("Hours", 400+45, 249-$tab_adj, 75, 21)

$capacity = GUICtrlCreateInput("", 400+185, 246-$tab_adj, 25, 21)
GUICtrlCreateLabel("Capacity", 400+140, 249-$tab_adj, 75, 21)

$scheduleclass = GUICtrlCreateButton("Schedule This Class",400+50+150+10, 290-$tab_adj, 150, 21)

$selectsemester = guictrlcreatecombo("",400+50,290-$tab_adj,150,21)

$searchedclasses = GUICtrlCreateCombo("", 90, 40, 100, 20)
GUICtrlSetState(-1, $GUI_FOCUS)
guictrlsettip($searchedclasses,"If you have searched for classes individually,"&@crlf&" they will appear here in a list.")
GUICtrlCreateLabel("Classes Found", 10, 44)

$addclass = GUICtrlCreateButton("Add Class To Schedule Queue", 200, 40, 170, 21,$BS_DEFPUSHBUTTON )
guictrlsettip(-1,"Clicking this will add the current class to the schedule queue,"&@crlf&"to be automatically scheduled once all the classes are added.")
$deleteclass = guictrlcreatebutton("Delete Class From Queue",200,65,170,21)
guictrlsettip(-1,"Clicking this will remove the current class to the schedule queue.")
$allpossible = GUICtrlCreateButton("Make Schedule", 200, 185, 170, 21)
guictrlsettip(-1,"Once you are ready with all your classes in the queue, click this,"&@crlf&"so that Scheduler Pro can find a possible schedule for you.")
$resched = GUICtrlCreateButton("Reschedule Selected Class", 200, 215, 170, 21)
guictrlsettip(-1,"Select a class from the above list to find the next available timeslot.")

$classlist = GUICtrlCreatelist("", 200,95, 170, 90,$WS_VSCROLL)
progressset(70)
$proffessorfilter = guictrlcreatecheckbox("Use Professor Rating Filter",10,75,175,22,"", $SS_CENTER)
guictrlsettip(-1,"This will refine your schedule search by only allowing classes to be scheduled "&@crlf&"if their respective professors are rated to your liking from www.ratemyprofessor.com")
guictrlcreatelabel("Professor Ratings Importance:",10,105,175,22,$SS_CENTER)
$definebest = guictrlcreateslider(10,120,175,30)
guictrlsettip(-1,"This slider adjusts the how a professor rating is interpreted."&@crlf&"On ratemyprofessor.com there are two ratings, this slider allows you "&@crlf&"to give them the weight that you see fit.")
$abilityeaseslider = guictrlcreatelabel("",10,150,175,22,$SS_CENTER)

$crnlist = guictrlcreatelabel("Type in the class in the box above using department and number."&@crlf&@crlf&"Then select 'Add Class to Schedule Queue' to begin creating your schedule.",10,202,170,100)

$loadjones = GUICtrlCreateCombo("Load Scheduler Jones Schedule", 10, 310, 180, 21)
guictrlsettip(-1,"If you have Scheduler Jones installed this will allow you to load that schedule into Scheduler Pro.")
GUICtrlSetData(-1, loadschedule())
$loadjonesbutton = GUICtrlCreateButton("Load", 195, 310, 35, 21)

if not fileexists("c:\program files\scheduler jones\name.txt") then
	guictrlsetstate($loadjones,$GUI_DISABLE)
	guictrlsetstate($loadjonesbutton,$GUI_DISABLE)
EndIf

#endregion
progressset(80)

;-------------------------------------------------------------------------------

progressset(90)

$tab1 = GUICtrlCreateTabItem("Teacher Ratings")
$nameGUI = GUICtrlCreateCombo("", 100, 40, 100, 21)
$nameGUIlabel = GUICtrlCreateLabel("Prof. Last Name", 10, 44)

$ease = GUICtrlCreateProgress(60, 85, 330, 10)
GUICtrlSetData(-1, 0)
$1 = GUICtrlCreateLabel("Easiness:", 10, 82)
$2 = GUICtrlCreateLabel("Easy", 60, 95)
$3 = GUICtrlCreateLabel("Difficult", 352, 95)

$quality = GUICtrlCreateProgress(60, 135, 330, 10)
GUICtrlSetData(-1, 0)
$4 = GUICtrlCreateLabel("Ability:", 10, 132)
$5 = GUICtrlCreateLabel("Poor", 60, 145)
$6 = GUICtrlCreateLabel("Excellent", 345, 145)

$namelabel = GUICtrlCreateLabel("", 10, 170, 150)
$email = GUICtrlCreateLabel("", 10, 185, 150)
$reviews = GUICtrlCreateLabel("", 325, 170, 100)
$date = GUICtrlCreateLabel("", 325, 185, 90)
$okbutton1 = GUICtrlCreateButton("Professor Rating", 230,40, 150, 20)
$compare = GUICtrlCreateButton("Compare Professors", 20, 270, 150, 20)




$tab2controls = _ArrayCreate($nameGUI, $nameGUIlabel, $1, $2, $3, $4, $5, $6, $ease, $quality, $namelabel, $email, $reviews, $date, $okbutton1, $compare)

;-----------------Professor Rating tab hidden GUI-------------------------
$nameGUI1 = GUICtrlCreateCombo("", 100, 40, 100, 21)
GUICtrlSetState(-1, $GUI_HIDE)
$nameGUI1label = GUICtrlCreateLabel("Professor 1:", 10, 44)
GUICtrlSetState(-1, $GUI_HIDE)

$nameGUI2 = GUICtrlCreateCombo("", 100, 70, 100, 21)
GUICtrlSetState(-1, $GUI_HIDE)
$nameGUI2label = GUICtrlCreateLabel("Professor 2:", 10, 74)
GUICtrlSetState(-1, $GUI_HIDE)

$findratings = GUICtrlCreateButton("Find Professor Ratings", 240, 51, 150, 30)
GUICtrlSetState(-1, $GUI_HIDE)

$switch = GUICtrlCreateButton("Back to Single Professor", 10, 280, 150, 30)
GUICtrlSetState(-1, $GUI_HIDE)

$_ease1 = GUICtrlCreateProgress(40, 105, 320, 10)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetData($_ease1, 0)
$_ease2 = GUICtrlCreateProgress(40, 125, 320, 10)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetData($_ease2, 0)
$_1 = GUICtrlCreateLabel("Easy", 10, 111)
GUICtrlSetState(-1, $GUI_HIDE)
$_2 = GUICtrlCreateLabel("Hard", 365, 111)
GUICtrlSetState(-1, $GUI_HIDE)

$_ability1 = GUICtrlCreateProgress(40, 165, 320, 10)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetData($_ease1, 0)
$_ability2 = GUICtrlCreateProgress(40, 185, 320, 10)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetData($_ease2, 0)
$_3 = GUICtrlCreateLabel("Poor", 10, 171)
GUICtrlSetState(-1, $GUI_HIDE)
$_4 = GUICtrlCreateLabel("Great", 365, 171)
GUICtrlSetState(-1, $GUI_HIDE)
$_easeverdict = GUICtrlCreateLabel("", 10, 210, 250)
GUICtrlSetState(-1, $GUI_HIDE)
$_abilityverdict = GUICtrlCreateLabel("", 10,225, 250)
GUICtrlSetState(-1, $GUI_HIDE)


$tab2controls1 = _ArrayCreate($nameGUI1, $nameGUI1label, $nameGUI2, $nameGUI2label, $findratings, $_ease1, $_ease2, $_1, $_2, $_3, $_4, $_ability1, $_ability2, $switch, $_abilityverdict, $_easeverdict)
#endregion

;----------tabs 2 and 3-----------------


GUICtrlSetState($tab_0, $GUI_SHOW)

GUICtrlCreateTabItem("")

$summary = GUICtrlCreateGroup("My Schedule Summary:", 240, 240, 140, 110)

guictrlsetstate($searchedclasses,$GUI_FOCUS)

$total_hours = GUICtrlCreateLabel("0.0",245, 260,130, 45,$SS_CENTER)
GUICtrlSetFont(-1, 35)
GUICtrlCreateLabel("Credit Hours", 280, 310, 60, 13)
$classcount = GUICtrlCreateLabel("0 Classes", 280, 330, 60, 13)
GUICtrlCreateGroup("", -99, -99, 1, 1)
guictrlsetstate($addclass,$GUI_FOCUS)

GUICtrlSetOnEvent($_exititem,"exit_schedulerpro")
GUICtrlSetOnEvent($_sendfeedback,"feedback")
GUICtrlSetOnEvent($_saveitem,"saveschedule")
GUICtrlSetOnEvent($_loaditem,"_loadschedule")
GUICtrlSetOnEvent($_print,"print")
GUICtrlSetOnEvent($findCRN,"findinfo")
GUICtrlSetOnEvent($okbutton1,"professorrating")
GUICtrlSetOnEvent($findbuilding,"findbuilding_function")
GUICtrlSetOnEvent($findratings,"professorcompare")
GUICtrlSetOnEvent($switch,"swap")
GUICtrlSetOnEvent($compare,"swap")
GUICtrlSetOnEvent($professorrate,"professorrate")
GUICtrlSetOnEvent($get_description,"describe")
GUICtrlSetOnEvent($scheduleclass,"scheduleclassmanual")
GUICtrlSetOnEvent($loadjonesbutton,"loadjones")
GUICtrlSetOnEvent($addclass,"add_class_function")
GUICtrlSetOnEvent($_clearschedule,"clear_schedule_function")
GUICtrlSetOnEvent($deleteclass,"delete_class_function")
GUICtrlSetOnEvent($allpossible,"all_possible_function")
GUICtrlSetOnEvent($resched,"reschedule_class_function")
GUICtrlSetOnEvent($aboutprog,"aboutprog")
GUICtrlSetOnEvent($solar,"solar")
GUICtrlSetOnEvent($mapall,"mapall")
GUICtrlSetOnEvent($installopal,"installopal")
GUICtrlSetOnEvent($save_jones_menu,"save_jones_menu")
GUICtrlSetOnEvent($load_jones_menu,"load_jones_menu")
GUICtrlSetOnEvent($find_jones_menu,"find_jones_menu")
GUICtrlSetOnEvent($crn,"filldata")
GUICtrlSetOnEvent($num,"filldata")

GUISetState()

$oldcrn = ""
$oldnum = ""
#endregion
progressset(95)
#endregion

$time = TimerStart()
opt("GuiCoordMode",1)
$done = 0
guictrlsetstate($addclass,$BS_DEFPUSHBUTTON)

global $focusarray = _arraycreate($dept,$num, $findCRN ,$crn ,$professorrate,$professorinput ,$buildinginput,$findbuilding ,$get_description ,$buildinginput2 ,$daysinput ,$timesinput ,$Credithours ,$capacity,$scheduleclass ,$selectsemester ,$searchedclasses ,$addclass ,$deleteclass,$allpossible ,$resched)
global $focusarray2 = _arraycreate($classlist ,$proffessorfilter ,$definebest ,$abilityeaseslider ,$crnlist,$loadjones ,$loadjonesbutton ,$nameGUI ,$okbutton1 ,$compare,$nameGUI1 ,$nameGUI2,$findratings ,$switch)
for $r = 0 to ubound($focusarray2)-1
	_arrayadd($focusarray,$focusarray2[$r])
	Next


global $editarray = _arraycreate($dept,$num ,$crn ,$professorinput ,$buildinginput ,$buildinginput2 ,$daysinput ,$timesinput ,$Credithours ,$capacity ,$selectsemester ,$searchedclasses,$classlist,$abilityeaseslider ,$crnlist,$loadjones ,$nameGUI ,$nameGUI1 ,$nameGUI2)	
global $buttonarray = _arraycreate($findCRN,$professorrate,$get_description , $scheduleclass ,$addclass ,$deleteclass,$allpossible ,$resched ,$loadjonesbutton ,$okbutton1 ,$compare, $findratings ,$switch)
global $testsem = 0
global $allsemster = getsemester()
;_ieaction($htmlschedule,"refresh")

While 1
	sleep(10)
	if TimerDiff($time) > 500 then
		$time = TimerStart()
		guictrlsetdata($abilityeaseslider,100 - guictrlread($definebest) & "% Ease    "&guictrlread($definebest)&"% Ability")
	endif

WEnd
GUIDelete()
Exit

;functions start.................

func save_jones_menu()
	msgbox(0,"Error","Function under development")
EndFunc

func find_jones_menu()
	msgbox(0,"Error","Function under development")
EndFunc

func load_jones_menu()
	msgbox(0,"Error","Function under development")
EndFunc

func reschedule_class_function()
	reschedule (GUICtrlRead($classlist))
	EndFunc

func all_possible_function()
	findallschedules ()
	GUICtrlSetState($mapall, $GUI_ENABLE)
	EndFunc

func delete_class_function()
	If Not GUICtrlRead($classlist) = '' Then
		$finalclasslist = StringReplace($finalclasslist, GUICtrlRead($classlist), "", 1)
		$finalclasslist = StringReplace($finalclasslist, "||", "|")
		GUICtrlSetData($classlist, '')
		GUICtrlSetData($classlist, $finalclasslist)
	EndIf
	
	EndFunc

func clear_schedule_function()
	clearfullschedule ()
	GUICtrlSetData($crnlist, "")
	GUICtrlSetData($classlist, "")
	showschedule ()
	endfunc

func add_class_function()
	GUICtrlSetData($crnlist, "Type in your next class in the same way, and add it to the queue." & @CRLF & @CRLF & "Once all the classes you want to take are in the Schedule Queue, select 'Find Basic Schedule' to complete your new schedule.")
			$donethisbefore = 0
			spellcheck ()
			refreshclasslist ()
	EndFunc

func findbuilding_function()
	If buildinglocator (GUICtrlRead($buildinginput)) = 0 Then MsgBox(0, "Building not found...", "Building cannot be found.")
	endfunc


func exit_schedulerpro()
	
	$reply = MsgBox(3, "Save Schedule?", "Would you like to save your schedule first?")
			If $reply = 6 Then
				saveschedule ()
			Else
				If $reply = 7 Then
					FileDelete("building.gif")
					FileDelete("building_converted.jpg")
					FileDelete("C:\Program Files\Scheduler Pro\classtemp.txt")
					FileDelete("C:\Program Files\Scheduler Pro\class.html")
					FileDelete("C:\Program Files\Scheduler Pro\i_view32.exe")
					FileDelete("C:\Program Files\Scheduler Pro\captdll.dll")
					Exit
				EndIf
			EndIf
		EndFunc
		
func exit_schedulerpro_event()
	exit
	EndFunc

func describe()
	if guictrlread($crn) = "" then 
		msgbox(0,"Select CRN","You need to select a Course Refrence Number in order to search for a class description.")
		Return
		EndIf
		$ie_object1 = _iecreate("                                                                "&getsemester()&"&crn="& guictrlread($crn),0,0)
		$description = _IEBodyReadText($ie_object1)	
		$description = stringtrimleft($description,stringinstr($description,"Descript")+11)
		$description = stringtrimright($description,stringlen($description) - stringinstr($description,"Comments","",-1)+6)
		if stringstripws($description,8) = '' then $description = "There is no availabe description for this class. However, ."
		progressoff()
		
		msgbox(0,"Class Description",$description)
		return
	EndFunc

func installopal()	
	msgbox(0,"ActiveX","Note: You must have ActiveX controls enabled in Internet Exlorer in order to operate the Opal Plugin with or without SchedulerPro.")
	fileinstall("downloadprogress.exe","C:\Program Files\Scheduler Pro\downloadprogress.exe")
	if 7 = msgbox(4,"Download and Install","In order to register your classes online you need to install the Opal Internet Explorer Plugin. Solar Installation Packages total about 5 megabytes. Continue?")Then return 0
	if 7 = msgbox(4,"Blocking Input","During this installtion, input from your keyboard and mouse will be blocked so that the install can go smoothly. It will take maybe 5 minutes. Perhpas less, perhaps more. Be patient. Continue intallation of Opal?") then return 0
	blockinput(1)
	progresson("Installing...","","Working...")
	$size = inetgetsize("http://www.case.edu/net/SOLAR/plugins/solar.exe")
	_filecreate(@tempdir & "\filesize.dat")
	progressset(50)
	filewriteline(@tempdir & "\filesize.dat",$size)
	filewriteline(@tempdir & "\filesize.dat",@tempdir & "\solar.exe")
	run("C:\Program Files\Scheduler Pro\downloadprogress.exe")
	sleep(1000)
	inetget("http://www.case.edu/net/SOLAR/plugins/solar.exe",@tempdir & "\solar.exe")
	run(@tempdir & "\solar.exe")
	filedelete(@tempdir & "\filesize.dat")
	winwait("Opal Player Setup")
	winwait("Welcome")
	send("!n")
	winwait("Software License")
	send("!y")
	winwait("Select")
	send("!n")
	winwait("Opal Folder Selection")
	send("!n")
	winwait("Question")
	send("!y")
	winwait("Opal Player Plugin Selection")
	send("!n")
	winwait("Start Copying Files")
	send("!n")
	winwait("Information")
	send("{enter}")
	progressoff()
	blockinput(0)
	msgbox(0,"Setup Complete","Opal Player has been sucessfully installed.")
	EndFunc

#region
func solarlogin()
	msgbox(0,"Under Development","Thus function will, as of yet, only log you in to solar. The scheduling you will still have to do yourself.")
	$ID = InputBox("User ID and PIN","Student ID Number (9 Digits):","","*",200,50)
	$pin= InputBox("User ID and PIN","Student PIN Number (4 Char):","","*",200,50)
	
	$schedlogin = GuiCreate("Login Progress", 392, 107,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	$percent = GuiCtrlCreateProgress(20, 20, 360, 20)
	$cancel = GuiCtrlCreateButton("Cancel Scheduled Login", 110, 70, 170, 20)
	$plus = 1
	if @hour<7 then $plus = 0
	$tomorrow = _dateadd("D",$plus,_nowcalc())
	$tomorrow = stringtrimright($tomorrow,8)
	$tomorrow = $tomorrow & "07:00:00"
	$timeleft = _DateDiff( 's',$tomorrow,_NowCalc())
	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE or $msg = $cancel
				ExitLoop
			Case Else
		EndSelect
		sleep(10)
	
		guictrlsetdata($percent,100-_DateDiff( 's',$tomorrow,_NowCalc())/$timeleft * 100)
		if (-_DateDiff( 's',$tomorrow,_NowCalc())/$timeleft * 100)>=100 then solar(1)
	WEnd
	guidelete($schedlogin)
	return
	
EndFunc   ;==>solarlogin

func solar($v = 0)
	hotkeyset("{tab}")
	msgbox(0,"Under Development","Thus function will, as of yet, only log you in to solar. The scheduling you will still have to do yourself. ")
	if $v = 0 then
	$ID = InputBox("User ID and PIN","Student ID Number (9 Digits):","","*",200,50)
	$pin= InputBox("User ID and PIN","Student PIN Number (4 Char):","","*",200,50)
	EndIf
	if fileexists("C:\OpalPlay\Program\OpalPlay.exe") = 0 then 
		msgbox(0,"Opal Problem","You will need to install the Opal plugin to Internet Explorer before your classes can be registered.")
		installopal()
		return 0
		EndIf
	_IENavigate($htmlschedule,"http://www.case.edu/net/SOLAR/cgi/bin/solar.pl")
	_ieloadwait($htmlschedule)
	_ienavigate($htmlschedule,"C:\Program Files\Scheduler Pro\schedule_show.html")
	winwait("Opal Player")
	winwait("Opal Player - h")
	WinMove("Opal Player - h","",0,0)
	$size = WinGetClientSize("Opal")
	
	blockinput(1)

	mouseclick("left",$size[0] * 0.59 ,$size[1] *.60,1,0)
	
	sleep(1000)
	send($id)
	send("{tab}")
	send($pin)
	send("{tab}")
	send("{space}")
	blockinput(0)
	
	hotkeyset("{tab}","tabforward")
	EndFunc   ;==>solar

func aboutprog()
	$aboutgui = GuiCreate("About Class Scheduler Pro", 392, 322,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	fileinstall("globe.ico","C:\Program Files\Scheduler Pro\globe.ico")
	$Label_2 = GuiCtrlCreateLabel("Class Scheduler Pro was designed because I thought that a scheduling program should do more than fill in timeslots. I saw that there were many features missing that should be included in a scheduler. So, I did what I could to add them.", 20, 100, 360, 50)
	$Button_3 = GuiCtrlCreateButton("Go Back", 50, 240, 300, 50)
	$Icon_4 = GuiCtrlCreateIcon("", 0, 40, 30, 32, 32)
	guictrlsetimage($Icon_4,"C:\Program Files\Scheduler Pro\globe.ico")
	$Label_5 = GuiCtrlCreateLabel("Class Scheduler Pro - Beta 3.0." & $version, 80, 35, 300, 20)
	guictrlsetfont(-1,15,"","","Myriad Web Pro")
	guictrlcreatelabel("Andrew Freyer '09", 196-100,60)
	
	$Label_6 = GuiCtrlCreateLabel("This is program is meant to make scheduling classes on a Windows machine a little bit easier, and to give the user all the useful information that he or she needs in order to make the right decision when scheduling a class.", 20, 160, 360, 50)
	
	GuiSetState()
	While 1
		$msg = GuiGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE or $msg = $Button_3
				guidelete($aboutgui)
				return
		EndSelect
	WEnd
	guidelete($aboutgui)
	filedelete("C:\Program Files\Scheduler Pro\globe.ico")
	return
endfunc   ;==>aboutprog

func refreshclasslist()
	guictrlsetdata($classlist,"")
	guictrlsetdata($classlist,$finalclasslist)
	$counter = stringsplit(stringtrimright(stringtrimleft($finalclasslist,1),1),"|")
	guictrlsetdata($classcount,$counter[0] & " Classes")
EndFunc   ;==>refreshclasslist

func orderclasses()
	$finalclasslist = "|" & $finalclasslist
	
	stringreplace($finalclasslist,"||","|")
	$tempclasslist = stringsplit($finalclasslist,"|")
	
	$final=$tempclasslist[0]
	for $var =1 to $tempclasslist[0]
		$lines = _FileCountLines("C:\Program Files\Scheduler Pro\classes\" & $tempclasslist[$var]&".html")
		$timedaytemp = ''
		$countoftimes = 0
		
		for $var1 = 1 to $lines
			$currentcourse = stringsplit(filereadline("C:\Program Files\Scheduler Pro\classes\" & $tempclasslist[$var]&".html",$var1),"|")
			
			if not $currentcourse[1] = "" then
				$timeday = stringstripws($currentcourse[7]&$currentcourse[8],8)
				if stringinstr($timedaytemp,$timeday)=0 then $countoftimes = $countoftimes+1
				$timedaytemp = $timeday&$timedaytemp
			endif
		Next
		
		$tempclasslist[$var] = 	$countoftimes & $tempclasslist[$var]
		
	Next
	_arraysort($tempclasslist,0)
	$final1 = $final
	for $var =1 to $final
		if $var>$final then exitloop
		$tempclasslist[$var]= stringtrimleft($tempclasslist[$var],1)
		if $tempclasslist[$var] = '' then
			_arraydelete($tempclasslist,$var)
			$final = $final-1
			$var = $var-1
		EndIf
	Next
	$finalclasslist=stringtrimleft(_arraytostring($tempclasslist,"|"),2)
	
EndFunc   ;==>orderclasses

func _orderclasses()
	$finalclasslist = "|" & $finalclasslist
	stringreplace($finalclasslist,"||","|")
	$tempclasslist = stringsplit($finalclasslist,"|")
	
	$final=$tempclasslist[0]
	for $var =1 to $tempclasslist[0]
		$lines = _FileCountLines("C:\Program Files\Scheduler Pro\classes\" & $tempclasslist[$var]&".html")
		$timedaytemp = ''
		$countoftimes = 0
		for $var1 = 1 to $lines
			$currentcourse = stringsplit(filereadline("C:\Program Files\Scheduler Pro\classes\" & $tempclasslist[$var]&".html",$var1),"|")
			if not $currentcourse[1] = "" then
				$timeday = stringstripws($currentcourse[3],8)
				if stringinstr($timedaytemp,$timeday)=0 then $countoftimes = $countoftimes+1
				$timedaytemp = $timeday&$timedaytemp
			endif
		Next
		
		$tempclasslist[$var] = 	$countoftimes & $tempclasslist[$var]
		
	Next
	_arraysort($tempclasslist,0)
	$final1 = $final
	for $var =1 to $final
		if $var>$final then exitloop
		$tempclasslist[$var]= stringtrimleft($tempclasslist[$var],1)
		if $tempclasslist[$var] = '' then
			_arraydelete($tempclasslist,$var)
			$final = $final-1
			$var = $var-1
		EndIf
	Next
	$finalclasslist=stringtrimleft(_arraytostring($tempclasslist,"|"),2)
EndFunc   ;==>_orderclasses

func spellcheck()
	$success = 0
	$spellcorrect =stringsplit("ABLE|ACCT|AMST|ANTH|APMU|ARAB|ARSC|ARTH|ARTS|ASIA|ASTR|BAFI|BETH|BIOC|BIOL|BLAW|CHEM|CHIN|CHST|CIA|CLSC|COSI|DANC|DEND|DENT|EBME|ECHE|ECIV|ECON|EDMP|EDUC|EECS|EMAC|EMAE|EMBA|EMSE|ENGL|ENGR|ENTP|EPBI|EPOM|ESTD|ETHS|FRCH|FSCC|FSNA|FSSO|GEOL|GERO|GREK|GRMN|HBRW|HSMC|HSTY|IIME|ITAL|JAPN|JDST|LATN|LAWS|LHRP|MAND|MATH|MBAC|MEDII|MGMT|MIDS|MKMR|MUAP|MUAR|MUCP|MUDE|MUED|MUEN|MUGN|MUHI|MULI|MUPD|MURP|MUTH|MUHI|MUSC|NEUR|NTRN|NUND|NUNI|NUNP|NURS|OPMT|OPRE|ORBH|PHED|PHIL|PHRM|PHYS|PLCY|POSC|PSCL|QUMM|RLGN|RUSN|SASS|SOCI|SPAN|SSBT|STAT|THTR|UNIV|USNA|USSO|USSY|WLIT|WMST|","|")
	$spellinvert1 = stringsplit("ALBE|ACCT|ASMT|ATNH|AMPU|AARB|ASRC|ATRH|ATRS|AISA|ATSR|BFAI|BTEH|BOIC|BOIL|BALW|CEHM|CIHN|CSHT|CAI|CSLC|CSOI|DNAC|DNED|DNET|EMBE|EHCE|EICV|EOCN|EMDP|EUDC|ECES|EAMC|EAME|EBMA|ESME|EGNL|EGNR|ETNP|EBPI|EOPM|ETSD|EHTS|FCRH|FCSC|FNSA|FSSO|GOEL|GREO|GERK|GMRN|HRBW|HMSC|HTSY|IMIE|IATL|JPAN|JSDT|LTAN|LWAS|LRHP|MNAD|MTAH|MABC|MDEI|MMGT|MDIS|MMKR|MHUI|MSUC|NUER|NRTN|NNUD|NNUI|NNUP|NRUS|OMPT|ORPE|OBRH|PEHD|PIHL|PRHM|PYHS|PCLY|PSOC|PCSL|QMUM|RGLN|RSUN|SSAS|SCOI|SAPN|SBST|SATT|TTHR|UINV|UNSA|USSO|USSY|WILT|WSMT|","|")
	$spellinvert2 = stringsplit("ABEL|ACTC|AMTS|ANHT|APUM|ARBA|ARCS|ARHT|ARST|ASAI|ASRT|BAIF|BEHT|BICO|BILO|BLWA|CHME|CHNI|CHTS|CIA|CLCS|COIS|DACN|DEDN|DETN|EBEM|ECEH|ECVI|ECNO|EDPM|EDCU|EESC|EMCA|EMEA|EMAB|EMES|ENLG|ENRG|ENPT|EPIB|EPMO|ESDT|ETSH|FRHC|FSCC|FSAN|FSOS|GELO|GEOR|GRKE|GRNM|HBWR|HSCM|HSYT|IIEM|ITLA|JANP|JDTS|LANT|LASW|LHPR|MADN|MAHT|MBCA|MEID|MGTM|MISD|MKRM|MUIH|MUCS|NERU|NTNR|NUDN|NUIN|NUPN|NUSR|OPTM|OPER|ORHB|PHDE|PHLI|PHMR|PHSY|PLYC|POCS|PSLC|QUMM|RLNG|RUNS|SASS|SOIC|SPNA|SSTB|STTA|THRT|UNVI|USAN|USOS|USYS|WLTI|WMTS|","|")
	$spellinvert3 = stringsplit("ABL|ACC|AMS|ANT|APM|ARA|ARS|ART|ART|ASI|AST|BAF|BET|BIO|BIO|BLA|CHE|CHI|CHS|CIA|CLS|COS|DAN|DEN|DEN|EBM|ECH|ECI|ECO|EDM|EDU|EEC|EMA|EMA|EMB|EMS|ENG|ENG|ENT|EPB|EPO|EST|ETH|FRC|FSC|FSN|FSS|GEO|GER|GRE|GRM|HBR|HSM|HST|IIM|ITA|JAP|JDS|LAT|LAW|LHR|MAN|MAT|MBA|MED|MGM|MID|MKM|MUH|MUS|NEU|NTR|NUN|NUN|NUN|NUR|OPM|OPR|ORB|PHE|PHI|PHR|PHY|PLC|POS|PSC|QUM|RLG|RUS|SAS|SOC|SPA|SSB|STA|THT|UNI|USN|USS|USS|WLI|WMS|","|")

	$class = stringupper(stringleft(stringstripws(guictrlread($searchedclasses),8),4))
	for $var = 1 to $spellcorrect[0]
		if not stringinstr($spellcorrect[$var],$class) = 0 then
			$success =  1
			ExitLoop
		endif
	Next
	if $class = '' then return 
	if $success = 0 then
		for $var = 1 to $spellcorrect[0]
			if not stringinstr($spellinvert1[$var],$class) = 0 then
				$success = 1
				exitloop
			EndIf
			if not stringinstr($spellinvert2[$var],$class) = 0 then
				$success = 1
				exitloop
			EndIf
			if not stringinstr($spellinvert3[$var],$class) = 0 then
				$success = 1
				exitloop
			EndIf
			$success = 0
		Next
		if $success = 1 and msgbox(4,"Spelling Error:","The class "& stringupper(guictrlread($searchedclasses))&" has a spelling error. Did you intend to add "& $spellcorrect[$var] &" "& stringright(stringstripws(guictrlread($searchedclasses),8),3)&" to the scheduling queue?")=7 then
			guictrlsetdata($searchedclasses,"|"&$spellcorrect[$var] &" "& stringright(stringstripws(guictrlread($searchedclasses),8),3))
			return
		endif
		
		if $success = 0 then msgbox(4096,"Spelling Error:","The class "& stringupper(guictrlread($searchedclasses))&" has a spelling error. Check spelling and try again.")
	endif
	
	if $success=1 then
		;If Not GUICtrlRead($searchedclasses) = "" Then GUICtrlSetData($classlist, stringleft(stringstripws(stringupper(GUICtrlRead($searchedclasses)),8),4)& " " &stringright(stringstripws(stringupper(GUICtrlRead($searchedclasses)),8),3) )
		
		if stringinstr($finalclasslist,$spellcorrect[$var] &" "& stringright(stringstripws(guictrlread($searchedclasses),8),3))=0 then
			$finalclasslist = $finalclasslist & "|"
			$finalclasslist = $finalclasslist & $spellcorrect[$var] &" "& stringright(stringstripws(guictrlread($searchedclasses),8),3) &"|"
			$finalclasslist = stringreplace($finalclasslist,"||","|")
		endif
		guictrlsetdata($classlist,'')
		guictrlsetdata($classlist,$finalclasslist)
		guictrlsetstate($searchedclasses,$GUI_FOCUS)
	EndIf
	
EndFunc   ;==>spellcheck

func _spellcheck()
	$success = 0
	$spellcorrect =stringsplit( "ABLE|ACCT|AMST|ANTH|APMU|ARAB|ARSC|ARTH|ARTS|ASIA|ASTR|BAFI|BETH|BIOC|BIOL|BLAW|CHEM|CHIN|CHST|CIA|CLSC|COSI|DANC|DEND|DENT|EBME|ECHE|ECIV|ECON|EDMP|EDUC|EECS|EMAC|EMAE|EMBA|EMSE|ENGL|ENGR|ENTP|EPBI|EPOM|ESTD|ETHS|FRCH|FSCC|FSNA|FSSO|GEOL|GERO|GREK|GRMN|HBRW|HSMC|HSTY|IIME|ITAL|JAPN|JDST|LATN|LAWS|LHRP|MAND|MATH|MBAC|MEDII|MGMT|MIDS|MKMR|MUHI|MUSC|NEUR|NTRN|NUND|NUNI|NUNP|NURS|OPMT|OPRE|ORBH|PHED|PHIL|PHRM|PHYS|PLCY|POSC|PSCL|QUMM|RLGN|RUSN|SASS|SOCI|SPAN|SSBT|STAT|THTR|UNIV|USNA|USSO|USSY|WLIT|WMST|","|")
	$spellinvert1 = stringsplit("ALBE|ACCT|ASMT|ATNH|AMPU|AARB|ASRC|ATRH|ATRS|AISA|ATSR|BFAI|BTEH|BOIC|BOIL|BALW|CEHM|CIHN|CSHT|CAI|CSLC|CSOI|DNAC|DNED|DNET|EMBE|EHCE|EICV|EOCN|EMDP|EUDC|ECES|EAMC|EAME|EBMA|ESME|EGNL|EGNR|ETNP|EBPI|EOPM|ETSD|EHTS|FCRH|FCSC|FNSA|FSSO|GOEL|GREO|GERK|GMRN|HRBW|HMSC|HTSY|IMIE|IATL|JPAN|JSDT|LTAN|LWAS|LRHP|MNAD|MTAH|MABC|MDEI|MMGT|MDIS|MMKR|MHUI|MSUC|NUER|NRTN|NNUD|NNUI|NNUP|NRUS|OMPT|ORPE|OBRH|PEHD|PIHL|PRHM|PYHS|PCLY|PSOC|PCSL|QMUM|RGLN|RSUN|SSAS|SCOI|SAPN|SBST|SATT|TTHR|UINV|UNSA|USSO|USSY|WILT|WSMT|","|")
	$spellinvert2 = stringsplit("ABEL|ACTC|AMTS|ANHT|APUM|ARBA|ARCS|ARHT|ARST|ASAI|ASRT|BAIF|BEHT|BICO|BILO|BLWA|CHME|CHNI|CHTS|CIA|CLCS|COIS|DACN|DEDN|DETN|EBEM|ECEH|ECVI|ECNO|EDPM|EDCU|EESC|EMCA|EMEA|EMAB|EMES|ENLG|ENRG|ENPT|EPIB|EPMO|ESDT|ETSH|FRHC|FSCC|FSAN|FSOS|GELO|GEOR|GRKE|GRNM|HBWR|HSCM|HSYT|IIEM|ITLA|JANP|JDTS|LANT|LASW|LHPR|MADN|MAHT|MBCA|MEID|MGTM|MISD|MKRM|MUIH|MUCS|NERU|NTNR|NUDN|NUIN|NUPN|NUSR|OPTM|OPER|ORHB|PHDE|PHLI|PHMR|PHSY|PLYC|POCS|PSLC|QUMM|RLNG|RUNS|SASS|SOIC|SPNA|SSTB|STTA|THRT|UNVI|USAN|USOS|USYS|WLTI|WMTS|","|")
	$spellinvert3 = stringsplit("ABL|ACC|AMS|ANT|APM|ARA|ARS|ART|ART|ASI|AST|BAF|BET|BIO|BIO|BLA|CHE|CHI|CHS|CIA|CLS|COS|DAN|DEN|DEN|EBM|ECH|ECI|ECO|EDM|EDU|EEC|EMA|EMA|EMB|EMS|ENG|ENG|ENT|EPB|EPO|EST|ETH|FRC|FSC|FSN|FSS|GEO|GER|GRE|GRM|HBR|HSM|HST|IIM|ITA|JAP|JDS|LAT|LAW|LHR|MAN|MAT|MBA|MED|MGM|MID|MKM|MUH|MUS|NEU|NTR|NUN|NUN|NUN|NUR|OPM|OPR|ORB|PHE|PHI|PHR|PHY|PLC|POS|PSC|QUM|RLG|RUS|SAS|SOC|SPA|SSB|STA|THT|UNI|USN|USS|USS|WLI|WMS|","|")
	
	$class = stringstripws(guictrlread($dept),8)
	for $var = 1 to $spellcorrect[0]
		if not stringinstr($spellcorrect[$var],$class) = 0 then
			$success =  1
			return 1
			ExitLoop
		endif
	Next
	if $success = 1 then return $spellcorrect[$var]
	if $success = 0 then
		for $var = 1 to $spellcorrect[0]
			if not stringinstr($spellinvert1[$var],$class) = 0 then
				$success = 1
				exitloop
			EndIf
			if not stringinstr($spellinvert2[$var],$class) = 0 then
				$success = 1
				exitloop
			EndIf
			if not stringinstr($spellinvert3[$var],$class) = 0 then
				$success = 1
				exitloop
			EndIf
			$success = 0
		Next
		
		if $success = 1 and msgbox(4,"Spelling Error:","The class "&guictrlread($dept)&" "& guictrlread($num) &" has a spelling error. Did you intend to search for "& $spellcorrect[$var] &" "& guictrlread($num) &"?")=7 then
			return $spellcorrect[$var]
		else
			return 0
		EndIf
		
		if $success = 0 then msgbox(0,"Spelling Error:","The class "&guictrlread($dept)&" "& guictrlread($num) &" has a spelling error. Check spelling and try again.")
	endif
	return 0
EndFunc   ;==>_spellcheck


#endregion
func findallschedules()
	;	if $seenthisbefore = 0 and not msgbox(49,"Schedule Overwrite","This operation will overwrite all previously scheduled classes and personal additions. Continue?") = 1 Then
	;		return
	;	Else
	;		$seenthisbefore = 1
	;	EndIf
	guictrlsetstate($resched,$GUI_ENABLE)
	for $first = 0 to 4
		for $second = 0 to 8
			$visualschedule[$first][$second] = ""
		Next
	Next
	
	dirremove("C:\Program Files\Scheduler Pro\classes",1)
	dircreate("C:\Program Files\Scheduler Pro\classes")
	guictrlsetdata($total_hours,"0.0")
	
	ProgressOn("Finding All Schedules", "", "Downloading class information...",(@DesktopWidth / 2) - 150, (@DesktopHeight / 2) - 200)
	Progressset(5)
	
	orderclasses()
	
	if guictrlread($proffessorfilter) = 1 then _orderclasses()
	
	
	$scheduledclasses = stringsplit($finalclasslist,"|") ;how many classes there are in an array
	
	for $classnumber = 1 to $scheduledclasses[0]
		
		$currentclass = stringsplit($finalclasslist,"|")
		$_class = stringsplit($currentclass[$classnumber]," ")
		progressset(25,"Analyzing scheduling requirements...")
		
		if not fileexists("C:\Program Files\Scheduler Pro\classes\"&$currentclass[$classnumber]&".html")  then
			if @error = 0 then
				progressset(45,"Information downloading...")
				
				InetGet("                                                                                                        "&getsemester()&"&subj=" & StringUpper($_class[1]) & "&crse=" & $_class[2] & "&crn=&college=&title=&stime_h=&stime_m=&stime_ampm=am&etime_h=&etime_m=&etime_ampm=am&instr=&desc=&building=&room=&submit=Submit+Query", "C:\Program Files\Scheduler Pro\class.html")
				$newfile = fileopen("C:\Program Files\Scheduler Pro\class.html",1)
				filewriteline($newfile,"<!--                                                                                                        "&getsemester()&"&subj=" & StringUpper($_class[1]) & "&crse=" & $_class[2] & "&crn=&college=&title=&stime_h=&stime_m=&stime_ampm=am&etime_h=&etime_m=&etime_ampm=am&instr=&desc=&building=&room=&submit=Submit+Query")
				fileclose($newfile)
			Else
				
				msgbox(0,"Error","The internet connection was interrupted by third-party software. Check your connection, and try again.")
			EndIf
			progressset(25,"Extracting Class Information for current class...")
			$returnvalue= classextract()
			if $returnvalue=0 then 
				msgbox(0,"No Classes found","There were no courses found for "&StringUpper($_class[1])&" " & $_class[2]&". Remove this course from your queue and try again.")
				return
			EndIf
			if $returnvalue=-1 then 
				msgbox(0,"No Classes found","There was a server error when trying to access information for "&StringUpper($_class[1])&" " & $_class[2]&". Wait a moment, and try again.")
				return
				EndIf
			FILECOPY("C:\Program Files\Scheduler Pro\classtemp.txt","C:\Program Files\Scheduler Pro\classes\"&$currentclass[$classnumber]&".html")
		endif
		
	next
	orderclasses()
	
	if guictrlread($proffessorfilter) = 1 then _orderclasses()
	
	refreshclasslist()
	$currentclass = stringsplit($finalclasslist,"|")
	$crnfile = ''
	progressset(46,"Information Downloaded and Extracted...")
	
	for $classnumber = 1 to $scheduledclasses[0]
		$filename = string("C:\Program Files\Scheduler Pro\classes\"&$currentclass[$classnumber]&".html")
		$length = _filecountlines($filename)
		$cutprof ="||"
		$firsttest = 0
		dim $tempvisual[5][9]
		$success = 0
		#region Begin Professor Rating Comparison --> save only 'best' professor in a TEMP file
		
		
		if guictrlread($proffessorfilter) = 1 then
			for $line = 1  to $length
				$_proftemp = filereadline($filename,$line)
				$__proftemp = stringsplit($_proftemp,"|")
				$proftemp = stringsplit($__proftemp[3],",")
				if stringinstr($cutprof,$proftemp[1])=0 then
					$cutprof = $cutprof &"|"& $proftemp[1]
				EndIf
			Next
			
			$cutprof = stringreplace($cutprof,"No Information","")
			$cutprof = stringreplace($cutprof,"|||","")
			$cutprof = stringreplace($cutprof,"||","|")
			
			$cutprofarray = stringsplit($cutprof,"|")
			$needtorate = 1
			
			if $cutprofarray[0] = 1 then $needtorate = 0
			
			if $needtorate = 1 then
				ProgressSet(52)
				for $currentprof = 1 to $cutprofarray[0]
					ProgressSet(55+$currentprof*3)
					if not  $cutprofarray[$currentprof] = '' then
						$letter = stringleft($cutprofarray[$currentprof],1)
						ProgressSet(60+$currentprof*3)
						$lastname_ = stringsplit($cutprofarray[$currentprof],",")
						$lastname = $lastname_[1]
						ProgressSet(70+$currentprof*3)
						$line = _filelinesearch("C:\Program Files\Scheduler Pro\ratings\"&stringupper($letter)&".html",$lastname,1)
						$line = _filelinesearch("C:\Program Files\Scheduler Pro\ratings\"&stringupper($letter)&".html","col_six",$line)+1
						$profabilityrating = stringformat("%.2f",stringleft(stringtrimleft(stringstripws(filereadline("C:\Program Files\Scheduler Pro\ratings\"&stringupper($letter)&".html",$line),8),3),3))
						$profeaserating =stringformat("%.2f",stringleft(stringtrimleft(stringstripws(filereadline("C:\Program Files\Scheduler Pro\ratings\"&stringupper($letter)&".html",$line+3),8),3),3))
						ProgressSet(80+$currentprof*3)
						$cutprofarray[$currentprof] = $cutprofarray[$currentprof] &"-"&$profabilityrating&","&$profeaserating
					endif
				Next
			endif
			
			$lastscore = 0
			$_bestprofessor = stringsplit($cutprofarray[1],",")
			if $needtorate = 1  then
				for $var = 2 to $cutprofarray[0]
					$_ratings = stringsplit($cutprofarray[$var],"-")
					$ratings = stringsplit($_ratings[2],",")
					$ability = stringformat("%.1f",$ratings[1])
					$ease = stringformat("%.1f",$ratings[2])
					$totalscore = $ability*guictrlread($definebest)/100 + $ease*(100-guictrlread($definebest))/100
					if $totalscore > $lastscore then
						$_bestprofessor = stringsplit($_ratings[1],",")
						$lastscore = $totalscore
					endif
					
				Next
			EndIf
			
			$filename = "C:\Program Files\Scheduler Pro\classes\"&$currentclass[$classnumber]&".temp"
			_filecreate($filename)
			$filehandle1 = fileopen($filename,1)
			$count = _filecountlines("C:\Program Files\Scheduler Pro\classes\"&$currentclass[$classnumber]&".html")
			
			for $counter=1 to $count
				$line = filereadline("C:\Program Files\Scheduler Pro\classes\"&$currentclass[$classnumber]&".html",$counter)
				if not stringinstr($line,$_bestprofessor[1]) = 0 then
					filewriteline($filename,$line)
				EndIf
			Next
			fileclose($filehandle1)
		EndIf
		
		$length =  _filecountlines($filename)
		#endregion
		
		
		for $crntest = 1 to $length
			$classtemp = filereadline($filename,$crntest)
			$classarray = stringsplit($classtemp,"|")
			$success = 0
			
			if not @error then $firsttest = addtoschedule($classarray[2],stringstripws($classarray[7],8),$classarray[8],0)
				
			if $firsttest = 1 then
				$success = 1
				
				$secondtest = addtoschedule($classarray[2],stringstripws($classarray[9],8),$classarray[10],1)
			
				if not stringstripws($classarray[9],8)='' and $secondtest = 1 then
					$success = 1
					
				Else
					if not stringstripws($classarray[9],8)='' then $success = 0
				EndIf
				
			EndIf
			
			if $success = 1 then
				$names = stringsplit(_stringproper($classarray[3]),",")
				$crnfile = $crnfile &"|"&$classarray[1]	&"     "& stringupper($classarray[2])& "     "&_stringproper($names[1])
				GUICtrlSetData($nameGUI, _stringproper(GUICtrlRead($nameGUI) & $classarray[3]) & "|")
				GUICtrlSetData($nameGUI1, _stringproper(GUICtrlRead($nameGUI1) & $classarray[3]) & "|")
				GUICtrlSetData($nameGUI2,_stringproper(GUICtrlRead($nameGUI2) & $classarray[3])& "|")
				
				guictrlsetdata($total_hours,stringformat("%.1f",stringformat("%.2f",guictrlread($total_hours))  + stringformat("%.2f",$classarray[5])))
				ExitLoop
			EndIf
		Next
		if $success = 0 then
			if guictrlread($proffessorfilter) = 1 then
				guictrlsetstate($proffessorfilter,$GUI_UNCHECKED)
				reschedule($scheduledclasses[$classnumber])
				msgbox(0,"Professor Filer",$scheduledclasses[$classnumber] & " was scheduled without the professor filter because the timeslots for the class that Professor " & _stringproper($_bestprofessor[1]) & " teaches are filled.")
			Else
				msgbox(0,"Scheduling Error:","Looks like there is a problem scheduling " & $scheduledclasses[$classnumber]&". All of the possible timeslots are taken.")
				progressoff()
				return 
			EndIf
			
		EndIf
		if stringleft($crnfile,1) = "|" then $crnfile = stringtrimleft($crnfile,1)
		guictrlsetdata($crnlist,stringreplace($crnfile,"|",@crlf))
	Next
	
	$donethisbefore = $donethisbefore + 1
	
	mapall()
	showschedule()
	progressoff()
EndFunc   ;==>findallschedules

func removeclass($removeclass,$hours) ; hours = 1 adjust class hours, else do not adjust hours
	for $first = 0 to 4 ; to duplicate current schedule...
		for $second = 0 to 8
			if $visualschedule[$first][$second] = $removeclass then $visualschedule[$first][$second] = ''
		Next
	Next
	$visualschedule[3][2] = stringreplace($visualschedule[3][2],$removeclass,"")
	if not  stringinstr($crnfile,$removeclass) = 0 then
		$crnfilearray = stringsplit($crnfile,"|")
		for $var = 1 to $crnfilearray[0]
			if not  stringinstr($crnfilearray[$var],$removeclass) = 0 then exitloop
		Next
		_arraydelete($crnfilearray,$var)
		_arraydelete($crnfilearray,0)
		$crnfile = _arraytostring($crnfilearray,"|")
	EndIf
	
	$classtest = stringsplit(filereadline("C:\Program Files\Scheduler Pro\classes\" & $removeclass & ".html"),"|")
	
	if $hours = 1 then guictrlsetdata($total_hours, stringformat("%.1f",stringformat("%.1f",guictrlread($total_hours))- stringformat("%.1f",$classtest[5])))
endfunc   ;==>removeclass

func reschedule($class)
	$tempcrnfile = $crnfile
	for $first = 0 to 4 ; to duplicate current schedule...
		for $second = 0 to 8
			$tempvisual[$first][$second] = $visualschedule[$first][$second]
		Next
	Next
	
	
	if not stringlen(stringstripws($class,8)) = 8 then return 0
	$success = 0
	$length = _filecountlines("C:\Program Files\Scheduler Pro\classes\"&$class&".html")
	$filename = "C:\Program Files\Scheduler Pro\classes\"&$class&".html"
	
	if guictrlread($proffessorfilter) = 1 then
		$length = _filecountlines("C:\Program Files\Scheduler Pro\classes\"&$class&".temp")
		$filename = "C:\Program Files\Scheduler Pro\classes\"&$class&".temp"
	EndIf
	
	$crnfilearray = stringsplit($crnfile,"|")
	$testcrn = 0
	
	for $var = 1 to _FileCountLines($filename)
		if not  stringinstr($crnfile, stringleft(filereadline($filename,$var),5)) = 0 then
			$testcrn = $var
			exitloop
		endif
	Next

	
	removeclass($class,1)
	
	;showschedule()
	
	if $testcrn+1> $length then $testcrn = 0
	
	for $var =$testcrn + 1 to $length
		$classtemparray = stringsplit(filereadline($filename,$var),"|")
		if ubound ($classtemparray)<19 then 
			msgbox(0,"All Times Blocks Already Seen","There are no more time blocks for that class to fill. The next timeblock filled will be the same as the first one.")
			$classtemparray = stringsplit(filereadline($filename,1),"|")
			$testcrn = 0
			EndIf
		$firstattempt = addtoschedule($classtemparray[2],stringstripws($classtemparray[7],8),stringstripws($classtemparray[8],8),0)
		$success = 0
		
		if $firstattempt = 1 then
			$success = 1
			;showschedule()
			$secondattempt = addtoschedule($classtemparray[2],stringstripws($classtemparray[9],8),stringstripws($classtemparray[10],8),1)
			if $secondattempt = 0 and not stringstripws($classtemparray[9],8) = "" then $success = 0
			if $firstattempt = 1 and not stringstripws($classtemparray[9],8) = "" and $secondattempt = 1 then
				if $secondattempt = 1 then
					$success = 1
					;showschedule()
				Else
					$success = 0
				EndIf
			EndIf
			if $secondattempt = 0 and stringstripws($classtemparray[9],8) and $firstattempt = 1 then $success = 1
		Endif
		
		if $success = 0 then
			removeclass($class,0)
		EndIf
		
		if $success = 1 then exitloop
		
	Next
	
	if $success = 1 then
		mapall()
		$names = stringsplit(_stringproper($classtemparray[3]),",")
		$crnfile = $crnfile &"|"&$classtemparray[1]	&@tab& stringupper($classtemparray[2])& @tab&_stringproper($names[1])
		guictrlsetdata($crnlist,stringreplace($crnfile,"|",@crlf))
		GUICtrlSetData($nameGUI, _stringproper(GUICtrlRead($nameGUI) & $classtemparray[3]) & "|")
		GUICtrlSetData($nameGUI1, _stringproper(GUICtrlRead($nameGUI1) & $classtemparray[3]) & "|")
		GUICtrlSetData($nameGUI2,_stringproper(GUICtrlRead($nameGUI2) & $classtemparray[3])& "|")
		guictrlsetdata($total_hours,stringformat("%.1f",stringformat("%.2f",guictrlread($total_hours))  + stringformat("%.2f",$classtemparray[5])))
		showschedule()
		return 1
	EndIf
	
	if $success = 0 then
		$crnfile = $tempcrnfile
		for $first = 0 to 4 ; to duplicate current schedule...
			for $second = 0 to 8
				$visualschedule[$first][$second] = 	$tempvisual[$first][$second]
			Next
		Next
		guictrlsetdata($crnlist,stringreplace($crnfile,"|",@crlf))
		showschedule()
		return 0
	EndIf
EndFunc   ;==>reschedule

func checkschedule($classarray)
	$disable = 1
	$handle = fileopen("C:\Program Files\Scheduler Pro\classes\crnfile.html",1)
	for $line = 1 to _filecountlines("C:\Program Files\Scheduler Pro\classes\crnfile.html")
		$duplicate = 0
		for $x = 1 to $classarray[0]
			$coursecrn = stringleft(stringstripws($classarray[$x],8),5)
			if not stringinstr(filereadline("C:\Program Files\Scheduler Pro\classes/crnfile.html",$line),$coursecrn) = 0 then $duplicate = $duplicate + 1
		Next
	Next
	
	
	if $duplicate = $classarray[0] then
		fileclose($handle)
		if $classarray[0] = stringformat("%i",guictrlread($classcount)) then
			return 0
		EndIf
		
	Else
		
		$temparray = stringsplit($crnfile,"|")
		$temparray1 = stringsplit($crnfile,"|")
		_arraysort($temparray)
		_arraydelete($temparray,0)
		$crnfile = _arraytostring($temparray,"|")
		
		if $temparray1[0] = stringformat("%i",guictrlread($classcount)) then
			filewriteline("C:\Program Files\Scheduler Pro\classes\crnfile.html",$crnfile)
			fileclose($handle)
			return 1
		EndIf
	EndIf
	
	$disable = 0
endfunc   ;==>checkschedule

func addtoschedule($class, $day,$time,$state) ; state = 0 checks for current class in records;;;; state=1 ignores if current class in in the schedule
		
	$time = stringreplace($time,"a","")
	$time = stringreplace($time,"p","")
	$time = stringreplace($time,"-","")
	if $class = '' or $day = '' or $time = '' then return 0
	
	$time2 = stringright($time,4)
	$time = stringleft($time,4)
	$time3 = $time
	
	$time3 = stringformat("%f",stringformat("%f",stringleft($time3,2)) + stringformat("%f",stringright($time3,2))/60)
	$time2 = stringformat("%f",stringformat("%f",stringleft($time2,2)) + stringformat("%f",stringright($time2,2))/60)
	
	if $time3>4.5 and $time3<8.5 then
		if not $disable then MsgBox(0,"Late Night Scheduling...",$class & " has an unusually late class time"&@crlf&"scheduled. It starts at "&  stringleft($time,2) & ":"& stringmid($time,3,2) & " PM , after"&@crlf&"the published scheduled day. It will not"&@crlf&"appear in your visual schedule.")
		return 1
	endif
	
	if $time2<8 then $time2 = $time2 + 12
	if $time3<8 then $time3 = $time3 + 12
	
	$timediff = $time2-$time3
	
	$return = 0
	$day = stringstripws($day,8)
	
	$for_time = stringformat("%i",$time)
	
	if $for_time<=700 then $for_time = $for_time + 1200	
	;test("Before: " & $time)
	
	if $for_time>=830 and $for_time<920 and not ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "0830"
	if $for_time>=920 and $for_time<1020 and not ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "0930"	
	if $for_time>=1020 and $for_time<1120 and not ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "1030"
	if $for_time>=1120 and $for_time<1220 and not ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "1130"
	if $for_time>=1220 and $for_time<1345 and not ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "1230"	
	if $for_time>=1345 and $for_time<1450 and not ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "0200"
	if $for_time>=1450 and $for_time<1550 and not ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "0300"
	if $for_time>=1550 and $for_time<1650 and not ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "0400"
	
	if $for_time>=830 and $for_time<945 and ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "0830"
	if $for_time>=945 and $for_time<1115 and ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "1000"
	if $for_time>=1115 and $for_time<1300 and ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "1130"
	if $for_time>=1300 and $for_time<1430 and ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "0115"
	if $for_time>=1430 and $for_time<1600 and ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "0245"
	if $for_time>=1600 and $for_time<1745 and ($day = "Tues" or $day = "Thurs"or $day = "TuesThurs") then $time = "0430"
	
	;test("After: "&$time)
	
	for $first = 0 to 4 ; to duplicate current schedule...
		for $second = 0 to 8
			$tempvisual[$first][$second] = $visualschedule[$first][$second]
		Next
	Next
	
	
	if not stringinstr($visualschedule[3][2],$class) or $state = 1 then
		
		if not stringinstr($day,"Tues")=0 then ;; Tuesday
			if  $timediff>0 or $time = "0830" and $visualschedule[1][0] = '' then
				if $return = 1 or $time = "0830" then
					$visualschedule[1][0] = $class
					$return = 1
					$timediff = $timediff - 1.25
				endif
			Else
				if $time = "0830" and not $visualschedule[1][0] = '' then return $visualschedule[1][0]
			EndIf
			
			if  $timediff>0 or $time = "1000" and $visualschedule[1][1] = '' then
				if $return = 1 or $time = "1000" then
					$visualschedule[1][1] = $class
					$return = 1
					$timediff = $timediff - 1.25
				endif
			Else
				if $time = "1000"and not $visualschedule[1][1] = '' then return $visualschedule[1][1]
			EndIf
			
			if  $timediff>0  or $time = "1130" or $time ="1135" and $visualschedule[1][2] = '' then
				if $return = 1 or $time = "1130" or $time = "1135"then
					$visualschedule[1][2] = $class
					$return = 1
					$timediff = $timediff - 1.5
				endif
			Else
				if $time = "1130" and not $visualschedule[1][2] = '' then return $visualschedule[1][2]
				if $time = "1135" and not $visualschedule[1][2] = '' then return $visualschedule[1][2]
			EndIf
				
			
			
			if  $timediff>0  or $time = "0115" and $visualschedule[1][3] = '' then
				if $return = 1 or $time = "0115" then
					$visualschedule[1][3] = $class
					$return = 1
					$timediff = $timediff - 1.25
				endif
			Else
				if $time = "0115" and not $visualschedule[1][3] = '' then return $visualschedule[1][3]
			EndIf
			
			if  $timediff>0 or $time = "0245" and $visualschedule[1][4] = '' then
				if $return = 1 or $time = "0245" then
					$visualschedule[1][4] = $class
					$return = 1
					$timediff = $timediff - 1.25
				endif
			Else
				if $time = "0245" and not $visualschedule[1][4] = '' then return $visualschedule[1][4]
			EndIf
			
			if  $timediff>0 or $time = "0430" and $visualschedule[1][5] = '' then
				if $return = 1 or $time = "0430" then
					$visualschedule[1][5] = $class
					$return = 1
					$timediff = $timediff - 1.25
				endif
			Else
				if $time = "0430" and not $visualschedule[1][5] = '' then return $visualschedule[1][5]
			EndIf
		EndIf
		if $return = 1 then $day = stringreplace($day,"Tues","")
		;$return & "|"& @ScriptLineNumber)
		if not stringinstr($day,"Thurs")=0 then ;; Thursday
			if $timediff>0  or $time = "0830" and $visualschedule[3][0] = '' then
				if $return = 1 or $time = "0830" then
					$visualschedule[3][0] = $class
					$return = 1
					$timediff = $timediff - 1.25
				endif
			Else
				if $time = "0830" and not $visualschedule[3][0] = '' then return $visualschedule[3][0]
			EndIf
			;test($return & "|"& @ScriptLineNumber)
			if $timediff>0  or $time = "1000" and $visualschedule[3][1] = '' then
				if $return = 1 or $time = "1000" then
					$visualschedule[3][1] = $class
					$return = 1
					$timediff = $timediff - 2.25
				endif
			Else
				if $time = "1000" and not $visualschedule[3][1] = '' then return $visualschedule[3][1]
			EndIf
			
			
			if $timediff>0  or $time = "0115" and $visualschedule[3][3] = '' then
				if $return = 1 or $time = "0115" then
					$visualschedule[3][3] = $class
					$return = 1
					$timediff = $timediff - 1.25
				endif
			Else
				if  $time = "0115" and not $visualschedule[3][3] = '' then return $visualschedule[3][3]
			EndIf
			
			if $timediff>0  or $time = "0245" and $visualschedule[3][4] = '' then
				if $return = 1 or $time = "0245" then
					$visualschedule[3][4] = $class
					$return = 1
					$timediff = $timediff - 1.25
				endif
			Else
				if $time = "0245" and not $visualschedule[3][5] = '' then return $visualschedule[3][5]
			EndIf
			
			if $timediff>0  or $time = "0430" and $visualschedule[3][5] = '' then
				if $return = 1 or $time = "0430" then
					$visualschedule[3][5] = $class
					$return = 1
					$timediff = $timediff - 1.25
				endif
			Else
				if $time = "0430" and not $visualschedule[3][5] = '' then return $visualschedule[3][5]
			EndIf
		EndIf
		if $return = 1 then $day = stringreplace($day,"Thurs","")
		;test($return & "|"& @ScriptLineNumber)
		if not stringinstr($day,"Mon")=0 then ;; Monday
			if $timediff>0  or $time = "0830" and $visualschedule[0][0] = '' and $visualschedule[0][1] = '' then
				if $return = 1 or $time = "0830" then
					$visualschedule[0][0] = $class
					$return = 1
					$timediff = $timediff - 50/60
				endif
			Else
				if $time = "0830" and not $visualschedule[0][0] = '' or not $visualschedule[0][1] = ''  then return $visualschedule[0][0]
			EndIf
			;test($return & "|"& @ScriptLineNumber)
			if $timediff>0  or  $time = "0900" and $visualschedule[0][1] = '' and $visualschedule[0][0] = '' and $visualschedule[0][2] = ''then
				if $return = 1 or $time = "0900" then
					$visualschedule[0][1] = $class
					$return = 1
					$timediff = $timediff - 1.25
				EndIf
			Else
				if $time = "0900" then
					if not $visualschedule[0][1] = ''  or not  $visualschedule[0][0] = '' or not  $visualschedule[0][2] = '' then return $visualschedule[0][1]
				EndIf
			EndIf
			;test($return & "|"& @ScriptLineNumber)
			if  $timediff>0  or $time = "0930" and $visualschedule[0][2] = '' and $visualschedule[0][1] = '' then
				if $return = 1 or $time = "0930" then
					$visualschedule[0][2] = $class
					$return = 1
					$timediff = $timediff - 50/60
				endif
			Else
				if $time = "0930" and not $visualschedule[0][2] = '' or not $visualschedule[0][1] = ''  then return $visualschedule[0][2]
			EndIf
			;test($return & "|"& @ScriptLineNumber)
			if  $timediff>0  or $time = "1030" and $visualschedule[0][3] = '' then
				if $return = 1 or $time = "1030" then
					$visualschedule[0][3] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "1030" and not $visualschedule[0][3] = '' then return $visualschedule[0][3]
			EndIf
			;test($return & "|"& @ScriptLineNumber)
			if  $timediff>0  or $time = "1130" and $visualschedule[0][4] = '' then
				if $return = 1 or $time = "1130" then
					$visualschedule[0][4] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "1130" and not $visualschedule[0][4] = '' then return $visualschedule[0][4]
			EndIf
			;test($return & "|"& @ScriptLineNumber)
			
			if  $timediff>0  or $time = "1230" and $visualschedule[0][5] = '' then
				if $return = 1 or $time = "1230" then
					$visualschedule[0][5] = $class
					$return = 1
					$timediff = $timediff -1.25
				endif
			Else
				
				if $time = "1230" and not $visualschedule[0][5] = '' then return $visualschedule[0][5]
			EndIf
			;test($return & "|"& @ScriptLineNumber)
			if $timediff>0  or $time = "0200" and $visualschedule[0][6] = '' then
				if $return = 1 or $time = "0200" then
					$visualschedule[0][6] = $class
					$return = 1
					$timediff = $timediff -50/60
				EndIf
			Else
				if $time = "0200" and not $visualschedule[0][6] = '' then return $visualschedule[0][6]
			EndIf
			;test($return & "|"& @ScriptLineNumber)
			if $timediff>0  or  $time = "0300" and $visualschedule[0][7] = '' then
				if $return = 1 or $time = "0300" then
					$visualschedule[0][7] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "0300" and not $visualschedule[0][7] = '' then return $visualschedule[0][7]
			EndIf
			;test($return & "|"& @ScriptLineNumber)
			if $timediff>0  or $time = "0400" and $visualschedule[0][8] = '' then
				if $return = 1 or $time = "0400" then
					$visualschedule[0][8] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "0400" and not $visualschedule[0][8] = '' then return $visualschedule[0][8]
			EndIf
			;test($return & "|"& @ScriptLineNumber)
		EndIf
		if $return = 1 then $day = stringreplace($day,"Mon","")
		;test($return & "|"& @ScriptLineNumber)
		if not stringinstr($day,"Wed")=0 then ;; wednesday
			if $timediff>0  or $time = "0830" and $visualschedule[2][0] = '' and $visualschedule[2][1] = '' then
				if $return = 1 or $time = "0830" then
					$visualschedule[2][0] = $class
					$return = 1
					$timediff = $timediff - 50/60
				endif
			Else
				if $time = "0830" and not $visualschedule[2][0] = '' or not $visualschedule[2][1] = ''  then return $visualschedule[2][0]
			EndIf
			if $timediff>0  or  $time = "0900" and $visualschedule[2][1] = '' and $visualschedule[2][0] = '' and $visualschedule[2][2] = ''then
				if $return = 1 or $time = "0900" then
					$visualschedule[2][1] = $class
					$return = 1
					$timediff = $timediff - 1.25
				EndIf
			Else
				if $time = "0900" then
					if not $visualschedule[2][1] = ''  or not  $visualschedule[2][0] = '' or not  $visualschedule[2][2] = '' then return $visualschedule[2][1]
				EndIf
			EndIf
			if  $timediff>0  or $time = "0930" and $visualschedule[2][2] = '' and $visualschedule[2][1] = '' then
				if $return = 1 or $time = "0930" then
					$visualschedule[2][2] = $class
					$return = 1
					$timediff = $timediff - 50/60
				endif
			Else
				if $time = "0930" and not $visualschedule[2][2] = '' or not $visualschedule[2][1] = ''  then return $visualschedule[2][2]
			EndIf
			
			if  $timediff>0  or $time = "1030" and $visualschedule[2][3] = '' then
				if $return = 1 or $time = "1030" then
					$visualschedule[2][3] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "1030" and not $visualschedule[2][3] = '' then return $visualschedule[2][3]
			EndIf
			
			if  $timediff>0  or $time = "1130" and $visualschedule[2][4] = '' then
				if $return = 1 or $time = "1130" then
					$visualschedule[2][4] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "1130" and not $visualschedule[2][4] = '' then return $visualschedule[2][4]
			EndIf
			
			if  $timediff>0  or $time = "1230" and $visualschedule[2][5] = '' then
				if $return = 1 or $time = "1230" then
					$visualschedule[2][5] = $class
					$return = 1
					$timediff = $timediff -1.25
				endif
			Else
				if $time = "1230" and not $visualschedule[2][5] = '' then return $visualschedule[2][5]
			EndIf
			
			if $timediff>0  or $time = "0200" and $visualschedule[2][6] = '' then
				if $return = 1 or $time = "0200" then
					$visualschedule[2][6] = $class
					$return = 1
					$timediff = $timediff -50/60
				EndIf
			Else
				if $time = "0200" and not $visualschedule[2][6] = '' then return  $visualschedule[2][6]
			EndIf
			
			if $timediff>0  or  $time = "0300" and $visualschedule[2][7] = '' then
				if $return = 1 or $time = "0300" then
					$visualschedule[2][7] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "0300" and not $visualschedule[2][7] = '' then return $visualschedule[2][7]
			EndIf
			if $timediff>0  or $time = "0400" and $visualschedule[2][8] = '' then
				if $return = 1 or $time = "0400" then
					$visualschedule[2][8] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "0400" and not $visualschedule[2][8] = '' then return $visualschedule[2][8]
			EndIf
			
		EndIf
		if $return = 1 then $day = stringreplace($day,"Wed","")
		;test($return & "|"& @ScriptLineNumber)
		if not stringinstr($day,"Fri")=0 then ;; Friday
			if $timediff>0  or $time = "0830" and $visualschedule[4][0] = '' and $visualschedule[4][1] = '' then
				if $return = 1 or $time = "0830" then
					$visualschedule[4][0] = $class
					$return = 1
					$timediff = $timediff - 50/60
				endif
			Else
				if $time = "0830" and not $visualschedule[4][0] = '' or not $visualschedule[4][1] = ''  then return $visualschedule[4][0]
			EndIf
			if $timediff>0  or  $time = "0900" and $visualschedule[4][1] = '' and $visualschedule[4][0] = '' and $visualschedule[4][2] = '' then
				if $return = 1 or $time = "0900" then
					$visualschedule[4][1] = $class
					$return = 1
					$timediff = $timediff - 1.25
				EndIf
			Else
				if $time = "0900" then
					if not $visualschedule[4][1] = ''  or not  $visualschedule[4][0] = '' or not  $visualschedule[4][2] = '' then return $visualschedule[4][1]
				endif
			EndIf
			if  $timediff>0  or $time = "0930" and $visualschedule[4][2] = '' and $visualschedule[4][1] = '' then
				if $return = 1 or $time = "0930" then
					$visualschedule[4][2] = $class
					$return = 1
					$timediff = $timediff - 50/60
				endif
			Else
				if $time = "0930" and not $visualschedule[4][2] = '' or not $visualschedule[4][1] = ''  then return $visualschedule[4][2]
			EndIf
			
			if  $timediff>0  or $time = "1030" and $visualschedule[4][3] = '' then
				if $return = 1 or $time = "1030" then
					$visualschedule[4][3] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "1030" and not $visualschedule[4][3] = '' then return $visualschedule[4][3]
			EndIf
			
			if  $timediff>0  or $time = "1130" and $visualschedule[4][4] = '' then
				if $return = 1 or $time = "1130" then
					$visualschedule[4][4] = $class
					$return = 1
					$timediff = $timediff -2.5
				endif
			Else
				if $time = "1130" and not $visualschedule[4][4] = '' then return $visualschedule[4][4]
			EndIf
			
			
			if $timediff>0  or $time = "0200" and $visualschedule[4][6] = '' then
				if $return = 1 or $time = "0200" then
					$visualschedule[4][6] = $class
					$return = 1
					$timediff = $timediff -50/60
				EndIf
			Else
				if $time = "0200" and not $visualschedule[4][6] = '' then return $visualschedule[4][6]
			EndIf
			
			if $timediff>0  or  $time = "0300" and $visualschedule[4][7] = '' then
				if $return = 1 or $time = "0300" then
					$visualschedule[4][7] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "0300" and not $visualschedule[4][7] = '' then return $visualschedule[4][7]
			EndIf
			if $timediff>0  or $time = "0400" and $visualschedule[4][8] = '' then
				if $return = 1 or $time = "0400" then
					$visualschedule[4][8] = $class
					$return = 1
					$timediff = $timediff -50/60
				endif
			Else
				if $time = "0400" and not $visualschedule[4][8] = '' then return $visualschedule[4][8]
			EndIf
			
		EndIf
		if $return = 1 then $day = stringreplace($day,"Fri","")
		;test($return & "|"& @ScriptLineNumber)
		#region
		if $day = '' then $return = 1
		if $return = 1 then $visualschedule[3][2] = $class & " " & $visualschedule[3][2]
		
		if $return = 0 then
			for $first = 0 to 4 ; to replicate current schedule...
				for $second = 0 to 8
					$visualschedule[$first][$second]=$tempvisual[$first][$second]
				Next
			Next
		endif
		#endregion
		
	EndIf
	;test("Timediff " & $timediff)
	
	return $return
	
EndFunc   ;==>addtoschedule

func showschedule()
	$classarray = stringsplit($finalclasslist,"|")
	_arraydelete($classarray,0)
	dim $colors[ubound($classarray)*2]
	dim $colornames[7]
	$colornames[0]='green'
	$colornames[1]='dblue'
	$colornames[2]='yellow'
	$colornames[3]='orange'
	$colornames[4]='purple'
	$colornames[5]='red'
	$colornames[6]='lblue'
	
	
	for $var = 0 to ubound($colors)-1
		if $var / 2 = int($var/2) Then
			$colors[$var] = $classarray[$var/2]
		EndIf
		
		if $var/2 <> int($var/2) Then
			$colors[$var] = $colornames[int($var/2)+1]
		EndIf
		
	Next

	test($colors)
	
	$workingschedule = _IEBodyReadHTML($htmlschedule)
	progressoff()

	if stringstripws($workingschedule,8) = "0" Then
		_ienavigate($htmlschedule,"C:\Program Files\Scheduler Pro\schedule_original.html")
		$workingschedule = _IEBodyReadHTML($htmlschedule)
	EndIf

	$workingschedule = stringregexpreplace($workingschedule,'<FONT face="Myriad Web Pro">(.*?)</FONT></B></TD><!--','<FONT face="Myriad Web Pro"></FONT></B></TD><!--')
	$workingschedule = stringregexpreplace($workingschedule,'<FONT face="Myriad Web Pro">(.*?)</FONT></B></P></TD><!--t','<FONT face="Myriad Web Pro"></FONT></B></P></TD><!--t')
	
	for $q = 0 to ubound($colornames)-1
		$workingschedule = stringreplace($workingschedule,$colornames[$q],"grey")
		Next
	$workingschedule = stringreplace($workingschedule,"filtegrey","filtered")

	for $number = 0 to 8
		if $number = 1 then $number = 2
		$workingschedule = stringreplace($workingschedule,'<FONT face="Myriad Web Pro"></FONT></B></TD><!--mon '&$number&'','<FONT face="Myriad Web Pro">'&$visualschedule[0][$number]&'</FONT></B></TD><!--mon '&$number)
		if not( $visualschedule[0][$number] = '')  then 
			$position = _arraysearch($colors,$visualschedule[0][$number],0) + 1
			test($colors[$position])
			$workingschedule = stringreplace($workingschedule,'src="schedule_files/grey.gif" width=100 border=0></FONT></B></P></TD><!--*mon '&$number&'-->','src="schedule_files/'&$colors[$position]&'.gif" width=100 border=0></FONT></B></P></TD><!--*mon '&$number&'-->')
			EndIf
		next	
		
$workingschedule = stringreplace($workingschedule,'<FONT face="Myriad Web Pro"></FONT></B></P></TD><!--tues 0','<FONT face="Myriad Web Pro">'&$visualschedule[1][0]&'</FONT></B></P></TD><!--tues 0')
	
	$position = _arraysearch($colors,$visualschedule[1][0],0) + 1
	if not( $visualschedule[1][0] = '')  then $workingschedule = stringreplace($workingschedule,'src="schedule_files/grey.gif" width=100 border=0></FONT></B></P></TD><!--*tues 0','src="schedule_files/'&$colors[$position]&'.gif" width=100 border=0></FONT></B></P></TD><!--*tues 0')
	
	for $number = 1 to 5
		$workingschedule = stringreplace($workingschedule,'<FONT face="Myriad Web Pro"></FONT></B></TD><!--tues '&$number&'','<FONT face="Myriad Web Pro">'&$visualschedule[1][$number]&'</FONT></B></TD><!--tues '&$number)
		$position = _arraysearch($colors,$visualschedule[1][$number],0) + 1
		test($colors[$position])
		if not( $visualschedule[1][$number] = '')  then $workingschedule = stringreplace($workingschedule,'src="schedule_files/grey.gif" width=100 border=0></FONT></B></P></TD><!--*tues '&$number&'-->','src="schedule_files/'&$colors[$position]&'.gif" width=100 border=0></FONT></B></P></TD><!--*tues '&$number&'-->')
	Next
		

	for $number = 0 to 8
		if $number = 1 then $number = 2
		$workingschedule = stringreplace($workingschedule,'<FONT face="Myriad Web Pro"></FONT></B></TD><!--wed '&$number&'','<FONT face="Myriad Web Pro">'&$visualschedule[2][$number]&'</FONT></B></TD><!--wed '&$number)
		$position = _arraysearch($colors,$visualschedule[2][$number],0) + 1
		test($colors[$position])
		if not( $visualschedule[2][$number] = '')  then $workingschedule = stringreplace($workingschedule,'src="schedule_files/grey.gif" width=100 border=0></FONT></B></P></TD><!--*wed '&$number&'-->','src="schedule_files/'&$colors[$position]&'.gif" width=100 border=0></FONT></B></P></TD><!--*wed '&$number&'-->')
		next

$workingschedule = stringreplace($workingschedule,'<FONT face="Myriad Web Pro"></FONT></B></P></TD><!--thurs 0','<FONT face="Myriad Web Pro">'&$visualschedule[3][0]&'</FONT></B></P></TD><!--thurs 0')
	$position = _arraysearch($colors,$visualschedule[3][0],0) + 1
	
	if not( $visualschedule[3][0] = '')  then $workingschedule = stringreplace($workingschedule,'src="schedule_files/grey.gif" width=100 border=0></FONT></B></P></TD><!--*thurs 0','src="schedule_files/'&$colors[$position]&'.gif" width=100 border=0></FONT></B></P></TD><!--*thurs 0')
	for $number = 1 to 5
		if $number = 2 then $number = 3
		$workingschedule = stringreplace($workingschedule,'<FONT face="Myriad Web Pro"></FONT></B></TD><!--thurs '&$number&'','<FONT face="Myriad Web Pro">'&$visualschedule[3][$number]&'</FONT></B></TD><!--thurs '&$number)
		$position = _arraysearch($colors,$visualschedule[3][$number],0) + 1
		test($colors[$position])
		if not( $visualschedule[3][$number] = '')  then $workingschedule = stringreplace($workingschedule,'src="schedule_files/grey.gif" width=100 border=0></FONT></B></P></TD><!--*thurs '&$number&'-->','src="schedule_files/'&$colors[$position]&'.gif" width=100 border=0></FONT></B></P></TD><!--*thurs '&$number&'-->')
		next

	for $number = 0 to 8
		if $number = 1 then $number = 2
		$workingschedule = stringreplace($workingschedule,'<FONT face="Myriad Web Pro"></FONT></B></TD><!--fri '&$number&'','<FONT face="Myriad Web Pro">'&$visualschedule[4][$number]&'</FONT></B></TD><!--fri '&$number)
		$position = _arraysearch($colors,$visualschedule[4][$number],0) + 1
		test($colors[$position])
		if not( $visualschedule[4][$number] = '')  then $workingschedule = stringreplace($workingschedule,'src="schedule_files/grey.gif" width=100 border=0></FONT></B></P></TD><!--*fri '&$number&'-->','src="schedule_files/'&$colors[$position]&'.gif" width=100 border=0></FONT></B></P></TD><!--*fri '&$number&'-->')
	next
	
	$more = stringregexp($workingschedule,"<!--.*?-->",3)

	if ubound($more)>72 then $workingschedule = stringleft($workingschedule,stringinstr($workingschedule,"<!--end-->"))
	
	$workingschedule = stringreplace($workingschedule,"schedule_files/.gif","schedule_files/lblue.gif")


	filedelete("C:\Program Files\Scheduler Pro\schedule_show.html")
	_FILECREATE("C:\Program Files\Scheduler Pro\schedule_show.html")
	$temp  = fileopen("C:\Program Files\Scheduler Pro\schedule_show.html",1)
	filewriteline("C:\Program Files\Scheduler Pro\schedule_show.html",$workingschedule)
	fileclose($temp)
	_IENavigate($htmlschedule,'C:\Program Files\Scheduler Pro\schedule_show.html')
	
EndFunc   ;==>showschedule

Func saveschedule() ; this function saves as a .pro and a .jones file
	
	$savefile = filesavedialog("Save Current Schedule",",'C:\Program Files\Scheduler Pro\Saved Schedules\","Schedule Files (*.pro)", 3)
	if stringinstr($savefile,".pro") = 0 then $savefile = $savefile & ".pro"
	
	$classarray_save = stringsplit($finalclasslist,"|")
	$crnarray_save = stringsplit($crnfile,"|")
	for $var = 0 to ubound($crnarray_save)-1
		$crnarray_save[$var] = stringleft($crnarray_save[$var],5)
		Next
	_arraydelete($classarray_save,0)
	_arraydelete($crnarray_save,0)
	
	if ubound($classarray_save) <> ubound($crnarray_save) then 
		msgbox(0,"Saving Error","There was an error when reading the file parameters. File could not be saved.")
		return
		EndIf
	$savehandle = fileopen($savefile,1)
	for $g = 0 to ubound($classarray_save)-1
		$temphandle = fileopen("c:\program files\scheduler pro\classes\"&$classarray_save[$g]&".html",1)
		$crnline = _filelinesearch("c:\program files\scheduler pro\classes\"&$classarray_save[$g]&".html",$crnarray_save[$g],0)
	
		filewriteline($savefile,filereadline("c:\program files\scheduler pro\classes\"&$classarray_save[$g]&".html",$crnline))
		fileclose($temphandle)
	next
	
	
	
	fileclose($savehandle)
	
	$jonesname = stringright($savefile,stringlen($savefile) - stringinstr($savefile,"\","",-1))
	$jonesname = stringreplace($jonesname,".pro","")

	_filecreate("c:\program files\scheduler pro\saved schedules\"& $jonesname & ".txt")
	$joneshandle = fileopen("c:\program files\scheduler pro\saved schedules\"& $jonesname & ".txt",1)
	filewriteline($joneshandle,"1) "&$jonesname)
	filewriteline($joneshandle, ubound($crnarray_save))
	filewriteline($joneshandle, getsemester())
	;$crnfile &"|"&$classarray[1]	&"     "& stringupper($classarray[2])& "     "&_stringproper($names[1])
	;$course = $crnarray[$var] & "|" & $courseIDarray[$var] & "|" & $profarray[$var] & "|" & $titlearray[$var] & "|" & $creditarray[$var] & "|" & $termarray[$var] & "|" & $dayarray[$var] & "|" & $classtime[$var] & "|" & $recdayarray[$var] & "|" & $recclasstime[$var] & "|" & $buildingarray[$var] & "|" & $roomarray[$var] & "|" & $capacityarray[$var] & "|" & $currentenroll[$var] & "|" & $feearray[$var] & "|" & "" & "|" & "" & "|" & $recbuildingarray[$var] & "|" & $recroomarray[$var] & "|"&$emailarray[$var]
	for $h = 0 to ubound($classarray_save)-1
		$temp_class_array = stringsplit(filereadline($savefile,$h+1),"|")
			
		filewriteline($joneshandle, stringleft($temp_class_array[2],4)) ;dept
		filewriteline($joneshandle, stringtrimleft($temp_class_array[2],5)) ; num
		filewriteline($joneshandle, $temp_class_array[7]) ;day 1
		filewriteline($joneshandle, $temp_class_array[8]) ;time 1
		if $temp_class_array[11] = '' then $temp_class_array[11] = " N/A"
		filewriteline($joneshandle, "Building:" & $temp_class_array[11]) ;building 1
		if stringstripws($temp_class_array[9],8) = '' then
			filewriteline($joneshandle, "")
		else 
			filewriteline($joneshandle, $temp_class_array[9]);rectime 1
		EndIf
		if stringstripws($temp_class_array[10],8) = '' then
			filewriteline($joneshandle, "")
		else 
			filewriteline($joneshandle, $temp_class_array[10]);rectime 2
		EndIf
		if $temp_class_array[12] = '' then $temp_class_array[12] = " N/A"
		filewriteline($joneshandle, "Building2:"&$temp_class_array[12]);recbuilding
		filewriteline($joneshandle, $temp_class_array[5]);credit
		filewriteline($joneshandle, $temp_class_array[3]);professor
		filewriteline($joneshandle, $temp_class_array[1]);crn
	Next
	filewriteline($joneshandle,0)
	filewriteline($joneshandle, getname())
	fileclose($joneshandle)
	
	if 7 = msgbox(4,"Save Online?","Would you like to save this schedule online so that others can view your schedule?")then Return
	
	$jonesname_online = stringright($savefile,stringlen($savefile) - stringinstr($savefile,"\","",-1))
	$jonesname_online = stringreplace($jonesname_online,".pro","")

	_filecreate("c:\program files\scheduler pro\saved schedules\"& $jonesname_online & ".txt")
	$joneshandle_online = fileopen("c:\program files\scheduler pro\saved schedules\"& $jonesname_online & ".txt",1)
	$name_online = stringsplit(getname()," ")
	;filewriteline($joneshandle_online, $name_online[2] &","&$name_online[1])
	filewriteline($joneshandle,"                            , ")
	test($name_online[2] &","&$name_online[1])
	;filewriteline($joneshandle_online,"1) "&$joneshandle_online)
	filewriteline($joneshandle_online, getsemester())
	filewriteline($joneshandle_online, ubound($crnarray_save)&"*")
	filewriteline($joneshandle_online,"0!")
	filewriteline($joneshandle_online,stringformat("%i",guictrlread($total_hours))&"$")
	for $h = 0 to ubound($classarray_save)-1
		$temp_class_array = stringsplit(filereadline($savefile,$h+1),"|")
		filewriteline($joneshandle_online, stringleft($temp_class_array[2],4)) ;dept
		filewriteline($joneshandle_online, stringtrimleft($temp_class_array[2],5)) ; num
		filewriteline($joneshandle_online, $temp_class_array[7]) ;day 1
		filewriteline($joneshandle_online, $temp_class_array[8]) ;time 1
		if $temp_class_array[11] = '' then $temp_class_array[11] = " N/A"
		filewriteline($joneshandle_online, "Building:" & $temp_class_array[11]) ;building 1
		if stringstripws($temp_class_array[9],8) = '' then
			filewriteline($joneshandle_online, "")
		else 
			filewriteline($joneshandle_online, $temp_class_array[9]);rectime 1
		EndIf
		if stringstripws($temp_class_array[10],8) = '' then
			filewriteline($joneshandle_online, "")
		else 
			filewriteline($joneshandle_online, $temp_class_array[10]);rectime 2
		EndIf
		if $temp_class_array[12] = '' then $temp_class_array[12] = " N/A"
		filewriteline($joneshandle_online, "Building2:"&$temp_class_array[12]);recbuilding
		filewriteline($joneshandle_online, $temp_class_array[5]);credit
		filewriteline($joneshandle_online, $temp_class_array[3]);professor
		filewriteline($joneshandle_online, $temp_class_array[1]);crn
	Next
	fileclose($joneshandle_online)
	
	;"c:\program files\scheduler pro\saved schedules\"& $jonesname & ".txt"	
	
	$IE = _iecreate("c:\program files\scheduler pro\saved schedules\"& $jonesname & ".txt",0,0)
	$text = _IEBodyReadText($IE)
	$text = stringreplace($text," ","%20")
	$text = stringreplace($text,@crlf,"!*!")
	$text = stringreplace($text,"N/A","%20")
	_ienavigate($IE,"conesus.cwru.edu/schedules/save.php?term="&getsemester() & "&data="&$text&"!*! HTTP/1.1")
	_ieloadwait($ie)
	_iequit($ie)
	msgbox(0,"Sent","Your schedule has been saved online and can be accessed by either Scheduler Jones or Scheduler Pro.",5)
EndFunc   ;==>saveschedule

Func _loadschedule()
	
	$loadfile = FileOpenDialog("Open Schedule File",",'C:\Program Files\Scheduler Pro\Saved Schedules\","Schedule Files (*.pro)", 3)
	

	$loadhandle = fileopen($loadfile,1)
	
	$length = _FileCountLines($loadfile)
	
	for $var = 1 to $length
		$read_line = stringsplit(filereadline($loadfile,$var),"|")
		$firsttest = addtoschedule($read_line[2],$read_line[7],$read_line[8],1)
		if stringstripws($read_line[9],8) <> '' and $firsttest = 1 then 
			$secondtest = addtoschedule($read_line[2],$read_line[9],$read_line[10],0)
			if $secondtest = 0 then msgbox(0,"Loading Error","There was an unexpected error when trying to load the file that you selected. It appears as though there is a scheduling conflict.")
			endif
		Next
	fileclose($loadhandle)
	showschedule()
EndFunc   ;==>_loadschedule

Func loadjones()
	clearall()
	For $var = 1 To 5
		$temphandle = FileOpen("c:\program files\scheduler jones\" & $var & ".txt", 1)
		If Not StringInStr(FileReadLine("c:\program files\scheduler jones\" & $var & ".txt", 1), GUICtrlRead($loadjones)) = 0 Then ExitLoop
		FileClose($temphandle)
	Next
	
	$number_ = FileReadLine("c:\program files\scheduler jones\" & $var & ".txt", 2)
	If $number_ = 0 Then Return 0
	
	$fullschedule = ''
	
	For $class = 4 To _FileCountLines("c:\program files\scheduler jones\" & $var & ".txt")
		$fullschedule = $fullschedule & FileReadLine("c:\program files\scheduler jones\" & $var & ".txt", $class) & "|"
		If Mod($class - 3, 11) = 0 Then $fullschedule = $fullschedule & @CRLF
	Next
	
	FileClose($temphandle)
	
	_FileCreate("C:\Program Files\Scheduler Pro\sjones.temp")
	$temphandle = FileOpen("C:\Program Files\Scheduler Pro\sjones.temp", 1)
	FileWriteLine("C:\Program Files\Scheduler Pro\sjones.temp", $fullschedule)
	FileClose("C:\Program Files\Scheduler Pro\sjones.temp")
	loadschedulerjones()
EndFunc   ;==>loadjones

Func loadschedulerjones()
	
	for $first = 0 to 4
		for $second = 0 to 8
			$visualschedule[$first][$second] = ""
		Next
	Next
	
	
	$numberofclasses = _FileCountLines("C:\Program Files\Scheduler Pro\sjones.temp")
	
	guictrlsetstate($resched,$gui_disable)
	$credits = 0
	$crnfiletemp = ''
	$crnlisttemp = ''
	For $var = 1 To $numberofclasses - 1
		$classarray = StringSplit(FileReadLine("C:\Program Files\Scheduler Pro\sjones.temp", $var), "|")
		$credits = $credits + stringformat("%.1f",$classarray[9])
		$crnlisttemp = $crnlisttemp & "|"& $classarray[1] & " " & $classarray[2]
		$crnfiletemp = $crnfiletemp & @crlf& $classarray[11] &@tab& $classarray[1] & " " & $classarray[2] &@tab& _stringproper(stringleft($classarray[10],stringinstr($classarray[10],",")-1))
	Next
	
	$crnlisttemp = stringtrimleft($crnlisttemp,1)
	$finalclasslist = $crnlisttemp
	guictrlsetdata($classlist,$crnlisttemp)
	guictrlsetdata($total_hours, $credits)
	guictrlsetdata($crnlist,$crnfiletemp)

	
	For $var = 1 To $numberofclasses - 1
		$classarray = StringSplit(FileReadLine("C:\Program Files\Scheduler Pro\sjones.temp", $var), "|")
		
		$classname = $classarray[1] & " " & $classarray[2]
	Next	
EndFunc   ;==>loadschedulerjones

Func loadschedule()
	$choose = ''
	For $var = 1 To 5
		If FileExists("c:\program files\scheduler jones\" & $var & ".txt") Then $choose = $choose & StringTrimLeft(FileReadLine("c:\program files\scheduler jones\" & $var & ".txt", 1), 3) & "|"
	Next
	Return $choose
EndFunc   ;==>loadschedule

Func print()
	winactivate("Schedule")
	send("^p")
	winwait("Print")
	msgbox(0,"Rotate","If you want the schedule to print full page, rotate the page so that it prints landscape.")
	return
endFunc   ;==>print

Func findinfo()
	$data = _spellcheck()
	if  $data = 0 then return
	
	GUICtrlSetData($dept, stringstripws(StringUpper(GUICtrlRead($dept)),8))
	
	_GUICtrlComboResetContent($crn)
	clearall()
	$handle = WinGetHandle("Class Scheduler Pro")
	GUISwitch($handle)
	ProgressOn("Adding Class...", "", "Accessing Course Information", (@DesktopWidth / 2) - 150, (@DesktopHeight / 2) - 200)
	ProgressSet(15, "Checking Internet Connectivity...")

	if 0=InetGet("                                                                                                        "&getsemester()&"&subj=" & StringUpper(GUICtrlRead($dept)) & "&crse=" & GUICtrlRead($num) & "&crn=&college=&title=&stime_h=&stime_m=&stime_ampm=am&etime_h=&etime_m=&etime_ampm=am&instr=&desc=&building=&room=&submit=Submit+Query", "C:\Program Files\Scheduler Pro\class.html") then 
		msgbox(0,"Connection Error","There was a problem downloading the page. It doesn't seem like you are connected to the internet.")
		progressoff()
		Return
	EndIf
	
	
	$newfile = fileopen("C:\Program Files\Scheduler Pro\class.html",1)
	filewriteline($newfile,"<!--                                                                                                        "&getsemester()&"&subj=" & StringUpper(GUICtrlRead($dept)) & "&crse=" & GUICtrlRead($num) & "&crn=&college=&title=&stime_h=&stime_m=&stime_ampm=am&etime_h=&etime_m=&etime_ampm=am&instr=&desc=&building=&room=&submit=Submit+Query")
	fileclose($newfile)
	
	
	ProgressSet(45, "Extracting Course Reference Numbers (CRN)")
	$classtemp = FileOpen("C:\Program Files\Scheduler Pro\classtemp.txt", 1)
	$_number = classextract()
	if $_number = -1 then 
		msgbox(0,"No Classes Found","There was a server error, the Searchable Schedule of Classes is temporarily offline. Wait a moment and try again.")
		Return
	EndIf
	if $_number = 0 then 
		msgbox(0,"No Classes Found","There are no classes matching that course number and department code. Check spelling and try again.")
		Return
		EndIf
	$numbers = ''
	For $line = 1 To $_number
		$coursearray = StringSplit(FileReadLine("C:\Program Files\Scheduler Pro\classtemp.txt", $line), "|")
		If Not $line = 1 Then
			GUICtrlSetData($crn, GUICtrlRead($crn) & $coursearray[1] & "|", $coursearray[1])
			
		Else
			GUICtrlSetData($crn, $coursearray[1] & "|", $coursearray[1])
		EndIf
		if stringinstr($numbers,stringstripws(stringtrimleft($coursearray[2],4),8)&"|")=0 then $numbers = $numbers & stringstripws(stringtrimleft($coursearray[2],4),8) &"|"
	Next
	
	guictrlsetdata($num,$numbers,stringleft($numbers,stringinstr($numbers,"|")))
	
	$num_ = stringsplit($numbers,"|")
	_ArrayDelete($num_,0)
	if ubound($num_)>2 Then
		for $u=0 to ubound($num_)-1
			_filecreate("C:\Program Files\Scheduler Pro\classes\" & stringupper(guictrlread($dept)) & " "& $num_[$u] & ".html")
			$current_file = fileopen("C:\Program Files\Scheduler Pro\classes\" & stringupper(guictrlread($dept)) & " "& $num_[$u] & ".html",1)
			for $j = 1 to $_number
				if stringinstr(filereadline("C:\Program Files\Scheduler Pro\classtemp.txt",$j),stringupper(guictrlread($dept)) & " "& $num_[$u])<> 0 then 

					filewriteline($current_file,filereadline("C:\Program Files\Scheduler Pro\classtemp.txt",$j))
					EndIf
				Next
			Next
			fileclose($current_file)
		EndIf
	
	$coursearray = _arraydelete($coursearray,ubound($coursearray)-1)
	
	$allprofs = ''
	For $line = 1 To $_number
		$coursearray = StringSplit(FileReadLine("C:\Program Files\Scheduler Pro\classtemp.txt", $line), "|")
		If Not @error And Not StringInStr($allprofs, $coursearray[3]) Then
			GUICtrlSetData($nameGUI, _stringproper(GUICtrlRead($nameGUI) & "|"& $coursearray[3]) & "|")
			GUICtrlSetData($nameGUI1, _stringproper(GUICtrlRead($nameGUI1) & "|"& $coursearray[3]) & "|")
			GUICtrlSetData($nameGUI2,_stringproper(GUICtrlRead($nameGUI2) & "|"& $coursearray[3])& "|")
			$allprofs = $allprofs & $coursearray[3]
		EndIf
	Next
		
	FileClose($classtemp)
	filldata()
	ProgressOff()
EndFunc   ;==>findinfo


Func scheduleclassmanual()
	if FileExists("C:\Program Files\Scheduler Pro\Classes\"&stringupper(guictrlread($dept)) & " " & guictrlread($num) & ".html") = 0 then 
		$crn_temp = guictrlread($crn)
		findinfo()
		_GUICtrlComboSelectString($crn,-1,$crn_temp)
		filldata()
	endif
	
	$day = stringstripws(guictrlread($daysinput),8)&"-"
	$day = stringreplace($day,"--","-")
	$weekday = stringsplit($day,"-")
	$time = stringstripws(guictrlread($timesinput),8)&"-"
	$time = stringreplace($time,"--","*")
	$time = stringreplace($time,"-","")
	$weektime = stringsplit($time,"*")
	$success = 0
	_arrayadd($weektime,"")
	_arrayadd($weekday,"")
	;addtoschedule(stringupper(guictrlread($dept)) &" "& guictrlread($num),$weekday[1],$weektime[1],0)
	
	
	$firsttest = addtoschedule(stringupper(guictrlread($dept)) &" "& guictrlread($num),$weekday[1],$weektime[1],0)
	
	if $firsttest = 1 then
		$success = 1
		$secondtest = addtoschedule(stringupper(guictrlread($dept)) &" "& guictrlread($num),$weekday[2],$weektime[2],1)
		
		if not stringstripws($weekday[2],8)='' and $secondtest = 1 then
			$success = 1
		Else
			if not stringstripws($weekday[2],8)='' then $success = 0
		EndIf
	Else
		if $firsttest = 0 then msgbox(0,"Erroneous!","You can't schedule that class. Either there isn't valid time or day information, or there is something in its place already.")
	EndIf
	if $success = 1 then
		$finalclasslist = $finalclasslist &"|"& StringUpper(GUICtrlRead($dept)) & " "& GUICtrlRead($num)
		$crnfile = $crnfile &" "&guictrlread($crn)
		guictrlsetdata($total_hours,stringformat("%.1f",stringformat("%.2f",guictrlread($total_hours))  + stringformat("%.2f",guictrlread($credithours))))
	EndIf
	
	_GUICtrlListAddItem($classlist,guictrlread($dept) & " " &guictrlread($num))
	guictrlsetdata($crnlist, guictrlread($crn) &@tab&  guictrlread($dept) & " " & guictrlread($num)&@tab&guictrlread($professorinput))
	showschedule()
EndFunc   ;==>scheduleclassmanual

Func clearall()
	GUICtrlSetData($Credithours, "")
	GUICtrlSetData($timesinput, "")
	GUICtrlSetData($professorinput, "")
	GUICtrlSetData($buildinginput, "")
	GUICtrlSetData($capacity, "")
	GUICtrlSetData($daysinput, "")
EndFunc   ;==>clearall

Func filldata()
	If guictrlread($crn)='' or guictrlread($num)=''Then
		Return 0
	EndIf
	
	if _GUICtrlComboGetDroppedState($num) then 
		_GUICtrlComboResetContent($crn)
		for $f = 1 to _FileCountLines("C:\Program Files\Scheduler Pro\classtemp.txt")
			$line = stringsplit(filereadline("C:\Program Files\Scheduler Pro\classtemp.txt",$f),"|")
			if stringinstr($line[2],guictrlread($num)) then 
				If Not $f = 1 Then
					GUICtrlSetData($crn, GUICtrlRead($crn) & $line[1] & "|", $line[1])
				Else
					GUICtrlSetData($crn, $line[1] & "|", $line[1])
				EndIf
			EndIf
			Next
		EndIf
		
	$_findcrn = _filelinesearch ("C:\Program Files\Scheduler Pro\classtemp.txt", GUICtrlRead($crn), 1)
	$course = StringSplit(FileReadLine("C:\Program Files\Scheduler Pro\classtemp.txt", $_findcrn), "|")
	
	If $course[0] > 1 Then
		;_GUICtrlComboSetCurSel($crn,$_findcrn-2)
		guictrlsetdata($course_title,_stringproper(stringleft($course[4],30)))
		GUICtrlSetData($professorinput, _StringProper($course[3]))
		GUICtrlSetData($buildinginput, _StringProper($course[11]) & " " & $course[12])
		GUICtrlSetData($daysinput, _StringProper($course[7]))
		GUICtrlSetData($buildinginput2, _StringProper($course[18]) & " " & $course[19])
		If Not StringStripWS($course[9], 8) = "" Then GUICtrlSetData($daysinput, StringStripWS(_StringProper($course[7]) & " -- " & _StringProper($course[9]), 3))
		GUICtrlSetData($timesinput, $course[8])
		If Not StringStripWS($course[10], 8) = "" Then GUICtrlSetData($timesinput, $course[8] & " -- " & $course[10])
		GUICtrlSetData($Credithours, $course[5])
		GUICtrlSetData($capacity, $course[13])
	EndIf
	findbuilding()
EndFunc   ;==>filldata

Func professorrate()
	GUICtrlSetState($tab1, $GUI_SHOW)
	guictrlsetdata($nameGUI, _StringProper(GUICtrlRead($professorinput)))
	professorrating()
EndFunc   ;==>professorrate

Func swap()
	For $var = 0 To 15
		
		If GUICtrlGetState($tab2controls[$var]) = 80 Then
			GUICtrlSetState($tab2controls[$var], $GUI_HIDE)
		Else
			If GUICtrlGetState($tab2controls[$var]) = 96 Then GUICtrlSetState($tab2controls[$var], $GUI_SHOW)
		EndIf
	Next
	
	For $var = 0 To 15
		
		If GUICtrlGetState($tab2controls1[$var]) = 80 Then
			GUICtrlSetState($tab2controls1[$var], $GUI_HIDE)
		Else
			If GUICtrlGetState($tab2controls1[$var]) = 96 Then GUICtrlSetState($tab2controls1[$var], $GUI_SHOW)
		EndIf
	Next
EndFunc   ;==>swap

Func professorcompare()
	$firstname = String("")
	if GUICtrlRead($nameGUI1) = '' or GUICtrlRead($nameGUI2) = '' or stringstripws(GUICtrlRead($nameGUI1),8) = 'NoInformation' or  _
			stringstripws(GUICtrlRead($nameGUI2),8) = 'NoInformation' or stringlen($namegui1)<2 or stringlen($namegui2)<2  _
			or stringlen(GUICtrlRead($nameGUI1)) <2 or stringlen(GUICtrlRead($nameGUI2)) <2 then 
		msgbox(0,"No Comparison:", "No comparison can be made because one (or both) of the requested professor names is invalid. To rate a single professor, switch to the single professor review screen.")
		Return
	endif
	
	if stringinstr(guictrlread($namegui1), ",") = 0 then guictrlsetdata($namegui1,guictrlread($namegui1)&",")
	if stringinstr(guictrlread($namegui2), ",") = 0 then guictrlsetdata($namegui2,guictrlread($namegui2)&",")
	
	$professor1 = StringSplit(GUICtrlRead($nameGUI1), ",")
	$professor2 = StringSplit(GUICtrlRead($nameGUI2), ",")
	
	If Not @error Then $professor1[2] = StringLeft($professor1[2], 3)
	If Not @error Then $professor2[2] = StringLeft($professor2[2], 3)
	ProgressOn("Professor Ratings", "", "Finding Professor Ratings")
	For $var1 = 1 To 2
		ProgressSet(10 * $var1)
		If $var1 = 1 Then
			$letter = StringLeft($professor1[1], 1)
			$_lastname = $professor1[1]
			If $professor1[0] = 2 Then $firstname = $professor1[2]
			If $firstname = "" Then
				ProgressOff()
				$firstname = InputBox("First Name", "What is the first name (partial or full) of Professor " & $_lastname & "?" & @CRLF & "If you do not know, then click OK and the first Professor with that last name will be rated.", "", "", 300, 160)
				ProgressOn("Professor Ratings", "", "Finding Professor Ratings")
			EndIf
			If @error Then $firstname = $professor1[2]
			
		EndIf
		If $var1 = 2 Then
			$letter = StringLeft($professor2[1], 1)
			$_lastname = $professor2[1]
			If $professor2[0] = 2 Then $firstname = $professor2[2]
			If $firstname = "" Then
				ProgressOff()
				$firstname = InputBox("First Name", "What is the first name (partial or full) of Professor " & $_lastname & "?" & @CRLF & "If you do not know, then click OK and the first Professor with that last name will be rated.", "", "", 300, 160)
				ProgressOn("Professor Ratings", "", "Finding Professor Ratings")
			EndIf
			If @error Then $firstname = $professor2[2]
		EndIf
		ProgressSet(20 * $var1)
		$filename = ("C:\Program Files\Scheduler Pro\ratings\" & $letter & ".html")
		$exists = FileExists($filename)
		;$age = FileGetTime($filename,0,0)
		$handle = FileOpen($filename, 0)
		If $exists = 0 And Not $letter = 0 Then InetGet("http://www.ratemyprofessors.com/SelectTeacher.jsp?sid=186&orderby=TLName&letter=" & $letter, $filename)
		
		$line = 0
		If Not $firstname = "" Then
			For $var = 1 To _FileCountLines($filename)
				If Not StringInStr(FileReadLine($filename, $var), $firstname) = 0 And Not StringInStr(FileReadLine($filename, $var), $_lastname) = 0 Then
					$line = $var
					ExitLoop
				EndIf
			Next
		EndIf
		ProgressSet(30 * $var1)
		If $firstname = "" Then
			For $var = 1 To _FileCountLines($filename)
				If Not StringInStr(FileReadLine($filename, $var), $_lastname) = 0 Then
					$line = $var
					ExitLoop
				EndIf
			Next
		EndIf
		ProgressSet(40 * $var1)
		If $line = 0 Then
			progressoff()
			MsgBox(0, "Information Could Not Be Retrieved", "Professor Information Not Found. Please visit www.ratemyprofessor.com to submit a rating")
			ProgressOn("Professor Ratings", "", "Finding Professor Ratings")
		EndIf
		If $var1 = 1 Then $professor1[0] = $line
		If $var1 = 2 Then $professor2[0] = $line
		
		$lineend = _FileLineSearch ($filename, "col_one", $line)
		If $lineend = 0 Then $lineend = _FileLineSearch ($filename, "end code", $line + 1)
		FileClose($handle)
		$prof_info = _removeHTML ($filename, $line, $lineend)
		If $var1 = 1 Then
			
			If Not $prof_info = 0 Then
				$prof_info = StringReplace($prof_info, @CRLF, "|")
				$infoarray = StringSplit($prof_info, "|")
				GUICtrlSetData($_ease1, StringFormat("%f", (5 - $infoarray[5])) * 19)
				GUICtrlSetData($_ability1, StringFormat("%f", $infoarray[4]) * 19)
			EndIf
		EndIf
		ProgressSet(45 * $var1)
		If $var1 = 2 Then
			;test($prof_info)
			If Not $prof_info = 0 Then
				$prof_info = StringReplace($prof_info, @CRLF, "|")
				$infoarray = StringSplit($prof_info, "|")
				GUICtrlSetData($_ease2, StringFormat("%f", (5 - $infoarray[5])) * 19)
				GUICtrlSetData($_ability2, StringFormat("%f", $infoarray[4]) * 19)
			EndIf
		EndIf
		
	Next
	If GUICtrlRead($_ease1) < GUICtrlRead($_ease2) Then
		$_lastname = GUICtrlRead($nameGUI1)
	Else
		$_lastname = GUICtrlRead($nameGUI2)
	EndIf
	
	GUICtrlSetData($_easeverdict, "Professor " & stringleft(_StringProper($_lastname),stringinstr($_lastname,",")-1) & " teaches the easier class.")
	
	If GUICtrlRead($_ability1) > GUICtrlRead($_ability2) Then
		$_lastname = GUICtrlRead($nameGUI1)
	Else
		$_lastname = GUICtrlRead($nameGUI2)
	EndIf
	
	GUICtrlSetData($_abilityverdict, "Professor " &stringleft(_StringProper($_lastname),stringinstr($_lastname,",")-1) & " is rated to be the better instructor.")
	ProgressOff()
EndFunc   ;==>professorcompare

Func professorrating()
	$info = professor()
	If Not $info = 0 Then
		$info = StringReplace($info, @CRLF, "|")
		$infoarray = StringSplit($info, "|")
		
		GUICtrlSetData($ease, StringFormat("%f", (5 - $infoarray[5])) * 19)
		GUICtrlSetData($quality, StringFormat("%f", $infoarray[4]) * 19)
		
		
		GUICtrlSetData($date, "Last:" & $infoarray[2])
		If StringInStr($infoarray[3], "nbsp") = 0 Then
			GUICtrlSetData($reviews, "Reviews: " & $infoarray[3])
		Else
			GUICtrlSetData($reviews, "Reviews: NA")
		EndIf
		
		GUICtrlSetData($namelabel, $infoarray[1])
		$_lastname = StringLeft($infoarray[1], StringInStr($infoarray[1], ",") - 1)
		$line = _filelinesearch("C:\Program Files\Scheduler Pro\classtemp.txt",stringstripws(stringupper($_lastname),8),0)
		$infoarray1 = stringsplit(filereadline("C:\Program Files\Scheduler Pro\classtemp.txt",$line),"|")
		guictrlsetdata($email,$infoarray1[ubound($infoarray1)-1])
				
		;GUICtrlSetData($email, StringLeft(StringTrimLeft(FileReadLine("C:\Program Files\Scheduler Pro\class.html", _filelinesearch ("C:\Program Files\Scheduler Pro\class.html", StringLeft($infoarray[1], StringInStr($infoarray[1], ",") - 1), 1)), 43), 20))
	EndIf
EndFunc   ;==>professorrating

Func findbuilding()
	
	$buildingname = String("")
	$location = _filelinesearch ("C:\Program Files\Scheduler Pro\classtemp.txt", GUICtrlRead($crn), 1)
	$classinfo = StringSplit(FileReadLine("C:\Program Files\Scheduler Pro\classtemp.txt", $location), "|")
	If Not @error Then
		$short_building = $classinfo[11]
	Else
		$short_building = StringLeft(StringStripWS(GUICtrlRead($buildinginput), 8), 4)
	EndIf
	
	$short_building = StringLeft(GUICtrlRead($buildinginput), 4)
	$short_building_location = _filelinesearch ("C:\Program Files\Scheduler Pro\buildings.txt", $short_building, 1)
	$long_building = FileReadLine("C:\Program Files\Scheduler Pro\buildings.txt", $short_building_location)
	
	if not stringinstr($long_building,"|")=0 then $long_building = stringleft($Long_building,stringinstr($long_building,"|")-1)
	if $long_building = '' and not guictrlread($buildingname)='' then 
		msgbox(0,"Error","This building code is not recognised by SchedulerPro. If you want to make an exception for this code to find the correct building, find the building in the file c:\program files\scheduler pro\buildings.txt and add the unknown code after a '|' symbol on the line with the appropriate building to display (ie Millis|Dgrc for Degrace Hall in the Hillis building.")
		endif
	if $long_building = "Peter B. Lewis" then
		inetget("                                                                       ","C:\Program Files\Scheduler Pro\buildings\" & StringLower($long_building) & ".jpg")
	Else
		InetGet("http://www.cwru.edu/pix/buildings/" & stringstripws(StringLower($long_building),8) & ".jpg", "C:\Program Files\Scheduler Pro\buildings\" & StringLower($long_building) & ".jpg")
	EndIf
	
	GUICtrlSetImage($buildingpic, "C:\Program Files\Scheduler Pro\buildings\" & StringLower($long_building) & ".jpg")
	If FileGetSize("C:\Program Files\Scheduler Pro\buildings\" & StringLower($long_building) & ".jpg") / 1024 < 10 Then guictrlsetimage($buildingpic,"C:\Program Files\Scheduler Pro\buildings\veale.jpg")
	GUICtrlSetData($buildinglabel, _StringProper($long_building))
EndFunc   ;==>findbuilding

func professor()
	GUICtrlSetData($ease, 0)
	GUICtrlSetData($quality, 0)
	GUICtrlSetData($namelabel, "")
	GUICtrlSetData($email, "")
	GUICtrlSetData($reviews, "")
	GUICtrlSetData($date, "")
	progresson("Finding Professor Information","")
	progressset(10)
	$name = guictrlread($nameGUI)&","
	$name_array = stringsplit($name,",")
	$name = $name_array[1]
	
	$letter = stringleft(stringstripws($name,8),1)
	
	if $letter = '' then 
		progressoff()
		msgbox(0,"Name Problem","Make sure that you type a valid professor name...")
		return 0
		EndIf
	
	progressset(15)
	$IEo = _iecreate("http://www.ratemyprofessors.com/SelectTeacher.jsp?sid=186&orderby=TLName&letter=" & $letter,0,0)
	_ieaction($IEo,"refresh")
	progressset(30)
	$body = _iebodyreadtext($IEo)
	progressset(60)
	$body = stringreplace($body,"    ","|")
	$body = stringtrimleft($body,stringinstr($body,$name)-1)
	$body = stringleft($body,stringinstr($body,"|")-1)
	$body = stringreplace($body," ","|")
	$body_a = stringsplit($body,"|")
	_arraydelete($body_a,3)
	$body_a[1] = $body_a[1]&$body_a[2]
	_arraydelete($body_a,2)
	_arraydelete($body_a,0)
	progressset(100)
	$body = _arraytostring($body_a,@crlf)
	progressoff()
	
	return $body
	EndFunc
#cs
Func professor()
	$temp = GUICtrlRead($nameGUI) & ","
	$tempo = stringsplit($temp,",")
	if stringlen($tempo[1])<2 or GUICtrlRead($nameGUI) = '' or not stringstripws(GUICtrlRead($nameGUI),8)="Noinformation" then
		msgbox(0,"No Professor Selected","Please type in a valid professor name.")
		Return
	endif
	GUICtrlSetData($ease, 0)
	GUICtrlSetData($quality, 0)
	GUICtrlSetData($namelabel, "")
	GUICtrlSetData($email, "")
	GUICtrlSetData($reviews, "")
	GUICtrlSetData($date, "")
	$name = StringStripWS(GUICtrlRead($nameGUI), 8)
	$name0 = StringSplit($name, ",")
	$lastname = $name0[1]
	$firstname = String("")
	If $name0[0] = 2 Then $firstname = StringLeft($name0[2], 1)
	
	ProgressOn("Finding Professor Rating", "", "Accessing www.ratemyprofessor.com", (@DesktopWidth / 2) - 150, (@DesktopHeight / 2) - 200)
	$letter = StringUpper(StringLeft($name, 1))
	
	
	$filename = ("C:\Program Files\Scheduler Pro\ratings\" & $letter & ".html")
	$exists = FileExists($filename)
	ProgressSet(20, "Downloading Page...")
	If $exists = 0 And Not $letter = 0 Then InetGet("http://www.ratemyprofessors.com/SelectTeacher.jsp?sid=186&orderby=TLName&letter=" & $letter, $filename)
	
	$line = 0
	
	ProgressSet(35, "Professor information page accessed...")
	
	$handle12 = FileOpen($filename, 1)
	progressoff()
	If $firstname = "" Then $firstname = InputBox("First Name", "What is the first name (partial or full) of Professor " & _StringProper($lastname) & "?" & @CRLF & "If you do not know, then click CANCEL and the first Professor with that last name will be rated.", "", "", 350, 150)
	progresson("","","Reading Parameters")
	If Not $firstname = "" Then
		$linecount = _FileCountLines($filename)
		For $var = 1 To $linecount
			ProgressSet($var/$linecount*100,"Finding teacher ratings...")
			If Not StringInStr(FileReadLine($filename, $var), $firstname) = 0 And Not StringInStr(FileReadLine($filename, $var), $lastname) = 0 Then
				$line = $var
				ExitLoop
			EndIf
		Next
	EndIf
	
	If $firstname = "" Then
		
		For $var = 1 To _FileCountLines($filename)
			If Not StringInStr(FileReadLine($filename, $var), $lastname) = 0 Then
				$line = $var
				ExitLoop
			EndIf
		Next
	EndIf
	
	ProgressSet(47, "Determining if professor has rating...")
	
	If $line = 0 Then
		ProgressOff()
		MsgBox(0, "Information Could Not Be Retrieved", "Professor Information Not Found. Please visit www.ratemyprofessor.com to submit a rating")
		Return 0
	EndIf
	$lineend = _FileLineSearch ($filename, "col_one", $line)
	If $lineend = 0 Then $lineend = _FileLineSearch ($filename, "end code", $line + 1)
	ProgressSet(95, "Writing Variables...")
	ProgressOff()
	FileClose($handle12)
	 test(_removeHTML ($filename, $line, $lineend))
	 
	Return _removeHTML ($filename, $line, $lineend)
EndFunc   ;==>professor
#ce

Func test($string='')
	if @compiled = 1 then return
	if isarray($string) then 
		_arraydisplay($string,"")
		clipput(_arraytostring($string,"|"))
		Return
	EndIf
	MsgBox(1, "", $string)
	clipput($string)
EndFunc   ;==>test

Func classextract()
	$howlong = timerstart()
	progressset(35,"Extracting Classes from the Internet...")
	$address = filereadline("C:\Program Files\Scheduler Pro\class.html",_FileCountLines("C:\Program Files\Scheduler Pro\class.html"))
	$address = stringtrimleft($address,4)

	$ie_object = _IECreate ($address ,0,0)
	_ieaction($ie_object,"refresh")
	$string = _IEBodyReadhtml($ie_object)
	if stringinstr(stringstripws(_IEBodyReadText($ie_object),8),"NoCoursesFound")<>0 then 
		msgbox(0,"No Course Information Found","There was no course information found for that department and class code. If you are unsure of the number of the class that you want to take, just enter in the hundred level. For example, to search for all 400 level classes in Engineering, try searching for ENGR 4.")
		progressoff()
		Return 0
		EndIf
	$string=stringreplace($string,"&nbsp;","")
	$string1 = stringstripws($string,8)	
	$string1 = stringreplace($string1,"<TDclass=crnonclick=show_course",@crlf & "<TDclass=crn onclick=show_course")
	_filecreate("tempfile.pro")
	$tempfile ="tempfile.pro"
	$temphandle = fileopen("tempfile.pro",1)

	filewriteline($temphandle,$string1)
	fileclose($temphandle)
	
	if stringinstr($string1,"ServerError")<>0 then
		progressoff()
		return -1
		endif
		
	if stringinstr($string,"Server Error")<>0 then
		progressoff()
		return -1
		
		endif
	
	progressset(38,"Reading HTML...")
	;Working Pattern
	$pattern = '(?i)<td class=crn onclick=.*; noWrap>(.*?)</td>'
		$crnarray = StringRegExp($string, $pattern, 3)
		progressset(48,"Extracting CRNs...")
		
	;	_IENavigate($ie_object,"                                                                                           ")
	;	$description = _IEBodyReadText($ie_object)
	;	$description = stringtrimleft($description,stringinstr($description,"Descript")+11)
	;	$description = stringtrimright($description,stringlen($description) - stringinstr($description,"Comments","",-1)+6)
	
		;test($crnarray)
	$pattern = '(?i)<td class=subj noWrap>(.*?)</td>'
		$courseIDarray = StringRegExp($string, $pattern, 3)
		progressset(55,"Extracting Subject...")
		;test($courseIDarray)
	$pattern = '(?i)<TD class=title noWrap colSpan=3>(.*?)</TD>'
		$titlearray = StringRegExp($string, $pattern, 3)
		progressset(60,"Extracting Titles...")
		;test($titlearray)
	$pattern = "(?i)<TD class=crdhrs noWrap>(.*?)</TD>"
		$creditarray = StringRegExp($string, $pattern, 3)
		progressset(65,"Extracting Credit Hours....")
		;test($creditarray)
	$pattern = '(?i)<TD class=fees noWrap>(.*?)</TD>'
		$feearray = StringRegExp($string, $pattern, 3)
		;test($feearray)
		progressset(70,"Extracting Fees for Class...")
	$pattern = "(?i)<TD class=term vAlign=top noWrap>(.*?)</TD>"
		$termarray = StringRegExp($string, $pattern, 3)
		progressset(75,"Extracting Term....")
		;test($termarray)
	;$pattern = '<TD class=results vAlign=top noWrap><A href="(?:.*)">(.*?)</A>'
	;$profarray = StringRegExp($string, $pattern, 3)
	;$pattern = '<TDclass=crnonclick=.*>(?:.*)'&$pattern&'(?:.*)<TDclass=curenrollnoWrap>'

	$pattern = '<TDclass=resultsvAlign=topnoWrap><Ahref="(?:.*?)">(.*?)</A>'
	dim $profarray[ubound($crnarray)]
	$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then $profarray[$var-2] = $testarray[0]
			Next
	
	for $r = 0 to ubound($profarray)-1
		if stringinstr($profarray[$r],".")<>0 then 
			$profarray[$r] = stringtrimright($profarray[$r],2)
			$profarray[$r] = stringreplace($profarray[$r],",",", ")
		EndIf
	Next
	
	$pattern = '<TD class=results vAlign=top noWrap><A href="(?:.*?)">(.*?)</A>'
		$proper = stringregexp($string,$pattern,3)
		
	for $r = 0 to ubound($profarray)-1
		for $s = 0 to ubound($proper)-1
			if stringupper(stringleft($proper[$s],3))=stringupper(stringleft($profarray[$r],3))Then
				$profarray[$r] = $proper[$s]
				EndIf
		Next
		Next
	
	$pattern = '<TDclass=resultsvAlign=topnoWrap><Ahref="mailto:(.*?)">'
	dim $emailarray[ubound($crnarray)]
	$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then $emailarray[$var-2] = $testarray[0]
			Next

	progressset(80,"Extracting Professor Information...")
		

		
	$pattern = '<Ahref="http://www.case.edu/provost/registrar/building-help.html"target=_blank>(.*?)</A>'
	dim $buildingarray[ubound($crnarray)]
	$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then $buildingarray[$var-2] = $testarray[0]
			Next
	

	
	$pattern = '</A> (.*?) (?:.*)<BR><A href="http://www.case.edu/provost/registrar/building-help.html" target=_blank>'
	dim $roomarray[ubound($crnarray)]
	$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then $roomarray[$var-2] = $testarray[0]
			Next
	
	$pattern = '</A> (?:.*) (.*?)<BR><A href="http://www.case.edu/provost/registrar/building-help.html" target=_blank>'
	
	dim $capacityarray[ubound($crnarray)]
	$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then $capacityarray[$var-2] = $testarray[0]
			Next
	
	$pattern = '<BR><A href="http://www.case.edu/provost/registrar/building-help.html" target=_blank>(.*?)</A> (?:.*)</TD>'
		dim $recbuildingarray[ubound($crnarray)]
		$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then $recbuildingarray[$var-2] = $testarray[0]
			Next
	$pattern = '<BR><A href="http://www.case.edu/provost/registrar/building-help.html" target=_blank>(?:.*)</A> (.*?) (?:.*) </TD>'
		dim $recroomarray[ubound($crnarray)]
		$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then $recroomarray[$var-2] = $testarray[0]
			Next
		
	
	$pattern = "<TD class=times1 width=17>(.*)</TD>"
		$dayarraytemp = StringRegExp($string, $pattern, 3)		
		progressset(85,"Extracting Days of Class and Recitation(if there is one)...")
		dim $dayarray[ubound($crnarray)]
		dim $recdayarray[ubound($crnarray)]
		dim $addrecarray[ubound($crnarray)]
		$position = -1
		for $var = 0 to ubound ($crnarray)-1
			$newline = ''
			$newlinerec = ''
			$newlinethird = ''
			for $var1 = 1 to 21
				$position = $position +1 
				if $position>ubound($dayarraytemp)-1 then exitloop
				
				if not (stringinstr($dayarraytemp[$position],"</TD>") = 0) then ExitLoop
				if $var1<7 then 
					$newline = $newline & $dayarraytemp[$position]
				EndIf				
				if $var1 >=7 and $var1<14 then 
					$newlinerec=$newlinerec&  $dayarraytemp[$position]
				EndIf
				if $var1 >=14 and $var1<21 then 
					$newlinethird=$newlinethird&  $dayarraytemp[$position]
				EndIf
				if $position>ubound($dayarraytemp)-1 then exitloop				
			Next
			
			$newline=stringreplace($newline,"M","Mon ")
			$newline=stringreplace($newline,"T","Tues ")
			$newline=stringreplace($newline,"W","Wed ")
			$newline=stringreplace($newline,"R","Thurs ")
			$newline=stringreplace($newline,"F","Fri ")
			
			$newlinethird=stringreplace($newlinethird,"M","Mon ")
			$newlinethird=stringreplace($newlinethird,"T","Tues ")
			$newlinethird=stringreplace($newlinethird,"W","Wed ")
			$newlinethird=stringreplace($newlinethird,"R","Thurs ")
			$newlinethird=stringreplace($newlinethird,"F","Fri ")
			
			$newlinerec=stringreplace($newlinerec,"M","Mon ")
			$newlinerec=stringreplace($newlinerec,"T","Tues ")
			$newlinerec=stringreplace($newlinerec,"W","Wed ")
			$newlinerec=stringreplace($newlinerec,"R","Thurs ")
			$newlinerec=stringreplace($newlinerec,"F","Fri ")
			$dayarray[$var] = $newline
			$recdayarray[$var] = $newlinerec
			$addrecarray[$var] = $newlinethird
		Next
		
	$pattern = '(?i)<TD class=times vAlign=top noWrap>(.*?)</TD>'
		dim $classtime[ubound($crnarray)]
		$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then 
				if not(stringinstr($testarray[0],"<")=0) then 
					$testarray[0] = stringleft($testarray[0],stringinstr($testarray[0],"<")-1)
					EndIf
				$classtime[$var-2] = $testarray[0]		
				EndIf
			Next
		progressset(90,"Extracting Times of Class and Recitation...")
	$pattern = '(?i)<TD class=times vAlign=top noWrap>(?:.*?)<BR>(.*?)</TD>'
		progressset(93,"Extracting Times of Class and Recitation...")
		;test($recclasstime)
		dim $recclasstime[ubound($crnarray)]
		$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then $recclasstime[$var-2] = $testarray[0]
			Next
	$pattern = "(?i)<TD class=curenroll noWrap>(.*?)<STRONG"

		dim $currentenroll[ubound($crnarray)]
		$pattern = stringstripws($pattern,8)
		for $var = 2 to ubound($crnarray)+2
			$readline  = filereadline($tempfile,$var)
			$testarray= stringregexp($readline,$pattern,3)
			if isarray($testarray) then $currentenroll[$var-2] = $testarray[0]
			Next
		progressset(100,"Extracting Current Enrollment...")
		;test($currentenroll)

	
	_filecreate("C:\Program Files\Scheduler Pro\Classes\"&$courseIDarray[0] &".html")
	$handle = fileopen("C:\Program Files\Scheduler Pro\Classes\"&$courseIDarray[0] &".html",2)
	for $var = 0 to ubound($crnarray)-1
		$course = $crnarray[$var] & "|" & $courseIDarray[$var] & "|" & $profarray[$var] & "|" & $titlearray[$var] & "|" & $creditarray[$var] & "|" & $termarray[$var] & "|" & $dayarray[$var] & "|" & $classtime[$var] & "|" & $recdayarray[$var] & "|" & $recclasstime[$var] & "|" & $buildingarray[$var] & "|" & $roomarray[$var] & "|" & $capacityarray[$var] & "|" & $currentenroll[$var] & "|" & $feearray[$var] & "|" & "" & "|" & "" & "|" & $recbuildingarray[$var] & "|" & $recroomarray[$var] & "|"&$emailarray[$var]
		filewriteline($handle,$course)
	Next
	;filewriteline($handle,$description)
	fileclose($handle)
	filecopy("C:\Program Files\Scheduler Pro\Classes\"&$courseIDarray[0] &".html","C:\Program Files\Scheduler Pro\classtemp.txt",1)
	
	$pattern = '<TD style="TEXT-ALIGN: left"><B>Courses Found:</B> (.*?)</TD>'
		$numberofclasses = StringRegExp($string, $pattern, 3)
	$number_classes = stringformat("%i",$numberofclasses[0])
	;$course = $_crn & "|" & $subj & "|" & $_professor & "|" & $title & "|" & $_credithours & "|" & $term & "|" & $days & "|" & $times & "|" & $res & "|" & $rectimes & "|" & $_building & "|" & $room & "|" & $_capacity & "|" & $curenroll & "|" & $fee & "|" & "" & "|" & "" & "|" & $_recbuilding & "|" & $roomrec & "|"	
	;test(timerdiff($howlong)/1000 & " Seconds to Search")
	Return $number_classes
EndFunc   ;==>classextract

func testserver()
	;progresson("Pinging Server","","Verifying that the Searchable Schedule of Classes"&@crlf&"is available and ready to use...")
	progressset(10)
	inetget("                                            ","C:\Program Files\Scheduler Pro\class.html")
	progressset(25)
	if _filelinesearch("C:\Program Files\Scheduler Pro\class.html","SSOC is not currently available for maintenance reasons",1) = 0 then
		;Msgbox(0,"Server Online", "The Case Server has been brought online.")
		;progressoff()
		Return
	EndIf
	progressset(35)
	inetget("                                            ","C:\Program Files\Scheduler Pro\class.html")
	progressset(55)
	
	for $var =55 to 100
		progressset($var)
	Next
	
	if not _filelinesearch("C:\Program Files\Scheduler Pro\class.html","SSOC is not currently available for maintenance reasons",1) = 0 then
		progressoff()
		if 4= msgbox(5,"Server busy","The Searchable Schedule of Classes has been taken offline. This may be due to unusually high network traffic, so in a few moments the server may be accessible.")Then
			testserver()
		EndIf
	Else
		;progressoff()
		return ;msgbox(0,"Server Active","Case Webservers are back online, for the time being.")
	endif
	;progressoff()
EndFunc   ;==>testserver


func feedback()
	opt("GuionEventmode",0)
	$quickexit = 1
	$feedback_ = GuiCreate("Feedback or Bug Report", 392, 375,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	
	guictrlcreatelabel("Subject for Feedback Email to AJF17@case.edu:" ,10,10)
	$subject = GuiCtrlCreateInput("", 10, 30, 370, 20)
	$body = GuiCtrlCreateEdit("", 10, 60, 370, 180,$ES_WANTRETURN+$ES_MULTILINE)
	
	GuiCtrlCreateLabel(@crlf&"Send whatever feedback you want. I'll read it and get back to you when I can. If you are reporting a bug in the program, I'll get back to you sooner and hopefully fix it quickly. If you want me to respond, please include an email address somewhere in the subject or the body of the message.", 10, 290, 370, 80)
	$Bug = GuiCtrlCreateCheckbox("Bug Report", 10, 254, 80, 20)
	$Button_7 = GuiCtrlCreateButton("Send Feedback Email", 110, 260, 260, 30)
	$feature = GuiCtrlCreateCheckbox("Add Feature", 10, 280, 80, 20)
	
	guictrlsetstate($subject,$GUI_FOCUS)
	GuiSetState()
	
	While 1
		$msg = GuiGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				guidelete($feedback_)
				return
			Case $msg = $Button_7
				dim $s_body[2]
				$s_body[0] = ""
				$s_body[1] = guictrlread($body)
				
				if guictrlread($Bug) = 1 then
					$s_subject = "[BUG REPORT] " & guictrlread($subject)
				Else
					$s_subject = "[FEEDBACK] " & guictrlread($subject)
					if guictrlread($feature) = 1 then $s_subject = "[FEATURE] "& guictrlread($subject)
				EndIf
				$sender = getname()
				if stringisint($sender) then $sender = "Scheduler Pro"
				$s_subject = "[" & $sender&"]"& $s_subject
				_INetSmtpMail("smtp.case.edu","Scheduler Pro","andrew.freyer@case.edu","ajf17@case.edu",$s_subject,$s_body)
				msgbox(0,"Message Sent", "Email feedback was successfully sent.")
				guidelete($feedback_)
				return
		EndSelect
		sleep(10)
	WEnd
	opt("GuionEventmode",0)
	guidelete($feedback_)
EndFunc   ;==>feedback

Func OnAutoItExit()
	;fileinstall("_updater.exe","C:\Program Files\Scheduler Pro\_updater.exe")
	;run("C:\Program Files\Scheduler Pro\_updater.exe")
	ProcessClose("iexplore.exe")
	EndFunc   ;==>OnAutoItExit

Func _FiletypeAssociation($extension, $type, $program, $description = '')
	; e.g. _FiletypeAssociation('.pdf', 'FoxitReader.Document', '"%ProgramFiles%\FoxitReader.exe" "%1"')
	$exitcode = RunWait(@ComSpec & ' /c ftype ' & $type & '=' & $program &  _
			' && assoc ' & $extension & '=' & $type, '', @SW_HIDE)
	If $description And Not $exitcode Then
		Return RegWrite('HKCR\' & $type, '', 'Reg_sz', $description)
	EndIf
	Return Not $exitcode
EndFunc   ;==>_FiletypeAssociation

Func GetName()
	Local $colItems, $objWMIService, $objItem
	Dim $aOSInfo[1][60], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_OperatingSystem", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aOSInfo[UBound($aOSInfo) + 1][60]
			$aOSInfo[$i][0]  = $objItem.Name
			$aOSInfo[$i][1]  = $objItem.BootDevice
			$aOSInfo[$i][2]  = $objItem.BuildNumber
			$aOSInfo[$i][3]  = $objItem.BuildType
			$aOSInfo[$i][4]  = $objItem.Description
			$aOSInfo[$i][5]  = $objItem.CodeSet
			$aOSInfo[$i][6]  = $objItem.CountryCode
			$aOSInfo[$i][7]  = $objItem.CreationClassName
			$aOSInfo[$i][8]  = $objItem.CSCreationClassName
			$aOSInfo[$i][9]  = $objItem.CSDVersion
			$aOSInfo[$i][10] = $objItem.CSName
			$aOSInfo[$i][11] = $objItem.CurrentTimeZone
			$aOSInfo[$i][12] = $objItem.DataExecutionPrevention_32BitApplications
			$aOSInfo[$i][13] = $objItem.DataExecutionPrevention_Available
			$aOSInfo[$i][14] = $objItem.DataExecutionPrevention_Drivers
			$aOSInfo[$i][15] = $objItem.DataExecutionPrevention_SupportPolicy
			$aOSInfo[$i][16] = $objItem.Debug
			$aOSInfo[$i][17] = $objItem.Distributed
			$aOSInfo[$i][18] = $objItem.EncryptionLevel
			$aOSInfo[$i][19] = $objItem.ForegroundApplicationBoost
			$aOSInfo[$i][20] = $objItem.FreePhysicalMemory
			$aOSInfo[$i][21] = $objItem.FreeSpaceInPagingFiles
			$aOSInfo[$i][22] = $objItem.FreeVirtualMemory
			$aOSInfo[$i][23] = __StringToDate($objItem.InstallDate)
			$aOSInfo[$i][24] = $objItem.LargeSystemCache
			$aOSInfo[$i][25] = __StringToDate($objItem.LastBootUpTime)
			$aOSInfo[$i][26] = __StringToDate($objItem.LocalDateTime)
			$aOSInfo[$i][27] = $objItem.Locale
			$aOSInfo[$i][28] = $objItem.Manufacturer
			$aOSInfo[$i][29] = $objItem.MaxNumberOfProcesses
			$aOSInfo[$i][30] = $objItem.MaxProcessMemorySize
			$aOSInfo[$i][31] = $objItem.NumberOfLicensedUsers
			$aOSInfo[$i][32] = $objItem.NumberOfProcesses
			$aOSInfo[$i][33] = $objItem.NumberOfUsers
			$aOSInfo[$i][34] = $objItem.Organization
			$aOSInfo[$i][35] = $objItem.OSLanguage
			$aOSInfo[$i][36] = $objItem.OSProductSuite
			$aOSInfo[$i][37] = $objItem.OSType
			$aOSInfo[$i][38] = $objItem.OtherTypeDescription
			$aOSInfo[$i][39] = $objItem.PlusProductID
			$aOSInfo[$i][40] = $objItem.PlusVersionNumber
			$aOSInfo[$i][41] = $objItem.Primary
			$aOSInfo[$i][42] = $objItem.ProductType
			$aOSInfo[$i][43] = $objItem.QuantumLength
			$aOSInfo[$i][44] = $objItem.QuantumType
			$aOSInfo[$i][45] = $objItem.RegisteredUser
			$aOSInfo[$i][46] = $objItem.SerialNumber
			$aOSInfo[$i][47] = $objItem.ServicePackMajorVersion
			$aOSInfo[$i][48] = $objItem.ServicePackMinorVersion
			$aOSInfo[$i][49] = $objItem.SizeStoredInPagingFiles
			$aOSInfo[$i][50] = $objItem.Status
			$aOSInfo[$i][51] = $objItem.SuiteMask
			$aOSInfo[$i][52] = $objItem.SystemDevice
			$aOSInfo[$i][53] = $objItem.SystemDirectory
			$aOSInfo[$i][54] = $objItem.SystemDrive
			$aOSInfo[$i][55] = $objItem.TotalSwapSpaceSize
			$aOSInfo[$i][56] = $objItem.TotalVirtualMemorySize
			$aOSInfo[$i][57] = $objItem.TotalVisibleMemorySize
			$aOSInfo[$i][58] = $objItem.Version
			$aOSInfo[$i][59] = $objItem.WindowsDirectory
			$i += 1
		Next
		$aOSInfo[0][0] = UBound($aOSInfo) - 1
		If $aOSInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
	return $aOSInfo[1][45]
EndFunc   ;==>GetName


func clearfullschedule()
	for $first = 0 to 4 ; to duplicate current schedule...
		for $second = 0 to 8		
			$visualschedule[$first][$second] = ''
		Next
	Next
	$test = _IEBodyReadHTML($htmlschedule)
	$test = stringreplace($test,"filtered","main-map")
	filedelete("C:\Program Files\Scheduler Pro\schedule.html")
	$temp  = fileopen("C:\Program Files\Scheduler Pro\schedule.html",1)
	filewriteline("C:\Program Files\Scheduler Pro\schedule.html",$test)
	_ieaction($htmlschedule,"refresh")
	$crnfile = ''
	$finalclasslist = ''
	guictrlsetdata($total_hours,0.0)
EndFunc   ;==>clearfullschedule

func buildinglocator($building)
	$building = stringleft(stringstripws($building,8),4)
	if stringstripws(stringlower($building),8) = "nord" then $building = "Enterprise"
	if stringstripws(stringlower($building),8) = "dgrc" then $building = "DeGrace"
	if stringstripws(stringlower($building),8) = "pblb" then $building = "Peter"
	filedelete("building_converted.jpg")
	filedelete("building.gif")
	$buildings = stringsplit(" Adelbert Gym| Adelbert Hall| Alpha Chi Omega| Alumni House| Amasa Stone Chapel| American Heart Association| Arabica| Atrium| Baker Building| Baricelli Inn| Bingham Building| Biomedical Research Building| Bishop Building| Bolwell Health Center| Carlton Commons| Cedar Avenue Service Center| Church of the Covenant| Clark Hall| Clarke Tower| Cleveland Hearing and Speech Center| Cleveland Institute of Art| Cleveland Institute of Music| Cleveland Museum of Art| Cleveland Museum of Natural History| Crawford Auto Aviation Museum| Crawford Hall| Cutler House| Cutter House| DeGrace Hall (formerly Biology Building)| Delta Kappa Epsilon Fraternity (Beta Theta Pi House)| Delta Sigma Delta Dental Fraternity| Delta Tau Delta Fraternity| Denison Building| Dental School| Dively Executive Education Center| Donnell Pool| Early Music America| Eldred Hall| Elephant Steps| Emerson Gym| Enterprise Hall| Epstein-Gutzwiller| Epworth Euclid United Methodist Church| Finnigan Fields| First Church of Christ Scientist| Frances Payne Bolton School of Nursing| Free Clinic| Fribley Commons| Garden Center of Greater Cleveland| Glaser House| Glennan Building| Guest House| Guilford House| Hallinan Center| Hanna House| Hanna Pavilion| Hanna Perkins School| Harcourt House| Harkness Chapel| Harvey House| Haydn Hall| Health Sciences Library| Hillel Foundation| Hitchcock House| Howe House| Humphrey Building| Institute of Pathology| Kelvin Smith Library| Kusch House| Lakeside| Law School (Gund Hall)| League House| Lerner Tower| Leutner Commons| Lowman House| Magnolia House| Mandel School of Applied Social Sciences| Martin Luther King Library| Mather Dance Center| Mather House| Mather Memorial| Mather Pavilion| Medical School| Michelson House| Millis Science Center| Morley Laboratory| Mount Zion Congregational Church| Murray Hill House| Music School Settlement| North Campus Security Office| Norton House| Olin Building| One To One| Pentecostal Church of Christ| Peter B. Lewis Building| Phi Delta Theta Fraternity| Phi Gamma Delta| Phi Kappa Psi Fraternity| Phi Kappa Theta Fraternity| Phi Mu| Pierce House| Powerhouse| RTA Bus Station| RTA Rapid Station - University Circle Stop| Rainbow Babies and Childrens Hospital| Raymond House| Religious Society of Friends| Robb House| Rockefeller Building| Sears Library| Severance Hall| Sherman House| Sigma Alpha Epsilon Fraternity| Sigma Alpha Mu Fraternity| Sigma Nu Fraternity| Sigma Psi Sorority| Smith Building| Smith Engineering and Science Building| Smith House| Staley House| Steiner House| Stone Dining Hall| Storrs House| Strosacker Auditorium| Taft House| Taplin House| Temple (Jewish)| The Factory (CIA)| Theta Chi Fraternity| Thwing Center| Tippit House| Tomlinson Hall| Tyler House| University Circle Inc. Offices| University Circle Inc. Police Station| University Circle Research Center| University Circle West| University Health Services (Campus Security)| University MacDonald Womens Hospital| Van Horn Field| Veale| Veterans Administration Medical Center| Wade Area Office| Wade Lagoon| Wearn Building| West Quad| Western Reserve Historical Society| White Building| Wickenden Building| Yost Hall| Zeta Beta Tau Fraternity| Zeta Psi Fraternity|0","|")
	
	
	for $var = 1 to $buildings[0]
		if not stringinstr($buildings[$var],$building) = 0 and stringlower(stringleft(stringstripws($buildings[$var],8),1)) = stringlower(stringleft(stringstripws($building,8),1)) then ExitLoop
	Next
	if $var-1 = $buildings[0] then return 0
	
	$buildings[$var] = stringreplace($buildings[$var]," ","+")
	if stringleft($buildings[$var],1) = "+" then $buildings[$var] = stringtrimleft($buildings[$var],1)
	inetget("http://www.case.edu/cgi-bin/campusmap?b=" & $buildings[$var],@TempDir &"\file.html")
	$line = _filelinesearch(@TempDir &"\file.html","/cgi-bin/mapbox/main-map.ppm",140)
	$extractline = filereadline(@TempDir &"\file.html",$line)
	filedelete(@TempDir &"\file.html")
	$extractline = stringtrimleft($extractline,10)
	$extractline = stringleft($extractline,stringinstr($extractline,'"')-1)
	Inetget("http://www.case.edu/" & $extractline,"C:\Program Files\Scheduler Pro\schedule_files\filtered.gif")
	if fileexists("C:\Program Files\Scheduler Pro\schedule_files\filtered.gif") = 0 then return 0

	$test = _IEBodyReadHTML($htmlschedule)
	$test = stringreplace($test,"main-map","filtered")
	filedelete("C:\Program Files\Scheduler Pro\schedule_show.html")
	$temp  = fileopen("C:\Program Files\Scheduler Pro\schedule_show.html",1)
	filewriteline("C:\Program Files\Scheduler Pro\schedule_show.html",$test)
	
	_ieaction($htmlschedule,"refresh")
	#endregion --- GuiBuilder generated code End ---
	return 1
EndFunc   ;==>buildinglocator

func mapall()
	$classarray = stringsplit(stringreplace(guictrlread($crnlist),@crlf&@crlf,@crlf),@crlf)
	$newbuilding = ''
	for $var = 1 to $classarray[0]
		if not stringstripws($classarray[$var],8) = '' then 
			$newcrn = stringleft(stringstripws($classarray[$var],8),5)
			$newclass = stringupper(stringleft(stringtrimleft(stringstripws($classarray[$var],8),5),4)) & " " &stringleft(stringtrimleft(stringstripws($classarray[$var],8),9),3)
			$line = _filelinesearch("C:\Program Files\Scheduler Pro\Classes\" & $newclass & ".html",$newcrn,0)
			$newclassinfo = stringsplit(filereadline("C:\Program Files\Scheduler Pro\Classes\" & $newclass & ".html",$Line),"|")
			$newbuilding = $newbuilding & stringstripws($newclassinfo[11] &"|"&$newclassinfo[18],8)
			EndIf
		Next
	$htmlbuildinglist=''
	$buildinglist = stringsplit($newbuilding,"|")
	for $var1 = 1 to $buildinglist[0]
		if not stringstripws($buildinglist[$var1],8) = '' then
			$building = $buildinglist[$var1]
			$building = stringleft(stringstripws($building,8),4)
			
			if stringstripws(stringlower($building),8) = "nord" then $building = "Enterprise"
			if stringstripws(stringlower($building),8) = "dgrc" then $building = "DeGrace"
			if stringstripws(stringlower($building),8) = "pblb" then $building = "Peter"
			filedelete("building_converted.jpg")
			filedelete("building.gif")
			$buildings = stringsplit(" Adelbert Gym| Adelbert Hall| Alpha Chi Omega| Alumni House| Amasa Stone Chapel| American Heart Association| Arabica| Atrium| Baker Building| Baricelli Inn| Bingham Building| Biomedical Research Building| Bishop Building| Bolwell Health Center| Carlton Commons| Cedar Avenue Service Center| Church of the Covenant| Clark Hall| Clarke Tower| Cleveland Hearing and Speech Center| Cleveland Institute of Art| Cleveland Institute of Music| Cleveland Museum of Art| Cleveland Museum of Natural History| Crawford Auto Aviation Museum| Crawford Hall| Cutler House| Cutter House| DeGrace Hall (formerly Biology Building)| Delta Kappa Epsilon Fraternity (Beta Theta Pi House)| Delta Sigma Delta Dental Fraternity| Delta Tau Delta Fraternity| Denison Building| Dental School| Dively Executive Education Center| Donnell Pool| Early Music America| Eldred Hall| Elephant Steps| Emerson Gym| Enterprise Hall| Epstein-Gutzwiller| Epworth Euclid United Methodist Church| Finnigan Fields| First Church of Christ Scientist| Frances Payne Bolton School of Nursing| Free Clinic| Fribley Commons| Garden Center of Greater Cleveland| Glaser House| Glennan Building| Guest House| Guilford House| Hallinan Center| Hanna House| Hanna Pavilion| Hanna Perkins School| Harcourt House| Harkness Chapel| Harvey House| Haydn Hall| Health Sciences Library| Hillel Foundation| Hitchcock House| Howe House| Humphrey Building| Institute of Pathology| Kelvin Smith Library| Kusch House| Lakeside| Law School (Gund Hall)| League House| Lerner Tower| Leutner Commons| Lowman House| Magnolia House| Mandel School of Applied Social Sciences| Martin Luther King Library| Mather Dance Center| Mather House| Mather Memorial| Mather Pavilion| Medical School| Michelson House| Millis Science Center| Morley Laboratory| Mount Zion Congregational Church| Murray Hill House| Music School Settlement| North Campus Security Office| Norton House| Olin Building| One To One| Pentecostal Church of Christ| Peter B. Lewis Building| Phi Delta Theta Fraternity| Phi Gamma Delta| Phi Kappa Psi Fraternity| Phi Kappa Theta Fraternity| Phi Mu| Pierce House| Powerhouse| RTA Bus Station| RTA Rapid Station - University Circle Stop| Rainbow Babies and Childrens Hospital| Raymond House| Religious Society of Friends| Robb House| Rockefeller Building| Sears Library| Severance Hall| Sherman House| Sigma Alpha Epsilon Fraternity| Sigma Alpha Mu Fraternity| Sigma Nu Fraternity| Sigma Psi Sorority| Smith Building| Smith Engineering and Science Building| Smith House| Staley House| Steiner House| Stone Dining Hall| Storrs House| Strosacker Auditorium| Taft House| Taplin House| Temple (Jewish)| The Factory (CIA)| Theta Chi Fraternity| Thwing Center| Tippit House| Tomlinson Hall| Tyler House| University Circle Inc. Offices| University Circle Inc. Police Station| University Circle Research Center| University Circle West| University Health Services (Campus Security)| University MacDonald Womens Hospital| Van Horn Field| Veale| Veterans Administration Medical Center| Wade Area Office| Wade Lagoon| Wearn Building| West Quad| Western Reserve Historical Society| White Building| Wickenden Building| Yost Hall| Zeta Beta Tau Fraternity| Zeta Psi Fraternity|0","|")
			
			for $var = 1 to $buildings[0]
				if not stringinstr($buildings[$var],$building) = 0 and stringlower(stringleft(stringstripws($buildings[$var],8),1)) = stringlower(stringleft(stringstripws($building,8),1)) then ExitLoop
			Next
			if $var <= $buildings[0] then 			
				$buildings[$var] = stringreplace($buildings[$var]," ","+")
				if stringleft($buildings[$var],1) = "+" then $buildings[$var] = stringtrimleft($buildings[$var],1)
				$htmlbuildinglist = "|"&$buildings[$var]& $htmlbuildinglist
				EndIf
		EndIf
	Next
	$htmlbuildinglist = stringtrimleft($htmlbuildinglist,1)
	$temparray = stringsplit($htmlbuildinglist,"|")
	_ArrayTrim($temparray,0)
	_arraydelete($temparray,0)
	$htmlbuildinglist = _arraytostring($temparray,"|")
	
	$htmlbuildinglist = stringreplace($htmlbuildinglist,"|","&b=")
	$htmlbuildinglist = stringreplace($htmlbuildinglist,"(","%28")
	$htmlbuildinglist = stringreplace($htmlbuildinglist,")","%29")
	progresson("Creating Campus Map...","","Creating campus map...")
	ProgressSet(23)
	inetget("http://www.case.edu/cgi-bin/campusmap?b=" & $htmlbuildinglist,@TempDir &"\file.html")
	Progressset(58,"Finding Buildings...")
	$line = _filelinesearch(@TempDir &"\file.html","/cgi-bin/mapbox/main-map.ppm",140)
	$extractline = filereadline(@TempDir &"\file.html",$line)
	filedelete(@TempDir &"\file.html")
	$extractline = stringtrimleft($extractline,10)
	$extractline = stringleft($extractline,stringinstr($extractline,'"')-1)
	progressset(68,"Creating building filter...")
	filedelete("C:\Program Files\Scheduler Pro\schedule_files\filtered.gif")
	$got = Inetget("http://www.case.edu/" & $extractline,"C:\Program Files\Scheduler Pro\schedule_files\filtered.gif")
	if $got = 0 then msgbox(0,"Map Download Problem","There was a problem when downloading the map. This most likely means that there was a server error.")
	if fileexists("C:\Program Files\Scheduler Pro\schedule_files\filtered.gif") = 0 then return 0
	progressset(80,"Reformating image for display...")
	
	
	$test = _IEBodyReadHTML($htmlschedule)
	$test = stringreplace($test,"main-map","filtered")

	filedelete("C:\Program Files\Scheduler Pro\schedule_show.html")
	_FILECREATE("C:\Program Files\Scheduler Pro\schedule_show.html")
	$temp  = fileopen("C:\Program Files\Scheduler Pro\schedule_show.html",1)
	filewriteline("C:\Program Files\Scheduler Pro\schedule_show.html",$test)
	fileclose($temp)
	_IENavigate($htmlschedule,"C:\Program Files\Scheduler Pro\schedule_show.html")
	progressoff()
	#endregion --- GuiBuilder generated code End ---
	return 1
endfunc

func getsemester()
	if $testsem = 0 then 
		;progresson("Finding Semsters","",(@DesktopWidth / 2) , (@DesktopHeight / 2))
		progressset(35,"Getting Semseter Information...")
		$object = _IECreate ("                                                                       " ,0,0)
		progressset(46,"Reading page...")
		$tests = _iebodyreadhtml($object)
		
		progressset(50,"Extracting data from web page...")
		$_allsems = stringregexp($tests,'<OPTION value=.*?>(.*?)</OPTION>',3)
		if isarray($_allsems) = 0 then
			progressoff()
			guidelete()
			
			msgbox(0,"Website Error","There was an error with the script on the Searchable Schedule of Classes. Scheduler Pro must Exit")
			Exit
			EndIf
		if not( stringinstr($_allsems[0], "All") = 0) then 
			for $t = 0 to ubound($_allsems)-1
				if stringinstr($_allsems[$t],"Spri")<>0 then ExitLoop
				if stringinstr($_allsems[$t],"Summ")<>0 then ExitLoop
				if stringinstr($_allsems[$t],"Fall")<>0 then exitloop
	
				_arraydelete($_allsems,0)
				$t = -1
			next
		EndIf
		if $_allsems = 1 then 
			msgbox(0,"No Internet Connection","You aren't connected to the internet. You need to be.")
			return 0 
			EndIf
		$allcodes = stringregexp($tests,'<OPTION value=[1-9]{3}',3)
		dim $allsems[1]
		$allsems[0] = $_allsems[0]
		for $svar = 1 to ubound($allcodes)-1
			_arrayadd($allsems,$_allsems[$svar])
			Next
		for $svar =0 to ubound($allcodes)-1
			$allcodes[$svar] = stringstripws(stringreplace($allcodes[$svar],"<OPTION value=",""),8)
		Next
		guictrlsetdata($selectsemester,_arraytostring($allsems,"|"),$allsems[0])
		$testsem = 1
		progressoff()
		global $allseme = $allsems
		Return $allcodes
	EndIf
	if $testsem = 1 then 
		$test = guictrlread($selectsemester)
		for $war = 0 to ubound($allseme)-1
			if stringstripws($allseme[$war],8) = stringstripws($test,8) then ExitLoop
			Next
		return $allsemster[$war]
		EndIf

	EndFunc
func formatoriginal()
	
	
	$tempOBJ = _iecreate("C:\Program Files\Scheduler Pro\schedule_original.html",0,0)
	$body = _iebodyreadhtml($tempOBJ)
	if not $w_adj = 1 then 
		$widths = stringregexp($body ,"width=(.*?)height",3)
		$hold_vars = ''
		for $t=0 to ubound($widths)-1
			if stringinstr($hold_vars,stringstripws($widths[$t],8)&"|") = 0 then 
				$wid_num = stringstripws($widths[$t],8)
				if not (stringinstr($wid_num, "col") = 0) then $wid_num = stringleft($wid_num,stringinstr($wid_num, "col")-1)
				$hold_vars = $hold_vars & $wid_num &"|"
				EndIf
			Next
		$wid_array = stringsplit($hold_vars,"|")
		_arraydelete($wid_array,0)
	
		for $q=0 to ubound($wid_array)-1
			stringregexpreplace($body,"width="&$wid_array[$q],"width="&$wid_array[$q]*$w_adj)
		Next
	EndIf
	
		if not $h_adj = 1 then 
		$heights = stringregexp($body ,"height=(.*?)",3)
		$hold_vars = ''
		for $t=0 to ubound($heights)-1
			if stringinstr($hold_vars,stringstripws($heights[$t],8)&"|") = 0 then 
				$h_num = stringstripws($heights[$t],8)
				if not (stringinstr($h_num, "col") = 0) then $h_num = stringleft($h_num,stringinstr($h_num, "col")-1)
				$hold_vars = $hold_vars & $h_num &"|"
				EndIf
			Next
		$h_array = stringsplit($hold_vars,"|")
		_arraydelete($h_array,0)
	
		for $q=0 to ubound($h_array)-1
			stringregexpreplace($body,"width="&$h_array[$q],"width="&$h_array[$q]*$h_adj)
		Next
	EndIf
EndFunc

func tabforward()
	$focus = ControlGetFocus("Scheduler")
	if stringinstr($focus,"Edit") then 
		$focus = stringformat("%i",stringreplace($focus,"Edit",""))-1
		if $focus > ubound($editarray)-1 then $focus = 0
		$foc_loc = _arraysearch($focusarray,$editarray[$focus],0)+1
		guictrlsetstate($focusarray[$foc_loc],$GUI_FOCUS)
	EndIf
	if stringinstr($focus,"Button") then 
		$focus = stringformat("%i",stringreplace($focus,"Button",""))-1
		if $focus > ubound($buttonarray)-1 then $focus = 0
		$foc_loc = _arraysearch($focusarray,$buttonarray[$focus],0)+1
		guictrlsetstate($focusarray[$foc_loc],$GUI_FOCUS)
	EndIf
	
EndFunc

func getonline()
	GuiCreate("Find Schedules", 303, 250,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	global $Jones_sems= GuiCtrlCreateCombo("", 20, 20, 160, 21)
	global $jones_find = GuiCtrlCreateButton("Find Schedules", 200, 20, 90, 20)
	global $schedules = GuiCtrlCreateList("", 20, 50, 270, 162)
	global $jones_loadsch = GuiCtrlCreateButton("Load Schedule", 20, 220, 270, 20)
GuiSetState()

dim $allsemster_jones = getsems()

opt("GuionEventmode",0)
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $jones_find
		jones_find()
	Case $msg = $jones_loadsch
		jones_loadsched()
	EndSelect
WEnd
guidelete()
opt("GuionEventmode",1)
#endregion --- GuiBuilder generated code End ---
EndFunc

func jones_loadsched()
	
	$selected = _GUICtrlListGetSelItemsText($schedules)
	
	for $var = 0 to ubound($name_ip)-1
		if stringinstr($name_ip[$var],$selected[1]) <> 0 Then 
			$IP_name = stringsplit($name_ip[$var]," ")
			$ip = stringstripws($ip_name[1],8)
			$filename = "C:\Program Files\Scheduler Pro\Online Schedules\"&getsems()&"\"&$ip &".txt"
			ExitLoop
		EndIf
		Next
	EndFunc

func jones_find()
		$sem_cur = getsems()
		_GUICtrlListClear($schedules)
		$ieo = _iecreate("                                  "&getsems(),0,0)
		$_ipaddresses = _iebodyreadhtml($ieo)
		$ipaddresses = stringregexp($_ipaddresses,'href="(.*?)"',3)
		_arraydelete($ipaddresses,0)
		_arraydelete($ipaddresses,0)
		_arraydelete($ipaddresses,0)
		_arraydelete($ipaddresses,0)
		_arraydelete($ipaddresses,0)
		global $name_ip[ubound($ipaddresses)]
		DirCreate("C:\Program Files\Scheduler Pro\Online Schedules\"&$sem_cur)
		for $var = 0 to ubound ($ipaddresses)-1
			inetget("                                  "&$sem_cur&"/"&$ipaddresses[$var],"C:\Program Files\Scheduler Pro\Online Schedules\"&$sem_cur&"\"&$ipaddresses[$var] &".txt")
			$cur_name = filereadline("C:\Program Files\Scheduler Pro\Online Schedules\"&$sem_cur&"\"&$ipaddresses[$var] &".txt",1)
			_GUICtrlListAddItem($schedules,$cur_name)
			$name_ip[$var] = $ipaddresses[$var] & " " &$cur_name
			Next
		msgbox(0,"Found","Found " &ubound($ipaddresses)& " schedules.")
		_iequit($ieo)
	EndFunc

Func getsems()
		if $testsem_jones = 0 then 
		;progresson("Finding Semsters","",(@DesktopWidth / 2) , (@DesktopHeight / 2))
		progressset(35,"Getting Semseter Information...")
		$object = _IECreate ("                                                                       " ,0,0)
		progressset(46,"Reading page...")
		$tests = _iebodyreadhtml($object)
		
		progressset(50,"Extracting data from web page...")
		$_allsems = stringregexp($tests,'<OPTION value=.*?>(.*?)</OPTION>',3)
		if isarray($_allsems) = 0 then
			progressoff()
			guidelete()
			
			msgbox(0,"Website Error","There was an error with the script on the Searchable Schedule of Classes. Scheduler Pro must Exit")
			Exit
			EndIf
		if not( stringinstr($_allsems[0], "All") = 0) then 
			for $t = 0 to ubound($_allsems)-1
				if stringinstr($_allsems[$t],"Spri")<>0 then ExitLoop
				if stringinstr($_allsems[$t],"Summ")<>0 then ExitLoop
				if stringinstr($_allsems[$t],"Fall")<>0 then exitloop
	
				_arraydelete($_allsems,0)
				$t = -1
			next
		EndIf
		if $_allsems = 1 then 
			msgbox(0,"No Internet Connection","You aren't connected to the internet. You need to be.")
			return 0 
			EndIf
		$allcodes = stringregexp($tests,'<OPTION value=[1-9]{3}',3)
		dim $allsems[1]
		$allsems[0] = $_allsems[0]
		for $svar = 1 to ubound($allcodes)-1
			_arrayadd($allsems,$_allsems[$svar])
			Next
		for $svar =0 to ubound($allcodes)-1
			$allcodes[$svar] = stringstripws(stringreplace($allcodes[$svar],"<OPTION value=",""),8)
		Next
		guictrlsetdata($Jones_sems,_arraytostring($allsems,"|"),$allsems[0])
		$testsem_jones = 1
		progressoff()
		global $allseme_jones = $allsems
		Return $allcodes
	EndIf
	if $testsem_jones = 1 then 
		$test = guictrlread($Jones_sems)
		for $war = 0 to ubound($allseme_jones)-1
			if stringstripws($allseme_jones[$war],8) = stringstripws($test,8) then ExitLoop
			Next
		return $allsemster_jones[$war]
		EndIf
	_iequit($object)
EndFunc

