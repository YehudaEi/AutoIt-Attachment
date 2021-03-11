#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include-once
#include <Array.au3>

Global Const $AL_IDX_INI_FILE                  = 00 ;
Global Const $AL_IDX_SCENARIO                  = 01 ;
Global Const $AL_IDX_ENTITY                    = 02 ;
Global Const $AL_IDX_DIR                       = 03 ;
Global Const $AL_IDX_GP                        = 04 ;
Global Const $AL_IDX_WAVE                      = 05 ;
Global Const $AL_IDX_WLF_REF                   = 06 ;
Global Const $AL_IDX_RUN                       = 07 ;
Global Const $AL_IDX_TITLE                     = 08 ;
Global Const $AL_IDX_LAST_TIME                 = 09 ;
Global Const $AL_IDX_DURATION                  = 10 ;
Global Const $AL_IDX_STATUS                    = 11 ;
Global Const $AL_IDX_CB_HANDLE                 = 12 ;
Global Const $AL_IDX_CB_CHECKED                = 13 ;
Global Const $AL_IDX_NB_COLUMNS                = 14 ;Nombre de colonnes dans le tableau

Local $error
Global Const $NB_ITEM = 5
Local $AliasList[$NB_ITEM][$AL_IDX_NB_COLUMNS]

$AliasList[0][$AL_IDX_INI_FILE  ] = "Ini File"        ;00
$AliasList[0][$AL_IDX_SCENARIO  ] = "Scenario"        ;01
$AliasList[0][$AL_IDX_ENTITY    ] = "Entity"          ;02
$AliasList[0][$AL_IDX_DIR       ] = "Dir"             ;03
$AliasList[0][$AL_IDX_GP        ] = "GP"              ;04
$AliasList[0][$AL_IDX_WAVE      ] = "Wave"            ;05
$AliasList[0][$AL_IDX_WLF_REF   ] = "WLF_Reference"   ;06
$AliasList[0][$AL_IDX_RUN       ] = "Run"             ;07
$AliasList[0][$AL_IDX_TITLE     ] = "Title"           ;08
$AliasList[0][$AL_IDX_LAST_TIME ] = "Last_Time"       ;09
$AliasList[0][$AL_IDX_DURATION  ] = "Duration"        ;10
$AliasList[0][$AL_IDX_STATUS    ] = "Status"          ;11
$AliasList[0][$AL_IDX_CB_HANDLE ] = "CB_Handle"       ;12
$AliasList[0][$AL_IDX_CB_CHECKED] = "Checked"         ;13

$AliasList[1][$AL_IDX_INI_FILE  ] = "ini1"
$AliasList[2][$AL_IDX_INI_FILE  ] = "ini2"
$AliasList[3][$AL_IDX_INI_FILE  ] = "ini3"
$AliasList[4][$AL_IDX_INI_FILE  ] = "ini4"

$AliasList[1][$AL_IDX_SCENARIO  ] = "Nom n°1"
$AliasList[2][$AL_IDX_SCENARIO  ] = "Nom n°2"
$AliasList[3][$AL_IDX_SCENARIO  ] = "Nom n°3"
$AliasList[4][$AL_IDX_SCENARIO  ] = "Nom n°4"

$AliasList[1][$AL_IDX_ENTITY    ] = "entity1"
$AliasList[2][$AL_IDX_ENTITY    ] = "entity2"
$AliasList[3][$AL_IDX_ENTITY    ] = "entity3"
$AliasList[4][$AL_IDX_ENTITY    ] = "entity4"

$AliasList[1][$AL_IDX_DIR       ] = "dir1"
$AliasList[2][$AL_IDX_DIR       ] = "dir2"
$AliasList[3][$AL_IDX_DIR       ] = "dir3"
$AliasList[4][$AL_IDX_DIR       ] = "dir4"

$AliasList[1][$AL_IDX_DURATION  ] = 102030
$AliasList[2][$AL_IDX_DURATION  ] = 104050
$AliasList[3][$AL_IDX_DURATION  ] = 106070
$AliasList[4][$AL_IDX_DURATION  ] = 108090

$AliasList[1][$AL_IDX_STATUS    ] = "OK"
$AliasList[2][$AL_IDX_STATUS    ] = "BAD"
$AliasList[3][$AL_IDX_STATUS    ] = "KO"
$AliasList[4][$AL_IDX_STATUS    ] = "???"

;[0]|Ini File|Scenario|Entity|Dir|GP|Wave|WLF_Reference|Run|Title|Last_Time|Duration|Status|CB_Handle|Checked
;[1]||Nom n°1||||||||||||
;[2]||Nom n°2||||||||||||
;[3]||Nom n°3||||||||||||
;[4]||Nom n°4||||||||||||
_ArrayDisplay($AliasList)
Local $struct = DllStructCreate("char IniFile     [256];" & _
                                "char ScenarioName[256];" & _
				                "char Entity      [256];" & _
				                "char Dir         [256];" & _
				                "char GP          [256];" & _
				                "char wave        [256];" & _
				                "char WlfRef      [256];" & _
				                "char Run          [10];" & _
				                "char Title       [256];" & _
				                "char LastTime     [20];" & _
				                "int  Duration         ;" & _
				                "char Status        [7];" & _
				                "int  CB_Handle        ;" & _
				                "int  CB_Checked       ;"   _
				                )

DllStructSetData($struct,2,"this is my question")

ConsoleWrite("valeur @ T0                 = " & DllStructGetData($struct,2) & @CRLF)
ConsoleWrite("DllStructGetPtr($struct)    = " & DllStructGetPtr($struct)    & @CRLF)
ConsoleWrite("====================================================================================" & @CRLF)
ConsoleWrite("test 1" & @CRLF)
DllCall("./MyCustomDll_x64.dll","int:cdecl","MyFunction","str","file12345678","struct*",DllStructGetPtr($struct),"int",$NB_ITEM) ;This send only one item of $AliasList
ConsoleWrite("valeur @ T1                 = " & DllStructGetData($struct,2) & @CRLF)
ConsoleWrite("====================================================================================" & @CRLF)
ConsoleWrite("test 2" & @CRLF)
DllCall("./MyCustomDll_x64.dll","int:cdecl","MyFunction","str","file12345678","struct*",DllStructGetPtr($struct),"int",$NB_ITEM) ;This send only one item of $AliasList
ConsoleWrite("====================================================================================" & @CRLF)
ConsoleWrite("test 3" & @CRLF)
DllCall("./MyCustomDll_x64.dll","int:cdecl","MyFunction","str","file12345678","ptr*",$AliasList,"int",$NB_ITEM)
ConsoleWrite("====================================================================================" & @CRLF)




