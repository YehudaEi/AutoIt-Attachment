#cs ----------------------------------------------------------------------------

  AutoIt Version: 3.3.0.1
         Authors: Jackalo
                  Jeffrey C. Jacobs (TimeHorse)
				  Matthias Georg
 Script Function: FarmVille Clicker
           $Date: 2009-10-20 10:51:53 -0400 (Tue, 20 Oct 2009) $
       $Revision: 566 $

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;*** Farmville Bot
;
; v2009-07-30 - Now has a GUI, a target button, and optional avoidance of spawning square.
; v2009-07-31 - Added a Mouse Speed variable, made the GUI look better
; v2009-08-23 - Reworked the entire script to use hotkeys and a variable harvest area
; v2009-08-24 - Finished the rewrite, cleaned and compacted the code, added Help button
; v2009-10-07 - Added some code do delete plots and handle the confirmation button
; v2009-10-07a - Better integrated the deletion loop with the plow / plant loops and assigned each their own hot keys
; v2009-10-09 - Added more mouse positions which can be set by the user
; v2009-10-13 - Removed some magic numbers and put them into variables, such as the plot offset sizes, so that they could be more flexible such as setting for different zoom distances; moved some common code into their own functions; added a training routine for setting mouse positions and removed hot keys bound to anything besides the 6 INSERT-DELETE keys and Escape
; v2009-10-13a - Fixed the arrow key handlers so that up/right is faster and down/left is slower
; v2009-10-13b - Cleaned up code; modified GUI; added choice of 3 different clicking direction modes
; v2009-10-13c - Fixed text of the Eastward click mode to match the true direction
; v2009-10-13d - Added some code to support cycling through various Plow-Plant cycles and modified GUI accordingly
; v2009-10-14 - Added support for pausing the script and repeating a sequence (SHIFT+INSERT); added support for Reaping (Harvesting a Crop)
; v2009-10-14a - Disable key handlers when paused; added simple set_status function; fixed some bug in the Eastward Clicker mode
; v2009-10-14b - Added a grass matching algorithm that will check if a pixel's red, green and blue values lie within 1 standard deviation of the average grass pixel colour and counts any such pixel as grass, all be it fuzzy-matched grass -- this is likely because of some Alpha-channel shadow from the confirmation dialog over the grass causing it to discolour
; v2009-10-15 - Check to see if even though we registered a plot as non-grass, it may actually have been a dialog so check again the next time we try to click.
; v2009-10-15a - Added support for arbitrary zoom levels (in this case 0.33) and some more proper variable declarations
; v2009-10-18 -
; 1) More variable scope declarations
; 2) Set the setting for my window, including the 0.33 zoom ratio
; 3) More variable scope declarations
; 4) Set the setting to the defaults for my window, including the 0.33 zoom
;    ratio
; 5) Added in a setting for an offset when messages appear above the game -- 51
;    pixels for connection problems
; 6) Added in a log file and logging function
; 7) Added a way to log what the clicker would calculate all the points it
;    would click without actually clicking them and instead logging them in the
;    log file using SHIFT+PGUP
; 8) Changed Escape to mean go to the next action in an action sequence, which
;    is Idle when not in repeat mode
; 9) Made SHIFT+ESCAPE now act as the clear mode and reset to Idle function
; 10) Set the click timeout to 2 Minutes though it still times out when a
;     random dialog appears
; 11) Reduced the dialog dismissal timeout to 3 seconds since it is likely to
;     succeed within that time
; 12) Added in a time gap between plowing and planting, reaping and plowing and
;     plowing and deleting commeserate with the time it takes for the player to
;     perform each preceeding action
; 13) The time gap is adjusted by a multiplier which allows for the character
;     walk between plots if not penned in his cage currently set to 3x normal
;     speed
; 14) Enumerate the 1,000 most common pixel colours used by FarmVille's
;     Confirmation dialog to aide in dialog dismissal detection
; 15) Added a hot key for logging the mouse's current position, pixel colour
;     and CRC to the log file with SHIFT+HOME
; 16) Reminder to change the code to block all new actions when not idle to
;     avoid issues with asynchronous with the command loop
; 17) Added in code to skip the time gap when ESCAPE is pressed
; 18) Added a bunch of error handlers for when the PixelChecksum method might
;     set an error, as is likely if the function returns 0x80000000 since the
;     odds of such a result happening in reality is astonomical
; 19) For the accept, seed and other dialogs, a bad CRC read is ignored with
;     a fixed timeout to compensate for the inability to read whether a dialog
;     has properly been displayed or dismissed
; 20) crc_at_mouse now passes on errors from get_crc
; 21) get_crc now passes on errors from PixelChecksum
; 22) get_crc now tries a fixed number of times to get a valid CRC
; 23) Added second seed CRC override as calculated by the log message when it
;     can't match the CRC with the one recorded for some reason
; 24) Added a function for detecting if a dialog is still present
; 25) Move to home position (Shovel) when deleting repeatedly and keep clicking
;     the shovel to make sure we are in the right mode in case of page reload
; 26) Pause between delete confirmation and the next click
; 27) Log all status messages
; v2009-10-18a - Made a failure to dismiss dialog a non-catastrophic error
;     which should instead just wait for the timeout and continue as normal;
;     fixed the name of is_plowing to is_not_plowing to match what it does
; v2009-10-18b - Fixed typo
; v2009-10-18c - Force a PixelChecksum of 0x80000000 to be treated as an error;
;                Created a corresponding error code
; v2009-10-19 - Turned on force variable declarations and formally declared all
;     variable with their scope; put more wait states into the delete timers to
;     better support pausing during deletion; assume user clicked seed if seed
;     could not be clicked during training

; Just some things to remember...
; When zoomed all the way out, the below are true...
; Moving across columns, x+25, y-12
; Moving down rows, x+25, y+12
; See $offset_x and $offset_y to change these

;*** Design Goals
; 1. Create a better looking interface



; Force variable declarations
AutoItSetOption("MustDeclareVars", 1)

; Includes
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <WindowsConstants.au3>

; Define a few (global) variables
;Const $screen_shift = 51 ; Use this for when it say there is Connection Problems
Const $screen_shift = 0

Global $script_x = 406
Global $script_y = 588 + $screen_shift
Global $script_speed = 15
Global $script_size_columns = 20
Global $script_size_rows = 19
Global $script_running = False
Global $log_filename = 'FVClicker.log'

; TODO: Should this be configurable and if so, update $offset_x, $offset_y -------> Done
Global $zoom = 1

Const $speed_increment = 1
Const $speed_jump = 5
Const $offset_at_one_x = 25
Const $offset_at_one_y = 12

Global $offset_x = $offset_at_one_x * $zoom
Global $offset_y = $offset_at_one_y * $zoom

; Various GUI controls
Global $window_main
Global $graphic_background
Global $label_running
Global $label_coordinate_home
Global $label_coordinate_multi_tool
Global $label_coordinate_seed
Global $label_coordinate_accept
Global $input_speed
Global $updown_speed
Global $button_speed_1
Global $button_speed_5
Global $button_speed_10
Global $button_speed_15
Global $button_speed_25
Global $button_speed_50
Global $input_size_columns
Global $updown_size_columns
Global $input_size_rows
Global $updown_size_rows
Global $combo_rotation
Global $input_repeat_count
Global $updown_repeat_count
Global $button_help
Global $combo_direction
Global $label_status
Global $window_help

;changed by M
Global $window_settings
Global $combo_asp
Global $combo_zoomlevel

Const $asp_43 = "4:3"
Const $asp_169 = "16:9"
Const $zoom_level1 = "Fully zoomed in"
Const $zoom_level2 = "Zoom stage 1"
Const $zoom_level3 = "Zoom stage 2"
Const $zoom_level4 = "Fully zoomed out"
Global $set_asp = $asp_43
Global $set_zoom = $zoom_level4



Const $idle = "Idle"
Const $plowing = "Plowing"
Const $planting = "Planting"
Const $deleting = "Deleting"
Const $reaping = "Reaping"
Const $clicking = "Clicking"
Const $logging_clicks = "Logging Clicks"
Const $training_multi_tool = "Learning Multi Tool"
Const $training_home = "Learning Home Position"
Const $training_seed = "Learning Seed"
Const $training_accept = "Learning Accept"
Const $pausing = "Paused"

Global $mode = $idle

Global $paused_mode = $idle

Const $ppw_rotation = "Plow, Plant, Wither"
Const $ppd_rotation = "Plow, Plant, Delete"
Const $rpp_rotation = "Reap, Plow, Plant"

Global $rotation = $ppd_rotation

Const $ppw_modes[2] = [ $plowing, $planting ]
Const $ppd_modes[3] = [ $plowing, $planting, $deleting ]
Const $rpp_modes[3] = [ $reaping, $plowing, $planting ]

Global $repeat = False
Global $repeat_count = 1
Global $current_repeat = $repeat_count
Global $repeat_step = 0
Global $repeat_sequence = to_repeat_sequence($rotation)
Global $skip_repeat_wait

Const $forward_rows = "North-East"
Const $zigzag_rows = "North-East then South-West"
Const $eastward_rows = "Eastward South then North"

; TODO: Note: North-East then South-West and Eastward cannot work if
;       there is a non-crop in path because context menu will pop up and
;       then be clicked rather than clicking the desired thing below it
Global $direction = $zigzag_rows

Const $big_button_width = 50
Const $big_button_height = 64 ; 62?

Global $arrow1_x = 955
Global $arrow1_y = 712 + $screen_shift
Global $arrow1_crc = 4025221020

Global $hoe1_x = 1005
Global $hoe1_y = 712 + $screen_shift
Global $hoe1_crc = 2463686371

Global $arrow_x = 955
Global $arrow_y = 776 + $screen_shift
Global $arrow_crc = 1458900428

Global $hoe_x = 1005
Global $hoe_y = 776 + $screen_shift
Global $hoe_crc = 3175953493

Global $shovel_x = 1055
Global $shovel_y = 776 + $screen_shift
Global $shovel_crc = 904470361

; TODO: Need to get CRC for "Market" button
Global $market_x = 1005
Global $market_y = 840 + $screen_shift

Const $click_timeout_ms = 120000 ; Might become configurable
Const $dismiss_timeout_ms = 3000 ; Might become configurable
Const $wait_sleep_ms = 500
Const $click_retries = 3 ; Might become configurable
Const $status_timeout_ms = 10000
Const $bad_crc_timeout_ms = 5000

Global $accept_x = 596
Global $accept_y = 660 + $screen_shift
Global $accept_crc = 473184913
Global $accept_crc_unsel = 2076860222

Global $seed_x = 493
Global $seed_y = 624 + $screen_shift
Global $seed_crc = 1882647171
Global $seed_crc_alt = 2034035334

Const $plow_time_ms = 1000
Const $plant_time_ms = 1000
Const $reap_time_ms = 1000
Global $fast_click_compensator = 3.00

Const $crc_retries = 100
Const $could_not_dismiss_dialog_error = -1001
Const $crcs_of_0x80000000_are_invalid = -1002

; Grass Pixels
Global Const $grass_pixels[27] = [ 0x00398633, 0x003A8734, 0x003A8835, 0x003C8A37, 0x003D8B37, 0x003D8B39, 0x003F8D3B, 0x00408E3C, 0x0041903E, 0x0043A143, 0x00469443, 0x00469645, 0x00499848, 0x004A9A4A, 0x004B9B4A, 0x004B9C4A, 0x004E9F45, 0x004F9F4B, 0x0052A44D, 0x0053A54D, 0x0056A84E, 0x0056A94E, 0x005BAF4F, 0x005CB050, 0x005DB150, 0x005EB250, 0x005EB350 ]
Global $dialog_pixels[1000]
$dialog_pixels[0] = 0xfdfefb
$dialog_pixels[1] = 0xfffde5
$dialog_pixels[2] = 0x70543a
$dialog_pixels[3] = 0xc3463a
$dialog_pixels[4] = 0x94bc41
$dialog_pixels[5] = 0xd9bc9e
$dialog_pixels[6] = 0xebcda2
$dialog_pixels[7] = 0x8e6f4a
$dialog_pixels[8] = 0xebcca2
$dialog_pixels[9] = 0x559890
$dialog_pixels[10] = 0xffffff
$dialog_pixels[11] = 0xd8bc9e
$dialog_pixels[12] = 0xd7bb9d
$dialog_pixels[13] = 0xfcd9a9
$dialog_pixels[14] = 0xefcfa4
$dialog_pixels[15] = 0xeccda2
$dialog_pixels[16] = 0xedcea3
$dialog_pixels[17] = 0xe8caa0
$dialog_pixels[18] = 0xd7ba9c
$dialog_pixels[19] = 0xd6ba9c
$dialog_pixels[20] = 0xeacca2
$dialog_pixels[21] = 0xf7d5a7
$dialog_pixels[22] = 0xdbbe9f
$dialog_pixels[23] = 0x1d180f
$dialog_pixels[24] = 0x91609
$dialog_pixels[25] = 0x183918
$dialog_pixels[26] = 0x286228
$dialog_pixels[27] = 0x388738
$dialog_pixels[28] = 0xdabd9e
$dialog_pixels[29] = 0xd7ba9d
$dialog_pixels[30] = 0xeccea2
$dialog_pixels[31] = 0xbca186
$dialog_pixels[32] = 0xeacca1
$dialog_pixels[33] = 0xd9bd9e
$dialog_pixels[34] = 0xd5b99c
$dialog_pixels[35] = 0x933032
$dialog_pixels[36] = 0x365a37
$dialog_pixels[37] = 0xc6b697
$dialog_pixels[38] = 0xdbbe9e
$dialog_pixels[39] = 0xe6c89f
$dialog_pixels[40] = 0xfad7a8
$dialog_pixels[41] = 0xf0d0a4
$dialog_pixels[42] = 0xdcbf9f
$dialog_pixels[43] = 0xfedaa9
$dialog_pixels[44] = 0xedcea2
$dialog_pixels[45] = 0xeacba1
$dialog_pixels[46] = 0xf1d1a5
$dialog_pixels[47] = 0xd5b89b
$dialog_pixels[48] = 0x10401
$dialog_pixels[49] = 0xdec0a0
$dialog_pixels[50] = 0xbea287
$dialog_pixels[51] = 0xe7c9a0
$dialog_pixels[52] = 0xf1d1a4
$dialog_pixels[53] = 0xf9d7a8
$dialog_pixels[54] = 0xf5d3a6
$dialog_pixels[55] = 0xf8d6a7
$dialog_pixels[56] = 0xdfc1a0
$dialog_pixels[57] = 0xe4c79e
$dialog_pixels[58] = 0xfdd9a9
$dialog_pixels[59] = 0xbea285
$dialog_pixels[60] = 0xd7bc98
$dialog_pixels[61] = 0xe2d9be
$dialog_pixels[62] = 0xd1b895
$dialog_pixels[63] = 0xc3a78b
$dialog_pixels[64] = 0xaa9270
$dialog_pixels[65] = 0xc0a489
$dialog_pixels[66] = 0xdcbe9f
$dialog_pixels[67] = 0xf3d2a5
$dialog_pixels[68] = 0xcfb694
$dialog_pixels[69] = 0xf5d4a6
$dialog_pixels[70] = 0xe9cba1
$dialog_pixels[71] = 0xf2d1a5
$dialog_pixels[72] = 0xe8c9a3
$dialog_pixels[73] = 0xf3d3a5
$dialog_pixels[74] = 0xfbd8a9
$dialog_pixels[75] = 0x65673c
$dialog_pixels[76] = 0xf0cfa4
$dialog_pixels[77] = 0xbda286
$dialog_pixels[78] = 0xfddaa9
$dialog_pixels[79] = 0xf6d5a7
$dialog_pixels[80] = 0xe3c59e
$dialog_pixels[81] = 0xbea388
$dialog_pixels[82] = 0xe9caa3
$dialog_pixels[83] = 0xc1a68a
$dialog_pixels[84] = 0xdec09f
$dialog_pixels[85] = 0xfbd9a9
$dialog_pixels[86] = 0xdcc09a
$dialog_pixels[87] = 0xddc0a0
$dialog_pixels[88] = 0xf4d3a6
$dialog_pixels[89] = 0xe7c8a2
$dialog_pixels[90] = 0xe2c49d
$dialog_pixels[91] = 0xbba085
$dialog_pixels[92] = 0x3c913c
$dialog_pixels[93] = 0xeecea3
$dialog_pixels[94] = 0x2d6c2d
$dialog_pixels[95] = 0xdabe9e
$dialog_pixels[96] = 0xe0c39c
$dialog_pixels[97] = 0xeecfa4
$dialog_pixels[98] = 0x1c431c
$dialog_pixels[99] = 0xd4ba96
$dialog_pixels[100] = 0xb1b0b
$dialog_pixels[101] = 0xe2c3a1
$dialog_pixels[102] = 0xeecfa3
$dialog_pixels[103] = 0xd3b996
$dialog_pixels[104] = 0xdec1a0
$dialog_pixels[105] = 0xebcba4
$dialog_pixels[106] = 0xefd0a4
$dialog_pixels[107] = 0xd2b895
$dialog_pixels[108] = 0xd9be99
$dialog_pixels[109] = 0xe4c5a2
$dialog_pixels[110] = 0xf3d2a6
$dialog_pixels[111] = 0xdbbf9a
$dialog_pixels[112] = 0xe0c2a0
$dialog_pixels[113] = 0xe2c59e
$dialog_pixels[114] = 0xe6c8a0
$dialog_pixels[115] = 0xf1d0a4
$dialog_pixels[116] = 0xf6d4a7
$dialog_pixels[117] = 0xeecea4
$dialog_pixels[118] = 0xebcca4
$dialog_pixels[119] = 0xbfa488
$dialog_pixels[120] = 0x43a143
$dialog_pixels[121] = 0xc2a78b
$dialog_pixels[122] = 0xf8d5a7
$dialog_pixels[123] = 0xc0a589
$dialog_pixels[124] = 0xddc09f
$dialog_pixels[125] = 0xc1a0c
$dialog_pixels[126] = 0xe6c8a2
$dialog_pixels[127] = 0xfad8a8
$dialog_pixels[128] = 0xf8d7a7
$dialog_pixels[129] = 0xddc19b
$dialog_pixels[130] = 0xd4b89a
$dialog_pixels[131] = 0xfad8a9
$dialog_pixels[132] = 0xd5ba96
$dialog_pixels[133] = 0xc8ab8f
$dialog_pixels[134] = 0xeacba3
$dialog_pixels[135] = 0xceb593
$dialog_pixels[136] = 0xd1b598
$dialog_pixels[137] = 0xe9caa0
$dialog_pixels[138] = 0xedcda4
$dialog_pixels[139] = 0xd0b795
$dialog_pixels[140] = 0xb5a286
$dialog_pixels[141] = 0xeccca4
$dialog_pixels[142] = 0xddbf9f
$dialog_pixels[143] = 0xe4c59e
$dialog_pixels[144] = 0xf4d3a5
$dialog_pixels[145] = 0xd5b89a
$dialog_pixels[146] = 0xe5c89e
$dialog_pixels[147] = 0xcdb493
$dialog_pixels[148] = 0xccb392
$dialog_pixels[149] = 0xd2b698
$dialog_pixels[150] = 0xe6c9a0
$dialog_pixels[151] = 0xeacba4
$dialog_pixels[152] = 0xd8bd98
$dialog_pixels[153] = 0xe1c3a1
$dialog_pixels[154] = 0xd6bb97
$dialog_pixels[155] = 0xdbc09a
$dialog_pixels[156] = 0xcab291
$dialog_pixels[157] = 0xe0c1a0
$dialog_pixels[158] = 0xc1a589
$dialog_pixels[159] = 0xc5aa8e
$dialog_pixels[160] = 0xd8bb9d
$dialog_pixels[161] = 0xe5c89f
$dialog_pixels[162] = 0xf1d0a5
$dialog_pixels[163] = 0xc3a88d
$dialog_pixels[164] = 0xbfa388
$dialog_pixels[165] = 0xf2d1a6
$dialog_pixels[166] = 0xeacaa3
$dialog_pixels[167] = 0xdec19b
$dialog_pixels[168] = 0xf5d3a7
$dialog_pixels[169] = 0xf5d4a7
$dialog_pixels[170] = 0xb2a084
$dialog_pixels[171] = 0xe6c8a1
$dialog_pixels[172] = 0xe2c4a0
$dialog_pixels[173] = 0xe2c39d
$dialog_pixels[174] = 0xd1b795
$dialog_pixels[175] = 0xf8d6a8
$dialog_pixels[176] = 0x927455
$dialog_pixels[177] = 0xccb093
$dialog_pixels[178] = 0xd4b694
$dialog_pixels[179] = 0xe5c7a2
$dialog_pixels[180] = 0xe4c5a1
$dialog_pixels[181] = 0x8f7254
$dialog_pixels[182] = 0xbca085
$dialog_pixels[183] = 0xb4a186
$dialog_pixels[184] = 0xd5b99a
$dialog_pixels[185] = 0xbda287
$dialog_pixels[186] = 0xe6c7a2
$dialog_pixels[187] = 0xd5bb97
$dialog_pixels[188] = 0xd8bc9d
$dialog_pixels[189] = 0xe1c49d
$dialog_pixels[190] = 0xba9e84
$dialog_pixels[191] = 0xf7d6a7
$dialog_pixels[192] = 0xbca086
$dialog_pixels[193] = 0xe1c29c
$dialog_pixels[194] = 0xc4a98d
$dialog_pixels[195] = 0xe1c39e
$dialog_pixels[196] = 0xe8caa1
$dialog_pixels[197] = 0xbea98b
$dialog_pixels[198] = 0xb89d82
$dialog_pixels[199] = 0xbea288
$dialog_pixels[200] = 0xd9bc9c
$dialog_pixels[201] = 0xb99e83
$dialog_pixels[202] = 0xcfb396
$dialog_pixels[203] = 0xcfb498
$dialog_pixels[204] = 0xdec19c
$dialog_pixels[205] = 0xdbbe9c
$dialog_pixels[206] = 0xceb195
$dialog_pixels[207] = 0xd3b79a
$dialog_pixels[208] = 0xdfc29c
$dialog_pixels[209] = 0xedcea4
$dialog_pixels[210] = 0xf2d2a5
$dialog_pixels[211] = 0x66663d
$dialog_pixels[212] = 0xd3b799
$dialog_pixels[213] = 0xe7c8a3
$dialog_pixels[214] = 0xdabe99
$dialog_pixels[215] = 0xb3a085
$dialog_pixels[216] = 0xe2c59d
$dialog_pixels[217] = 0xebcba3
$dialog_pixels[218] = 0xd3ba96
$dialog_pixels[219] = 0xeacaa4
$dialog_pixels[220] = 0xc5a479
$dialog_pixels[221] = 0xceb493
$dialog_pixels[222] = 0xe1c39d
$dialog_pixels[223] = 0xd5ba97
$dialog_pixels[224] = 0xe3c5a1
$dialog_pixels[225] = 0xeecea5
$dialog_pixels[226] = 0xc5a98d
$dialog_pixels[227] = 0xd5b795
$dialog_pixels[228] = 0xd5b99b
$dialog_pixels[229] = 0xe5c7a1
$dialog_pixels[230] = 0xc3ad8e
$dialog_pixels[231] = 0xdec29c
$dialog_pixels[232] = 0xe3c4a1
$dialog_pixels[233] = 0xc3a78c
$dialog_pixels[234] = 0xcbaf92
$dialog_pixels[235] = 0xe1c2a0
$dialog_pixels[236] = 0xb8a488
$dialog_pixels[237] = 0xe8caa2
$dialog_pixels[238] = 0xe2c39e
$dialog_pixels[239] = 0xf0d0a5
$dialog_pixels[240] = 0x92946d
$dialog_pixels[241] = 0xc5af8f
$dialog_pixels[242] = 0xf0cfa5
$dialog_pixels[243] = 0xe5c7a0
$dialog_pixels[244] = 0xe0c19b
$dialog_pixels[245] = 0xcbae8f
$dialog_pixels[246] = 0xb6a286
$dialog_pixels[247] = 0xc2a68b
$dialog_pixels[248] = 0xdcc09f
$dialog_pixels[249] = 0xebcca3
$dialog_pixels[250] = 0xba9f84
$dialog_pixels[251] = 0xc1a58a
$dialog_pixels[252] = 0xe8c9a0
$dialog_pixels[253] = 0xe7caa0
$dialog_pixels[254] = 0xd6b99c
$dialog_pixels[255] = 0xc9ad91
$dialog_pixels[256] = 0xdec19f
$dialog_pixels[257] = 0xceb194
$dialog_pixels[258] = 0xd8bc98
$dialog_pixels[259] = 0xd1b698
$dialog_pixels[260] = 0xb7a487
$dialog_pixels[261] = 0xe5c79f
$dialog_pixels[262] = 0xc0a488
$dialog_pixels[263] = 0xe0c29c
$dialog_pixels[264] = 0xd6ba9a
$dialog_pixels[265] = 0xc2ac8d
$dialog_pixels[266] = 0xd1b497
$dialog_pixels[267] = 0xaf9d82
$dialog_pixels[268] = 0xb6a386
$dialog_pixels[269] = 0xdbbd9e
$dialog_pixels[270] = 0xc8ab8d
$dialog_pixels[271] = 0xc1ab8d
$dialog_pixels[272] = 0xe9cba0
$dialog_pixels[273] = 0x907354
$dialog_pixels[274] = 0xc8b190
$dialog_pixels[275] = 0xf0d1a4
$dialog_pixels[276] = 0xad9b81
$dialog_pixels[277] = 0xcfb295
$dialog_pixels[278] = 0xd1b699
$dialog_pixels[279] = 0xe7c9a1
$dialog_pixels[280] = 0xae9c82
$dialog_pixels[281] = 0xe5c5a2
$dialog_pixels[282] = 0xefcea4
$dialog_pixels[283] = 0x917455
$dialog_pixels[284] = 0xdabd9d
$dialog_pixels[285] = 0xefcea5
$dialog_pixels[286] = 0xfad7a9
$dialog_pixels[287] = 0xccb196
$dialog_pixels[288] = 0xe0c29f
$dialog_pixels[289] = 0xdcbf9c
$dialog_pixels[290] = 0xc7af8f
$dialog_pixels[291] = 0xc9b191
$dialog_pixels[292] = 0xcbb291
$dialog_pixels[293] = 0xdabd9f
$dialog_pixels[294] = 0xe2c4a1
$dialog_pixels[295] = 0xe7caa1
$dialog_pixels[296] = 0xe9caa1
$dialog_pixels[297] = 0xceb091
$dialog_pixels[298] = 0xccb492
$dialog_pixels[299] = 0xd6b896
$dialog_pixels[300] = 0xf3d1a6
$dialog_pixels[301] = 0xd9bd9b
$dialog_pixels[302] = 0xd4b999
$dialog_pixels[303] = 0xc5a98e
$dialog_pixels[304] = 0xa9987f
$dialog_pixels[305] = 0xdec19e
$dialog_pixels[306] = 0xe2c49e
$dialog_pixels[307] = 0xd0b497
$dialog_pixels[308] = 0xcfb693
$dialog_pixels[309] = 0xd3b699
$dialog_pixels[310] = 0xe3c4a2
$dialog_pixels[311] = 0xa7967e
$dialog_pixels[312] = 0xb4a286
$dialog_pixels[313] = 0xcab095
$dialog_pixels[314] = 0xc0ab8c
$dialog_pixels[315] = 0xc9ac90
$dialog_pixels[316] = 0xc1ac8d
$dialog_pixels[317] = 0xc9ac8d
$dialog_pixels[318] = 0xe8caa3
$dialog_pixels[319] = 0xf7d4a7
$dialog_pixels[320] = 0xab9a80
$dialog_pixels[321] = 0xb09e83
$dialog_pixels[322] = 0xb6a287
$dialog_pixels[323] = 0xbba789
$dialog_pixels[324] = 0xd2b593
$dialog_pixels[325] = 0xccb296
$dialog_pixels[326] = 0xd3b696
$dialog_pixels[327] = 0xd7b996
$dialog_pixels[328] = 0xd9bb98
$dialog_pixels[329] = 0x8d7153
$dialog_pixels[330] = 0xe0c29e
$dialog_pixels[331] = 0xcdb296
$dialog_pixels[332] = 0xcaae91
$dialog_pixels[333] = 0xceb295
$dialog_pixels[334] = 0xe0c2a1
$dialog_pixels[335] = 0xab9980
$dialog_pixels[336] = 0xc8b090
$dialog_pixels[337] = 0x86b5a8
$dialog_pixels[338] = 0xf4d2a6
$dialog_pixels[339] = 0xd3b798
$dialog_pixels[340] = 0xc7aa8c
$dialog_pixels[341] = 0xb4a185
$dialog_pixels[342] = 0xcaad91
$dialog_pixels[343] = 0xceb397
$dialog_pixels[344] = 0xdfc09b
$dialog_pixels[345] = 0xe9c9a3
$dialog_pixels[346] = 0xefcfa5
$dialog_pixels[347] = 0xa5957c
$dialog_pixels[348] = 0xcbb195
$dialog_pixels[349] = 0xe1c39c
$dialog_pixels[350] = 0xd7ba9a
$dialog_pixels[351] = 0x20401
$dialog_pixels[352] = 0x316831
$dialog_pixels[353] = 0xc8ac8f
$dialog_pixels[354] = 0xceb192
$dialog_pixels[355] = 0xab3b36
$dialog_pixels[356] = 0x1e401e
$dialog_pixels[357] = 0x8c7052
$dialog_pixels[358] = 0x658b3c
$dialog_pixels[359] = 0xddbfa0
$dialog_pixels[360] = 0xd3b89a
$dialog_pixels[361] = 0xddc09c
$dialog_pixels[362] = 0x5c9c93
$dialog_pixels[363] = 0xbca789
$dialog_pixels[364] = 0xbfa98b
$dialog_pixels[365] = 0xc8ae93
$dialog_pixels[366] = 0xedcda3
$dialog_pixels[367] = 0xc7ad93
$dialog_pixels[368] = 0xb74038
$dialog_pixels[369] = 0x7ca33e
$dialog_pixels[370] = 0xbda88a
$dialog_pixels[371] = 0xcfb292
$dialog_pixels[372] = 0xd3b594
$dialog_pixels[373] = 0x9ac1b2
$dialog_pixels[374] = 0xcaad8f
$dialog_pixels[375] = 0xdabd9c
$dialog_pixels[376] = 0xd3b898
$dialog_pixels[377] = 0xd3b593
$dialog_pixels[378] = 0xe6c99f
$dialog_pixels[379] = 0xb29f84
$dialog_pixels[380] = 0xd1b394
$dialog_pixels[381] = 0xf9d6a8
$dialog_pixels[382] = 0xddbf9a
$dialog_pixels[383] = 0xf8d7a8
$dialog_pixels[384] = 0xd7ba9b
$dialog_pixels[385] = 0xdabc99
$dialog_pixels[386] = 0xc2ad8d
$dialog_pixels[387] = 0xc4ad91
$dialog_pixels[388] = 0xcdb091
$dialog_pixels[389] = 0xdcc19b
$dialog_pixels[390] = 0xe1c2a1
$dialog_pixels[391] = 0xedcfa3
$dialog_pixels[392] = 0xe4c5a0
$dialog_pixels[393] = 0xd5b999
$dialog_pixels[394] = 0xe4c7a0
$dialog_pixels[395] = 0xceb497
$dialog_pixels[396] = 0xa8977e
$dialog_pixels[397] = 0xac9a80
$dialog_pixels[398] = 0xbca78a
$dialog_pixels[399] = 0xd8ba98
$dialog_pixels[400] = 0xdfc39c
$dialog_pixels[401] = 0xe2c3a0
$dialog_pixels[402] = 0xf1d1a6
$dialog_pixels[403] = 0xd9bc9a
$dialog_pixels[404] = 0xd9bd98
$dialog_pixels[405] = 0xcaad8e
$dialog_pixels[406] = 0xd2b699
$dialog_pixels[407] = 0xc7ab8f
$dialog_pixels[408] = 0xd6bc97
$dialog_pixels[409] = 0xefcfa3
$dialog_pixels[410] = 0xd4b794
$dialog_pixels[411] = 0xb9a588
$dialog_pixels[412] = 0xc9af94
$dialog_pixels[413] = 0xccaf90
$dialog_pixels[414] = 0xdbbd9a
$dialog_pixels[415] = 0xdabf9a
$dialog_pixels[416] = 0xe2c49f
$dialog_pixels[417] = 0xddc09d
$dialog_pixels[418] = 0xc2806b
$dialog_pixels[419] = 0xdcbe9c
$dialog_pixels[420] = 0xdfc19e
$dialog_pixels[421] = 0xdec09e
$dialog_pixels[422] = 0xd9bc9d
$dialog_pixels[423] = 0xdfc29f
$dialog_pixels[424] = 0xe9caa2
$dialog_pixels[425] = 0xd5b897
$dialog_pixels[426] = 0x92946e
$dialog_pixels[427] = 0xbba084
$dialog_pixels[428] = 0xc0aa8c
$dialog_pixels[429] = 0xc8ac90
$dialog_pixels[430] = 0xdbbf9b
$dialog_pixels[431] = 0xdcc09b
$dialog_pixels[432] = 0xdec09d
$dialog_pixels[433] = 0xdcbf9e
$dialog_pixels[434] = 0x8e7153
$dialog_pixels[435] = 0x9a7c59
$dialog_pixels[436] = 0x9f8f79
$dialog_pixels[437] = 0xe0c29b
$dialog_pixels[438] = 0xddbf9c
$dialog_pixels[439] = 0xccaf93
$dialog_pixels[440] = 0xdcbf9d
$dialog_pixels[441] = 0xdfc19b
$dialog_pixels[442] = 0xe8c9a1
$dialog_pixels[443] = 0xd8ba97
$dialog_pixels[444] = 0xc07f6a
$dialog_pixels[445] = 0xa0825e
$dialog_pixels[446] = 0xd0b496
$dialog_pixels[447] = 0xdabe9a
$dialog_pixels[448] = 0xd9bc9b
$dialog_pixels[449] = 0xd7bb9a
$dialog_pixels[450] = 0xcfb496
$dialog_pixels[451] = 0xb5997b
$dialog_pixels[452] = 0xb7a387
$dialog_pixels[453] = 0xc4a379
$dialog_pixels[454] = 0xdbbe9d
$dialog_pixels[455] = 0xd4b797
$dialog_pixels[456] = 0xd6b895
$dialog_pixels[457] = 0xe8c8a3
$dialog_pixels[458] = 0xd2b897
$dialog_pixels[459] = 0xe1c3a0
$dialog_pixels[460] = 0xe3c5a0
$dialog_pixels[461] = 0x8e916c
$dialog_pixels[462] = 0xb19e84
$dialog_pixels[463] = 0xb8a588
$dialog_pixels[464] = 0xd0b694
$dialog_pixels[465] = 0xd7bb9b
$dialog_pixels[466] = 0xd8bc9c
$dialog_pixels[467] = 0xb89e83
$dialog_pixels[468] = 0xccae8f
$dialog_pixels[469] = 0xceb693
$dialog_pixels[470] = 0xcfb293
$dialog_pixels[471] = 0xd1b493
$dialog_pixels[472] = 0xa9987e
$dialog_pixels[473] = 0xaf9c82
$dialog_pixels[474] = 0xcdb194
$dialog_pixels[475] = 0xd3b896
$dialog_pixels[476] = 0xdebf9a
$dialog_pixels[477] = 0x1e401d
$dialog_pixels[478] = 0x9c8d77
$dialog_pixels[479] = 0xb89d83
$dialog_pixels[480] = 0xcab191
$dialog_pixels[481] = 0xd4b895
$dialog_pixels[482] = 0xd6ba99
$dialog_pixels[483] = 0xe0c39d
$dialog_pixels[484] = 0xd1b796
$dialog_pixels[485] = 0xceb297
$dialog_pixels[486] = 0x878b6a
$dialog_pixels[487] = 0x9e8e78
$dialog_pixels[488] = 0xcaaf95
$dialog_pixels[489] = 0xbca488
$dialog_pixels[490] = 0xcaae92
$dialog_pixels[491] = 0xdabc98
$dialog_pixels[492] = 0xc9ac8e
$dialog_pixels[493] = 0x316731
$dialog_pixels[494] = 0x2f682f
$dialog_pixels[495] = 0x8c7053
$dialog_pixels[496] = 0xbda78c
$dialog_pixels[497] = 0xceb396
$dialog_pixels[498] = 0xc8856d
$dialog_pixels[499] = 0xe3c59f
$dialog_pixels[500] = 0x418a41
$dialog_pixels[501] = 0xbaa689
$dialog_pixels[502] = 0xc3ad8d
$dialog_pixels[503] = 0xc5ae91
$dialog_pixels[504] = 0xd7b997
$dialog_pixels[505] = 0xe8c9a2
$dialog_pixels[506] = 0xcdb396
$dialog_pixels[507] = 0x8e7254
$dialog_pixels[508] = 0xeccda4
$dialog_pixels[509] = 0x93956e
$dialog_pixels[510] = 0xb99e84
$dialog_pixels[511] = 0xc1ab8c
$dialog_pixels[512] = 0xc4ae8e
$dialog_pixels[513] = 0xd6bc98
$dialog_pixels[514] = 0xe9cba2
$dialog_pixels[515] = 0xedcca4
$dialog_pixels[516] = 0xd8bc9b
$dialog_pixels[517] = 0xd0b598
$dialog_pixels[518] = 0xdfc19d
$dialog_pixels[519] = 0xccaf8f
$dialog_pixels[520] = 0xe0c19c
$dialog_pixels[521] = 0xc7846d
$dialog_pixels[522] = 0x9a8b75
$dialog_pixels[523] = 0xb6a387
$dialog_pixels[524] = 0xe5c79e
$dialog_pixels[525] = 0xd4b898
$dialog_pixels[526] = 0xdabe9f
$dialog_pixels[527] = 0xe7c8a1
$dialog_pixels[528] = 0xe7c8a0
$dialog_pixels[529] = 0xf7f8e1
$dialog_pixels[530] = 0xe9cba3
$dialog_pixels[531] = 0xce685e
$dialog_pixels[532] = 0xcfb597
$dialog_pixels[533] = 0x94956e
$dialog_pixels[534] = 0xd0b695
$dialog_pixels[535] = 0xd3b694
$dialog_pixels[536] = 0xf6d5a6
$dialog_pixels[537] = 0xdbbe9a
$dialog_pixels[538] = 0xcfb598
$dialog_pixels[539] = 0xd0b498
$dialog_pixels[540] = 0xd8bc99
$dialog_pixels[541] = 0x66653d
$dialog_pixels[542] = 0xc3816b
$dialog_pixels[543] = 0xc6a479
$dialog_pixels[544] = 0xd4b998
$dialog_pixels[545] = 0xd2b799
$dialog_pixels[546] = 0xe0c19d
$dialog_pixels[547] = 0xcfb497
$dialog_pixels[548] = 0xd3b899
$dialog_pixels[549] = 0xccaf91
$dialog_pixels[550] = 0xc5ad93
$dialog_pixels[551] = 0x8c6f52
$dialog_pixels[552] = 0xf5d3a5
$dialog_pixels[553] = 0xd1b697
$dialog_pixels[554] = 0xe9caa4
$dialog_pixels[555] = 0xd5a586
$dialog_pixels[556] = 0xc5ac92
$dialog_pixels[557] = 0xccb295
$dialog_pixels[558] = 0xcbb295
$dialog_pixels[559] = 0xdcbe9a
$dialog_pixels[560] = 0xdcc0a0
$dialog_pixels[561] = 0xe3c49e
$dialog_pixels[562] = 0xa6c8b8
$dialog_pixels[563] = 0xd8bb9a
$dialog_pixels[564] = 0xf6d4a6
$dialog_pixels[565] = 0xe1c29b
$dialog_pixels[566] = 0xd7ba99
$dialog_pixels[567] = 0xdfc19f
$dialog_pixels[568] = 0xe4c59f
$dialog_pixels[569] = 0xd3b596
$dialog_pixels[570] = 0xd8bb9c
$dialog_pixels[571] = 0xaa987f
$dialog_pixels[572] = 0xcbaf8f
$dialog_pixels[573] = 0xd8bb9b
$dialog_pixels[574] = 0xe1c29d
$dialog_pixels[575] = 0xe3c5a2
$dialog_pixels[576] = 0xcfb296
$dialog_pixels[577] = 0xe3c49d
$dialog_pixels[578] = 0xbd9e76
$dialog_pixels[579] = 0xcaac8e
$dialog_pixels[580] = 0xcaad90
$dialog_pixels[581] = 0xccb194
$dialog_pixels[582] = 0xd8bb9e
$dialog_pixels[583] = 0xddbe9a
$dialog_pixels[584] = 0xc5a98b
$dialog_pixels[585] = 0xdbbe9b
$dialog_pixels[586] = 0x10301
$dialog_pixels[587] = 0xc8ac8e
$dialog_pixels[588] = 0xdcc09d
$dialog_pixels[589] = 0xdcbe9e
$dialog_pixels[590] = 0xc1806b
$dialog_pixels[591] = 0xb19e83
$dialog_pixels[592] = 0xb9a387
$dialog_pixels[593] = 0xddc09e
$dialog_pixels[594] = 0xc4a98b
$dialog_pixels[595] = 0xd3b895
$dialog_pixels[596] = 0xd8b997
$dialog_pixels[597] = 0x90bbad
$dialog_pixels[598] = 0xa8c9b9
$dialog_pixels[599] = 0xc5a889
$dialog_pixels[600] = 0xb3d0bf
$dialog_pixels[601] = 0xfcd8a9
$dialog_pixels[602] = 0xe3c4a0
$dialog_pixels[603] = 0xebf1db
$dialog_pixels[604] = 0xd4b899
$dialog_pixels[605] = 0xeccca2
$dialog_pixels[606] = 0x9d805c
$dialog_pixels[607] = 0xccb195
$dialog_pixels[608] = 0xc5ae8f
$dialog_pixels[609] = 0xb19f84
$dialog_pixels[610] = 0x72a99e
$dialog_pixels[611] = 0xd2b595
$dialog_pixels[612] = 0x7aaea2
$dialog_pixels[613] = 0xcab094
$dialog_pixels[614] = 0x89b7aa
$dialog_pixels[615] = 0xdcbfa0
$dialog_pixels[616] = 0xaacaba
$dialog_pixels[617] = 0xd5ba9a
$dialog_pixels[618] = 0xb9d3c2
$dialog_pixels[619] = 0xd5e4d0
$dialog_pixels[620] = 0xc5aa8c
$dialog_pixels[621] = 0xdcbf9b
$dialog_pixels[622] = 0xf5f7e0
$dialog_pixels[623] = 0xd5b998
$dialog_pixels[624] = 0xd8bb98
$dialog_pixels[625] = 0xdec09a
$dialog_pixels[626] = 0xd5b899
$dialog_pixels[627] = 0xdfc29d
$dialog_pixels[628] = 0xdbbf9e
$dialog_pixels[629] = 0xc5a98c
$dialog_pixels[630] = 0xbda88b
$dialog_pixels[631] = 0x7cafa3
$dialog_pixels[632] = 0xe5c5a1
$dialog_pixels[633] = 0xe6c7a1
$dialog_pixels[634] = 0xeccda3
$dialog_pixels[635] = 0xf1cfa5
$dialog_pixels[636] = 0xb4d0bf
$dialog_pixels[637] = 0xc8af93
$dialog_pixels[638] = 0xd4e3cf
$dialog_pixels[639] = 0xe3ecd7
$dialog_pixels[640] = 0xd3b999
$dialog_pixels[641] = 0xe7c9a2
$dialog_pixels[642] = 0xd4ba97
$dialog_pixels[643] = 0xc8ae94
$dialog_pixels[644] = 0xb39574
$dialog_pixels[645] = 0xd2b694
$dialog_pixels[646] = 0x5a9b92
$dialog_pixels[647] = 0x5e9d94
$dialog_pixels[648] = 0x42a042
$dialog_pixels[649] = 0xbda588
$dialog_pixels[650] = 0x6ea69c
$dialog_pixels[651] = 0x76aba0
$dialog_pixels[652] = 0xc7ab8c
$dialog_pixels[653] = 0xc8ab8c
$dialog_pixels[654] = 0x7eb0a4
$dialog_pixels[655] = 0xd1b495
$dialog_pixels[656] = 0xcfb596
$dialog_pixels[657] = 0x8eb9ac
$dialog_pixels[658] = 0xd7bd98
$dialog_pixels[659] = 0xd9be98
$dialog_pixels[660] = 0xe8c8a2
$dialog_pixels[661] = 0xf1cfa4
$dialog_pixels[662] = 0xd4b99a
$dialog_pixels[663] = 0xd5ba9b
$dialog_pixels[664] = 0xe5edd8
$dialog_pixels[665] = 0xfdfce4
$dialog_pixels[666] = 0xd5b898
$dialog_pixels[667] = 0x67673d
$dialog_pixels[668] = 0xdfc19c
$dialog_pixels[669] = 0xdbbd9f
$dialog_pixels[670] = 0xa09079
$dialog_pixels[671] = 0xbda387
$dialog_pixels[672] = 0xc0a385
$dialog_pixels[673] = 0xbca689
$dialog_pixels[674] = 0xc3ab91
$dialog_pixels[675] = 0xc8b08f
$dialog_pixels[676] = 0xd0b393
$dialog_pixels[677] = 0xd6b795
$dialog_pixels[678] = 0xeff3dd
$dialog_pixels[679] = 0xe6c7a0
$dialog_pixels[680] = 0xcbb196
$dialog_pixels[681] = 0x8b6f52
$dialog_pixels[682] = 0xceb596
$dialog_pixels[683] = 0xd6b997
$dialog_pixels[684] = 0x9a8b76
$dialog_pixels[685] = 0xd2b494
$dialog_pixels[686] = 0x629f96
$dialog_pixels[687] = 0xc1a178
$dialog_pixels[688] = 0x66a298
$dialog_pixels[689] = 0xbca286
$dialog_pixels[690] = 0xbaa488
$dialog_pixels[691] = 0xc2a586
$dialog_pixels[692] = 0xc5ad92
$dialog_pixels[693] = 0xccb090
$dialog_pixels[694] = 0xc9b190
$dialog_pixels[695] = 0x8ab7aa
$dialog_pixels[696] = 0xdcbd9a
$dialog_pixels[697] = 0xe4c89e
$dialog_pixels[698] = 0xd6bb9a
$dialog_pixels[699] = 0xdabd9b
$dialog_pixels[700] = 0xdcbe9b
$dialog_pixels[701] = 0xddc09b
$dialog_pixels[702] = 0xdec09b
$dialog_pixels[703] = 0xd5ba98
$dialog_pixels[704] = 0xdec19d
$dialog_pixels[705] = 0x8d7053
$dialog_pixels[706] = 0x9f815d
$dialog_pixels[707] = 0xd1b596
$dialog_pixels[708] = 0x9d8d77
$dialog_pixels[709] = 0xbea88b
$dialog_pixels[710] = 0xcbb391
$dialog_pixels[711] = 0xc8af92
$dialog_pixels[712] = 0xdabe9d
$dialog_pixels[713] = 0x97bfb1
$dialog_pixels[714] = 0xeccca3
$dialog_pixels[715] = 0xd0b698
$dialog_pixels[716] = 0xbfd7c5
$dialog_pixels[717] = 0xc3d9c7
$dialog_pixels[718] = 0xe7eed9
$dialog_pixels[719] = 0xe8cba0
$dialog_pixels[720] = 0xeacaa2
$dialog_pixels[721] = 0xe5c8a0
$dialog_pixels[722] = 0x306630
$dialog_pixels[723] = 0x65663c
$dialog_pixels[724] = 0xbf7e6a
$dialog_pixels[725] = 0xd1b494
$dialog_pixels[726] = 0xc9af95
$dialog_pixels[727] = 0xbba186
$dialog_pixels[728] = 0xc2a278
$dialog_pixels[729] = 0x69a49a
$dialog_pixels[730] = 0x81b2a6
$dialog_pixels[731] = 0xd0b394
$dialog_pixels[732] = 0xd2b492
$dialog_pixels[733] = 0x20421e
$dialog_pixels[734] = 0xd9ba98
$dialog_pixels[735] = 0xd6bb98
$dialog_pixels[736] = 0xdfc09a
$dialog_pixels[737] = 0xb1cebe
$dialog_pixels[738] = 0xf2d2a6
$dialog_pixels[739] = 0xf5d5a6
$dialog_pixels[740] = 0xc9ddca
$dialog_pixels[741] = 0xedf2dc
$dialog_pixels[742] = 0xf1f5de
$dialog_pixels[743] = 0xe0c39f
$dialog_pixels[744] = 0xd5ba99
$dialog_pixels[745] = 0xbb9e7f
$dialog_pixels[746] = 0xc5aa8d
$dialog_pixels[747] = 0xddbf9e
$dialog_pixels[748] = 0xd6ba96
$dialog_pixels[749] = 0x5b9b93
$dialog_pixels[750] = 0x64a197
$dialog_pixels[751] = 0xb8a387
$dialog_pixels[752] = 0xb8a487
$dialog_pixels[753] = 0xbea689
$dialog_pixels[754] = 0xc2a98b
$dialog_pixels[755] = 0xc0aa8b
$dialog_pixels[756] = 0xd6ba9d
$dialog_pixels[757] = 0xd9bd9d
$dialog_pixels[758] = 0xccb493
$dialog_pixels[759] = 0xd2b493
$dialog_pixels[760] = 0xd6ba97
$dialog_pixels[761] = 0x94bdaf
$dialog_pixels[762] = 0xe7c9a3
$dialog_pixels[763] = 0xe4c7a1
$dialog_pixels[764] = 0xd3b997
$dialog_pixels[765] = 0xafcdbd
$dialog_pixels[766] = 0xf3d1a5
$dialog_pixels[767] = 0xd7e5d1
$dialog_pixels[768] = 0xf3f6df
$dialog_pixels[769] = 0xd2b697
$dialog_pixels[770] = 0xd0b392
$dialog_pixels[771] = 0x20402
$dialog_pixels[772] = 0xd1b0c
$dialog_pixels[773] = 0xe5c5a0
$dialog_pixels[774] = 0xeacba2
$dialog_pixels[775] = 0x1f411e
$dialog_pixels[776] = 0xd5b996
$dialog_pixels[777] = 0x2f652e
$dialog_pixels[778] = 0x316630
$dialog_pixels[779] = 0xd7ba97
$dialog_pixels[780] = 0xc8af94
$dialog_pixels[781] = 0xd3b697
$dialog_pixels[782] = 0x408a40
$dialog_pixels[783] = 0x408b40
$dialog_pixels[784] = 0x428b42
$dialog_pixels[785] = 0x458f42
$dialog_pixels[786] = 0x62a096
$dialog_pixels[787] = 0xb3a084
$dialog_pixels[788] = 0xbca588
$dialog_pixels[789] = 0xc1a586
$dialog_pixels[790] = 0x6ea79c
$dialog_pixels[791] = 0xc2a78a
$dialog_pixels[792] = 0xcab192
$dialog_pixels[793] = 0xcdb495
$dialog_pixels[794] = 0x82b2a6
$dialog_pixels[795] = 0xd6b996
$dialog_pixels[796] = 0xb6d1c0
$dialog_pixels[797] = 0xdabd9a
$dialog_pixels[798] = 0xc1d8c6
$dialog_pixels[799] = 0xcddfcc
$dialog_pixels[800] = 0xc3a88c
$dialog_pixels[801] = 0xf2f5de
$dialog_pixels[802] = 0xc6b68b
$dialog_pixels[803] = 0xddbf9b
$dialog_pixels[804] = 0xfefce4
$dialog_pixels[805] = 0xd7bb98
$dialog_pixels[806] = 0xb190b
$dialog_pixels[807] = 0xa2845e
$dialog_pixels[808] = 0xd9bd9c
$dialog_pixels[809] = 0x1d3f1d
$dialog_pixels[810] = 0x1d401d
$dialog_pixels[811] = 0x1d411d
$dialog_pixels[812] = 0x1e411d
$dialog_pixels[813] = 0x1f411d
$dialog_pixels[814] = 0xc4ae8f
$dialog_pixels[815] = 0x2f662f
$dialog_pixels[816] = 0xdec09c
$dialog_pixels[817] = 0x326831
$dialog_pixels[818] = 0xe3c49f
$dialog_pixels[819] = 0xbea88d
$dialog_pixels[820] = 0xc7aa8d
$dialog_pixels[821] = 0x418b3f
$dialog_pixels[822] = 0x3f8c3f
$dialog_pixels[823] = 0x898c6b
$dialog_pixels[824] = 0xba8c77
$dialog_pixels[825] = 0x438d41
$dialog_pixels[826] = 0x458f41
$dialog_pixels[827] = 0xa2927b
$dialog_pixels[828] = 0xa6957d
$dialog_pixels[829] = 0xa7967d
$dialog_pixels[830] = 0xac9b81
$dialog_pixels[831] = 0xb2a085
$dialog_pixels[832] = 0x68a399
$dialog_pixels[833] = 0xbda689
$dialog_pixels[834] = 0xc4a88b
$dialog_pixels[835] = 0x73aa9f
$dialog_pixels[836] = 0xc9ab8d
$dialog_pixels[837] = 0x458e42
$dialog_pixels[838] = 0xd7ba98
$dialog_pixels[839] = 0xe8b8b3
$dialog_pixels[840] = 0xdabb99
$dialog_pixels[841] = 0x9bc1b3
$dialog_pixels[842] = 0xeacaa1
$dialog_pixels[843] = 0xf9d7a7
$dialog_pixels[844] = 0x428b40
$dialog_pixels[845] = 0xc5ae90
$dialog_pixels[846] = 0xf0f4dd
$dialog_pixels[847] = 0xe6c9a1
$dialog_pixels[848] = 0xcdb090
$dialog_pixels[849] = 0xcbae91
$dialog_pixels[850] = 0xd9bd99
$dialog_pixels[851] = 0xc3a98e
$dialog_pixels[852] = 0xcbb293
$dialog_pixels[853] = 0xd5b797
$dialog_pixels[854] = 0xbc7c6a
$dialog_pixels[855] = 0xa1835e
$dialog_pixels[856] = 0xccb094
$dialog_pixels[857] = 0xa0917a
$dialog_pixels[858] = 0xa1917a
$dialog_pixels[859] = 0xaa9980
$dialog_pixels[860] = 0x599a92
$dialog_pixels[861] = 0xad9c82
$dialog_pixels[862] = 0xb9a084
$dialog_pixels[863] = 0xb0a384
$dialog_pixels[864] = 0xb6a486
$dialog_pixels[865] = 0xbaa588
$dialog_pixels[866] = 0xbea78a
$dialog_pixels[867] = 0xbfaa8c
$dialog_pixels[868] = 0xc9ad90
$dialog_pixels[869] = 0x7db0a4
$dialog_pixels[870] = 0xd2b596
$dialog_pixels[871] = 0xd5b694
$dialog_pixels[872] = 0xd5b794
$dialog_pixels[873] = 0xd4b996
$dialog_pixels[874] = 0x92bcae
$dialog_pixels[875] = 0x95beb0
$dialog_pixels[876] = 0xbda388
$dialog_pixels[877] = 0xf9f9e2
$dialog_pixels[878] = 0xd6b998
$dialog_pixels[879] = 0xe1c39f
$dialog_pixels[880] = 0xc1ab8e
$dialog_pixels[881] = 0xc8ab8e
$dialog_pixels[882] = 0xd9bb99
$dialog_pixels[883] = 0xe0c29d
$dialog_pixels[884] = 0xd6ba9b
$dialog_pixels[885] = 0xdebf9e
$dialog_pixels[886] = 0x67663d
$dialog_pixels[887] = 0xdcc09c
$dialog_pixels[888] = 0xbca68c
$dialog_pixels[889] = 0xc17f6b
$dialog_pixels[890] = 0xceb296
$dialog_pixels[891] = 0xc7ab8d
$dialog_pixels[892] = 0xcaae90
$dialog_pixels[893] = 0x91936d
$dialog_pixels[894] = 0xa3937b
$dialog_pixels[895] = 0x5f9e95
$dialog_pixels[896] = 0x609f95
$dialog_pixels[897] = 0xbaa387
$dialog_pixels[898] = 0x6ba59b
$dialog_pixels[899] = 0xbaa589
$dialog_pixels[900] = 0xdfc29e
$dialog_pixels[901] = 0x70a89d
$dialog_pixels[902] = 0xbfaa8b
$dialog_pixels[903] = 0xc7ac8d
$dialog_pixels[904] = 0xc4ab92
$dialog_pixels[905] = 0x7baea3
$dialog_pixels[906] = 0xddbf9d
$dialog_pixels[907] = 0x98c0b1
$dialog_pixels[908] = 0x9fc4b5
$dialog_pixels[909] = 0xe6c79f
$dialog_pixels[910] = 0xd6b897
$dialog_pixels[911] = 0xacccbb
$dialog_pixels[912] = 0xd1b392
$dialog_pixels[913] = 0xb7d2c1
$dialog_pixels[914] = 0xc8dcc9
$dialog_pixels[915] = 0xf4f6df
$dialog_pixels[916] = 0xcbaf91
$dialog_pixels[917] = 0xdabd99
$dialog_pixels[918] = 0xd3b897
$dialog_pixels[919] = 0x8e7154
$dialog_pixels[920] = 0x9e805c
$dialog_pixels[921] = 0xc5836c
$dialog_pixels[922] = 0x9b8b76
$dialog_pixels[923] = 0xa88b6a
$dialog_pixels[924] = 0xab8d6c
$dialog_pixels[925] = 0xcdb494
$dialog_pixels[926] = 0xa4947c
$dialog_pixels[927] = 0xa5947c
$dialog_pixels[928] = 0x94966e
$dialog_pixels[929] = 0x409a40
$dialog_pixels[930] = 0xb89f84
$dialog_pixels[931] = 0xbba286
$dialog_pixels[932] = 0xbda386
$dialog_pixels[933] = 0xcbad8f
$dialog_pixels[934] = 0xb7a488
$dialog_pixels[935] = 0x6aa59a
$dialog_pixels[936] = 0xc0a588
$dialog_pixels[937] = 0x6da69c
$dialog_pixels[938] = 0xbda78a
$dialog_pixels[939] = 0xcab195
$dialog_pixels[940] = 0xc2aa8c
$dialog_pixels[941] = 0xc7aa8e
$dialog_pixels[942] = 0xc2ac8e
$dialog_pixels[943] = 0x79ada2
$dialog_pixels[944] = 0xcdb092
$dialog_pixels[945] = 0x91bbae
$dialog_pixels[946] = 0xdabc9c
$dialog_pixels[947] = 0x9dc3b4
$dialog_pixels[948] = 0xe1c49e
$dialog_pixels[949] = 0xadccbc
$dialog_pixels[950] = 0xeecda4
$dialog_pixels[951] = 0xdabc9a
$dialog_pixels[952] = 0xd9bd9a
$dialog_pixels[953] = 0xd2b69a
$dialog_pixels[954] = 0xc5dac8
$dialog_pixels[955] = 0xd6b99b
$dialog_pixels[956] = 0xe1ebd6
$dialog_pixels[957] = 0xe9efda
$dialog_pixels[958] = 0xdbbd9b
$dialog_pixels[959] = 0xeef3dc
$dialog_pixels[960] = 0xfafae2
$dialog_pixels[961] = 0xd3b698
$dialog_pixels[962] = 0xc8b091
$dialog_pixels[963] = 0xc9ad8e
$dialog_pixels[964] = 0xd1b799
$dialog_pixels[965] = 0x9e8f79
$dialog_pixels[966] = 0xa6967d
$dialog_pixels[967] = 0xa9977f
$dialog_pixels[968] = 0x589a91
$dialog_pixels[969] = 0xbc9f7f
$dialog_pixels[970] = 0x63a097
$dialog_pixels[971] = 0xbea387
$dialog_pixels[972] = 0xbea589
$dialog_pixels[973] = 0xbfa589
$dialog_pixels[974] = 0xc0ab8d
$dialog_pixels[975] = 0xc4ab91
$dialog_pixels[976] = 0xd7b998
$dialog_pixels[977] = 0xc7b08f
$dialog_pixels[978] = 0x7fb1a5
$dialog_pixels[979] = 0x80b1a5
$dialog_pixels[980] = 0xd4ba98
$dialog_pixels[981] = 0x80b2a5
$dialog_pixels[982] = 0x88b6a9
$dialog_pixels[983] = 0x98bfb1
$dialog_pixels[984] = 0x9cc2b3
$dialog_pixels[985] = 0xe3c59d
$dialog_pixels[986] = 0xa3c6b7
$dialog_pixels[987] = 0xbbd4c3
$dialog_pixels[988] = 0xc8ad93
$dialog_pixels[989] = 0xbbd5c3
$dialog_pixels[990] = 0xebcca1
$dialog_pixels[991] = 0xd0e1cd
$dialog_pixels[992] = 0xd3e2cf
$dialog_pixels[993] = 0xd8e6d1
$dialog_pixels[994] = 0xdfc0a0
$dialog_pixels[995] = 0xdfead5
$dialog_pixels[996] = 0xd1b597
$dialog_pixels[997] = 0xd1b393
$dialog_pixels[998] = 0xeaf2d9
$dialog_pixels[999] = 0xe5c8a1

;b=723, 447
;l=700, 434
;r=823, 400

;bstat=723.7,447

;rx-bx = 100 ; ry-by = -47 -- (100, -48)
;lx-bx = -23 ; ly-by = -13 -- (-25, -12)
;t=800,387

; Hotkeys
HotKeySet("{HOME}", "train")

HotKeySet("{INSERT}", "plow")
HotKeySet("{END}", "plant")
HotKeySet("{PGDN}", "reap")
HotKeySet("{DELETE}", "shovel")
HotKeySet("{PGUP}", "click_current_tool")
HotKeySet("+{INSERT}", "start_repeat")

HotKeySet("{ESCAPE}", "escape")
HotKeySet("+{DELETE}", "accept")
HotKeySet("{PAUSE}", "toggle_pause")

HotKeySet("{UP}", "faster")
HotKeySet("{DOWN}", "slower")
HotKeySet("{LEFT}", "much_slower")
HotKeySet("{RIGHT}", "much_faster")

HotKeySet("+{HOME}", "register_position")
HotKeySet("+{PGUP}", "log_clicks_only")

HotKeySet("+{ESCAPE}", "clear_mode")

;changed by M
HotKeySet("+{PAUSE}", "zoom_settings")


; Hotkey Functions
; TODO: Disable command hot keys when already executing a command -- only allow command execution on Idle


;changed by M just to get the settings dialog -- maybe changed to button
Func zoom_settings()
 GUISetState(@SW_SHOW, $window_settings)
EndFunc


Func train()
    If is_paused() Then
        hotkey_passthrough("{HOME}", "train")
    ElseIf $mode == $idle Then
        prompt_multi_tool()
    ElseIf $mode == $training_multi_tool Then
        set_multi_tool_at_mouse()
        prompt_home()
    ElseIf $mode == $training_home Then
        set_home_at_mouse()
        prompt_seed()
    ElseIf $mode == $training_seed Then
        set_seed_at_mouse()
        prompt_accept()
    ElseIf $mode == $training_accept Then
        set_accept_at_mouse()
        prompt_training_done()
    EndIf
EndFunc

Func escape()
    If is_training() Then
        next_training_step()
    Else
        $skip_repeat_wait = True
        $script_running = False
    EndIf
EndFunc

Func clear_mode()
    GUICtrlSetColor($graphic_background, "0xF0F0F0")
;~  GUICtrlSetBkColor($button_help, "0xF0F0F0")
    $repeat = False
    $skip_repeat_wait = False
    $mode = $idle
    $script_running = False
    $paused_mode = $idle
    GUICtrlSetData($label_running, $mode)
EndFunc

Func click_current_tool()
    If is_paused() Then
        hotkey_passthrough("{PGUP}", "click_current_tool")
    Else
        set_mode($clicking)
        start_clicker()
    EndIf
EndFunc

Func plow()
    If is_paused() Then
        hotkey_passthrough("{INSERT}", "plow")
    Else
        set_mode($plowing)
        MouseClick("primary", $hoe_x, $hoe_y, 1, $script_speed)
        ; TODO: Click to confirm Hoe use or Tractor?
        start_clicker()
    EndIf
EndFunc

Func plant()
    If is_paused() Then
        hotkey_passthrough("{END}", "plant")
    Else
        set_mode($planting)
        MouseClick("primary", $market_x, $market_y, 1, $script_speed)
        If select_seed() Then
            start_clicker()
        Else
            ; Could not select a Seed to plant, abort
            clear_mode()
            set_status("ERROR: Unable to select a seed for planting; please select one manually and then use the generic clicker method.")
        EndIf
    EndIf
EndFunc

Func shovel()
    If is_paused() Then
        hotkey_passthrough("{DELETE}", "shovel")
    Else
        set_mode($deleting)
        MouseClick("primary", $shovel_x, $shovel_y, 1, $script_speed)
        start_clicker()
    EndIf
EndFunc

Func reap()
    If is_paused() Then
        hotkey_passthrough("{PGDN}", "reap")
    Else
        set_mode($reaping)
        MouseClick("primary", $arrow_x, $arrow_y, 1, $script_speed)
        ; TODO: Select Harvester or Seeder instead of Multi Tool?
        start_clicker()
    EndIf
EndFunc

Func accept()
    If is_paused() Then
        hotkey_passthrough("+{DELETE}", "accept")
    Else
        Local $jPos = MouseGetPos()
        MouseClick("primary", $accept_x, $accept_y, 1, 0)
        MouseMove($jPos[0], $jPos[1], 0)
    EndIf
EndFunc

Func faster()
    If is_paused() Then
        hotkey_passthrough("{UP}", "faster")
    Else
        set_speed($script_speed - $speed_increment)
    EndIf
EndFunc

Func slower()
    If is_paused() Then
        hotkey_passthrough("{DOWN}", "slower")
    Else
        set_speed($script_speed + $speed_increment)
    EndIf
EndFunc

Func much_faster()
    If is_paused() Then
        hotkey_passthrough("{RIGHT}", "much_faster")
    Else
        set_speed($script_speed - $speed_jump)
    EndIf
EndFunc

Func much_slower()
    If is_paused() Then
        hotkey_passthrough("{LEFT}", "much_slower")
    Else
        set_speed($script_speed + $speed_jump)
    EndIf
EndFunc

Func start_repeat()
    If is_paused() Then
        hotkey_passthrough("+{INSERT}", "start_repeat")
    Else
        set_status("Starting Repeat Sequence")

        $rotation = GUICtrlRead($combo_rotation)
        $repeat_count = GUICtrlRead($input_repeat_count)

        $current_repeat = $repeat_count
        $repeat_step = 0
        $repeat_sequence = to_repeat_sequence($rotation)
        $repeat = True

        initiate_mode($repeat_sequence[$repeat_step])
    EndIf
EndFunc

Func toggle_pause()
    If $mode == $pausing Then
        GUICtrlSetColor($graphic_background, "0x33FF33")
    ;~  GUICtrlSetBkColor($button_help, "0x33FF33")
        $mode = $paused_mode
        Local $paused_running = GUICtrlRead($label_running)
        Local $running_str_pos = StringLen($pausing) + 3 ; Convert to 1 base (+1) and skip " (" (+2)
        $paused_running = StringMid($paused_running, $running_str_pos, StringLen($paused_running) - $running_str_pos) ; Final ")" included in 1-base (+1) above
        GUICtrlSetData($label_running, $paused_running)
        $paused_mode = $idle
    Else
        ; Can't pause Idle!
        ; TODO: Disable interrupts when Paused or Repeating! (though ESC can interrupt Both, and Pause interrupt Repeat)
        GUICtrlSetColor($graphic_background, "0x33FF33")
    ;~  GUICtrlSetBkColor($button_help, "0x33FF33")
        $paused_mode = $mode
        Local $paused_running = GUICtrlRead($label_running)
        $mode = $pausing
        GUICtrlSetData($label_running, $pausing & " (" & $paused_running & ")")
    EndIf
EndFunc

Func register_position()
    If is_paused() Then
        hotkey_passthrough("+{HOME}", "register_position")
    Else
        Local $jPos = MouseGetPos()
        ; Move mouse away from capture point to get its default state
        MouseMove(0, 0, 0)
        Sleep($wait_sleep_ms)

        log_point($jPos[0], $jPos[1], "Registered")
        MouseMove($jPos[0], $jPos[1])
    EndIf
EndFunc

Func log_clicks_only()
    If is_paused() Then
        hotkey_passthrough("+{PGUP}", "log_clicks_only")
    Else
        set_mode($logging_clicks)
        log_msg("Using Offsets: (" & $offset_x & ", " & $offset_y & ")")
        start_clicker()
    EndIf
EndFunc

; Helper Functions
Func hotkey_passthrough($keyname, $registered_function)
    HotKeySet($keyname)
    Send($keyname)
    HotKeySet($keyname, $registered_function)
EndFunc

Func is_paused()
    Return $mode == $pausing
EndFunc

Func set_home_at_mouse()
    set_home_pos(MouseGetPos(0), MouseGetPos(1))
EndFunc

Func set_multi_tool_at_mouse()
    set_multi_tool_pos(MouseGetPos(0), MouseGetPos(1))
EndFunc

Func set_accept_at_mouse()
    set_accept_pos(MouseGetPos(0), MouseGetPos(1))
EndFunc

Func set_seed_at_mouse()
    set_seed_pos(MouseGetPos(0), MouseGetPos(1))
EndFunc

Func prompt_multi_tool()
    set_mode($training_multi_tool)

    set_status("Hover mouse over Multi Tool and click HOME -- ESC to skip")
    GUICtrlSetData($label_running, $mode)
EndFunc

Func prompt_home()
    set_mode($training_home)
    MouseClick("primary", $hoe_x, $hoe_y, 1, $script_speed)

    set_status("Hover mouse over the left-most point of your planing area and click HOME -- ESC to skip")
    GUICtrlSetData($label_running, $mode)
EndFunc

Func prompt_seed()
    set_mode($training_seed)

    ; Plow land for seeding (assumes plow)
    MouseClick("primary", $script_x, $script_y, 1, $script_speed)

    MouseClick("primary", $market_x, $market_y, 1, $script_speed)

    set_status("Hover mouse over the Buy button for the seed you wish to plant and click HOME -- ESC to skip")
    GUICtrlSetData($label_running, $mode)
EndFunc

Func prompt_accept()
    set_mode($training_accept)
    Local $warning = ""

    ; Plant Seed (assumes market screen)
    If Not select_seed() Then
        $warning = "Unable to select seed, assuming user clicked it"
        set_status($warning)
        $warning = $warning & "; "
    EndIf

    ; Plant Seed in plot from before
    MouseClick("primary", $script_x, Round($script_y - $offset_y), 1, $script_speed)

    MouseClick("primary", $shovel_x, $shovel_y, 1, $script_speed)
    MouseClick("primary", $script_x, Round($script_y - $offset_y), 1, $script_speed)

    set_status($warning & "Hover mouse over the Accept button and click HOME -- ESC to skip")
    GUICtrlSetData($label_running, $mode)
EndFunc

Func prompt_training_done()
    clear_mode()
    Local $msg = "Training complete, click Cancel to avoid deleting your plot or Accept to proceed"
    set_status($msg)
    Sleep($status_timeout_ms)
    ; Clear status after timeout
    If GUICtrlRead($label_status) == $msg Then clear_status()
EndFunc

Func next_training_step()
    If $mode == $idle Then
        prompt_multi_tool()
    ElseIf $mode == $training_multi_tool Then
        prompt_home()
    ElseIf $mode == $training_home Then
        prompt_seed()
    ElseIf $mode == $training_seed Then
        prompt_accept()
    ElseIf $mode == $training_accept Then
        prompt_training_done()
    EndIf
EndFunc

Func set_home_pos($the_x, $the_y)
    $script_x = $the_x
    $script_y = $the_y

    GUICtrlSetData($label_coordinate_home, home_string())
    set_status("Set new Home Position!")
EndFunc

Func set_multi_tool_pos($the_x, $the_y)
    $arrow_x = $the_x
    $arrow_y = $the_y
    $hoe_x = $the_x + $big_button_width
    $hoe_y = $the_y
    $shovel_x = $the_x + $big_button_width * 2
    $shovel_y = $the_y
    $arrow1_x = $the_x
    $arrow1_y = $the_y - $big_button_height
    $hoe1_x = $the_x + $big_button_width
    $hoe1_y = $the_y - $big_button_height
    $market_x = $the_x + $big_button_width
    $market_y = $the_y + $big_button_height
    ; TODO: Should we also recalculate CRCs here?
    GUICtrlSetData($label_coordinate_multi_tool, multi_tool_string())
    set_status("Set new Multi Tool button offset!")
EndFunc

Func set_accept_pos($the_x, $the_y)
    $accept_x = $the_x
    $accept_y = $the_y
    ; Need to recalculate CRC!
    MouseMove($accept_x + 30, $accept_y, 0)
    $accept_crc = get_crc($accept_x, $accept_y)
    If @error Then
        ; Since we could not retrieve the CRC, wait and assume success
        Local $err_str = " (" & @error & ", " & @extended & ")"
        set_status("WARNING: CRC of Accept Button at (" & $accept_x & ", " & $accept_y & ") could not be retrieved" & $err_str & ".  Assuming Default (0x80000000).")
        Sleep($bad_crc_timeout_ms)
    EndIf
    MouseMove($shovel_x, $shovel_y, 0)
    Sleep($wait_sleep_ms)
    $accept_crc_unsel = get_crc($accept_x, $accept_y)
    If @error Then
        ; Since we could not retrieve the CRC, wait and assume success
        $err_str = " (" & @error & ", " & @extended & ")"
        set_status("WARNING: CRC of Accept Button at (" & $accept_x & ", " & $accept_y & ") [Deselected] could not be retrieved" & $err_str & ".  Assuming Default (0x80000000).")
        Sleep($bad_crc_timeout_ms)
    EndIf
    MouseMove($accept_x, $accept_y, 0)
    GUICtrlSetData($label_coordinate_accept, accept_string())
    set_status("Set new Accept button offset!")
EndFunc

Func set_seed_pos($the_x, $the_y)
    ; TODO: Allow an algorithm to click the next arrow if crop on subsequent page
    $seed_x = $the_x
    $seed_y = $the_y
    ; Need to recalculate CRC!
    MouseMove($market_x, $market_y, 0)
    Sleep($wait_sleep_ms)
    $seed_crc = get_crc($seed_x, $seed_y)
    If @error Then
        ; Since we could not retrieve the CRC, wait and assume success
        Local $err_str = " (" & @error & ", " & @extended & ")"
        set_status("WARNING: CRC of Seed Button at (" & $accept_x & ", " & $accept_y & ") could not be retrieved" & $err_str & ".  Assuming Default (0x80000000).")
        Sleep($bad_crc_timeout_ms)
    EndIf
    ;MouseMove(0, 0, 10)
    ;$seed_crc_unsel = get_crc($seed_x, $seed_y)
    MouseMove($seed_x, $seed_y, 0)
    GUICtrlSetData($label_coordinate_seed, seed_string())
    set_status("Set new Seed button offset!")
EndFunc

Func set_mode($new_mode)
    GUICtrlSetColor($graphic_background, "0x33FF33")
;~  GUICtrlSetBkColor($button_help, "0x33FF33")
    $mode = $new_mode
    GUICtrlSetData($label_running, "Started " & $mode)
EndFunc

Func initiate_mode($new_mode)
    wait_for_pause()
    If $new_mode == $plowing Then
        plow()
    ElseIf $new_mode == $planting Then
        plant()
    ElseIf $new_mode == $reaping Then
        reap()
    ElseIf $new_mode == $deleting Then
        shovel()
    ElseIf $new_mode == $clicking Then
        click_current_tool()
    ElseIf $new_mode == $logging_clicks Then
        log_clicks_only()
    ElseIf $new_mode == $training_multi_tool Then
        prompt_multi_tool()
    ElseIf $new_mode == $training_home Then
        prompt_home()
    ElseIf $new_mode == $training_seed Then
        prompt_seed()
    ElseIf $new_mode == $training_accept Then
        prompt_accept()
    ElseIf $new_mode == $pausing Then
        wait_for_pause()
    ElseIf $new_mode == $idle Then
        clear_mode()
    Else
        set_status("ERROR: Invalid mode setting!")
        clear_mode()
    EndIf
EndFunc

Func is_training()
    Return $mode == $training_multi_tool Or $mode == $training_home Or $mode == $training_seed Or $mode == $training_accept
EndFunc

Func to_coordinate_string($the_x, $the_y)
    Return "(" & $the_x & ", " & $the_y & ")"
EndFunc

Func home_string()
    Return to_coordinate_string($script_x, $script_y)
EndFunc

Func multi_tool_string()
    Return to_coordinate_string($arrow_x, $arrow_y)
EndFunc

Func seed_string()
    Return to_coordinate_string($seed_x, $seed_y)
EndFunc

Func accept_string()
    Return to_coordinate_string($accept_x, $accept_y)
EndFunc

Func start_clicker()
    $script_running = True
    GUICtrlSetData($label_running, $mode)
EndFunc

Func crc_at_mouse()
    Local $crc = get_crc(MouseGetPos(0), MouseGetPos(1))
    If @error Then
        SetError(@error, @extended)
    EndIf

    Return $crc
EndFunc

Func get_crc($the_x, $the_y)
    Local $pSum = 0x80000000
    Local $err_no = 0

    For $i = 1 to $crc_retries
        $pSum = PixelChecksum($the_x-10,$the_y-25,$the_x+10, $the_y+25)
        If @error Or $pSum == 0x80000000 Then
            ; I don't know why it returns 0x80000000 some times, but
            ; clearly it's invalid in this case, but it IS a valid
            ; return, so there is NO way to tell and thus we have to
            ; assume that if we get 0x80000000 as a return, it must have
            ; failed!
            If @error Then
                $err_no = @error
            Else
                $err_no = $crcs_of_0x80000000_are_invalid
            EndIf
            Local $ext_no = @extended
            set_status("ERROR: PixelChecksum failed with error " & $err_no & " and extended " & $ext_no)
        Else
            log_msg("CRC read at point (" & $the_x & ", " & $the_y & "): 0x" & Hex($pSum))
            $err_no = 0
            ExitLoop
        EndIf
    Next
    If $err_no Then SetError($err_no, $ext_no)

    Return $pSum
EndFunc

Func ave_colour_at_mouse()
    Return get_ave_colour(MouseGetPos(0), MouseGetPos(1))
EndFunc

Func get_ave_colour($the_x, $the_y)
    Local $colour = 0
    Local $count = 0
    For $x = $the_x - 10 To $the_x + 10
        For $y = $the_y - 25 To $the_y + 25
            $colour = $colour + PixelGetColor($x, $y)
            $count = $count + 1
        Next
    Next
    Return $colour / $count
EndFunc

Func click_button($button_x, $button_y, $crc_expect, $crc_expect2 = False, $home_x = 0, $home_y = 0)
    ; Move Mouse out of Way of Checksum
    Local $jPos = MouseGetPos()
    MouseMove($home_x, $home_y, 0)

    Local $crc = get_crc($button_x, $button_y)
    If @error Then
        ; Since we could not retrieve the CRC, wait and assume success
        Local $err_str = " (" & @error & ", " & @extended & ")"
        set_status("WARNING: CRC of (" & $button_x & ", " & $button_y & ") could not be retrieved" & $err_str & ".  Assuming Success.")
        Sleep($bad_crc_timeout_ms)
        wait_for_pause()
        $crc = $crc_expect
    EndIf

    ; Restore MouseClick
    MouseMove($jPos[0], $jPos[1], 0)

    If $crc = $crc_expect Or ($crc_expect2 And $crc = $crc_expect2) Then
        MouseClick("primary", $button_x, $button_y, 1, $script_speed)
        Return True
    Else
        Return False
    EndIf
EndFunc

Func confirm_click($button_x, $button_y, $crc_expect, $crc_expect2 = False, $home_x = 0, $home_y = 0)
    ; Move Mouse out of Way of Checksum
    Local $jPos = MouseGetPos()
    MouseMove($home_x, $home_y, 0)

    Local $crc = get_crc($button_x, $button_y)
    If @error Then
        ; Since we could not retrieve the CRC, wait and assume success
        Local $err_str = " (" & @error & ", " & @extended & ")"
        set_status("WARNING: CRC of (" & $button_x & ", " & $button_y & ") could not be retrieved" & $err_str & ".  Assuming Success.")
        Sleep($bad_crc_timeout_ms)
        wait_for_pause()
        $crc = $crc_expect
    EndIf

    ; Restore MouseClick
    MouseMove($jPos[0], $jPos[1], 0)

    Return $crc <> $crc_expect And (Not $crc_expect2 Or $crc <> $crc_expect2)
EndFunc

Func wait_for_dialog($click_x, $click_y, $click_crc, $click_crc2 = False, $home_x = 0, $home_y = 0, $timeout_ms = $click_timeout_ms)
    ;For PixelChecksum, move the mouse away
    Local $timer = TimerInit()
    Local $accepted = click_button($click_x, $click_y, $click_crc, $click_crc2, $home_x, $home_y)
    While Not $accepted And TimerDiff($timer) < $timeout_ms And $mode <> $idle
        Sleep($wait_sleep_ms)
        $timeout_ms = $timeout_ms + wait_for_pause()
        $accepted = click_button($click_x, $click_y, $click_crc, $click_crc2, $home_x, $home_y)
    WEnd

    Return $accepted Or $mode == $idle
EndFunc

Func wait_for_dialog_exit($click_x, $click_y, $click_crc, $click_crc2 = False, $home_x = 0, $home_y = 0, $timeout_ms = $dismiss_timeout_ms)
    ;For PixelChecksum, move the mouse away
    Local $timer = TimerInit()
    Local $dismissed = confirm_click($click_x, $click_y, $click_crc, $click_crc2, $home_x, $home_y)
    While Not $dismissed And TimerDiff($timer) < $timeout_ms And $mode <> $idle
        Sleep($wait_sleep_ms)
        $timeout_ms = $timeout_ms + wait_for_pause()
        $dismissed = confirm_click($click_x, $click_y, $click_crc, $click_crc2, $home_x, $home_y)
    WEnd

    Return $dismissed Or Not $mode == $idle
EndFunc

Func handle_dialog($click_x, $click_y, $click_crc, $click_crc2 = False, $home_x = 0, $home_y = 0)
    If wait_for_dialog($click_x, $click_y, $click_crc, $click_crc2, $home_x, $home_y) Then
        If wait_for_dialog_exit($click_x, $click_y, $click_crc, $click_crc2, $home_x, $home_y) Then
            Return True
        Else
            SetError($could_not_dismiss_dialog_error)
            Return False
        EndIf
    Else
        Return False
    EndIf
EndFunc

Func wait_for_pause()
    ; Returns the number of timer ticks paused (milliseconds)
    Local $timer = TimerInit()
    While $mode == $pausing
        Sleep($wait_sleep_ms)
    WEnd
    Return TimerDiff($timer)
EndFunc

Func click_accept()
    Local $result = handle_dialog($accept_x, $accept_y, $accept_crc, $accept_crc_unsel, $shovel_x, $shovel_y)
    If @error == $could_not_dismiss_dialog_error Then
        ; Could not see the dialog being dismissed, wait anoter cycle then continue as if successful
        Sleep($dismiss_timeout_ms)
        wait_for_pause()
        $result = True
    EndIf
    Return $result
EndFunc

Func select_seed()
    Local $result = handle_dialog($seed_x, $seed_y, $seed_crc, $seed_crc_alt, $market_x, $market_y)
    If @error == $could_not_dismiss_dialog_error Then
        ; Could not see the dialog being dismissed, wait anoter cycle then continue as if successful
        Sleep($dismiss_timeout_ms)
        wait_for_pause()
        $result = True
    EndIf
    Return $result
EndFunc

Func is_grass($the_x, $the_y)
    ; Move Mouse out of Way of Checksum
    set_status("Testing Grass")

    ;$jPos = MouseGetPos()
    ;MouseMove($shovel_x, $shovel_y, 0)

    Local $px = PixelGetColor($the_x, $the_y)

    ; Restore MouseClick
    ;MouseMove($jPos[0], $jPos[1], 0)
    Local $grass_match = False

    For $i = 0 To UBound($grass_pixels) - 1
        If $px == $grass_pixels[$i] Then
            $grass_match = True
            set_status("Exact GRASS Pixel at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
            ExitLoop
        EndIf
    Next

    If Not $grass_match Then
        ; Fuzzy Match with Statistics
        Local Const $ave_red = 74
        Local Const $ave_green = 154
        Local Const $ave_blue = 72

        Local Const $std_red = 6
        Local Const $std_green = 7
        Local Const $std_blue = 6

        Local Const $red = BitAND(BitShift($px, 16), 0xFF)
        Local Const $green = BitAND(BitShift($px, 8), 0xFF)
        Local Const $blue = BitAND($px, 0xFF)

        If $red > $ave_red + $std_red Then
            set_status("Too Red Non-Grass Pixel at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
        ElseIf $red < $ave_red - $std_red Then
            set_status("Not Red Enough Non-Grass Pixel at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
        ElseIf $green > $ave_green + $std_green Then
            set_status("Too Green Non-Grass Pixel at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
        ElseIf $green < $ave_green - $std_green Then
            set_status("Not Green Enough Non-Grass Pixel at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
        ElseIf $blue > $ave_blue + $std_blue Then
            set_status("Too Blue Non-Grass Pixel at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
        ElseIf $blue < $ave_blue - $std_blue Then
            set_status("Not Blue Enough Non-Grass Pixel at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
        Else
            $grass_match = True
            set_status("Fuzzy Grass Pixel at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
        EndIf
    EndIf

    Return $grass_match
EndFunc

Func is_dialog($the_x, $the_y)
    set_status("Testing Dialog")
    Local $dialog_match = False
    Local $timeout_ms = $dismiss_timeout_ms

    Local $px = PixelGetColor($the_x, $the_y)

    For $i = 0 To UBound($dialog_pixels) - 1
        If $px == $dialog_pixels[$i] Then
            ; Wait for dialog to go
            Local $timer = TimerInit()
            set_status("Common Dialog Pixel Detected at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
            While $px == $dialog_pixels[$i] And TimerDiff($timer) < $timeout_ms And $mode <> $idle
                Sleep($wait_sleep_ms)
                $timeout_ms = $timeout_ms + wait_for_pause()
            WEnd

            $dialog_match = $px == $dialog_pixels[$i]
            If $dialog_match Then set_status("Dialog Pixel Still There at " & to_coordinate_string($the_x, $the_y) & ": 0x00" & Hex($px))
            ExitLoop
        EndIf
    Next

    Return $dialog_match
EndFunc

Func set_speed($new_speed)
    ; Clipping
    If $new_speed < 0 Then $new_speed = 0
    If $new_speed > 100 Then $new_speed = 100

    $script_speed = $new_speed
    GUICtrlSetData($input_speed, $script_speed)
EndFunc

Func do_delete_farm_at($the_x, $the_y)
    If is_grass($the_x, $the_y) Then
        ; Do not delete Grass
        ;$pixel = PixelGetColor($the_x, $the_y)
        ;set_status("Grass Pixel at " & to_coordinate_string($the_x, $the_y) & ": 0x" & Hex($pixel))
    Else
        ;clear_status()

        ; Always move back home to help with dialog detection
        MouseMove($shovel_x, $shovel_y, 0)
        is_dialog($the_x, $the_y)

        For $attempt = 1 to $click_retries
            MouseClick("primary", $the_x, $the_y, 1, $script_speed)

            ; Always move back home to help with grass detection
            MouseClick("primary", $shovel_x, $shovel_y, 1, 0)

            If is_grass($the_x, $the_y) Or click_accept() Then ExitLoop
		Next

        ; A small delay after deletion to make sure everything moves smoothly
        Sleep($wait_sleep_ms)
		wait_for_pause()
    EndIf
EndFunc

Func do_click_farm_at($the_x, $the_y)
    ;$colour = PixelGetColor($the_x, $the_y)
    ;If $colour <> 0xFFFFFF And $colour <> 0x000000 Then
        MouseClick("primary", $the_x, $the_y, 1, $script_speed)
    ;EndIf
EndFunc

Func do_log_click_at($the_x, $the_y)
    log_point($the_x, $the_y, "Logged")
EndFunc

Func get_clicker_function()
    If $mode == $deleting Then
        Return "do_delete_farm_at"
    ElseIf $mode == $logging_clicks Then
        Return "do_log_click_at"
    Else
        Return "do_click_farm_at"
    EndIf
EndFunc

Func to_repeat_sequence($new_rotation)
    If $new_rotation == $ppw_rotation Then
        Return $ppw_modes
    ElseIf $new_rotation == $ppd_rotation Then
        Return $ppd_modes
    ElseIf $new_rotation == $rpp_rotation Then
        Return $rpp_modes
    Else
        clear_mode()
        set_status("ERROR: Unrecognized Rotation Sequence!")
    EndIf
EndFunc

Func get_action_timeout()
    Local $time_per_click = 0

    If $mode == $plowing Then
        $time_per_click = $plow_time_ms
    ElseIf $mode == $planting Then
        $time_per_click = $plant_time_ms
    ElseIf $mode == $reaping Or $mode == $clicking Then
        ; Clicking assumes Reaping
        $time_per_click = $reap_time_ms
    EndIf

    Return Int($time_per_click * $fast_click_compensator)
EndFunc

Func next_mode_delayed()
    If $repeat Then
        GUICtrlSetData($label_running, "Ended " & $mode)

        $skip_repeat_wait = False

        ; Allow clicks to finish
        Local $timeout_ms = get_action_timeout() * $script_size_columns * $script_size_rows
        Local $timer = TimerInit()
        While Not $skip_repeat_wait And TimerDiff($timer) < $timeout_ms And $mode <> $idle
            Sleep($wait_sleep_ms)
			; Pause counts toward the next action gap timeout
			wait_for_pause()
        WEnd
    EndIf
    next_mode()
EndFunc

Func next_mode()
    If $repeat Then
        $repeat_step += 1

        If $repeat_step >= UBound($repeat_sequence) Then
            $repeat_step = 0

            If $repeat_count <> 0 Then
                $current_repeat -= 1
                If $current_repeat > 0 Then
                    set_status("Repeat: " & $current_repeat & " cycles remaining")
                Else
                    ; Repeat complete
                    clear_mode()
                    set_status("Repeat sequence completed")
                    Return False
                EndIf
            Else
                set_status("Repeat: Infinite Repeat Continuing")
            EndIf
        EndIf

        initiate_mode($repeat_sequence[$repeat_step])
        Return True
    Else
        clear_mode()
        Return True
    EndIf
EndFunc

Func is_not_plowing()
    wait_for_pause()
    ; Treat the click-logger as if it was plowing
    Return $mode <> $plowing And $mode <> $logging_clicks
EndFunc

Func set_status($msg)
    GUICtrlSetData($label_status, $msg)
    log_msg($msg)
EndFunc

Func clear_status()
    GUICtrlSetData($label_status, "")
EndFunc

Func log_point($the_x, $the_y, $point_type = "Generic")
    Local $crc = get_crc($the_x, $the_y)
    If @error Then
        ; Could not retrieve CRC
        $crc = "[Unavailable] (" & @error & ", " & @extended & ")"
    Else
        $crc = "0x" & Hex($crc)
    EndIf

    log_msg($point_type & " Point: (" & $the_x & ", " & $the_y & ")    Colour: 0x00" & Hex(PixelGetColor($the_x, $the_y)) & "    CRC: " & $crc)
EndFunc

Func log_msg($msg)
    Local $log_file = FileOpen($log_filename, 1)
    If @error Then
        set_status("ERROR: Could not log message '" & $msg & "' -- unable to open log file!")
    Else
        FileWriteLine($log_file, $msg)
        FileClose($log_file)
    EndIf
EndFunc

$window_main = GUICreate("Farmville Bot", 250, 240)
$graphic_background = GUICtrlCreateGraphic(0, 0, 250, 240)
GUICtrlSetState($graphic_background, $GUI_DISABLE)

$label_running = GUICtrlCreateLabel($idle, 5, 5, 240)

GUICtrlCreateGroup("Coordinates", 5, 20, 145, 85)
GUICtrlCreateLabel("Home:", 10, 37, 120)
GUICtrlCreateLabel("Multi Tool:", 10, 52, 120)
GUICtrlCreateLabel("Seed:", 10, 67, 120)
GUICtrlCreateLabel("Accept:", 10, 82, 120)
$label_coordinate_home = GUICtrlCreateLabel(home_string(), 65, 37, 75)
$label_coordinate_multi_tool = GUICtrlCreateLabel(multi_tool_string(), 65, 52, 75)
$label_coordinate_seed = GUICtrlCreateLabel(seed_string(), 65, 67, 75)
$label_coordinate_accept = GUICtrlCreateLabel(accept_string(), 65, 82, 75)

GUICtrlCreateGroup("Mouse Speed", 160, 20, 85, 85)
$input_speed = GUICtrlCreateInput($script_speed, 175, 40, 50, 20, $ES_CENTER)
$updown_speed = GUICtrlCreateUpdown($input_speed)
GUICtrlSetLimit($updown_speed, 100, 1)
$button_speed_1 = GUICtrlCreateButton("1", 165, 65, 25, 15)
$button_speed_5 = GUICtrlCreateButton("5", 190, 65, 25, 15)
$button_speed_10 = GUICtrlCreateButton("10", 215, 65, 25, 15)
$button_speed_15 = GUICtrlCreateButton("15", 165, 85, 25, 15)
$button_speed_25 = GUICtrlCreateButton("25", 190, 85, 25, 15)
$button_speed_50 = GUICtrlCreateButton("50", 215, 85, 25, 15)

GUICtrlCreateGroup("Size", 5, 114, 105, 61)
GUICtrlCreateLabel("Columns:", 13, 129)
$input_size_columns = GUICtrlCreateInput($script_size_columns, 60, 127, 40, 20)
$updown_size_columns = GUICtrlCreateUpdown($input_size_columns)
GUICtrlSetLimit($updown_size_columns, 20, 1)
GUICtrlCreateLabel("Rows:", 13, 151)
$input_size_rows = GUICtrlCreateInput($script_size_rows, 60, 149, 40, 20)
$updown_size_rows = GUICtrlCreateUpdown($input_size_rows)
GUICtrlSetLimit($updown_size_rows, 20, 1)

GUICtrlCreateGroup("Rotations", 115, 114, 130, 61)
$combo_rotation = GUICtrlCreateCombo("", 120, 129, 120, -1, $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL)
GUICtrlSetData($combo_rotation, $ppw_rotation & "|" & $ppd_rotation & "|" & $rpp_rotation, $rotation)
GUICtrlCreateLabel("Count:", 120, 153)
$input_repeat_count = GUICtrlCreateInput($repeat_count, 180, 151, 60, 20)
$updown_repeat_count = GUICtrlCreateUpdown($input_repeat_count)
GUICtrlSetLimit($updown_repeat_count, 32767, 0)

$button_help = GUICtrlCreateButton("&Help", 5, 183, 75, 25)

$combo_direction = GUICtrlCreateCombo("", 85, 185, 160, -1, $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL)
GUICtrlSetData($combo_direction, $forward_rows & "|" & $zigzag_rows & "|" & $eastward_rows, $direction)

$label_status = GUICtrlCreateLabel("", 5, 210, 240, 30)

; TODO: Update to reflect current controls -----------------------------------> started please check 
$window_help = GUICreate("Help", 300, 500, -1, -1, -1, 0, $window_main)
GUICtrlCreateLabel("Common Controls", 10, 5)
GUICtrlCreateLabel("[ESC]", 15, 25) 
GUICtrlCreateLabel("= Abort current task", 120, 25)
GUICtrlCreateLabel("[SHIFT]+[ESC]", 15, 45)
GUICtrlCreateLabel("= Clear mode", 120, 45)
GUICtrlCreateLabel("[PAUSE]", 15, 65)
GUICtrlCreateLabel("= Pause the script", 120, 65)
GUICtrlCreateLabel("[SHIFT]+[PAUSE]", 15, 85)
GUICtrlCreateLabel("= Access zoom settings", 120, 85)



;changed by M
$window_settings = GUICreate("Settings", 205, 40, -1, -1, -1, 0, $window_main)
$combo_asp = GUICtrlCreateCombo("", 15, 10, 50, -1, $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL)
GUICtrlSetData($combo_asp, $asp_43 & "|" & $asp_169, $set_asp) ;<--- change default when ini or reg is made
$combo_zoomlevel = GUICtrlCreateCombo("", 80, 10, 110, -1, $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL)
GUICtrlSetData($combo_zoomlevel, $zoom_level1 & "|" & $zoom_level2 & "|" & $zoom_level3 & "|" & $zoom_level4 & "|", $set_zoom) ;<--- change default when ini or reg is made

GUISetState(@SW_SHOW, $window_main)


While 1
    If $script_running Then
        ; Seriously, why is this even necessary...?
        $script_size_columns = GUICtrlRead($input_size_columns)
        $script_size_rows = GUICtrlRead($input_size_rows)
        $direction = GUICtrlRead($combo_direction)

        wait_for_pause()

        If $direction == $forward_rows Then
            farm_NENE()
        ElseIf $direction == $zigzag_rows Then
            farm_NESW()
        ElseIf $direction == $eastward_rows Then
            farm_NS()
        Else
            set_status("ERROR: Please select a direction in which to click")
            clear_mode()
        EndIf
    EndIf

    $script_speed = GUICtrlRead($input_speed)

    ; Check for clipping and force back to limits
    If $script_speed < 0 Or $script_speed > 100 Then set_speed($script_speed)

    Local $gui_msg = GUIGetMsg(1)

    Select
        Case $gui_msg[0] = $GUI_EVENT_CLOSE
            If $gui_msg[1] = $window_main Then
                ExitLoop
            ElseIf $gui_msg[1] = $window_help Then
                GUISetState(@SW_HIDE, $window_help)
			ElseIf $gui_msg[1] = $window_settings Then ;<---- edited by M
                set_zoom()
				GUISetState(@SW_HIDE, $window_settings)
				renew_offset()
            EndIf
        Case $gui_msg[0] = $button_help
            GUISetState(@SW_SHOW, $window_help)
        Case $gui_msg[0] = $button_speed_1
            set_speed(1)
        Case $gui_msg[0] = $button_speed_5
            set_speed(5)
        Case $gui_msg[0] = $button_speed_10
            set_speed(10)
        Case $gui_msg[0] = $button_speed_15
            set_speed(15)
        Case $gui_msg[0] = $button_speed_25
            set_speed(25)
        Case $gui_msg[0] = $button_speed_50
            set_speed(50)
    EndSelect

    Sleep(25)
WEnd

Func set_zoom()
Select
	Case $combo_zoomlevel = $zoom_level1
		If $combo_asp = $asp_43 Then
			$zoom = 4	
		ElseIf $combo_asp = $asp_169 Then
			$zoom = 2.65	
		EndIf
	Case $combo_zoomlevel = $zoom_level2
		If $combo_asp = $asp_43 Then
			$zoom = 3	
		ElseIf $combo_asp = $asp_169 Then
			$zoom = 1.98	
		EndIf
	Case $combo_zoomlevel = $zoom_level3
		If $combo_asp = $asp_43 Then
			$zoom = 2	
		ElseIf $combo_asp = $asp_169 Then
			$zoom = 1.32	
		EndIf
	Case $combo_zoomlevel = $zoom_level4
		If $combo_asp = $asp_43 Then
		$zoom = 1	
		ElseIf $combo_asp = $asp_169 Then
		$zoom = 0.66	
		EndIf
EndSelect
EndFunc

Func renew_offset()
$offset_x = Round($offset_at_one_x * $zoom,0)
$offset_y = Round($offset_at_one_y * $zoom,0)
EndFunc


Func farm_NENE()
    ; Some (local) variables
    Local $current_x = $script_x
    Local $current_y = $script_y
    Local $clicker = get_clicker_function()

    ; TODO: because clicking on the edge to plow is different from clicking in the center for planting, assume HOME is for plow and move up 1/2 for plant / reap / delete / generic
    If is_not_plowing() Then $current_y = $current_y - $offset_y

    ; Directions:
    ; 1) [as is] NE, NE, NE (always follow a row North-East)
    ; 2) NE, SW, NE, SW (follow a row up, then follow the next one down, repeat)
    ; 3) N, S, N, S (follow the diagnol upard, then downward in a rhombus pattern)

    For $current_row = 1 To $script_size_rows Step 1
        For $current_column = 1 To $script_size_columns Step 1
            wait_for_pause()
            Call($clicker, Round($current_x), Round($current_y))

            $current_x = $current_x + $offset_x
            $current_y = $current_y - $offset_y

            If Not $script_running Then ExitLoop
        Next

        ; Reset to beginning of row
        $current_x = $current_x - ($offset_x * $script_size_columns)
        $current_y = $current_y - (-$offset_y * $script_size_columns)

        ; Advance to the next row
        $current_x = $current_x + $offset_x
        $current_y = $current_y + $offset_y

        If Not $script_running Then ExitLoop
    Next

    ; Load next mode
    next_mode_delayed()
EndFunc

Func farm_NESW()
    ; Some (local) variables
    Local $current_x = $script_x
    Local $current_y = $script_y
    Local $clicker = get_clicker_function()

    ; TODO: because clicking on the edge to plow is different from clicking in the center for planting, assume HOME is for plow and move up 1/2 for plant / reap / delete / generic
    If is_not_plowing() Then $current_y = $current_y - $offset_y

    ; Directions:
    ; 2) NE, SW, NE, SW (follow a row up, then follow the next one down, repeat)

    Local $multiplier = +1
    Local $current_row = 1
    Local $current_column = 1
    Local $first_column = 1
    Local $last_column = $script_size_columns
    While $current_row <= $script_size_rows And $script_running
        For $current_column = $first_column To $last_column Step $multiplier
            wait_for_pause()
            Call($clicker, Round($current_x), Round($current_y))

            $current_x = $current_x + $offset_x * $multiplier
            $current_y = $current_y - $offset_y * $multiplier

            If Not $script_running Then ExitLoop
        Next

        ; Advance to the next row
        $current_x = $current_x + $offset_x * (1 - $multiplier)
        $current_y = $current_y + $offset_y * (1 + $multiplier)
        $current_row = $current_row + 1

        ; Switch Direction
        $first_column = $script_size_columns + 1 - $first_column
        $last_column = $script_size_columns + 1 - $last_column
        $multiplier = -$multiplier
    WEnd

    ; Load next mode
    next_mode_delayed()
EndFunc

Func farm_NS()
    ; Some (local) variables
    Local $current_x = $script_x
    Local $current_y = $script_y
    Local $clicker = get_clicker_function()

    ; TODO: because clicking on the edge to plow is different from clicking in the center for planting, assume HOME is for plow and move up 1/2 for plant / reap / delete / generic
    If is_not_plowing() Then $current_y = $current_y - $offset_y

    ; Directions:
    ; 3) N, S, N, S (follow the diagnol upard, then downward in a rhombus pattern)

    ;    I   S   D
    ; + +y  -y  -y
    ; - -y  -y  +y

    Local $multiplier = -2
    Local $plot_x_count = $script_size_rows + $script_size_columns - 1
    Local $max_y, $default_multiplier
    If $script_size_rows > $script_size_columns Then
        $max_y = $script_size_columns
        $default_multiplier = -1
    Else
        $max_y = $script_size_rows
        $default_multiplier = +1
    EndIf
    ; if x + x < x_count, y_count = x; else y_count = x_count - x + 1
    Local $plot_x = 1
    Local $plot_y_count, $multiplier2, $plot_y

    While $plot_x <= $plot_x_count And $script_running
        If $plot_x < $max_y Then
            $plot_y_count = $plot_x
            $multiplier2 = BitShift($multiplier, 1)
        ElseIf $plot_x_count - $plot_x + 1 <= $max_y Then
            $plot_y_count = $plot_x_count - $plot_x + 1
            $multiplier2 = -BitShift($multiplier, 1)
        Else
            $plot_y_count = $max_y
            $multiplier2 = $default_multiplier
        EndIf

        ;$plot_y_count = _Min($script_x, _Min($plot_x, $plot_x_count - $plot_x))
        $plot_y = 1

        While $plot_y <= $plot_y_count And $script_running
            wait_for_pause()
            Call($clicker, Round($current_x), Round($current_y))

            $current_y = $current_y + $offset_y * $multiplier
            $plot_y += 1
        WEnd

        $current_x = $current_x + $offset_x
        $current_y = $current_y + $offset_y * ($multiplier2 - $multiplier)
        $plot_x += 1
        $multiplier = -$multiplier
    WEnd

    ; Load next mode
    next_mode_delayed()
EndFunc

