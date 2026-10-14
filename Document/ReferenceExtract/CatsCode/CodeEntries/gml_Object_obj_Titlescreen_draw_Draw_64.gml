draw_set_halign(fa_left);
with (obj_Titlescreen_start)
{
    if (Ready == -1)
    {
        draw_text((x + 11 + global.Camera_offset_x) * global.screen_multiplier, (y + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text);
    }
}
with (obj_Titlescreen_newgame)
{
    if (Ready == -1)
    {
        draw_text((x + 11 + global.Camera_offset_x) * global.screen_multiplier, (y + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text);
    }
}
with (obj_Titlescreen_option)
{
    if (Ready == -1)
    {
        draw_text((x + 11 + global.Camera_offset_x) * global.screen_multiplier, (y + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text);
    }
}
with (obj_Titlescreen_quit)
{
    if (Ready == -1)
    {
        draw_text((x + 11 + global.Camera_offset_x) * global.screen_multiplier, (y + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text);
    }
}
draw_set_halign(fa_center);
