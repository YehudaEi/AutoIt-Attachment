#include <IE.au3>
#Include <Clipboard.au3>

_IEErrorHandlerRegister()

func click_on_element_inside_browser_tree($id)
	;;��� �� ������ ����������� �������
	$view_frame = _IEFrameGetObjByName ($ie, "view")
	$browser_frame = _IEFrameGetObjByName ($view_frame, "browser")
	$browser_tree_form = _IEFormGetObjByName ($browser_frame, "BrowserTree_0")
	$oLinks = _IETagNameAllGetCollection ($browser_tree_form,0)

	$oDiv = _IEGetObjById($oLinks, $id)
	_IEAction($oDiv, "click")

EndFunc


func click_on_Create()
	;;��� �� ������ ����������� �������
	$view_frame = _IEFrameGetObjByName ($ie, "view")
	$workarea_frame = _IEFrameGetObjByName ($view_frame, "workarea")
	$menubar = _IEFrameGetObjByName ($workarea_frame, "menubar")
	$create_form = _IEFormGetObjByName ($menubar, "MenuBar_0")
	$tables = _IETableGetCollection ($create_form, 0)

	$oDiv = _IEGetObjById($tables, "MenuBar_DocumentRegistrationMenu_0html_id")
	_IEAction($oDiv, "click")

EndFunc

func click_on_popup()
	;;������ ������� ����� � �������� ������
	$view_frame = _IEFrameGetObjByName ($ie, "view")
	$workarea_frame = _IEFrameGetObjByName ($view_frame, "workarea")
	$menubar = _IEFrameGetObjByName ($workarea_frame, "menubar")
	$create_form = _IEFormGetObjByName ($menubar, "MenuBar_0")
	$tables = _IETableGetCollection ($create_form, 0)

	$oDiv = _IEGetObjById($tables, "MenuBar_DocumentRegistrationMenu_0html_id")
	_IEAction($oDiv, "click")
	Opt("MouseCoordMode", 0)
	MouseClick("left", 320, 250)


EndFunc

Func create_notreg_document()
	$view_frame = _IEFrameGetObjByName ($ie, "view")
	$workarea_frame = _IEFrameGetObjByName ($view_frame, "workarea")
	$content_frame = _IEFrameGetObjByName ($workarea_frame, "content")
	$container = _IEFormGetObjByName ($content_frame, "NotregDocumentContainer_0")
	$divs = _IETableGetCollection($container, 0)

	$first_div = _IEGetObjById($divs, "scrollingcontent")
EndFunc



$ie = _IECreate ("http://localhost:8080/webtop-eosdo")

$login = _IEGetObjById ($ie, "LoginUsername")

;; �������� ����������� ������, ��� ������� ��������� �� ����
_IEAction ($login, "focus")
For $i = 25 to 1 step -1
	Send("{delete}")
Next

;; ��������� �����
_ClipBoard_SetData("oleg6",$CF_TEXT)
_IEAction ($login, "paste")

;; ��������� ������
$pass = _IEGetObjById ($ie, "LoginPassword")
_ClipBoard_SetData("1",$CF_TEXT)
_IEAction ($pass, "focus")
_IEAction ($pass, "paste")

;; ���������
$button = _IEGetObjByName($ie, "Login_loginButton_0")
_IEAction ($button, "click")

_IELoadWait ($ie)

;�������� �� ������ �����
click_on_element_inside_browser_tree("docbrowser5")

_IELoadWait ($ie)

;;�������� �� �������
click_on_Create()

_IELoadWait ($ie)

;;�������� �� ������ �� popupmenu
click_on_popup()

Sleep(1000)

;;����� ���������������� �������
create_notreg_document()

_IELoadWait ($ie)