if (Ready != -1)
{
    switch (Ready)
    {
        case 0:
            if (!instance_exists(obj_Screen_transition_start))
            {
                Ready = 0.5;
                if (instance_exists(obj_Titlescreen_newgame))
                {
                    wait_counter_max += 12;
                }
            }
            break;
        case 0.5:
            wait_counter += 1;
            if (wait_counter >= wait_counter_max)
            {
                alpha = 0.2;
                Ready = 1;
                wait_counter = 0;
            }
            break;
        case 1:
            alpha += 0.02;
            subimg += 0.2;
            if (subimg >= 2.9)
            {
                currentspr = spr_Titlescreen_options;
                subimg = 0;
                alpha = 1;
                Ready = -1;
            }
            break;
    }
    exit;
}
if (global.Game_Pause == 0)
{
    if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
    {
        if (subimg == 0)
        {
            audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
        }
        subimg = 1;
        shift_y = -1;
        if (global.Lmouse_pressed)
        {
            audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
            scr_GamePause();
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
