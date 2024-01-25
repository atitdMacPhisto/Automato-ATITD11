dofile("common.inc");
dofile("settings.inc");
--dofile("debug.inc");

centerX = 0;
centerY = 0;
BEER_CHOOSE = {5, 10, -90, -50};
TIMER_CHOOSE = {4, 10, -90, -50};
ingredientNames = {"Honey", "Malt (Raw)", "Malt (Light Roasted)", "Malt (Medium Roasted)", "Malt (Dark Roasted)", "Malt (Burnt)", "Wheat (Dried, Raw)", "Wheat (Light Roasted)", "Wheat (Medium Roasted)", "Wheat (Dark Roasted)", "Wheat (Burnt)"};
imageNames = { "honey", "maltraw", "maltlight", "maltmedium", "maltdark", "maltburnt", "wheatraw", "wheatlight", "wheatmedium", "wheatdark", "wheatburnt" };
ingredients = {};
ingredients[1] = {4, 30, 1200};
ingredients[2] = {1, 100, 1200};
ingredients[3] = {2, 25, 12};
ingredients[4] = {0, 0, 0};
seal = 1250;

function sendKey(key, qty)
	for i = 1, qty do
		srKeyDown(key);
	  lsSleep(10);
	  srKeyUp(key);
		lsSleep(10);
	end
end
	
function chooseIngredient(idx)
	srSetWindowBorderColorRange(minThickWindowBorderColorRange, maxThickWindowBorderColorRange);
	local win = getWindowBorders(centerX, centerY);
	local choose = findImage("beer/" .. imageNames[ingredients[idx][1]] .. ".png", win);
	if not choose then
		choose = findImage("beer/" .. imageNames[ingredients[idx][1]] .. "alt.png", win);
		if not choose then
			error("ingredient '" .. ingredientNames[ingredients[idx][1]] .. "' not found");
		end
	end
	safeClick(choose[0] + 3, choose[1] + 3);
	lsSleep(click_delay);
	local ok = findImage("ok.png");
	if not ok then
		error("could not find ok button");
	end
	safeClick(ok[0], ok[1]);
	lsSleep(click_delay);
	srReadScreen();
	sendKey(VK_BACK,4);
	srKeyEvent("" .. ingredients[idx][2]);
	sendKey(VK_RETURN,1);
	sendKey(VK_BACK,4);
	srKeyEvent("" .. ingredients[idx][3]);
	sendKey(VK_RETURN,1);
	srSetWindowBorderColorRange(minThinWindowBorderColorRange, maxThinWindowBorderColorRange);

end

function scheduleIngredient(idx)
	if ingredients[idx][2] > 0 then
		srReadScreen();
		local sched = findText("Schedule");
		if not sched then
			error("Could not find schedule;")
		end
		clickText(sched);
		lsSleep(click_delay);
		srReadScreen();
		
		local ing = findText("Ingredient ".. idx);
		if not ing then
			error("could not find Ingredient " .. idx);
		end
		clickText(ing);
		lsSleep(click_delay);
		srReadScreen();
		
		chooseIngredient(idx);
	end
end

function scheduleSeal()
	srReadScreen();
	local sched = findText("Schedule");
	if not sched then
		error("Could not find schedule;")
	end
	clickText(sched);
	lsSleep(200);
	srReadScreen();

	local sealbtn = findText("Seal");
	if not sealbtn then
		error("could not find Seal");
	end
	clickText(sealbtn);
	lsSleep(click_delay);
	srReadScreen();

	srSetWindowBorderColorRange(minThickWindowBorderColorRange, maxThickWindowBorderColorRange);
	local choose = findText("Sand Timer", win, nil, TIMER_CHOOSE);
	if not choose then
		error("Sand Timer not found");
	end
	clickText(choose);
	lsSleep(click_delay);
	local ok = findImage("ok.png");
	if not ok then
		error("could not find ok button");
	end
	safeClick(ok[0], ok[1]);
	lsSleep(click_delay);
	srReadScreen();
	sendKey(VK_BACK,4);
	srKeyEvent("" .. seal);
	sendKey(VK_RETURN,1);
	srSetWindowBorderColorRange(minThinWindowBorderColorRange, maxThinWindowBorderColorRange);
end

function startBeer()
--	lsPrintln(dump(ingredients));
	local mx,my = srMousePos();
--	lsPrintln(dump(mx));
	openAndPin(mx, my, 1000);
	lsSleep(click_delay);
	srReadScreen();
	
	local beer = findImage("beer/beer.png");
	if not beer then
		error("Could not find beer button");
	end
	safeClick(beer[0], beer[1]);
	lsSleep(click_delay);
	refreshAllWindows();
	lsSleep(click_delay);
	for i = 1, 4 do
		scheduleIngredient(i);
	end
	scheduleSeal();

	refreshAllWindows();
	srReadScreen();
	
	local begin = findImage("beer/begin.png");
	if not begin then
		error("Could not find begin button");
	end
	safeClick(begin[0], begin[1]);
	lsSleep(click_delay);
	
	local window = getWindowBorders(begin[0], begin[1]);
	unpinWindow(window);
end

function startYeast()
	local mx,my = srMousePos();
	openAndPin(mx, my, 1000);
	lsSleep(click_delay);
	srReadScreen();
	local yeast = findImage("beer/yeasttest.png");
	if not yeast then
		error("Could not find yeast test button");
	end
	safeClick(yeast[0], yeast[1]);
	lsSleep(click_delay);
	refreshAllWindows();
	lsSleep(click_delay);
	
	if seal > 0 then
		scheduleSeal();
	end
	
	refreshAllWindows();
	srReadScreen();
	
	local begin = findImage("beer/begin.png");
	if not begin then
		error("Could not find begin button");
	end
	safeClick(begin[0], begin[1]);
	lsSleep(click_delay);

	local window = getWindowBorders(begin[0], begin[1]);
	unpinWindow(window);
end

function doit()
	askForWindow("Beer Brewing");
	local client = srGetWindowSize();
	centerX = math.floor(client[0] / 2);
	centerY = math.floor(client[1] / 2);

--	srReadScreen();
--	srSetWindowBorderColorRange(minThickWindowBorderColorRange, maxThickWindowBorderColorRange);
--	local win = getWindowBorders(centerX, centerY);
--	local parses = findAllText(nil, win, nil, TIMER_CHOOSE);
--	lsPrintln(dump(parses));
	--error("end");

	local is_done = false
	scale = 1.5;
  local z = 0;
	local boolval;
	local i1 = readSetting("ingredient1",ingredients[1][1]);
	local i2 = readSetting("ingredient2",ingredients[2][1]);
	local i3 = readSetting("ingredient3",ingredients[3][1]);
	local i4 = readSetting("ingredient4",ingredients[4][1]);
	local q1 = readSetting("qty1",ingredients[1][2]);
	local q2 = readSetting("qty2",ingredients[2][2]);
	local q3 = readSetting("qty3",ingredients[3][2]);
	local q4 = readSetting("qty4",ingredients[4][2]);
	local t1 = readSetting("time1",ingredients[1][3]);
	local t2 = readSetting("time2",ingredients[2][3]);
	local t3 = readSetting("time3",ingredients[3][3]);
	local t4 = readSetting("time4",ingredients[4][3]);
	local st = readSetting("sealTime", seal);

  while not is_done do
		checkBreak();
		
		local y = 60;
		lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);

		lsPrint(10, y, z, 1, 1, 0xffffffff, "Ingredient");		
		lsPrint(270, y, z, 1, 1, 0xffffffff, "Qty");	
		lsPrint(350, y, z, 1, 1, 0xffffffff, "Time");	
		y = y + 30;

		i1 = lsDropdown("ing1", 10, y, 0, 250, i1, ingredientNames);
		
		boolval, q1 = lsEditBox("qty1", 270, y, z, 70, 30, 1.0, 1.0, 0x000000ff, q1);
		q1 = tonumber(q1);
		if not q1 then
			lsPrint(10, 250, 10, 0.7, 0.7, 0xFF2020ff, "QTY AND TIME FIELDS MUST BE A NUMBER");
			q1 = 0;
		end

		boolval, t1 = lsEditBox("time1", 350, y, z, 70, 30, 1.0, 1.0, 0x000000ff, t1);
		t1 = tonumber(t1);
		if not t1 then
			lsPrint(10, 250, 10, 0.7, 0.7, 0xFF2020ff, "QTY AND TIME FIELDS MUST BE A NUMBER");
			t1 = 0;
		end
		y = y + 30;

		i2 = lsDropdown("ing2", 10, y, 0, 250, i2, ingredientNames);

		boolval, q2 = lsEditBox("qty2", 270, y, z, 70, 30, 1.0, 1.0, 0x000000ff, q2);
		q2 = tonumber(q2);
		if not q2 then
			lsPrint(10, 250, 10, 0.7, 0.7, 0xFF2020ff, "QTY AND TIME FIELDS MUST BE A NUMBER");
			q2 = 0;
		end

		boolval, t2 = lsEditBox("time2", 350, y, z, 70, 30, 1.0, 1.0, 0x000000ff, t2);
		t2 = tonumber(t2);
		if not t2 then
			lsPrint(10, 250, 10, 0.7, 0.7, 0xFF2020ff, "QTY AND TIME FIELDS MUST BE A NUMBER");
			t2 = 0;
		end
		y = y + 30;
		
		i3 = lsDropdown("ing3", 10, y, 0, 250, i3, ingredientNames);

		boolval, q3 = lsEditBox("qty3", 270, y, z, 70, 30, 1.0, 1.0, 0x000000ff, q3);
		q3 = tonumber(q3);
		if not q3 then
			lsPrint(10, 250, 10, 0.7, 0.7, 0xFF2020ff, "QTY AND TIME FIELDS MUST BE A NUMBER");
			q3 = 0;
		end

		boolval, t3 = lsEditBox("time3", 350, y, z, 70, 30, 1.0, 1.0, 0x000000ff, t3);
		t3 = tonumber(t3);
		if not t3 then
			lsPrint(10, 250, 10, 0.7, 0.7, 0xFF2020ff, "QTY AND TIME FIELDS MUST BE A NUMBER");
			t3 = 0;
		end
		y = y + 30;

		i4 = lsDropdown("ing4", 10, y, 0, 250, i4, ingredientNames);
		
		boolval, q4 = lsEditBox("qty4", 270, y, z, 70, 30, 1.0, 1.0, 0x000000ff, q4);
		q4 = tonumber(q4);
		if not q4 then
			lsPrint(10, 250, 10, 0.7, 0.7, 0xFF2020ff, "QTY AND TIME FIELDS MUST BE A NUMBER");
			q4 = 0;
		end

		boolval, t4 = lsEditBox("time4", 350, y, z, 70, 30, 1.0, 1.0, 0x000000ff, t4);
		t4 = tonumber(t4);
		if not t4 then
			lsPrint(10, 250, 10, 0.7, 0.7, 0xFF2020ff, "QTY AND TIME FIELDS MUST BE A NUMBER");
			t1 = 0;
		end
		y = y + 30;

		lsPrint(10, y, z, 1, 1, 0xffffffff, "Seal Time");
		boolval, st = lsEditBox("sealTime", 120, y, z, 70, 30, 1.0, 1.0, 0x000000ff, st);
		st = tonumber(st);
		if not st then
			lsPrint(120, y+30, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
			st = 0;
		end
						
		lsPrintWrapped(10, 300, z, 350, 1, 1, 0xffffffff, "Move mouse over beer kettle and press CTRL to brew beer, ALT to start Yeast Test.");		

    if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff, "End script") then
    	is_done = true;
      error "Clicked End Script button";
    end

		if lsControlHeld() then
			while lsControlHeld() do
				statusScreen("Release CTL");
			end

	  	ingredients[1][1] = i1;
			writeSetting("ingredient1",i1);
			ingredients[1][2] = q1;
			writeSetting("quantity1",q1);
			ingredients[1][3] = t1;
			writeSetting("time1",t1);
	  	ingredients[2][1] = i2;
			writeSetting("ingredient2",i2);
			ingredients[2][2] = q2;
			writeSetting("quantity2",q2);
			ingredients[2][3] = t2;
			writeSetting("time2",t2);
	  	ingredients[3][1] = i3;
			writeSetting("ingredient3",i3);
			ingredients[3][2] = q3;
			writeSetting("quantity3",q3);
			ingredients[3][3] = t3;
			writeSetting("time3",t3);
	  	ingredients[4][1] = i4;
			writeSetting("ingredient4",i4);
			ingredients[4][2] = q4;
			writeSetting("quantity4",q4);
			ingredients[4][3] = t4;
			writeSetting("time4",t4);
			seal = st;
			writeSetting("sealTime", st);
			startBeer();
		else
			if lsAltHeld() then
				while lsAltHeld() do
					statusScreen("Release ALT");
				end
				
				seal = st;
				writeSetting("sealTime", st);
				startYeast();
			end
		end
		
    lsDoFrame();
    lsSleep(100);

	end
	
--	srReadScreen();
--	local winsize = srGetWindowSize();
--	centerX = math.floor(winsize[0] / 2);
--	centerY = math.floor(winsize[1] / 2);
--	srSetWindowBorderColorRange(minThickWindowBorderColorRange, maxThickWindowBorderColorRange);
--	lsPrintln(centerX .. "," .. centerY);
--	local win = getWindowBorders(centerX, centerY);
--	lsPrintln(dump(win));
--	local choose = findAllText(nil, win, nil, BEER_CHOOSE);
--	lsPrintln(dump(choose));
--	srSetWindowBorderColorRange(minThinWindowBorderColorRange, maxThinWindowBorderColorRange);

end