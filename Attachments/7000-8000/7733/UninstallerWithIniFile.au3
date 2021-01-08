;Fisrt setup for applications

If FileExists("C:\settings.ini") Then
    ;MsgBox(4096, "test","Settings File available.")
Else
;Write All Global settings to C:\settings.ini
IniWrite ("C:\Settings.ini","GlobalSettings","Progdir","C:\Program Files\")
IniWrite ("C:\Settings.ini","GlobalSettings","Uninstallexe","Unins000.exe")
IniWrite ("C:\Settings.ini","Switches","Switch","/silent")

;Write All Gamenames to C:\Settings.ini
IniWrite ("C:\Settings.ini","GameNames","GameName1","5 Card Slingo")
IniWrite ("C:\Settings.ini","GameNames","GameName2","5 Spots")
IniWrite ("C:\Settings.ini","GameNames","GameName3","5 Spots II")
IniWrite ("C:\Settings.ini","GameNames","GameName4","ABC Island")
IniWrite ("C:\Settings.ini","GameNames","GameName5","Absolute Blue")
IniWrite ("C:\Settings.ini","GameNames","GameName6","Acropolis")
IniWrite ("C:\Settings.ini","GameNames","GameName7","Action Ball Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName8","Action Memory")
IniWrite ("C:\Settings.ini","GameNames","GameName9","Add Em Up")
IniWrite ("C:\Settings.ini","GameNames","GameName10","Adventure Ball")
IniWrite ("C:\Settings.ini","GameNames","GameName11","Adventure Inlay")
IniWrite ("C:\Settings.ini","GameNames","GameName12","Adventure Inlay Safari Edition")
IniWrite ("C:\Settings.ini","GameNames","GameName13","Age of Castles")
IniWrite ("C:\Settings.ini","GameNames","GameName14","Air Strike 2")
IniWrite ("C:\Settings.ini","GameNames","GameName15","Air Strike II Gulf Thunder")
IniWrite ("C:\Settings.ini","GameNames","GameName16","Alien Defense")
IniWrite ("C:\Settings.ini","GameNames","GameName17","Alien Outbreak 2 Invasion")
IniWrite ("C:\Settings.ini","GameNames","GameName18","Alien Shooter")
IniWrite ("C:\Settings.ini","GameNames","GameName19","Alien Sky")
IniWrite ("C:\Settings.ini","GameNames","GameName20","Aloha Solitaire")
IniWrite ("C:\Settings.ini","GameNames","GameName21","Aloha Tripeaks")
IniWrite ("C:\Settings.ini","GameNames","GameName22","Alpha Ball")
IniWrite ("C:\Settings.ini","GameNames","GameName23","Amazon Quest")
IniWrite ("C:\Settings.ini","GameNames","GameName24","Ancient Seal")
IniWrite ("C:\Settings.ini","GameNames","GameName25","Anime Bowling Babes")
IniWrite ("C:\Settings.ini","GameNames","GameName26","Ant War")
IniWrite ("C:\Settings.ini","GameNames","GameName27","Aqua Bubble")
IniWrite ("C:\Settings.ini","GameNames","GameName28","Aqua Bubble 2")
IniWrite ("C:\Settings.ini","GameNames","GameName29","Aqua Pearls")
IniWrite ("C:\Settings.ini","GameNames","GameName30","Aqua Slider")
IniWrite ("C:\Settings.ini","GameNames","GameName31","Aqua Words")
IniWrite ("C:\Settings.ini","GameNames","GameName32","Aquabble Avalanche")
IniWrite ("C:\Settings.ini","GameNames","GameName33","Aquacade")
IniWrite ("C:\Settings.ini","GameNames","GameName34","AquaPOP")
IniWrite ("C:\Settings.ini","GameNames","GameName35","Aquatic of Sherwood")
IniWrite ("C:\Settings.ini","GameNames","GameName36","Arcalands")
IniWrite ("C:\Settings.ini","GameNames","GameName37","Arctic Quest")
IniWrite ("C:\Settings.ini","GameNames","GameName38","Arklight")
IniWrite ("C:\Settings.ini","GameNames","GameName39","Asea")
IniWrite ("C:\Settings.ini","GameNames","GameName40","Asianata")
IniWrite ("C:\Settings.ini","GameNames","GameName41","AstroAvenger")
IniWrite ("C:\Settings.ini","GameNames","GameName42","Astrobatics")
IniWrite ("C:\Settings.ini","GameNames","GameName43","Atlantis")
IniWrite ("C:\Settings.ini","GameNames","GameName44","Atomaders")
IniWrite ("C:\Settings.ini","GameNames","GameName45","Avalanche")
IniWrite ("C:\Settings.ini","GameNames","GameName46","Ball 7")
IniWrite ("C:\Settings.ini","GameNames","GameName47","Ballistik")
IniWrite ("C:\Settings.ini","GameNames","GameName48","Balloon Blast")
IniWrite ("C:\Settings.ini","GameNames","GameName49","Barnyard Invasion")
IniWrite ("C:\Settings.ini","GameNames","GameName50","Battle Castles")
IniWrite ("C:\Settings.ini","GameNames","GameName51","Beeline")
IniWrite ("C:\Settings.ini","GameNames","GameName52","Beesly's Buzzwords")
IniWrite ("C:\Settings.ini","GameNames","GameName53","Beetle Bomp")
IniWrite ("C:\Settings.ini","GameNames","GameName54","Bejeweled 2 Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName55","Best Gift")
IniWrite ("C:\Settings.ini","GameNames","GameName56","Betty's Beer Bar")
IniWrite ("C:\Settings.ini","GameNames","GameName57","Big Kahuna Reef")
IniWrite ("C:\Settings.ini","GameNames","GameName58","Big Kahuna Words")
IniWrite ("C:\Settings.ini","GameNames","GameName59","Bistro Stars")
IniWrite ("C:\Settings.ini","GameNames","GameName60","Blox World")
IniWrite ("C:\Settings.ini","GameNames","GameName61","Bombard Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName62","Bonnie's Bookstore")
IniWrite ("C:\Settings.ini","GameNames","GameName63","Book Bind")
IniWrite ("C:\Settings.ini","GameNames","GameName64","Boulder Dash")
IniWrite ("C:\Settings.ini","GameNames","GameName65","Brave Dwarves 2")
IniWrite ("C:\Settings.ini","GameNames","GameName66","Brave Dwarves Back For Treasures")
IniWrite ("C:\Settings.ini","GameNames","GameName67","Brave Piglet")
IniWrite ("C:\Settings.ini","GameNames","GameName68","Break Ball 2 Gold")
IniWrite ("C:\Settings.ini","GameNames","GameName69","Break Quest")
IniWrite ("C:\Settings.ini","GameNames","GameName70","BreakIn")
IniWrite ("C:\Settings.ini","GameNames","GameName71","Bricks of Atlantis")
IniWrite ("C:\Settings.ini","GameNames","GameName72","Bricks of Camelot")
IniWrite ("C:\Settings.ini","GameNames","GameName73","Bricks of Egypt")
IniWrite ("C:\Settings.ini","GameNames","GameName74","BrixFormer")
IniWrite ("C:\Settings.ini","GameNames","GameName75","Brixout XP")
IniWrite ("C:\Settings.ini","GameNames","GameName76","Brixquest")
IniWrite ("C:\Settings.ini","GameNames","GameName77","Bubblefish Bob")
IniWrite ("C:\Settings.ini","GameNames","GameName78","Bud Redhead")
IniWrite ("C:\Settings.ini","GameNames","GameName79","Bugatron")
IniWrite ("C:\Settings.ini","GameNames","GameName80","Bugix Adventures")
IniWrite ("C:\Settings.ini","GameNames","GameName81","Butterflight")
IniWrite ("C:\Settings.ini","GameNames","GameName82","Buzzy Bumble")
IniWrite ("C:\Settings.ini","GameNames","GameName83","Cactus Bruce")
IniWrite ("C:\Settings.ini","GameNames","GameName84","Cactus Bruce and the Corporate Monkeys")
IniWrite ("C:\Settings.ini","GameNames","GameName85","Caramba")
IniWrite ("C:\Settings.ini","GameNames","GameName86","Carl The Caveman")
IniWrite ("C:\Settings.ini","GameNames","GameName87","Carls Classics")
IniWrite ("C:\Settings.ini","GameNames","GameName88","Castle of Cards")
IniWrite ("C:\Settings.ini","GameNames","GameName89","Chainz")
IniWrite ("C:\Settings.ini","GameNames","GameName90","Charm Solitaire")
IniWrite ("C:\Settings.ini","GameNames","GameName91","Charm Tale")
IniWrite ("C:\Settings.ini","GameNames","GameName92","CheboMan")
IniWrite ("C:\Settings.ini","GameNames","GameName93","Chicken Village")
IniWrite ("C:\Settings.ini","GameNames","GameName94","Chomp! Chomp! Safari")
IniWrite ("C:\Settings.ini","GameNames","GameName95","Circulate")
IniWrite ("C:\Settings.ini","GameNames","GameName96","Clash N Slash")
IniWrite ("C:\Settings.ini","GameNames","GameName97","Coffee Tycoon")
IniWrite ("C:\Settings.ini","GameNames","GameName98","Colony")
IniWrite ("C:\Settings.ini","GameNames","GameName99","Cookie Chef")
IniWrite ("C:\Settings.ini","GameNames","GameName100","Cosmic Bugs")
IniWrite ("C:\Settings.ini","GameNames","GameName101","Crime Puzzle")
IniWrite ("C:\Settings.ini","GameNames","GameName102","Crimsonland")
IniWrite ("C:\Settings.ini","GameNames","GameName103","Crusaders of Space Open Range")
IniWrite ("C:\Settings.ini","GameNames","GameName104","Crystalix")
IniWrite ("C:\Settings.ini","GameNames","GameName105","Cubes Invasion")
IniWrite ("C:\Settings.ini","GameNames","GameName106","Cubology")
IniWrite ("C:\Settings.ini","GameNames","GameName107","Dark Archon")
IniWrite ("C:\Settings.ini","GameNames","GameName108","DDD Pool")
IniWrite ("C:\Settings.ini","GameNames","GameName109","Deep Sea Adventures")
IniWrite ("C:\Settings.ini","GameNames","GameName110","Deep Sea Tycoon")
IniWrite ("C:\Settings.ini","GameNames","GameName111","Deep Sea Tycoon 2")
IniWrite ("C:\Settings.ini","GameNames","GameName112","Desperate Space")
IniWrite ("C:\Settings.ini","GameNames","GameName113","Diamond Drop")
IniWrite ("C:\Settings.ini","GameNames","GameName114","Digby's Donuts")
IniWrite ("C:\Settings.ini","GameNames","GameName115","Digi Pool")
IniWrite ("C:\Settings.ini","GameNames","GameName116","Diner Dash")
IniWrite ("C:\Settings.ini","GameNames","GameName117","Docker Sokoban")
IniWrite ("C:\Settings.ini","GameNames","GameName118","Double Digger")
IniWrite ("C:\Settings.ini","GameNames","GameName119","Double Trump\Electric")
IniWrite ("C:\Settings.ini","GameNames","GameName120","Dr Blobs Organism")
IniWrite ("C:\Settings.ini","GameNames","GameName121","Dr Germ")
IniWrite ("C:\Settings.ini","GameNames","GameName122","Dragon Ball")
IniWrite ("C:\Settings.ini","GameNames","GameName123","Drop")
IniWrite ("C:\Settings.ini","GameNames","GameName124","Drop! 2")
IniWrite ("C:\Settings.ini","GameNames","GameName125","Dropheads")
IniWrite ("C:\Settings.ini","GameNames","GameName126","Dungeon Scroll Gold Edition")
IniWrite ("C:\Settings.ini","GameNames","GameName127","Electra")
IniWrite ("C:\Settings.ini","GameNames","GameName128","Elythril The Elf Treasure")
IniWrite ("C:\Settings.ini","GameNames","GameName129","Emperors Mahjong")
IniWrite ("C:\Settings.ini","GameNames","GameName130","Evil Invasion")
IniWrite ("C:\Settings.ini","GameNames","GameName131","Fairies")
IniWrite ("C:\Settings.ini","GameNames","GameName132","Fairy Words")
IniWrite ("C:\Settings.ini","GameNames","GameName133","Fatman Adventures")
IniWrite ("C:\Settings.ini","GameNames","GameName134","Feed The Snake")
IniWrite ("C:\Settings.ini","GameNames","GameName135","Feeding Frenzy")
IniWrite ("C:\Settings.ini","GameNames","GameName136","Fiber Twig")
IniWrite ("C:\Settings.ini","GameNames","GameName137","Fiber Twig 2")
IniWrite ("C:\Settings.ini","GameNames","GameName138","Filler")
IniWrite ("C:\Settings.ini","GameNames","GameName139","Fireworks Extravaganza")
IniWrite ("C:\Settings.ini","GameNames","GameName140","Fish Tales")
IniWrite ("C:\Settings.ini","GameNames","GameName141","Fish Tycoon")
IniWrite ("C:\Settings.ini","GameNames","GameName142","Fishing Trip")
IniWrite ("C:\Settings.ini","GameNames","GameName143","Five Card Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName144","Flip Words")
IniWrite ("C:\Settings.ini","GameNames","GameName145","Flying Doughman")
IniWrite ("C:\Settings.ini","GameNames","GameName146","Flying Leo")
IniWrite ("C:\Settings.ini","GameNames","GameName147","Fresco Wizard")
IniWrite ("C:\Settings.ini","GameNames","GameName148","Froggy Castle 2")
IniWrite ("C:\Settings.ini","GameNames","GameName149","Fruit Lockers")
IniWrite ("C:\Settings.ini","GameNames","GameName150","Full Circle")
IniWrite ("C:\Settings.ini","GameNames","GameName151","Funkiball Adventure")
IniWrite ("C:\Settings.ini","GameNames","GameName152","Funky Farm")
IniWrite ("C:\Settings.ini","GameNames","GameName153","Funny Creatures")
IniWrite ("C:\Settings.ini","GameNames","GameName154","Funny Faces")
IniWrite ("C:\Settings.ini","GameNames","GameName155","Fusion")
IniWrite ("C:\Settings.ini","GameNames","GameName156","Gamehouse Sudoku")
IniWrite ("C:\Settings.ini","GameNames","GameName157","Gamehouse Word Collection")
IniWrite ("C:\Settings.ini","GameNames","GameName158","Garfield Goes to Pieces")
IniWrite ("C:\Settings.ini","GameNames","GameName159","Gem Mine")
IniWrite ("C:\Settings.ini","GameNames","GameName160","Gem Shop")
IniWrite ("C:\Settings.ini","GameNames","GameName161","Genius Move")
IniWrite ("C:\Settings.ini","GameNames","GameName162","Geom")
IniWrite ("C:\Settings.ini","GameNames","GameName163","Global Defense Network")
IniWrite ("C:\Settings.ini","GameNames","GameName164","Glow Worm")
IniWrite ("C:\Settings.ini","GameNames","GameName165","Gold Miner")
IniWrite ("C:\Settings.ini","GameNames","GameName166","Gold Miner Joe")
IniWrite ("C:\Settings.ini","GameNames","GameName167","Gold Miner Special Edition")
IniWrite ("C:\Settings.ini","GameNames","GameName168","Gold Sprinter")
IniWrite ("C:\Settings.ini","GameNames","GameName169","Golden Dozen Solitaire")
IniWrite ("C:\Settings.ini","GameNames","GameName170","Golf Adventure Galaxy")
IniWrite ("C:\Settings.ini","GameNames","GameName171","Granny In Paradise")
IniWrite ("C:\Settings.ini","GameNames","GameName172","Gravity Drive")
IniWrite ("C:\Settings.ini","GameNames","GameName173","Gravity Gems")
IniWrite ("C:\Settings.ini","GameNames","GameName174","Grump")
IniWrite ("C:\Settings.ini","GameNames","GameName175","Gunner 2")
IniWrite ("C:\Settings.ini","GameNames","GameName176","Gutterball 2")
IniWrite ("C:\Settings.ini","GameNames","GameName177","Hamster Blocks")
IniWrite ("C:\Settings.ini","GameNames","GameName178","Hamsterball")
IniWrite ("C:\Settings.ini","GameNames","GameName179","Hangman Wild West 2")
IniWrite ("C:\Settings.ini","GameNames","GameName180","HangStan")
IniWrite ("C:\Settings.ini","GameNames","GameName181","Hard Rock Casino")
IniWrite ("C:\Settings.ini","GameNames","GameName182","Heavy Weapon")
IniWrite ("C:\Settings.ini","GameNames","GameName183","Hexalot")
IniWrite ("C:\Settings.ini","GameNames","GameName184","Holiday Express")
IniWrite ("C:\Settings.ini","GameNames","GameName185","Hyperballoid")
IniWrite ("C:\Settings.ini","GameNames","GameName186","Hyperballoid Complete\uninst")
IniWrite ("C:\Settings.ini","GameNames","GameName187","Ice Age")
IniWrite ("C:\Settings.ini","GameNames","GameName188","Ice Breaker")
IniWrite ("C:\Settings.ini","GameNames","GameName189","Icy Spell")
IniWrite ("C:\Settings.ini","GameNames","GameName190","Incadia")
IniWrite ("C:\Settings.ini","GameNames","GameName191","Invadazoid")
IniWrite ("C:\Settings.ini","GameNames","GameName192","Jeez")
IniWrite ("C:\Settings.ini","GameNames","GameName193","Jets N Guns")
IniWrite ("C:\Settings.ini","GameNames","GameName194","Jewel Quest")
IniWrite ("C:\Settings.ini","GameNames","GameName195","Jezzonix")
IniWrite ("C:\Settings.ini","GameNames","GameName196","Jig Words")
IniWrite ("C:\Settings.ini","GameNames","GameName197","Jigsaw365")
IniWrite ("C:\Settings.ini","GameNames","GameName198","Jungle Heart")
IniWrite ("C:\Settings.ini","GameNames","GameName199","Kasparov Chessmate")
IniWrite ("C:\Settings.ini","GameNames","GameName200","Kick Shot Pool")
IniWrite ("C:\Settings.ini","GameNames","GameName201","King Kong Skull Island Adventure")
IniWrite ("C:\Settings.ini","GameNames","GameName202","Last Galaxy Hero")
IniWrite ("C:\Settings.ini","GameNames","GameName203","Legend of Aladdin")
IniWrite ("C:\Settings.ini","GameNames","GameName204","Lemonade Tycoon")
IniWrite ("C:\Settings.ini","GameNames","GameName205","Lemonade Tycoon 2")
IniWrite ("C:\Settings.ini","GameNames","GameName206","LexiCastle")
IniWrite ("C:\Settings.ini","GameNames","GameName207","Library of the Ages")
IniWrite ("C:\Settings.ini","GameNames","GameName208","Live Billiards")
IniWrite ("C:\Settings.ini","GameNames","GameName209","Lucky Streak Poker")
IniWrite ("C:\Settings.ini","GameNames","GameName210","Luxor")
IniWrite ("C:\Settings.ini","GameNames","GameName211","Machine Hell")
IniWrite ("C:\Settings.ini","GameNames","GameName212","Mad Cars")
IniWrite ("C:\Settings.ini","GameNames","GameName213","MadCaps")
IniWrite ("C:\Settings.ini","GameNames","GameName214","Magic Ball")
IniWrite ("C:\Settings.ini","GameNames","GameName215","Magic Ball 2")
IniWrite ("C:\Settings.ini","GameNames","GameName216","Magic Gem")
IniWrite ("C:\Settings.ini","GameNames","GameName217","Magic Inlay")
IniWrite ("C:\Settings.ini","GameNames","GameName218","Magic Match")
IniWrite ("C:\Settings.ini","GameNames","GameName219","Magic Vines")
IniWrite ("C:\Settings.ini","GameNames","GameName220","Mah Jong Adventures")
IniWrite ("C:\Settings.ini","GameNames","GameName221","Mah Jong Quest")
IniWrite ("C:\Settings.ini","GameNames","GameName222","Mahjong Holidays 2005")
IniWrite ("C:\Settings.ini","GameNames","GameName223","Mahjong Mania Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName224","Mahjong Medley")
IniWrite ("C:\Settings.ini","GameNames","GameName225","Mahjong Towers Eternity")
IniWrite ("C:\Settings.ini","GameNames","GameName226","Mahjong Towers II")
IniWrite ("C:\Settings.ini","GameNames","GameName227","MaxGammon")
IniWrite ("C:\Settings.ini","GameNames","GameName228","Mayan Squares")
IniWrite ("C:\Settings.ini","GameNames","GameName229","Mega Flexicon")
IniWrite ("C:\Settings.ini","GameNames","GameName230","Mega Monty")
IniWrite ("C:\Settings.ini","GameNames","GameName231","Memory Loops")
IniWrite ("C:\Settings.ini","GameNames","GameName232","Mind Machine")
IniWrite ("C:\Settings.ini","GameNames","GameName233","Mind Your Marbles")
IniWrite ("C:\Settings.ini","GameNames","GameName234","Mind Your Marbles Christmas Edition")
IniWrite ("C:\Settings.ini","GameNames","GameName235","Mini Golf Pro")
IniWrite ("C:\Settings.ini","GameNames","GameName236","Mirror Magic")
IniWrite ("C:\Settings.ini","GameNames","GameName237","Moleculous")
IniWrite ("C:\Settings.ini","GameNames","GameName238","Mortimer and the Enchanted Castle")
IniWrite ("C:\Settings.ini","GameNames","GameName239","Musikapa")
IniWrite ("C:\Settings.ini","GameNames","GameName240","Mutant Storm")
IniWrite ("C:\Settings.ini","GameNames","GameName241","Mystery Case Files Huntsville")
IniWrite ("C:\Settings.ini","GameNames","GameName242","Napad")
IniWrite ("C:\Settings.ini","GameNames","GameName243","Naval Strike")
IniWrite ("C:\Settings.ini","GameNames","GameName244","Navigatris")
IniWrite ("C:\Settings.ini","GameNames","GameName245","Oasis")
IniWrite ("C:\Settings.ini","GameNames","GameName246","Ocean Diver")
IniWrite ("C:\Settings.ini","GameNames","GameName247","Off Road Arena")
IniWrite ("C:\Settings.ini","GameNames","GameName248","Orbz")
IniWrite ("C:\Settings.ini","GameNames","GameName249","Outpost Kaloki")
IniWrite ("C:\Settings.ini","GameNames","GameName250","PacQuest 3D")
IniWrite ("C:\Settings.ini","GameNames","GameName251","Paradoxion")
IniWrite ("C:\Settings.ini","GameNames","GameName252","Passage 3")
IniWrite ("C:\Settings.ini","GameNames","GameName253","Pastime Puzzles")
IniWrite ("C:\Settings.ini","GameNames","GameName254","Pat Sajak's Lucky Letters")
IniWrite ("C:\Settings.ini","GameNames","GameName255","Pharaoh's Curse Gold")
IniWrite ("C:\Settings.ini","GameNames","GameName256","Picture Pyramid")
IniWrite ("C:\Settings.ini","GameNames","GameName257","Pingo Pango")
IniWrite ("C:\Settings.ini","GameNames","GameName258","Pirates of Treasure Island")
IniWrite ("C:\Settings.ini","GameNames","GameName259","Pizza Frenzy")
IniWrite ("C:\Settings.ini","GameNames","GameName260","Platypus")
IniWrite ("C:\Settings.ini","GameNames","GameName261","Playtonium Jigsaw Animals of Africa")
IniWrite ("C:\Settings.ini","GameNames","GameName262","Playtonium Jigsaw Atlantic Lighthouses")
IniWrite ("C:\Settings.ini","GameNames","GameName263","Playtonium Jigsaw Enchanted Forest")
IniWrite ("C:\Settings.ini","GameNames","GameName264","Plummit")
IniWrite ("C:\Settings.ini","GameNames","GameName265","Poker Superstars Invitational")
IniWrite ("C:\Settings.ini","GameNames","GameName266","Professor Fizzwizzle")
IniWrite ("C:\Settings.ini","GameNames","GameName267","Pulsarius")
IniWrite ("C:\Settings.ini","GameNames","GameName268","Puzzle Blast")
IniWrite ("C:\Settings.ini","GameNames","GameName269","Puzzle Express")
IniWrite ("C:\Settings.ini","GameNames","GameName270","Puzzle Myth")
IniWrite ("C:\Settings.ini","GameNames","GameName271","Puzzle Word")
IniWrite ("C:\Settings.ini","GameNames","GameName272","QBicles")
IniWrite ("C:\Settings.ini","GameNames","GameName273","Race Cars The Extreme Rally")
IniWrite ("C:\Settings.ini","GameNames","GameName274","Rainbow Drops Buster")
IniWrite ("C:\Settings.ini","GameNames","GameName275","Rainbow Web")
IniWrite ("C:\Settings.ini","GameNames","GameName276","Rally Racers")
IniWrite ("C:\Settings.ini","GameNames","GameName277","Reader's Digest Super Word Power")
IniWrite ("C:\Settings.ini","GameNames","GameName278","Reaktor")
IniWrite ("C:\Settings.ini","GameNames","GameName279","Real Ball")
IniWrite ("C:\Settings.ini","GameNames","GameName280","Real Jigsaw Puzzle")
IniWrite ("C:\Settings.ini","GameNames","GameName281","Redisruption")
IniWrite ("C:\Settings.ini","GameNames","GameName282","Ricochet Lost Worlds")
IniWrite ("C:\Settings.ini","GameNames","GameName283","Ricochet Lost Worlds Recharged")
IniWrite ("C:\Settings.ini","GameNames","GameName284","Ricochet Xtreme")
IniWrite ("C:\Settings.ini","GameNames","GameName285","Riotball")
IniWrite ("C:\Settings.ini","GameNames","GameName286","RIP")
IniWrite ("C:\Settings.ini","GameNames","GameName287","Rival Ball Tournament")
IniWrite ("C:\Settings.ini","GameNames","GameName288","River Raider II")
IniWrite ("C:\Settings.ini","GameNames","GameName289","Rocket Bowl")
IniWrite ("C:\Settings.ini","GameNames","GameName290","Rocket Mania Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName291","Rotate Mania Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName292","Runic One")
IniWrite ("C:\Settings.ini","GameNames","GameName293","Secret Chamber")
IniWrite ("C:\Settings.ini","GameNames","GameName294","Shape Solitaire")
IniWrite ("C:\Settings.ini","GameNames","GameName295","ShapeShifter")
IniWrite ("C:\Settings.ini","GameNames","GameName296","Shroomz")
IniWrite ("C:\Settings.ini","GameNames","GameName297","Sky Bubbles Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName298","Slickball")
IniWrite ("C:\Settings.ini","GameNames","GameName299","Slingo")
IniWrite ("C:\Settings.ini","GameNames","GameName300","Slingo Casino Pak")
IniWrite ("C:\Settings.ini","GameNames","GameName301","Slot Words")
IniWrite ("C:\Settings.ini","GameNames","GameName302","Slyder Adventures")
IniWrite ("C:\Settings.ini","GameNames","GameName303","Snail Mail")
IniWrite ("C:\Settings.ini","GameNames","GameName304","Snow Ball")
IniWrite ("C:\Settings.ini","GameNames","GameName305","Snowy Puzzle Islands")
IniWrite ("C:\Settings.ini","GameNames","GameName306","Snowy Space Trip")
IniWrite ("C:\Settings.ini","GameNames","GameName307","Snowy The Bears Adventure")
IniWrite ("C:\Settings.ini","GameNames","GameName308","Snowy Treasure Hunter")
IniWrite ("C:\Settings.ini","GameNames","GameName309","Snowy Treasure Hunter 2")
IniWrite ("C:\Settings.ini","GameNames","GameName310","Soda Pipes")
IniWrite ("C:\Settings.ini","GameNames","GameName311","Solitaire")
IniWrite ("C:\Settings.ini","GameNames","GameName312","Solitaire 2")
IniWrite ("C:\Settings.ini","GameNames","GameName313","Space Skramble")
IniWrite ("C:\Settings.ini","GameNames","GameName314","Space Taxi 2")
IniWrite ("C:\Settings.ini","GameNames","GameName315","Speed")
IniWrite ("C:\Settings.ini","GameNames","GameName316","Spellagories")
IniWrite ("C:\Settings.ini","GameNames","GameName317","Spellunker")
IniWrite ("C:\Settings.ini","GameNames","GameName318","Spin & Win")
IniWrite ("C:\Settings.ini","GameNames","GameName319","Splash")
IniWrite ("C:\Settings.ini","GameNames","GameName320","Sportball Challenge")
IniWrite ("C:\Settings.ini","GameNames","GameName321","Spring Sprang Sprung")
IniWrite ("C:\Settings.ini","GameNames","GameName322","Star Defender 2")
IniWrite ("C:\Settings.ini","GameNames","GameName323","Strike Ball")
IniWrite ("C:\Settings.ini","GameNames","GameName324","Sunny Ball")
IniWrite ("C:\Settings.ini","GameNames","GameName325","Super Bounce Out")
IniWrite ("C:\Settings.ini","GameNames","GameName326","Super Collapse")
IniWrite ("C:\Settings.ini","GameNames","GameName327","Super Collapse II")
IniWrite ("C:\Settings.ini","GameNames","GameName328","Super Cubes")
IniWrite ("C:\Settings.ini","GameNames","GameName329","Super Glinx")
IniWrite ("C:\Settings.ini","GameNames","GameName330","Super Groovy")
IniWrite ("C:\Settings.ini","GameNames","GameName331","Super Mahjong")
IniWrite ("C:\Settings.ini","GameNames","GameName332","Super Popcorn Machine")
IniWrite ("C:\Settings.ini","GameNames","GameName333","Super Spongebob Collapse")
IniWrite ("C:\Settings.ini","GameNames","GameName334","Super Text Twist")
IniWrite ("C:\Settings.ini","GameNames","GameName335","Superstar Chefs")
IniWrite ("C:\Settings.ini","GameNames","GameName336","Swap & Fall 2")
IniWrite ("C:\Settings.ini","GameNames","GameName337","Tablut")
IniWrite ("C:\Settings.ini","GameNames","GameName338","Tanks Evolution")
IniWrite ("C:\Settings.ini","GameNames","GameName339","TeamUp")
IniWrite ("C:\Settings.ini","GameNames","GameName340","Telltale Texas Hold'Em")
IniWrite ("C:\Settings.ini","GameNames","GameName341","Tennis Titans")
IniWrite ("C:\Settings.ini","GameNames","GameName342","Texas Hold 'Em Championship")
IniWrite ("C:\Settings.ini","GameNames","GameName343","The Cursed Wheel")
IniWrite ("C:\Settings.ini","GameNames","GameName344","The Great Mahjong")
IniWrite ("C:\Settings.ini","GameNames","GameName345","The Lost City of Gold")
IniWrite ("C:\Settings.ini","GameNames","GameName346","The Walls of Jericho")
IniWrite ("C:\Settings.ini","GameNames","GameName347","Think Tanks")
IniWrite ("C:\Settings.ini","GameNames","GameName348","Thomas And The Magical Words")
IniWrite ("C:\Settings.ini","GameNames","GameName349","Time Breaker")
IniWrite ("C:\Settings.ini","GameNames","GameName350","Top 10 Solitaire")
IniWrite ("C:\Settings.ini","GameNames","GameName351","Totem Treasure")
IniWrite ("C:\Settings.ini","GameNames","GameName352","Tradewinds 2")
IniWrite ("C:\Settings.ini","GameNames","GameName353","Traffic Jam Extreme")
IniWrite ("C:\Settings.ini","GameNames","GameName354","Treasure Fall")
IniWrite ("C:\Settings.ini","GameNames","GameName355","Treasure Machine")
IniWrite ("C:\Settings.ini","GameNames","GameName356","Trijinx")
IniWrite ("C:\Settings.ini","GameNames","GameName357","Triptych")
IniWrite ("C:\Settings.ini","GameNames","GameName358","Trivia Machine")
IniWrite ("C:\Settings.ini","GameNames","GameName359","TriviaNet Challenge")
IniWrite ("C:\Settings.ini","GameNames","GameName360","Troll")
IniWrite ("C:\Settings.ini","GameNames","GameName361","Truffle Tray")
IniWrite ("C:\Settings.ini","GameNames","GameName362","Tumble Bugs")
IniWrite ("C:\Settings.ini","GameNames","GameName363","Turtle Bay")
IniWrite ("C:\Settings.ini","GameNames","GameName364","Turtle Odyssey")
IniWrite ("C:\Settings.ini","GameNames","GameName365","Twinxoid")
IniWrite ("C:\Settings.ini","GameNames","GameName366","Twistingo")
IniWrite ("C:\Settings.ini","GameNames","GameName367","Universal Boxing Manager")
IniWrite ("C:\Settings.ini","GameNames","GameName368","Varmintz Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName369","Virticon Millennium")
IniWrite ("C:\Settings.ini","GameNames","GameName370","Void War")
IniWrite ("C:\Settings.ini","GameNames","GameName371","War Chess")
IniWrite ("C:\Settings.ini","GameNames","GameName372","Warblade")
IniWrite ("C:\Settings.ini","GameNames","GameName373","Warkanoid 2")
IniWrite ("C:\Settings.ini","GameNames","GameName374","Water Bugs")
IniWrite ("C:\Settings.ini","GameNames","GameName375","Weave Words")
IniWrite ("C:\Settings.ini","GameNames","GameName376","Wik And The Fable Of Souls")
IniWrite ("C:\Settings.ini","GameNames","GameName377","Wild West Wendy")
IniWrite ("C:\Settings.ini","GameNames","GameName378","Wonderland")
IniWrite ("C:\Settings.ini","GameNames","GameName379","Wonderland Secret Worlds")
IniWrite ("C:\Settings.ini","GameNames","GameName380","Word Blitz Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName381","Word Craft")
IniWrite ("C:\Settings.ini","GameNames","GameName382","Word Emperor")
IniWrite ("C:\Settings.ini","GameNames","GameName383","Word Harmony")
IniWrite ("C:\Settings.ini","GameNames","GameName384","Word Search Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName385","Word Slinger")
IniWrite ("C:\Settings.ini","GameNames","GameName386","Word Wizard Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName387","WordJong")
IniWrite ("C:\Settings.ini","GameNames","GameName388","Xeno Assault II")
IniWrite ("C:\Settings.ini","GameNames","GameName389","Xmas Bonus")
IniWrite ("C:\Settings.ini","GameNames","GameName390","Zam BeeZee")
IniWrite ("C:\Settings.ini","GameNames","GameName391","Zero Count")
IniWrite ("C:\Settings.ini","GameNames","GameName392","Zulu Gems")
IniWrite ("C:\Settings.ini","GameNames","GameName393","Zuma Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName394","Zzed")
IniWrite ("C:\Settings.ini","GameNames","GameName395","Hyperspace Invader")
IniWrite ("C:\Settings.ini","GameNames","GameName396","Gamino")
IniWrite ("C:\Settings.ini","GameNames","GameName397","Family Feud")
IniWrite ("C:\Settings.ini","GameNames","GameName398","Incrediball -  The Seven Sapphires")
IniWrite ("C:\Settings.ini","GameNames","GameName399","Alien Abduction")
IniWrite ("C:\Settings.ini","GameNames","GameName400","Flip Wit")
IniWrite ("C:\Settings.ini","GameNames","GameName401","Gekko Mahjong")
IniWrite ("C:\Settings.ini","GameNames","GameName402","African War")
IniWrite ("C:\Settings.ini","GameNames","GameName403","Gold Miner Vegas")
IniWrite ("C:\Settings.ini","GameNames","GameName404","Valentines Gift")
IniWrite ("C:\Settings.ini","GameNames","GameName405","Astral Masters")
IniWrite ("C:\Settings.ini","GameNames","GameName406","Academy of Magic Word Spells")
IniWrite ("C:\Settings.ini","GameNames","GameName407","Theseus Return of the Hero")
IniWrite ("C:\Settings.ini","GameNames","GameName408","Egg vs. Chicken")
IniWrite ("C:\Settings.ini","GameNames","GameName409","Tradewinds Legends")
IniWrite ("C:\Settings.ini","GameNames","GameName410","Shoot-n-Roll")
IniWrite ("C:\Settings.ini","GameNames","GameName411","Hotel Solitaire")
IniWrite ("C:\Settings.ini","GameNames","GameName412","Serpengo")
IniWrite ("C:\Settings.ini","GameNames","GameName413","Karu")
IniWrite ("C:\Settings.ini","GameNames","GameName414","Jewel Of Atlantis")
IniWrite ("C:\Settings.ini","GameNames","GameName415","Around The World")
IniWrite ("C:\Settings.ini","GameNames","GameName416","Strike Ball 2")
IniWrite ("C:\Settings.ini","GameNames","GameName417","Qbeez 2")
IniWrite ("C:\Settings.ini","GameNames","GameName418","Temple Of Jewels")
IniWrite ("C:\Settings.ini","GameNames","GameName419","Word Whacky")
IniWrite ("C:\Settings.ini","GameNames","GameName420","Luxor Amun Rising")
IniWrite ("C:\Settings.ini","GameNames","GameName421","Beads")
IniWrite ("C:\Settings.ini","GameNames","GameName422","Chainz 2")
IniWrite ("C:\Settings.ini","GameNames","GameName423","Feelers")
IniWrite ("C:\Settings.ini","GameNames","GameName424","Ice Puzzle Deluxe")
IniWrite ("C:\Settings.ini","GameNames","GameName425","7 Wonders")
IniWrite ("C:\Settings.ini","GameNames","GameName426","Rock Frenzy")
IniWrite ("C:\Settings.ini","GameNames","GameName427","Mosaic Tomb of Mystery")
IniWrite ("C:\Settings.ini","GameNames","GameName428","Froggy's Adventures")
IniWrite ("C:\Settings.ini","GameNames","GameName429","Poker Superstars II")
IniWrite ("C:\Settings.ini","GameNames","GameName430","Ancient Tripeaks")
IniWrite ("C:\Settings.ini","GameNames","GameName431","Magic Ball 2 New Worlds")
IniWrite ("C:\Settings.ini","GameNames","GameName432","Plantasia")
IniWrite ("C:\Settings.ini","GameNames","GameName433","City Magnate")
IniWrite ("C:\Settings.ini","GameNames","GameName434","Greedy Words")
IniWrite ("C:\Settings.ini","GameNames","GameName435","Mahjong The Endless Journey")
IniWrite ("C:\Settings.ini","GameNames","GameName436","Atlantis Quest")
IniWrite ("C:\Settings.ini","GameNames","GameName437","Cake Mania")
IniWrite ("C:\Settings.ini","GameNames","GameName438","Mighty Rodent")
IniWrite ("C:\Settings.ini","GameNames","GameName439","Greedy Words")
IniWrite ("C:\Settings.ini","GameNames","GameName440","Mahjong The Endless Journey")
IniWrite ("C:\Settings.ini","GameNames","GameName441","Atlantis Quest")
IniWrite ("C:\Settings.ini","GameNames","GameName442","7 Wonders")
IniWrite ("C:\Settings.ini","GameNames","GameName443","Easter Bonus")


EndIf

;Settings
;Use Ini file
$Progdir = IniRead("C:\settings.ini","GlobalSettings","Progdir", 1)
$Uninstallexe = IniRead("C:\settings.ini","GlobalSettings","Uninstallexe", 1)
$Switch = IniRead("C:\settings.ini","Switches","Switch", 1)
;MsgBox(4096, $switch,"Settings File available.",20)
;Readgame name for uninstall

$GameName = IniRead("C:\settings.ini","GameNames","GameName1", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall

;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName2", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName3", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName4", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName5", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall

;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName6", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName7", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName8", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName9", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName10", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName11", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName12", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName13", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName14", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName15", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName16", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName17", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName18", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName19", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName20", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName21", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName22", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName23", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName24", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName25", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName26", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName27", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall
;Readgame name for uninstall
$GameName = IniRead("C:\settings.ini","GameNames","GameName443", 1)

$Uninstaller = $Progdir & $GameName & "\" & $Uninstallexe
$UninstallerFinal = $Uninstaller & " " & $Switch

If FileExists($Uninstaller) Then
RUNWAIT($UninstallerFinal) 
ENDIF
;Endgame Uninstall

;Cleanup Inifile
FileDelete("C:\settings.ini")