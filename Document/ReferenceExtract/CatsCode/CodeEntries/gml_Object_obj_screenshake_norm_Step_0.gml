if (global.Game_Pause == 0)
{
    camera_set_view_pos(global.Camera, -global.Camera_offset_x + choose(-shake_max, shake_max), -global.Camera_offset_y + choose(-shake_max, shake_max));
    counter += 1;
    if (counter == counter_max)
    {
        instance_destroy();
        camera_set_view_pos(global.Camera, -global.Camera_offset_x, -global.Camera_offset_y);
    }
}
else if (global.Game_Pause == 1)
{
}
