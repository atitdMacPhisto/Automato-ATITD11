-- Console will output last character in each line (when training).
-- Also check https://www.atitd.org/wiki/tale6/User:Skyfeather/VT_OCR for more info on OCR

dofile("common.inc");
dofile("settings.inc");

offsetX = 102;
offsetY = 72;
train_windows = true;

function doit()
  askForWindow("Train OCR\n\nType a single letter/number in main chat.\n\nUse offsetX/Y to get the white box to surround this letter/number. Tip: You can also resize Main Chat to move into the white box. Top&Left of white box should border the letter/number. \n\nThen check Train button to show the code (in Console).\n\nThis macro is looking for your main chat window and the last letter/number you typed...\n\nOnce you find the values in Console, copy that to automato/games/ATITD9//data/charTemplate.txt file.");
  while true do
    findStuff();
  end
end

function findStuff()
  checkBreak();
  local z = 0;
  local scale = 0.9;

  srReadScreen();
  if train_windows then
    -- Values required for training the ocr from standard UI windows.
    regions = findAllTextRegions();
    regions = regions[1];
    srSetWindowInvertColorRange(minSetWindowInvertColorRange, maxSetWindowInvertColorRange);
  else
    -- Values required for training the ocr from the main chat window.
    regions = findChatRegionReplacement();
    srSetWindowBackgroundColorRange(0x797070,0xFFFFFA);
  end

  --sleepWithStatus(5000, regions[0] .. ", " .. regions[1] .. ", " .. regions[2] .. ", " .. regions[3]);

  lsPrint(10, lsScreenY - 155, z, scale, scale, 0xFFFFFFff, "offsetX:");

  offsetX = readSetting("offsetX",offsetX);
  foo, offsetX = lsEditBox("offsetX", 80, lsScreenY - 156, 0, 50, 30, 1.0, 1.0, 0x000000ff, offsetX);
  offsetX = tonumber(offsetX);
  if not offsetX then
    lsPrint(140, lsScreenY - 160+3, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
    offsetX = 0;
  end
  writeSetting("offsetX",offsetX);

  lsPrint(140, lsScreenY - 155, z, scale, scale, 0xFFFFFFff, "offsetY:");

  offsetY = readSetting("offsetY",offsetY);
  foo, offsetY = lsEditBox("offsetY", 210, lsScreenY - 156, 0, 50, 30, 1.0, 1.0, 0x000000ff, offsetY);

  offsetY = tonumber(offsetY);
  if not offsetY then
    lsPrint(140, lsScreenY - 130+3, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
    offsetY = 0;
  end
  writeSetting("offsetY",offsetY);

  zoom = CheckBox(10, lsScreenY - 100, z, 0xffffffff, " Zoom 2.5x", zoom);
  if zoom then
    zoomLevel = 2.5;
  else
    zoomLevel = 1.0;
  end

  train_windows = readSetting("train_windows",train_windows);
  if train_windows then
    train_windows = CheckBox(10, lsScreenY - 120, z, 0xffffffff, " Training UI Windows (Toggle)", train_windows);
  else
    train_windows = CheckBox(10, lsScreenY - 120, z, 0xffffffff, " Training Chat Window (Toggle)", train_windows);
  end
  writeSetting("train_windows",train_windows);

  lsPrintWrapped(10, lsScreenY - 70, 10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "Train Results displays in Console!\n"
  .. "Replace ? with the character you just trained");

  srStripRegion(regions[0], regions[1], regions[2], regions[3]);
  if lsButtonText(10, lsScreenY - 30, z, 100, 0x00ff00ff, "Train") then
    --[[
      Console will output ??? as last character in each line (when training).
      Replace ??? with the correct number of letter (case sensitive)
    --]]
    srTrainTextReader(regions[0]+offsetX,regions[1]+offsetY, '?')
  end

  srMakeImage("current-region", regions[0], regions[1], regions[2], regions[3], true);
  srShowImageDebug("current-region", 0, 0, 1, zoomLevel);

  lsDrawLine(offsetX * zoomLevel, offsetY * zoomLevel, offsetX * zoomLevel, (offsetY + 12) * zoomLevel, 2, 1 + zoomLevel, 1, 0x66FF66FF);

  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
    0xFF0000ff, "End Script") then
    error(quit_message);
  end

  lsDoFrame();
  lsSleep(50);
end
