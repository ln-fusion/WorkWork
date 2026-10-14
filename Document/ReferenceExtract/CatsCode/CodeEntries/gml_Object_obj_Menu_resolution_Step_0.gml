if (global.Game_Pause == 1)
{
    if (global.Fullscreen == 0)
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
                    with (instance_create_layer(x, y + 24, "UI", obj_Menu_resolution_dropdown))
                    {
                        Window_width = 1280;
                        Window_height = 720;
                        Text_window = string(Window_width) + "x" + string(Window_height);
                    }
                    with (instance_create_layer(x, y + 48, "UI", obj_Menu_resolution_dropdown))
                    {
                        Window_width = 1366;
                        Window_height = 768;
                        Text_window = string(Window_width) + "x" + string(Window_height);
                    }
                    with (instance_create_layer(x, y + 72, "UI", obj_Menu_resolution_dropdown))
                    {
                        Window_width = 1920;
                        Window_height = 1080;
                        Text_window = string(Window_width) + "x" + string(Window_height);
                    }
                    with (instance_create_layer(x, y + 96, "UI", obj_Menu_resolution_dropdown))
                    {
                        Window_width = 2560;
                        Window_height = 1440;
                        Text_window = string(Window_width) + "x" + string(Window_height);
                    }
                    with (instance_create_layer(x, y + 120, "UI", obj_Menu_resolution_dropdown))
                    {
                        Window_width = 3840;
                        Window_height = 2160;
                        Text_window = string(Window_width) + "x" + string(Window_height);
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
            if (position_meeting(obj_Cursor.x, obj_Cursor.y, id) || position_meeting(obj_Cursor.x, obj_Cursor.y, obj_Menu_resolution_dropdown))
            {
                if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
                {
                    if (global.Lmouse_pressed)
                    {
                        audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                        Selected = 0;
                        with (obj_Menu_resolution_dropdown)
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
                    with (obj_Menu_resolution_dropdown)
                    {
                        instance_destroy();
                    }
                }
            }
        }
    }
    else
    {
        subimg = 2;
    }
}
else if (global.Game_Pause == 0)
{
}
