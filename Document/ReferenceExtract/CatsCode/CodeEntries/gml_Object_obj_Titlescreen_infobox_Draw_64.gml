draw_set_font(global.font_norm1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
scr_Text_draw((x + 4 + global.Camera_offset_x) * global.screen_multiplier, (y + 3 + global.Camera_offset_y) * global.screen_multiplier, Text, 13 * global.screen_multiplier, 212 * global.screen_multiplier);
draw_set_font(global.font_big1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
