Run("CadCli.exe") 
$file = FileOpen("c:\Familia.txt", 0)


While 1
$Whole_Line = FileReadLine($File)
If @error = -1 Then ExitLoop
$Columns = StringSplit($Whole_Line, "|")
$First_Column = $Columns[1]
$Second_Column = $Columns[2]


WinWaitActive("Cadastro de Clientes")
ControlClick("Cadastro de Clientes", "", "[CLASS:TEdit;INSTANCE:2]")
Send($First_Column)
ControlClick("Cadastro de Clientes", "", "[CLASS:TEdit;INSTANCE:1]")
Send($Second_Column)
ControlClick("Cadastro de Clientes", "", "[CLASS:TButton; TEXT:Gravar; INSTANCE:2]")
Send("{ENTER}")
Wend
FileClose($Whole_Line)
MsgBox(0, "Teste", "Todos os arquivos foram gravados com sucesso") 



