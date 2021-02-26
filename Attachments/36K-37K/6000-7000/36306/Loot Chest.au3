HotKeySet("{ESC}", "LootChest")
HotKeySet("^!x", "MyExit")

While 1
      Sleep(50)
WEnd
   
Func LootChest()
; LootChest
MouseClick ( "right",872,398)
Sleep(5000)
HotKeySet("{ESC}", "LootChest")
Exit
EndFunc

Func MyExit()
    Exit
EndFunc 