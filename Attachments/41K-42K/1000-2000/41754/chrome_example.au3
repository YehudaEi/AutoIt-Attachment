#Include <Array.au3>
#Include <Chrome.au3>


; Close any existing Chrome browser
_ChromeShutdown()

; Start Chrome with the URL "http://www.december.com/html/demo/form.html"
_ChromeStartup("http://www.december.com/html/demo/form.html")

; Wait for the page with the document title of "HTML Form Example"
_ChromeDocWaitForExistenceByTitle("HTML Form Example", 10)

; Set the value of the field labelled "Your age:" to "8"
_ChromeObjSetValueByName("user-age", "8")

; Select the radio button labelled "Female"
_ChromeInputSetCheckedByName("user-gender", true, 1)

; Check the checkbox labelled "Marc Andreessen"
_ChromeInputSetCheckedByName("knows-marc", true, 0)

; Select the option with the text "Lynx"
_ChromeOptionSelectWithTextByObjName("Lynx", "favorite-web-browser")

; Select the option with the value of "daring" (Cherry Garcia)
_ChromeOptionSelectWithValueByObjName("daring", "tried-ice-cream")

; Set the value of the field labelled "Guess the secret password:" to "password"
_ChromeObjSetValueByName("password-guess", "password")

; Select the radio button labelled "Yes"
_ChromeInputSetCheckedWithValueByName("Yes", "nickname", true)

; Set the value of the field labelled "it is:" to "fred"
_ChromeObjSetValueByName("user-nickname", "fred")

; Click the button labelled "Send this survey"
_ChromeInputClickByType("submit")

; Wait for the page with the document title of "Thank You"
_ChromeDocWaitForExistenceByTitle("Thank You", 10)

; Get the <title> tag (Thank You)
ConsoleWrite("_ChromeDocGetTitle() = " & _ChromeDocGetTitle() & @CRLF)

; Get the <h1> tag (Thank You For Filling Out This Form)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""h1"") = " & _ChromeObjGetHTMLByTagName("h1") & @CRLF)

; Get the first <p> tag (user-age: 8)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""p"", 1) = " & StringStripWS(_ChromeObjGetHTMLByTagName("p", 1), 3) & @CRLF)

; Get the second <p> tag (user-gender: F)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""p"", 2) = " & StringStripWS(_ChromeObjGetHTMLByTagName("p", 2), 3) & @CRLF)

; Get the third <p> tag (knows-marc: on)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""p"", 3) = " & StringStripWS(_ChromeObjGetHTMLByTagName("p", 3), 3) & @CRLF)

; Get the fourth <p> tag (favorite-web-browser: Lynx)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""p"", 4) = " & StringStripWS(_ChromeObjGetHTMLByTagName("p", 4), 3) & @CRLF)

; Get the fifth <p> tag (tried-ice-cream: daring)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""p"", 5) = " & StringStripWS(_ChromeObjGetHTMLByTagName("p", 5), 3) & @CRLF)

; Get the sixth <p> tag (password-guess: password)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""p"", 6) = " & StringStripWS(_ChromeObjGetHTMLByTagName("p", 6), 3) & @CRLF)

; Get the seventh <p> tag (nickname: Yes)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""p"", 7) = " & StringStripWS(_ChromeObjGetHTMLByTagName("p", 7), 3) & @CRLF)

; Get the eighth <p> tag (user-nickname: fred)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""p"", 8) = " & StringStripWS(_ChromeObjGetHTMLByTagName("p", 8), 3) & @CRLF)

; Get the ninth <p> tag (user-motto: All is well that ends well.)
ConsoleWrite("_ChromeObjGetHTMLByTagName(""p"", 9) = " & StringStripWS(_ChromeObjGetHTMLByTagName("p", 9), 3) & @CRLF)

