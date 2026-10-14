if (global.Game_Pause == 0)
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
            url_open_ext("https://store.steampowered.com/app/3128280/Cats__Dice/", "_blank");
        }
    }
    else
    {
        subimg = 0;
    }
}
else if (global.Game_Pause == 1)
{
}
