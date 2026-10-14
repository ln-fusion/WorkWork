if (surface_exists(surf))
{
    surface_set_target(surf);
    part_system_drawit(pluspoints_system);
    surface_reset_target();
    draw_surface_ext(surf, ((x - 70) + global.Camera_offset_x) * global.screen_multiplier, ((y - 140) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
}
