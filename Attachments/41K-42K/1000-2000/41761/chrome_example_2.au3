#Include <Array.au3>
#Include <Chrome.au3>

; Close any existing Chrome browser
_ChromeShutdown()

; Start Chrome with the file URL "file:///D:/form.html"
_ChromeStartup("file:///C:/chrome_udf_example_2.html")

; Wait for the page with the document title of "_IE_Example('form')"
_ChromeDocWaitForExistenceByTitle("Chrome Example Form", 10)

; Get the "method" attribute of the "ExampleForm" form element
ConsoleWrite("_ChromeObjGetPropertyByName(""ExampleForm"", ""method"") = " & _ChromeObjGetPropertyByName("ExampleForm", "method") & @CRLF)

; Get the "value" attribute of the "hiddenExample" hidden input element
ConsoleWrite("_ChromeObjGetValueByName(""hiddenExample"") = " & _ChromeObjGetValueByName("hiddenExample") & @CRLF)

; Set the "value" attribute of the "textExample" text input element to a random string
ConsoleWrite("_ChromeObjSetValueByName(""textExample"", _RandomText(10)) = " & _ChromeObjSetValueByName("textExample", _RandomText(10)) & @CRLF)

; Get the "value" attribute of the "textExample" text input element
ConsoleWrite("_ChromeObjGetValueByName(""textExample"") = " & _ChromeObjGetValueByName("textExample") & @CRLF)

; Set the "value" attribute of the "passwordExample" password input element to a random string
ConsoleWrite("_ChromeObjSetValueByName(""passwordExample"", _RandomText(10)) = " & _ChromeObjSetValueByName("passwordExample", _RandomText(10)) & @CRLF)

; Get the "value" attribute of the "passwordExample" password input element
ConsoleWrite("_ChromeObjGetValueByName(""passwordExample"") = " & _ChromeObjGetValueByName("passwordExample") & @CRLF)

; Get the "type" attribute of the "fileExample" file input element
ConsoleWrite("_ChromeObjGetPropertyByName(""fileExample"", ""type"") = " & _ChromeObjGetPropertyByName("fileExample", "type") & @CRLF)

; Get the "src" attribute of the "imageExample" image input element
ConsoleWrite("_ChromeObjGetPropertyByName(""imageExample"", ""src"") = " & _ChromeObjGetPropertyByName("imageExample", "src") & @CRLF)

; Click the "imageExample" image input element
_ChromeInputClickByName("imageExample")

; Get the "innerHTML" attribute of the "messages" DIV element (updated from the "imageExample" click above)
ConsoleWrite("_ChromeObjGetHTMLById(""messages"") = " & _ChromeObjGetHTMLById("messages") & @CRLF)

; Set the "value" attribute of the "textareaExample" textarea input element to a random string
ConsoleWrite("_ChromeObjSetValueByName(""textareaExample"", _RandomText(10)) = " & _ChromeObjSetValueByName("textareaExample", _RandomText(10)) & @CRLF)

; Get the "value" attribute of the "textareaExample" textarea input element
ConsoleWrite("_ChromeObjGetValueByName(""textareaExample"") = " & _ChromeObjGetValueByName("textareaExample") & @CRLF)

; Check the first "checkboxG1Example" checkbox input element
_ChromeInputSetCheckedByName("checkboxG1Example", True)

; Get the "checked" attribute of the first "checkboxG1Example" checkbox input element
ConsoleWrite("_ChromeObjGetPropertyByName(""checkboxG1Example"", ""checked"") = " & _ChromeObjGetPropertyByName("checkboxG1Example", "checked") & @CRLF)

; Uncheck the first "checkboxG2Example" checkbox input element
_ChromeInputSetCheckedByName("checkboxG2Example", False, 0)

; Get the "checked" attribute of the first "checkboxG2Example" checkbox input element
ConsoleWrite("_ChromeObjGetPropertyByName(""checkboxG2Example"", ""checked"") = " & _ChromeObjGetPropertyByName("checkboxG2Example", "checked") & @CRLF)

; Check the first "radioExample" radio input element
_ChromeInputSetCheckedByName("radioExample", True, 0)

; Get the "checked" attribute of the first "radioExample" radio input element
ConsoleWrite("_ChromeObjGetPropertyByName(""radioExample"", ""checked"", 0) = " & _ChromeObjGetPropertyByName("radioExample", "checked", 0) & @CRLF)

; Select the "midipage.html" option in the "selectExample" select element
_ChromeOptionSelectWithValueByObjName("midipage.html", "selectExample")

; Get the selected value of the "selectExample" select element
ConsoleWrite("_ChromeObjGetPropertyByName(""selectExample"", ""selectedIndex"") = " & _ChromeObjGetPropertyByName("selectExample", "selectedIndex") & @CRLF)

; Select the "Name2" option in the "multipleSelectExample" select element
_ChromeOptionSelectWithValueByObjName("Name2", "multipleSelectExample")

; Get the selected value of the "multipleSelectExample" select element
ConsoleWrite("_ChromeObjGetPropertyByName(""multipleSelectExample"", ""selectedIndex"") = " & _ChromeObjGetPropertyByName("multipleSelectExample", "selectedIndex") & @CRLF)

; Click the "submitExample" submit input element
_ChromeInputClickByName("submitExample")

; Get the "innerHTML" attribute of the "messages" DIV element (updated from the "submitExample" click above)
ConsoleWrite("_ChromeObjGetHTMLById(""messages"") = " & _ChromeObjGetHTMLById("messages") & @CRLF)


Func _RandomText($length)
    $text = ""
    For $i = 1 To $length
        $text &= Chr(Random(65, 90, 1))
    Next
    Return $text
EndFunc   ;==>_RandomText
