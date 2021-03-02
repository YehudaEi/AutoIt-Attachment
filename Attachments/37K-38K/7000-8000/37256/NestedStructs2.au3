;Nested Structs Example

#cs
struct date{
	// members of structure
    int day;
	int month;
	int year;
};

struct company{
	char name[20];
	int employee_id;
	char sex[5];
	int age;
	struct date dob;};
#ce

Dim $structEmployee	;This will be our final "nested" struct
Dim $s_structNested = ""  ;This is our struct text after it's all put together

$iNumEmployees = 3
$iNumElementsPerEmployee = 7

$s_structCompany = 	"char name[20];int employee_id;char sex[5];int age;" ;Struct to be nested is excluded here, take note of the position of each data type
;~ 						POS1			POS2		POS3		POS4
$s_structDate = 	"int day;int month;int year;"	;This is the struct to be nested into company struct
;~ 					POS5		POS6	POS7

;The following "nests" the structs. You're really concatenating
For $k = 1 To $iNumEmployees
	$s_structNested &= $s_structCompany & $s_structDate
Next

ConsoleWrite($s_structNested & @CRLF)	;here's our structure string
$s_structNested = StringTrimRight($s_structNested, 1)   ;Remove that final semi-colon; just found out it apparently isn't necessary
ConsoleWrite($s_structNested & @CRLF)	;here's our structure string without the semi-colon

$structEmployee = DllStructCreate($s_structNested)		;create the struct

$j = 0

;~ Load data into the struct
For $i = 1 To (($iNumEmployees - 1) * $iNumElementsPerEmployee) + 1 Step 7		;Here $i = 1 then 8 then 15
	$j = $i + 4
	DllStructSetData($structEmployee, $i, 		"Name" & $i)
	DllStructSetData($structEmployee, $i + 1, 	$i + 1000)
	DllStructSetData($structEmployee, $i + 2, 	"Male")
	DllStructSetData($structEmployee, $i + 3, 	$i + 25)
	DllStructSetData($structEmployee, $j, 		$i + 2)
	DllStructSetData($structEmployee, $j + 1, 	$i + 4)
	DllStructSetData($structEmployee, $j + 2, 	$i + 2008)
Next

;~ Display the struct
For $i = 1 To (($iNumEmployees - 1) * $iNumElementsPerEmployee) + 1 Step 7
	$j = $i + 4
	ConsoleWrite("Name: " 			& DllStructGetData($structEmployee, $i) 			& @CRLF)
	ConsoleWrite("Employee ID: " 	& DllStructGetData($structEmployee, $i + 1) 		& @CRLF)
	ConsoleWrite("Sex: " 			& DllStructGetData($structEmployee, $i + 2) 		& @CRLF)
	ConsoleWrite("Age: " 			& DllStructGetData($structEmployee, $i + 3) 		& @CRLF)
	ConsoleWrite("Date: " 			& DllStructGetData($structEmployee, $j + 1) 		& "/" & _	;Month
									  DllStructGetData($structEmployee, $j) 			& "/" & _	;Day
									  DllStructGetData($structEmployee, $j + 2) 		& @CRLF)	;Year
	ConsoleWrite(@CRLF)
Next
