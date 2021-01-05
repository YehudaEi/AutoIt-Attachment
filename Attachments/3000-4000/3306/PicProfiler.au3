#include <GUIConstants.au3>

$version = "0.10";
$font="Times New Roman"

;; Image Installs

FileInstall("C:\CODE\AutoIT\PictureProfiler\logo.gif", @TempDir & "\logo.gif", 1)
FileInstall("C:\CODE\AutoIT\PictureProfiler\picpreview.jpg", @TempDir & "\picpreview.jpg", 1)
FileInstall("C:\CODE\AutoIT\PictureProfiler\pp_about.gif", @TempDir & "\pp_about.gif", 1)


;; --------------------------------------------------
;; Main GUI Design
;; --------------------------------------------------

Opt("GUICoordMode",0)
$gui_main = GUICreate("Picture Profiler (Ver "& $version & ")", 355, 450) 
GUISetBkColor ( 16777215, $gui_main )

; Menu Design

$filemenu = GuiCtrlCreateMenu ("File")
$ctrl_menu_image_library = GuiCtrlCreateMenuitem ("Browse Image Library", $filemenu)
GuiCtrlCreateMenuitem ("", $filemenu)
$ctrl_menu_exit = GuiCtrlCreateMenuitem ("Exit", $filemenu)

$optionsmenu = GuiCtrlCreateMenu ("Options")
$ctrl_menu_options_client = GuiCtrlCreateMenuitem ("Client Setup", $optionsmenu)

$helpmenu = GuiCtrlCreateMenu ("About")
$ctrl_menu_about_pp = GuiCtrlCreateMenuitem ("About Picture Profiler", $helpmenu)

; Main Layout Design

$ctrl_logo=GUICtrlCreatePic(@TempDir & "\logo.gif", 0, 0, 355, 36)

GUICtrlCreateGroup ("Preview", 10, 30, 340, 250)
$ctrl_pic_preview = GUICtrlCreatePic(@TempDir & "\picpreview.jpg", 5, 15, 329, 229)

GUICtrlCreateGroup ("Description", -5, 5+229, 340, 100)
$ctrl_input_pic_description = GUICtrlCreateInput ( "", 5,  15, 330, 80, $ES_MULTILINE+$ES_WANTRETURN, $WS_EX_TRANSPARENT)
GUICtrlCreateButton ("Save Image Information",  -5, 90, 150)

;; --------------------------------------------------
;; Client Setup GUI Design
;; --------------------------------------------------

$gui_client_setup = GUICreate("Client Setup", 309, 240, -1, -1, $WS_EX_APPWINDOW) 

;---------------------
; Client Details Group
;---------------------

GUICtrlCreateGroup ("Client Details", 5, 5, 300, 120);

GUICtrlCreateLabel ("Client Name",  10, 20, 65) 
$ctrl_input_options_clientName = GUICtrlCreateInput ( "", 65, -5, 100, 20)

GUICtrlCreateLabel ("Extra Information",  -65, 25, 100) 
$ctrl_input_options_extra = GUICtrlCreateInput ( "", 0,  15, 280, 55, $ES_MULTILINE+$ES_WANTRETURN)

;---------------------
; Directory Setup Group
;---------------------

GUICtrlCreateGroup ("Directory Setup", -10, 70, 300, 65);
$ctrl_input_options_dir =  GUICtrlCreateInput ( "<Path to Image Directory>", 10, 15, 275, 20)
$ctrl_button_options_dir_browse = GUICtrlCreateButton ("Browse", 0, 24, 100, 20)

$ctrl_button_options_save = GUICtrlCreateButton ("Save Settings", 100, 30, 100, 20)
$ctrl_button_options_close = GUICtrlCreateButton ("Close", 110, 0, 80, 20)

;; --------------------------------------------------
;; About GUI Design
;; --------------------------------------------------

$gui_about = GUICreate("About Picture Profiler", 407, 133, -1, -1, $WS_EX_APPWINDOW) 
$ctrl_logo=GUICtrlCreatePic(@TempDir & "\pp_about.gif", 0, 0, 407, 113)



$status_gui_child_open = 0;


;; -- Initiate GUI

GUISetState (@SW_SHOW, $gui_main)

; Run the GUI until the dialog is closed
While 1

		$msg = GUIGetMsg()
		
		Select
		    Case ($msg == $GUI_EVENT_CLOSE) or ($msg == $ctrl_menu_exit) or ($msg == $ctrl_button_options_close)
						if ($status_gui_child_open == 1) Then
				    		CloseChildGUI();
						Else
		    				ExitLoop		        
		    		EndIf
		    Case $msg = $ctrl_menu_about_pp
		    		GUISetState (@SW_DISABLE, $gui_main)
		        GUISetState (@SW_SHOW, $gui_about)
		        $status_gui_child_open = 1;
				Case $msg = $ctrl_menu_options_client
		    		GUISetState (@SW_DISABLE, $gui_main)
		        GUISetState (@SW_SHOW, $gui_client_setup)
		        $status_gui_child_open = 1;		
		        
		        $pic_dir = IniRead(@WindowsDir & "\picprosetup.ini", "setup", "pic_dir", "<Not Set>");
		        GUICtrlSetData($ctrl_input_options_dir, $pic_dir);
		        
		        If ($pic_dir <> "<Not Set>") Then
		        		$var = IniRead($pic_dir & "\picpro.ini", "setup", "clientname", "");
		        		GUICtrlSetData($ctrl_input_options_clientName, $var);
		        		
		        		$var = IniRead($pic_dir & "\picpro.ini", "setup", "extra", "");
		        		$var = StringReplace($var, "#", @CRLF)
		        		GUICtrlSetData($ctrl_input_options_extra, $var);
		        		
		        EndIf
		        		
		    
		    ;-------------------------------------------
		    ; Client Configuration Setup
		    
		    Case $msg = $ctrl_button_options_dir_browse
		    		$var = FileSelectFolder("Find path to to picture folder.", "")
						GUICtrlSetData($ctrl_input_options_dir, $var);		    
				Case $msg = $ctrl_button_options_save

						$pic_dir = GUICtrlRead($ctrl_input_options_dir);
						IniWrite(@WindowsDir & "\picprosetup.ini", "setup", "pic_dir", $var)
				
						$var = GUICtrlRead($ctrl_input_options_clientName);
						IniWrite($pic_dir & "\picpro.ini", "setup", "clientname", $var)

						$var = GUICtrlRead($ctrl_input_options_extra);
					 	$var = StringReplace($var, @CRLF, "#")

						IniWrite($pic_dir & "\picpro.ini", "setup", "extra", $var)						
	        	
	        	CloseChildGUI();		        
		        
		    Case $msg = $ctrl_menu_image_library
		    		$var = FileOpenDialog("Select an Image File", "My Documents", "Images (*.jpg;*.bmp;*.gif)", 1 )		    		
		    		GuiCtrlSetImage ($ctrl_pic_preview, $var)				
		    Case Else
		        ; Do nothin
		EndSelect		
		
    
    
    
Wend

Func CloseChildGUI ()
		
		global $status_gui_child_open;

		GUISetState (@SW_ENABLE, $gui_main)
    GUISetState (@SW_HIDE, $gui_about)						
    GUISetState (@SW_HIDE, $gui_client_setup)						
    				        
    $status_gui_child_open = 0;
    
EndFunc				        