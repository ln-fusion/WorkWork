if (global.Game_Pause == 0)
{
    var var_w = string_width(Text) / global.screen_multiplier;
    var var_h = string_height(Text) / global.screen_multiplier;
    if (point_in_rectangle(obj_Cursor.x, obj_Cursor.y, x, y, x + var_w + 1, y + var_h + 1))
    {
        if (Text_scale == 1)
        {
            audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
        }
        Text_scale = 1.06;
        if (global.Lmouse_pressed)
        {
            audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
            url_open_ext(External_link, "_blank");
        }
    }
    else
    {
        Text_scale = 1;
    }
}
else if (global.Game_Pause == 1)
{
}
