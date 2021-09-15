start_time, end_time = reaper.GetSet_ArrangeView2(0, false, 0, 0, 0, 0)

shift = reaper.GetProjectLength(0) - end_time + 0.1

reaper.GetSet_ArrangeView2(0, true, 0, 0, start_time + shift, end_time + shift)