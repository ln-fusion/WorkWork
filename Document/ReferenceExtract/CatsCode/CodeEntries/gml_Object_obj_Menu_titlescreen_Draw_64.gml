draw_sprite_ext(spr_Menu_base, 0, (70 + global.Camera_offset_x) * global.screen_multiplier, (20 + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
if (Interactable == 1)
{
    draw_sprite_ext(currentspr, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
}
