with (obj_Button_Bonus)
{
    draw_text_color((x + global.Camera_offset_x) * global.screen_multiplier, (y + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text, #EDDACB, #EDDACB, #EDDACB, #EDDACB, 1);
}
with (obj_Button_Boonbane)
{
    draw_text_ext_color((x + global.Camera_offset_x) * global.screen_multiplier, ((y - 1) + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text, 13 * global.screen_multiplier, 50 * global.screen_multiplier, #D2C0DD, #D2C0DD, #D2C0DD, #D2C0DD, 1);
}
with (obj_Button_Score)
{
    draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text + string(global.Round_score));
}
with (obj_Button_Reroll)
{
    draw_text(((x - 2) + global.Camera_offset_x) * global.screen_multiplier, ((y - 9) + shift_y + global.Camera_offset_y) * global.screen_multiplier, Text);
    if (global.Phase == "Shop")
    {
        draw_text(((x - 3) + global.Camera_offset_x) * global.screen_multiplier, (y + 9 + shift_y + global.Camera_offset_y) * global.screen_multiplier, "$" + string(global_Level.Reroll_cost));
    }
    else
    {
        draw_text(((x - 2) + global.Camera_offset_x) * global.screen_multiplier, (y + 9 + shift_y + global.Camera_offset_y) * global.screen_multiplier, global.Round_reroll);
    }
}
if (global.Phase == "Shop")
{
    with (obj_Cat)
    {
        if (Shop_created == 1 && Selected == 0)
        {
            if (Visible == 1)
            {
                draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + 9 + global.Camera_offset_y) * global.screen_multiplier, "$" + string(Cat_cost));
            }
        }
    }
    with (obj_Item)
    {
        if (Shop_created == 1 && Selected == 0)
        {
            if (Visible == 1)
            {
                draw_text((x + global.Camera_offset_x) * global.screen_multiplier, (y + 20 + global.Camera_offset_y) * global.screen_multiplier, "$" + string(Item_cost));
            }
        }
    }
}
if (global.Phase == "Play" || global.Phase == "Start_roll" || global.Phase == "Start_wait")
{
    var var_bonus = "";
    if (global.Track_pair > 0)
    {
        var_bonus = var_bonus + string(global.Track_pair) + " " + Text_BonusPair;
    }
    if (global.Track_same3 > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + string(global.Track_same3) + " " + Text_BonusTriple;
    }
    if (global.Track_same4 > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusSame4;
    }
    if (global.Track_same5 > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusSame5;
    }
    if (global.Track_same6 > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusSame6;
    }
    if (global.Track_dif6 > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusAlldif;
    }
    if (global.Track_21 > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusBlackjack;
    }
    else if (global.Track_21 < 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusBust;
    }
    if (global.Track_lowroll > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusLowroll;
    }
    if (global.Track_highroll > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusHighroll;
    }
    if (global.Track_straight > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusStraight;
    }
    if (global.Track_empty > 0)
    {
        if (var_bonus != "")
        {
            var_bonus = var_bonus + " + ";
        }
        var_bonus = var_bonus + Text_BonusEmpty;
    }
    draw_text_color((((room_width / 2) - 12) + global.Camera_offset_x) * global.screen_multiplier, (26 + global.Camera_offset_y) * global.screen_multiplier, var_bonus, c_white, c_white, c_white, c_white, 0.75);
    if (infobar_display == 1)
    {
        draw_text_color((((room_width / 2) - 12) + global.Camera_offset_x) * global.screen_multiplier, (39 + global.Camera_offset_y) * global.screen_multiplier, infobar_text, #FF5150, #FF5150, #FF5150, #FF5150, 1);
        var var_length = string_width(infobar_text);
        var var_center = floor(0.5 * var_length);
        var var_x = 0;
        while (var_x < (var_length + (global.screen_multiplier * 2)))
        {
            if (string_width("-") > (global.screen_multiplier * 2))
            {
                var_x -= (global.screen_multiplier * 2);
            }
            draw_text_colour((((((room_width / 2) - 10) + global.Camera_offset_x) * global.screen_multiplier) - var_center) + var_x, (39 + global.Camera_offset_y) * global.screen_multiplier, "-", #FF5150, #FF5150, #FF5150, #FF5150, 0.8);
            var_x += string_width("-");
        }
    }
}
draw_set_font(global.font_score_big);
if (global.Phase == "Score_display" || global.Phase == "Score_check")
{
    var var_current = global.Score_current;
    if (string_length(global.Score_current) > 4)
    {
        for (var var_i = 1; var_i < string_length(global.Score_current); var_i += 1)
        {
            if ((var_i % 3) == 0)
            {
                var_current = string_insert(",", var_current, (string_length(global.Score_current) - var_i) + 1);
            }
        }
    }
    draw_text_ext_transformed((((room_width / 2) - 12) + global.Camera_offset_x) * global.screen_multiplier, (64 + global.Camera_offset_y) * global.screen_multiplier, var_current, 1, 286 * global.screen_multiplier, fontpoints_scale * global.screen_multiplier, fontpoints_scale * global.screen_multiplier, 0);
    draw_set_halign(fa_left);
}
else if (global.Phase == "Round_won" || global.Phase == "Round_won_display")
{
    draw_set_halign(fa_left);
}
else
{
    draw_set_halign(fa_right);
    var var_chips = global.Chips_display;
    if (string_length(global.Chips_display) > 4)
    {
        for (var var_i = 1; var_i < string_length(global.Chips_display); var_i += 1)
        {
            if ((var_i % 3) == 0)
            {
                var_chips = string_insert(",", var_chips, (string_length(global.Chips_display) - var_i) + 1);
            }
        }
    }
    draw_text_ext_transformed_color((285 + global.Camera_offset_x) * global.screen_multiplier, (64 + global.Camera_offset_y) * global.screen_multiplier, var_chips, 1, 136 * global.screen_multiplier, fontpoints_scale * global.screen_multiplier, fontpoints_scale * global.screen_multiplier, 0, 16777215, 16777215, 16777215, 16777215, 0.95);
    draw_set_halign(fa_left);
    var var_mult = global.Mult_display;
    if (string_length(global.Mult_display) > 4)
    {
        for (var var_j = 1; var_j < string_length(global.Mult_display); var_j += 1)
        {
            if ((var_j % 3) == 0)
            {
                var_mult = string_insert(",", var_mult, (string_length(global.Mult_display) - var_j) + 1);
            }
        }
    }
    draw_text_ext_transformed_color((335 + global.Camera_offset_x) * global.screen_multiplier, (64 + global.Camera_offset_y) * global.screen_multiplier, var_mult, 1, 136 * global.screen_multiplier, fontmult_scale * global.screen_multiplier, fontmult_scale * global.screen_multiplier, 0, 16777215, 16777215, 16777215, 16777215, 0.95);
}
draw_set_font(global.font_norm1);
draw_text_color((73 + global.Camera_offset_x) * global.screen_multiplier, (27 + global.Camera_offset_y) * global.screen_multiplier, Text_current, #D3B170, #D3B170, #D3B170, #D3B170, 1);
draw_text_color((119 + global.Camera_offset_x) * global.screen_multiplier, (27 + global.Camera_offset_y) * global.screen_multiplier, Text_reward, #D3B170, #D3B170, #D3B170, #D3B170, 1);
draw_text_color((468 + global.Camera_offset_x) * global.screen_multiplier, (25 + global.Camera_offset_y) * global.screen_multiplier, Text_preview, c_white, c_white, c_white, c_white, 0.75);
draw_set_font(global.font_digital);
var var_needed = global.Score_needed;
if (string_length(var_needed) > 4)
{
    for (var var_i = 1; var_i < string_length(var_needed); var_i += 1)
    {
        if ((var_i % 3) == 0)
        {
            draw_sprite_ext(spr_font_digital_comma, 0, (((466 + string_width(var_needed)) - (var_i * 11)) + global.Camera_offset_x) * global.screen_multiplier, (49 + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 0.85);
        }
    }
}
draw_text_transformed_color((468 + global.Camera_offset_x) * global.screen_multiplier, (41 + global.Camera_offset_y) * global.screen_multiplier, global.Score_needed, global.screen_multiplier, global.screen_multiplier, 0, c_white, c_white, c_white, c_white, 0.85);
if (Text_preview == Text_atleast)
{
    var var_total = global.Score_total;
    if (string_length(var_total) > 4)
    {
        for (var var_i = 1; var_i < string_length(var_total); var_i += 1)
        {
            if ((var_i % 3) == 0)
            {
                draw_sprite_ext(spr_font_digital_comma, 0, (((466 + string_width(var_total)) - (var_i * 11)) + global.Camera_offset_x) * global.screen_multiplier, (76 + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 0.85);
            }
        }
    }
    draw_text_transformed_color((468 + global.Camera_offset_x) * global.screen_multiplier, (68 + global.Camera_offset_y) * global.screen_multiplier, global.Score_total, global.screen_multiplier, global.screen_multiplier, 0, c_white, c_white, c_white, c_white, 0.85);
}
else if (Text_preview == Text_nextround)
{
    if (global.Boss == 1)
    {
        draw_set_font(global.font_big2);
        draw_text_color((468 + global.Camera_offset_x) * global.screen_multiplier, (68 + global.Camera_offset_y) * global.screen_multiplier, Text_Boonbane, c_white, c_white, c_white, c_white, 0.75);
    }
}
draw_set_font(global.font_big1);
draw_set_halign(fa_center);
draw_text_color((93 + global.Camera_offset_x) * global.screen_multiplier, (44 + global.Camera_offset_y) * global.screen_multiplier, "$" + string(global.Player_gold), #D3B170, #D3B170, #D3B170, #D3B170, 1);
draw_text_color((134 + global.Camera_offset_x) * global.screen_multiplier, (44 + global.Camera_offset_y) * global.screen_multiplier, "+$" + string(global.Stage_earnings), #D3B170, #D3B170, #D3B170, #D3B170, 1);
var var_round = Text_round + string(global.Stage_progress) + "/" + "16";
draw_text_color((112 + global.Camera_offset_x) * global.screen_multiplier, (69 + global.Camera_offset_y) * global.screen_multiplier, var_round, #A9DBE9, #A9DBE9, #A9DBE9, #A9DBE9, 0.85);
