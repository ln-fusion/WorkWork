draw_set_alpha(0.4);
draw_set_colour(c_black);
draw_rectangle(camera_get_view_x(view_camera[0]) * global.screen_multiplier, camera_get_view_y(view_camera[0]) * global.screen_multiplier, global.Screen_width * global.screen_multiplier, global.Screen_height * global.screen_multiplier, 0);
draw_set_alpha(1);
draw_set_colour(c_white);
draw_sprite_ext(currentspr, 0, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
draw_set_font(global.font_big2);
draw_text((x + 259 + global.Camera_offset_x) * global.screen_multiplier, (y + 17 + global.Camera_offset_y) * global.screen_multiplier, Text);
if (Phase > 0)
{
    draw_set_font(global.font_big1);
    draw_set_halign(fa_left);
    draw_text((x + 8 + global.Camera_offset_x) * global.screen_multiplier, (y + 17 + 28 + global.Camera_offset_y) * global.screen_multiplier, Text_roundreward);
    var var_length = string_width(Text_roundreward);
    while (var_length < (450 * global.screen_multiplier))
    {
        draw_text(((x + 8 + global.Camera_offset_x) * global.screen_multiplier) + var_length, (y + 17 + 28 + global.Camera_offset_y) * global.screen_multiplier, " . ");
        var_length += string_width(" . ");
    }
    draw_text((x + 468 + global.Camera_offset_x) * global.screen_multiplier, (y + 17 + 28 + global.Camera_offset_y) * global.screen_multiplier, "$" + string(global.Stage_earnings + global.Extra_earnings));
    if (Phase > 1)
    {
        draw_text((x + 8 + global.Camera_offset_x) * global.screen_multiplier, (y + 17 + 28 + 24 + global.Camera_offset_y) * global.screen_multiplier, Text_remain);
        var_length = string_width(Text_remain);
        while (var_length < (450 * global.screen_multiplier))
        {
            draw_text(((x + 8 + global.Camera_offset_x) * global.screen_multiplier) + var_length, (y + 17 + 28 + 24 + global.Camera_offset_y) * global.screen_multiplier, " . ");
            var_length += string_width(" . ");
        }
        draw_text((x + 468 + global.Camera_offset_x) * global.screen_multiplier, (y + 17 + 28 + 24 + global.Camera_offset_y) * global.screen_multiplier, "$" + string(global.Round_score));
    }
    if (Phase > 2)
    {
        draw_text((x + 8 + global.Camera_offset_x) * global.screen_multiplier, (y + 17 + 28 + 48 + global.Camera_offset_y) * global.screen_multiplier, Text_interest);
        var_length = string_width(Text_interest);
        while (var_length < (450 * global.screen_multiplier))
        {
            draw_text(((x + 8 + global.Camera_offset_x) * global.screen_multiplier) + var_length, (y + 17 + 28 + 48 + global.Camera_offset_y) * global.screen_multiplier, " . ");
            var_length += string_width(" . ");
        }
        draw_text((x + 468 + global.Camera_offset_x) * global.screen_multiplier, (y + 17 + 28 + 48 + global.Camera_offset_y) * global.screen_multiplier, "$" + string(Interest_earned));
    }
    if (Phase > 3)
    {
        var var_line = 0;
        while (var_line < (502 * global.screen_multiplier))
        {
            draw_text(((x + 8 + global.Camera_offset_x) * global.screen_multiplier) + var_line, (y + 17 + 28 + 72 + global.Camera_offset_y) * global.screen_multiplier, "_");
            var_line += string_width("_");
        }
        draw_text((x + 8 + global.Camera_offset_x) * global.screen_multiplier, (y + 17 + 28 + 106 + global.Camera_offset_y) * global.screen_multiplier, Text_winnings);
        var_length = string_width(Text_winnings);
        while (var_length < (450 * global.screen_multiplier))
        {
            draw_text(((x + 8 + global.Camera_offset_x) * global.screen_multiplier) + var_length, (y + 17 + 28 + 106 + global.Camera_offset_y) * global.screen_multiplier, " . ");
            var_length += string_width(" . ");
        }
        draw_text((x + 468 + global.Camera_offset_x) * global.screen_multiplier, (y + 17 + 28 + 106 + global.Camera_offset_y) * global.screen_multiplier, "$" + string(Total_earned));
    }
}
else if (Phase < 0)
{
    draw_set_font(global.font_big1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    scr_Text_draw((x + 8 + global.Camera_offset_x) * global.screen_multiplier, (y + 44 + global.Camera_offset_y) * global.screen_multiplier, Text_demo1, 16 * global.screen_multiplier, 450 * global.screen_multiplier);
    draw_set_valign(fa_middle);
}
draw_set_halign(fa_center);
draw_set_font(global.font_big1);
