if (Visible == 1)
{
    draw_sprite_ext(currentspr, subimg, (x + float_x + 3 + global.Camera_offset_x) * global.screen_multiplier, (((y + 2 + float_y) - 1) + global.Camera_offset_y) * global.screen_multiplier, xscale * global.screen_multiplier, yscale * global.screen_multiplier, rotate, c_black, 0.2);
    draw_sprite_ext(currentspr, subimg, (x + float_x + global.Camera_offset_x) * global.screen_multiplier, (((y + float_y) - 1) + global.Camera_offset_y) * global.screen_multiplier, xscale * global.screen_multiplier, yscale * global.screen_multiplier, rotate, -1, 1);
    if (global.Phase == "Shop")
    {
        if (Anim_state >= 0)
        {
            draw_set_font(global.font_white_small);
            for (var var_i = 0; var_i < Slot_max; var_i += 1)
            {
                if (Item_slot[var_i] == -1)
                {
                    switch (var_i)
                    {
                        case 0:
                            draw_sprite_ext(spr_Item_slot, 0, ((x - 27) + global.Camera_offset_x) * global.screen_multiplier, ((y - 74) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 0.9);
                            draw_text_transformed(((x - 27) + global.Camera_offset_x) * global.screen_multiplier, ((y - 74) + global.Camera_offset_y) * global.screen_multiplier, "1", global.screen_multiplier, global.screen_multiplier, 0);
                            break;
                        case 1:
                            draw_sprite_ext(spr_Item_slot, 0, (x + 27 + global.Camera_offset_x) * global.screen_multiplier, ((y - 74) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 0.9);
                            draw_text_transformed((x + 27 + global.Camera_offset_x) * global.screen_multiplier, ((y - 74) + global.Camera_offset_y) * global.screen_multiplier, "2", global.screen_multiplier, global.screen_multiplier, 0);
                            break;
                        case 2:
                            draw_sprite_ext(spr_Item_slot, 0, ((x - 27) + global.Camera_offset_x) * global.screen_multiplier, ((y - 10) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 0.9);
                            draw_text_transformed(((x - 27) + global.Camera_offset_x) * global.screen_multiplier, ((y - 10) + global.Camera_offset_y) * global.screen_multiplier, "3", global.screen_multiplier, global.screen_multiplier, 0);
                            break;
                        case 3:
                            draw_sprite_ext(spr_Item_slot, 0, (x + 27 + global.Camera_offset_x) * global.screen_multiplier, ((y - 10) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 0.9);
                            draw_text_transformed((x + 27 + global.Camera_offset_x) * global.screen_multiplier, ((y - 10) + global.Camera_offset_y) * global.screen_multiplier, "4", global.screen_multiplier, global.screen_multiplier, 0);
                            break;
                    }
                }
            }
            draw_set_font(global.font_big1);
        }
    }
}
