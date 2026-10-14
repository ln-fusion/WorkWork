if (global.Game_Pause == 1)
{
    draw_set_alpha(0.4);
    draw_set_colour(c_black);
    draw_rectangle(camera_get_view_x(view_camera[0]) * global.screen_multiplier, camera_get_view_y(view_camera[0]) * global.screen_multiplier, global.Screen_width * global.screen_multiplier, global.Screen_height * global.screen_multiplier, 0);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}
