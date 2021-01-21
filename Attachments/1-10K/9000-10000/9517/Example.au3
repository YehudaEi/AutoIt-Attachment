#include <Event.au3>
$EventHandle = _EventCreate()
_EventClear($EventHandle)
_EventWrite($EventHandle, $EVENT_TYPE_INFORMATION, "YaY it works!")
_EventClose($EventHandle)