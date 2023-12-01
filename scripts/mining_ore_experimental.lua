----------------------------------------------------
-- mining_ore_experimental - Livin' the MacDream! --
----------------------------------------------------

dofile("common.inc");
dofile("settings.inc");

local find = string.find;
local match = string.match;
local sub = string.sub;
local gsub = string.gsub;

function noop (...) return nil; end

function enum (T) 
  -- assumes the T is an array, i.e., all the keys are
  -- successive integers - otherwise #T will fail
  local length = #T
  for i = 1, length do
      local v = T[i]
      T[v] = i
  end

  return T
end


WHITE = 0xFFFFFFff;
RED = 0xFF2020ff;
GREEN = 0x66CD00ff;
YELLOW = 0xffff00ff;

local version = '0.19-MacDreamy';
info = "Macro brute force tries every possible 3 stone combination (and optionally 4 stone, too)."..
  "\nTime consuming but it works! (DualMonitorMode is slower)"..
  "\n\nMAIN chat will be selected and minimized";

local WARNING = {  
  [[ 1. You MUST pull a fresh workload every time you start the macro!!]],
  [[   * YES, even if you just started working the mine and closed and reopend the macro!]],
  [[   * "Worked the {something} Mine" MUST be the most recent message in main chat before picking stone locations]],
  [[ 2. In Options -> Interface Options]],
  [[   * SET: UI Size to Normal]],
  [[   * SET: Transparencies to 0% (double-check this!!)]],
  [[   * ENABLE : Use the chat area instead of popups for many messages]],
  [[   * DISABLE: Use Flyaway Messages for some things]],
  [[   * ENABLE : Suppress the flyaway messages, only use console]],
  [[ 3. You probably want to disable chat bubbles in Options -> Chat-Related]],
  [[ 4. Press F8 F8 to set the camera in top down mode]],
  [[ 5. Zoom out enough to see all the stones in the ore field!']],
  [[ 6. Press ALT-L to lock the camera so it doesn't move accidentally]],
  [[ 7. MAIN chat must be showing!!]],
  [[ 8. ALT*SHIFT will quickly pause the macro]],
  [[ 9. Moving off of MAIN chat will also pause the macro]],
  [[   * Press F9 or F10 to move over a tab (Game window must be active)]],
  [[   * While macro is paused you may chat in other tabs.]],
  [[   * You will have 5 seconds to reset once you select MAIN again.]],
  [[10. Do not move once the macro is running]],
  [[11. Do not use the mouse whilst the macro is running]],
  [[   * Unless in DualMonitorMode]],
  [[12. (Optional) Pin the mine's Take...Ore... menu]],
  [[   * It will refresh every round]],
  [[   * "All Ore" will appear in the pinned window]],
  '',
  [[Use Automato discord to report issues or suggestions]],
  '',
  [[THIS IS A WORK IN PROGRESS.]],
  [[IT IS FUNCTIONAL BUT NOT PERFECT. USE AT YOUR OWN RISK!]],
  '',
  [[Press CONTINUE to accept]],
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  [[In the midnight hour, she cried, "Ore, ore, ore"]],
  [[With a rebel yell, "Ore, ore, ore]],
  [[Ore, ore, ore"]]
};

-- Start don't alter these ...
local oreGathered = 0;
local oreGatheredTotal = 0;
local oreGatheredLast = 0;
local miningTime = 0;
local timesworked = 0;
local miningTimeTotal = 0;
local dropdown_key_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
local key_strings = {"tap SHIFT", "tap CTRL", "tap ALT", "click MWHEEL"};
local key_functions = {lsShiftHeld, lsControlHeld, lsAltHeld, function() lsMouseIsDown(2); end}
local dropdown_ore_values = {"Aluminum (9)", "Antimony (14)", "Coal (10)", "Cobalt (10)", "Copper (8)", "Gold (12)", "Iron (7)", "Lead (9)", "Magnesium (9)", "Nickel (13)", "Platinum (12)", "Silver (10)", "Tin (9)", "Zinc (10)"};
local cancelButton = 0;

local userKeyFn = key_functions[1];
local userKeyStr = key_strings[1];
local ore = nil;
local stonecount = nil;

local clickList = {};
local oreNodes = {};
local oreNodes4 = {};
local oreNodesFour = {};
local brokenStones = {};
local mines = {};

local flashIdx = 0;
local flashColors = {RED, WHITE, GREEN};
-- End Don't alter these ...

--Customizable
local autoWorkMine = readSetting("autoWorkMine",1);
local manualSets = readSetting("manualSets",0);
local extraStones = readSetting("extraStones",1);
local noMouseMove = readSetting("noMouseMove",0); 
local muteSoundEffects = readSetting("noMouseMove",1);
local clickDelay = readSetting("clickDelay",125);

-- Useful for debugging. If true, will write log file to mining_ore.txt
 local writeLogFile = readSetting("writeLogFile",0);

 --These tolerance values might need tweaked
local rgbTol = 50; --50?  Was 150
local hueTol = 50; --10?  Was 75

local minResultDelay = 150; -- The minimum delay time used during waitForResult() function
local oreMatchPattern = '[^%d]+(%d+)[-A-Za-z ]+Ore';
--local gemMatchPattern = 'You got [%a+] ([%a+]) ([%a+])';
local chatReadTimeOut = 3500; -- Maximum Time(ms) to wait before moving on to the next workload.
local chatParseTargets = {"Worked", "Year"}
--End Customizable

----------------------------------------
--          Ore Stone Object          --
----------------------------------------
local StoneState = enum {
  "AVAILABLE",
  "BROKEN"
}
local Stone = {
  id = 0,
  x = nil,
  y = nil,
  pointColor = nil,
  workloads = 0,
  breakThreshold = 7, -- NUmber of successful workloads before setting a stone as broken. This should be a configurable option in the future
  state = StoneState.AVAILABLE;
}
function Stone:new (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self  
  return o
end
function Stone:use ()
  self.workloads = self.workloads + 1;
  
  if(self.workloads >= self.breakThreshold or self:isCleared()) then
    self:setBroken(); 
  end
end
function Stone:setBroken ()
  --print('Stone ['..self.id..'] broke after ['..self.workloads..'] workloads!')
  self.state = StoneState.BROKEN;
  table.insert(brokenStones, self.id);
  table.sort(brokenStones);
end
function Stone:isBroken ()
  --print("Stone ["..self.id.."]: State = ["..StoneState[self.state].."]")
  return self.state == StoneState.BROKEN;
end
function Stone:isCleared ()
  return (not compareColorEx(srReadPixel(self.x, self.y), self.pointColor, rgbTol, hueTol));
end
----------------------------------------

function doit()   
  displayInstructions();
  askForWindow(info);
  setup();
end

function displayInstructions()
  local is_done = false;

  while not is_done do
    local windowRight = lsGetWindowSize()[0];
    local windowBottom = lsGetWindowSize()[1];
    current_y = 10

    lsPrintWrapped(5, current_y, 10, lsGetWindowSize()[0]-5, 0.7, 0.7, GREEN, "SETUP INSTRUCTIONS:");
    current_y = current_y + lsPrintWrapped(windowRight-110, current_y, 10, lsGetWindowSize()[0]-5, 0.7, 0.7, YELLOW, version);

    if not flashing_colour then
      flashing_colour = flashColors[flashIdx+1];
      last_flash = lsGetTimer()
    end    
    current_y = current_y + 10 + lsPrintWrapped(5, current_y+5, 10, lsGetWindowSize()[0]-5, 0.7, 0.7, flashing_colour, "READ AND RE-READ THESE INSTRUCTIONS,\nTHEY ARE VERY VERY VERY IMPORTANT!!");
    if lsGetTimer() - last_flash > 500 then
      flashIdx = (flashIdx+1)%3;
      flashing_colour = flashColors[flashIdx+1];

      last_flash = lsGetTimer()
    end

    lsScrollAreaBegin("warningScroll", 10, current_y, z, windowRight-10, windowBottom-150);
      for i=1, #WARNING do        
        current_y = current_y + lsPrintWrapped(X_PADDING, current_y-60, 10, windowRight-25, 0.6, 0.6, WHITE, WARNING[i])
      end
    lsScrollAreaEnd(current_y-10);

 
    -- Bottom-Left
    if drawBottomButton(lsScreenX - 5, "Continue", GREEN) then
      is_done = 1;
    end

    -- Bottom-Right
    if drawBottomButton(lsScreenX - (windowRight-105), "Exit Script", RED) then
      error "Script exited by user"
    end

    lsDoFrame()
    lsSleep(10)
  end
end

function setup ()
    if not initChat() then 
      error "Unable to initialize MAIN chat!!"; 
    end
    promptDelays();
    getMineLoc();
    start();
end

function start()
  getPoints();
  if manualSets then
    getTraits();
    findSets();
  end
  clickSequence();
end
local reset = start;

function promptDelays()
  local is_done = false;
  local count = 1;
  while not is_done do
    checkBreak();    
    
    local y = 10;    
    lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Key or Mouse to Select Nodes:");    

    y = y + 35;
    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
    dropdown_cur_value_key = readSetting("dropdown_cur_value_key",dropdown_cur_value_key);
    dropdown_cur_value_key = lsDropdown("thisKey", 15, y, 0, 320, dropdown_cur_value_key, dropdown_key_values);
    writeSetting("dropdown_cur_value_key",dropdown_cur_value_key);
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
    
    y = y + 20;
    lsPrint(10, y, 0, 0.67, 0.67, 0xffffffff, "How many Nodes?");
    
    y = y + 50;
    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
    dropdown_ore_cur_value = readSetting("dropdown_ore_cur_value",dropdown_ore_cur_value);
    dropdown_ore_cur_value = lsDropdown("thisOre", 15, y, 0, 320, dropdown_ore_cur_value, dropdown_ore_values);
    writeSetting("dropdown_ore_cur_value",dropdown_ore_cur_value);
    
    y = y + 35;
    lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Node Click Delay (ms):");
    
    y = y + 22;
    clickDelay = readSetting("clickDelay",clickDelay);
    is_done, clickDelay = lsEditBox("clickDelay", 15, y, 0, 50, 30, 1.0, 1.0, 0x000000ff, clickDelay);
    clickDelay = tonumber(clickDelay);
    if not clickDelay then
      is_done = false;
      lsPrint(75, y+6, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      clickDelay = 100;
    end
    writeSetting("clickDelay",clickDelay);
    
    y = y + 40;
    lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Total Ore Found Starting Value:");
    
    y = y + 22;
    is_done, oreGatheredTotal = lsEditBox("oreGatheredTotal", 15, y, 0, 80, 30, 1.0, 1.0, 0x000000ff, 0);
    oreGatheredTotal = tonumber(oreGatheredTotal);
    if not oreGatheredTotal then
      is_done = false;
      lsPrint(105, y+6, 20, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      oreGatheredTotal = 0;
    end

    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
    y = y - 15;
    lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Node Delay: Pause between selecting each node.");
    y = y + 16;
    lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Raise value to run slower (try increments of 25)");
    y = y + 20;
    lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Total Ore Starting Value: Useful to keep track of");
    y = y + 16;
    lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "ore already in the mine. Set to value of ore in mine");
    y = y + 22;
    lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Dual Monitor: Doeesn\'t move mouse over nodes.");
    y = y + 16;
    lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "This lets you move mouse on second monitor.");
    y = y + 22;
    if ButtonText(10, lsScreenY - 30, 0, 70, 0xFFFFFFff, "Next") then
      is_done = 1;
    end

    if cancelButton == 1 then
      if ButtonText(115, lsScreenY - 30, 0, 80, 0xFFFFFFff, "Cancel") then
        getPoints();
        cancelButton = 0;
      end
    end

    if ButtonText(205, lsScreenY - 30, 0, 110, 0xFFFFFFff,
        "End script") then
        error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(10);
  end
  processInput();
  return count;
end

function processInput()
  -- This is called after the loop in promptDelays is complete
  userKeyFn = key_functions[dropdown_cur_value_key];
  userKeyStr = key_strings[dropdown_cur_value_key];
  ore, stonecount = dropdown_ore_values[dropdown_ore_cur_value]:match('(%a+)%s*%((%d+)%)');
  stonecount = stonecount and tonumber(stonecount) or -1;

  if (ore == "Silver") then  oreMatchPattern = '(%d+) Silver'; 
  elseif (ore == "Coal") then oreMatchPattern = '(%d+) Coal'
  --elseif (ore == "Sand") then oreMatchPattern = '(%d+) Sand'; 
  end
end

function getMineLoc()
    mineList = {};
    local was_shifted = userKeyFn();
    local is_done = false;
    mx = 0;
    my = 0;
    z = 0;
    while not is_done do
        mx, my = srMousePos();
        local is_shifted = userKeyFn();
        if is_shifted and not was_shifted then
            mineList[#mineList + 1] = {mx, my};
        end
        was_shifted = is_shifted;
        checkBreak();
        lsPrint(10, 10, z, 1.0, 1.0, 0xc0c0ffff, "Set Mine Location");
        local y = 60;
        lsPrint(10, y, z, 0.7, 0.7, 0xf0f0f0ff, "Lock ATITD screen (Alt+L) - OPTIONAL!");
        y = y + 20;
        lsPrint(10, y, z, 0.7, 0.7, 0xf0f0f0ff, "Suggest F5 view, zoomed about 75% out.");
        y = y + 60;
        lsPrint(10, y, z, 0.7, 0.7, 0xc0c0ffff, "Hover and " .. userKeyStr .. " over the MINE !");
        y = y + 70;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "TIP (Optional):");
        y = y + 20;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "For Maximum Performance (least lag) Uncheck:");
        y = y + 16;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Options, Interface, Other: 'Use Flyaway Messages'");
        local start = math.max(1, #mineList - 20);
        local index = 0;
        for i=start,#mineList do
            mineX = mineList[i][1];
            mineY = mineList[i][2];
        end
        if #mineList >= 1 then
            is_done = 1;
        end
        if ButtonText(205, lsScreenY - 30, z, 110, 0xFFFFFFff,
            "End script") then
            error "Clicked End Script button";
        end
        lsDoFrame();
        lsSleep(10);
    end
end


function fetchTotalCombos3()
    TotalCombos = 0;
    for i=1,#clickList do
        for j=i+1,#clickList do
            for k=j+1,#clickList do
                TotalCombos = TotalCombos + 1;
            end
        end
    end
end


function fetchTotalCombos4()
  local text4 = "";
  local counter = 0;
  oreNodes4 = {};
  TotalCombos = 0;
  local stone1 = nil;
  local stone2 = nil;
  local stone3 = nil;
  local stone4 = nil;
  for i=1, #clickList do
    for j=i+1,#clickList do
      for k=j+1,#clickList do
        for l=k+1,#clickList do
          counter = counter + 1;
          broken = nil;

          stone1 = clickList[i];
          if (stone1:isBroken()) then broken = 1 end
          stone2 = clickList[j];
          if (stone2:isBroken()) then broken = 1; end
          stone3 = clickList[k];
          if (stone3:isBroken()) then broken = 1; end
          stone4 = clickList[l];
          if (stone4:isBroken()) then broken = 1; end 

          -- if i,j,k,l is already already broken, then don't add to oreNodes4{array}

          if (broken and writeLogFile) then
            WriteLog("\n" .. i .. ", " .. j .. ", " .. k .. ", " .. l .. " ..  1+ Nodes are in Broken Node List, Excluded from oreNodes4{array} (4 Stone Combo Array)");
          end

          if not broken and isFourSetValid(i,j,k,l) then     
            found = false;
            for y=1, #oreNodes4 do
              if oreNodes4[y] == {i,j,k,l} then
                found = true;
              end -- if oreNodes4[y] ...
            end -- for y

            if not found then
              text4 = text4 .. "\n" .. i .. ", " .. j .. ", " .. k .. ", " .. l;
              TotalCombos = TotalCombos + 1;
              oreNodes4[#oreNodes4 + 1] = {i,j,k,l};
            end -- if not found
          end -- if isFourSetValid(i,j,k,l)
          
          sleepWithStatus(5, "Verifying Four Stone Combos...\n\n(" .. counter .. ")  "  .. i .. ", " .. j .. ", " .. k .. ", " .. l .. "\n\n" .. TotalCombos .. " Found", nil, 0.7, "Parsing");
        end
      end
    end
  end

    text4 = text4 .. ((TotalCombos==0) and "<Skipping 4 Stone Combos>" or "\n<Working 4 Stone Combos>\n");
  
  if writeLogFile then
    WriteLog("\n**** " .. TotalCombos .. "/" .. #oreNodes .. " of the Combos that produced Ore have valid 4 Stone Combos\n" .. text4);
  end
  sleepWithStatus(1250, "Finished Verifying Four Stone Combos...\n\n" .. TotalCombos .. " Found -> " .. text4, nil, 0.7, "Parsing Complete");
end

function getPoints()
    clickList = {};    
    mines = {};

    local nodeleft = stonecount;
    local is_done = false;
    local nx = 0;
    local ny = 0;
    local pixelColor = 0xFFFFFF;
    local z = 0;
    local skipValidCheck = false;
    local invalidStateCount = 0;
    local was_shifted = userKeyFn();    
    while not is_done do
        nx, ny = srMousePos();  
        pixelColor = srReadPixel(nx, ny);      
        local is_shifted = userKeyFn();
        if is_shifted and not was_shifted then
          if (skipValidCheck or chatStateIsValid()) then
            skipValidCheck = true;
            local index = #clickList+1;
            local s = Stone:new({
              id = index,
              x = nx,
              y = ny,
              pointColor = pixelColor
            });
            clickList[index] = s;
            
            mines[index] = {};
            mines[index].trait = {};
            nodeleft = nodeleft - 1;
          else
            invalidStateCount = invalidStateCount + 1;
            -- Why are you setting up with a previously used workload?!?
            -- Even if you didn't use it... it must be reset to maintain consistent state!
            lsMessageBox("Invalid State" .. (invalidStateCount>1 and ' x'..invalidStateCount or ''), "Invalid selection, pull a fresh set of ore nodes");
          end
        end
        
        was_shifted = is_shifted;
        checkBreak();
        lsPrint(10, 10, z, 1.0, 1.0, 0xc0c0ffff, "Set Node Locations (" .. #clickList .. "/" .. stonecount .. ")");
        local y = 60;
        lsSetCamera(0,0,lsScreenX*1.4,lsScreenY*1.4);
        autoWorkMine = readSetting("autoWorkMine",autoWorkMine);
        autoWorkMine = lsCheckBox(15, y, z, 0xffffffff, " Auto 'Work Mine'", autoWorkMine);
        writeSetting("autoWorkMine",autoWorkMine);
        y = y + 25
        noMouseMove = readSetting("noMouseMove",noMouseMove);
        noMouseMove = lsCheckBox(15, y, z, 0xffffffff, " Dual Monitor (NoMouseMove) Mode", noMouseMove);
        writeSetting("noMouseMove",noMouseMove);
        y = y + 25
        writeLogFile = readSetting("writeLogFile",writeLogFile);
        writeLogFile = lsCheckBox(15, y, z, 0xffffffff, " Write Log File", writeLogFile);
        writeSetting("writeLogFile",writeLogFile);
        y = y + 25
        manualSets = readSetting("manualSets",manualSets);
        manualSets = lsCheckBox(15, y, z, 0xffffffff, " Manually Set Patterns", manualSets);
        writeSetting("manualSets",manualSets);
          y = y + 25
        if not manualSets then
          extraStones = readSetting("extraStones",extraStones);
          extraStones = lsCheckBox(15, y, z, 0xffffffff, " Work 4 stone combinations", extraStones);
          writeSetting("extraStones",extraStones);
        end
        lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
        y = y - 22
        lsPrint(10, y, z, 0.7, 0.7, 0xc0c0ffff, "Hover and " .. userKeyStr .. " over each node.");
        y = y + 20;
        lsPrint(10, y, z, 0.7, 0.7, 0xB0B0B0ff, "Mine Type: " .. ore .. " / Worked: " .. timesworked .. " times");
        y = y + 20;
        if miningTime ~= 0 then
          miningTimeGUI = DecimalsToMinutes(miningTime/1000);
        else
          miningTimeGUI = "N/A";
        end
        if miningTimeTotal ~= 0 then
          avgMiningTimeGUI = DecimalsToMinutes(miningTimeTotal/timesworked/1000);
        else
          avgMiningTimeGUI =  "N/A";
        end
        lsPrint(10, y, z, 0.7, 0.7, 0xf0f0f0ff, "Last: " .. miningTimeGUI .. "   /   Average: " .. avgMiningTimeGUI);
        y = y + 20;
        lsPrint(10, y, z, 0.7, 0.7, 0x80ff80ff, "Total Ore Found: " .. comma_value(math.floor(oreGatheredTotal)));
        lsPrint(175, y, z, 0.7, 0.7, 0x40ffffff, " Last: " .. comma_value(math.floor(oreGatheredLast)));
        y = y + 20;
        lsPrint(10, y, z, 0.65, 0.65, 0xB0B0B0ff, "Select " .. nodeleft .. " more nodes to automatically start!");
        y = y + 20;
        local start = math.max(1, #clickList - 20);
        local index = 0;
        for i=start,#clickList do
            local xOff = (index % 4) * 75;
            local yOff = (index - index%4)/2 * 7;
            local xOff2 = (#clickList % 4) * 75;
            local yOff2 = (#clickList - #clickList%4)/2 * 7;
            lsPrint(8 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff, i);
            lsPrint(8 + xOff, y + yOff, z, 0.5, 0.5, clickList[i].pointColor, "     (" .. clickList[i].x .. ", " .. clickList[i].y .. ")");
            index = index + 1;
            if #clickList < stonecount then
              lsPrint(8 + xOff2, y+yOff2, z, 0.5, 0.5, 0xffffffff, #clickList+1 .. ":");
              lsPrint(8 + xOff2, y+yOff2, z, 0.5, 0.5, pixelColor, "      " .. nx .. ", " .. ny);
            end
        end

        if #clickList == 0 then
          lsPrint(8, y, z, 0.5, 0.5, 0xffffffff, "1:");
          lsPrint(8, y, z, 0.5, 0.5, pixelColor, "      " .. nx .. ", " .. ny);
        end

        if #clickList >= stonecount then
            is_done = 1;
        end

        if #clickList == 0 then
            if ButtonText(10, lsScreenY - 30, z, 110, 0xffff80ff, "Work Mine") then
                workMine();
            end
        end

        if ButtonText(120, lsScreenY -30, z, 80, 0xffffffff, "Config") then
            cancelButton = 1;
            setup();
        end

        if #clickList > 0 then
            if ButtonText(10, lsScreenY - 30, z, 100, 0xff8080ff, "Reset") then
                getPoints();
                return;
            end
        end

        if ButtonText(205, lsScreenY - 30, z, 110, 0xFFFFFFff,
            "End script") then
            error "Clicked End Script button";
        end

        lsDoFrame();
        lsSleep(10);
    end
end


function clickSequence()
    oreGatheredLast = 0;
    oreGathered = 0;
    worked = 0;
    logResult = "";
    brokenStones = {};
    oreNodes = {};
    oreNodesFour = {};
    brokenStoneInfo = "";
    startMiningTime = lsGetTimer();

    if manualSets then 
      TotalCombos = #sets;
    end

    if noMouseMove then
      sleepWithStatus(3000, "Starting...\n\nNow is your chance to move your mouse to second monitor!", nil, 0.7, "Attention");
    else
      sleepWithStatus(150, "Starting...\n\nDon\'t move mouse!", nil, 0.7, "Attention");
    end

    if checkAbort() then return; end
    if manualSets then
      setsCombo();
    elseif extraStones then
       -- Work 4 stone combinations after 3 stone combinations (if any)
      fetchTotalCombos3();
      if checkAbort() then return; end
      threeStoneCombo();
      if checkAbort() then return; end

      if #oreNodes >= 4 then -- Only try 4-stone combos if there were at least four 3-stone combos, otherwise there aren't any possible
        fetchTotalCombos4();
        if checkAbort() then return; end
        worked = 0; -- Reset worked back to 0, before doing 4 stone combos
        fourStoneCombo();        
      end

    else
      fetchTotalCombos3();
      if checkAbort() then return; end
      threeStoneCombo();
    end

    miningTime = lsGetTimer() - startMiningTime;
    miningTimeTotal =  miningTimeTotal + miningTime;
    timesworked = timesworked + 1;

    lsSleep(250); -- Delay not required, just gives a slight chance to see the last node worked on GUI, from updateGUI(), before it disappears off screen

    if not muteSoundEffects then
        lsPlaySound("beepping.wav");
    end

    if autoWorkMine then
        workMine();
    end
    TakeOreWindowRefresh();
    reset();
end


function workMine()
    if noMouseMove then
      srClickMouseNoMove(mineX, mineY);
      lsSleep(clickDelay);
      clickAllText("Work this Mine", 20, 2); -- offsetX, offsetY, rightClick (1 = true)
    else
      srSetMousePos(mineX, mineY);
      lsSleep(clickDelay);
      --Send 'W' key over Mine to Work it (Get new nodes)
      srKeyEvent('W');
    end
    if writeLogFile then
      WriteLog("\nWorking Mine...");
    end
    sleepWithStatus(1000, "Working mine (Fetching new nodes)", nil, 0.7, "Refreshing Nodes");
    findClosePopUpOld();
end


function checkCloseWindows()
    -- Rare situations a click can cause a window to appear for a node, blocking the view to other nodes.
    -- This is a safeguard to keep random windows that could appear, from remaining on screen and blocking the view of other nodes from being selected.
    srReadScreen();
    lsSleep(10);
    local closeWindows = findAllImages("thisis.png");

    if #closeWindows > 0 then
        for i=#closeWindows, 1, -1 do
            -- 2 right clicks in a row to close window (1st click pins it, 2nd unpins it
            srClickMouseNoMove(closeWindows[i][0]+5, closeWindows[i][1]+10, true);
            lsSleep(100);
            srClickMouseNoMove(closeWindows[i][0]+5, closeWindows[i][1]+10, true);
        end
        lsSleep(10);
    end
end


function checkAbort()
  checkBreak();

  if lsControlHeld() and lsAltHeld() then
    sleepWithStatus(750, "Aborting ...");
    reset();
    return true;
  end
end

function waitForResult()
  startTime = lsGetTimer();
  local loopCount = 0;
  local OK = nil;
  local sleepDelay = math.max(clickDelay, minResultDelay)

  while 1 do
    loopCount = loopCount+1;
    logResult = 'findWorkResult['..loopCount..']: ';
    checkBreak();
    -- Find chat messages
    --print('['..loopCount..'] Checking main chat...');
    parseChat();
      
    if (not oreFound) then
      -- Find and Close Popup
      --print('['..loopCount..'] Looking for Popup...');
      OK = srFindImage("OK.png");
      if OK then
        srClickMouseNoMove(OK[0]+2,OK[1]+2);
        lsSleep(sleepDelay);
        logResult = logResult .. 'Found Popup (No Ore Gathered)'
        --print(logResult);
        break;
      end
    end

    --If we gathered new ore, add to tally, we're not going to get a popup.
    local curTime = lsGetTimer() - startTime;
    if (oreFound) or (curTime > chatReadTimeOut)  then
      logResult = logResult .. ((curTime > chatReadTimeOut) and 'Timed Out' or 'Normal Break');

      if (curTime > chatReadTimeOut) then
        -- We really shouldn't get in here anymore except under the most exceptional circumstances
        -- If we actually timeout we're going to assume some misclicks occurred and force no ore found
        oreFound = nil;
        oreGathered = nil;
      end

      if oreFound and oreGathered ~= nil then
        oreGatheredTotal = oreGatheredTotal + oreGathered;
        oreGatheredLast = oreGatheredLast + oreGathered;
        logResult = logResult .. "\n[Ore Gathered: " .. oreGathered .. "]  [oreGatheredLast: " .. math.floor(oreGatheredLast) .. "]  [oreGatheredTotal: " .. math.floor(oreGatheredTotal) .. "]";
      end

      --print(logResult);
      lsSleep(sleepDelay);
      break;
    end

    lsSleep(sleepDelay);
  end
end


function findClosePopUpOld()
    while 1 do
        checkBreak();
        srReadScreen();
        lsSleep(10);
        OK = srFindImage("OK.png");
        if OK then
            srClickMouseNoMove(OK[0]+2,OK[1]+2);
            lsSleep(clickDelay);
        else
            break;
        end
    end
end

function parseChat()
  local chatText = getChat();
  local lastLine = chatText and chatText[#chatText][2];
  if (lastLine and lastLine:findAny(chatParseTargets)) then
    -- We haven't received any 
    --if (not messageReceived) then -- Don't fill the console with the same message over and over and over and...
      --print('Workload has no value.'); 
      --messageReceived = true;
    --end
    oreFound = nil;
    return;
  end
  --messageReceived = false;
 
  local idx = #chatText;
  --print('Line to parse: '..chatText[idx][2]);
  local currentLine = gsub(chatText[idx][2], '.+] ','');
  repeat -- loop backwards though the lines until we find the messages we want or the time
    --print('Current ['..idx..'] Line: '..currentLine);    
    --gemSize, gemType = currentLine:match(gemMatchPattern);    
    --print('Ore Match Pattern: '..oreMatchPattern);   
    oreGathered = match(currentLine, oreMatchPattern);
    if (oreGathered) then -- We found ore!
      oreFound = true;
      --print("Ore gathered: "..oreGathered);
      chatcmd("time");
      break;
    else
      oreFound = nil;
    end 
           
    idx = idx-1;
    currentLine = gsub(chatText[idx][2],'.+] ','');
    lsSleep(1); -- Yes this is too fast to do anything. It just gives me the warm/fuzzies
  until (currentLine:findAny(chatParseTargets)); 
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function DecimalsToMinutes(dec)
  local ms = tonumber(dec)
  if ms >= 60 then
    return math.floor(ms / 60).."m ".. math.floor(ms % 60) .. "s";
  else
    return math.floor(ms) .. "s";
  end
end


function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


function TakeOreWindowRefresh()
 findAllOre = findText("All Ore");
 findAllMetal = findText("All Metal"); -- Silver Mines give metal, not Ore. This check is for Silver Mines.

	if findAllOre then
		if not autoWorkMine then
	         sleepWithStatus(1000, "Refreshing pinned Ore menu ..."); -- Let pinned window catchup. If autowork mine, there is already a 1000 delay on workMine()
		end
	 safeClick(findAllOre[0]-3,findAllOre[1]-3);
	end
	if findAllMetal then
		if not autoWorkMine then
	         sleepWithStatus(1000, "Refreshing pinned Metal menu ..."); -- Let pinned window catchup. If autowork mine, there is already a 1000 delay on workMine()
		end
	 safeClick(findAllMetal[0]-3,findAllMetal[1]-3);
	end
end


function updateGUI(i,j,k,l)
                local y = 10;
                lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to End this script.");
                y = y +15
                lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to Pause this script.");
                y = y +35
                if l ~= nil then -- this is l (lower cased L), not 1 (number one), l is the 4th node from a 4 stone combo (i,j,k,l)
                  lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. ", " .. l);
                else -- We're doing a 3 stone combo (i,j,k)
                  lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k);
                end
                y = y + 20;
                lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Node Click Delay: " .. clickDelay .. " ms");
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Last 'Nodes Worked' Time: " .. round((setTime/100)/10,2) .. "s");
                y = y + 16;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Mine Worked: " .. timesworked .. " times");
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Current Time Elapsed:   " .. DecimalsToMinutes(elapsedTime/1000));
                y = y + 16;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Previous Time Elapsed: " .. miningTimeGUI);
                y = y + 16;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Average Time Elapsed:  " .. avgMiningTimeGUI);
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0x40ffffff, "Current Ore Found: " .. comma_value(math.floor(oreGatheredLast)));
                y = y + 20;
                lsPrint(10, y, 0, 0.7, 0.7, 0x80ff80ff, "Total Ore Found:     " .. comma_value(math.floor(oreGatheredTotal)));
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffff80ff, "Hold Ctrl+Alt to Abort and Return to Menu.");
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0xff8080ff, "Don't touch mouse until finished!");
                y = y + 35;
                progressBar(y)

                brokenStoneInfo = "Broken Nodes: " .. table.concat(brokenStones,", ");
                y = y + 20
                lsPrintWrapped(10, y, 0, lsScreenX-20, 0.7, 0.7, 0xFFFFFFff, brokenStoneInfo);

                lsDoFrame();
end

function threeStoneCombo()
  local skipWork = nil;
  local stone1 = nil;
  local stone1_broken = nil;
  local stone2 = nil;
  local stone2_broken = nil;
  local stone3 = nil;
  for i=1,#clickList do
    stone1 = clickList[i];
    stone1_broken = stone1:isBroken();
    for j=i+1,#clickList do
      stone2 = clickList[j];
      stone2_broken = stone2:isBroken();
      for k=j+1,#clickList do
        stone3 = clickList[k];

        skipWork = stone1_broken or stone2_broken or stone3:isBroken();
        -- I'm only keeping skipWork because it's used in writeLogFile section below (for now)
        if (skipWork) then goto CONTINUE; end

        findClosePopUpOld(); --Extra precaution to check for remaining popup before working the nodes
        if checkAbort() then return; end

        startSetTime = lsGetTimer();
        if noMouseMove then -- Check for dual monitor option - don't move mouse cursor over each node and send keyEvents. Instead do rightClick popup menus
          -- 1st Node
          srClickMouseNoMove(stone1.x, stone1.y);
          lsSleep(clickDelay);
          clickAllText("[A]", 20, 2);

          srReadScreen();
          clickAllText("Ore Stone", 20, 2)

          -- 2nd Node
          srClickMouseNoMove(stone2.x, stone2.y);
          lsSleep(clickDelay);
          clickAllText("[A]", 20, 2);

          srReadScreen();
          clickAllText("Ore Stone", 20, 2)

          -- 3rd Node
          srClickMouseNoMove(stone3.x, stone3.y);
          lsSleep(clickDelay);
          clickAllText("[S]", 20, 2);

          srReadScreen();
          clickAllText("Ore Stone", 20, 2)

        else -- noMouseMove is false
          -- 1st Node
          srSetMousePos(stone1.x, stone1.y);
          lsSleep(clickDelay);
          srKeyEvent('A');

          -- 2nd Node
          srSetMousePos(stone2.x, stone2.y);
          lsSleep(clickDelay);
          srKeyEvent('A');

          -- 3rd Node
          srSetMousePos(stone3.x, stone3.y);
          lsSleep(clickDelay);
          srKeyEvent('S');
        end -- end noMouseMove check
        if checkAbort() then return; end

        lsSleep(150);
        waitForResult();
        elapsedTime = lsGetTimer() - startMiningTime;
        setTime = lsGetTimer() - startSetTime;

        if (oreFound) then
          oreNodes[#oreNodes + 1] = {i, j, k};
          stone1:use();
          stone2:use();
          stone3:use();          
        end
        if checkAbort() then return; end 

        stone1_broken = stone1:isBroken();
        stone2_broken = stone2:isBroken();
        ::CONTINUE::

        if checkAbort() then return; end
        worked = worked + 1
        updateGUI(i,j,k);
        if checkAbort() then return; end

        if writeLogFile then
          if skipWork then
            lsPlaySound("start.wav");  -- Audible alert that we are skipping this workload
            WriteLog("[" .. worked .. "/" .. TotalCombos .. "] Skipping Broken Node Combo (Broken Node(s) = " .. table.concat(brokenStones,", ") .. "): " .. i .. ", " .. j .. ", " .. k);
          elseif not OK then
          --  WriteLog("\n[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. " - Result: " .. logResult);
          else
            WriteLog("[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. " - Result: " .. logResult);
          end
          logResult = "";
        end        
      end
    end
  end

  parseOreNodes()
end

function fourStoneCombo()
  local skipWork = nil;
  local stone1 = nil;
  local stone2 = nil;
  local stone3 = nil;
  local stone4 = nil;

  for a=1,#oreNodes4 do
    findClosePopUpOld(); --Extra precaution to check for remaining popup before working the nodes

    i = oreNodes4[a][1];
    stone1 = clickList[i];    
    j = oreNodes4[a][2];
    stone2 = clickList[j];
    k = oreNodes4[a][3];
    stone3 = clickList[k];
    l = oreNodes4[a][4];
    stone4 = clickList[l];
    skipWork = stone1:isBroken() or stone2:isBroken() or stone3:isBroken() or stone4:isBroken();
    -- I'm only keeping skipWork because it's used in writeLogFile section below (for now)
    if (skipWork) then goto CONTINUE; end

    if checkAbort() then return; end
    startSetTime = lsGetTimer();

    if noMouseMove then -- Check for dual monitor option - don't move mouse cursor over each node and send keyEvents. Instead do rightClick popup menus        
      -- 1st Node
      srClickMouseNoMove(clickList[oreNodes4[a][1]][1], clickList[oreNodes4[a][1]][2]);
      lsSleep(clickDelay);
      clickAllText("[A]", 20, 2);

      -- 2nd Node
      srClickMouseNoMove(clickList[oreNodes4[a][2]][1], clickList[oreNodes4[a][2]][2]);
      lsSleep(clickDelay);
      clickAllText("[A]", 20, 2);

      -- 3rd Node
      srClickMouseNoMove(clickList[oreNodes4[a][3]][1], clickList[oreNodes4[a][3]][2]);
      lsSleep(clickDelay);
      clickAllText("[A]", 20, 2);

      -- 4th Node
      srClickMouseNoMove(clickList[oreNodes4[a][4]][1], clickList[oreNodes4[a][4]][2]);
      lsSleep(clickDelay);
      clickAllText("[S]", 20, 2);
    else -- noMouseMove is false
      -- 1st Node
      srSetMousePos(clickList[oreNodes4[a][1]][1], clickList[oreNodes4[a][1]][2]);
      lsSleep(clickDelay);
      srKeyEvent('A');

      -- 2nd Node
      srSetMousePos(clickList[oreNodes4[a][2]][1], clickList[oreNodes4[a][2]][2]);
      lsSleep(clickDelay);
      srKeyEvent('A');

      -- 3rd Node
      srSetMousePos(clickList[oreNodes4[a][3]][1], clickList[oreNodes4[a][3]][2]);
      lsSleep(clickDelay);
      srKeyEvent('A');

      -- 4th Node
      srSetMousePos(clickList[oreNodes4[a][4]][1], clickList[oreNodes4[a][4]][2]);
      lsSleep(clickDelay);
      srKeyEvent('S');
    end -- end noMouseMove check
      
    if checkAbort() then return; end      
    waitForResult();
    if checkAbort() then return; end

    elapsedTime = lsGetTimer() - startMiningTime;
    setTime = lsGetTimer() - startSetTime;

    if (oreFound) then
      oreNodesFour[#oreNodesFour + 1] = {i, j, k, l};
      stone1:use();
      stone2:use();
      stone3:use();
      stone4:use();
    end
    if checkAbort() then return; end 

    ::CONTINUE::

    if checkAbort() then return; end
    worked = worked + 1
    updateGUI(i,j,k,l);
    if checkAbort() then return; end

    if writeLogFile then
  		if skipWork then
	  	  lsPlaySound("start.wav");  -- Audible alert that we are skipping this workload
		    WriteLog("[" .. worked .. "/" .. TotalCombos .. "] Skipping Broken Node Combo (Broken Node(s) = " .. table.concat(brokenStones,", ") .. "): " .. i .. ", " .. j .. ", " .. k .. ", " .. l);
		  elseif not OK then
		    WriteLog("\n[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. ", " .. l .. " - Result: " .. logResult);
		  else
		    WriteLog("[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. ", " .. l .." - Result: " .. logResult);
		  end
		  logResult = "";
	  end
  end

  parseOreNodesFour();
end


function setsCombo()
  local stones = {};

	for i=1, #sets do
    w = sets[i][1]    
    x = sets[i][2]
    y = sets[i][3]
    z = sets[i][4]

		for j=1, #sets[i] do
      findClosePopUpOld(); --Extra precaution to check for remaining popup before working the nodes
      startSetTime = lsGetTimer();
      key = (j == #sets[i] and "S" or "A");    
      stones[j] = clickList[sets[i][j]];
      srSetMousePos(stone[j].x,stone[j].y)
      lsSleep(clickDelay);
      srKeyEvent(key);
      lsSLeep(10);
		end -- for j

    waitForResult();
    elapsedTime = lsGetTimer() - startMiningTime;
    setTime = lsGetTimer() - startSetTime;
		
    if (oreFound) then
      for _, stone in ipairs(stones) do
        stone:use();
      end
    end
    if checkAbort() then return; end

    worked = worked + 1
    updateGUI(w,x,y,z);

    if writeLogFile then
		  if #sets[i] == 4 then
		    WriteLog("[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. w .. ", " .. x .. ", " .. y .. ", " .. z);
			else -- else it's 3 nodes
		    WriteLog("[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. w .. ", " .. x .. ", " .. y);
		  end
		end
	end -- for i
end


function compareColorEx(left, right, rgbTol, hueTol)
	local leftRgb = parseColor(left);
	local rightRgb = parseColor(right);
	local i;
	local d;
	local rgbTotal = 0;
	local hueTotal = 0;
	for i = 0, 2 do
		-- Compare raw RGB values
		d = leftRgb[i] - rightRgb[i];
		rgbTotal = rgbTotal + (d * d);
		if(rgbTotal > rgbTol) then
			return false;
		end
		-- Compare hue
		if(i < 2) then
			d = (leftRgb[i] - leftRgb[i+1]) - (rightRgb[i] - rightRgb[i+1]);
			hueTotal = hueTotal + (d * d);
		else
			d = (leftRgb[i] - leftRgb[0]) - (rightRgb[i] - rightRgb[0]);
			hueTotal = hueTotal + (d * d);
		end
		if(hueTotal > hueTol) then
			return false;
		end
	end
	return true;
end


function parseColor(color)
	local rgb = {};
	local c = color / 256;
	rgb[0] = math.floor(c / 65536);
	c1 = c - (rgb[0] * 65536);
	if(rgb[0] < 0) then
		rgb[0] = rgb[0] + 256;
	end
	rgb[1] = math.floor(c1 / 256);
	rgb[2] = math.floor(c1 - (rgb[1] * 256));
	return rgb;
end


function WriteLog(Text)
	logfile = io.open("mining_ore_Logs.txt","a+");
	logfile:write(Text .. "\n");
	logfile:close();
end


function getTraits()
  minesB = {}
  trait=1;
  traits_done = nil;
  trait_value = 1;

  while not traits_done do
    checkBreak()
    local z = 0;
    local y = 2;
    y = 40;

      for i=1,#clickList do

        for j=1,#minesB do
	    if minesB[j][1] == i then
	      lsPrint(150, y, 0, 0.7, 0.7, 0xFFFFFFff, minesB[j][2] .. ":" .. minesB[j][3]);
	    end
        end --end j

	  lsPrint(50, y, 0, 0.7, 0.7, 0xFFFFFFff, "Node " .. i);

	  if ButtonText(110, y, z, 50, 0xFFFFFFff, "Set", 0.7, 0.7) then
	      isSet = nil
	      for j=1,#minesB do
	          if minesB[j][1] == i and minesB[j][1] ~= nil then
	            isSet = 1
	          end
	      end
	      if not isSet then
	        minesB[#minesB + 1] = {i, trait, trait_value}
	        index = i
	        mines[index].trait[trait] = trait_value;
	      end
	  end


	  if ButtonText(10, y, z, 40, 0xFFFFFFff, "PM", 0.7, 0.7) then
	    while lsMouseIsDown() do
	      lsPrintWrapped(10, 10, z, lsScreenX - 20, 0.7, 0.7, 0xf2f2f2ff, "Point Mouse to Node " .. i .. "\n\nRelease Mouse Button to continue ...");
	      lsDoFrame()
	      lsSleep(16)
	    end
	    srSetMousePos(clickList[i][1], clickList[i][2])
	  end
          y = y + 20;


	end --end i


			if ButtonText(5, lsScreenY - 100, 1, 120, 0xFFFFFFff, "Next Value", 0.7, 0.7) then
			  trait_value = trait_value + 1;
			end

			if ButtonText(5, lsScreenY - 75, 1, 120, 0xFFFFFFff, "Next Trait", 0.7, 0.7) then
				if not allMinesHaveTrait(trait) then
					lsMessageBox("Trait not done", "You have not finished assigning values to all ore stones for this trait.");
				else
					trait = trait + 1;
					trait_value = 1;
				end
			end

			if trait > 1 then
			  if ButtonText(5, lsScreenY - 50, 1, 120, 0xFFFFFFff, "Prev Trait", 0.7, 0.7) then
				trait = trait - 1;
				trait_value = 1;
			  end
			end

			if ButtonText(5, lsScreenY - 25, 1, 220, 0xFFFFFFff, "Done assigning traits", 0.7, 0.7) then
				traits_done = true;
			end



    lsPrintWrapped(10, 2, z, lsScreenX - 20, 0.7, 0.7, 0xf2f2f2ff, "Trait #" .. trait .. ", value #" .. trait_value .. "\nClick all matching ore stones");
    lsDoFrame()
    lsSleep(10);
  end -- while not traits_done
end


function findSets()
	local set_min_size = 3; -- Number of ore stones needed to make a set?
	-- find all sets
	statusScreen("Searching for sets (this may take a while)", 0xFFFFFFff, "no break");
	num_traits = trait;
	sets = {};
	count = 0;
	for set_size = set_min_size, #mines do
		local found_one_at_this_size = false;
		set = {};
		for i=1, set_size do
			set[i] = i;
		end

		while set do

			count = count + 1;

			if count == 1000 then
				count = 0;
				lsPrintln(set_to_string(set) .. " found " .. #sets .. " so far.");
			end

			if is_valid_set(set) then
				if is_matching_set(set) then
					sets[#sets + 1] = set;
					found_one_at_this_size = true;
				end
			end

			set = increment_set(set);
		end
		if not found_one_at_this_size then
			break;
		end
	end

	-- display results

	while true do
		if #sets == 0 then
			statusScreen("NO matching sets", 0xFFFFFFff, "no break");
		else
			statusScreen("Matching sets", 0xFFFFFFff, "no break");
		end
		lsScrollAreaBegin("ResultsScroll", 0, 100, 0, lsScreenX - 50, lsScreenX - 110)
		for i=1, #sets do
			lsPrint(0, (i-1)*20, 3, 1, 1, 0xFFFFFFff, set_to_string(sets[i]));
		end
		lsScrollAreaEnd(#sets*20);
		--lsScrollAreaEnd(lsScreenY-50);

        if ButtonText(10, lsScreenY - 30, z, 110, 0xFFFFFFff, "GO") then
          break;
        end
	lsSleep(10);
	end
end


function is_valid_set(set)
	local used = {};
	local last = 0;
	for i=1, #set do
		if set[i] <= last then
			return false;
		end
		last = set[i];
	end
	return true;
end


function is_matching_set(set)
	for i=1, num_traits do
		local match=false;
		local unmatch=false;
		for j=2, #set do
			for k=1, j-1 do
				if mines[set[j]].trait[i] == mines[set[k]].trait[i] then
					match = true;
				else
					unmatch = true;
				end
			end
		end
		if match and unmatch then
			return false;
		end
	end
	return true;
end


function increment_set(set)
	local newset = {};
	for i=1, #set do
		newset[i] = set[i];
	end
	set = newset;
	local index = #set;
	while true do
		if set[index] == #mines then
			if index == 1 then
				return nil;
			end
			set[index] = 1;
			index = index - 1;

		else
			set[index] = set[index] + 1;
			return set;
		end
	end
end


function set_to_string(set)
	local ret = "";
	for i=1, #set do
		ret = ret .. "  " .. set[i];
	end
	return ret;
end


function allMinesHaveTrait(trait_num)
	for i=1, #mines do
		if not mines[i].trait[trait_num] then
			return false;
		end
	end
	return true;
end


function progressBar(y)
  local barWidth = 220;
  local barTextX = (barWidth - 22) / 2
  local barX = 10;
  local percent = round(worked / TotalCombos * 100,2)
  local progress = ( (barWidth-4) / TotalCombos) * worked
  if progress < barX+6 then
    progress = barX+6
  end
  if math.floor(percent) <= 25 then
    progressBarColor = 0x669c35FF
  elseif math.floor(percent) <= 50 then
    progressBarColor = 0x77bb41FF
  elseif math.floor(percent) <= 65 then
    progressBarColor = 0x96d35fFF
  elseif math.floor(percent) <= 72 then
    progressBarColor = 0xdced41FF
  elseif math.floor(percent) <= 79 then
    progressBarColor = 0xe9ea18FF
  elseif math.floor(percent) <= 83 then
    progressBarColor = 0xf8be0cFF
  elseif math.floor(percent) <= 92 then
    progressBarColor = 0xff7567FF
  elseif math.floor(percent) <= 99 then
    progressBarColor = 0xff301bFF
  else
    progressBarColor = 0xe3c6faFF
  end
  lsPrint(barTextX, y+3.5, 15, 0.60, 0.60, 0x000000ff, percent .. " %");
  lsDrawRect(barX, y, barWidth, y+20, 5,  0x3a88feFF); -- blue shadow
  lsDrawRect(barX+2, y+2, barWidth-2, y+18, 10,  0xf6f6f6FF); -- white bar background
  lsDrawRect(barX+4, y+4, progress, y+16, 15,  progressBarColor); -- colored progress bar
end


function findBrokenStone()
  --sleepWithStatus(100, "Searching for Broken Nodes", nil, 0.7);
  findClosePopUpOld(); -- Double check for any leftover popups that might be covering a node and prevent proper detection
  brokenStones = {} -- Flush array
  for i=1, #clickList do
    thisColor = srReadPixel(clickList[i][1], clickList[i][2])
      if(not compareColorEx(thisColor, clickListColor[i][1], rgbTol, hueTol)) then
      table.insert(brokenStones, i);
      end -- if(not compare...
  end -- for i

    if writeLogFile and #brokenStones > 1 then
      -- Plural
      WriteLog("\n**** Found Coal/Gem message (within past 2 lines - Recheck pixel check on ALL nodes)!\nNodes: " .. table.concat(brokenStones,", ") .. " are no longer present.\n")
      -- Singular
    elseif writeLogFile and #brokenStones == 1 then
      WriteLog("\n**** Found Coal/Gem message! Node: " .. table.concat(brokenStones,", ") .. " is no longer present.\n")
    end
end


function parseOreNodes()
  if writeLogFile then WriteLog("\n**** " .. #oreNodes .. "/" .. TotalCombos .. " Combos produced Ore:") end;
    for a=1, #oreNodes do
      if writeLogFile then WriteLog("{" .. oreNodes[a][1] .. ", " .. oreNodes[a][2] .. ", " .. oreNodes[a][3] .. "},") end;
    end
end


function parseOreNodesFour()
  if writeLogFile then WriteLog("\n**** " .. #oreNodesFour " 4 Stone Combos produced Ore:") end;
    for a=1, #oreNodesFour do
      if writeLogFile then WriteLog(oreNodesFour[a][1] .. ", " .. oreNodesFour[a][2] .. ", " .. oreNodesFour[a][3] .. ", " .. oreNodesFour[a][4]) end;
    end
end


--------------------- Credits: Ashen for below Functions

function equalset(a, b)
    if not #a == #b then
        return false;
    end
    for i=1,#a do
        local found = false;
        for j=1,#b do
            if (b[j] == a[i]) then
                found = true;
                break;
            end
        end
        if not found then
            return false;
        end
    end
    return true;
end


function wasThreeSetValid(a, b, c)
    local s = {a, b, c};
    for i=1, #oreNodes do
        if equalset(s, oreNodes[i]) then
            return true;
        end
    end
    return false
end


function isFourSetValid(a, b, c, d)
    if not wasThreeSetValid(a, b, c) then
       return false;
    end
    if not wasThreeSetValid(a, b, d) then
       return false;
    end
    if not wasThreeSetValid(b, c, d) then
       return false;
    end
    if not wasThreeSetValid(a, c, d) then

       return false;
    end
    return true;
end

---------------------

--------------------- Chat Related Functions
function initChat()
  if not openChat("chat/main_chat.png", "ocr/mainChatWhite.png", "ocr/mainChatRed.png") then    
    return false;
  end
  
  if not minimizeChat() then 
    return false;
  end

  return true;
end

function openChat(active, white, red)
  srReadScreen();
  if not srFindImage(active) then
    --print("Couldn't find [active] image");
    local chat = srFindImage(white);
    if not chat then
      --print("Couldn't find [white] image");
      chat = srFindImage(red);
    end

    if not chat then
      lsPrintln("Chat tab not found");
      return false;
    end

    safeClick(chat[0], chat[1]);
    lsSleep(100);
  end

  if not waitForImage(active, 2500) then
    --print("Chat tab failed to open");
    return false;
  end

  srReadScreen();
  local min = srFindImage("chat/chat_min.png");
  if min then
    srKeyDown(VK_RETURN);
    lsSleep(10);
    srKeyUp(VK_RETURN);
    lsSleep(10);
  end

  if waitForNoImage("chat/chat_min.png", 2000) then
    --print("Chat failed to start");
    return false;
  end

  return true;
end

function minimizeChat()
  lsSleep(100); -- Give the system a little time if it's going to minimize chat itself!
  srReadScreen();

  local min = srFindImage("chat/chat_min.png");
  if not min then
    srKeyDown(VK_RETURN);
    lsSleep(10);
    srKeyUp(VK_RETURN);
    lsSleep(10);
  end

  if not waitForImage("chat/chat_min.png", 2000) then
    lsPrintln("Chat failed to minimize");
    return false;
  end

  return true;

end

function isChatMain()
  local active = srFindImage("chat/main_chat.png");
  --print('Active: ' .. dump(active));
  return (active ~= nil);
end
function isChatMinimized()
  local minimized = srFindImage("chat/chat_min.png");
 return (minimized ~= nil);
end

function say(msg)
  if not openChat("chat/main_chat.png", "ocr/mainChatWhite.png", "ocr/mainChatRed.png") then
    return;
  end

  srKeyEvent(msg);
  lsSleep(100);
  srKeyDown(VK_RETURN);
  lsSleep(10);
  srKeyUp(VK_RETURN);
  lsSleep(10);

  if not minimizeChat() then error "Unable to minimize chat"; end
end

function chatcmd(cmd) 
  if not openChat("chat/main_chat.png", "ocr/mainChatWhite.png", "ocr/mainChatRed.png") then
    return;
  end

  srKeyDown(VK_DIVIDE);
  lsSleep(10);
  srKeyUp(VK_DIVIDE);
  lsSleep(10);
  srKeyEvent(cmd);
  lsSleep(100);
  srKeyDown(VK_RETURN);
  lsSleep(10);
  srKeyUp(VK_RETURN);
  lsSleep(10)

  if not minimizeChat() then error "Unable to minimize chat"; end
end

function getChat()
  srReadScreen();
  pauseForChat();
  return getChatText();
end

function chatStateIsValid()
  local chatText = getChat();
  --print(dump(chatText));
  local lastLine = chatText[#chatText] and chatText[#chatText][2] or nil;
  return lastLine and lastLine:findAny(chatParseTargets);
end

function pauseForChat()
  if (isChatMain()) then return; end
  local chatPause = false;

  -- Wait for Main chat screen and alert user if its not showing
  local playedSound = false
  repeat
    while (not isChatMain()) do
      checkAbort();
      chatPause = true;
      if (not muteSoundEffects and not playedSound) then 
        lsPlaySound("timer.wav"); 
        playedSound = true;
      end
       
      sleepWithStatus(500, "Paused while waiting for MAIN chat to be actived." ..
        "\nYou may chat in other tabs during this time.\n\nReactivate MAIN to continue.", nil, 0.7);
      srReadScreen();
    end

    if (chatPause) then 
      local countDown = 5;
      -- We were paused waiting on MAIN chat. Let's give a 5 second count down to restart
      repeat
        sleepWithStatus(1000, "Restarting in - " .. countDown);
        countDown = countDown - 1;
      until (countDown == 0)
      srReadScreen();
    end
    chatPause = false;  
  until (isChatMain())  
end
---------------------
function string:findAny(T)
  --print('String: '..self ..'\nTargets: '..dump(T))
  if (type(T) == 'table') then
    for i=1,#T do
      if find(self, T[i]) then return true; end
    end
  else
    return find(self, T);
  end
  return false;
end

function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end

function drawBottomButton(xOffset, text, colour)
  return lsButtonText(lsScreenX - xOffset, lsGetWindowSize()[1] - 30, 100, 100, colour or WHITE, text)
end