-- If there are no items on current track go to beginning of the project.
-- If there are items on current track, select and move to item on the
-- left from cursor, or if it doesn’t exist, item on the right side.

local selectedTracks = reaper.GetSelectedTrack(0, 0)

if selectedTracks == nil then
    return
end

if (reaper.CountTrackMediaItems(selectedTracks) > 0) then
    -- Select and move to previous item
    reaper.Main_OnCommand(40416, 0)

    if (reaper.CountSelectedMediaItems(0) == 0) then
        -- Select and move to next item
        reaper.Main_OnCommand(40417, 0)
    end
else
    -- Go to beginning of project
    reaper.Main_OnCommand(40042, 0)
end
