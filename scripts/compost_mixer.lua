dofile("common.inc");
dofile("settings.inc");

askText = [[Compost Mixer

This macro will prompt you for an ingredient and quantity to add to the Compost Mixer, to save from having to constantly reconfigure simon and to save what can otherwise be hundreds of clicks.

Pin your Compost Mixer and Press SHIFT over the ATITD window to begin.]];

mixer_ingredients = {
	"Clinker",
	"Salt",
	"Water",
	"Salt Water",
	"Dung",
	"Charcoal",
	"Khefre's",
	"Gravel",
	"Dirt",
	"Sand",
	"Clay",
	"Smashed Stone",
	"Split Stone",
	"Sulph Water",
	"Acid",
	"Potash",
	"Lime",
	"Salts of Al"	
};

SOILWIDTH = 366;
SOILCOLOR = 0x32D184;

mix_metal = "";
mix_ph = "";
mix_salinity = "";
mix_water = "";
mix_nitrogen = "";
mix_phosphorus = "";
mix_metal = "";
mix_potassium = "";
mix_soot = "";
mix_eco = "";

function getSoilValue(win)
	srReadScreen();
	local pos = srFindImage("soiltype.png");

	while not pos do
		checkBreak();
		srReadScreen();
		sleepWithStatus(1000, "Soil Type not found/obscured");
		pos = srFindImage("soiltype.png");
	end
	
	srSetMousePos(pos[0], pos[1]);

	pos[0] = pos[0] + 75;
	pos[1] = pos[1] - 3;

	local base = pos[0];

	local ofs = makePoint(0, 0);
	local val = 0;
	local left = nil;
	local right = nil;
	
	srReadScreen();
	for i=1,SOILWIDTH+10 do
		if pixelMatchFromBuffer(pos, ofs, SOILCOLOR, 0) then
			if left == nil then
				left = ofs[0];
			end
			right = ofs[0];
		end
		ofs[0] = ofs[0] + 1;
	end

	if (left ~= nil) and (right ~= nil) then
		val = right - left;

		val = math.ceil(100.0 * val / (SOILWIDTH / 2.0));

		if (val >= 98) then
			val = 100;
		end

		if (left < SOILWIDTH/2) then
			val = val * -1;
		end
	end

	return val;
end

function getMixerWin()
	srReadScreen();
	local mixerWin = findAllText("Compost Mixer");

	while #mixerWin ~= 1 do
		checkBreak();

		srReadScreen();
		mixerWin = findAllText("Compost Mixer");
		
		if #mixerWin < 1 then
			sleepWithStatus(1000, "Mixer window not found");
		end
		if #mixerWin > 1 then
			sleepWithStatus(1000, "Too many mixer windows");
		end
	end

	return getWindowBorders(mixerWin[1][0], mixerWin[1][1]);
end

function doAdd(what, count)
	win = getMixerWin();
	plusses = findAllImages("plus.png", win);

	if #plusses ~= #mixer_ingredients then
		error("Unexpected # of plusses found (" .. #plusses .. ")");
	end

	for i = 1,count do
		checkBreak();
		safeClick(plusses[what][0] + 2, plusses[what][1] + 2);
		
		lsPrint(10, y, 10, 0.7, 0.7, 0xFFFFFFff, "Adding " .. mixer_ingredients[what] .. " " .. i .. "/" .. count);
		
		lsSleep(150);

		imgs = findAllImages("ok.png");
		
		if imgs and #imgs > 0 then
			lsPlaySound("fail.wav");
			sleepWithStatus(8000, "Insufficient ingredients on hand!");
			clickAllImages("ok.png");
			return i - 1;
		end

		if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFF0000ff, "Stop") then
			return i;
		end
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
		
		lsDoFrame();
		lsSleep(50);
	end

	return count;
end

function doit()
	askForWindow(askText);

	local count = 1;
	local what = 1;
	local soil = 0;

	count = readSetting("count", count);
	what = readSetting("what", what);
	
	while true do
		checkBreak();

		win = getMixerWin();
		soil = getSoilValue(win);
		
		y = 10;
		lsPrint(10, y, 10, 0.7, 0.7, 0xFFFFFFff, "Qty");
		lsPrint(70, y, 10, 0.7, 0.7, 0xFFFFFFff, "Ingredient");

		y = y + 30;
		is_done, count = lsEditBox('qty', 10, y, 0, 40, 0, 1.0, 1.0, 0x000000ff, count)

		what = lsDropdown('ing', 70, y, 0, 200, what, mixer_ingredients);
		
		y = y + 30;
		if not tonumber(count) or tonumber(count) < 1 then
			is_done = nil;
			count = 0;
			lsPrint(10, y, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER > 0");
		else
			lsPrint(10, y, 10, 0.7, 0.7, 0xFFFFFFff, "Requires up to " .. math.ceil(count / 10) .. " " .. mixer_ingredients[what] .. " in inventory");
			count = tonumber(count)
		end

		y = y + 30;
		lsPrint(10, y, 10, 0.7, 0.7, 0xFFFFFFff, "SOIL: " .. soil);

		if lsButtonText(10, lsScreenY - 30, 0, 100, 0x00FF00ff, "ADD IT") and count > 0 then
			writeSetting("count", count);
			writeSetting("what", what);
			count = count - doAdd(what, count);
			writeSetting("count", count);
			lsEditBoxSetText('qty', count);
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
		
		lsDoFrame();
		lsSleep(50);
	end
end
