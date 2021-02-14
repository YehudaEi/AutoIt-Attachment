#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Bible.ico
#AutoIt3Wrapper_outfile=Bible Downloader.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

$Ukranian = "ukr"
$Russian = "rus"
$FTotal = ""
$FLeft = ""
#Region GUI
$Form1 = GUICreate("Библия в эМ Пи 3",220,400)
	GUICtrlCreateGroup ("Звукозапись на каком языке ?",5,5,210,40)
		$Russian = GUICtrlCreateRadio ("Русском",10,20)
		GUICtrlSetState (-1,$GUI_CHECKED)
		$Ukranian = GUICtrlCreateRadio ("Украинском",80,20)
	GUICtrlCreateGroup ("Качать с какого сервера ?",5,50,210,50)
		$Address = GUICtrlCreateInput ("http://mp3.bibleonline.ru/",10,70,200,20)
	GUICtrlCreateGroup ("Выбирете Завет",5,100,210,40)
		$Old = GUICtrlCreateRadio ("Старый",10,115)
		$New = GUICtrlCreateRadio ("Новый",80,115)
	GUICtrlCreateGroup ("Куда закачивать",5,140,210,75)
		$OutputDir = GUICtrlCreateInput (@ScriptDir & "\Bible",10,160,145,20)
		$ChangeDir = GUICtrlCreateButton ("Изменить",155,160,55,20)
		$Start = GUICtrlCreateButton ("Закачать выбранное",10,180,200)
	GUICtrlCreateGroup ("Прогресс",5,220,210,175)
		$Progress = GUICtrlCreateProgress (10,240,200,20)
		$Status = GUICtrlCreateInput ("",10,260,200,20)
		$Completed = GUICtrlCreateEdit ("",10,280,200,105,$ES_AUTOVSCROLL)
#EndRegion GUI
GUISetState(@SW_SHOW)
Global $BookNumber = "" ;those are changed when testament is case $testament Old or New
Global $Chapter = ""
Global $Folder = ""
Global $RenamedFile = ""
_GUI()
Func _GUI()
	Global $Form1
	Local $Form2,$Form3
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Old
				If WinExists ("Новый Завет") Then GUIDelete ($Form3)
				If WinExists ("Старый Завет") Then GUIDelete ($Form2)
				$Form2 = GUICreate ("Старый Завет",433,420,220,-23,$WS_CLIPCHILDREN + $WS_POPUP + $WS_THICKFRAME,$WS_EX_MDICHILD,$Form1)
				GUISetState(@SW_SHOW,$Form2)
				$Bitie = GUICtrlCreateRadio ("Книга Бытие",5,0,-1,20);"1" 1-50
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Буття")
				$Ishod = GUICtrlCreateRadio ("Книга Исход",5,20,-1,20)			;"2"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Вихід")
				$Levit = GUICtrlCreateRadio ("Книга Левит",5,40,-1,20)			;"3"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Левит")
				$Chisla = 	GUICtrlCreateRadio ("Книга Числа",5,60,-1,20)		;"4"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Числа")
				$Vtorozakonie = GUICtrlCreateRadio ("Книга Второзаконие",5,80,-1,20)	;"5"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Повторення Закону")
				$IisusNavin = GUICtrlCreateRadio ("Книга Иисуса Навина",5,100,-1,20)		;"6"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Ісус Навин")
				$Soodie = 	GUICtrlCreateRadio ("Книга Судей",5,120,-1,20)		;"7"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Книга Суддів")
				$Roofi = 	GUICtrlCreateRadio ("Книга Руфь",5,140,-1,20)		;"8"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Рут")
				$1Tsarstv = GUICtrlCreateRadio ("Первая книга Царств",5,160,-1,20)		;"9"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"1 Самуїлова")
				$2Tsarstv = GUICtrlCreateRadio ("Вторая книга Царств",5,180,-1,20)		;"10"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"2 Самуїлова")
				$3Tsarstv = GUICtrlCreateRadio ("Третья книга Царств",5,200,-1,20)		;"11"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"1 Царів")
				$4Tsarstv =	GUICtrlCreateRadio ("Четвёртая книга Царств",5,220,-1,20)		;"12"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"2 Царів")
				$1Paralipomenon = GUICtrlCreateRadio ("Первая книга Паралипоменон",5,240,-1,20) 	;"13"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"1 Хроніки")
				$2Paralipomenon = GUICtrlCreateRadio ("Вторая книга Паралипоменон",5,260,-1,20)	;"14"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"2 Хроніки")
				$Ezdra = GUICtrlCreateRadio ("Ездра",5,280,-1,20)			;"15"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Ездра")
				$Neemiya = GUICtrlCreateRadio ("Неемия",5,300,-1,20)			;"16"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Неемія")
				$Esfir = GUICtrlCreateRadio ("Есфирь",5,320,-1,20)			;"17"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Естер")
				$Iov = GUICtrlCreateRadio ("Иов",5,340,-1,20)				;"18"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Йов")
				$Psaltir = GUICtrlCreateRadio ("Псалтирь",5,360,-1,20)			;"19"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Псалми")
				$Pritchi = GUICtrlCreateRadio ("Притчи",205,0,80,20)			;"20"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Приповісті")
				$Ekklesiast = GUICtrlCreateRadio ("Екклесиаст",205,20,-1,20)		;"21"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Екклезіяст")
				$PesnyaPesney = GUICtrlCreateRadio ("Песня Песней",205,40,-1,20)	;"22"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Пісня над піснями")
				$Isaya = GUICtrlCreateRadio ("Исаия",205,60,-1,20)			;"23"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Ісая")
				$Ieremeya = GUICtrlCreateRadio ("Иеремия",205,80,-1,20)		;"24"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Єремія")
				$PLachIeremee = GUICtrlCreateRadio ("Плач Иеремии",205,100,-1,20);"25"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Плач Єремії")
				$Iezekiil = GUICtrlCreateRadio ("Иезекииль",205,120,-1,20)	;"26"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Єзекіїль")
				$Daniil = GUICtrlCreateRadio ("Даниил",205,140,-1,20)		;"27"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Даниїл")
				$Ociya = GUICtrlCreateRadio ("Осия",205,160,-1,20)			;"28"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Осія")
				$Ioil = GUICtrlCreateRadio ("Иоиль",205,180,-1,20)			;"29"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Йоїл")
				$Amos = GUICtrlCreateRadio ("Амос",205,200,-1,20)			;"30"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Амос")
				$Awdi = GUICtrlCreateRadio ("Авдий",205,220,-1,20)			;"31"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Овдій")
				$Iona = GUICtrlCreateRadio ("Иона",205,240,-1,20)			;"32"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Йона")
				$Mihey = GUICtrlCreateRadio ("Михей",205,260,-1,20)			;"33"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Михей")
				$Naum = GUICtrlCreateRadio ("Наум",205,280,-1,20)			;"34"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Наум")
				$Avvakym = GUICtrlCreateRadio ("Аввакум",205,300,-1,20)			;"35"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Авакум")
				$Sofoniya = GUICtrlCreateRadio ("Софония",205,320,-1,20)		;"36"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Софонія")
				$Aggei = GUICtrlCreateRadio ("Аггей",205,340,-1,20)			;"37"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Огій")
				$Zahariya = GUICtrlCreateRadio ("Захария",205,360,-1,20)		;"38"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Захарія")
				$Malahiya = GUICtrlCreateRadio ("Малахия",205,380,-1,20)		;"39"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Малахії")
			Case $New
				If WinExists ("Старый Завет") Then GUIDelete ($Form2)
				If WinExists ("Новый Завет") Then GUIDelete ($Form3)
				$Form3 = GUICreate ("Новый Завет",433,420,220,-23,$WS_CLIPCHILDREN + $WS_POPUP + $WS_THICKFRAME,$WS_EX_MDICHILD,$Form1)
				GUISetState(@SW_SHOW,$Form3)
				$OtMatfeya = GUICtrlCreateRadio ("Св. Евангелие от Матфея",5,0,-1,20)						;"40"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Від Матвія")
				$OtMarka = GUICtrlCreateRadio ("Св. Евангелие от Марка",5,20,-1,20) 						;"41"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Від Марка")
				$OtLooki = GUICtrlCreateRadio ("Св. Евангелие от Луки",5,40,-1,20) 							;"42"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Від Луки")
				$OtIoanna = GUICtrlCreateRadio ("Св. Евангелие от Иоанна",5,60,-1,20) 						;"43"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Від Івана")
				$Deyaniya = GUICtrlCreateRadio ("Деяния св. Апостолов",5,80,-1,20) 							;"44"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Дії Апостолів")
				$Iakova = GUICtrlCreateRadio ("Послание Иакова",5,100,-1,20) 								;"45"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Якова")
				$1Petra = GUICtrlCreateRadio ("Первое послание Петра",5,120,-1,20)							;"46"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"1 Петра")
				$2Petra = GUICtrlCreateRadio ("Второе послание Петра",5,140,-1,20)							;"47"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"2 Петра")
				$1Ioanna = GUICtrlCreateRadio ("Первое послание Иоанна",5,160,-1,20) 						;"48"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"1 Івана")
				$2Ioanna = GUICtrlCreateRadio ("Второе послание Иоанна",5,180,-1,20) 						;"49"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"2 Івана")
				$3Ioanna = GUICtrlCreateRadio ("Третье послание Иоанна",5,200,-1,20) 						;"50"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"3 Івана")
				$Ioodi = GUICtrlCreateRadio ("Послание Иуды",5,220,-1,20) 									;"51"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Юда")
				$KRimlyanam = GUICtrlCreateRadio ("Послание к Римлянам",5,240,-1,20) 						;"52"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"До Римлян")
				$1Korinfyanam = GUICtrlCreateRadio ("Первое послание к Коринфянам",5,260,-1,20) 			;"53"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"1 до Коринтян")
				$2Korinfyanam = GUICtrlCreateRadio ("Второе послание к Коринфянам",5,280,-1,20) 			;"54"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"2 до Коринтян")
				$KGalatam = GUICtrlCreateRadio ("Послание к Галатам",5,300,-1,20) 							;"55"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"До Галатів")
				$KEfesyanam = GUICtrlCreateRadio ("Послание к Ефесянам",5,320,-1,20) 						;"56"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"До Ефесян")
				$KFilipiytsam = GUICtrlCreateRadio ("Послание к Филиппийцам",5,340,-1,20) 					;"57"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"До филип'ян")
				$KKolosyanam = GUICtrlCreateRadio ("Послание к Колоссянам",5,360,-1,20) 					;"58"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"До Колоссян")

				$1KFessalonikiytsam = GUICtrlCreateRadio ("Первое послание к Фессалоникийцам",205,0,-1,20) 	;"59"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"1 до Солунян")
				$2KFessalonikiytsam = GUICtrlCreateRadio ("Второе послание к Фессалоникийцам",205,20,-1,20) ;"60"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"2 до Солунян")
				$1Timofeu = GUICtrlCreateRadio ("Первое послание к Тимофею",205,40,-1,20) 					;"61"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"1 Тимофію")
				$2Timofeu = GUICtrlCreateRadio ("Второе послание к Тимофею",205,60,-1,20) 					;"62"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"2 Тимофію")
				$KTitu = GUICtrlCreateRadio ("Послание к Титу",205,80,-1,20) 								;"63"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"До Тита")
				$KFilimonu = GUICtrlCreateRadio ("Послание к Филимону",205,100,-1,20) 						;"64"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"До Филимона")
				$KEvreyam = GUICtrlCreateRadio ("Послание к Евреям",205,120,-1,20) 							;"65"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"До Євреїв")
				$Otkroveniya = GUICtrlCreateRadio ("Откровение Иоанна Богослова",205,140,-1,20) 			;"66"
				If GUICtrlRead ($Ukranian) = $GUI_CHECKED Then GUICtrlSetData (-1,"Одкровення")
			Case $ChangeDir
				$DirSelect = FileSelectFolder ("Укажите куда качать","",1+2+4,'',$Form1)
				If $DirSelect = "" Then
					MsgBox (16,"Ошибка","Ничего не указанно",'',$Form1)
				Else
				GUICtrlSetData ($OutputDir,$DirSelect)
			EndIf
			Case $Start
#Region ;Start Old
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Bitie) = $GUI_CHECKED Then
					Assign ("Folder","\#1_Бытие")
					Assign ("RenamedFile","#1_Бытие_")
					Assign ("BookNumber", "1")
					Assign ("Chapter", "50")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Ishod) = $GUI_CHECKED Then
					Assign ("Folder","\#2_Исход")
					Assign ("RenamedFile","#2_Исход_")
					Assign ("BookNumber", "2")
					Assign ("Chapter", "40")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Levit) = $GUI_CHECKED Then
					Assign ("Folder","\#3_Левит")
					Assign ("RenamedFile","#3_Левит_")
					Assign ("BookNumber","3")
					Assign ("Chapter","27")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Chisla) = $GUI_CHECKED Then
					Assign ("Folder","\#4_Числа")
					Assign ("RenamedFile","#4_Числа_")
					Assign ("BookNumber","4")
					Assign ("Chapter","36")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Vtorozakonie) = $GUI_CHECKED Then
					Assign ("Folder","\#5_Второзаконие")
					Assign ("RenamedFile","#5_Второзаконие_")
					Assign ("BookNumber","5")
					Assign ("Chapter","34")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($IisusNavin) = $GUI_CHECKED Then
					Assign ("Folder","\#6_Иисуса Навина")
					Assign ("RenamedFile","#6_Иисуса Навина_")
					Assign ("BookNumber","6")
					Assign ("Chapter","24")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Soodie) = $GUI_CHECKED Then
					Assign ("Folder","\#7_Судьи")
					Assign ("RenamedFile","#7_Судьи_")
					Assign ("BookNumber","7")
					Assign ("Chapter","21")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Roofi) = $GUI_CHECKED Then
					Assign ("Folder","\#8_Руфь")
					Assign ("RenamedFile","#8_Руфь_")
					Assign ("BookNumber","8")
					Assign ("Chapter","4")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($1Tsarstv) = $GUI_CHECKED Then
					Assign ("Folder","\#9_1 Царств")
					Assign ("RenamedFile","#1 Царств_")
					Assign ("BookNumber","9")
					Assign ("Chapter","31")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($2Tsarstv) = $GUI_CHECKED Then
					Assign ("Folder","\#10_2 Царств")
					Assign ("RenamedFile","#10_2 Царств_")
					Assign ("BookNumber","10")
					Assign ("Chapter","24")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($3Tsarstv) = $GUI_CHECKED Then
					Assign ("Folder","\#11_3 Царств")
					Assign ("RenamedFile","#11_3 Царств_")
					Assign ("BookNumber","11")
					Assign ("Chapter","22")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($4Tsarstv) = $GUI_CHECKED Then
					Assign ("Folder","\#12_4 Царств")
					Assign ("RenamedFile","#12_4 Царств_")
					Assign ("BookNumber","12")
					Assign ("Chapter","25")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($1Paralipomenon) = $GUI_CHECKED Then
					Assign ("Folder","\#13_1 Паралипоменон")
					Assign ("RenamedFile","#13_1 Паралипоменон_")
					Assign ("BookNumber","13")
					Assign ("Chapter","29")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($2Paralipomenon) = $GUI_CHECKED Then
					Assign ("Folder","\#14_2 Паралипоменон")
					Assign ("RenamedFile","#14_2 Паралипоменон_")
					Assign ("BookNumber","14")
					Assign ("Chapter","36")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Ezdra) = $GUI_CHECKED Then
					Assign ("Folder","\#15_Ездра")
					Assign ("RenamedFile","#15_Ездра_")
					Assign ("BookNumber","15")
					Assign ("Chapter","10")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Neemiya) = $GUI_CHECKED Then
					Assign ("Folder","\#16_Неемия")
					Assign ("RenamedFile","#16_Неемия_")
					Assign ("BookNumber","16")
					Assign ("Chapter","13")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Esfir) = $GUI_CHECKED Then
					Assign ("Folder","\17#_Есфирь")
					Assign ("RenamedFile","#17_Есфирь_")
					Assign ("BookNumber","17")
					Assign ("Chapter","10")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Iov) = $GUI_CHECKED Then
					Assign ("Folder","\#18_Иов")
					Assign ("RenamedFile","#18_Иов_")
					Assign ("BookNumber","18")
					Assign ("Chapter","42")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Psaltir) = $GUI_CHECKED Then
					Assign ("Folder","\#19_Псалтирь")
					Assign ("RenamedFile","#19_Псалтирь_")
					Assign ("BookNumber","19")
					Assign ("Chapter","150")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Pritchi) = $GUI_CHECKED Then
					Assign ("Folder","\#20_Притчи")
					Assign ("RenamedFile","#20_Притчи_")
					Assign ("BookNumber","20")
					Assign ("Chapter","31")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Ekklesiast) = $GUI_CHECKED Then
					Assign ("Folder","\#21_Екклесиаст")
					Assign ("RenamedFile","#21_Екклесиаст_")
					Assign ("BookNumber","21")
					Assign ("Chapter","12")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($PesnyaPesney) = $GUI_CHECKED Then
					Assign ("Folder","\#22_Песня Песней")
					Assign ("RenamedFile","#22_Песня Песней_")
					Assign ("BookNumber","22")
					Assign ("Chapter","8")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Isaya) = $GUI_CHECKED Then
					Assign ("Folder","\#23_Исаия")
					Assign ("RenamedFile","#23_Исаия_")
					Assign ("BookNumber","23")
					Assign ("Chapter","66")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Ieremeya) = $GUI_CHECKED Then
					Assign ("Folder","\#24_Иеремия")
					Assign ("RenamedFile","#24_Иеремия_")
					Assign ("BookNumber","24")
					Assign ("Chapter","52")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($PLachIeremee) = $GUI_CHECKED Then
					Assign ("Folder","\#25_Плач Иеремии")
					Assign ("RenamedFile","#25_Плач Иеремии_")
					Assign ("BookNumber","25")
					Assign ("Chapter","5")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Iezekiil) = $GUI_CHECKED Then
					Assign ("Folder","\#26_Иезекииль")
					Assign ("RenamedFile","#26_Иезекииль_")
					Assign ("BookNumber","26")
					Assign ("Chapter","48")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Daniil) = $GUI_CHECKED Then
					Assign ("Folder","\#27_Даниил")
					Assign ("RenamedFile","#27_Даниил_")
					Assign ("BookNumber","27")
					Assign ("Chapter","12")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Ociya) = $GUI_CHECKED Then
					Assign ("Folder","\#28_Осия")
					Assign ("RenamedFile","#28_Осия_")
					Assign ("BookNumber","28")
					Assign ("Chapter","14")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Ioil) = $GUI_CHECKED Then
					Assign ("Folder","\#29_Иоиль")
					Assign ("RenamedFile","#29_Иоиль_")
					Assign ("BookNumber","29")
					Assign ("Chapter","3")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Amos) = $GUI_CHECKED Then
					Assign ("Folder","\#30_Амос")
					Assign ("RenamedFile","#30_Амос_")
					Assign ("BookNumber","30")
					Assign ("Chapter","9")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Awdi) = $GUI_CHECKED Then
					Assign ("Folder","\#31_Авдий")
					Assign ("RenamedFile","#31_Авдий_")
					Assign ("BookNumber","31")
					Assign ("Chapter","1")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Iona) = $GUI_CHECKED Then
					Assign ("Folder","\#32_Иона")
					Assign ("RenamedFile","#32_Иона_")
					Assign ("BookNumber","32")
					Assign ("Chapter","4")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Mihey) = $GUI_CHECKED Then
					Assign ("Folder","\#33_Михей")
					Assign ("RenamedFile","#33_Михей_")
					Assign ("BookNumber","33")
					Assign ("Chapter","7")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Naum) = $GUI_CHECKED Then
					Assign ("Folder","\#34_Наум")
					Assign ("RenamedFile","#34_Наум_")
					Assign ("BookNumber","34")
					Assign ("Chapter","3")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Avvakym) = $GUI_CHECKED Then
					Assign ("Folder","\#35_Аввакум")
					Assign ("RenamedFile","#35_Аввакум_")
					Assign ("BookNumber","35")
					Assign ("Chapter","3")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Sofoniya) = $GUI_CHECKED Then
					Assign ("Folder","\#36_Софония")
					Assign ("RenamedFile","#36_Софония_")
					Assign ("BookNumber","36")
					Assign ("Chapter","3")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Aggei) = $GUI_CHECKED Then
					Assign ("Folder","\#37_Аггей")
					Assign ("RenamedFile","#37_Аггей_")
					Assign ("BookNumber","37")
					Assign ("Chapter","2")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Zahariya) = $GUI_CHECKED Then
					Assign ("Folder","\#38_Захария")
					Assign ("RenamedFile","#38_Захария_")
					Assign ("BookNumber","38")
					Assign ("Chapter","14")
					_Download()
				EndIf
				If GUICtrlRead ( $Old) = $GUI_CHECKED And GUICtrlRead ($Malahiya) = $GUI_CHECKED Then
					Assign ("Folder","\#39_Малахия")
					Assign ("RenamedFile","#39_Малахия_")
					Assign ("BookNumber","39")
					Assign ("Chapter","4")
					_Download()
				EndIf
#EndRegion ;Old Ens
#Region ;Start New
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($OtMatfeya) = $GUI_CHECKED Then
					Assign ("Folder","\#40_От Матфея")
					Assign ("RenamedFile","#40_От Матфея_")
					Assign ("BookNumber","40")
					Assign ("Chapter","28")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($OtMarka) = $GUI_CHECKED Then
					Assign ("Folder","\#41_От Марка")
					Assign ("RenamedFile","#41_От Марка_")
					Assign ("BookNumber","41")
					Assign ("Chapter","16")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($OtLooki) = $GUI_CHECKED Then
					Assign ("Folder","\#42_От Луки")
					Assign ("RenamedFile","#42_От Луки_")
					Assign ("BookNumber","42")
					Assign ("Chapter","24")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($OtIoanna) = $GUI_CHECKED Then
					Assign ("Folder","\#43_От Иоанна")
					Assign ("RenamedFile","#43_От Иоанна_")
					Assign ("BookNumber","43")
					Assign ("Chapter","21")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($Deyaniya) = $GUI_CHECKED Then
					Assign ("Folder","\#44_Деяния св. Апостолов")
					Assign ("RenamedFile","#44_Деяния св. Апостолов_")
					Assign ("BookNumber","44")
					Assign ("Chapter","28")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($Iakova) = $GUI_CHECKED Then
					Assign ("Folder","\#45_Послание Иакова")
					Assign ("RenamedFile","#45_Послание Иакова_")
					Assign ("BookNumber","45")
					Assign ("Chapter","5")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($1Petra) = $GUI_CHECKED Then
					Assign ("Folder","\#46_Первое послание Петра")
					Assign ("RenamedFile","#46_Первое послание Петра_")
					Assign ("BookNumber","46")
					Assign ("Chapter","5")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($2Petra) = $GUI_CHECKED Then
					Assign ("Folder","\#47_Второе послание Петра")
					Assign ("RenamedFile","#47_Второе послание Петра_")
					Assign ("BookNumber","47")
					Assign ("Chapter","3")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($1Ioanna) = $GUI_CHECKED Then
					Assign ("Folder","\#48_Первое послание Иоанна")
					Assign ("RenamedFile","#48_Первое послание Иоанна_")
					Assign ("BookNumber","48")
					Assign ("Chapter","5")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($2Ioanna) = $GUI_CHECKED Then
					Assign ("Folder","\#49_Второе послание Иоанна")
					Assign ("RenamedFile","#49_Второе послание Иоанна_")
					Assign ("BookNumber","49")
					Assign ("Chapter","1")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($3Ioanna) = $GUI_CHECKED Then
					Assign ("Folder","\#50_Третье послание Иоанна")
					Assign ("RenamedFile","#50_Третье послание Иоанна_")
					Assign ("BookNumber","50")
					Assign ("Chapter","1")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($Ioodi) = $GUI_CHECKED Then
					Assign ("Folder","\#51_Послание Иуды")
					Assign ("RenamedFile","#51_Послание Иуды_")
					Assign ("BookNumber","51")
					Assign ("Chapter","1")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($KRimlyanam) = $GUI_CHECKED Then
					Assign ("Folder","\#52_Послание к Римлянам")
					Assign ("RenamedFile","#52_Послание к Римлянам_")
					Assign ("BookNumber","52")
					Assign ("Chapter","16")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($1Korinfyanam) = $GUI_CHECKED Then
					Assign ("Folder","\#53_Первое послание к Коринфянам")
					Assign ("RenamedFile","#53_Первое послание к Коринфянам_")
					Assign ("BookNumber","53")
					Assign ("Chapter","16")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($2Korinfyanam) = $GUI_CHECKED Then
					Assign ("Folder","\#54_Второе послание к Коринфянам")
					Assign ("RenamedFile","#54_Второе послание к Коринфянам_")
					Assign ("BookNumber","54")
					Assign ("Chapter","13")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($KGalatam) = $GUI_CHECKED Then
					Assign ("Folder","\#55_Послание к Галатам")
					Assign ("RenamedFile","#55_Послание к Галатам_")
					Assign ("BookNumber","55")
					Assign ("Chapter","6")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($KEfesyanam) = $GUI_CHECKED Then
					Assign ("Folder","\#56_Послание к Ефесянам")
					Assign ("RenamedFile","#56_Послание к Ефесянам_")
					Assign ("BookNumber","56")
					Assign ("Chapter","6")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($KFilipiytsam) = $GUI_CHECKED Then
					Assign ("Folder","\#57_Послание к Филиппийцам")
					Assign ("RenamedFile","#57_Послание к Филиппийцам_")
					Assign ("BookNumber","57")
					Assign ("Chapter","4")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($KKolosyanam) = $GUI_CHECKED Then
					Assign ("Folder","\#58_Послание к Колоссянам")
					Assign ("RenamedFile","#58_Послание к Колоссянам_")
					Assign ("BookNumber","58")
					Assign ("Chapter","4")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($1KFessalonikiytsam) = $GUI_CHECKED Then
					Assign ("Folder","\#59_Первое послание к Фессалоникийцам")
					Assign ("RenamedFile","#59_Первое послание к Фессалоникийцам_")
					Assign ("BookNumber","59")
					Assign ("Chapter","4")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($2KFessalonikiytsam) = $GUI_CHECKED Then
					Assign ("Folder","\#60_Второе послание к Фессалоникийцам")
					Assign ("RenamedFile","#60_Второе послание к Фессалоникийцам_")
					Assign ("BookNumber","60")
					Assign ("Chapter","3")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($1Timofeu) = $GUI_CHECKED Then
					Assign ("Folder","\#61_Первое послание к Тимофею")
					Assign ("RenamedFile","#61_Первое послание к Тимофею_")
					Assign ("BookNumber","61")
					Assign ("Chapter","4")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($2Timofeu) = $GUI_CHECKED Then
					Assign ("Folder","\#62_Второе послание к Тимофею")
					Assign ("RenamedFile","#62_Второе послание к Тимофею_")
					Assign ("BookNumber","62")
					Assign ("Chapter","4")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($KTitu) = $GUI_CHECKED Then
					Assign ("Folder","\#63_Послание к Титу")
					Assign ("RenamedFile","#63_Послание к Титу_")
					Assign ("BookNumber","63")
					Assign ("Chapter","3")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($KFilimonu) = $GUI_CHECKED Then
					Assign ("Folder","\#64_Послание к Филимону")
					Assign ("RenamedFile","#64_Послание к Филимону_")
					Assign ("BookNumber","64")
					Assign ("Chapter","1")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($KEvreyam) = $GUI_CHECKED Then
					Assign ("Folder","\#65_Послание к Евреям")
					Assign ("RenamedFile","#65_Послание к Евреям_")
					Assign ("BookNumber","65")
					Assign ("Chapter","13")
					_Download()
				EndIf
				If GUICtrlRead ( $New) = $GUI_CHECKED And GUICtrlRead ($Otkroveniya) = $GUI_CHECKED Then
					Assign ("Folder","\#66_Откровение Иоанна Богослова")
					Assign ("RenamedFile","#66_Откровение Иоанна Богослова_")
					Assign ("BookNumber","66")
					Assign ("Chapter","22")
					_Download()
				EndIf
#EndRegion ;New Ends
		EndSwitch
	WEnd
EndFunc
Func _Download()
	GUICtrlSetData ($Start,"Стоп/Закрыть програму")
	$URL = GUICtrlRead ($Address)
	$Destination = (GUICtrlRead ($OutputDir)) & ($Folder)
	DirCreate ($Destination)
	$FilesToDownload = $Chapter
	$Percent = "0"
	If Guictrlread ($Russian) = $GUI_CHECKED Then
		$Lang = "rus"
	EndIf
	If Guictrlread ($Ukranian) = $GUI_CHECKED Then
		$Lang = "ukr"
	EndIf
	$OrigFileName = ($Lang & "_"& $Chapter &"_") ;original part of the file from server
	$DownloadedFilesCount = "0"
	$Skipped = "0"
	For $X = 1 to $Chapter
		$FileSizeRemote = InetGetSize ($URL & $OrigFileName & $X & ".mp3",1)
		$FileSizeLocal = FileGetSize ($Destination & "\" & $RenamedFile & $X & ".mp3");this cant be used because server gives smaller size due to compression i think.
		If FileExists ($Destination & "\" & $RenamedFile & $X & ".mp3") <> 1 Then
			$Download = InetGet ($URL & $Lang & "_" & $BookNumber & "_" & $X & ".mp3",$Destination & "\" & $RenamedFile & $X & ".mp3",1,1) ;download file from url where 0 is to wait till file dowloaded
			Do
				$Msg = GUIGetMsg() ;this is to read the button to make sure you can stop it in the middle of the process
				Switch $Msg
					Case $Start
						Exit
					EndSwitch
				GUICtrlSetData ($Status,"Качаем фаил." & @CRLF & "Пожалуйста подождите.")
			Until InetGetInfo ($Download,2)
				InetClose ($Download)
				$Percent = Round ($X * 100 / $FilesToDownload) ;rounded percent
				GUICtrlSetData ($Progress,$Percent)
				Assign ("Percent",$X / $FilesToDownload * 100)
				Assign ("DownloadedFilesCount",$DownloadedFilesCount+1)
				GUICtrlSetData ($Completed,"Скачал " & $RenamedFile & $X & ".mp3" & @CRLF & "Счет файла " & $X & @CRLF & "Размер файла " & $FileSizeRemote & " Байт" & @CRLF & "Законченно " & Round ($X * 100 / $FilesToDownload) & "%")
		Else
			$Percent = Round ($X * 100 / $FilesToDownload,-1) ;rounded percent
			GUICtrlSetData ($Progress,$Percent)
			Assign ("Percent",$X / $FilesToDownload * 100)
			Assign ("Skipped",$Skipped+1)
			GUICtrlSetData ($Completed,"Пропустил " & $RenamedFile & $X & ".mp3" & @CRLF & "Счет файла " & $X & @CRLF & "Размер файла " & $FileSizeLocal & " Байт" & @CRLF & "Законченно " & Round ($X * 100 / $FilesToDownload) & "%")
		EndIf
	Next
		GUICtrlSetData ($Completed,@CRLF & $DownloadedFilesCount & " Закаченно","List")
		GUICtrlSetData ($Completed,@CRLF & $Skipped & " Пропущенно","List")
		GUICtrlSetData ($Start,"Закачать выбранное")
	EndFunc