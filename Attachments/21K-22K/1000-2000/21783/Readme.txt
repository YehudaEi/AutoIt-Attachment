Inlcuded in this readme file are:
Introduction - A1
Setup and Installation - A2
Features - A3
FAQ (Frequenly Asked Questions) - A4
Credits - A5

Introduction - A1:
Hello and welcome to AutoIt Smith's FishBot.  You will notice serveral features that may be easy or advanced and you are advised that if you can't understand how to setup this program, then botting may not be for you.  This bots features include: Color Custimization(Hex or Dec), Zone Personal Colors, Automated Fishing, Macros, Anti-Afk, and Statistics(TBA)

Setup and Installation - A2:
Once you unzip the main folder it should be labeled WoW Fisher.  Open the unziped folder.  You will see 7+ different files.

Required Files:
WoW Fisher.exe <---- Program We Will Run
Colors.ini <-------- Customizable Color File
Readme.txt <-------- This File!

If for any reason you do not see these files or they are named differently, you may want to check if your copy is safe or not.  To setup follow these easy directions:

Step 1:
Start "World of Warcraft" and press "ESC".  From here goto your "Video Options" and uncheck the box labeled "Hardware Cursor".  From here press Okay and exit your Main Menu.

(OPTIONAL) You may also goto the "Interface Options" and check AutoLoot.

Step 2:
Move near water and scroll in your character so none of it can be seen.  Then cast your pole and make sure it is above your chat box and slightly below your minimap area.  This will ensure the automated process will find your bobber.

Step 3:
Open up your "Spellbook & Abilities" interface or press "P" to access it.  Select the "General" tab and move Fishing into Slot 1 of your command bar.  (Make sure your fishing pole and/or bobbles are equipped as well).  Make sure NOTHING is in your 8th Slot.

(OPTIONAL) You may add a Macro in Slot 8.  View the file "SS Macro '8'.jpg" for an idea.

Step 4:
Alt+Tab out of World of Warcraft and select your color on the menu located below the statistics area.  You are now ready!  Press the Start button on your program interface and sit back!

Remember to exit the bot, just press ESC.

Features - A3:

1 - Automated Fishing :
This is the main purpose of any "fish bot".  The programming allows a set of colors to be searched for in the goal to have an automated fishing process so you don't have to repeat mundain tasks.

2 - Zone Personal Colors :
You will see with your color select menu and inside Colors.ini there are a variety of colors that match different zones(countries) and different times(day and night).  This was developed so that users did not need to know programming and could easily select what zone for a more optimal and effecient botting experience.

3 - Color Custimization(Advanced) :
Colors.ini is the source of all color information where in Hex or Dec strings.  You will see an file similar to this:
[Standard]
List=Color1|Color2
Color1=0x000000
Color2=0x000000

To edit this you must find a color inside of World of Warcraft where the bobber color red usually is and to add it edit the list value accordingly"

List=Color1|Color2|NewColor

Noticing the character | and NewColor (the title) was added.  Now add a value like this

NewColor=0x000000 (replace 0x000000 with the color string in Hex OR Dec)

Now reload the program titled WoW Fisher.exe and you will see that a new selection in your menu was created with your new color.  This is color custimization.

4 - Statistics :
In the future I plan to create not memory loading but freelance reading/packet sending to tell us how many sucessful catchs you made and how much and what type of each fish.  This technology is yet to be researched but everytime the timer expires it will be seen as a "failed" catch and everytime it resets without failing will be seen as "successful".  This is a crude form of statistics but it will be as close as I can get until the research has been done.

5 - Macro Implementation :
In the slot 8 it will use if you want to use a macro.  This is shown by my screen shot in the zip file.  Specially used to fish specific fish instead of plogging your inventory with bad fish.

6- Anti Afk :
The bot will jump before each cast to make sure you don't go afk, AND to make you stand up if sitting :).

FAQ (Frequenly Asked Questions) - A4
Q: I've setup the bot correctly but it won't take my mouse to the bobber.
A: That is a color issue, try to see if there is a different Time on the zone you've choosen or even a different type.  For example, Menethil Harbor has two different Night-time colors. (ADVANCED) You may even customize your own color.  ConvertShots has been included.  Just take a screenshot and convert it to jpg and from there grab the color you want.

Q: (Above) but instead of bobber it won't find the splash.
A: Again this is a color issue (which may be fixed in the feature) or your latency or fps(frame per second) lags so much that the program cannot find the splash color before it ends.  If you are running a 32mb card (minimum requirements) and have extreme hesitation that is most likely the problem.

Q: When it catches a fish it won't loot or "pick up" the fish.
A: This bot was not designed to autoloot simply because you can change that option in your Interface Options.  Press ESC and goto your Interface Options to autoloot check the box and it will autoloot the fishes for you.

Q: Help!  My mouse is going crazy!!!
A: Press ESC to exit the bot or press the stop button on the graphic window.

Q: I would like to make a donation because I just love this!
A: Please email me (AutoIt Smith) at the address located in the credits for more information.  OR you can donate to the AutoIt Forums or Edge Of Nowhere forums (however I will not receive the donation).

Credits - A5:
Source Code, Readme, and Color Research - AutoIt Smith (Max Gardner) - king [dot] of [dot] all [at] comcast [dot] net  (king.of.all@comcast.net)
Forum Topics - AutoIt Forums (http://www.autoitscript.com), Edge Of Nowhere (                           )