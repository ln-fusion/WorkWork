if (global.Game_Pause == 1)
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
            switch (Language)
            {
                case "English":
                    global.lang_file = "lang_English.txt";
                    break;
                case "ChineseS":
                    global.lang_file = "lang_ChineseS.txt";
                    break;
                case "ChineseT":
                    global.lang_file = "lang_ChineseT.txt";
                    break;
            }
            scr_Font_adjust();
            room_restart();
            global.Game_Pause = 3;
        }
    }
    else
    {
        subimg = 0;
    }
}
else if (global.Game_Pause == 0)
{
}
