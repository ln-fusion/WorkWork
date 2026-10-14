if (instance_exists(obj_UI_Cat_head))
{
    draw_set_font(global.font_norm2);
    with (obj_UI_Cat_head)
    {
        draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, Text_head);
    }
    draw_set_font(global.font_norm1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    with (obj_UI_Cat_body)
    {
        scr_Text_draw((x + 2 + global.Camera_offset_x) * global.screen_multiplier, (y + 1 + global.Camera_offset_y) * global.screen_multiplier, Text_body, 13 * global.screen_multiplier, 168 * global.screen_multiplier);
    }
    draw_set_font(global.font_big1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
}
