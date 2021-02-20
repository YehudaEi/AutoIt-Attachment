#CS
	GUI principal du programme : $main_gui

	fichier parent : sysStats.au3
	fichier enfant :
	fonction enfant :
	GUI courant		: $main_gui
	GUI enfant		:
#CE

Func main_gui()

	#Region ### START Koda GUI section ### Form=E:\MY WORKSTATION\DEV\SOFTS\AUTOIT\SysStats\GUI\main_gui.kxf

	#include <GuiConstants.au3>

	$main_gui = GUICreate("System Statistics", 935, 794, 342, 130, _
												BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP), _
												BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))


			; ******************
			;  MENU BAR DISPLAY
			; ******************

			#include "Include\MenuBar.au3"



			; ******************
			; 		TABS
			; ******************

			;$mainTab = GUICtrlCreateTab(24, 16, 881, 745, $TCS_SCROLLOPPOSITE)
			$mainTab = GUICtrlCreateTab(24, 16, 881, 745)

					; CPU DETAILS
					#include "Include\CPUdetails.au3"

					; MEM DETAILS
					#include "Include\MEMdetails.au3"

					; HDD DETAILS
					#include "Include\HDDdetails.au3"

					; end tabitem definition
					GUICtrlCreateTabItem("")

			GUISetState(@SW_SHOW)

	#EndRegion ### END Koda GUI section ###

			; _GUICtrlListView_RegisterSortCallBack($lv_CPUdetails, True, True)
			; _GUICtrlListView_RegisterSortCallBack($lv_MEMdetails, True, True)
			_GUICtrlListView_RegisterSortCallBack($lv_CPUdetails)
			 ;_GUICtrlListView_SortItems ($lv_CPUdetails, 5)

			;_GUICtrlListView_RegisterSortCallBack($lv_MEMdetails)
			 ;_GUICtrlListView_SortItems($lv_MEMdetails, 5)


			; ***********
			; 	HOTKEYS
			; ***********

			;HotKeySet ("^{enter}", "FunctionName")



			; *************
			; 	EVENMENTS
			; *************


							; ***********************
							; 		  MENUBAR
							; ***********************

							GUICtrlSetOnEvent($m_Close, "MainGui_Close")


							; ************************
							; 		GUI CONTROLS
							; ************************

							GUISetOnEvent($GUI_EVENT_CLOSE, "MainGui_Close")
							;GUISetOnEvent($LVN_COLUMNCLICK , "sortItemsInListView")
							;GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

							; GUICtrlSetOnEvent ($CPU , "enableCPUTab")
							GUICtrlSetOnEvent ($lv_CPUdetails , "sortItemsInCPUListView")
							GUICtrlSetOnEvent ($b_CPUrefresh , "updateCPUListView")

							; GUICtrlSetOnEvent ($MEMORY , "enableMEMTab")
							GUICtrlSetOnEvent ($lv_MEMdetails , "sortItemsInMEMListView")
							GUICtrlSetOnEvent ($b_MEMsave , "updateMEMListView")

							;GUICtrlSetOnEvent ($HDD , "enableHDDTab")



							;Global $B_CPU_DESCENDING[_GUICtrlListView_GetColumnCount ($lv_CPUdetails) ]
							;Global $B_MEM_DESCENDING[_GUICtrlListView_GetColumnCount ($lv_MEMdetails) ]

			While 1
				Sleep(10)
			WEnd

	; exiting the program
	MainGui_Close()


EndFunc
