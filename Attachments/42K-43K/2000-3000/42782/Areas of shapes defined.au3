Global $shape
$shape = InputBox("Area", "Which shape would you like to know the equation for? Circle , Square , or Triangle ")


If $shape = "Circle" Then
   $circle = MsgBox(4, "Area of a Circle", "Area of a circle is A=3.14*r^2. Would you like to find the area of a cirle?")
EndIf

If $shape = "Square" Then
   $square = MsgBox(4, "Area of a square", "The area a square is A=l*w or A=l^2. Would you like to find the area of a square?")
EndIf

If $square = 6 Then
   $squareside = InputBox("Area of a square", "Enter the length of one side,")
EndIf

If $circle = 6 Then
   $circleradius = InputBox("Area of a circle", "Enter the length of the radius.")
EndIf




$squarearea = ($squareside *$squareside)
$circlearea = ($circleradius * $circleradius) * 3.14

MsgBox(0, "Area of a circle", "The area of the circle is, " & $circlearea)




