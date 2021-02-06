; Source files are in "C:\Documents and Settings\10012137\Desktop\Autoit a3x\"

; Choose folder to extract to without trailing backslash
Global $ArchiveExtractDir = ''

Func _ArchiveInstall()
	Run($ArchiveExtractDir & '\setup.exe')
EndFunc

Func _ArchiveRemove()
	Return DirRemove($ArchiveExtractDir, 1)
EndFunc

Func _ArchiveExtract()
	Local $AED = $ArchiveExtractDir
	If DirCreate($AED) Then
		DirCreate($AED & '\index.php_files\')
		DirCreate($AED & '\index.php_files\ADTECH_data\')
		FileInstall('Autoit a3x\index.php.htm', $AED & '\', 1)
		FileInstall('Autoit a3x\index.php_files\ADTECH.htm', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\banned.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\bullet_black.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\closelabel.gif', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\comment_add.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\dev.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\feed.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\geshi.js', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\help.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\icon14.gif', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\index.css', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\index.js', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\index_002.js', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\ipb_print.css', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\key.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\lang-sql.js', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\lightbox.js', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\loading.gif', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\logo.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\paste_plain.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\prettify.js', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\snapback.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\user_green.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\user_off.png', $AED & '\index.php_files\', 1)
		FileInstall('Autoit a3x\index.php_files\ADTECH_data\796371999d18bdf653dfb3649a99bc3e.gif', $AED & '\index.php_files\ADTECH_data\', 1)
		FileInstall('Autoit a3x\index.php_files\ADTECH_data\ADTECH.js', $AED & '\index.php_files\ADTECH_data\', 1)
		FileInstall('Autoit a3x\index.php_files\ADTECH_data\imp.js', $AED & '\index.php_files\ADTECH_data\', 1)
		FileInstall('Autoit a3x\index.php_files\ADTECH_data\q.gif', $AED & '\index.php_files\ADTECH_data\', 1)
		FileInstall('Autoit a3x\index.php_files\ADTECH_data\st.txt', $AED & '\index.php_files\ADTECH_data\', 1)
		Return 1
	EndIf
EndFunc
