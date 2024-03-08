dofile("common.inc");
dofile("settings.inc")

----------------------------------------
--          Global Variables          --
----------------------------------------

askText = singleLine([[
  Automatically gathers wood from pinned tree windows.
]]);

----------------------------------------

function doit()
  askForWindow(askText);
  promptParameters();
  askForFocus();
  while 1 do
    checkBreak();
    refreshWindows();
    findWood();
    refreshWindows();
    bonfire();
    refreshWindows();
    sleepWithStatus(5000, "Searching\n\nPinned Trees found: " .. #nowood .. "\nBonfire found: ".. (#Bonfire > 0 and 'Yes' or 'No') );
  end
end

function promptParameters()
  scale = 1.0;
  local z = 0;
  local is_done = nil;
  -- Edit box and text display
  while not is_done do
    checkBreak();
    y = 5;

    lsPrintWrapped(10, y, z, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
	  "Pin 5-10 tree windows, will click them VERTICALLY"
    .. " (left to right if there is a tie - multiple columns are fine)."
    .. "\n\nOptionally, pin a Bonfire window for stashing wood."
    .. "\n\nIf the trees are part of an oasis, you only need to pin 1 of the trees.");
    y = y + 140

    lsPrint(10, y, 10, scale, scale, 0xffff40ff,
    "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
    y = y + 25

    autoCarrot = readSetting("autoCarrot",autoCarrot);
    autoCarrot = lsCheckBox(10, y, z, 0xFFFFFFff, " Automatically Eat Carrots", autoCarrot);
    writeSetting("autoCarrot",autoCarrot);

    lsPrintWrapped(10, y+25, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
      "(Pin the 'Grilled Carrot' window)\nAutomatically eat a carrot, everytime the perception buff is not visible.");

    if lsButtonText(10, (lsScreenY - 30) * scale, z, 100, 0x00ff00ff, "OK") then
      is_done = 1;
    end

    if lsButtonText((lsScreenX - 110) * scale, (lsScreenY - 30) * scale, z, 100, 0xFF0000ff,
      "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(100);
  end
end

function findWood()
  srReadScreen();

  if autoCarrot then
    eatCarrot()
  end

  nowood = findAllImages("wood/no_wood.png")
  local clickWood = findAllImages("wood/gather_wood.png");
  local mightyChop = findAllImages("wood/mighty_chop.png");

  if #mightyChop > 0 then
    for i=1,#mightyChop do
      safeClick(mightyChop[i][0], mightyChop[i][1])
    end
  else
    for i=1,#clickWood do
      safeClick(clickWood[i][0], clickWood[i][1])
    end
  end
end

function bonfire()
  srReadScreen();
  local BonfireAdd = findAllText("Add some Wood");
  for i=1,#BonfireAdd do
    safeClick(BonfireAdd[i][0]+10, BonfireAdd[i][1]+10);
    lsSleep(500);
    srReadScreen();
    local max = srFindImage("max.png");
      if max then
        safeClick(max[0]+10,max[1]);
      else
        sleepWithStatus(500, "Could not add wood to the bonfire");
      end
  end
end

----------------------------------------
--         Utility Functions          --
----------------------------------------

function refreshWindows()
  srReadScreen();
  this = findAllImages("wood/This.png");
  Bonfire = findAllText("Bonfire");
    for i=1,#this do
      safeClick(this[i][0], this[i][1])
    end
  lsSleep(500);
end

function eatCarrot()
  srReadScreen();
  buffed = srFindImage("stats/perceptionBuff.png")
    if not buffed then
      srReadScreen();
      local consumeCarrot = srFindImage("consume.png")
      if consumeCarrot ~= nil then
        safeClick(consumeCarrot[0],consumeCarrot[1]);
        waitForImage("stats/perceptionBuff.png", 5000, "Waiting for Perception Buff icon")
        srClickMouseNoMove(consumeCarrot[0]-5,consumeCarrot[1]-10);
        lsSleep(click_delay);
      end
    end
end

----------------------------------------