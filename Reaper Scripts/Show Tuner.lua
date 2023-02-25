-- Show the GTune tuner window that is on the first track anywhere
-- in your FX chain.

local track = reaper.GetTrack(0, 0)
local fxIndex = reaper.TrackFX_GetByName(track, "GTune", false)
local tunerWindow = reaper.TrackFX_GetFloatingWindow(track, fxIndex)

if tunerWindow == nil then
    reaper.TrackFX_Show(track, fxIndex, 3) -- Show tuner
end
