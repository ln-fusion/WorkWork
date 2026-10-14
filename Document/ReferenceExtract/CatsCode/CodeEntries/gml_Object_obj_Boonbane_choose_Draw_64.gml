draw_set_font(global.font_norm2);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
if (Text == "")
{
    scr_Text_draw(((x - 79) + global.Camera_offset_x) * global.screen_multiplier, ((y - 33) + global.Camera_offset_y) * global.screen_multiplier, Text_boon, 13 * global.screen_multiplier, 161 * global.screen_multiplier);
    scr_Text_draw(((x - 79) + global.Camera_offset_x) * global.screen_multiplier, (y + 1 + global.Camera_offset_y) * global.screen_multiplier, Text_bane, 13 * global.screen_multiplier, 161 * global.screen_multiplier);
}
else
{
    scr_Text_draw(((x - 79) + global.Camera_offset_x) * global.screen_multiplier, ((y - 20) + global.Camera_offset_y) * global.screen_multiplier, Text, 13 * global.screen_multiplier, 161 * global.screen_multiplier);
}
draw_set_font(global.font_big1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
