dofile("common.inc");

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

function getMixerWin()
	local mixerWin = findAllText("Compost Mixer");
	if #mixerWin < 1 then
		error("Mixer window not found");
	end
	if #mixerWin > 1 then
		error("Too many mixer windows");
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
			return;
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
		
		lsDoFrame();
		lsSleep(50);
	end
end

function doit()
	askForWindow(askText);
	getMixerWin();

	local count = 1;
	local what = 1;

	while true do
		checkBreak();
		
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

		if lsButtonText(10, lsScreenY - 30, 0, 100, 0x00FF00ff, "ADD IT") and count > 0 then
			doAdd(what, count);
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
		
		lsDoFrame();
		lsSleep(50);
	end
end
