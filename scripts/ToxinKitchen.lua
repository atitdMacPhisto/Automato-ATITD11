-- Ashen's improved Toxin Kitchen macro
-- Make All The Toxins
-- TODO: Support making EoG Serum with alternative ingredients

dofile("common.inc");

----------------------------------------
--          Global Variables          --
----------------------------------------

-- Names of products to list in menu
AUTOMENU = {
	"Eye of God Serum",
	"Nut's Essence",
	"Cloudy Solvent",
	"Milky Solvent",
	"Clear Solvent",
	"Glass Solvent",
	"Crystal Solvent",
	"Diamond Solvent",
	"Minu's Solvent",
	"Osiris' Solvent",
	"Renenutet's Solvent",
};

-- Names of products as listed in toxin kitchen
PRODUCTS = {
	"Eye of God Serum",
	"Nut's Essence",
	"Revelation Solvent (Cloudy)",
	"Revelation Solvent (Milky)",
	"Revelation Solvent (Clear)",
	"Revelation Solvent (Glass)",
	"Revelation Solvent (Crystal)",
	"Revelation Solvent (Diamond)",
	"Revelation Solvent (Minu's)",
	"Revelation Solvent (Osiris')",
	"Revelation Solvent (Renenutet's)",
};

DONTCARE = -1;

-- Always add water when volume is <= this value
MINVOLUME = 3.0;

-- Temperature ranges required for each product at each stage
STAGETEMP = {
	-- Eye of God Serum
	{ { 625, 775 }, { DONTCARE, DONTCARE }, { 190, 385 } },
	-- Nut's Essence
	{ { 600, 800 }, { DONTCARE, DONTCARE }, { 200, 400 } },
	-- Cloudy
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Milky
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Clear
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Glass
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Crystal
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Diamond
	{ { 360, 400 }, { DONTCARE, DONTCARE }, { 650, 800 } },
	-- Minu
	{ { 380, 400 }, { 0, 100 }, { 750, 800 } },
	-- Osiris
	{ { 580, 600 }, { 500, 700 }, { 770, 800 } },
	-- Renenutet
	{ { 400, 550 }, { 100, 250 }, { 700, 850 } },
};

-- Temperature ranges in which to bother testing acidity with cabbage juice
-- during each stage for each product
CABBAGETEMP = {
	-- Eye of God Serum
	{ { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE } },
	-- Nut's Essence
	{ { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE } },
	-- Cloudy
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Milky
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Clear
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Glass
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Crystal
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Diamond
	{ { DONTCARE, DONTCARE }, { 0, 200 }, { DONTCARE, DONTCARE } },
	-- Minu
	{ { DONTCARE, DONTCARE }, { 0, 250 }, { DONTCARE, DONTCARE } },
	-- Osiris
	{ { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE }, { DONTCARE, DONTCARE } },
	-- Renenutet
	{ { DONTCARE, DONTCARE }, { 0, 350 }, { DONTCARE, DONTCARE } },
};

-- Required acidity range for each stage for product
STAGEACID = {
	-- Eye of God Serum
	{ { DONTCARE, DONTCARE }, { 3.1, 3.6 }, { DONTCARE, DONTCARE } },
	-- Nut's Essence
	{ { DONTCARE, DONTCARE }, { 3.40, 3.80 }, { DONTCARE, DONTCARE } },
	-- Cloudy
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Milky
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Clear
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Glass
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Crystal
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Diamond
	{ { 3.0, 3.4 }, { 1.2, 1.5 }, { DONTCARE, DONTCARE } },
	-- Minu
	{ { 4.0, 4.5 }, { 1.2, 1.5 }, { 2.0, 5.0 } },
	-- Osiris
	{ { 5.0, 5.4 }, { 1.2, 1.5 }, { 3.0, 4.0 } },
	-- Renenutet
	{ { 2.2, 2.6 }, { 1.1, 1.5 }, { 4.6, 5.0 } },
};

-- Initial sap to add upon stage change for each stage for each product
STAGESAP = {
	-- Eye of God Serum
	{ 0, 2, 0 },
	-- Nut's Essence
	{ 0, 2, 0 },
	-- Cloudy
	{ 2, 0, 0 },
	-- Milky
	{ 0, 2, 0 },
	-- Clear
	{ 0, 2, 0 },
	-- Glass
	{ 0, 2, 0 },
	-- Crystal
	{ 0, 2, 0 },
	-- Diamond
	{ 2, 0, 0 },
	-- Minu
	{ 3, 0, 0 },
	-- Osiris
	{ 4, 0, 0 },
	-- Renenutet
	{ 3, 0, 2 },
};

-- Ingredient requirements for calculating totals. Rough estimates for water/cc/sap/juice.
INGREDIENTS = {
	-- ingredients, water, cc, sap, juice
	-- Eye of God Serum
	{ {{ 2, "Nature's Jug" }, { 1, "Arsenic"}}, 10, 15, 10, 15 },
	-- Nut's Essence
	{ {{ 3, "Hairy Tooth" }}, 10, 15, 10, 15 },
	-- Cloudy
	{ {{ 25, "Cobra Hood" }, { 25, "Camels Mane" }, { 25, "Flat"}}, 10, 15, 10, 15 },
	-- Milky
	{ {{ 3, "Sand Spore" }}, 10, 15, 10, 15 },
	-- Clear
	{ {{ 3, "Slave's Bread" }}, 10, 15, 10, 15 },
	-- Glass
	{ {{ 3, "Razor's Edge" }}, 10, 15, 10, 15 },
	-- Crystal
	{ {{ 6, "Peasant Foot" }}, 10, 15, 10, 15 },
	-- Diamond
	{ {{ 3, "Scorpion's Brood" }, { 3, "Heaven's Torrent" }, { 3, "Heart of Ash"}}, 25, 25, 25, 25 },
	-- Minu
	{ {{ 4, "Salt Water Fungus" }, { 4, "Razor's Edge" }, { 4, "Falcon's Bait"}}, 25, 25, 25, 25 },
	-- Osiris
	{ {{ 5, "Beehive" }, { 5, "Eye of Osiris" }, { 5, "Dueling Serpents"}}, 25, 25, 25, 25 },
	-- Renenutet
	{ {{ 6, "Spiderling" }, { 6, "Sand Spore" }, { 6, "Sun Star"}}, 25, 25, 25, 25 },
};

-- What to add at each stage of each recipe
STAGEADD = {
	-- Eye of God Serum
	{ "Nature", "Arsenic", "Nature" },
	-- Nut's Essence
	{ "Hairy", "Hairy", "Hairy" },
	-- Cloudy
	{ "Cobra", "Camels", "Flat" },
	-- Milky
	{ "Sand", "Sand", "Sand" },
	-- Clear
	{ "Slave", "Slave", "Slave" },
	-- Glass
	{ "Razor", "Razor", "Razor" },
	-- Crystal
	{ "Peasant", "Peasant", "Peasant" },
	-- Diamond
	{ "Scorpion", "Heaven", "Heart" },
	-- Minu
	{ "Salt", "Razor", "Falcon" },
	-- Osiris
	{ "Beehive", "Eye", "Dueling" },
	-- Renenutet
	{ "Spider", "Sand", "Sun" },
};

per_click_delay = 20;
tick_time = 1000;
readDelay = 110;
window_w = 260;
window_h = 256;
tol = 6000;

stop_cooking = false;
conready = true;

tempchanged = {};
volchanged = {};
ticked = {};
stagechanged = {};
curstage = {};
curtemp = {};
curacidity = {};
curvolume = {};
curprecip = {};
bounds = {};

cabbageqty	= 0;
waterqty	= 0;
cactusqty	= 0;
ccqty		= 0;

qtydone = 0;
qtystarted = 0;
qtyrequested = 1;

MAXWINDOWS = 10;

----------------------------------------

function resetstate(num)
	curstage[num] = 0;
	curtemp[num] = 0;
	curacidity[num] = 0.0;
	curvolume[num] = 0.0;
	curprecip[num] = 0.0;
	ticked[num] = false;
	stagechanged[num] = false;
	tempchanged[num] = false;
	volchanged[num] = false;
end

function resetall()
	cabbageqty = 0;
	waterqty = 0;
	cactusqty = 0;
	ccqty = 0;
	qtydone = 0;
	qtystarted = 0;

	for num=1,MAXWINDOWS do
		curstage[num] = 0;
		curtemp[num] = 0;
		curacidity[num] = 0.0;
		curvolume[num] = 0.0;
		curprecip[num] = 0.0;
		ticked[num] = false;
		stagechanged[num] = false;
		tempchanged[num] = false;
		volchanged[num] = false;
	end
end

function checkConReady()
	srReadScreen();
	conready = not srFindImage("stats/constitution.png");
end

function updateStatus(windows)
	-- Update CON Ready status
	checkConReady();

	-- Update per-window status
	for num = 1,#windows do
		local newstage = curstage[num];
		local newtemp = curtemp[num];
		local newvolume = curvolume[num];
		local newacidity = curacidity[num];
		local newprecip = curprecip[num];

		--search for which stage we're in
		image = findImageInWindow("toxinKitchen/ToxinStage.png", windows[num].x+5, windows[num].y+5, tol);
		if image then
			newstage = ocrNumber(image[0] + 34, image[1], BLUE_SMALL_SET);
		end

		--check volume
		image = findImageInWindow("toxinKitchen/ToxinVolume.png", windows[num].x+5, windows[num].y+5, tol);
		if image then
			newvolume = ocrNumber(image[0] + 48, image[1], BLUE_SMALL_SET);
		end

		--check temp
		image = findImageInWindow("toxinKitchen/ToxinTemperature.png", windows[num].x+5, windows[num].y+5, tol);
		if image then
			newtemp = ocrNumber(image[0] + 66, image[1], BLUE_SMALL_SET);
		end

		--check acidity
		image = findImageInWindow("toxinKitchen/ToxinAcidity.png", windows[num].x+5, windows[num].y+5, tol);
		if image then
			newacidity = ocrNumber(image[0] + 41, image[1], BLUE_SMALL_SET);
		end

		--precipitate
		image = findImageInWindow("toxinKitchen/ToxinPrecipitate.png", windows[num].x+5, windows[num].y+5, tol);
		if image then
			newprecip = ocrNumber(image[0] + 59, image[1], BLUE_SMALL_SET);
		end

		if (newtemp ~= curtemp[num]) then
			tempchanged[num] = true;
		end

		if (newvolume ~= curvolume[num]) then
			volchanged[num] = true;
		end

		if (newstage ~= curstage[num]) then
			stagechanged[num] = true;
		end

		-- Update cooking count if kitchen was not previously known to be cooking
		if (stagechanged[num] and (curstage[num] == 0)) then
			qtystarted = qtystarted + 1;
		end

		if (stagechanged[num] or volchanged[num] or tempchanged[num] or (newacidity ~= curacidity[num])) then
			curstage[num] = newstage;
			curtemp[num] = newtemp;
			curvolume[num] = newvolume;
			curacidity[num] = newacidity;
			ticked[num] = true;
		end

		curprecip[num] = newprecip;
	end
end

-- Display status and sleep
function displayStatus(tid, windows)
	local start_time = lsGetTimer();

	while tick_time - (lsGetTimer() - start_time) > 0 do
		-- Update CON Ready status
		checkConReady();

		time_left = tick_time - (lsGetTimer() - start_time);

		local y = 10;
		local x = 10;

		lsPrint(x, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
		lsPrint(x, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
		y = y + 40;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Making " .. AUTOMENU[tid] .. " " .. qtydone
			.. "/" .. qtyrequested .. " (" .. qtystarted .. " cooking)");
		y = y + 40;

		y = 90;
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Stage:");
		y = y + 12;
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Temperature:");
		y = y + 12;
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Volume:");
		y = y + 12;
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Acidity:");
		y = y + 12;
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Precipitate:");
		y = y + 12;

		x = 10;
		for num=1,#windows do
			y = 90;
			lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curstage[num]);
			y = y + 12;
			lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curtemp[num]);
			y = y + 12;
			lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curvolume[num]);
			y = y + 12;
			lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curacidity[num]);
			y = y + 12;
			lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, curprecip[num]);
			y = y + 12;
			x = x + 40;
		end

		x = 10;
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Waiting:");
		lsPrint(x+100, y, 0, 0.7, 0.7, 0xB0B0B0ff, time_left);
		y = y + 40;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "CC Used:");
		lsPrint(x+120, y, 0, 0.7, 0.7, 0xB0B0B0ff, ccqty);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Cactus Used:");
		lsPrint(x+120, y, 0, 0.7, 0.7, 0xB0B0B0ff, cactusqty);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Cabbage Used:");
		lsPrint(x+120, y, 0, 0.7, 0.7, 0xB0B0B0ff, cabbageqty);
		y = y + 12;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Water Used:");
		lsPrint(x+120, y, 0, 0.7, 0.7, 0xB0B0B0ff, waterqty);
		y = y + 40;
		if not conready then
			lsPrint(x, y, 0, 0.7, 0.7, 0xFF0000ff, "CON Not Ready");
		end

		c = 0xFFFFFFff;
		if (stop_cooking) then
			c = 0x00FF00ff;
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, c, "Finish up") then
			qtyrequested = qtydone + qtystarted;
			stop_cooking = true;
		end
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end

		lsDoFrame();
		lsSleep(25);
		checkBreak();
	end
end

function checkAddWater(windows, num)
	srReadScreen();
	if (curvolume[num] < MINVOLUME) then
		image = findImageInWindow("toxinKitchen/DiluteWater.png", windows[num].x+5, windows[num].y+5, tol);
		if image then
			srClickMouseNoMove(image[0] + 10, image[1] + 2);
			lsSleep(per_click_delay);
			waterqty = waterqty + 1;
		else
			lsPlaySound("error.wav");
			sleepWithStatus(2000, "Dilute button not found");
		end
	end
end

function addCharcoal(windows, num)
	srReadScreen();
	image = findImageInWindow("toxinKitchen/HeatCharcoal.png", windows[num].x+5, windows[num].y+5, tol);
	if (image) then
		srClickMouseNoMove(image[0] + 10, image[1] + 2);
		lsSleep(per_click_delay);
		ccqty = ccqty + 1;
	else
		lsPlaySound("error.wav");
		sleepWithStatus(2000, "Heat button not found");
	end
end

function addSap(windows, num, qty)
	srReadScreen();
	image = findImageInWindow("toxinKitchen/CatalyzeSap.png", windows[num].x+5, windows[num].y+5, tol);
	if (image) then
		for num = 1, qty, 1 do
			srClickMouseNoMove(image[0] + 10, image[1] + 2);
			lsSleep(per_click_delay);
			cactusqty = cactusqty + 1;
		end
	else
		lsPlaySound("error.wav");
		sleepWithStatus(2000, "Catalyze button not found");
	end
end

function addCabbage(windows, num)
	srReadScreen();
	image = findImageInWindow("toxinKitchen/CheckAcidity.png", windows[num].x+5, windows[num].y+5, tol);
	if (image) then
		srClickMouseNoMove(image[0] + 10, image[1] + 2);
		lsSleep(per_click_delay);
		cabbageqty = cabbageqty + 1;
	else
		lsPlaySound("error.wav");
		sleepWithStatus(2000, "Check Acidity button not found");
	end
end

function checkTakeProduct(tid, windows, num)
	if (curstage[num] == 4) then
		srReadScreen();
		clickloc = findText("Take the " .. PRODUCTS[tid], windows[num]);

		-- Kludge to work around misspelled Cloudy solvent
		if (not clickloc and string.find(PRODUCTS[tid], "Cloudy")) then
			local alt = string.gsub(PRODUCTS[tid], "Revelation", "Revealation");
			clickloc = findText("Take the " .. alt, windows[num]);
		end

		if (clickloc) then
			srClickMouseNoMove(clickloc[0] + 10, clickloc[1] + 2);
			lsSleep(per_click_delay);
			return true;
		end
	end

	return false;
end

function addIngredient(tid, windows, num)
	srReadScreen();
	if ((curstage[num] >= 1) and (curstage[num] <= 3)) then
		ingredients = STAGEADD[tid];
		addtext = "Ingredient: " .. ingredients[curstage[num]];
		srReadScreen();
		clickloc = findText(addtext, windows[num]);
		if clickloc then
			srClickMouseNoMove(clickloc[0] + 10, clickloc[1] + 2);
			lsSleep(per_click_delay);
		else
			lsPlaySound("error.wav");
			sleepWithStatus(2000, "Could not find '" .. addtext .. "'");
		end
	end
end

function doTick(tid, windows, num)
	local acidok = false;
	local tempok = false;
	local docabbage = false;
	local cabbageok = false;

	-- Update CON Ready status
	checkConReady();

	-- If nothing cooking, start a batch if we can
	if (curstage[num] == 0) then
		if conready and (qtydone + qtystarted < qtyrequested) then
			srReadScreen();
			clickloc = findText("Start a batch of " .. PRODUCTS[tid], windows[num]);
			
			if clickloc then
				clickText(clickloc);
				lsSleep(per_click_delay);
			end
		end

		closePopUp();
		return;
	end

	-- Otherwise, nothing to do if no tick has passed
	if (not ticked[num]) then
		return;
	end
	
	closePopUp();
	
	-- Refresh of window required for new buttons to appear
	srClickMouseNoMove(windows[num].x+5, windows[num].y+5);

	-- Take product from this window if it's done
	if (checkTakeProduct(tid, windows, num)) then
		qtydone = qtydone + 1;
		qtystarted = qtystarted - 1;
		resetstate(num);
		return;
	end

	-- Always ensure there's plenty of water volume remaining
	checkAddWater(windows, num);
	closePopUp();
	
	-- Always make sure temp > 0 and acidity > 0 else cooking (and ticking) stops
	if ((curtemp[num] == 0) or (curacidity[num] == 0)) then
		if (curtemp[num] == 0) then
			addCharcoal(windows, num);
			closePopUp();
		end
		if (curacidity[num] == 0) then
			addSap(windows, num, 1);
			closePopUp();
		end
		addCabbage(windows, num);
		closePopUp();
		return;
	end

	-- Nothing else to do for stage 4 except wait for precipitate
	if (curstage[num] == 4) then
		return;
	end

	initsap = STAGESAP[tid][curstage[num]];
	acidrange = STAGEACID[tid][curstage[num]];
	temprange = STAGETEMP[tid][curstage[num]];
	cabbagerange = CABBAGETEMP[tid][curstage[num]];

	-- Check current acidity vs. required, if it matters for this stage
	if (((acidrange[1] == DONTCARE) or (curacidity[num] >= acidrange[1])) and
		((acidrange[2] == DONTCARE) or (curacidity[num] <= acidrange[2]))) then
		acidok = true;
	end

	-- Check current temperature vs. required, if it matters for this stage
	if (((temprange[1] == DONTCARE) or (curtemp[num] >= temprange[1])) and
		((temprange[2] == DONTCARE) or (curtemp[num] <= temprange[2]))) then
		tempok = true;
	else
		if ((temprange[1] ~= DONTCARE) and (curtemp[num] < temprange[1])) then
			addCharcoal(windows, num);
			closePopUp();
		end
	end

	-- Check current temperature vs. range where we should be checking acidity.
	-- This is mainly to avoid wasting cabbage while waiting for a large drop
	-- that coincides with an allowed large temperature drop.
	if (((cabbagerange[1] == DONTCARE) or (curtemp[num] >= cabbagerange[1])) and
		((cabbagerange[2] == DONTCARE) or (curtemp[num] <= cabbagerange[2])) and
		((acidrange[1] ~= DONTCARE) or (acidrange[2] ~= DONTCARE))) then
		cabbageok = true;
	end

	if (stagechanged[num] and (initsap > 0)) then
		addSap(windows, num, initsap);
		closePopUp();
		docabbage = true;
	end

	if (not stagechanged[num] and (acidrange[1] ~= DONTCARE) and (curacidity[num] < acidrange[1])) then
		addSap(windows, num, 1);
		closePopUp();
		docabbage = true;
	elseif ((acidrange[2] ~= DONTCARE) and (tempchanged[num] or volchanged[num])) then
		docabbage = true;
	end

	if (docabbage and cabbageok) then
		addCabbage(windows, num);
		closePopUp();
	end

	-- Add ingredient if both acidity and temperature are in range
	if (acidok and tempok) then
		addIngredient(tid, windows, num);
		closePopUp();
	end

	ticked[num] = false;
	stagechanged[num] = false;
	tempchanged[num] = false;
	volchanged[num] = false;
end

function makeToxin(tid)
	resetall();
	
	while qtydone < qtyrequested do
		closePopUp();

		windows = {}
		while #windows < 1 do
			srReadScreen();
			windows = findAllText("This is [a-z]+ Toxin Kitchen", nil, REGEX+REGION);

			if #windows < 1 then
				sleepWithStatus(500, "No Toxin Kitchen windows found");
			end

			checkBreak();
		end
		
		updateStatus(windows);
		displayStatus(tid, windows);
		
		for num=1,#windows do
			doTick(tid, windows, num);
		end

		checkBreak();
	end
end

function getQuantity(tid)
	local quantities = INGREDIENTS[tid];
	local ingredients = quantities[1];
	local water = quantities[2];
	local cc = quantities[3];
	local sap = quantities[4];
	local juice = quantities[5];

	while true do
		local y = 10;
		local x = 10;

		lsPrint(x, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
		lsPrint(x, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
		y = y + 40;

		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "How many " .. AUTOMENU[tid] .. "?");
		y = y + 30;

		local done, qty = lsEditBox("toxinQty", x, y, 0, 50, 30, 1.0, 1.0, 0x000000ff, qtyrequested);
		y = y + 40;

		qty = tonumber(qty);

		if (qty and (qty > 0)) then
			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, qty .. " " .. AUTOMENU[tid] .. " Requires:");
			y = y + 24;

			for i=1,#ingredients do
				item = ingredients[i];
				lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, (qty * item[1]) .. " " .. item[2]);
				y = y + 12;
			end

			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "~" .. (qty * water) .. " Water in Jugs");
			y = y + 12;

			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "~" .. (qty * cc) .. " Charcoal");
			y = y + 12;

			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "~" .. (qty * sap) .. " Cactus Sap");
			y = y + 12;

			lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "~" .. (qty * juice) .. " Cabbage Juice");
		else
			lsPrint(x, y, 0, 0.7, 0.7, 0xFF0000ff, "Please enter a valid number > 0!");
		end

		if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Back") then
			return 0;
		end

		if (qty and (qty > 0)) then
			c = 0x80D080ff;
		else
			c = 0xFFFFFFff;
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, c, "Begin") then
			if (qty and (qty > 0)) then
				qtyrequested = qty;
				return qty;
			end
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "End Script") then
			error "Clicked End Script button";
		end

		lsDoFrame();
		lsSleep(25);
		checkBreak();
	end
end

function displayMenu()
	-- Ask for which button
	local selected = nil;
	while not selected do
		local y = 6;
		local x = 30;

		for i=1, #AUTOMENU do
			if lsButtonText(x, y, 0, 250, 0x80D080ff, AUTOMENU[i]) then
				selected = i;
			end
			y = y + 30;
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end

		lsDoFrame();
		lsSleep(25);
		checkBreak();
	end

	if not stop_cooking then
		if selected then
			qtyrequested = getQuantity(selected);
		end

		if (qtyrequested > 0) then
			makeToxin(selected);
		end
	end
end

function doit()
	askForWindow("Pin Toxin Kitchen window(s) and press SHIFT over the ATITD window.");

	refreshWindows();
	lsSleep(readDelay);

	srReadScreen();
	windows = findAllText("This is [a-z]+ Toxin Kitchen", nil, REGEX+REGION);

	if #windows < 1 then
		error "Did not find any Toxin Kitchen windows";
	end

	if #windows > MAXWINDOWS then
		error "Too many Toxin Kitchen windows!";
	end

	while not stop_cooking do
		displayMenu();
		checkBreak();
	end
end
