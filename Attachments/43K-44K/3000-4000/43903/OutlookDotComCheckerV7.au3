#include <Math.au3>
#include <IE.au3>
#include <Date.au3>
#include <Timers.au3>
#include <GUIConstantsEx.au3>

#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#Include <File.au3>
#include <WindowsConstants.au3>
#Include <GuiListBox.au3>
#Include <GuiListView.au3>
#include <ListviewConstants.au3>
#Include <GuiRichEdit.au3>

#cs
	Title:   		Outlook,com mail checker
	Filename:  		*.au3
	Description: 	?
	Author:   		ozmike
	Version:  		V0.1
	Last Update: 	24/06/13
	Requirements: 	AutoIt3 3.2 or higher
	Changelog:		
					---------24/06/13---------- v0.1
					Initial release.
#ce


;------------------------------------------------------------------
; Constants and Variables
;------------------------------------------------------------------


Const $delay = 150, $safe_tv_area_indent = 30, $max_button_width = 740 - ($safe_tv_area_indent * 2), $max_button_height = 580 - ($safe_tv_area_indent * 2) ;$max_button_width = 740, $max_button_height = 580
Const $main_gui_width = 550, $main_gui_height = 550, $std_button_width = 70, $std_button_height = 20, $std_button_gap = 10, $std_input_width = 200
const $screen_centre_x = abs($max_button_width / 2), $screen_centre_y = abs($max_button_height / 2), $button_margin = 20
Const $ini_filename = @TempDir & "\outlookcheckerv5.ini"
dim $msg, $button_width, $main_gui
dim $res
Dim $szDrive, $szDir, $szFName, $szExt


Dim $gipoll = 0
Dim $gifound = 0
Dim $giemail= 0
Dim $gi_error = 0
Dim $gi_errortxt = ""
;------------------------------------------------------------------
; Configure the GUI
;------------------------------------------------------------------

$main_gui = GUICreate("Outlook.com checker. v7", $main_gui_width, $main_gui_height)
$filemenu = GUICtrlCreateMenu("&File")
$exititem = GUICtrlCreateMenuItem("Exit", $filemenu)


GUICtrlCreateLabel("Outlook.com message checker : ", 10, 30, 230)


$cancelbutton = GUICtrlCreateButton("&Stop Sound", 370, 50, $std_button_width, $std_button_height)


$gobutton = GUICtrlCreateButton("GO", 450, 50, 60, 20)

;GUICtrlCreateLabel("mode : ", 10, 50, 50)

;$combo_mode = GUICtrlCreateCombo("", 50+10, 50, 300, 20)
;GUICtrlSetData(-1, "Alert when any email arrives|Alert when only title contains your text |Alert when title and body contain your text", "Alert when title and body contain your text")

GUISetState(@SW_SHOW)




dim $g_emailtitle = ""
dim $g_emaildt = ""
dim $g_emailbody = ""
dim $g_emailfrom = ""
Dim $whnd_ie  = 0

dim $l_emailtitle = ""
dim $l_emaildt = ""
dim $l_emailbody = ""
dim $l_emailfrom = ""


Local $hGui, $hRichEdit, $iMsg
$hGui = $main_gui
    $hRichEdit = _GUICtrlRichEdit_Create($hGui, " "   , 10, 80, 500, 220, _
            BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
			
			_GUICtrlRichEdit_AppendText($hRichEdit, @CR & "Instructions : login to your outlook.com in Internet explorer (IE).  .")
_GUICtrlRichEdit_AppendText($hRichEdit, @CR & "In outlook.com have email preview on ie. in email settings, choose 'reading pane bottom'"   )
_GUICtrlRichEdit_AppendText($hRichEdit, @CR & " Enter your search criteria THEN press GO."   & @CR & @CR )

;_GUICtrlRichEdit_AppendText($hRichEdit, @CR & " Once you have done this press the GO button."   & @CR )

_GUICtrlRichEdit_AppendText($hRichEdit, @CR & "HELP : This app will alert you when an email arrives " ) 
_GUICtrlRichEdit_AppendText($hRichEdit, @CR & "Depending on the search criteria entered"  & @CR)

_GUICtrlRichEdit_AppendText($hRichEdit, @CR & "When an email arrives,  " & @CR) 
_GUICtrlRichEdit_AppendText($hRichEdit, @CR & "1. Will check if email matches your criteria." ) 
_GUICtrlRichEdit_AppendText($hRichEdit, @CR & "2. If all search fields are left blank it will beep when any email arrives." ) 

_GUICtrlRichEdit_AppendText($hRichEdit, @CR & "3. beep and then play the sound file (if given)"  & @CR)


	_GUICtrlRichEdit_SetFont($hRichEdit, 15, "Courier")
	
                        



;
$voffset = 60

GUICtrlCreateLabel("Your Email address:", 10, 270+ $voffset, 100)
;dim $email_addr = 
$email_addr_ctrl = GUICtrlCreateInput(  IniRead($ini_filename, "config", "Email address", "myemail@hotmail.com")  , 110, 270+ $voffset, 400, 20)
GUICtrlCreateLabel("Search Fields : Leave fields blank if don't want to match ( to beep when any email arrives leave all blank):", 10, 300+ $voffset, 500)


;dim $search_title = 
GUICtrlCreateLabel("Email From Contains :", 10, 330+ $voffset, 100)
$search_from_ctrl = GUICtrlCreateInput(  IniRead($ini_filename, "config", "Search Email From", "name@domain.com") , 110, 330+ $voffset, 400, 20)

GUICtrlCreateLabel("Email Title Contains :", 10, 360+ $voffset, 100)
$search_title_ctrl = GUICtrlCreateInput(  IniRead($ini_filename, "config", "Search Email Title", "Play sound when Email Message title contains this text") , 110, 360+ $voffset, 400, 20)

GUICtrlCreateLabel("Email Body Contains :", 10, 390+ $voffset, 100)
$search_body_ctrl = GUICtrlCreateInput(  IniRead($ini_filename, "config", "Search Email Body", "Friday") , 110, 390+ $voffset, 400, 20)



GUICtrlCreateLabel("Sound File :", 10, 450+ $voffset, 100)
;dim $sound_file =
$sound_file_ctrl = GUICtrlCreateInput(  IniRead($ini_filename, "config", "Sound File", "C:\Users\user\Music\my.mp3")  , 110, 450+ $voffset, 400, 20)
$sound_file_button = GUICtrlCreateButton("..", 400+110, 450+ $voffset, 20, 20)

beep(); sound test





Dim $oie, $oFld

func sGetField($s, $from, $to)
	$i = StringInStr($s,  $from )
	if $i = 0 Then
	    $gi_error = $gi_error + 1
		$gi_errortxt = "Not found from :" & $from
		return "Not found :" & $from
	endif	
	$ss= StringMid($s,$i + StringLen($from) )
	$i = StringInStr($ss,  $to )
	if $i = 0 Then
	    $gi_error = $gi_error + 1
		$gi_errortxt = "Not found to :" & $to
		return "Not found :" & $to
		
	endif
	$sss= StringLeft($ss,$i - 1 )
	return $sss
endfunc

	

func GetLatestEmail()
    Dim $richtext = ""
	if $oie = 0 then
		$email_addr = GUICtrlRead($email_addr_ctrl)
		$oie = _IEAttach($email_addr  )
	 endif
	 
	if $oie = 0 Then
		
		_GUICtrlRichEdit_SetText($hRichEdit, "Can't find an IE tab with " & _
												$email_addr  & " in title." &  @CRLF & _
											  "Make sure Internet Explorer is started and you " & _
											  "are logged into outlook.com.")				
		return -1
	endif	
	;msgbox(0,  "Can't find ", $oie )

	Local $sHTML = _IEDocReadHTML($oIE)
	;_GUICtrlRichEdit_SetText($hRichEdit, $sHTML)
    $search = "RPOn" ; RPBottom
	$i = StringInStr($sHTML, $search) 
	if $i = 0 Then
		;msgbox(0,  "Can't find ", $inbox )
		_GUICtrlRichEdit_SetText($hRichEdit, "Review pane must be on. See outlook.com Settings. Can't find " & $search & @CRLF)
		return
	endif
    $search = "RPBottom" ; 
	$i = StringInStr($sHTML, $search) 
	if $i = 0 Then
		;msgbox(0,  "Can't find ", $inbox )
		_GUICtrlRichEdit_SetText($hRichEdit, "Review pane must be on Bottom. See outlook.com Settings. Can't find " & $search & @CRLF)
		return
	endif	 
	
	;$inbox = "inboxtablebody"
	$inbox = "MessageRow"
	$i = StringInStr($sHTML, $inbox) 
	if $i = 0 Then
		;msgbox(0,  "Can't find ", $inbox )
		_GUICtrlRichEdit_SetText($hRichEdit, "Can't find " & $inbox & @CRLF)
		return
	endif	
	;return
	$emailhdr = StringMid($sHTML,$i, 3000)
	_GUICtrlRichEdit_SetFont($hRichEdit, 15, "Courier")
	_GUICtrlRichEdit_SetText($hRichEdit, $emailhdr)

	_GUICtrlRichEdit_SetText($hRichEdit, "")
	; get first email
	
	;_GUICtrlRichEdit_AppendText($hRichEdit, @CRLF)
	;_GUICtrlRichEdit_AppendText($hRichEdit, "Header :" & $emailhdr)
    $emaildt = sGetField($emailhdr, "class=""Dt"">", "class=""Sb" )
	;<span class="Dt">        <script type="jsv#827^"></script>2:55 PM<script type="jsv/827^"></script>      </span>

	$emaildt = sGetField($emaildt, "</script>", "<script") ; get time or date 
	
	$i = StringInStr($emailhdr, """>") ; skip to script

	$emailhdr = StringMid($emailhdr,$i, 3000)
	
    $richtext = $richtext & "Email Date  : " & $emaildt & @CRLF
	;$richtext = $richtext & "Email Hdr  : " & $emaildt & @CRLF
	
	;_GUICtrlRichEdit_AppendText($hRichEdit, @CRLF)

	;$emailtitle = sGetField($emailhdr, "href=""#"">", "</a>")
	
	;<span class="Sb">      <span class="t_estc t_elnk" data-link="class{getClassesForSubject:IsRead}">        <script type="jsv#828^"></script>Email title Newsletter - April 2014<script type="jsv/828^"></script>
	$emailtitle = sGetField($emailhdr, "class=""t_estc t_elnk""", "/li")
	
	$emailtitle = sGetField($emailtitle, "</script>", "<script") ; title text 
	
	;_GUICtrlRichEdit_AppendText($hRichEdit, @CRLF)
	;_GUICtrlRichEdit_AppendText($hRichEdit, "Email Title : "  & $emailtitle)
	$richtext = $richtext & "Email Title : "  & $emailtitle & @CRLF
	;consolewrite("title:" & $emailtitle &  ":" &  stringlen($emailtitle) &  @CRLF) 
	;$emaildt = sGetField($emailhdr, "mdt=""", """")
	
	;_GUICtrlRichEdit_AppendText($hRichEdit, "Email Date  : " & $emaildt)
	;_GUICtrlRichEdit_AppendText($hRichEdit, @CRLF)
	
	$emailfrom = sGetField($emailhdr, "email=""", """"); not changed
    $richtext = $richtext & "Email From  : " & $emailfrom & @CRLF
	
	$richtext =  @CRLF & $richtext & @CRLF & _
	"Emails arrived " & $giemail & " Emails matched " & $gifound & " ; Cycles " & $gipoll &  " ; Errors " & $gi_error & " ; Last Error " & $gi_errortxt 

	;_GUICtrlRichEdit_AppendText($hRichEdit, "Email From  : " & $emailfrom)
	;_GUICtrlRichEdit_AppendText($hRichEdit, @CRLF)
	
	;$msgContainer ="mpf0_MsgContainer"
	$msgContainer ="MsgBodyContainer"
	
	$emailbody = ""
	$i = StringInStr($sHTML, $msgContainer) 
	if $i > 0 Then
		
		$emailbody = StringMid($sHTML,$i)
		$emailbody = sGetField($emailbody, $msgContainer, "</div>")
		; if you want to search something specific you could put here
		;$jobstartstime = sGetField($emailbody, "Start Date Time:", "<br>") ;16/09/2013 0805 Monday
		
		;$search_body_text = GUICtrlRead($search_body_ctrl)
		
		;
		;if StringInStr($jobstartstime, $search_body_text)  > 0 Then
		;		ConsoleWrite("Text found:" &  @CRLF)
				
		;else
		;		ConsoleWrite("Text NOT found:" &  @CRLF)
		;endif
		
		
		;_GUICtrlRichEdit_AppendText($hRichEdit, "Job Start Time:" & $jobstartstime )
		;_GUICtrlRichEdit_AppendText($hRichEdit, @CRLF)
		
		
		
		
   else
		 $richtext = $richtext & "Email body Not Found :" & $msgContainer & @CRLF

		;_GUICtrlRichEdit_AppendText($hRichEdit, "Email body Not Found :" & $msgContainer)
		;_GUICtrlRichEdit_AppendText($hRichEdit, @CRLF)
   endif	
	 _GUICtrlRichEdit_AppendText($hRichEdit, $richtext)
	$g_emailbody = $emailbody
	$g_emailtitle = $emailtitle 
	$g_emaildt  = $emaildt 
	$g_emailfrom  = $emailfrom 


	return

endfunc

func playsound()
	
	beep( 1000, 1000);
	SoundPlay ( GUICtrlRead($sound_file_ctrl) ); 
endfunc	

func StopScreenSaver()
	
	
	if _Timer_GetIdleTime() > 20*1000  then ; if idle 20 sec
    
	    $x = MouseGetPos (0)
		
        $y = MouseGetPos (1)
        MouseMove ($x + 20, $y, 5)
        MouseMove ($x, $y, 5)
    EndIf
	
endfunc	
func bIsAtTop()
	Local $sHTML = _IEDocReadHTML($oIE)
	
	;$inbox = "inboxtablebody"
	$inbox = "MessageRow"
	$i = StringInStr($sHTML, $inbox) 
	if $i = 0 Then
		;msgbox(0,  "Can't find ", $inbox )
		_GUICtrlRichEdit_SetText($hRichEdit, "Can't find " & $inbox)
		return
    endif	
	$idtext = StringMid($sHTML,$i, 300)
	$idfirst = sGetField($idtext, "id=""", """") ; first id
	ConsoleWrite("idfirst=:" &  $idfirst & ":" &  @CRLF)
	
	$search = " mlSel" ; find selected row
	$i = StringInStr($sHTML, $search) 
	if $i = 0 Then
		;msgbox(0,  "Can't find ", $inbox )
		_GUICtrlRichEdit_SetText($hRichEdit, "Can't find mlSel" & $inbox)
		return
	endif	
	$idtext = StringMid($sHTML,$i, 300)
	$id = sGetField($idtext, "id=""", """") 
	;$bof = sGetField($idtext, "bof=""", """")
	;$mdt = sGetField($idtext, "mdt=""", """")
	ConsoleWrite("id     =:" &  $id & ":" &  @CRLF)
	
	;ConsoleWrite("mdt    =:" &  $mdt & ":" &  @CRLF)
	if $id = $idfirst Then ; begin of file - latest email
		ConsoleWrite("at BOF=:" &  "YES" & ":" &  @CRLF)
		return true
	EndIf
	return false;
	
	
endfunc
func bIsAtTopold(); not used
	Local $sHTML = _IEDocReadHTML($oIE)
	$search = " mlSel" ; find selected row
	$i = StringInStr($sHTML, $search) 
	if $i = 0 Then
		;msgbox(0,  "Can't find ", $inbox )
		_GUICtrlRichEdit_SetText($hRichEdit, "Can't find mlSel" & $inbox)
		return
	endif	
	$idtext = StringMid($sHTML,$i, 300)
	$id = sGetField($idtext, "id=""", """") 
	$bof = sGetField($idtext, "bof=""", """")
	$mdt = sGetField($idtext, "mdt=""", """")
	
	ConsoleWrite("id=:" &  $id & ":" &  @CRLF)
	ConsoleWrite("bof=:" &  $bof & ":" &  @CRLF)
	ConsoleWrite("mdt=:" &  $mdt & ":" &  @CRLF)
	
	if $bof = "bof" Then ; begin of file - latest email
		ConsoleWrite("at BOF=:" &  $bof & ":" &  @CRLF)
		return true
	EndIf
	return false;
	
	
endfunc
	
func MoveToTopEmail()
		; check if top message selected - if not select it so that preview pane show latest body
	
;Dim $bAtTop = false


	while bIsAtTop() = false
		EmailMovePrev()
				
		;send("^,"); outlook .com press up arrow previous message..
		;ConsoleWrite("Not at top:" &  @CRLF)

			
	wend	
endfunc

func EmailMovePrev()
	; must have IE window active
	send("^,"); outlook .com press up arrow previous message..
	ConsoleWrite("Not at top:EmailMovePrev()" &  @CRLF)

endfunc	

func CheckEmailTitle()

	$gipoll = $gipoll + 1

; UI validations




	

	$rdata = GetLatestEmail( )
	
	
	;ConsoleWrite($l_emailtitle & @CRLF)
	;ConsoleWrite(":" & $g_emailtitle & ":" & @CRLF)
	;ConsoleWrite($l_emaildt  & @CRLF)
	;ConsoleWrite(  $g_emaildt & @CRLF)
	;ConsoleWrite($l_emaildt <>  $g_emaildt & @CRLF)
	Dim $bNewEmailTitleMatch = false
	Dim $bNewEmailBodyMatch = false
	Dim $bNewEmailFromMatch = false
    Dim $bNewMatch = false

	Dim $bNewEmail = false
	if $l_emaildt <>  $g_emaildt Then  ; new email 
		$giemail = $giemail + 1

		$email_addr = GUICtrlRead($email_addr_ctrl)
		
		$bNewEmail = True
		
		ConsoleWrite("Click " & $l_emaildt  & @CRLF)
		
		;if GUICtrlRead($search_body_ctrl) <> "" then ;must move email to top, to see lower pane
		Opt("WinTitleMatchMode", 2)
		WinActivate( $email_addr)
	 
		while bIsAtTop() = false and $bNewMatch = false
			EmailMovePrev()
		 
			
		 ;if stringinstr( $l_emailtitle , GUICtrlRead($search_title_ctrl) ) > 0  then
			 ;beep() ; target email title arrives
			 sleep(1000) ; allow time for lower pane to refresh; should be in EmailMovePrev
			 ;$bNewEmailTitleMatch = True
			 $rdata = GetLatestEmail( ) ; should just get body..
			  $l_emailtitle = $g_emailtitle 
			  $l_emaildt  = $g_emaildt 
			  $l_emailfrom  = $g_emailfrom 
			  $l_emailbody  = $g_emailbody 
			 
			 ;ConsoleWrite("email title " & $l_emailtitle  & @CRLF)
			 ;ConsoleWrite("email body " & $l_emailbody  & @CRLF) 
			 if stringinstr( $l_emailfrom , GUICtrlRead($search_from_ctrl) ) > 0  or GUICtrlRead($search_from_ctrl) = "" then
				  $bNewEmailFromMatch = true
				 
			 EndIf
			 if stringinstr( $l_emailtitle , GUICtrlRead($search_title_ctrl) ) > 0 or  GUICtrlRead($search_title_ctrl) = "" then
				  $bNewEmailTitleMatch = true
				 
			 EndIf
			 if stringinstr( $l_emailbody , GUICtrlRead($search_body_ctrl) ) > 0  or GUICtrlRead($search_body_ctrl) = "" then
				 $bNewEmailBodyMatch = true
				 
				 ;playsound()
				 ;return ; stop if email found could alse check if read.
			  endif
			  if $bNewEmailFromMatch = true and $bNewEmailTitleMatch = true and $bNewEmailBodyMatch = true then
				  $bNewMatch = true
			  endif	 
			 ;exit;
		 ;	playsound()
		 ;endif
		 wend
		 if    $bNewMatch = false Then
			return ;no match
		 endif   
		 ;EndIf	
		 ; Found match
		Opt("WinTitleMatchMode", 2)
	    WinActivate( $email_addr)
		;if $bNewEmailBodyMatch = true Then
		$gifound = $gifound + 1
			playsound() ; everything matches
		;endif
		
		
	endif	
	





return


EndFunc


;dim $g_mousepos

While 1
	
	$msg = GUIGetMsg()
	
    if $msg = $gobutton Then
		$rdata = GetLatestEmail( )
		if $rdata <> -1 Then
		   Opt("WinTitleMatchMode", 2)
		   $email_addr = GUICtrlRead($email_addr_ctrl)
		   
		   
		   ; if a body match required - must move to first email, so that split pane is shown
		   ;if GUICtrlRead($search_body_ctrl) <> "" then
			  WinActivate( $email_addr)
			  MoveToTopEmail()
			  if bIsAtTop() = false Then
				  ConsoleWrite("not at top 1 " & @CRLF)
			  else	
				  ConsoleWrite("at top " & @CRLF)
			   endif
			;endif
		   
		   $l_emailtitle = $g_emailtitle ; set to initial title  ; comment out to test
		   $l_emaildt  = $g_emaildt 
		   $l_emailbody  = $g_emailbody ; probably needed?
		   $l_emailfrom  = $g_emailfrom ; probably needed?
		   ConsoleWrite("Started " & @CRLF)
		   ;$g_mousepos = MouseGetPos (0)
	   
		   AdlibRegister("CheckEmailTitle", 3000) ; poll every 3 secs
		   AdlibRegister("StopScreenSaver", 20*1000); every so often move mouse
	    endif
		
		
		
	endif	
	
	if $msg = $cancelbutton Then
		SoundPlay ( ""  );[, wait] )
	endif	
    if $msg = $sound_file_button Then	
		$var = FileOpenDialog("select a sound file", @UserProfileDir & "\", "Sound Files (*.mp3;*.wav)", 1 + 2 )
		If @error Then
			MsgBox(4096,"","No File(s) chosen")
		Else
			$var = StringReplace($var, "|", @CRLF)
			;MsgBox(4096,"","You chose " & $var)
			GUICtrlSetdata($sound_file_ctrl, $var)
		EndIf
	endif	



	If $msg = $GUI_EVENT_CLOSE or $msg = $exititem Then
		;IniWrite($ini_filename, "config", "Outlook.com", "https://blu158.mail.live.com/#!/"); mot used
		IniWrite($ini_filename, "config", "Email address", GUICtrlRead( $email_addr_ctrl  ));)
		IniWrite($ini_filename, "config", "Search Email Title", GUICtrlRead( $search_title_ctrl  ))
	    IniWrite($ini_filename, "config", "Search Email From", GUICtrlRead( $search_from_ctrl  ))
		IniWrite($ini_filename, "config", "Search Email Body", GUICtrlRead( $search_body_ctrl  ))

		IniWrite($ini_filename, "config", "Sound File", GUICtrlRead( $sound_file_ctrl  ))
	  

		
		ExitLoop
	EndIf
		
	
		
WEnd
GUIDelete()

Func _IEGetObjByClass($oIE, $sClass, $sTag = "*")
    Local $aRet[1] = [0]

    Local $allHTMLTags = _IETagNameGetCollection($oIE, $sTag)
    For $o In $allHTMLTags
        If IsString($o.className) And $o.className = $sClass Then
			ConsoleWrite("found:" & @CRLF)
            $aRet[0] += 1
            ReDim $aRet[$aRet[0] + 1]
            $aRet[$aRet[0]] = $o
			ConsoleWrite("found:" & $o.className  & @CRLF)
			
			_IEAction($o, "click")
        EndIf
    Next
	ConsoleWrite("count:" & $aRet[0]  & @CRLF)
			
    Return $aRet
	
EndFunc  

;==>_IEGetObjByClass
;1173658c-1c08-11e3-bc8a-00237de3a320
		;Local $oDiv = _IEGetObjById($oIE, "1173658c-1c08-11e3-bc8a-00237de3a320")
		;$oDiv = _IEGetObjById($oIE, "e6019a0b-1c16-11e3-8aa5-00215ad7c1d2")
		;ConsoleWrite("Get" & @CRLF)
		;ConsoleWrite("zero not found:" & $oDiv & @CRLF)
		;ConsoleWrite("Error:" & @error & @CRLF)
		;_IEAction($oDiv, "click")
		;$oDiv.FireEvent("onclick")
		;ConsoleWrite("b4" & @CRLF)
		;$oElements = _IEGetObjByClass($oie, "lnav_itemLnk t_s_hov t_sel", "a");"t_estc" ,
		;ConsoleWrite("ar" & @CRLF)
		;ConsoleWrite("Element Info Tagname: " & $oElement[0] & @CR )
		;ConsoleWrite("ar" & @CRLF)
		;ConsoleWrite("Element Info Tagname: " & $oElement[1].tagname & @CR ); & "innerText: " & $oElement.innerText)
		;For $oElement In $oElements
		;	ConsoleWrite("Element Info", "Tagname: " & $oElement.tagname & @CR ); & "innerText: " & $oElement.innerText)
		;Next	
		;ConsoleWrite("b4" & @CRLF)
		;$oElements = _IETagNameAllGetCollection ($oDiv)
		;For $oElement In $oElements
		;	 ConsoleWrite("Element Info Tagname: " & $oElement.tagname & @CR ); & "innerText: " & $oElement.innerText)
		;Next

		;ConsoleWrite("after click:" & @CRLF)
		;ConsoleWrite("after click:" & $oDiv.id  ) & @CRLF)
		
		;_GUICtrlRichEdit_AppendText($hRichEdit, "Job Start Time:" & _IEPropertyGet($oDiv, "id" )
		;_GUICtrlRichEdit_AppendText($hRichEdit, @CRLF)
		;ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CRLF)
		
		
		
		;#include <IE.au3>

;$oIE = _IECreate()
;_IEDocWriteHTML($oIE, "<html><head><script luanguage = 'javascript'>foo='bar';</script></head><body></body></html>")

;ConsoleWrite("foo = " & $oIE.document.parentwindow.eval('foo') & @CR)

	;$email_addr = GUICtrlRead($email_addr_ctrl)
	;dim $oie = -1
	;sleep(2000)
	;ConsoleWrite("oie" & $oie & @CRLF)
	;ConsoleWrite("oie" & $email_addr  & @CRLF)
	;$oie = _IEAttach($email_addr  )
	;ConsoleWrite("@error" & @error & @CRLF)
	;ConsoleWrite("@extended" & @extended & @CRLF)
	;ConsoleWrite("oie" & $oie & @CRLF)
	;ConsoleWrite("url " & _IEPropertyGet ($oIE, "locationurl") & @CRLF)
	;if $oie = 0 Then
	
	;	ConsoleWrite("oie" & $oie & @CRLF)				
	;	return
	;endif	
	;Local $oDiv = _IEGetObjById($oie, $id)
	
	
	;ConsoleWrite("after=ret" & $odiv & @CRLF)
	;ConsoleWrite("after=ret" & @error & @CRLF)
	;ConsoleWrite("className=" &  $oDiv.className & @CRLF)
	;ConsoleWrite("id=" &  $oDiv.id & @CRLF)
	;ConsoleWrite("mdt=" & $oDiv.mdt & @CRLF)
	
		
	;ConsoleWrite("mdt=" &  $oDiv.mdtName & @CRLF)
		
	; now get id
