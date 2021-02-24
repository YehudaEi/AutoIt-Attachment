#include <mmb_cpux86.au3>
#include <mmb.au3>

#RequireAdmin

; Create the temp file needed to get Machine Info
_GetCPUzInfo()

; Create the output
$outputdir = @ScriptDir &"\"& _GetLaptop() &"\"& _GetManufacturer() &"\"& _GetModel() &"\"& @OSVersion &"_"& @OSArch
MsgBox(0,"Your Machine will be backed up to: ",$outputdir)
