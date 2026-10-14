if (global.Game_Pause == 1)
{
    if (Selected == 0)
    {
        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
        {
            if (subimg == 0)
            {
                audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
            }
            subimg = 1;
            if (global.Lmouse_pressed)
            {
                audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                subimg = 2;
                Selected = 1;
            }
        }
        else
        {
            subimg = 0;
        }
    }
    else if (Selected == 1)
    {
        if (!global.Lmouse_click)
        {
            Selected = 0;
            subimg = 0;
            audio_play_sound(sfx_UI_button_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
        }
        x = obj_Cursor.x;
        if (x > (Master.x + Master.Width))
        {
            x = Master.x + Master.Width;
        }
        else if (x < Master.x)
        {
            x = Master.x;
        }
        if (Master.object_index == obj_Menu_vol_master)
        {
            global.Volume_Master = (x - Master.x) / Master.Width;
            global.Ctrl_SFX = global.Volume_Master * global.Volume_SFX;
            global.Ctrl_Music = global.Volume_Master * global.Volume_Music;
            audio_group_set_gain(audiogroup_SFX, global.Ctrl_SFX, 0);
            audio_group_set_gain(audiogroup_Music, global.Ctrl_Music, 0);
        }
        else if (Master.object_index == obj_Menu_vol_sfx)
        {
            global.Volume_SFX = (x - Master.x) / Master.Width;
            global.Ctrl_SFX = global.Volume_Master * global.Volume_SFX;
            audio_group_set_gain(audiogroup_SFX, global.Ctrl_SFX, 0);
        }
        else if (Master.object_index == obj_Menu_vol_music)
        {
            global.Volume_Music = (x - Master.x) / Master.Width;
            global.Ctrl_Music = global.Volume_Master * global.Volume_Music;
            audio_group_set_gain(audiogroup_Music, global.Ctrl_Music, 0);
        }
    }
}
else if (global.Game_Pause == 0)
{
}
