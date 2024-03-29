-----------------------------------------------------------
-- Verified T11. teppy_multiplier can be found at https://catitd.com/time.asp?show or use test_ocr_lag_check.lua
-- https://catitd.com/time.asp?show fetches game ratio from a reliable source: https://armeagle.atitd.org/tabtime.php ~ Thanks Brad!
-- Math formula to determine teppy_multipler is: 1 + ( 1 - (ratio/3) )
-- T11 multiplier averages between 0.893 - 0.915 - We'll use the higher end.

  teppy_multiplier =  0.915;

-----------------------------------------------------------
-- convertTime(ms)
--
-- returns days:minutes:seconds based on ms
----------------------------------------------------------
function convertTime(ms)
  if not ms then
    error("Incorrect number of arguments for convertTime()");
  end
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

-----------------------------------------------------------
-- convertTeppyTime(ms, extra_lag_ms)
--
-- returns adjusted ms based on teppy multipler
--
-- Example: You want to return ms value for sleepWithStatus() based on game seconds to complete a task.
-- If you want to time something that takes 60 teppy seconds you'd use convertTeppyTime(60000) or convertTeppyTime(60)
-- Example usage: sleepWithStatus(convertTeppyTime(60000), "Hello", nil, 0.8);
-- If ms or extra_lag_ms < 1000 then we'll assume regular seconds was passed and multiply it by 1000.
-- By default an extra 2 second delay is added. You can override this with more or less by passing extra_lag_ms parameter
-- Passing 0 for extra_lag_ms will prevent extra delay but be careful when doing that.
----------------------------------------------------------
function convertTeppyTime(ms, extra_lag_ms)
  if not ms then
    error("Incorrect number of arguments for convertTeppyTime()");
  end

  local default_extra_lag_ms = 2000; -- Add default/minimum 2 seconds (2000 ms) extra to adjust for potential lag.

  if ms < 1000 then ms = ms * 1000 end
    if extra_lag_ms == nil then
      extra_lag_ms = default_extra_lag_ms;
    elseif extra_lag_ms < 1000 and extra_lag_ms ~= 0 then
      extra_lag_ms = extra_lag_ms * 1000;
    end
  return math.ceil( ( ms * teppy_multiplier ) + extra_lag_ms );
end
