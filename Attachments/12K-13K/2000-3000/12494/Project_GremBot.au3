$WORKINGDIR = @ScriptDir & "\";
$INIFILE = $WORKINGDIR & "Project GremBot.ini"

MsgBox(4096,"Reading Ini",StringUpper( IniRead($INIFILE, "Trade", "Mode", "ALL")))
