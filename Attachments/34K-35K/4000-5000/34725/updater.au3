;не показывать иконку в системном трее
;#NoTrayIcon
;---------------------------объявление переменных---------------------------------------------
Dim $max_date ;объявление переменной, в которой будет храниться максимальная дата изменения файла
Dim $strdate ;переменная, в которой будет храниться строка текущей даты изменения файла
Dim $numdate ;переменная, в которой будет храниться числовое значение текущей даты изменения файла
Dim $str_srav_date ;переменная, в которую считывается дата из файла тип строка
Dim $num_srav_date ;переменная, в которую считывается дата из файла тип число
Dim $file_list ;список файлов, получаемый из папки
Dim $file_name ;текущее имя файла
Dim $file ;идентификатор текущего файла
Dim $saved_file_name ;сохраненное имя файла с максимальной датой изменения
Dim Const $const_path="\\10.30.5.2\Obmen\Автоматизация\Обновления\CheckXML\!update" ;path to an update folder
Dim Const $const_process="checkxml.exe" ;name of a process for killing
Dim Const $const_file_date="checkxml.txt" ;name of a log file with date of an last update file
Dim $long_file_name ;contains the full path+name of the update file
$max_date=20000101000000 ;инициализация максимальной даты изменения файла минимально возможной датой
;------------------поиск в папке файла с наибольшей датой изменения---------------------------
$file_list=FileFindFirstFile($const_path & "\*.exe") ;инициализирует поиск и вывод списка всех файлов с расширением exe
If $file_list=-1 Then ;если в папке ни одного файла, удовлетворяющего условию *.exe
	Exit ;закончить выполнение программы
EndIf
While true ;бесконечный цикл для организации перебора всех названий файлов
	$file_name=FileFindNextFile($file_list) ;в переменную присваивается имя файла
	If @error Then ExitLoop ;когда файлов в папке больше не осталось, выйти из цикла
	$long_file_name=$const_path & "\" & $file_name ;conacatenation of path and name of an update file
	$strdate=FileGetTime($long_file_name,0,1) ;получаем дату изменения текущего файла в строку
	$numdate=Number($strdate) ;конвертируем полученную строку в числовое значение
	If $max_date<$numdate Then ;если максимальная дата файла меньше полученной
		$max_date=$numdate ;присваиваем полученную дату максимальной
		$saved_file_name=$long_file_name ;получаем длинное имя файла
	EndIf
WEnd
FileClose($file_list) ;конец перебора файлов
;;----------------------считывание даты последнего обновления из файла------------------------------
$file=FileOpen("c:\windows\pfrupdate\" & $const_file_date) ;открытие файла для чтения
$str_srav_date=FileReadLine($file,-1) ;считать последнюю строку - в ней  хранится дата изменения файла, с которого последний раз производилось обновление
$num_srav_date=Number($str_srav_date) ;преобразование к типу число
FileClose($file) ;закрытие файла
;---------------------сравнение максимальной даты изменения файла в папке обновлений и даты, считанной из файла---------------------------------------------
If $max_date<>$num_srav_date Then
	;FileChangeDir("\\10.30.5.2\Obmen\Автоматизация\Обновления\CheckXML\Rep") ;меняем текущую папку (необходимо для запуска файлов обновлений)
	;-----------------------запуск файла обновлений---------------------------------
	If ProcessExists($const_process) Then ;If checkxml is running
		ProcessClose($const_process) ;killing the CheckXML process
	EndIf
	RunWait($saved_file_name) ;запуск файла обновлений
	;-----------------------запись даты изменения в файл-------------------------------
	$file=FileOpen("c:\windows\pfrupdate\" & $const_file_date,2) ;открытие файла для записи при стирании прелыдущего содержимого
	FileWriteLine($file,$max_date) ;запись в файл даты изменения файла, из которого последним производилсь обновление
	FileClose($file) ;закрытие файла
EndIf


