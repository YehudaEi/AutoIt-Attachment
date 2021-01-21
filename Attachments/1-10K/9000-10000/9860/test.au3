WinWaitActive("Hardware Update Wizard", "Click the")

$ListItemEntry = ControlListView ("Hardware Update Wizard", "Click the", "SysListView321", "FindItem", "Broadcom 570x Gigabit Integrated Controller")
MsgBox(0, "Debug", @error)
MsgBox (0, "Debug", $ListItemEntry)
ControlListView ("Hardware Update Wizard", "", 1580, "Select" , $ListItemEntry)
