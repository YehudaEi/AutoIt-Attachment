#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=Teste_ProductVersion.exe
#AutoIt3Wrapper_Res_Fileversion=0.0.0.23
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=Y
#AutoIt3Wrapper_Res_ProductVersion=0.1.2.3
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;
$sProductVersion   = FileGetVersion(@ScriptFullPath, "ProductVersion")
$sFileVersion      = FileGetVersion(@ScriptFullPath, "FileVersion")
MsgBox (64, "Product Version", "ProductVersion  :" & $sProductVersion, 10)
MsgBox (64, "File Version"   , "FileVersion     :" & $sFileVersion, 10)
Exit