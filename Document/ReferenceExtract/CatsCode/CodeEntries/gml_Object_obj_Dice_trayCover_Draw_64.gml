draw_sprite_ext(currentspr, 0, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, alpha);
draw_text((x + 270 + global.Camera_offset_x) * global.screen_multiplier, (y + 72 + global.Camera_offset_y) * global.screen_multiplier, Text + string(Sell_value));
