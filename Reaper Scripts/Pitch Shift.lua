-- As pitch shifters that do not introduce latency usually produce some
-- artifacts in sound, this script enables a latency-free pitch shifter
-- during the recording of instrument and a more solid one when
-- listening to the recording.
--
-- First, it toggles the record arm for selected tracks, which is also the
-- way to evaluate if we are currently recording or listening.
--
-- When the record arm is on, it enables Pitchproof and Manipulator and
-- disables ReaPitch.
-- When the record arm is off, it enables ReaPitch and disables Pitchproof
-- and Manipulator.
--
-- It toggles plugins on the selected track itself and also on any track
-- that it sends to.

local selectedTrack = reaper.GetSelectedTrack(0, 0)

if selectedTrack == nil then
	return
end

local manipulator = reaper.TrackFX_GetByName(selectedTrack, "Manipulator", false)
local pitchproof = reaper.TrackFX_GetByName(selectedTrack, "PitchProof", false)
local reapitch = reaper.TrackFX_GetByName(selectedTrack, "ReaPitch", false)
local trackNumSends = reaper.GetTrackNumSends(selectedTrack, 0)

-- Track: Toggle record arm for selected tracks
reaper.Main_OnCommand(9, 0)

if reaper.GetMediaTrackInfo_Value(selectedTrack, "I_RECARM") == 1 then
	reaper.TrackFX_SetEnabled(selectedTrack, manipulator, true)
	reaper.TrackFX_SetEnabled(selectedTrack, pitchproof, true)
	reaper.TrackFX_SetEnabled(selectedTrack, reapitch, false)

	if trackNumSends > 0 then
		for i = 0, trackNumSends - 1 do
			local receiveTrack = reaper.BR_GetMediaTrackSendInfo_Track(selectedTrack, 0, i, 1)
			local manipulatorReceive = reaper.TrackFX_GetByName(receiveTrack, "Manipulator", false)
			local pitchproofReceive = reaper.TrackFX_GetByName(receiveTrack, "PitchProof", false)
			local reapitchReceive = reaper.TrackFX_GetByName(receiveTrack, "ReaPitch", false)

			reaper.TrackFX_SetEnabled(receiveTrack, manipulatorReceive, true)
			reaper.TrackFX_SetEnabled(receiveTrack, pitchproofReceive, true)
			reaper.TrackFX_SetEnabled(receiveTrack, reapitchReceive, false)
		end
	end
else
	reaper.TrackFX_SetEnabled(selectedTrack, manipulator, false)
	reaper.TrackFX_SetEnabled(selectedTrack, pitchproof, false)
	reaper.TrackFX_SetEnabled(selectedTrack, reapitch, true)

	if trackNumSends > 0 then
		for i = 0, trackNumSends - 1 do
			local receiveTrack = reaper.BR_GetMediaTrackSendInfo_Track(selectedTrack, 0, i, 1)
			local manipulatorReceive = reaper.TrackFX_GetByName(receiveTrack, "Manipulator", false)
			local pitchproofReceive = reaper.TrackFX_GetByName(receiveTrack, "PitchProof", false)
			local reapitchReceive = reaper.TrackFX_GetByName(receiveTrack, "ReaPitch", false)

			reaper.TrackFX_SetEnabled(receiveTrack, manipulatorReceive, false)
			reaper.TrackFX_SetEnabled(receiveTrack, pitchproofReceive, false)
			reaper.TrackFX_SetEnabled(receiveTrack, reapitchReceive, true)
		end
	end
end
