function scr_Text_draw(arg0, arg1, arg2, arg3, arg4)
{
    var var_newstring = arg2;
    var var_break = 0;
    var var_colorstring = var_newstring;
    var_break = string_pos_ext("+[chips]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = "+" + string(Cat_chips);
        var_newstring = string_replace_all(var_newstring, "+[chips]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert("~", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "+[chips]", var_replace2);
    }
    var_break = string_pos_ext("+[r_chips]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = "+" + string(Round_chips);
        var_newstring = string_replace_all(var_newstring, "+[r_chips]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert(".", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "+[r_chips]", var_replace2);
    }
    var_break = string_pos_ext("[chips]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = string(Cat_chips);
        var_newstring = string_replace_all(var_newstring, "[chips]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert("~", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "[chips]", var_replace2);
    }
    var_break = string_pos_ext("*Points", var_newstring, 1);
    if (var_break > 0)
    {
        var_newstring = string_replace_all(var_newstring, "*Points", Text_Points);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(Text_Points); var_j += 1)
        {
            var_replace2 = string_insert("~", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "*Points", var_replace2);
    }
    var_break = string_pos_ext("+[mult]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = "+" + string(Cat_mult);
        var_newstring = string_replace_all(var_newstring, "+[mult]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert("@", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "+[mult]", var_replace2);
    }
    var_break = string_pos_ext("+[r_mult]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = "+" + string(Round_mult);
        var_newstring = string_replace_all(var_newstring, "+[r_mult]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert(".", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "+[r_mult]", var_replace2);
    }
    var_break = string_pos_ext("x[mult]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = "x" + string(Cat_mult);
        var_newstring = string_replace_all(var_newstring, "x[mult]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert("@", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "x[mult]", var_replace2);
    }
    var_break = string_pos_ext("x[r_mult]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = "x" + string(Round_mult);
        var_newstring = string_replace_all(var_newstring, "x[r_mult]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert(".", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "x[r_mult]", var_replace2);
    }
    var_break = string_pos_ext("[mult]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = string(Cat_mult);
        var_newstring = string_replace_all(var_newstring, "[mult]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert("@", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "[mult]", var_replace2);
    }
    var_break = string_pos_ext("*Mult", var_newstring, 1);
    if (var_break > 0)
    {
        var_newstring = string_replace_all(var_newstring, "*Mult", Text_Mult);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(Text_Mult); var_j += 1)
        {
            var_replace2 = string_insert("@", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "*Mult", var_replace2);
    }
    var_break = string_pos_ext("+$[num]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = "+$" + string(Cat_num);
        var_newstring = string_replace_all(var_newstring, "+$[num]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert("^", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "+$[num]", var_replace2);
    }
    var_break = string_pos_ext("$[num]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = "$" + string(Cat_num);
        var_newstring = string_replace_all(var_newstring, "$[num]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert("^", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "$[num]", var_replace2);
    }
    var_break = string_pos_ext("$", var_newstring, 1);
    if (var_break > 0)
    {
        var_colorstring = string_replace_all(var_colorstring, "$", "^");
    }
    var_break = string_pos_ext("+[num]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = "+" + string(Cat_num);
        var_newstring = string_replace_all(var_newstring, "+[num]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert("^", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "+[num]", var_replace2);
    }
    var_break = string_pos_ext("[num]", var_newstring, 1);
    if (var_break > 0)
    {
        var var_replace = string(Cat_num);
        var_newstring = string_replace_all(var_newstring, "[num]", var_replace);
        var var_replace2 = "";
        for (var var_j = 0; var_j < string_length(var_replace); var_j += 1)
        {
            var_replace2 = string_insert("^", var_replace2, 1);
        }
        var_colorstring = string_replace_all(var_colorstring, "[num]", var_replace2);
    }
    var var_width = string_width(var_newstring);
    if (var_width > arg4)
    {
        var var_shorten = "";
        var var_words = 0;
        var_length = 0;
        var var_line = 0;
        var_x = 0;
        var var_pos = 0;
        if (global.lang_file == "lang_ChineseS.txt" || global.lang_file == "lang_ChineseT.txt" || global.lang_file == "lang_Japanese.txt" || global.lang_file == "lang_Korean.txt")
        {
            while (var_width > arg4)
            {
                var var_skip = 0;
                while (var_length < arg4)
                {
                    var_pos += 1;
                    var_shorten = string_copy(var_newstring, 1 + var_words, var_pos);
                    var_length = string_width(var_shorten);
                    var var_char = string_char_at(var_newstring, 1 + var_words + var_pos);
                    if (var_char == "#")
                    {
                        var_skip = 1;
                        break;
                    }
                }
                if (var_skip == 0)
                {
                    if (var_length > arg4)
                    {
                        var_pos -= 1;
                        var_shorten = string_copy(var_newstring, 1 + var_words, var_pos);
                        var_length = string_width(var_shorten);
                    }
                    var_newstring = string_insert("#", var_newstring, var_words + var_pos + 1);
                    var_colorstring = string_insert("#", var_colorstring, var_words + var_pos + 1);
                    var_words += 1;
                }
                var_width -= var_length;
                var_words += var_pos;
                var_pos = 0;
                var_shorten = "";
                var_length = 0;
            }
        }
        else
        {
            while (var_length <= arg4)
            {
                var_words += 1;
                var_shorten = string_copy(var_newstring, 1, var_words);
                var_length = string_width(var_shorten);
            }
            while (string_length(var_shorten) < string_length(var_newstring))
            {
                var_words += 1;
                var_shorten = string_copy(var_newstring, 1, var_words);
                if (string_char_at(var_shorten, var_words) == " ")
                {
                    var_length = string_width(var_shorten);
                    break;
                }
            }
            while (var_width > arg4)
            {
                var_line = string_width_ext(var_shorten, arg3, arg4);
                var_x = 0;
                for (var var_i = 1; var_i < (string_length(var_shorten) + 1); var_i += 1)
                {
                    var var_char = string_char_at(var_shorten, var_i);
                    if (var_char == "#")
                    {
                        var_pos += var_i;
                        var_shorten = string_delete(var_newstring, 1, var_pos);
                        var_width = string_width(var_shorten);
                        if (string_width(var_shorten) > arg4)
                        {
                            var_shorten = "";
                            var_words = 0;
                            var_length = 0;
                            while (var_length <= arg4)
                            {
                                var_words += 1;
                                var_shorten = string_copy(var_newstring, var_pos, var_words);
                                var_length = string_width(var_shorten);
                            }
                            while ((var_pos + 1 + var_words) < string_length(var_newstring))
                            {
                                var_words += 1;
                                var_shorten = string_copy(var_newstring, var_pos, var_words);
                                if (string_char_at(var_shorten, var_words) == " ")
                                {
                                    var_length = string_width(var_shorten);
                                    break;
                                }
                            }
                        }
                        break;
                    }
                    else
                    {
                        var_x += string_width(var_char);
                        if (var_x >= var_line)
                        {
                            if (string_char_at(var_newstring, var_pos + var_i + 1) == " ")
                            {
                                var_newstring = string_delete(var_newstring, var_pos + var_i + 1, 1);
                                var_colorstring = string_delete(var_colorstring, var_pos + var_i + 1, 1);
                                var_shorten = string_delete(var_shorten, var_i + 1, 1);
                            }
                            var_newstring = string_insert("#", var_newstring, var_pos + var_i + 1);
                            var_colorstring = string_insert("#", var_colorstring, var_pos + var_i + 1);
                            var_pos += (var_i + 1);
                            var_shorten = string_delete(var_newstring, 1, var_pos);
                            if (string_width(var_shorten) > arg4)
                            {
                                var_shorten = "";
                                var_words = 0;
                                var_length = 0;
                                while (var_length <= arg4)
                                {
                                    var_words += 1;
                                    var_shorten = string_copy(var_newstring, var_pos, var_words);
                                    var_length = string_width(var_shorten);
                                }
                                while ((var_pos + 1 + var_words) < string_length(var_newstring))
                                {
                                    var_words += 1;
                                    var_shorten = string_copy(var_newstring, var_pos, var_words);
                                    if (string_char_at(var_shorten, var_words) == " ")
                                    {
                                        var_length = string_width(var_shorten);
                                        break;
                                    }
                                }
                            }
                            var_width = string_width(var_shorten);
                            break;
                        }
                    }
                }
            }
        }
    }
    var var_total_lines = 0;
    var var_x = 0;
    var var_y = 0;
    var var_length = string_length(var_newstring);
    for (var var_i = 1; var_i < (var_length + 1); var_i += 1)
    {
        var var_char = string_char_at(var_newstring, var_i);
        if (var_char == "#")
        {
            var_y += arg3;
            var_x = 0;
            var_total_lines += 1;
        }
        else
        {
            if (string_pos_ext("*Bl", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*Bl", var_newstring, 1) - 1));
                var var_replace = "?Bl";
                var_newstring = string_replace_all(var_newstring, "*Bl", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 3; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*Bl", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 0, arg0 + var_pos, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*El", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*El", var_newstring, 1) - 1));
                var var_replace = "?El";
                var_newstring = string_replace_all(var_newstring, "*El", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 3; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*El", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 1, arg0 + var_pos, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*l", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*l", var_newstring, 1) - 1));
                var var_replace = "?l";
                var_newstring = string_replace_all(var_newstring, "*l", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 2; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*l", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 2, (arg0 + var_pos) - (global.screen_multiplier * 2), arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*R", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*R", var_newstring, 1) - 1));
                var var_replace = "?R";
                var_newstring = string_replace_all(var_newstring, "*R", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 2; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*R", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 3, (arg0 + var_pos) - global.screen_multiplier, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*^R", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*^R", var_newstring, 1) - 1));
                var var_replace = "?^R";
                var_newstring = string_replace_all(var_newstring, "*^R", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 3; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*^R", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 4, arg0 + var_pos, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*S", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*S", var_newstring, 1) - 1));
                var var_replace = "?S";
                var_newstring = string_replace_all(var_newstring, "*S", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 2; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*S", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 6, (arg0 + var_pos) - global.screen_multiplier, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*H", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*H", var_newstring, 1) - 1));
                var var_replace = "?H";
                var_newstring = string_replace_all(var_newstring, "*H", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 2; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*H", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 7, (arg0 + var_pos) - global.screen_multiplier, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*Tl", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*Tl", var_newstring, 1) - 1));
                var var_replace = "?Tl";
                var_newstring = string_replace_all(var_newstring, "*Tl", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 3; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*Tl", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 8, arg0 + var_pos, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*D", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*D", var_newstring, 1) - 1));
                var var_replace = "?D";
                var_newstring = string_replace_all(var_newstring, "*D", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 2; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*D", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 9, (arg0 + var_pos) - global.screen_multiplier, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*P", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*P", var_newstring, 1) - 1));
                var var_replace = "?P";
                var_newstring = string_replace_all(var_newstring, "*P", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 2; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*P", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 10, (arg0 + var_pos) - global.screen_multiplier, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*2l", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*2l", var_newstring, 1) - 1));
                var var_replace = "?2l";
                var_newstring = string_replace_all(var_newstring, "*2l", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 3; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*2l", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 11, arg0 + var_pos, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*Xl", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*Xl", var_newstring, 1) - 1));
                var var_replace = "?Xl";
                var_newstring = string_replace_all(var_newstring, "*Xl", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 3; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*Xl", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 12, arg0 + var_pos, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*!", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*!", var_newstring, 1) - 1));
                var var_replace = "?!";
                var_newstring = string_replace_all(var_newstring, "*!", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 2; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*!", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 13, arg0 + var_pos, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            if (string_pos_ext("*A", var_newstring, 1) > 0)
            {
                var var_pos = string_width(string_copy(var_newstring, 1, string_pos_ext("*A", var_newstring, 1) - 1));
                var var_replace = "?A";
                var_newstring = string_replace_all(var_newstring, "*A", var_replace);
                var var_replace2 = "";
                for (var var_j = 0; var_j < 2; var_j += 1)
                {
                    var_replace2 = string_insert("{", var_replace2, 1);
                }
                var_colorstring = string_replace_all(var_colorstring, "*A", var_replace2);
                draw_sprite_ext(spr_Dice_effect, 14, (arg0 + var_pos) - global.screen_multiplier, arg1 + var_y + 1, global.screen_multiplier, global.screen_multiplier, 0, -1, 1);
            }
            var var_color = 16777215;
            switch (string_char_at(var_colorstring, var_i))
            {
                case "~":
                    var_color = 11462984;
                    break;
                case "@":
                    var_color = 7039743;
                    break;
                case "^":
                    var_color = 5234162;
                    break;
                case "{":
                    var_color = "skip";
                    break;
            }
            if (var_color != "skip")
            {
                draw_text_color(arg0 + var_x, arg1 + var_y, var_char, var_color, var_color, var_color, var_color, 1);
            }
            var_x += string_width(var_char);
        }
    }
    return var_total_lines;
}
