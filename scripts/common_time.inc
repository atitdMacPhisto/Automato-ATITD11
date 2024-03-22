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
-- convertTeppyTime(ms)
--
-- returns adjusted ms based on teppy multipler
-- Example: You want to return a ms value for sleepWithStatus() based on game seconds to complete a task.
-- If you want to time drying linen, which takes 60 teppy seconds you use convertTeppyTime(60000) or convertTeppyTime(60)
-- If ms < 1000 then we'll assume regular seconds was passed and multiply it by 1000.
----------------------------------------------------------
function convertTeppyTime(ms, extra_lag_secs)
  if ms < 1000 then ms = ms * 1000 end
    if extra_lag_secs == nil then
      extra_lag_secs = 2000; -- Add default/minimum 2 seconds extra to adjust for potential lag.
    elseif extra_lag_secs < 1000 and extra_lag_secs ~= 0 then
      extra_lag_secs = extra_lag_secs * 1000;
    end
  return math.ceil( ( ms * teppy_multiplier ) + extra_lag_secs );
end
