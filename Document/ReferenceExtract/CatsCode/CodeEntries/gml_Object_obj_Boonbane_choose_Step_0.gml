if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    if (obj_Cursor.Holding == 0)
    {
        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
        {
            if (subimg == 0)
            {
                audio_play_sound(sfx_UI_button_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
            }
            subimg = 1;
            if (global.Lmouse_pressed)
            {
                audio_play_sound(sfx_UI_button_click, 80, false, global.Ctrl_SFX, 0, 1);
                scr_Boonbane_setup("Boon", Boon_type, 0);
                scr_Boonbane_setup("Bane", Bane_type, 0);
                with (global_Level)
                {
                    ds_list_add(List_boon, other.Boon_type);
                    ds_list_add(List_bane, other.Bane_type);
                }
                with (obj_Boonbane_choose)
                {
                    instance_destroy();
                }
                global.Phase = "Start_roll";
            }
        }
        else
        {
            subimg = 0;
        }
    }
    else
    {
        subimg = 2;
    }
}
else if (global.Game_Pause == 1)
{
}
