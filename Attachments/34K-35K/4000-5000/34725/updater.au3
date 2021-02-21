;�� ���������� ������ � ��������� ����
;#NoTrayIcon
;---------------------------���������� ����������---------------------------------------------
Dim $max_date ;���������� ����������, � ������� ����� ��������� ������������ ���� ��������� �����
Dim $strdate ;����������, � ������� ����� ��������� ������ ������� ���� ��������� �����
Dim $numdate ;����������, � ������� ����� ��������� �������� �������� ������� ���� ��������� �����
Dim $str_srav_date ;����������, � ������� ����������� ���� �� ����� ��� ������
Dim $num_srav_date ;����������, � ������� ����������� ���� �� ����� ��� �����
Dim $file_list ;������ ������, ���������� �� �����
Dim $file_name ;������� ��� �����
Dim $file ;������������� �������� �����
Dim $saved_file_name ;����������� ��� ����� � ������������ ����� ���������
Dim Const $const_path="\\10.30.5.2\Obmen\�������������\����������\CheckXML\!update" ;path to an update folder
Dim Const $const_process="checkxml.exe" ;name of a process for killing
Dim Const $const_file_date="checkxml.txt" ;name of a log file with date of an last update file
Dim $long_file_name ;contains the full path+name of the update file
$max_date=20000101000000 ;������������� ������������ ���� ��������� ����� ���������� ��������� �����
;------------------����� � ����� ����� � ���������� ����� ���������---------------------------
$file_list=FileFindFirstFile($const_path & "\*.exe") ;�������������� ����� � ����� ������ ���� ������ � ����������� exe
If $file_list=-1 Then ;���� � ����� �� ������ �����, ���������������� ������� *.exe
	Exit ;��������� ���������� ���������
EndIf
While true ;����������� ���� ��� ����������� �������� ���� �������� ������
	$file_name=FileFindNextFile($file_list) ;� ���������� ������������� ��� �����
	If @error Then ExitLoop ;����� ������ � ����� ������ �� ��������, ����� �� �����
	$long_file_name=$const_path & "\" & $file_name ;conacatenation of path and name of an update file
	$strdate=FileGetTime($long_file_name,0,1) ;�������� ���� ��������� �������� ����� � ������
	$numdate=Number($strdate) ;������������ ���������� ������ � �������� ��������
	If $max_date<$numdate Then ;���� ������������ ���� ����� ������ ����������
		$max_date=$numdate ;����������� ���������� ���� ������������
		$saved_file_name=$long_file_name ;�������� ������� ��� �����
	EndIf
WEnd
FileClose($file_list) ;����� �������� ������
;;----------------------���������� ���� ���������� ���������� �� �����------------------------------
$file=FileOpen("c:\windows\pfrupdate\" & $const_file_date) ;�������� ����� ��� ������
$str_srav_date=FileReadLine($file,-1) ;������� ��������� ������ - � ���  �������� ���� ��������� �����, � �������� ��������� ��� ������������� ����������
$num_srav_date=Number($str_srav_date) ;�������������� � ���� �����
FileClose($file) ;�������� �����
;---------------------��������� ������������ ���� ��������� ����� � ����� ���������� � ����, ��������� �� �����---------------------------------------------
If $max_date<>$num_srav_date Then
	;FileChangeDir("\\10.30.5.2\Obmen\�������������\����������\CheckXML\Rep") ;������ ������� ����� (���������� ��� ������� ������ ����������)
	;-----------------------������ ����� ����������---------------------------------
	If ProcessExists($const_process) Then ;If checkxml is running
		ProcessClose($const_process) ;killing the CheckXML process
	EndIf
	RunWait($saved_file_name) ;������ ����� ����������
	;-----------------------������ ���� ��������� � ����-------------------------------
	$file=FileOpen("c:\windows\pfrupdate\" & $const_file_date,2) ;�������� ����� ��� ������ ��� �������� ����������� �����������
	FileWriteLine($file,$max_date) ;������ � ���� ���� ��������� �����, �� �������� ��������� ������������ ����������
	FileClose($file) ;�������� �����
EndIf


