if (global.Game_Pause == 1)
{
    if (Selected == 0)
    {
        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) && !position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Menu_resolution_dropdown))
        {
            if (subimg == 0)
            {
                audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
            }
            subimg = 1;
            if (global.Lmouse_pressed)
            {
                audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                with (instance_create_layer(x, y + 24, "UI", obj_Menu_language_dropdown))
                {
                    Language = "English";
                    ini_open(global.lang_file);
                    Text_window = ini_read_string("Menu_text", "Language_English", "");
                    ini_close();
                }
                with (instance_create_layer(x, y + 48, "UI", obj_Menu_language_dropdown))
                {
                    Language = "ChineseS";
                    ini_open(global.lang_file);
                    Text_window = ini_read_string("Menu_text", "Language_ChineseS", "");
                    ini_close();
                }
                with (instance_create_layer(x, y + 72, "UI", obj_Menu_language_dropdown))
                {
                    Language = "ChineseT";
                    ini_open(global.lang_file);
                    Text_window = ini_read_string("Menu_text", "Language_ChineseT", "");
                    ini_close();
                }
                Selected = 1;
                subimg = 0;
            }
        }
        else
        {
            subimg = 0;
        }
    }
    else if (Selected == 1)
    {
        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) || position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Menu_language_dropdown))
        {
            if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
            {
                if (global.Lmouse_pressed)
                {
                    audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                    Selected = 0;
                    with (obj_Menu_language_dropdown)
                    {
                        instance_destroy();
                    }
                }
            }
        }
        else
        {
            subimg = 0;
            if (global.Lmouse_pressed)
            {
                Selected = 0;
                with (obj_Menu_language_dropdown)
                {
                    instance_destroy();
                }
            }
        }
    }
}
else if (global.Game_Pause == 0)
{
}
