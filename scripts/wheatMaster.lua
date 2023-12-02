dofile("common.inc");
dofile("settings.inc");
dofile("debug.inc");

water_count = 0;
refill_jugs = 40;
total_harvests = 0;
total_plantings = 0;
total_waterings = 0;
click_delay = 0; -- Overide the default of 50 in common.inc libarary.
wheatFields = {};

client_w = 0;
client_h = 0;
plantWindow_w = 250;
plantWindow_h = 105;
UNPLANTED = 0;
PLANTED = 1;
HARVESTED = 2;

askText = singleLine([[
Pin 'Plant Wheat' window in upper right for planting by ALT key. 
You must be standing with water icon present and water jugs in inventory.
Press Shift to continue.
]]);
----------------------------------------

function promptParameters()
  scale = 0.8;

  local z = 0;
  local is_done = nil;

  while not is_done do
    -- Make sure we don't lock up with no easy way to escape!
    checkBreak();
		
    lsPrintWrapped(10, 10, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff,
      "Wheat Settings\n-------------------------------------------");
    local y = 40;
    
   	plantCount = readSetting("plantCount", plantCount);
    lsPrint(10, y+5, z, scale, scale, 0xffffffff, "Plantings:");
    is_done, plantCount = lsEditBox("plants", 80, y+5, z, 80, 30, scale, scale,
        0x000000ff, plantCount);
    if not tonumber(plantCount) then
        is_done = nil;
        lsPrint(10, y + 30, z + 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        plantCount = 1;
    else
    		plantCount = tonumber(plantCount);
    end
    writeSetting("plantCount",tonumber(plantCount));
    y = y + 35;

   	fieldCount = readSetting("fieldCount", fieldCount);
    lsPrint(10, y+5, z, scale, scale, 0xffffffff, "Fields:");
    is_done, fieldCount = lsEditBox("fields", 80, y+5, z, 80, 30, scale, scale,
        0x000000ff, fieldCount);
    if not tonumber(fieldCount) then
        is_done = nil;
        lsPrint(10, y + 30, z + 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        fieldCount = 1;
    else
    		fieldCount = tonumber(fieldCount);
    end
    writeSetting("fieldCount",tonumber(fieldCount));
    y = y + 35;

   	jugCount = readSetting("jugCount", jugCount);
    lsPrint(10, y+5, z, scale, scale, 0xffffffff, "Jugs:");
    is_done, jugCount = lsEditBox("jugs", 80, y+5, z, 80, 30, scale, scale,
        0x000000ff, jugCount);
    if not tonumber(jugCount) then
        is_done = nil;
        lsPrint(10, y + 30, z + 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        jugCount = 10;
    else
    		jugCount = tonumber(jugCount);
    		refill_jugs = tonumber(jugCount);
    end
    writeSetting("jugCount",tonumber(jugCount));
    y = y + 35;

    if lsButtonText(10, lsScreenY - 30, z, 100, 0x00ff00ff, "Begin") then
        is_done = 1;
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFF0000ff,
        "End script") then
        error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(100);
	end
end

function setupFields()
	local offset_x = 5;
	local offset_y = 130;
	local loc_x = offset_x;
	local loc_y = offset_y;
	wheatFields = {};
	
	for i = 1, fieldCount do
		local field = {};
		field.state = UNPLANTED;
		field.x = loc_x;
		field.y = loc_y;
		wheatFields[i] = field;
		loc_x = loc_x + plantWindow_w;
		if ((loc_x + plantWindow_w) > (client_w - lsScreenX)) then
			loc_x = offset_x;
			loc_y = loc_y + plantWindow_h;
		end		
	end
	--lsPrintln(dump(wheatFields));
end

function getEmptyField()
	for i=1,fieldCount do
		lsPrintln("FIeld: " .. i .. " State: " .. wheatFields[i].state);
		if (wheatFields[i].state == UNPLANTED) then
			return i
		end
	end
	
	return 0;
end

function refillWater()
	water_count = 0;
	refill_jugs = tonumber(jugCount);
	lsSleep(100);
	srReadScreen();
	findWater = srFindImage("water.png");

	if findWater then
    statusScreen("Refilling water...");
    srClickMouseNoMove(findWater[0]+3,findWater[1]-5);
    lsSleep(500);
    srReadScreen();
    maxButton = srFindImage("max.png");
      if maxButton then
        srClickMouseNoMove(maxButton[0]+3,maxButton[1]+3);
        lsSleep(500);
      end
    end
end

function getFieldLocation(fieldNum)
	local field = wheatFields[fieldNum];
	return {field.x, field.y};
end

function findUnplantedField()
	local i;
	for i=1,fieldCount do
		if wheatFields[i].state == UNPLANTED then
			return i;
		end
	end
	return 0;
end

function tendField(fieldNum)
	if (wheatFields[fieldNum].state == PLANTED) then
		lsPrintln(dump(wheatFields[fieldNum]));
		local x = wheatFields[fieldNum].x + 5;
		local y = wheatFields[fieldNum].y + 5;
		srClickMouseNoMove(x, y);
		lsSleep(click_delay);
		srReadScreen();
		
		local water = findText("Water this", getWindowBorders(x, y));
		if (water) then
			lsPrintln("calling clickText(water)");
			clickText(water);
			water_count = water_count + 1;
			refill_jugs = jugCount - water_count;
			total_waterings = total_waterings + 1;
			return;
		end

		local harvest = findText("Harvest this", getWindowBorders(x, y));
		if (harvest) then
			lsPrintln("calling clickText(harvest)");
			clickText(harvest);
			total_harvests = total_harvests + 1;
			wheatFields[fieldNum].state = UNPLANTED;
			return;
		end
	end
end

function plantField()
	if (total_plantings >= plantCount) then
		return;
	end

	local fieldNum = findUnplantedField();
	if (fieldNum == 0) then
		return
	end
	
	while (lsAltHeld()) do
		checkBreak();
		while (lsAltHeld()) do
			checkBreak();
		end
		lsPrintln("Field: " .. fieldNum .. " " .. dump(wheatFields[fieldNum]));

		local plant = findText("Plant");
		
		if plant then
			lsPrintln("plant found at " .. plant[0] .. "," .. plant[1]);
			clickText(plant);
			lsPrintln("Planted");
			lsSleep(click_delay);
			x, y = srMousePos();
			openAndPin(x, y, 500);
			safeDrag(x, y, wheatFields[fieldNum].x, wheatFields[fieldNum].y);
			wheatFields[fieldNum].state = PLANTED;
			total_plantings = total_plantings + 1;
		
			lsSleep(200);
			srClickMouseNoMove(wheatFields[fieldNum].x + 5, wheatFields[fieldNum].y + 5)
		end
	end
end

function tendingLoop()
	lsPrintln("Tending Loop");
	
	local curFieldNum = 1;
  scale = 0.8;
  local z = 0;
  local is_done = nil;
	

	while not is_done do
		checkBreak();
		if (total_harvests == plantCount) then
			is_done = 1;
		end
		if (tonumber(refill_jugs) < 5) then
			refillWater()
		end
		tendField(curFieldNum);
		plantField();
    lsPrintWrapped(10, 10, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff, "Wheat Tending\n-------------------------------------------");
    lsPrint(10, 50, z, 0.7, 0.7, 0xffffffff, "Waterings SINCE Jugs Refill: " .. water_count);
    lsPrint(10, 70, z, 0.7, 0.7, 0xffffffff, "Waterings UNTIL Jugs Refill: " .. refill_jugs);
    lsPrint(10, 90, z, 0.7, 0.7, 0xffffffff, "Total Waterings: " .. total_waterings);
    lsPrint(10, 110, z, 0.7, 0.7, 0xffffffff, "Total Harvests: " .. total_harvests);
    lsPrint(10, 130, z, 0.7, 0.7, 0xffffffff, "Total Plantings: " .. total_plantings);

		lsPrintWrapped(10, 150, Z, lsScreenY - 10, 0.7, 0.7, 0xffffffff, "-------------------------------------------\n\nTo plant a new field, move to desired location hover mouse over spot near avatar but not directly on it, and press the ALT key.")
    
    if lsButtonText(10, lsScreenY - 30, z, 100, 0x00ff00ff, "Stop") then
        is_done = 1;
    end

	  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFF0000ff, "End script") then
	      error("");
	  end
    lsDoFrame();
    lsSleep(100);
    curFieldNum = curFieldNum + 1;
    if curFieldNum > fieldCount then
    	curFieldNum = 1
    end
	end
end

function doit()
  askForWindow(askText);
  local screen = srGetWindowSize();
  client_w = screen[0];
  client_h = screen[1];
	refillWater();
  while (1) do
	  promptParameters();
	  setupFields();
		tendingLoop();
	end
end
