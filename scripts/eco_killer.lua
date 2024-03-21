dofile("common.inc");

askText = [[Eco Killer Qu'est-ce Que C'est?

This macro will do some uncommon things to help you manipulate ecology for mushroom spawing or lab testing. It will empty jugs to raise water levels, rapid fire a bullet furnace to raise metal/soot, or mass-kill vegetables to cause seed-specific effects.

Make sure "Plant all crops where you stand" is ON and pin jug menu, seed menu, and/or bullet furnace menu as desired and press SHIFT in the ATITD window to begin.]];

errormsg = "";

function getPasses(text, var, default)
	count = default;
	while true do
		y = 10;
		lsPrint(10, y, 0, 1.0, 1.0, 0xFFFFFFff, text)

		y = y + 30;
		lsPrint(10, y, 0, 1.0, 1.0, 0xFFFFFFff, "Passes")

		is_done, count = lsEditBox(var, 105, y, 0, 100, 0, 1.0, 1.0, 0x000000ff, count)
		y = y + 30;
		if not tonumber(count) then
			is_done = nil;
			count = 0;
			lsPrint(10, y, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
		else
			count = tonumber(count)
		end

		if lsButtonText(10, lsScreenY - 30, 0, 100, 0x00FF00ff, "Begin") and count >= 0 then
			return count;
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Cancel") then
			return 0;
		end
		
		lsDoFrame();
		lsSleep(50);
	end
end

function printIters(text, iter, count)
	y = 10;
	lsPrint(10, y, 0, 1.0, 1.0, 0xFFFFFFff, text)

	y = y + 30;
	lsPrint(10, y, 0, 1.0, 1.0, 0xFFFFFFff, "Pass " .. iter .. "/" .. count)

	if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Abort") then
		return false;
	end
	
	lsDoFrame();
	return true;
end

function abortStatusScreen(message, color)
  if not message then
    message = "";
  end
  if not color then
    color = 0xFFFFFFff;
  end
  scale = 0.8;
  lsPrintWrapped(10, 80, 0, lsScreenX - 20, scale, scale, color, message);
  lsPrintWrapped(10, lsScreenY-100, 0, lsScreenX - 20, scale, scale, 0xffd0d0ff,
                 error_status);
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
                  0xFF0000ff, "Abort") then
    return false;
  end
  if allow_break then
    lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,
            "Hold Ctrl+Shift to end this script.");
    if allow_pause then
      lsPrint(10, 24, 0, 0.7, 0.7, 0xB0B0B0ff,
              "Hold Alt+Shift to pause this script.");
    end
    checkBreak();
  end
  lsSleep(tick_delay);
  lsDoFrame();
  return true;
end

function waitForImageWithAbort(op, text, img)
	while true do
		checkBreak();
		srReadScreen();
		if findImage(img) then		
			return true;
		end
		
		if not abortStatusScreen("Waiting for '" .. text .. "' text") then
			errormsg = op .. " aborted";
			return false;
		end
	end
end

function waitForTextWithAbort(op, text)
	while true do
		checkBreak();
		srReadScreen();
		if findText(text) then		
			return true;
		end
		
		if not abortStatusScreen("Waiting for '" .. text .. "' text") then
			errormsg = op .. " aborted";
			return false;
		end
	end
end

local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;

function sleepWithAbort(delay_time, message, color, scale, waitMessage)
  if not waitMessage then
    waitMessage = "Waiting ";
  else
    waitMessage = waitMessage .. " ";
  end
  if not color then
    color = 0xffffffff;
  end
  if not delay_time then
    error("Incorrect number of arguments for sleepWithAbort()");
  end
  if not scale then
    scale = 0.8;
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
    local frame = math.floor(waitFrame/5) % #waitChars + 1;
    time_left = delay_time - (lsGetTimer() - start_time);
    newWaitMessage = waitMessage;
    if delay_time >= 1000 then
      newWaitMessage = waitMessage .. time_left .. " ms ";
    end
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
                   newWaitMessage .. waitChars[frame]);
    if not abortStatusScreen(message, color, nil, scale) then
		return false;
	end
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
  end
  return true;
end

function doRapidFire()
	while true do
		refreshAllWindows();
		local count = getPasses("Rapid Fire", "firings", 200);
		
		if count <= 0 then
			return
		end

		for i=1,count do
			refreshAllWindows();
			srReadScreen();
			if not findText("Bullet Furnace") then
				errormsg = "Bullet Furnace not found";
				return;
			end

			clickme = findText("Ore");
			if not clickme then
				errormsg = "No ore left to fire furnace";
				return;
			end
			
			clickText(clickme, true, 5, 5);
			local ok = waitForImage("ok2.png", 250, "Waiting for OK button");
			if ok then
			  srKeyEvent("1");
			  lsSleep(60);
			  safeClick(ok[0], ok[1]);
			  waitForNoImage("ok2.png", 250, "Waiting for OK button to hide");
			end

			clickme = findText("Charcoal");
			if not clickme then
				errormsg = "Could not find charcoal button";
				return;
			end
			
			clickText(clickme, true, 5, 5);
			local ok = waitForImage("ok2.png", 250, "Waiting for OK button");
			if ok then
			  srKeyEvent("1");
			  lsSleep(60);
			  safeClick(ok[0], ok[1]);
			  waitForNoImage("ok2.png", 250, "Waiting for OK button to hide");
			end

			if not sleepWithAbort(1500, "Waiting...") then
				errormsg = "Rapid Fire aborted";
				return;
			end

			clickme = findText("Fire the Bullet Furnace");
			if not clickme then
				errormsg = "Could not find Fire button";
				return;
			end

			clickText(clickme, true, 5, 5);

			if not sleepWithAbort(5000, "LET THEM COOK " .. i .. "/" .. count) then
				errormsg = "Rapid Fire aborted";
				return;
			end
			refreshAllWindows();

			srReadScreen();
			clickme = findText("Open the Chamber");
			if not clickme then
				errormsg = "Can't find Open button";
				return;
			end

			clickText(clickme, true, 5, 5);

			waitAndClickImage("yes.png");

			for i=1,5 do
				if not sleepWithAbort(1000, "Waiting...") then
					errormsg = "Rapid Fire aborted";
					return;
				end
				refreshAllWindows();

				srReadScreen();
				clickme = findText("Take");
				if clickme then
					break;
				end		
			end
			
			if not clickme then
				errormsg = "Could not find Take button";
				return;
			end

			clickText(clickme, true, 5, 5);
			lsSleep(250);

			srReadScreen();
			clickme = findText("Everything");
			if not clickme then
				errormsg = "Could not find Everything button";
				return;
			end

			clickText(clickme, true, 5, 5);

			if not sleepWithAbort(1000, "Waiting...") then
				errormsg = "Rapid Fire aborted";
				return;
			end
		end
	end
end

function doEmptyJugs()
	while true do
		refreshAllWindows();
		local count = getPasses("Empty Jugs", "jugs", 1000);
		
		if count <= 0 then
			return
		end
		
		srReadScreen();
		refreshAllWindows();
		
		for i=1,count do
			if not printIters("Empty Jugs", i, count) then
				errormsg = "Empty Jugs aborted";
				return;
			end
			if not waitForTextWithAbort("Empty Jugs", "Empty") then
				return;
			end
			clickAllText("Empty");
			lsSleep(60);
			if not waitForImageWithAbort("Empty Jugs", "OK button", "ok2.png") then
				return;
			end
			local ok = waitForImage("ok2.png", 250, "Waiting for OK button");
			if ok then
			  srKeyEvent("1");
			  lsSleep(60);
			  safeClick(ok[0], ok[1]);
			  waitForNoImage("ok2.png", 250, "Waiting for OK button to hide");
			end
		end
	end
end

function doKillVeggies()
	while true do
		refreshAllWindows();
		local count = getPasses("Kill Veggies", "seeds", 100);
		
		if count <= 0 then
			return
		end
		
		srReadScreen();
		refreshAllWindows();
		
		for i=1,count do
			if not printIters("Plant Veggies", i, count) then
				errormsg = "Kill Veggies aborted";
				count = i;
				break;
			end
			srReadScreen();
			if not waitForTextWithAbort("Kill Veggies", "Plant") then
				return;
			end
			clickText(findText("Plant"));
			lsSleep(250);
		end

		pos = askForWindow("Wait for veggies to go to seed. Hover mouse over seeds and press SHIFT.");
		
		for i=1,count do
			if not printIters("Pick Seeds", i, count) then
				errormsg = "Kill Veggies aborted";
				return;
			end
			safeClick(pos[0], pos[1]);
			lsSleep(100);
		end
		
		srKeyDown(VK_ESCAPE);
		lsSleep(100);
	end
end

function doit()
	askForWindow(askText);

	while true do
		local dowhat = 0;
		y = 10;
		if lsButtonText(10, y, 0, lsScreenX - 20, 0xFFFFFFff, "Empty Jugs") then
			dowhat = 1;
		end

		y = y + 30;
		if lsButtonText(10, y, 0, lsScreenX - 20, 0xFFFFFFff, "Kill Veggies") then
			dowhat = 2;
		end
		
		y = y + 30;
		if lsButtonText(10, y, 0, lsScreenX - 20, 0xFFFFFFff, "Rapid Fire") then
			dowhat = 3;
		end

		y = y + 30;
		if errormsg ~= "" then
			lsPrint(10, y, 10, 0.7, 0.7, 0xFF2020ff, errormsg);
		end

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end

		if dowhat > 0 then
			errormsg = "";
		end
			
		if dowhat == 1 then
			doEmptyJugs();
		elseif dowhat == 2 then
			doKillVeggies();
		elseif dowhat == 3 then
			doRapidFire();
		else
			lsDoFrame();
			lsSleep(50);
		end
	end
end