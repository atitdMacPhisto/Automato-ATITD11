-----------------------------------------------------------
-- convertTime(ms)
--
-- returns days:minutes:seconds based on ms
----------------------------------------------------------
function convertTime(ms)
	local duration = math.floor(ms / 1000);
	local hours = math.floor(duration / 60 / 60);
	local minutes = math.floor((duration - hours * 60 * 60) / 60);
	local seconds = duration - hours * 60 * 60 - minutes * 60;

  if hours > 0 then
    return string.format("%02dh %02dm %02ds",hours,minutes,seconds);
  else
    return string.format("%02dm %02ds",minutes,seconds);
  end
end
