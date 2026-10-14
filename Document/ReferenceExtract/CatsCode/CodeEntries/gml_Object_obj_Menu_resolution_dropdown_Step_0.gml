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
            global.Screen_width = Window_width;
            global.Screen_height = Window_height;
            global.screen_multiplier = global.Screen_height div 360;
            global.Camera_width = floor(global.Screen_width / global.screen_multiplier);
            global.Camera_height = floor(global.Screen_height / global.screen_multiplier);
            global.Camera_offset_x = floor((global.Camera_width - 640) / 2);
            global.Camera_offset_y = floor((global.Camera_height - 360) / 2);
            surface_resize(application_surface, global.Screen_width, global.Screen_height);
            window_set_size(global.Screen_width, global.Screen_height);
            camera_set_view_pos(global.Camera, -global.Camera_offset_x, -global.Camera_offset_y);
            camera_set_view_size(global.Camera, global.Camera_width, global.Camera_height);
            scr_Font_adjust();
            with (obj_Menu_resolution)
            {
                Selected = 0;
                Text_window = string(global.Screen_width) + "x" + string(global.Screen_height);
                subimg = 1;
            }
            with (obj_Menu_resolution_dropdown)
            {
                instance_destroy();
            }
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
