draw_sprite_ext(currentspr, subimg, (71 + global.Camera_offset_x) * global.screen_multiplier, (15 + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
if (Display_type == 0)
{
    with (obj_Button_Bonus)
    {
        draw_sprite_ext(spr_Button_Bonuslight, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
        draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text);
    }
    draw_set_halign(fa_left);
    draw_set_font(global.font_norm1);
    with (obj_Display_Bonus)
    {
        draw_sprite_ext(currentspr, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
        draw_text((x + 3 + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text);
        if (Nullified == 1)
        {
            var var_length = string_width(Text);
            var var_x = 0;
            while (var_x < var_length)
            {
                if (string_width("-") > global.screen_multiplier)
                {
                    var_x -= global.screen_multiplier;
                }
                draw_text(((x + 3 + global.Camera_offset_x) * global.screen_multiplier) + var_x, (y + global.Camera_offset_y) * global.screen_multiplier, "-");
                var_x += string_width("-");
            }
        }
    }
    draw_set_halign(fa_right);
    with (obj_Display_Bonus)
    {
        draw_text((x + 492 + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text2);
        if (Nullified == 1)
        {
            var var_length = string_width(Text2);
            var var_x = 0;
            while (var_x < var_length)
            {
                if (string_width("-") > global.screen_multiplier)
                {
                    var_x -= global.screen_multiplier;
                }
                draw_text(((x + 492 + global.Camera_offset_x) * global.screen_multiplier) - var_x, (y + global.Camera_offset_y) * global.screen_multiplier, "-");
                var_x += string_width("-");
            }
        }
    }
}
else if (Display_type == 1)
{
    with (obj_Button_Boonbane)
    {
        draw_sprite_ext(spr_Button_Boonbanelight, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
        draw_text_ext((x + global.Camera_offset_x) * global.screen_multiplier, (y + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text, 13 * global.screen_multiplier, 50 * global.screen_multiplier);
    }
    draw_set_halign(fa_left);
    draw_set_font(global.font_norm1);
    with (obj_Display_Boonbane)
    {
        draw_sprite_ext(currentspr, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
        scr_Text_draw((x + 4 + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text, 12 * global.screen_multiplier, 420 * global.screen_multiplier);
    }
}
draw_set_halign(fa_center);
draw_set_font(global.font_big1);
