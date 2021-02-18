$interpret_ready = True

$Comment_Character = ";"
$Def_Language = "Autoit_3.x" ;NO SPACES!!!

;In format: Function-Outputtype-Workingaction.
global $interpret_actions[4] = [ _
"Un_Tidy-File-Rebuild", _
"Dependency_Discovery-File-Hold", _
"Function_Alloc-File-Hold", _
"Parser_Launch-File-Hold"]


;Definitions in the format: 0 = Prefix, 1 = [Container] , 2 = Container...
;CURRENTLY ONLY SUPPORT FOR THE FIRST CONTAINER
global $Dependency_Discovery_Def[3] = ["#Include","<>",'""']
global $Dependency_Discovery_Is_Recursive = False

global $String_Identifiers[2] = ['"', "'"]
global $Var_has_symbol = True
global $Var_Symbol = "$"


;============CONTROL BLOCK SYNTAX===============
global $Control_Block_Suffix = ""

;Overriding is supported.
global $Function_Alloc_Def[2] = ["Func ",""]
global $Function_Alloc_Endblock = "EndFunc"
global $Function_Alloc_Is_Recursive = False


global $FOR_statement = "FOR" ; FOR (assignment expression)  TO (comparison Expression) STEP (increment Expression)
global $FOR_intermediate = "TO"
global $FOR_intermediate2 = "STEP" ;if only I didnt have to do this.
global $FOR_Suffix = ""
Global $FOR_Close = "NEXT"

global $IF_statement = "IF"; IF (expression) THEN
global $IF_suffix_spaced = True
global $IF_Suffix = "THEN"
global $ELSE_Prefix = "ELSE"
global $ELSEIF_Prefix = "ELSEIF"
global $IF_Close = "ENDIF"

global $WHILE_statement = "WHILE" ; WHILE (Comparison Expression)
global $WHILE_Suffix_Spaced = False
global $WHILE_Suffix = ""
global $While_Close = "WEND"

;Functions that do not have parameters and are passed an expression. (or even no expression)
global $Expressional_functions[3] = ["RETURN", "EXITLOOP", "CONTINUELOOP"]

global $Builtin_Funcs[24] = [ "ABS", _ ;Someone needs to help me populate this list.
"CONSOLEWRITE", _
"FILEEXISTS", _
"DIRCREATE", _
"FILEOPENDIALOG", _
"SLEEP", _
"STRINGSPLIT", _
"ASC", _
"CHR", _
"STRINGLEFT", _
"STRINGRIGHT", _
"STRINGTRIMLEFT", _
"STRINGTRIMRIGHT", _
"STRINGLEN", _
"UBOUND", _
"INIWRITE", _
"INIREAD", _
"FILEOPEN", _
"FILEWRITE", _
"FILECLOSE", _
"FILEWRITELINE", _
"FILEREADLINE", _
"RANDOM", _
"EXIT"]

;Scope Changing Keywords
global $Prefix_Modifiers[4] = ["DIM", "REDIM", "GLOBAL", "LOCAL"]
