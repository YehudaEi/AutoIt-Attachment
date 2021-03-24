
;--------------------------------------------------------------------------------------------------
;Examples of work with SQLiteEx - simple SQLite interface for AutoIt
;--------------------------------------------------------------------------------------------------


#Include 'SQLiteEx.au3'

$bVerbose = TRUE

;----------------------FIRST DATABASE--------------------------------------------------------------
$sDB_Earth			= 'earth_2012'
$sTableCountries	= 'countries'

$sSQL =  "CREATE TABLE " & $sTableCountries & " (country text, internet_users integer, population integer);" & @CR
$sSQL &= "INSERT INTO " & $sTableCountries & " (country, internet_users, population) VALUES " & @CR
$sSQL &= "('Brazil',		99357737,	193946886),"	& @CR
$sSQL &= "('China',			568192066,	1343239923),"	& @CR
$sSQL &= "('India',			151598994,	1205073612),"	& @CR
$sSQL &= "('Japan',			100684474,	127368088),"	& @CR
$sSQL &= "('Russia',		75926004,	142517670),"	& @CR
$sSQL &= "('United States',	254295536,	313847465),"	& @CR
$sSQL &= "('You are here',	2405518376,	7017846922)"	& @CR

Say('Deleting previous ' & $sDB_Earth & ' database: ' & _SQLiteEx_DropDatabase($sDB_Earth))

Say('Opening database ' & $sDB_Earth & ': ' & _SQLiteEx_Open($sDB_Earth, $sSQL))

_SQLiteEx_SetTable($sTableCountries)

Say('Set changed value: ' & _SQLiteEx_Set('country', 'World', "country = 'You are here'"))

Say('Getting value - All internet users in the World: ' & _SQLiteEx_Get('internet_users', "country = 'World'"))

Dim $aColumns[3] =	['country',			'internet_users',	'population']
Dim $aValues[3] =	['Ancient Rome',	0,					0]
Say('Inserting row at Row ID: ' & _SQLiteEx_Insert($aColumns, $aValues))

Say('Deleting row: ' & _SQLiteEx_Delete('country', 'Ancient Rome'))

Say('Is table still exists: ' & _SQLiteEx_TableExists())

_SQLiteEx_ShowTable(Default, 'internet_users', 'DESC')

Say('Dropping table: ' & _SQLiteEx_DropTable($sTableCountries))

Say('Is table still exists: ' & _SQLiteEx_TableExists())

_SQLiteEx_Close()


;----------------------SECOND DATABASE-------------------------------------------------------------
$sDB_SolarSystem	= 'solar_system'
$sTablePlanets		= 'planets'

$sSQL2 =  "CREATE TABLE " & $sTablePlanets & " (planet text, mass real, length_of_day real, mean_temperature real, ring_system integer);" & @CR
$sSQL2 &= "INSERT INTO " & $sTablePlanets & " (planet, mass, length_of_day, mean_temperature, ring_system) VALUES " & @CR
$sSQL2 &= "('Mercury',	0.330,	4222.6,	167,	0)," & @CR
$sSQL2 &= "('Venus',	4.87,	2802.0,	464,	0)," & @CR
$sSQL2 &= "('Earth',	5.97,	24.0,	15,		0)," & @CR
$sSQL2 &= "('Moon',		0.073,	708.7,	-20,	0)," & @CR
$sSQL2 &= "('Mars',		0.642,	24.7,	-65,	0)," & @CR
$sSQL2 &= "('Jupiter',	1898,	9.9,	-110,	1),"  & @CR
$sSQL2 &= "('Saturn',	568,	10.7,	-140,	1),"  & @CR
$sSQL2 &= "('Uranus',	86.8,	17.2,	-195,	1),"  & @CR
$sSQL2 &= "('Neptune',	102,	16.1,	-200,	1),"  & @CR
$sSQL2 &= "('Pluto',	0.0131,	153.3,	-225,	0)"  & @CR
;--------------------------------------------------------------------------------------------------

Say('Deleting previous ' & $sDB_SolarSystem & ' database: ' & _SQLiteEx_DropDatabase($sDB_SolarSystem))

Say('Opening database ' & $sDB_SolarSystem & ': ' & _SQLiteEx_Open($sDB_SolarSystem, $sSQL2))

_SQLiteEx_SetTable($sTablePlanets)

$aRow = _SQLiteEx_QuerySingleRow('SELECT AVG(length_of_day) FROM ' & $sTablePlanets)
Say('Result of queue - Average length of the day in our solar system: ' & $aRow[0] & ' hours')

$aFirstEntry = _SQLiteEx_FirstTableEntry()
Say('First table entry (planet): ' & $aFirstEntry[0])

$aLastEntry = _SQLiteEx_LastTableEntry()
Say('Last table entry (planet): ' & $aLastEntry[0])

_SQLiteEx_ShowTable()

Say('Is first database ' & $sDB_Earth & ' still exists? ' & _SQLiteEx_DatabaseExists($sDB_Earth))

Say('Dropping database ' & $sDB_Earth & ': ' & _SQLiteEx_DropDatabase($sDB_Earth))

_SQLiteEx_Close()


Func Say($sMsg)
	If $bVerbose Then
		MsgBox(0, 'SQLiteEx Example Says', $sMsg)
	Else
		_FileWriteLog('SQLitex_Example.log', $sMsg)
	EndIf
EndFunc