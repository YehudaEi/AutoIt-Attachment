#NoTrayIcon
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>

#include <SQLite.au3>
#include <SQLite.dll.au3>
#Include <Array.au3>
#Include <GuiListView.au3>
#Include <String.au3>
#Include <GuiListBox.au3>
#Include <GuiComboBox.au3>
#Include <Date.au3>
#include <Process.au3>


;~ {[набор цифр](контр сумм)} – md5


Opt("GUIOnEventMode", 1)


Global $aResult, $UsedArr, $iRows, $iColumns
Global $FormCaption='Balance Of Food', $SearchPause=300, $Count=False, $DBFile=@ScriptDir&'\Database.db', $AutoSearchTime=500
Global $iDouble_Click_Event_ListView1 = False, $iOne_Click_Event_ListView1 = False, $Click_On_Column_Head_Event_ListView1=-1
Global $iDouble_Click_Event_ListView2 = False, $iOne_Click_Event_ListView2 = False, $Click_On_Column_Head_Event_ListView2=-1
Global $iDouble_Click_Event_ListView3 = False, $iOne_Click_Event_ListView3 = False, $Click_On_Column_Head_Event_ListView3=-1
Global $LastInput16, $LastInput24, $LastInput18, $LastInput19, $LastInput20, $LastInput21, $LastInput25, $LastInput1, $LastInput9, $LastInput10, $LastListView1, $LastListView2
Global $LastInput12

If WinExists($FormCaption) Then
	MsgBox(16, $FormCaption, 'Нельзя запускать две программы одновременно.')
	Exit
EndIf

OnAutoItExitRegister('ExitFunc')

_SQLite_Startup()
$MainstreamSQL=_SQLite_Open($DBFile)

_SQLite_Exec($MainstreamSQL, 'BEGIN;')
_SQLite_Exec($MainstreamSQL, "Create Table IF NOT EXISTS Food (FoodName VARCHAR NOT NULL UNIQUE, FoodNameIndex VARCHAR NOT NULL, GramPerUnit NUMERIC NOT NULL, KKIn100g NUMERIC NOT NULL, ProteinIn100g NUMERIC NOT NULL, FatIn100g NUMERIC NOT NULL, CarbohydrateIn100g NUMERIC NOT NULL, Glycemic NUMERIC, Insulinemic NUMERIC);")
_SQLite_Exec($MainstreamSQL, "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ")
_SQLite_Exec($MainstreamSQL, "Create Table IF NOT EXISTS UsedFood (UserName VARCHAR NOT NULL, Date DATE NOT NULL, Num INTEGER NOT NULL, FoodName VARCHAR NOT NULL, GramUsed NUMERIC NOT NULL, CaloriesUsed NUMERIC NOT NULL, ProteinUsed NUMERIC NOT NULL, FatUsed NUMERIC NOT NULL, CarbohydrateUsed NUMERIC NOT NULL);")
_SQLite_Exec($MainstreamSQL, "Create Table IF NOT EXISTS Links (Description VARCHAR NOT NULL, DescriptionIndes VARCHAR NOT NULL, Link VARCHAR NOT NULL UNIQUE);")
_SQLite_Exec($MainstreamSQL, 'COMMIT;')




$Form1 = GUICreate("Balance Of Food", 977, 603, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Tab1 = GUICtrlCreateTab(128, 8, 845, 316)
$TabSheet1 = GUICtrlCreateTabItem("Потребление")
$Label3 = GUICtrlCreateLabel("Максимальное кол-во:", 136, 84, 135, 17, $SS_CENTER)
$Label4 = GUICtrlCreateLabel("", 352, 84, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label5 = GUICtrlCreateLabel("Белков", 352, 60, 50, 17, $SS_CENTER)
$Label6 = GUICtrlCreateLabel("", 464, 84, 55, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label7 = GUICtrlCreateLabel("Углеводов", 464, 60, 55, 17)
$Label8 = GUICtrlCreateLabel("", 408, 84, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label9 = GUICtrlCreateLabel("Жиров", 408, 60, 50, 17, $SS_CENTER)
$Label10 = GUICtrlCreateLabel("", 276, 124, 70, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label11 = GUICtrlCreateLabel("", 352, 124, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label12 = GUICtrlCreateLabel("", 408, 124, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label13 = GUICtrlCreateLabel("", 464, 124, 55, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label26 = GUICtrlCreateLabel("Оставшееся кол-во:", 136, 124, 135, 17, $SS_CENTER)
$ListView2 = GUICtrlCreateListView("№|Наименование продукта|Граммы|КК|Белки|Жиры|Углеводы", 132, 168, 834, 150)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 25)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 511)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 60)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 55)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 45)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 47)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 70)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView2), 2, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView2), 3, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView2), 4, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView2), 5, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView2), 6, 2)
$Label39 = GUICtrlCreateLabel("Килокалорий", 276, 60, 70, 17)
$Label40 = GUICtrlCreateLabel("", 276, 84, 70, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label28 = GUICtrlCreateLabel("Употребленное кол-во:", 136, 104, 135, 17, $SS_CENTER)
$Label36 = GUICtrlCreateLabel("", 276, 104, 70, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label41 = GUICtrlCreateLabel("", 352, 104, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label42 = GUICtrlCreateLabel("", 408, 104, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label43 = GUICtrlCreateLabel("", 464, 104, 55, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label53 = GUICtrlCreateLabel("Имя пользователя", 136, 60, 100, 17)
$Label54 = GUICtrlCreateLabel("", 136, 39, 100, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Date3 = GUICtrlCreateDate("2012/01/05 22:22:47", 784, 114, 140, 21)
$Label64 = GUICtrlCreateLabel("С выбранным продуктом:", 136, 144, 135, 17, $SS_CENTER)
$Label65 = GUICtrlCreateLabel("", 276, 144, 70, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label66 = GUICtrlCreateLabel("", 352, 144, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label67 = GUICtrlCreateLabel("", 408, 144, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label68 = GUICtrlCreateLabel("", 464, 144, 55, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Button15 = GUICtrlCreateButton("Вычесть", 656, 104, 75, 25)
GUICtrlSetOnEvent(-1, "Button15Click")
$Button16 = GUICtrlCreateButton("Прибавить", 656, 72, 75, 25)
GUICtrlSetOnEvent(-1, "Button16Click")
$Button17 = GUICtrlCreateButton("Перенести", 656, 136, 75, 25)
$Group1 = GUICtrlCreateGroup("Действие при двойном клике мыши", 744, 40, 217, 65)
$Radio1 = GUICtrlCreateRadio("Удалять продукт из употребленных", 752, 56, 201, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Radio2 = GUICtrlCreateRadio("Перенести продукт на другую дату", 752, 80, 201, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Прибавить/вычесть ", 528, 66, 121, 65)
$Radio3 = GUICtrlCreateRadio("Граммы", 536, 82, 65, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Radio4 = GUICtrlCreateRadio("Порции", 536, 106, 65, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Input11 = GUICtrlCreateInput("", 568, 138, 80, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Label61 = GUICtrlCreateLabel("Кол-во:", 528, 140, 41, 17)
$TabSheet3 = GUICtrlCreateTabItem("Данные пользователя")
$Input12 = GUICtrlCreateInput("", 136, 41, 100, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Label14 = GUICtrlCreateLabel("Имя пользователя", 136, 64, 100, 17)
$Label15 = GUICtrlCreateLabel("Пол", 239, 64, 73, 17, $SS_CENTER)
$Combo1 = GUICtrlCreateCombo("", 239, 41, 73, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Мужской|Женский")
$Label16 = GUICtrlCreateLabel("Дата рождения", 316, 64, 140, 17, $SS_CENTER)
$Date1 = GUICtrlCreateDate("2011/07/02 21:38:8", 316, 41, 140, 21)
$Label17 = GUICtrlCreateLabel("Рост в сантиметрах", 460, 64, 105, 17, $SS_CENTER)
$Input13 = GUICtrlCreateInput("", 460, 41, 105, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input14 = GUICtrlCreateInput("", 568, 41, 103, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Label18 = GUICtrlCreateLabel("Вес в килограммах", 568, 64, 103, 17, $SS_CENTER)
$Combo13 = GUICtrlCreateCombo("", 136, 85, 570, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Сидячий образ жизни|Средняя активность (легкие упражнения 1-3 в неделю)|Высокая активность (интенсивные занятия 3-5 раз в неделю)|Очень высокая активность (тяжелые физические нагрузки 6-7 раз в неделю)|Экстремальная активность (очень тяжелая физическая работа, либо интенсивный тренинг 2 раза в день) ", "Сидячий образ жизни")
$Label19 = GUICtrlCreateLabel("Углеводов", 652, 143, 55, 17, $SS_CENTER)
$Label20 = GUICtrlCreateLabel("Максимальное кол-во:", 340, 144, 120, 17)
$Label21 = GUICtrlCreateLabel("Белков", 540, 144, 50, 17, $SS_CENTER)
$Label22 = GUICtrlCreateLabel("Килокалорий", 464, 144, 70, 17, $SS_CENTER)
$Label23 = GUICtrlCreateLabel("Жиров", 596, 144, 50, 17, $SS_CENTER)
$Label24 = GUICtrlCreateLabel("Установить", 136, 115, 64, 17)
$Combo2 = GUICtrlCreateCombo("", 204, 113, 80, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "норму|дефицит|профицит", "норму")
GUICtrlSetOnEvent(-1, "Combo2Change")
$Label25 = GUICtrlCreateLabel("калорий на", 292, 115, 61, 17)
$Input2 = GUICtrlCreateInput("", 360, 113, 50, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Button2 = GUICtrlCreateButton("Рассчитать", 444, 111, 70, 25)
GUICtrlSetOnEvent(-1, "Button2Click")
$Button3 = GUICtrlCreateButton("Сохранить", 536, 111, 75, 25)
GUICtrlSetOnEvent(-1, "Button3Click")
$Button6 = GUICtrlCreateButton("Удалить", 632, 111, 75, 25)
GUICtrlSetOnEvent(-1, "Button6Click")
$Label44 = GUICtrlCreateLabel("%", 416, 115, 12, 17)
$Label46 = GUICtrlCreateLabel("", 464, 164, 70, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label47 = GUICtrlCreateLabel("", 540, 164, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label48 = GUICtrlCreateLabel("", 596, 164, 50, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label49 = GUICtrlCreateLabel("", 652, 164, 55, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetBkColor(-1, 0xE3E3E3)
$Label45 = GUICtrlCreateLabel("Белки", 136, 188, 50, 17, $SS_CENTER)
$Label50 = GUICtrlCreateLabel("Жиры", 208, 188, 50, 17, $SS_CENTER)
$Label51 = GUICtrlCreateLabel("Углеводы", 284, 188, 50, 17, $SS_CENTER)
$Input5 = GUICtrlCreateInput("20", 136, 165, 50, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input6 = GUICtrlCreateInput("30", 208, 165, 50, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input7 = GUICtrlCreateInput("50", 284, 165, 50, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Label52 = GUICtrlCreateLabel("Баланс белков жиров и углеводов в %", 136, 144, 199, 17)
$Label55 = GUICtrlCreateLabel("Расчет калорий по формуле", 676, 64, 160, 17, $SS_CENTER)
;~ $Combo10 = GUICtrlCreateCombo("Миффлина - Сан Жеора", 676, 41, 160, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
$Combo10 = GUICtrlCreateCombo("", 676, 41, 160, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Харриса-Бенедикта|Миффлина - Сан Жеора|Самостоятельный расчет")
GUICtrlSetOnEvent(-1, "Combo10Change")
$Input3 = GUICtrlCreateInput("", 840, 41, 108, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Label56 = GUICtrlCreateLabel("КК при саморасчете", 840, 64, 108, 17)
$Button9 = GUICtrlCreateButton("Сброс параметров", 728, 111, 110, 25)
GUICtrlSetOnEvent(-1, "Button9Click")
$TabSheet2 = GUICtrlCreateTabItem("Информер")
$ListView3 = GUICtrlCreateListView("Описание|Ссылка", 136, 40, 825, 193)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 300)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 501)
$Input9 = GUICtrlCreateInput("", 136, 264, 300, 21)
$Input10 = GUICtrlCreateInput("", 440, 264, 521, 21)
$Button10 = GUICtrlCreateButton("Сохранить", 136, 288, 75, 25)
GUICtrlSetOnEvent(-1, "Button10Click")
$Button12 = GUICtrlCreateButton("Удалить", 225, 288, 75, 25)
GUICtrlSetOnEvent(-1, "Button12Click")
$Button13 = GUICtrlCreateButton("Очистить поля ввода", 314, 288, 123, 25)
GUICtrlSetOnEvent(-1, "Button13Click")
$Label62 = GUICtrlCreateLabel("Название ресурса", 136, 240, 300, 17, $SS_CENTER)
$Label63 = GUICtrlCreateLabel("Ссылка", 440, 240, 521, 17, $SS_CENTER)
$TabSheet4 = GUICtrlCreateTabItem("Настройки")
$Button8 = GUICtrlCreateButton("Выполнить", 136, 288, 75, 25)
GUICtrlSetOnEvent(-1, "Button8Click")
$Combo11 = GUICtrlCreateCombo("Выберете действие", 224, 290, 220, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Удалить все продукты без знака ™|Удалить все продукты из базы|Экспортировать все продукты|Импортировать продукты|Удалить всех пользователей|Экспортировать пользователей|Импортировать пользователей|Удалить все ссылки|Экспортировать все ссылки|Импортировать ссылки")
GUICtrlCreateTabItem("")
$Input16 = GUICtrlCreateInput("", 7, 544, 600, 21)
$Input24 = GUICtrlCreateInput("", 616, 544, 59, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input18 = GUICtrlCreateInput("", 682, 544, 53, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input19 = GUICtrlCreateInput("", 742, 544, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input20 = GUICtrlCreateInput("", 785, 544, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input21 = GUICtrlCreateInput("", 828, 544, 55, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input25 = GUICtrlCreateInput("", 892, 544, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input1 = GUICtrlCreateInput("", 936, 544, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Button4 = GUICtrlCreateButton("Сохранить", 8, 570, 90, 25)
GUICtrlSetOnEvent(-1, "Button4Click")
$Combo7 = GUICtrlCreateCombo("", 616, 570, 59, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "=|>|<|>=|<=|<>", "=")
GUICtrlSetOnEvent(-1, "Combo7Change")
$Combo3 = GUICtrlCreateCombo("", 682, 570, 53, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "=|>|<|>=|<=|<>", "=")
GUICtrlSetOnEvent(-1, "Combo3Change")
$Combo4 = GUICtrlCreateCombo("", 742, 570, 35, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "=|>|<|>=|<=|<>", "=")
GUICtrlSetOnEvent(-1, "Combo4Change")
$Combo5 = GUICtrlCreateCombo("", 785, 570, 35, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "=|>|<|>=|<=|<>", "=")
GUICtrlSetOnEvent(-1, "Combo5Change")
$Combo6 = GUICtrlCreateCombo("", 828, 570, 55, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "=|>|<|>=|<=|<>", "=")
GUICtrlSetOnEvent(-1, "Combo6Change")
$Combo8 = GUICtrlCreateCombo("", 892, 570, 35, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "=|>|<|>=|<=|<>", "=")
GUICtrlSetOnEvent(-1, "Combo8Change")
$Combo9 = GUICtrlCreateCombo("", 936, 570, 35, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "=|>|<|>=|<=|<>", "=")
GUICtrlSetOnEvent(-1, "Combo9Change")
$Input22 = GUICtrlCreateInput("", 140, 490, 50, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Input4 = GUICtrlCreateInput("", 248, 490, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Label27 = GUICtrlCreateLabel("Наименование продукта", 39, 520, 240, 17, $SS_CENTER)
$Label29 = GUICtrlCreateLabel("Содержание в 100г продукта:", 455, 520, 154, 17, $SS_CENTER)
$Label30 = GUICtrlCreateLabel("КК", 682, 520, 53, 17, $SS_CENTER)
$Label31 = GUICtrlCreateLabel("Белки", 742, 520, 35, 17)
$Label32 = GUICtrlCreateLabel("Жиры", 785, 520, 35, 17)
$Label33 = GUICtrlCreateLabel("Углеводы", 828, 520, 55, 17)
$Label35 = GUICtrlCreateLabel("Грамм", 91, 492, 38, 17)
$Label37 = GUICtrlCreateLabel("Порция гр.", 616, 520, 59, 17, $SS_CENTER)
$Label38 = GUICtrlCreateLabel("ГИ", 892, 520, 35, 17, $SS_CENTER)
$Button5 = GUICtrlCreateButton("Удалить", 108, 570, 90, 25)
GUICtrlSetOnEvent(-1, "Button5Click")
$Button1 = GUICtrlCreateButton("Сброс параметров поиска", 448, 570, 160, 25)
GUICtrlSetOnEvent(-1, "Button1Click")
$Label1 = GUICtrlCreateLabel("ИИ", 936, 520, 35, 17, $SS_CENTER)
$ListView1 = GUICtrlCreateListView("Наименование продукта|Граммы|КК|Белки|Жиры|Углеводы|ГИ|ИИ", 4, 332, 968, 150)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 600)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 60)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 55)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 45)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 47)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 70)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 35)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 7, 35)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView1), 1, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView1), 2, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView1), 3, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView1), 4, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView1), 5, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView1), 6, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($ListView1), 7, 2)
$List1 = GUICtrlCreateList("", 4, 32, 120, 240)
GUICtrlSetOnEvent(-1, "List1Click")
$Label2 = GUICtrlCreateLabel("Пользователи", 4, 10, 120, 17, $SS_CENTER)
$Button11 = GUICtrlCreateButton("Добавить", 8, 488, 75, 25)
GUICtrlSetOnEvent(-1, "Button11Click")
$Label34 = GUICtrlCreateLabel("Порций", 199, 492, 41, 17)
$Button7 = GUICtrlCreateButton("Автоподбор", 300, 488, 80, 25)
GUICtrlSetOnEvent(-1, "Button7Click")
$Input8 = GUICtrlCreateInput("", 388, 490, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
$Label57 = GUICtrlCreateLabel("грамм", 432, 492, 37, 17)
$Label58 = GUICtrlCreateLabel("™", 7, 520, 22, 17, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "Label58Click")
$Label59 = GUICtrlCreateLabel("", 488, 492, 482, 17, $SS_CENTER)
$Date2 = GUICtrlCreateDate("2011/10/16 22:31:11", 4, 303, 120, 21)
GUICtrlSetOnEvent(-1, "Date2Change")
$Label60 = GUICtrlCreateLabel("Данные на", 4, 280, 120, 17, $SS_CENTER)
$Button14 = GUICtrlCreateButton("Справка", 280, 570, 75, 25)
GUICtrlSetOnEvent(-1, "Button14Click")
$Checkbox1 = GUICtrlCreateCheckbox("Только каллории", 300, 520, 121, 17)
GUICtrlSetOnEvent(-1, "Checkbox1Click")
GUISetState(@SW_SHOW)


GUICtrlSetState($Button15, $GUI_HIDE)
GUICtrlSetState($Button16, $GUI_HIDE)
GUICtrlSetState($Button17, $GUI_HIDE)
GUICtrlSetState($Label61, $GUI_HIDE)
GUICtrlSetState($Input11, $GUI_HIDE)
GUICtrlSetState($Radio3, $GUI_HIDE)
GUICtrlSetState($Radio4, $GUI_HIDE)
GUICtrlSetState($Group2, $GUI_HIDE)
GUICtrlSetState($Button14, $GUI_HIDE)



GUICtrlSetState($Input2, $GUI_DISABLE)
GUICtrlSetState($Input3, $GUI_DISABLE)

GUICtrlSetData($Date1, @YEAR&'/'&@MON&'/'&@MDAY)
GUICtrlSetData($Date2, @YEAR&'/'&@MON&'/'&@MDAY)

$sJulDate = _DateToDayValue(@YEAR, @MON, @MDAY)
Dim $YEAR, $MON, $MDAY
$sJulDate = _DayValueToDate($sJulDate-1, $YEAR, $MON, $MDAY)
GUICtrlSetData($Date3, $YEAR&'/'&$MON&'/'&$MDAY)

_GUICtrlListView_RegisterSortCallBack($ListView1)
_GUICtrlListView_RegisterSortCallBack($ListView2)
_GUICtrlListView_RegisterSortCallBack($ListView3)


;~ _SQLite_Exec(-1, 'BEGIN;')
;~ _SQLite_GetTable2d (-1, "SELECT FoodName, ProteinIn100g, FatIn100g, CarbohydrateIn100g FROM Food;", $aResult, $iRows, $iColumns)
;~ For $Num=1 To UBound($aResult)-1
;~ _SQLite_Exec(-1, "Update Food SET KKIn100g='"&$aResult[$Num][1]*4+$aResult[$Num][2]*9+$aResult[$Num][3]*4&"' WHERE FoodName='"&$aResult[$Num][0]&"' ;" )
;~ Next
;~ _SQLite_Exec(-1, 'COMMIT;')

ToolTipEx('Загрузка базы.')
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
_SQLite_GetTable2d($MainstreamSQL, "SELECT FoodName, GramPerUnit, KKIn100g, ProteinIn100g, FatIn100g, CarbohydrateIn100g, Glycemic, Insulinemic FROM Food ORDER BY FoodName;", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'COMMIT;')
_GUICtrlListView_BeginUpdate($ListView1)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6]&'|'&$aResult[$Num][7], $ListView1)
Next
_GUICtrlListView_EndUpdate($ListView1)
ToolTipEx('')

_SQLite_Exec($MainstreamSQL, 'BEGIN;')
_SQLite_GetTable2d($MainstreamSQL, "SELECT UserName, MAX (DATE) FROM Users GROUP BY UserName;", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'COMMIT;')
If UBound($aResult)>1 Then
	ToolTipEx('Загрузка пользователей.')
 _GUICtrlListBox_BeginUpdate($List1)
For $Num=1 To UBound($aResult)-1
GUICtrlSetData($List1, $aResult[$Num][0])
Next
 _GUICtrlListBox_EndUpdate($List1)
	ToolTipEx('')
If UBound($aResult)=2 Then _GUICtrlListBox_ClickItem($List1, 0)
EndIf

ToolTipEx('Загрузка ссылок.')
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
_SQLite_GetTable2d($MainstreamSQL, "SELECT Description, Link FROM Links ORDER BY Description;", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'COMMIT;')
_GUICtrlListView_BeginUpdate($ListView3)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1], $ListView3)
Next
_GUICtrlListView_EndUpdate($ListView3)
ToolTipEx('')



GUIRegisterMsg($WM_NOTIFY, "ListView1Click")

AdlibRegister('AutoSearch', $AutoSearchTime)



While 1
	Sleep(100)
	If $iOne_Click_Event_ListView1 Then
        $iOne_Click_Event_ListView1 = 0
        ListView1ItemClick()
    EndIf

    If $iDouble_Click_Event_ListView1 Then
        $iDouble_Click_Event_ListView1 = 0
        ListView1ItemDoubleClick()
    EndIf

	If $Click_On_Column_Head_Event_ListView1<>-1 Then
		$Click_On_Column_Head_Event_ListView1=-1
		ListView1HeadClick()
	EndIf


	If $iOne_Click_Event_ListView2 Then
        $iOne_Click_Event_ListView2 = 0
        ListView2ItemClick()
    EndIf

    If $iDouble_Click_Event_ListView2 Then
        $iDouble_Click_Event_ListView2 = 0
        ListView2ItemDoubleClick()
    EndIf

	If $Click_On_Column_Head_Event_ListView2<>-1 Then
		$Click_On_Column_Head_Event_ListView2=-1
		ListView2HeadClick()
	EndIf


	If $iOne_Click_Event_ListView3 Then
        $iOne_Click_Event_ListView3 = 0
        ListView3ItemClick()
    EndIf

    If $iDouble_Click_Event_ListView3 Then
        $iDouble_Click_Event_ListView3 = 0
        ListView3ItemDoubleClick()
    EndIf

	If $Click_On_Column_Head_Event_ListView3<>-1 Then
		$Click_On_Column_Head_Event_ListView3=-1
		ListView3HeadClick()
	EndIf
WEnd



;~ -----------------------------------------------------------------------------Button1Click----------------------------------------------------------------------------
Func Button1Click()
ToolTipEx('Загрузка базы.')

For $Num=0 To 7
_GUICtrlHeader_SetItemFormat(_GUICtrlListView_GetHeader($ListView1), $Num, BitAND(_GUICtrlHeader_GetItemFormat(_GUICtrlListView_GetHeader($ListView1), $Num), BitNOT(BitOR($HDF_SORTDOWN, $HDF_SORTUP))))
Next

AdlibUnRegister('AutoSearch')

GUICtrlSetData($Input16, '')
GUICtrlSetData($Input24, '')
GUICtrlSetData($Input18, '')
GUICtrlSetData($Input19, '')
GUICtrlSetData($Input20, '')
GUICtrlSetData($Input21, '')
GUICtrlSetData($Input25, '')
GUICtrlSetData($Input1, '')

$LastInput16=''
$LastInput24=''
$LastInput18=''
$LastInput19=''
$LastInput20=''
$LastInput21=''
$LastInput25=''
$LastInput1=''

_SQLite_Exec($MainstreamSQL, 'BEGIN;')
_SQLite_GetTable2d($MainstreamSQL, "SELECT FoodName, GramPerUnit, KKIn100g, ProteinIn100g, FatIn100g, CarbohydrateIn100g, Glycemic, Insulinemic FROM Food ORDER BY FoodName;", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
_GUICtrlListView_BeginUpdate($ListView1)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6]&'|'&$aResult[$Num][7], $ListView1)
Next
_GUICtrlListView_EndUpdate($ListView1)

AdlibRegister('AutoSearch', $AutoSearchTime)
ToolTipEx('')
EndFunc



;~ -----------------------------------------------------------------------------Button2Click----------------------------------------------------------------------------
Func Button2Click()
$Count=True
Button3Click()
EndFunc



;~ -----------------------------------------------------------------------------Button3Click----------------------------------------------------------------------------
Func Button3Click()

$Username=StringReplace(GUICtrlRead($Input12), "'", "’")

$Sex=GUICtrlRead($Combo1)

$Birthd=DateConvert(GUICtrlRead($Date1))
$Birthday=$Birthd[2]&'/'&$Birthd[1]&'/'&$Birthd[0]
$Age=_DateDiff('Y', $Birthday, @YEAR&'/'&@MON&'/'&@MDAY)

$Growth=StringRegExpReplace(StringStripWS(GUICtrlRead($Input13), 3), '[^0-9]', '.')
$Growth=ZeroCut($Growth)
$GrowthPart=StringSplit($Growth, '.')

$Weight=StringRegExpReplace(StringStripWS(GUICtrlRead($Input14), 3), '[^0-9]', '.')
$Weight=ZeroCut($Weight)
$WeightPart=StringSplit($Weight, '.')

$Formula=_GUICtrlComboBox_GetCurSel($Combo10)

$SelfCount=StringRegExpReplace(StringStripWS(GUICtrlRead($Input3), 3), '[^0-9]', '.')
$SelfCount=ZeroCut($SelfCount)
$SelfCountPart=StringSplit($SelfCount, '.')

$Activity=_GUICtrlComboBox_GetCurSel($Combo13)

$Change=GUICtrlRead($Combo2)
If $Change='норму' Then GUICtrlSetData($Input2, '')

$ChangePercent=StringRegExpReplace(StringStripWS(GUICtrlRead($Input2), 3), '[^0-9]', '.')
$ChangePercent=ZeroCut($ChangePercent)
$ChangePercentPart=StringSplit($ChangePercent, '.')

$ProteinPercent=StringRegExpReplace(StringStripWS(GUICtrlRead($Input5), 3), '[^0-9]', '.')
$ProteinPercent=ZeroCut($ProteinPercent)
$ProteinPercentPart=StringSplit($ProteinPercent, '.')

$FatPercent=StringRegExpReplace(StringStripWS(GUICtrlRead($Input6), 3), '[^0-9]', '.')
$FatPercent=ZeroCut($FatPercent)
$FatPercentPart=StringSplit($FatPercent, '.')

$CarbohydratePercent=StringRegExpReplace(StringStripWS(GUICtrlRead($Input7), 3), '[^0-9]', '.')
$CarbohydratePercent=ZeroCut($CarbohydratePercent)
$CarbohydratePercentPart=StringSplit($CarbohydratePercent, '.')



Select
Case $UserName=''
	MsgBoxEx(16, $FormCaption, 'Не указано имя пользователя.')
	Return 0

Case $Sex=''
	MsgBoxEx(16, $FormCaption, 'Не указан пол пользователя.')
	Return 0

Case $Age<=0
	MsgBoxEx(16, $FormCaption, 'Неверно указана дата рождения пользователя.')
	Return 0

;~ Рост
Case StringIsDigit($GrowthPart[1])=0
	MsgBoxEx(16, $FormCaption, 'Рост должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $GrowthPart[0]=2 And (StringIsDigit($GrowthPart[1])=0 Or StringIsDigit($GrowthPart[2])=0)
	MsgBoxEx(16, $FormCaption, 'Рост должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $GrowthPart[0]>2 And StringIsDigit($GrowthPart[2])=0
	MsgBoxEx(16, $FormCaption, 'В поле "Рост" содержится более одного десятичного разделителя.')
	Return 0

;~ Вес
Case StringIsDigit($WeightPart[1])=0
	MsgBoxEx(16, $FormCaption, 'Вес должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $WeightPart[0]=2 And (StringIsDigit($WeightPart[1])=0 Or StringIsDigit($WeightPart[2])=0)
	MsgBoxEx(16, $FormCaption, 'Вес должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $WeightPart[0]>2 And StringIsDigit($WeightPart[2])=0
	MsgBoxEx(16, $FormCaption, 'В поле "Вес" содержится более одного десятичного разделителя.')
	Return 0

Case $ProteinPercent+$FatPercent+$CarbohydratePercent<>100
	MsgBoxEx(16, $FormCaption, 'Сумма процентного соотношения белков жиров и углеводов должна равняться 100.')
	Return 0

;~ Белки
Case StringIsDigit($ProteinPercentPart[1])=0
	MsgBoxEx(16, $FormCaption, 'Процент белков должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $ProteinPercentPart[0]=2 And (StringIsDigit($ProteinPercentPart[1])=0 Or StringIsDigit($ProteinPercentPart[2])=0)
	MsgBoxEx(16, $FormCaption, 'Процент белков должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $ProteinPercentPart[0]>2 And StringIsDigit($ProteinPercentPart[2])=0
	MsgBoxEx(16, $FormCaption, 'В поле "Белки" содержится более одного десятичного разделителя.')
	Return 0

;~ Жиры
Case StringIsDigit($FatPercentPart[1])=0
	MsgBoxEx(16, $FormCaption, 'Процент жиров должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $FatPercentPart[0]=2 And (StringIsDigit($FatPercentPart[1])=0 Or StringIsDigit($FatPercentPart[2])=0)
	MsgBoxEx(16, $FormCaption, 'Процент жиров должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $FatPercentPart[0]>2 And StringIsDigit($FatPercentPart[2])=0
	MsgBoxEx(16, $FormCaption, 'В поле "Жиры" содержится более одного десятичного разделителя.')
	Return 0

;~ Углеводы
Case StringIsDigit($CarbohydratePercentPart[1])=0
	MsgBoxEx(16, $FormCaption, 'Процент углеводов должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $CarbohydratePercentPart[0]=2 And (StringIsDigit($CarbohydratePercentPart[1])=0 Or StringIsDigit($CarbohydratePercentPart[2])=0)
	MsgBoxEx(16, $FormCaption, 'Процент углеводов должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $CarbohydratePercentPart[0]>2 And StringIsDigit($CarbohydratePercentPart[2])=0
	MsgBoxEx(16, $FormCaption, 'В поле "Углеводы" содержится более одного десятичного разделителя.')
	Return 0
EndSelect

;~ Килокалории при саморасчете
If $Formula=2 Then
Select
Case StringIsDigit($SelfCountPart[1])=0
	MsgBoxEx(16, $FormCaption, 'Количество килокалорий должно быть указано в цифрах, десятичные указываются после точки.')
	Return 0

Case $SelfCountPart[0]=2 And (StringIsDigit($SelfCountPart[1])=0 Or StringIsDigit($SelfCountPart[2])=0)
	MsgBoxEx(16, $FormCaption, 'Количество килокалорий должно быть указано в цифрах, десятичные указываются после точки.')
	Return 0

Case $SelfCountPart[0]>2 And StringIsDigit($SelfCountPart[2])=0
	MsgBoxEx(16, $FormCaption, 'В поле "КК при саморасчете" содержится более одного десятичного разделителя.')
	Return 0
EndSelect
 EndIf

;~  Уровень изменения килокалорий
If $Formula<>2 And $Change<>'норму' Then
Select
Case StringIsDigit($ChangePercentPart[1])=0
	MsgBoxEx(16, $FormCaption, 'Процент дефицита/профицита килокалорий должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $ChangePercentPart[0]=2 And (StringIsDigit($ChangePercentPart[1])=0 Or StringIsDigit($ChangePercentPart[2])=0)
	MsgBoxEx(16, $FormCaption, 'Процент дефицита/профицита килокалорий должен быть указан в цифрах, десятичные указываются после точки.')
	Return 0

Case $ChangePercentPart[0]>2 And StringIsDigit($ChangePercentPart[2])=0
	MsgBoxEx(16, $FormCaption, 'В поле количества дефицита/профицита килокалорий содержится более одного десятичного разделителя.')
	Return 0
EndSelect
EndIf

If $Change='дефицит' And $ChangePercent>25 Then MsgBoxEx(48, $FormCaption, 'Не рекомендуется отнимать от дневной нормы потребления более 25% килокалорий, оптимальное значение 15-25%.')

$BF=BFCount($Sex, $Age, $Growth, $Weight, $Formula, $SelfCount, $Activity, $Change, $ChangePercent, $ProteinPercent, $FatPercent, $CarbohydratePercent)

If $Count=True Then
	$Count=False
GUICtrlSetData($Label46, $BF[0])
GUICtrlSetData($Label47, $BF[1])
GUICtrlSetData($Label48, $BF[2])
GUICtrlSetData($Label49, $BF[3])
	Return 0
EndIf

GUICtrlSetData($Date2, @YEAR&'/'&@MON&'/'&@MDAY)

;~ _SQLite_Exec(-1, "Create Table Users            (   UserName ,         UserNameIndex VARCHAR NOT NULL,           Birthday ,         Date DATE NOT NULL,           Age,         Sex ,       Growth ,       Weight ,       Formula ,       Activity ,       Change ,       ChangePercent,    CaloriesMAX,CaloriesUsed,ProteinMAX,ProteinUsed,ProteinPercent, FatMax,  FatUsed,   FatPercent, CarbohydrateMax,CarbohydrateUsed,CarbohydratePercent, UNIQUE(UserName, DATE));")
 If Not _SQLite_Exec($MainstreamSQL, "Insert into Users values ('"&$Username&"', '"&_StringToHex(StringLower($Username))&"', '"&$Birthday&"', '"&@YEAR&'/'&@MON&'/'&@MDAY&"', '"&$Age&"', '"&$Sex&"',  '"&$Growth&"', '"&$Weight&"', '"&$Formula&"', '"&$Activity&"', '"&$Change&"', '"&$ChangePercent&"', '"&$BF[0]&"', '0', '"&$BF[1]&"', '0', '"&$ProteinPercent&"', '"&$BF[2]&"', '0', '"&$FatPercent&"', '"&$BF[3]&"', '0', '"&$CarbohydratePercent&"');" ) = $SQLITE_OK Then
	If SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), 'Пользователь с таким именем уже существует, перезаписать сведения?')=7 Then Return 0
_SQLite_Exec($MainstreamSQL, "Update Users SET Birthday='"&$Birthday&"', Age='"&$Age&"', Sex='"&$Sex&"', Growth='"&$Growth&"', Weight='"&$Weight&"', Formula='"&$Formula&"', Activity='"&$Activity&"', Change='"&$Change&"', ChangePercent='"&$ChangePercent&"', CaloriesMAX='"&$BF[0]&"', ProteinMAX='"&$BF[1]&"', ProteinPercent='"&$ProteinPercent&"', FatMax='"&$BF[2]&"', FatPercent='"&$FatPercent&"', CarbohydrateMax='"&$BF[3]&"', CarbohydratePercent='"&$CarbohydratePercent&"' WHERE UserName='"&$UserName&"' AND Date='"&@YEAR&'/'&@MON&'/'&@MDAY&"' ;" )
 EndIf

_GUICtrlListBox_ResetContent($List1)
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
_SQLite_GetTable2d($MainstreamSQL, "SELECT UserName, MAX (DATE) FROM Users GROUP BY UserName;", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'COMMIT;')
If UBound($aResult)>1 Then
 _GUICtrlListBox_BeginUpdate($List1)
For $Num=1 To UBound($aResult)-1
GUICtrlSetData($List1, $aResult[$Num][0])
Next
 _GUICtrlListBox_EndUpdate($List1)
If UBound($aResult)=2 Then _GUICtrlListBox_ClickItem($List1, 0)
EndIf
EndFunc



;~ -----------------------------------------------------------------------------Button4Click----------------------------------------------------------------------------
Func Button4Click()

$ProduktName=StringStripWS(StringReplace(GUICtrlRead($Input16), "'", "’"), 2)

$GramPerUnit=StringRegExpReplace(StringStripWS(GUICtrlRead($Input24), 3), '[^0-9]', '.')
$GramPerUnit=ZeroCut($GramPerUnit)
$GramPerUnitPart=StringSplit($GramPerUnit, '.')

;~ $KK=StringRegExpReplace(StringStripWS(GUICtrlRead($Input18), 3), '[^0-9]', '.')
;~ $KK=ZeroCut($KK)
;~ $KKPart=StringSplit($KK, '.')

$Protein=StringRegExpReplace(StringStripWS(GUICtrlRead($Input19), 3), '[^0-9]', '.')
$Protein=ZeroCut($Protein)
$ProteinPart=StringSplit($Protein, '.')

$Fat=StringRegExpReplace(StringStripWS(GUICtrlRead($Input20), 3), '[^0-9]', '.')
$Fat=ZeroCut($Fat)
$FatPart=StringSplit($Fat, '.')

$Carbohydrate=StringRegExpReplace(StringStripWS(GUICtrlRead($Input21), 3), '[^0-9]', '.')
$Carbohydrate=ZeroCut($Carbohydrate)
$CarbohydratePart=StringSplit($Carbohydrate, '.')

$GlycemicIndex=StringRegExpReplace(StringStripWS(GUICtrlRead($Input25), 3), '[^0-9]', '.')
$InsulemicIndex=StringRegExpReplace(StringStripWS(GUICtrlRead($Input1), 3), '[^0-9]', '.')


Select
Case $ProduktName=''
MsgBoxEx(48, $FormCaption, 'Не указано наименование продукта.')
Return 0

;~ GramPerUnit
Case StringIsDigit($GramPerUnitPart[1])=0
MsgBox(16, $FormCaption, 'Граммы в единице потребляемого продукта должны быть указаны в цифрах, десятичные указываются после точки.')
Return 0

Case $GramPerUnitPart[0]=2 And (StringIsDigit($GramPerUnitPart[1])=0 Or StringIsDigit($GramPerUnitPart[2])=0)
MsgBox(16, $FormCaption, 'Граммы в единице потребляемого продукта должны быть указаны в цифрах, десятичные указываются после точки.')
Return 0

Case $GramPerUnitPart[0]>2
MsgBox(16, $FormCaption, 'В поле ввода количества грамм на единицу потребляемого продукта содержится более одного десятичного разделителя.')
Return 0

;~ KK
;~ Case StringIsDigit($KKPart[1])=0
;~ MsgBox(16, $FormCaption, 'Калорийность продукта должна быть указана в цифрах, десятичные указываются после точки.')
;~ Return 0

;~ Case $KKPart[0]=2 And (StringIsDigit($KKPart[1])=0 Or StringIsDigit($KKPart[2])=0)
;~ MsgBox(16, $FormCaption, 'Калорийность продукта должна быть указана в цифрах, десятичные указываются после точки.')
;~ Return 0

;~ Case $KKPart[0]>2
;~ MsgBox(16, $FormCaption, 'В поле ввода калорийности продукта содержится более одного десятичного разделителя.')
;~ Return 0

;~ Белки
Case StringIsDigit($ProteinPart[1])=0
MsgBoxEx(48, $FormCaption, 'Содержание белков в продукте должно быть указано в цифрах, десятичные указываются после точки.')
Return 0

Case $ProteinPart[0]=2 And (StringIsDigit($ProteinPart[1])=0 Or StringIsDigit($ProteinPart[2])=0)
MsgBoxEx(48, $FormCaption, 'Содержание белков в продукте должно быть указано в цифрах, десятичные указываются после точки.')
Return 0

Case $ProteinPart[0]>2 And StringIsDigit($ProteinPart[2])=0
MsgBoxEx(48, $FormCaption, 'В поле ввода содержании белков продукта содержится более одного десятичного разделителя.')
Return 0

;~ Жиры
Case StringIsDigit($FatPart[1])=0
MsgBoxEx(48, $FormCaption, 'Содержание жиров в продукте должно быть указано в цифрах, десятичные указываются после точки.')
Return 0

Case $FatPart[0]=2 And (StringIsDigit($FatPart[1])=0 Or StringIsDigit($FatPart[2])=0)
MsgBoxEx(48, $FormCaption, 'Содержание жиров в продукте должно быть указано в цифрах, десятичные указываются после точки.')
Return 0

Case $FatPart[0]>2 And StringIsDigit($FatPart[2])=0
MsgBoxEx(48, $FormCaption, 'В поле ввода содержании жиров продукта содержится более одного десятичного разделителя.')
Return 0

;~ Углеводы
Case StringIsDigit($CarbohydratePart[1])=0
MsgBoxEx(48, $FormCaption, 'Содержание углеводов в продукте должно быть указано в цифрах, десятичные указываются после точки.')
Return 0

Case $CarbohydratePart[0]=2 And (StringIsDigit($CarbohydratePart[1])=0 Or StringIsDigit($CarbohydratePart[2])=0)
MsgBoxEx(48, $FormCaption, 'Содержание углеводов в продукте должно быть указано в цифрах, десятичные указываются после точки.')
Return 0

Case $CarbohydratePart[0]>2 And StringIsDigit($CarbohydratePart[2])=0
MsgBoxEx(48, $FormCaption, 'В поле ввода содержании углеводов продукта содержится более одного десятичного разделителя.')
Return 0

Case $GlycemicIndex<>'' And StringIsDigit($GlycemicIndex)=0
MsgBoxEx(48, $FormCaption, 'Гликемический индекс должен быть положительным целым числом.')
Return 0

Case $InsulemicIndex<>'' And StringIsDigit($InsulemicIndex)=0
MsgBoxEx(48, $FormCaption, 'Гликемический индекс должен быть положительным целым числом.')
Return 0
EndSelect

$KK=Round($Protein*4+$Fat*9+$Carbohydrate*4, 2)

;~ _SQLite_Exec(-1, "Create Table Food              (FoodName ,              FoodNameIndex ,                             GramPerUnit ,   KKIn100g  , ProteinIn100g  , FatIn100g  , CarbohydrateIn100g  , Glycemic NUMERIC, Insulinemic NUMERIC);")
If Not _SQLite_Exec($MainstreamSQL, "Insert into Food values ('"&$ProduktName&"', '"&_StringToHex(StringLower($ProduktName))&"', '"&$GramPerUnit&"', '"&$KK&"', '"&$Protein&"', '"&$Fat&"', '"&$Carbohydrate&"', NULL, NULL);" ) = $SQLITE_OK Then
If SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), 'Данный продукт уже есть в базе данных, перезаписать сведения?')=7 Then Return 0
_SQLite_Exec($MainstreamSQL, "Update Food SET GramPerUnit='"&$GramPerUnit&"', KKIn100g='"&$KK&"', ProteinIn100g='"&$Protein&"', FatIn100g='"&$Fat&"', CarbohydrateIn100g='"&$Carbohydrate&"', Glycemic='"&$GlycemicIndex&"', Insulinemic='"&$InsulemicIndex&"' WHERE FoodName='"&$ProduktName&"' ;" )
EndIf

_SQLite_Exec($MainstreamSQL, 'BEGIN;')
If $GlycemicIndex<>'' Then _SQLite_Exec($MainstreamSQL, "Update Food SET Glycemic='"&$GlycemicIndex&"' WHERE FoodName='"&$ProduktName&"'  ;" )
If $GlycemicIndex='' Then _SQLite_Exec($MainstreamSQL, "Update Food SET Glycemic=NULL WHERE FoodName='"&$ProduktName&"'  ;" )
If $InsulemicIndex<>'' Then _SQLite_Exec($MainstreamSQL, "Update Food SET Insulinemic='"&$InsulemicIndex&"' WHERE FoodName='"&$ProduktName&"'  ;" )
If $InsulemicIndex='' Then _SQLite_Exec($MainstreamSQL, "Update Food SET Insulinemic=NULL WHERE FoodName='"&$ProduktName&"' ;" )
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
GUICtrlCreateListViewItem($ProduktName&'|'&$GramPerUnit&'|'&$KK&'|'&$Protein&'|'&$Fat&'|'&$Carbohydrate&'|'&$GlycemicIndex&'|'&$InsulemicIndex, $ListView1)

AdlibUnRegister('AutoSearch')
GUICtrlSetData($Input16, '')
GUICtrlSetData($Input24, '')
GUICtrlSetData($Input18, '')
GUICtrlSetData($Input19, '')
GUICtrlSetData($Input20, '')
GUICtrlSetData($Input21, '')
GUICtrlSetData($Input25, '')
GUICtrlSetData($Input1, '')

$LastInput16=''
$LastInput24=''
$LastInput18=''
$LastInput19=''
$LastInput20=''
$LastInput21=''
$LastInput25=''
$LastInput1=''
AdlibRegister('AutoSearch', $AutoSearchTime)
EndFunc



;~ -----------------------------------------------------------------------------Button5Click----------------------------------------------------------------------------
Func Button5Click()
$SelectItem=_GUICtrlListView_GetItemTextArray($ListView1)

If $SelectItem[1]='' Then
	MsgBoxEx(48, $FormCaption, 'Нет выбранных позиций.')
	Return 0
EndIf

If MsgBoxEx(36, $FormCaption, 'Удалить продукт "'&$SelectItem[1]&'" из базы данных?')=7 Then Return 0
_SQLite_Exec($MainstreamSQL, "DELETE FROM Food WHERE FoodName='"&$SelectItem[1]&"' ;")
_GUICtrlListView_DeleteItemsSelected(GUICtrlGetHandle($ListView1))
EndFunc



;~ -----------------------------------------------------------------------------Button6Click----------------------------------------------------------------------------
Func Button6Click()
$User=GUICtrlRead($List1)
If $User='' Then
	MsgBoxEx(64, $FormCaption, 'Не выбран пользователь.')
	Return 0
EndIf

If MsgBoxEx(36, $FormCaption, 'Удалить пользователя "'&$User&'" из базы данных?')=7 Then Return 0
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
_SQLite_Exec($MainstreamSQL, "DELETE FROM Users WHERE UserName='"&$User&"' ;")
_SQLite_Exec($MainstreamSQL, "DELETE From UsedFood WHERE UserName='"&$User&"' ;" )
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

_GUICtrlListBox_ResetContent($List1)

_SQLite_Exec($MainstreamSQL, 'BEGIN;')
_SQLite_GetTable2d ($MainstreamSQL, "SELECT UserName FROM Users;", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

For $Num=1 To UBound($aResult)-1
GUICtrlSetData($List1, $aResult[$Num][0])
Next
EndFunc



;~ -----------------------------------------------------------------------------Button7Click----------------------------------------------------------------------------
Func Button7Click()
$User=GUICtrlRead($List1)
If $User='' Then
	MsgBoxEx(64, $FormCaption, 'Не выбран пользователь.')
	Return 0
EndIf

For $Num=0 To 7
_GUICtrlHeader_SetItemFormat(_GUICtrlListView_GetHeader($ListView1), $Num, BitAND(_GUICtrlHeader_GetItemFormat(_GUICtrlListView_GetHeader($ListView1), $Num), BitNOT(BitOR($HDF_SORTDOWN, $HDF_SORTUP))))
Next

_GUICtrlListView_SortItems($ListView1, -1)

$Gramm=StringRegExpReplace(StringStripWS(GUICtrlRead($Input8), 3), '[^0-9]', '.')
$GrammPart=StringSplit($Gramm, '.')

Select
Case $Gramm=0
	MsgBoxEx(16, $FormCaption, 'Граммы должны быть больше ноля.')
	Return 0

Case StringIsDigit($GrammPart[1])=0
	MsgBoxEx(16, $FormCaption, 'Граммы должны быть указаны в цифрах, десятичные указываются после точки.')
	Return 0

Case $GrammPart[0]=2 And (StringIsDigit($GrammPart[1])=0 Or StringIsDigit($GrammPart[2])=0)
	MsgBoxEx(16, $FormCaption, 'Граммы должны быть указаны в цифрах, десятичные указываются после точки.')
	Return 0

Case $GrammPart[0]>2 And StringIsDigit($GrammPart[2])=0
	MsgBoxEx(16, $FormCaption, 'В поле "граммы" содержится более одного десятичного разделителя.')
	Return 0
EndSelect

$FoodUnit=Round(100/$Gramm, 2)
$Date=DateConvert(GUICtrlRead($Date2))
$CurrentDate=$Date[2]&'/'&$Date[1]&'/'&$Date[0]

_SQLite_Exec($MainstreamSQL, 'BEGIN;')
If GUICtrlRead($Checkbox1)=$GUI_UNCHECKED Then
_SQLite_GetTable2d($MainstreamSQL, "SELECT Food.FoodName, Food.GramPerUnit, Food.KKIn100g, Food.ProteinIn100g, Food.FatIn100g, Food.CarbohydrateIn100g, Food.Glycemic, Food.Insulinemic FROM Food, Users WHERE Users.Date='"&$CurrentDate&"' AND (Food.KKIn100g<="&$FoodUnit&"*(Users.CaloriesMAX-Users.CaloriesUsed) OR Food.KKIn100g='0') AND (Food.ProteinIn100g<="&$FoodUnit&"*(Users.ProteinMAX-Users.ProteinUsed) OR Food.ProteinIn100g='0') AND (Food.FatIn100g<="&$FoodUnit&"*(Users.FatMax-Users.FatUsed) OR Food.FatIn100g='0') AND (Food.CarbohydrateIn100g<="&$FoodUnit&"*(Users.CarbohydrateMax-Users.CarbohydrateUsed) OR Food.CarbohydrateIn100g='0') GROUP BY FoodName ;", $aResult, $iRows, $iColumns)
Else
_SQLite_GetTable2d($MainstreamSQL, "SELECT Food.FoodName, Food.GramPerUnit, Food.KKIn100g, Food.ProteinIn100g, Food.FatIn100g, Food.CarbohydrateIn100g, Food.Glycemic, Food.Insulinemic FROM Food, Users WHERE Users.Date='"&$CurrentDate&"' AND (Food.KKIn100g<="&$FoodUnit&"*(Users.CaloriesMAX-Users.CaloriesUsed) OR Food.KKIn100g='0') GROUP BY FoodName ;", $aResult, $iRows, $iColumns)
EndIf
_SQLite_Exec($MainstreamSQL, 'COMMIT;')


If UBound($aResult)=1 Then
	MsgBoxEx(64, $FormCaption, 'Подходящих продуктов не найдено.')
	Return 0
EndIf

_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
_GUICtrlListView_BeginUpdate($ListView1)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6]&'|'&$aResult[$Num][7], $ListView1)
Next
_GUICtrlListView_EndUpdate($ListView1)

;~ GUICtrlSetData($Input8, '')
EndFunc



;~ -----------------------------------------------------------------------------Button8Click----------------------------------------------------------------------------
Func Button8Click()
$Select=_GUICtrlComboBox_GetCurSel($Combo11)

Select
	Case $Select=0
	MsgBoxEx(16, $FormCaption, 'Не выбран параметр.')
	Return 0

	Case $Select=1
	If MsgBoxEx(36, $FormCaption, 'Удалить все продукты из базы данных которые не имеют товарного знака "™"?')=7 Then Return 0
	_SQLite_Exec($MainstreamSQL, "DELETE From Food WHERE FoodName NOT LIKE '%™%' ;" )

	ToolTipEx('Загрузка базы.')
	_SQLite_GetTable2d($MainstreamSQL, "SELECT FoodName, GramPerUnit, KKIn100g, ProteinIn100g, FatIn100g, CarbohydrateIn100g, Glycemic, Insulinemic FROM Food WHERE KKIn100g<=(SELECT KKIn100g From Food);", $aResult, $iRows, $iColumns)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
	_GUICtrlListView_BeginUpdate($ListView1)
	For $Num=1 To UBound($aResult)-1
	GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6]&'|'&$aResult[$Num][7], $ListView1)
	Next
	_GUICtrlListView_EndUpdate($ListView1)
	ToolTipEx('')
	MsgBoxEx(64, $FormCaption, 'Продукты удалены.')

	Case $Select=2
	If MsgBoxEx(36, $FormCaption, 'Удалить все продукты из базы данных?')=7 Then Return 0
	_SQLite_Exec($MainstreamSQL, "DELETE From Food ;" )
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
	MsgBoxEx(64, $FormCaption, 'Продукты удалены.')

	Case $Select=3
	ExportFood()

	Case $Select=4
	ImportFood()

	Case $Select=5
	If MsgBoxEx(36, $FormCaption, 'Удалить всех пользователей из базы данных?')=7 Then Return 0
	ToolTipEx('Удаление пользователей.')
	_SQLite_Exec($MainstreamSQL, 'BEGIN;')
	_SQLite_Exec($MainstreamSQL, "DELETE From Users ;" )
	_SQLite_Exec($MainstreamSQL, "DELETE From UsedFood ;" )
	_SQLite_Exec($MainstreamSQL, 'COMMIT;')
	_GUICtrlListBox_ResetContent($List1)
	ToolTipEx('')
	MsgBoxEx(64, $FormCaption, 'Пользователи удалены.')

	Case $Select=6
	ExportUsers()

	Case $Select=7
	ImportUsers()

	Case $Select=8
	If MsgBoxEx(36, $FormCaption, 'Удалить все ссылки из базы данных?')=7 Then Return 0
	_SQLite_Exec($MainstreamSQL, "DELETE From Links ;" )
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView3))
	MsgBoxEx(64, $FormCaption, 'Ссылки удалены.')

	Case $Select=9
	ExportLinks()

	Case $Select=10
	ImportLinks()
EndSelect

_GUICtrlComboBox_SetCurSel($Combo11, 0)
EndFunc



;~ -----------------------------------------------------------------------------Button9Click----------------------------------------------------------------------------
Func Button9Click()
AdlibUnRegister('AutoSearch')

_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView2))

GUICtrlSetData($Input12, '')
_GUICtrlComboBox_SetCurSel($Combo1, 0)
GUICtrlSetData($Date1, @YEAR&'/'&@MON&'/'&@MDAY)
GUICtrlSetData($Input13, '')
GUICtrlSetData($Input14, '')
_GUICtrlComboBox_SetCurSel($Combo10, 0)
GUICtrlSetData($Input3, '')
_GUICtrlComboBox_SetCurSel($Combo13, 0)
_GUICtrlComboBox_SetCurSel($Combo2, 0)
GUICtrlSetData($Input2, '')
GUICtrlSetData($Label46, '')
GUICtrlSetData($Label47, '')
GUICtrlSetData($Label48, '')
GUICtrlSetData($Label49, '')

_GUICtrlListBox_ResetContent($List1)
_SQLite_GetTable2d($MainstreamSQL, "SELECT UserName, MAX (DATE) FROM Users GROUP BY UserName;", $aResult, $iRows, $iColumns)
If UBound($aResult)>1 Then
 _GUICtrlListBox_BeginUpdate($List1)
For $Num=1 To UBound($aResult)-1
GUICtrlSetData($List1, $aResult[$Num][0])
Next
 _GUICtrlListBox_EndUpdate($List1)
 EndIf

 $LastInput12=''
 AdlibRegister('AutoSearch', $AutoSearchTime)
EndFunc



;~ -----------------------------------------------------------------------------Button10Click----------------------------------------------------------------------------
Func Button10Click()
$Link=GUICtrlRead($Input10)
$Description=GUICtrlRead($Input9)

If Not _SQLite_Exec($MainstreamSQL, "Insert into Links values ('"&$Description&"', '"&_StringToHex(StringLower($Description))&"', '"&$Link&"' );" ) = $SQLITE_OK Then
If SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), 'Данная ссылка уже есть в базе данных, перезаписать сведения?')=7 Then Return 0
_SQLite_Exec($MainstreamSQL, "Update Links SET Description='"&$Description&"', DescriptionIndex='"&_StringToHex(StringLower($Description))&"'  WHERE Link='"&$Link&"' ;" )
EndIf

_GUICtrlListView_SortItems($ListView3, -1)
_GUICtrlListView_InsertItem($ListView3, '', 0)
_GUICtrlListView_SetItemText($ListView3, 0, $Description&'|'&$Link, -1)
_GUICtrlListView_Scroll($ListView3, 0, -9999999)

EndFunc



;~ -----------------------------------------------------------------------------Button11Click----------------------------------------------------------------------------
Func Button11Click()
$UserName=GUICtrlRead($List1)
If $UserName='' Then
	MsgBoxEx(64, $FormCaption, 'Не выбран пользователь.')
	Return 0
EndIf

For $Num=0 To 6
_GUICtrlHeader_SetItemFormat(_GUICtrlListView_GetHeader($ListView2), $Num, BitAND(_GUICtrlHeader_GetItemFormat(_GUICtrlListView_GetHeader($ListView2), $Num), BitNOT(BitOR($HDF_SORTDOWN, $HDF_SORTUP))))
Next

$SelectItem=_GUICtrlListView_GetItemTextArray($ListView1)
If $SelectItem[1]='' And _GUICtrlListView_GetItemCount($ListView1)=1 Then
_GUICtrlListView_SetItemSelected($ListView1, 0)
$SelectItem=_GUICtrlListView_GetItemTextArray($ListView1)
EndIf

If $SelectItem[1]='' Then
	MsgBoxEx(16, $FormCaption, 'Не выбран продукт')
	Return 0
EndIf

$Gramm=StringRegExpReplace(StringStripWS(GUICtrlRead($Input22), 3), '[^0-9]', '.')
$FoodUnit=StringRegExpReplace(StringStripWS(GUICtrlRead($Input4), 3), '[^0-9]', '.')

$UnitWeght=-1

Select
	Case $Gramm<>''
	$Unit=$Gramm
	$UnitPart=StringSplit($Unit, '.')

	Case $FoodUnit<>''
	$Unit=$FoodUnit
	$UnitPart=StringSplit($Unit, '.')
	$UnitWeght=$SelectItem[2]

	Case Else
	MsgBoxEx(16, $FormCaption, 'Должен быть указан вес продукта или количество единиц.')
	Return 0
EndSelect


Select
Case StringIsDigit($UnitPart[1])=0
MsgBoxEx(48, $FormCaption, 'Вес продукта или количество единиц должно быть указано в цифрах, десятичные указываются после точки.')
Return 0

Case $UnitPart[0]=2 And (StringIsDigit($UnitPart[1])=0 Or StringIsDigit($UnitPart[2])=0)
MsgBoxEx(48, $FormCaption, 'Вес продукта или количество единиц должно быть указано в цифрах, десятичные указываются после точки.')
Return 0

Case $UnitPart[0]>2 And StringIsDigit($UnitPart[2])=0
MsgBoxEx(48, $FormCaption, 'В поле ввода веса или единицы продукта содержится более одного десятичного разделителя.')
Return 0
EndSelect

ToolTipEx('Добавление продукта в употребленные.')
If $UnitWeght<>-1 Then $Unit=$Unit*$UnitWeght

$CaloriesUsed=Round($SelectItem[3]/100*$Unit, 2)
$ProteinUsed=Round($SelectItem[4]/100*$Unit, 2)
$FatUsed=Round($SelectItem[5]/100*$Unit, 2)
$CarbohydrateUsed=Round($SelectItem[6]/100*$Unit, 2)

$Date=DateConvert(GUICtrlRead($Date2))
$CurrentDate=$Date[2]&'/'&$Date[1]&'/'&$Date[0]


_SQLite_Exec($MainstreamSQL, 'BEGIN;')
Do
_SQLite_GetTable2d($MainstreamSQL, "SELECT MAX (Num) FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $aResult, $iRows, $iColumns)
$Num=1
If UBound($aResult)>1 Then $Num=$aResult[1][0]+1
Until Not StringInStr($Num, '.')
_SQLite_Exec($MainstreamSQL, "Insert into UsedFood values ('"&$UserName&"', '"&$CurrentDate&"', '"&$Num&"', '"&$SelectItem[1]&"', '"&$Unit&"', '"&$CaloriesUsed&"', '"&$ProteinUsed&"', '"&$FatUsed&"', '"&$CarbohydrateUsed&"' );" )

;~ If Not _SQLite_GetTable2d (-1, "SELECT SUM(CaloriesUsed), SUM(ProteinUsed), SUM(FatUsed), SUM(CarbohydrateUsed) FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $UsedArr, $iRows, $iColumns)=$SQLITE_OK Then SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), '2')
_SQLite_GetTable2d($MainstreamSQL, "SELECT SUM(CaloriesUsed), SUM(ProteinUsed), SUM(FatUsed), SUM(CarbohydrateUsed) FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $UsedArr, $iRows, $iColumns)

_SQLite_Exec($MainstreamSQL, "Update Users SET CaloriesUsed='"&$UsedArr[1][0]&"', ProteinUsed='"&$UsedArr[1][1]&"', FatUsed='"&$UsedArr[1][2]&"', CarbohydrateUsed='"&$UsedArr[1][3]&"' WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;" )

If Not _SQLite_GetTable2d($MainstreamSQL, "SELECT CaloriesMAX-CaloriesUsed, ProteinMAX-ProteinUsed, FatMax-FatUsed, CarbohydrateMax-CarbohydrateUsed FROM Users WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $aResult, $iRows, $iColumns)=$SQLITE_OK Then SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), '3')
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

GUICtrlSetData($Label36, Round($UsedArr[1][0], 2))
GUICtrlSetData($Label41, Round($UsedArr[1][1], 2))
GUICtrlSetData($Label42, Round($UsedArr[1][2], 2))
GUICtrlSetData($Label43, Round($UsedArr[1][3], 2))

GUICtrlSetData($Label10, Round($aResult[1][0], 2))
GUICtrlSetData($Label11, Round($aResult[1][1], 2))
GUICtrlSetData($Label12, Round($aResult[1][2], 2))
GUICtrlSetData($Label13, Round($aResult[1][3], 2))

If $aResult[1][0]<0 Then GUICtrlSetColor($Label10, 0xFF0000)
If $aResult[1][0]>=0 Then GUICtrlSetColor($Label10, 0x000000)
If $aResult[1][1]<0 Then GUICtrlSetColor($Label11, 0xFF0000)
If $aResult[1][1]>=0 Then GUICtrlSetColor($Label11, 0x000000)
If $aResult[1][2]<0 Then GUICtrlSetColor($Label12, 0xFF0000)
If $aResult[1][2]>=0 Then GUICtrlSetColor($Label12, 0x000000)
If $aResult[1][3]<0 Then GUICtrlSetColor($Label13, 0xFF0000)
If $aResult[1][3]>=0 Then GUICtrlSetColor($Label13, 0x000000)

CountMAX($SelectItem, $aResult)

_GUICtrlListView_InsertItem($ListView2, '', 0)
_GUICtrlListView_SetItemText($ListView2, 0, $Num&'|'&$SelectItem[1]&'|'&$Unit&'|'&$CaloriesUsed&'|'&$ProteinUsed&'|'&$FatUsed&'|'&$CarbohydrateUsed, -1)
_GUICtrlListView_Scroll($ListView2, 0, -9999999)

GUICtrlSetData($Input22, '')
GUICtrlSetData($Input4, '')
ToolTipEx('')
EndFunc



;~ -----------------------------------------------------------------------------Button12Click----------------------------------------------------------------------------
Func Button12Click()
$SelectItem=_GUICtrlListView_GetItemTextArray($ListView3)

If $SelectItem[1]='' Then
	MsgBoxEx(48, $FormCaption, 'Нет выбранных позиций.')
	Return 0
EndIf

If MsgBoxEx(36, $FormCaption, 'Удалить выбранную ссылку из базы данных?')=7 Then Return 0
_SQLite_Exec($MainstreamSQL, "DELETE FROM Links WHERE Link='"&$SelectItem[2]&"' ;")
_GUICtrlListView_DeleteItemsSelected(GUICtrlGetHandle($ListView3))
EndFunc



;~ -----------------------------------------------------------------------------Button13Click----------------------------------------------------------------------------
Func Button13Click()
AdlibUnRegister('AutoSearch')

GUICtrlSetData($Input9, '')
GUICtrlSetData($Input10, '')
$LastInput9=''
$LastInput10=''

ToolTipEx('Загрузка ссылок.')
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView3))
_SQLite_GetTable2d($MainstreamSQL, "SELECT Description, Link FROM Links ORDER BY Link;", $aResult, $iRows, $iColumns)
_GUICtrlListView_BeginUpdate($ListView3)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1], $ListView3)
Next
_GUICtrlListView_EndUpdate($ListView3)
ToolTipEx('')

AdlibRegister('AutoSearch', $AutoSearchTime)
EndFunc



;~ -----------------------------------------------------------------------------Button14Click----------------------------------------------------------------------------
Func Button14Click()
EndFunc



;~ -----------------------------------------------------------------------------Button15Click----------------------------------------------------------------------------
Func Button15Click()
EndFunc



;~ -----------------------------------------------------------------------------Button16Click----------------------------------------------------------------------------
Func Button16Click()
EndFunc



;~ -----------------------------------------------------------------------------ExportFood----------------------------------------------------------------------------
Func ExportFood()
$Path=FileSaveDialog($FormCaption, @ScriptDir, 'Файл базы данных BOF (*.db)', '2', 'Food')
If @error Then Return 0

If FileExists($Path) Then
	If MsgBoxEx(36, $FormCaption, 'Файл с таким именем уже существует, при сохранении он будет заменен новым файлом, продолжить?')=7 Then Return 0
EndIf

ToolTipEx('Дождитесь завершения экспорта.')
$String=StringSplit($Path, '.')
$FileName=$String[1]&'.db'

FileCopy($DBFile, $FileName, 1)
_SQLite_Close()
_SQLite_Open($FileName)

_SQLite_GetTable2d($MainstreamSQL, "SELECT Name From SQLITE_MASTER WHERE Type='table' AND Name<>'Food';", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
For $Num=1 To UBound($aResult)-1
_SQLite_Exec($MainstreamSQL, "Drop Table "&$aResult[$Num][0]&";")
Next
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

_SQLite_Close()
_SQLite_Open($DBFile)
ToolTipEx('')

MsgBoxEx(64, $FormCaption, 'Экспорт произведен в файл '&@CRLF&'"'&$FileName&'"')
EndFunc



;~ -----------------------------------------------------------------------------ImportFood----------------------------------------------------------------------------
Func ImportFood()
$FileName=FileOpenDialog($FormCaption, @ScriptDir, 'Файл базы данных BOF (*.db)', 1, 'Food.db')

_SQLite_Close()
_SQLite_Open($FileName)
_SQLite_GetTable2d($MainstreamSQL, "SELECT Name From SQLITE_MASTER WHERE Type='table' AND Name='Food';", $aResult, $iRows, $iColumns)
If UBound($aResult)=1 Then
	MsgBoxEx(16, $FormCaption, 'Не найдено подходящих данных для импорта в файле '&@CRLF&'"'&$FileName&'"')
	Return 0
EndIf

ToolTipEx('Импорт данных.')
_SQLite_GetTable2d($MainstreamSQL, "SELECT * FROM Food ;", $aResult, $iRows, $iColumns)
_SQLite_Close()

_SQLite_Open($DBFile)
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
For $Num=1 To UBound($aResult)-1
	_SQLite_Exec($MainstreamSQL, "Insert into Food values ('"&$aResult[$Num][0]&"', '"&$aResult[$Num][1]&"', '"&$aResult[$Num][2]&"', '"&$aResult[$Num][3]&"', '"&$aResult[$Num][4]&"', '"&$aResult[$Num][5]&"', '"&$aResult[$Num][6]&"', '"&$aResult[$Num][7]&"', '"&$aResult[$Num][8]&"');" )
Next
_SQLite_Exec($MainstreamSQL, 'COMMIT;')
;~ ToolTipEx('')

ToolTipEx('Загрузка базы.')
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
_SQLite_GetTable2d($MainstreamSQL, "SELECT FoodName, GramPerUnit, KKIn100g, ProteinIn100g, FatIn100g, CarbohydrateIn100g, Glycemic, Insulinemic FROM Food ORDER BY FoodName;", $aResult, $iRows, $iColumns)
_GUICtrlListView_BeginUpdate($ListView1)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6]&'|'&$aResult[$Num][7], $ListView1)
Next
_GUICtrlListView_EndUpdate($ListView1)
ToolTipEx('')

MsgBoxEx(64, $FormCaption, 'Завершен импорт из файла '&@CRLF&'"'&$FileName&'"')
EndFunc



;~ -----------------------------------------------------------------------------ExportUsers----------------------------------------------------------------------------
Func ExportUsers()
$Path=FileSaveDialog($FormCaption, @ScriptDir, 'Файл базы данных BOF (*.db)', '2', 'Users')
If @error Then Return 0

If FileExists($Path) Then
	If MsgBoxEx(36, $FormCaption, 'Файл с таким именем уже существует, при сохранении он будет заменен новым файлом, продолжить?')=7 Then Return 0
EndIf

ToolTipEx('Дождитесь завершения экспорта.')
$String=StringSplit($Path, '.')
$FileName=$String[1]&'.db'

FileCopy($DBFile, $FileName, 1)
_SQLite_Close()
_SQLite_Open($FileName)

_SQLite_GetTable2d($MainstreamSQL, "SELECT Name From SQLITE_MASTER WHERE Type='table' AND Name<>'Users' AND Name<>'UsedFood';", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
For $Num=1 To UBound($aResult)-1
_SQLite_Exec($MainstreamSQL, "Drop Table "&$aResult[$Num][0]&";")
Next
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

_SQLite_Close()
_SQLite_Open($DBFile)
ToolTipEx('')

MsgBoxEx(64, $FormCaption, 'Экспорт произведен в файл '&@CRLF&'"'&$FileName&'"')
EndFunc



;~ -----------------------------------------------------------------------------ImportUsers----------------------------------------------------------------------------
Func ImportUsers()
$FileName=FileOpenDialog($FormCaption, @ScriptDir, 'Файл базы данных BOF (*.db)', 1, 'Users.db')

_SQLite_Close()
_SQLite_Open($FileName)
_SQLite_GetTable2d($MainstreamSQL, "SELECT Name From SQLITE_MASTER WHERE Type='table' AND (Name='Users' OR Name='UsedFood');", $aResult, $iRows, $iColumns)
If UBound($aResult)=1 Then
	MsgBoxEx(16, $FormCaption, 'Не найдено подходящих данных для импорта в файле '&@CRLF&'"'&$FileName&'"')
	Return 0
EndIf

ToolTipEx('Импорт данных.')
Dim $Users, $UsedFood
_SQLite_GetTable2d($MainstreamSQL, "SELECT * FROM Users ;", $Users, $iRows, $iColumns)
_SQLite_GetTable2d($MainstreamSQL, "SELECT * FROM UsedFood ;", $UsedFood, $iRows, $iColumns)
_SQLite_Close()

_SQLite_Open($DBFile)
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
For $Num=1 To UBound($Users)-1
	_SQLite_Exec($MainstreamSQL, "Insert into Users values ('"&$Users[$Num][0]&"', '"&$Users[$Num][1]&"', '"&$Users[$Num][2]&"', '"&$Users[$Num][3]&"', '"&$Users[$Num][4]&"', '"&$Users[$Num][5]&"', '"&$Users[$Num][6]&"', '"&$Users[$Num][7]&"', '"&$Users[$Num][8]&"', '"&$Users[$Num][9]&"', '"&$Users[$Num][10]&"', '"&$Users[$Num][11]&"', '"&$Users[$Num][12]&"', '"&$Users[$Num][13]&"', '"&$Users[$Num][14]&"', '"&$Users[$Num][15]&"', '"&$Users[$Num][16]&"', '"&$Users[$Num][17]&"', '"&$Users[$Num][18]&"', '"&$Users[$Num][19]&"', '"&$Users[$Num][20]&"', '"&$Users[$Num][21]&"', '"&$Users[$Num][22]&"');" )
Next
For $Num=1 To UBound($UsedFood)-1
	_SQLite_Exec($MainstreamSQL, "Insert into UsedFood values ('"&$UsedFood[$Num][0]&"', '"&$UsedFood[$Num][1]&"', '"&$UsedFood[$Num][2]&"', '"&$UsedFood[$Num][3]&"', '"&$UsedFood[$Num][4]&"', '"&$UsedFood[$Num][5]&"', '"&$UsedFood[$Num][6]&"', '"&$UsedFood[$Num][7]&"', '"&$UsedFood[$Num][8]&"');" )
Next
_SQLite_Exec($MainstreamSQL, 'COMMIT;')
;~ ToolTipEx('')

ToolTipEx('Загрузка базы.')
_SQLite_GetTable2d($MainstreamSQL, "SELECT UserName, MAX (DATE) FROM Users GROUP BY UserName;", $aResult, $iRows, $iColumns)
If UBound($aResult)>1 Then
_GUICtrlListBox_ResetContent($List1)
_GUICtrlListBox_BeginUpdate($List1)
For $Num=1 To UBound($aResult)-1
GUICtrlSetData($List1, $aResult[$Num][0])
Next
 _GUICtrlListBox_EndUpdate($List1)
 EndIf
ToolTipEx('')

MsgBoxEx(64, $FormCaption, 'Завершен импорт из Файла '&@CRLF&'"'&$FileName&'"')
EndFunc



;~ -----------------------------------------------------------------------------ExportLinks----------------------------------------------------------------------------
Func ExportLinks()
$Path=FileSaveDialog($FormCaption, @ScriptDir, 'Файл базы данных BOF (*.db)', '2', 'Links')
If @error Then Return 0

If FileExists($Path) Then
	If MsgBoxEx(36, $FormCaption, 'Файл с таким именем уже существует, при сохранении он будет заменен новым файлом, продолжить?')=7 Then Return 0
EndIf

ToolTipEx('Дождитесь завершения экспорта.')
$String=StringSplit($Path, '.')
$FileName=$String[1]&'.db'

FileCopy($DBFile, $FileName, 1)
_SQLite_Close()
_SQLite_Open($FileName)

_SQLite_GetTable2d($MainstreamSQL, "SELECT Name From SQLITE_MASTER WHERE Type='table' AND Name<>'Links' ;", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
For $Num=1 To UBound($aResult)-1
_SQLite_Exec($MainstreamSQL, "Drop Table "&$aResult[$Num][0]&";")
Next
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

_SQLite_Close()
_SQLite_Open($DBFile)
ToolTipEx('')

MsgBoxEx(64, $FormCaption, 'Экспорт произведен в файл '&@CRLF&'"'&$FileName&'"')
EndFunc



;~ -----------------------------------------------------------------------------ImportLinks----------------------------------------------------------------------------
Func ImportLinks()
$FileName=FileOpenDialog($FormCaption, @ScriptDir, 'Файл базы данных BOF (*.db)', 1, 'Links.db')

_SQLite_Close()
_SQLite_Open($FileName)
_SQLite_GetTable2d($MainstreamSQL, "SELECT Name From SQLITE_MASTER WHERE Type='table' AND Name='Links' ;", $aResult, $iRows, $iColumns)
If UBound($aResult)=1 Then
	MsgBoxEx(16, $FormCaption, 'Не найдено подходящих данных для импорта в файле '&@CRLF&'"'&$FileName&'"')
	Return 0
EndIf

ToolTipEx('Импорт данных.')
Dim $Users, $UsedFood
_SQLite_GetTable2d($MainstreamSQL, "SELECT * FROM Links ;", $aResult, $iRows, $iColumns)
_SQLite_Close()

_SQLite_Open($DBFile)
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
For $Num=1 To UBound($Users)-1
	_SQLite_Exec($MainstreamSQL, "Insert into Users values ('"&$aResult[$Num][0]&"', '"&$aResult[$Num][1]&"', '"&$aResult[$Num][2]&"' );" )
Next
_SQLite_Exec($MainstreamSQL, 'COMMIT;')
;~ ToolTipEx('')

ToolTipEx('Загрузка базы.')
_SQLite_GetTable2d($MainstreamSQL, "SELECT Description, Links FROM Links ORDER BY Links;", $aResult, $iRows, $iColumns)
If UBound($aResult)>1 Then
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView3))
_GUICtrlListView_BeginUpdate($ListView3)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1], $ListView3)
Next
_GUICtrlListView_EndUpdate($ListView3)
 EndIf
ToolTipEx('')

MsgBoxEx(64, $FormCaption, 'Завершен импорт из Файла '&@CRLF&'"'&$FileName&'"')
EndFunc



;~ -----------------------------------------------------------------------------Label58Click----------------------------------------------------------------------------
Func Label58Click()
GUICtrlSetData($Input16, StringReplace(GUICtrlRead($Input16), "'", "’")&'™')
EndFunc



;~ -------------------------------------------------------------------------------List1Click------------------------------------------------------------------------------
Func List1Click()
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView2))

$UserName=GUICtrlRead($List1)

_SQLite_Exec($MainstreamSQL, 'BEGIN;')
_SQLite_GetTable2d($MainstreamSQL, "SELECT *, MAX (DATE) FROM Users WHERE UserName='"&$UserName&"';", $aResult, $iRows, $iColumns)
$Date=DateConvert(GUICtrlRead($Date2))
$CurrentDate=$Date[2]&'/'&$Date[1]&'/'&$Date[0]
$Age=_DateDiff('Y', $aResult[1][2], $CurrentDate)
$BF=BFCount($aResult[1][5], $Age, $aResult[1][6], $aResult[1][7], $aResult[1][8], $aResult[1][12], $aResult[1][9], $aResult[1][10], $aResult[1][11], $aResult[1][16], $aResult[1][19], $aResult[1][22])
If Not IsArray($aResult) Then MsgBox(0,'','нет массива')
_SQLite_Exec($MainstreamSQL, "Insert into Users values ('"&$aResult[1][0]&"', '"&$aResult[1][1]&"', '"&$aResult[1][2]&"', '"&$CurrentDate&"', '"&$Age&"', '"&$aResult[1][5]&"', '"&$aResult[1][6]&"', '"&$aResult[1][7]&"', '"&$aResult[1][8]&"', '"&$aResult[1][9]&"', '"&$aResult[1][10]&"', '"&$aResult[1][11]&"', '"&$BF[0]&"', '0', '"&$BF[1]&"', '0', '"&$aResult[1][16]&"', '"&$BF[2]&"', '0', '"&$aResult[1][19]&"', '"&$BF[3]&"', '0', '"&$aResult[1][22]&"');" )


;~ (                         , Birthday,  Sex ,Growth, Weight, Formula, Activity, Change, ChangePercent, CaloriesMAX, CaloriesUsed , ProteinMAX, ProteinUsed, ProteinPercent, FatMax, FatUsed, FatPercent, CarbohydrateMax, CarbohydrateUsed, CarbohydratePercent, UNIQUE(UserName, DATE));")
_SQLite_GetTable2d($MainstreamSQL, "SELECT Birthday, Sex, Growth, Weight, Formula, Activity, Change, ChangePercent, CaloriesMAX, CaloriesUsed, ProteinMAX, ProteinUsed, ProteinPercent, FatMax, FatUsed, FatPercent, CarbohydrateMax, CarbohydrateUsed, CarbohydratePercent FROM Users WHERE UserName='"&$UserName&"' AND Date='"&$CurrentDate&"' ;", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

AdlibUnRegister('AutoSearch')
GUICtrlSetData($Input12, $UserName)
$LastInput12=$UserName
AdlibRegister('AutoSearch', $AutoSearchTime)

GUICtrlSetData($Label54, $UserName)
GUICtrlSetData($Date1, $aResult[1][0])
_GUICtrlComboBox_SelectString($Combo1, $aResult[1][1])
GUICtrlSetData($Input13, $aResult[1][2])
GUICtrlSetData($Input14, $aResult[1][3])
_GUICtrlComboBox_SetCurSel($Combo10, $aResult[1][4])
If $aResult[1][4]=2 Then GUICtrlSetData($Input3, $aResult[1][8])
_GUICtrlComboBox_SetCurSel($Combo13, $aResult[1][5])
_GUICtrlComboBox_SelectString($Combo2, $aResult[1][6])
GUICtrlSetData($Input2, $aResult[1][7])
GUICtrlSetData($Label46, $aResult[1][8]) ;CaloriesMAX
GUICtrlSetData($Label40, $aResult[1][8])
GUICtrlSetData($Label36, $aResult[1][9])
GUICtrlSetData($Label10, Round($aResult[1][8]-$aResult[1][9], 2))
GUICtrlSetData($Label47, $aResult[1][10]) ;ProteinMAX
GUICtrlSetData($Label4, $aResult[1][10])
GUICtrlSetData($Label41, $aResult[1][11])
GUICtrlSetData($Label11, Round($aResult[1][10]-$aResult[1][11], 2))
GUICtrlSetData($Input5, $aResult[1][12])
GUICtrlSetData($Label48, $aResult[1][13]) ;FatMax
GUICtrlSetData($Label8, $aResult[1][13])
GUICtrlSetData($Label42, $aResult[1][14])
GUICtrlSetData($Label12, Round($aResult[1][13]-$aResult[1][14], 2))
GUICtrlSetData($Input6, $aResult[1][15])
GUICtrlSetData($Label49, $aResult[1][16]) ;CarbohydrateMax
GUICtrlSetData($Label6, $aResult[1][16])
GUICtrlSetData($Label43, $aResult[1][17])
GUICtrlSetData($Label13, Round($aResult[1][16]-$aResult[1][17], 2))
GUICtrlSetData($Input7, $aResult[1][18])

If Round($aResult[1][8]-$aResult[1][9], 2)<0 Then GUICtrlSetColor($Label10, 0xFF0000)
If Round($aResult[1][8]-$aResult[1][9], 2)>=0 Then GUICtrlSetColor($Label10, 0x000000)
If Round($aResult[1][10]-$aResult[1][11], 2)<0 Then GUICtrlSetColor($Label11, 0xFF0000)
If Round($aResult[1][10]-$aResult[1][11], 2)>=0 Then GUICtrlSetColor($Label11, 0x000000)
If Round($aResult[1][13]-$aResult[1][14], 2)<0 Then GUICtrlSetColor($Label12, 0xFF0000)
If Round($aResult[1][13]-$aResult[1][14], 2)>=0 Then GUICtrlSetColor($Label12, 0x000000)
If Round($aResult[1][16]-$aResult[1][17], 2)<0 Then GUICtrlSetColor($Label13, 0xFF0000)
If Round($aResult[1][16]-$aResult[1][17], 2)>=0 Then GUICtrlSetColor($Label13, 0x000000)

Combo10Change()
Combo2Change()


_SQLite_GetTable2d($MainstreamSQL, "SELECT Num, FoodName, GramUsed, CaloriesUsed, ProteinUsed, FatUsed, CarbohydrateUsed FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ORDER BY Num DESC;", $aResult, $iRows, $iColumns)
If UBound($aResult)>1 Then
_GUICtrlListView_BeginUpdate($ListView2)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6], $ListView2)
Next
_GUICtrlListView_EndUpdate($ListView2)
EndIf
EndFunc



;~ -----------------------------------------------------------------------------ListViewClick----------------------------------------------------------------------------
Func ListView1Click($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView

	Local $hListView=$ListView1
	If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

	Local $hListView2=$ListView2
	If Not IsHWnd($hListView2) Then $hWndListView2 = GUICtrlGetHandle($hListView2)

	Local $hListView3=$ListView3
	If Not IsHWnd($hListView3) Then $hWndListView3 = GUICtrlGetHandle($hListView3)



    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")

    Switch $hWndFrom
	    Case $hWndListView
            Switch $iCode
                Case $NM_CLICK
                    $iOne_Click_Event_ListView1 = True
                Case $NM_DBLCLK
                    $iDouble_Click_Event_ListView1 = True
				Case $LVN_COLUMNCLICK
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					$Click_On_Column_Head_Event_ListView1=DllStructGetData($tInfo, "SubItem")
				EndSwitch

        Case $hWndListView2
			Switch $iCode
                Case $NM_CLICK
                    $iOne_Click_Event_ListView2 = True
                Case $NM_DBLCLK
                    $iDouble_Click_Event_ListView2 = True
				Case $LVN_COLUMNCLICK
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					$Click_On_Column_Head_Event_ListView2=DllStructGetData($tInfo, "SubItem")
			EndSwitch

        Case $hWndListView3
			Switch $iCode
                Case $NM_CLICK
                    $iOne_Click_Event_ListView3 = True
                Case $NM_DBLCLK
                    $iDouble_Click_Event_ListView3 = True
				Case $LVN_COLUMNCLICK
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					$Click_On_Column_Head_Event_ListView3=DllStructGetData($tInfo, "SubItem")
			EndSwitch

    EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc



;~ -----------------------------------------------------------------------------ListView1ItemClick----------------------------------------------------------------------------
Func ListView1ItemClick()
AdlibUnRegister('AutoSearch')
$SelectItem=_GUICtrlListView_GetItemTextArray($ListView1)

$UserName=GUICtrlRead($List1)
If $UserName<>'' And $SelectItem[1]<>'' Then
$Date=DateConvert(GUICtrlRead($Date2))
$CurrentDate=$Date[2]&'/'&$Date[1]&'/'&$Date[0]

_SQLite_GetTable2d($MainstreamSQL, "SELECT CaloriesMAX-CaloriesUsed, ProteinMAX-ProteinUsed, FatMax-FatUsed, CarbohydrateMax-CarbohydrateUsed FROM Users WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $aResult, $iRows, $iColumns)
$CaloriesMAX=9999999
$ProteinMAX=9999999
$FatMax=9999999
$CarbohydrateMax=9999999

If $SelectItem[3]>0 Then $CaloriesMAX=Round($aResult[1][0]/$SelectItem[3]*100, 2)
If $SelectItem[4]>0 Then $ProteinMAX=Round($aResult[1][1]/$SelectItem[4]*100, 2)
If $SelectItem[5]>0 Then $FatMax=Round($aResult[1][2]/$SelectItem[5]*100, 2)
If $SelectItem[6]>0 Then $CarbohydrateMax=Round($aResult[1][3]/$SelectItem[6]*100, 2)

$MAX=$CaloriesMAX
If $MAX>$ProteinMAX Then $MAX=$ProteinMAX
If $MAX>$FatMax Then $MAX=$FatMax
If $MAX>$CarbohydrateMax Then $MAX=$CarbohydrateMax
If $MAX<0 Then $MAX=0

If GUICtrlRead($Checkbox1)=$GUI_UNCHECKED Then
GUICtrlSetData($Label59, 'Выбранного продукта можно употребить максимум '&$MAX&' грамм или '&Round($MAX/$SelectItem[2], 2)&' порций.')
Else
GUICtrlSetData($Label59, 'Выбранного продукта можно употребить максимум '&Round($aResult[1][0]/$SelectItem[3]*100, 2)&' грамм или '&Round(Round($aResult[1][0]/$SelectItem[3]*100, 2)/$SelectItem[2], 2)&' порций.')
EndIf

EndIf

If $SelectItem[1]<>'' Then
GUICtrlSetData($Input16, $SelectItem[1])
GUICtrlSetData($Input24, $SelectItem[2])
GUICtrlSetData($Input18, $SelectItem[3])
GUICtrlSetData($Input19, $SelectItem[4])
GUICtrlSetData($Input20, $SelectItem[5])
GUICtrlSetData($Input21, $SelectItem[6])
GUICtrlSetData($Input25, $SelectItem[7])
GUICtrlSetData($Input1, $SelectItem[8])

$LastInput16=$SelectItem[1]
$LastInput24=$SelectItem[2]
$LastInput18=$SelectItem[3]
$LastInput19=$SelectItem[4]
$LastInput20=$SelectItem[5]
$LastInput21=$SelectItem[6]
$LastInput25=$SelectItem[7]
$LastInput1=$SelectItem[8]

_ArrayDelete($SelectItem, 0)
$LastListView1=_ArrayToString($SelectItem)
EndIf

AdlibRegister('AutoSearch', $AutoSearchTime)
EndFunc



;~ -----------------------------------------------------------------------------ListView1ItemDoubleClick----------------------------------------------------------------------------
Func ListView1ItemDoubleClick()
$UserName=GUICtrlRead($List1)
If $UserName='' Then
	MsgBoxEx(64, $FormCaption, 'Не выбран пользователь.')
	Return 0
EndIf

ToolTipEx('Добавление продукта в употребленные.')

For $Num=0 To 6
_GUICtrlHeader_SetItemFormat(_GUICtrlListView_GetHeader($ListView2), $Num, BitAND(_GUICtrlHeader_GetItemFormat(_GUICtrlListView_GetHeader($ListView2), $Num), BitNOT(BitOR($HDF_SORTDOWN, $HDF_SORTUP))))
Next

$SelectItem=_GUICtrlListView_GetItemTextArray($ListView1)

$CaloriesUsed=Round($SelectItem[3]/100*$SelectItem[2], 2)
$ProteinUsed=Round($SelectItem[4]/100*$SelectItem[2], 2)
$FatUsed=Round($SelectItem[5]/100*$SelectItem[2], 2)
$CarbohydrateUsed=Round($SelectItem[6]/100*$SelectItem[2], 2)

$Date=DateConvert(GUICtrlRead($Date2))
$CurrentDate=$Date[2]&'/'&$Date[1]&'/'&$Date[0]


;~  _SQLite_Exec(-1, "Create Table UsedFood    (UserName VARCHAR,      DATE DATE,                        time time,             FoodName VARCHAR,     GramUsed NUMERIC,   CaloriesUsed NUMERIC, ProteinUsed NUMERIC, FatUsed NUMERIC, CarbohydrateUsed NUMERIC);")
_SQLite_Exec($MainstreamSQL, 'BEGIN;')
Do
_SQLite_GetTable2d($MainstreamSQL, "SELECT MAX (Num) FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $aResult, $iRows, $iColumns)
$Num=1
If UBound($aResult)>1 Then $Num=$aResult[1][0]+1
Until Not StringInStr($Num, '.')
_SQLite_Exec($MainstreamSQL, "Insert into UsedFood values ('"&$UserName&"', '"&$CurrentDate&"', '"&$Num&"', '"&$SelectItem[1]&"', '"&$SelectItem[2]&"', '"&$CaloriesUsed&"', '"&$ProteinUsed&"', '"&$FatUsed&"', '"&$CarbohydrateUsed&"' );" )
_SQLite_GetTable2d($MainstreamSQL, "SELECT SUM(CaloriesUsed), SUM(ProteinUsed), SUM(FatUsed), SUM(CarbohydrateUsed) FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $UsedArr, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, "Update Users SET CaloriesUsed='"&$UsedArr[1][0]&"', ProteinUsed='"&$UsedArr[1][1]&"', FatUsed='"&$UsedArr[1][2]&"', CarbohydrateUsed='"&$UsedArr[1][3]&"' WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;" )
_SQLite_GetTable2d($MainstreamSQL, "SELECT CaloriesMAX-CaloriesUsed, ProteinMAX-ProteinUsed, FatMax-FatUsed, CarbohydrateMax-CarbohydrateUsed FROM Users WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $aResult, $iRows, $iColumns)
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

GUICtrlSetData($Label36, Round($UsedArr[1][0], 2))
GUICtrlSetData($Label41, Round($UsedArr[1][1], 2))
GUICtrlSetData($Label42, Round($UsedArr[1][2], 2))
GUICtrlSetData($Label43, Round($UsedArr[1][3], 2))

GUICtrlSetData($Label10, Round($aResult[1][0], 2))
GUICtrlSetData($Label11, Round($aResult[1][1], 2))
GUICtrlSetData($Label12, Round($aResult[1][2], 2))
GUICtrlSetData($Label13, Round($aResult[1][3], 2))

If $aResult[1][0]<0 Then GUICtrlSetColor($Label10, 0xFF0000)
If $aResult[1][0]>=0 Then GUICtrlSetColor($Label10, 0x000000)
If $aResult[1][1]<0 Then GUICtrlSetColor($Label11, 0xFF0000)
If $aResult[1][1]>=0 Then GUICtrlSetColor($Label11, 0x000000)
If $aResult[1][2]<0 Then GUICtrlSetColor($Label12, 0xFF0000)
If $aResult[1][2]>=0 Then GUICtrlSetColor($Label12, 0x000000)
If $aResult[1][3]<0 Then GUICtrlSetColor($Label13, 0xFF0000)
If $aResult[1][3]>=0 Then GUICtrlSetColor($Label13, 0x000000)

CountMAX($SelectItem, $aResult)

_GUICtrlListView_InsertItem($ListView2, '', 0)
_GUICtrlListView_SetItemText($ListView2, 0, $Num&'|'&$SelectItem[1]&'|'&$SelectItem[2]&'|'&$CaloriesUsed&'|'&$ProteinUsed&'|'&$FatUsed&'|'&$CarbohydrateUsed, -1)
_GUICtrlListView_Scroll($ListView2, 0, -9999999)
ToolTipEx('')
EndFunc



;~ -----------------------------------------------------------------------------ListView1HeadClick----------------------------------------------------------------------------
Func ListView1HeadClick()
ToolTipEx('Сортировка списка продуктов.')
$Index=GUICtrlGetState($ListView1)
_GUICtrlListView_SortItems($ListView1, $Index)

If _GUICtrlHeader_GetItemFlags(_GUICtrlListView_GetHeader($ListView1), $Index)=4 Then
$Sort='DESC'
Else
$Sort='ASC'
EndIf

Select
	Case $Index=0
	$ColumnName='FoodName'

	Case $Index=1
	$ColumnName='GramPerUnit'

	Case $Index=2
	$ColumnName='KKIn100g'

	Case $Index=3
	$ColumnName='ProteinIn100g'

	Case $Index=4
	$ColumnName='FatIn100g'

	Case $Index=5
	$ColumnName='CarbohydrateIn100g'

	Case $Index=6
	$ColumnName='Glycemic'

	Case $Index=7
	$ColumnName='Insulinemic'
EndSelect

_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
_SQLite_GetTable2d($MainstreamSQL, "SELECT FoodName, GramPerUnit, KKIn100g, ProteinIn100g, FatIn100g, CarbohydrateIn100g, Glycemic, Insulinemic FROM Food ORDER BY "&$ColumnName&" "&$Sort&";", $aResult, $iRows, $iColumns)
_GUICtrlListView_BeginUpdate($ListView1)
For $num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6]&'|'&$aResult[$Num][7], $ListView1)
Next
_GUICtrlListView_EndUpdate($ListView1)
ToolTipEx('')
EndFunc



;~ -----------------------------------------------------------------------------ListView2ItemClick----------------------------------------------------------------------------
Func ListView2ItemClick()
$SelectItem=_GUICtrlListView_GetItemTextArray($ListView2)
If $SelectItem[1]='' Then
GUICtrlSetData($Label65, '')
GUICtrlSetData($Label66, '')
GUICtrlSetData($Label67, '')
GUICtrlSetData($Label68, '')
Return 0
EndIf
AdlibUnRegister('AutoSearch')

ToolTipEx('Поиск продукта.')

_GUICtrlListView_SortItems($ListView1, -1)
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
$LabelText=GUICtrlRead($Label27)
GUICtrlSetData($Label27, 'Поиск')
GUICtrlSetColor($Label27, 0xFF0000)

_SQLite_GetTable2d($MainstreamSQL, "SELECT FoodName, GramPerUnit, KKIn100g, ProteinIn100g, FatIn100g, CarbohydrateIn100g, Glycemic, Insulinemic FROM Food WHERE FoodName='"&$SelectItem[2]&"' ORDER BY FoodName ;", $aResult, $iRows, $iColumns)
If UBound($aResult)=1 Then
ToolTipEx('')
GUICtrlSetData($Label59, '')
GUICtrlSetData($Label27, $LabelText)
GUICtrlSetColor($Label27, 0x000000)
Return 0
EndIf

_GUICtrlListView_BeginUpdate($ListView1)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6]&'|'&$aResult[$Num][7], $ListView1)
Next
_GUICtrlListView_EndUpdate($ListView1)

GUICtrlSetData($Label27, $LabelText)
GUICtrlSetColor($Label27, 0x000000)

$LastListView2=_GUICtrlListView_GetItemTextString($ListView2)

If UBound($aResult)>1 Then
$UserName=GUICtrlRead($List1)
$Date=DateConvert(GUICtrlRead($Date2))
$CurrentDate=$Date[2]&'/'&$Date[1]&'/'&$Date[0]

_SQLite_GetTable2d($MainstreamSQL, "SELECT CaloriesMAX-CaloriesUsed, ProteinMAX-ProteinUsed, FatMax-FatUsed, CarbohydrateMax-CarbohydrateUsed FROM Users WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $UsedArr, $iRows, $iColumns)
$CaloriesMAX=9999999
$ProteinMAX=9999999
$FatMax=9999999
$CarbohydrateMax=9999999

If $SelectItem[4]>0 Then $CaloriesMAX=Round($UsedArr[1][0]/$aResult[1][2]*100, 2)
If $SelectItem[5]>0 Then $ProteinMAX=Round($UsedArr[1][1]/$aResult[1][3]*100, 2)
If $SelectItem[6]>0 Then $FatMax=Round($UsedArr[1][2]/$aResult[1][4]*100, 2)
If $SelectItem[7]>0 Then $CarbohydrateMax=Round($UsedArr[1][3]/$aResult[1][5]*100, 2)

$MAX=$CaloriesMAX
If $MAX>$ProteinMAX Then $MAX=$ProteinMAX
If $MAX>$FatMax Then $MAX=$FatMax
If $MAX>$CarbohydrateMax Then $MAX=$CarbohydrateMax
If $MAX<0 Then $MAX=0

If GUICtrlRead($Checkbox1)=$GUI_UNCHECKED Then
GUICtrlSetData($Label59, 'Выбранного продукта можно употребить максимум '&$MAX&' грамм или '&Round($MAX/$aResult[1][1], 2)&' порций.')
Else
GUICtrlSetData($Label59, 'Выбранного продукта можно употребить максимум '&Round($UsedArr[1][0]/$aResult[1][2]*100, 2)&' грамм или '&Round(Round($UsedArr[1][0]/$aResult[1][2]*100, 2)/$aResult[1][1], 2)&' порций.')
EndIf

EndIf

_SQLite_GetTable2d($MainstreamSQL, "SELECT SUM(CaloriesUsed), SUM(ProteinUsed), SUM(FatUsed), SUM(CarbohydrateUsed) FROM UsedFood WHERE FoodName='"&$SelectItem[2]&"' AND DATE='"&$CurrentDate&"' ;", $aResult, $iRows, $iColumns)
GUICtrlSetData($Label65, $aResult[1][0])
GUICtrlSetData($Label66, $aResult[1][1])
GUICtrlSetData($Label67, $aResult[1][2])
GUICtrlSetData($Label68, $aResult[1][3])


AdlibRegister('AutoSearch', $AutoSearchTime)
ToolTipEx('')
EndFunc



;~ -----------------------------------------------------------------------------ListView2ItemDoubleClick----------------------------------------------------------------------------
Func ListView2ItemDoubleClick()
$UserName=GUICtrlRead($List1)
$SelectItem=_GUICtrlListView_GetItemTextArray($ListView2)

$Date=DateConvert(GUICtrlRead($Date2))
$CurrentDate=$Date[2]&'/'&$Date[1]&'/'&$Date[0]

If GUICtrlRead($Radio1)=$GUI_CHECKED Then
	ToolTipEx('Удаление продукта из списка употребленных.')
	_SQLite_Exec($MainstreamSQL, "DELETE FROM UsedFood WHERE UserName='"&$UserName&"' AND Date='"&$CurrentDate&"' AND Num='"&$SelectItem[1]&"' ;")
Else
	$Date=DateConvert(GUICtrlRead($Date3))
	$RemoveToDate=$Date[2]&'/'&$Date[1]&'/'&$Date[0]

_SQLite_Exec($MainstreamSQL, 'BEGIN;')
If Not _SQLite_GetTable2d($MainstreamSQL, "SELECT *, MAX (DATE) FROM Users WHERE UserName='"&$UserName&"';", $aResult, $iRows, $iColumns)=$SQLITE_OK Then SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), '')
$Age=_DateDiff('Y', $aResult[1][2], $RemoveToDate)
$BF=BFCount($aResult[1][5], $Age, $aResult[1][6], $aResult[1][7], $aResult[1][8], $aResult[1][12], $aResult[1][9], $aResult[1][10], $aResult[1][11], $aResult[1][16], $aResult[1][19], $aResult[1][22])
If Not _SQLite_Exec($MainstreamSQL, "Insert into Users values ('"&$aResult[1][0]&"', '"&$aResult[1][1]&"', '"&$aResult[1][2]&"', '"&$RemoveToDate&"', '"&$Age&"', '"&$aResult[1][5]&"', '"&$aResult[1][6]&"', '"&$aResult[1][7]&"', '"&$aResult[1][8]&"', '"&$aResult[1][9]&"', '"&$aResult[1][10]&"', '"&$aResult[1][11]&"', '"&$BF[0]&"', '0', '"&$BF[1]&"', '0', '"&$aResult[1][16]&"', '"&$BF[2]&"', '0', '"&$aResult[1][19]&"', '"&$BF[3]&"', '0', '"&$aResult[1][22]&"');" )=$SQLITE_OK Then SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), '')

	If $CurrentDate=$RemoveToDate Then
		MsgBoxEx(16, $FormCaption, 'Продукт уже числится на выбранной дате.')
	Return 0
	EndIf
	ToolTipEx('Перевод продукта на '&$Date[0]&'/'&$Date[1]&'/'&$Date[2])
	Do
	If Not _SQLite_GetTable2d($MainstreamSQL, "SELECT MAX (Num) FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$RemoveToDate&"' ;", $aResult, $iRows, $iColumns)=$SQLITE_OK Then SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), '')
	$Num=1
	If UBound($aResult)>1 Then $Num=$aResult[1][0]+1
	Until Not StringInStr($Num, '.')
	_SQLite_Exec($MainstreamSQL, "Update UsedFood SET Date='"&$RemoveToDate&"', Num='"&$Num&"' WHERE UserName='"&$UserName&"' AND Date='"&$CurrentDate&"' AND Num='"&$SelectItem[1]&"' ;")

If Not _SQLite_GetTable2d($MainstreamSQL, "SELECT SUM(CaloriesUsed), SUM(ProteinUsed), SUM(FatUsed), SUM(CarbohydrateUsed) FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$RemoveToDate&"' ;", $UsedArr, $iRows, $iColumns)=$SQLITE_OK Then SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), '')
$CaloriesUsed=Round($UsedArr[1][0], 2)
$ProteinUsed=Round($UsedArr[1][1], 2)
$FatUsed=Round($UsedArr[1][2], 2)
$CarbohydrateUsed=Round($UsedArr[1][3], 2)

_SQLite_Exec($MainstreamSQL, "Update Users SET CaloriesUsed='"&$CaloriesUsed&"', ProteinUsed='"&$ProteinUsed&"', FatUsed='"&$FatUsed&"', CarbohydrateUsed='"&$CarbohydrateUsed&"' WHERE UserName='"&$UserName&"' AND DATE='"&$RemoveToDate&"' ;" )
_SQLite_Exec($MainstreamSQL, 'COMMIT;')
EndIf

_SQLite_Exec($MainstreamSQL, 'BEGIN;')
If Not _SQLite_GetTable2d($MainstreamSQL, "SELECT SUM(CaloriesUsed), SUM(ProteinUsed), SUM(FatUsed), SUM(CarbohydrateUsed) FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $UsedArr, $iRows, $iColumns)=$SQLITE_OK Then SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), '')
$CaloriesUsed=Round($UsedArr[1][0], 2)
$ProteinUsed=Round($UsedArr[1][1], 2)
$FatUsed=Round($UsedArr[1][2], 2)
$CarbohydrateUsed=Round($UsedArr[1][3], 2)

_SQLite_Exec($MainstreamSQL, "Update Users SET CaloriesUsed='"&$CaloriesUsed&"', ProteinUsed='"&$ProteinUsed&"', FatUsed='"&$FatUsed&"', CarbohydrateUsed='"&$CarbohydrateUsed&"' WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;" )
GUICtrlSetData($Label36, $CaloriesUsed)
GUICtrlSetData($Label41, $ProteinUsed)
GUICtrlSetData($Label42, $FatUsed)
GUICtrlSetData($Label43, $CarbohydrateUsed)

If Not _SQLite_GetTable2d($MainstreamSQL, "SELECT CaloriesMAX-CaloriesUsed, ProteinMAX-ProteinUsed, FatMax-FatUsed, CarbohydrateMax-CarbohydrateUsed FROM Users WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ;", $aResult, $iRows, $iColumns)=$SQLITE_OK Then SQLMessage(_SQLite_ErrMsg(), _SQLite_ErrCode(), '')
GUICtrlSetData($Label10, Round($aResult[1][0], 2))
GUICtrlSetData($Label11, Round($aResult[1][1], 2))
GUICtrlSetData($Label12, Round($aResult[1][2], 2))
GUICtrlSetData($Label13, Round($aResult[1][3], 2))
_SQLite_Exec($MainstreamSQL, 'COMMIT;')

If $aResult[1][0]<0 Then GUICtrlSetColor($Label10, 0xFF0000)
If $aResult[1][0]>=0 Then GUICtrlSetColor($Label10, 0x000000)
If $aResult[1][1]<0 Then GUICtrlSetColor($Label11, 0xFF0000)
If $aResult[1][1]>=0 Then GUICtrlSetColor($Label11, 0x000000)
If $aResult[1][2]<0 Then GUICtrlSetColor($Label12, 0xFF0000)
If $aResult[1][2]>=0 Then GUICtrlSetColor($Label12, 0x000000)
If $aResult[1][3]<0 Then GUICtrlSetColor($Label13, 0xFF0000)
If $aResult[1][3]>=0 Then GUICtrlSetColor($Label13, 0x000000)

$SelectItem=_GUICtrlListView_GetItemTextArray($ListView1)
If $SelectItem[1]<>'' Then
CountMAX($SelectItem, $aResult)
EndIf

_GUICtrlListView_DeleteItemsSelected(GUICtrlGetHandle($ListView2))
ToolTipEx('')
EndFunc



;~ -----------------------------------------------------------------------------ListView2HeadClick----------------------------------------------------------------------------
Func ListView2HeadClick()
$UserName=GUICtrlRead($List1)
If $UserName='' Then
	MsgBoxEx(64, $FormCaption, 'Не выбран пользователь.')
	Return 0
EndIf

ToolTipEx('Сортировка списка продуктов.')
$Index=GUICtrlGetState($ListView2)
_GUICtrlListView_SortItems($ListView2, $Index)


If _GUICtrlHeader_GetItemFlags(_GUICtrlListView_GetHeader($ListView2), $Index)=4 Then
$Sort='DESC'
Else
$Sort='ASC'
EndIf

Select
	Case $Index=0
	$ColumnName='Num'

	Case $Index=1
	$ColumnName='FoodName'

	Case $Index=2
	$ColumnName='GramUsed'

	Case $Index=3
	$ColumnName='CaloriesUsed'

	Case $Index=4
	$ColumnName='ProteinUsed'

	Case $Index=5
	$ColumnName='FatUsed'

	Case $Index=6
	$ColumnName='CarbohydrateUsed'
EndSelect

$Date=DateConvert(GUICtrlRead($Date2))
$CurrentDate=$Date[2]&'/'&$Date[1]&'/'&$Date[0]

_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView2))

_SQLite_GetTable2d($MainstreamSQL, "SELECT Num, FoodName, GramUsed, CaloriesUsed, ProteinUsed, FatUsed, CarbohydrateUsed FROM UsedFood WHERE UserName='"&$UserName&"' AND DATE='"&$CurrentDate&"' ORDER BY "&$ColumnName&" "&$Sort&";", $aResult, $iRows, $iColumns)
_GUICtrlListView_BeginUpdate($ListView2)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6], $ListView2)
Next
_GUICtrlListView_EndUpdate($ListView2)
ToolTipEx('')
EndFunc



;~ -----------------------------------------------------------------------------ListView3ItemClick----------------------------------------------------------------------------
Func ListView3ItemClick()
$SelectItem=_GUICtrlListView_GetItemTextArray($ListView3)
If $SelectItem[1]='' Then Return 0
AdlibUnRegister('AutoSearch')

GUICtrlSetData($Input9, $SelectItem[1])
GUICtrlSetData($Input10, $SelectItem[2])

$LastInput9=$SelectItem[1]
$LastInput10=$SelectItem[2]

AdlibRegister('AutoSearch', $AutoSearchTime)
EndFunc



;~ -----------------------------------------------------------------------------ListView3ItemDoubleClick----------------------------------------------------------------------------
Func ListView3ItemDoubleClick()
$SelectItem=_GUICtrlListView_GetItemTextArray($ListView3)
If $SelectItem[1]='' Then Return 0

$Brouser=RegRead('HKLM\SOFTWARE\Clients\StartMenuInternet\'&RegRead('HKCU\SOFTWARE\Clients\StartMenuInternet','')&'\shell\open\command', '')
If StringRegExp($Brouser, '.exe') Then
Run($Brouser&' '&$SelectItem[2])
Else
_RunDOS('"'&@ProgramFilesDir&'\Internet Explorer\iexplore.exe" '&$SelectItem[2])
EndIf
EndFunc



;~ -----------------------------------------------------------------------------ListView3HeadClick----------------------------------------------------------------------------
Func ListView3HeadClick()
ToolTipEx('Сортировка списка ссылок.')
$Index=GUICtrlGetState($ListView3)
_GUICtrlListView_SortItems($ListView3, $Index)

If _GUICtrlHeader_GetItemFlags(_GUICtrlListView_GetHeader($ListView3), $Index)=4 Then
$Sort='DESC'
Else
$Sort='ASC'
EndIf

Select
	Case $Index=0
	$ColumnName='Description'

	Case $Index=1
	$ColumnName='Link'
EndSelect

_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView3))

_SQLite_GetTable2d($MainstreamSQL, "SELECT Description, Link FROM Links ORDER BY "&$ColumnName&" "&$Sort&";", $aResult, $iRows, $iColumns)
_GUICtrlListView_BeginUpdate($ListView3)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1], $ListView3)
Next
_GUICtrlListView_EndUpdate($ListView3)
ToolTipEx('')
EndFunc



;~ -----------------------------------------------------------------------------Combo7Change----------------------------------------------------------------------------
Func Combo7Change()
ExactlySearch(GUICtrlRead($Input24), $Label37, $Combo7, 'GramPerUnit')
EndFunc



;~ -----------------------------------------------------------------------------Combo3Change----------------------------------------------------------------------------
Func Combo3Change()
ExactlySearch(GUICtrlRead($Input18), $Label30, $Combo3, 'KKIn100g')
EndFunc



;~ -----------------------------------------------------------------------------Combo4Change----------------------------------------------------------------------------
Func Combo4Change()
ExactlySearch(GUICtrlRead($Input19), $Label31, $Combo4, 'ProteinIn100g')
EndFunc



;~ -----------------------------------------------------------------------------Combo5Change----------------------------------------------------------------------------
Func Combo5Change()
ExactlySearch(GUICtrlRead($Input20), $Label32, $Combo5, 'FatIn100g')
EndFunc



;~ -----------------------------------------------------------------------------Combo6Change----------------------------------------------------------------------------
Func Combo6Change()
ExactlySearch(GUICtrlRead($Input21), $Label33, $Combo6, 'CarbohydrateIn100g')
EndFunc



;~ -----------------------------------------------------------------------------Combo8Change----------------------------------------------------------------------------
Func Combo8Change()
ExactlySearch(GUICtrlRead($Input25), $Label38, $Combo8, 'Glycemic')
EndFunc



;~ -----------------------------------------------------------------------------Combo9Change----------------------------------------------------------------------------
Func Combo9Change()
ExactlySearch(GUICtrlRead($Input1), $Label1, $Combo9, 'Insulinemic')
EndFunc

;~ -----------------------------------------------------------------------------Combo2Change----------------------------------------------------------------------------
Func Combo2Change()
If GUICtrlRead($Combo2)='норму' Then
GUICtrlSetState($Input2, $GUI_DISABLE)
Else
GUICtrlSetState($Input2, $GUI_ENABLE)
EndIf
EndFunc

;~ -----------------------------------------------------------------------------Combo10Change----------------------------------------------------------------------------
Func Combo10Change()
If _GUICtrlComboBox_GetCurSel($Combo10)=2 Then
GUICtrlSetState($Input3, $GUI_ENABLE)
GUICtrlSetState($Combo13, $GUI_DISABLE)
GUICtrlSetState($Combo2, $GUI_DISABLE)
GUICtrlSetState($Input2, $GUI_DISABLE)
Else
GUICtrlSetState($Input3, $GUI_DISABLE)
GUICtrlSetState($Combo13, $GUI_ENABLE)
GUICtrlSetState($Combo2, $GUI_ENABLE)
GUICtrlSetState($Input2, $GUI_ENABLE)
EndIf
EndFunc



;~ -----------------------------------------------------------------------------Date2Change----------------------------------------------------------------------------
Func Date2Change()
If GUICtrlRead($List1)<>'' Then List1Click()
EndFunc



;~ -----------------------------------------------------------------------------AdlibFunc----------------------------------------------------------------------------
Func AutoSearch()
Select

Case $LastInput12<>StringReplace(GUICtrlRead($Input12), "'", "’")
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView2))
Do
$LastInput12=StringReplace(GUICtrlRead($Input12), "'", "’")
Sleep($SearchPause)
Until $LastInput12=StringReplace(GUICtrlRead($Input12), "'", "’")
LikeSearch2($LastInput12, $Label14, 'UserNameIndex')

Case $LastInput16<>StringReplace(GUICtrlRead($Input16), "'", "’")
Do
$LastInput16=StringReplace(GUICtrlRead($Input16), "'", "’")
Sleep($SearchPause)
Until $LastInput16=StringReplace(GUICtrlRead($Input16), "'", "’")
LikeSearch($LastInput16, $Label27, 'FoodNameIndex')

Case $LastInput9<>StringReplace(GUICtrlRead($Input9), "'", "’")
Do
$LastInput9=StringReplace(GUICtrlRead($Input9), "'", "’")
Sleep($SearchPause)
Until $LastInput9=StringReplace(GUICtrlRead($Input9), "'", "’")
LikeSearch3($LastInput9, $Label62, 'DescriptionIndes')

Case $LastInput10<>GUICtrlRead($Input10)
Do
$LastInput10=GUICtrlRead($Input10)
Sleep($SearchPause)
Until $LastInput10=GUICtrlRead($Input10)
LikeSearch3($LastInput10, $Label63, 'Link')

Case $LastInput24<>StringRegExpReplace(StringStripWS(GUICtrlRead($Input24), 3), '[^0-9]', '.')
Do
$LastInput24=StringRegExpReplace(StringStripWS(GUICtrlRead($Input24), 3), '[^0-9]', '.')
Sleep($SearchPause)
Until $LastInput24=StringRegExpReplace(StringStripWS(GUICtrlRead($Input24), 3), '[^0-9]', '.')
ExactlySearch($LastInput24, $Label37, $Combo7, 'GramPerUnit')

Case $LastInput18<>StringRegExpReplace(StringStripWS(GUICtrlRead($Input18), 3), '[^0-9]', '.')
Do
$LastInput18=StringRegExpReplace(StringStripWS(GUICtrlRead($Input18), 3), '[^0-9]', '.')
Sleep($SearchPause)
Until $LastInput18=StringRegExpReplace(StringStripWS(GUICtrlRead($Input18), 3), '[^0-9]', '.')
ExactlySearch($LastInput18, $Label30, $Combo3, 'KKIn100g')

Case $LastInput19<>StringRegExpReplace(StringStripWS(GUICtrlRead($Input19), 3), '[^0-9]', '.')
Do
$LastInput19=StringRegExpReplace(StringStripWS(GUICtrlRead($Input19), 3), '[^0-9]', '.')
Sleep($SearchPause)
Until $LastInput19=StringRegExpReplace(StringStripWS(GUICtrlRead($Input19), 3), '[^0-9]', '.')
ExactlySearch($LastInput19, $Label31, $Combo4, 'ProteinIn100g')

Case $LastInput20<>StringRegExpReplace(StringStripWS(GUICtrlRead($Input20), 3), '[^0-9]', '.')
Do
$LastInput20=StringRegExpReplace(StringStripWS(GUICtrlRead($Input20), 3), '[^0-9]', '.')
Sleep($SearchPause)
Until $LastInput20=StringRegExpReplace(StringStripWS(GUICtrlRead($Input20), 3), '[^0-9]', '.')
ExactlySearch($LastInput20, $Label32, $Combo5, 'FatIn100g')

Case $LastInput21<>StringRegExpReplace(StringStripWS(GUICtrlRead($Input21), 3), '[^0-9]', '.')
Do
$LastInput21=StringRegExpReplace(StringStripWS(GUICtrlRead($Input21), 3), '[^0-9]', '.')
Sleep($SearchPause)
Until $LastInput21=StringRegExpReplace(StringStripWS(GUICtrlRead($Input21), 3), '[^0-9]', '.')
ExactlySearch($LastInput21, $Label33, $Combo6, 'CarbohydrateIn100g')

Case $LastInput25<>GUICtrlRead($Input25)
Do
$LastInput25=GUICtrlRead($Input25)
Sleep($SearchPause)
Until $LastInput25=GUICtrlRead($Input25)
ExactlySearch($LastInput25, $Label38, $Combo8, 'Glycemic')

Case $LastInput1<>GUICtrlRead($Input1)
Do
$LastInput1=GUICtrlRead($Input1)
Sleep($SearchPause)
Until $LastInput1=GUICtrlRead($Input1)
ExactlySearch($LastInput1, $Label1, $Combo9, 'Insulinemic')

Case $LastListView1<>_GUICtrlListView_GetItemTextString($ListView1)
Do
$LastListView1=_GUICtrlListView_GetItemTextString($ListView1)
Until $LastListView1=_GUICtrlListView_GetItemTextString($ListView1)
ListView1ItemClick()

Case $LastListView2<>_GUICtrlListView_GetItemTextString($ListView2)
Do
$LastListView2=_GUICtrlListView_GetItemTextString($ListView2)
Until $LastListView2=_GUICtrlListView_GetItemTextString($ListView2)
ListView2ItemClick()
EndSelect
EndFunc



;~ -----------------------------------------------------------------------------LikeSearch----------------------------------------------------------------------------
Func LikeSearch($SearchString, $LabelName, $ColumnName)
$AutoSearchSQL=_SQLite_Open($DBFile)
For $Num=0 To 7
_GUICtrlHeader_SetItemFormat(_GUICtrlListView_GetHeader($ListView1), $Num, BitAND(_GUICtrlHeader_GetItemFormat(_GUICtrlListView_GetHeader($ListView1), $Num), BitNOT(BitOR($HDF_SORTDOWN, $HDF_SORTUP))))
Next

$LabelText=GUICtrlRead($LabelName)
GUICtrlSetData($LabelName, 'Поиск')
GUICtrlSetColor($LabelName, 0xFF0000)


_SQLite_GetTable2d ($AutoSearchSQL, "SELECT FoodName, GramPerUnit, KKIn100g, ProteinIn100g, FatIn100g, CarbohydrateIn100g, Glycemic, Insulinemic FROM Food WHERE "&$ColumnName&" LIKE '%"&_StringToHex(StringLower($SearchString))&"%' ORDER BY FoodName ;", $aResult, $iRows, $iColumns)
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
_GUICtrlListView_BeginUpdate($ListView1)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6]&'|'&$aResult[$Num][7], $ListView1)
Next
_GUICtrlListView_EndUpdate($ListView1)

GUICtrlSetData($LabelName, $LabelText)
GUICtrlSetColor($LabelName, 0x000000)
_SQLite_Close($AutoSearchSQL)
EndFunc



;~ -----------------------------------------------------------------------------LikeSearch2----------------------------------------------------------------------------
Func LikeSearch2($SearchString, $LabelName, $ColumnName)
	$AutoSearchSQL=_SQLite_Open($DBFile)
$LabelText=GUICtrlRead($LabelName)
GUICtrlSetData($LabelName, 'Поиск')
GUICtrlSetColor($LabelName, 0xFF0000)


_SQLite_GetTable2d ($AutoSearchSQL, "SELECT UserName FROM Users WHERE "&$ColumnName&" LIKE '%"&_StringToHex(StringLower($SearchString))&"%' ;", $aResult, $iRows, $iColumns)
_GUICtrlListBox_ResetContent($List1)
_GUICtrlListView_BeginUpdate($ListView1)
For $Num=1 To UBound($aResult)-1
GUICtrlSetData($List1, $aResult[$Num][0])
Next
_GUICtrlListView_EndUpdate($ListView1)

GUICtrlSetData($LabelName, $LabelText)
GUICtrlSetColor($LabelName, 0x000000)
_SQLite_Close($AutoSearchSQL)
EndFunc



;~ -----------------------------------------------------------------------------LikeSearch3----------------------------------------------------------------------------
Func LikeSearch3($SearchString, $LabelName, $ColumnName)
	$AutoSearchSQL=_SQLite_Open($DBFile)
$LabelText=GUICtrlRead($LabelName)
GUICtrlSetData($LabelName, 'Поиск')
GUICtrlSetColor($LabelName, 0xFF0000)

;~ _SQLite_Exec(-1, "Create Table IF NOT EXISTS Links (Description VARCHAR NOT NULL, DescriptionIndes VARCHAR NOT NULL, Link VARCHAR NOT NULL UNIQUE);")
If $ColumnName='DescriptionIndes' Then _SQLite_GetTable2d ($AutoSearchSQL, "SELECT Description, Link FROM Links WHERE "&$ColumnName&" LIKE '%"&_StringToHex(StringLower($SearchString))&"%' ;", $aResult, $iRows, $iColumns)
If $ColumnName='Link' Then _SQLite_GetTable2d ($AutoSearchSQL, "SELECT Description, Link FROM Links WHERE "&$ColumnName&" LIKE '%"&$SearchString&"%' ;", $aResult, $iRows, $iColumns)
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView3))
_GUICtrlListView_BeginUpdate($ListView3)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1], $ListView3)
Next
_GUICtrlListView_EndUpdate($ListView3)

GUICtrlSetData($LabelName, $LabelText)
GUICtrlSetColor($LabelName, 0x000000)
_SQLite_Close($AutoSearchSQL)
EndFunc



;~ -----------------------------------------------------------------------------ExactlySearch----------------------------------------------------------------------------
Func ExactlySearch($SearchString, $LabelName, $ComboName, $ColumnName)
$AutoSearchSQL=_SQLite_Open($DBFile)
For $Num=0 To 7
_GUICtrlHeader_SetItemFormat(_GUICtrlListView_GetHeader($ListView1), $Num, BitAND(_GUICtrlHeader_GetItemFormat(_GUICtrlListView_GetHeader($ListView1), $Num), BitNOT(BitOR($HDF_SORTDOWN, $HDF_SORTUP))))
Next

$ComboValue=GUICtrlRead($ComboName)
$LabelText=GUICtrlRead($LabelName)
GUICtrlSetData($LabelName, 'Поиск')
GUICtrlSetColor($LabelName, 0xFF0000)

If ($ColumnName='Glycemic' Or $ColumnName='Insulinemic') And $SearchString='' Then

_SQLite_GetTable2d ($AutoSearchSQL, "SELECT FoodName, GramPerUnit, KKIn100g, ProteinIn100g, FatIn100g, CarbohydrateIn100g, Glycemic, Insulinemic FROM Food WHERE "&$ColumnName&" IS NULL ;", $aResult, $iRows, $iColumns)
Else

_SQLite_GetTable2d ($AutoSearchSQL, "SELECT FoodName, GramPerUnit, KKIn100g, ProteinIn100g, FatIn100g, CarbohydrateIn100g, Glycemic, Insulinemic FROM Food WHERE "&$ColumnName&""&$ComboValue&"'"&$SearchString&"' ORDER BY "&$ColumnName&" ;", $aResult, $iRows, $iColumns)
EndIf

_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView1))
_GUICtrlListView_BeginUpdate($ListView1)
For $Num=1 To UBound($aResult)-1
GUICtrlCreateListViewItem($aResult[$Num][0]&'|'&$aResult[$Num][1]&'|'&$aResult[$Num][2]&'|'&$aResult[$Num][3]&'|'&$aResult[$Num][4]&'|'&$aResult[$Num][5]&'|'&$aResult[$Num][6]&'|'&$aResult[$Num][7], $ListView1)
Next
_GUICtrlListView_EndUpdate($ListView1)

GUICtrlSetData($LabelName, $LabelText)
GUICtrlSetColor($LabelName, 0x000000)
_SQLite_Close($AutoSearchSQL)
EndFunc



;~ -----------------------------------------------------------------------------MsgBoxEx----------------------------------------------------------------------------
Func MsgBoxEx($Flag, $Title, $Text)
GUISetState(@SW_DISABLE)
$Value=MsgBox($Flag, $Title, $Text)
GUISetState(@SW_ENABLE)
GUISetState(@SW_RESTORE)
Return $Value
EndFunc



;~ -----------------------------------------------------------------------------ToolTipEx----------------------------------------------------------------------------
Func ToolTipEx($Text)
If StringLen($Text)>0 Then
GUISetState(@SW_DISABLE)
ToolTip($Text, @DesktopWidth/2, @DesktopHeight/2, $FormCaption, 1, 2)
Else
ToolTip($Text)
GUISetState(@SW_ENABLE)
GUISetState(@SW_RESTORE)
EndIf
EndFunc



;~ -----------------------------------------------------------------------------DateConvert----------------------------------------------------------------------------
Func DateConvert($Date)
$DatePart=StringSplit($Date, ' ')
If StringLen($DatePart[1])=1 Then $DatePart[1]='0'&$DatePart[1]

Select
Case $DatePart[2]='января'
	 $DatePart[2]='01'
Case $DatePart[2]='февраля'
	 $DatePart[2]='02'
Case $DatePart[2]='марта'
	 $DatePart[2]='03'
Case $DatePart[2]='апреля'
	 $DatePart[2]='04'
Case $DatePart[2]='мая'
	 $DatePart[2]='05'
Case $DatePart[2]='июня'
	 $DatePart[2]='06'
Case $DatePart[2]='июля'
	 $DatePart[2]='07'
Case $DatePart[2]='августа'
	 $DatePart[2]='08'
Case $DatePart[2]='сентября'
	 $DatePart[2]='09'
Case $DatePart[2]='октября'
	 $DatePart[2]='10'
Case $DatePart[2]='ноября'
	 $DatePart[2]='11'
Case $DatePart[2]='декабря'
	 $DatePart[2]='12'
 EndSelect
 _ArrayDelete($DatePart, $DatePart[0])
 _ArrayDelete($DatePart, 0)

Return $DatePart
EndFunc



;~ -----------------------------------------------------------------------------BFCount----------------------------------------------------------------------------
Func BFCount($Sex, $Age, $Growth, $Weight, $Formula, $SelfCount, $Activity, $Change, $ChangePercent, $ProteinPercent, $FatPercent, $CarbohydratePercent)
Dim $BFArr[4]

If $Formula<>2 Then
Select
	Case $Formula=0
	If $Sex='Мужской' Then
	$BMR=66+13.7*$Weight+5*$Growth-6.8*$Age
ElseIf $Sex='Женский' Then
	$BMR=655+9.6*$Weight+1.8*$Growth-4.7*$Age
	EndIf

	Case $Formula=1
	If $Sex='Мужской' Then
	$BMR=10*$Weight+6.25*$Growth-5*$Age+5
ElseIf $Sex='Женский' Then
	$BMR=10*$Weight+6.25*$Growth-5*$Age-161
	EndIf

	Case Else
	MsgBox(16, $FormCaption, 'Ошибка при определении формулы подсчета калорий.')
EndSelect

Select
Case $Activity=0
	 $FactorActivity=1.2

Case $Activity=1
	 $FactorActivity=1.375

Case $Activity=2
	 $FactorActivity=1.55

Case $Activity=3
	 $FactorActivity=1.725

Case $Activity=4
	 $FactorActivity=1.9
EndSelect

$TDEE=$BMR*$FactorActivity

If $Change='дефицит' Then $TDEE=$TDEE-$TDEE*$ChangePercent/100
If $Change='профицит' Then $TDEE=$TDEE+$TDEE*$ChangePercent/100

Else
$TDEE=$SelfCount
EndIf

If $TDEE<1200 Then MsgBoxEx(48, $FormCaption, 'Снижение дневного потребления килокалорий ниже 1200 не рекомендуется.')

$BFArr[0]=Round($TDEE, 2) ;CaloryMAX
$BFArr[1]=Round($TDEE*$ProteinPercent/100/4, 2) ;$ProteinMAX
$BFArr[2]=Round($TDEE*$FatPercent/100/9, 2) ;$FatMax
$BFArr[3]=Round($TDEE*$CarbohydratePercent/100/4, 2) ;$CarbohydrateMax

Return $BFArr
EndFunc



Func CountMAX($SelectArr, $ResultArr)
$CaloriesMAX=9999999
$ProteinMAX=9999999
$FatMax=9999999
$CarbohydrateMax=9999999

If $SelectArr[3]>0 Then $CaloriesMAX=Round($ResultArr[1][0]/$SelectArr[3]*100, 2)
If $SelectArr[4]>0 Then $ProteinMAX=Round($ResultArr[1][1]/$SelectArr[4]*100, 2)
If $SelectArr[5]>0 Then $FatMax=Round($ResultArr[1][2]/$SelectArr[5]*100, 2)
If $SelectArr[6]>0 Then $CarbohydrateMax=Round($ResultArr[1][3]/$SelectArr[6]*100, 2)

$MAX=$CaloriesMAX
If $MAX>$ProteinMAX Then $MAX=$ProteinMAX
If $MAX>$FatMax Then $MAX=$FatMax
If $MAX>$CarbohydrateMax Then $MAX=$CarbohydrateMax
If $MAX<0 Then $MAX=0

If GUICtrlRead($Checkbox1)=$GUI_UNCHECKED Then
GUICtrlSetData($Label59, 'Выбранного продукта можно употребить максимум '&$MAX&' грамм или '&Round($MAX/$SelectArr[2], 2)&' порций.')
Else
GUICtrlSetData($Label59, 'Выбранного продукта можно употребить максимум '&Round($aResult[1][0]/$SelectArr[3]*100, 2)&' грамм или '&Round(Round($ResultArr[1][0]/$SelectArr[3]*100, 2)/$SelectArr[2], 2)&' порций.')
EndIf
EndFunc



;~ -----------------------------------------------------------------------------Form1Close----------------------------------------------------------------------------
Func Form1Close()
Exit
EndFunc



;~ -----------------------------------------------------------------------------SQLMessage----------------------------------------------------------------------------
Func SQLMessage($MSG, $Code, $Text)
Select
	Case $Code=0
	MsgBoxEx(0, $Code, $Text&'Err - '&$MSG)
	Case $Code=19
	Return MsgBoxEx(36, $FormCaption, $Text)
	Case $Code=21
	MsgBoxEx(36, $FormCaption, 'Невозможно произвести запись в базу данных.'&@CRLF&'Работа программы будет прекращена.')
	Exit
	Case Else
	MsgBoxEx(0, $Code, 'SQL message - '&$MSG)
EndSelect
EndFunc



;~ -----------------------------------------------------------------------------ZeroCut----------------------------------------------------------------------------
Func ZeroCut($String)
	If Not StringInStr($String, '.') Then Return $String
Do
	If StringRight($String, 1)='0' Then $String=StringTrimRight($String, 1)
Until StringRight($String, 1)<>'0'

Do
If StringRight($String, 1)='.' Then $String=StringTrimRight($String, 1)
Until StringRight($String, 1)<>'.'
Return $String
EndFunc



Func Checkbox1Click()
EndFunc



;~ -----------------------------------------------------------------------------ExitFunc----------------------------------------------------------------------------
Func ExitFunc()
_SQLite_Exec($MainstreamSQL, "DELETE FROM Users WHERE CaloriesUsed='0' AND DATE<>'"&@YEAR&'/'&@MON&'/'&@MDAY&"' ;")
_SQLite_Close()
_SQLite_Shutdown()
_GUICtrlListView_UnRegisterSortCallBack($ListView1)
_GUICtrlListView_UnRegisterSortCallBack($ListView2)
_GUICtrlListView_UnRegisterSortCallBack($ListView3)
EndFunc

