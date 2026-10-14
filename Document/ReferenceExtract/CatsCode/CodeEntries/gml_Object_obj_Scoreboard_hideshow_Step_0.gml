if (global.Game_Pause == 0)
{
    with (obj_Ctrl_Cat)
    {
        Wait_counter = 0;
    }
    if (Show == 1)
    {
        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
        {
            if (subimg == 0)
            {
                audio_play_sound(sfx_UI_button_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
            }
            subimg = 1;
            shift_y = -1;
            if (global.Lmouse_pressed)
            {
                audio_play_sound(sfx_UI_button_click, 80, false, global.Ctrl_SFX, 0, 1);
                subimg = 2;
                shift_y = 0;
                Show = 0;
                Text = Text_show;
                with (obj_Display_Scoreboard)
                {
                    instance_destroy();
                }
                with (obj_Exlink)
                {
                    instance_destroy();
                }
            }
        }
        else
        {
            subimg = 0;
            shift_y = 0;
        }
    }
    else if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
    {
        if (subimg == 0)
        {
            audio_play_sound(sfx_UI_button_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
        }
        subimg = 1;
        shift_y = -1;
        if (global.Lmouse_pressed)
        {
            audio_play_sound(sfx_UI_button_click, 80, false, global.Ctrl_SFX, 0, 1);
            subimg = 2;
            shift_y = 0;
            Show = 1;
            Text = Text_hide;
            with (instance_create_layer(71, 14, "UI", obj_Display_Scoreboard))
            {
                Phase = -1;
                Text = Text_victory;
                counter = counter_max;
            }
        }
    }
    else
    {
        subimg = 0;
        shift_y = 0;
    }
}
else if (global.Game_Pause == 1)
{
}
