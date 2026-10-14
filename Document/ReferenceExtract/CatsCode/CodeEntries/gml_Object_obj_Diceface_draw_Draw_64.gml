var var_exceed = 0;
with (obj_Dice_face)
{
    if (instance_exists(obj_greyscreen))
    {
        draw_sprite_ext(spr_Dice_outline, 0, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, rotate, -1, alpha);
    }
    draw_sprite_ext(spr_Dice_base, subimg_outline, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, rotate, -1, alpha);
    if (subimg <= 6)
    {
        draw_sprite_ext(currentspr, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, rotate, -1, alpha);
    }
    else
    {
        var_exceed += 1;
    }
}
if (var_exceed > 0)
{
    draw_set_font(global.font_dice);
    with (obj_Dice_face)
    {
        if (subimg > 6)
        {
            draw_text_ext_transformed((x + 1 + lengthdir_y(6, rotate) + global.Camera_offset_x) * global.screen_multiplier, ((y - lengthdir_x(6, rotate)) + global.Camera_offset_y) * global.screen_multiplier, subimg, 1, 1000, global.screen_multiplier, global.screen_multiplier, rotate);
        }
    }
}
draw_set_font(global.font_white_small);
with (obj_Dice_face)
{
    draw_text_ext_transformed(((x - 14) + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + global.Camera_offset_y) * global.screen_multiplier, Dice_face, 1, 1000, global.screen_multiplier, global.screen_multiplier, rotate);
    if (array_length(Dice_effect) > 0)
    {
        for (var var_i = 0; var_i < array_length(Dice_effect); var_i += 1)
        {
            switch (Dice_effect[var_i][0])
            {
                case "<>":
                    draw_sprite_ext(spr_Dice_effect, 0, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "M":
                    draw_sprite_ext(spr_Dice_effect, 1, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "$":
                    draw_sprite_ext(spr_Dice_effect, 2, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "R":
                    draw_sprite_ext(spr_Dice_effect, 3, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "^R":
                    draw_sprite_ext(spr_Dice_effect, 4, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "^Add":
                    draw_sprite_ext(spr_Dice_effect, 5, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "Spade":
                    draw_sprite_ext(spr_Dice_effect, 6, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "Heart":
                    draw_sprite_ext(spr_Dice_effect, 7, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "Boost":
                    draw_sprite_ext(spr_Dice_effect, 8, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "D":
                    draw_sprite_ext(spr_Dice_effect, 9, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "P+":
                    draw_sprite_ext(spr_Dice_effect, 10, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "SS":
                    draw_sprite_ext(spr_Dice_effect, 11, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
                case "X2":
                    draw_sprite_ext(spr_Dice_effect, 12, (x + 11 + global.Camera_offset_x) * global.screen_multiplier, ((y - 17) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
                    if (Dice_effect[var_i][1] > 1)
                    {
                        draw_text_ext_transformed((x + 21 + global.Camera_offset_x) * global.screen_multiplier, ((y - 13) + (var_i * 13) + global.Camera_offset_y) * global.screen_multiplier, Dice_effect[var_i][1], 1, 1000, global.screen_multiplier, global.screen_multiplier, 0);
                    }
                    break;
            }
        }
    }
}
if (instance_exists(obj_UI_Dice_body))
{
    draw_set_font(global.font_norm1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    with (obj_UI_Dice_body)
    {
        draw_sprite_ext(currentspr, subimg, (x + global.Camera_offset_x) * global.screen_multiplier, (y + global.Camera_offset_y) * global.screen_multiplier, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
        scr_Text_draw((x + 2 + global.Camera_offset_x) * global.screen_multiplier, (y + 1 + global.Camera_offset_y) * global.screen_multiplier, Text_body, 12 * global.screen_multiplier, 138 * global.screen_multiplier);
    }
}
draw_set_font(global.font_big1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
