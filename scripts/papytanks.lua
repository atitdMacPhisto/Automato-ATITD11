dofile("common.inc");
dofile("settings.inc");

seedsToPlant = 7;
doPlanting = true;

askText = ([[
Papyrus Tank Maintainer.
 
Harvests Papyrus Tanks and optionanally replants them with specified number of seeds.
 
Press shift over the ATITD window to begin.
]]);

function sendKey(key, qty)
	for i = 1, qty do
		srKeyDown(key);
	  lsSleep(10);
	  srKeyUp(key);
		lsSleep(10);
	end
end

function pinTank()
		local posX, posY = srMousePos();
		safeClick(posX, posY);
		lsSleep(click_delay);
		safeClick(posX, posY, 1);
		lsSleep(click_delay);
		srReadScreen();
end

function harvestPapy()
	local harvest = findText("Harvest", window);
	if harvest then
		local window = getWindowBorders(harvest[0], harvest[1]);
		clickText(harvest);
		lsSleep(click_delay);
		while harvest do
			checkBreak();
	    srClickMouseNoMove(window.x + 5, window.y + 5);
  	  lsSleep(click_delay);
    	srReadScreen();
    	harvest = findText("Harvest", window);
		end
	end
	srReadScreen();
end

function plantPapy(seeds)
	local plant = findText("Plant Papyrus");
	if plant then
		clickText(plant);
		lsSleep(click_delay);
		srReadScreen();
		srKeyEvent("" .. seeds);
		sendKey(VK_RETURN,1);
		lsSleep(click_delay);
	end
	srReadScreen();
end

function doit()
	askForWindow(askText);

	local is_done = false
	scale = 1.4;
  local z = 0;
	local pseeds = readSetting("seeds",seedsToPlant);
	
  while not is_done do
		checkBreak();

		local y = 40;
		lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);

    if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff, "End script") then
    	is_done = true;
      error "Clicked End Script button";
    end

    doPlanting = readSetting("doPlanting",doPlanting);
    doPlanting = CheckBox(10, y, z, 0xff8080ff, "Plant Seeds", doPlanting, 0.7, 0.7);
    writeSetting("doPlanting",doPlanting);
    y = y + 24;

		if doPlanting then
	    lsPrint(10, y, z, 1, 1, 0xffffffff, "Papy Seeds to Plant");
    	y = y + 24;
	    
	    pseeds = readSetting("seeds",pseeds);
			boolval, pseeds = lsEditBox("seeds", 10, y, z, 70, 30, 1.0, 1.0, 0x000000ff, pseeds);
			pseeds = tonumber(pseeds);
			if not pseeds then
				lsPrint(100, y+3, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
				kDelay = 0;
			end
			writeSetting("seeds",pseeds);
		end
   	y = y + 24;

		lsPrintWrapped(10, y+24, z, 350, 0.8, 0.8, 0xffffffff, "Move mouse over papy tank and\npress CTRL to Harvest/Plant.");		

		if lsControlHeld() then
			while lsControlHeld() do
				statusScreen("Release CTL");
			end
			
			pinTank();
			harvestPapy();
			if doPlanting then
				plantPapy(pseeds);
			end
			closeAllWindows();
		end
    lsDoFrame();
    lsSleep(100);
	end
end