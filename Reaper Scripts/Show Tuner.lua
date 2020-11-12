-- Show the GTune tuner window that is on the first track anywhere
-- in your FX chain.

Track = reaper.GetTrack(0, 0)
FXIndex = reaper.TrackFX_GetByName(Track, "GTune", false)
TunerWindow = reaper.TrackFX_GetFloatingWindow(Track, FXIndex)

if TunerWindow == null then
    reaper.TrackFX_Show(Track, FXIndex, 3) -- Show tuner
end
