; ======================================================================
; MW2 Admin Tool - SySpirit.tk
; ======================================================================
$VERSION = "v2.7"
; ======================================================================
; Includes
; ======================================================================
#include <Misc.au3>
#Include <File.au3>
#Include <WinAPI.au3>
#include <SQLite.au3>
#Include <Array.au3>
#include "memory.au3"
#Include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include "WinHTTP.au3"
#Include <String.au3>
#Include <UnixTime.au3>

; Make it impossible to run in multiple instances
if _Singleton("mw2admintool",1) = 0 Then
    Msgbox(16,"Warning", "MW2 Admin Tool is already running.")
    Exit
EndIf

; Bind enter and escape
HotKeySet("{ENTER}", "capture_enter")
HotKeySet("{ESC}", "capture_esc")

; Tweak script
AutoItSetOption ("WinTitleMatchMode", 2)
AutoItSetOption ("GUIOnEventMode", 1)
AutoItSetOption ("TrayOnEventMode", 1)
AutoItSetOption ("TrayAutoPause", 0)
AutoItSetOption ("TrayMenuMode", 1)

; ======================================================================
; Tray
; ======================================================================
$tray_about  = TrayCreateItem ("About")
TrayItemSetOnEvent(-1,"about")
TrayCreateItem("")
$tray_options = TrayCreateItem ("Options")
TrayItemSetOnEvent(-1,"options")
$tray_custom = TrayCreateItem ("Custom commands")
TrayItemSetOnEvent(-1,"custom")
TrayCreateItem("")
$tray_exit  = TrayCreateItem ("Exit")
TrayItemSetOnEvent(-1,"closebutton")

TraySetToolTip ( "MW2 Admin Tool "&$VERSION )

func about()
	TrayItemSetState ( $tray_about, 4 )
	MsgBox(64,"About","CoD:Modern Warfare 2 Admin Tool "&$VERSION&@CRLF&"for v1.3.37a alterIW version of MW2"&@CRLF&"Developed by www.SySpirit.tk 2010"&@CRLF&"Removed outside links by Nestea")
endfunc

; ======================================================================
; Memory Addresses
; ======================================================================
$process_name = IniRead( "data/core.ini", "Core", "ProcessName", "" )
Local $game_window_title = "unset"
Local $console_window_title = "unset"
$FIRST_CLIENT_ID = IniRead( "data/core.ini", "Memory Addresses", "FIRST_CLIENT_ID", "" ) ; memory address of the name of the player with client ID 1
$CLIENT_ID_OFFSET = IniRead( "data/core.ini", "Memory Addresses", "CLIENT_ID_OFFSET", "" ) ; lenght between the player names (ex.: $FIRST_CLIENT_ID + $CLIENT_ID_OFFSET = name of the Client ID 2 player)
$FIRST_XUID = IniRead( "data/core.ini", "Memory Addresses", "FIRST_XUID", "" ) ; memory address of the XUID of the player with client ID 1
$XUID_OFFSET = IniRead( "data/core.ini", "Memory Addresses", "XUID_OFFSET", "" ) ; lenght between the XUIDs
$HOST_CHECKER = IniRead( "data/core.ini", "Memory Addresses", "HOST_CHECKER", "" ) ; if this address is filled with data you are the host
$INGAME_CHECKER = IniRead( "data/core.ini", "Memory Addresses", "INGAME_CHECKER", "" ) ; if this address is filled with data you are ingame
$CHAT_MEMORY = IniRead( "data/core.ini", "Memory Addresses", "CHAT_MEMORY", "" ) ; chat text
$CHAT_OPEN = IniRead( "data/core.ini", "Memory Addresses", "CHAT_OPEN", "" )  ; (0x0 = closed, can be opened 0x10 = menu, cannot be opened, 0x20 = chat open)
$CHAT_TYPE = IniRead( "data/core.ini", "Memory Addresses", "CHAT_TYPE", "" ) ; (0x0 = public chat, 0x1 = team chat)
$CHAT_CURSOR = IniRead( "data/core.ini", "Memory Addresses", "CHAT_CURSOR", "" )  ; chat indicator position
$CHAT_LENGHT = IniRead( "data/core.ini", "Memory Addresses", "CHAT_LENGHT", "" ) ; lenght of the chat text
$HOST_CLIENTID = IniRead( "data/core.ini", "Memory Addresses", "HOST_CLIENTID", "" ) ; the host player's client id
$LOBBY_CHECKER = IniRead( "data/core.ini", "Memory Addresses", "LOBBY_CHECKER", "" ) ; if not 0, you are in private, or public lobby
$LOBBY_MAPNAME = IniRead( "data/core.ini", "Memory Addresses", "LOBBY_MAPNAME", "" ) ; Selected map in the lobby
$LOBBY_SEARCH = IniRead( "data/core.ini", "Memory Addresses", "LOBBY_SEARCH", "" ) ; Lobby find game (searching for games if set to 1 [default])
$TITLE_GAME = IniRead( "data/core.ini", "Memory Addresses", "TITLE_GAME", "" ) ; Memory address of the game window's title
$TITLE_CONSOLE = IniRead( "data/core.ini", "Memory Addresses", "TITLE_CONSOLE", "" ) ; Memory address of the console's title

$IP_BYTE_1 = IniRead( "data/core.ini", "Server Browser", "IP_BYTE_1", "" ) ; Host IP byte 1 (ex.: 111 from 111.222.333.444)
$IP_BYTE_2 = IniRead( "data/core.ini", "Server Browser", "IP_BYTE_2", "" ) ; Host IP byte 2
$IP_BYTE_3 = IniRead( "data/core.ini", "Server Browser", "IP_BYTE_3", "" ) ; Host IP byte 3
$IP_BYTE_4 = IniRead( "data/core.ini", "Server Browser", "IP_BYTE_4", "" ) ; Host IP byte 4
$IP_PORT_ADDR = IniRead( "data/core.ini", "Server Browser", "IP_PORT_ADDR", "" ) ; Host port
$INGAME_MAP_NAME_ADDR = IniRead( "data/core.ini", "Server Browser", "INGAME_MAP_NAME_ADDR", "" ) ; Current map name (ingame)
$LOBBY_MAP_NAME_ADDR = IniRead( "data/core.ini", "Server Browser", "LOBBY_MAP_NAME_ADDR", "" ) ; Current map name (lobby)
$MAX_CLIENTS_ADDR = IniRead( "data/core.ini", "Server Browser", "MAX_CLIENTS_ADDR", "" ) ; Max clients
$TIMELEFT_ADDR = IniRead( "data/core.ini", "Server Browser", "TIMELEFT_ADDR", "" ) ; ingame timeleft string
$GAMETYPE_ADDR = IniRead( "data/core.ini", "Server Browser", "GAMETYPE_ADDR", "" ) ; ingame game type string (ex.: war, dm, ctf)
$PLAYERS_LOBBY_ADDR = IniRead( "data/core.ini", "Server Browser", "PLAYERS_LOBBY_ADDR", "" ) ; number of players (lobby)
$PLAYERS_INGAME_ADDR = IniRead( "data/core.ini", "Server Browser", "PLAYERS_INGAME_ADDR", "" ) ; number of players (ingame)
$SERVER_FULL_CHECKER = IniRead( "data/core.ini", "Server Browser", "SERVER_FULL_CHECKER", "" ) ; server is full notice while trying to connect
$SERVER_INFO = IniRead( "data/core.ini", "Server Browser", "SERVER_INFO", "" ) ; server info (required to identify mods)
; ======================================================================
; Detect window names
; ======================================================================
func setWindowNames()
	if $ATTACHED then
		$game_window_title = _MEMORYREAD($TITLE_GAME, $PROCESS, "char[20]")
		$console_window_title = _MEMORYREAD($TITLE_CONSOLE, $PROCESS, "char[20]")
	endif
endfunc

; ======================================================================
; Global variables
; ======================================================================
$keylist = "q|w|e|r|t|y|u|i|o|p|a|s|d|f|g|h|j|k|l|z|x|c|v|b|n|m|1|2|3|4|5|6|7|8|9|0|{BACKSPACE}|{DELETE}|{UP}|{DOWN}|{LEFT}|{RIGHT}|{HOME}|{END}|{INSERT}|{PGUP}|{PGDN}|{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|" & _
"{F8}|{F9}|{F10}|{F11}|{F12}|{TAB}|{PRINTSCREEN}|{PAUSE}|{NUMPAD0}|{NUMPAD1}|{NUMPAD2}|{NUMPAD3}|{NUMPAD4}|{NUMPAD5}|{NUMPAD6}|{NUMPAD7}|{NUMPAD8}|{NUMPAD9}|{NUMPADMULT}|{NUMPADADD}|{NUMPADSUB}|" & _
"{NUMPADDIV}|{NUMPADDOT}|{NUMPADENTER}|{MEDIA_NEXT}|{MEDIA_PREV}|{MEDIA_STOP}|{MEDIA_PLAY_PAUSE}|{LAUNCH_MAIL}|{LAUNCH_MEDIA}|{LAUNCH_APP1}|{LAUNCH_APP2}"

$ATTACHED = 0 ; 1 if attached to iw4mp.dat
$PROCESS = 0 ; handle to iw4mp.dat process
$YOU_ARE_THE_HOST = 1
$KICK_CID = 0
$SOUND_ENABLED = 1
Global $CLIENT_ID_NAME[18]
Global $CLIENT_ID_LABEL[18]
Global $KICK[18]
$METHOD = 0 ; Main menu state: 0 = closed, 1 = main menu, 2 = kick_menu, 3 = map menu, 4 = game_mode menu, 5 = ingame console
$M_MENU = 1
$M_KICK = 2
$M_MAP = 3
$M_GAMEMODE = 4
$M_CONSOLE = 5
$M_MAX = 6
$M_FOV = 7
$M_FPS = 8
$M_WIN = 9
$M_SCORE = 10
$M_TIME = 11
$M_BAN = 12
$check_player_name_id = 0
$lobby_map = 0
$server_full_warning = 0
Local $mult_key, $div_key, $next_key, $prev_key, $mw2_path, $connect_2_ip, $warning_update_counter, $share_server, $server_name

; attach to iw4mp.dat process
Func ATTACH()
	Dim $PROPID = ProcessExists($process_name)
	$PROCESS = _MEMORYOPEN($PROPID)
	If @error == 1 Then
		TrayTip(0, "", "Invalid Process ID.")
	ElseIf @error == 2 Then
		TrayTip(0, "", "Failed to open Kernel32.dll.")
	ElseIf @error == 3 Then
		TrayTip(0, "", "Failed to open the specified process.")
	Else
		$ATTACHED = 1
		if $connect_2_ip then
			TrayTip ( "Admin Tool", "Attached to "&$process_name&@CRLF&"Connecting to "&$connect_2_ip, 3 )
		else
			TrayTip ( "Admin Tool", "Attached to "&$process_name, 3 )
		endif
		
		setWindowNames()
		
		; ip has been set, lets connect
		if $connect_2_ip then
			while _MEMORYREAD($INGAME_MAP_NAME_ADDR, $PROCESS, "char[255]") <> "localized_ui_mp"
				sleep(100)
			wend
			setWindowNames() ; just to make sure ;)
			ConsoleCmd("connect "&$connect_2_ip)
			$server_full_warning = 0
			$connect_2_ip = 0
			If $SOUND_ENABLED <> 0 Then
				SoundPlay("sounds/connecting.wav")
			EndIf
		endif
	EndIf
EndFunc

; Update MW2 Server Browser
#include <mw2sb.au3>

; MENU
#include <menu.au3>

; KICK
#include <kick.au3>

; Game mode and Map
#include <map_gm.au3>

; FPS Field of View and Max Clients
#include <fps_fov_maxclients.au3>

; Time score and win limit
#include <timescorewinlimit.au3>

; Ingame Console
#include <ingame_console.au3>

; ======================================================================
; KEY EFFECTS
; ======================================================================
#include <keyeffects.au3>

; ======================================================================
; CUSTOM COMMAND GUI
; ======================================================================
#include <custom_cmd.au3>

; ======================================================================
; OPTIONS GUI
; ======================================================================
#include <options.au3>

; ======================================================================
; Helpers
; ======================================================================
Func RenderText($text)
		_MEMORYWRITE($CHAT_TYPE, $PROCESS, 0x0, "int") ; public chat
		_MEMORYWRITE($CHAT_OPEN, $PROCESS, 0x20, "int") ; open chat
		_MEMORYWRITE($CHAT_MEMORY, $PROCESS, $text, "char[255]") ; set chat text
		_MEMORYWRITE($CHAT_LENGHT, $PROCESS, 255, "int") ; set chat lenght
		_MEMORYWRITE($CHAT_CURSOR, $PROCESS, 1, "int") ; set chat lenght
EndFunc

Func ConsoleCmd($text)
	ControlSetText ( $console_window_title, "", 101, $text, 0 )
	ControlSend($console_window_title, "", 101, "{Enter}")
Endfunc

Func bindKeys()
	Local $keys, $IROWS, $ICOLUMNS, $IRVAL
	$IRVAL = _SQLITE_GETTABLE2D(-1, "SELECT * FROM keys;", $keys, $IROWS, $ICOLUMNS)
	
	If $IRVAL <> $SQLITE_OK Then 
		MsgBox(16, "SQLite Error: " & $IRVAL, _SQLITE_ERRMSG()) 
	EndIf
	
	For $I = 1 To 4 Step 1
		HotKeySet($keys[$I][1], $keys[$I][0])
	Next
	
	$mult_key = $keys[1][1]
	$div_key = $keys[2][1]
	$next_key = $keys[3][1]
	$prev_key = $keys[4][1]
	
	$SOUND_ENABLED = $keys[5][1]
	
	$auto_complete_enabled = $keys[6][1]
	
	$mw2_path = $keys[7][1]
	
	$share_server = $keys[8][1]
	
	$server_name = replaceRestrictedChars($keys[9][1])
endfunc

; ======================================================================
; Helper Text
; ======================================================================
#include <helpertext.au3>
; ======================================================================
; Splash Screen
; ======================================================================
$SPLASH_SCREEN = GUICreate("Loading...", 450, 268, -1, -1, BitOR($WS_POPUP, $WS_CLIPSIBLINGS))
$SPLASH_BG = GUICtrlCreatePic("data\splash.jpg", 0, 0, 450, 268, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$SPLASH_TEXT = GUICtrlCreateLabel($VERSION, 16, 243, 273, 17)
GUICtrlSetBkColor($SPLASH_TEXT, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor($SPLASH_TEXT, 0xffffff)
GUICtrlSetFont($SPLASH_TEXT, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)

; SQLite Start
if @AutoItX64 then
_SQLITE_STARTUP("data/SQLite3_x64.dll")
else
_SQLITE_STARTUP("data/SQLite3.dll")
endif

If @error > 0 Then
	MsgBox(16, "SQLite Error", "SQLite3.dll Can't be Loaded!")
	Exit -1
EndIf
_SQLITE_OPEN(@ScriptDir & "/data/sql.db")
If @error > 0 Then
	MsgBox(16, "SQLite Error", "Can't Load Database!")
	Exit -1
EndIf

bindKeys() ; bind +-*/
bindCustomKeys()

; splash music
If $SOUND_ENABLED == 2 Then
	SoundPlay("sounds/start_program.wav")
EndIf

sleep(2500)
GUIDelete($SPLASH_SCREEN)

; ======================================================================
; Main Loop
; ======================================================================
While 1
	Sleep(100)
	If $ATTACHED == 0 Then ; not yet attached
		If ProcessExists($process_name) Then
			ATTACH()
		EndIf
	Elseif ProcessExists($process_name) Then ; attached and process is still exist
		If $YOU_ARE_THE_HOST <> 1 And _MEMORYREAD($HOST_CHECKER, $PROCESS, "int") <> 0 Then
			$YOU_ARE_THE_HOST = 1
			If $SOUND_ENABLED == 2 Then
				SoundPlay("sounds/you_are_the_host.wav")
			ElseIf $SOUND_ENABLED == 1 Then
				SoundPlay("sounds/you_are_the_host_short.wav")
			EndIf
		ElseIf $YOU_ARE_THE_HOST <> 0 And _MEMORYREAD($HOST_CHECKER, $PROCESS, "int") == 0 Then
			$YOU_ARE_THE_HOST = 0
			$METHOD = 0
		EndIf
		
		if $METHOD and _MEMORYREAD($CHAT_OPEN, $PROCESS, "int") == 0x10 then
			$METHOD = 0
			If $SOUND_ENABLED <> 0 Then
				SoundPlay("sounds/process_cancelled.wav")
			EndIf
		endif
		
		; update names
		$check_player_name_id = $check_player_name_id + 1
		if $check_player_name_id == 18 then
			$check_player_name_id = 0
		endif
		If $CLIENT_ID_NAME[$check_player_name_id] <> _MEMORYREAD($FIRST_CLIENT_ID + $check_player_name_id * $CLIENT_ID_OFFSET, $PROCESS, "char[31]") Then
			$CLIENT_ID_NAME[$check_player_name_id] = _MEMORYREAD($FIRST_CLIENT_ID + $check_player_name_id * $CLIENT_ID_OFFSET, $PROCESS, "char[31]")
			; banned player?
			_SQLITE_EXEC(-1, "DELETE FROM bans WHERE end < "&_TimeGetStamp()&";")
			Local $aRow
			_SQLite_QuerySingleRow(-1,"SELECT end FROM bans WHERE XUID = '"&_MEMORYREAD($FIRST_XUID+($XUID_OFFSET*($check_player_name_id-1)), $PROCESS, "UINT64")&"' LIMIT 1;",$aRow) ; Select single row and single field !
			if $aRow[0] then
				ConsoleCmd("sv_kickBanTime 3600;tempbanclient " & $check_player_name_id &";say ^3"&$CLIENT_ID_NAME[$check_player_name_id]&" ^7is banned until ^3"&_StringFormatTime("%Y %b %d %H:%M", $aRow[0])& "^7, connection rejected.")
			endif
		EndIf
		
		; update server browser
		$sb_update_counter = $sb_update_counter + 100
		if $sb_update_counter > $sb_update_freq then
			$sb_update_counter = 0
			update_mw2sb()
		endif
		
		If $METHOD == $M_CONSOLE and $auto_complete_active == 1 and $auto_complete_enabled == 1 then
			AutoComplete()
		Endif
		
		; server is full warning
		$warning_update_counter = $warning_update_counter + 100
		If $SOUND_ENABLED <> 0 and $warning_update_counter > 500 Then
			$warning_update_counter = 0
			If $server_full_warning == 0 and _MEMORYREAD($SERVER_FULL_CHECKER, $PROCESS, "char[11]") == "Server is f" then
				$server_full_warning = 1
				SoundPlay("sounds/server_is_full.wav")
			endif
		EndIf
		
	Else ; was attached but process lost
		$ATTACHED = 0
		TrayTip ( "Admin Tool", "Attachment lost", 3 )
	EndIf
WEnd

; close the whole program
Func CLOSEBUTTON()
	_SQLITE_CLOSE()
	_SQLITE_SHUTDOWN()
	Exit
EndFunc