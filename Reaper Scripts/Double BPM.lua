-- Double project tempo

if (reaper.GetToggleCommandState(40259) == 0) then
    reaper.Main_OnCommand(40259, 0)
end

reaper.SetCurrentBPM(0, reaper.TimeMap2_GetDividedBpmAtTime(0, 0) * 2, true)
