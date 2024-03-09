
dofile("screen_reader_common.inc");
dofile("ui_utils.inc");

askText = "Due to the vast number of possible combinations that now exist with the new list of Resins, chem_helper has been broken into two scripts.\n\nchem_helper_cheap = Geb & Maat Soltions\n\nchem_helper = Set, Osiris, Thoth & Ra Solutions"

-- Initial values
compound_type = 6;
attrib_reqs = {
	{5,-1},
	{8,1},
	{7,1},
	{6,1}
};

max_essences = 5;

compound_reqs = {
--	{"Test",1,15},
	{"Geb",2,4},
	{"Maat",2,7},
	{"Set",3,7},
	{"Osiris",2,10},
	{"Thoth",3,10},
	{"Ra",2,13},
	{"Ra Brilliant",4,7}
};

mods = {
	[3]={"3",[-1]="-3"},
	[4]={"++",[-1]="--"},
	[6]={"6",[-1]="-6"},
	[7]={"+++",[-1]="---"},
	[9]={"9",[-1]="-9"},
	[10]={"++++",[-1]="----"},
	[12]={"12",[-1]="-12"},
	[13]={"+++++",[-1]="-----"},
	[15]={"15",[-1]="-15"},
};

attribs = {
	"Ar","As","Bi","Sa","So","Sp","Sw","To"
};

herb_list = {
"Allbright","Aloe","Altar's Blessing","Anansi","Apiphenalm","Apothecary's Scythe","Artemesia","Asafoetida","Asane","Ashoka","Azure Tristeria","Banto","Bay Tree",
"Bee Balm","Beetle Leaf","Beggar's Button","Bhillawa","Bilimbi","Bitter Florian","Black Pepper Plant","Blessed Mariae","Bleubillae","Blood Balm","Blood Blossom",
"Blood Root","Blooded Harebell","Bloodwort","Blue Damia","Blue Tarafern","Blueberry Tea Tree","Bluebottle Clover","Blushing Blossom","Borage","Brassy Caltrops",
"Brown Muskerro","Buckler-leaf","Bull's Blood","Burnt Tarragon","Butterfly Damia","Butterroot","Calabash","Camelmint","Caraway","Cardamom","Cassia","Chaffa",
"Chatinabrae","Chives","Chukkah","Cicada Bean","Cinnamon","Cinquefoil","Cirallis","Clingroot","Common Basil","Common Rosemary","Common Sage","Coriander",
"Corsacia","Covage","Crampbark","Cranesbill","Creeping Black Nightshade","Creeping Thyme","Crimson Clover","Crimson Lettuce","Crimson Nightshade","Crimson Pipeweed",
"Crimson Windleaf","Crumpled Leaf Basil","Curly Sage","Cyan Cressida","Daggerleaf","Dalchini","Dameshood","Dank Mullien","Dark Ochoa","Dark Radish","Death's Piping",
"Deadly Catsclaw","Dewplant","Digweed","Discorea","Drapeau D'or","Dusty Blue Sage","Dwarf Hogweed","Dwarf Wild Lettuce","Earth Apple","Elegia","Enchanter's Plant",
"Finlow","Fire Allspice","Fire Lily","Fivesleaf","Flaming Skirret","Flander's Blossom","Fleabane","Fool's Agar","Fumitory","Garcinia","Garlic Chives","Ginger Root",
"Ginger Tarragon","Ginseng Root","Glechoma","Gnemnon","Gokhru","Golden Doubloon","Golden Gladalia","Golden Sellia","Golden Sweetgrass","Golden Sun","Golden Thyme",
"Gynura","Harebell","Harrow","Hazlewort","Headache Tree","Heartsease","Hogweed","Homesteader Palm","Honey Mint","Houseleek","Hyssop","Ice Blossom","Ice Mint","Ilex",
"Indigo Damia","Ipomoea","Jagged Dewcup","Jaivanti","Jaiyanti","Joy of the Mountain","Jugwort","Katako Root","Khokali","King's Coin","Lamae","Larkspur","Lavender Navarre",
"Lavender Scented Thyme","Lemon Basil","Lemon Grass","Lemondrop","Lilia","Liquorice","Lungclot","Lythrum","Mahonia","Malice Weed","Mandrake Root","Maragosa","Mariae",
"Meadowsweet","Medicago","Mindanao","Miniature Bamboo","Miniature Lamae","Mirabellis Fern","Moon Aloe","Morpha","Motherwort","Mountain Mint","Myristica","Myrrh","Naranga",
"Nubian Liquorice","Octec's Grace","Opal Harebell","Orange Nasturtium","Orange Niali","Orange Sweetgrass","Orris","Pale Dhamasa","Pale Ochoa","Pale Russet","Pale Skirret",
"Panoe","Paradise Lily","Patchouli","Peppermint","Pippali","Pitcher Plant","Primula","Prisniparni","Pulmonaria Opal","Purple Tintiri","Quamash","Red Nasturtium",
"Red Pepper Plant","Revivia","Rhubarb","Royal Rosemary","Rubia","Rubydora","Sacred Palm","Sagar Ghota","Sandalwood","Sandy Dustweed","Satsatchi","Schisandra","Shrub Sage",
"Shrubby Basil","Shyama","Shyamalata","Sickly Root","Silvertongue Damia","Skirret","Sky Gladalia","Soapwort","Sorrel","Spinach","Spinnea","Squill","Steel Bladegrass",
"Stickler Hedge","Strawberry Tea","Strychnos","Sugar Cane","Sweet Groundmaple","Sweetflower","Sweetgrass","Sweetsop","Tagetese","Tamarask","Tangerine Dream","Thunder Plant",
"Thyme","Tiny Clover","Trilobe","Tristeria","True Tarragon","Tsangto","Tsatso","Turtle's Shell","Umber Basil","Upright Ochoa","Vanilla Tea Tree","Verdant Squill",
"Verdant Two-Lobe","Wasabi","Weeping Patala","White Pepper Plant","Whitebelly","Wild Garlic","Wild Lettuce","Wild Onion","Wild Yam","Wood Sage","Xanat","Xanosi","Yava",
"Yellow Gentian","Yellow Tristeria","Yigory","Zanthoxylum",
}
herbs = {};
for i=1,#herb_list do
	herbs[herb_list[i]] = 1;
end

resin_list = {
"Acacia","Acacia Sapling","Acacia Youth","Ackee","Ackee Sapling","Ackee Youth","Anaxi","Arconis","Ash Palm","Autumn Bloodbark","Autumn Bloodbark Sapling",
"Autumn Bloodbark Youth","Beetlenut","Blaze Maple","Blaze Maple Sapling","Blaze Maple Youth","Bloodbark","Bottle Tree","Bramble Hedge","Broadleaf Palm",
"Butterleaf Tree","Cerulean Blue","Chakkanut Tree","Chicory","Cinnar","Coconut Palm","Cricklewood","Deadwood Tree","Delta Palm","Dikbas","Dikbas Sapling"
,"Dikbas Youth","Elephantia","Feather Tree","Feather Tree Sapling","Feather Tree Youth","Fern Palm","Folded Birch","Giant Cricklewood","Golden Hemlock"
,"Golden Hemlock Sapling","Golden Hemlock Youth","Green Ash","Green Ash Sapling","Green Ash Youth","Hawthorn","Hokkaido","Illawara","Illawara Sapling"
,"Illawara Youth","Jacaranda","Jacaranda Sapling","Jacaranda Youth","Japanese Cherry","Japanese Cherry Sapling","Japanese Cherry Youth","Kaeshra","Katsura"
,"Katsura Sapling","Katsura Youth","Khaya","Khaya Sapling","Khaya Youth","Kotukutuku","Kotukutuku Sapling","Kotukutuku Youth","Locust Palm","Mimosa"
,"Mimosa Sapling","Mimosa Youth","Miniature Fern Palm","Mini Palmetto","Monkey Palm","Monterey Pine","Monterey Pine Sapling","Monterey Pine Youth"
,"Montu Maple","Oil Palm","Oleaceae","Oranje","Orrorin","Parrotia","Parrotia Sapling","Parrotia Youth","Passam","Peaches 'n Cream Maple"
,"Peaches 'n Cream Sapling","Peaches 'n Cream Youth","Phoenix Palm","Pratyeka Tree","Ranyahn","Razor Palm","Red Maple","River Birch","River Birch Sapling"
,"River Birch Youth","Royal Palm","Safsaf Sapling","Safsaf Willow","Safsaf Willow Youth","Savaka","Scaley Hardwood","Silky Oak","Spiked Fishtree"
,"Spindle Tree","Stout Palm","Summer Maple","Summer Maple Sapling","Summer Maple Youth","Sweet Pine","Tapacae Miralis","Tiny Oil Palm","Towering Palm"
,"Trilobellia","Umbrella Palm","White Pine","White Pine Sapling","White Pine Youth","Windriver Palm",
}
resins = {};
for i=1,#resin_list do
	resins[resin_list[i]] = 1;
end

chem_data = {
{"Acacia","67","7 Mineral, 3 Vegetable","6","2","0","0","0","-2","-1","3","-3"},
{"Acacia Sapling","87","9 Grey, 1 Vegetable","6","0","-1","-2","-3","0","0","0","3"},
{"Acacia Youth","10","10 Wood","6","0","1","2","-2","-1","0","0","0"},
{"Ackee","22","6 Grain, 4 Wood","6","0","-1","0","2","-3","-2","0","1"},
{"Ackee Sapling","17","7 Worm, 3 Wood","6","2","0","1","-1","3","0","-2","-3"},
{"Ackee Youth","10","10 Wood","6","-2","0","0","0","-1","3","1","2"},
{"Anaxi","46","6 Grain, 4 Mineral","6","0","-3","0","0","-1","0","0","3"},
{"Arconis","86","8 Grey, 2 Mineral","6","0","0","-3","1","-1","-2","0","0"},
{"Ash Palm","56","9 Vegetable, 1 Worm","6","0","0","0","1","-2","-1","-3","0"},
{"Autumn Bloodbark","42","6 Grain, 4 Vegetable","6","-1","1","0","0","0","-3","0","-2"},
{"Autumn Bloodbark Sapling","15","5 Worm, 5 Wood","6","-3","0","1","-1","0","-2","0","0"},
{"Autumn Bloodbark Youth","44","6 Vegetable, 4 Worm","6","2","-1","-2","0","0","1","0","0"},
{"Beetlenut","24","7 Grain, 3 Wood","6","-1","1","-3","-2","0","0","0","0"},
{"Blaze Maple","79","9 Fish, 1 Mineral","6","0","0","0","-3","0","3","-2","-1"},
{"Blaze Maple Sapling","84","9 Grey, 1 Grain","6","-2","0","1","0","0","0","3","-1"},
{"Blaze Maple Youth","86","8 Grey, 2 Mineral","6","-2","-3","0","-1","0","0","1","2"},
{"Bloodbark","22","6 Grain, 4 Wood","6","1","0","-2","3","0","0","-1","-3"},
{"Bottle Tree","51","7 Vegetable, 3 Grain","6","0","-1","0","2","0","-3","0","1"},
{"Bramble Hedge","28","8 Grain, 2 Worm","6","0","-1","0","3","-2","-3","0","0"},
{"Broadleaf Palm","83","9 Gray, 1 Worm","6","0","0","-3","0","0","-2","2","-1"},
{"Butterleaf Tree","77","7 Fish, 3 Mineral","6","-1","0","-2","-3","0","0","0","0"},
{"Cerulean Blue","56","9 Vegetable, 1 Worm","6","-1","0","1","0","-2","-3","3","0"},
{"Chakkanut Tree","42","6 Grain, 4 Vegetable","6","-3","-2","1","3","0","0","-1","2"},
{"Chicory","90","10 Grey","6","0","0","1","-3","-1","0","3","-2"},
{"Cinnar","23","7 Worm, 3 Grain","6","0","-2","0","1","-3","0","-1","0"},
{"Coconut Palm","39","7 Grain, 3 Vegetable","6","-1","3","0","-2","0","-3","0","1"},
{"Cricklewood","41","5 Grain, 4 Vegetable, 1 Worm","6","0","0","2","0","-2","-1","0","0"},
{"Deadwood Tree","31","7 Grain, 2 Worm, 1 Vegetable","6","-2","3","-1","0","0","-3","0","0"},
{"Delta Palm","14","8 Wood, 2 Grain","6","-1","2","1","-2","0","0","0","0"},
{"Dikbas","89","9 Grey, 1 Fish","6","0","-1","-2","3","0","-3","0","1"},
{"Dikbas Sapling","47","6 Vegetable, 3 Grain, 1 Worm","6","-1","3","0","0","0","1","-2","0"},
{"Dikbas Youth","15","5 Worm, 5 Wood","6","1","0","-1","3","-2","-3","0","0"},
{"Elephantia","59","7 Vegetable, 2 Mineral, 1 Grain","6","1","0","2","-2","-3","0","0","-1"},
{"Feather Tree","43","6 Grain, 3 Vegetable, 1 Mineral","6","0","0","-2","0","0","0","-1","0"},
{"Feather Tree Sapling","19","9 Worm, 1 Wood","6","2","0","0","-2","1","-3","-1","0"},
{"Feather Tree Youth","30","10 Grain","6","2","0","0","-1","0","0","-2","0"},
{"Fern Palm","40","5 Worm, 5 Vegetable","6","0","0","0","0","-1","3","-3","1"},
{"Folded Birch","34","9 Grain, 1 Mineral","6","0","-1","1","-2","0","0","0","0"},
{"Giant Cricklewood","7","3 Rock, 7 Wood","6","0","2","0","-2","0","1","-1","0"},
{"Golden Hemlock","2","8 Rock, 2 Wood","6","-2","1","2","0","0","0","-1","0"},
{"Golden Hemlock Sapling","8","2 Rock, 8 Wood","6","1","3","-3","0","-1","2","0","-2"},
{"Golden Hemlock Youth","62","8 Vegetable, 2 Mineral","6","0","-1","0","-3","0","1","-2","0"},
{"Green Ash","66","9 Mineral, 1 Grain","6","0","0","-1","0","1","0","0","-2"},
{"Green Ash Sapling","48","6 Vegetable, 4 Grain","6","-3","3","-1","0","2","0","0","-2"},
{"Green Ash Youth","35","7 Worm, 3 Mineral","6","-3","1","0","0","0","-2","-1","0"},
{"Hawthorn","34","9 Grain, 1 Mineral","6","0","-3","3","0","-1","0","0","0"},
{"Hokkaido","42","6 Grain, 4 Vegetable","6","3","0","0","-3","0","2","1","-1"},
{"Illawara","87","9 Grey, 1 Vegetable","6","-1","0","0","-3","-2","3","0","0"},
{"Illawara Sapling","9","1 Rock, 9 Wood","6","0","0","-2","0","0","3","-3","-1"},
{"Illawara Youth","76","6 Fish, 4 Mineral","6","0","-2","-1","2","3","0","0","0"},
{"Jacaranda","21","9 Worm, 1 Grain","6","-3","0","-2","-1","0","0","1","0"},
{"Jacaranda Sapling","45","5 Grain, 5 Vegetable","6","-1","-2","-3","2","0","0","1","0"},
{"Jacaranda Youth","39","7 Grain, 3 Vegetable","6","-1","1","-2","-3","0","0","0","0"},
{"Japanese Cherry","90","10 Grey","6","-3","0","-1","1","0","0","0","3"},
{"Japanese Cherry Sapling","41","5 Grain, 4 Vegetable, 1 Worm","6","0","0","1","0","0","-2","0","-1"},
{"Japanese Cherry Youth","63","7 Vegetable, 3 Mineral","6","0","0","0","-1","0","1","3","-2"},
{"Kaeshra","45","5 Grain, 5 Vegetable","6","-3","1","0","0","0","-1","-2","0"},
{"Katsura","45","5 Grain, 5 Vegetable","6","0","0","-3","1","-2","0","-1","3"},
{"Katsura Sapling","55","9 Vegetable, 1 Wood","6","0","-2","0","3","-1","0","0","0"},
{"Katsura Youth","68","8 Mineral, 2 Vegetable","6","0","0","0","2","0","-2","-1","0"},
{"Khaya","2","8 Rock, 2 Wood","6","3","0","-2","-1","0","1","0","0"},
{"Khaya Sapling","62","8 Vegetable, 2 Mineral","6","0","-2","0","-1","-3","1","0","0"},
{"Khaya Youth","80","10 Fish","6","0","0","0","0","-3","0","-1","1"},
{"Kotukutuku","32","7 Worm, 3 Vegetable","6","0","-3","0","-2","-1","3","0","0"},
{"Kotukutuku Sapling","8","2 Rock, 8 Wood","6","0","3","0","0","-1","-2","0","1"},
{"Kotukutuku Youth","23","7 Worm, 3 Grain","6","2","0","-3","0","1","-2","3","-1"},
{"Locust Palm","70","10 Mineral","6","-1","1","0","-2","0","0","0","0"},
{"Mimosa","33","9 Grain, 1 Vegetable","6","0","0","1","0","-2","3","-3","-1"},
{"Mimosa Sapling","77","7 Fish, 3 Mineral","6","3","0","0","-2","2","0","-1","1"},
{"Mimosa Youth","73","3 Fish, 7 Mineral","6","0","0","0","0","-3","-1","-2","1"},
{"Miniature Fern Palm","31","7 Grain, 2 Worm, 1 Vegetable","6","2","1","0","-3","-2","0","-1","3"},
{"Mini Palmetto","36","8 Grain, 2 Vegetable","6","-3","2","-1","0","-2","0","3","0"},
{"Monkey Palm","58","7 Mineral, 3 Grain","6","-1","0","-3","2","0","3","0","-2"},
{"Monterey Pine","60","10 Vegetable","6","-3","-1","0","-2","2","0","3","0"},
{"Monterey Pine Sapling","84","9 Grey, 1 Grain","6","1","-1","0","0","2","-3","0","0"},
{"Monterey Pine Youth","51","7 Vegetable, 3 Grain","6","-2","0","-3","0","0","1","0","-1"},
{"Montu Maple","1","9 Rock, 1 Wood","6","2","0","0","-2","-1","1","0","0"},
{"Oil Palm","49","5 Grain, 4 Mineral, 1 Vegetable","6","0","0","-1","-2","0","-3","0","1"},
{"Oleaceae","82","9 Gray, 1 Wood","6","3","-1","0","-2","-3","0","2","0"},
{"Oranje","66","9 Mineral, 1 Grain","6","-1","-3","0","0","2","1","0","-2"},
{"Orrorin","66","9 Mineral, 1 Grain","6","0","0","-2","-1","-3","0","1","0"},
{"Parrotia","73","3 Fish, 7 Mineral","6","-2","0","0","0","-3","2","-1","1"},
{"Parrotia Sapling","16","6 Worm, 4 Wood","6","-2","1","-1","3","0","-3","0","0"},
{"Parrotia Youth","33","9 Grain, 1 Vegetable","6","0","1","2","0","3","-2","-1","0"},
{"Passam","67","7 Mineral, 3 Vegetable","6","-1","-2","2","0","0","0","0","1"},
{"Peaches 'n Cream Maple","72","2 Fish, 8 Mineral","6","2","-3","1","0","0","0","-1","-2"},
{"Peaches 'n Cream Sapling","17","7 Worm, 3 Wood","6","-3","1","3","0","-2","2","-1","0"},
{"Peaches 'n Cream Youth","80","10 Fish","6","0","-2","0","-1","3","2","1","-3"},
{"Phoenix Palm","84","9 Grey, 1 Grain","6","2","1","0","0","0","3","-2","-1"},
{"Pratyeka Tree","68","8 Mineral, 2 Vegetable","6","1","-3","-1","0","0","0","-2","0"},
{"Ranyahn","24","7 Grain, 3 Wood","6","0","-2","-1","0","0","-3","3","1"},
{"Razor Palm","61","9 Vegetable, 1 Mineral","6","0","0","3","1","0","0","-1","-2"},
{"Red Maple","9","1 Rock, 9 Wood","6","-1","0","0","-3","0","-2","0","2"},
{"River Birch","34","9 Grain, 1 Mineral","6","-1","0","0","0","1","2","-2","-3"},
{"River Birch Sapling","85","1 Mineral, 1 Vegetable, 8 Grey","6","0","1","0","-2","-1","0","-3","0"},
{"River Birch Youth","80","10 Fish","6","0","3","0","0","-3","0","-2","-1"},
{"Royal Palm","36","8 Grain, 2 Vegetable","6","0","0","1","3","-1","0","-3","-2"},
{"Safsaf Sapling","77","7 Fish, 3 Mineral","6","0","0","2","-2","0","-1","-3","0"},
{"Safsaf Willow","27","7 Grain, 3 Worm","6","0","-1","0","1","-2","3","0","0"},
{"Safsaf Willow Youth","42","6 Grain, 4 Vegetable","6","2","0","-1","0","1","-2","-3","0"},
{"Savaka","33","9 Grain, 1 Vegetable","6","0","0","-2","0","-1","2","1","0"},
{"Scaley Hardwood","76","6 Fish, 4 Mineral","6","-1","0","1","-3","-2","0","0","0"},
{"Silky Oak","26","6 Grain, 4 Worm","6","0","3","0","-1","-2","1","0","0"},
{"Spiked Fishtree","50","5 Grain, 5 Mineral","6","0","3","2","0","0","-2","-1","-3"},
{"Spindle Tree","42","6 Grain, 4 Vegetable","6","-3","2","0","-2","0","0","-1","3"},
{"Stout Palm","42","6 Grain, 4 Vegetable","6","2","0","0","0","0","-2","1","-1"},
{"Summer Maple","53","8 Vegetable, 1 Grain, 1 Worm","6","0","-1","-2","1","0","2","3","-3"},
{"Summer Maple Sapling","36","8 Grain, 2 Vegetable","6","0","0","1","0","0","0","-1","3"},
{"Summer Maple Youth","2","8 Rock, 2 Wood","6","3","-1","0","0","2","-3","-2","1"},
{"Sweet Pine","28","8 Grain, 2 Worm","6","0","-1","3","1","0","0","-2","-3"},
{"Tapacae Miralis","71","1 Fish, 9 Mineral","6","0","-3","0","-1","0","2","1","-2"},
{"Tiny Oil Palm","15","5 Worm, 5 Wood","6","-3","0","0","0","-2","3","1","-1"},
{"Towering Palm","90","10 Grey","6","0","-3","-2","0","-1","0","1","0"},
{"Trilobellia","83","9 Gray, 1 Worm","6","0","0","-2","0","-1","0","-3","1"},
{"Umbrella Palm","84","9 Grey, 1 Grain","6","0","2","1","-2","-1","0","0","0"},
{"White Pine","59","7 Vegetable, 2 Mineral, 1 Grain","6","-1","3","0","-2","0","0","1","0"},
{"White Pine Sapling","40","5 Worm, 5 Vegetable","6","0","-2","0","-3","0","-1","0","1"},
{"White Pine Youth","71","1 Fish, 9 Mineral","6","3","0","-2","0","0","-3","-1","0"},
{"Windriver Palm","78","8 Fish, 2 Mineral","6","0","0","3","-2","1","-3","0","-1"},
{"Powdered Diamond","30","10 Grain","6","0","1","3","2","-2","0","-3","-1"},
{"Powdered Emerald","42","6 Grain, 4 Vegetable","6","0","-3","0","0","-1","1","0","-2"},
{"Powdered Opal","5","5 Rock, 5 Wood","6","0","0","-1","2","0","1","-2","0"},
{"Powdered Quartz","13","7 Wood, 3 Worm","6","2","0","-1","0","1","-2","0","0"},
{"Powdered Ruby","75","5 Fish, 5 Mineral","6","-1","-3","0","-2","0","2","0","0"},
{"Powdered Sapphire","13","7 Wood, 3 Worm","6","-2","0","0","-1","3","0","0","2"},
{"Powdered Topaz","34","9 Grain, 1 Mineral","6","0","-2","-1","0","2","3","0","0"},
{"Powdered Amethyst","83","9 Gray, 1 Worm","6","-1","3","2","0","-3","0","0","0"},
{"Powdered Citrine","10","10 Wood","6","0","-1","3","1","0","0","-3","0"},
{"Powdered Garnet","80","10 Fish","6","0","-2","0","-3","2","-1","0","1"},
{"Powdered Jade","20","10 Worm","6","-3","2","0","0","-2","-1","0","0"},
{"Powdered Lapis","49","5 Grain, 4 Mineral, 1 Vegetable","6","0","2","0","3","0","-1","0","1"},
{"Powdered Sunstone","52","8 Vegetable, 2 Worm","6","-1","0","0","-2","3","2","0","1"},
{"Powdered Turquoise","84","9 Grey, 1 Grain","6","-1","-2","-3","0","0","0","2","0"},
{"Powdered Almandine","48","6 Vegetable, 4 Grain","6","0","-3","2","-2","-1","0","0","0"},
{"Powdered Aquamarine","88","9 Grey, 1 Mineral","6","-2","0","0","-3","0","-1","1","0"},
{"Powdered Kunzite","15","5 Worm, 5 Wood","6","0","0","2","0","-2","-3","1","-1"},
{"Powdered Morganite","70","10 Mineral","6","2","0","0","-2","-1","0","1","0"},
--{"Powdered Aqua Pearl","","","6","","","","","","","",""},
--{"Powdered Beige Pearl","43","6 Grain, 3 Vegetable, 1 Mineral","6","","","","","","","",""},
--{"Powdered Black Pearl","34","9 Grain, 1 Mineral","6","","","","","","","",""},
--{"Powdered Coral Pearl","83","9 Gray, 1 Worm","6","","","","","","","",""},
--{"Powdered Pink Pearl","3","7 Rock, 3 Wood","6","","","","","","","",""},
--{"Powdered Smoke Pearl","11","9 Wood, 1 Worm","6","","","","","","","",""},
--{"Powdered White Pearl","","","6","","","","","","","",""},
{"Salts Of Aluminum","53","8 Vegetable, 1 Grain, 1 Worm","6","0","2","-2","-3","0","1","0","-1"},
{"Salts Of Antimony","16","6 Worm, 4 Wood","6","0","0","0","0","2","-3","0","-1"},
{"Salts Of Cobalt","9","1 Rock, 9 Wood","6","3","-2","-3","0","0","0","0","-1"},
{"Salts Of Copper","30","10 Grain","6","-3","0","0","-1","0","3","-2","0"},
{"Salts Of Gold","23","7 Worm, 3 Grain","6","-1","-3","0","-2","0","1","0","2"},
{"Salts Of Iron","34","9 Grain, 1 Mineral","6","0","0","0","0","-1","-3","0","-2"},
{"Salts Of Lead","69","9 Mineral, 1 Vegetable","6","0","-3","0","3","0","-2","0","-1"},
{"Salts Of Magnesium","20","10 Worm","6","1","0","-2","-1","-3","0","0","2"},
{"Salts Of Nickel","70","10 Mineral","6","3","0","-3","0","1","-1","2","-2"},
{"Salts Of Platinum","10","10 Wood","6","2","0","0","3","-3","0","1","-1"},
{"Salts Of Silver","76","6 Fish, 4 Mineral","6","0","0","-3","0","0","-2","-1","3"},
{"Salts Of Tin","80","10 Fish","6","-3","-1","0","0","1","2","0","0"},
{"Salts Of Zinc","59","7 Vegetable, 2 Mineral, 1 Grain","6","0","0","-1","0","-2","2","0","0"},
--{"Oyster Shell Marble Dust","","","6","","","","","","","",""},
--{"Allbright","","","6","","","","","","","",""},
{"Aloe","26","6 Grain, 4 Worm","6","3","0","0","-1","-2","1","0","0"},
--{"Altar's Blessing","31","7 Grain, 2 Worm, 1 Vegetable","6","","","","","","","",""},
{"Anansi","70","10 Mineral","6","2","0","-1","-2","-3","0","1","3"},
--{"Apiphenalm","","","6","","","","","","","",""},
--{"Apothecary's Scythe","","","6","","","","","","","",""},
--{"Artemesia","","","6","","","","","","","",""},
--{"Asafoetida","","","6","","","","","","","",""},
--{"Asane","","","6","","","","","","","",""},
{"Ashoka","45","5 Grain, 5 Vegetable","6","1","0","0","2","-2","0","0","-1"},
--{"Azure Tristeria","","","6","","","","","","","",""},
{"Banto","71","1 Fish, 9 Mineral","6","-1","1","2","0","0","-3","0","0"},
{"Bay Tree","74","4 Fish, 6 Mineral","6","-3","-2","-1","1","0","3","0","2"},
{"Bee Balm","3","7 Rock, 3 Wood","6","3","-1","0","-3","0","0","-2","0"},
{"Beetle Leaf","59","7 Vegetable, 2 Mineral, 1 Grain","6","3","-2","0","0","-1","0","1","0"},
{"Beggar's Button","70","10 Mineral","6","3","0","0","0","-1","-2","2","1"},
--{"Bhillawa","","","6","","","","","","","",""},
--{"Bilimbi","","","6","","","","","","","",""},
--{"Bitter Florian","","","6","","","","","","","",""},
{"Black Pepper Plant","3","7 Rock, 3 Wood","6","0","-1","-2","0","0","1","0","0"},
--{"Blessed Mariae","","","6","","","","","","","",""},
--{"Bleubillae","","","6","","","","","","","",""},
--{"Blood Balm","","","6","","","","","","","",""},
--{"Blood Blossom","","","6","","","","","","","",""},
--{"Blood Root","","","6","","","","","","","",""},
{"Blooded Harebell","59","7 Vegetable, 2 Mineral, 1 Grain","6","1","0","-2","0","-1","0","-3","0"},
--{"Bloodwort","","","6","","","","","","","",""},
--{"Blue Damia","1","9 Rock, 1 Wood","6","","","","","","","",""},
{"Blue Tarafern","79","9 Fish, 1 Mineral","6","-1","3","1","0","0","-2","-3","0"},
--{"Blueberry Tea Tree","","","6","","","","","","","",""},
{"Bluebottle Clover","77","7 Fish, 3 Mineral","6","3","0","-1","-3","1","0","-2","0"},
--{"Blushing Blossom","","","6","","","","","","","",""},
{"Borage","30","10 Grain","6","0","2","-1","0","0","1","-2","0"},
--{"Brassy Caltrops","","","6","","","","","","","",""},
{"Brown Muskerro","61","9 Vegetable, 1 Mineral","6","1","0","-1","-2","0","0","0","0"},
{"Buckler-leaf","30","10 Grain","6","1","-1","2","0","-2","0","-3","0"},
--{"Bull's Blood","","","6","","","","","","","",""},
{"Burnt Tarragon","68","8 Mineral, 2 Vegetable","6","3","-1","2","0","0","-3","0","-2"},
--{"Butterfly Damia","","","6","","","","","","","",""},
--{"Butterroot","","","6","","","","","","","",""},
--{"Calabash","","","6","","","","","","","",""},
--{"Camelmint","","","6","","","","","","","",""},
{"Caraway","4","6 Rock, 4 Wood","6","2","0","0","0","0","-1","-2","1"},
{"Cardamom","61","9 Vegetable, 1 Mineral","6","-2","2","-3","0","1","0","0","-1"},
--{"Cassia","","","6","","","","","","","",""},
{"Chaffa","79","9 Fish, 1 Mineral","6","-3","-1","0","0","-2","0","1","0"},
{"Chatinabrae","82","9 Gray, 1 Wood","6","0","0","0","-2","0","-1","3","1"},
{"Chives","30","10 Grain","6","1","-1","-3","0","-2","0","0","0"},
--{"Chukkah","","","6","","","","","","","",""},
--{"Cicada Bean","48","6 Vegetable, 4 Grain","6","","","","","","","",""},
{"Cinnamon","80","10 Fish","6","-1","-3","0","0","0","0","2","0"},
--{"Cinquefoil","48","6 Vegetable, 4 Grain","6","","","","","","","",""},
--{"Cirallis","","","6","","","","","","","",""},
--{"Clingroot","44","6 Vegetable, 4 Worm","6","","","","","","","",""},
{"Common Basil","16","6 Worm, 4 Wood","6","0","0","-1","-2","0","1","2","0"},
{"Common Rosemary","75","5 Fish, 5 Mineral","6","2","3","-3","1","-1","0","-2","0"},
{"Common Sage","34","9 Grain, 1 Mineral","6","3","1","-1","2","-3","-2","0","0"},
--{"Coriander","80","10 Fish","6","","","","","","","",""},
--{"Corsacia","","","6","","","","","","","",""},
--{"Covage","71","1 Fish, 9 Mineral","6","","","","","","","",""},
{"Crampbark","29","9 Grain, 1 Worm","6","0","-1","0","1","-2","-3","0","0"},
--{"Cranesbill","","","6","","","","","","","",""},
--{"Creeping Black Nightshade","","","6","","","","","","","",""},
--{"Creeping Thyme","","","6","","","","","","","",""},
--{"Crimson Clover","81","9 Gray, 1 Rock","6","","","","","","","",""},
{"Crimson Lettuce","68","8 Mineral, 2 Vegetable","6","0","0","3","-2","-3","1","0","-1"},
--{"Crimson Nightshade","","","6","","","","","","","",""},
--{"Crimson Pipeweed","26","6 Grain, 4 Worm","6","","","","","","","",""},
--{"Crimson Windleaf","","","6","","","","","","","",""},
--{"Crumpled Leaf Basil","57","9 Vegetable, 1 Grain","6","","","","","","","",""},
--{"Curly Sage","","","6","","","","","","","",""},
--{"Cyan Cressida","","","6","","","","","","","",""},
{"Daggerleaf","76","6 Fish, 4 Mineral","6","-3","3","0","-1","0","0","-2","0"},
--{"Dalchini","51","7 Vegetable, 3 Grain","6","","","","","","","",""},
--{"Dameshood","73","3 Fish, 7 Mineral","6","","","","","","","",""},
--{"Dank Mullien","","","6","","","","","","","",""},
{"Dark Ochoa","10","10 Wood","6","-3","-1","-2","0","0","3","0","2"},
--{"Dark Radish","71","1 Fish, 9 Mineral","6","","","","","","","",""},
--{"Death's Piping","","","6","","","","","","","",""},
--{"Deadly Catsclaw","","","6","","","","","","","",""},
--{"Dewplant","","","6","","","","","","","",""},
--{"Digweed","22","6 Grain, 4 Wood","6","","","","","","","",""},
{"Discorea","9","1 Rock, 9 Wood","6","-1","0","-2","0","0","0","2","-3"},
{"Drapeau D'or","16","6 Worm, 4 Wood","6","0","-1","0","3","-3","1","-2","0"},
{"Dusty Blue Sage","66","9 Mineral, 1 Grain","6","0","0","-3","2","3","-1","0","0"},
{"Dwarf Hogweed","39","7 Grain, 3 Vegetable","6","0","-2","0","-1","-3","1","0","0"},
--{"Dwarf Wild Lettuce","42","6 Grain, 4 Vegetable","6","","","","","","","",""},
{"Earth Apple","74","4 Fish, 6 Mineral","6","3","-2","0","2","-1","0","1","-3"},
{"Elegia","45","5 Grain, 5 Vegetable","6","-3","0","0","0","2","0","-1","-2"},
--{"Enchanter's Plant","","","6","","","","","","","",""},
{"Finlow","55","9 Vegetable, 1 Wood","6","3","0","0","-1","0","-2","1","2"},
--{"Fire Allspice","","","6","","","","","","","",""},
--{"Fire Lily","","","6","","","","","","","",""},
--{"Fivesleaf","86","8 Grey, 2 Mineral","6","","","","","","","",""},
--{"Flaming Skirret","","","6","","","","","","","",""},
{"Flander's Blossom","82","9 Gray, 1 Wood","6","0","-2","1","-1","-3","0","0","0"},
{"Fleabane","39","7 Grain, 3 Vegetable","6","2","-1","0","-2","0","0","0","0"},
{"Fool's Agar","25","5 Grain, 5 Worm","6","3","-2","-3","1","0","-1","0","2"},
--{"Fumitory","6","4 Rock, 6 Wood","6","","","","","","","",""},
{"Garcinia","20","10 Worm","6","0","2","-1","0","-3","0","-2","0"},
--{"Garlic Chives","74","4 Fish, 6 Mineral","6","","","","","","","",""},
{"Ginger Root","21","9 Worm, 1 Grain","6","2","-3","1","-1","0","-2","0","0"},
--{"Ginger Tarragon","","","6","","","","","","","",""},
{"Ginseng Root","50","5 Grain, 5 Mineral","6","1","-2","-1","0","0","2","3","0"},
{"Glechoma","64","6 Vegetable, 4 Mineral","6","0","3","0","0","-3","0","-1","0"},
--{"Gnemnon","59","7 Vegetable, 2 Mineral, 1 Grain","6","","","","","","","",""},
{"Gokhru","50","5 Grain, 5 Mineral","6","-1","0","-3","3","0","0","1","-2"},
--{"Golden Doubloon","","","6","","","","","","","",""},
--{"Golden Gladalia","","","6","","","","","","","",""},
--{"Golden Sellia","","","6","","","","","","","",""},
--{"Golden Sweetgrass","","","6","","","","","","","",""},
--{"Golden Sun","","","6","","","","","","","",""},
{"Golden Thyme","31","7 Grain, 2 Worm, 1 Vegetable","6","0","1","0","3","-1","0","-3","-2"},
{"Gynura","28","8 Grain, 2 Worm","6","-1","1","0","0","-2","-3","0","3"},
{"Harebell","35","7 Worm, 3 Mineral","6","-2","0","2","0","-1","0","0","1"},
--{"Harrow","15","5 Worm, 5 Wood","6","","","","","","","",""},
{"Hazlewort","22","6 Grain, 4 Wood","6","0","2","0","0","-3","-1","3","0"},
--{"Headache Tree","70","10 Mineral","6","","","","","","","",""},
--{"Heartsease","","","6","","","","","","","",""},
--{"Hogweed","33","9 Grain, 1 Vegetable","6","","","","","","","",""},
--{"Homesteader Palm","","","6","","","","","","","",""},
--{"Honey Mint","30","10 Grain","6","","","","","","","",""},
{"Houseleek","8","2 Rock, 8 Wood","6","3","0","2","-1","0","0","0","-2"},
{"Hyssop","16","6 Worm, 4 Wood","6","-1","1","0","-2","0","0","0","2"},
--{"Ice Blossom","","","6","","","","","","","",""},
--{"Ice Mint","","","6","","","","","","","",""},
--{"Ilex","33","9 Grain, 1 Vegetable","6","","","","","","","",""},
{"Indigo Damia","21","9 Worm, 1 Grain","6","-3","0","0","0","0","-1","-2","1"},
--{"Ipomoea","56","9 Vegetable, 1 Worm","6","","","","","","","",""},
--{"Jagged Dewcup","64","6 Vegetable, 4 Mineral","6","","","","","","","",""},
--{"Jaivanti","","","6","","","","","","","",""},
--{"Jaiyanti","","","6","","","","","","","",""},
--{"Joy of the Mountain","11","9 Wood, 1 Worm","6","","","","","","","",""},
--{"Jugwort","","","6","","","","","","","",""},
--{"Katako Root","72","2 Fish, 8 Mineral","6","","","","","","","",""},
--{"Khokali","59","7 Vegetable, 2 Mineral, 1 Grain","6","","","","","","","",""},
--{"King's Coin","","","6","","","","","","","",""},
--{"Lamae","","","6","","","","","","","",""},
--{"Larkspur","10","10 Wood","6","","","","","","","",""},
--{"Lavender Navarre","47","6 Vegetable, 3 Grain, 1 Worm","6","","","","","","","",""},
--{"Lavender Scented Thyme","59","7 Vegetable, 2 Mineral, 1 Grain","6","","","","","","","",""},
--{"Lemon Basil","","","6","","","","","","","",""},
--{"Lemon Grass","","","6","","","","","","","",""},
{"Lemondrop","8","2 Rock, 8 Wood","6","-1","0","2","1","-2","-3","0","0"},
--{"Lilia","","","6","","","","","","","",""},
--{"Liquorice","87","9 Grey, 1 Vegetable","6","","","","","","","",""},
--{"Lungclot","84","9 Grey, 1 Grain","6","","","","","","","",""},
--{"Lythrum","46","6 Grain, 4 Mineral","6","","","","","","","",""},
--{"Mahonia","23","7 Worm, 3 Grain","6","","","","","","","",""},
--{"Malice Weed","","","6","","","","","","","",""},
--{"Mandrake Root","","","6","","","","","","","",""},
--{"Maragosa","","","6","","","","","","","",""},
{"Mariae","20","10 Worm","6","2","-1","0","0","3","0","1","-2"},
{"Meadowsweet","1","9 Rock, 1 Wood","6","-2","0","-3","-1","3","1","2","0"},
--{"Medicago","4","6 Rock, 4 Wood","6","","","","","","","",""},
{"Mindanao","12","9 Wood, 1 Grain","6","-2","2","0","1","3","0","-1","0"},
--{"Miniature Bamboo","56","9 Vegetable, 1 Worm","6","","","","","","","",""},
--{"Miniature Lamae","15","5 Worm, 5 Wood","6","","","","","","","",""},
--{"Mirabellis Fern","80","10 Fish","6","","","","","","","",""},
--{"Moon Aloe","84","9 Grey, 1 Grain","6","","","","","","","",""},
{"Morpha","78","8 Fish, 2 Mineral","6","-2","-3","2","0","-1","1","0","0"},
{"Motherwort","2","8 Rock, 2 Wood","6","1","0","-1","0","3","2","0","-3"},
{"Mountain Mint","12","9 Wood, 1 Grain","6","0","0","-3","0","3","-1","0","2"},
{"Myristica","90","10 Grey","6","0","0","3","-3","-1","0","-2","0"},
--{"Myrrh","13","7 Wood, 3 Worm","6","","","","","","","",""},
--{"Naranga","","","6","","","","","","","",""},
--{"Nubian Liquorice","","","6","","","","","","","",""},
--{"Octec's Grace","","","6","","","","","","","",""},
--{"Opal Harebell","74","4 Fish, 6 Mineral","6","","","","","","","",""},
--{"Orange Nasturtium","","","6","","","","","","","",""},
--{"Orange Niali","9","1 Rock, 9 Wood","6","","","","","","","",""},
--{"Orange Sweetgrass","26","6 Grain, 4 Worm","6","","","","","","","",""},
--{"Orris","","","6","","","","","","","",""},
{"Pale Dhamasa","53","8 Vegetable, 1 Grain, 1 Worm","6","0","0","-3","0","-1","1","-2","3"},
--{"Pale Ochoa","83","9 Gray, 1 Worm","6","","","","","","","",""},
--{"Pale Russet","26","6 Grain, 4 Worm","6","","","","","","","",""},
--{"Pale Skirret","","","6","","","","","","","",""},
--{"Panoe","66","9 Mineral, 1 Grain","6","","","","","","","",""},
--{"Paradise Lily","","","6","","","","","","","",""},
--{"Patchouli","52","8 Vegetable, 2 Worm","6","","","","","","","",""},
--{"Peppermint","29","9 Grain, 1 Worm","6","","","","","","","",""},
--{"Pippali","80","10 Fish","6","","","","","","","",""},
--{"Pitcher Plant","91","10 Grey","6","","","","","","","",""},
--{"Primula","19","9 Worm, 1 Wood","6","","","","","","","",""},
--{"Prisniparni","81","9 Gray, 1 Rock","6","","","","","","","",""},
--{"Pulmonaria Opal","5","5 Rock, 5 Wood","6","","","","","","","",""},
--{"Purple Tintiri","50","5 Grain, 5 Mineral","6","","","","","","","",""},
--{"Quamash","","","6","","","","","","","",""},
{"Red Nasturtium","74","4 Fish, 6 Mineral","6","0","1","2","0","3","-1","0","-2"},
--{"Red Pepper Plant","","","6","","","","","","","",""},
--{"Revivia","","","6","","","","","","","",""},
--{"Rhubarb","33","9 Grain, 1 Vegetable","6","","","","","","","",""},
--{"Royal Rosemary","","","6","","","","","","","",""},
--{"Rubia","","","6","","","","","","","",""},
--{"Rubydora","","","6","","","","","","","",""},
--{"Sacred Palm","","","6","","","","","","","",""},
--{"Sagar Ghota","","","6","","","","","","","",""},
--{"Sandalwood","","","6","","","","","","","",""},
--{"Sandy Dustweed","","","6","","","","","","","",""},
{"Satsatchi","37","6 Grain, 3 Vegetable, 1 Wood","6","0","0","3","-3","0","-2","1","-1"},
--{"Schisandra","","","6","","","","","","","",""},
{"Shrub Sage","21","9 Worm, 1 Grain","6","-3","-1","0","-2","0","2","0","0"},
--{"Shrubby Basil","15","5 Worm, 5 Wood","6","","","","","","","",""},
--{"Shyama","","","6","","","","","","","",""},
--{"Shyamalata","","","6","","","","","","","",""},
--{"Sickly Root","","","6","","","","","","","",""},
--{"Silvertongue Damia","30","10 Grain","6","","","","","","","",""},
--{"Skirret","","","6","","","","","","","",""},
--{"Sky Gladalia","","","6","","","","","","","",""},
--{"Soapwort","77","7 Fish, 3 Mineral","6","","","","","","","",""},
--{"Sorrel","18","8 Worm, 2 Wood","6","","","","","","","",""},
--{"Spinach","35","7 Worm, 3 Mineral","6","","","","","","","",""},
--{"Spinnea","","","6","","","","","","","",""},
--{"Squill","","","6","","","","","","","",""},
--{"Steel Bladegrass","","","6","","","","","","","",""},
{"Stickler Hedge","36","8 Grain, 2 Vegetable","6","-1","1","0","-3","0","0","3","-2"},
{"Strawberry Tea","80","10 Fish","6","-2","-1","0","0","0","1","0","-3"},
--{"Strychnos","","","6","","","","","","","",""},
--{"Sugar Cane","39","7 Grain, 3 Vegetable","6","","","","","","","",""},
--{"Sweet Groundmaple","","","6","","","","","","","",""},
--{"Sweetflower","3","7 Rock, 3 Wood","6","","","","","","","",""},
--{"Sweetgrass","60","10 Vegetable","6","","","","","","","",""},
--{"Sweetsop","73","3 Fish, 7 Mineral","6","","","","","","","",""},
--{"Tagetese","41","5 Grain, 4 Vegetable, 1 Worm","6","","","","","","","",""},
--{"Tamarask","","","6","","","","","","","",""},
--{"Tangerine Dream","","","6","","","","","","","",""},
--{"Thunder Plant","","","6","","","","","","","",""},
{"Thyme","74","4 Fish, 6 Mineral","6","0","-3","3","0","2","0","-2","-1"},
{"Tiny Clover","25","5 Grain, 5 Worm","6","-3","2","-2","0","0","0","-1","0"},
--{"Trilobe","","","6","","","","","","","",""},
--{"Tristeria","","","6","","","","","","","",""},
--{"True Tarragon","20","10 Worm","6","","","","","","","",""},
--{"Tsangto","30","10 Grain","6","","","","","","","",""},
--{"Tsatso","","","6","","","","","","","",""},
--{"Turtle's Shell","","","6","","","","","","","",""},
--{"Umber Basil","","","6","","","","","","","",""},
--{"Upright Ochoa","","","6","","","","","","","",""},
--{"Vanilla Tea Tree","","","6","","","","","","","",""},
{"Verdant Squill","26","6 Grain, 4 Worm","6","0","2","0","0","-3","-2","1","-1"},
--{"Verdant Two-Lobe","","","6","","","","","","","",""},
--{"Wasabi","","","6","","","","","","","",""},
--{"Weeping Patala","","","6","","","","","","","",""},
--{"White Pepper Plant","","","6","","","","","","","",""},
--{"Whitebelly","","","6","","","","","","","",""},
--{"Wild Garlic","","","6","","","","","","","",""},
{"Wild Lettuce","20","","6","1","-3","-2","-1","0","0","0","3"},
--{"Wild Onion","54","","6","","","","","","","",""},
--{"Wild Yam","","","6","","","","","","","",""},
--{"Wood Sage","","","6","","","","","","","",""},
--{"Xanat","","","6","","","","","","","",""},
{"Xanosi","82","","6","0","0","-2","0","0","-1","1","-3"},
--{"Yava","3","","6","","","","","","","",""},
--{"Yellow Gentian","","","6","","","","","","","",""},
--{"Yellow Tristeria","","","6","","","","","","","",""},
--{"Yigory","63","","6","","","","","","","",""},
--{"Zanthoxylum","","","6","","","","","","","",""},
--{"Camel Pheromones (Female)","","","6","","","","","","","",""},
--{"Camel Pheromones (Male)","","","6","","","","","","","",""},
};

function color(s)
	if herbs[s] then
		return 0x80D080ff;
	elseif resins[s] then
		return 0xD0D080ff;
	else
		return 0x808080ff;
	end
end

solve_result = {};
solve_tooltip = {};
solve_lists = {};
dp = {};
dp_count = 0;

function addResult(s, tip)
	local index = #solve_result+1;
	solve_result[index] = s;
	solve_tooltip[index] = tip;
end

function key_from_vars(vars)
	local r = 0;
	local i;
	for i=1,#vars do
		r = r*100;
		r = r + vars[i]+50;
	end
	return r;
end

-- value is a list of essence indices
function cache(left, index, key, value)
	if not dp[left] then
		dp[left] = {};
	end
	if not dp[left][index] then
		dp[left][index] = {};
	end
	if not dp[left][index][key] then
		dp[left][index][key] = {};
	end
	dp[left][index][key][#dp[left][index][key]+1] = value;
end

function iscached(left, index, key)
	if not dp[left] then
		return nil;
	end
	if not dp[left][index] then
		return nil;
	end
	return dp[left][index][key];
end
-- returns a list of lists
function getcache(left, index, key)
	if not dp[left] then
		return nil;
	end
	if not dp[left][index] then
		return nil;
	end
	if not dp[left][index][key] then
		return nil;
	end
	if dp[left][index][key][1][1] == 0 then
		return nil;
	end
	return dp[left][index][key];
end


function dodp(left, index, vars)
	if (index > #chem_data) then
		return nil;
	end
	if (left == 0) then
		error 'assert';
	end
	local key=key_from_vars(vars);
	if iscached(left, index, key) then
		--lsPrintln("cached: " .. left .. "," .. index .. "," .. vars[1]);
		return getcache(left, index, key);
	end
	--lsPrintln("uncach: " .. left .. "," .. index .. "," .. vars[1]);
	dp_count = dp_count + 1;
	if (dp_count % 5000) == 0 then
		statusScreen("Solving...  Searched " .. dp_count .. "...");
	end
	local i;
	local j;

	-- Try not using this index
	local ret = dodp(left, index+1, vars);
	if ret then
		for i=1, #ret do
			-- cache results of not using this one into this index
			cache(left, index, key, ret[i]);
		end
	end

	-- Try using this index
	local newvars = {};
	for i=1, compound_reqs[compound_type][2] do
		newvars[i] = vars[i] + chem_data[index][4 + attrib_reqs[i][1]];
	end
	if (left == 1) then
		-- check it
		local good = true;
		for i=1, compound_reqs[compound_type][2] do
			local sign = attrib_reqs[i][2];
			if newvars[i]*sign < compound_reqs[compound_type][3] then
				good = nil;
			end
		end
		if good then
			cache(left, index, key, {index});
		end
	else
		-- Check if possible
		local possible=true;
		for i=1, compound_reqs[compound_type][2] do
			local sign = attrib_reqs[i][2];
			if vars[i]*sign + left*3 < compound_reqs[compound_type][3] then
				possible = nil;
			end
		end
		if not possible then
			-- not searching below
		else
			local ret = dodp(left-1, index+1, newvars);
			if ret then
				for i=1, #ret do
					local tail = ret[i];
					local newlist = {index};
					for j=1, #tail do
						newlist[j+1] = tail[j];
					end
					cache(left, index, key, newlist);
				end
			end
		end
	end

	if not iscached(left, index, key) then
		cache(left, index, key, {0});
		if not iscached(left, index, key) then
			error 'assert 2';
		end
	end

	return getcache(left, index, key);
end

function solve()
	local i, j;
	solve_result = {};
	solve_tooltip = {};
	solve_lists = {};
	dp = {};
	dp_count = 0;
	local vars = {};
	for i=1, compound_reqs[compound_type][2] do
		vars[#vars+1] = 0;
	end
	local ret = dodp(max_essences, 1, vars);
	if ret then
		solve_lists = ret;
		addResult("Searched: " .. dp_count .. " Found: " .. #ret, nil);
		local s = "";
		for i=1, compound_reqs[compound_type][2] do
			s = s .. attribs[attrib_reqs[i][1]] .. " " .. mods[compound_reqs[compound_type][3]][attrib_reqs[i][2]];
			if not (i == compound_reqs[compound_type][2]) then
				s = s .. " || ";
			end
		end
		if false then
			local head = s;
			for i=1, #ret do
				local s = "";
				local list = ret[i];
				for j=1, #list do
					local index = list[j];
					s = s .. chem_data[index][1];
					if not (j == #list) then
						s = s .. " || ";
					end
				end
				lsPrintln("| " .. head .. " || " .. s .. " |");
				if false then
					local combined = s;
					local tip = "";
					for j=1, #list do
						local index = list[j];
						s = "    " .. chem_data[index][1] .. " (" .. chem_data[index][3] .. ")";
						tip = tip .. s;
						if not (j == #list) then
							tip = tip .. "\n";
						end
						lsPrintln(s);
					end
					--addResult(combined, tip);
				end
			end
		end
	else
		addResult("Searched: " .. dp_count, nil);
		addResult("No solution was found", nil);
	end
end

function doit()
	askForWindow(askText);
	local selected = {};
	local chem_cache = nil;
	local scale = 25/16.0;
	z = 1;
	tip = "";
	while 1 do
		lsSetCamera(0, 0, lsScreenX*scale, lsScreenY*scale);
		local maxX = lsScreenX*scale;
		local maxY = lsScreenY*scale;
		for i=1,#compound_reqs do
			x = (i-1)*60;
			if compound_type == i then
				lsPrint(x, 5, z, 1, 1, 0xFFFFFFff, compound_reqs[i][1]);
			elseif lsButtonText(x, 5, z, 60, 0xFFFFFFff, compound_reqs[i][1]) then
				compound_type = i
			end
		end

		x=10;
		y=32;
		for i=1, compound_reqs[compound_type][2] do

			attrib_reqs[i][1] = lsDropdown("ChemDropDown" .. i, x, y, z, 50,
				attrib_reqs[i][1], attribs);
			if lsButtonText(x+50, y, z, 100, 0xFFFFFFff, mods[compound_reqs[compound_type][3]][attrib_reqs[i][2]]) then
				attrib_reqs[i][2] = -attrib_reqs[i][2];
			end

			y=y+26;
		end

		y = y+5;

		if lsButtonText(0, y, z, 100, 0xFFFFFFff, "Solve") then
			statusScreen("Solving... (this may take a while)");
			statusScreen("Solving... (this may take a while)");
			solve();
			statusScreen("Done solving, generating ingredient browser...");
			statusScreen("Done solving, generating ingredient browser...");
			selected = {};
			chem_cache = nil;
		end
		y=y+30;

		if false then
			if lsButtonText(0, y, z, 400, 0xFFFFFFff, "Generate all to console") then
				statusScreen("Working... (this will take ages");
				for a11=1, 8 do
					attrib_reqs[1][1]=a11;
					for a12=-1,1,2 do
						attrib_reqs[1][2]=a12;
						for a21=attrib_reqs[1][1]+1, 8 do
							attrib_reqs[2][1]=a21;
							for a22=-1,1,2 do
								attrib_reqs[2][2]=a22;
								local s = "";
								for i=1, compound_reqs[compound_type][2] do
									s = s .. attribs[attrib_reqs[i][1]] .. " " .. mods[compound_reqs[compound_type][3]][attrib_reqs[i][2]];
									if not (i == compound_reqs[compound_type][2]) then
										s = s .. ", ";
									end
								end
								statusScreen("Solving " .. s);
								solve();
							end
						end
					end
				end
			end
		end

		y=y+45;


		local max_solutions = #solve_result;
		if max_solutions > 30 then
			max_solutions = 30;
		end

		for i=1, max_solutions do
			if solve_tooltip[i] then
				if lsButtonText(10, y, z, maxX - 12, 0xFFFFFFff, solve_result[i]) then
					tip = solve_tooltip[i];
				end
			else
				lsPrint(10, y, z, 1, 1, 0xFFFFFFff, solve_result[i]);
			end
			y=y+26;
		end

		if tip then
			lsPrintWrapped(150, 32, z+1, maxX - 150, 0.7, 0.7, 0xFFFFFFff, tip);
		end

		-- heirarchical display
		for i=#selected, 1, -1 do
			if lsButtonText(165, 32+(i-1)*26, z, maxX - 165, color(chem_data[selected[i]][1]), chem_data[selected[i]][1] .. " (" .. chem_data[selected[i]][3] .. ")") then
				-- remove it
				for j=i, #selected-1 do
					selected[j] = selected[j+1];
				end
				selected[#selected] = nil;
				chem_cache = nil;
			end
		end

		local build_cache = false;
		if not chem_cache then
			build_cache = true;
			chem_cache = {};
		end
		lsScrollAreaBegin("ChemDataScrollArea", 5, y, z-1, 318, maxY - y);
		y = 0;
		-- reduce recipes to those that are valid
		local ingredient_recipe_count = {};
		if build_cache then
			for j=1, #solve_lists do
				-- check if recipe matches current list
				local this_valid = true;
				for ii=1, #selected do
					local found=false;
					for k=1, max_essences do
						if selected[ii] == solve_lists[j][k] then
							found = true;
						end
					end
					if not found then
						this_valid = false;
					end
				end
				if this_valid then
					for k=1, max_essences do
						local idx = solve_lists[j][k];
						if ingredient_recipe_count[idx] then
							ingredient_recipe_count[idx] = ingredient_recipe_count[idx] + 1;
						else
							ingredient_recipe_count[idx] = 1;
						end
					end
				end
			end
			for j=1, #selected do
				ingredient_recipe_count[selected[j]] = nil;
			end
		end
		clear_cache = false;
		for i=1, #chem_data do
			if build_cache then
				local skip=false;
				recipe_count = ingredient_recipe_count[i];

				if (#solve_lists > 0) and (recipe_count == #solve_lists) then
					selected[#selected+1] = i;
					clear_cache = true;
					recipe_count = nil
				end
				chem_cache[i] = recipe_count;
			else
				recipe_count = chem_cache[i];
			end
			if recipe_count then
				if lsButtonText(0, y, z, 300, color(chem_data[i][1]), chem_data[i][1] .. " (" .. recipe_count .. ")") then
					selected[#selected+1] = i;
					clear_cache = true;
				end
				y = y + 26;
			end
		end
		if clear_cache then
			chem_cache = nil;
		end

		lsScrollAreaEnd(y);

		if (maxX < 465) or (maxY < 400) then
			lsPrint(10, maxY-30, z+3, 0.7, 0.7, 0x801010ff, "You may need to resize this window to see everything.");
		end
		if lsButtonText(maxX - 72, maxY - 26*3, z, 70, 0xFFFFFFff, "Font +") then
			scale = scale * 4/5;
		end
		if lsButtonText(maxX - 72, maxY - 26*2, z, 70, 0xFFFFFFff, "Font -") then
			scale = scale * 5/4;
		end
		if lsButtonText(maxX - 142, maxY - 26, z, 140, 0xFFFFFFff, "Menu (slow)") then
			error "Clicked End Script button";
		end

		lsDoFrame();
		lsSleep(25);
	end
end
