function scr_GamePause()
{
    if (global.Game_Pause == 2 || global.Freeze_frame == 2)
    {
        exit;
    }
    global.Game_Pause += 1;
    if (global.Game_Pause > 1)
    {
        global.Game_Pause = 0;
    }
    if (global.Game_Pause == 1)
    {
        instance_create_layer((room_width / 2) - 156, (room_height / 2) - 134, "UI", obj_Menu_fullscreen);
        instance_create_layer((room_width / 2) - 123, (room_height / 2) - 134, "UI", obj_Menu_borderless);
        instance_create_layer(((room_width / 2) - 156) + 54, (room_height / 2) - 100, "UI", obj_Menu_resolution);
        instance_create_layer(((room_width / 2) - 156) + 54, (room_height / 2) - 66, "UI", obj_Menu_language);
        with (instance_create_layer(((room_width / 2) - 156) + 48, (room_height / 2) - 32, "UI", obj_Menu_keybind))
        {
            ini_open(global.lang_file);
            Text = ini_read_string("Menu_text", "Menu_Key_select", "");
            ini_close();
            Text_key = scr_Text_keytostring(global_Control.kLmouse);
        }
        with (instance_create_layer(((room_width / 2) - 156) + 48, (room_height / 2) + 2, "UI", obj_Menu_keybind))
        {
            ini_open(global.lang_file);
            Text = ini_read_string("Menu_text", "Menu_Key_examine", "");
            ini_close();
            Text_key = scr_Text_keytostring(global_Control.kRmouse);
        }
        with (instance_create_layer(((room_width / 2) - 156) + 48, (room_height / 2) + 36, "UI", obj_Menu_keybind))
        {
            ini_open(global.lang_file);
            Text = ini_read_string("Menu_text", "Menu_Key_movedice", "");
            ini_close();
            Text_key = scr_Text_keytostring(global_Control.kSpace);
        }
        with (instance_create_layer(((room_width / 2) - 156) + 48, (room_height / 2) + 70, "UI", obj_Menu_keybind))
        {
            ini_open(global.lang_file);
            Text = ini_read_string("Menu_text", "Menu_Key_pause", "");
            ini_close();
            Text_key = scr_Text_keytostring(global_Control.kEscape);
        }
        instance_create_layer((room_width / 2) + 140, (room_height / 2) - 134, "UI", obj_Menu_vol_master);
        instance_create_layer((room_width / 2) + 140, (room_height / 2) - 100, "UI", obj_Menu_vol_sfx);
        instance_create_layer((room_width / 2) + 140, (room_height / 2) - 66, "UI", obj_Menu_vol_music);
        instance_create_layer((room_width / 2) + 206, (room_height / 2) + 118, "UI", obj_Menu_titlescreen);
        if (room == rm_Titlescreen)
        {
            instance_create_layer(room_width - 30, 36, "UI", obj_Menu_X);
        }
        else
        {
            with (obj_Button_Option)
            {
                depth = layer_get_depth("UI") - 2;
            }
        }
    }
    else if (global.Game_Pause == 0)
    {
        with (par_Menu)
        {
            instance_destroy();
        }
        with (obj_Button_Option)
        {
            depth = layer_get_depth("Base");
        }
        scr_Save_system();
    }
}
