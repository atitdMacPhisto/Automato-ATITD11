lsRequireVersion(2,74);
dofile("common.inc");

--[[
The list of essences below has various letters missing from names on
purpose, so do no worry if it looks like complete rubbish!

It is due to the new mipmapping rendering system used for the font, the
OCR cannot recognise some letters as they merge together :( - T10
]]--

wmText = "Tap Ctrl on chem labs to open and pin.\nTap Alt on chem labs to open, pin and stash.";

essences = {
{"ResinAcacia",67},
{"ResinAcaciaSapling",87},
{"ResinAcaciaYouth",10},
{"ResinAckee",22},
{"ResinAckeeSapling",17},
{"ResinAckeeYouth",10},
{"ResinAnaxi",46},
{"ResinArconis",86},
{"ResinAshPalm",56},
{"ResinAutumnBloodbark",42},
{"ResinAutumnBloodbarkSapling",15},
{"ResinAutumnBloodbarkYouth",44},
{"ResinBeetlenut",24},
{"ResinBlazeMaple",79},
{"ResinBlazeMapleSapling",84},
{"ResinBlazeMapleYouth",86},
{"ResinBloodbark",22},
{"ResinBottleTree",51},
{"ResinBrambleHedge",28},
{"ResinBroadleafPalm",83},
{"ResinButterleafTree",77},
{"ResinCeruleanBlue",56},
{"ResinChakkanutTree",42},
{"ResinChicory",90},
{"ResinCinnar",23},
{"ResinCoconutPalm",39},
{"ResinCricklewood",41},
{"ResinDeadwoodTree",31},
{"ResinDeltaPalm",14},
{"ResinDikbas",89},
{"ResinDikbasSapling",47},
{"ResinDikbasYouth",15},
{"ResinElephantia",59},
{"ResinFeatherTree",43},
{"ResinFeatherTreeSapling",19},
{"ResinFeatherTreeYouth",30},
{"ResinFernPalm",40},
{"ResinFoldedBirch",34},
{"ResinGiantCricklewood",7},
{"ResinGoldenHemlock",2},
{"ResinGoldenHemlockSapling",8},
{"ResinGoldenHemlockYouth",62},
{"ResinGreenAsh",66},
{"ResinGreenAshSapling",48},
{"ResinGreenAshYouth",35},
{"ResinHawthorn",34},
{"ResinHokkaido",42},
{"ResinIllawara",87},
{"ResinIllawaraSapling",9},
{"ResinIllawaraYouth",76},
{"ResinJacaranda",21},
{"ResinJacarandaSapling",45},
{"ResinJacarandaYouth",39},
{"ResinJapaneseCherry",90},
{"ResinJapaneseCherrySapling",41},
{"ResinJapaneseCherryYouth",63},
{"ResinKaeshra",45},
{"ResinKatsura",45},
{"ResinKatsuraSapling",55},
{"ResinKatsuraYouth",68},
{"ResinKhaya",2},
{"ResinKhayaSapling",62},
{"ResinKhayaYouth",80},
{"ResinKotukutuku",32},
{"ResinKotukutukuSapling",8},
{"ResinKotukutukuYouth",23},
{"ResinLocustPalm",70},
{"ResinMimosa",33},
{"ResinMimosaSapling",77},
{"ResinMimosaYouth",73},
{"ResinMiniatureFernPalm",31},
{"ResinMiniPalmetto",36},
{"ResinMonkeyPalm",58},
{"ResinMontereyPine",60},
{"ResinMontereyPineSapling",84},
{"ResinMontereyPineYouth",51},
{"ResinMontuMaple",1},
{"ResinOilPalm",49},
{"ResinOleaceae",82},
{"ResinOranje",66},
{"ResinOrrorin",66},
{"ResinParrotia",73},
{"ResinParrotiaSapling",16},
{"ResinParrotiaYouth",33},
{"ResinPassam",67},
{"ResinPeachesnCreamMaple",72},
{"ResinPeachesnCreamSapling",17},
{"ResinPeachesnCreamYouth",80},
{"ResinPhoenixPalm",84},
{"ResinPratyekaTree",68},
{"ResinRanyahn",24},
{"ResinRazorPalm",61},
{"ResinRedMaple",9},
{"ResinRiverBirch",34},
{"ResinRiverBirchSapling",85},
{"ResinRiverBirchYouth",80},
{"ResinRoyalPalm",36},
{"ResinSafsafSapling",77},
{"ResinSafsafWillow",27},
{"ResinSafsafWillowYouth",42},
{"ResinSavaka",33},
{"ResinScaleyHardwood",76},
{"ResinSilkyOak",26},
{"ResinSpikedFishtree",50},
{"ResinSpindleTree",42},
{"ResinStoutPalm",42},
{"ResinSummerMaple",53},
{"ResinSummerMapleSapling",36},
{"ResinSummerMapleYouth",2},
{"ResinSweetPine",28},
{"ResinTapacaeMiralis",71},
{"ResinTinyOilPalm",15},
{"ResinToweringPalm",90},
{"ResinTrilobellia",83},
{"ResinUmbrellaPalm",84},
{"ResinWhitePine",59},
{"ResinWhitePineSapling",40},
{"ResinWhitePineYouth",71},
{"ResinWindriverPalm",78},
{"PowderedDiamond",30},
{"PowderedEmerald",42},
{"PowderedOpal",5},
{"PowderedQuartz",13},
{"PowderedRuby",75},
{"PowderedSapphire",13},
{"PowderedTopaz",34},
{"PowderedAmethyst",83},
{"PowderedCitrine",10},
{"PowderedGarnet",80},
{"PowderedJade",20},
{"PowderedLapis",49},
{"PowderedSunstone",52},
{"PowderedTuruoise",84},              -- need to fix map q
{"PowderedAlmandine",48},
{"PowderedAquamarine",88},
{"PowderedKunzite",15},
{"PowderedMorganite",70},
--{"PowderedAquaPearl",},
--{"PowderedBeigePearl",43},
--{"PowderedBlackPearl",34},
--{"PowderedCoralPearl",83},
--{"PowderedPinkPearl",3},
--{"PowderedSmokePearl",11},
--{"PowderedWhitePearl",},
{"SaltsOfAluminum",53},
{"SaltsOfAntimony",16},
{"SaltsOfCobalt",9},
{"SaltsOfCopper",30},
{"SaltsOfGold",23},
{"SaltsOfIron",34},
{"SaltsOfLead",69},
{"SaltsOfMagnesium",20},
{"SaltsOfNickel",70},
{"SaltsOfPlatinum",10},
{"SaltsOfSilver",76},
{"SaltsOfTin",80},
{"SaltsOfZinc",59},
--{"OysterShellMarbleDust",},
--{"Allbright",},
{"Aloe",26},
{"AltarsBlessing",31},
{"Anansi",70},
--{"Apiphenalm",},
--{"ApothecarysScythe",},
--{"Artemesia",},
--{"Asafoetida",},
--{"Asane",},
{"Ashoka",45},
--{"AzureTristeria",},
{"Banto",71},
{"BayTree",74},
{"BeeBalm",3},
{"BeetleLeaf",59},
{"BeggarsButton",70},
--{"Bhillawa",},
--{"Bilimbi",},
--{"BitterFlorian",},
{"BlackPepperPlant",3},
--{"BlessedMariae",},
--{"Bleubillae",},
--{"BloodBalm",},
--{"BloodBlossom",},
--{"BloodRoot",},
{"BloodedHarebell",59},
--{"Bloodwort",},
{"BlueDamia",1},
{"BlueTarafern",79},
--{"BlueberryTeaTree",},
{"BluebottleClover",77},
--{"BlushingBlossom",},
{"Borage",30},
--{"BrassyCaltrops",},
{"BrownMuskerro",61},
{"Buckleleaf",30},					-- r need to be mapped?
--{"BullsBlood",},
{"BurntTarragon",68},
--{"ButterflyDamia",},
--{"Butterroot",},
--{"Calabash",},
--{"Camelmint",},
{"Caraway",4},
{"Cardamom",61},
--{"Cassia",},
{"Chaffa",79},
{"Chatinabrae",82},
{"Chives",30},
--{"Chukkah",},
{"CicadaBean",48},
{"Cinnamon",80},
{"Cinquefoil",48},
--{"Cirallis",},
{"Clingroot",44},
{"CommonBasil",16},
{"CommonRosemary",75},
{"CommonSage",34},
{"Coriander",80},
--{"Corsacia",},
{"Covage",71},
{"Crampbark",29},
--{"Cranesbill",},
--{"CreepingBlackNightshade",},
--{"CreepingThyme",},
{"CrimsonClover",81},
{"CrimsonLettuce",68},
--{"CrimsonNightshade",},
{"CrimsonPipeweed",26},
--{"CrimsonWindleaf",},
{"CrumpledLeafBasil",57},
--{"CurlySage",},
--{"CyanCressida",},
{"Daggerleaf",76},
{"Dalchini",51},
{"Dameshood",73},
--{"DankMullien",},
{"DarkOchoa",10},
{"DarkRadish",71},
--{"DeathsPiping",},
--{"DeadlyCatsclaw",},
--{"Dewplant",},
{"Digweed",22},
{"Discorea",9},
{"DrapeauDor",16},
{"DustyBlueSage",66},
{"DwarfHogweed",39},
{"DwarfWildLettuce",42},
{"EarthApple",74},
{"Elegia",45},
--{"EnchantersPlant",},
{"Finlow",55},
--{"FireAllspice",},
--{"FireLily",},
{"Fivesleaf",86},
--{"FlamingSkirret",},
{"FlandersBlossom",82},
{"Fleabane",39},
{"FoolsAgar",25},
{"Fumitory",6},
{"Garcinia",20},
{"GarlicChives",74},
{"GingerRoot",21},
--{"GingerTarragon",},
{"GinsengRoot",50},
{"Glechoma",64},
{"Gnemnon",59},
{"Gokhru",50},
--{"GoldenDoubloon",},
--{"GoldenGladalia",},
--{"GoldenSellia",},
--{"GoldenSweetgrass",},
--{"GoldenSun",},
{"GoldenThyme",31},
{"Gynura",28},
{"Harebell",35},
{"Harrow",15},
{"Hazlewort",22},
{"HeadacheTree",70},
--{"Heartsease",},
{"Hogweed",33},
--{"HomesteaderPalm",},
{"HoneyMint",30},
{"Houseleek",8},
{"Hyssop",16},
--{"IceBlossom",},
--{"IceMint",},
{"Ilex",33},
{"IndigoDamia",21},
{"Ipomoea",56},
{"JaggedDewcup",64},
--{"Jaivanti",},
--{"Jaiyanti",},
{"JoyoftheMountain",11},
--{"Jugwort",},
{"KatakoRoot",72},
{"Khokali",59},
--{"KingsCoin",},
--{"Lamae",},
{"Larkspur",10},
{"LavenderNavarre",47},
{"LavenderScentedThyme",59},
--{"LemonBasil",},
--{"LemonGrass",},
{"Lemondrop",8},
--{"Lilia",},
{"Liquorice",87},
{"Lungclot",84},
{"Lythrum",46},
{"Mahonia",23},
--{"MaliceWeed",},
--{"MandrakeRoot",},
--{"Maragosa",},
{"Mariae",20},
{"Meadowsweet",1},
{"Medicago",4},
{"Mindanao",12},
{"MiniatureBamboo",56},
{"MiniatureLamae",15},
{"MirabellisFern",80},
{"MoonAloe",84},
{"Morpha",78},
{"Motherwort",2},
{"MountainMint",12},
{"Myristica",90},
{"Myrrh",13},
--{"Naranga",},
--{"NubianLiquorice",},
--{"OctecsGrace",},
{"OpalHarebell",74},
--{"OrangeNasturtium",},
{"OrangeNiali",9},
{"OrangeSweetgrass",26},
--{"Orris",},
{"PaleDhamasa",53},
{"PaleOchoa",83},
{"PaleRusset",26},
--{"PaleSkirret",},
{"Panoe",66},
--{"ParadiseLily",},
{"Patchouli",52},
{"Peppermint",29},
{"Pippali",80},
{"PitcherPlant",91},
{"Primula",19},
{"Prisniparni",81},
{"PulmonariaOpal",5},
{"PurpleTintiri",50},
--{"Quamash",},
{"RedNasturtium",74},
--{"RedPepperPlant",},
--{"Revivia",},
{"Rhubarb",33},
--{"RoyalRosemary",},
--{"Rubia",},
--{"Rubydora",},
--{"SacredPalm",},
--{"SagarGhota",},
--{"Sandalwood",},
--{"SandyDustweed",},
{"Satsatchi",37},
--{"Schisandra",},
{"ShrubSage",21},
{"ShrubbyBasil",15},
--{"Shyama",},
--{"Shyamalata",},
--{"SicklyRoot",},
{"SilvertongueDamia",30},
--{"Skirret",},
--{"SkyGladalia",},
{"Soapwort",77},
{"Sorrel",18},
{"Spinach",35},
--{"Spinnea",},
--{"Squill",},
--{"SteelBladegrass",},
{"SticklerHedge",36},
{"StrawberryTea",80},
--{"Strychnos",},
{"SugarCane",39},
--{"SweetGroundmaple",},
{"Sweetflower",3},
{"Sweetgrass",60},
{"Sweetsop",73},
{"Tagetese",41},
--{"Tamarask",},
--{"TangerineDream",},
--{"ThunderPlant",},
{"Thyme",74},
{"TinyClover",25},
--{"Trilobe",},
--{"Tristeria",},
{"TrueTarragon",20},
{"Tsangto",30},
--{"Tsatso",},
--{"TurtlesShell",},
--{"UmberBasil",},
--{"UprightOchoa",},
--{"VanillaTeaTree",},
{"VerdantSquill",26},
--{"VerdantTwoLobe",},
--{"Wasabi",},
--{"WeepingPatala",},
--{"WhitePepperPlant",},
--{"Whitebelly",},
--{"WildGarlic",},
{"WildLettuce",20},
{"WildOnion",54},
--{"WildYam",},
--{"WoodSage",},
--{"Xanat",},
{"Xanosi",82},
{"Yava",3},
--{"YellowGentian",},
--{"YellowTristeria",},
{"Yigory",63},
--{"Zanthoxylum",},
--{"CamelPheromonesFemale",},
--{"CamelPheromonesMale",},
};


alcType = {};
alcType[3] = {"Wood Spirits", 1};
alcType[2] = {"Worm Spirits", 2};
alcType[1] = {"Grain Spirits", 3};
alcType[4] = {"Vegetable Spirits", 6};
alcType[5] = {"Mineral Spirits", 7};

function getSpirits(goal)
	local t = {};
		if goal < 10 then
			t[1] = {};
			t[1][1] = "Rock Spirits";
			t[1][2] = 10-goal;
				if goal ~= 0 then
					t[2] = {};
					t[2][1] = "Wood Spirits";
					t[2][2] = goal;
				end
			return t;
		end
		if goal == 81 or goal == 82 or goal == 83 then
			t[1] = {};
			t[1][1] = "Fish Spirits";
			t[1][2] = 10;
			return t;
		end
		if goal == 84 then
			t[1] = {};
			t[1][1] = "Grey Spirits";
			t[1][2] = 9;
			t[2] = {};
			t[2][1] = "Grain Spirits";
			t[2][2] = 1;
			return t;
		end
		if goal == 85 then
			if goal ~= 0 then
				t[1] = {};
				t[1][1] = "Mineral Spirits";
				t[1][2] = 1;
				t[2] = {};
				t[2][1] = "Vegetable Spirits";
				t[2][2] = 1;
				t[3] = {};
				t[3][1] = "Grey Spirits";
				t[3][2] = 8;
			end
			return t;
		end
		if goal > 80 then
			alcType[7] = {"Grey Spirits", 9};
			alcType[6] = {"Fish Spirits", 8};
		else
			alcType[7] = nil;
			alcType[6] = nil;
		end
		if goal > 70 and goal <= 80 then
			t[1] = {};
			t[1][1] = "Fish Spirits";
			t[1][2] = goal - 70;
			if goal ~= 80 then
				t[2] = {};
				t[2][1] = "Mineral Spirits";
				t[2][2] = 80-goal;
			end
			return t;
		end
		if goal == 20 then
			t[1] = {};
			t[1][1] = "Worm Spirits";
			t[1][2] = 10;
			return t;
		end
		if goal == 30 then
			t[1] = {};
			t[1][1] = "Grain Spirits";
			t[1][2] = 10;
			return t;
		end
	for k = 1, #alcType do
		for l = 1, #alcType do
			for i = 10, 5, -1 do
				j = 10 - i;
				temp = alcType[k][2] * i + alcType[l][2] * j;
					if temp == goal then
						t[1] = {};
						t[1][1] = alcType[k][1];
						t[1][2] = i;
							if j ~= 0 then
								t[2] = {};
								t[2][1] = alcType[l][1];
								t[2][2] = j;
							end
						return t;
					end
			end
		end
	end
	--otherwise, we didn't find it

	for k = 1, #alcType do
		for l = 1, #alcType do
			for m = 1, #alcType do
				for i = 8, 5, -1 do
					j = 10 - i - 1;
					temp = alcType[k][2] * i + alcType[l][2] * j + alcType[m][2];
						if temp == goal then
							t[1] = {};
							t[2] = {};
							t[3] = {};
							t[1][1] = alcType[k][1];
							t[1][2] = i;
							t[2][1] = alcType[l][1];
							t[2][2] = j;
							t[3][1] = alcType[m][1];
							t[3][2] = 1;
							return t;
						end
				end
			end
		end
	end
end

function displayStatus()
	lsPrint(10, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
	lsPrint(10, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");

	for window_index=1, #labWindows do
		lsPrint(10, 80 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - " .. labState[window_index].status);
	end
	if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
		error "Clicked End Script button";
	end

	checkBreak();
	lsDoFrame();
end

numFinished = 0;

function labTick(essWin, state)
	message = "";
	statusScreen("Starting ...", nil, 0.7, 0.7);
	state.count = state.count + 1;
	state.status = "Chem Lab: " .. state.count;
	state.active = false;
	local i;
	state.essenceIndex = nil;

	if state.finished then
		return;
	end

	--and here is where we add in the essence
	local outer;
		while outer == nil do
			safeClick(essWin.x + 10, essWin.y + essWin.height / 2);
			srReadScreen();
			statusScreen("Waiting to Click: Manufacture ...", nil, 0.7, 0.7);
			outer = findText("Manufacture...", essWin);
			lsSleep(per_read_delay);
			checkBreak();
		end
	clickText(outer);

	statusScreen("Waiting to Click: Essential Distill ...", nil, 0.7, 0.7);
	local t = waitForText("Essential Distill");
	clickText(t);

	statusScreen("Waiting to Click: Place Essential Mat ...", nil, 0.7, 0.7);
	t = waitForText("Place Essential Mat");
	clickText(t);

	statusScreen("Searching for Macerator ...", nil, 0.7, 0.7);
	--search for something to add
	local rw = waitForImage("essence/chooseMaterial.png");
	srSetWindowBorderColorRange(minThickWindowBorderColorRange, maxThickWindowBorderColorRange);
	local win = getWindowBorders(rw[0], rw[1]);
	srSetWindowBorderColorRange(minThinWindowBorderColorRange, maxThinWindowBorderColorRange);
	
	local parse = findAllText(nil, win);
	local foundEss = false;
	if parse then
		for i = 1, #parse do
--			lsPrintln(parse[i][2]);
			parse[i][2] = parse[i][2]:gsub('[^A-Za-z]','');
--			lsPrintln(parse[i][2]);
			if foundEss == false then
				for k = 1, #essences do
					if essences[k][2] ~= -1 and parse[i][2] == essences[k][1] and foundEss == false then
						state.essenceIndex = k;
						foundEss = true;
						clickText(parse[i]);
						message = "Added Macerator: " .. essences[k][1] .. "\n";
						state.temp = essences[k][2];
						if state.temp == nil then
						  error("That material has not yet been mapped.");
						end
					end
				end
			end
		end
	end

		if foundEss == false then
			sleepWithStatus(2000, "foundEss is false")
			state.status = "Couldn't find essence";
			numFinished = numFinished + 1;
			state.finished = 1;
			clickAllImages("cancel.png")
			lsSleep(100);
			return;
		end

	clickAllImages("OK.png")
	lsSleep(250);

	lsSleep(per_read_delay);
	lsSleep(1000);

	local spiritsNeeded = getSpirits(state.temp);

	state.lastOffset = 10;

	for i = 1, #spiritsNeeded do
		--Add the alcohol
		clickText(waitForText("Manufacture...", nil, nil, essWin));
		lsSleep(per_click_delay);
		clickText(waitForText("Alcohol Lamp."));
		lsSleep(per_click_delay);
		clickText(waitForText("Fill Alcohol Lamp"), nil, 20, 1);
		lsSleep(per_click_delay);

		--click on the spirit itself
		message = message .. "\nAdding Spirits : " .. spiritsNeeded[i][2] .. " " .. spiritsNeeded[i][1];
		statusScreen(message, nil, 0.7, 0.7);
		clickText(waitForText(spiritsNeeded[i][1]));
		lsSleep(per_click_delay);
		waitForImage("max.png");
		srKeyEvent(spiritsNeeded[i][2] .. "\n");
		lsSleep(per_click_delay + per_read_delay)
		message = message .. " -- OK!"
	end

	clickText(waitForText("Manufacture...", nil, nil, essWin));
	lsSleep(per_click_delay + per_read_delay);
	t = waitForText("Essential Distill");
	clickText(t);
	lsSleep(per_click_delay);

	local image;

	while 1 do
		srReadScreen();
		image = srFindImage("essence/StartDistillMini.png");
		if image then
			safeClick(image[0] + 2, image[1] + 2);
			lsSleep(per_click_delay);
			break;
		else
			statusScreen("Could not find start Essential, updating menu");
			--otherwise, search for place, and and update the menu
			clickText(t);
			lsSleep(200);
		end
	end
		safeClick(essWin.x + 10, essWin.y + essWin.height / 2);
	lsSleep(per_click_delay);
	return;
end

curActive = 1;

function makeEssences()
	last_time = lsGetTimer() + 5000;

	tick_time = 150;
	per_click_delay = 100;
	per_read_delay = 200;

	refreshWindows();
	srReadScreen();
	labWindows = findAllText("This is [a-z]+ Chemistry Laboratory", nil, REGION+REGEX);
		if labWindows == nil then
			error 'Did not find any open windows';
		end

	labState = {};
	local last_ret = {};
		for window_index=1, #labWindows do
			labState[window_index] = {};
			labState[window_index].count = 0;
			labState[window_index].active = false;
			labState[window_index].status = "Initial";
			labState[window_index].needTest = 1;
		end

	labState[1].active = true;
	while 1 do
		-- Tick
		srReadScreen();
		upgrades = findText("Upgrades...", labWindows[window_index])

		local should_continue = nil;
			if upgrades then
				for window_index=1, #labWindows do
					local wasActive = labState[window_index].active;
					if wasActive == true then
						local r = labTick(labWindows[window_index], labState[window_index]);
						--check to see if it's still active
							if window_index == #labWindows then
								labState[1].active = true;
							else
								labState[window_index + 1].active = true;
							end
						break;
					end
					if r then
						should_continue = 1;
					end
				end
			else
			--refresh windows. Chem Lab window does not refresh itself after it's done making essence. Refresh to force window to update, so we know when it's done.
			refreshWindows();
			end

		--check to see if we're finished.
			if numFinished == #labWindows then
				error "Completed.";
			end

		-- Display status and sleep
		local start_time = lsGetTimer();
			while tick_time - (lsGetTimer() - start_time) > 0 do
				time_left = tick_time - (lsGetTimer() - start_time);
				displayStatus(labState);
				lsSleep(25);
			end
		checkBreak();
		-- error 'done';
	end
end

function doit()
	askForWindow("Pin all Chemistry Laboratories");
  windowManager("CHem Lab Setup", wmText, false, true, 305, 275, nil, 10, 5);
  askForFocus();
  sleepWithStatus(2000, "Preparing to make essences", 0xffffffff);
  unpinOnExit(makeEssences);
end
