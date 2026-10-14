if (global.Freeze_frame == 0)
{
    if (depth == (layer_get_depth("UI") - 2))
    {
        currentspr = spr_Button_X;
    }
    else
    {
        currentspr = spr_Button_Options;
    }
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
            scr_GamePause();
        }
    }
    else
    {
        subimg = 0;
    }
}
