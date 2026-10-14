var var_adjust = 0;
var var_x = 0;
var var_y = 0;
var var_subimg = 0;
var var_j = global.Screen_height;
while (var_j >= (-dia_wh * global.screen_multiplier))
{
    var var_i = 0;
    while (var_i < (global.Screen_width + (dia_wh * global.screen_multiplier)))
    {
        if ((var_y % 2) != 0 || var_y == 1)
        {
            var_adjust = (dia_wh * global.screen_multiplier) / 2;
        }
        else
        {
            var_adjust = 0;
        }
        var_subimg = subimg - ((var_x + var_y) * 2);
        if (var_subimg < 0)
        {
            var_subimg = 0;
        }
        else if (var_subimg > 9)
        {
            var_subimg = 9;
        }
        draw_sprite_ext(currentspr, var_subimg, var_i - var_adjust, var_j, global.screen_multiplier, global.screen_multiplier, 0, -1, alpha);
        var_x += 1;
        var_i += (dia_wh * global.screen_multiplier);
    }
    var_y += 1;
    var_x = 0;
    var_j -= ((dia_wh / 2) * global.screen_multiplier);
}
