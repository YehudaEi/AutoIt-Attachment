
#include-once

; #FUNCTION# ====================================================================================================================
; Name...........: myFileListToArray_AllFiles
; Description ...: Lists files and\or folders in a specified path
; Syntax.........: myFileListToArray_AllFiles($sPath[, $sFilter = "*.*"[, $iFlag = 1[, $full_adress = True[, $methody = 0[, $size_min = 0[, $size_max = 0[, $Accept_Attribute = 0[, $NO_Accept_Attribute = 0[, $LevelTooDown = 0]]]]\]]]])
; Parameters ....: 	$sPath - Path to generate filelist for.
;					$sFilter = [default is "*.*"]. The filter to use. Search the Autoit3 manual for the word "WildCards" For details, support now for multiple searches
;                           			Example "*.exe; *.txt" will find all "*.exe" and "*.txt" files.
;										'*' = 0 or more. '?' = 0 or 1.
;					$iFlag = Optional: specifies whether to return files folders or both
;                  						|$iFlag=0 Return both files and folders
;                  						|$iFlag=1 (Default)Return files only
;                  						|$iFlag=2 Return Folders only
;					$full_adress = Optional: [default is true]
;										|True - Return full adress for file
;										|False - Return only file name
;					$methody = Optional:[default is 1] search methody
;										|$methody = 0 - simple
;										|$methody = 1 - is full pattern
;					$size_min = Optional:[default is 0] Minimal file size [MB]
;					$size_max = Optional:[default is 0] Max file size [MB]
;					$Accept_Attribute = Optional:[default is ""] Acccept only is file haw attributes.
;										|"R" = READONLY
;										|"A" = ARCHIVE
;										|"S" = SYSTEM
;										|"H" = HIDDEN
;										|"N" = NORMAL
;										|"D" = DIRECTORY
;										|"O" = OFFLINE
;										|"C" = COMPRESSED (NTFS compression, not ZIP compression)
;										|"T" = TEMPORARY
;					$NO_Accept_Attribute = Optional:[default is ""] NO acccept is file haw attributes.
;										|"R" = READONLY
;										|"A" = ARCHIVE
;										|"S" = SYSTEM
;										|"H" = HIDDEN
;										|"N" = NORMAL
;										|"D" = DIRECTORY
;										|"O" = OFFLINE
;										|"C" = COMPRESSED (NTFS compression, not ZIP compression)
;										|"T" = TEMPORARY
;					$LevelTooDown = Optional:[default is 0] how many level too down/up
;										|0 = full tree (all files)
;										|1 = search only one folder.
;										|2 = 2 level down
;										|3 = 3 level down
;										|x = x level down
;										|-1 = 1 level up (+ full tree)
;										|-2 = 2 level up (+ full tree)
;										|-x = x level up (+ full tree)
; Return values . : On Success - The array returned is one-dimensional and is made up as follows:
;                                		$array[0] = Number of Files\Folders returned
;                                		$array[1] = 1st File\Folder
;                                		$array[2] = 2nd File\Folder
;                                		$array[3] = 3rd File\Folder
;                                		$array[n] = nth File\Folder
;								 		@extended = How many files test
;					On Failure - @Error = 1 - Path not found or invalid
;                  				 @Error = 2 - No File(s) Found
;								 @extended = How many files test
; ===============================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: myFileListToArray_AllFiles
; Description ...: Zwraca liste plikow i/lub fodlderow
; Syntax.........: myFileListToArray_AllFiles($sPath[, $sFilter = "*.*"[, $iFlag = 1[, $full_adress = True[, $methody = 0[, $size_min = 0[, $size_max = 0[, $Accept_Attribute = 0[, $NO_Accept_Attribute = 0[, $LevelTooDown = 0]]]]]]]]])
; Parameters ....: 	$sPath - Sciezka dostempu do pliku
;					$sFilter = [default is "*.*"]. Filtr uzywany przy wyszukiwaniu. Mozna uzyc ich kilka oddzielajac kolejne znakiem ";"
;                           			Naprzyklad skrut "*.exe; *.txt" zastapi dwa wyszukiwania "*.exe" i "*.txt".
;										'*' = 0 lub wiecej. '?' = 0 lub 1.
;					$iFlag = Optional: parametr ustalajacy czy zwracac tylko pliki, foldery, czy oba na raz.
;                  						|$iFlag=0 Zwracaj wszystko
;                  						|$iFlag=1 (Default)Zwracaj tylko pliki
;                  						|$iFlag=2 Zwracaj tylko foldery
;					$full_adress = [default is true]
;										|True - Zwracaj pe³ny adress
;										|False - Zwracaj tylko nazwe pliku
;					$methody = [default is 1] - metoda szukania
;										|$methody = 0 - metoda prosta (szukaj plik zawierajacy czesc podanej nazwy)
;										|$methody = 1 - pelny pattern (to jest caly pattern)
;					$size_min = [default is 0] Minimalny rozmiar pliku [MB]
;					$size_max = [default is 0] maksymalny rozmiar pliku [MB]
;					$Accept_Attribute = [default is ""] Akceptuj tylko te pliki co maja te atrybuty.
;										|"R" = READONLY
;										|"A" = ARCHIVE
;										|"S" = SYSTEM
;										|"H" = HIDDEN
;										|"N" = NORMAL
;										|"D" = DIRECTORY
;										|"O" = OFFLINE
;										|"C" = COMPRESSED (NTFS compression, not ZIP compression)
;										|"T" = TEMPORARY
;					$NO_Accept_Attribute = [default is ""] Nie akceptuj plikow z tymi atrybutami.
;										|"R" = READONLY
;										|"A" = ARCHIVE
;										|"S" = SYSTEM
;										|"H" = HIDDEN
;										|"N" = NORMAL
;										|"D" = DIRECTORY
;										|"O" = OFFLINE
;										|"C" = COMPRESSED (NTFS compression, not ZIP compression)
;										|"T" = TEMPORARY
;					$LevelTooDown = [default is 0] = Jak gleboko (poziom) szukac w dol/gore.
;										|0 = cale drzewo (all files).
;										|1 = Szukaj tylko w 1 folderze.
;										|2 = 2 poziomy w dol.
;										|3 = 3 poziomy w dol.
;										|x = x poziomy w dol.
;										|-1 = 1 poziom w gore (+ cale drzewo)
;										|-2 = 2 poziom w gore (+ cale drzewo)
;										|-x = x poziom w gore (+ cale drzewo)
; Return values . : On Success - Zwraca tablice wyników:
;                                		$array[0] = Liczba znalezionych plikow i folderow
;                                		$array[1] = 1st File\Folder
;                                		$array[2] = 2nd File\Folder
;                                		$array[3] = 3rd File\Folder
;                                		$array[n] = nth File\Folder
;									   @extended  = Ile plikow przeszukano na dysku
;					On Niepowodzenie - @Error = 1 - Sciezka do katalogu jest bledna lub katalog nie istnieje ($sPath)
;                  				 	   @Error = 2 - Nie znaleziono plikow
;								 	   @extended  = Ile plikow przeszukano na dysku
; ===============================================================================================================================

Func myFileListToArray_AllFiles($sPath, $sFilter = "*.*", $iFlag = 1, $full_adress = 1, $methody = 1, $size_min = 0, $size_max = 0, $Accept_Attribute = 0, $NO_Accept_Attribute = 0, $LevelTooDown = 0)

	Local $hSearch, $sFile, $sFileList, $sDelim = "|", $HowManyFiles = 0, $aReturn
	$sPath = StringRegExpReplace($sPath, "[\\/]+\z", "") & "\" ; ensure single trailing backslash
	Local $c, $is_ok, $attrib, $FileSize, $lev, $levPath
	Local $foldery = '', $newFoldersSearch = '', $array_foldery, $extended, $a_Attribute, $NO_a_Attribute

	$iFlag = Number($iFlag)
	$full_adress = Number($full_adress)
	If $full_adress <> 0 Then $full_adress = 1
	$methody = Number($methody)
	If $methody <> 0 Then $methody = 1
	$size_min = Number($size_min * 100) / 100
	$size_max = Number($size_max * 100) / 100
	If $size_max - $size_min < 0 Then $size_max = 0
	If $Accept_Attribute = Default Or $Accept_Attribute = -1 Or $Accept_Attribute = '' Or $Accept_Attribute = '0' Then $Accept_Attribute = 0
	If $NO_Accept_Attribute = Default Or $NO_Accept_Attribute = -1 Or $NO_Accept_Attribute = '' Or $NO_Accept_Attribute = '0' Then $NO_Accept_Attribute = 0
	If $Accept_Attribute Then $a_Attribute = StringSplit(StringRegExpReplace($Accept_Attribute, "[;, ]", ""), "", 3)
	If $NO_Accept_Attribute Then $NO_a_Attribute = StringSplit(StringRegExpReplace($NO_Accept_Attribute, "[;, ]", ""), "", 3)

	$LevelTooDown = Number($LevelTooDown) ; TREE - level up/down
	If $LevelTooDown > 0 Then
		StringReplace($sPath, '\', '\')
		$levPath = @extended - 2
	ElseIf $LevelTooDown < 0 Then
		StringReplace($sPath, '\', '\')
		$levPath = @extended
		If $LevelTooDown <= $levPath Then
			$LevelTooDown = $levPath + $LevelTooDown
			If $LevelTooDown <= 0 Then $LevelTooDown = 1
			$sPath = StringLeft($sPath, StringInStr($sPath, '\', 0, $LevelTooDown))
			$LevelTooDown = 0
		EndIf
	EndIf

	If Not FileExists($sPath) Then Return SetError(1, 0, '')

	$sFilter = StringRegExpReplace($sFilter, "\s*;\s*", "|")
	If ($sFilter = Default) or ($sFilter = -1) Or StringInStr("|" & $sFilter & "|", "|*.*|") Or StringInStr("|" & $sFilter & "|", "||") Then
		$sFilter = '(?i).*'
	Else
		If $methody = 0 Then ;$methody = 0 - "simple"
			$sFilter = StringReplace($sFilter, '*', '\E*\Q')
			$sFilter = StringReplace($sFilter, '?', '\E?\Q')
			$sFilter = StringReplace($sFilter, '.', '\E*[.]*\Q')
			$sFilter = StringReplace($sFilter, '|', '\E*|*\Q')
			$sFilter = '\Q' & $sFilter & '\E'
			$sFilter = StringReplace($sFilter, '\Q\E', '')
			$sFilter = StringReplace($sFilter, '*', '.*')
			$sFilter = StringReplace($sFilter, '?', '.?')
			$sFilter = '(?i).*' & $sFilter & '.*'
			$sFilter = StringRegExpReplace($sFilter, '([.][*]){2,}', '.*')
		Else ;$methody = 1 - "is full pattern"
			$sFilter = StringReplace($sFilter, '*', '\E*\Q')
			$sFilter = StringReplace($sFilter, '?', '\E?\Q')
			$sFilter = StringReplace($sFilter, '.', '\E[.]\Q')
			$sFilter = StringReplace($sFilter, '|', '\E|\Q')
			$sFilter = '\Q' & $sFilter & '\E'
			$sFilter = StringReplace($sFilter, '\Q\E', '')
			$sFilter = StringReplace($sFilter, '*', '.*')
			$sFilter = StringReplace($sFilter, '?', '.?')
			$sFilter = '(?i)' & $sFilter
			$sFilter = StringRegExpReplace($sFilter, '([.][*]){2,}', '.*')
		EndIf
	EndIf
	;ConsoleWrite($sFilter & @CRLF)

	While 1
		$hSearch = FileFindFirstFile($sPath & '*')
		If Not @error Then
			While 1
				$sFile = FileFindNextFile($hSearch)
				If @error Then ExitLoop
				$extended = @extended
				$HowManyFiles += 1
				If $extended = 1 Then ;folder
					;If $Accept_Attribute Or $NO_Accept_Attribute Then
					;$attrib = FileGetAttrib($sPath & $sFile & '\')
					;$is_ok = True
					;If $Accept_Attribute Then ; test atrybutow - akceptowane
					;For $c = 0 To UBound($a_Attribute) - 1
					;If Not StringInStr($attrib, $a_Attribute[$c]) Then $is_ok = False
					;Next
					;EndIf
					;If $NO_Accept_Attribute Then ; test atrybutow - nie akceptowane
					;For $c = 0 To UBound($NO_a_Attribute) - 1
					;If StringInStr($attrib, $NO_a_Attribute[$c]) Then $is_ok = False
					;Next
					;EndIf
					;If $is_ok = False Then ContinueLoop
					;EndIf
					If Not $LevelTooDown Then
						$newFoldersSearch &= $sPath & $sFile & '\' & $sDelim ;nowe foldery do szukania
					Else
						StringReplace($sPath & $sFile, '\', '\')
						$lev = @extended - $levPath
						If $LevelTooDown >= $lev Then
							$newFoldersSearch &= $sPath & $sFile & '\' & $sDelim
						EndIf
					EndIf
				EndIf
				If ($iFlag + $extended = 2) Then ContinueLoop

				$is_ok = Not StringRegExpReplace($sFile, $sFilter, '') ; test pattern

				If ($Accept_Attribute Or $NO_Accept_Attribute) And $is_ok Then ;test atrybutow
					$attrib = FileGetAttrib($sPath & $sFile)
					If $Accept_Attribute Then ; test atrybutow - akceptowane
						For $c = 0 To UBound($a_Attribute) - 1
							If Not StringInStr($attrib, $a_Attribute[$c]) Then $is_ok = False
						Next
					EndIf
					If $NO_Accept_Attribute Then ; test atrybutow - nie akceptowane
						For $c = 0 To UBound($NO_a_Attribute) - 1
							If StringInStr($attrib, $NO_a_Attribute[$c]) Then $is_ok = False
						Next
					EndIf
				EndIf

				If ($size_min Or $size_max) And $is_ok Then ; test size
					$FileSize = Round(FileGetSize($sPath & $sFile) / 1048576, 2) ; size = MB
					If $size_min And $size_min > $FileSize Then $is_ok = False
					If $size_max And $size_max < $FileSize Then $is_ok = False
				EndIf

				If $full_adress And $is_ok Then
					$sFileList &= $sDelim & $sPath & $sFile
				ElseIf Not $full_adress And $is_ok Then
					$sFileList &= $sDelim & $sFile
				EndIf

			WEnd
		EndIf
		FileClose($hSearch)
		$foldery = $newFoldersSearch & $foldery
		$newFoldersSearch = ''
		$array_foldery = StringSplit($foldery, $sDelim, 3)
		If UBound($array_foldery) <= 1 Then ExitLoop
		$foldery = StringTrimLeft($foldery, StringInStr($foldery, $sDelim))
		$sPath = $array_foldery[0]
	WEnd
	If Not $sFileList Then Return SetError(2, $HowManyFiles, "")

	$aReturn = StringSplit(StringTrimLeft($sFileList, 1), $sDelim)
	$sFileList = 0
	SetExtended($HowManyFiles)
	Return $aReturn
EndFunc   ;==>myFileListToArray_AllFiles



;##############################################################
;					version 2 (only 4 parameters)
;##############################################################

Func myFileListToArray_AllFilesEx($sPath, $sFilter = "*.*", $iFlag = 1, $full_adress = 1)

	Local $hSearch, $sFile, $sFileList, $sDelim = "|", $HowManyFiles = 0, $aReturn
	$sPath = StringRegExpReplace($sPath, "[\\/]+\z", "") & "\" ; ensure single trailing backslash
	Local $is_ok, $foldery = '', $newFoldersSearch = '', $array_foldery, $extended

	$iFlag = Number($iFlag)
	$full_adress = Number($full_adress)
	If $full_adress <> 0 Then $full_adress = 1

	If Not FileExists($sPath) Then Return SetError(1, 0, '')

	$sFilter = StringRegExpReplace($sFilter, "\s*;\s*", "|")
	If ($sFilter = Default) or ($sFilter = -1) Or StringInStr("|" & $sFilter & "|", "|*.*|") Or StringInStr("|" & $sFilter & "|", "||") Then
		$sFilter = '(?i).*'
	Else
		$sFilter = StringReplace($sFilter, '*', '\E*\Q')
		$sFilter = StringReplace($sFilter, '?', '\E?\Q')
		$sFilter = StringReplace($sFilter, '.', '\E[.]\Q')
		$sFilter = StringReplace($sFilter, '|', '\E|\Q')
		$sFilter = '\Q' & $sFilter & '\E'
		$sFilter = StringReplace($sFilter, '\Q\E', '')
		$sFilter = StringReplace($sFilter, '*', '.*')
		$sFilter = StringReplace($sFilter, '?', '.?')
		$sFilter = '(?i)' & $sFilter
		$sFilter = StringRegExpReplace($sFilter, '([.][*]){2,}', '.*')
	EndIf
	;ConsoleWrite($sFilter &@CRLF)

	While 1
		$hSearch = FileFindFirstFile($sPath & '*')
		If Not @error Then
			While 1
				$sFile = FileFindNextFile($hSearch)
				If @error Then ExitLoop
				$extended = @extended
				$HowManyFiles += 1
				If $extended = 1 Then ;folder
					$newFoldersSearch &= $sPath & $sFile & '\' & $sDelim ;nowe foldery do szukania
				EndIf
				If ($iFlag + $extended = 2) Then ContinueLoop

				$is_ok = Not StringRegExpReplace($sFile, $sFilter, '') ; test pattern

				If $full_adress And $is_ok Then
					$sFileList &= $sDelim & $sPath & $sFile
				ElseIf Not $full_adress And $is_ok Then
					$sFileList &= $sDelim & $sFile
				EndIf

			WEnd
		EndIf
		FileClose($hSearch)
		$foldery = $newFoldersSearch & $foldery
		$newFoldersSearch = ''
		$array_foldery = StringSplit($foldery, $sDelim, 3)
		If UBound($array_foldery) <= 1 Then ExitLoop
		$foldery = StringTrimLeft($foldery, StringInStr($foldery, $sDelim))
		$sPath = $array_foldery[0]
	WEnd
	If Not $sFileList Then Return SetError(2, $HowManyFiles, "")

	$aReturn = StringSplit(StringTrimLeft($sFileList, 1), $sDelim)
	$sFileList = 0
	SetExtended($HowManyFiles)
	Return $aReturn
EndFunc   ;==>myFileListToArray_AllFilesEx