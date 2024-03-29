dofile("common.inc");

-- optional message
function askForWindowAndPixel(message)
	-- Wait for release if it's already held
	while lsShiftHeld() do end;
	-- Display message until shift is held
	while not lsShiftHeld() do
		lsPrintWrapped(5, 2, 1, lsScreenX-10, 0.7, 0.7, 0xFFFFFFff,
			"Pin the raeli oven window. Mouse over relevant color (usually White), in bottom pane of window and press Shift.");
		if message then
			lsPrintWrapped(5, 40, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
				message);
		end
		lsSetCaptureWindow();
		mouse_x, mouse_y = srMousePos();
		px = srReadPixel(mouse_x, mouse_y);
		lsPrintWrapped(5, 55, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
			"Mouse Pos:  " .. mouse_x .. ", " .. mouse_y);
		lsPrintWrapped(5, 75, 1, lsScreenX, 0.7, 0.7, px,
			"Hovered Color:  (" .. (math.floor(px/256/256/256) % 256) .. "," .. (math.floor(px/256/256) % 256) .. "," .. (math.floor(px/256) % 256) .. "," .. (px % 256) .. ")" );
		-- Testing other methods of grabbing the pixel, making sure RGBA values match
		-- srReadScreen();
		-- px2 = srReadPixelFromBuffer(mouse_x, mouse_y);
		-- lsPrintWrapped(0, 80, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
		-- 	mouse_x .. ", " .. mouse_y .. " = " .. (math.floor(px2/256/256/256) % 256) .. "," .. (math.floor(px2/256/256) % 256) .. "," .. (math.floor(px2/256) % 256) .. "," .. (px2 % 256) );
		-- lsButtonText(lsScreenX - 110, lsScreenY - 90, 0, 100, px, "test1");
		-- lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, px2, "test2");
		lsDoFrame();
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Exit") then
			error "Canceled";
		end
	end
	lsSetCaptureWindow();
	-- Wait for shift to be released
	while lsShiftHeld() do end;
	xyWindowSize = srGetWindowSize();
end


function doit()
	askForWindowAndPixel();
	
	local t0 = lsGetTimer();
	startTime = t0;
	local px = 0;
	local index=0;
	while 1 do
		lsSleep(100);
		srReadScreen();
		new_px = srReadPixel(mouse_x, mouse_y);
		local t = (lsGetTimer() - t0) / 1000 / 60;
		t = math.floor(t*10 + 0.5)/10;
		local t_string = t;
		if not (new_px == px) then
			index = index+1;
			srSaveLastReadScreen("screen_" .. index .. "_" .. t_string .. ".png");
			sleepWithStatus(5000, "Saving Image: screen_" .. index .. "_" .. t_string .. ".png", nil, 0.8);
			px = new_px;
			lsPlaySound("Clank.wav");
		end

		lsPrintWrapped(5, 5, 1, lsScreenX, 0.7, 0.7, px,
			"Watching Pixel: (" .. (math.floor(px/256/256/256) % 256) .. "," .. (math.floor(px/256/256) % 256) .. "," .. (math.floor(px/256) % 256) .. "," .. (px % 256) .. ")\n\nScreenshots Saved: " .. index .. "\n\nTime Elapsed: " .. getElapsedTime(startTime) .. "  ( " .. t_string .. " minutes )");

		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Exit") then
			error "Cancelled";
		end	
		lsDoFrame();
	end
end
