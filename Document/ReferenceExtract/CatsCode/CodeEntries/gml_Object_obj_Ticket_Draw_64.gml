draw_set_font(global.font_norm2);
draw_text((x + global.Camera_offset_x) * global.screen_multiplier, ((y - 22) + global.Camera_offset_y) * global.screen_multiplier, Text_head);
draw_set_font(global.font_norm1);
draw_set_halign(fa_left);
scr_Text_draw(((x - 66) + global.Camera_offset_x) * global.screen_multiplier, ((y - 6) + global.Camera_offset_y) * global.screen_multiplier, Text_body, 13 * global.screen_multiplier, 136 * global.screen_multiplier);
draw_set_font(global.font_big1);
var var_cost = 0;
if (Ticket_cost > 0)
{
    var_cost = "$" + string(Ticket_cost);
}
else
{
    var_cost = "+$" + string(abs(Ticket_cost));
}
draw_text((x + subimg + 76 + global.Camera_offset_x) * global.screen_multiplier, ((y - 8) + global.Camera_offset_y) * global.screen_multiplier, var_cost);
draw_text((x + 80 + global.Camera_offset_x) * global.screen_multiplier, (y + 20 + global.Camera_offset_y) * global.screen_multiplier, string(global_Level.Ticket_refresh));
