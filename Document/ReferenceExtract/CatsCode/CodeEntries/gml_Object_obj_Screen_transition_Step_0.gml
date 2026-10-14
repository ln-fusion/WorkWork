global.Game_Pause = 2;
global.Freeze_frame = 2;
switch (Phase)
{
    case 0:
        subimg += 1;
        if (subimg >= (9 + total_dia + 2))
        {
            subimg = 9 + total_dia;
            Phase = 0.5;
        }
        break;
    case 0.5:
        subimg = 9 + total_dia;
        if (Auto == 1)
        {
            counter += 1;
            if (counter >= 4)
            {
                Phase = 1.1;
                room_goto(target_room);
                if (target_room == rm_Titlescreen)
                {
                    audio_group_set_gain(audiogroup_Music, global.Ctrl_Music, 0);
                    audio_group_stop_all(audiogroup_Music);
                    with (global_Control)
                    {
                        Music_start = 0;
                    }
                }
            }
        }
        break;
    case 1:
        Phase = 1.1;
        break;
    case 1.1:
        subimg -= 1;
        if (subimg <= 0)
        {
            subimg = 0;
            global.Game_Pause = 0;
            global.Freeze_frame = 0;
            instance_destroy();
        }
        break;
}
