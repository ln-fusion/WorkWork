for (var var_i = -260; var_i < global.Camera_width; var_i += sprite_size)
{
    for (var var_j = 0; var_j < (global.Camera_height + 180); var_j += sprite_size)
    {
        draw_sprite_ext(currentspr, subimg, -global.Camera_offset_x + var_i + x_offset, -global.Camera_offset_y + var_j + y_offset, 1, 1, 0, -1, 1);
    }
}
if (Change == 1)
{
    for (var var_i = -260; var_i < global.Camera_width; var_i += sprite_size)
    {
        for (var var_j = 0; var_j < (global.Camera_height + 180); var_j += sprite_size)
        {
            draw_sprite_ext(previous_spr, previous_subimg, -global.Camera_offset_x + var_i + x_offset, -global.Camera_offset_y + var_j + y_offset, 1, 1, 0, -1, alpha);
        }
    }
}
