;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Jonathan Bennett (jon@hiddensoft.com)
;
; Script Function:
;
$g_szVersion = "My Script Asentar"
If WinExists($g_szVersion) Then 
   MsgBox(4096, "En proceso", "Existe un Script Previo en ejecucion.. No se puede procesar", 3) 
   Exit ; Ya está en ejecución
endif
AutoItWinSetTitle($g_szVersion)


Login()
Asentar_factura()
;Login()
;Asentar_caja()
exit


func asentar_factura()
   send("P")
   send("{tab 4}")	
   send("T")
   send("{right}")
   send("F")
   send("F")
   send("{right}")
   send("A")
   Send("{ENTER }")
   WinWaitActive("Asentar Facturas")
   Send("{ENTER}")
   WinWaitActive("Opciones de Impresión")
   Send("{ENTER }")
   WinWaitActive("Status de Impresión")
   Send("{ENTER }")
   if winactive("Progression") then
      Send("{ENTER}")
   endif
   if winactive("MSL System Warning") then
      Send("{ENTER}")
   endif
   WinActivate("Progression Workflow Explorer")
   Asentar_caja()
;   send("!f")
;   send("x")
endfunc

func asentar_caja()
;   send("P")
;   send("{tab 4}")	
;   send("T")
;   send("{right}")
;   send("F")
;   send("F")
;   send("{right}")
;   send("A")
   send("A")
   Send("{ENTER}")
   WinWaitActive("Asentar caja")
   Send("{ENTER}")
   WinWaitActive("Opciones de Impresión")
   Send("{ENTER }")
   if winactive("Progression") then
      Send("{ENTER }")
   endif
   if winactivate("Asentar caja") then
      Send("!{f4}")
   endif 
   Send("!f")
   Send("x")
endfunc

Func login()
   Run("L:\MACSQL75\PWE.exe")
   WinWaitActive("Progression Workflow Explorer: Login")
   AutoItSetOption("SendKeyDelay", 100)
   Send("GUEST")
   Send("{tab}")
   Send("GUEST")
   Send("{tab}")
   Send("{DOWN }")
   send("010")		
   Send("{tab}")
   Send("{ENTER}")
   Send("{PGUP}")
   WinWaitActive("Progression Workflow Explorer")
endFunc
