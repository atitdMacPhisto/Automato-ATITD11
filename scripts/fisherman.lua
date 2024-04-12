dofile("common.inc");
dofile("settings.inc");

askText = "Fisherman\nPin your lure menu like in fishing.lua. Also like fishing.lua, if you have whole fish in inventory and pin your fillet menu (so that Fillet all fish is visible) and if auto-fillet is enabled, will automatically fillet fish as it goes.\n\nThis macro is still a bit experimental."

rods = { "Simple Fly Rod", "Whisperer's Fly Rod", "Beachcomber's Fly Rod", "Spiderfang Fly Rod", "Whiptail Fly Rod", "Openheart Fly Rod", "Snakespine Fly Rod"};
commonfish = {"Abdju", "Carp", "Catfish", "Chromis", "Oxyrynchus", "Perch", "Phagrus", "Tilapia"};
validlines = {"Caught", "you did catch", "You produced", "You didn't catch anything", "line got wrapped around", "almost caught", "found part"}
failmsgs = {"You didn't catch anything", "line got wrapped around", "almost caught", "found part"};

flyrod = 1;
autofillet = false;
logfish = true;
loglure = false;
logfillet = false;
debuglog = false;

currentlure = nil;
lures = {};
caughtFish = {};
lastChat = {};
lastFish = nil;
isfishing = false;
errmsg = nil;

local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;

function trim(s)
	return string.match( s, "^()%s*$" ) and "" or string.match( s, "^%s*(.*%S)" )
end

function findLures()
	srReadScreen();
	refreshAllWindows();
	local l = findText("Fishing Lure");
	if not l then
		errmsg = "Out of lures";
		return false;
	end
	lures = {};
	local w = getWindowBorders(l[0], l[1]);
	local p = findAllText(nil, w);
	local i = 0;
	for i = 2, #p do
		lures[#lures+1] = p[i][2];
	end
	errmsg = nil;
	return true;
end

function chooseLure()
	local l = lures[1];
	srReadScreen();
	refreshAllWindows();
	local p = findText(l);
	if not p then
		errmsg = "Find Lure Fail;";
		return false;
	end
	currentlure = l:match("([A-Za-z%s]+)%s*%(");
	if currentlure then
		currentlure = trim(currentlure);
	end
	clickText(p);
	p = waitForText("Select as preferred", 1000);
	if not p then
		srReadScreen();
		local p2 = findText("Deselect");
		if p2 then
			local win = getWindowBorders(p2[0], p2[1]);
			unpinWindow(win);
			lsSleep(click_delay);
			unpinWindow(win);
			return true;
		end
		errmsg = "Select Lure Fail";
		return false;
	end
	clickText(p);
	waitForNoText("Select as preferred");
	srReadScreen();
	errmsg = nil;
	return true;
end

function checkIfMain(chatText)
  for j = 1, #chatText do
    if string.find(chatText[j][2], "^%*%*", 0) then
      return true;
    end
  end
  return false;
end

function getChatLines()
	srReadScreen();
	chatText = getChatText();
	while not (checkIfMain(chatText)) do
		sleepWithStatus(1000, "Please selec the main chat tab so we can determine last chat line.");
		srReadScreen();
		chatText = getChatText();
	end
	lastChat = {}
	local i;
	for i = 1, #chatText do
		local s = chatText[i][2];
		for j = 1, #validlines do
			if s:find(validlines[j]) then
				local s2 = s:match("%]%s([%w%s%p]+)");
				lastChat[#lastChat+1] = s2;
			end
		end
	end
end

function chatChanged()
	local oldChat 
	oldChat = lastChat;
	srReadScreen();
	getChatLines();
	local mincount = math.min(#oldChat, #lastChat);
	local i
	for i = 0, mincount - 1 do
		if lastChat[#lastChat - i] ~= oldChat[#oldChat - i] then
			logFishDebug();
			return true;
		end
	end
	if #lastChat > #oldChat then
		logFishDebug();
		return true;
	end
	return false;
end

function checkCommonFish(fishtext)
	local i;
	for i = 1, #commonfish do
		if fishtext:find(commonfish[i]) then
			lastFish = nil;
			isfishing = false;
			return true;
		end
	end
	return false;
end

function checkCaughtFish(fishtext)
	local db, f
	
	if not fishtext:find("Caught a") and not fishtext:find("catch a") then 
		return false
	end
	db, f = fishtext:match("a (%d+) deben ([%a%s]+).");
	lastFish = f;
	local	newCaught = {};
	newCaught[1] = f .. " (" .. db .. "db) [" .. currentlure .. "]" ;
	
	if #caughtFish > 0 then
		local m = math.min(9, #caughtFish);
		local i;
		for i = 1, m do
			newCaught[i + 1] = caughtFish[i];
		end
	end
	caughtFish = newCaught;
	
	logFish(db, f);
	isfishing = false;
	return true;
end

function checkLostLure(fishtext)
--	if fishtext:find("The Fishing Lure") then
--		if fishtext:find("falls apart, it is unable to do any more work") then
--			return true
--		end
--	end
	if fishtext:find("lost your lure") then
		return true;
	end
	return false;
end

function checkFailCast(fishtext)
	local i;
	for i = 1, #failmsgs do
		if fishtext:find(failmsgs[i]) then
			isfishing = false;
			return true;
		end
	end
	return false;
end

function filletFish()
	if not autofillet then
		return;
	end
	
	srReadScreen();
	refreshAllWindows();
	local p;
	p = findText("Fillet all fish");
	if p then
		clickText(p);
		srReadScreen();
		while not chatChanged() do
			checkBreak();
			lsSleep(click_delay);
			srReadScreen();
		end
		if lastFish then
			local s = lastChat[#lastChat];
			local m, r, o, rm = s:match("(%d+) Meat, (%d+) Roe, (%d+) Fish Oil and (%d+) Rotten Meat");
			logFillet(m, r, o, rm);
		end
		refreshAllWindows();
		getChatLines();
--		logFishDebug();
	end
end

function logFish(db, fish)
	if logfish then
		local t = getTime(1);
		local r = getRegion();
		local loc = findCoords();
		local f = io.open("fisherman.txt","a");
		f:write(t .. "\t" .. r .. "\t" .. loc[0] .. "\t" .. loc[1] .. "\t" .. rods[flyrod] .. "\t" .. currentlure .. "\t" .. fish .. "\t" .. db .. "\n");
		f:close();
	end
end

function logFishDebug()
	if debuglog then
		local f = io.open("fisherman_debug.txt","a");
		f:write(lastChat[#lastChat] .. "\n");
		f:close();
	end
end

function logLure()
	if loglure then
		local t = getTime(1);
		local r = getRegion();
		if not t then
			t = "----";
		end
		local f = io.open("fisherman_lures.txt","a");
		f:write(t .. "\t" .. r .. "\t" .. currentlure .. "\n");
		f:close();
	end
end

function logFillet(meat, roe, oil, rmeat)
	if logfillet then
		if lastFish then
			local f = io.open("fisherman_fillet.txt","a");
			f:write(lastFish .. "\t" .. meat .. "\t" .. roe .. "\t" .. oil .. "\t" .. rmeat .. "\n");
			f:close();
		end
	end
end

function waitForFishStatus()
	local scale = 1.4;
  local z = 0;

	while not chatChanged() do
		checkBreak();

		local luremsg = "Current lure: " .. currentlure;
    local frame = math.floor(waitFrame/5) % #waitChars + 1;
		local waitmsg = "Waiting for fishing result  " .. waitChars[frame];
		local y = 20
		lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
		lsPrint(10, y, z, 1, 1, 0xffffffff, luremsg);		
		y = y + 30;
		lsPrint(10, y, z, 1, 1, 0xffffffff, waitmsg);		
		y = y + 60;
		lsPrint(10, y, z, 0.8, 0.8, 0xffffffff, "Last 10 fish caught:");		
		y = y + 20;
		local i;
		for i = 1, #caughtFish do
			lsPrint(10, y, z, 0.8, 0.81, 0xffffffff, caughtFish[i]);		
			y = y + 20;
		end

		if lsButtonText(10 * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
	    "Menu") then
	    return "menu";
	  end

    if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
      "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(100);
    waitFrame = waitFrame + 1;
	end
	
	return lastChat[#lastChat];
end

function doFishing()
	local doreturn = false;
	
	getChatLines();

	if not findLures() then
		return;
	end
	
	while (1) do
		checkBreak();

		if not currentlure then
			if not chooseLure() then
				isfishing = false
				return;
			end
		end
		
		srReadScreen();
		local fishIcon = findImage("Fishing/fishicon.png");
		while not fishIcon do
			sleepWithStatus(2000, "You are not in range of water...");
			srReadScreen();
			fishIcon = findImage("Fishing/fishicon.png");
		end
		
		if not isfishing then
			if doreturn then
				isfishing = false
				return
			end
			logLure();
			srClickMouseNoMove(fishIcon[0], fishIcon[1]);
			isfishing = true
		end
		
		local fishingStatus = waitForFishStatus();
		
		if fishingStatus == "menu" then
			doreturn = true;
		end
		
		if isfishing then
			if not checkFailCast(fishingStatus) then
				if checkCommonFish(fishingStatus) or checkCaughtFish(fishingStatus) then
					filletFish();
					if checkLostLure(fishingStatus) then
						if not findLures() then
							doreturn = true;
						else
							if not chooseLure() then
								doreturn = true;
							end
						end
					end
				end
			end
		end

    lsDoFrame();
	end
end

function doit()
	askForWindow(askText)
	srReadScreen();
	
	local scale = 1.4;
  local z = 0;
  local is_done = false;
	local r = flyrod;
	local f = autofillet;
	local lf = logfish;
	local ll = loglure;
	local lfi = logfillet;
	local dl = debuglog;
	
  while not is_done do
		checkBreak();

		local y = 30
		lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
		
		lsPrint(10, y, z, 1, 1, 0xffffffff, "Fisherman");		
		y = y + 30;
		if errmsg then
			lsPrint(10, y, z, 1, 1, 0xffa500ff, errmsg);		
		end
		y = y + 30;
		
		lsPrint(10, y, z, 1, 1, 0xffffffff, "Fly Rod: ");
    r = readSetting("flyrod",r);
    r = lsDropdown("FlyRod", 90, y, 0, 280, r, rods);
    if r ~= flyrod then
    	flyrod = r;
			writeSetting("flyrod",flyrod);
		end
		y = y + 40;

    f = readSetting("autofillet", f)
    f = lsCheckBox(10, y, z, 0xFFFFFFff, "Automatically Fillet Fish", f);
    if f ~= autofillet then
    	autofillet = f;
    	writeSetting("autofillet", f)
		end
		y = y + 30;
		
		lf = readSetting("logfish", lf)
    lf = lsCheckBox(10, y, z, 0xFFFFFFff, "Log Fish Caught", lf);
    if lf ~= logfish then
    	logfish = lf;
    	writeSetting("logfish", lf)
		end
		y = y + 30;

		ll = readSetting("loglure", ll)
    ll = lsCheckBox(10, y, z, 0xFFFFFFff, "Log Used Lures", ll);
    if ll ~= loglure then
    	loglure = ll;
    	writeSetting("loglure", loglure);
    end
		y = y + 30;

		lfi = readSetting("logfillet", lfi)
    lfi = lsCheckBox(10, y, z, 0xFFFFFFff, "Log Fillets", lfi);
    if lfi ~= logfillet then
    	logfillet = lfi;
    	writeSetting("logfillet", logfillet);
    end
		y = y + 30;

		dl = readSetting("debuglog", dl)
    dl = lsCheckBox(10, y, z, 0xFFFFFFff, "Debug Log", dl);
    if dl ~= debuglog then
    	debuglog = dl;
    	writeSetting("debuglog", debuglog);
    end
		y = y + 30;

		if lsButtonText(100 * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
      "Start") then
      errmsg = nil;
      currentlure = nil;
      doFishing();
    end

    if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
      "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(100);
	end
end
                                                           