dofile("common.inc");

askText = ([[
 LOAD ALL THE THINGS!
 
 Repeatedly loads whatever materials can be into buildings being built or needing repair.

 Press shift over the ATITD window to begin.
]]);

function doTheThing()
	local plusButtons;
	local maxButton;
	local theButton;
	local pressed;
	local missing = false;

	local mx, my = srMousePos();
	safeClick(mx, my);

	lsSleep(500);
	srReadScreen();

	pressed = clickAllText("Blueprints...");
	if (pressed > 0) then
		lsSleep(500);
		srReadScreen();
	end

	pressed = clickAllText("Load Materials");
	if (pressed > 0) then
		lsSleep(500);
		srReadScreen();
	else
		pressed = clickAllText("Repair");
		if (pressed > 0) then
			lsSleep(500);
			srReadScreen();
		end
	end

	if (pressed <= 0) then
		sleepWithStatus(5000, "No Repair or Load Materials button found", nil, 0.7);
		return;
	end

	plusButtons = findAllImages("plus.png");

	for i=1,#plusButtons do
		local x = plusButtons[i][0];
		local y = plusButtons[i][1];
		safeClick(x, y);

		sleepWithStatus(500,"Loading " .. i, nil, 0.7);

		srReadScreen();
		OK = srFindImage("ok.png")

		if OK then
			missing = true;
			safeClick(OK[0], OK[1]);
		else -- No OK button, Load Material
			maxButton = srFindImage("max.png");
			if maxButton then
				safeClick(maxButton[0], maxButton[1]);
			end
		end
	end
	
	if missing then
		srReadScreen();
		blackX = srFindImage("blackX.png");
		if blackX then
			safeClick(blackX[0], blackX[1]);
		end

		sleepWithStatus(5000, "Some materials were missing; build/repair not complete", nil, 0.7)
	end
end

function doit()
	askForWindow(askText);
	windowSize = srGetWindowSize();

	while true do
		checkBreak();

		bAltPressed = lsAltHeld();
		
		if bAltPressed then
			while bAltPressed do
				checkBreak();
				bAltPressed = lsAltHeld();
				lsSleep(50);
			end
			
			doTheThing();
		else
			local y = 60;
			lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Hover mouse over building and press Alt");
			y = y + 20
			
			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
					"End script") then
				error "Clicked End Script button";
			end

			lsDoFrame();
			lsSleep(50);
		end
	end
end