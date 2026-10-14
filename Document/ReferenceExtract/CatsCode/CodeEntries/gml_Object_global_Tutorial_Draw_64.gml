if (Show == 1)
{
    draw_sprite_ext(currentspr, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
    draw_set_font(global.font_norm1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    scr_Text_draw((x + 2 + global.Camera_offset_x) * global.screen_multiplier, (y + 1 + global.Camera_offset_y) * global.screen_multiplier, Text1, 13 * global.screen_multiplier, 168 * global.screen_multiplier);
    draw_set_halign(fa_center);
    draw_text((x + 86 + global.Camera_offset_x) * global.screen_multiplier, (y + 42 + global.Camera_offset_y) * global.screen_multiplier, Text2);
    draw_set_font(global.font_big1);
    draw_set_valign(fa_middle);
}
