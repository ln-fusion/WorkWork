draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_transformed((x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text, Text_scale, Text_scale, 0);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
