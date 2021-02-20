; PROGRAM NAME
Global Const $SOFT_NAME = "Sys-Stats"

; GUI
Global $main_gui, $mainTab
; MENU BAR
Global $m_File, $m_Save, $m_Save_CPUdetails, $b_Save_MEMdetails, $m_Save_HDDdetails, $m_Save_All, $m_Close
Global $m_Edit
Global $m_Display
Global $m_Help, $m_About
; CPU details
Global $CPU
Global $g_CPUinfo, $l_CPUinfoResponse
Global $l_CPUmessage
Global $lv_CPUdetails
Global $b_CPUsave, $b_CPUrefresh
; MEMORY details
Global $MEMORY
Global $g_MEMinfo, $l_PhyRAMused, $l_PhyRAMfree, $l_PhyRAMtotal, $l_VirtualRAMused, $l_VirtualRAMfree, $l_VirtualRAMtotal
Global $l_MEMmessage
Global $lv_MEMdetails
Global $b_MEMsave, $b_MEMrefresh
; HDD details
Global $HDD
Global $g_HDDinfo, $tv_HDDdrive, $chb_Temp, $chb_TIF, $chb_Downloads
Global $l_HDDmessage
Global $lv_HDDdetails
Global $b_HDDsave, $b_HDDrefresh

; Processes
;Dim $a_ProcessDetails[1][11]
Global $a_ProcessDetails, $B_DESCENDING, $B_CPU_DESCENDING, $B_MEM_DESCENDING

; GUI controls styles
Global $i_ExWindowStyle = BitOR($WS_EX_DLGMODALFRAME, $WS_EX_CLIENTEDGE)
Global $i_ExListViewStyle = BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER)
														; BitOR ($GUI_SS_DEFAULT_LISTVIEW,$LVS_SORTASCENDING,$WS_VSCROLL,$LVS_REPORT)
														; BitOR ($WS_EX_CLIENTEDGE,$LVS_EX_HEADERDRAGDROP,$LVS_EX_FULLROWSELECT)