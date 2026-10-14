if (global.Game_Pause == 1)
{
    if (global.Fullscreen != 0.5)
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
                subimg = 3;
                window_set_fullscreen(false);
                window_set_showborder(false);
                global.Screen_width = display_get_width();
                global.Screen_height = display_get_height();
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
                alarm[0] = 16;
                global.Fullscreen = -1;
            }
        }
        else
        {
            subimg = 0;
        }
    }
    else if (global.Fullscreen == 0.5)
    {
        if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
        {
            if (subimg == 2)
            {
                audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
            }
            subimg = 3;
            if (global.Lmouse_pressed)
            {
                audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
                subimg = 1;
                window_set_fullscreen(false);
                window_set_showborder(true);
                global.Screen_width = display_get_width();
                global.Screen_height = display_get_height();
                global.screen_multiplier = global.Screen_height div 360;
                global.Camera_width = floor(global.Screen_width / global.screen_multiplier);
                global.Camera_height = floor(global.Screen_height / global.screen_multiplier);
                global.Camera_offset_x = floor((global.Camera_width - 640) / 2);
                global.Camera_offset_y = floor((global.Camera_height - 360) / 2);
                surface_resize(application_surface, global.Screen_width, global.Screen_height);
                window_set_size(global.Screen_width, global.Screen_height);
                camera_set_view_pos(global.Camera, -global.Camera_offset_x, -global.Camera_offset_y);
                camera_set_view_size(global.Camera, global.Camera_width, global.Camera_height);
                alarm[1] = 16;
                global.Fullscreen = -1;
            }
        }
        else
        {
            subimg = 2;
        }
    }
}
else if (global.Game_Pause == 0)
{
}
