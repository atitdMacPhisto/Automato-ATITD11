dofile("common.inc");
dofile("settings.inc");

askText = "Edit the scripts/resins.txt file with the specific resins you wish to collect. All other resins will be ignored."

filename = "scripts/resins.txt";
resins = {};

function loadResins()
  local file = io.open(filename, "a+");
  io.close(file);
  for line in io.lines(filename) do
		resins[#resins+1] = line;
	end
end

function checkResin(resin)
	local r = resin:match("nick the [%a%s%']+ %[");
	r = r:gsub("nick the ","");
	r = r:gsub(" %[","");
	for i = 1, #resins do
		if resins[i] == r then
			return true;
		end
	end
	return false;
end

function doTick()
	srReadScreen();
	local p = findText("Gather the resin");
	if p then
		if checkResin(p[2]) then
			clickText(p);
		else
			local win = getWindowBorders(p[0], p[1]);
			srClickMouseNoMove(win.x + 5, win.y + 5, 1);
			lsSleep(click_delay);
			srClickMouseNoMove(win.x + 5, win.y + 5, 1);
		end
	else
		p = findText("Nick the ");
		if p then
			clickText(p);
		else
			p = findText("This ");
			if p then
				local win = getWindowBorders(p[0], p[1]);
				srClickMouseNoMove(win.x + 5, win.y + 5, 1);
				lsSleep(click_delay);
				srClickMouseNoMove(win.x + 5, win.y + 5, 1);
			end
		end
	end
end

function doit()
	askForWindow(askText);

	loadResins();
	
	scale = 1.4;
  local z = 0;
  local is_done = false;

  while not is_done do
		checkBreak();

		local y = 60;
		lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);

		lsPrint(10, y, z, 1, 1, 0xffffffff, "Watching for Tree Menu");		


    if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
      "End script") then
      error "Clicked End Script button";
    end

		doTick();
    lsDoFrame();
    lsSleep(100);
	end
end